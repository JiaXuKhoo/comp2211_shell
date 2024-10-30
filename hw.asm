
user/_hw:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char** argv){
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16

// print
printf("Hello World");
   8:	00001517          	auipc	a0,0x1
   c:	84850513          	addi	a0,a0,-1976 # 850 <malloc+0x100>
  10:	68c000ef          	jal	69c <printf>

exit(0);
  14:	4501                	li	a0,0
  16:	26e000ef          	jal	284 <exit>

000000000000001a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  1a:	1141                	addi	sp,sp,-16
  1c:	e406                	sd	ra,8(sp)
  1e:	e022                	sd	s0,0(sp)
  20:	0800                	addi	s0,sp,16
  extern int main();
  main();
  22:	fdfff0ef          	jal	0 <main>
  exit(0);
  26:	4501                	li	a0,0
  28:	25c000ef          	jal	284 <exit>

000000000000002c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  2c:	1141                	addi	sp,sp,-16
  2e:	e422                	sd	s0,8(sp)
  30:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  32:	87aa                	mv	a5,a0
  34:	0585                	addi	a1,a1,1
  36:	0785                	addi	a5,a5,1
  38:	fff5c703          	lbu	a4,-1(a1)
  3c:	fee78fa3          	sb	a4,-1(a5)
  40:	fb75                	bnez	a4,34 <strcpy+0x8>
    ;
  return os;
}
  42:	6422                	ld	s0,8(sp)
  44:	0141                	addi	sp,sp,16
  46:	8082                	ret

0000000000000048 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  48:	1141                	addi	sp,sp,-16
  4a:	e422                	sd	s0,8(sp)
  4c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  4e:	00054783          	lbu	a5,0(a0)
  52:	cb91                	beqz	a5,66 <strcmp+0x1e>
  54:	0005c703          	lbu	a4,0(a1)
  58:	00f71763          	bne	a4,a5,66 <strcmp+0x1e>
    p++, q++;
  5c:	0505                	addi	a0,a0,1
  5e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  60:	00054783          	lbu	a5,0(a0)
  64:	fbe5                	bnez	a5,54 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  66:	0005c503          	lbu	a0,0(a1)
}
  6a:	40a7853b          	subw	a0,a5,a0
  6e:	6422                	ld	s0,8(sp)
  70:	0141                	addi	sp,sp,16
  72:	8082                	ret

0000000000000074 <strlen>:

uint
strlen(const char *s)
{
  74:	1141                	addi	sp,sp,-16
  76:	e422                	sd	s0,8(sp)
  78:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  7a:	00054783          	lbu	a5,0(a0)
  7e:	cf91                	beqz	a5,9a <strlen+0x26>
  80:	0505                	addi	a0,a0,1
  82:	87aa                	mv	a5,a0
  84:	86be                	mv	a3,a5
  86:	0785                	addi	a5,a5,1
  88:	fff7c703          	lbu	a4,-1(a5)
  8c:	ff65                	bnez	a4,84 <strlen+0x10>
  8e:	40a6853b          	subw	a0,a3,a0
  92:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  94:	6422                	ld	s0,8(sp)
  96:	0141                	addi	sp,sp,16
  98:	8082                	ret
  for(n = 0; s[n]; n++)
  9a:	4501                	li	a0,0
  9c:	bfe5                	j	94 <strlen+0x20>

000000000000009e <memset>:

void*
memset(void *dst, int c, uint n)
{
  9e:	1141                	addi	sp,sp,-16
  a0:	e422                	sd	s0,8(sp)
  a2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a4:	ca19                	beqz	a2,ba <memset+0x1c>
  a6:	87aa                	mv	a5,a0
  a8:	1602                	slli	a2,a2,0x20
  aa:	9201                	srli	a2,a2,0x20
  ac:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b4:	0785                	addi	a5,a5,1
  b6:	fee79de3          	bne	a5,a4,b0 <memset+0x12>
  }
  return dst;
}
  ba:	6422                	ld	s0,8(sp)
  bc:	0141                	addi	sp,sp,16
  be:	8082                	ret

00000000000000c0 <strchr>:

char*
strchr(const char *s, char c)
{
  c0:	1141                	addi	sp,sp,-16
  c2:	e422                	sd	s0,8(sp)
  c4:	0800                	addi	s0,sp,16
  for(; *s; s++)
  c6:	00054783          	lbu	a5,0(a0)
  ca:	cb99                	beqz	a5,e0 <strchr+0x20>
    if(*s == c)
  cc:	00f58763          	beq	a1,a5,da <strchr+0x1a>
  for(; *s; s++)
  d0:	0505                	addi	a0,a0,1
  d2:	00054783          	lbu	a5,0(a0)
  d6:	fbfd                	bnez	a5,cc <strchr+0xc>
      return (char*)s;
  return 0;
  d8:	4501                	li	a0,0
}
  da:	6422                	ld	s0,8(sp)
  dc:	0141                	addi	sp,sp,16
  de:	8082                	ret
  return 0;
  e0:	4501                	li	a0,0
  e2:	bfe5                	j	da <strchr+0x1a>

00000000000000e4 <gets>:

char*
gets(char *buf, int max)
{
  e4:	711d                	addi	sp,sp,-96
  e6:	ec86                	sd	ra,88(sp)
  e8:	e8a2                	sd	s0,80(sp)
  ea:	e4a6                	sd	s1,72(sp)
  ec:	e0ca                	sd	s2,64(sp)
  ee:	fc4e                	sd	s3,56(sp)
  f0:	f852                	sd	s4,48(sp)
  f2:	f456                	sd	s5,40(sp)
  f4:	f05a                	sd	s6,32(sp)
  f6:	ec5e                	sd	s7,24(sp)
  f8:	1080                	addi	s0,sp,96
  fa:	8baa                	mv	s7,a0
  fc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  fe:	892a                	mv	s2,a0
 100:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 102:	4aa9                	li	s5,10
 104:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 106:	89a6                	mv	s3,s1
 108:	2485                	addiw	s1,s1,1
 10a:	0344d663          	bge	s1,s4,136 <gets+0x52>
    cc = read(0, &c, 1);
 10e:	4605                	li	a2,1
 110:	faf40593          	addi	a1,s0,-81
 114:	4501                	li	a0,0
 116:	186000ef          	jal	29c <read>
    if(cc < 1)
 11a:	00a05e63          	blez	a0,136 <gets+0x52>
    buf[i++] = c;
 11e:	faf44783          	lbu	a5,-81(s0)
 122:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 126:	01578763          	beq	a5,s5,134 <gets+0x50>
 12a:	0905                	addi	s2,s2,1
 12c:	fd679de3          	bne	a5,s6,106 <gets+0x22>
    buf[i++] = c;
 130:	89a6                	mv	s3,s1
 132:	a011                	j	136 <gets+0x52>
 134:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 136:	99de                	add	s3,s3,s7
 138:	00098023          	sb	zero,0(s3)
  return buf;
}
 13c:	855e                	mv	a0,s7
 13e:	60e6                	ld	ra,88(sp)
 140:	6446                	ld	s0,80(sp)
 142:	64a6                	ld	s1,72(sp)
 144:	6906                	ld	s2,64(sp)
 146:	79e2                	ld	s3,56(sp)
 148:	7a42                	ld	s4,48(sp)
 14a:	7aa2                	ld	s5,40(sp)
 14c:	7b02                	ld	s6,32(sp)
 14e:	6be2                	ld	s7,24(sp)
 150:	6125                	addi	sp,sp,96
 152:	8082                	ret

0000000000000154 <stat>:

int
stat(const char *n, struct stat *st)
{
 154:	1101                	addi	sp,sp,-32
 156:	ec06                	sd	ra,24(sp)
 158:	e822                	sd	s0,16(sp)
 15a:	e04a                	sd	s2,0(sp)
 15c:	1000                	addi	s0,sp,32
 15e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 160:	4581                	li	a1,0
 162:	162000ef          	jal	2c4 <open>
  if(fd < 0)
 166:	02054263          	bltz	a0,18a <stat+0x36>
 16a:	e426                	sd	s1,8(sp)
 16c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 16e:	85ca                	mv	a1,s2
 170:	16c000ef          	jal	2dc <fstat>
 174:	892a                	mv	s2,a0
  close(fd);
 176:	8526                	mv	a0,s1
 178:	134000ef          	jal	2ac <close>
  return r;
 17c:	64a2                	ld	s1,8(sp)
}
 17e:	854a                	mv	a0,s2
 180:	60e2                	ld	ra,24(sp)
 182:	6442                	ld	s0,16(sp)
 184:	6902                	ld	s2,0(sp)
 186:	6105                	addi	sp,sp,32
 188:	8082                	ret
    return -1;
 18a:	597d                	li	s2,-1
 18c:	bfcd                	j	17e <stat+0x2a>

000000000000018e <atoi>:

int
atoi(const char *s)
{
 18e:	1141                	addi	sp,sp,-16
 190:	e422                	sd	s0,8(sp)
 192:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 194:	00054683          	lbu	a3,0(a0)
 198:	fd06879b          	addiw	a5,a3,-48
 19c:	0ff7f793          	zext.b	a5,a5
 1a0:	4625                	li	a2,9
 1a2:	02f66863          	bltu	a2,a5,1d2 <atoi+0x44>
 1a6:	872a                	mv	a4,a0
  n = 0;
 1a8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1aa:	0705                	addi	a4,a4,1
 1ac:	0025179b          	slliw	a5,a0,0x2
 1b0:	9fa9                	addw	a5,a5,a0
 1b2:	0017979b          	slliw	a5,a5,0x1
 1b6:	9fb5                	addw	a5,a5,a3
 1b8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1bc:	00074683          	lbu	a3,0(a4)
 1c0:	fd06879b          	addiw	a5,a3,-48
 1c4:	0ff7f793          	zext.b	a5,a5
 1c8:	fef671e3          	bgeu	a2,a5,1aa <atoi+0x1c>
  return n;
}
 1cc:	6422                	ld	s0,8(sp)
 1ce:	0141                	addi	sp,sp,16
 1d0:	8082                	ret
  n = 0;
 1d2:	4501                	li	a0,0
 1d4:	bfe5                	j	1cc <atoi+0x3e>

00000000000001d6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1d6:	1141                	addi	sp,sp,-16
 1d8:	e422                	sd	s0,8(sp)
 1da:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1dc:	02b57463          	bgeu	a0,a1,204 <memmove+0x2e>
    while(n-- > 0)
 1e0:	00c05f63          	blez	a2,1fe <memmove+0x28>
 1e4:	1602                	slli	a2,a2,0x20
 1e6:	9201                	srli	a2,a2,0x20
 1e8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1ec:	872a                	mv	a4,a0
      *dst++ = *src++;
 1ee:	0585                	addi	a1,a1,1
 1f0:	0705                	addi	a4,a4,1
 1f2:	fff5c683          	lbu	a3,-1(a1)
 1f6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 1fa:	fef71ae3          	bne	a4,a5,1ee <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 1fe:	6422                	ld	s0,8(sp)
 200:	0141                	addi	sp,sp,16
 202:	8082                	ret
    dst += n;
 204:	00c50733          	add	a4,a0,a2
    src += n;
 208:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 20a:	fec05ae3          	blez	a2,1fe <memmove+0x28>
 20e:	fff6079b          	addiw	a5,a2,-1
 212:	1782                	slli	a5,a5,0x20
 214:	9381                	srli	a5,a5,0x20
 216:	fff7c793          	not	a5,a5
 21a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 21c:	15fd                	addi	a1,a1,-1
 21e:	177d                	addi	a4,a4,-1
 220:	0005c683          	lbu	a3,0(a1)
 224:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 228:	fee79ae3          	bne	a5,a4,21c <memmove+0x46>
 22c:	bfc9                	j	1fe <memmove+0x28>

000000000000022e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 22e:	1141                	addi	sp,sp,-16
 230:	e422                	sd	s0,8(sp)
 232:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 234:	ca05                	beqz	a2,264 <memcmp+0x36>
 236:	fff6069b          	addiw	a3,a2,-1
 23a:	1682                	slli	a3,a3,0x20
 23c:	9281                	srli	a3,a3,0x20
 23e:	0685                	addi	a3,a3,1
 240:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 242:	00054783          	lbu	a5,0(a0)
 246:	0005c703          	lbu	a4,0(a1)
 24a:	00e79863          	bne	a5,a4,25a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 24e:	0505                	addi	a0,a0,1
    p2++;
 250:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 252:	fed518e3          	bne	a0,a3,242 <memcmp+0x14>
  }
  return 0;
 256:	4501                	li	a0,0
 258:	a019                	j	25e <memcmp+0x30>
      return *p1 - *p2;
 25a:	40e7853b          	subw	a0,a5,a4
}
 25e:	6422                	ld	s0,8(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret
  return 0;
 264:	4501                	li	a0,0
 266:	bfe5                	j	25e <memcmp+0x30>

0000000000000268 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e406                	sd	ra,8(sp)
 26c:	e022                	sd	s0,0(sp)
 26e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 270:	f67ff0ef          	jal	1d6 <memmove>
}
 274:	60a2                	ld	ra,8(sp)
 276:	6402                	ld	s0,0(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret

000000000000027c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 27c:	4885                	li	a7,1
 ecall
 27e:	00000073          	ecall
 ret
 282:	8082                	ret

0000000000000284 <exit>:
.global exit
exit:
 li a7, SYS_exit
 284:	4889                	li	a7,2
 ecall
 286:	00000073          	ecall
 ret
 28a:	8082                	ret

000000000000028c <wait>:
.global wait
wait:
 li a7, SYS_wait
 28c:	488d                	li	a7,3
 ecall
 28e:	00000073          	ecall
 ret
 292:	8082                	ret

0000000000000294 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 294:	4891                	li	a7,4
 ecall
 296:	00000073          	ecall
 ret
 29a:	8082                	ret

000000000000029c <read>:
.global read
read:
 li a7, SYS_read
 29c:	4895                	li	a7,5
 ecall
 29e:	00000073          	ecall
 ret
 2a2:	8082                	ret

00000000000002a4 <write>:
.global write
write:
 li a7, SYS_write
 2a4:	48c1                	li	a7,16
 ecall
 2a6:	00000073          	ecall
 ret
 2aa:	8082                	ret

00000000000002ac <close>:
.global close
close:
 li a7, SYS_close
 2ac:	48d5                	li	a7,21
 ecall
 2ae:	00000073          	ecall
 ret
 2b2:	8082                	ret

00000000000002b4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2b4:	4899                	li	a7,6
 ecall
 2b6:	00000073          	ecall
 ret
 2ba:	8082                	ret

00000000000002bc <exec>:
.global exec
exec:
 li a7, SYS_exec
 2bc:	489d                	li	a7,7
 ecall
 2be:	00000073          	ecall
 ret
 2c2:	8082                	ret

00000000000002c4 <open>:
.global open
open:
 li a7, SYS_open
 2c4:	48bd                	li	a7,15
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2cc:	48c5                	li	a7,17
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2d4:	48c9                	li	a7,18
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2dc:	48a1                	li	a7,8
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <link>:
.global link
link:
 li a7, SYS_link
 2e4:	48cd                	li	a7,19
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2ec:	48d1                	li	a7,20
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2f4:	48a5                	li	a7,9
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <dup>:
.global dup
dup:
 li a7, SYS_dup
 2fc:	48a9                	li	a7,10
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 304:	48ad                	li	a7,11
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 30c:	48b1                	li	a7,12
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 314:	48b5                	li	a7,13
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 31c:	48b9                	li	a7,14
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 324:	1101                	addi	sp,sp,-32
 326:	ec06                	sd	ra,24(sp)
 328:	e822                	sd	s0,16(sp)
 32a:	1000                	addi	s0,sp,32
 32c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 330:	4605                	li	a2,1
 332:	fef40593          	addi	a1,s0,-17
 336:	f6fff0ef          	jal	2a4 <write>
}
 33a:	60e2                	ld	ra,24(sp)
 33c:	6442                	ld	s0,16(sp)
 33e:	6105                	addi	sp,sp,32
 340:	8082                	ret

0000000000000342 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 342:	7139                	addi	sp,sp,-64
 344:	fc06                	sd	ra,56(sp)
 346:	f822                	sd	s0,48(sp)
 348:	f426                	sd	s1,40(sp)
 34a:	0080                	addi	s0,sp,64
 34c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 34e:	c299                	beqz	a3,354 <printint+0x12>
 350:	0805c963          	bltz	a1,3e2 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 354:	2581                	sext.w	a1,a1
  neg = 0;
 356:	4881                	li	a7,0
 358:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 35c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 35e:	2601                	sext.w	a2,a2
 360:	00000517          	auipc	a0,0x0
 364:	50850513          	addi	a0,a0,1288 # 868 <digits>
 368:	883a                	mv	a6,a4
 36a:	2705                	addiw	a4,a4,1
 36c:	02c5f7bb          	remuw	a5,a1,a2
 370:	1782                	slli	a5,a5,0x20
 372:	9381                	srli	a5,a5,0x20
 374:	97aa                	add	a5,a5,a0
 376:	0007c783          	lbu	a5,0(a5)
 37a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 37e:	0005879b          	sext.w	a5,a1
 382:	02c5d5bb          	divuw	a1,a1,a2
 386:	0685                	addi	a3,a3,1
 388:	fec7f0e3          	bgeu	a5,a2,368 <printint+0x26>
  if(neg)
 38c:	00088c63          	beqz	a7,3a4 <printint+0x62>
    buf[i++] = '-';
 390:	fd070793          	addi	a5,a4,-48
 394:	00878733          	add	a4,a5,s0
 398:	02d00793          	li	a5,45
 39c:	fef70823          	sb	a5,-16(a4)
 3a0:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3a4:	02e05a63          	blez	a4,3d8 <printint+0x96>
 3a8:	f04a                	sd	s2,32(sp)
 3aa:	ec4e                	sd	s3,24(sp)
 3ac:	fc040793          	addi	a5,s0,-64
 3b0:	00e78933          	add	s2,a5,a4
 3b4:	fff78993          	addi	s3,a5,-1
 3b8:	99ba                	add	s3,s3,a4
 3ba:	377d                	addiw	a4,a4,-1
 3bc:	1702                	slli	a4,a4,0x20
 3be:	9301                	srli	a4,a4,0x20
 3c0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3c4:	fff94583          	lbu	a1,-1(s2)
 3c8:	8526                	mv	a0,s1
 3ca:	f5bff0ef          	jal	324 <putc>
  while(--i >= 0)
 3ce:	197d                	addi	s2,s2,-1
 3d0:	ff391ae3          	bne	s2,s3,3c4 <printint+0x82>
 3d4:	7902                	ld	s2,32(sp)
 3d6:	69e2                	ld	s3,24(sp)
}
 3d8:	70e2                	ld	ra,56(sp)
 3da:	7442                	ld	s0,48(sp)
 3dc:	74a2                	ld	s1,40(sp)
 3de:	6121                	addi	sp,sp,64
 3e0:	8082                	ret
    x = -xx;
 3e2:	40b005bb          	negw	a1,a1
    neg = 1;
 3e6:	4885                	li	a7,1
    x = -xx;
 3e8:	bf85                	j	358 <printint+0x16>

00000000000003ea <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3ea:	711d                	addi	sp,sp,-96
 3ec:	ec86                	sd	ra,88(sp)
 3ee:	e8a2                	sd	s0,80(sp)
 3f0:	e0ca                	sd	s2,64(sp)
 3f2:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 3f4:	0005c903          	lbu	s2,0(a1)
 3f8:	26090863          	beqz	s2,668 <vprintf+0x27e>
 3fc:	e4a6                	sd	s1,72(sp)
 3fe:	fc4e                	sd	s3,56(sp)
 400:	f852                	sd	s4,48(sp)
 402:	f456                	sd	s5,40(sp)
 404:	f05a                	sd	s6,32(sp)
 406:	ec5e                	sd	s7,24(sp)
 408:	e862                	sd	s8,16(sp)
 40a:	e466                	sd	s9,8(sp)
 40c:	8b2a                	mv	s6,a0
 40e:	8a2e                	mv	s4,a1
 410:	8bb2                	mv	s7,a2
  state = 0;
 412:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 414:	4481                	li	s1,0
 416:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 418:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 41c:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 420:	06c00c93          	li	s9,108
 424:	a005                	j	444 <vprintf+0x5a>
        putc(fd, c0);
 426:	85ca                	mv	a1,s2
 428:	855a                	mv	a0,s6
 42a:	efbff0ef          	jal	324 <putc>
 42e:	a019                	j	434 <vprintf+0x4a>
    } else if(state == '%'){
 430:	03598263          	beq	s3,s5,454 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 434:	2485                	addiw	s1,s1,1
 436:	8726                	mv	a4,s1
 438:	009a07b3          	add	a5,s4,s1
 43c:	0007c903          	lbu	s2,0(a5)
 440:	20090c63          	beqz	s2,658 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 444:	0009079b          	sext.w	a5,s2
    if(state == 0){
 448:	fe0994e3          	bnez	s3,430 <vprintf+0x46>
      if(c0 == '%'){
 44c:	fd579de3          	bne	a5,s5,426 <vprintf+0x3c>
        state = '%';
 450:	89be                	mv	s3,a5
 452:	b7cd                	j	434 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 454:	00ea06b3          	add	a3,s4,a4
 458:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 45c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 45e:	c681                	beqz	a3,466 <vprintf+0x7c>
 460:	9752                	add	a4,a4,s4
 462:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 466:	03878f63          	beq	a5,s8,4a4 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 46a:	05978963          	beq	a5,s9,4bc <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 46e:	07500713          	li	a4,117
 472:	0ee78363          	beq	a5,a4,558 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 476:	07800713          	li	a4,120
 47a:	12e78563          	beq	a5,a4,5a4 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 47e:	07000713          	li	a4,112
 482:	14e78a63          	beq	a5,a4,5d6 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 486:	07300713          	li	a4,115
 48a:	18e78a63          	beq	a5,a4,61e <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 48e:	02500713          	li	a4,37
 492:	04e79563          	bne	a5,a4,4dc <vprintf+0xf2>
        putc(fd, '%');
 496:	02500593          	li	a1,37
 49a:	855a                	mv	a0,s6
 49c:	e89ff0ef          	jal	324 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4a0:	4981                	li	s3,0
 4a2:	bf49                	j	434 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4a4:	008b8913          	addi	s2,s7,8
 4a8:	4685                	li	a3,1
 4aa:	4629                	li	a2,10
 4ac:	000ba583          	lw	a1,0(s7)
 4b0:	855a                	mv	a0,s6
 4b2:	e91ff0ef          	jal	342 <printint>
 4b6:	8bca                	mv	s7,s2
      state = 0;
 4b8:	4981                	li	s3,0
 4ba:	bfad                	j	434 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 4bc:	06400793          	li	a5,100
 4c0:	02f68963          	beq	a3,a5,4f2 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4c4:	06c00793          	li	a5,108
 4c8:	04f68263          	beq	a3,a5,50c <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 4cc:	07500793          	li	a5,117
 4d0:	0af68063          	beq	a3,a5,570 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 4d4:	07800793          	li	a5,120
 4d8:	0ef68263          	beq	a3,a5,5bc <vprintf+0x1d2>
        putc(fd, '%');
 4dc:	02500593          	li	a1,37
 4e0:	855a                	mv	a0,s6
 4e2:	e43ff0ef          	jal	324 <putc>
        putc(fd, c0);
 4e6:	85ca                	mv	a1,s2
 4e8:	855a                	mv	a0,s6
 4ea:	e3bff0ef          	jal	324 <putc>
      state = 0;
 4ee:	4981                	li	s3,0
 4f0:	b791                	j	434 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4f2:	008b8913          	addi	s2,s7,8
 4f6:	4685                	li	a3,1
 4f8:	4629                	li	a2,10
 4fa:	000ba583          	lw	a1,0(s7)
 4fe:	855a                	mv	a0,s6
 500:	e43ff0ef          	jal	342 <printint>
        i += 1;
 504:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 506:	8bca                	mv	s7,s2
      state = 0;
 508:	4981                	li	s3,0
        i += 1;
 50a:	b72d                	j	434 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 50c:	06400793          	li	a5,100
 510:	02f60763          	beq	a2,a5,53e <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 514:	07500793          	li	a5,117
 518:	06f60963          	beq	a2,a5,58a <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 51c:	07800793          	li	a5,120
 520:	faf61ee3          	bne	a2,a5,4dc <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 524:	008b8913          	addi	s2,s7,8
 528:	4681                	li	a3,0
 52a:	4641                	li	a2,16
 52c:	000ba583          	lw	a1,0(s7)
 530:	855a                	mv	a0,s6
 532:	e11ff0ef          	jal	342 <printint>
        i += 2;
 536:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 538:	8bca                	mv	s7,s2
      state = 0;
 53a:	4981                	li	s3,0
        i += 2;
 53c:	bde5                	j	434 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 53e:	008b8913          	addi	s2,s7,8
 542:	4685                	li	a3,1
 544:	4629                	li	a2,10
 546:	000ba583          	lw	a1,0(s7)
 54a:	855a                	mv	a0,s6
 54c:	df7ff0ef          	jal	342 <printint>
        i += 2;
 550:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 552:	8bca                	mv	s7,s2
      state = 0;
 554:	4981                	li	s3,0
        i += 2;
 556:	bdf9                	j	434 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 558:	008b8913          	addi	s2,s7,8
 55c:	4681                	li	a3,0
 55e:	4629                	li	a2,10
 560:	000ba583          	lw	a1,0(s7)
 564:	855a                	mv	a0,s6
 566:	dddff0ef          	jal	342 <printint>
 56a:	8bca                	mv	s7,s2
      state = 0;
 56c:	4981                	li	s3,0
 56e:	b5d9                	j	434 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 570:	008b8913          	addi	s2,s7,8
 574:	4681                	li	a3,0
 576:	4629                	li	a2,10
 578:	000ba583          	lw	a1,0(s7)
 57c:	855a                	mv	a0,s6
 57e:	dc5ff0ef          	jal	342 <printint>
        i += 1;
 582:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 584:	8bca                	mv	s7,s2
      state = 0;
 586:	4981                	li	s3,0
        i += 1;
 588:	b575                	j	434 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 58a:	008b8913          	addi	s2,s7,8
 58e:	4681                	li	a3,0
 590:	4629                	li	a2,10
 592:	000ba583          	lw	a1,0(s7)
 596:	855a                	mv	a0,s6
 598:	dabff0ef          	jal	342 <printint>
        i += 2;
 59c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 59e:	8bca                	mv	s7,s2
      state = 0;
 5a0:	4981                	li	s3,0
        i += 2;
 5a2:	bd49                	j	434 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5a4:	008b8913          	addi	s2,s7,8
 5a8:	4681                	li	a3,0
 5aa:	4641                	li	a2,16
 5ac:	000ba583          	lw	a1,0(s7)
 5b0:	855a                	mv	a0,s6
 5b2:	d91ff0ef          	jal	342 <printint>
 5b6:	8bca                	mv	s7,s2
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	bdad                	j	434 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5bc:	008b8913          	addi	s2,s7,8
 5c0:	4681                	li	a3,0
 5c2:	4641                	li	a2,16
 5c4:	000ba583          	lw	a1,0(s7)
 5c8:	855a                	mv	a0,s6
 5ca:	d79ff0ef          	jal	342 <printint>
        i += 1;
 5ce:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d0:	8bca                	mv	s7,s2
      state = 0;
 5d2:	4981                	li	s3,0
        i += 1;
 5d4:	b585                	j	434 <vprintf+0x4a>
 5d6:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5d8:	008b8d13          	addi	s10,s7,8
 5dc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5e0:	03000593          	li	a1,48
 5e4:	855a                	mv	a0,s6
 5e6:	d3fff0ef          	jal	324 <putc>
  putc(fd, 'x');
 5ea:	07800593          	li	a1,120
 5ee:	855a                	mv	a0,s6
 5f0:	d35ff0ef          	jal	324 <putc>
 5f4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5f6:	00000b97          	auipc	s7,0x0
 5fa:	272b8b93          	addi	s7,s7,626 # 868 <digits>
 5fe:	03c9d793          	srli	a5,s3,0x3c
 602:	97de                	add	a5,a5,s7
 604:	0007c583          	lbu	a1,0(a5)
 608:	855a                	mv	a0,s6
 60a:	d1bff0ef          	jal	324 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 60e:	0992                	slli	s3,s3,0x4
 610:	397d                	addiw	s2,s2,-1
 612:	fe0916e3          	bnez	s2,5fe <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 616:	8bea                	mv	s7,s10
      state = 0;
 618:	4981                	li	s3,0
 61a:	6d02                	ld	s10,0(sp)
 61c:	bd21                	j	434 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 61e:	008b8993          	addi	s3,s7,8
 622:	000bb903          	ld	s2,0(s7)
 626:	00090f63          	beqz	s2,644 <vprintf+0x25a>
        for(; *s; s++)
 62a:	00094583          	lbu	a1,0(s2)
 62e:	c195                	beqz	a1,652 <vprintf+0x268>
          putc(fd, *s);
 630:	855a                	mv	a0,s6
 632:	cf3ff0ef          	jal	324 <putc>
        for(; *s; s++)
 636:	0905                	addi	s2,s2,1
 638:	00094583          	lbu	a1,0(s2)
 63c:	f9f5                	bnez	a1,630 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 63e:	8bce                	mv	s7,s3
      state = 0;
 640:	4981                	li	s3,0
 642:	bbcd                	j	434 <vprintf+0x4a>
          s = "(null)";
 644:	00000917          	auipc	s2,0x0
 648:	21c90913          	addi	s2,s2,540 # 860 <malloc+0x110>
        for(; *s; s++)
 64c:	02800593          	li	a1,40
 650:	b7c5                	j	630 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 652:	8bce                	mv	s7,s3
      state = 0;
 654:	4981                	li	s3,0
 656:	bbf9                	j	434 <vprintf+0x4a>
 658:	64a6                	ld	s1,72(sp)
 65a:	79e2                	ld	s3,56(sp)
 65c:	7a42                	ld	s4,48(sp)
 65e:	7aa2                	ld	s5,40(sp)
 660:	7b02                	ld	s6,32(sp)
 662:	6be2                	ld	s7,24(sp)
 664:	6c42                	ld	s8,16(sp)
 666:	6ca2                	ld	s9,8(sp)
    }
  }
}
 668:	60e6                	ld	ra,88(sp)
 66a:	6446                	ld	s0,80(sp)
 66c:	6906                	ld	s2,64(sp)
 66e:	6125                	addi	sp,sp,96
 670:	8082                	ret

0000000000000672 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 672:	715d                	addi	sp,sp,-80
 674:	ec06                	sd	ra,24(sp)
 676:	e822                	sd	s0,16(sp)
 678:	1000                	addi	s0,sp,32
 67a:	e010                	sd	a2,0(s0)
 67c:	e414                	sd	a3,8(s0)
 67e:	e818                	sd	a4,16(s0)
 680:	ec1c                	sd	a5,24(s0)
 682:	03043023          	sd	a6,32(s0)
 686:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 68a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 68e:	8622                	mv	a2,s0
 690:	d5bff0ef          	jal	3ea <vprintf>
}
 694:	60e2                	ld	ra,24(sp)
 696:	6442                	ld	s0,16(sp)
 698:	6161                	addi	sp,sp,80
 69a:	8082                	ret

000000000000069c <printf>:

void
printf(const char *fmt, ...)
{
 69c:	711d                	addi	sp,sp,-96
 69e:	ec06                	sd	ra,24(sp)
 6a0:	e822                	sd	s0,16(sp)
 6a2:	1000                	addi	s0,sp,32
 6a4:	e40c                	sd	a1,8(s0)
 6a6:	e810                	sd	a2,16(s0)
 6a8:	ec14                	sd	a3,24(s0)
 6aa:	f018                	sd	a4,32(s0)
 6ac:	f41c                	sd	a5,40(s0)
 6ae:	03043823          	sd	a6,48(s0)
 6b2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6b6:	00840613          	addi	a2,s0,8
 6ba:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6be:	85aa                	mv	a1,a0
 6c0:	4505                	li	a0,1
 6c2:	d29ff0ef          	jal	3ea <vprintf>
}
 6c6:	60e2                	ld	ra,24(sp)
 6c8:	6442                	ld	s0,16(sp)
 6ca:	6125                	addi	sp,sp,96
 6cc:	8082                	ret

00000000000006ce <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ce:	1141                	addi	sp,sp,-16
 6d0:	e422                	sd	s0,8(sp)
 6d2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d4:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d8:	00001797          	auipc	a5,0x1
 6dc:	9287b783          	ld	a5,-1752(a5) # 1000 <freep>
 6e0:	a02d                	j	70a <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6e2:	4618                	lw	a4,8(a2)
 6e4:	9f2d                	addw	a4,a4,a1
 6e6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6ea:	6398                	ld	a4,0(a5)
 6ec:	6310                	ld	a2,0(a4)
 6ee:	a83d                	j	72c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6f0:	ff852703          	lw	a4,-8(a0)
 6f4:	9f31                	addw	a4,a4,a2
 6f6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6f8:	ff053683          	ld	a3,-16(a0)
 6fc:	a091                	j	740 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6fe:	6398                	ld	a4,0(a5)
 700:	00e7e463          	bltu	a5,a4,708 <free+0x3a>
 704:	00e6ea63          	bltu	a3,a4,718 <free+0x4a>
{
 708:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 70a:	fed7fae3          	bgeu	a5,a3,6fe <free+0x30>
 70e:	6398                	ld	a4,0(a5)
 710:	00e6e463          	bltu	a3,a4,718 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 714:	fee7eae3          	bltu	a5,a4,708 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 718:	ff852583          	lw	a1,-8(a0)
 71c:	6390                	ld	a2,0(a5)
 71e:	02059813          	slli	a6,a1,0x20
 722:	01c85713          	srli	a4,a6,0x1c
 726:	9736                	add	a4,a4,a3
 728:	fae60de3          	beq	a2,a4,6e2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 72c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 730:	4790                	lw	a2,8(a5)
 732:	02061593          	slli	a1,a2,0x20
 736:	01c5d713          	srli	a4,a1,0x1c
 73a:	973e                	add	a4,a4,a5
 73c:	fae68ae3          	beq	a3,a4,6f0 <free+0x22>
    p->s.ptr = bp->s.ptr;
 740:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 742:	00001717          	auipc	a4,0x1
 746:	8af73f23          	sd	a5,-1858(a4) # 1000 <freep>
}
 74a:	6422                	ld	s0,8(sp)
 74c:	0141                	addi	sp,sp,16
 74e:	8082                	ret

0000000000000750 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 750:	7139                	addi	sp,sp,-64
 752:	fc06                	sd	ra,56(sp)
 754:	f822                	sd	s0,48(sp)
 756:	f426                	sd	s1,40(sp)
 758:	ec4e                	sd	s3,24(sp)
 75a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 75c:	02051493          	slli	s1,a0,0x20
 760:	9081                	srli	s1,s1,0x20
 762:	04bd                	addi	s1,s1,15
 764:	8091                	srli	s1,s1,0x4
 766:	0014899b          	addiw	s3,s1,1
 76a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 76c:	00001517          	auipc	a0,0x1
 770:	89453503          	ld	a0,-1900(a0) # 1000 <freep>
 774:	c915                	beqz	a0,7a8 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 776:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 778:	4798                	lw	a4,8(a5)
 77a:	08977a63          	bgeu	a4,s1,80e <malloc+0xbe>
 77e:	f04a                	sd	s2,32(sp)
 780:	e852                	sd	s4,16(sp)
 782:	e456                	sd	s5,8(sp)
 784:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 786:	8a4e                	mv	s4,s3
 788:	0009871b          	sext.w	a4,s3
 78c:	6685                	lui	a3,0x1
 78e:	00d77363          	bgeu	a4,a3,794 <malloc+0x44>
 792:	6a05                	lui	s4,0x1
 794:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 798:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 79c:	00001917          	auipc	s2,0x1
 7a0:	86490913          	addi	s2,s2,-1948 # 1000 <freep>
  if(p == (char*)-1)
 7a4:	5afd                	li	s5,-1
 7a6:	a081                	j	7e6 <malloc+0x96>
 7a8:	f04a                	sd	s2,32(sp)
 7aa:	e852                	sd	s4,16(sp)
 7ac:	e456                	sd	s5,8(sp)
 7ae:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7b0:	00001797          	auipc	a5,0x1
 7b4:	86078793          	addi	a5,a5,-1952 # 1010 <base>
 7b8:	00001717          	auipc	a4,0x1
 7bc:	84f73423          	sd	a5,-1976(a4) # 1000 <freep>
 7c0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7c2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7c6:	b7c1                	j	786 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 7c8:	6398                	ld	a4,0(a5)
 7ca:	e118                	sd	a4,0(a0)
 7cc:	a8a9                	j	826 <malloc+0xd6>
  hp->s.size = nu;
 7ce:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7d2:	0541                	addi	a0,a0,16
 7d4:	efbff0ef          	jal	6ce <free>
  return freep;
 7d8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7dc:	c12d                	beqz	a0,83e <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7de:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7e0:	4798                	lw	a4,8(a5)
 7e2:	02977263          	bgeu	a4,s1,806 <malloc+0xb6>
    if(p == freep)
 7e6:	00093703          	ld	a4,0(s2)
 7ea:	853e                	mv	a0,a5
 7ec:	fef719e3          	bne	a4,a5,7de <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 7f0:	8552                	mv	a0,s4
 7f2:	b1bff0ef          	jal	30c <sbrk>
  if(p == (char*)-1)
 7f6:	fd551ce3          	bne	a0,s5,7ce <malloc+0x7e>
        return 0;
 7fa:	4501                	li	a0,0
 7fc:	7902                	ld	s2,32(sp)
 7fe:	6a42                	ld	s4,16(sp)
 800:	6aa2                	ld	s5,8(sp)
 802:	6b02                	ld	s6,0(sp)
 804:	a03d                	j	832 <malloc+0xe2>
 806:	7902                	ld	s2,32(sp)
 808:	6a42                	ld	s4,16(sp)
 80a:	6aa2                	ld	s5,8(sp)
 80c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 80e:	fae48de3          	beq	s1,a4,7c8 <malloc+0x78>
        p->s.size -= nunits;
 812:	4137073b          	subw	a4,a4,s3
 816:	c798                	sw	a4,8(a5)
        p += p->s.size;
 818:	02071693          	slli	a3,a4,0x20
 81c:	01c6d713          	srli	a4,a3,0x1c
 820:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 822:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 826:	00000717          	auipc	a4,0x0
 82a:	7ca73d23          	sd	a0,2010(a4) # 1000 <freep>
      return (void*)(p + 1);
 82e:	01078513          	addi	a0,a5,16
  }
}
 832:	70e2                	ld	ra,56(sp)
 834:	7442                	ld	s0,48(sp)
 836:	74a2                	ld	s1,40(sp)
 838:	69e2                	ld	s3,24(sp)
 83a:	6121                	addi	sp,sp,64
 83c:	8082                	ret
 83e:	7902                	ld	s2,32(sp)
 840:	6a42                	ld	s4,16(sp)
 842:	6aa2                	ld	s5,8(sp)
 844:	6b02                	ld	s6,0(sp)
 846:	b7f5                	j	832 <malloc+0xe2>
