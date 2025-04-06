## 注意事项
1. 每次在vscode中创建sv文件后，要在vivado中添加文件
2. ip核修改coe文件后，有可能不生效，建议删除ip核重新添加
3. 注意小端和大端存储的区别（本项目使用小端存储，所以 inst_rom 和 data_ram 中**读出**和**写入**的数据要先转换，即little endian存储，big endian取出）
4. inst_rom, data_ram 使用的IP核是 distributed memory generator (depth = 256, width = 32)
5. 仿真时间默认10us，需要再点击播放键，会继续仿真直到 ```$stop```

## 辅助知识

### I-type 指令格式
| opcode | rs     | rt     | imm     |
|--------|--------|--------|--------|
| 31-26  | 25-21  | 20-16  | 15-0    |
| 6 bits | 5 bits | 5 bits | 16 bits |

### R-type 指令格式
| opcode | rs     | rt     | rd     | shamt  | funct  |
|--------|--------|--------|--------|--------|--------|
| 31-26  | 25-21  | 20-16  | 15-11  | 10-6   | 5-0    |
| 6 bits | 5 bits | 5 bits | 5 bits | 5 bits | 6 bits |

### J-type 指令格式
| opcode | address |
|--------|--------|
| 31-26  | 25-0    |
| 6 bits | 26 bits |

#### lw 指令
|    | opcode | rs     | rt     | imm     |
|----|--------|--------|--------|--------|
| lw | 100011 | rs     | rt     | imm     |
| sw | 101011 | rs     | rt     | imm     |

## 波形验证

### 1. lw & sw 指令
注意看instr的内容，是小端所以和coe文件中的内容不一样

![wave_instr](./pic/image_1.png)

注意看register的内容，最后写入reg[0]是因为op = 000000, RegWrite = 1 (正常不应该写入，继续完成其他指令会修改)

![wave_reg](./pic/image_2.png)

```verilog
case (opcode)
   6'b000000: begin // R-type instructions
       RegDst = 1'b1; // Write to rd
       RegWrite = 1'b1; // Enable register write
       case (funct)
           6'b100000: ALUOp = 3'b010; // ADD
           6'b100010: ALUOp = 3'b110; // SUB
           6'b100100: ALUOp = 3'b001; // AND
           6'b100101: ALUOp = 3'b001; // OR 
           default:   ALUOp = 3'b000; // Default case for unsupported funct 
       endcase
   end
```

### 2. I-type 指令(lui, ori, addiu)
注意看reg中的变化，和汇编代码中的变化一致

![wave_lui](./pic/image_3.png)

### 3. R-type 指令(slt, beq, addu(是I-type但是新实现的), j)

注意看reg中的变化，来判断 slt 和 addu 是否正确
注意看instr的变化，来判断 beq 和 j 是否正确

![wave_slt](./pic/image_4.png)


### 4. bne 指令

注意看instr的变化，来判断 bne 是否正确

![wave_bne](./pic/image_5.png)


### sort.S (冒泡排序 综合测试)

先使用 sim/inst_rom.coe 和 sim/data_ram.coe 进行仿真，因为这里面的指令较少，方便观察波形图，无误后使用 board/inst_rom.coe 和 board/data_ram.coe 进行仿真，就可以发现 led_g 为 1，表示排序成功，通过测试！


注意看reg中的变化，来判断是否正确，可以看到寄存器```$t0 ~ $t7```的值按序排列了，成功！

![wave_sort](./pic/image_6.png)

在阅读波形图的时候，下面的 表格、汇编&指令的对应 可以帮助你理解 指令 和 寄存器 的变化
<details>
<summary>表格、汇编&指令的对应</summary>

| | |
|------- |-----|
|reg[8]  | $t0 |
|reg[9]  | $t1 |
|reg[10] | $t2 |
|reg[11] | $t3 |
|reg[12] | $t4 |
|reg[13] | $t5 |
|reg[14] | $t6 |
|reg[15] | $t7 |
|reg[16] | $s0 |
|reg[17] | $s1 |
|reg[19] | $s3 |
|reg[20] | $s4 |


``` assembly
0010103c    lui s0,0x1000
00001026    addiu s0,s0,0
1c001136    ori $s1,$s0,0x1C

sort_loop:
0000138e    lw $s3,0($s0)  
0000348e    lw $s4,0($s1)
2a407402    slt $t0,$s3,$s4
02000011    beq $t0,$0,sort_next 
000033ae    sw $s3, 0($s1)
000014ae    sw $s4, 0($s0)

sort_next:
fcff3126    addiu $s1, $s1, -4  
f8ff1116    bne $s0, $s1, sort_loop  

04001026    addiu $s0,$s0,4     
0010083c    lui t0,0x1000
00000825    addiu t0,t0,0
1c000934    ori $t1,$zero,0x1C
21880901    addu $s1,$t0,$t1
f2ff1116    bne $s0, $s1, sort_loop 

0010103c    lui s0,0x1000
00001026    addiu s0,s0,0

0000088e
0400098e
08000a8e
0c000b8e
10000c8e
14000d8e
18000e8e
1c000f8e
1b000008
```
</details>

最终在 board 上测试成功，led_g 亮起，表示排序成功！

![board](./pic/image_7.png)