
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 7b 11 80       	mov    $0x80117b50,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 70 31 10 80       	mov    $0x80103170,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 34 b6 10 80       	mov    $0x8010b634,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 00 79 10 80       	push   $0x80107900
80100051:	68 00 b6 10 80       	push   $0x8010b600
80100056:	e8 e5 46 00 00       	call   80104740 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 fc fc 10 80       	mov    $0x8010fcfc,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 4c fd 10 80 fc 	movl   $0x8010fcfc,0x8010fd4c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 50 fd 10 80 fc 	movl   $0x8010fcfc,0x8010fd50
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 fc fc 10 80 	movl   $0x8010fcfc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 07 79 10 80       	push   $0x80107907
80100097:	50                   	push   %eax
80100098:	e8 73 45 00 00       	call   80104610 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 50 fd 10 80       	mov    0x8010fd50,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 50 fd 10 80    	mov    %ebx,0x8010fd50
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb a0 fa 10 80    	cmp    $0x8010faa0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 00 b6 10 80       	push   $0x8010b600
801000e4:	e8 27 48 00 00       	call   80104910 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 50 fd 10 80    	mov    0x8010fd50,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb fc fc 10 80    	cmp    $0x8010fcfc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb fc fc 10 80    	cmp    $0x8010fcfc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 4c fd 10 80    	mov    0x8010fd4c,%ebx
80100126:	81 fb fc fc 10 80    	cmp    $0x8010fcfc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb fc fc 10 80    	cmp    $0x8010fcfc,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 00 b6 10 80       	push   $0x8010b600
80100162:	e8 49 47 00 00       	call   801048b0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 de 44 00 00       	call   80104650 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 5f 22 00 00       	call   801023f0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 0e 79 10 80       	push   $0x8010790e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 2d 45 00 00       	call   801046f0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 17 22 00 00       	jmp    801023f0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 1f 79 10 80       	push   $0x8010791f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ec 44 00 00       	call   801046f0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 9c 44 00 00       	call   801046b0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
8010021b:	e8 f0 46 00 00       	call   80104910 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 50 fd 10 80       	mov    0x8010fd50,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 fc fc 10 80 	movl   $0x8010fcfc,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 50 fd 10 80       	mov    0x8010fd50,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 50 fd 10 80    	mov    %ebx,0x8010fd50
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 00 b6 10 80 	movl   $0x8010b600,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 3f 46 00 00       	jmp    801048b0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 26 79 10 80       	push   $0x80107926
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	pushl  0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 d7 16 00 00       	call   80101970 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 00 00 11 80 	movl   $0x80110000,(%esp)
801002a0:	e8 6b 46 00 00       	call   80104910 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 e0 ff 10 80       	mov    0x8010ffe0,%eax
801002b5:	3b 05 e4 ff 10 80    	cmp    0x8010ffe4,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 00 00 11 80       	push   $0x80110000
801002c8:	68 e0 ff 10 80       	push   $0x8010ffe0
801002cd:	e8 8e 3e 00 00       	call   80104160 <sleep>
    while(input.r == input.w){
801002d2:	a1 e0 ff 10 80       	mov    0x8010ffe0,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 e4 ff 10 80    	cmp    0x8010ffe4,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 a9 37 00 00       	call   80103a90 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 00 00 11 80       	push   $0x80110000
801002f6:	e8 b5 45 00 00       	call   801048b0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	pushl  0x8(%ebp)
801002ff:	e8 8c 15 00 00       	call   80101890 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 e0 ff 10 80    	mov    %edx,0x8010ffe0
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 60 ff 10 80 	movsbl -0x7fef00a0(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 00 00 11 80       	push   $0x80110000
8010034c:	e8 5f 45 00 00       	call   801048b0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	pushl  0x8(%ebp)
80100355:	e8 36 15 00 00       	call   80101890 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 e0 ff 10 80       	mov    %eax,0x8010ffe0
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 34 00 11 80 00 	movl   $0x0,0x80110034
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 62 26 00 00       	call   80102a00 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 2d 79 10 80       	push   $0x8010792d
801003a7:	e8 d4 02 00 00       	call   80100680 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	pushl  0x8(%ebp)
801003b0:	e8 cb 02 00 00       	call   80100680 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 b7 83 10 80 	movl   $0x801083b7,(%esp)
801003bc:	e8 bf 02 00 00       	call   80100680 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 93 43 00 00       	call   80104760 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	pushl  (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 41 79 10 80       	push   $0x80107941
801003dd:	e8 9e 02 00 00       	call   80100680 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 38 00 11 80 01 	movl   $0x1,0x80110038
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <cgaputc>:
{
80100400:	55                   	push   %ebp
80100401:	89 c1                	mov    %eax,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100403:	b8 0e 00 00 00       	mov    $0xe,%eax
80100408:	89 e5                	mov    %esp,%ebp
8010040a:	57                   	push   %edi
8010040b:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100410:	56                   	push   %esi
80100411:	89 fa                	mov    %edi,%edx
80100413:	53                   	push   %ebx
80100414:	83 ec 1c             	sub    $0x1c,%esp
80100417:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100418:	be d5 03 00 00       	mov    $0x3d5,%esi
8010041d:	89 f2                	mov    %esi,%edx
8010041f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100420:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100423:	89 fa                	mov    %edi,%edx
80100425:	c1 e0 08             	shl    $0x8,%eax
80100428:	89 c3                	mov    %eax,%ebx
8010042a:	b8 0f 00 00 00       	mov    $0xf,%eax
8010042f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100430:	89 f2                	mov    %esi,%edx
80100432:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100433:	0f b6 c0             	movzbl %al,%eax
80100436:	09 d8                	or     %ebx,%eax
  if(c == '\n')
80100438:	83 f9 0a             	cmp    $0xa,%ecx
8010043b:	0f 84 97 00 00 00    	je     801004d8 <cgaputc+0xd8>
  else if(c == BACKSPACE){
80100441:	81 f9 00 01 00 00    	cmp    $0x100,%ecx
80100447:	74 77                	je     801004c0 <cgaputc+0xc0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100449:	0f b6 c9             	movzbl %cl,%ecx
8010044c:	8d 58 01             	lea    0x1(%eax),%ebx
8010044f:	80 cd 07             	or     $0x7,%ch
80100452:	66 89 8c 00 00 80 0b 	mov    %cx,-0x7ff48000(%eax,%eax,1)
80100459:	80 
  if(pos < 0 || pos > 25*80)
8010045a:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100460:	0f 8f cc 00 00 00    	jg     80100532 <cgaputc+0x132>
  if((pos/80) >= 24){  // Scroll up.
80100466:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
8010046c:	0f 8f 7e 00 00 00    	jg     801004f0 <cgaputc+0xf0>
  outb(CRTPORT+1, pos>>8);
80100472:	0f b6 c7             	movzbl %bh,%eax
  outb(CRTPORT+1, pos);
80100475:	89 df                	mov    %ebx,%edi
  crt[pos] = ' ' | 0x0700;
80100477:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
  outb(CRTPORT+1, pos>>8);
8010047e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100481:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100486:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048b:	89 da                	mov    %ebx,%edx
8010048d:	ee                   	out    %al,(%dx)
8010048e:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100493:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80100497:	89 ca                	mov    %ecx,%edx
80100499:	ee                   	out    %al,(%dx)
8010049a:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049f:	89 da                	mov    %ebx,%edx
801004a1:	ee                   	out    %al,(%dx)
801004a2:	89 f8                	mov    %edi,%eax
801004a4:	89 ca                	mov    %ecx,%edx
801004a6:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004a7:	b8 20 07 00 00       	mov    $0x720,%eax
801004ac:	66 89 06             	mov    %ax,(%esi)
}
801004af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004b2:	5b                   	pop    %ebx
801004b3:	5e                   	pop    %esi
801004b4:	5f                   	pop    %edi
801004b5:	5d                   	pop    %ebp
801004b6:	c3                   	ret    
801004b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801004be:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004c0:	8d 58 ff             	lea    -0x1(%eax),%ebx
801004c3:	85 c0                	test   %eax,%eax
801004c5:	75 93                	jne    8010045a <cgaputc+0x5a>
801004c7:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
801004cb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004d0:	31 ff                	xor    %edi,%edi
801004d2:	eb ad                	jmp    80100481 <cgaputc+0x81>
801004d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004d8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004dd:	f7 e2                	mul    %edx
801004df:	c1 ea 06             	shr    $0x6,%edx
801004e2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004e5:	c1 e0 04             	shl    $0x4,%eax
801004e8:	8d 58 50             	lea    0x50(%eax),%ebx
801004eb:	e9 6a ff ff ff       	jmp    8010045a <cgaputc+0x5a>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f0:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004f3:	8d 7b b0             	lea    -0x50(%ebx),%edi
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004f6:	8d b4 1b 60 7f 0b 80 	lea    -0x7ff480a0(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fd:	68 60 0e 00 00       	push   $0xe60
80100502:	68 a0 80 0b 80       	push   $0x800b80a0
80100507:	68 00 80 0b 80       	push   $0x800b8000
8010050c:	e8 5f 45 00 00       	call   80104a70 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100511:	b8 80 07 00 00       	mov    $0x780,%eax
80100516:	83 c4 0c             	add    $0xc,%esp
80100519:	29 f8                	sub    %edi,%eax
8010051b:	01 c0                	add    %eax,%eax
8010051d:	50                   	push   %eax
8010051e:	6a 00                	push   $0x0
80100520:	56                   	push   %esi
80100521:	e8 aa 44 00 00       	call   801049d0 <memset>
  outb(CRTPORT+1, pos);
80100526:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
8010052a:	83 c4 10             	add    $0x10,%esp
8010052d:	e9 4f ff ff ff       	jmp    80100481 <cgaputc+0x81>
    panic("pos under/overflow");
80100532:	83 ec 0c             	sub    $0xc,%esp
80100535:	68 45 79 10 80       	push   $0x80107945
8010053a:	e8 41 fe ff ff       	call   80100380 <panic>
8010053f:	90                   	nop

80100540 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100540:	55                   	push   %ebp
80100541:	89 e5                	mov    %esp,%ebp
80100543:	57                   	push   %edi
80100544:	56                   	push   %esi
80100545:	53                   	push   %ebx
80100546:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100549:	ff 75 08             	pushl  0x8(%ebp)
{
8010054c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010054f:	e8 1c 14 00 00       	call   80101970 <iunlock>
  acquire(&cons.lock);
80100554:	c7 04 24 00 00 11 80 	movl   $0x80110000,(%esp)
8010055b:	e8 b0 43 00 00       	call   80104910 <acquire>
  for(i = 0; i < n; i++)
80100560:	83 c4 10             	add    $0x10,%esp
80100563:	85 f6                	test   %esi,%esi
80100565:	7e 3a                	jle    801005a1 <consolewrite+0x61>
80100567:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010056a:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
8010056d:	8b 15 38 00 11 80    	mov    0x80110038,%edx
80100573:	85 d2                	test   %edx,%edx
80100575:	74 09                	je     80100580 <consolewrite+0x40>
  asm volatile("cli");
80100577:	fa                   	cli    
    for(;;)
80100578:	eb fe                	jmp    80100578 <consolewrite+0x38>
8010057a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100580:	0f b6 03             	movzbl (%ebx),%eax
    uartputc(c);
80100583:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < n; i++)
80100586:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100589:	50                   	push   %eax
8010058a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010058d:	e8 8e 5e 00 00       	call   80106420 <uartputc>
  cgaputc(c);
80100592:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100595:	e8 66 fe ff ff       	call   80100400 <cgaputc>
  for(i = 0; i < n; i++)
8010059a:	83 c4 10             	add    $0x10,%esp
8010059d:	39 df                	cmp    %ebx,%edi
8010059f:	75 cc                	jne    8010056d <consolewrite+0x2d>
  release(&cons.lock);
801005a1:	83 ec 0c             	sub    $0xc,%esp
801005a4:	68 00 00 11 80       	push   $0x80110000
801005a9:	e8 02 43 00 00       	call   801048b0 <release>
  ilock(ip);
801005ae:	58                   	pop    %eax
801005af:	ff 75 08             	pushl  0x8(%ebp)
801005b2:	e8 d9 12 00 00       	call   80101890 <ilock>

  return n;
}
801005b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005ba:	89 f0                	mov    %esi,%eax
801005bc:	5b                   	pop    %ebx
801005bd:	5e                   	pop    %esi
801005be:	5f                   	pop    %edi
801005bf:	5d                   	pop    %ebp
801005c0:	c3                   	ret    
801005c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801005c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801005cf:	90                   	nop

801005d0 <printint>:
{
801005d0:	55                   	push   %ebp
801005d1:	89 e5                	mov    %esp,%ebp
801005d3:	57                   	push   %edi
801005d4:	56                   	push   %esi
801005d5:	53                   	push   %ebx
801005d6:	83 ec 2c             	sub    $0x2c,%esp
801005d9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801005dc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
801005df:	85 c9                	test   %ecx,%ecx
801005e1:	74 04                	je     801005e7 <printint+0x17>
801005e3:	85 c0                	test   %eax,%eax
801005e5:	78 7e                	js     80100665 <printint+0x95>
    x = xx;
801005e7:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
801005ee:	89 c1                	mov    %eax,%ecx
  i = 0;
801005f0:	31 db                	xor    %ebx,%ebx
801005f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
801005f8:	89 c8                	mov    %ecx,%eax
801005fa:	31 d2                	xor    %edx,%edx
801005fc:	89 de                	mov    %ebx,%esi
801005fe:	89 cf                	mov    %ecx,%edi
80100600:	f7 75 d4             	divl   -0x2c(%ebp)
80100603:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100606:	0f b6 92 70 79 10 80 	movzbl -0x7fef8690(%edx),%edx
  }while((x /= base) != 0);
8010060d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010060f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100613:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100616:	73 e0                	jae    801005f8 <printint+0x28>
  if(sign)
80100618:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010061b:	85 c9                	test   %ecx,%ecx
8010061d:	74 0c                	je     8010062b <printint+0x5b>
    buf[i++] = '-';
8010061f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100624:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100626:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010062b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
  if(panicked){
8010062f:	a1 38 00 11 80       	mov    0x80110038,%eax
80100634:	85 c0                	test   %eax,%eax
80100636:	74 08                	je     80100640 <printint+0x70>
80100638:	fa                   	cli    
    for(;;)
80100639:	eb fe                	jmp    80100639 <printint+0x69>
8010063b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop
    consputc(buf[i]);
80100640:	0f be f2             	movsbl %dl,%esi
    uartputc(c);
80100643:	83 ec 0c             	sub    $0xc,%esp
80100646:	56                   	push   %esi
80100647:	e8 d4 5d 00 00       	call   80106420 <uartputc>
  cgaputc(c);
8010064c:	89 f0                	mov    %esi,%eax
8010064e:	e8 ad fd ff ff       	call   80100400 <cgaputc>
  while(--i >= 0)
80100653:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100656:	83 c4 10             	add    $0x10,%esp
80100659:	39 c3                	cmp    %eax,%ebx
8010065b:	74 0e                	je     8010066b <printint+0x9b>
    consputc(buf[i]);
8010065d:	0f b6 13             	movzbl (%ebx),%edx
80100660:	83 eb 01             	sub    $0x1,%ebx
80100663:	eb ca                	jmp    8010062f <printint+0x5f>
    x = -xx;
80100665:	f7 d8                	neg    %eax
80100667:	89 c1                	mov    %eax,%ecx
80100669:	eb 85                	jmp    801005f0 <printint+0x20>
}
8010066b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010066e:	5b                   	pop    %ebx
8010066f:	5e                   	pop    %esi
80100670:	5f                   	pop    %edi
80100671:	5d                   	pop    %ebp
80100672:	c3                   	ret    
80100673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010067a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100680 <cprintf>:
{
80100680:	55                   	push   %ebp
80100681:	89 e5                	mov    %esp,%ebp
80100683:	57                   	push   %edi
80100684:	56                   	push   %esi
80100685:	53                   	push   %ebx
80100686:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100689:	a1 34 00 11 80       	mov    0x80110034,%eax
8010068e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
80100691:	85 c0                	test   %eax,%eax
80100693:	0f 85 37 01 00 00    	jne    801007d0 <cprintf+0x150>
  if (fmt == 0)
80100699:	8b 75 08             	mov    0x8(%ebp),%esi
8010069c:	85 f6                	test   %esi,%esi
8010069e:	0f 84 3f 02 00 00    	je     801008e3 <cprintf+0x263>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006a4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006a7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006aa:	31 db                	xor    %ebx,%ebx
801006ac:	85 c0                	test   %eax,%eax
801006ae:	74 56                	je     80100706 <cprintf+0x86>
    if(c != '%'){
801006b0:	83 f8 25             	cmp    $0x25,%eax
801006b3:	0f 85 d7 00 00 00    	jne    80100790 <cprintf+0x110>
    c = fmt[++i] & 0xff;
801006b9:	83 c3 01             	add    $0x1,%ebx
801006bc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006c0:	85 d2                	test   %edx,%edx
801006c2:	74 42                	je     80100706 <cprintf+0x86>
    switch(c){
801006c4:	83 fa 70             	cmp    $0x70,%edx
801006c7:	0f 84 94 00 00 00    	je     80100761 <cprintf+0xe1>
801006cd:	7f 51                	jg     80100720 <cprintf+0xa0>
801006cf:	83 fa 25             	cmp    $0x25,%edx
801006d2:	0f 84 48 01 00 00    	je     80100820 <cprintf+0x1a0>
801006d8:	83 fa 64             	cmp    $0x64,%edx
801006db:	0f 85 04 01 00 00    	jne    801007e5 <cprintf+0x165>
      printint(*argp++, 10, 1);
801006e1:	8d 47 04             	lea    0x4(%edi),%eax
801006e4:	b9 01 00 00 00       	mov    $0x1,%ecx
801006e9:	ba 0a 00 00 00       	mov    $0xa,%edx
801006ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
801006f1:	8b 07                	mov    (%edi),%eax
801006f3:	e8 d8 fe ff ff       	call   801005d0 <printint>
801006f8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fb:	83 c3 01             	add    $0x1,%ebx
801006fe:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100702:	85 c0                	test   %eax,%eax
80100704:	75 aa                	jne    801006b0 <cprintf+0x30>
  if(locking)
80100706:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100709:	85 c0                	test   %eax,%eax
8010070b:	0f 85 b5 01 00 00    	jne    801008c6 <cprintf+0x246>
}
80100711:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100714:	5b                   	pop    %ebx
80100715:	5e                   	pop    %esi
80100716:	5f                   	pop    %edi
80100717:	5d                   	pop    %ebp
80100718:	c3                   	ret    
80100719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	75 33                	jne    80100758 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100725:	8d 47 04             	lea    0x4(%edi),%eax
80100728:	8b 3f                	mov    (%edi),%edi
8010072a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010072d:	85 ff                	test   %edi,%edi
8010072f:	0f 85 33 01 00 00    	jne    80100868 <cprintf+0x1e8>
        s = "(null)";
80100735:	bf 58 79 10 80       	mov    $0x80107958,%edi
      for(; *s; s++)
8010073a:	89 5d dc             	mov    %ebx,-0x24(%ebp)
8010073d:	b8 28 00 00 00       	mov    $0x28,%eax
80100742:	89 fb                	mov    %edi,%ebx
  if(panicked){
80100744:	8b 15 38 00 11 80    	mov    0x80110038,%edx
8010074a:	85 d2                	test   %edx,%edx
8010074c:	0f 84 27 01 00 00    	je     80100879 <cprintf+0x1f9>
80100752:	fa                   	cli    
    for(;;)
80100753:	eb fe                	jmp    80100753 <cprintf+0xd3>
80100755:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100758:	83 fa 78             	cmp    $0x78,%edx
8010075b:	0f 85 84 00 00 00    	jne    801007e5 <cprintf+0x165>
      printint(*argp++, 16, 0);
80100761:	8d 47 04             	lea    0x4(%edi),%eax
80100764:	31 c9                	xor    %ecx,%ecx
80100766:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010076b:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010076e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100771:	8b 07                	mov    (%edi),%eax
80100773:	e8 58 fe ff ff       	call   801005d0 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100778:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
8010077c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010077f:	85 c0                	test   %eax,%eax
80100781:	0f 85 29 ff ff ff    	jne    801006b0 <cprintf+0x30>
80100787:	e9 7a ff ff ff       	jmp    80100706 <cprintf+0x86>
8010078c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100790:	8b 0d 38 00 11 80    	mov    0x80110038,%ecx
80100796:	85 c9                	test   %ecx,%ecx
80100798:	74 06                	je     801007a0 <cprintf+0x120>
8010079a:	fa                   	cli    
    for(;;)
8010079b:	eb fe                	jmp    8010079b <cprintf+0x11b>
8010079d:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc(c);
801007a0:	83 ec 0c             	sub    $0xc,%esp
801007a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007a6:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
801007a9:	50                   	push   %eax
801007aa:	e8 71 5c 00 00       	call   80106420 <uartputc>
  cgaputc(c);
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	e8 49 fc ff ff       	call   80100400 <cgaputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007b7:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      continue;
801007bb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007be:	85 c0                	test   %eax,%eax
801007c0:	0f 85 ea fe ff ff    	jne    801006b0 <cprintf+0x30>
801007c6:	e9 3b ff ff ff       	jmp    80100706 <cprintf+0x86>
801007cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801007cf:	90                   	nop
    acquire(&cons.lock);
801007d0:	83 ec 0c             	sub    $0xc,%esp
801007d3:	68 00 00 11 80       	push   $0x80110000
801007d8:	e8 33 41 00 00       	call   80104910 <acquire>
801007dd:	83 c4 10             	add    $0x10,%esp
801007e0:	e9 b4 fe ff ff       	jmp    80100699 <cprintf+0x19>
  if(panicked){
801007e5:	8b 0d 38 00 11 80    	mov    0x80110038,%ecx
801007eb:	85 c9                	test   %ecx,%ecx
801007ed:	75 71                	jne    80100860 <cprintf+0x1e0>
    uartputc(c);
801007ef:	83 ec 0c             	sub    $0xc,%esp
801007f2:	89 55 e0             	mov    %edx,-0x20(%ebp)
801007f5:	6a 25                	push   $0x25
801007f7:	e8 24 5c 00 00       	call   80106420 <uartputc>
  cgaputc(c);
801007fc:	b8 25 00 00 00       	mov    $0x25,%eax
80100801:	e8 fa fb ff ff       	call   80100400 <cgaputc>
  if(panicked){
80100806:	8b 15 38 00 11 80    	mov    0x80110038,%edx
8010080c:	83 c4 10             	add    $0x10,%esp
8010080f:	85 d2                	test   %edx,%edx
80100811:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100814:	0f 84 8e 00 00 00    	je     801008a8 <cprintf+0x228>
8010081a:	fa                   	cli    
    for(;;)
8010081b:	eb fe                	jmp    8010081b <cprintf+0x19b>
8010081d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100820:	a1 38 00 11 80       	mov    0x80110038,%eax
80100825:	85 c0                	test   %eax,%eax
80100827:	74 07                	je     80100830 <cprintf+0x1b0>
80100829:	fa                   	cli    
    for(;;)
8010082a:	eb fe                	jmp    8010082a <cprintf+0x1aa>
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartputc(c);
80100830:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100833:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100836:	6a 25                	push   $0x25
80100838:	e8 e3 5b 00 00       	call   80106420 <uartputc>
  cgaputc(c);
8010083d:	b8 25 00 00 00       	mov    $0x25,%eax
80100842:	e8 b9 fb ff ff       	call   80100400 <cgaputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100847:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
}
8010084b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010084e:	85 c0                	test   %eax,%eax
80100850:	0f 85 5a fe ff ff    	jne    801006b0 <cprintf+0x30>
80100856:	e9 ab fe ff ff       	jmp    80100706 <cprintf+0x86>
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop
80100860:	fa                   	cli    
    for(;;)
80100861:	eb fe                	jmp    80100861 <cprintf+0x1e1>
80100863:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100867:	90                   	nop
      for(; *s; s++)
80100868:	0f b6 07             	movzbl (%edi),%eax
8010086b:	84 c0                	test   %al,%al
8010086d:	74 6c                	je     801008db <cprintf+0x25b>
8010086f:	89 5d dc             	mov    %ebx,-0x24(%ebp)
80100872:	89 fb                	mov    %edi,%ebx
80100874:	e9 cb fe ff ff       	jmp    80100744 <cprintf+0xc4>
    uartputc(c);
80100879:	83 ec 0c             	sub    $0xc,%esp
        consputc(*s);
8010087c:	0f be f8             	movsbl %al,%edi
      for(; *s; s++)
8010087f:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100882:	57                   	push   %edi
80100883:	e8 98 5b 00 00       	call   80106420 <uartputc>
  cgaputc(c);
80100888:	89 f8                	mov    %edi,%eax
8010088a:	e8 71 fb ff ff       	call   80100400 <cgaputc>
      for(; *s; s++)
8010088f:	0f b6 03             	movzbl (%ebx),%eax
80100892:	83 c4 10             	add    $0x10,%esp
80100895:	84 c0                	test   %al,%al
80100897:	0f 85 a7 fe ff ff    	jne    80100744 <cprintf+0xc4>
      if((s = (char*)*argp++) == 0)
8010089d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
801008a0:	8b 7d e0             	mov    -0x20(%ebp),%edi
801008a3:	e9 53 fe ff ff       	jmp    801006fb <cprintf+0x7b>
    uartputc(c);
801008a8:	83 ec 0c             	sub    $0xc,%esp
801008ab:	89 55 e0             	mov    %edx,-0x20(%ebp)
801008ae:	52                   	push   %edx
801008af:	e8 6c 5b 00 00       	call   80106420 <uartputc>
  cgaputc(c);
801008b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
801008b7:	89 d0                	mov    %edx,%eax
801008b9:	e8 42 fb ff ff       	call   80100400 <cgaputc>
}
801008be:	83 c4 10             	add    $0x10,%esp
801008c1:	e9 35 fe ff ff       	jmp    801006fb <cprintf+0x7b>
    release(&cons.lock);
801008c6:	83 ec 0c             	sub    $0xc,%esp
801008c9:	68 00 00 11 80       	push   $0x80110000
801008ce:	e8 dd 3f 00 00       	call   801048b0 <release>
801008d3:	83 c4 10             	add    $0x10,%esp
}
801008d6:	e9 36 fe ff ff       	jmp    80100711 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
801008db:	8b 7d e0             	mov    -0x20(%ebp),%edi
801008de:	e9 18 fe ff ff       	jmp    801006fb <cprintf+0x7b>
    panic("null fmt");
801008e3:	83 ec 0c             	sub    $0xc,%esp
801008e6:	68 5f 79 10 80       	push   $0x8010795f
801008eb:	e8 90 fa ff ff       	call   80100380 <panic>

801008f0 <consoleintr>:
{
801008f0:	55                   	push   %ebp
801008f1:	89 e5                	mov    %esp,%ebp
801008f3:	57                   	push   %edi
801008f4:	56                   	push   %esi
801008f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801008f6:	31 db                	xor    %ebx,%ebx
{
801008f8:	83 ec 28             	sub    $0x28,%esp
801008fb:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801008fe:	68 00 00 11 80       	push   $0x80110000
80100903:	e8 08 40 00 00       	call   80104910 <acquire>
  while((c = getc()) >= 0){
80100908:	83 c4 10             	add    $0x10,%esp
8010090b:	eb 1a                	jmp    80100927 <consoleintr+0x37>
8010090d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100910:	83 f8 08             	cmp    $0x8,%eax
80100913:	0f 84 17 01 00 00    	je     80100a30 <consoleintr+0x140>
80100919:	83 f8 10             	cmp    $0x10,%eax
8010091c:	0f 85 9a 01 00 00    	jne    80100abc <consoleintr+0x1cc>
80100922:	bb 01 00 00 00       	mov    $0x1,%ebx
  while((c = getc()) >= 0){
80100927:	ff d6                	call   *%esi
80100929:	85 c0                	test   %eax,%eax
8010092b:	0f 88 6f 01 00 00    	js     80100aa0 <consoleintr+0x1b0>
    switch(c){
80100931:	83 f8 15             	cmp    $0x15,%eax
80100934:	0f 84 b6 00 00 00    	je     801009f0 <consoleintr+0x100>
8010093a:	7e d4                	jle    80100910 <consoleintr+0x20>
8010093c:	83 f8 7f             	cmp    $0x7f,%eax
8010093f:	0f 84 eb 00 00 00    	je     80100a30 <consoleintr+0x140>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100945:	8b 15 e8 ff 10 80    	mov    0x8010ffe8,%edx
8010094b:	89 d1                	mov    %edx,%ecx
8010094d:	2b 0d e0 ff 10 80    	sub    0x8010ffe0,%ecx
80100953:	83 f9 7f             	cmp    $0x7f,%ecx
80100956:	77 cf                	ja     80100927 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
80100958:	89 d1                	mov    %edx,%ecx
8010095a:	83 c2 01             	add    $0x1,%edx
  if(panicked){
8010095d:	8b 3d 38 00 11 80    	mov    0x80110038,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100963:	89 15 e8 ff 10 80    	mov    %edx,0x8010ffe8
80100969:	83 e1 7f             	and    $0x7f,%ecx
        c = (c == '\r') ? '\n' : c;
8010096c:	83 f8 0d             	cmp    $0xd,%eax
8010096f:	0f 84 9b 01 00 00    	je     80100b10 <consoleintr+0x220>
        input.buf[input.e++ % INPUT_BUF] = c;
80100975:	88 81 60 ff 10 80    	mov    %al,-0x7fef00a0(%ecx)
  if(panicked){
8010097b:	85 ff                	test   %edi,%edi
8010097d:	0f 85 98 01 00 00    	jne    80100b1b <consoleintr+0x22b>
  if(c == BACKSPACE){
80100983:	3d 00 01 00 00       	cmp    $0x100,%eax
80100988:	0f 85 b3 01 00 00    	jne    80100b41 <consoleintr+0x251>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010098e:	83 ec 0c             	sub    $0xc,%esp
80100991:	6a 08                	push   $0x8
80100993:	e8 88 5a 00 00       	call   80106420 <uartputc>
80100998:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010099f:	e8 7c 5a 00 00       	call   80106420 <uartputc>
801009a4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801009ab:	e8 70 5a 00 00       	call   80106420 <uartputc>
  cgaputc(c);
801009b0:	b8 00 01 00 00       	mov    $0x100,%eax
801009b5:	e8 46 fa ff ff       	call   80100400 <cgaputc>
801009ba:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009bd:	a1 e0 ff 10 80       	mov    0x8010ffe0,%eax
801009c2:	83 e8 80             	sub    $0xffffff80,%eax
801009c5:	39 05 e8 ff 10 80    	cmp    %eax,0x8010ffe8
801009cb:	0f 85 56 ff ff ff    	jne    80100927 <consoleintr+0x37>
          wakeup(&input.r);
801009d1:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
801009d4:	a3 e4 ff 10 80       	mov    %eax,0x8010ffe4
          wakeup(&input.r);
801009d9:	68 e0 ff 10 80       	push   $0x8010ffe0
801009de:	e8 3d 38 00 00       	call   80104220 <wakeup>
801009e3:	83 c4 10             	add    $0x10,%esp
801009e6:	e9 3c ff ff ff       	jmp    80100927 <consoleintr+0x37>
801009eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801009ef:	90                   	nop
      while(input.e != input.w &&
801009f0:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
801009f5:	3b 05 e4 ff 10 80    	cmp    0x8010ffe4,%eax
801009fb:	0f 84 26 ff ff ff    	je     80100927 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100a01:	83 e8 01             	sub    $0x1,%eax
80100a04:	89 c2                	mov    %eax,%edx
80100a06:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100a09:	80 ba 60 ff 10 80 0a 	cmpb   $0xa,-0x7fef00a0(%edx)
80100a10:	0f 84 11 ff ff ff    	je     80100927 <consoleintr+0x37>
  if(panicked){
80100a16:	8b 15 38 00 11 80    	mov    0x80110038,%edx
        input.e--;
80100a1c:	a3 e8 ff 10 80       	mov    %eax,0x8010ffe8
  if(panicked){
80100a21:	85 d2                	test   %edx,%edx
80100a23:	74 33                	je     80100a58 <consoleintr+0x168>
80100a25:	fa                   	cli    
    for(;;)
80100a26:	eb fe                	jmp    80100a26 <consoleintr+0x136>
80100a28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a2f:	90                   	nop
      if(input.e != input.w){
80100a30:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
80100a35:	3b 05 e4 ff 10 80    	cmp    0x8010ffe4,%eax
80100a3b:	0f 84 e6 fe ff ff    	je     80100927 <consoleintr+0x37>
        input.e--;
80100a41:	83 e8 01             	sub    $0x1,%eax
80100a44:	a3 e8 ff 10 80       	mov    %eax,0x8010ffe8
  if(panicked){
80100a49:	a1 38 00 11 80       	mov    0x80110038,%eax
80100a4e:	85 c0                	test   %eax,%eax
80100a50:	74 7e                	je     80100ad0 <consoleintr+0x1e0>
80100a52:	fa                   	cli    
    for(;;)
80100a53:	eb fe                	jmp    80100a53 <consoleintr+0x163>
80100a55:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100a58:	83 ec 0c             	sub    $0xc,%esp
80100a5b:	6a 08                	push   $0x8
80100a5d:	e8 be 59 00 00       	call   80106420 <uartputc>
80100a62:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100a69:	e8 b2 59 00 00       	call   80106420 <uartputc>
80100a6e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100a75:	e8 a6 59 00 00       	call   80106420 <uartputc>
  cgaputc(c);
80100a7a:	b8 00 01 00 00       	mov    $0x100,%eax
80100a7f:	e8 7c f9 ff ff       	call   80100400 <cgaputc>
      while(input.e != input.w &&
80100a84:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
80100a89:	83 c4 10             	add    $0x10,%esp
80100a8c:	3b 05 e4 ff 10 80    	cmp    0x8010ffe4,%eax
80100a92:	0f 85 69 ff ff ff    	jne    80100a01 <consoleintr+0x111>
80100a98:	e9 8a fe ff ff       	jmp    80100927 <consoleintr+0x37>
80100a9d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&cons.lock);
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	68 00 00 11 80       	push   $0x80110000
80100aa8:	e8 03 3e 00 00       	call   801048b0 <release>
  if(doprocdump) {
80100aad:	83 c4 10             	add    $0x10,%esp
80100ab0:	85 db                	test   %ebx,%ebx
80100ab2:	75 50                	jne    80100b04 <consoleintr+0x214>
}
80100ab4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ab7:	5b                   	pop    %ebx
80100ab8:	5e                   	pop    %esi
80100ab9:	5f                   	pop    %edi
80100aba:	5d                   	pop    %ebp
80100abb:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100abc:	85 c0                	test   %eax,%eax
80100abe:	0f 84 63 fe ff ff    	je     80100927 <consoleintr+0x37>
80100ac4:	e9 7c fe ff ff       	jmp    80100945 <consoleintr+0x55>
80100ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100ad0:	83 ec 0c             	sub    $0xc,%esp
80100ad3:	6a 08                	push   $0x8
80100ad5:	e8 46 59 00 00       	call   80106420 <uartputc>
80100ada:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100ae1:	e8 3a 59 00 00       	call   80106420 <uartputc>
80100ae6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100aed:	e8 2e 59 00 00       	call   80106420 <uartputc>
  cgaputc(c);
80100af2:	b8 00 01 00 00       	mov    $0x100,%eax
80100af7:	e8 04 f9 ff ff       	call   80100400 <cgaputc>
}
80100afc:	83 c4 10             	add    $0x10,%esp
80100aff:	e9 23 fe ff ff       	jmp    80100927 <consoleintr+0x37>
}
80100b04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b07:	5b                   	pop    %ebx
80100b08:	5e                   	pop    %esi
80100b09:	5f                   	pop    %edi
80100b0a:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100b0b:	e9 f0 37 00 00       	jmp    80104300 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100b10:	c6 81 60 ff 10 80 0a 	movb   $0xa,-0x7fef00a0(%ecx)
  if(panicked){
80100b17:	85 ff                	test   %edi,%edi
80100b19:	74 05                	je     80100b20 <consoleintr+0x230>
80100b1b:	fa                   	cli    
    for(;;)
80100b1c:	eb fe                	jmp    80100b1c <consoleintr+0x22c>
80100b1e:	66 90                	xchg   %ax,%ax
    uartputc(c);
80100b20:	83 ec 0c             	sub    $0xc,%esp
80100b23:	6a 0a                	push   $0xa
80100b25:	e8 f6 58 00 00       	call   80106420 <uartputc>
  cgaputc(c);
80100b2a:	b8 0a 00 00 00       	mov    $0xa,%eax
80100b2f:	e8 cc f8 ff ff       	call   80100400 <cgaputc>
          input.w = input.e;
80100b34:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
80100b39:	83 c4 10             	add    $0x10,%esp
80100b3c:	e9 90 fe ff ff       	jmp    801009d1 <consoleintr+0xe1>
    uartputc(c);
80100b41:	83 ec 0c             	sub    $0xc,%esp
80100b44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100b47:	50                   	push   %eax
80100b48:	e8 d3 58 00 00       	call   80106420 <uartputc>
  cgaputc(c);
80100b4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100b50:	e8 ab f8 ff ff       	call   80100400 <cgaputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100b55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100b58:	83 c4 10             	add    $0x10,%esp
80100b5b:	83 f8 0a             	cmp    $0xa,%eax
80100b5e:	74 09                	je     80100b69 <consoleintr+0x279>
80100b60:	83 f8 04             	cmp    $0x4,%eax
80100b63:	0f 85 54 fe ff ff    	jne    801009bd <consoleintr+0xcd>
          input.w = input.e;
80100b69:	a1 e8 ff 10 80       	mov    0x8010ffe8,%eax
80100b6e:	e9 5e fe ff ff       	jmp    801009d1 <consoleintr+0xe1>
80100b73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100b80 <consoleinit>:

void
consoleinit(void)
{
80100b80:	55                   	push   %ebp
80100b81:	89 e5                	mov    %esp,%ebp
80100b83:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100b86:	68 68 79 10 80       	push   $0x80107968
80100b8b:	68 00 00 11 80       	push   $0x80110000
80100b90:	e8 ab 3b 00 00       	call   80104740 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100b95:	58                   	pop    %eax
80100b96:	5a                   	pop    %edx
80100b97:	6a 00                	push   $0x0
80100b99:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100b9b:	c7 05 ec 09 11 80 40 	movl   $0x80100540,0x801109ec
80100ba2:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100ba5:	c7 05 e8 09 11 80 80 	movl   $0x80100280,0x801109e8
80100bac:	02 10 80 
  cons.locking = 1;
80100baf:	c7 05 34 00 11 80 01 	movl   $0x1,0x80110034
80100bb6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100bb9:	e8 d2 19 00 00       	call   80102590 <ioapicenable>
}
80100bbe:	83 c4 10             	add    $0x10,%esp
80100bc1:	c9                   	leave  
80100bc2:	c3                   	ret    
80100bc3:	66 90                	xchg   %ax,%ax
80100bc5:	66 90                	xchg   %ax,%ax
80100bc7:	66 90                	xchg   %ax,%ax
80100bc9:	66 90                	xchg   %ax,%ax
80100bcb:	66 90                	xchg   %ax,%ax
80100bcd:	66 90                	xchg   %ax,%ax
80100bcf:	90                   	nop

80100bd0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100bd0:	55                   	push   %ebp
80100bd1:	89 e5                	mov    %esp,%ebp
80100bd3:	57                   	push   %edi
80100bd4:	56                   	push   %esi
80100bd5:	53                   	push   %ebx
80100bd6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100bdc:	e8 af 2e 00 00       	call   80103a90 <myproc>
80100be1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100be7:	e8 84 22 00 00       	call   80102e70 <begin_op>

  if((ip = namei(path)) == 0){
80100bec:	83 ec 0c             	sub    $0xc,%esp
80100bef:	ff 75 08             	pushl  0x8(%ebp)
80100bf2:	e8 b9 15 00 00       	call   801021b0 <namei>
80100bf7:	83 c4 10             	add    $0x10,%esp
80100bfa:	85 c0                	test   %eax,%eax
80100bfc:	0f 84 02 03 00 00    	je     80100f04 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100c02:	83 ec 0c             	sub    $0xc,%esp
80100c05:	89 c3                	mov    %eax,%ebx
80100c07:	50                   	push   %eax
80100c08:	e8 83 0c 00 00       	call   80101890 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100c0d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100c13:	6a 34                	push   $0x34
80100c15:	6a 00                	push   $0x0
80100c17:	50                   	push   %eax
80100c18:	53                   	push   %ebx
80100c19:	e8 82 0f 00 00       	call   80101ba0 <readi>
80100c1e:	83 c4 20             	add    $0x20,%esp
80100c21:	83 f8 34             	cmp    $0x34,%eax
80100c24:	74 22                	je     80100c48 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100c26:	83 ec 0c             	sub    $0xc,%esp
80100c29:	53                   	push   %ebx
80100c2a:	e8 f1 0e 00 00       	call   80101b20 <iunlockput>
    end_op();
80100c2f:	e8 ac 22 00 00       	call   80102ee0 <end_op>
80100c34:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100c37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100c3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c3f:	5b                   	pop    %ebx
80100c40:	5e                   	pop    %esi
80100c41:	5f                   	pop    %edi
80100c42:	5d                   	pop    %ebp
80100c43:	c3                   	ret    
80100c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100c48:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100c4f:	45 4c 46 
80100c52:	75 d2                	jne    80100c26 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100c54:	e8 57 69 00 00       	call   801075b0 <setupkvm>
80100c59:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100c5f:	85 c0                	test   %eax,%eax
80100c61:	74 c3                	je     80100c26 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c63:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100c6a:	00 
80100c6b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100c71:	0f 84 ac 02 00 00    	je     80100f23 <exec+0x353>
  sz = 0;
80100c77:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100c7e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c81:	31 ff                	xor    %edi,%edi
80100c83:	e9 8e 00 00 00       	jmp    80100d16 <exec+0x146>
80100c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c8f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100c90:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100c97:	75 6c                	jne    80100d05 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100c99:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100c9f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ca5:	0f 82 87 00 00 00    	jb     80100d32 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100cab:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100cb1:	72 7f                	jb     80100d32 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100cb3:	83 ec 04             	sub    $0x4,%esp
80100cb6:	50                   	push   %eax
80100cb7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100cbd:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100cc3:	e8 08 67 00 00       	call   801073d0 <allocuvm>
80100cc8:	83 c4 10             	add    $0x10,%esp
80100ccb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100cd1:	85 c0                	test   %eax,%eax
80100cd3:	74 5d                	je     80100d32 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100cd5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100cdb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ce0:	75 50                	jne    80100d32 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100ce2:	83 ec 0c             	sub    $0xc,%esp
80100ce5:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100ceb:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100cf1:	53                   	push   %ebx
80100cf2:	50                   	push   %eax
80100cf3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100cf9:	e8 e2 65 00 00       	call   801072e0 <loaduvm>
80100cfe:	83 c4 20             	add    $0x20,%esp
80100d01:	85 c0                	test   %eax,%eax
80100d03:	78 2d                	js     80100d32 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d05:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100d0c:	83 c7 01             	add    $0x1,%edi
80100d0f:	83 c6 20             	add    $0x20,%esi
80100d12:	39 f8                	cmp    %edi,%eax
80100d14:	7e 3a                	jle    80100d50 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100d16:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100d1c:	6a 20                	push   $0x20
80100d1e:	56                   	push   %esi
80100d1f:	50                   	push   %eax
80100d20:	53                   	push   %ebx
80100d21:	e8 7a 0e 00 00       	call   80101ba0 <readi>
80100d26:	83 c4 10             	add    $0x10,%esp
80100d29:	83 f8 20             	cmp    $0x20,%eax
80100d2c:	0f 84 5e ff ff ff    	je     80100c90 <exec+0xc0>
    freevm(pgdir);
80100d32:	83 ec 0c             	sub    $0xc,%esp
80100d35:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d3b:	e8 f0 67 00 00       	call   80107530 <freevm>
  if(ip){
80100d40:	83 c4 10             	add    $0x10,%esp
80100d43:	e9 de fe ff ff       	jmp    80100c26 <exec+0x56>
80100d48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d4f:	90                   	nop
  sz = PGROUNDUP(sz);
80100d50:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d56:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100d5c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d62:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100d68:	83 ec 0c             	sub    $0xc,%esp
80100d6b:	53                   	push   %ebx
80100d6c:	e8 af 0d 00 00       	call   80101b20 <iunlockput>
  end_op();
80100d71:	e8 6a 21 00 00       	call   80102ee0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d76:	83 c4 0c             	add    $0xc,%esp
80100d79:	56                   	push   %esi
80100d7a:	57                   	push   %edi
80100d7b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100d81:	57                   	push   %edi
80100d82:	e8 49 66 00 00       	call   801073d0 <allocuvm>
80100d87:	83 c4 10             	add    $0x10,%esp
80100d8a:	89 c6                	mov    %eax,%esi
80100d8c:	85 c0                	test   %eax,%eax
80100d8e:	0f 84 94 00 00 00    	je     80100e28 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d94:	83 ec 08             	sub    $0x8,%esp
80100d97:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100d9d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d9f:	50                   	push   %eax
80100da0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100da1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100da3:	e8 a8 68 00 00       	call   80107650 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100da8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dab:	83 c4 10             	add    $0x10,%esp
80100dae:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100db4:	8b 00                	mov    (%eax),%eax
80100db6:	85 c0                	test   %eax,%eax
80100db8:	0f 84 8b 00 00 00    	je     80100e49 <exec+0x279>
80100dbe:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100dc4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100dca:	eb 23                	jmp    80100def <exec+0x21f>
80100dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100dd3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100dda:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100ddd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100de3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100de6:	85 c0                	test   %eax,%eax
80100de8:	74 59                	je     80100e43 <exec+0x273>
    if(argc >= MAXARG)
80100dea:	83 ff 20             	cmp    $0x20,%edi
80100ded:	74 39                	je     80100e28 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100def:	83 ec 0c             	sub    $0xc,%esp
80100df2:	50                   	push   %eax
80100df3:	e8 d8 3d 00 00       	call   80104bd0 <strlen>
80100df8:	f7 d0                	not    %eax
80100dfa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100dfc:	58                   	pop    %eax
80100dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e00:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e03:	ff 34 b8             	pushl  (%eax,%edi,4)
80100e06:	e8 c5 3d 00 00       	call   80104bd0 <strlen>
80100e0b:	83 c0 01             	add    $0x1,%eax
80100e0e:	50                   	push   %eax
80100e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e12:	ff 34 b8             	pushl  (%eax,%edi,4)
80100e15:	53                   	push   %ebx
80100e16:	56                   	push   %esi
80100e17:	e8 04 6a 00 00       	call   80107820 <copyout>
80100e1c:	83 c4 20             	add    $0x20,%esp
80100e1f:	85 c0                	test   %eax,%eax
80100e21:	79 ad                	jns    80100dd0 <exec+0x200>
80100e23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e27:	90                   	nop
    freevm(pgdir);
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100e31:	e8 fa 66 00 00       	call   80107530 <freevm>
80100e36:	83 c4 10             	add    $0x10,%esp
  return -1;
80100e39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e3e:	e9 f9 fd ff ff       	jmp    80100c3c <exec+0x6c>
80100e43:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e49:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100e50:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100e52:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100e59:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e5d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100e5f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100e62:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100e68:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e6a:	50                   	push   %eax
80100e6b:	52                   	push   %edx
80100e6c:	53                   	push   %ebx
80100e6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100e73:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100e7a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e7d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e83:	e8 98 69 00 00       	call   80107820 <copyout>
80100e88:	83 c4 10             	add    $0x10,%esp
80100e8b:	85 c0                	test   %eax,%eax
80100e8d:	78 99                	js     80100e28 <exec+0x258>
  for(last=s=path; *s; s++)
80100e8f:	8b 45 08             	mov    0x8(%ebp),%eax
80100e92:	8b 55 08             	mov    0x8(%ebp),%edx
80100e95:	0f b6 00             	movzbl (%eax),%eax
80100e98:	84 c0                	test   %al,%al
80100e9a:	74 13                	je     80100eaf <exec+0x2df>
80100e9c:	89 d1                	mov    %edx,%ecx
80100e9e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100ea0:	83 c1 01             	add    $0x1,%ecx
80100ea3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100ea5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100ea8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100eab:	84 c0                	test   %al,%al
80100ead:	75 f1                	jne    80100ea0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100eaf:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100eb5:	83 ec 04             	sub    $0x4,%esp
80100eb8:	6a 10                	push   $0x10
80100eba:	89 f8                	mov    %edi,%eax
80100ebc:	52                   	push   %edx
80100ebd:	83 c0 6c             	add    $0x6c,%eax
80100ec0:	50                   	push   %eax
80100ec1:	e8 ca 3c 00 00       	call   80104b90 <safestrcpy>
  curproc->pgdir = pgdir;
80100ec6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100ecc:	89 f8                	mov    %edi,%eax
80100ece:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100ed1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100ed3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100ed6:	89 c1                	mov    %eax,%ecx
80100ed8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100ede:	8b 40 18             	mov    0x18(%eax),%eax
80100ee1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100ee4:	8b 41 18             	mov    0x18(%ecx),%eax
80100ee7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100eea:	89 0c 24             	mov    %ecx,(%esp)
80100eed:	e8 5e 62 00 00       	call   80107150 <switchuvm>
  freevm(oldpgdir);
80100ef2:	89 3c 24             	mov    %edi,(%esp)
80100ef5:	e8 36 66 00 00       	call   80107530 <freevm>
  return 0;
80100efa:	83 c4 10             	add    $0x10,%esp
80100efd:	31 c0                	xor    %eax,%eax
80100eff:	e9 38 fd ff ff       	jmp    80100c3c <exec+0x6c>
    end_op();
80100f04:	e8 d7 1f 00 00       	call   80102ee0 <end_op>
    cprintf("exec: fail\n");
80100f09:	83 ec 0c             	sub    $0xc,%esp
80100f0c:	68 81 79 10 80       	push   $0x80107981
80100f11:	e8 6a f7 ff ff       	call   80100680 <cprintf>
    return -1;
80100f16:	83 c4 10             	add    $0x10,%esp
80100f19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f1e:	e9 19 fd ff ff       	jmp    80100c3c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100f23:	31 ff                	xor    %edi,%edi
80100f25:	be 00 20 00 00       	mov    $0x2000,%esi
80100f2a:	e9 39 fe ff ff       	jmp    80100d68 <exec+0x198>
80100f2f:	90                   	nop

80100f30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100f36:	68 8d 79 10 80       	push   $0x8010798d
80100f3b:	68 40 00 11 80       	push   $0x80110040
80100f40:	e8 fb 37 00 00       	call   80104740 <initlock>
}
80100f45:	83 c4 10             	add    $0x10,%esp
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f54:	bb 74 00 11 80       	mov    $0x80110074,%ebx
{
80100f59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100f5c:	68 40 00 11 80       	push   $0x80110040
80100f61:	e8 aa 39 00 00       	call   80104910 <acquire>
80100f66:	83 c4 10             	add    $0x10,%esp
80100f69:	eb 10                	jmp    80100f7b <filealloc+0x2b>
80100f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f6f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f70:	83 c3 18             	add    $0x18,%ebx
80100f73:	81 fb d4 09 11 80    	cmp    $0x801109d4,%ebx
80100f79:	74 25                	je     80100fa0 <filealloc+0x50>
    if(f->ref == 0){
80100f7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100f7e:	85 c0                	test   %eax,%eax
80100f80:	75 ee                	jne    80100f70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100f82:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100f85:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100f8c:	68 40 00 11 80       	push   $0x80110040
80100f91:	e8 1a 39 00 00       	call   801048b0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100f96:	89 d8                	mov    %ebx,%eax
      return f;
80100f98:	83 c4 10             	add    $0x10,%esp
}
80100f9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f9e:	c9                   	leave  
80100f9f:	c3                   	ret    
  release(&ftable.lock);
80100fa0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100fa3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100fa5:	68 40 00 11 80       	push   $0x80110040
80100faa:	e8 01 39 00 00       	call   801048b0 <release>
}
80100faf:	89 d8                	mov    %ebx,%eax
  return 0;
80100fb1:	83 c4 10             	add    $0x10,%esp
}
80100fb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fb7:	c9                   	leave  
80100fb8:	c3                   	ret    
80100fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100fc0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	53                   	push   %ebx
80100fc4:	83 ec 10             	sub    $0x10,%esp
80100fc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100fca:	68 40 00 11 80       	push   $0x80110040
80100fcf:	e8 3c 39 00 00       	call   80104910 <acquire>
  if(f->ref < 1)
80100fd4:	8b 43 04             	mov    0x4(%ebx),%eax
80100fd7:	83 c4 10             	add    $0x10,%esp
80100fda:	85 c0                	test   %eax,%eax
80100fdc:	7e 1a                	jle    80100ff8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100fde:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100fe1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100fe4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100fe7:	68 40 00 11 80       	push   $0x80110040
80100fec:	e8 bf 38 00 00       	call   801048b0 <release>
  return f;
}
80100ff1:	89 d8                	mov    %ebx,%eax
80100ff3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ff6:	c9                   	leave  
80100ff7:	c3                   	ret    
    panic("filedup");
80100ff8:	83 ec 0c             	sub    $0xc,%esp
80100ffb:	68 94 79 10 80       	push   $0x80107994
80101000:	e8 7b f3 ff ff       	call   80100380 <panic>
80101005:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010100c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101010 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101010:	55                   	push   %ebp
80101011:	89 e5                	mov    %esp,%ebp
80101013:	57                   	push   %edi
80101014:	56                   	push   %esi
80101015:	53                   	push   %ebx
80101016:	83 ec 28             	sub    $0x28,%esp
80101019:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010101c:	68 40 00 11 80       	push   $0x80110040
80101021:	e8 ea 38 00 00       	call   80104910 <acquire>
  if(f->ref < 1)
80101026:	8b 53 04             	mov    0x4(%ebx),%edx
80101029:	83 c4 10             	add    $0x10,%esp
8010102c:	85 d2                	test   %edx,%edx
8010102e:	0f 8e a5 00 00 00    	jle    801010d9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101034:	83 ea 01             	sub    $0x1,%edx
80101037:	89 53 04             	mov    %edx,0x4(%ebx)
8010103a:	75 44                	jne    80101080 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010103c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101040:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101043:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101045:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010104b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010104e:	88 45 e7             	mov    %al,-0x19(%ebp)
80101051:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101054:	68 40 00 11 80       	push   $0x80110040
  ff = *f;
80101059:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
8010105c:	e8 4f 38 00 00       	call   801048b0 <release>

  if(ff.type == FD_PIPE)
80101061:	83 c4 10             	add    $0x10,%esp
80101064:	83 ff 01             	cmp    $0x1,%edi
80101067:	74 57                	je     801010c0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101069:	83 ff 02             	cmp    $0x2,%edi
8010106c:	74 2a                	je     80101098 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010106e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101071:	5b                   	pop    %ebx
80101072:	5e                   	pop    %esi
80101073:	5f                   	pop    %edi
80101074:	5d                   	pop    %ebp
80101075:	c3                   	ret    
80101076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010107d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101080:	c7 45 08 40 00 11 80 	movl   $0x80110040,0x8(%ebp)
}
80101087:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010108a:	5b                   	pop    %ebx
8010108b:	5e                   	pop    %esi
8010108c:	5f                   	pop    %edi
8010108d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010108e:	e9 1d 38 00 00       	jmp    801048b0 <release>
80101093:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101097:	90                   	nop
    begin_op();
80101098:	e8 d3 1d 00 00       	call   80102e70 <begin_op>
    iput(ff.ip);
8010109d:	83 ec 0c             	sub    $0xc,%esp
801010a0:	ff 75 e0             	pushl  -0x20(%ebp)
801010a3:	e8 18 09 00 00       	call   801019c0 <iput>
    end_op();
801010a8:	83 c4 10             	add    $0x10,%esp
}
801010ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010ae:	5b                   	pop    %ebx
801010af:	5e                   	pop    %esi
801010b0:	5f                   	pop    %edi
801010b1:	5d                   	pop    %ebp
    end_op();
801010b2:	e9 29 1e 00 00       	jmp    80102ee0 <end_op>
801010b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010be:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801010c0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801010c4:	83 ec 08             	sub    $0x8,%esp
801010c7:	53                   	push   %ebx
801010c8:	56                   	push   %esi
801010c9:	e8 72 25 00 00       	call   80103640 <pipeclose>
801010ce:	83 c4 10             	add    $0x10,%esp
}
801010d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d4:	5b                   	pop    %ebx
801010d5:	5e                   	pop    %esi
801010d6:	5f                   	pop    %edi
801010d7:	5d                   	pop    %ebp
801010d8:	c3                   	ret    
    panic("fileclose");
801010d9:	83 ec 0c             	sub    $0xc,%esp
801010dc:	68 9c 79 10 80       	push   $0x8010799c
801010e1:	e8 9a f2 ff ff       	call   80100380 <panic>
801010e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ed:	8d 76 00             	lea    0x0(%esi),%esi

801010f0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010f0:	55                   	push   %ebp
801010f1:	89 e5                	mov    %esp,%ebp
801010f3:	53                   	push   %ebx
801010f4:	83 ec 04             	sub    $0x4,%esp
801010f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801010fa:	83 3b 02             	cmpl   $0x2,(%ebx)
801010fd:	75 31                	jne    80101130 <filestat+0x40>
    ilock(f->ip);
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	ff 73 10             	pushl  0x10(%ebx)
80101105:	e8 86 07 00 00       	call   80101890 <ilock>
    stati(f->ip, st);
8010110a:	58                   	pop    %eax
8010110b:	5a                   	pop    %edx
8010110c:	ff 75 0c             	pushl  0xc(%ebp)
8010110f:	ff 73 10             	pushl  0x10(%ebx)
80101112:	e8 59 0a 00 00       	call   80101b70 <stati>
    iunlock(f->ip);
80101117:	59                   	pop    %ecx
80101118:	ff 73 10             	pushl  0x10(%ebx)
8010111b:	e8 50 08 00 00       	call   80101970 <iunlock>
    return 0;
  }
  return -1;
}
80101120:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101123:	83 c4 10             	add    $0x10,%esp
80101126:	31 c0                	xor    %eax,%eax
}
80101128:	c9                   	leave  
80101129:	c3                   	ret    
8010112a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101130:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101133:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101138:	c9                   	leave  
80101139:	c3                   	ret    
8010113a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101140 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101140:	55                   	push   %ebp
80101141:	89 e5                	mov    %esp,%ebp
80101143:	57                   	push   %edi
80101144:	56                   	push   %esi
80101145:	53                   	push   %ebx
80101146:	83 ec 0c             	sub    $0xc,%esp
80101149:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010114c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010114f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101152:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101156:	74 60                	je     801011b8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101158:	8b 03                	mov    (%ebx),%eax
8010115a:	83 f8 01             	cmp    $0x1,%eax
8010115d:	74 41                	je     801011a0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010115f:	83 f8 02             	cmp    $0x2,%eax
80101162:	75 5b                	jne    801011bf <fileread+0x7f>
    ilock(f->ip);
80101164:	83 ec 0c             	sub    $0xc,%esp
80101167:	ff 73 10             	pushl  0x10(%ebx)
8010116a:	e8 21 07 00 00       	call   80101890 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010116f:	57                   	push   %edi
80101170:	ff 73 14             	pushl  0x14(%ebx)
80101173:	56                   	push   %esi
80101174:	ff 73 10             	pushl  0x10(%ebx)
80101177:	e8 24 0a 00 00       	call   80101ba0 <readi>
8010117c:	83 c4 20             	add    $0x20,%esp
8010117f:	89 c6                	mov    %eax,%esi
80101181:	85 c0                	test   %eax,%eax
80101183:	7e 03                	jle    80101188 <fileread+0x48>
      f->off += r;
80101185:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101188:	83 ec 0c             	sub    $0xc,%esp
8010118b:	ff 73 10             	pushl  0x10(%ebx)
8010118e:	e8 dd 07 00 00       	call   80101970 <iunlock>
    return r;
80101193:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101196:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101199:	89 f0                	mov    %esi,%eax
8010119b:	5b                   	pop    %ebx
8010119c:	5e                   	pop    %esi
8010119d:	5f                   	pop    %edi
8010119e:	5d                   	pop    %ebp
8010119f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801011a0:	8b 43 0c             	mov    0xc(%ebx),%eax
801011a3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a9:	5b                   	pop    %ebx
801011aa:	5e                   	pop    %esi
801011ab:	5f                   	pop    %edi
801011ac:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801011ad:	e9 2e 26 00 00       	jmp    801037e0 <piperead>
801011b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801011b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801011bd:	eb d7                	jmp    80101196 <fileread+0x56>
  panic("fileread");
801011bf:	83 ec 0c             	sub    $0xc,%esp
801011c2:	68 a6 79 10 80       	push   $0x801079a6
801011c7:	e8 b4 f1 ff ff       	call   80100380 <panic>
801011cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801011d0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011d0:	55                   	push   %ebp
801011d1:	89 e5                	mov    %esp,%ebp
801011d3:	57                   	push   %edi
801011d4:	56                   	push   %esi
801011d5:	53                   	push   %ebx
801011d6:	83 ec 1c             	sub    $0x1c,%esp
801011d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801011dc:	8b 75 08             	mov    0x8(%ebp),%esi
801011df:	89 45 dc             	mov    %eax,-0x24(%ebp)
801011e2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801011e5:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801011e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801011ec:	0f 84 bd 00 00 00    	je     801012af <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801011f2:	8b 06                	mov    (%esi),%eax
801011f4:	83 f8 01             	cmp    $0x1,%eax
801011f7:	0f 84 bf 00 00 00    	je     801012bc <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801011fd:	83 f8 02             	cmp    $0x2,%eax
80101200:	0f 85 c8 00 00 00    	jne    801012ce <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101206:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101209:	31 ff                	xor    %edi,%edi
    while(i < n){
8010120b:	85 c0                	test   %eax,%eax
8010120d:	7f 30                	jg     8010123f <filewrite+0x6f>
8010120f:	e9 94 00 00 00       	jmp    801012a8 <filewrite+0xd8>
80101214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101218:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010121b:	83 ec 0c             	sub    $0xc,%esp
8010121e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101221:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101224:	e8 47 07 00 00       	call   80101970 <iunlock>
      end_op();
80101229:	e8 b2 1c 00 00       	call   80102ee0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010122e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101231:	83 c4 10             	add    $0x10,%esp
80101234:	39 c3                	cmp    %eax,%ebx
80101236:	75 60                	jne    80101298 <filewrite+0xc8>
        panic("short filewrite");
      i += r;
80101238:	01 df                	add    %ebx,%edi
    while(i < n){
8010123a:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
8010123d:	7e 69                	jle    801012a8 <filewrite+0xd8>
      int n1 = n - i;
8010123f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101242:	b8 00 06 00 00       	mov    $0x600,%eax
80101247:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101249:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
8010124f:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101252:	e8 19 1c 00 00       	call   80102e70 <begin_op>
      ilock(f->ip);
80101257:	83 ec 0c             	sub    $0xc,%esp
8010125a:	ff 76 10             	pushl  0x10(%esi)
8010125d:	e8 2e 06 00 00       	call   80101890 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101262:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101265:	53                   	push   %ebx
80101266:	ff 76 14             	pushl  0x14(%esi)
80101269:	01 f8                	add    %edi,%eax
8010126b:	50                   	push   %eax
8010126c:	ff 76 10             	pushl  0x10(%esi)
8010126f:	e8 2c 0a 00 00       	call   80101ca0 <writei>
80101274:	83 c4 20             	add    $0x20,%esp
80101277:	85 c0                	test   %eax,%eax
80101279:	7f 9d                	jg     80101218 <filewrite+0x48>
      iunlock(f->ip);
8010127b:	83 ec 0c             	sub    $0xc,%esp
8010127e:	ff 76 10             	pushl  0x10(%esi)
80101281:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101284:	e8 e7 06 00 00       	call   80101970 <iunlock>
      end_op();
80101289:	e8 52 1c 00 00       	call   80102ee0 <end_op>
      if(r < 0)
8010128e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101291:	83 c4 10             	add    $0x10,%esp
80101294:	85 c0                	test   %eax,%eax
80101296:	75 17                	jne    801012af <filewrite+0xdf>
        panic("short filewrite");
80101298:	83 ec 0c             	sub    $0xc,%esp
8010129b:	68 af 79 10 80       	push   $0x801079af
801012a0:	e8 db f0 ff ff       	call   80100380 <panic>
801012a5:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
801012a8:	89 f8                	mov    %edi,%eax
801012aa:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801012ad:	74 05                	je     801012b4 <filewrite+0xe4>
801012af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801012b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012b7:	5b                   	pop    %ebx
801012b8:	5e                   	pop    %esi
801012b9:	5f                   	pop    %edi
801012ba:	5d                   	pop    %ebp
801012bb:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801012bc:	8b 46 0c             	mov    0xc(%esi),%eax
801012bf:	89 45 08             	mov    %eax,0x8(%ebp)
}
801012c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012c5:	5b                   	pop    %ebx
801012c6:	5e                   	pop    %esi
801012c7:	5f                   	pop    %edi
801012c8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801012c9:	e9 12 24 00 00       	jmp    801036e0 <pipewrite>
  panic("filewrite");
801012ce:	83 ec 0c             	sub    $0xc,%esp
801012d1:	68 b5 79 10 80       	push   $0x801079b5
801012d6:	e8 a5 f0 ff ff       	call   80100380 <panic>
801012db:	66 90                	xchg   %ax,%ax
801012dd:	66 90                	xchg   %ax,%ax
801012df:	90                   	nop

801012e0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801012e0:	55                   	push   %ebp
801012e1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801012e3:	89 d0                	mov    %edx,%eax
801012e5:	c1 e8 0c             	shr    $0xc,%eax
801012e8:	03 05 ac 26 11 80    	add    0x801126ac,%eax
{
801012ee:	89 e5                	mov    %esp,%ebp
801012f0:	56                   	push   %esi
801012f1:	53                   	push   %ebx
801012f2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801012f4:	83 ec 08             	sub    $0x8,%esp
801012f7:	50                   	push   %eax
801012f8:	51                   	push   %ecx
801012f9:	e8 d2 ed ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801012fe:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101300:	c1 fb 03             	sar    $0x3,%ebx
80101303:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101306:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101308:	83 e1 07             	and    $0x7,%ecx
8010130b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101310:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101316:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101318:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010131d:	85 c1                	test   %eax,%ecx
8010131f:	74 23                	je     80101344 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101321:	f7 d0                	not    %eax
  log_write(bp);
80101323:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101326:	21 c8                	and    %ecx,%eax
80101328:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010132c:	56                   	push   %esi
8010132d:	e8 1e 1d 00 00       	call   80103050 <log_write>
  brelse(bp);
80101332:	89 34 24             	mov    %esi,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	83 c4 10             	add    $0x10,%esp
8010133d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101340:	5b                   	pop    %ebx
80101341:	5e                   	pop    %esi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
    panic("freeing free block");
80101344:	83 ec 0c             	sub    $0xc,%esp
80101347:	68 bf 79 10 80       	push   $0x801079bf
8010134c:	e8 2f f0 ff ff       	call   80100380 <panic>
80101351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101358:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010135f:	90                   	nop

80101360 <balloc>:
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101369:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
{
8010136f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101372:	85 c9                	test   %ecx,%ecx
80101374:	0f 84 87 00 00 00    	je     80101401 <balloc+0xa1>
8010137a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101381:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101384:	83 ec 08             	sub    $0x8,%esp
80101387:	89 f0                	mov    %esi,%eax
80101389:	c1 f8 0c             	sar    $0xc,%eax
8010138c:	03 05 ac 26 11 80    	add    0x801126ac,%eax
80101392:	50                   	push   %eax
80101393:	ff 75 d8             	pushl  -0x28(%ebp)
80101396:	e8 35 ed ff ff       	call   801000d0 <bread>
8010139b:	83 c4 10             	add    $0x10,%esp
8010139e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013a1:	a1 94 26 11 80       	mov    0x80112694,%eax
801013a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801013a9:	31 c0                	xor    %eax,%eax
801013ab:	eb 2f                	jmp    801013dc <balloc+0x7c>
801013ad:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801013b0:	89 c1                	mov    %eax,%ecx
801013b2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801013ba:	83 e1 07             	and    $0x7,%ecx
801013bd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013bf:	89 c1                	mov    %eax,%ecx
801013c1:	c1 f9 03             	sar    $0x3,%ecx
801013c4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801013c9:	89 fa                	mov    %edi,%edx
801013cb:	85 df                	test   %ebx,%edi
801013cd:	74 41                	je     80101410 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013cf:	83 c0 01             	add    $0x1,%eax
801013d2:	83 c6 01             	add    $0x1,%esi
801013d5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801013da:	74 05                	je     801013e1 <balloc+0x81>
801013dc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801013df:	77 cf                	ja     801013b0 <balloc+0x50>
    brelse(bp);
801013e1:	83 ec 0c             	sub    $0xc,%esp
801013e4:	ff 75 e4             	pushl  -0x1c(%ebp)
801013e7:	e8 04 ee ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801013ec:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801013f3:	83 c4 10             	add    $0x10,%esp
801013f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801013f9:	39 05 94 26 11 80    	cmp    %eax,0x80112694
801013ff:	77 80                	ja     80101381 <balloc+0x21>
  panic("balloc: out of blocks");
80101401:	83 ec 0c             	sub    $0xc,%esp
80101404:	68 d2 79 10 80       	push   $0x801079d2
80101409:	e8 72 ef ff ff       	call   80100380 <panic>
8010140e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101410:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101413:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101416:	09 da                	or     %ebx,%edx
80101418:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010141c:	57                   	push   %edi
8010141d:	e8 2e 1c 00 00       	call   80103050 <log_write>
        brelse(bp);
80101422:	89 3c 24             	mov    %edi,(%esp)
80101425:	e8 c6 ed ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010142a:	58                   	pop    %eax
8010142b:	5a                   	pop    %edx
8010142c:	56                   	push   %esi
8010142d:	ff 75 d8             	pushl  -0x28(%ebp)
80101430:	e8 9b ec ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101435:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101438:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010143a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010143d:	68 00 02 00 00       	push   $0x200
80101442:	6a 00                	push   $0x0
80101444:	50                   	push   %eax
80101445:	e8 86 35 00 00       	call   801049d0 <memset>
  log_write(bp);
8010144a:	89 1c 24             	mov    %ebx,(%esp)
8010144d:	e8 fe 1b 00 00       	call   80103050 <log_write>
  brelse(bp);
80101452:	89 1c 24             	mov    %ebx,(%esp)
80101455:	e8 96 ed ff ff       	call   801001f0 <brelse>
}
8010145a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010145d:	89 f0                	mov    %esi,%eax
8010145f:	5b                   	pop    %ebx
80101460:	5e                   	pop    %esi
80101461:	5f                   	pop    %edi
80101462:	5d                   	pop    %ebp
80101463:	c3                   	ret    
80101464:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010146b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010146f:	90                   	nop

80101470 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	57                   	push   %edi
80101474:	89 c7                	mov    %eax,%edi
80101476:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101477:	31 f6                	xor    %esi,%esi
{
80101479:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010147a:	bb 74 0a 11 80       	mov    $0x80110a74,%ebx
{
8010147f:	83 ec 28             	sub    $0x28,%esp
80101482:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101485:	68 40 0a 11 80       	push   $0x80110a40
8010148a:	e8 81 34 00 00       	call   80104910 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010148f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101492:	83 c4 10             	add    $0x10,%esp
80101495:	eb 1b                	jmp    801014b2 <iget+0x42>
80101497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010149e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014a0:	39 3b                	cmp    %edi,(%ebx)
801014a2:	74 6c                	je     80101510 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014a4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014aa:	81 fb 94 26 11 80    	cmp    $0x80112694,%ebx
801014b0:	73 26                	jae    801014d8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014b2:	8b 43 08             	mov    0x8(%ebx),%eax
801014b5:	85 c0                	test   %eax,%eax
801014b7:	7f e7                	jg     801014a0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801014b9:	85 f6                	test   %esi,%esi
801014bb:	75 e7                	jne    801014a4 <iget+0x34>
801014bd:	89 d9                	mov    %ebx,%ecx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014bf:	81 c3 90 00 00 00    	add    $0x90,%ebx
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801014c5:	85 c0                	test   %eax,%eax
801014c7:	75 6e                	jne    80101537 <iget+0xc7>
801014c9:	89 ce                	mov    %ecx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014cb:	81 fb 94 26 11 80    	cmp    $0x80112694,%ebx
801014d1:	72 df                	jb     801014b2 <iget+0x42>
801014d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014d7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801014d8:	85 f6                	test   %esi,%esi
801014da:	74 73                	je     8010154f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801014dc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801014df:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801014e1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801014e4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801014eb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801014f2:	68 40 0a 11 80       	push   $0x80110a40
801014f7:	e8 b4 33 00 00       	call   801048b0 <release>

  return ip;
801014fc:	83 c4 10             	add    $0x10,%esp
}
801014ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101502:	89 f0                	mov    %esi,%eax
80101504:	5b                   	pop    %ebx
80101505:	5e                   	pop    %esi
80101506:	5f                   	pop    %edi
80101507:	5d                   	pop    %ebp
80101508:	c3                   	ret    
80101509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101510:	39 53 04             	cmp    %edx,0x4(%ebx)
80101513:	75 8f                	jne    801014a4 <iget+0x34>
      release(&icache.lock);
80101515:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101518:	83 c0 01             	add    $0x1,%eax
      return ip;
8010151b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010151d:	68 40 0a 11 80       	push   $0x80110a40
      ip->ref++;
80101522:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101525:	e8 86 33 00 00       	call   801048b0 <release>
      return ip;
8010152a:	83 c4 10             	add    $0x10,%esp
}
8010152d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101530:	89 f0                	mov    %esi,%eax
80101532:	5b                   	pop    %ebx
80101533:	5e                   	pop    %esi
80101534:	5f                   	pop    %edi
80101535:	5d                   	pop    %ebp
80101536:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101537:	81 fb 94 26 11 80    	cmp    $0x80112694,%ebx
8010153d:	73 10                	jae    8010154f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010153f:	8b 43 08             	mov    0x8(%ebx),%eax
80101542:	85 c0                	test   %eax,%eax
80101544:	0f 8f 56 ff ff ff    	jg     801014a0 <iget+0x30>
8010154a:	e9 6e ff ff ff       	jmp    801014bd <iget+0x4d>
    panic("iget: no inodes");
8010154f:	83 ec 0c             	sub    $0xc,%esp
80101552:	68 e8 79 10 80       	push   $0x801079e8
80101557:	e8 24 ee ff ff       	call   80100380 <panic>
8010155c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101560 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	57                   	push   %edi
80101564:	56                   	push   %esi
80101565:	89 c6                	mov    %eax,%esi
80101567:	53                   	push   %ebx
80101568:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010156b:	83 fa 0b             	cmp    $0xb,%edx
8010156e:	0f 86 8c 00 00 00    	jbe    80101600 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101574:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101577:	83 fb 7f             	cmp    $0x7f,%ebx
8010157a:	0f 87 a2 00 00 00    	ja     80101622 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101580:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
      ip->addrs[bn] = addr = balloc(ip->dev);
80101586:	8b 16                	mov    (%esi),%edx
    if((addr = ip->addrs[NDIRECT]) == 0)
80101588:	85 c0                	test   %eax,%eax
8010158a:	74 5c                	je     801015e8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010158c:	83 ec 08             	sub    $0x8,%esp
8010158f:	50                   	push   %eax
80101590:	52                   	push   %edx
80101591:	e8 3a eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101596:	83 c4 10             	add    $0x10,%esp
80101599:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010159d:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010159f:	8b 3b                	mov    (%ebx),%edi
801015a1:	85 ff                	test   %edi,%edi
801015a3:	74 1b                	je     801015c0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801015a5:	83 ec 0c             	sub    $0xc,%esp
801015a8:	52                   	push   %edx
801015a9:	e8 42 ec ff ff       	call   801001f0 <brelse>
801015ae:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801015b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015b4:	89 f8                	mov    %edi,%eax
801015b6:	5b                   	pop    %ebx
801015b7:	5e                   	pop    %esi
801015b8:	5f                   	pop    %edi
801015b9:	5d                   	pop    %ebp
801015ba:	c3                   	ret    
801015bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015bf:	90                   	nop
801015c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801015c3:	8b 06                	mov    (%esi),%eax
801015c5:	e8 96 fd ff ff       	call   80101360 <balloc>
      log_write(bp);
801015ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015cd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801015d0:	89 03                	mov    %eax,(%ebx)
801015d2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801015d4:	52                   	push   %edx
801015d5:	e8 76 1a 00 00       	call   80103050 <log_write>
801015da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015dd:	83 c4 10             	add    $0x10,%esp
801015e0:	eb c3                	jmp    801015a5 <bmap+0x45>
801015e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801015e8:	89 d0                	mov    %edx,%eax
801015ea:	e8 71 fd ff ff       	call   80101360 <balloc>
    bp = bread(ip->dev, addr);
801015ef:	8b 16                	mov    (%esi),%edx
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801015f1:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801015f7:	eb 93                	jmp    8010158c <bmap+0x2c>
801015f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101600:	8d 5a 14             	lea    0x14(%edx),%ebx
80101603:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101607:	85 ff                	test   %edi,%edi
80101609:	75 a6                	jne    801015b1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010160b:	8b 00                	mov    (%eax),%eax
8010160d:	e8 4e fd ff ff       	call   80101360 <balloc>
80101612:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101616:	89 c7                	mov    %eax,%edi
}
80101618:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010161b:	5b                   	pop    %ebx
8010161c:	89 f8                	mov    %edi,%eax
8010161e:	5e                   	pop    %esi
8010161f:	5f                   	pop    %edi
80101620:	5d                   	pop    %ebp
80101621:	c3                   	ret    
  panic("bmap: out of range");
80101622:	83 ec 0c             	sub    $0xc,%esp
80101625:	68 f8 79 10 80       	push   $0x801079f8
8010162a:	e8 51 ed ff ff       	call   80100380 <panic>
8010162f:	90                   	nop

80101630 <readsb>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	56                   	push   %esi
80101634:	53                   	push   %ebx
80101635:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101638:	83 ec 08             	sub    $0x8,%esp
8010163b:	6a 01                	push   $0x1
8010163d:	ff 75 08             	pushl  0x8(%ebp)
80101640:	e8 8b ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101645:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101648:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010164a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010164d:	6a 1c                	push   $0x1c
8010164f:	50                   	push   %eax
80101650:	56                   	push   %esi
80101651:	e8 1a 34 00 00       	call   80104a70 <memmove>
  brelse(bp);
80101656:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101659:	83 c4 10             	add    $0x10,%esp
}
8010165c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010165f:	5b                   	pop    %ebx
80101660:	5e                   	pop    %esi
80101661:	5d                   	pop    %ebp
  brelse(bp);
80101662:	e9 89 eb ff ff       	jmp    801001f0 <brelse>
80101667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010166e:	66 90                	xchg   %ax,%ax

80101670 <iinit>:
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	53                   	push   %ebx
80101674:	bb 80 0a 11 80       	mov    $0x80110a80,%ebx
80101679:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010167c:	68 0b 7a 10 80       	push   $0x80107a0b
80101681:	68 40 0a 11 80       	push   $0x80110a40
80101686:	e8 b5 30 00 00       	call   80104740 <initlock>
  for(i = 0; i < NINODE; i++) {
8010168b:	83 c4 10             	add    $0x10,%esp
8010168e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101690:	83 ec 08             	sub    $0x8,%esp
80101693:	68 12 7a 10 80       	push   $0x80107a12
80101698:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101699:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010169f:	e8 6c 2f 00 00       	call   80104610 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801016a4:	83 c4 10             	add    $0x10,%esp
801016a7:	81 fb a0 26 11 80    	cmp    $0x801126a0,%ebx
801016ad:	75 e1                	jne    80101690 <iinit+0x20>
  bp = bread(dev, 1);
801016af:	83 ec 08             	sub    $0x8,%esp
801016b2:	6a 01                	push   $0x1
801016b4:	ff 75 08             	pushl  0x8(%ebp)
801016b7:	e8 14 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801016bc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801016bf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801016c1:	8d 40 5c             	lea    0x5c(%eax),%eax
801016c4:	6a 1c                	push   $0x1c
801016c6:	50                   	push   %eax
801016c7:	68 94 26 11 80       	push   $0x80112694
801016cc:	e8 9f 33 00 00       	call   80104a70 <memmove>
  brelse(bp);
801016d1:	89 1c 24             	mov    %ebx,(%esp)
801016d4:	e8 17 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801016d9:	ff 35 ac 26 11 80    	pushl  0x801126ac
801016df:	ff 35 a8 26 11 80    	pushl  0x801126a8
801016e5:	ff 35 a4 26 11 80    	pushl  0x801126a4
801016eb:	ff 35 a0 26 11 80    	pushl  0x801126a0
801016f1:	ff 35 9c 26 11 80    	pushl  0x8011269c
801016f7:	ff 35 98 26 11 80    	pushl  0x80112698
801016fd:	ff 35 94 26 11 80    	pushl  0x80112694
80101703:	68 78 7a 10 80       	push   $0x80107a78
80101708:	e8 73 ef ff ff       	call   80100680 <cprintf>
}
8010170d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101710:	83 c4 30             	add    $0x30,%esp
80101713:	c9                   	leave  
80101714:	c3                   	ret    
80101715:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010171c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101720 <ialloc>:
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	57                   	push   %edi
80101724:	56                   	push   %esi
80101725:	53                   	push   %ebx
80101726:	83 ec 1c             	sub    $0x1c,%esp
80101729:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010172c:	83 3d 9c 26 11 80 01 	cmpl   $0x1,0x8011269c
{
80101733:	8b 75 08             	mov    0x8(%ebp),%esi
80101736:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101739:	0f 86 91 00 00 00    	jbe    801017d0 <ialloc+0xb0>
8010173f:	bf 01 00 00 00       	mov    $0x1,%edi
80101744:	eb 21                	jmp    80101767 <ialloc+0x47>
80101746:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010174d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101750:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101753:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101756:	53                   	push   %ebx
80101757:	e8 94 ea ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010175c:	83 c4 10             	add    $0x10,%esp
8010175f:	3b 3d 9c 26 11 80    	cmp    0x8011269c,%edi
80101765:	73 69                	jae    801017d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101767:	89 f8                	mov    %edi,%eax
80101769:	83 ec 08             	sub    $0x8,%esp
8010176c:	c1 e8 03             	shr    $0x3,%eax
8010176f:	03 05 a8 26 11 80    	add    0x801126a8,%eax
80101775:	50                   	push   %eax
80101776:	56                   	push   %esi
80101777:	e8 54 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010177c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010177f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101781:	89 f8                	mov    %edi,%eax
80101783:	83 e0 07             	and    $0x7,%eax
80101786:	c1 e0 06             	shl    $0x6,%eax
80101789:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010178d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101791:	75 bd                	jne    80101750 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101793:	83 ec 04             	sub    $0x4,%esp
80101796:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101799:	6a 40                	push   $0x40
8010179b:	6a 00                	push   $0x0
8010179d:	51                   	push   %ecx
8010179e:	e8 2d 32 00 00       	call   801049d0 <memset>
      dip->type = type;
801017a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801017a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801017aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801017ad:	89 1c 24             	mov    %ebx,(%esp)
801017b0:	e8 9b 18 00 00       	call   80103050 <log_write>
      brelse(bp);
801017b5:	89 1c 24             	mov    %ebx,(%esp)
801017b8:	e8 33 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801017bd:	83 c4 10             	add    $0x10,%esp
}
801017c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801017c3:	89 fa                	mov    %edi,%edx
}
801017c5:	5b                   	pop    %ebx
      return iget(dev, inum);
801017c6:	89 f0                	mov    %esi,%eax
}
801017c8:	5e                   	pop    %esi
801017c9:	5f                   	pop    %edi
801017ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801017cb:	e9 a0 fc ff ff       	jmp    80101470 <iget>
  panic("ialloc: no inodes");
801017d0:	83 ec 0c             	sub    $0xc,%esp
801017d3:	68 18 7a 10 80       	push   $0x80107a18
801017d8:	e8 a3 eb ff ff       	call   80100380 <panic>
801017dd:	8d 76 00             	lea    0x0(%esi),%esi

801017e0 <iupdate>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	56                   	push   %esi
801017e4:	53                   	push   %ebx
801017e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017e8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017eb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ee:	83 ec 08             	sub    $0x8,%esp
801017f1:	c1 e8 03             	shr    $0x3,%eax
801017f4:	03 05 a8 26 11 80    	add    0x801126a8,%eax
801017fa:	50                   	push   %eax
801017fb:	ff 73 a4             	pushl  -0x5c(%ebx)
801017fe:	e8 cd e8 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101803:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101807:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010180a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010180c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010180f:	83 e0 07             	and    $0x7,%eax
80101812:	c1 e0 06             	shl    $0x6,%eax
80101815:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101819:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010181c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101820:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101823:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101827:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010182b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010182f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101833:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101837:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010183a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010183d:	6a 34                	push   $0x34
8010183f:	53                   	push   %ebx
80101840:	50                   	push   %eax
80101841:	e8 2a 32 00 00       	call   80104a70 <memmove>
  log_write(bp);
80101846:	89 34 24             	mov    %esi,(%esp)
80101849:	e8 02 18 00 00       	call   80103050 <log_write>
  brelse(bp);
8010184e:	89 75 08             	mov    %esi,0x8(%ebp)
80101851:	83 c4 10             	add    $0x10,%esp
}
80101854:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101857:	5b                   	pop    %ebx
80101858:	5e                   	pop    %esi
80101859:	5d                   	pop    %ebp
  brelse(bp);
8010185a:	e9 91 e9 ff ff       	jmp    801001f0 <brelse>
8010185f:	90                   	nop

80101860 <idup>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	53                   	push   %ebx
80101864:	83 ec 10             	sub    $0x10,%esp
80101867:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010186a:	68 40 0a 11 80       	push   $0x80110a40
8010186f:	e8 9c 30 00 00       	call   80104910 <acquire>
  ip->ref++;
80101874:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101878:	c7 04 24 40 0a 11 80 	movl   $0x80110a40,(%esp)
8010187f:	e8 2c 30 00 00       	call   801048b0 <release>
}
80101884:	89 d8                	mov    %ebx,%eax
80101886:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101889:	c9                   	leave  
8010188a:	c3                   	ret    
8010188b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010188f:	90                   	nop

80101890 <ilock>:
{
80101890:	55                   	push   %ebp
80101891:	89 e5                	mov    %esp,%ebp
80101893:	56                   	push   %esi
80101894:	53                   	push   %ebx
80101895:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101898:	85 db                	test   %ebx,%ebx
8010189a:	0f 84 b7 00 00 00    	je     80101957 <ilock+0xc7>
801018a0:	8b 53 08             	mov    0x8(%ebx),%edx
801018a3:	85 d2                	test   %edx,%edx
801018a5:	0f 8e ac 00 00 00    	jle    80101957 <ilock+0xc7>
  acquiresleep(&ip->lock);
801018ab:	83 ec 0c             	sub    $0xc,%esp
801018ae:	8d 43 0c             	lea    0xc(%ebx),%eax
801018b1:	50                   	push   %eax
801018b2:	e8 99 2d 00 00       	call   80104650 <acquiresleep>
  if(ip->valid == 0){
801018b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801018ba:	83 c4 10             	add    $0x10,%esp
801018bd:	85 c0                	test   %eax,%eax
801018bf:	74 0f                	je     801018d0 <ilock+0x40>
}
801018c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018c4:	5b                   	pop    %ebx
801018c5:	5e                   	pop    %esi
801018c6:	5d                   	pop    %ebp
801018c7:	c3                   	ret    
801018c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018cf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018d0:	8b 43 04             	mov    0x4(%ebx),%eax
801018d3:	83 ec 08             	sub    $0x8,%esp
801018d6:	c1 e8 03             	shr    $0x3,%eax
801018d9:	03 05 a8 26 11 80    	add    0x801126a8,%eax
801018df:	50                   	push   %eax
801018e0:	ff 33                	pushl  (%ebx)
801018e2:	e8 e9 e7 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018e7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018ea:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801018ec:	8b 43 04             	mov    0x4(%ebx),%eax
801018ef:	83 e0 07             	and    $0x7,%eax
801018f2:	c1 e0 06             	shl    $0x6,%eax
801018f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801018f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801018ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101903:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101907:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010190b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010190f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101913:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101917:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010191b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010191e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101921:	6a 34                	push   $0x34
80101923:	50                   	push   %eax
80101924:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101927:	50                   	push   %eax
80101928:	e8 43 31 00 00       	call   80104a70 <memmove>
    brelse(bp);
8010192d:	89 34 24             	mov    %esi,(%esp)
80101930:	e8 bb e8 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101935:	83 c4 10             	add    $0x10,%esp
80101938:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010193d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101944:	0f 85 77 ff ff ff    	jne    801018c1 <ilock+0x31>
      panic("ilock: no type");
8010194a:	83 ec 0c             	sub    $0xc,%esp
8010194d:	68 30 7a 10 80       	push   $0x80107a30
80101952:	e8 29 ea ff ff       	call   80100380 <panic>
    panic("ilock");
80101957:	83 ec 0c             	sub    $0xc,%esp
8010195a:	68 2a 7a 10 80       	push   $0x80107a2a
8010195f:	e8 1c ea ff ff       	call   80100380 <panic>
80101964:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010196b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010196f:	90                   	nop

80101970 <iunlock>:
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	56                   	push   %esi
80101974:	53                   	push   %ebx
80101975:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101978:	85 db                	test   %ebx,%ebx
8010197a:	74 28                	je     801019a4 <iunlock+0x34>
8010197c:	83 ec 0c             	sub    $0xc,%esp
8010197f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101982:	56                   	push   %esi
80101983:	e8 68 2d 00 00       	call   801046f0 <holdingsleep>
80101988:	83 c4 10             	add    $0x10,%esp
8010198b:	85 c0                	test   %eax,%eax
8010198d:	74 15                	je     801019a4 <iunlock+0x34>
8010198f:	8b 43 08             	mov    0x8(%ebx),%eax
80101992:	85 c0                	test   %eax,%eax
80101994:	7e 0e                	jle    801019a4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101996:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101999:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010199c:	5b                   	pop    %ebx
8010199d:	5e                   	pop    %esi
8010199e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010199f:	e9 0c 2d 00 00       	jmp    801046b0 <releasesleep>
    panic("iunlock");
801019a4:	83 ec 0c             	sub    $0xc,%esp
801019a7:	68 3f 7a 10 80       	push   $0x80107a3f
801019ac:	e8 cf e9 ff ff       	call   80100380 <panic>
801019b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop

801019c0 <iput>:
{
801019c0:	55                   	push   %ebp
801019c1:	89 e5                	mov    %esp,%ebp
801019c3:	57                   	push   %edi
801019c4:	56                   	push   %esi
801019c5:	53                   	push   %ebx
801019c6:	83 ec 28             	sub    $0x28,%esp
801019c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801019cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801019cf:	57                   	push   %edi
801019d0:	e8 7b 2c 00 00       	call   80104650 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801019d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801019d8:	83 c4 10             	add    $0x10,%esp
801019db:	85 d2                	test   %edx,%edx
801019dd:	74 07                	je     801019e6 <iput+0x26>
801019df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801019e4:	74 32                	je     80101a18 <iput+0x58>
  releasesleep(&ip->lock);
801019e6:	83 ec 0c             	sub    $0xc,%esp
801019e9:	57                   	push   %edi
801019ea:	e8 c1 2c 00 00       	call   801046b0 <releasesleep>
  acquire(&icache.lock);
801019ef:	c7 04 24 40 0a 11 80 	movl   $0x80110a40,(%esp)
801019f6:	e8 15 2f 00 00       	call   80104910 <acquire>
  ip->ref--;
801019fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801019ff:	83 c4 10             	add    $0x10,%esp
80101a02:	c7 45 08 40 0a 11 80 	movl   $0x80110a40,0x8(%ebp)
}
80101a09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a0c:	5b                   	pop    %ebx
80101a0d:	5e                   	pop    %esi
80101a0e:	5f                   	pop    %edi
80101a0f:	5d                   	pop    %ebp
  release(&icache.lock);
80101a10:	e9 9b 2e 00 00       	jmp    801048b0 <release>
80101a15:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101a18:	83 ec 0c             	sub    $0xc,%esp
80101a1b:	68 40 0a 11 80       	push   $0x80110a40
80101a20:	e8 eb 2e 00 00       	call   80104910 <acquire>
    int r = ip->ref;
80101a25:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101a28:	c7 04 24 40 0a 11 80 	movl   $0x80110a40,(%esp)
80101a2f:	e8 7c 2e 00 00       	call   801048b0 <release>
    if(r == 1){
80101a34:	83 c4 10             	add    $0x10,%esp
80101a37:	83 fe 01             	cmp    $0x1,%esi
80101a3a:	75 aa                	jne    801019e6 <iput+0x26>
80101a3c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101a42:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a45:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101a48:	89 cf                	mov    %ecx,%edi
80101a4a:	eb 0b                	jmp    80101a57 <iput+0x97>
80101a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101a50:	83 c6 04             	add    $0x4,%esi
80101a53:	39 fe                	cmp    %edi,%esi
80101a55:	74 19                	je     80101a70 <iput+0xb0>
    if(ip->addrs[i]){
80101a57:	8b 16                	mov    (%esi),%edx
80101a59:	85 d2                	test   %edx,%edx
80101a5b:	74 f3                	je     80101a50 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101a5d:	8b 03                	mov    (%ebx),%eax
80101a5f:	e8 7c f8 ff ff       	call   801012e0 <bfree>
      ip->addrs[i] = 0;
80101a64:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101a6a:	eb e4                	jmp    80101a50 <iput+0x90>
80101a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101a70:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101a76:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a79:	85 c0                	test   %eax,%eax
80101a7b:	75 2d                	jne    80101aaa <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101a7d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101a80:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101a87:	53                   	push   %ebx
80101a88:	e8 53 fd ff ff       	call   801017e0 <iupdate>
      ip->type = 0;
80101a8d:	31 c0                	xor    %eax,%eax
80101a8f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101a93:	89 1c 24             	mov    %ebx,(%esp)
80101a96:	e8 45 fd ff ff       	call   801017e0 <iupdate>
      ip->valid = 0;
80101a9b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101aa2:	83 c4 10             	add    $0x10,%esp
80101aa5:	e9 3c ff ff ff       	jmp    801019e6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101aaa:	83 ec 08             	sub    $0x8,%esp
80101aad:	50                   	push   %eax
80101aae:	ff 33                	pushl  (%ebx)
80101ab0:	e8 1b e6 ff ff       	call   801000d0 <bread>
80101ab5:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ab8:	83 c4 10             	add    $0x10,%esp
80101abb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101ac1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101ac4:	8d 70 5c             	lea    0x5c(%eax),%esi
80101ac7:	89 cf                	mov    %ecx,%edi
80101ac9:	eb 0c                	jmp    80101ad7 <iput+0x117>
80101acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101acf:	90                   	nop
80101ad0:	83 c6 04             	add    $0x4,%esi
80101ad3:	39 f7                	cmp    %esi,%edi
80101ad5:	74 0f                	je     80101ae6 <iput+0x126>
      if(a[j])
80101ad7:	8b 16                	mov    (%esi),%edx
80101ad9:	85 d2                	test   %edx,%edx
80101adb:	74 f3                	je     80101ad0 <iput+0x110>
        bfree(ip->dev, a[j]);
80101add:	8b 03                	mov    (%ebx),%eax
80101adf:	e8 fc f7 ff ff       	call   801012e0 <bfree>
80101ae4:	eb ea                	jmp    80101ad0 <iput+0x110>
    brelse(bp);
80101ae6:	83 ec 0c             	sub    $0xc,%esp
80101ae9:	ff 75 e4             	pushl  -0x1c(%ebp)
80101aec:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101aef:	e8 fc e6 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101af4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101afa:	8b 03                	mov    (%ebx),%eax
80101afc:	e8 df f7 ff ff       	call   801012e0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101b01:	83 c4 10             	add    $0x10,%esp
80101b04:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101b0b:	00 00 00 
80101b0e:	e9 6a ff ff ff       	jmp    80101a7d <iput+0xbd>
80101b13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101b20 <iunlockput>:
{
80101b20:	55                   	push   %ebp
80101b21:	89 e5                	mov    %esp,%ebp
80101b23:	56                   	push   %esi
80101b24:	53                   	push   %ebx
80101b25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b28:	85 db                	test   %ebx,%ebx
80101b2a:	74 34                	je     80101b60 <iunlockput+0x40>
80101b2c:	83 ec 0c             	sub    $0xc,%esp
80101b2f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101b32:	56                   	push   %esi
80101b33:	e8 b8 2b 00 00       	call   801046f0 <holdingsleep>
80101b38:	83 c4 10             	add    $0x10,%esp
80101b3b:	85 c0                	test   %eax,%eax
80101b3d:	74 21                	je     80101b60 <iunlockput+0x40>
80101b3f:	8b 43 08             	mov    0x8(%ebx),%eax
80101b42:	85 c0                	test   %eax,%eax
80101b44:	7e 1a                	jle    80101b60 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101b46:	83 ec 0c             	sub    $0xc,%esp
80101b49:	56                   	push   %esi
80101b4a:	e8 61 2b 00 00       	call   801046b0 <releasesleep>
  iput(ip);
80101b4f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101b52:	83 c4 10             	add    $0x10,%esp
}
80101b55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5d                   	pop    %ebp
  iput(ip);
80101b5b:	e9 60 fe ff ff       	jmp    801019c0 <iput>
    panic("iunlock");
80101b60:	83 ec 0c             	sub    $0xc,%esp
80101b63:	68 3f 7a 10 80       	push   $0x80107a3f
80101b68:	e8 13 e8 ff ff       	call   80100380 <panic>
80101b6d:	8d 76 00             	lea    0x0(%esi),%esi

80101b70 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	8b 55 08             	mov    0x8(%ebp),%edx
80101b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101b79:	8b 0a                	mov    (%edx),%ecx
80101b7b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101b7e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101b81:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101b84:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101b88:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101b8b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101b8f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b93:	8b 52 58             	mov    0x58(%edx),%edx
80101b96:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b99:	5d                   	pop    %ebp
80101b9a:	c3                   	ret    
80101b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b9f:	90                   	nop

80101ba0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 1c             	sub    $0x1c,%esp
80101ba9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101bac:	8b 45 08             	mov    0x8(%ebp),%eax
80101baf:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101bb5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bb8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bbd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bc0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101bc3:	0f 84 a7 00 00 00    	je     80101c70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101bc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bcc:	8b 40 58             	mov    0x58(%eax),%eax
80101bcf:	39 c6                	cmp    %eax,%esi
80101bd1:	0f 87 ba 00 00 00    	ja     80101c91 <readi+0xf1>
80101bd7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101bda:	31 c9                	xor    %ecx,%ecx
80101bdc:	89 da                	mov    %ebx,%edx
80101bde:	01 f2                	add    %esi,%edx
80101be0:	0f 92 c1             	setb   %cl
80101be3:	89 cf                	mov    %ecx,%edi
80101be5:	0f 82 a6 00 00 00    	jb     80101c91 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101beb:	89 c1                	mov    %eax,%ecx
80101bed:	29 f1                	sub    %esi,%ecx
80101bef:	39 d0                	cmp    %edx,%eax
80101bf1:	0f 43 cb             	cmovae %ebx,%ecx
80101bf4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bf7:	85 c9                	test   %ecx,%ecx
80101bf9:	74 67                	je     80101c62 <readi+0xc2>
80101bfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101c03:	89 f2                	mov    %esi,%edx
80101c05:	c1 ea 09             	shr    $0x9,%edx
80101c08:	89 d8                	mov    %ebx,%eax
80101c0a:	e8 51 f9 ff ff       	call   80101560 <bmap>
80101c0f:	83 ec 08             	sub    $0x8,%esp
80101c12:	50                   	push   %eax
80101c13:	ff 33                	pushl  (%ebx)
80101c15:	e8 b6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c1a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101c1d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c22:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c25:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c27:	89 f0                	mov    %esi,%eax
80101c29:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c2e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c30:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101c33:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101c35:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c39:	39 d9                	cmp    %ebx,%ecx
80101c3b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c3e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c3f:	01 df                	add    %ebx,%edi
80101c41:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101c43:	50                   	push   %eax
80101c44:	ff 75 e0             	pushl  -0x20(%ebp)
80101c47:	e8 24 2e 00 00       	call   80104a70 <memmove>
    brelse(bp);
80101c4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101c4f:	89 14 24             	mov    %edx,(%esp)
80101c52:	e8 99 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c57:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101c5a:	83 c4 10             	add    $0x10,%esp
80101c5d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101c60:	77 9e                	ja     80101c00 <readi+0x60>
  }
  return n;
80101c62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101c65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c68:	5b                   	pop    %ebx
80101c69:	5e                   	pop    %esi
80101c6a:	5f                   	pop    %edi
80101c6b:	5d                   	pop    %ebp
80101c6c:	c3                   	ret    
80101c6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 17                	ja     80101c91 <readi+0xf1>
80101c7a:	8b 04 c5 e0 09 11 80 	mov    -0x7feef620(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 0c                	je     80101c91 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101c85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101c8f:	ff e0                	jmp    *%eax
      return -1;
80101c91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c96:	eb cd                	jmp    80101c65 <readi+0xc5>
80101c98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c9f:	90                   	nop

80101ca0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ca0:	55                   	push   %ebp
80101ca1:	89 e5                	mov    %esp,%ebp
80101ca3:	57                   	push   %edi
80101ca4:	56                   	push   %esi
80101ca5:	53                   	push   %ebx
80101ca6:	83 ec 1c             	sub    $0x1c,%esp
80101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cac:	8b 75 0c             	mov    0xc(%ebp),%esi
80101caf:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101cb2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101cb7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101cba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101cbd:	8b 75 10             	mov    0x10(%ebp),%esi
80101cc0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101cc3:	0f 84 b7 00 00 00    	je     80101d80 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101cc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ccc:	3b 70 58             	cmp    0x58(%eax),%esi
80101ccf:	0f 87 e7 00 00 00    	ja     80101dbc <writei+0x11c>
80101cd5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101cd8:	31 d2                	xor    %edx,%edx
80101cda:	89 f8                	mov    %edi,%eax
80101cdc:	01 f0                	add    %esi,%eax
80101cde:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ce1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ce6:	0f 87 d0 00 00 00    	ja     80101dbc <writei+0x11c>
80101cec:	85 d2                	test   %edx,%edx
80101cee:	0f 85 c8 00 00 00    	jne    80101dbc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cf4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101cfb:	85 ff                	test   %edi,%edi
80101cfd:	74 72                	je     80101d71 <writei+0xd1>
80101cff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d00:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101d03:	89 f2                	mov    %esi,%edx
80101d05:	c1 ea 09             	shr    $0x9,%edx
80101d08:	89 f8                	mov    %edi,%eax
80101d0a:	e8 51 f8 ff ff       	call   80101560 <bmap>
80101d0f:	83 ec 08             	sub    $0x8,%esp
80101d12:	50                   	push   %eax
80101d13:	ff 37                	pushl  (%edi)
80101d15:	e8 b6 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d1a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101d1f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101d22:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d25:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101d27:	89 f0                	mov    %esi,%eax
80101d29:	83 c4 0c             	add    $0xc,%esp
80101d2c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d31:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101d33:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101d37:	39 d9                	cmp    %ebx,%ecx
80101d39:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101d3c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d3d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101d3f:	ff 75 dc             	pushl  -0x24(%ebp)
80101d42:	50                   	push   %eax
80101d43:	e8 28 2d 00 00       	call   80104a70 <memmove>
    log_write(bp);
80101d48:	89 3c 24             	mov    %edi,(%esp)
80101d4b:	e8 00 13 00 00       	call   80103050 <log_write>
    brelse(bp);
80101d50:	89 3c 24             	mov    %edi,(%esp)
80101d53:	e8 98 e4 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d58:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101d5b:	83 c4 10             	add    $0x10,%esp
80101d5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d61:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101d64:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101d67:	77 97                	ja     80101d00 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101d69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d6c:	3b 70 58             	cmp    0x58(%eax),%esi
80101d6f:	77 37                	ja     80101da8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d71:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101d74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d77:	5b                   	pop    %ebx
80101d78:	5e                   	pop    %esi
80101d79:	5f                   	pop    %edi
80101d7a:	5d                   	pop    %ebp
80101d7b:	c3                   	ret    
80101d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101d80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d84:	66 83 f8 09          	cmp    $0x9,%ax
80101d88:	77 32                	ja     80101dbc <writei+0x11c>
80101d8a:	8b 04 c5 e4 09 11 80 	mov    -0x7feef61c(,%eax,8),%eax
80101d91:	85 c0                	test   %eax,%eax
80101d93:	74 27                	je     80101dbc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101d95:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101d98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d9b:	5b                   	pop    %ebx
80101d9c:	5e                   	pop    %esi
80101d9d:	5f                   	pop    %edi
80101d9e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d9f:	ff e0                	jmp    *%eax
80101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101da8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101dab:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101dae:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101db1:	50                   	push   %eax
80101db2:	e8 29 fa ff ff       	call   801017e0 <iupdate>
80101db7:	83 c4 10             	add    $0x10,%esp
80101dba:	eb b5                	jmp    80101d71 <writei+0xd1>
      return -1;
80101dbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dc1:	eb b1                	jmp    80101d74 <writei+0xd4>
80101dc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101dd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101dd0:	55                   	push   %ebp
80101dd1:	89 e5                	mov    %esp,%ebp
80101dd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101dd6:	6a 0e                	push   $0xe
80101dd8:	ff 75 0c             	pushl  0xc(%ebp)
80101ddb:	ff 75 08             	pushl  0x8(%ebp)
80101dde:	e8 fd 2c 00 00       	call   80104ae0 <strncmp>
}
80101de3:	c9                   	leave  
80101de4:	c3                   	ret    
80101de5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101df0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	56                   	push   %esi
80101df5:	53                   	push   %ebx
80101df6:	83 ec 1c             	sub    $0x1c,%esp
80101df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101dfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101e01:	0f 85 85 00 00 00    	jne    80101e8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101e07:	8b 53 58             	mov    0x58(%ebx),%edx
80101e0a:	31 ff                	xor    %edi,%edi
80101e0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e0f:	85 d2                	test   %edx,%edx
80101e11:	74 3e                	je     80101e51 <dirlookup+0x61>
80101e13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e17:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e18:	6a 10                	push   $0x10
80101e1a:	57                   	push   %edi
80101e1b:	56                   	push   %esi
80101e1c:	53                   	push   %ebx
80101e1d:	e8 7e fd ff ff       	call   80101ba0 <readi>
80101e22:	83 c4 10             	add    $0x10,%esp
80101e25:	83 f8 10             	cmp    $0x10,%eax
80101e28:	75 55                	jne    80101e7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101e2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e2f:	74 18                	je     80101e49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101e31:	83 ec 04             	sub    $0x4,%esp
80101e34:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e37:	6a 0e                	push   $0xe
80101e39:	50                   	push   %eax
80101e3a:	ff 75 0c             	pushl  0xc(%ebp)
80101e3d:	e8 9e 2c 00 00       	call   80104ae0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101e42:	83 c4 10             	add    $0x10,%esp
80101e45:	85 c0                	test   %eax,%eax
80101e47:	74 17                	je     80101e60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e49:	83 c7 10             	add    $0x10,%edi
80101e4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e4f:	72 c7                	jb     80101e18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101e51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101e54:	31 c0                	xor    %eax,%eax
}
80101e56:	5b                   	pop    %ebx
80101e57:	5e                   	pop    %esi
80101e58:	5f                   	pop    %edi
80101e59:	5d                   	pop    %ebp
80101e5a:	c3                   	ret    
80101e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e5f:	90                   	nop
      if(poff)
80101e60:	8b 45 10             	mov    0x10(%ebp),%eax
80101e63:	85 c0                	test   %eax,%eax
80101e65:	74 05                	je     80101e6c <dirlookup+0x7c>
        *poff = off;
80101e67:	8b 45 10             	mov    0x10(%ebp),%eax
80101e6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101e6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101e70:	8b 03                	mov    (%ebx),%eax
80101e72:	e8 f9 f5 ff ff       	call   80101470 <iget>
}
80101e77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e7a:	5b                   	pop    %ebx
80101e7b:	5e                   	pop    %esi
80101e7c:	5f                   	pop    %edi
80101e7d:	5d                   	pop    %ebp
80101e7e:	c3                   	ret    
      panic("dirlookup read");
80101e7f:	83 ec 0c             	sub    $0xc,%esp
80101e82:	68 59 7a 10 80       	push   $0x80107a59
80101e87:	e8 f4 e4 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101e8c:	83 ec 0c             	sub    $0xc,%esp
80101e8f:	68 47 7a 10 80       	push   $0x80107a47
80101e94:	e8 e7 e4 ff ff       	call   80100380 <panic>
80101e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ea0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ea0:	55                   	push   %ebp
80101ea1:	89 e5                	mov    %esp,%ebp
80101ea3:	57                   	push   %edi
80101ea4:	56                   	push   %esi
80101ea5:	53                   	push   %ebx
80101ea6:	89 c3                	mov    %eax,%ebx
80101ea8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101eab:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101eae:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101eb1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101eb4:	0f 84 64 01 00 00    	je     8010201e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101eba:	e8 d1 1b 00 00       	call   80103a90 <myproc>
  acquire(&icache.lock);
80101ebf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101ec2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101ec5:	68 40 0a 11 80       	push   $0x80110a40
80101eca:	e8 41 2a 00 00       	call   80104910 <acquire>
  ip->ref++;
80101ecf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ed3:	c7 04 24 40 0a 11 80 	movl   $0x80110a40,(%esp)
80101eda:	e8 d1 29 00 00       	call   801048b0 <release>
80101edf:	83 c4 10             	add    $0x10,%esp
80101ee2:	eb 07                	jmp    80101eeb <namex+0x4b>
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ee8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101eeb:	0f b6 03             	movzbl (%ebx),%eax
80101eee:	3c 2f                	cmp    $0x2f,%al
80101ef0:	74 f6                	je     80101ee8 <namex+0x48>
  if(*path == 0)
80101ef2:	84 c0                	test   %al,%al
80101ef4:	0f 84 06 01 00 00    	je     80102000 <namex+0x160>
  while(*path != '/' && *path != 0)
80101efa:	0f b6 03             	movzbl (%ebx),%eax
80101efd:	84 c0                	test   %al,%al
80101eff:	0f 84 10 01 00 00    	je     80102015 <namex+0x175>
80101f05:	89 df                	mov    %ebx,%edi
80101f07:	3c 2f                	cmp    $0x2f,%al
80101f09:	0f 84 06 01 00 00    	je     80102015 <namex+0x175>
80101f0f:	90                   	nop
80101f10:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101f14:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101f17:	3c 2f                	cmp    $0x2f,%al
80101f19:	74 04                	je     80101f1f <namex+0x7f>
80101f1b:	84 c0                	test   %al,%al
80101f1d:	75 f1                	jne    80101f10 <namex+0x70>
  len = path - s;
80101f1f:	89 f8                	mov    %edi,%eax
80101f21:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101f23:	83 f8 0d             	cmp    $0xd,%eax
80101f26:	0f 8e ac 00 00 00    	jle    80101fd8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101f2c:	83 ec 04             	sub    $0x4,%esp
80101f2f:	6a 0e                	push   $0xe
80101f31:	53                   	push   %ebx
    path++;
80101f32:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101f34:	ff 75 e4             	pushl  -0x1c(%ebp)
80101f37:	e8 34 2b 00 00       	call   80104a70 <memmove>
80101f3c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f3f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101f42:	75 0c                	jne    80101f50 <namex+0xb0>
80101f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f4b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f4e:	74 f8                	je     80101f48 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	56                   	push   %esi
80101f54:	e8 37 f9 ff ff       	call   80101890 <ilock>
    if(ip->type != T_DIR){
80101f59:	83 c4 10             	add    $0x10,%esp
80101f5c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101f61:	0f 85 cd 00 00 00    	jne    80102034 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f6a:	85 c0                	test   %eax,%eax
80101f6c:	74 09                	je     80101f77 <namex+0xd7>
80101f6e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101f71:	0f 84 22 01 00 00    	je     80102099 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f77:	83 ec 04             	sub    $0x4,%esp
80101f7a:	6a 00                	push   $0x0
80101f7c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101f7f:	56                   	push   %esi
80101f80:	e8 6b fe ff ff       	call   80101df0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f85:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101f88:	83 c4 10             	add    $0x10,%esp
80101f8b:	89 c7                	mov    %eax,%edi
80101f8d:	85 c0                	test   %eax,%eax
80101f8f:	0f 84 e1 00 00 00    	je     80102076 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f95:	83 ec 0c             	sub    $0xc,%esp
80101f98:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101f9b:	52                   	push   %edx
80101f9c:	e8 4f 27 00 00       	call   801046f0 <holdingsleep>
80101fa1:	83 c4 10             	add    $0x10,%esp
80101fa4:	85 c0                	test   %eax,%eax
80101fa6:	0f 84 30 01 00 00    	je     801020dc <namex+0x23c>
80101fac:	8b 56 08             	mov    0x8(%esi),%edx
80101faf:	85 d2                	test   %edx,%edx
80101fb1:	0f 8e 25 01 00 00    	jle    801020dc <namex+0x23c>
  releasesleep(&ip->lock);
80101fb7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101fba:	83 ec 0c             	sub    $0xc,%esp
80101fbd:	52                   	push   %edx
80101fbe:	e8 ed 26 00 00       	call   801046b0 <releasesleep>
  iput(ip);
80101fc3:	89 34 24             	mov    %esi,(%esp)
80101fc6:	89 fe                	mov    %edi,%esi
80101fc8:	e8 f3 f9 ff ff       	call   801019c0 <iput>
80101fcd:	83 c4 10             	add    $0x10,%esp
80101fd0:	e9 16 ff ff ff       	jmp    80101eeb <namex+0x4b>
80101fd5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101fd8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101fdb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101fde:	83 ec 04             	sub    $0x4,%esp
80101fe1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101fe4:	50                   	push   %eax
80101fe5:	53                   	push   %ebx
    name[len] = 0;
80101fe6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101fe8:	ff 75 e4             	pushl  -0x1c(%ebp)
80101feb:	e8 80 2a 00 00       	call   80104a70 <memmove>
    name[len] = 0;
80101ff0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ff3:	83 c4 10             	add    $0x10,%esp
80101ff6:	c6 02 00             	movb   $0x0,(%edx)
80101ff9:	e9 41 ff ff ff       	jmp    80101f3f <namex+0x9f>
80101ffe:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102000:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102003:	85 c0                	test   %eax,%eax
80102005:	0f 85 be 00 00 00    	jne    801020c9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
8010200b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010200e:	89 f0                	mov    %esi,%eax
80102010:	5b                   	pop    %ebx
80102011:	5e                   	pop    %esi
80102012:	5f                   	pop    %edi
80102013:	5d                   	pop    %ebp
80102014:	c3                   	ret    
  while(*path != '/' && *path != 0)
80102015:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102018:	89 df                	mov    %ebx,%edi
8010201a:	31 c0                	xor    %eax,%eax
8010201c:	eb c0                	jmp    80101fde <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
8010201e:	ba 01 00 00 00       	mov    $0x1,%edx
80102023:	b8 01 00 00 00       	mov    $0x1,%eax
80102028:	e8 43 f4 ff ff       	call   80101470 <iget>
8010202d:	89 c6                	mov    %eax,%esi
8010202f:	e9 b7 fe ff ff       	jmp    80101eeb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102034:	83 ec 0c             	sub    $0xc,%esp
80102037:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010203a:	53                   	push   %ebx
8010203b:	e8 b0 26 00 00       	call   801046f0 <holdingsleep>
80102040:	83 c4 10             	add    $0x10,%esp
80102043:	85 c0                	test   %eax,%eax
80102045:	0f 84 91 00 00 00    	je     801020dc <namex+0x23c>
8010204b:	8b 46 08             	mov    0x8(%esi),%eax
8010204e:	85 c0                	test   %eax,%eax
80102050:	0f 8e 86 00 00 00    	jle    801020dc <namex+0x23c>
  releasesleep(&ip->lock);
80102056:	83 ec 0c             	sub    $0xc,%esp
80102059:	53                   	push   %ebx
8010205a:	e8 51 26 00 00       	call   801046b0 <releasesleep>
  iput(ip);
8010205f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102062:	31 f6                	xor    %esi,%esi
  iput(ip);
80102064:	e8 57 f9 ff ff       	call   801019c0 <iput>
      return 0;
80102069:	83 c4 10             	add    $0x10,%esp
}
8010206c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010206f:	89 f0                	mov    %esi,%eax
80102071:	5b                   	pop    %ebx
80102072:	5e                   	pop    %esi
80102073:	5f                   	pop    %edi
80102074:	5d                   	pop    %ebp
80102075:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102076:	83 ec 0c             	sub    $0xc,%esp
80102079:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010207c:	52                   	push   %edx
8010207d:	e8 6e 26 00 00       	call   801046f0 <holdingsleep>
80102082:	83 c4 10             	add    $0x10,%esp
80102085:	85 c0                	test   %eax,%eax
80102087:	74 53                	je     801020dc <namex+0x23c>
80102089:	8b 4e 08             	mov    0x8(%esi),%ecx
8010208c:	85 c9                	test   %ecx,%ecx
8010208e:	7e 4c                	jle    801020dc <namex+0x23c>
  releasesleep(&ip->lock);
80102090:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102093:	83 ec 0c             	sub    $0xc,%esp
80102096:	52                   	push   %edx
80102097:	eb c1                	jmp    8010205a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102099:	83 ec 0c             	sub    $0xc,%esp
8010209c:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010209f:	53                   	push   %ebx
801020a0:	e8 4b 26 00 00       	call   801046f0 <holdingsleep>
801020a5:	83 c4 10             	add    $0x10,%esp
801020a8:	85 c0                	test   %eax,%eax
801020aa:	74 30                	je     801020dc <namex+0x23c>
801020ac:	8b 7e 08             	mov    0x8(%esi),%edi
801020af:	85 ff                	test   %edi,%edi
801020b1:	7e 29                	jle    801020dc <namex+0x23c>
  releasesleep(&ip->lock);
801020b3:	83 ec 0c             	sub    $0xc,%esp
801020b6:	53                   	push   %ebx
801020b7:	e8 f4 25 00 00       	call   801046b0 <releasesleep>
}
801020bc:	83 c4 10             	add    $0x10,%esp
}
801020bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020c2:	89 f0                	mov    %esi,%eax
801020c4:	5b                   	pop    %ebx
801020c5:	5e                   	pop    %esi
801020c6:	5f                   	pop    %edi
801020c7:	5d                   	pop    %ebp
801020c8:	c3                   	ret    
    iput(ip);
801020c9:	83 ec 0c             	sub    $0xc,%esp
801020cc:	56                   	push   %esi
    return 0;
801020cd:	31 f6                	xor    %esi,%esi
    iput(ip);
801020cf:	e8 ec f8 ff ff       	call   801019c0 <iput>
    return 0;
801020d4:	83 c4 10             	add    $0x10,%esp
801020d7:	e9 2f ff ff ff       	jmp    8010200b <namex+0x16b>
    panic("iunlock");
801020dc:	83 ec 0c             	sub    $0xc,%esp
801020df:	68 3f 7a 10 80       	push   $0x80107a3f
801020e4:	e8 97 e2 ff ff       	call   80100380 <panic>
801020e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020f0 <dirlink>:
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	57                   	push   %edi
801020f4:	56                   	push   %esi
801020f5:	53                   	push   %ebx
801020f6:	83 ec 20             	sub    $0x20,%esp
801020f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801020fc:	6a 00                	push   $0x0
801020fe:	ff 75 0c             	pushl  0xc(%ebp)
80102101:	53                   	push   %ebx
80102102:	e8 e9 fc ff ff       	call   80101df0 <dirlookup>
80102107:	83 c4 10             	add    $0x10,%esp
8010210a:	85 c0                	test   %eax,%eax
8010210c:	75 67                	jne    80102175 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010210e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102111:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102114:	85 ff                	test   %edi,%edi
80102116:	74 29                	je     80102141 <dirlink+0x51>
80102118:	31 ff                	xor    %edi,%edi
8010211a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010211d:	eb 09                	jmp    80102128 <dirlink+0x38>
8010211f:	90                   	nop
80102120:	83 c7 10             	add    $0x10,%edi
80102123:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102126:	73 19                	jae    80102141 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102128:	6a 10                	push   $0x10
8010212a:	57                   	push   %edi
8010212b:	56                   	push   %esi
8010212c:	53                   	push   %ebx
8010212d:	e8 6e fa ff ff       	call   80101ba0 <readi>
80102132:	83 c4 10             	add    $0x10,%esp
80102135:	83 f8 10             	cmp    $0x10,%eax
80102138:	75 4e                	jne    80102188 <dirlink+0x98>
    if(de.inum == 0)
8010213a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010213f:	75 df                	jne    80102120 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102141:	83 ec 04             	sub    $0x4,%esp
80102144:	8d 45 da             	lea    -0x26(%ebp),%eax
80102147:	6a 0e                	push   $0xe
80102149:	ff 75 0c             	pushl  0xc(%ebp)
8010214c:	50                   	push   %eax
8010214d:	e8 de 29 00 00       	call   80104b30 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102152:	6a 10                	push   $0x10
  de.inum = inum;
80102154:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102157:	57                   	push   %edi
80102158:	56                   	push   %esi
80102159:	53                   	push   %ebx
  de.inum = inum;
8010215a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010215e:	e8 3d fb ff ff       	call   80101ca0 <writei>
80102163:	83 c4 20             	add    $0x20,%esp
80102166:	83 f8 10             	cmp    $0x10,%eax
80102169:	75 2a                	jne    80102195 <dirlink+0xa5>
  return 0;
8010216b:	31 c0                	xor    %eax,%eax
}
8010216d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102170:	5b                   	pop    %ebx
80102171:	5e                   	pop    %esi
80102172:	5f                   	pop    %edi
80102173:	5d                   	pop    %ebp
80102174:	c3                   	ret    
    iput(ip);
80102175:	83 ec 0c             	sub    $0xc,%esp
80102178:	50                   	push   %eax
80102179:	e8 42 f8 ff ff       	call   801019c0 <iput>
    return -1;
8010217e:	83 c4 10             	add    $0x10,%esp
80102181:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102186:	eb e5                	jmp    8010216d <dirlink+0x7d>
      panic("dirlink read");
80102188:	83 ec 0c             	sub    $0xc,%esp
8010218b:	68 68 7a 10 80       	push   $0x80107a68
80102190:	e8 eb e1 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102195:	83 ec 0c             	sub    $0xc,%esp
80102198:	68 9a 81 10 80       	push   $0x8010819a
8010219d:	e8 de e1 ff ff       	call   80100380 <panic>
801021a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021b0 <namei>:

struct inode*
namei(char *path)
{
801021b0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801021b1:	31 d2                	xor    %edx,%edx
{
801021b3:	89 e5                	mov    %esp,%ebp
801021b5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801021b8:	8b 45 08             	mov    0x8(%ebp),%eax
801021bb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801021be:	e8 dd fc ff ff       	call   80101ea0 <namex>
}
801021c3:	c9                   	leave  
801021c4:	c3                   	ret    
801021c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801021d0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801021d0:	55                   	push   %ebp
  return namex(path, 1, name);
801021d1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801021d6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801021d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801021db:	8b 45 08             	mov    0x8(%ebp),%eax
}
801021de:	5d                   	pop    %ebp
  return namex(path, 1, name);
801021df:	e9 bc fc ff ff       	jmp    80101ea0 <namex>
801021e4:	66 90                	xchg   %ax,%ax
801021e6:	66 90                	xchg   %ax,%ax
801021e8:	66 90                	xchg   %ax,%ax
801021ea:	66 90                	xchg   %ax,%ax
801021ec:	66 90                	xchg   %ax,%ax
801021ee:	66 90                	xchg   %ax,%ax

801021f0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801021f0:	55                   	push   %ebp
801021f1:	89 e5                	mov    %esp,%ebp
801021f3:	57                   	push   %edi
801021f4:	56                   	push   %esi
801021f5:	53                   	push   %ebx
801021f6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801021f9:	85 c0                	test   %eax,%eax
801021fb:	0f 84 b4 00 00 00    	je     801022b5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102201:	8b 70 08             	mov    0x8(%eax),%esi
80102204:	89 c3                	mov    %eax,%ebx
80102206:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010220c:	0f 87 96 00 00 00    	ja     801022a8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102212:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010221e:	66 90                	xchg   %ax,%ax
80102220:	89 ca                	mov    %ecx,%edx
80102222:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102223:	83 e0 c0             	and    $0xffffffc0,%eax
80102226:	3c 40                	cmp    $0x40,%al
80102228:	75 f6                	jne    80102220 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010222a:	31 ff                	xor    %edi,%edi
8010222c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102231:	89 f8                	mov    %edi,%eax
80102233:	ee                   	out    %al,(%dx)
80102234:	b8 01 00 00 00       	mov    $0x1,%eax
80102239:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010223e:	ee                   	out    %al,(%dx)
8010223f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102244:	89 f0                	mov    %esi,%eax
80102246:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102247:	89 f0                	mov    %esi,%eax
80102249:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010224e:	c1 f8 08             	sar    $0x8,%eax
80102251:	ee                   	out    %al,(%dx)
80102252:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102257:	89 f8                	mov    %edi,%eax
80102259:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010225a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010225e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102263:	c1 e0 04             	shl    $0x4,%eax
80102266:	83 e0 10             	and    $0x10,%eax
80102269:	83 c8 e0             	or     $0xffffffe0,%eax
8010226c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010226d:	f6 03 04             	testb  $0x4,(%ebx)
80102270:	75 16                	jne    80102288 <idestart+0x98>
80102272:	b8 20 00 00 00       	mov    $0x20,%eax
80102277:	89 ca                	mov    %ecx,%edx
80102279:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010227a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010227d:	5b                   	pop    %ebx
8010227e:	5e                   	pop    %esi
8010227f:	5f                   	pop    %edi
80102280:	5d                   	pop    %ebp
80102281:	c3                   	ret    
80102282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102288:	b8 30 00 00 00       	mov    $0x30,%eax
8010228d:	89 ca                	mov    %ecx,%edx
8010228f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102290:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102295:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102298:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229d:	fc                   	cld    
8010229e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801022a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022a3:	5b                   	pop    %ebx
801022a4:	5e                   	pop    %esi
801022a5:	5f                   	pop    %edi
801022a6:	5d                   	pop    %ebp
801022a7:	c3                   	ret    
    panic("incorrect blockno");
801022a8:	83 ec 0c             	sub    $0xc,%esp
801022ab:	68 d4 7a 10 80       	push   $0x80107ad4
801022b0:	e8 cb e0 ff ff       	call   80100380 <panic>
    panic("idestart");
801022b5:	83 ec 0c             	sub    $0xc,%esp
801022b8:	68 cb 7a 10 80       	push   $0x80107acb
801022bd:	e8 be e0 ff ff       	call   80100380 <panic>
801022c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801022d0 <ideinit>:
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801022d6:	68 e6 7a 10 80       	push   $0x80107ae6
801022db:	68 e0 26 11 80       	push   $0x801126e0
801022e0:	e8 5b 24 00 00       	call   80104740 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801022e5:	58                   	pop    %eax
801022e6:	a1 64 28 11 80       	mov    0x80112864,%eax
801022eb:	5a                   	pop    %edx
801022ec:	83 e8 01             	sub    $0x1,%eax
801022ef:	50                   	push   %eax
801022f0:	6a 0e                	push   $0xe
801022f2:	e8 99 02 00 00       	call   80102590 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022f7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022fa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022ff:	90                   	nop
80102300:	ec                   	in     (%dx),%al
80102301:	83 e0 c0             	and    $0xffffffc0,%eax
80102304:	3c 40                	cmp    $0x40,%al
80102306:	75 f8                	jne    80102300 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102308:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010230d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102312:	ee                   	out    %al,(%dx)
80102313:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102318:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010231d:	eb 06                	jmp    80102325 <ideinit+0x55>
8010231f:	90                   	nop
  for(i=0; i<1000; i++){
80102320:	83 e9 01             	sub    $0x1,%ecx
80102323:	74 0f                	je     80102334 <ideinit+0x64>
80102325:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102326:	84 c0                	test   %al,%al
80102328:	74 f6                	je     80102320 <ideinit+0x50>
      havedisk1 = 1;
8010232a:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102331:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102334:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102339:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010233e:	ee                   	out    %al,(%dx)
}
8010233f:	c9                   	leave  
80102340:	c3                   	ret    
80102341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102348:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010234f:	90                   	nop

80102350 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	57                   	push   %edi
80102354:	56                   	push   %esi
80102355:	53                   	push   %ebx
80102356:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102359:	68 e0 26 11 80       	push   $0x801126e0
8010235e:	e8 ad 25 00 00       	call   80104910 <acquire>

  if((b = idequeue) == 0){
80102363:	8b 1d c4 26 11 80    	mov    0x801126c4,%ebx
80102369:	83 c4 10             	add    $0x10,%esp
8010236c:	85 db                	test   %ebx,%ebx
8010236e:	74 63                	je     801023d3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102370:	8b 43 58             	mov    0x58(%ebx),%eax
80102373:	a3 c4 26 11 80       	mov    %eax,0x801126c4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102378:	8b 33                	mov    (%ebx),%esi
8010237a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102380:	75 2f                	jne    801023b1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102382:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010238e:	66 90                	xchg   %ax,%ax
80102390:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102391:	89 c1                	mov    %eax,%ecx
80102393:	83 e1 c0             	and    $0xffffffc0,%ecx
80102396:	80 f9 40             	cmp    $0x40,%cl
80102399:	75 f5                	jne    80102390 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010239b:	a8 21                	test   $0x21,%al
8010239d:	75 12                	jne    801023b1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010239f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801023a2:	b9 80 00 00 00       	mov    $0x80,%ecx
801023a7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801023ac:	fc                   	cld    
801023ad:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801023af:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801023b1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801023b4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801023b7:	83 ce 02             	or     $0x2,%esi
801023ba:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801023bc:	53                   	push   %ebx
801023bd:	e8 5e 1e 00 00       	call   80104220 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801023c2:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801023c7:	83 c4 10             	add    $0x10,%esp
801023ca:	85 c0                	test   %eax,%eax
801023cc:	74 05                	je     801023d3 <ideintr+0x83>
    idestart(idequeue);
801023ce:	e8 1d fe ff ff       	call   801021f0 <idestart>
    release(&idelock);
801023d3:	83 ec 0c             	sub    $0xc,%esp
801023d6:	68 e0 26 11 80       	push   $0x801126e0
801023db:	e8 d0 24 00 00       	call   801048b0 <release>

  release(&idelock);
}
801023e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023e3:	5b                   	pop    %ebx
801023e4:	5e                   	pop    %esi
801023e5:	5f                   	pop    %edi
801023e6:	5d                   	pop    %ebp
801023e7:	c3                   	ret    
801023e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023ef:	90                   	nop

801023f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	53                   	push   %ebx
801023f4:	83 ec 10             	sub    $0x10,%esp
801023f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801023fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801023fd:	50                   	push   %eax
801023fe:	e8 ed 22 00 00       	call   801046f0 <holdingsleep>
80102403:	83 c4 10             	add    $0x10,%esp
80102406:	85 c0                	test   %eax,%eax
80102408:	0f 84 c3 00 00 00    	je     801024d1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010240e:	8b 03                	mov    (%ebx),%eax
80102410:	83 e0 06             	and    $0x6,%eax
80102413:	83 f8 02             	cmp    $0x2,%eax
80102416:	0f 84 a8 00 00 00    	je     801024c4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010241c:	8b 53 04             	mov    0x4(%ebx),%edx
8010241f:	85 d2                	test   %edx,%edx
80102421:	74 0d                	je     80102430 <iderw+0x40>
80102423:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102428:	85 c0                	test   %eax,%eax
8010242a:	0f 84 87 00 00 00    	je     801024b7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102430:	83 ec 0c             	sub    $0xc,%esp
80102433:	68 e0 26 11 80       	push   $0x801126e0
80102438:	e8 d3 24 00 00       	call   80104910 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010243d:	a1 c4 26 11 80       	mov    0x801126c4,%eax
  b->qnext = 0;
80102442:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102449:	83 c4 10             	add    $0x10,%esp
8010244c:	85 c0                	test   %eax,%eax
8010244e:	74 60                	je     801024b0 <iderw+0xc0>
80102450:	89 c2                	mov    %eax,%edx
80102452:	8b 40 58             	mov    0x58(%eax),%eax
80102455:	85 c0                	test   %eax,%eax
80102457:	75 f7                	jne    80102450 <iderw+0x60>
80102459:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010245c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010245e:	39 1d c4 26 11 80    	cmp    %ebx,0x801126c4
80102464:	74 3a                	je     801024a0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102466:	8b 03                	mov    (%ebx),%eax
80102468:	83 e0 06             	and    $0x6,%eax
8010246b:	83 f8 02             	cmp    $0x2,%eax
8010246e:	74 1b                	je     8010248b <iderw+0x9b>
    sleep(b, &idelock);
80102470:	83 ec 08             	sub    $0x8,%esp
80102473:	68 e0 26 11 80       	push   $0x801126e0
80102478:	53                   	push   %ebx
80102479:	e8 e2 1c 00 00       	call   80104160 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010247e:	8b 03                	mov    (%ebx),%eax
80102480:	83 c4 10             	add    $0x10,%esp
80102483:	83 e0 06             	and    $0x6,%eax
80102486:	83 f8 02             	cmp    $0x2,%eax
80102489:	75 e5                	jne    80102470 <iderw+0x80>
  }


  release(&idelock);
8010248b:	c7 45 08 e0 26 11 80 	movl   $0x801126e0,0x8(%ebp)
}
80102492:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102495:	c9                   	leave  
  release(&idelock);
80102496:	e9 15 24 00 00       	jmp    801048b0 <release>
8010249b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010249f:	90                   	nop
    idestart(b);
801024a0:	89 d8                	mov    %ebx,%eax
801024a2:	e8 49 fd ff ff       	call   801021f0 <idestart>
801024a7:	eb bd                	jmp    80102466 <iderw+0x76>
801024a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024b0:	ba c4 26 11 80       	mov    $0x801126c4,%edx
801024b5:	eb a5                	jmp    8010245c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801024b7:	83 ec 0c             	sub    $0xc,%esp
801024ba:	68 15 7b 10 80       	push   $0x80107b15
801024bf:	e8 bc de ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801024c4:	83 ec 0c             	sub    $0xc,%esp
801024c7:	68 00 7b 10 80       	push   $0x80107b00
801024cc:	e8 af de ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801024d1:	83 ec 0c             	sub    $0xc,%esp
801024d4:	68 ea 7a 10 80       	push   $0x80107aea
801024d9:	e8 a2 de ff ff       	call   80100380 <panic>
801024de:	66 90                	xchg   %ax,%ax

801024e0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801024e0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801024e1:	c7 05 14 27 11 80 00 	movl   $0xfec00000,0x80112714
801024e8:	00 c0 fe 
{
801024eb:	89 e5                	mov    %esp,%ebp
801024ed:	56                   	push   %esi
801024ee:	53                   	push   %ebx
  ioapic->reg = reg;
801024ef:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801024f6:	00 00 00 
  return ioapic->data;
801024f9:	8b 15 14 27 11 80    	mov    0x80112714,%edx
801024ff:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102502:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102508:	8b 0d 14 27 11 80    	mov    0x80112714,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010250e:	0f b6 15 60 28 11 80 	movzbl 0x80112860,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102515:	c1 ee 10             	shr    $0x10,%esi
80102518:	89 f0                	mov    %esi,%eax
8010251a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010251d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102520:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102523:	39 c2                	cmp    %eax,%edx
80102525:	74 16                	je     8010253d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102527:	83 ec 0c             	sub    $0xc,%esp
8010252a:	68 34 7b 10 80       	push   $0x80107b34
8010252f:	e8 4c e1 ff ff       	call   80100680 <cprintf>
  ioapic->reg = reg;
80102534:	8b 0d 14 27 11 80    	mov    0x80112714,%ecx
8010253a:	83 c4 10             	add    $0x10,%esp
8010253d:	83 c6 21             	add    $0x21,%esi
{
80102540:	ba 10 00 00 00       	mov    $0x10,%edx
80102545:	b8 20 00 00 00       	mov    $0x20,%eax
8010254a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102550:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102552:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102554:	8b 0d 14 27 11 80    	mov    0x80112714,%ecx
  for(i = 0; i <= maxintr; i++){
8010255a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010255d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102563:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102566:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102569:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010256c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010256e:	8b 0d 14 27 11 80    	mov    0x80112714,%ecx
80102574:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010257b:	39 f0                	cmp    %esi,%eax
8010257d:	75 d1                	jne    80102550 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010257f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102582:	5b                   	pop    %ebx
80102583:	5e                   	pop    %esi
80102584:	5d                   	pop    %ebp
80102585:	c3                   	ret    
80102586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010258d:	8d 76 00             	lea    0x0(%esi),%esi

80102590 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102590:	55                   	push   %ebp
  ioapic->reg = reg;
80102591:	8b 0d 14 27 11 80    	mov    0x80112714,%ecx
{
80102597:	89 e5                	mov    %esp,%ebp
80102599:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010259c:	8d 50 20             	lea    0x20(%eax),%edx
8010259f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801025a3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801025a5:	8b 0d 14 27 11 80    	mov    0x80112714,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025ab:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801025ae:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801025b4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801025b6:	a1 14 27 11 80       	mov    0x80112714,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025bb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801025be:	89 50 10             	mov    %edx,0x10(%eax)
}
801025c1:	5d                   	pop    %ebp
801025c2:	c3                   	ret    
801025c3:	66 90                	xchg   %ax,%ax
801025c5:	66 90                	xchg   %ax,%ax
801025c7:	66 90                	xchg   %ax,%ax
801025c9:	66 90                	xchg   %ax,%ax
801025cb:	66 90                	xchg   %ax,%ax
801025cd:	66 90                	xchg   %ax,%ax
801025cf:	90                   	nop

801025d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	53                   	push   %ebx
801025d4:	83 ec 04             	sub    $0x4,%esp
801025d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801025da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801025e0:	75 76                	jne    80102658 <kfree+0x88>
801025e2:	81 fb 50 7b 11 80    	cmp    $0x80117b50,%ebx
801025e8:	72 6e                	jb     80102658 <kfree+0x88>
801025ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801025f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801025f5:	77 61                	ja     80102658 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801025f7:	83 ec 04             	sub    $0x4,%esp
801025fa:	68 00 10 00 00       	push   $0x1000
801025ff:	6a 01                	push   $0x1
80102601:	53                   	push   %ebx
80102602:	e8 c9 23 00 00       	call   801049d0 <memset>

  if(kmem.use_lock)
80102607:	8b 15 54 27 11 80    	mov    0x80112754,%edx
8010260d:	83 c4 10             	add    $0x10,%esp
80102610:	85 d2                	test   %edx,%edx
80102612:	75 1c                	jne    80102630 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102614:	a1 58 27 11 80       	mov    0x80112758,%eax
80102619:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010261b:	a1 54 27 11 80       	mov    0x80112754,%eax
  kmem.freelist = r;
80102620:	89 1d 58 27 11 80    	mov    %ebx,0x80112758
  if(kmem.use_lock)
80102626:	85 c0                	test   %eax,%eax
80102628:	75 1e                	jne    80102648 <kfree+0x78>
    release(&kmem.lock);
}
8010262a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010262d:	c9                   	leave  
8010262e:	c3                   	ret    
8010262f:	90                   	nop
    acquire(&kmem.lock);
80102630:	83 ec 0c             	sub    $0xc,%esp
80102633:	68 20 27 11 80       	push   $0x80112720
80102638:	e8 d3 22 00 00       	call   80104910 <acquire>
8010263d:	83 c4 10             	add    $0x10,%esp
80102640:	eb d2                	jmp    80102614 <kfree+0x44>
80102642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102648:	c7 45 08 20 27 11 80 	movl   $0x80112720,0x8(%ebp)
}
8010264f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102652:	c9                   	leave  
    release(&kmem.lock);
80102653:	e9 58 22 00 00       	jmp    801048b0 <release>
    panic("kfree");
80102658:	83 ec 0c             	sub    $0xc,%esp
8010265b:	68 66 7b 10 80       	push   $0x80107b66
80102660:	e8 1b dd ff ff       	call   80100380 <panic>
80102665:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010266c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102670 <freerange>:
{
80102670:	55                   	push   %ebp
80102671:	89 e5                	mov    %esp,%ebp
80102673:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102674:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102677:	8b 75 0c             	mov    0xc(%ebp),%esi
8010267a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010267b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102681:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102687:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010268d:	39 de                	cmp    %ebx,%esi
8010268f:	72 23                	jb     801026b4 <freerange+0x44>
80102691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102698:	83 ec 0c             	sub    $0xc,%esp
8010269b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026a7:	50                   	push   %eax
801026a8:	e8 23 ff ff ff       	call   801025d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026ad:	83 c4 10             	add    $0x10,%esp
801026b0:	39 f3                	cmp    %esi,%ebx
801026b2:	76 e4                	jbe    80102698 <freerange+0x28>
}
801026b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026b7:	5b                   	pop    %ebx
801026b8:	5e                   	pop    %esi
801026b9:	5d                   	pop    %ebp
801026ba:	c3                   	ret    
801026bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026bf:	90                   	nop

801026c0 <kinit2>:
{
801026c0:	55                   	push   %ebp
801026c1:	89 e5                	mov    %esp,%ebp
801026c3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801026c4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801026c7:	8b 75 0c             	mov    0xc(%ebp),%esi
801026ca:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801026cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026dd:	39 de                	cmp    %ebx,%esi
801026df:	72 23                	jb     80102704 <kinit2+0x44>
801026e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801026e8:	83 ec 0c             	sub    $0xc,%esp
801026eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026f7:	50                   	push   %eax
801026f8:	e8 d3 fe ff ff       	call   801025d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026fd:	83 c4 10             	add    $0x10,%esp
80102700:	39 de                	cmp    %ebx,%esi
80102702:	73 e4                	jae    801026e8 <kinit2+0x28>
  kmem.use_lock = 1;
80102704:	c7 05 54 27 11 80 01 	movl   $0x1,0x80112754
8010270b:	00 00 00 
}
8010270e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102711:	5b                   	pop    %ebx
80102712:	5e                   	pop    %esi
80102713:	5d                   	pop    %ebp
80102714:	c3                   	ret    
80102715:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010271c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102720 <kinit1>:
{
80102720:	55                   	push   %ebp
80102721:	89 e5                	mov    %esp,%ebp
80102723:	56                   	push   %esi
80102724:	53                   	push   %ebx
80102725:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102728:	83 ec 08             	sub    $0x8,%esp
8010272b:	68 6c 7b 10 80       	push   $0x80107b6c
80102730:	68 20 27 11 80       	push   $0x80112720
80102735:	e8 06 20 00 00       	call   80104740 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010273a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010273d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102740:	c7 05 54 27 11 80 00 	movl   $0x0,0x80112754
80102747:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010274a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102750:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102756:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010275c:	39 de                	cmp    %ebx,%esi
8010275e:	72 1c                	jb     8010277c <kinit1+0x5c>
    kfree(p);
80102760:	83 ec 0c             	sub    $0xc,%esp
80102763:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102769:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010276f:	50                   	push   %eax
80102770:	e8 5b fe ff ff       	call   801025d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102775:	83 c4 10             	add    $0x10,%esp
80102778:	39 de                	cmp    %ebx,%esi
8010277a:	73 e4                	jae    80102760 <kinit1+0x40>
}
8010277c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010277f:	5b                   	pop    %ebx
80102780:	5e                   	pop    %esi
80102781:	5d                   	pop    %ebp
80102782:	c3                   	ret    
80102783:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102790 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102790:	a1 54 27 11 80       	mov    0x80112754,%eax
80102795:	85 c0                	test   %eax,%eax
80102797:	75 1f                	jne    801027b8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102799:	a1 58 27 11 80       	mov    0x80112758,%eax
  if(r)
8010279e:	85 c0                	test   %eax,%eax
801027a0:	74 0e                	je     801027b0 <kalloc+0x20>
    kmem.freelist = r->next;
801027a2:	8b 10                	mov    (%eax),%edx
801027a4:	89 15 58 27 11 80    	mov    %edx,0x80112758
  if(kmem.use_lock)
801027aa:	c3                   	ret    
801027ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027af:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
801027b0:	c3                   	ret    
801027b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801027b8:	55                   	push   %ebp
801027b9:	89 e5                	mov    %esp,%ebp
801027bb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801027be:	68 20 27 11 80       	push   $0x80112720
801027c3:	e8 48 21 00 00       	call   80104910 <acquire>
  r = kmem.freelist;
801027c8:	a1 58 27 11 80       	mov    0x80112758,%eax
  if(kmem.use_lock)
801027cd:	8b 15 54 27 11 80    	mov    0x80112754,%edx
  if(r)
801027d3:	83 c4 10             	add    $0x10,%esp
801027d6:	85 c0                	test   %eax,%eax
801027d8:	74 08                	je     801027e2 <kalloc+0x52>
    kmem.freelist = r->next;
801027da:	8b 08                	mov    (%eax),%ecx
801027dc:	89 0d 58 27 11 80    	mov    %ecx,0x80112758
  if(kmem.use_lock)
801027e2:	85 d2                	test   %edx,%edx
801027e4:	74 16                	je     801027fc <kalloc+0x6c>
    release(&kmem.lock);
801027e6:	83 ec 0c             	sub    $0xc,%esp
801027e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027ec:	68 20 27 11 80       	push   $0x80112720
801027f1:	e8 ba 20 00 00       	call   801048b0 <release>
  return (char*)r;
801027f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801027f9:	83 c4 10             	add    $0x10,%esp
801027fc:	c9                   	leave  
801027fd:	c3                   	ret    
801027fe:	66 90                	xchg   %ax,%ax

80102800 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102800:	ba 64 00 00 00       	mov    $0x64,%edx
80102805:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102806:	a8 01                	test   $0x1,%al
80102808:	0f 84 ca 00 00 00    	je     801028d8 <kbdgetc+0xd8>
{
8010280e:	55                   	push   %ebp
8010280f:	ba 60 00 00 00       	mov    $0x60,%edx
80102814:	89 e5                	mov    %esp,%ebp
80102816:	53                   	push   %ebx
80102817:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102818:	8b 1d 5c 27 11 80    	mov    0x8011275c,%ebx
  data = inb(KBDATAP);
8010281e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102821:	3c e0                	cmp    $0xe0,%al
80102823:	74 5b                	je     80102880 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102825:	89 da                	mov    %ebx,%edx
80102827:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010282a:	84 c0                	test   %al,%al
8010282c:	78 62                	js     80102890 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010282e:	85 d2                	test   %edx,%edx
80102830:	74 09                	je     8010283b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102832:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102835:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102838:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010283b:	0f b6 91 a0 7c 10 80 	movzbl -0x7fef8360(%ecx),%edx
  shift ^= togglecode[data];
80102842:	0f b6 81 a0 7b 10 80 	movzbl -0x7fef8460(%ecx),%eax
  shift |= shiftcode[data];
80102849:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010284b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010284d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010284f:	89 15 5c 27 11 80    	mov    %edx,0x8011275c
  c = charcode[shift & (CTL | SHIFT)][data];
80102855:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102858:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010285b:	8b 04 85 80 7b 10 80 	mov    -0x7fef8480(,%eax,4),%eax
80102862:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102866:	74 0b                	je     80102873 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102868:	8d 50 9f             	lea    -0x61(%eax),%edx
8010286b:	83 fa 19             	cmp    $0x19,%edx
8010286e:	77 50                	ja     801028c0 <kbdgetc+0xc0>
      c += 'A' - 'a';
80102870:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102873:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102876:	c9                   	leave  
80102877:	c3                   	ret    
80102878:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010287f:	90                   	nop
    shift |= E0ESC;
80102880:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102883:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102885:	89 1d 5c 27 11 80    	mov    %ebx,0x8011275c
}
8010288b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010288e:	c9                   	leave  
8010288f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102890:	83 e0 7f             	and    $0x7f,%eax
80102893:	85 d2                	test   %edx,%edx
80102895:	0f 44 c8             	cmove  %eax,%ecx
    return 0;
80102898:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010289a:	0f b6 91 a0 7c 10 80 	movzbl -0x7fef8360(%ecx),%edx
801028a1:	83 ca 40             	or     $0x40,%edx
801028a4:	0f b6 d2             	movzbl %dl,%edx
801028a7:	f7 d2                	not    %edx
801028a9:	21 da                	and    %ebx,%edx
}
801028ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801028ae:	89 15 5c 27 11 80    	mov    %edx,0x8011275c
}
801028b4:	c9                   	leave  
801028b5:	c3                   	ret    
801028b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028bd:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801028c0:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801028c3:	8d 50 20             	lea    0x20(%eax),%edx
}
801028c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028c9:	c9                   	leave  
      c += 'a' - 'A';
801028ca:	83 f9 1a             	cmp    $0x1a,%ecx
801028cd:	0f 42 c2             	cmovb  %edx,%eax
}
801028d0:	c3                   	ret    
801028d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801028d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801028dd:	c3                   	ret    
801028de:	66 90                	xchg   %ax,%ax

801028e0 <kbdintr>:

void
kbdintr(void)
{
801028e0:	55                   	push   %ebp
801028e1:	89 e5                	mov    %esp,%ebp
801028e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801028e6:	68 00 28 10 80       	push   $0x80102800
801028eb:	e8 00 e0 ff ff       	call   801008f0 <consoleintr>
}
801028f0:	83 c4 10             	add    $0x10,%esp
801028f3:	c9                   	leave  
801028f4:	c3                   	ret    
801028f5:	66 90                	xchg   %ax,%ax
801028f7:	66 90                	xchg   %ax,%ax
801028f9:	66 90                	xchg   %ax,%ax
801028fb:	66 90                	xchg   %ax,%ax
801028fd:	66 90                	xchg   %ax,%ax
801028ff:	90                   	nop

80102900 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102900:	a1 60 27 11 80       	mov    0x80112760,%eax
80102905:	85 c0                	test   %eax,%eax
80102907:	0f 84 cb 00 00 00    	je     801029d8 <lapicinit+0xd8>
  lapic[index] = value;
8010290d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102914:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102917:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010291a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102921:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102924:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102927:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010292e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102931:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102934:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010293b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010293e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102941:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102948:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010294b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010294e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102955:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102958:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010295b:	8b 50 30             	mov    0x30(%eax),%edx
8010295e:	c1 ea 10             	shr    $0x10,%edx
80102961:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102967:	75 77                	jne    801029e0 <lapicinit+0xe0>
  lapic[index] = value;
80102969:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102970:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102973:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102976:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010297d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102980:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102983:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010298a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010298d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102990:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102997:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010299a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010299d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801029a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029aa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801029b1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801029b4:	8b 50 20             	mov    0x20(%eax),%edx
801029b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029be:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801029c0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801029c6:	80 e6 10             	and    $0x10,%dh
801029c9:	75 f5                	jne    801029c0 <lapicinit+0xc0>
  lapic[index] = value;
801029cb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801029d2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029d5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801029d8:	c3                   	ret    
801029d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801029e0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801029e7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029ea:	8b 50 20             	mov    0x20(%eax),%edx
}
801029ed:	e9 77 ff ff ff       	jmp    80102969 <lapicinit+0x69>
801029f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a00 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102a00:	a1 60 27 11 80       	mov    0x80112760,%eax
80102a05:	85 c0                	test   %eax,%eax
80102a07:	74 07                	je     80102a10 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102a09:	8b 40 20             	mov    0x20(%eax),%eax
80102a0c:	c1 e8 18             	shr    $0x18,%eax
80102a0f:	c3                   	ret    
    return 0;
80102a10:	31 c0                	xor    %eax,%eax
}
80102a12:	c3                   	ret    
80102a13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102a20 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102a20:	a1 60 27 11 80       	mov    0x80112760,%eax
80102a25:	85 c0                	test   %eax,%eax
80102a27:	74 0d                	je     80102a36 <lapiceoi+0x16>
  lapic[index] = value;
80102a29:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a30:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a33:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102a36:	c3                   	ret    
80102a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a3e:	66 90                	xchg   %ax,%ax

80102a40 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102a40:	c3                   	ret    
80102a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a4f:	90                   	nop

80102a50 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102a50:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a51:	b8 0f 00 00 00       	mov    $0xf,%eax
80102a56:	ba 70 00 00 00       	mov    $0x70,%edx
80102a5b:	89 e5                	mov    %esp,%ebp
80102a5d:	53                   	push   %ebx
80102a5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102a61:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a64:	ee                   	out    %al,(%dx)
80102a65:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a6a:	ba 71 00 00 00       	mov    $0x71,%edx
80102a6f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102a70:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102a72:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102a75:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a7b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a7d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102a80:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102a82:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a85:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102a88:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102a8e:	a1 60 27 11 80       	mov    0x80112760,%eax
80102a93:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a99:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a9c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102aa3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102aa9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102ab0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ab6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102abc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102abf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ac5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ac8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ace:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ad1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ad7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102ada:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102add:	c9                   	leave  
80102ade:	c3                   	ret    
80102adf:	90                   	nop

80102ae0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102ae0:	55                   	push   %ebp
80102ae1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102ae6:	ba 70 00 00 00       	mov    $0x70,%edx
80102aeb:	89 e5                	mov    %esp,%ebp
80102aed:	57                   	push   %edi
80102aee:	56                   	push   %esi
80102aef:	53                   	push   %ebx
80102af0:	83 ec 4c             	sub    $0x4c,%esp
80102af3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af4:	ba 71 00 00 00       	mov    $0x71,%edx
80102af9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102afa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102afd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102b02:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102b05:	8d 76 00             	lea    0x0(%esi),%esi
80102b08:	31 c0                	xor    %eax,%eax
80102b0a:	89 da                	mov    %ebx,%edx
80102b0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b0d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102b12:	89 ca                	mov    %ecx,%edx
80102b14:	ec                   	in     (%dx),%al
80102b15:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b18:	89 da                	mov    %ebx,%edx
80102b1a:	b8 02 00 00 00       	mov    $0x2,%eax
80102b1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b20:	89 ca                	mov    %ecx,%edx
80102b22:	ec                   	in     (%dx),%al
80102b23:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b26:	89 da                	mov    %ebx,%edx
80102b28:	b8 04 00 00 00       	mov    $0x4,%eax
80102b2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b2e:	89 ca                	mov    %ecx,%edx
80102b30:	ec                   	in     (%dx),%al
80102b31:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b34:	89 da                	mov    %ebx,%edx
80102b36:	b8 07 00 00 00       	mov    $0x7,%eax
80102b3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b3c:	89 ca                	mov    %ecx,%edx
80102b3e:	ec                   	in     (%dx),%al
80102b3f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b42:	89 da                	mov    %ebx,%edx
80102b44:	b8 08 00 00 00       	mov    $0x8,%eax
80102b49:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4a:	89 ca                	mov    %ecx,%edx
80102b4c:	ec                   	in     (%dx),%al
80102b4d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b4f:	89 da                	mov    %ebx,%edx
80102b51:	b8 09 00 00 00       	mov    $0x9,%eax
80102b56:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b57:	89 ca                	mov    %ecx,%edx
80102b59:	ec                   	in     (%dx),%al
80102b5a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b5c:	89 da                	mov    %ebx,%edx
80102b5e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b64:	89 ca                	mov    %ecx,%edx
80102b66:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102b67:	84 c0                	test   %al,%al
80102b69:	78 9d                	js     80102b08 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102b6b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102b6f:	89 fa                	mov    %edi,%edx
80102b71:	0f b6 fa             	movzbl %dl,%edi
80102b74:	89 f2                	mov    %esi,%edx
80102b76:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b79:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b7d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b80:	89 da                	mov    %ebx,%edx
80102b82:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102b85:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b88:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102b8c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102b8f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b92:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102b96:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102b99:	31 c0                	xor    %eax,%eax
80102b9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b9c:	89 ca                	mov    %ecx,%edx
80102b9e:	ec                   	in     (%dx),%al
80102b9f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ba2:	89 da                	mov    %ebx,%edx
80102ba4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ba7:	b8 02 00 00 00       	mov    $0x2,%eax
80102bac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bad:	89 ca                	mov    %ecx,%edx
80102baf:	ec                   	in     (%dx),%al
80102bb0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bb3:	89 da                	mov    %ebx,%edx
80102bb5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102bb8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bbd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bbe:	89 ca                	mov    %ecx,%edx
80102bc0:	ec                   	in     (%dx),%al
80102bc1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc4:	89 da                	mov    %ebx,%edx
80102bc6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102bc9:	b8 07 00 00 00       	mov    $0x7,%eax
80102bce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bcf:	89 ca                	mov    %ecx,%edx
80102bd1:	ec                   	in     (%dx),%al
80102bd2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd5:	89 da                	mov    %ebx,%edx
80102bd7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102bda:	b8 08 00 00 00       	mov    $0x8,%eax
80102bdf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102be0:	89 ca                	mov    %ecx,%edx
80102be2:	ec                   	in     (%dx),%al
80102be3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be6:	89 da                	mov    %ebx,%edx
80102be8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102beb:	b8 09 00 00 00       	mov    $0x9,%eax
80102bf0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf1:	89 ca                	mov    %ecx,%edx
80102bf3:	ec                   	in     (%dx),%al
80102bf4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102bf7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102bfa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102bfd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102c00:	6a 18                	push   $0x18
80102c02:	50                   	push   %eax
80102c03:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102c06:	50                   	push   %eax
80102c07:	e8 14 1e 00 00       	call   80104a20 <memcmp>
80102c0c:	83 c4 10             	add    $0x10,%esp
80102c0f:	85 c0                	test   %eax,%eax
80102c11:	0f 85 f1 fe ff ff    	jne    80102b08 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102c17:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102c1b:	75 78                	jne    80102c95 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102c1d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c20:	89 c2                	mov    %eax,%edx
80102c22:	83 e0 0f             	and    $0xf,%eax
80102c25:	c1 ea 04             	shr    $0x4,%edx
80102c28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102c31:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c34:	89 c2                	mov    %eax,%edx
80102c36:	83 e0 0f             	and    $0xf,%eax
80102c39:	c1 ea 04             	shr    $0x4,%edx
80102c3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c42:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102c45:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c48:	89 c2                	mov    %eax,%edx
80102c4a:	83 e0 0f             	and    $0xf,%eax
80102c4d:	c1 ea 04             	shr    $0x4,%edx
80102c50:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c53:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c56:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102c59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c5c:	89 c2                	mov    %eax,%edx
80102c5e:	83 e0 0f             	and    $0xf,%eax
80102c61:	c1 ea 04             	shr    $0x4,%edx
80102c64:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c67:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c6a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102c6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c70:	89 c2                	mov    %eax,%edx
80102c72:	83 e0 0f             	and    $0xf,%eax
80102c75:	c1 ea 04             	shr    $0x4,%edx
80102c78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c7e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102c81:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c84:	89 c2                	mov    %eax,%edx
80102c86:	83 e0 0f             	and    $0xf,%eax
80102c89:	c1 ea 04             	shr    $0x4,%edx
80102c8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c92:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102c95:	8b 75 08             	mov    0x8(%ebp),%esi
80102c98:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c9b:	89 06                	mov    %eax,(%esi)
80102c9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ca0:	89 46 04             	mov    %eax,0x4(%esi)
80102ca3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ca6:	89 46 08             	mov    %eax,0x8(%esi)
80102ca9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102cac:	89 46 0c             	mov    %eax,0xc(%esi)
80102caf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102cb2:	89 46 10             	mov    %eax,0x10(%esi)
80102cb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102cb8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102cbb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102cc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cc5:	5b                   	pop    %ebx
80102cc6:	5e                   	pop    %esi
80102cc7:	5f                   	pop    %edi
80102cc8:	5d                   	pop    %ebp
80102cc9:	c3                   	ret    
80102cca:	66 90                	xchg   %ax,%ax
80102ccc:	66 90                	xchg   %ax,%ax
80102cce:	66 90                	xchg   %ax,%ax

80102cd0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cd0:	8b 0d c8 27 11 80    	mov    0x801127c8,%ecx
80102cd6:	85 c9                	test   %ecx,%ecx
80102cd8:	0f 8e 8a 00 00 00    	jle    80102d68 <install_trans+0x98>
{
80102cde:	55                   	push   %ebp
80102cdf:	89 e5                	mov    %esp,%ebp
80102ce1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102ce2:	31 ff                	xor    %edi,%edi
{
80102ce4:	56                   	push   %esi
80102ce5:	53                   	push   %ebx
80102ce6:	83 ec 0c             	sub    $0xc,%esp
80102ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102cf0:	a1 b4 27 11 80       	mov    0x801127b4,%eax
80102cf5:	83 ec 08             	sub    $0x8,%esp
80102cf8:	01 f8                	add    %edi,%eax
80102cfa:	83 c0 01             	add    $0x1,%eax
80102cfd:	50                   	push   %eax
80102cfe:	ff 35 c4 27 11 80    	pushl  0x801127c4
80102d04:	e8 c7 d3 ff ff       	call   801000d0 <bread>
80102d09:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d0b:	58                   	pop    %eax
80102d0c:	5a                   	pop    %edx
80102d0d:	ff 34 bd cc 27 11 80 	pushl  -0x7feed834(,%edi,4)
80102d14:	ff 35 c4 27 11 80    	pushl  0x801127c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102d1a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d1d:	e8 ae d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d22:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d25:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d27:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d2a:	68 00 02 00 00       	push   $0x200
80102d2f:	50                   	push   %eax
80102d30:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102d33:	50                   	push   %eax
80102d34:	e8 37 1d 00 00       	call   80104a70 <memmove>
    bwrite(dbuf);  // write dst to disk
80102d39:	89 1c 24             	mov    %ebx,(%esp)
80102d3c:	e8 6f d4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102d41:	89 34 24             	mov    %esi,(%esp)
80102d44:	e8 a7 d4 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102d49:	89 1c 24             	mov    %ebx,(%esp)
80102d4c:	e8 9f d4 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d51:	83 c4 10             	add    $0x10,%esp
80102d54:	39 3d c8 27 11 80    	cmp    %edi,0x801127c8
80102d5a:	7f 94                	jg     80102cf0 <install_trans+0x20>
  }
}
80102d5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d5f:	5b                   	pop    %ebx
80102d60:	5e                   	pop    %esi
80102d61:	5f                   	pop    %edi
80102d62:	5d                   	pop    %ebp
80102d63:	c3                   	ret    
80102d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d68:	c3                   	ret    
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d77:	ff 35 b4 27 11 80    	pushl  0x801127b4
80102d7d:	ff 35 c4 27 11 80    	pushl  0x801127c4
80102d83:	e8 48 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102d88:	8b 0d c8 27 11 80    	mov    0x801127c8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102d8e:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d91:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102d93:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102d96:	85 c9                	test   %ecx,%ecx
80102d98:	7e 18                	jle    80102db2 <write_head+0x42>
80102d9a:	31 c0                	xor    %eax,%eax
80102d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102da0:	8b 14 85 cc 27 11 80 	mov    -0x7feed834(,%eax,4),%edx
80102da7:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
80102dab:	83 c0 01             	add    $0x1,%eax
80102dae:	39 c1                	cmp    %eax,%ecx
80102db0:	75 ee                	jne    80102da0 <write_head+0x30>
  }
  bwrite(buf);
80102db2:	83 ec 0c             	sub    $0xc,%esp
80102db5:	53                   	push   %ebx
80102db6:	e8 f5 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102dbb:	89 1c 24             	mov    %ebx,(%esp)
80102dbe:	e8 2d d4 ff ff       	call   801001f0 <brelse>
}
80102dc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dc6:	83 c4 10             	add    $0x10,%esp
80102dc9:	c9                   	leave  
80102dca:	c3                   	ret    
80102dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102dcf:	90                   	nop

80102dd0 <initlog>:
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	53                   	push   %ebx
80102dd4:	83 ec 2c             	sub    $0x2c,%esp
80102dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102dda:	68 a0 7d 10 80       	push   $0x80107da0
80102ddf:	68 80 27 11 80       	push   $0x80112780
80102de4:	e8 57 19 00 00       	call   80104740 <initlock>
  readsb(dev, &sb);
80102de9:	58                   	pop    %eax
80102dea:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ded:	5a                   	pop    %edx
80102dee:	50                   	push   %eax
80102def:	53                   	push   %ebx
80102df0:	e8 3b e8 ff ff       	call   80101630 <readsb>
  log.start = sb.logstart;
80102df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102df8:	59                   	pop    %ecx
  log.dev = dev;
80102df9:	89 1d c4 27 11 80    	mov    %ebx,0x801127c4
  log.size = sb.nlog;
80102dff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102e02:	a3 b4 27 11 80       	mov    %eax,0x801127b4
  log.size = sb.nlog;
80102e07:	89 15 b8 27 11 80    	mov    %edx,0x801127b8
  struct buf *buf = bread(log.dev, log.start);
80102e0d:	5a                   	pop    %edx
80102e0e:	50                   	push   %eax
80102e0f:	53                   	push   %ebx
80102e10:	e8 bb d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102e15:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102e18:	8b 58 5c             	mov    0x5c(%eax),%ebx
  struct buf *buf = bread(log.dev, log.start);
80102e1b:	89 c1                	mov    %eax,%ecx
  log.lh.n = lh->n;
80102e1d:	89 1d c8 27 11 80    	mov    %ebx,0x801127c8
  for (i = 0; i < log.lh.n; i++) {
80102e23:	85 db                	test   %ebx,%ebx
80102e25:	7e 1b                	jle    80102e42 <initlog+0x72>
80102e27:	31 c0                	xor    %eax,%eax
80102e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102e30:	8b 54 81 60          	mov    0x60(%ecx,%eax,4),%edx
80102e34:	89 14 85 cc 27 11 80 	mov    %edx,-0x7feed834(,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
80102e3b:	83 c0 01             	add    $0x1,%eax
80102e3e:	39 c3                	cmp    %eax,%ebx
80102e40:	75 ee                	jne    80102e30 <initlog+0x60>
  brelse(buf);
80102e42:	83 ec 0c             	sub    $0xc,%esp
80102e45:	51                   	push   %ecx
80102e46:	e8 a5 d3 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102e4b:	e8 80 fe ff ff       	call   80102cd0 <install_trans>
  log.lh.n = 0;
80102e50:	c7 05 c8 27 11 80 00 	movl   $0x0,0x801127c8
80102e57:	00 00 00 
  write_head(); // clear the log
80102e5a:	e8 11 ff ff ff       	call   80102d70 <write_head>
}
80102e5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e62:	83 c4 10             	add    $0x10,%esp
80102e65:	c9                   	leave  
80102e66:	c3                   	ret    
80102e67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e6e:	66 90                	xchg   %ax,%ax

80102e70 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102e76:	68 80 27 11 80       	push   $0x80112780
80102e7b:	e8 90 1a 00 00       	call   80104910 <acquire>
80102e80:	83 c4 10             	add    $0x10,%esp
80102e83:	eb 18                	jmp    80102e9d <begin_op+0x2d>
80102e85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e88:	83 ec 08             	sub    $0x8,%esp
80102e8b:	68 80 27 11 80       	push   $0x80112780
80102e90:	68 80 27 11 80       	push   $0x80112780
80102e95:	e8 c6 12 00 00       	call   80104160 <sleep>
80102e9a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102e9d:	a1 c0 27 11 80       	mov    0x801127c0,%eax
80102ea2:	85 c0                	test   %eax,%eax
80102ea4:	75 e2                	jne    80102e88 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102ea6:	a1 bc 27 11 80       	mov    0x801127bc,%eax
80102eab:	8b 15 c8 27 11 80    	mov    0x801127c8,%edx
80102eb1:	83 c0 01             	add    $0x1,%eax
80102eb4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102eb7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102eba:	83 fa 1e             	cmp    $0x1e,%edx
80102ebd:	7f c9                	jg     80102e88 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102ebf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102ec2:	a3 bc 27 11 80       	mov    %eax,0x801127bc
      release(&log.lock);
80102ec7:	68 80 27 11 80       	push   $0x80112780
80102ecc:	e8 df 19 00 00       	call   801048b0 <release>
      break;
    }
  }
}
80102ed1:	83 c4 10             	add    $0x10,%esp
80102ed4:	c9                   	leave  
80102ed5:	c3                   	ret    
80102ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102edd:	8d 76 00             	lea    0x0(%esi),%esi

80102ee0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102ee0:	55                   	push   %ebp
80102ee1:	89 e5                	mov    %esp,%ebp
80102ee3:	57                   	push   %edi
80102ee4:	56                   	push   %esi
80102ee5:	53                   	push   %ebx
80102ee6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102ee9:	68 80 27 11 80       	push   $0x80112780
80102eee:	e8 1d 1a 00 00       	call   80104910 <acquire>
  log.outstanding -= 1;
80102ef3:	a1 bc 27 11 80       	mov    0x801127bc,%eax
  if(log.committing)
80102ef8:	8b 35 c0 27 11 80    	mov    0x801127c0,%esi
80102efe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102f01:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102f04:	89 1d bc 27 11 80    	mov    %ebx,0x801127bc
  if(log.committing)
80102f0a:	85 f6                	test   %esi,%esi
80102f0c:	0f 85 22 01 00 00    	jne    80103034 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102f12:	85 db                	test   %ebx,%ebx
80102f14:	0f 85 f6 00 00 00    	jne    80103010 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102f1a:	c7 05 c0 27 11 80 01 	movl   $0x1,0x801127c0
80102f21:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102f24:	83 ec 0c             	sub    $0xc,%esp
80102f27:	68 80 27 11 80       	push   $0x80112780
80102f2c:	e8 7f 19 00 00       	call   801048b0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102f31:	8b 0d c8 27 11 80    	mov    0x801127c8,%ecx
80102f37:	83 c4 10             	add    $0x10,%esp
80102f3a:	85 c9                	test   %ecx,%ecx
80102f3c:	7f 42                	jg     80102f80 <end_op+0xa0>
    acquire(&log.lock);
80102f3e:	83 ec 0c             	sub    $0xc,%esp
80102f41:	68 80 27 11 80       	push   $0x80112780
80102f46:	e8 c5 19 00 00       	call   80104910 <acquire>
    wakeup(&log);
80102f4b:	c7 04 24 80 27 11 80 	movl   $0x80112780,(%esp)
    log.committing = 0;
80102f52:	c7 05 c0 27 11 80 00 	movl   $0x0,0x801127c0
80102f59:	00 00 00 
    wakeup(&log);
80102f5c:	e8 bf 12 00 00       	call   80104220 <wakeup>
    release(&log.lock);
80102f61:	c7 04 24 80 27 11 80 	movl   $0x80112780,(%esp)
80102f68:	e8 43 19 00 00       	call   801048b0 <release>
80102f6d:	83 c4 10             	add    $0x10,%esp
}
80102f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f73:	5b                   	pop    %ebx
80102f74:	5e                   	pop    %esi
80102f75:	5f                   	pop    %edi
80102f76:	5d                   	pop    %ebp
80102f77:	c3                   	ret    
80102f78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f7f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102f80:	a1 b4 27 11 80       	mov    0x801127b4,%eax
80102f85:	83 ec 08             	sub    $0x8,%esp
80102f88:	01 d8                	add    %ebx,%eax
80102f8a:	83 c0 01             	add    $0x1,%eax
80102f8d:	50                   	push   %eax
80102f8e:	ff 35 c4 27 11 80    	pushl  0x801127c4
80102f94:	e8 37 d1 ff ff       	call   801000d0 <bread>
80102f99:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f9b:	58                   	pop    %eax
80102f9c:	5a                   	pop    %edx
80102f9d:	ff 34 9d cc 27 11 80 	pushl  -0x7feed834(,%ebx,4)
80102fa4:	ff 35 c4 27 11 80    	pushl  0x801127c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102faa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fad:	e8 1e d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102fb2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fb5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102fb7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102fba:	68 00 02 00 00       	push   $0x200
80102fbf:	50                   	push   %eax
80102fc0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102fc3:	50                   	push   %eax
80102fc4:	e8 a7 1a 00 00       	call   80104a70 <memmove>
    bwrite(to);  // write the log
80102fc9:	89 34 24             	mov    %esi,(%esp)
80102fcc:	e8 df d1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102fd1:	89 3c 24             	mov    %edi,(%esp)
80102fd4:	e8 17 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102fd9:	89 34 24             	mov    %esi,(%esp)
80102fdc:	e8 0f d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102fe1:	83 c4 10             	add    $0x10,%esp
80102fe4:	3b 1d c8 27 11 80    	cmp    0x801127c8,%ebx
80102fea:	7c 94                	jl     80102f80 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102fec:	e8 7f fd ff ff       	call   80102d70 <write_head>
    install_trans(); // Now install writes to home locations
80102ff1:	e8 da fc ff ff       	call   80102cd0 <install_trans>
    log.lh.n = 0;
80102ff6:	c7 05 c8 27 11 80 00 	movl   $0x0,0x801127c8
80102ffd:	00 00 00 
    write_head();    // Erase the transaction from the log
80103000:	e8 6b fd ff ff       	call   80102d70 <write_head>
80103005:	e9 34 ff ff ff       	jmp    80102f3e <end_op+0x5e>
8010300a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103010:	83 ec 0c             	sub    $0xc,%esp
80103013:	68 80 27 11 80       	push   $0x80112780
80103018:	e8 03 12 00 00       	call   80104220 <wakeup>
  release(&log.lock);
8010301d:	c7 04 24 80 27 11 80 	movl   $0x80112780,(%esp)
80103024:	e8 87 18 00 00       	call   801048b0 <release>
80103029:	83 c4 10             	add    $0x10,%esp
}
8010302c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010302f:	5b                   	pop    %ebx
80103030:	5e                   	pop    %esi
80103031:	5f                   	pop    %edi
80103032:	5d                   	pop    %ebp
80103033:	c3                   	ret    
    panic("log.committing");
80103034:	83 ec 0c             	sub    $0xc,%esp
80103037:	68 a4 7d 10 80       	push   $0x80107da4
8010303c:	e8 3f d3 ff ff       	call   80100380 <panic>
80103041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103048:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010304f:	90                   	nop

80103050 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	53                   	push   %ebx
80103054:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103057:	8b 15 c8 27 11 80    	mov    0x801127c8,%edx
{
8010305d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103060:	83 fa 1d             	cmp    $0x1d,%edx
80103063:	0f 8f 85 00 00 00    	jg     801030ee <log_write+0x9e>
80103069:	a1 b8 27 11 80       	mov    0x801127b8,%eax
8010306e:	83 e8 01             	sub    $0x1,%eax
80103071:	39 c2                	cmp    %eax,%edx
80103073:	7d 79                	jge    801030ee <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103075:	a1 bc 27 11 80       	mov    0x801127bc,%eax
8010307a:	85 c0                	test   %eax,%eax
8010307c:	7e 7d                	jle    801030fb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010307e:	83 ec 0c             	sub    $0xc,%esp
80103081:	68 80 27 11 80       	push   $0x80112780
80103086:	e8 85 18 00 00       	call   80104910 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010308b:	8b 15 c8 27 11 80    	mov    0x801127c8,%edx
80103091:	83 c4 10             	add    $0x10,%esp
80103094:	85 d2                	test   %edx,%edx
80103096:	7e 4a                	jle    801030e2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103098:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010309b:	31 c0                	xor    %eax,%eax
8010309d:	eb 08                	jmp    801030a7 <log_write+0x57>
8010309f:	90                   	nop
801030a0:	83 c0 01             	add    $0x1,%eax
801030a3:	39 c2                	cmp    %eax,%edx
801030a5:	74 29                	je     801030d0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030a7:	39 0c 85 cc 27 11 80 	cmp    %ecx,-0x7feed834(,%eax,4)
801030ae:	75 f0                	jne    801030a0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801030b0:	89 0c 85 cc 27 11 80 	mov    %ecx,-0x7feed834(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801030b7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801030ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801030bd:	c7 45 08 80 27 11 80 	movl   $0x80112780,0x8(%ebp)
}
801030c4:	c9                   	leave  
  release(&log.lock);
801030c5:	e9 e6 17 00 00       	jmp    801048b0 <release>
801030ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801030d0:	89 0c 95 cc 27 11 80 	mov    %ecx,-0x7feed834(,%edx,4)
    log.lh.n++;
801030d7:	83 c2 01             	add    $0x1,%edx
801030da:	89 15 c8 27 11 80    	mov    %edx,0x801127c8
801030e0:	eb d5                	jmp    801030b7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
801030e2:	8b 43 08             	mov    0x8(%ebx),%eax
801030e5:	a3 cc 27 11 80       	mov    %eax,0x801127cc
  if (i == log.lh.n)
801030ea:	75 cb                	jne    801030b7 <log_write+0x67>
801030ec:	eb e9                	jmp    801030d7 <log_write+0x87>
    panic("too big a transaction");
801030ee:	83 ec 0c             	sub    $0xc,%esp
801030f1:	68 b3 7d 10 80       	push   $0x80107db3
801030f6:	e8 85 d2 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801030fb:	83 ec 0c             	sub    $0xc,%esp
801030fe:	68 c9 7d 10 80       	push   $0x80107dc9
80103103:	e8 78 d2 ff ff       	call   80100380 <panic>
80103108:	66 90                	xchg   %ax,%ax
8010310a:	66 90                	xchg   %ax,%ax
8010310c:	66 90                	xchg   %ax,%ax
8010310e:	66 90                	xchg   %ax,%ax

80103110 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103110:	55                   	push   %ebp
80103111:	89 e5                	mov    %esp,%ebp
80103113:	53                   	push   %ebx
80103114:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103117:	e8 54 09 00 00       	call   80103a70 <cpuid>
8010311c:	89 c3                	mov    %eax,%ebx
8010311e:	e8 4d 09 00 00       	call   80103a70 <cpuid>
80103123:	83 ec 04             	sub    $0x4,%esp
80103126:	53                   	push   %ebx
80103127:	50                   	push   %eax
80103128:	68 e4 7d 10 80       	push   $0x80107de4
8010312d:	e8 4e d5 ff ff       	call   80100680 <cprintf>
  idtinit();       // load idt register
80103132:	e8 f9 2e 00 00       	call   80106030 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103137:	e8 c4 08 00 00       	call   80103a00 <mycpu>
8010313c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010313e:	b8 01 00 00 00       	mov    $0x1,%eax
80103143:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010314a:	e8 01 0c 00 00       	call   80103d50 <scheduler>
8010314f:	90                   	nop

80103150 <mpenter>:
{
80103150:	55                   	push   %ebp
80103151:	89 e5                	mov    %esp,%ebp
80103153:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103156:	e8 e5 3f 00 00       	call   80107140 <switchkvm>
  seginit();
8010315b:	e8 50 3f 00 00       	call   801070b0 <seginit>
  lapicinit();
80103160:	e8 9b f7 ff ff       	call   80102900 <lapicinit>
  mpmain();
80103165:	e8 a6 ff ff ff       	call   80103110 <mpmain>
8010316a:	66 90                	xchg   %ax,%ax
8010316c:	66 90                	xchg   %ax,%ax
8010316e:	66 90                	xchg   %ax,%ax

80103170 <main>:
{
80103170:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103174:	83 e4 f0             	and    $0xfffffff0,%esp
80103177:	ff 71 fc             	pushl  -0x4(%ecx)
8010317a:	55                   	push   %ebp
8010317b:	89 e5                	mov    %esp,%ebp
8010317d:	53                   	push   %ebx
8010317e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010317f:	83 ec 08             	sub    $0x8,%esp
80103182:	68 00 00 40 80       	push   $0x80400000
80103187:	68 50 7b 11 80       	push   $0x80117b50
8010318c:	e8 8f f5 ff ff       	call   80102720 <kinit1>
  kvmalloc();      // kernel page table
80103191:	e8 9a 44 00 00       	call   80107630 <kvmalloc>
  mpinit();        // detect other processors
80103196:	e8 85 01 00 00       	call   80103320 <mpinit>
  lapicinit();     // interrupt controller
8010319b:	e8 60 f7 ff ff       	call   80102900 <lapicinit>
  seginit();       // segment descriptors
801031a0:	e8 0b 3f 00 00       	call   801070b0 <seginit>
  picinit();       // disable pic
801031a5:	e8 76 03 00 00       	call   80103520 <picinit>
  ioapicinit();    // another interrupt controller
801031aa:	e8 31 f3 ff ff       	call   801024e0 <ioapicinit>
  consoleinit();   // console hardware
801031af:	e8 cc d9 ff ff       	call   80100b80 <consoleinit>
  uartinit();      // serial port
801031b4:	e8 67 31 00 00       	call   80106320 <uartinit>
  pinit();         // process table
801031b9:	e8 22 08 00 00       	call   801039e0 <pinit>
  tvinit();        // trap vectors
801031be:	e8 ed 2d 00 00       	call   80105fb0 <tvinit>
  binit();         // buffer cache
801031c3:	e8 78 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
801031c8:	e8 63 dd ff ff       	call   80100f30 <fileinit>
  ideinit();       // disk 
801031cd:	e8 fe f0 ff ff       	call   801022d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801031d2:	83 c4 0c             	add    $0xc,%esp
801031d5:	68 8a 00 00 00       	push   $0x8a
801031da:	68 6c b5 10 80       	push   $0x8010b56c
801031df:	68 00 70 00 80       	push   $0x80007000
801031e4:	e8 87 18 00 00       	call   80104a70 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801031e9:	83 c4 10             	add    $0x10,%esp
801031ec:	69 05 64 28 11 80 b0 	imul   $0xb0,0x80112864,%eax
801031f3:	00 00 00 
801031f6:	05 80 28 11 80       	add    $0x80112880,%eax
801031fb:	3d 80 28 11 80       	cmp    $0x80112880,%eax
80103200:	76 7e                	jbe    80103280 <main+0x110>
80103202:	bb 80 28 11 80       	mov    $0x80112880,%ebx
80103207:	eb 20                	jmp    80103229 <main+0xb9>
80103209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103210:	69 05 64 28 11 80 b0 	imul   $0xb0,0x80112864,%eax
80103217:	00 00 00 
8010321a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103220:	05 80 28 11 80       	add    $0x80112880,%eax
80103225:	39 c3                	cmp    %eax,%ebx
80103227:	73 57                	jae    80103280 <main+0x110>
    if(c == mycpu())  // We've started already.
80103229:	e8 d2 07 00 00       	call   80103a00 <mycpu>
8010322e:	39 c3                	cmp    %eax,%ebx
80103230:	74 de                	je     80103210 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103232:	e8 59 f5 ff ff       	call   80102790 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103237:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010323a:	c7 05 f8 6f 00 80 50 	movl   $0x80103150,0x80006ff8
80103241:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103244:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010324b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010324e:	05 00 10 00 00       	add    $0x1000,%eax
80103253:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103258:	0f b6 03             	movzbl (%ebx),%eax
8010325b:	68 00 70 00 00       	push   $0x7000
80103260:	50                   	push   %eax
80103261:	e8 ea f7 ff ff       	call   80102a50 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103266:	83 c4 10             	add    $0x10,%esp
80103269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103270:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103276:	85 c0                	test   %eax,%eax
80103278:	74 f6                	je     80103270 <main+0x100>
8010327a:	eb 94                	jmp    80103210 <main+0xa0>
8010327c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103280:	83 ec 08             	sub    $0x8,%esp
80103283:	68 00 00 00 8e       	push   $0x8e000000
80103288:	68 00 00 40 80       	push   $0x80400000
8010328d:	e8 2e f4 ff ff       	call   801026c0 <kinit2>
  userinit();      // first user process
80103292:	e8 29 08 00 00       	call   80103ac0 <userinit>
  mpmain();        // finish this processor's setup
80103297:	e8 74 fe ff ff       	call   80103110 <mpmain>
8010329c:	66 90                	xchg   %ax,%ax
8010329e:	66 90                	xchg   %ax,%ax

801032a0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801032a0:	55                   	push   %ebp
801032a1:	89 e5                	mov    %esp,%ebp
801032a3:	57                   	push   %edi
801032a4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801032a5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801032ab:	53                   	push   %ebx
  e = addr+len;
801032ac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801032af:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801032b2:	39 de                	cmp    %ebx,%esi
801032b4:	72 10                	jb     801032c6 <mpsearch1+0x26>
801032b6:	eb 50                	jmp    80103308 <mpsearch1+0x68>
801032b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032bf:	90                   	nop
801032c0:	89 fe                	mov    %edi,%esi
801032c2:	39 fb                	cmp    %edi,%ebx
801032c4:	76 42                	jbe    80103308 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032c6:	83 ec 04             	sub    $0x4,%esp
801032c9:	8d 7e 10             	lea    0x10(%esi),%edi
801032cc:	6a 04                	push   $0x4
801032ce:	68 f8 7d 10 80       	push   $0x80107df8
801032d3:	56                   	push   %esi
801032d4:	e8 47 17 00 00       	call   80104a20 <memcmp>
801032d9:	83 c4 10             	add    $0x10,%esp
801032dc:	89 c2                	mov    %eax,%edx
801032de:	85 c0                	test   %eax,%eax
801032e0:	75 de                	jne    801032c0 <mpsearch1+0x20>
801032e2:	89 f0                	mov    %esi,%eax
801032e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801032e8:	0f b6 08             	movzbl (%eax),%ecx
  for(i=0; i<len; i++)
801032eb:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032ee:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032f0:	39 f8                	cmp    %edi,%eax
801032f2:	75 f4                	jne    801032e8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032f4:	84 d2                	test   %dl,%dl
801032f6:	75 c8                	jne    801032c0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801032f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032fb:	89 f0                	mov    %esi,%eax
801032fd:	5b                   	pop    %ebx
801032fe:	5e                   	pop    %esi
801032ff:	5f                   	pop    %edi
80103300:	5d                   	pop    %ebp
80103301:	c3                   	ret    
80103302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103308:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010330b:	31 f6                	xor    %esi,%esi
}
8010330d:	5b                   	pop    %ebx
8010330e:	89 f0                	mov    %esi,%eax
80103310:	5e                   	pop    %esi
80103311:	5f                   	pop    %edi
80103312:	5d                   	pop    %ebp
80103313:	c3                   	ret    
80103314:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010331b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010331f:	90                   	nop

80103320 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103320:	55                   	push   %ebp
80103321:	89 e5                	mov    %esp,%ebp
80103323:	57                   	push   %edi
80103324:	56                   	push   %esi
80103325:	53                   	push   %ebx
80103326:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103329:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103330:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103337:	c1 e0 08             	shl    $0x8,%eax
8010333a:	09 d0                	or     %edx,%eax
8010333c:	c1 e0 04             	shl    $0x4,%eax
8010333f:	75 1b                	jne    8010335c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103341:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103348:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010334f:	c1 e0 08             	shl    $0x8,%eax
80103352:	09 d0                	or     %edx,%eax
80103354:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103357:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010335c:	ba 00 04 00 00       	mov    $0x400,%edx
80103361:	e8 3a ff ff ff       	call   801032a0 <mpsearch1>
80103366:	89 c3                	mov    %eax,%ebx
80103368:	85 c0                	test   %eax,%eax
8010336a:	0f 84 40 01 00 00    	je     801034b0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103370:	8b 73 04             	mov    0x4(%ebx),%esi
80103373:	85 f6                	test   %esi,%esi
80103375:	0f 84 25 01 00 00    	je     801034a0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010337b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010337e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103384:	6a 04                	push   $0x4
80103386:	68 fd 7d 10 80       	push   $0x80107dfd
8010338b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010338c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010338f:	e8 8c 16 00 00       	call   80104a20 <memcmp>
80103394:	83 c4 10             	add    $0x10,%esp
80103397:	85 c0                	test   %eax,%eax
80103399:	0f 85 01 01 00 00    	jne    801034a0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010339f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801033a6:	3c 01                	cmp    $0x1,%al
801033a8:	74 08                	je     801033b2 <mpinit+0x92>
801033aa:	3c 04                	cmp    $0x4,%al
801033ac:	0f 85 ee 00 00 00    	jne    801034a0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801033b2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801033b9:	66 85 d2             	test   %dx,%dx
801033bc:	74 22                	je     801033e0 <mpinit+0xc0>
801033be:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801033c1:	89 f0                	mov    %esi,%eax
  sum = 0;
801033c3:	31 d2                	xor    %edx,%edx
801033c5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033c8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801033cf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801033d2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801033d4:	39 f8                	cmp    %edi,%eax
801033d6:	75 f0                	jne    801033c8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801033d8:	84 d2                	test   %dl,%dl
801033da:	0f 85 c0 00 00 00    	jne    801034a0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801033e0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801033e6:	a3 60 27 11 80       	mov    %eax,0x80112760
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033eb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801033f2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801033f8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033fd:	03 55 e4             	add    -0x1c(%ebp),%edx
80103400:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103403:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103407:	90                   	nop
80103408:	39 d0                	cmp    %edx,%eax
8010340a:	73 15                	jae    80103421 <mpinit+0x101>
    switch(*p){
8010340c:	0f b6 08             	movzbl (%eax),%ecx
8010340f:	80 f9 02             	cmp    $0x2,%cl
80103412:	74 4c                	je     80103460 <mpinit+0x140>
80103414:	77 3a                	ja     80103450 <mpinit+0x130>
80103416:	84 c9                	test   %cl,%cl
80103418:	74 56                	je     80103470 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010341a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010341d:	39 d0                	cmp    %edx,%eax
8010341f:	72 eb                	jb     8010340c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103421:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103424:	85 f6                	test   %esi,%esi
80103426:	0f 84 d9 00 00 00    	je     80103505 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010342c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103430:	74 15                	je     80103447 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103432:	b8 70 00 00 00       	mov    $0x70,%eax
80103437:	ba 22 00 00 00       	mov    $0x22,%edx
8010343c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010343d:	ba 23 00 00 00       	mov    $0x23,%edx
80103442:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103443:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103446:	ee                   	out    %al,(%dx)
  }
}
80103447:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010344a:	5b                   	pop    %ebx
8010344b:	5e                   	pop    %esi
8010344c:	5f                   	pop    %edi
8010344d:	5d                   	pop    %ebp
8010344e:	c3                   	ret    
8010344f:	90                   	nop
    switch(*p){
80103450:	83 e9 03             	sub    $0x3,%ecx
80103453:	80 f9 01             	cmp    $0x1,%cl
80103456:	76 c2                	jbe    8010341a <mpinit+0xfa>
80103458:	31 f6                	xor    %esi,%esi
8010345a:	eb ac                	jmp    80103408 <mpinit+0xe8>
8010345c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103460:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103464:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103467:	88 0d 60 28 11 80    	mov    %cl,0x80112860
      continue;
8010346d:	eb 99                	jmp    80103408 <mpinit+0xe8>
8010346f:	90                   	nop
      if(ncpu < NCPU) {
80103470:	8b 0d 64 28 11 80    	mov    0x80112864,%ecx
80103476:	83 f9 07             	cmp    $0x7,%ecx
80103479:	7f 19                	jg     80103494 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010347b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103481:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103485:	83 c1 01             	add    $0x1,%ecx
80103488:	89 0d 64 28 11 80    	mov    %ecx,0x80112864
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010348e:	88 9f 80 28 11 80    	mov    %bl,-0x7feed780(%edi)
      p += sizeof(struct mpproc);
80103494:	83 c0 14             	add    $0x14,%eax
      continue;
80103497:	e9 6c ff ff ff       	jmp    80103408 <mpinit+0xe8>
8010349c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801034a0:	83 ec 0c             	sub    $0xc,%esp
801034a3:	68 02 7e 10 80       	push   $0x80107e02
801034a8:	e8 d3 ce ff ff       	call   80100380 <panic>
801034ad:	8d 76 00             	lea    0x0(%esi),%esi
{
801034b0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801034b5:	eb 13                	jmp    801034ca <mpinit+0x1aa>
801034b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034be:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801034c0:	89 f3                	mov    %esi,%ebx
801034c2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801034c8:	74 d6                	je     801034a0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034ca:	83 ec 04             	sub    $0x4,%esp
801034cd:	8d 73 10             	lea    0x10(%ebx),%esi
801034d0:	6a 04                	push   $0x4
801034d2:	68 f8 7d 10 80       	push   $0x80107df8
801034d7:	53                   	push   %ebx
801034d8:	e8 43 15 00 00       	call   80104a20 <memcmp>
801034dd:	83 c4 10             	add    $0x10,%esp
801034e0:	89 c2                	mov    %eax,%edx
801034e2:	85 c0                	test   %eax,%eax
801034e4:	75 da                	jne    801034c0 <mpinit+0x1a0>
801034e6:	89 d8                	mov    %ebx,%eax
801034e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034ef:	90                   	nop
    sum += addr[i];
801034f0:	0f b6 08             	movzbl (%eax),%ecx
  for(i=0; i<len; i++)
801034f3:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801034f6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801034f8:	39 f0                	cmp    %esi,%eax
801034fa:	75 f4                	jne    801034f0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034fc:	84 d2                	test   %dl,%dl
801034fe:	75 c0                	jne    801034c0 <mpinit+0x1a0>
80103500:	e9 6b fe ff ff       	jmp    80103370 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103505:	83 ec 0c             	sub    $0xc,%esp
80103508:	68 1c 7e 10 80       	push   $0x80107e1c
8010350d:	e8 6e ce ff ff       	call   80100380 <panic>
80103512:	66 90                	xchg   %ax,%ax
80103514:	66 90                	xchg   %ax,%ax
80103516:	66 90                	xchg   %ax,%ax
80103518:	66 90                	xchg   %ax,%ax
8010351a:	66 90                	xchg   %ax,%ax
8010351c:	66 90                	xchg   %ax,%ax
8010351e:	66 90                	xchg   %ax,%ax

80103520 <picinit>:
80103520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103525:	ba 21 00 00 00       	mov    $0x21,%edx
8010352a:	ee                   	out    %al,(%dx)
8010352b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103530:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103531:	c3                   	ret    
80103532:	66 90                	xchg   %ax,%ax
80103534:	66 90                	xchg   %ax,%ax
80103536:	66 90                	xchg   %ax,%ax
80103538:	66 90                	xchg   %ax,%ax
8010353a:	66 90                	xchg   %ax,%ax
8010353c:	66 90                	xchg   %ax,%ax
8010353e:	66 90                	xchg   %ax,%ax

80103540 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	57                   	push   %edi
80103544:	56                   	push   %esi
80103545:	53                   	push   %ebx
80103546:	83 ec 0c             	sub    $0xc,%esp
80103549:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010354c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010354f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103555:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010355b:	e8 f0 d9 ff ff       	call   80100f50 <filealloc>
80103560:	89 03                	mov    %eax,(%ebx)
80103562:	85 c0                	test   %eax,%eax
80103564:	0f 84 a8 00 00 00    	je     80103612 <pipealloc+0xd2>
8010356a:	e8 e1 d9 ff ff       	call   80100f50 <filealloc>
8010356f:	89 06                	mov    %eax,(%esi)
80103571:	85 c0                	test   %eax,%eax
80103573:	0f 84 87 00 00 00    	je     80103600 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103579:	e8 12 f2 ff ff       	call   80102790 <kalloc>
8010357e:	89 c7                	mov    %eax,%edi
80103580:	85 c0                	test   %eax,%eax
80103582:	0f 84 b0 00 00 00    	je     80103638 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103588:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010358f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103592:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103595:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010359c:	00 00 00 
  p->nwrite = 0;
8010359f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801035a6:	00 00 00 
  p->nread = 0;
801035a9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801035b0:	00 00 00 
  initlock(&p->lock, "pipe");
801035b3:	68 f8 7f 10 80       	push   $0x80107ff8
801035b8:	50                   	push   %eax
801035b9:	e8 82 11 00 00       	call   80104740 <initlock>
  (*f0)->type = FD_PIPE;
801035be:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801035c0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801035c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801035c9:	8b 03                	mov    (%ebx),%eax
801035cb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801035cf:	8b 03                	mov    (%ebx),%eax
801035d1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801035d5:	8b 03                	mov    (%ebx),%eax
801035d7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801035da:	8b 06                	mov    (%esi),%eax
801035dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801035e2:	8b 06                	mov    (%esi),%eax
801035e4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801035e8:	8b 06                	mov    (%esi),%eax
801035ea:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801035ee:	8b 06                	mov    (%esi),%eax
801035f0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801035f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801035f6:	31 c0                	xor    %eax,%eax
}
801035f8:	5b                   	pop    %ebx
801035f9:	5e                   	pop    %esi
801035fa:	5f                   	pop    %edi
801035fb:	5d                   	pop    %ebp
801035fc:	c3                   	ret    
801035fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103600:	8b 03                	mov    (%ebx),%eax
80103602:	85 c0                	test   %eax,%eax
80103604:	74 1e                	je     80103624 <pipealloc+0xe4>
    fileclose(*f0);
80103606:	83 ec 0c             	sub    $0xc,%esp
80103609:	50                   	push   %eax
8010360a:	e8 01 da ff ff       	call   80101010 <fileclose>
8010360f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103612:	8b 06                	mov    (%esi),%eax
80103614:	85 c0                	test   %eax,%eax
80103616:	74 0c                	je     80103624 <pipealloc+0xe4>
    fileclose(*f1);
80103618:	83 ec 0c             	sub    $0xc,%esp
8010361b:	50                   	push   %eax
8010361c:	e8 ef d9 ff ff       	call   80101010 <fileclose>
80103621:	83 c4 10             	add    $0x10,%esp
}
80103624:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103627:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010362c:	5b                   	pop    %ebx
8010362d:	5e                   	pop    %esi
8010362e:	5f                   	pop    %edi
8010362f:	5d                   	pop    %ebp
80103630:	c3                   	ret    
80103631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103638:	8b 03                	mov    (%ebx),%eax
8010363a:	85 c0                	test   %eax,%eax
8010363c:	75 c8                	jne    80103606 <pipealloc+0xc6>
8010363e:	eb d2                	jmp    80103612 <pipealloc+0xd2>

80103640 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	56                   	push   %esi
80103644:	53                   	push   %ebx
80103645:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103648:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010364b:	83 ec 0c             	sub    $0xc,%esp
8010364e:	53                   	push   %ebx
8010364f:	e8 bc 12 00 00       	call   80104910 <acquire>
  if(writable){
80103654:	83 c4 10             	add    $0x10,%esp
80103657:	85 f6                	test   %esi,%esi
80103659:	74 65                	je     801036c0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010365b:	83 ec 0c             	sub    $0xc,%esp
8010365e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103664:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010366b:	00 00 00 
    wakeup(&p->nread);
8010366e:	50                   	push   %eax
8010366f:	e8 ac 0b 00 00       	call   80104220 <wakeup>
80103674:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103677:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010367d:	85 d2                	test   %edx,%edx
8010367f:	75 0a                	jne    8010368b <pipeclose+0x4b>
80103681:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103687:	85 c0                	test   %eax,%eax
80103689:	74 15                	je     801036a0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010368b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010368e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103691:	5b                   	pop    %ebx
80103692:	5e                   	pop    %esi
80103693:	5d                   	pop    %ebp
    release(&p->lock);
80103694:	e9 17 12 00 00       	jmp    801048b0 <release>
80103699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801036a0:	83 ec 0c             	sub    $0xc,%esp
801036a3:	53                   	push   %ebx
801036a4:	e8 07 12 00 00       	call   801048b0 <release>
    kfree((char*)p);
801036a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801036ac:	83 c4 10             	add    $0x10,%esp
}
801036af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036b2:	5b                   	pop    %ebx
801036b3:	5e                   	pop    %esi
801036b4:	5d                   	pop    %ebp
    kfree((char*)p);
801036b5:	e9 16 ef ff ff       	jmp    801025d0 <kfree>
801036ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801036c0:	83 ec 0c             	sub    $0xc,%esp
801036c3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801036c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801036d0:	00 00 00 
    wakeup(&p->nwrite);
801036d3:	50                   	push   %eax
801036d4:	e8 47 0b 00 00       	call   80104220 <wakeup>
801036d9:	83 c4 10             	add    $0x10,%esp
801036dc:	eb 99                	jmp    80103677 <pipeclose+0x37>
801036de:	66 90                	xchg   %ax,%ax

801036e0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	57                   	push   %edi
801036e4:	56                   	push   %esi
801036e5:	53                   	push   %ebx
801036e6:	83 ec 28             	sub    $0x28,%esp
801036e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801036ec:	53                   	push   %ebx
801036ed:	e8 1e 12 00 00       	call   80104910 <acquire>
  for(i = 0; i < n; i++){
801036f2:	8b 45 10             	mov    0x10(%ebp),%eax
801036f5:	83 c4 10             	add    $0x10,%esp
801036f8:	85 c0                	test   %eax,%eax
801036fa:	0f 8e c0 00 00 00    	jle    801037c0 <pipewrite+0xe0>
80103700:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103703:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103709:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010370f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103712:	03 45 10             	add    0x10(%ebp),%eax
80103715:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103718:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010371e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103724:	89 ca                	mov    %ecx,%edx
80103726:	05 00 02 00 00       	add    $0x200,%eax
8010372b:	39 c1                	cmp    %eax,%ecx
8010372d:	74 3f                	je     8010376e <pipewrite+0x8e>
8010372f:	eb 67                	jmp    80103798 <pipewrite+0xb8>
80103731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103738:	e8 53 03 00 00       	call   80103a90 <myproc>
8010373d:	8b 48 24             	mov    0x24(%eax),%ecx
80103740:	85 c9                	test   %ecx,%ecx
80103742:	75 34                	jne    80103778 <pipewrite+0x98>
      wakeup(&p->nread);
80103744:	83 ec 0c             	sub    $0xc,%esp
80103747:	57                   	push   %edi
80103748:	e8 d3 0a 00 00       	call   80104220 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010374d:	58                   	pop    %eax
8010374e:	5a                   	pop    %edx
8010374f:	53                   	push   %ebx
80103750:	56                   	push   %esi
80103751:	e8 0a 0a 00 00       	call   80104160 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103756:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010375c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103762:	83 c4 10             	add    $0x10,%esp
80103765:	05 00 02 00 00       	add    $0x200,%eax
8010376a:	39 c2                	cmp    %eax,%edx
8010376c:	75 2a                	jne    80103798 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010376e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103774:	85 c0                	test   %eax,%eax
80103776:	75 c0                	jne    80103738 <pipewrite+0x58>
        release(&p->lock);
80103778:	83 ec 0c             	sub    $0xc,%esp
8010377b:	53                   	push   %ebx
8010377c:	e8 2f 11 00 00       	call   801048b0 <release>
        return -1;
80103781:	83 c4 10             	add    $0x10,%esp
80103784:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103789:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010378c:	5b                   	pop    %ebx
8010378d:	5e                   	pop    %esi
8010378e:	5f                   	pop    %edi
8010378f:	5d                   	pop    %ebp
80103790:	c3                   	ret    
80103791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103798:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010379b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010379e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801037a4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801037aa:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801037ad:	83 c6 01             	add    $0x1,%esi
801037b0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037b3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801037b7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801037ba:	0f 85 58 ff ff ff    	jne    80103718 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801037c0:	83 ec 0c             	sub    $0xc,%esp
801037c3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801037c9:	50                   	push   %eax
801037ca:	e8 51 0a 00 00       	call   80104220 <wakeup>
  release(&p->lock);
801037cf:	89 1c 24             	mov    %ebx,(%esp)
801037d2:	e8 d9 10 00 00       	call   801048b0 <release>
  return n;
801037d7:	8b 45 10             	mov    0x10(%ebp),%eax
801037da:	83 c4 10             	add    $0x10,%esp
801037dd:	eb aa                	jmp    80103789 <pipewrite+0xa9>
801037df:	90                   	nop

801037e0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	57                   	push   %edi
801037e4:	56                   	push   %esi
801037e5:	53                   	push   %ebx
801037e6:	83 ec 18             	sub    $0x18,%esp
801037e9:	8b 75 08             	mov    0x8(%ebp),%esi
801037ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801037ef:	56                   	push   %esi
801037f0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801037f6:	e8 15 11 00 00       	call   80104910 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037fb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103801:	83 c4 10             	add    $0x10,%esp
80103804:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010380a:	74 2f                	je     8010383b <piperead+0x5b>
8010380c:	eb 37                	jmp    80103845 <piperead+0x65>
8010380e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103810:	e8 7b 02 00 00       	call   80103a90 <myproc>
80103815:	8b 48 24             	mov    0x24(%eax),%ecx
80103818:	85 c9                	test   %ecx,%ecx
8010381a:	0f 85 80 00 00 00    	jne    801038a0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103820:	83 ec 08             	sub    $0x8,%esp
80103823:	56                   	push   %esi
80103824:	53                   	push   %ebx
80103825:	e8 36 09 00 00       	call   80104160 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010382a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103830:	83 c4 10             	add    $0x10,%esp
80103833:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103839:	75 0a                	jne    80103845 <piperead+0x65>
8010383b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103841:	85 c0                	test   %eax,%eax
80103843:	75 cb                	jne    80103810 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103845:	8b 55 10             	mov    0x10(%ebp),%edx
80103848:	31 db                	xor    %ebx,%ebx
8010384a:	85 d2                	test   %edx,%edx
8010384c:	7f 20                	jg     8010386e <piperead+0x8e>
8010384e:	eb 2c                	jmp    8010387c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103850:	8d 48 01             	lea    0x1(%eax),%ecx
80103853:	25 ff 01 00 00       	and    $0x1ff,%eax
80103858:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010385e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103863:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103866:	83 c3 01             	add    $0x1,%ebx
80103869:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010386c:	74 0e                	je     8010387c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010386e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103874:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010387a:	75 d4                	jne    80103850 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010387c:	83 ec 0c             	sub    $0xc,%esp
8010387f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103885:	50                   	push   %eax
80103886:	e8 95 09 00 00       	call   80104220 <wakeup>
  release(&p->lock);
8010388b:	89 34 24             	mov    %esi,(%esp)
8010388e:	e8 1d 10 00 00       	call   801048b0 <release>
  return i;
80103893:	83 c4 10             	add    $0x10,%esp
}
80103896:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103899:	89 d8                	mov    %ebx,%eax
8010389b:	5b                   	pop    %ebx
8010389c:	5e                   	pop    %esi
8010389d:	5f                   	pop    %edi
8010389e:	5d                   	pop    %ebp
8010389f:	c3                   	ret    
      release(&p->lock);
801038a0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801038a3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801038a8:	56                   	push   %esi
801038a9:	e8 02 10 00 00       	call   801048b0 <release>
      return -1;
801038ae:	83 c4 10             	add    $0x10,%esp
}
801038b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038b4:	89 d8                	mov    %ebx,%eax
801038b6:	5b                   	pop    %ebx
801038b7:	5e                   	pop    %esi
801038b8:	5f                   	pop    %edi
801038b9:	5d                   	pop    %ebp
801038ba:	c3                   	ret    
801038bb:	66 90                	xchg   %ax,%ax
801038bd:	66 90                	xchg   %ax,%ax
801038bf:	90                   	nop

801038c0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038c4:	bb 34 2e 11 80       	mov    $0x80112e34,%ebx
{
801038c9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801038cc:	68 00 2e 11 80       	push   $0x80112e00
801038d1:	e8 3a 10 00 00       	call   80104910 <acquire>
801038d6:	83 c4 10             	add    $0x10,%esp
801038d9:	eb 10                	jmp    801038eb <allocproc+0x2b>
801038db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038df:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038e0:	83 c3 7c             	add    $0x7c,%ebx
801038e3:	81 fb 34 4d 11 80    	cmp    $0x80114d34,%ebx
801038e9:	74 75                	je     80103960 <allocproc+0xa0>
    if(p->state == UNUSED)
801038eb:	8b 43 0c             	mov    0xc(%ebx),%eax
801038ee:	85 c0                	test   %eax,%eax
801038f0:	75 ee                	jne    801038e0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801038f2:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
801038f7:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801038fa:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103901:	89 43 10             	mov    %eax,0x10(%ebx)
80103904:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103907:	68 00 2e 11 80       	push   $0x80112e00
  p->pid = nextpid++;
8010390c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103912:	e8 99 0f 00 00       	call   801048b0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103917:	e8 74 ee ff ff       	call   80102790 <kalloc>
8010391c:	83 c4 10             	add    $0x10,%esp
8010391f:	89 43 08             	mov    %eax,0x8(%ebx)
80103922:	85 c0                	test   %eax,%eax
80103924:	74 53                	je     80103979 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103926:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010392c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010392f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103934:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103937:	c7 40 14 9a 5f 10 80 	movl   $0x80105f9a,0x14(%eax)
  p->context = (struct context*)sp;
8010393e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103941:	6a 14                	push   $0x14
80103943:	6a 00                	push   $0x0
80103945:	50                   	push   %eax
80103946:	e8 85 10 00 00       	call   801049d0 <memset>
  p->context->eip = (uint)forkret;
8010394b:	8b 43 1c             	mov    0x1c(%ebx),%eax
  // p->shared_memory = kalloc();
  // p->is_message = 0;
  // p->msg_count = 0;
  // initlock(&p->lock, "proc");

  return p;
8010394e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103951:	c7 40 10 90 39 10 80 	movl   $0x80103990,0x10(%eax)
}
80103958:	89 d8                	mov    %ebx,%eax
8010395a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010395d:	c9                   	leave  
8010395e:	c3                   	ret    
8010395f:	90                   	nop
  release(&ptable.lock);
80103960:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103963:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103965:	68 00 2e 11 80       	push   $0x80112e00
8010396a:	e8 41 0f 00 00       	call   801048b0 <release>
}
8010396f:	89 d8                	mov    %ebx,%eax
  return 0;
80103971:	83 c4 10             	add    $0x10,%esp
}
80103974:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103977:	c9                   	leave  
80103978:	c3                   	ret    
    p->state = UNUSED;
80103979:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103980:	31 db                	xor    %ebx,%ebx
}
80103982:	89 d8                	mov    %ebx,%eax
80103984:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103987:	c9                   	leave  
80103988:	c3                   	ret    
80103989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103990 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103996:	68 00 2e 11 80       	push   $0x80112e00
8010399b:	e8 10 0f 00 00       	call   801048b0 <release>

  if (first) {
801039a0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801039a5:	83 c4 10             	add    $0x10,%esp
801039a8:	85 c0                	test   %eax,%eax
801039aa:	75 04                	jne    801039b0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801039ac:	c9                   	leave  
801039ad:	c3                   	ret    
801039ae:	66 90                	xchg   %ax,%ax
    first = 0;
801039b0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801039b7:	00 00 00 
    iinit(ROOTDEV);
801039ba:	83 ec 0c             	sub    $0xc,%esp
801039bd:	6a 01                	push   $0x1
801039bf:	e8 ac dc ff ff       	call   80101670 <iinit>
    initlog(ROOTDEV);
801039c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801039cb:	e8 00 f4 ff ff       	call   80102dd0 <initlog>
}
801039d0:	83 c4 10             	add    $0x10,%esp
801039d3:	c9                   	leave  
801039d4:	c3                   	ret    
801039d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801039e0 <pinit>:
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801039e6:	68 3b 7e 10 80       	push   $0x80107e3b
801039eb:	68 00 2e 11 80       	push   $0x80112e00
801039f0:	e8 4b 0d 00 00       	call   80104740 <initlock>
}
801039f5:	83 c4 10             	add    $0x10,%esp
801039f8:	c9                   	leave  
801039f9:	c3                   	ret    
801039fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a00 <mycpu>:
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	56                   	push   %esi
80103a04:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a05:	9c                   	pushf  
80103a06:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a07:	f6 c4 02             	test   $0x2,%ah
80103a0a:	75 4e                	jne    80103a5a <mycpu+0x5a>
  apicid = lapicid();
80103a0c:	e8 ef ef ff ff       	call   80102a00 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103a11:	8b 35 64 28 11 80    	mov    0x80112864,%esi
  apicid = lapicid();
80103a17:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
80103a19:	85 f6                	test   %esi,%esi
80103a1b:	7e 30                	jle    80103a4d <mycpu+0x4d>
80103a1d:	31 c0                	xor    %eax,%eax
80103a1f:	eb 0e                	jmp    80103a2f <mycpu+0x2f>
80103a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a28:	83 c0 01             	add    $0x1,%eax
80103a2b:	39 f0                	cmp    %esi,%eax
80103a2d:	74 1e                	je     80103a4d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103a2f:	69 d0 b0 00 00 00    	imul   $0xb0,%eax,%edx
80103a35:	0f b6 8a 80 28 11 80 	movzbl -0x7feed780(%edx),%ecx
80103a3c:	39 d9                	cmp    %ebx,%ecx
80103a3e:	75 e8                	jne    80103a28 <mycpu+0x28>
}
80103a40:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103a43:	8d 82 80 28 11 80    	lea    -0x7feed780(%edx),%eax
}
80103a49:	5b                   	pop    %ebx
80103a4a:	5e                   	pop    %esi
80103a4b:	5d                   	pop    %ebp
80103a4c:	c3                   	ret    
  panic("unknown apicid\n");
80103a4d:	83 ec 0c             	sub    $0xc,%esp
80103a50:	68 42 7e 10 80       	push   $0x80107e42
80103a55:	e8 26 c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a5a:	83 ec 0c             	sub    $0xc,%esp
80103a5d:	68 44 7f 10 80       	push   $0x80107f44
80103a62:	e8 19 c9 ff ff       	call   80100380 <panic>
80103a67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a6e:	66 90                	xchg   %ax,%ax

80103a70 <cpuid>:
cpuid() {
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a76:	e8 85 ff ff ff       	call   80103a00 <mycpu>
}
80103a7b:	c9                   	leave  
  return mycpu()-cpus;
80103a7c:	2d 80 28 11 80       	sub    $0x80112880,%eax
80103a81:	c1 f8 04             	sar    $0x4,%eax
80103a84:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a8a:	c3                   	ret    
80103a8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a8f:	90                   	nop

80103a90 <myproc>:
myproc(void) {
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	53                   	push   %ebx
80103a94:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a97:	e8 24 0d 00 00       	call   801047c0 <pushcli>
  c = mycpu();
80103a9c:	e8 5f ff ff ff       	call   80103a00 <mycpu>
  p = c->proc;
80103aa1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103aa7:	e8 64 0d 00 00       	call   80104810 <popcli>
}
80103aac:	89 d8                	mov    %ebx,%eax
80103aae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ab1:	c9                   	leave  
80103ab2:	c3                   	ret    
80103ab3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ac0 <userinit>:
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	53                   	push   %ebx
80103ac4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103ac7:	e8 f4 fd ff ff       	call   801038c0 <allocproc>
80103acc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103ace:	a3 40 62 11 80       	mov    %eax,0x80116240
  if((p->pgdir = setupkvm()) == 0)
80103ad3:	e8 d8 3a 00 00       	call   801075b0 <setupkvm>
80103ad8:	89 43 04             	mov    %eax,0x4(%ebx)
80103adb:	85 c0                	test   %eax,%eax
80103add:	0f 84 bd 00 00 00    	je     80103ba0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103ae3:	83 ec 04             	sub    $0x4,%esp
80103ae6:	68 2c 00 00 00       	push   $0x2c
80103aeb:	68 40 b5 10 80       	push   $0x8010b540
80103af0:	50                   	push   %eax
80103af1:	e8 6a 37 00 00       	call   80107260 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103af6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103af9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103aff:	6a 4c                	push   $0x4c
80103b01:	6a 00                	push   $0x0
80103b03:	ff 73 18             	pushl  0x18(%ebx)
80103b06:	e8 c5 0e 00 00       	call   801049d0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b0b:	8b 43 18             	mov    0x18(%ebx),%eax
80103b0e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b13:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b16:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b1b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b1f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b22:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b26:	8b 43 18             	mov    0x18(%ebx),%eax
80103b29:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b2d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b31:	8b 43 18             	mov    0x18(%ebx),%eax
80103b34:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b38:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b3c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b3f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b46:	8b 43 18             	mov    0x18(%ebx),%eax
80103b49:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b50:	8b 43 18             	mov    0x18(%ebx),%eax
80103b53:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b5a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b5d:	6a 10                	push   $0x10
80103b5f:	68 6b 7e 10 80       	push   $0x80107e6b
80103b64:	50                   	push   %eax
80103b65:	e8 26 10 00 00       	call   80104b90 <safestrcpy>
  p->cwd = namei("/");
80103b6a:	c7 04 24 74 7e 10 80 	movl   $0x80107e74,(%esp)
80103b71:	e8 3a e6 ff ff       	call   801021b0 <namei>
80103b76:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b79:	c7 04 24 00 2e 11 80 	movl   $0x80112e00,(%esp)
80103b80:	e8 8b 0d 00 00       	call   80104910 <acquire>
  p->state = RUNNABLE;
80103b85:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b8c:	c7 04 24 00 2e 11 80 	movl   $0x80112e00,(%esp)
80103b93:	e8 18 0d 00 00       	call   801048b0 <release>
}
80103b98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b9b:	83 c4 10             	add    $0x10,%esp
80103b9e:	c9                   	leave  
80103b9f:	c3                   	ret    
    panic("userinit: out of memory?");
80103ba0:	83 ec 0c             	sub    $0xc,%esp
80103ba3:	68 52 7e 10 80       	push   $0x80107e52
80103ba8:	e8 d3 c7 ff ff       	call   80100380 <panic>
80103bad:	8d 76 00             	lea    0x0(%esi),%esi

80103bb0 <growproc>:
{
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	56                   	push   %esi
80103bb4:	53                   	push   %ebx
80103bb5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103bb8:	e8 03 0c 00 00       	call   801047c0 <pushcli>
  c = mycpu();
80103bbd:	e8 3e fe ff ff       	call   80103a00 <mycpu>
  p = c->proc;
80103bc2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bc8:	e8 43 0c 00 00       	call   80104810 <popcli>
  sz = curproc->sz;
80103bcd:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103bcf:	85 f6                	test   %esi,%esi
80103bd1:	7f 1d                	jg     80103bf0 <growproc+0x40>
  } else if(n < 0){
80103bd3:	75 3b                	jne    80103c10 <growproc+0x60>
  switchuvm(curproc);
80103bd5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103bd8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103bda:	53                   	push   %ebx
80103bdb:	e8 70 35 00 00       	call   80107150 <switchuvm>
  return 0;
80103be0:	83 c4 10             	add    $0x10,%esp
80103be3:	31 c0                	xor    %eax,%eax
}
80103be5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103be8:	5b                   	pop    %ebx
80103be9:	5e                   	pop    %esi
80103bea:	5d                   	pop    %ebp
80103beb:	c3                   	ret    
80103bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103bf0:	83 ec 04             	sub    $0x4,%esp
80103bf3:	01 c6                	add    %eax,%esi
80103bf5:	56                   	push   %esi
80103bf6:	50                   	push   %eax
80103bf7:	ff 73 04             	pushl  0x4(%ebx)
80103bfa:	e8 d1 37 00 00       	call   801073d0 <allocuvm>
80103bff:	83 c4 10             	add    $0x10,%esp
80103c02:	85 c0                	test   %eax,%eax
80103c04:	75 cf                	jne    80103bd5 <growproc+0x25>
      return -1;
80103c06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c0b:	eb d8                	jmp    80103be5 <growproc+0x35>
80103c0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c10:	83 ec 04             	sub    $0x4,%esp
80103c13:	01 c6                	add    %eax,%esi
80103c15:	56                   	push   %esi
80103c16:	50                   	push   %eax
80103c17:	ff 73 04             	pushl  0x4(%ebx)
80103c1a:	e8 e1 38 00 00       	call   80107500 <deallocuvm>
80103c1f:	83 c4 10             	add    $0x10,%esp
80103c22:	85 c0                	test   %eax,%eax
80103c24:	75 af                	jne    80103bd5 <growproc+0x25>
80103c26:	eb de                	jmp    80103c06 <growproc+0x56>
80103c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c2f:	90                   	nop

80103c30 <fork>:
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	57                   	push   %edi
80103c34:	56                   	push   %esi
80103c35:	53                   	push   %ebx
80103c36:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c39:	e8 82 0b 00 00       	call   801047c0 <pushcli>
  c = mycpu();
80103c3e:	e8 bd fd ff ff       	call   80103a00 <mycpu>
  p = c->proc;
80103c43:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c49:	e8 c2 0b 00 00       	call   80104810 <popcli>
  if((np = allocproc()) == 0){
80103c4e:	e8 6d fc ff ff       	call   801038c0 <allocproc>
80103c53:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c56:	85 c0                	test   %eax,%eax
80103c58:	0f 84 b7 00 00 00    	je     80103d15 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c5e:	83 ec 08             	sub    $0x8,%esp
80103c61:	ff 33                	pushl  (%ebx)
80103c63:	89 c7                	mov    %eax,%edi
80103c65:	ff 73 04             	pushl  0x4(%ebx)
80103c68:	e8 33 3a 00 00       	call   801076a0 <copyuvm>
80103c6d:	83 c4 10             	add    $0x10,%esp
80103c70:	89 47 04             	mov    %eax,0x4(%edi)
80103c73:	85 c0                	test   %eax,%eax
80103c75:	0f 84 a1 00 00 00    	je     80103d1c <fork+0xec>
  np->sz = curproc->sz;
80103c7b:	8b 03                	mov    (%ebx),%eax
80103c7d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103c80:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103c82:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103c85:	89 c8                	mov    %ecx,%eax
80103c87:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103c8a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103c8f:	8b 73 18             	mov    0x18(%ebx),%esi
80103c92:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103c94:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103c96:	8b 40 18             	mov    0x18(%eax),%eax
80103c99:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103ca0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ca4:	85 c0                	test   %eax,%eax
80103ca6:	74 13                	je     80103cbb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103ca8:	83 ec 0c             	sub    $0xc,%esp
80103cab:	50                   	push   %eax
80103cac:	e8 0f d3 ff ff       	call   80100fc0 <filedup>
80103cb1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103cb4:	83 c4 10             	add    $0x10,%esp
80103cb7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103cbb:	83 c6 01             	add    $0x1,%esi
80103cbe:	83 fe 10             	cmp    $0x10,%esi
80103cc1:	75 dd                	jne    80103ca0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103cc3:	83 ec 0c             	sub    $0xc,%esp
80103cc6:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cc9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103ccc:	e8 8f db ff ff       	call   80101860 <idup>
80103cd1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cd4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103cd7:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cda:	8d 47 6c             	lea    0x6c(%edi),%eax
80103cdd:	6a 10                	push   $0x10
80103cdf:	53                   	push   %ebx
80103ce0:	50                   	push   %eax
80103ce1:	e8 aa 0e 00 00       	call   80104b90 <safestrcpy>
  pid = np->pid;
80103ce6:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103ce9:	c7 04 24 00 2e 11 80 	movl   $0x80112e00,(%esp)
80103cf0:	e8 1b 0c 00 00       	call   80104910 <acquire>
  np->state = RUNNABLE;
80103cf5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103cfc:	c7 04 24 00 2e 11 80 	movl   $0x80112e00,(%esp)
80103d03:	e8 a8 0b 00 00       	call   801048b0 <release>
  return pid;
80103d08:	83 c4 10             	add    $0x10,%esp
}
80103d0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d0e:	89 d8                	mov    %ebx,%eax
80103d10:	5b                   	pop    %ebx
80103d11:	5e                   	pop    %esi
80103d12:	5f                   	pop    %edi
80103d13:	5d                   	pop    %ebp
80103d14:	c3                   	ret    
    return -1;
80103d15:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d1a:	eb ef                	jmp    80103d0b <fork+0xdb>
    kfree(np->kstack);
80103d1c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d1f:	83 ec 0c             	sub    $0xc,%esp
80103d22:	ff 73 08             	pushl  0x8(%ebx)
80103d25:	e8 a6 e8 ff ff       	call   801025d0 <kfree>
    np->kstack = 0;
80103d2a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103d31:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103d34:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d3b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d40:	eb c9                	jmp    80103d0b <fork+0xdb>
80103d42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d50 <scheduler>:
{
80103d50:	55                   	push   %ebp
80103d51:	89 e5                	mov    %esp,%ebp
80103d53:	57                   	push   %edi
80103d54:	56                   	push   %esi
80103d55:	53                   	push   %ebx
80103d56:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103d59:	e8 a2 fc ff ff       	call   80103a00 <mycpu>
  c->proc = 0;
80103d5e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d65:	00 00 00 
  struct cpu *c = mycpu();
80103d68:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103d6a:	8d 78 04             	lea    0x4(%eax),%edi
80103d6d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103d70:	fb                   	sti    
    acquire(&ptable.lock);
80103d71:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d74:	bb 34 2e 11 80       	mov    $0x80112e34,%ebx
    acquire(&ptable.lock);
80103d79:	68 00 2e 11 80       	push   $0x80112e00
80103d7e:	e8 8d 0b 00 00       	call   80104910 <acquire>
80103d83:	83 c4 10             	add    $0x10,%esp
80103d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d8d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103d90:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103d94:	75 33                	jne    80103dc9 <scheduler+0x79>
      switchuvm(p);
80103d96:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103d99:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103d9f:	53                   	push   %ebx
80103da0:	e8 ab 33 00 00       	call   80107150 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103da5:	58                   	pop    %eax
80103da6:	5a                   	pop    %edx
80103da7:	ff 73 1c             	pushl  0x1c(%ebx)
80103daa:	57                   	push   %edi
      p->state = RUNNING;
80103dab:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103db2:	e8 34 0e 00 00       	call   80104beb <swtch>
      switchkvm();
80103db7:	e8 84 33 00 00       	call   80107140 <switchkvm>
      c->proc = 0;
80103dbc:	83 c4 10             	add    $0x10,%esp
80103dbf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103dc6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dc9:	83 c3 7c             	add    $0x7c,%ebx
80103dcc:	81 fb 34 4d 11 80    	cmp    $0x80114d34,%ebx
80103dd2:	75 bc                	jne    80103d90 <scheduler+0x40>
    release(&ptable.lock);
80103dd4:	83 ec 0c             	sub    $0xc,%esp
80103dd7:	68 00 2e 11 80       	push   $0x80112e00
80103ddc:	e8 cf 0a 00 00       	call   801048b0 <release>
    sti();
80103de1:	83 c4 10             	add    $0x10,%esp
80103de4:	eb 8a                	jmp    80103d70 <scheduler+0x20>
80103de6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ded:	8d 76 00             	lea    0x0(%esi),%esi

80103df0 <sched>:
{
80103df0:	55                   	push   %ebp
80103df1:	89 e5                	mov    %esp,%ebp
80103df3:	56                   	push   %esi
80103df4:	53                   	push   %ebx
  pushcli();
80103df5:	e8 c6 09 00 00       	call   801047c0 <pushcli>
  c = mycpu();
80103dfa:	e8 01 fc ff ff       	call   80103a00 <mycpu>
  p = c->proc;
80103dff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e05:	e8 06 0a 00 00       	call   80104810 <popcli>
  if(!holding(&ptable.lock))
80103e0a:	83 ec 0c             	sub    $0xc,%esp
80103e0d:	68 00 2e 11 80       	push   $0x80112e00
80103e12:	e8 59 0a 00 00       	call   80104870 <holding>
80103e17:	83 c4 10             	add    $0x10,%esp
80103e1a:	85 c0                	test   %eax,%eax
80103e1c:	74 4f                	je     80103e6d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103e1e:	e8 dd fb ff ff       	call   80103a00 <mycpu>
80103e23:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e2a:	75 68                	jne    80103e94 <sched+0xa4>
  if(p->state == RUNNING)
80103e2c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103e30:	74 55                	je     80103e87 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e32:	9c                   	pushf  
80103e33:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e34:	f6 c4 02             	test   $0x2,%ah
80103e37:	75 41                	jne    80103e7a <sched+0x8a>
  intena = mycpu()->intena;
80103e39:	e8 c2 fb ff ff       	call   80103a00 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103e3e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103e41:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103e47:	e8 b4 fb ff ff       	call   80103a00 <mycpu>
80103e4c:	83 ec 08             	sub    $0x8,%esp
80103e4f:	ff 70 04             	pushl  0x4(%eax)
80103e52:	53                   	push   %ebx
80103e53:	e8 93 0d 00 00       	call   80104beb <swtch>
  mycpu()->intena = intena;
80103e58:	e8 a3 fb ff ff       	call   80103a00 <mycpu>
}
80103e5d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e60:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e66:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e69:	5b                   	pop    %ebx
80103e6a:	5e                   	pop    %esi
80103e6b:	5d                   	pop    %ebp
80103e6c:	c3                   	ret    
    panic("sched ptable.lock");
80103e6d:	83 ec 0c             	sub    $0xc,%esp
80103e70:	68 76 7e 10 80       	push   $0x80107e76
80103e75:	e8 06 c5 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103e7a:	83 ec 0c             	sub    $0xc,%esp
80103e7d:	68 a2 7e 10 80       	push   $0x80107ea2
80103e82:	e8 f9 c4 ff ff       	call   80100380 <panic>
    panic("sched running");
80103e87:	83 ec 0c             	sub    $0xc,%esp
80103e8a:	68 94 7e 10 80       	push   $0x80107e94
80103e8f:	e8 ec c4 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103e94:	83 ec 0c             	sub    $0xc,%esp
80103e97:	68 88 7e 10 80       	push   $0x80107e88
80103e9c:	e8 df c4 ff ff       	call   80100380 <panic>
80103ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ea8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103eaf:	90                   	nop

80103eb0 <exit>:
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	57                   	push   %edi
80103eb4:	56                   	push   %esi
80103eb5:	53                   	push   %ebx
80103eb6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103eb9:	e8 d2 fb ff ff       	call   80103a90 <myproc>
  if(curproc == initproc)
80103ebe:	39 05 40 62 11 80    	cmp    %eax,0x80116240
80103ec4:	0f 84 fd 00 00 00    	je     80103fc7 <exit+0x117>
80103eca:	89 c3                	mov    %eax,%ebx
80103ecc:	8d 70 28             	lea    0x28(%eax),%esi
80103ecf:	8d 78 68             	lea    0x68(%eax),%edi
80103ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103ed8:	8b 06                	mov    (%esi),%eax
80103eda:	85 c0                	test   %eax,%eax
80103edc:	74 12                	je     80103ef0 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103ede:	83 ec 0c             	sub    $0xc,%esp
80103ee1:	50                   	push   %eax
80103ee2:	e8 29 d1 ff ff       	call   80101010 <fileclose>
      curproc->ofile[fd] = 0;
80103ee7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103eed:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103ef0:	83 c6 04             	add    $0x4,%esi
80103ef3:	39 f7                	cmp    %esi,%edi
80103ef5:	75 e1                	jne    80103ed8 <exit+0x28>
  begin_op();
80103ef7:	e8 74 ef ff ff       	call   80102e70 <begin_op>
  iput(curproc->cwd);
80103efc:	83 ec 0c             	sub    $0xc,%esp
80103eff:	ff 73 68             	pushl  0x68(%ebx)
80103f02:	e8 b9 da ff ff       	call   801019c0 <iput>
  end_op();
80103f07:	e8 d4 ef ff ff       	call   80102ee0 <end_op>
  curproc->cwd = 0;
80103f0c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103f13:	c7 04 24 00 2e 11 80 	movl   $0x80112e00,(%esp)
80103f1a:	e8 f1 09 00 00       	call   80104910 <acquire>
  wakeup1(curproc->parent);
80103f1f:	8b 53 14             	mov    0x14(%ebx),%edx
80103f22:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f25:	b8 34 2e 11 80       	mov    $0x80112e34,%eax
80103f2a:	eb 0e                	jmp    80103f3a <exit+0x8a>
80103f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f30:	83 c0 7c             	add    $0x7c,%eax
80103f33:	3d 34 4d 11 80       	cmp    $0x80114d34,%eax
80103f38:	74 1c                	je     80103f56 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103f3a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f3e:	75 f0                	jne    80103f30 <exit+0x80>
80103f40:	3b 50 20             	cmp    0x20(%eax),%edx
80103f43:	75 eb                	jne    80103f30 <exit+0x80>
      p->state = RUNNABLE;
80103f45:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f4c:	83 c0 7c             	add    $0x7c,%eax
80103f4f:	3d 34 4d 11 80       	cmp    $0x80114d34,%eax
80103f54:	75 e4                	jne    80103f3a <exit+0x8a>
      p->parent = initproc;
80103f56:	8b 0d 40 62 11 80    	mov    0x80116240,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f5c:	ba 34 2e 11 80       	mov    $0x80112e34,%edx
80103f61:	eb 10                	jmp    80103f73 <exit+0xc3>
80103f63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f67:	90                   	nop
80103f68:	83 c2 7c             	add    $0x7c,%edx
80103f6b:	81 fa 34 4d 11 80    	cmp    $0x80114d34,%edx
80103f71:	74 3b                	je     80103fae <exit+0xfe>
    if(p->parent == curproc){
80103f73:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103f76:	75 f0                	jne    80103f68 <exit+0xb8>
      if(p->state == ZOMBIE)
80103f78:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103f7c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103f7f:	75 e7                	jne    80103f68 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f81:	b8 34 2e 11 80       	mov    $0x80112e34,%eax
80103f86:	eb 12                	jmp    80103f9a <exit+0xea>
80103f88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f8f:	90                   	nop
80103f90:	83 c0 7c             	add    $0x7c,%eax
80103f93:	3d 34 4d 11 80       	cmp    $0x80114d34,%eax
80103f98:	74 ce                	je     80103f68 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103f9a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f9e:	75 f0                	jne    80103f90 <exit+0xe0>
80103fa0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103fa3:	75 eb                	jne    80103f90 <exit+0xe0>
      p->state = RUNNABLE;
80103fa5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103fac:	eb e2                	jmp    80103f90 <exit+0xe0>
  curproc->state = ZOMBIE;
80103fae:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103fb5:	e8 36 fe ff ff       	call   80103df0 <sched>
  panic("zombie exit");
80103fba:	83 ec 0c             	sub    $0xc,%esp
80103fbd:	68 c3 7e 10 80       	push   $0x80107ec3
80103fc2:	e8 b9 c3 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103fc7:	83 ec 0c             	sub    $0xc,%esp
80103fca:	68 b6 7e 10 80       	push   $0x80107eb6
80103fcf:	e8 ac c3 ff ff       	call   80100380 <panic>
80103fd4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103fdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103fdf:	90                   	nop

80103fe0 <wait>:
{
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	56                   	push   %esi
80103fe4:	53                   	push   %ebx
  pushcli();
80103fe5:	e8 d6 07 00 00       	call   801047c0 <pushcli>
  c = mycpu();
80103fea:	e8 11 fa ff ff       	call   80103a00 <mycpu>
  p = c->proc;
80103fef:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ff5:	e8 16 08 00 00       	call   80104810 <popcli>
  acquire(&ptable.lock);
80103ffa:	83 ec 0c             	sub    $0xc,%esp
80103ffd:	68 00 2e 11 80       	push   $0x80112e00
80104002:	e8 09 09 00 00       	call   80104910 <acquire>
80104007:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010400a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010400c:	bb 34 2e 11 80       	mov    $0x80112e34,%ebx
80104011:	eb 10                	jmp    80104023 <wait+0x43>
80104013:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104017:	90                   	nop
80104018:	83 c3 7c             	add    $0x7c,%ebx
8010401b:	81 fb 34 4d 11 80    	cmp    $0x80114d34,%ebx
80104021:	74 1b                	je     8010403e <wait+0x5e>
      if(p->parent != curproc)
80104023:	39 73 14             	cmp    %esi,0x14(%ebx)
80104026:	75 f0                	jne    80104018 <wait+0x38>
      if(p->state == ZOMBIE){
80104028:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010402c:	74 62                	je     80104090 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010402e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104031:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104036:	81 fb 34 4d 11 80    	cmp    $0x80114d34,%ebx
8010403c:	75 e5                	jne    80104023 <wait+0x43>
    if(!havekids || curproc->killed){
8010403e:	85 c0                	test   %eax,%eax
80104040:	0f 84 a0 00 00 00    	je     801040e6 <wait+0x106>
80104046:	8b 46 24             	mov    0x24(%esi),%eax
80104049:	85 c0                	test   %eax,%eax
8010404b:	0f 85 95 00 00 00    	jne    801040e6 <wait+0x106>
  pushcli();
80104051:	e8 6a 07 00 00       	call   801047c0 <pushcli>
  c = mycpu();
80104056:	e8 a5 f9 ff ff       	call   80103a00 <mycpu>
  p = c->proc;
8010405b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104061:	e8 aa 07 00 00       	call   80104810 <popcli>
  if(p == 0)
80104066:	85 db                	test   %ebx,%ebx
80104068:	0f 84 8f 00 00 00    	je     801040fd <wait+0x11d>
  p->chan = chan;
8010406e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104071:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104078:	e8 73 fd ff ff       	call   80103df0 <sched>
  p->chan = 0;
8010407d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104084:	eb 84                	jmp    8010400a <wait+0x2a>
80104086:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010408d:	8d 76 00             	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104090:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104093:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104096:	ff 73 08             	pushl  0x8(%ebx)
80104099:	e8 32 e5 ff ff       	call   801025d0 <kfree>
        p->kstack = 0;
8010409e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801040a5:	5a                   	pop    %edx
801040a6:	ff 73 04             	pushl  0x4(%ebx)
801040a9:	e8 82 34 00 00       	call   80107530 <freevm>
        p->pid = 0;
801040ae:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801040b5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801040bc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801040c0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801040c7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801040ce:	c7 04 24 00 2e 11 80 	movl   $0x80112e00,(%esp)
801040d5:	e8 d6 07 00 00       	call   801048b0 <release>
        return pid;
801040da:	83 c4 10             	add    $0x10,%esp
}
801040dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040e0:	89 f0                	mov    %esi,%eax
801040e2:	5b                   	pop    %ebx
801040e3:	5e                   	pop    %esi
801040e4:	5d                   	pop    %ebp
801040e5:	c3                   	ret    
      release(&ptable.lock);
801040e6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801040e9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801040ee:	68 00 2e 11 80       	push   $0x80112e00
801040f3:	e8 b8 07 00 00       	call   801048b0 <release>
      return -1;
801040f8:	83 c4 10             	add    $0x10,%esp
801040fb:	eb e0                	jmp    801040dd <wait+0xfd>
    panic("sleep");
801040fd:	83 ec 0c             	sub    $0xc,%esp
80104100:	68 4c 80 10 80       	push   $0x8010804c
80104105:	e8 76 c2 ff ff       	call   80100380 <panic>
8010410a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104110 <yield>:
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	53                   	push   %ebx
80104114:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104117:	68 00 2e 11 80       	push   $0x80112e00
8010411c:	e8 ef 07 00 00       	call   80104910 <acquire>
  pushcli();
80104121:	e8 9a 06 00 00       	call   801047c0 <pushcli>
  c = mycpu();
80104126:	e8 d5 f8 ff ff       	call   80103a00 <mycpu>
  p = c->proc;
8010412b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104131:	e8 da 06 00 00       	call   80104810 <popcli>
  myproc()->state = RUNNABLE;
80104136:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010413d:	e8 ae fc ff ff       	call   80103df0 <sched>
  release(&ptable.lock);
80104142:	c7 04 24 00 2e 11 80 	movl   $0x80112e00,(%esp)
80104149:	e8 62 07 00 00       	call   801048b0 <release>
}
8010414e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104151:	83 c4 10             	add    $0x10,%esp
80104154:	c9                   	leave  
80104155:	c3                   	ret    
80104156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010415d:	8d 76 00             	lea    0x0(%esi),%esi

80104160 <sleep>:
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	57                   	push   %edi
80104164:	56                   	push   %esi
80104165:	53                   	push   %ebx
80104166:	83 ec 0c             	sub    $0xc,%esp
80104169:	8b 7d 08             	mov    0x8(%ebp),%edi
8010416c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010416f:	e8 4c 06 00 00       	call   801047c0 <pushcli>
  c = mycpu();
80104174:	e8 87 f8 ff ff       	call   80103a00 <mycpu>
  p = c->proc;
80104179:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010417f:	e8 8c 06 00 00       	call   80104810 <popcli>
  if(p == 0)
80104184:	85 db                	test   %ebx,%ebx
80104186:	0f 84 87 00 00 00    	je     80104213 <sleep+0xb3>
  if(lk == 0)
8010418c:	85 f6                	test   %esi,%esi
8010418e:	74 76                	je     80104206 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104190:	81 fe 00 2e 11 80    	cmp    $0x80112e00,%esi
80104196:	74 50                	je     801041e8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104198:	83 ec 0c             	sub    $0xc,%esp
8010419b:	68 00 2e 11 80       	push   $0x80112e00
801041a0:	e8 6b 07 00 00       	call   80104910 <acquire>
    release(lk);
801041a5:	89 34 24             	mov    %esi,(%esp)
801041a8:	e8 03 07 00 00       	call   801048b0 <release>
  p->chan = chan;
801041ad:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041b0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041b7:	e8 34 fc ff ff       	call   80103df0 <sched>
  p->chan = 0;
801041bc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801041c3:	c7 04 24 00 2e 11 80 	movl   $0x80112e00,(%esp)
801041ca:	e8 e1 06 00 00       	call   801048b0 <release>
    acquire(lk);
801041cf:	89 75 08             	mov    %esi,0x8(%ebp)
801041d2:	83 c4 10             	add    $0x10,%esp
}
801041d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041d8:	5b                   	pop    %ebx
801041d9:	5e                   	pop    %esi
801041da:	5f                   	pop    %edi
801041db:	5d                   	pop    %ebp
    acquire(lk);
801041dc:	e9 2f 07 00 00       	jmp    80104910 <acquire>
801041e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801041e8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041eb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041f2:	e8 f9 fb ff ff       	call   80103df0 <sched>
  p->chan = 0;
801041f7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801041fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104201:	5b                   	pop    %ebx
80104202:	5e                   	pop    %esi
80104203:	5f                   	pop    %edi
80104204:	5d                   	pop    %ebp
80104205:	c3                   	ret    
    panic("sleep without lk");
80104206:	83 ec 0c             	sub    $0xc,%esp
80104209:	68 cf 7e 10 80       	push   $0x80107ecf
8010420e:	e8 6d c1 ff ff       	call   80100380 <panic>
    panic("sleep");
80104213:	83 ec 0c             	sub    $0xc,%esp
80104216:	68 4c 80 10 80       	push   $0x8010804c
8010421b:	e8 60 c1 ff ff       	call   80100380 <panic>

80104220 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	53                   	push   %ebx
80104224:	83 ec 10             	sub    $0x10,%esp
80104227:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010422a:	68 00 2e 11 80       	push   $0x80112e00
8010422f:	e8 dc 06 00 00       	call   80104910 <acquire>
80104234:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104237:	b8 34 2e 11 80       	mov    $0x80112e34,%eax
8010423c:	eb 0c                	jmp    8010424a <wakeup+0x2a>
8010423e:	66 90                	xchg   %ax,%ax
80104240:	83 c0 7c             	add    $0x7c,%eax
80104243:	3d 34 4d 11 80       	cmp    $0x80114d34,%eax
80104248:	74 1c                	je     80104266 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010424a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010424e:	75 f0                	jne    80104240 <wakeup+0x20>
80104250:	3b 58 20             	cmp    0x20(%eax),%ebx
80104253:	75 eb                	jne    80104240 <wakeup+0x20>
      p->state = RUNNABLE;
80104255:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010425c:	83 c0 7c             	add    $0x7c,%eax
8010425f:	3d 34 4d 11 80       	cmp    $0x80114d34,%eax
80104264:	75 e4                	jne    8010424a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104266:	c7 45 08 00 2e 11 80 	movl   $0x80112e00,0x8(%ebp)
}
8010426d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104270:	c9                   	leave  
  release(&ptable.lock);
80104271:	e9 3a 06 00 00       	jmp    801048b0 <release>
80104276:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010427d:	8d 76 00             	lea    0x0(%esi),%esi

80104280 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	53                   	push   %ebx
80104284:	83 ec 10             	sub    $0x10,%esp
80104287:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010428a:	68 00 2e 11 80       	push   $0x80112e00
8010428f:	e8 7c 06 00 00       	call   80104910 <acquire>
80104294:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104297:	b8 34 2e 11 80       	mov    $0x80112e34,%eax
8010429c:	eb 0c                	jmp    801042aa <kill+0x2a>
8010429e:	66 90                	xchg   %ax,%ax
801042a0:	83 c0 7c             	add    $0x7c,%eax
801042a3:	3d 34 4d 11 80       	cmp    $0x80114d34,%eax
801042a8:	74 36                	je     801042e0 <kill+0x60>
    if(p->pid == pid){
801042aa:	39 58 10             	cmp    %ebx,0x10(%eax)
801042ad:	75 f1                	jne    801042a0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801042af:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801042b3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801042ba:	75 07                	jne    801042c3 <kill+0x43>
        p->state = RUNNABLE;
801042bc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801042c3:	83 ec 0c             	sub    $0xc,%esp
801042c6:	68 00 2e 11 80       	push   $0x80112e00
801042cb:	e8 e0 05 00 00       	call   801048b0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801042d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801042d3:	83 c4 10             	add    $0x10,%esp
801042d6:	31 c0                	xor    %eax,%eax
}
801042d8:	c9                   	leave  
801042d9:	c3                   	ret    
801042da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801042e0:	83 ec 0c             	sub    $0xc,%esp
801042e3:	68 00 2e 11 80       	push   $0x80112e00
801042e8:	e8 c3 05 00 00       	call   801048b0 <release>
}
801042ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801042f0:	83 c4 10             	add    $0x10,%esp
801042f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801042f8:	c9                   	leave  
801042f9:	c3                   	ret    
801042fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104300 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	57                   	push   %edi
80104304:	56                   	push   %esi
80104305:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104308:	53                   	push   %ebx
80104309:	bb a0 2e 11 80       	mov    $0x80112ea0,%ebx
8010430e:	83 ec 3c             	sub    $0x3c,%esp
80104311:	eb 24                	jmp    80104337 <procdump+0x37>
80104313:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104317:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104318:	83 ec 0c             	sub    $0xc,%esp
8010431b:	68 b7 83 10 80       	push   $0x801083b7
80104320:	e8 5b c3 ff ff       	call   80100680 <cprintf>
80104325:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104328:	83 c3 7c             	add    $0x7c,%ebx
8010432b:	81 fb a0 4d 11 80    	cmp    $0x80114da0,%ebx
80104331:	0f 84 81 00 00 00    	je     801043b8 <procdump+0xb8>
    if(p->state == UNUSED)
80104337:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010433a:	85 c0                	test   %eax,%eax
8010433c:	74 ea                	je     80104328 <procdump+0x28>
      state = "???";
8010433e:	ba e0 7e 10 80       	mov    $0x80107ee0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104343:	83 f8 05             	cmp    $0x5,%eax
80104346:	77 11                	ja     80104359 <procdump+0x59>
80104348:	8b 14 85 6c 7f 10 80 	mov    -0x7fef8094(,%eax,4),%edx
      state = "???";
8010434f:	b8 e0 7e 10 80       	mov    $0x80107ee0,%eax
80104354:	85 d2                	test   %edx,%edx
80104356:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104359:	53                   	push   %ebx
8010435a:	52                   	push   %edx
8010435b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010435e:	68 e4 7e 10 80       	push   $0x80107ee4
80104363:	e8 18 c3 ff ff       	call   80100680 <cprintf>
    if(p->state == SLEEPING){
80104368:	83 c4 10             	add    $0x10,%esp
8010436b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010436f:	75 a7                	jne    80104318 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104371:	83 ec 08             	sub    $0x8,%esp
80104374:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104377:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010437a:	50                   	push   %eax
8010437b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010437e:	8b 40 0c             	mov    0xc(%eax),%eax
80104381:	83 c0 08             	add    $0x8,%eax
80104384:	50                   	push   %eax
80104385:	e8 d6 03 00 00       	call   80104760 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010438a:	83 c4 10             	add    $0x10,%esp
8010438d:	8d 76 00             	lea    0x0(%esi),%esi
80104390:	8b 17                	mov    (%edi),%edx
80104392:	85 d2                	test   %edx,%edx
80104394:	74 82                	je     80104318 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104396:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104399:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010439c:	52                   	push   %edx
8010439d:	68 41 79 10 80       	push   $0x80107941
801043a2:	e8 d9 c2 ff ff       	call   80100680 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801043a7:	83 c4 10             	add    $0x10,%esp
801043aa:	39 fe                	cmp    %edi,%esi
801043ac:	75 e2                	jne    80104390 <procdump+0x90>
801043ae:	e9 65 ff ff ff       	jmp    80104318 <procdump+0x18>
801043b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043b7:	90                   	nop
  }
}
801043b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043bb:	5b                   	pop    %ebx
801043bc:	5e                   	pop    %esi
801043bd:	5f                   	pop    %edi
801043be:	5d                   	pop    %ebp
801043bf:	c3                   	ret    

801043c0 <ps>:

// Assignment 1.2
// ptable locks are being acquired and released so that while the syscalls are running other cpus/processes
// don't modify it (or the current process) to prevent any unwanted behaviour
int ps(void){
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	53                   	push   %ebx
801043c4:	bb a0 2e 11 80       	mov    $0x80112ea0,%ebx
801043c9:	83 ec 10             	sub    $0x10,%esp
  struct proc* process;

  acquire(&ptable.lock);
801043cc:	68 00 2e 11 80       	push   $0x80112e00
801043d1:	e8 3a 05 00 00       	call   80104910 <acquire>
  for (process = ptable.proc; process<&ptable.proc[NPROC]; process++){
801043d6:	83 c4 10             	add    $0x10,%esp
801043d9:	eb 10                	jmp    801043eb <ps+0x2b>
801043db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043df:	90                   	nop
801043e0:	83 c3 7c             	add    $0x7c,%ebx
801043e3:	81 fb a0 4d 11 80    	cmp    $0x80114da0,%ebx
801043e9:	74 29                	je     80104414 <ps+0x54>
    if(process->state != UNUSED){
801043eb:	8b 43 a0             	mov    -0x60(%ebx),%eax
801043ee:	85 c0                	test   %eax,%eax
801043f0:	74 ee                	je     801043e0 <ps+0x20>
      cprintf("pid:%d name:%s\n", process->pid, process->name);
801043f2:	83 ec 04             	sub    $0x4,%esp
801043f5:	53                   	push   %ebx
  for (process = ptable.proc; process<&ptable.proc[NPROC]; process++){
801043f6:	83 c3 7c             	add    $0x7c,%ebx
      cprintf("pid:%d name:%s\n", process->pid, process->name);
801043f9:	ff b3 28 ff ff ff    	pushl  -0xd8(%ebx)
801043ff:	68 ed 7e 10 80       	push   $0x80107eed
80104404:	e8 77 c2 ff ff       	call   80100680 <cprintf>
80104409:	83 c4 10             	add    $0x10,%esp
  for (process = ptable.proc; process<&ptable.proc[NPROC]; process++){
8010440c:	81 fb a0 4d 11 80    	cmp    $0x80114da0,%ebx
80104412:	75 d7                	jne    801043eb <ps+0x2b>
    }
  }

  release(&ptable.lock);
80104414:	83 ec 0c             	sub    $0xc,%esp
80104417:	68 00 2e 11 80       	push   $0x80112e00
8010441c:	e8 8f 04 00 00       	call   801048b0 <release>

  return 0;
}
80104421:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104424:	31 c0                	xor    %eax,%eax
80104426:	c9                   	leave  
80104427:	c3                   	ret    
80104428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010442f:	90                   	nop

80104430 <get_proc_by_id>:

// Assignment 1.3
// Function to get the process by its ID
struct proc* get_proc_by_id(int id){
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	56                   	push   %esi
80104434:	53                   	push   %ebx
80104435:	8b 75 08             	mov    0x8(%ebp),%esi

  acquire(&ptable.lock);
  struct proc* process;
  for (process = ptable.proc; process<&ptable.proc[NPROC]; process++){
80104438:	bb 34 2e 11 80       	mov    $0x80112e34,%ebx
  acquire(&ptable.lock);
8010443d:	83 ec 0c             	sub    $0xc,%esp
80104440:	68 00 2e 11 80       	push   $0x80112e00
80104445:	e8 c6 04 00 00       	call   80104910 <acquire>
8010444a:	83 c4 10             	add    $0x10,%esp
8010444d:	eb 0c                	jmp    8010445b <get_proc_by_id+0x2b>
8010444f:	90                   	nop
  for (process = ptable.proc; process<&ptable.proc[NPROC]; process++){
80104450:	83 c3 7c             	add    $0x7c,%ebx
80104453:	81 fb 34 4d 11 80    	cmp    $0x80114d34,%ebx
80104459:	74 25                	je     80104480 <get_proc_by_id+0x50>
    if(process->pid == id){
8010445b:	39 73 10             	cmp    %esi,0x10(%ebx)
8010445e:	75 f0                	jne    80104450 <get_proc_by_id+0x20>
      release(&ptable.lock);
80104460:	83 ec 0c             	sub    $0xc,%esp
80104463:	68 00 2e 11 80       	push   $0x80112e00
80104468:	e8 43 04 00 00       	call   801048b0 <release>
      return process;
8010446d:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ptable.lock);
  return 0;
}
80104470:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104473:	89 d8                	mov    %ebx,%eax
80104475:	5b                   	pop    %ebx
80104476:	5e                   	pop    %esi
80104477:	5d                   	pop    %ebp
80104478:	c3                   	ret    
80104479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104480:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80104483:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80104485:	68 00 2e 11 80       	push   $0x80112e00
8010448a:	e8 21 04 00 00       	call   801048b0 <release>
  return 0;
8010448f:	83 c4 10             	add    $0x10,%esp
}
80104492:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104495:	89 d8                	mov    %ebx,%eax
80104497:	5b                   	pop    %ebx
80104498:	5e                   	pop    %esi
80104499:	5d                   	pop    %ebp
8010449a:	c3                   	ret    
8010449b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010449f:	90                   	nop

801044a0 <send_message>:

int send_message(int s_pid, int r_pid, const char *msg){
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	57                   	push   %edi
801044a4:	56                   	push   %esi
801044a5:	53                   	push   %ebx
801044a6:	83 ec 18             	sub    $0x18,%esp
801044a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801044ac:	8b 75 10             	mov    0x10(%ebp),%esi
  acquire(&ptable.lock);
801044af:	68 00 2e 11 80       	push   $0x80112e00
801044b4:	e8 57 04 00 00       	call   80104910 <acquire>
801044b9:	83 c4 10             	add    $0x10,%esp
  for (process = ptable.proc; process<&ptable.proc[NPROC]; process++){
801044bc:	b8 34 2e 11 80       	mov    $0x80112e34,%eax
801044c1:	eb 0f                	jmp    801044d2 <send_message+0x32>
801044c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044c7:	90                   	nop
801044c8:	83 c0 7c             	add    $0x7c,%eax
801044cb:	3d 34 4d 11 80       	cmp    $0x80114d34,%eax
801044d0:	74 05                	je     801044d7 <send_message+0x37>
    if(process->pid == id){
801044d2:	3b 58 10             	cmp    0x10(%eax),%ebx
801044d5:	75 f1                	jne    801044c8 <send_message+0x28>
  release(&ptable.lock);
801044d7:	83 ec 0c             	sub    $0xc,%esp
801044da:	68 00 2e 11 80       	push   $0x80112e00
801044df:	e8 cc 03 00 00       	call   801048b0 <release>
  return 0;
801044e4:	83 c4 10             	add    $0x10,%esp
  // struct proc *sender_proc = get_proc_by_id(s_pid);
  struct proc *rec_proc = get_proc_by_id(r_pid);
  acquire(&ptable.lock);
801044e7:	83 ec 0c             	sub    $0xc,%esp
801044ea:	68 00 2e 11 80       	push   $0x80112e00
801044ef:	e8 1c 04 00 00       	call   80104910 <acquire>

  // Check if the receiver process has reached the maximum message count
  if (msg_count[r_pid] >= MAX_MSG_PER_PROC){
801044f4:	8b 3c 9d 40 4d 11 80 	mov    -0x7feeb2c0(,%ebx,4),%edi
801044fb:	83 c4 10             	add    $0x10,%esp
801044fe:	83 ff 09             	cmp    $0x9,%edi
80104501:	7f 44                	jg     80104547 <send_message+0xa7>
80104503:	8d 04 9b             	lea    (%ebx,%ebx,4),%eax
80104506:	8d 0c 47             	lea    (%edi,%eax,2),%ecx
    release(&ptable.lock);
    return -1;
  }

  // Copy the message to the receiver's message buffer
  for (int i=0; i<MSG_SIZE; i++){
80104509:	31 c0                	xor    %eax,%eax
8010450b:	c1 e1 03             	shl    $0x3,%ecx
8010450e:	66 90                	xchg   %ax,%ax
    messages[r_pid][msg_count[r_pid]][i] = *(msg + i);
80104510:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104514:	88 94 01 40 4e 11 80 	mov    %dl,-0x7feeb1c0(%ecx,%eax,1)
  for (int i=0; i<MSG_SIZE; i++){
8010451b:	83 c0 01             	add    $0x1,%eax
8010451e:	83 f8 08             	cmp    $0x8,%eax
80104521:	75 ed                	jne    80104510 <send_message+0x70>
  if (rec_proc->state == SLEEPING){
    wakeup1(&rec_proc); // using wakeup1 because ptable is already locked
  }
  // // cprintf("send %d \n", rec_proc->msg_count);
  // // rec_proc->is_message = 1;
  release(&ptable.lock);
80104523:	83 ec 0c             	sub    $0xc,%esp
  msg_count[r_pid] += 1;
80104526:	83 c7 01             	add    $0x1,%edi
  release(&ptable.lock);
80104529:	68 00 2e 11 80       	push   $0x80112e00
  msg_count[r_pid] += 1;
8010452e:	89 3c 9d 40 4d 11 80 	mov    %edi,-0x7feeb2c0(,%ebx,4)
  release(&ptable.lock);
80104535:	e8 76 03 00 00       	call   801048b0 <release>

  return 0;
8010453a:	83 c4 10             	add    $0x10,%esp
8010453d:	31 c0                	xor    %eax,%eax
}
8010453f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104542:	5b                   	pop    %ebx
80104543:	5e                   	pop    %esi
80104544:	5f                   	pop    %edi
80104545:	5d                   	pop    %ebp
80104546:	c3                   	ret    
    cprintf("[ERROR] Too many messages\n");
80104547:	83 ec 0c             	sub    $0xc,%esp
8010454a:	68 fd 7e 10 80       	push   $0x80107efd
8010454f:	e8 2c c1 ff ff       	call   80100680 <cprintf>
    release(&ptable.lock);
80104554:	c7 04 24 00 2e 11 80 	movl   $0x80112e00,(%esp)
8010455b:	e8 50 03 00 00       	call   801048b0 <release>
    return -1;
80104560:	83 c4 10             	add    $0x10,%esp
80104563:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104568:	eb d5                	jmp    8010453f <send_message+0x9f>
8010456a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104570 <receive_message>:

int receive_message(char *msg){
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	56                   	push   %esi
80104574:	53                   	push   %ebx
80104575:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104578:	83 ec 0c             	sub    $0xc,%esp
8010457b:	68 00 2e 11 80       	push   $0x80112e00
80104580:	e8 8b 03 00 00       	call   80104910 <acquire>
  pushcli();
80104585:	e8 36 02 00 00       	call   801047c0 <pushcli>
  c = mycpu();
8010458a:	e8 71 f4 ff ff       	call   80103a00 <mycpu>
  p = c->proc;
8010458f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104595:	e8 76 02 00 00       	call   80104810 <popcli>
  struct proc *cur_proc = myproc();

  // Check if the current process has any messages to receive
  if (msg_count[cur_proc->pid] <= 0){
8010459a:	83 c4 10             	add    $0x10,%esp
8010459d:	8b 56 10             	mov    0x10(%esi),%edx
801045a0:	8b 0c 95 40 4d 11 80 	mov    -0x7feeb2c0(,%edx,4),%ecx
801045a7:	85 c9                	test   %ecx,%ecx
801045a9:	7e 4d                	jle    801045f8 <receive_message+0x88>
    release(&ptable.lock);
    return -1;
  }

  // Copy the message from the message buffer to the provided `msg` buffer
  for (int i=0; i<MSG_SIZE; i++){
801045ab:	31 c0                	xor    %eax,%eax
801045ad:	eb 0b                	jmp    801045ba <receive_message+0x4a>
801045af:	90                   	nop
    *(msg + i) = messages[cur_proc->pid][msg_count[cur_proc->pid] - 1][i];
801045b0:	8b 56 10             	mov    0x10(%esi),%edx
801045b3:	8b 0c 95 40 4d 11 80 	mov    -0x7feeb2c0(,%edx,4),%ecx
801045ba:	8d 14 92             	lea    (%edx,%edx,4),%edx
801045bd:	8d 54 51 ff          	lea    -0x1(%ecx,%edx,2),%edx
801045c1:	0f b6 94 d0 40 4e 11 	movzbl -0x7feeb1c0(%eax,%edx,8),%edx
801045c8:	80 
801045c9:	88 14 03             	mov    %dl,(%ebx,%eax,1)
  for (int i=0; i<MSG_SIZE; i++){
801045cc:	83 c0 01             	add    $0x1,%eax
801045cf:	83 f8 08             	cmp    $0x8,%eax
801045d2:	75 dc                	jne    801045b0 <receive_message+0x40>
  }

  // Decrement the message count for the current process
  msg_count[cur_proc->pid] -= 1;

  release(&ptable.lock);
801045d4:	83 ec 0c             	sub    $0xc,%esp
  msg_count[cur_proc->pid] -= 1;
801045d7:	8b 46 10             	mov    0x10(%esi),%eax
  release(&ptable.lock);
801045da:	68 00 2e 11 80       	push   $0x80112e00
  msg_count[cur_proc->pid] -= 1;
801045df:	83 2c 85 40 4d 11 80 	subl   $0x1,-0x7feeb2c0(,%eax,4)
801045e6:	01 
  release(&ptable.lock);
801045e7:	e8 c4 02 00 00       	call   801048b0 <release>

  return 0;
801045ec:	83 c4 10             	add    $0x10,%esp
801045ef:	31 c0                	xor    %eax,%eax
}
801045f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045f4:	5b                   	pop    %ebx
801045f5:	5e                   	pop    %esi
801045f6:	5d                   	pop    %ebp
801045f7:	c3                   	ret    
    release(&ptable.lock);
801045f8:	83 ec 0c             	sub    $0xc,%esp
801045fb:	68 00 2e 11 80       	push   $0x80112e00
80104600:	e8 ab 02 00 00       	call   801048b0 <release>
    return -1;
80104605:	83 c4 10             	add    $0x10,%esp
80104608:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010460d:	eb e2                	jmp    801045f1 <receive_message+0x81>
8010460f:	90                   	nop

80104610 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	53                   	push   %ebx
80104614:	83 ec 0c             	sub    $0xc,%esp
80104617:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010461a:	68 84 7f 10 80       	push   $0x80107f84
8010461f:	8d 43 04             	lea    0x4(%ebx),%eax
80104622:	50                   	push   %eax
80104623:	e8 18 01 00 00       	call   80104740 <initlock>
  lk->name = name;
80104628:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010462b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104631:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104634:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010463b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010463e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104641:	c9                   	leave  
80104642:	c3                   	ret    
80104643:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010464a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104650 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	56                   	push   %esi
80104654:	53                   	push   %ebx
80104655:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104658:	8d 73 04             	lea    0x4(%ebx),%esi
8010465b:	83 ec 0c             	sub    $0xc,%esp
8010465e:	56                   	push   %esi
8010465f:	e8 ac 02 00 00       	call   80104910 <acquire>
  while (lk->locked) {
80104664:	8b 13                	mov    (%ebx),%edx
80104666:	83 c4 10             	add    $0x10,%esp
80104669:	85 d2                	test   %edx,%edx
8010466b:	74 16                	je     80104683 <acquiresleep+0x33>
8010466d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104670:	83 ec 08             	sub    $0x8,%esp
80104673:	56                   	push   %esi
80104674:	53                   	push   %ebx
80104675:	e8 e6 fa ff ff       	call   80104160 <sleep>
  while (lk->locked) {
8010467a:	8b 03                	mov    (%ebx),%eax
8010467c:	83 c4 10             	add    $0x10,%esp
8010467f:	85 c0                	test   %eax,%eax
80104681:	75 ed                	jne    80104670 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104683:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104689:	e8 02 f4 ff ff       	call   80103a90 <myproc>
8010468e:	8b 40 10             	mov    0x10(%eax),%eax
80104691:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104694:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104697:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010469a:	5b                   	pop    %ebx
8010469b:	5e                   	pop    %esi
8010469c:	5d                   	pop    %ebp
  release(&lk->lk);
8010469d:	e9 0e 02 00 00       	jmp    801048b0 <release>
801046a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046b0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	56                   	push   %esi
801046b4:	53                   	push   %ebx
801046b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801046b8:	8d 73 04             	lea    0x4(%ebx),%esi
801046bb:	83 ec 0c             	sub    $0xc,%esp
801046be:	56                   	push   %esi
801046bf:	e8 4c 02 00 00       	call   80104910 <acquire>
  lk->locked = 0;
801046c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801046ca:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801046d1:	89 1c 24             	mov    %ebx,(%esp)
801046d4:	e8 47 fb ff ff       	call   80104220 <wakeup>
  release(&lk->lk);
801046d9:	89 75 08             	mov    %esi,0x8(%ebp)
801046dc:	83 c4 10             	add    $0x10,%esp
}
801046df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046e2:	5b                   	pop    %ebx
801046e3:	5e                   	pop    %esi
801046e4:	5d                   	pop    %ebp
  release(&lk->lk);
801046e5:	e9 c6 01 00 00       	jmp    801048b0 <release>
801046ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046f0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	57                   	push   %edi
801046f4:	31 ff                	xor    %edi,%edi
801046f6:	56                   	push   %esi
801046f7:	53                   	push   %ebx
801046f8:	83 ec 18             	sub    $0x18,%esp
801046fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801046fe:	8d 73 04             	lea    0x4(%ebx),%esi
80104701:	56                   	push   %esi
80104702:	e8 09 02 00 00       	call   80104910 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104707:	8b 03                	mov    (%ebx),%eax
80104709:	83 c4 10             	add    $0x10,%esp
8010470c:	85 c0                	test   %eax,%eax
8010470e:	75 18                	jne    80104728 <holdingsleep+0x38>
  release(&lk->lk);
80104710:	83 ec 0c             	sub    $0xc,%esp
80104713:	56                   	push   %esi
80104714:	e8 97 01 00 00       	call   801048b0 <release>
  return r;
}
80104719:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010471c:	89 f8                	mov    %edi,%eax
8010471e:	5b                   	pop    %ebx
8010471f:	5e                   	pop    %esi
80104720:	5f                   	pop    %edi
80104721:	5d                   	pop    %ebp
80104722:	c3                   	ret    
80104723:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104727:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104728:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010472b:	e8 60 f3 ff ff       	call   80103a90 <myproc>
80104730:	39 58 10             	cmp    %ebx,0x10(%eax)
80104733:	0f 94 c0             	sete   %al
80104736:	0f b6 c0             	movzbl %al,%eax
80104739:	89 c7                	mov    %eax,%edi
8010473b:	eb d3                	jmp    80104710 <holdingsleep+0x20>
8010473d:	66 90                	xchg   %ax,%ax
8010473f:	90                   	nop

80104740 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104740:	55                   	push   %ebp
80104741:	89 e5                	mov    %esp,%ebp
80104743:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104746:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104749:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010474f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104752:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104759:	5d                   	pop    %ebp
8010475a:	c3                   	ret    
8010475b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010475f:	90                   	nop

80104760 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104760:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104761:	31 d2                	xor    %edx,%edx
{
80104763:	89 e5                	mov    %esp,%ebp
80104765:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104766:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104769:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010476c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010476f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104770:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104776:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010477c:	77 1a                	ja     80104798 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010477e:	8b 58 04             	mov    0x4(%eax),%ebx
80104781:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104784:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104787:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104789:	83 fa 0a             	cmp    $0xa,%edx
8010478c:	75 e2                	jne    80104770 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010478e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104791:	c9                   	leave  
80104792:	c3                   	ret    
80104793:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104797:	90                   	nop
  for(; i < 10; i++)
80104798:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010479b:	8d 51 28             	lea    0x28(%ecx),%edx
8010479e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801047a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801047a6:	83 c0 04             	add    $0x4,%eax
801047a9:	39 d0                	cmp    %edx,%eax
801047ab:	75 f3                	jne    801047a0 <getcallerpcs+0x40>
}
801047ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047b0:	c9                   	leave  
801047b1:	c3                   	ret    
801047b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	53                   	push   %ebx
801047c4:	83 ec 04             	sub    $0x4,%esp
801047c7:	9c                   	pushf  
801047c8:	5b                   	pop    %ebx
  asm volatile("cli");
801047c9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801047ca:	e8 31 f2 ff ff       	call   80103a00 <mycpu>
801047cf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801047d5:	85 c0                	test   %eax,%eax
801047d7:	74 17                	je     801047f0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801047d9:	e8 22 f2 ff ff       	call   80103a00 <mycpu>
801047de:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801047e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047e8:	c9                   	leave  
801047e9:	c3                   	ret    
801047ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801047f0:	e8 0b f2 ff ff       	call   80103a00 <mycpu>
801047f5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801047fb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104801:	eb d6                	jmp    801047d9 <pushcli+0x19>
80104803:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010480a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104810 <popcli>:

void
popcli(void)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104816:	9c                   	pushf  
80104817:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104818:	f6 c4 02             	test   $0x2,%ah
8010481b:	75 35                	jne    80104852 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010481d:	e8 de f1 ff ff       	call   80103a00 <mycpu>
80104822:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104829:	78 34                	js     8010485f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010482b:	e8 d0 f1 ff ff       	call   80103a00 <mycpu>
80104830:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104836:	85 d2                	test   %edx,%edx
80104838:	74 06                	je     80104840 <popcli+0x30>
    sti();
}
8010483a:	c9                   	leave  
8010483b:	c3                   	ret    
8010483c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104840:	e8 bb f1 ff ff       	call   80103a00 <mycpu>
80104845:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010484b:	85 c0                	test   %eax,%eax
8010484d:	74 eb                	je     8010483a <popcli+0x2a>
  asm volatile("sti");
8010484f:	fb                   	sti    
}
80104850:	c9                   	leave  
80104851:	c3                   	ret    
    panic("popcli - interruptible");
80104852:	83 ec 0c             	sub    $0xc,%esp
80104855:	68 8f 7f 10 80       	push   $0x80107f8f
8010485a:	e8 21 bb ff ff       	call   80100380 <panic>
    panic("popcli");
8010485f:	83 ec 0c             	sub    $0xc,%esp
80104862:	68 a6 7f 10 80       	push   $0x80107fa6
80104867:	e8 14 bb ff ff       	call   80100380 <panic>
8010486c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104870 <holding>:
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	56                   	push   %esi
80104874:	53                   	push   %ebx
80104875:	8b 75 08             	mov    0x8(%ebp),%esi
80104878:	31 db                	xor    %ebx,%ebx
  pushcli();
8010487a:	e8 41 ff ff ff       	call   801047c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010487f:	8b 06                	mov    (%esi),%eax
80104881:	85 c0                	test   %eax,%eax
80104883:	75 0b                	jne    80104890 <holding+0x20>
  popcli();
80104885:	e8 86 ff ff ff       	call   80104810 <popcli>
}
8010488a:	89 d8                	mov    %ebx,%eax
8010488c:	5b                   	pop    %ebx
8010488d:	5e                   	pop    %esi
8010488e:	5d                   	pop    %ebp
8010488f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104890:	8b 5e 08             	mov    0x8(%esi),%ebx
80104893:	e8 68 f1 ff ff       	call   80103a00 <mycpu>
80104898:	39 c3                	cmp    %eax,%ebx
8010489a:	0f 94 c3             	sete   %bl
  popcli();
8010489d:	e8 6e ff ff ff       	call   80104810 <popcli>
  r = lock->locked && lock->cpu == mycpu();
801048a2:	0f b6 db             	movzbl %bl,%ebx
}
801048a5:	89 d8                	mov    %ebx,%eax
801048a7:	5b                   	pop    %ebx
801048a8:	5e                   	pop    %esi
801048a9:	5d                   	pop    %ebp
801048aa:	c3                   	ret    
801048ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048af:	90                   	nop

801048b0 <release>:
{
801048b0:	55                   	push   %ebp
801048b1:	89 e5                	mov    %esp,%ebp
801048b3:	56                   	push   %esi
801048b4:	53                   	push   %ebx
801048b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801048b8:	e8 03 ff ff ff       	call   801047c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801048bd:	8b 03                	mov    (%ebx),%eax
801048bf:	85 c0                	test   %eax,%eax
801048c1:	75 15                	jne    801048d8 <release+0x28>
  popcli();
801048c3:	e8 48 ff ff ff       	call   80104810 <popcli>
    panic("release");
801048c8:	83 ec 0c             	sub    $0xc,%esp
801048cb:	68 ad 7f 10 80       	push   $0x80107fad
801048d0:	e8 ab ba ff ff       	call   80100380 <panic>
801048d5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801048d8:	8b 73 08             	mov    0x8(%ebx),%esi
801048db:	e8 20 f1 ff ff       	call   80103a00 <mycpu>
801048e0:	39 c6                	cmp    %eax,%esi
801048e2:	75 df                	jne    801048c3 <release+0x13>
  popcli();
801048e4:	e8 27 ff ff ff       	call   80104810 <popcli>
  lk->pcs[0] = 0;
801048e9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801048f0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801048f7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801048fc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104902:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104905:	5b                   	pop    %ebx
80104906:	5e                   	pop    %esi
80104907:	5d                   	pop    %ebp
  popcli();
80104908:	e9 03 ff ff ff       	jmp    80104810 <popcli>
8010490d:	8d 76 00             	lea    0x0(%esi),%esi

80104910 <acquire>:
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	53                   	push   %ebx
80104914:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104917:	e8 a4 fe ff ff       	call   801047c0 <pushcli>
  if(holding(lk))
8010491c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010491f:	e8 9c fe ff ff       	call   801047c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104924:	8b 03                	mov    (%ebx),%eax
80104926:	85 c0                	test   %eax,%eax
80104928:	75 7e                	jne    801049a8 <acquire+0x98>
  popcli();
8010492a:	e8 e1 fe ff ff       	call   80104810 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010492f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104938:	8b 55 08             	mov    0x8(%ebp),%edx
8010493b:	89 c8                	mov    %ecx,%eax
8010493d:	f0 87 02             	lock xchg %eax,(%edx)
80104940:	85 c0                	test   %eax,%eax
80104942:	75 f4                	jne    80104938 <acquire+0x28>
  __sync_synchronize();
80104944:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104949:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010494c:	e8 af f0 ff ff       	call   80103a00 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104951:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104954:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104956:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104959:	31 c0                	xor    %eax,%eax
8010495b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010495f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104960:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104966:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010496c:	77 1a                	ja     80104988 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010496e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104971:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104975:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104978:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010497a:	83 f8 0a             	cmp    $0xa,%eax
8010497d:	75 e1                	jne    80104960 <acquire+0x50>
}
8010497f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104982:	c9                   	leave  
80104983:	c3                   	ret    
80104984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104988:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010498c:	8d 51 34             	lea    0x34(%ecx),%edx
8010498f:	90                   	nop
    pcs[i] = 0;
80104990:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104996:	83 c0 04             	add    $0x4,%eax
80104999:	39 c2                	cmp    %eax,%edx
8010499b:	75 f3                	jne    80104990 <acquire+0x80>
}
8010499d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049a0:	c9                   	leave  
801049a1:	c3                   	ret    
801049a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801049a8:	8b 5b 08             	mov    0x8(%ebx),%ebx
801049ab:	e8 50 f0 ff ff       	call   80103a00 <mycpu>
801049b0:	39 c3                	cmp    %eax,%ebx
801049b2:	0f 85 72 ff ff ff    	jne    8010492a <acquire+0x1a>
  popcli();
801049b8:	e8 53 fe ff ff       	call   80104810 <popcli>
    panic("acquire");
801049bd:	83 ec 0c             	sub    $0xc,%esp
801049c0:	68 b5 7f 10 80       	push   $0x80107fb5
801049c5:	e8 b6 b9 ff ff       	call   80100380 <panic>
801049ca:	66 90                	xchg   %ax,%ax
801049cc:	66 90                	xchg   %ax,%ax
801049ce:	66 90                	xchg   %ax,%ax

801049d0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	57                   	push   %edi
801049d4:	8b 55 08             	mov    0x8(%ebp),%edx
801049d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801049da:	53                   	push   %ebx
801049db:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801049de:	89 d7                	mov    %edx,%edi
801049e0:	09 cf                	or     %ecx,%edi
801049e2:	83 e7 03             	and    $0x3,%edi
801049e5:	75 29                	jne    80104a10 <memset+0x40>
    c &= 0xFF;
801049e7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801049ea:	c1 e0 18             	shl    $0x18,%eax
801049ed:	89 fb                	mov    %edi,%ebx
801049ef:	c1 e9 02             	shr    $0x2,%ecx
801049f2:	c1 e3 10             	shl    $0x10,%ebx
801049f5:	09 d8                	or     %ebx,%eax
801049f7:	09 f8                	or     %edi,%eax
801049f9:	c1 e7 08             	shl    $0x8,%edi
801049fc:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801049fe:	89 d7                	mov    %edx,%edi
80104a00:	fc                   	cld    
80104a01:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104a03:	5b                   	pop    %ebx
80104a04:	89 d0                	mov    %edx,%eax
80104a06:	5f                   	pop    %edi
80104a07:	5d                   	pop    %ebp
80104a08:	c3                   	ret    
80104a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104a10:	89 d7                	mov    %edx,%edi
80104a12:	fc                   	cld    
80104a13:	f3 aa                	rep stos %al,%es:(%edi)
80104a15:	5b                   	pop    %ebx
80104a16:	89 d0                	mov    %edx,%eax
80104a18:	5f                   	pop    %edi
80104a19:	5d                   	pop    %ebp
80104a1a:	c3                   	ret    
80104a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a1f:	90                   	nop

80104a20 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	56                   	push   %esi
80104a24:	8b 75 10             	mov    0x10(%ebp),%esi
80104a27:	8b 55 08             	mov    0x8(%ebp),%edx
80104a2a:	53                   	push   %ebx
80104a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104a2e:	85 f6                	test   %esi,%esi
80104a30:	74 2e                	je     80104a60 <memcmp+0x40>
80104a32:	01 c6                	add    %eax,%esi
80104a34:	eb 14                	jmp    80104a4a <memcmp+0x2a>
80104a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104a40:	83 c0 01             	add    $0x1,%eax
80104a43:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104a46:	39 f0                	cmp    %esi,%eax
80104a48:	74 16                	je     80104a60 <memcmp+0x40>
    if(*s1 != *s2)
80104a4a:	0f b6 0a             	movzbl (%edx),%ecx
80104a4d:	0f b6 18             	movzbl (%eax),%ebx
80104a50:	38 d9                	cmp    %bl,%cl
80104a52:	74 ec                	je     80104a40 <memcmp+0x20>
      return *s1 - *s2;
80104a54:	0f b6 c1             	movzbl %cl,%eax
80104a57:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104a59:	5b                   	pop    %ebx
80104a5a:	5e                   	pop    %esi
80104a5b:	5d                   	pop    %ebp
80104a5c:	c3                   	ret    
80104a5d:	8d 76 00             	lea    0x0(%esi),%esi
80104a60:	5b                   	pop    %ebx
  return 0;
80104a61:	31 c0                	xor    %eax,%eax
}
80104a63:	5e                   	pop    %esi
80104a64:	5d                   	pop    %ebp
80104a65:	c3                   	ret    
80104a66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a6d:	8d 76 00             	lea    0x0(%esi),%esi

80104a70 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	57                   	push   %edi
80104a74:	8b 55 08             	mov    0x8(%ebp),%edx
80104a77:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a7a:	56                   	push   %esi
80104a7b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104a7e:	39 d6                	cmp    %edx,%esi
80104a80:	73 26                	jae    80104aa8 <memmove+0x38>
80104a82:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104a85:	39 fa                	cmp    %edi,%edx
80104a87:	73 1f                	jae    80104aa8 <memmove+0x38>
80104a89:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104a8c:	85 c9                	test   %ecx,%ecx
80104a8e:	74 0c                	je     80104a9c <memmove+0x2c>
      *--d = *--s;
80104a90:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104a94:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104a97:	83 e8 01             	sub    $0x1,%eax
80104a9a:	73 f4                	jae    80104a90 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104a9c:	5e                   	pop    %esi
80104a9d:	89 d0                	mov    %edx,%eax
80104a9f:	5f                   	pop    %edi
80104aa0:	5d                   	pop    %ebp
80104aa1:	c3                   	ret    
80104aa2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104aa8:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104aab:	89 d7                	mov    %edx,%edi
80104aad:	85 c9                	test   %ecx,%ecx
80104aaf:	74 eb                	je     80104a9c <memmove+0x2c>
80104ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104ab8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104ab9:	39 f0                	cmp    %esi,%eax
80104abb:	75 fb                	jne    80104ab8 <memmove+0x48>
}
80104abd:	5e                   	pop    %esi
80104abe:	89 d0                	mov    %edx,%eax
80104ac0:	5f                   	pop    %edi
80104ac1:	5d                   	pop    %ebp
80104ac2:	c3                   	ret    
80104ac3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ad0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104ad0:	eb 9e                	jmp    80104a70 <memmove>
80104ad2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ae0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	56                   	push   %esi
80104ae4:	8b 75 10             	mov    0x10(%ebp),%esi
80104ae7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104aea:	53                   	push   %ebx
80104aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104aee:	85 f6                	test   %esi,%esi
80104af0:	74 36                	je     80104b28 <strncmp+0x48>
80104af2:	01 c6                	add    %eax,%esi
80104af4:	eb 18                	jmp    80104b0e <strncmp+0x2e>
80104af6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104afd:	8d 76 00             	lea    0x0(%esi),%esi
80104b00:	38 da                	cmp    %bl,%dl
80104b02:	75 14                	jne    80104b18 <strncmp+0x38>
    n--, p++, q++;
80104b04:	83 c0 01             	add    $0x1,%eax
80104b07:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104b0a:	39 f0                	cmp    %esi,%eax
80104b0c:	74 1a                	je     80104b28 <strncmp+0x48>
80104b0e:	0f b6 11             	movzbl (%ecx),%edx
80104b11:	0f b6 18             	movzbl (%eax),%ebx
80104b14:	84 d2                	test   %dl,%dl
80104b16:	75 e8                	jne    80104b00 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104b18:	0f b6 c2             	movzbl %dl,%eax
80104b1b:	29 d8                	sub    %ebx,%eax
}
80104b1d:	5b                   	pop    %ebx
80104b1e:	5e                   	pop    %esi
80104b1f:	5d                   	pop    %ebp
80104b20:	c3                   	ret    
80104b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b28:	5b                   	pop    %ebx
    return 0;
80104b29:	31 c0                	xor    %eax,%eax
}
80104b2b:	5e                   	pop    %esi
80104b2c:	5d                   	pop    %ebp
80104b2d:	c3                   	ret    
80104b2e:	66 90                	xchg   %ax,%ax

80104b30 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	57                   	push   %edi
80104b34:	56                   	push   %esi
80104b35:	8b 75 08             	mov    0x8(%ebp),%esi
80104b38:	53                   	push   %ebx
80104b39:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104b3c:	89 f2                	mov    %esi,%edx
80104b3e:	eb 17                	jmp    80104b57 <strncpy+0x27>
80104b40:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104b44:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104b47:	83 c2 01             	add    $0x1,%edx
80104b4a:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104b4e:	89 f9                	mov    %edi,%ecx
80104b50:	88 4a ff             	mov    %cl,-0x1(%edx)
80104b53:	84 c9                	test   %cl,%cl
80104b55:	74 09                	je     80104b60 <strncpy+0x30>
80104b57:	89 c3                	mov    %eax,%ebx
80104b59:	83 e8 01             	sub    $0x1,%eax
80104b5c:	85 db                	test   %ebx,%ebx
80104b5e:	7f e0                	jg     80104b40 <strncpy+0x10>
    ;
  while(n-- > 0)
80104b60:	89 d1                	mov    %edx,%ecx
80104b62:	85 c0                	test   %eax,%eax
80104b64:	7e 1d                	jle    80104b83 <strncpy+0x53>
80104b66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b6d:	8d 76 00             	lea    0x0(%esi),%esi
    *s++ = 0;
80104b70:	83 c1 01             	add    $0x1,%ecx
80104b73:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104b77:	89 c8                	mov    %ecx,%eax
80104b79:	f7 d0                	not    %eax
80104b7b:	01 d0                	add    %edx,%eax
80104b7d:	01 d8                	add    %ebx,%eax
80104b7f:	85 c0                	test   %eax,%eax
80104b81:	7f ed                	jg     80104b70 <strncpy+0x40>
  return os;
}
80104b83:	5b                   	pop    %ebx
80104b84:	89 f0                	mov    %esi,%eax
80104b86:	5e                   	pop    %esi
80104b87:	5f                   	pop    %edi
80104b88:	5d                   	pop    %ebp
80104b89:	c3                   	ret    
80104b8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b90 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	56                   	push   %esi
80104b94:	8b 55 10             	mov    0x10(%ebp),%edx
80104b97:	8b 75 08             	mov    0x8(%ebp),%esi
80104b9a:	53                   	push   %ebx
80104b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104b9e:	85 d2                	test   %edx,%edx
80104ba0:	7e 25                	jle    80104bc7 <safestrcpy+0x37>
80104ba2:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104ba6:	89 f2                	mov    %esi,%edx
80104ba8:	eb 16                	jmp    80104bc0 <safestrcpy+0x30>
80104baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104bb0:	0f b6 08             	movzbl (%eax),%ecx
80104bb3:	83 c0 01             	add    $0x1,%eax
80104bb6:	83 c2 01             	add    $0x1,%edx
80104bb9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104bbc:	84 c9                	test   %cl,%cl
80104bbe:	74 04                	je     80104bc4 <safestrcpy+0x34>
80104bc0:	39 d8                	cmp    %ebx,%eax
80104bc2:	75 ec                	jne    80104bb0 <safestrcpy+0x20>
    ;
  *s = 0;
80104bc4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104bc7:	89 f0                	mov    %esi,%eax
80104bc9:	5b                   	pop    %ebx
80104bca:	5e                   	pop    %esi
80104bcb:	5d                   	pop    %ebp
80104bcc:	c3                   	ret    
80104bcd:	8d 76 00             	lea    0x0(%esi),%esi

80104bd0 <strlen>:

int
strlen(const char *s)
{
80104bd0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104bd1:	31 c0                	xor    %eax,%eax
{
80104bd3:	89 e5                	mov    %esp,%ebp
80104bd5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104bd8:	80 3a 00             	cmpb   $0x0,(%edx)
80104bdb:	74 0c                	je     80104be9 <strlen+0x19>
80104bdd:	8d 76 00             	lea    0x0(%esi),%esi
80104be0:	83 c0 01             	add    $0x1,%eax
80104be3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104be7:	75 f7                	jne    80104be0 <strlen+0x10>
    ;
  return n;
}
80104be9:	5d                   	pop    %ebp
80104bea:	c3                   	ret    

80104beb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104beb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104bef:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104bf3:	55                   	push   %ebp
  pushl %ebx
80104bf4:	53                   	push   %ebx
  pushl %esi
80104bf5:	56                   	push   %esi
  pushl %edi
80104bf6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104bf7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104bf9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104bfb:	5f                   	pop    %edi
  popl %esi
80104bfc:	5e                   	pop    %esi
  popl %ebx
80104bfd:	5b                   	pop    %ebx
  popl %ebp
80104bfe:	5d                   	pop    %ebp
  ret
80104bff:	c3                   	ret    

80104c00 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104c00:	55                   	push   %ebp
80104c01:	89 e5                	mov    %esp,%ebp
80104c03:	53                   	push   %ebx
80104c04:	83 ec 04             	sub    $0x4,%esp
80104c07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104c0a:	e8 81 ee ff ff       	call   80103a90 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c0f:	8b 00                	mov    (%eax),%eax
80104c11:	39 d8                	cmp    %ebx,%eax
80104c13:	76 1b                	jbe    80104c30 <fetchint+0x30>
80104c15:	8d 53 04             	lea    0x4(%ebx),%edx
80104c18:	39 d0                	cmp    %edx,%eax
80104c1a:	72 14                	jb     80104c30 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104c1c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c1f:	8b 13                	mov    (%ebx),%edx
80104c21:	89 10                	mov    %edx,(%eax)
  return 0;
80104c23:	31 c0                	xor    %eax,%eax
}
80104c25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c28:	c9                   	leave  
80104c29:	c3                   	ret    
80104c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104c30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c35:	eb ee                	jmp    80104c25 <fetchint+0x25>
80104c37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c3e:	66 90                	xchg   %ax,%ax

80104c40 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	53                   	push   %ebx
80104c44:	83 ec 04             	sub    $0x4,%esp
80104c47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104c4a:	e8 41 ee ff ff       	call   80103a90 <myproc>

  if(addr >= curproc->sz)
80104c4f:	39 18                	cmp    %ebx,(%eax)
80104c51:	76 2d                	jbe    80104c80 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104c53:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c56:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c58:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c5a:	39 d3                	cmp    %edx,%ebx
80104c5c:	73 22                	jae    80104c80 <fetchstr+0x40>
80104c5e:	89 d8                	mov    %ebx,%eax
80104c60:	eb 0d                	jmp    80104c6f <fetchstr+0x2f>
80104c62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c68:	83 c0 01             	add    $0x1,%eax
80104c6b:	39 c2                	cmp    %eax,%edx
80104c6d:	76 11                	jbe    80104c80 <fetchstr+0x40>
    if(*s == 0)
80104c6f:	80 38 00             	cmpb   $0x0,(%eax)
80104c72:	75 f4                	jne    80104c68 <fetchstr+0x28>
      return s - *pp;
80104c74:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104c76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c79:	c9                   	leave  
80104c7a:	c3                   	ret    
80104c7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c7f:	90                   	nop
80104c80:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104c83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c88:	c9                   	leave  
80104c89:	c3                   	ret    
80104c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c90 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	56                   	push   %esi
80104c94:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c95:	e8 f6 ed ff ff       	call   80103a90 <myproc>
80104c9a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c9d:	8b 40 18             	mov    0x18(%eax),%eax
80104ca0:	8b 40 44             	mov    0x44(%eax),%eax
80104ca3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ca6:	e8 e5 ed ff ff       	call   80103a90 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cab:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cae:	8b 00                	mov    (%eax),%eax
80104cb0:	39 c6                	cmp    %eax,%esi
80104cb2:	73 1c                	jae    80104cd0 <argint+0x40>
80104cb4:	8d 53 08             	lea    0x8(%ebx),%edx
80104cb7:	39 d0                	cmp    %edx,%eax
80104cb9:	72 15                	jb     80104cd0 <argint+0x40>
  *ip = *(int*)(addr);
80104cbb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cbe:	8b 53 04             	mov    0x4(%ebx),%edx
80104cc1:	89 10                	mov    %edx,(%eax)
  return 0;
80104cc3:	31 c0                	xor    %eax,%eax
}
80104cc5:	5b                   	pop    %ebx
80104cc6:	5e                   	pop    %esi
80104cc7:	5d                   	pop    %ebp
80104cc8:	c3                   	ret    
80104cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104cd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cd5:	eb ee                	jmp    80104cc5 <argint+0x35>
80104cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cde:	66 90                	xchg   %ax,%ax

80104ce0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	57                   	push   %edi
80104ce4:	56                   	push   %esi
80104ce5:	53                   	push   %ebx
80104ce6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104ce9:	e8 a2 ed ff ff       	call   80103a90 <myproc>
80104cee:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cf0:	e8 9b ed ff ff       	call   80103a90 <myproc>
80104cf5:	8b 55 08             	mov    0x8(%ebp),%edx
80104cf8:	8b 40 18             	mov    0x18(%eax),%eax
80104cfb:	8b 40 44             	mov    0x44(%eax),%eax
80104cfe:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104d01:	e8 8a ed ff ff       	call   80103a90 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d06:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d09:	8b 00                	mov    (%eax),%eax
80104d0b:	39 c7                	cmp    %eax,%edi
80104d0d:	73 31                	jae    80104d40 <argptr+0x60>
80104d0f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104d12:	39 c8                	cmp    %ecx,%eax
80104d14:	72 2a                	jb     80104d40 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104d16:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104d19:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104d1c:	85 d2                	test   %edx,%edx
80104d1e:	78 20                	js     80104d40 <argptr+0x60>
80104d20:	8b 16                	mov    (%esi),%edx
80104d22:	39 c2                	cmp    %eax,%edx
80104d24:	76 1a                	jbe    80104d40 <argptr+0x60>
80104d26:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104d29:	01 c3                	add    %eax,%ebx
80104d2b:	39 da                	cmp    %ebx,%edx
80104d2d:	72 11                	jb     80104d40 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104d2f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d32:	89 02                	mov    %eax,(%edx)
  return 0;
80104d34:	31 c0                	xor    %eax,%eax
}
80104d36:	83 c4 0c             	add    $0xc,%esp
80104d39:	5b                   	pop    %ebx
80104d3a:	5e                   	pop    %esi
80104d3b:	5f                   	pop    %edi
80104d3c:	5d                   	pop    %ebp
80104d3d:	c3                   	ret    
80104d3e:	66 90                	xchg   %ax,%ax
    return -1;
80104d40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d45:	eb ef                	jmp    80104d36 <argptr+0x56>
80104d47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d4e:	66 90                	xchg   %ax,%ax

80104d50 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104d50:	55                   	push   %ebp
80104d51:	89 e5                	mov    %esp,%ebp
80104d53:	56                   	push   %esi
80104d54:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d55:	e8 36 ed ff ff       	call   80103a90 <myproc>
80104d5a:	8b 55 08             	mov    0x8(%ebp),%edx
80104d5d:	8b 40 18             	mov    0x18(%eax),%eax
80104d60:	8b 40 44             	mov    0x44(%eax),%eax
80104d63:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104d66:	e8 25 ed ff ff       	call   80103a90 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d6b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d6e:	8b 00                	mov    (%eax),%eax
80104d70:	39 c6                	cmp    %eax,%esi
80104d72:	73 44                	jae    80104db8 <argstr+0x68>
80104d74:	8d 53 08             	lea    0x8(%ebx),%edx
80104d77:	39 d0                	cmp    %edx,%eax
80104d79:	72 3d                	jb     80104db8 <argstr+0x68>
  *ip = *(int*)(addr);
80104d7b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104d7e:	e8 0d ed ff ff       	call   80103a90 <myproc>
  if(addr >= curproc->sz)
80104d83:	3b 18                	cmp    (%eax),%ebx
80104d85:	73 31                	jae    80104db8 <argstr+0x68>
  *pp = (char*)addr;
80104d87:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d8a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104d8c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104d8e:	39 d3                	cmp    %edx,%ebx
80104d90:	73 26                	jae    80104db8 <argstr+0x68>
80104d92:	89 d8                	mov    %ebx,%eax
80104d94:	eb 11                	jmp    80104da7 <argstr+0x57>
80104d96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d9d:	8d 76 00             	lea    0x0(%esi),%esi
80104da0:	83 c0 01             	add    $0x1,%eax
80104da3:	39 c2                	cmp    %eax,%edx
80104da5:	76 11                	jbe    80104db8 <argstr+0x68>
    if(*s == 0)
80104da7:	80 38 00             	cmpb   $0x0,(%eax)
80104daa:	75 f4                	jne    80104da0 <argstr+0x50>
      return s - *pp;
80104dac:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104dae:	5b                   	pop    %ebx
80104daf:	5e                   	pop    %esi
80104db0:	5d                   	pop    %ebp
80104db1:	c3                   	ret    
80104db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104db8:	5b                   	pop    %ebx
    return -1;
80104db9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dbe:	5e                   	pop    %esi
80104dbf:	5d                   	pop    %ebp
80104dc0:	c3                   	ret    
80104dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dcf:	90                   	nop

80104dd0 <initializeSyscalls>:
        functionList[SYS_##name].index = SYS_##name;

    #include "syscall.h"

    #undef SYSCALL
}
80104dd0:	c3                   	ret    
80104dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dd8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ddf:	90                   	nop

80104de0 <syscall>:
int trace_state = 0; // 0 means no tracking, 1 means tracking
int syscall_count[1+NELEM(functionList)];

void
syscall(void)
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	53                   	push   %ebx
80104de4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104de7:	e8 a4 ec ff ff       	call   80103a90 <myproc>
80104dec:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104dee:	8b 40 18             	mov    0x18(%eax),%eax
80104df1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104df4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104df7:	83 fa 1b             	cmp    $0x1b,%edx
80104dfa:	77 34                	ja     80104e30 <syscall+0x50>
80104dfc:	8b 14 85 00 81 10 80 	mov    -0x7fef7f00(,%eax,4),%edx
80104e03:	85 d2                	test   %edx,%edx
80104e05:	74 29                	je     80104e30 <syscall+0x50>
    if (trace_state){
80104e07:	8b 0d d4 62 11 80    	mov    0x801162d4,%ecx
80104e0d:	85 c9                	test   %ecx,%ecx
80104e0f:	74 08                	je     80104e19 <syscall+0x39>
    // cprintf(" syscall%d\n",num);
      syscall_count[num] ++; // Increment the frequency count corresponding to the syscall num
80104e11:	83 04 85 60 62 11 80 	addl   $0x1,-0x7fee9da0(,%eax,4)
80104e18:	01 
    }
    curproc->tf->eax = syscalls[num]();
80104e19:	ff d2                	call   *%edx
80104e1b:	89 c2                	mov    %eax,%edx
80104e1d:	8b 43 18             	mov    0x18(%ebx),%eax
80104e20:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
80104e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e26:	c9                   	leave  
80104e27:	c3                   	ret    
80104e28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e2f:	90                   	nop
    cprintf("%d %s: unknown sys call %d\n",
80104e30:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104e31:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104e34:	50                   	push   %eax
80104e35:	ff 73 10             	pushl  0x10(%ebx)
80104e38:	68 bd 7f 10 80       	push   $0x80107fbd
80104e3d:	e8 3e b8 ff ff       	call   80100680 <cprintf>
    curproc->tf->eax = -1;
80104e42:	8b 43 18             	mov    0x18(%ebx),%eax
80104e45:	83 c4 10             	add    $0x10,%esp
80104e48:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80104e4f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e52:	c9                   	leave  
80104e53:	c3                   	ret    
80104e54:	66 90                	xchg   %ax,%ax
80104e56:	66 90                	xchg   %ax,%ax
80104e58:	66 90                	xchg   %ax,%ax
80104e5a:	66 90                	xchg   %ax,%ax
80104e5c:	66 90                	xchg   %ax,%ax
80104e5e:	66 90                	xchg   %ax,%ax

80104e60 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	57                   	push   %edi
80104e64:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104e65:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104e68:	53                   	push   %ebx
80104e69:	83 ec 34             	sub    $0x34,%esp
80104e6c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104e6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104e72:	57                   	push   %edi
80104e73:	50                   	push   %eax
{
80104e74:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104e77:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104e7a:	e8 51 d3 ff ff       	call   801021d0 <nameiparent>
80104e7f:	83 c4 10             	add    $0x10,%esp
80104e82:	85 c0                	test   %eax,%eax
80104e84:	0f 84 46 01 00 00    	je     80104fd0 <create+0x170>
    return 0;
  ilock(dp);
80104e8a:	83 ec 0c             	sub    $0xc,%esp
80104e8d:	89 c3                	mov    %eax,%ebx
80104e8f:	50                   	push   %eax
80104e90:	e8 fb c9 ff ff       	call   80101890 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104e95:	83 c4 0c             	add    $0xc,%esp
80104e98:	6a 00                	push   $0x0
80104e9a:	57                   	push   %edi
80104e9b:	53                   	push   %ebx
80104e9c:	e8 4f cf ff ff       	call   80101df0 <dirlookup>
80104ea1:	83 c4 10             	add    $0x10,%esp
80104ea4:	89 c6                	mov    %eax,%esi
80104ea6:	85 c0                	test   %eax,%eax
80104ea8:	74 56                	je     80104f00 <create+0xa0>
    iunlockput(dp);
80104eaa:	83 ec 0c             	sub    $0xc,%esp
80104ead:	53                   	push   %ebx
80104eae:	e8 6d cc ff ff       	call   80101b20 <iunlockput>
    ilock(ip);
80104eb3:	89 34 24             	mov    %esi,(%esp)
80104eb6:	e8 d5 c9 ff ff       	call   80101890 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104ebb:	83 c4 10             	add    $0x10,%esp
80104ebe:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104ec3:	75 1b                	jne    80104ee0 <create+0x80>
80104ec5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104eca:	75 14                	jne    80104ee0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104ecc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ecf:	89 f0                	mov    %esi,%eax
80104ed1:	5b                   	pop    %ebx
80104ed2:	5e                   	pop    %esi
80104ed3:	5f                   	pop    %edi
80104ed4:	5d                   	pop    %ebp
80104ed5:	c3                   	ret    
80104ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104edd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104ee0:	83 ec 0c             	sub    $0xc,%esp
80104ee3:	56                   	push   %esi
    return 0;
80104ee4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104ee6:	e8 35 cc ff ff       	call   80101b20 <iunlockput>
    return 0;
80104eeb:	83 c4 10             	add    $0x10,%esp
}
80104eee:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ef1:	89 f0                	mov    %esi,%eax
80104ef3:	5b                   	pop    %ebx
80104ef4:	5e                   	pop    %esi
80104ef5:	5f                   	pop    %edi
80104ef6:	5d                   	pop    %ebp
80104ef7:	c3                   	ret    
80104ef8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eff:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104f00:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104f04:	83 ec 08             	sub    $0x8,%esp
80104f07:	50                   	push   %eax
80104f08:	ff 33                	pushl  (%ebx)
80104f0a:	e8 11 c8 ff ff       	call   80101720 <ialloc>
80104f0f:	83 c4 10             	add    $0x10,%esp
80104f12:	89 c6                	mov    %eax,%esi
80104f14:	85 c0                	test   %eax,%eax
80104f16:	0f 84 cd 00 00 00    	je     80104fe9 <create+0x189>
  ilock(ip);
80104f1c:	83 ec 0c             	sub    $0xc,%esp
80104f1f:	50                   	push   %eax
80104f20:	e8 6b c9 ff ff       	call   80101890 <ilock>
  ip->major = major;
80104f25:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104f29:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104f2d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104f31:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104f35:	b8 01 00 00 00       	mov    $0x1,%eax
80104f3a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104f3e:	89 34 24             	mov    %esi,(%esp)
80104f41:	e8 9a c8 ff ff       	call   801017e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104f46:	83 c4 10             	add    $0x10,%esp
80104f49:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104f4e:	74 30                	je     80104f80 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104f50:	83 ec 04             	sub    $0x4,%esp
80104f53:	ff 76 04             	pushl  0x4(%esi)
80104f56:	57                   	push   %edi
80104f57:	53                   	push   %ebx
80104f58:	e8 93 d1 ff ff       	call   801020f0 <dirlink>
80104f5d:	83 c4 10             	add    $0x10,%esp
80104f60:	85 c0                	test   %eax,%eax
80104f62:	78 78                	js     80104fdc <create+0x17c>
  iunlockput(dp);
80104f64:	83 ec 0c             	sub    $0xc,%esp
80104f67:	53                   	push   %ebx
80104f68:	e8 b3 cb ff ff       	call   80101b20 <iunlockput>
  return ip;
80104f6d:	83 c4 10             	add    $0x10,%esp
}
80104f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f73:	89 f0                	mov    %esi,%eax
80104f75:	5b                   	pop    %ebx
80104f76:	5e                   	pop    %esi
80104f77:	5f                   	pop    %edi
80104f78:	5d                   	pop    %ebp
80104f79:	c3                   	ret    
80104f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104f80:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104f83:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104f88:	53                   	push   %ebx
80104f89:	e8 52 c8 ff ff       	call   801017e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104f8e:	83 c4 0c             	add    $0xc,%esp
80104f91:	ff 76 04             	pushl  0x4(%esi)
80104f94:	68 90 81 10 80       	push   $0x80108190
80104f99:	56                   	push   %esi
80104f9a:	e8 51 d1 ff ff       	call   801020f0 <dirlink>
80104f9f:	83 c4 10             	add    $0x10,%esp
80104fa2:	85 c0                	test   %eax,%eax
80104fa4:	78 18                	js     80104fbe <create+0x15e>
80104fa6:	83 ec 04             	sub    $0x4,%esp
80104fa9:	ff 73 04             	pushl  0x4(%ebx)
80104fac:	68 8f 81 10 80       	push   $0x8010818f
80104fb1:	56                   	push   %esi
80104fb2:	e8 39 d1 ff ff       	call   801020f0 <dirlink>
80104fb7:	83 c4 10             	add    $0x10,%esp
80104fba:	85 c0                	test   %eax,%eax
80104fbc:	79 92                	jns    80104f50 <create+0xf0>
      panic("create dots");
80104fbe:	83 ec 0c             	sub    $0xc,%esp
80104fc1:	68 83 81 10 80       	push   $0x80108183
80104fc6:	e8 b5 b3 ff ff       	call   80100380 <panic>
80104fcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fcf:	90                   	nop
}
80104fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104fd3:	31 f6                	xor    %esi,%esi
}
80104fd5:	5b                   	pop    %ebx
80104fd6:	89 f0                	mov    %esi,%eax
80104fd8:	5e                   	pop    %esi
80104fd9:	5f                   	pop    %edi
80104fda:	5d                   	pop    %ebp
80104fdb:	c3                   	ret    
    panic("create: dirlink");
80104fdc:	83 ec 0c             	sub    $0xc,%esp
80104fdf:	68 92 81 10 80       	push   $0x80108192
80104fe4:	e8 97 b3 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104fe9:	83 ec 0c             	sub    $0xc,%esp
80104fec:	68 74 81 10 80       	push   $0x80108174
80104ff1:	e8 8a b3 ff ff       	call   80100380 <panic>
80104ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ffd:	8d 76 00             	lea    0x0(%esi),%esi

80105000 <sys_dup>:
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	56                   	push   %esi
80105004:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105005:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105008:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010500b:	50                   	push   %eax
8010500c:	6a 00                	push   $0x0
8010500e:	e8 7d fc ff ff       	call   80104c90 <argint>
80105013:	83 c4 10             	add    $0x10,%esp
80105016:	85 c0                	test   %eax,%eax
80105018:	78 36                	js     80105050 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010501a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010501e:	77 30                	ja     80105050 <sys_dup+0x50>
80105020:	e8 6b ea ff ff       	call   80103a90 <myproc>
80105025:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105028:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010502c:	85 f6                	test   %esi,%esi
8010502e:	74 20                	je     80105050 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105030:	e8 5b ea ff ff       	call   80103a90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105035:	31 db                	xor    %ebx,%ebx
80105037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010503e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105040:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105044:	85 d2                	test   %edx,%edx
80105046:	74 18                	je     80105060 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105048:	83 c3 01             	add    $0x1,%ebx
8010504b:	83 fb 10             	cmp    $0x10,%ebx
8010504e:	75 f0                	jne    80105040 <sys_dup+0x40>
}
80105050:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105053:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105058:	89 d8                	mov    %ebx,%eax
8010505a:	5b                   	pop    %ebx
8010505b:	5e                   	pop    %esi
8010505c:	5d                   	pop    %ebp
8010505d:	c3                   	ret    
8010505e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105060:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105063:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105067:	56                   	push   %esi
80105068:	e8 53 bf ff ff       	call   80100fc0 <filedup>
  return fd;
8010506d:	83 c4 10             	add    $0x10,%esp
}
80105070:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105073:	89 d8                	mov    %ebx,%eax
80105075:	5b                   	pop    %ebx
80105076:	5e                   	pop    %esi
80105077:	5d                   	pop    %ebp
80105078:	c3                   	ret    
80105079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105080 <sys_read>:
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	56                   	push   %esi
80105084:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105085:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105088:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010508b:	53                   	push   %ebx
8010508c:	6a 00                	push   $0x0
8010508e:	e8 fd fb ff ff       	call   80104c90 <argint>
80105093:	83 c4 10             	add    $0x10,%esp
80105096:	85 c0                	test   %eax,%eax
80105098:	78 5e                	js     801050f8 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010509a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010509e:	77 58                	ja     801050f8 <sys_read+0x78>
801050a0:	e8 eb e9 ff ff       	call   80103a90 <myproc>
801050a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050a8:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
801050ac:	85 f6                	test   %esi,%esi
801050ae:	74 48                	je     801050f8 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050b0:	83 ec 08             	sub    $0x8,%esp
801050b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050b6:	50                   	push   %eax
801050b7:	6a 02                	push   $0x2
801050b9:	e8 d2 fb ff ff       	call   80104c90 <argint>
801050be:	83 c4 10             	add    $0x10,%esp
801050c1:	85 c0                	test   %eax,%eax
801050c3:	78 33                	js     801050f8 <sys_read+0x78>
801050c5:	83 ec 04             	sub    $0x4,%esp
801050c8:	ff 75 f0             	pushl  -0x10(%ebp)
801050cb:	53                   	push   %ebx
801050cc:	6a 01                	push   $0x1
801050ce:	e8 0d fc ff ff       	call   80104ce0 <argptr>
801050d3:	83 c4 10             	add    $0x10,%esp
801050d6:	85 c0                	test   %eax,%eax
801050d8:	78 1e                	js     801050f8 <sys_read+0x78>
  return fileread(f, p, n);
801050da:	83 ec 04             	sub    $0x4,%esp
801050dd:	ff 75 f0             	pushl  -0x10(%ebp)
801050e0:	ff 75 f4             	pushl  -0xc(%ebp)
801050e3:	56                   	push   %esi
801050e4:	e8 57 c0 ff ff       	call   80101140 <fileread>
801050e9:	83 c4 10             	add    $0x10,%esp
}
801050ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050ef:	5b                   	pop    %ebx
801050f0:	5e                   	pop    %esi
801050f1:	5d                   	pop    %ebp
801050f2:	c3                   	ret    
801050f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050f7:	90                   	nop
    return -1;
801050f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050fd:	eb ed                	jmp    801050ec <sys_read+0x6c>
801050ff:	90                   	nop

80105100 <sys_write>:
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	56                   	push   %esi
80105104:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105105:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105108:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010510b:	53                   	push   %ebx
8010510c:	6a 00                	push   $0x0
8010510e:	e8 7d fb ff ff       	call   80104c90 <argint>
80105113:	83 c4 10             	add    $0x10,%esp
80105116:	85 c0                	test   %eax,%eax
80105118:	78 5e                	js     80105178 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010511a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010511e:	77 58                	ja     80105178 <sys_write+0x78>
80105120:	e8 6b e9 ff ff       	call   80103a90 <myproc>
80105125:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105128:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010512c:	85 f6                	test   %esi,%esi
8010512e:	74 48                	je     80105178 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105130:	83 ec 08             	sub    $0x8,%esp
80105133:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105136:	50                   	push   %eax
80105137:	6a 02                	push   $0x2
80105139:	e8 52 fb ff ff       	call   80104c90 <argint>
8010513e:	83 c4 10             	add    $0x10,%esp
80105141:	85 c0                	test   %eax,%eax
80105143:	78 33                	js     80105178 <sys_write+0x78>
80105145:	83 ec 04             	sub    $0x4,%esp
80105148:	ff 75 f0             	pushl  -0x10(%ebp)
8010514b:	53                   	push   %ebx
8010514c:	6a 01                	push   $0x1
8010514e:	e8 8d fb ff ff       	call   80104ce0 <argptr>
80105153:	83 c4 10             	add    $0x10,%esp
80105156:	85 c0                	test   %eax,%eax
80105158:	78 1e                	js     80105178 <sys_write+0x78>
  return filewrite(f, p, n);
8010515a:	83 ec 04             	sub    $0x4,%esp
8010515d:	ff 75 f0             	pushl  -0x10(%ebp)
80105160:	ff 75 f4             	pushl  -0xc(%ebp)
80105163:	56                   	push   %esi
80105164:	e8 67 c0 ff ff       	call   801011d0 <filewrite>
80105169:	83 c4 10             	add    $0x10,%esp
}
8010516c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010516f:	5b                   	pop    %ebx
80105170:	5e                   	pop    %esi
80105171:	5d                   	pop    %ebp
80105172:	c3                   	ret    
80105173:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105177:	90                   	nop
    return -1;
80105178:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010517d:	eb ed                	jmp    8010516c <sys_write+0x6c>
8010517f:	90                   	nop

80105180 <sys_close>:
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	56                   	push   %esi
80105184:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105185:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105188:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010518b:	50                   	push   %eax
8010518c:	6a 00                	push   $0x0
8010518e:	e8 fd fa ff ff       	call   80104c90 <argint>
80105193:	83 c4 10             	add    $0x10,%esp
80105196:	85 c0                	test   %eax,%eax
80105198:	78 3e                	js     801051d8 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010519a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010519e:	77 38                	ja     801051d8 <sys_close+0x58>
801051a0:	e8 eb e8 ff ff       	call   80103a90 <myproc>
801051a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801051a8:	8d 5a 08             	lea    0x8(%edx),%ebx
801051ab:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801051af:	85 f6                	test   %esi,%esi
801051b1:	74 25                	je     801051d8 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801051b3:	e8 d8 e8 ff ff       	call   80103a90 <myproc>
  fileclose(f);
801051b8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801051bb:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
801051c2:	00 
  fileclose(f);
801051c3:	56                   	push   %esi
801051c4:	e8 47 be ff ff       	call   80101010 <fileclose>
  return 0;
801051c9:	83 c4 10             	add    $0x10,%esp
801051cc:	31 c0                	xor    %eax,%eax
}
801051ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051d1:	5b                   	pop    %ebx
801051d2:	5e                   	pop    %esi
801051d3:	5d                   	pop    %ebp
801051d4:	c3                   	ret    
801051d5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801051d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051dd:	eb ef                	jmp    801051ce <sys_close+0x4e>
801051df:	90                   	nop

801051e0 <sys_fstat>:
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	56                   	push   %esi
801051e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801051e5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801051e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801051eb:	53                   	push   %ebx
801051ec:	6a 00                	push   $0x0
801051ee:	e8 9d fa ff ff       	call   80104c90 <argint>
801051f3:	83 c4 10             	add    $0x10,%esp
801051f6:	85 c0                	test   %eax,%eax
801051f8:	78 46                	js     80105240 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801051fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801051fe:	77 40                	ja     80105240 <sys_fstat+0x60>
80105200:	e8 8b e8 ff ff       	call   80103a90 <myproc>
80105205:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105208:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010520c:	85 f6                	test   %esi,%esi
8010520e:	74 30                	je     80105240 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105210:	83 ec 04             	sub    $0x4,%esp
80105213:	6a 14                	push   $0x14
80105215:	53                   	push   %ebx
80105216:	6a 01                	push   $0x1
80105218:	e8 c3 fa ff ff       	call   80104ce0 <argptr>
8010521d:	83 c4 10             	add    $0x10,%esp
80105220:	85 c0                	test   %eax,%eax
80105222:	78 1c                	js     80105240 <sys_fstat+0x60>
  return filestat(f, st);
80105224:	83 ec 08             	sub    $0x8,%esp
80105227:	ff 75 f4             	pushl  -0xc(%ebp)
8010522a:	56                   	push   %esi
8010522b:	e8 c0 be ff ff       	call   801010f0 <filestat>
80105230:	83 c4 10             	add    $0x10,%esp
}
80105233:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105236:	5b                   	pop    %ebx
80105237:	5e                   	pop    %esi
80105238:	5d                   	pop    %ebp
80105239:	c3                   	ret    
8010523a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105240:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105245:	eb ec                	jmp    80105233 <sys_fstat+0x53>
80105247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010524e:	66 90                	xchg   %ax,%ax

80105250 <sys_link>:
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	57                   	push   %edi
80105254:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105255:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105258:	53                   	push   %ebx
80105259:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010525c:	50                   	push   %eax
8010525d:	6a 00                	push   $0x0
8010525f:	e8 ec fa ff ff       	call   80104d50 <argstr>
80105264:	83 c4 10             	add    $0x10,%esp
80105267:	85 c0                	test   %eax,%eax
80105269:	0f 88 fb 00 00 00    	js     8010536a <sys_link+0x11a>
8010526f:	83 ec 08             	sub    $0x8,%esp
80105272:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105275:	50                   	push   %eax
80105276:	6a 01                	push   $0x1
80105278:	e8 d3 fa ff ff       	call   80104d50 <argstr>
8010527d:	83 c4 10             	add    $0x10,%esp
80105280:	85 c0                	test   %eax,%eax
80105282:	0f 88 e2 00 00 00    	js     8010536a <sys_link+0x11a>
  begin_op();
80105288:	e8 e3 db ff ff       	call   80102e70 <begin_op>
  if((ip = namei(old)) == 0){
8010528d:	83 ec 0c             	sub    $0xc,%esp
80105290:	ff 75 d4             	pushl  -0x2c(%ebp)
80105293:	e8 18 cf ff ff       	call   801021b0 <namei>
80105298:	83 c4 10             	add    $0x10,%esp
8010529b:	89 c3                	mov    %eax,%ebx
8010529d:	85 c0                	test   %eax,%eax
8010529f:	0f 84 e4 00 00 00    	je     80105389 <sys_link+0x139>
  ilock(ip);
801052a5:	83 ec 0c             	sub    $0xc,%esp
801052a8:	50                   	push   %eax
801052a9:	e8 e2 c5 ff ff       	call   80101890 <ilock>
  if(ip->type == T_DIR){
801052ae:	83 c4 10             	add    $0x10,%esp
801052b1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052b6:	0f 84 b5 00 00 00    	je     80105371 <sys_link+0x121>
  iupdate(ip);
801052bc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801052bf:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801052c4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801052c7:	53                   	push   %ebx
801052c8:	e8 13 c5 ff ff       	call   801017e0 <iupdate>
  iunlock(ip);
801052cd:	89 1c 24             	mov    %ebx,(%esp)
801052d0:	e8 9b c6 ff ff       	call   80101970 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801052d5:	58                   	pop    %eax
801052d6:	5a                   	pop    %edx
801052d7:	57                   	push   %edi
801052d8:	ff 75 d0             	pushl  -0x30(%ebp)
801052db:	e8 f0 ce ff ff       	call   801021d0 <nameiparent>
801052e0:	83 c4 10             	add    $0x10,%esp
801052e3:	89 c6                	mov    %eax,%esi
801052e5:	85 c0                	test   %eax,%eax
801052e7:	74 5b                	je     80105344 <sys_link+0xf4>
  ilock(dp);
801052e9:	83 ec 0c             	sub    $0xc,%esp
801052ec:	50                   	push   %eax
801052ed:	e8 9e c5 ff ff       	call   80101890 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801052f2:	8b 03                	mov    (%ebx),%eax
801052f4:	83 c4 10             	add    $0x10,%esp
801052f7:	39 06                	cmp    %eax,(%esi)
801052f9:	75 3d                	jne    80105338 <sys_link+0xe8>
801052fb:	83 ec 04             	sub    $0x4,%esp
801052fe:	ff 73 04             	pushl  0x4(%ebx)
80105301:	57                   	push   %edi
80105302:	56                   	push   %esi
80105303:	e8 e8 cd ff ff       	call   801020f0 <dirlink>
80105308:	83 c4 10             	add    $0x10,%esp
8010530b:	85 c0                	test   %eax,%eax
8010530d:	78 29                	js     80105338 <sys_link+0xe8>
  iunlockput(dp);
8010530f:	83 ec 0c             	sub    $0xc,%esp
80105312:	56                   	push   %esi
80105313:	e8 08 c8 ff ff       	call   80101b20 <iunlockput>
  iput(ip);
80105318:	89 1c 24             	mov    %ebx,(%esp)
8010531b:	e8 a0 c6 ff ff       	call   801019c0 <iput>
  end_op();
80105320:	e8 bb db ff ff       	call   80102ee0 <end_op>
  return 0;
80105325:	83 c4 10             	add    $0x10,%esp
80105328:	31 c0                	xor    %eax,%eax
}
8010532a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010532d:	5b                   	pop    %ebx
8010532e:	5e                   	pop    %esi
8010532f:	5f                   	pop    %edi
80105330:	5d                   	pop    %ebp
80105331:	c3                   	ret    
80105332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105338:	83 ec 0c             	sub    $0xc,%esp
8010533b:	56                   	push   %esi
8010533c:	e8 df c7 ff ff       	call   80101b20 <iunlockput>
    goto bad;
80105341:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105344:	83 ec 0c             	sub    $0xc,%esp
80105347:	53                   	push   %ebx
80105348:	e8 43 c5 ff ff       	call   80101890 <ilock>
  ip->nlink--;
8010534d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105352:	89 1c 24             	mov    %ebx,(%esp)
80105355:	e8 86 c4 ff ff       	call   801017e0 <iupdate>
  iunlockput(ip);
8010535a:	89 1c 24             	mov    %ebx,(%esp)
8010535d:	e8 be c7 ff ff       	call   80101b20 <iunlockput>
  end_op();
80105362:	e8 79 db ff ff       	call   80102ee0 <end_op>
  return -1;
80105367:	83 c4 10             	add    $0x10,%esp
8010536a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010536f:	eb b9                	jmp    8010532a <sys_link+0xda>
    iunlockput(ip);
80105371:	83 ec 0c             	sub    $0xc,%esp
80105374:	53                   	push   %ebx
80105375:	e8 a6 c7 ff ff       	call   80101b20 <iunlockput>
    end_op();
8010537a:	e8 61 db ff ff       	call   80102ee0 <end_op>
    return -1;
8010537f:	83 c4 10             	add    $0x10,%esp
80105382:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105387:	eb a1                	jmp    8010532a <sys_link+0xda>
    end_op();
80105389:	e8 52 db ff ff       	call   80102ee0 <end_op>
    return -1;
8010538e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105393:	eb 95                	jmp    8010532a <sys_link+0xda>
80105395:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010539c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053a0 <sys_unlink>:
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	57                   	push   %edi
801053a4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801053a5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801053a8:	53                   	push   %ebx
801053a9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801053ac:	50                   	push   %eax
801053ad:	6a 00                	push   $0x0
801053af:	e8 9c f9 ff ff       	call   80104d50 <argstr>
801053b4:	83 c4 10             	add    $0x10,%esp
801053b7:	85 c0                	test   %eax,%eax
801053b9:	0f 88 7a 01 00 00    	js     80105539 <sys_unlink+0x199>
  begin_op();
801053bf:	e8 ac da ff ff       	call   80102e70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801053c4:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801053c7:	83 ec 08             	sub    $0x8,%esp
801053ca:	53                   	push   %ebx
801053cb:	ff 75 c0             	pushl  -0x40(%ebp)
801053ce:	e8 fd cd ff ff       	call   801021d0 <nameiparent>
801053d3:	83 c4 10             	add    $0x10,%esp
801053d6:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801053d9:	85 c0                	test   %eax,%eax
801053db:	0f 84 62 01 00 00    	je     80105543 <sys_unlink+0x1a3>
  ilock(dp);
801053e1:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801053e4:	83 ec 0c             	sub    $0xc,%esp
801053e7:	57                   	push   %edi
801053e8:	e8 a3 c4 ff ff       	call   80101890 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801053ed:	58                   	pop    %eax
801053ee:	5a                   	pop    %edx
801053ef:	68 90 81 10 80       	push   $0x80108190
801053f4:	53                   	push   %ebx
801053f5:	e8 d6 c9 ff ff       	call   80101dd0 <namecmp>
801053fa:	83 c4 10             	add    $0x10,%esp
801053fd:	85 c0                	test   %eax,%eax
801053ff:	0f 84 fb 00 00 00    	je     80105500 <sys_unlink+0x160>
80105405:	83 ec 08             	sub    $0x8,%esp
80105408:	68 8f 81 10 80       	push   $0x8010818f
8010540d:	53                   	push   %ebx
8010540e:	e8 bd c9 ff ff       	call   80101dd0 <namecmp>
80105413:	83 c4 10             	add    $0x10,%esp
80105416:	85 c0                	test   %eax,%eax
80105418:	0f 84 e2 00 00 00    	je     80105500 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010541e:	83 ec 04             	sub    $0x4,%esp
80105421:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105424:	50                   	push   %eax
80105425:	53                   	push   %ebx
80105426:	57                   	push   %edi
80105427:	e8 c4 c9 ff ff       	call   80101df0 <dirlookup>
8010542c:	83 c4 10             	add    $0x10,%esp
8010542f:	89 c3                	mov    %eax,%ebx
80105431:	85 c0                	test   %eax,%eax
80105433:	0f 84 c7 00 00 00    	je     80105500 <sys_unlink+0x160>
  ilock(ip);
80105439:	83 ec 0c             	sub    $0xc,%esp
8010543c:	50                   	push   %eax
8010543d:	e8 4e c4 ff ff       	call   80101890 <ilock>
  if(ip->nlink < 1)
80105442:	83 c4 10             	add    $0x10,%esp
80105445:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010544a:	0f 8e 1c 01 00 00    	jle    8010556c <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105450:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105455:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105458:	74 66                	je     801054c0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010545a:	83 ec 04             	sub    $0x4,%esp
8010545d:	6a 10                	push   $0x10
8010545f:	6a 00                	push   $0x0
80105461:	57                   	push   %edi
80105462:	e8 69 f5 ff ff       	call   801049d0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105467:	6a 10                	push   $0x10
80105469:	ff 75 c4             	pushl  -0x3c(%ebp)
8010546c:	57                   	push   %edi
8010546d:	ff 75 b4             	pushl  -0x4c(%ebp)
80105470:	e8 2b c8 ff ff       	call   80101ca0 <writei>
80105475:	83 c4 20             	add    $0x20,%esp
80105478:	83 f8 10             	cmp    $0x10,%eax
8010547b:	0f 85 de 00 00 00    	jne    8010555f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
80105481:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105486:	0f 84 94 00 00 00    	je     80105520 <sys_unlink+0x180>
  iunlockput(dp);
8010548c:	83 ec 0c             	sub    $0xc,%esp
8010548f:	ff 75 b4             	pushl  -0x4c(%ebp)
80105492:	e8 89 c6 ff ff       	call   80101b20 <iunlockput>
  ip->nlink--;
80105497:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010549c:	89 1c 24             	mov    %ebx,(%esp)
8010549f:	e8 3c c3 ff ff       	call   801017e0 <iupdate>
  iunlockput(ip);
801054a4:	89 1c 24             	mov    %ebx,(%esp)
801054a7:	e8 74 c6 ff ff       	call   80101b20 <iunlockput>
  end_op();
801054ac:	e8 2f da ff ff       	call   80102ee0 <end_op>
  return 0;
801054b1:	83 c4 10             	add    $0x10,%esp
801054b4:	31 c0                	xor    %eax,%eax
}
801054b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054b9:	5b                   	pop    %ebx
801054ba:	5e                   	pop    %esi
801054bb:	5f                   	pop    %edi
801054bc:	5d                   	pop    %ebp
801054bd:	c3                   	ret    
801054be:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801054c0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801054c4:	76 94                	jbe    8010545a <sys_unlink+0xba>
801054c6:	be 20 00 00 00       	mov    $0x20,%esi
801054cb:	eb 0b                	jmp    801054d8 <sys_unlink+0x138>
801054cd:	8d 76 00             	lea    0x0(%esi),%esi
801054d0:	83 c6 10             	add    $0x10,%esi
801054d3:	3b 73 58             	cmp    0x58(%ebx),%esi
801054d6:	73 82                	jae    8010545a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054d8:	6a 10                	push   $0x10
801054da:	56                   	push   %esi
801054db:	57                   	push   %edi
801054dc:	53                   	push   %ebx
801054dd:	e8 be c6 ff ff       	call   80101ba0 <readi>
801054e2:	83 c4 10             	add    $0x10,%esp
801054e5:	83 f8 10             	cmp    $0x10,%eax
801054e8:	75 68                	jne    80105552 <sys_unlink+0x1b2>
    if(de.inum != 0)
801054ea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801054ef:	74 df                	je     801054d0 <sys_unlink+0x130>
    iunlockput(ip);
801054f1:	83 ec 0c             	sub    $0xc,%esp
801054f4:	53                   	push   %ebx
801054f5:	e8 26 c6 ff ff       	call   80101b20 <iunlockput>
    goto bad;
801054fa:	83 c4 10             	add    $0x10,%esp
801054fd:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105500:	83 ec 0c             	sub    $0xc,%esp
80105503:	ff 75 b4             	pushl  -0x4c(%ebp)
80105506:	e8 15 c6 ff ff       	call   80101b20 <iunlockput>
  end_op();
8010550b:	e8 d0 d9 ff ff       	call   80102ee0 <end_op>
  return -1;
80105510:	83 c4 10             	add    $0x10,%esp
80105513:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105518:	eb 9c                	jmp    801054b6 <sys_unlink+0x116>
8010551a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105520:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105523:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105526:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010552b:	50                   	push   %eax
8010552c:	e8 af c2 ff ff       	call   801017e0 <iupdate>
80105531:	83 c4 10             	add    $0x10,%esp
80105534:	e9 53 ff ff ff       	jmp    8010548c <sys_unlink+0xec>
    return -1;
80105539:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010553e:	e9 73 ff ff ff       	jmp    801054b6 <sys_unlink+0x116>
    end_op();
80105543:	e8 98 d9 ff ff       	call   80102ee0 <end_op>
    return -1;
80105548:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010554d:	e9 64 ff ff ff       	jmp    801054b6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105552:	83 ec 0c             	sub    $0xc,%esp
80105555:	68 b4 81 10 80       	push   $0x801081b4
8010555a:	e8 21 ae ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010555f:	83 ec 0c             	sub    $0xc,%esp
80105562:	68 c6 81 10 80       	push   $0x801081c6
80105567:	e8 14 ae ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
8010556c:	83 ec 0c             	sub    $0xc,%esp
8010556f:	68 a2 81 10 80       	push   $0x801081a2
80105574:	e8 07 ae ff ff       	call   80100380 <panic>
80105579:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105580 <sys_open>:

int
sys_open(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
80105583:	57                   	push   %edi
80105584:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105585:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105588:	53                   	push   %ebx
80105589:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010558c:	50                   	push   %eax
8010558d:	6a 00                	push   $0x0
8010558f:	e8 bc f7 ff ff       	call   80104d50 <argstr>
80105594:	83 c4 10             	add    $0x10,%esp
80105597:	85 c0                	test   %eax,%eax
80105599:	0f 88 8e 00 00 00    	js     8010562d <sys_open+0xad>
8010559f:	83 ec 08             	sub    $0x8,%esp
801055a2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801055a5:	50                   	push   %eax
801055a6:	6a 01                	push   $0x1
801055a8:	e8 e3 f6 ff ff       	call   80104c90 <argint>
801055ad:	83 c4 10             	add    $0x10,%esp
801055b0:	85 c0                	test   %eax,%eax
801055b2:	78 79                	js     8010562d <sys_open+0xad>
    return -1;

  begin_op();
801055b4:	e8 b7 d8 ff ff       	call   80102e70 <begin_op>

  if(omode & O_CREATE){
801055b9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801055bd:	75 79                	jne    80105638 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801055bf:	83 ec 0c             	sub    $0xc,%esp
801055c2:	ff 75 e0             	pushl  -0x20(%ebp)
801055c5:	e8 e6 cb ff ff       	call   801021b0 <namei>
801055ca:	83 c4 10             	add    $0x10,%esp
801055cd:	89 c6                	mov    %eax,%esi
801055cf:	85 c0                	test   %eax,%eax
801055d1:	0f 84 7e 00 00 00    	je     80105655 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801055d7:	83 ec 0c             	sub    $0xc,%esp
801055da:	50                   	push   %eax
801055db:	e8 b0 c2 ff ff       	call   80101890 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801055e0:	83 c4 10             	add    $0x10,%esp
801055e3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801055e8:	0f 84 c2 00 00 00    	je     801056b0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801055ee:	e8 5d b9 ff ff       	call   80100f50 <filealloc>
801055f3:	89 c7                	mov    %eax,%edi
801055f5:	85 c0                	test   %eax,%eax
801055f7:	74 23                	je     8010561c <sys_open+0x9c>
  struct proc *curproc = myproc();
801055f9:	e8 92 e4 ff ff       	call   80103a90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801055fe:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105600:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105604:	85 d2                	test   %edx,%edx
80105606:	74 60                	je     80105668 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105608:	83 c3 01             	add    $0x1,%ebx
8010560b:	83 fb 10             	cmp    $0x10,%ebx
8010560e:	75 f0                	jne    80105600 <sys_open+0x80>
    if(f)
      fileclose(f);
80105610:	83 ec 0c             	sub    $0xc,%esp
80105613:	57                   	push   %edi
80105614:	e8 f7 b9 ff ff       	call   80101010 <fileclose>
80105619:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010561c:	83 ec 0c             	sub    $0xc,%esp
8010561f:	56                   	push   %esi
80105620:	e8 fb c4 ff ff       	call   80101b20 <iunlockput>
    end_op();
80105625:	e8 b6 d8 ff ff       	call   80102ee0 <end_op>
    return -1;
8010562a:	83 c4 10             	add    $0x10,%esp
8010562d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105632:	eb 6d                	jmp    801056a1 <sys_open+0x121>
80105634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105638:	83 ec 0c             	sub    $0xc,%esp
8010563b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010563e:	31 c9                	xor    %ecx,%ecx
80105640:	ba 02 00 00 00       	mov    $0x2,%edx
80105645:	6a 00                	push   $0x0
80105647:	e8 14 f8 ff ff       	call   80104e60 <create>
    if(ip == 0){
8010564c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010564f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105651:	85 c0                	test   %eax,%eax
80105653:	75 99                	jne    801055ee <sys_open+0x6e>
      end_op();
80105655:	e8 86 d8 ff ff       	call   80102ee0 <end_op>
      return -1;
8010565a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010565f:	eb 40                	jmp    801056a1 <sys_open+0x121>
80105661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105668:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
8010566b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010566f:	56                   	push   %esi
80105670:	e8 fb c2 ff ff       	call   80101970 <iunlock>
  end_op();
80105675:	e8 66 d8 ff ff       	call   80102ee0 <end_op>

  f->type = FD_INODE;
8010567a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105680:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105683:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105686:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105689:	89 d0                	mov    %edx,%eax
  f->off = 0;
8010568b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105692:	f7 d0                	not    %eax
80105694:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105697:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010569a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010569d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801056a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056a4:	89 d8                	mov    %ebx,%eax
801056a6:	5b                   	pop    %ebx
801056a7:	5e                   	pop    %esi
801056a8:	5f                   	pop    %edi
801056a9:	5d                   	pop    %ebp
801056aa:	c3                   	ret    
801056ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056af:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801056b0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801056b3:	85 c9                	test   %ecx,%ecx
801056b5:	0f 84 33 ff ff ff    	je     801055ee <sys_open+0x6e>
801056bb:	e9 5c ff ff ff       	jmp    8010561c <sys_open+0x9c>

801056c0 <sys_mkdir>:

int
sys_mkdir(void)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801056c6:	e8 a5 d7 ff ff       	call   80102e70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801056cb:	83 ec 08             	sub    $0x8,%esp
801056ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056d1:	50                   	push   %eax
801056d2:	6a 00                	push   $0x0
801056d4:	e8 77 f6 ff ff       	call   80104d50 <argstr>
801056d9:	83 c4 10             	add    $0x10,%esp
801056dc:	85 c0                	test   %eax,%eax
801056de:	78 30                	js     80105710 <sys_mkdir+0x50>
801056e0:	83 ec 0c             	sub    $0xc,%esp
801056e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056e6:	31 c9                	xor    %ecx,%ecx
801056e8:	ba 01 00 00 00       	mov    $0x1,%edx
801056ed:	6a 00                	push   $0x0
801056ef:	e8 6c f7 ff ff       	call   80104e60 <create>
801056f4:	83 c4 10             	add    $0x10,%esp
801056f7:	85 c0                	test   %eax,%eax
801056f9:	74 15                	je     80105710 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801056fb:	83 ec 0c             	sub    $0xc,%esp
801056fe:	50                   	push   %eax
801056ff:	e8 1c c4 ff ff       	call   80101b20 <iunlockput>
  end_op();
80105704:	e8 d7 d7 ff ff       	call   80102ee0 <end_op>
  return 0;
80105709:	83 c4 10             	add    $0x10,%esp
8010570c:	31 c0                	xor    %eax,%eax
}
8010570e:	c9                   	leave  
8010570f:	c3                   	ret    
    end_op();
80105710:	e8 cb d7 ff ff       	call   80102ee0 <end_op>
    return -1;
80105715:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010571a:	c9                   	leave  
8010571b:	c3                   	ret    
8010571c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105720 <sys_mknod>:

int
sys_mknod(void)
{
80105720:	55                   	push   %ebp
80105721:	89 e5                	mov    %esp,%ebp
80105723:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105726:	e8 45 d7 ff ff       	call   80102e70 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010572b:	83 ec 08             	sub    $0x8,%esp
8010572e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105731:	50                   	push   %eax
80105732:	6a 00                	push   $0x0
80105734:	e8 17 f6 ff ff       	call   80104d50 <argstr>
80105739:	83 c4 10             	add    $0x10,%esp
8010573c:	85 c0                	test   %eax,%eax
8010573e:	78 60                	js     801057a0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105740:	83 ec 08             	sub    $0x8,%esp
80105743:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105746:	50                   	push   %eax
80105747:	6a 01                	push   $0x1
80105749:	e8 42 f5 ff ff       	call   80104c90 <argint>
  if((argstr(0, &path)) < 0 ||
8010574e:	83 c4 10             	add    $0x10,%esp
80105751:	85 c0                	test   %eax,%eax
80105753:	78 4b                	js     801057a0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105755:	83 ec 08             	sub    $0x8,%esp
80105758:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010575b:	50                   	push   %eax
8010575c:	6a 02                	push   $0x2
8010575e:	e8 2d f5 ff ff       	call   80104c90 <argint>
     argint(1, &major) < 0 ||
80105763:	83 c4 10             	add    $0x10,%esp
80105766:	85 c0                	test   %eax,%eax
80105768:	78 36                	js     801057a0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010576a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010576e:	83 ec 0c             	sub    $0xc,%esp
80105771:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105775:	ba 03 00 00 00       	mov    $0x3,%edx
8010577a:	50                   	push   %eax
8010577b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010577e:	e8 dd f6 ff ff       	call   80104e60 <create>
     argint(2, &minor) < 0 ||
80105783:	83 c4 10             	add    $0x10,%esp
80105786:	85 c0                	test   %eax,%eax
80105788:	74 16                	je     801057a0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010578a:	83 ec 0c             	sub    $0xc,%esp
8010578d:	50                   	push   %eax
8010578e:	e8 8d c3 ff ff       	call   80101b20 <iunlockput>
  end_op();
80105793:	e8 48 d7 ff ff       	call   80102ee0 <end_op>
  return 0;
80105798:	83 c4 10             	add    $0x10,%esp
8010579b:	31 c0                	xor    %eax,%eax
}
8010579d:	c9                   	leave  
8010579e:	c3                   	ret    
8010579f:	90                   	nop
    end_op();
801057a0:	e8 3b d7 ff ff       	call   80102ee0 <end_op>
    return -1;
801057a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057aa:	c9                   	leave  
801057ab:	c3                   	ret    
801057ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057b0 <sys_chdir>:

int
sys_chdir(void)
{
801057b0:	55                   	push   %ebp
801057b1:	89 e5                	mov    %esp,%ebp
801057b3:	56                   	push   %esi
801057b4:	53                   	push   %ebx
801057b5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801057b8:	e8 d3 e2 ff ff       	call   80103a90 <myproc>
801057bd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801057bf:	e8 ac d6 ff ff       	call   80102e70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801057c4:	83 ec 08             	sub    $0x8,%esp
801057c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057ca:	50                   	push   %eax
801057cb:	6a 00                	push   $0x0
801057cd:	e8 7e f5 ff ff       	call   80104d50 <argstr>
801057d2:	83 c4 10             	add    $0x10,%esp
801057d5:	85 c0                	test   %eax,%eax
801057d7:	78 77                	js     80105850 <sys_chdir+0xa0>
801057d9:	83 ec 0c             	sub    $0xc,%esp
801057dc:	ff 75 f4             	pushl  -0xc(%ebp)
801057df:	e8 cc c9 ff ff       	call   801021b0 <namei>
801057e4:	83 c4 10             	add    $0x10,%esp
801057e7:	89 c3                	mov    %eax,%ebx
801057e9:	85 c0                	test   %eax,%eax
801057eb:	74 63                	je     80105850 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801057ed:	83 ec 0c             	sub    $0xc,%esp
801057f0:	50                   	push   %eax
801057f1:	e8 9a c0 ff ff       	call   80101890 <ilock>
  if(ip->type != T_DIR){
801057f6:	83 c4 10             	add    $0x10,%esp
801057f9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057fe:	75 30                	jne    80105830 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105800:	83 ec 0c             	sub    $0xc,%esp
80105803:	53                   	push   %ebx
80105804:	e8 67 c1 ff ff       	call   80101970 <iunlock>
  iput(curproc->cwd);
80105809:	58                   	pop    %eax
8010580a:	ff 76 68             	pushl  0x68(%esi)
8010580d:	e8 ae c1 ff ff       	call   801019c0 <iput>
  end_op();
80105812:	e8 c9 d6 ff ff       	call   80102ee0 <end_op>
  curproc->cwd = ip;
80105817:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010581a:	83 c4 10             	add    $0x10,%esp
8010581d:	31 c0                	xor    %eax,%eax
}
8010581f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105822:	5b                   	pop    %ebx
80105823:	5e                   	pop    %esi
80105824:	5d                   	pop    %ebp
80105825:	c3                   	ret    
80105826:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010582d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105830:	83 ec 0c             	sub    $0xc,%esp
80105833:	53                   	push   %ebx
80105834:	e8 e7 c2 ff ff       	call   80101b20 <iunlockput>
    end_op();
80105839:	e8 a2 d6 ff ff       	call   80102ee0 <end_op>
    return -1;
8010583e:	83 c4 10             	add    $0x10,%esp
80105841:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105846:	eb d7                	jmp    8010581f <sys_chdir+0x6f>
80105848:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010584f:	90                   	nop
    end_op();
80105850:	e8 8b d6 ff ff       	call   80102ee0 <end_op>
    return -1;
80105855:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010585a:	eb c3                	jmp    8010581f <sys_chdir+0x6f>
8010585c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105860 <sys_exec>:

int
sys_exec(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	57                   	push   %edi
80105864:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105865:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010586b:	53                   	push   %ebx
8010586c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105872:	50                   	push   %eax
80105873:	6a 00                	push   $0x0
80105875:	e8 d6 f4 ff ff       	call   80104d50 <argstr>
8010587a:	83 c4 10             	add    $0x10,%esp
8010587d:	85 c0                	test   %eax,%eax
8010587f:	0f 88 87 00 00 00    	js     8010590c <sys_exec+0xac>
80105885:	83 ec 08             	sub    $0x8,%esp
80105888:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010588e:	50                   	push   %eax
8010588f:	6a 01                	push   $0x1
80105891:	e8 fa f3 ff ff       	call   80104c90 <argint>
80105896:	83 c4 10             	add    $0x10,%esp
80105899:	85 c0                	test   %eax,%eax
8010589b:	78 6f                	js     8010590c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010589d:	83 ec 04             	sub    $0x4,%esp
801058a0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801058a6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801058a8:	68 80 00 00 00       	push   $0x80
801058ad:	6a 00                	push   $0x0
801058af:	56                   	push   %esi
801058b0:	e8 1b f1 ff ff       	call   801049d0 <memset>
801058b5:	83 c4 10             	add    $0x10,%esp
801058b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058bf:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801058c0:	83 ec 08             	sub    $0x8,%esp
801058c3:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
801058c9:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
801058d0:	50                   	push   %eax
801058d1:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801058d7:	01 f8                	add    %edi,%eax
801058d9:	50                   	push   %eax
801058da:	e8 21 f3 ff ff       	call   80104c00 <fetchint>
801058df:	83 c4 10             	add    $0x10,%esp
801058e2:	85 c0                	test   %eax,%eax
801058e4:	78 26                	js     8010590c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
801058e6:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801058ec:	85 c0                	test   %eax,%eax
801058ee:	74 30                	je     80105920 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801058f0:	83 ec 08             	sub    $0x8,%esp
801058f3:	8d 14 3e             	lea    (%esi,%edi,1),%edx
801058f6:	52                   	push   %edx
801058f7:	50                   	push   %eax
801058f8:	e8 43 f3 ff ff       	call   80104c40 <fetchstr>
801058fd:	83 c4 10             	add    $0x10,%esp
80105900:	85 c0                	test   %eax,%eax
80105902:	78 08                	js     8010590c <sys_exec+0xac>
  for(i=0;; i++){
80105904:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105907:	83 fb 20             	cmp    $0x20,%ebx
8010590a:	75 b4                	jne    801058c0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010590c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010590f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105914:	5b                   	pop    %ebx
80105915:	5e                   	pop    %esi
80105916:	5f                   	pop    %edi
80105917:	5d                   	pop    %ebp
80105918:	c3                   	ret    
80105919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105920:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105927:	00 00 00 00 
  return exec(path, argv);
8010592b:	83 ec 08             	sub    $0x8,%esp
8010592e:	56                   	push   %esi
8010592f:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105935:	e8 96 b2 ff ff       	call   80100bd0 <exec>
8010593a:	83 c4 10             	add    $0x10,%esp
}
8010593d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105940:	5b                   	pop    %ebx
80105941:	5e                   	pop    %esi
80105942:	5f                   	pop    %edi
80105943:	5d                   	pop    %ebp
80105944:	c3                   	ret    
80105945:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010594c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105950 <sys_pipe>:

int
sys_pipe(void)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
80105953:	57                   	push   %edi
80105954:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105955:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105958:	53                   	push   %ebx
80105959:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010595c:	6a 08                	push   $0x8
8010595e:	50                   	push   %eax
8010595f:	6a 00                	push   $0x0
80105961:	e8 7a f3 ff ff       	call   80104ce0 <argptr>
80105966:	83 c4 10             	add    $0x10,%esp
80105969:	85 c0                	test   %eax,%eax
8010596b:	78 4a                	js     801059b7 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010596d:	83 ec 08             	sub    $0x8,%esp
80105970:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105973:	50                   	push   %eax
80105974:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105977:	50                   	push   %eax
80105978:	e8 c3 db ff ff       	call   80103540 <pipealloc>
8010597d:	83 c4 10             	add    $0x10,%esp
80105980:	85 c0                	test   %eax,%eax
80105982:	78 33                	js     801059b7 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105984:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105987:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105989:	e8 02 e1 ff ff       	call   80103a90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010598e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105990:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105994:	85 f6                	test   %esi,%esi
80105996:	74 28                	je     801059c0 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105998:	83 c3 01             	add    $0x1,%ebx
8010599b:	83 fb 10             	cmp    $0x10,%ebx
8010599e:	75 f0                	jne    80105990 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801059a0:	83 ec 0c             	sub    $0xc,%esp
801059a3:	ff 75 e0             	pushl  -0x20(%ebp)
801059a6:	e8 65 b6 ff ff       	call   80101010 <fileclose>
    fileclose(wf);
801059ab:	58                   	pop    %eax
801059ac:	ff 75 e4             	pushl  -0x1c(%ebp)
801059af:	e8 5c b6 ff ff       	call   80101010 <fileclose>
    return -1;
801059b4:	83 c4 10             	add    $0x10,%esp
801059b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059bc:	eb 53                	jmp    80105a11 <sys_pipe+0xc1>
801059be:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
801059c0:	8d 73 08             	lea    0x8(%ebx),%esi
801059c3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801059c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801059ca:	e8 c1 e0 ff ff       	call   80103a90 <myproc>
801059cf:	89 c2                	mov    %eax,%edx
  for(fd = 0; fd < NOFILE; fd++){
801059d1:	31 c0                	xor    %eax,%eax
801059d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059d7:	90                   	nop
    if(curproc->ofile[fd] == 0){
801059d8:	8b 4c 82 28          	mov    0x28(%edx,%eax,4),%ecx
801059dc:	85 c9                	test   %ecx,%ecx
801059de:	74 20                	je     80105a00 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
801059e0:	83 c0 01             	add    $0x1,%eax
801059e3:	83 f8 10             	cmp    $0x10,%eax
801059e6:	75 f0                	jne    801059d8 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
801059e8:	e8 a3 e0 ff ff       	call   80103a90 <myproc>
801059ed:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801059f4:	00 
801059f5:	eb a9                	jmp    801059a0 <sys_pipe+0x50>
801059f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059fe:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105a00:	89 7c 82 28          	mov    %edi,0x28(%edx,%eax,4)
  }
  fd[0] = fd0;
80105a04:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a07:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80105a09:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105a0c:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80105a0f:	31 c0                	xor    %eax,%eax
}
80105a11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a14:	5b                   	pop    %ebx
80105a15:	5e                   	pop    %esi
80105a16:	5f                   	pop    %edi
80105a17:	5d                   	pop    %ebp
80105a18:	c3                   	ret    
80105a19:	66 90                	xchg   %ax,%ax
80105a1b:	66 90                	xchg   %ax,%ax
80105a1d:	66 90                	xchg   %ax,%ax
80105a1f:	90                   	nop

80105a20 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105a20:	e9 0b e2 ff ff       	jmp    80103c30 <fork>
80105a25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a30 <sys_exit>:
}

int
sys_exit(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	83 ec 08             	sub    $0x8,%esp
  exit();
80105a36:	e8 75 e4 ff ff       	call   80103eb0 <exit>
  return 0;  // not reached
}
80105a3b:	31 c0                	xor    %eax,%eax
80105a3d:	c9                   	leave  
80105a3e:	c3                   	ret    
80105a3f:	90                   	nop

80105a40 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105a40:	e9 9b e5 ff ff       	jmp    80103fe0 <wait>
80105a45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a50 <sys_kill>:
}

int
sys_kill(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105a56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105a59:	50                   	push   %eax
80105a5a:	6a 00                	push   $0x0
80105a5c:	e8 2f f2 ff ff       	call   80104c90 <argint>
80105a61:	83 c4 10             	add    $0x10,%esp
80105a64:	85 c0                	test   %eax,%eax
80105a66:	78 18                	js     80105a80 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105a68:	83 ec 0c             	sub    $0xc,%esp
80105a6b:	ff 75 f4             	pushl  -0xc(%ebp)
80105a6e:	e8 0d e8 ff ff       	call   80104280 <kill>
80105a73:	83 c4 10             	add    $0x10,%esp
}
80105a76:	c9                   	leave  
80105a77:	c3                   	ret    
80105a78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a7f:	90                   	nop
80105a80:	c9                   	leave  
    return -1;
80105a81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a86:	c3                   	ret    
80105a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a8e:	66 90                	xchg   %ax,%ax

80105a90 <sys_getpid>:

int
sys_getpid(void)
{
80105a90:	55                   	push   %ebp
80105a91:	89 e5                	mov    %esp,%ebp
80105a93:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105a96:	e8 f5 df ff ff       	call   80103a90 <myproc>
80105a9b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105a9e:	c9                   	leave  
80105a9f:	c3                   	ret    

80105aa0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105aa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105aa7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105aaa:	50                   	push   %eax
80105aab:	6a 00                	push   $0x0
80105aad:	e8 de f1 ff ff       	call   80104c90 <argint>
80105ab2:	83 c4 10             	add    $0x10,%esp
80105ab5:	85 c0                	test   %eax,%eax
80105ab7:	78 27                	js     80105ae0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105ab9:	e8 d2 df ff ff       	call   80103a90 <myproc>
  if(growproc(n) < 0)
80105abe:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105ac1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105ac3:	ff 75 f4             	pushl  -0xc(%ebp)
80105ac6:	e8 e5 e0 ff ff       	call   80103bb0 <growproc>
80105acb:	83 c4 10             	add    $0x10,%esp
80105ace:	85 c0                	test   %eax,%eax
80105ad0:	78 0e                	js     80105ae0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105ad2:	89 d8                	mov    %ebx,%eax
80105ad4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ad7:	c9                   	leave  
80105ad8:	c3                   	ret    
80105ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105ae0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105ae5:	eb eb                	jmp    80105ad2 <sys_sbrk+0x32>
80105ae7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aee:	66 90                	xchg   %ax,%ax

80105af0 <sys_sleep>:

int
sys_sleep(void)
{
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105af4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105af7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105afa:	50                   	push   %eax
80105afb:	6a 00                	push   $0x0
80105afd:	e8 8e f1 ff ff       	call   80104c90 <argint>
80105b02:	83 c4 10             	add    $0x10,%esp
80105b05:	85 c0                	test   %eax,%eax
80105b07:	0f 88 8a 00 00 00    	js     80105b97 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105b0d:	83 ec 0c             	sub    $0xc,%esp
80105b10:	68 00 63 11 80       	push   $0x80116300
80105b15:	e8 f6 ed ff ff       	call   80104910 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105b1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105b1d:	8b 1d e0 62 11 80    	mov    0x801162e0,%ebx
  while(ticks - ticks0 < n){
80105b23:	83 c4 10             	add    $0x10,%esp
80105b26:	85 d2                	test   %edx,%edx
80105b28:	75 27                	jne    80105b51 <sys_sleep+0x61>
80105b2a:	eb 54                	jmp    80105b80 <sys_sleep+0x90>
80105b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105b30:	83 ec 08             	sub    $0x8,%esp
80105b33:	68 00 63 11 80       	push   $0x80116300
80105b38:	68 e0 62 11 80       	push   $0x801162e0
80105b3d:	e8 1e e6 ff ff       	call   80104160 <sleep>
  while(ticks - ticks0 < n){
80105b42:	a1 e0 62 11 80       	mov    0x801162e0,%eax
80105b47:	83 c4 10             	add    $0x10,%esp
80105b4a:	29 d8                	sub    %ebx,%eax
80105b4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105b4f:	73 2f                	jae    80105b80 <sys_sleep+0x90>
    if(myproc()->killed){
80105b51:	e8 3a df ff ff       	call   80103a90 <myproc>
80105b56:	8b 40 24             	mov    0x24(%eax),%eax
80105b59:	85 c0                	test   %eax,%eax
80105b5b:	74 d3                	je     80105b30 <sys_sleep+0x40>
      release(&tickslock);
80105b5d:	83 ec 0c             	sub    $0xc,%esp
80105b60:	68 00 63 11 80       	push   $0x80116300
80105b65:	e8 46 ed ff ff       	call   801048b0 <release>
  }
  release(&tickslock);
  return 0;
}
80105b6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105b6d:	83 c4 10             	add    $0x10,%esp
80105b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b75:	c9                   	leave  
80105b76:	c3                   	ret    
80105b77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b7e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105b80:	83 ec 0c             	sub    $0xc,%esp
80105b83:	68 00 63 11 80       	push   $0x80116300
80105b88:	e8 23 ed ff ff       	call   801048b0 <release>
  return 0;
80105b8d:	83 c4 10             	add    $0x10,%esp
80105b90:	31 c0                	xor    %eax,%eax
}
80105b92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b95:	c9                   	leave  
80105b96:	c3                   	ret    
    return -1;
80105b97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b9c:	eb f4                	jmp    80105b92 <sys_sleep+0xa2>
80105b9e:	66 90                	xchg   %ax,%ax

80105ba0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ba0:	55                   	push   %ebp
80105ba1:	89 e5                	mov    %esp,%ebp
80105ba3:	53                   	push   %ebx
80105ba4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ba7:	68 00 63 11 80       	push   $0x80116300
80105bac:	e8 5f ed ff ff       	call   80104910 <acquire>
  xticks = ticks;
80105bb1:	8b 1d e0 62 11 80    	mov    0x801162e0,%ebx
  release(&tickslock);
80105bb7:	c7 04 24 00 63 11 80 	movl   $0x80116300,(%esp)
80105bbe:	e8 ed ec ff ff       	call   801048b0 <release>
  return xticks;
}
80105bc3:	89 d8                	mov    %ebx,%eax
80105bc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bc8:	c9                   	leave  
80105bc9:	c3                   	ret    
80105bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105bd0 <strcmp>:
extern int trace_state; //0 for off, 1 for on
extern struct FunctionInfo functionList[SYSCALL_COUNT]; //stores the syscall name along with its num
extern int syscall_count[1 + SYSCALL_COUNT]; // count for each syscall


int strcmp(const char *s1, const char *s2) { // strcmp function for sorting
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105bd6:	8b 55 0c             	mov    0xc(%ebp),%edx
    while (*s1 && *s1 == *s2) {
80105bd9:	0f b6 01             	movzbl (%ecx),%eax
80105bdc:	84 c0                	test   %al,%al
80105bde:	75 16                	jne    80105bf6 <strcmp+0x26>
80105be0:	eb 26                	jmp    80105c08 <strcmp+0x38>
80105be2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105be8:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
        s1++;
80105bec:	83 c1 01             	add    $0x1,%ecx
        s2++;
80105bef:	83 c2 01             	add    $0x1,%edx
    while (*s1 && *s1 == *s2) {
80105bf2:	84 c0                	test   %al,%al
80105bf4:	74 12                	je     80105c08 <strcmp+0x38>
80105bf6:	38 02                	cmp    %al,(%edx)
80105bf8:	74 ee                	je     80105be8 <strcmp+0x18>
    }
    return *(unsigned char *)s1 - *(unsigned char *)s2;
80105bfa:	0f b6 12             	movzbl (%edx),%edx
}
80105bfd:	5d                   	pop    %ebp
    return *(unsigned char *)s1 - *(unsigned char *)s2;
80105bfe:	29 d0                	sub    %edx,%eax
}
80105c00:	c3                   	ret    
80105c01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return *(unsigned char *)s1 - *(unsigned char *)s2;
80105c08:	0f b6 12             	movzbl (%edx),%edx
80105c0b:	31 c0                	xor    %eax,%eax
}
80105c0d:	5d                   	pop    %ebp
    return *(unsigned char *)s1 - *(unsigned char *)s2;
80105c0e:	29 d0                	sub    %edx,%eax
}
80105c10:	c3                   	ret    
80105c11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c1f:	90                   	nop

80105c20 <insertion_sort>:

void insertion_sort(struct FunctionInfo *functions, int count) {
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
80105c23:	57                   	push   %edi
80105c24:	56                   	push   %esi
80105c25:	53                   	push   %ebx
80105c26:	83 ec 10             	sub    $0x10,%esp
    for (int i = 1; i < count; i++) {
80105c29:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
80105c2d:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
80105c34:	0f 8e 94 00 00 00    	jle    80105cce <insertion_sort+0xae>
80105c3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        struct FunctionInfo key = functions[i];
80105c40:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105c43:	8b 7d 08             	mov    0x8(%ebp),%edi
80105c46:	8b 75 08             	mov    0x8(%ebp),%esi
80105c49:	8b 3c c7             	mov    (%edi,%eax,8),%edi
80105c4c:	8d 34 c6             	lea    (%esi,%eax,8),%esi
80105c4f:	89 7d ec             	mov    %edi,-0x14(%ebp)
80105c52:	8b 7d 08             	mov    0x8(%ebp),%edi
80105c55:	8b 7c c7 04          	mov    0x4(%edi,%eax,8),%edi
80105c59:	89 7d e4             	mov    %edi,-0x1c(%ebp)
        int j = i - 1;
80105c5c:	8d 78 ff             	lea    -0x1(%eax),%edi
        while (j >= 0 && strcmp(functions[j].funcName, key.funcName) > 0) {
80105c5f:	90                   	nop
80105c60:	8b 56 f8             	mov    -0x8(%esi),%edx
    while (*s1 && *s1 == *s2) {
80105c63:	89 75 f0             	mov    %esi,-0x10(%ebp)
80105c66:	0f b6 02             	movzbl (%edx),%eax
80105c69:	84 c0                	test   %al,%al
80105c6b:	74 73                	je     80105ce0 <insertion_sort+0xc0>
80105c6d:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80105c70:	eb 14                	jmp    80105c86 <insertion_sort+0x66>
80105c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105c78:	0f b6 42 01          	movzbl 0x1(%edx),%eax
        s1++;
80105c7c:	83 c2 01             	add    $0x1,%edx
        s2++;
80105c7f:	83 c1 01             	add    $0x1,%ecx
    while (*s1 && *s1 == *s2) {
80105c82:	84 c0                	test   %al,%al
80105c84:	74 5a                	je     80105ce0 <insertion_sort+0xc0>
80105c86:	0f b6 19             	movzbl (%ecx),%ebx
80105c89:	38 c3                	cmp    %al,%bl
80105c8b:	74 eb                	je     80105c78 <insertion_sort+0x58>
    return *(unsigned char *)s1 - *(unsigned char *)s2;
80105c8d:	29 d8                	sub    %ebx,%eax
        while (j >= 0 && strcmp(functions[j].funcName, key.funcName) > 0) {
80105c8f:	85 c0                	test   %eax,%eax
80105c91:	7e 1d                	jle    80105cb0 <insertion_sort+0x90>
            functions[j + 1] = functions[j];
80105c93:	8b 46 f8             	mov    -0x8(%esi),%eax
80105c96:	8b 56 fc             	mov    -0x4(%esi),%edx
            j --;
80105c99:	83 ef 01             	sub    $0x1,%edi
        while (j >= 0 && strcmp(functions[j].funcName, key.funcName) > 0) {
80105c9c:	83 ee 08             	sub    $0x8,%esi
            functions[j + 1] = functions[j];
80105c9f:	89 46 08             	mov    %eax,0x8(%esi)
80105ca2:	89 56 0c             	mov    %edx,0xc(%esi)
        while (j >= 0 && strcmp(functions[j].funcName, key.funcName) > 0) {
80105ca5:	83 ff ff             	cmp    $0xffffffff,%edi
80105ca8:	75 b6                	jne    80105c60 <insertion_sort+0x40>
80105caa:	8b 45 08             	mov    0x8(%ebp),%eax
80105cad:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        functions[j + 1] = key;
80105cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cb3:	8b 7d ec             	mov    -0x14(%ebp),%edi
    for (int i = 1; i < count; i++) {
80105cb6:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
        functions[j + 1] = key;
80105cba:	89 38                	mov    %edi,(%eax)
80105cbc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80105cbf:	89 78 04             	mov    %edi,0x4(%eax)
    for (int i = 1; i < count; i++) {
80105cc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105cc5:	39 45 0c             	cmp    %eax,0xc(%ebp)
80105cc8:	0f 85 72 ff ff ff    	jne    80105c40 <insertion_sort+0x20>
    }
}
80105cce:	83 c4 10             	add    $0x10,%esp
80105cd1:	5b                   	pop    %ebx
80105cd2:	5e                   	pop    %esi
80105cd3:	5f                   	pop    %edi
80105cd4:	5d                   	pop    %ebp
80105cd5:	c3                   	ret    
80105cd6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cdd:	8d 76 00             	lea    0x0(%esi),%esi
        functions[j + 1] = key;
80105ce0:	8b 45 08             	mov    0x8(%ebp),%eax
80105ce3:	8d 44 f8 08          	lea    0x8(%eax,%edi,8),%eax
80105ce7:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105cea:	eb c4                	jmp    80105cb0 <insertion_sort+0x90>
80105cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cf0 <sys_toggle>:

int
sys_toggle(void)
{
  trace_state = (trace_state + 1) % 2; // 0->1 and 1->0
80105cf0:	a1 d4 62 11 80       	mov    0x801162d4,%eax
80105cf5:	83 c0 01             	add    $0x1,%eax
80105cf8:	89 c1                	mov    %eax,%ecx
80105cfa:	c1 e9 1f             	shr    $0x1f,%ecx
80105cfd:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  for (int i=0; i<=SYSCALL_COUNT; i++){ // initialize all count to 0
80105d00:	31 c0                	xor    %eax,%eax
  trace_state = (trace_state + 1) % 2; // 0->1 and 1->0
80105d02:	83 e2 01             	and    $0x1,%edx
80105d05:	29 ca                	sub    %ecx,%edx
80105d07:	89 15 d4 62 11 80    	mov    %edx,0x801162d4
  for (int i=0; i<=SYSCALL_COUNT; i++){ // initialize all count to 0
80105d0d:	8d 76 00             	lea    0x0(%esi),%esi
    syscall_count[i] = 0;
80105d10:	c7 04 85 60 62 11 80 	movl   $0x0,-0x7fee9da0(,%eax,4)
80105d17:	00 00 00 00 
  for (int i=0; i<=SYSCALL_COUNT; i++){ // initialize all count to 0
80105d1b:	83 c0 01             	add    $0x1,%eax
80105d1e:	83 f8 1d             	cmp    $0x1d,%eax
80105d21:	75 ed                	jne    80105d10 <sys_toggle+0x20>
  }
  return trace_state;
}
80105d23:	89 d0                	mov    %edx,%eax
80105d25:	c3                   	ret    
80105d26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d2d:	8d 76 00             	lea    0x0(%esi),%esi

80105d30 <sys_print_count>:


int sys_print_count(void){
  if (trace_state == 0) {
80105d30:	8b 0d d4 62 11 80    	mov    0x801162d4,%ecx
80105d36:	85 c9                	test   %ecx,%ecx
80105d38:	0f 84 8e 00 00 00    	je     80105dcc <sys_print_count+0x9c>
int sys_print_count(void){
80105d3e:	55                   	push   %ebp
80105d3f:	89 e5                	mov    %esp,%ebp
80105d41:	56                   	push   %esi
80105d42:	53                   	push   %ebx
      return -1;
  }
  
  insertion_sort(functionList, SYSCALL_COUNT);
  for (int i = 0; i < SYSCALL_COUNT; i++) {
80105d43:	31 db                	xor    %ebx,%ebx
  insertion_sort(functionList, SYSCALL_COUNT);
80105d45:	6a 1c                	push   $0x1c
80105d47:	68 20 b0 10 80       	push   $0x8010b020
80105d4c:	e8 cf fe ff ff       	call   80105c20 <insertion_sort>
80105d51:	58                   	pop    %eax
80105d52:	5a                   	pop    %edx
80105d53:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d57:	90                   	nop
      int syscall_index = functionList[i].index;
      if (strcmp(functionList[i].funcName, "sys_print_count") == 0)
80105d58:	8b 34 dd 20 b0 10 80 	mov    -0x7fef4fe0(,%ebx,8),%esi
    while (*s1 && *s1 == *s2) {
80105d5f:	ba ad 80 10 80       	mov    $0x801080ad,%edx
80105d64:	0f b6 06             	movzbl (%esi),%eax
80105d67:	89 f1                	mov    %esi,%ecx
80105d69:	84 c0                	test   %al,%al
80105d6b:	75 11                	jne    80105d7e <sys_print_count+0x4e>
80105d6d:	eb 17                	jmp    80105d86 <sys_print_count+0x56>
80105d6f:	90                   	nop
80105d70:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
        s1++;
80105d74:	83 c1 01             	add    $0x1,%ecx
        s2++;
80105d77:	83 c2 01             	add    $0x1,%edx
    while (*s1 && *s1 == *s2) {
80105d7a:	84 c0                	test   %al,%al
80105d7c:	74 32                	je     80105db0 <sys_print_count+0x80>
80105d7e:	38 02                	cmp    %al,(%edx)
80105d80:	74 ee                	je     80105d70 <sys_print_count+0x40>
      if (strcmp(functionList[i].funcName, "sys_print_count") == 0)
80105d82:	38 02                	cmp    %al,(%edx)
80105d84:	74 12                	je     80105d98 <sys_print_count+0x68>
        continue;
      if (syscall_count[syscall_index]!=0)
80105d86:	8b 04 dd 24 b0 10 80 	mov    -0x7fef4fdc(,%ebx,8),%eax
80105d8d:	8b 04 85 60 62 11 80 	mov    -0x7fee9da0(,%eax,4),%eax
80105d94:	85 c0                	test   %eax,%eax
80105d96:	75 20                	jne    80105db8 <sys_print_count+0x88>
  for (int i = 0; i < SYSCALL_COUNT; i++) {
80105d98:	83 c3 01             	add    $0x1,%ebx
80105d9b:	83 fb 1c             	cmp    $0x1c,%ebx
80105d9e:	75 b8                	jne    80105d58 <sys_print_count+0x28>
        cprintf("%s %d\n", functionList[i].funcName, syscall_count[syscall_index]);
  }

  return 0;
}
80105da0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return 0;
80105da3:	31 c0                	xor    %eax,%eax
}
80105da5:	5b                   	pop    %ebx
80105da6:	5e                   	pop    %esi
80105da7:	5d                   	pop    %ebp
80105da8:	c3                   	ret    
80105da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105db0:	31 c0                	xor    %eax,%eax
80105db2:	eb ce                	jmp    80105d82 <sys_print_count+0x52>
80105db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf("%s %d\n", functionList[i].funcName, syscall_count[syscall_index]);
80105db8:	83 ec 04             	sub    $0x4,%esp
80105dbb:	50                   	push   %eax
80105dbc:	56                   	push   %esi
80105dbd:	68 d5 81 10 80       	push   $0x801081d5
80105dc2:	e8 b9 a8 ff ff       	call   80100680 <cprintf>
80105dc7:	83 c4 10             	add    $0x10,%esp
80105dca:	eb cc                	jmp    80105d98 <sys_print_count+0x68>
      return -1;
80105dcc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105dd1:	c3                   	ret    
80105dd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105de0 <sys_add>:


int sys_add(void){
80105de0:	55                   	push   %ebp
80105de1:	89 e5                	mov    %esp,%ebp
80105de3:	83 ec 20             	sub    $0x20,%esp
  // Get the two arguments from the user
  int a, b;
    if (argint(0, &a) < 0 || argint(1, &b) < 0)
80105de6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105de9:	50                   	push   %eax
80105dea:	6a 00                	push   $0x0
80105dec:	e8 9f ee ff ff       	call   80104c90 <argint>
80105df1:	83 c4 10             	add    $0x10,%esp
80105df4:	85 c0                	test   %eax,%eax
80105df6:	78 20                	js     80105e18 <sys_add+0x38>
80105df8:	83 ec 08             	sub    $0x8,%esp
80105dfb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105dfe:	50                   	push   %eax
80105dff:	6a 01                	push   $0x1
80105e01:	e8 8a ee ff ff       	call   80104c90 <argint>
80105e06:	83 c4 10             	add    $0x10,%esp
80105e09:	85 c0                	test   %eax,%eax
80105e0b:	78 0b                	js     80105e18 <sys_add+0x38>
      return -1;
  
    // Return the sum of a and b
    return a + b;
80105e0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e10:	03 45 f0             	add    -0x10(%ebp),%eax
}
80105e13:	c9                   	leave  
80105e14:	c3                   	ret    
80105e15:	8d 76 00             	lea    0x0(%esi),%esi
80105e18:	c9                   	leave  
      return -1;
80105e19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e1e:	c3                   	ret    
80105e1f:	90                   	nop

80105e20 <sys_ps>:

int sys_ps(void){
80105e20:	55                   	push   %ebp
80105e21:	89 e5                	mov    %esp,%ebp
80105e23:	83 ec 08             	sub    $0x8,%esp
  // Call the ps function defined in proc.c
  ps();
80105e26:	e8 95 e5 ff ff       	call   801043c0 <ps>

  return 0;
}
80105e2b:	31 c0                	xor    %eax,%eax
80105e2d:	c9                   	leave  
80105e2e:	c3                   	ret    
80105e2f:	90                   	nop

80105e30 <sys_send>:

// Assignment 1.3
int sys_send(void){
80105e30:	55                   	push   %ebp
80105e31:	89 e5                	mov    %esp,%ebp
80105e33:	83 ec 20             	sub    $0x20,%esp
  // Get the sender and receiver process IDs and the message from user space
  int sender_pid, rec_pid;
  char* msg;
  if (argint(0, &sender_pid) < 0 || argint(1, &rec_pid) < 0 || argptr(2, &msg, 8) < 0)
80105e36:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e39:	50                   	push   %eax
80105e3a:	6a 00                	push   $0x0
80105e3c:	e8 4f ee ff ff       	call   80104c90 <argint>
80105e41:	83 c4 10             	add    $0x10,%esp
80105e44:	85 c0                	test   %eax,%eax
80105e46:	78 48                	js     80105e90 <sys_send+0x60>
80105e48:	83 ec 08             	sub    $0x8,%esp
80105e4b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e4e:	50                   	push   %eax
80105e4f:	6a 01                	push   $0x1
80105e51:	e8 3a ee ff ff       	call   80104c90 <argint>
80105e56:	83 c4 10             	add    $0x10,%esp
80105e59:	85 c0                	test   %eax,%eax
80105e5b:	78 33                	js     80105e90 <sys_send+0x60>
80105e5d:	83 ec 04             	sub    $0x4,%esp
80105e60:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e63:	6a 08                	push   $0x8
80105e65:	50                   	push   %eax
80105e66:	6a 02                	push   $0x2
80105e68:	e8 73 ee ff ff       	call   80104ce0 <argptr>
80105e6d:	83 c4 10             	add    $0x10,%esp
80105e70:	85 c0                	test   %eax,%eax
80105e72:	78 1c                	js     80105e90 <sys_send+0x60>
    return -1;
  
  // Call the send_message function to send the message defined in proc.c
  return send_message(sender_pid, rec_pid, msg);
80105e74:	83 ec 04             	sub    $0x4,%esp
80105e77:	ff 75 f4             	pushl  -0xc(%ebp)
80105e7a:	ff 75 f0             	pushl  -0x10(%ebp)
80105e7d:	ff 75 ec             	pushl  -0x14(%ebp)
80105e80:	e8 1b e6 ff ff       	call   801044a0 <send_message>
80105e85:	83 c4 10             	add    $0x10,%esp
  // safestrcpy(sender_proc->shared_memory, msg, 8);

  // wakeup(rec_proc->chan);

  // return 0;
}
80105e88:	c9                   	leave  
80105e89:	c3                   	ret    
80105e8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105e90:	c9                   	leave  
    return -1;
80105e91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e96:	c3                   	ret    
80105e97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e9e:	66 90                	xchg   %ax,%ax

80105ea0 <sys_recv>:

int sys_recv(void){
80105ea0:	55                   	push   %ebp
80105ea1:	89 e5                	mov    %esp,%ebp
80105ea3:	83 ec 1c             	sub    $0x1c,%esp
  // Get the message buffer from user space
  char* msg;

  if (argptr(0, &msg, 8) < 0)
80105ea6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ea9:	6a 08                	push   $0x8
80105eab:	50                   	push   %eax
80105eac:	6a 00                	push   $0x0
80105eae:	e8 2d ee ff ff       	call   80104ce0 <argptr>
80105eb3:	83 c4 10             	add    $0x10,%esp
80105eb6:	89 c2                	mov    %eax,%edx
80105eb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ebd:	85 d2                	test   %edx,%edx
80105ebf:	78 1f                	js     80105ee0 <sys_recv+0x40>
80105ec1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  int stat = -1;
  while (stat == -1)
  {
    // recursively check for msg receive (blocking call)
    stat = receive_message(msg);
80105ec8:	83 ec 0c             	sub    $0xc,%esp
80105ecb:	ff 75 f4             	pushl  -0xc(%ebp)
80105ece:	e8 9d e6 ff ff       	call   80104570 <receive_message>
  while (stat == -1)
80105ed3:	83 c4 10             	add    $0x10,%esp
80105ed6:	83 f8 ff             	cmp    $0xffffffff,%eax
80105ed9:	74 ed                	je     80105ec8 <sys_recv+0x28>
  }
  return 1;
80105edb:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105ee0:	c9                   	leave  
80105ee1:	c3                   	ret    
80105ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ef0 <sys_send_multi>:

int sys_send_multi(void){
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	53                   	push   %ebx
  // Get the sender process ID, receiver process IDs, and the message from user space
  int sender_pid;
  int *rec_pids;
  char *msg;

  if(argint(0, &sender_pid) < 0 || argptr(1, (void*)&rec_pids, 8 * sizeof(int)) < 0 || argptr(2, &msg, 8)<0) {
80105ef4:	8d 45 ec             	lea    -0x14(%ebp),%eax
int sys_send_multi(void){
80105ef7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &sender_pid) < 0 || argptr(1, (void*)&rec_pids, 8 * sizeof(int)) < 0 || argptr(2, &msg, 8)<0) {
80105efa:	50                   	push   %eax
80105efb:	6a 00                	push   $0x0
80105efd:	e8 8e ed ff ff       	call   80104c90 <argint>
80105f02:	83 c4 10             	add    $0x10,%esp
80105f05:	85 c0                	test   %eax,%eax
80105f07:	78 60                	js     80105f69 <sys_send_multi+0x79>
80105f09:	83 ec 04             	sub    $0x4,%esp
80105f0c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105f0f:	6a 20                	push   $0x20
80105f11:	50                   	push   %eax
80105f12:	6a 01                	push   $0x1
80105f14:	e8 c7 ed ff ff       	call   80104ce0 <argptr>
80105f19:	83 c4 10             	add    $0x10,%esp
80105f1c:	85 c0                	test   %eax,%eax
80105f1e:	78 49                	js     80105f69 <sys_send_multi+0x79>
80105f20:	83 ec 04             	sub    $0x4,%esp
80105f23:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105f26:	6a 08                	push   $0x8
80105f28:	50                   	push   %eax
80105f29:	6a 02                	push   $0x2
80105f2b:	e8 b0 ed ff ff       	call   80104ce0 <argptr>
80105f30:	83 c4 10             	add    $0x10,%esp
80105f33:	85 c0                	test   %eax,%eax
80105f35:	78 32                	js     80105f69 <sys_send_multi+0x79>
80105f37:	31 db                	xor    %ebx,%ebx
80105f39:	eb 0d                	jmp    80105f48 <sys_send_multi+0x58>
80105f3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f3f:	90                   	nop
      return -1;
  }

  // Iterate through the receiver process IDs and call send_message for each valid ID
  for (int i=0; i < 8; i++){
80105f40:	83 c3 04             	add    $0x4,%ebx
80105f43:	83 fb 20             	cmp    $0x20,%ebx
80105f46:	74 30                	je     80105f78 <sys_send_multi+0x88>
    int rec_pid = *(rec_pids + i);
80105f48:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f4b:	8b 04 18             	mov    (%eax,%ebx,1),%eax
    if (rec_pid > 0){
80105f4e:	85 c0                	test   %eax,%eax
80105f50:	7e ee                	jle    80105f40 <sys_send_multi+0x50>
      int return_value = send_message(sender_pid, rec_pid, msg);
80105f52:	83 ec 04             	sub    $0x4,%esp
80105f55:	ff 75 f4             	pushl  -0xc(%ebp)
80105f58:	50                   	push   %eax
80105f59:	ff 75 ec             	pushl  -0x14(%ebp)
80105f5c:	e8 3f e5 ff ff       	call   801044a0 <send_message>
      if (return_value == -1){
80105f61:	83 c4 10             	add    $0x10,%esp
80105f64:	83 f8 ff             	cmp    $0xffffffff,%eax
80105f67:	75 d7                	jne    80105f40 <sys_send_multi+0x50>
      }
    }
  }

  return 1;
}
80105f69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105f6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105f71:	c9                   	leave  
80105f72:	c3                   	ret    
80105f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f77:	90                   	nop
80105f78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 1;
80105f7b:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105f80:	c9                   	leave  
80105f81:	c3                   	ret    

80105f82 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105f82:	1e                   	push   %ds
  pushl %es
80105f83:	06                   	push   %es
  pushl %fs
80105f84:	0f a0                	push   %fs
  pushl %gs
80105f86:	0f a8                	push   %gs
  pushal
80105f88:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105f89:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105f8d:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105f8f:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105f91:	54                   	push   %esp
  call trap
80105f92:	e8 c9 00 00 00       	call   80106060 <trap>
  addl $4, %esp
80105f97:	83 c4 04             	add    $0x4,%esp

80105f9a <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105f9a:	61                   	popa   
  popl %gs
80105f9b:	0f a9                	pop    %gs
  popl %fs
80105f9d:	0f a1                	pop    %fs
  popl %es
80105f9f:	07                   	pop    %es
  popl %ds
80105fa0:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105fa1:	83 c4 08             	add    $0x8,%esp
  iret
80105fa4:	cf                   	iret   
80105fa5:	66 90                	xchg   %ax,%ax
80105fa7:	66 90                	xchg   %ax,%ax
80105fa9:	66 90                	xchg   %ax,%ax
80105fab:	66 90                	xchg   %ax,%ax
80105fad:	66 90                	xchg   %ax,%ax
80105faf:	90                   	nop

80105fb0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105fb0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105fb1:	31 c0                	xor    %eax,%eax
{
80105fb3:	89 e5                	mov    %esp,%ebp
80105fb5:	83 ec 08             	sub    $0x8,%esp
80105fb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fbf:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105fc0:	8b 14 85 00 b1 10 80 	mov    -0x7fef4f00(,%eax,4),%edx
80105fc7:	c7 04 c5 42 63 11 80 	movl   $0x8e000008,-0x7fee9cbe(,%eax,8)
80105fce:	08 00 00 8e 
80105fd2:	66 89 14 c5 40 63 11 	mov    %dx,-0x7fee9cc0(,%eax,8)
80105fd9:	80 
80105fda:	c1 ea 10             	shr    $0x10,%edx
80105fdd:	66 89 14 c5 46 63 11 	mov    %dx,-0x7fee9cba(,%eax,8)
80105fe4:	80 
  for(i = 0; i < 256; i++)
80105fe5:	83 c0 01             	add    $0x1,%eax
80105fe8:	3d 00 01 00 00       	cmp    $0x100,%eax
80105fed:	75 d1                	jne    80105fc0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105fef:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105ff2:	a1 00 b2 10 80       	mov    0x8010b200,%eax
80105ff7:	c7 05 42 65 11 80 08 	movl   $0xef000008,0x80116542
80105ffe:	00 00 ef 
  initlock(&tickslock, "time");
80106001:	68 58 80 10 80       	push   $0x80108058
80106006:	68 00 63 11 80       	push   $0x80116300
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010600b:	66 a3 40 65 11 80    	mov    %ax,0x80116540
80106011:	c1 e8 10             	shr    $0x10,%eax
80106014:	66 a3 46 65 11 80    	mov    %ax,0x80116546
  initlock(&tickslock, "time");
8010601a:	e8 21 e7 ff ff       	call   80104740 <initlock>
}
8010601f:	83 c4 10             	add    $0x10,%esp
80106022:	c9                   	leave  
80106023:	c3                   	ret    
80106024:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010602b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010602f:	90                   	nop

80106030 <idtinit>:

void
idtinit(void)
{
80106030:	55                   	push   %ebp
  pd[0] = size-1;
80106031:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106036:	89 e5                	mov    %esp,%ebp
80106038:	83 ec 10             	sub    $0x10,%esp
8010603b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010603f:	b8 40 63 11 80       	mov    $0x80116340,%eax
80106044:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106048:	c1 e8 10             	shr    $0x10,%eax
8010604b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010604f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106052:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106055:	c9                   	leave  
80106056:	c3                   	ret    
80106057:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010605e:	66 90                	xchg   %ax,%ax

80106060 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106060:	55                   	push   %ebp
80106061:	89 e5                	mov    %esp,%ebp
80106063:	57                   	push   %edi
80106064:	56                   	push   %esi
80106065:	53                   	push   %ebx
80106066:	83 ec 1c             	sub    $0x1c,%esp
80106069:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010606c:	8b 43 30             	mov    0x30(%ebx),%eax
8010606f:	83 f8 40             	cmp    $0x40,%eax
80106072:	0f 84 68 01 00 00    	je     801061e0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106078:	83 e8 20             	sub    $0x20,%eax
8010607b:	83 f8 1f             	cmp    $0x1f,%eax
8010607e:	0f 87 8c 00 00 00    	ja     80106110 <trap+0xb0>
80106084:	ff 24 85 80 82 10 80 	jmp    *-0x7fef7d80(,%eax,4)
8010608b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010608f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106090:	e8 bb c2 ff ff       	call   80102350 <ideintr>
    lapiceoi();
80106095:	e8 86 c9 ff ff       	call   80102a20 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010609a:	e8 f1 d9 ff ff       	call   80103a90 <myproc>
8010609f:	85 c0                	test   %eax,%eax
801060a1:	74 1d                	je     801060c0 <trap+0x60>
801060a3:	e8 e8 d9 ff ff       	call   80103a90 <myproc>
801060a8:	8b 50 24             	mov    0x24(%eax),%edx
801060ab:	85 d2                	test   %edx,%edx
801060ad:	74 11                	je     801060c0 <trap+0x60>
801060af:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801060b3:	83 e0 03             	and    $0x3,%eax
801060b6:	66 83 f8 03          	cmp    $0x3,%ax
801060ba:	0f 84 e8 01 00 00    	je     801062a8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801060c0:	e8 cb d9 ff ff       	call   80103a90 <myproc>
801060c5:	85 c0                	test   %eax,%eax
801060c7:	74 0f                	je     801060d8 <trap+0x78>
801060c9:	e8 c2 d9 ff ff       	call   80103a90 <myproc>
801060ce:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801060d2:	0f 84 b8 00 00 00    	je     80106190 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801060d8:	e8 b3 d9 ff ff       	call   80103a90 <myproc>
801060dd:	85 c0                	test   %eax,%eax
801060df:	74 1d                	je     801060fe <trap+0x9e>
801060e1:	e8 aa d9 ff ff       	call   80103a90 <myproc>
801060e6:	8b 40 24             	mov    0x24(%eax),%eax
801060e9:	85 c0                	test   %eax,%eax
801060eb:	74 11                	je     801060fe <trap+0x9e>
801060ed:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801060f1:	83 e0 03             	and    $0x3,%eax
801060f4:	66 83 f8 03          	cmp    $0x3,%ax
801060f8:	0f 84 0f 01 00 00    	je     8010620d <trap+0x1ad>
    exit();
}
801060fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106101:	5b                   	pop    %ebx
80106102:	5e                   	pop    %esi
80106103:	5f                   	pop    %edi
80106104:	5d                   	pop    %ebp
80106105:	c3                   	ret    
80106106:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010610d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80106110:	e8 7b d9 ff ff       	call   80103a90 <myproc>
80106115:	8b 7b 38             	mov    0x38(%ebx),%edi
80106118:	85 c0                	test   %eax,%eax
8010611a:	0f 84 a2 01 00 00    	je     801062c2 <trap+0x262>
80106120:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106124:	0f 84 98 01 00 00    	je     801062c2 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010612a:	0f 20 d1             	mov    %cr2,%ecx
8010612d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106130:	e8 3b d9 ff ff       	call   80103a70 <cpuid>
80106135:	8b 73 30             	mov    0x30(%ebx),%esi
80106138:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010613b:	8b 43 34             	mov    0x34(%ebx),%eax
8010613e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106141:	e8 4a d9 ff ff       	call   80103a90 <myproc>
80106146:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106149:	e8 42 d9 ff ff       	call   80103a90 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010614e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106151:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106154:	51                   	push   %ecx
80106155:	57                   	push   %edi
80106156:	52                   	push   %edx
80106157:	ff 75 e4             	pushl  -0x1c(%ebp)
8010615a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010615b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010615e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106161:	56                   	push   %esi
80106162:	ff 70 10             	pushl  0x10(%eax)
80106165:	68 3c 82 10 80       	push   $0x8010823c
8010616a:	e8 11 a5 ff ff       	call   80100680 <cprintf>
    myproc()->killed = 1;
8010616f:	83 c4 20             	add    $0x20,%esp
80106172:	e8 19 d9 ff ff       	call   80103a90 <myproc>
80106177:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010617e:	e8 0d d9 ff ff       	call   80103a90 <myproc>
80106183:	85 c0                	test   %eax,%eax
80106185:	0f 85 18 ff ff ff    	jne    801060a3 <trap+0x43>
8010618b:	e9 30 ff ff ff       	jmp    801060c0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80106190:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106194:	0f 85 3e ff ff ff    	jne    801060d8 <trap+0x78>
    yield();
8010619a:	e8 71 df ff ff       	call   80104110 <yield>
8010619f:	e9 34 ff ff ff       	jmp    801060d8 <trap+0x78>
801061a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801061a8:	8b 7b 38             	mov    0x38(%ebx),%edi
801061ab:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801061af:	e8 bc d8 ff ff       	call   80103a70 <cpuid>
801061b4:	57                   	push   %edi
801061b5:	56                   	push   %esi
801061b6:	50                   	push   %eax
801061b7:	68 e4 81 10 80       	push   $0x801081e4
801061bc:	e8 bf a4 ff ff       	call   80100680 <cprintf>
    lapiceoi();
801061c1:	e8 5a c8 ff ff       	call   80102a20 <lapiceoi>
    break;
801061c6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801061c9:	e8 c2 d8 ff ff       	call   80103a90 <myproc>
801061ce:	85 c0                	test   %eax,%eax
801061d0:	0f 85 cd fe ff ff    	jne    801060a3 <trap+0x43>
801061d6:	e9 e5 fe ff ff       	jmp    801060c0 <trap+0x60>
801061db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061df:	90                   	nop
    if(myproc()->killed)
801061e0:	e8 ab d8 ff ff       	call   80103a90 <myproc>
801061e5:	8b 70 24             	mov    0x24(%eax),%esi
801061e8:	85 f6                	test   %esi,%esi
801061ea:	0f 85 c8 00 00 00    	jne    801062b8 <trap+0x258>
    myproc()->tf = tf;
801061f0:	e8 9b d8 ff ff       	call   80103a90 <myproc>
801061f5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801061f8:	e8 e3 eb ff ff       	call   80104de0 <syscall>
    if(myproc()->killed)
801061fd:	e8 8e d8 ff ff       	call   80103a90 <myproc>
80106202:	8b 48 24             	mov    0x24(%eax),%ecx
80106205:	85 c9                	test   %ecx,%ecx
80106207:	0f 84 f1 fe ff ff    	je     801060fe <trap+0x9e>
}
8010620d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106210:	5b                   	pop    %ebx
80106211:	5e                   	pop    %esi
80106212:	5f                   	pop    %edi
80106213:	5d                   	pop    %ebp
      exit();
80106214:	e9 97 dc ff ff       	jmp    80103eb0 <exit>
80106219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106220:	e8 5b 02 00 00       	call   80106480 <uartintr>
    lapiceoi();
80106225:	e8 f6 c7 ff ff       	call   80102a20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010622a:	e8 61 d8 ff ff       	call   80103a90 <myproc>
8010622f:	85 c0                	test   %eax,%eax
80106231:	0f 85 6c fe ff ff    	jne    801060a3 <trap+0x43>
80106237:	e9 84 fe ff ff       	jmp    801060c0 <trap+0x60>
8010623c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106240:	e8 9b c6 ff ff       	call   801028e0 <kbdintr>
    lapiceoi();
80106245:	e8 d6 c7 ff ff       	call   80102a20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010624a:	e8 41 d8 ff ff       	call   80103a90 <myproc>
8010624f:	85 c0                	test   %eax,%eax
80106251:	0f 85 4c fe ff ff    	jne    801060a3 <trap+0x43>
80106257:	e9 64 fe ff ff       	jmp    801060c0 <trap+0x60>
8010625c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106260:	e8 0b d8 ff ff       	call   80103a70 <cpuid>
80106265:	85 c0                	test   %eax,%eax
80106267:	0f 85 28 fe ff ff    	jne    80106095 <trap+0x35>
      acquire(&tickslock);
8010626d:	83 ec 0c             	sub    $0xc,%esp
80106270:	68 00 63 11 80       	push   $0x80116300
80106275:	e8 96 e6 ff ff       	call   80104910 <acquire>
      wakeup(&ticks);
8010627a:	c7 04 24 e0 62 11 80 	movl   $0x801162e0,(%esp)
      ticks++;
80106281:	83 05 e0 62 11 80 01 	addl   $0x1,0x801162e0
      wakeup(&ticks);
80106288:	e8 93 df ff ff       	call   80104220 <wakeup>
      release(&tickslock);
8010628d:	c7 04 24 00 63 11 80 	movl   $0x80116300,(%esp)
80106294:	e8 17 e6 ff ff       	call   801048b0 <release>
80106299:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010629c:	e9 f4 fd ff ff       	jmp    80106095 <trap+0x35>
801062a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
801062a8:	e8 03 dc ff ff       	call   80103eb0 <exit>
801062ad:	e9 0e fe ff ff       	jmp    801060c0 <trap+0x60>
801062b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801062b8:	e8 f3 db ff ff       	call   80103eb0 <exit>
801062bd:	e9 2e ff ff ff       	jmp    801061f0 <trap+0x190>
801062c2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801062c5:	e8 a6 d7 ff ff       	call   80103a70 <cpuid>
801062ca:	83 ec 0c             	sub    $0xc,%esp
801062cd:	56                   	push   %esi
801062ce:	57                   	push   %edi
801062cf:	50                   	push   %eax
801062d0:	ff 73 30             	pushl  0x30(%ebx)
801062d3:	68 08 82 10 80       	push   $0x80108208
801062d8:	e8 a3 a3 ff ff       	call   80100680 <cprintf>
      panic("trap");
801062dd:	83 c4 14             	add    $0x14,%esp
801062e0:	68 dc 81 10 80       	push   $0x801081dc
801062e5:	e8 96 a0 ff ff       	call   80100380 <panic>
801062ea:	66 90                	xchg   %ax,%ax
801062ec:	66 90                	xchg   %ax,%ax
801062ee:	66 90                	xchg   %ax,%ax

801062f0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801062f0:	a1 40 6b 11 80       	mov    0x80116b40,%eax
801062f5:	85 c0                	test   %eax,%eax
801062f7:	74 17                	je     80106310 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801062f9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801062fe:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801062ff:	a8 01                	test   $0x1,%al
80106301:	74 0d                	je     80106310 <uartgetc+0x20>
80106303:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106308:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106309:	0f b6 c0             	movzbl %al,%eax
8010630c:	c3                   	ret    
8010630d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106310:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106315:	c3                   	ret    
80106316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010631d:	8d 76 00             	lea    0x0(%esi),%esi

80106320 <uartinit>:
{
80106320:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106321:	31 c9                	xor    %ecx,%ecx
80106323:	89 c8                	mov    %ecx,%eax
80106325:	89 e5                	mov    %esp,%ebp
80106327:	57                   	push   %edi
80106328:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010632d:	56                   	push   %esi
8010632e:	89 fa                	mov    %edi,%edx
80106330:	53                   	push   %ebx
80106331:	83 ec 1c             	sub    $0x1c,%esp
80106334:	ee                   	out    %al,(%dx)
80106335:	be fb 03 00 00       	mov    $0x3fb,%esi
8010633a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010633f:	89 f2                	mov    %esi,%edx
80106341:	ee                   	out    %al,(%dx)
80106342:	b8 0c 00 00 00       	mov    $0xc,%eax
80106347:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010634c:	ee                   	out    %al,(%dx)
8010634d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106352:	89 c8                	mov    %ecx,%eax
80106354:	89 da                	mov    %ebx,%edx
80106356:	ee                   	out    %al,(%dx)
80106357:	b8 03 00 00 00       	mov    $0x3,%eax
8010635c:	89 f2                	mov    %esi,%edx
8010635e:	ee                   	out    %al,(%dx)
8010635f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106364:	89 c8                	mov    %ecx,%eax
80106366:	ee                   	out    %al,(%dx)
80106367:	b8 01 00 00 00       	mov    $0x1,%eax
8010636c:	89 da                	mov    %ebx,%edx
8010636e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010636f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106374:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106375:	3c ff                	cmp    $0xff,%al
80106377:	0f 84 93 00 00 00    	je     80106410 <uartinit+0xf0>
  uart = 1;
8010637d:	c7 05 40 6b 11 80 01 	movl   $0x1,0x80116b40
80106384:	00 00 00 
80106387:	89 fa                	mov    %edi,%edx
80106389:	ec                   	in     (%dx),%al
8010638a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010638f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106390:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106393:	bf 00 83 10 80       	mov    $0x80108300,%edi
80106398:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
8010639d:	6a 00                	push   $0x0
8010639f:	6a 04                	push   $0x4
801063a1:	e8 ea c1 ff ff       	call   80102590 <ioapicenable>
801063a6:	c6 45 e7 76          	movb   $0x76,-0x19(%ebp)
801063aa:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801063ad:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
801063b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
801063b8:	a1 40 6b 11 80       	mov    0x80116b40,%eax
801063bd:	bb 80 00 00 00       	mov    $0x80,%ebx
801063c2:	85 c0                	test   %eax,%eax
801063c4:	75 1c                	jne    801063e2 <uartinit+0xc2>
801063c6:	eb 2b                	jmp    801063f3 <uartinit+0xd3>
801063c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063cf:	90                   	nop
    microdelay(10);
801063d0:	83 ec 0c             	sub    $0xc,%esp
801063d3:	6a 0a                	push   $0xa
801063d5:	e8 66 c6 ff ff       	call   80102a40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801063da:	83 c4 10             	add    $0x10,%esp
801063dd:	83 eb 01             	sub    $0x1,%ebx
801063e0:	74 07                	je     801063e9 <uartinit+0xc9>
801063e2:	89 f2                	mov    %esi,%edx
801063e4:	ec                   	in     (%dx),%al
801063e5:	a8 20                	test   $0x20,%al
801063e7:	74 e7                	je     801063d0 <uartinit+0xb0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801063e9:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
801063ed:	ba f8 03 00 00       	mov    $0x3f8,%edx
801063f2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801063f3:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801063f7:	83 c7 01             	add    $0x1,%edi
801063fa:	84 c0                	test   %al,%al
801063fc:	74 12                	je     80106410 <uartinit+0xf0>
801063fe:	88 45 e6             	mov    %al,-0x1a(%ebp)
80106401:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106405:	88 45 e7             	mov    %al,-0x19(%ebp)
80106408:	eb ae                	jmp    801063b8 <uartinit+0x98>
8010640a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80106410:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106413:	5b                   	pop    %ebx
80106414:	5e                   	pop    %esi
80106415:	5f                   	pop    %edi
80106416:	5d                   	pop    %ebp
80106417:	c3                   	ret    
80106418:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010641f:	90                   	nop

80106420 <uartputc>:
  if(!uart)
80106420:	a1 40 6b 11 80       	mov    0x80116b40,%eax
80106425:	85 c0                	test   %eax,%eax
80106427:	74 47                	je     80106470 <uartputc+0x50>
{
80106429:	55                   	push   %ebp
8010642a:	89 e5                	mov    %esp,%ebp
8010642c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010642d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106432:	53                   	push   %ebx
80106433:	bb 80 00 00 00       	mov    $0x80,%ebx
80106438:	eb 18                	jmp    80106452 <uartputc+0x32>
8010643a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106440:	83 ec 0c             	sub    $0xc,%esp
80106443:	6a 0a                	push   $0xa
80106445:	e8 f6 c5 ff ff       	call   80102a40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010644a:	83 c4 10             	add    $0x10,%esp
8010644d:	83 eb 01             	sub    $0x1,%ebx
80106450:	74 07                	je     80106459 <uartputc+0x39>
80106452:	89 f2                	mov    %esi,%edx
80106454:	ec                   	in     (%dx),%al
80106455:	a8 20                	test   $0x20,%al
80106457:	74 e7                	je     80106440 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106459:	8b 45 08             	mov    0x8(%ebp),%eax
8010645c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106461:	ee                   	out    %al,(%dx)
}
80106462:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106465:	5b                   	pop    %ebx
80106466:	5e                   	pop    %esi
80106467:	5d                   	pop    %ebp
80106468:	c3                   	ret    
80106469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106470:	c3                   	ret    
80106471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106478:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010647f:	90                   	nop

80106480 <uartintr>:

void
uartintr(void)
{
80106480:	55                   	push   %ebp
80106481:	89 e5                	mov    %esp,%ebp
80106483:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106486:	68 f0 62 10 80       	push   $0x801062f0
8010648b:	e8 60 a4 ff ff       	call   801008f0 <consoleintr>
}
80106490:	83 c4 10             	add    $0x10,%esp
80106493:	c9                   	leave  
80106494:	c3                   	ret    

80106495 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106495:	6a 00                	push   $0x0
  pushl $0
80106497:	6a 00                	push   $0x0
  jmp alltraps
80106499:	e9 e4 fa ff ff       	jmp    80105f82 <alltraps>

8010649e <vector1>:
.globl vector1
vector1:
  pushl $0
8010649e:	6a 00                	push   $0x0
  pushl $1
801064a0:	6a 01                	push   $0x1
  jmp alltraps
801064a2:	e9 db fa ff ff       	jmp    80105f82 <alltraps>

801064a7 <vector2>:
.globl vector2
vector2:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $2
801064a9:	6a 02                	push   $0x2
  jmp alltraps
801064ab:	e9 d2 fa ff ff       	jmp    80105f82 <alltraps>

801064b0 <vector3>:
.globl vector3
vector3:
  pushl $0
801064b0:	6a 00                	push   $0x0
  pushl $3
801064b2:	6a 03                	push   $0x3
  jmp alltraps
801064b4:	e9 c9 fa ff ff       	jmp    80105f82 <alltraps>

801064b9 <vector4>:
.globl vector4
vector4:
  pushl $0
801064b9:	6a 00                	push   $0x0
  pushl $4
801064bb:	6a 04                	push   $0x4
  jmp alltraps
801064bd:	e9 c0 fa ff ff       	jmp    80105f82 <alltraps>

801064c2 <vector5>:
.globl vector5
vector5:
  pushl $0
801064c2:	6a 00                	push   $0x0
  pushl $5
801064c4:	6a 05                	push   $0x5
  jmp alltraps
801064c6:	e9 b7 fa ff ff       	jmp    80105f82 <alltraps>

801064cb <vector6>:
.globl vector6
vector6:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $6
801064cd:	6a 06                	push   $0x6
  jmp alltraps
801064cf:	e9 ae fa ff ff       	jmp    80105f82 <alltraps>

801064d4 <vector7>:
.globl vector7
vector7:
  pushl $0
801064d4:	6a 00                	push   $0x0
  pushl $7
801064d6:	6a 07                	push   $0x7
  jmp alltraps
801064d8:	e9 a5 fa ff ff       	jmp    80105f82 <alltraps>

801064dd <vector8>:
.globl vector8
vector8:
  pushl $8
801064dd:	6a 08                	push   $0x8
  jmp alltraps
801064df:	e9 9e fa ff ff       	jmp    80105f82 <alltraps>

801064e4 <vector9>:
.globl vector9
vector9:
  pushl $0
801064e4:	6a 00                	push   $0x0
  pushl $9
801064e6:	6a 09                	push   $0x9
  jmp alltraps
801064e8:	e9 95 fa ff ff       	jmp    80105f82 <alltraps>

801064ed <vector10>:
.globl vector10
vector10:
  pushl $10
801064ed:	6a 0a                	push   $0xa
  jmp alltraps
801064ef:	e9 8e fa ff ff       	jmp    80105f82 <alltraps>

801064f4 <vector11>:
.globl vector11
vector11:
  pushl $11
801064f4:	6a 0b                	push   $0xb
  jmp alltraps
801064f6:	e9 87 fa ff ff       	jmp    80105f82 <alltraps>

801064fb <vector12>:
.globl vector12
vector12:
  pushl $12
801064fb:	6a 0c                	push   $0xc
  jmp alltraps
801064fd:	e9 80 fa ff ff       	jmp    80105f82 <alltraps>

80106502 <vector13>:
.globl vector13
vector13:
  pushl $13
80106502:	6a 0d                	push   $0xd
  jmp alltraps
80106504:	e9 79 fa ff ff       	jmp    80105f82 <alltraps>

80106509 <vector14>:
.globl vector14
vector14:
  pushl $14
80106509:	6a 0e                	push   $0xe
  jmp alltraps
8010650b:	e9 72 fa ff ff       	jmp    80105f82 <alltraps>

80106510 <vector15>:
.globl vector15
vector15:
  pushl $0
80106510:	6a 00                	push   $0x0
  pushl $15
80106512:	6a 0f                	push   $0xf
  jmp alltraps
80106514:	e9 69 fa ff ff       	jmp    80105f82 <alltraps>

80106519 <vector16>:
.globl vector16
vector16:
  pushl $0
80106519:	6a 00                	push   $0x0
  pushl $16
8010651b:	6a 10                	push   $0x10
  jmp alltraps
8010651d:	e9 60 fa ff ff       	jmp    80105f82 <alltraps>

80106522 <vector17>:
.globl vector17
vector17:
  pushl $17
80106522:	6a 11                	push   $0x11
  jmp alltraps
80106524:	e9 59 fa ff ff       	jmp    80105f82 <alltraps>

80106529 <vector18>:
.globl vector18
vector18:
  pushl $0
80106529:	6a 00                	push   $0x0
  pushl $18
8010652b:	6a 12                	push   $0x12
  jmp alltraps
8010652d:	e9 50 fa ff ff       	jmp    80105f82 <alltraps>

80106532 <vector19>:
.globl vector19
vector19:
  pushl $0
80106532:	6a 00                	push   $0x0
  pushl $19
80106534:	6a 13                	push   $0x13
  jmp alltraps
80106536:	e9 47 fa ff ff       	jmp    80105f82 <alltraps>

8010653b <vector20>:
.globl vector20
vector20:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $20
8010653d:	6a 14                	push   $0x14
  jmp alltraps
8010653f:	e9 3e fa ff ff       	jmp    80105f82 <alltraps>

80106544 <vector21>:
.globl vector21
vector21:
  pushl $0
80106544:	6a 00                	push   $0x0
  pushl $21
80106546:	6a 15                	push   $0x15
  jmp alltraps
80106548:	e9 35 fa ff ff       	jmp    80105f82 <alltraps>

8010654d <vector22>:
.globl vector22
vector22:
  pushl $0
8010654d:	6a 00                	push   $0x0
  pushl $22
8010654f:	6a 16                	push   $0x16
  jmp alltraps
80106551:	e9 2c fa ff ff       	jmp    80105f82 <alltraps>

80106556 <vector23>:
.globl vector23
vector23:
  pushl $0
80106556:	6a 00                	push   $0x0
  pushl $23
80106558:	6a 17                	push   $0x17
  jmp alltraps
8010655a:	e9 23 fa ff ff       	jmp    80105f82 <alltraps>

8010655f <vector24>:
.globl vector24
vector24:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $24
80106561:	6a 18                	push   $0x18
  jmp alltraps
80106563:	e9 1a fa ff ff       	jmp    80105f82 <alltraps>

80106568 <vector25>:
.globl vector25
vector25:
  pushl $0
80106568:	6a 00                	push   $0x0
  pushl $25
8010656a:	6a 19                	push   $0x19
  jmp alltraps
8010656c:	e9 11 fa ff ff       	jmp    80105f82 <alltraps>

80106571 <vector26>:
.globl vector26
vector26:
  pushl $0
80106571:	6a 00                	push   $0x0
  pushl $26
80106573:	6a 1a                	push   $0x1a
  jmp alltraps
80106575:	e9 08 fa ff ff       	jmp    80105f82 <alltraps>

8010657a <vector27>:
.globl vector27
vector27:
  pushl $0
8010657a:	6a 00                	push   $0x0
  pushl $27
8010657c:	6a 1b                	push   $0x1b
  jmp alltraps
8010657e:	e9 ff f9 ff ff       	jmp    80105f82 <alltraps>

80106583 <vector28>:
.globl vector28
vector28:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $28
80106585:	6a 1c                	push   $0x1c
  jmp alltraps
80106587:	e9 f6 f9 ff ff       	jmp    80105f82 <alltraps>

8010658c <vector29>:
.globl vector29
vector29:
  pushl $0
8010658c:	6a 00                	push   $0x0
  pushl $29
8010658e:	6a 1d                	push   $0x1d
  jmp alltraps
80106590:	e9 ed f9 ff ff       	jmp    80105f82 <alltraps>

80106595 <vector30>:
.globl vector30
vector30:
  pushl $0
80106595:	6a 00                	push   $0x0
  pushl $30
80106597:	6a 1e                	push   $0x1e
  jmp alltraps
80106599:	e9 e4 f9 ff ff       	jmp    80105f82 <alltraps>

8010659e <vector31>:
.globl vector31
vector31:
  pushl $0
8010659e:	6a 00                	push   $0x0
  pushl $31
801065a0:	6a 1f                	push   $0x1f
  jmp alltraps
801065a2:	e9 db f9 ff ff       	jmp    80105f82 <alltraps>

801065a7 <vector32>:
.globl vector32
vector32:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $32
801065a9:	6a 20                	push   $0x20
  jmp alltraps
801065ab:	e9 d2 f9 ff ff       	jmp    80105f82 <alltraps>

801065b0 <vector33>:
.globl vector33
vector33:
  pushl $0
801065b0:	6a 00                	push   $0x0
  pushl $33
801065b2:	6a 21                	push   $0x21
  jmp alltraps
801065b4:	e9 c9 f9 ff ff       	jmp    80105f82 <alltraps>

801065b9 <vector34>:
.globl vector34
vector34:
  pushl $0
801065b9:	6a 00                	push   $0x0
  pushl $34
801065bb:	6a 22                	push   $0x22
  jmp alltraps
801065bd:	e9 c0 f9 ff ff       	jmp    80105f82 <alltraps>

801065c2 <vector35>:
.globl vector35
vector35:
  pushl $0
801065c2:	6a 00                	push   $0x0
  pushl $35
801065c4:	6a 23                	push   $0x23
  jmp alltraps
801065c6:	e9 b7 f9 ff ff       	jmp    80105f82 <alltraps>

801065cb <vector36>:
.globl vector36
vector36:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $36
801065cd:	6a 24                	push   $0x24
  jmp alltraps
801065cf:	e9 ae f9 ff ff       	jmp    80105f82 <alltraps>

801065d4 <vector37>:
.globl vector37
vector37:
  pushl $0
801065d4:	6a 00                	push   $0x0
  pushl $37
801065d6:	6a 25                	push   $0x25
  jmp alltraps
801065d8:	e9 a5 f9 ff ff       	jmp    80105f82 <alltraps>

801065dd <vector38>:
.globl vector38
vector38:
  pushl $0
801065dd:	6a 00                	push   $0x0
  pushl $38
801065df:	6a 26                	push   $0x26
  jmp alltraps
801065e1:	e9 9c f9 ff ff       	jmp    80105f82 <alltraps>

801065e6 <vector39>:
.globl vector39
vector39:
  pushl $0
801065e6:	6a 00                	push   $0x0
  pushl $39
801065e8:	6a 27                	push   $0x27
  jmp alltraps
801065ea:	e9 93 f9 ff ff       	jmp    80105f82 <alltraps>

801065ef <vector40>:
.globl vector40
vector40:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $40
801065f1:	6a 28                	push   $0x28
  jmp alltraps
801065f3:	e9 8a f9 ff ff       	jmp    80105f82 <alltraps>

801065f8 <vector41>:
.globl vector41
vector41:
  pushl $0
801065f8:	6a 00                	push   $0x0
  pushl $41
801065fa:	6a 29                	push   $0x29
  jmp alltraps
801065fc:	e9 81 f9 ff ff       	jmp    80105f82 <alltraps>

80106601 <vector42>:
.globl vector42
vector42:
  pushl $0
80106601:	6a 00                	push   $0x0
  pushl $42
80106603:	6a 2a                	push   $0x2a
  jmp alltraps
80106605:	e9 78 f9 ff ff       	jmp    80105f82 <alltraps>

8010660a <vector43>:
.globl vector43
vector43:
  pushl $0
8010660a:	6a 00                	push   $0x0
  pushl $43
8010660c:	6a 2b                	push   $0x2b
  jmp alltraps
8010660e:	e9 6f f9 ff ff       	jmp    80105f82 <alltraps>

80106613 <vector44>:
.globl vector44
vector44:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $44
80106615:	6a 2c                	push   $0x2c
  jmp alltraps
80106617:	e9 66 f9 ff ff       	jmp    80105f82 <alltraps>

8010661c <vector45>:
.globl vector45
vector45:
  pushl $0
8010661c:	6a 00                	push   $0x0
  pushl $45
8010661e:	6a 2d                	push   $0x2d
  jmp alltraps
80106620:	e9 5d f9 ff ff       	jmp    80105f82 <alltraps>

80106625 <vector46>:
.globl vector46
vector46:
  pushl $0
80106625:	6a 00                	push   $0x0
  pushl $46
80106627:	6a 2e                	push   $0x2e
  jmp alltraps
80106629:	e9 54 f9 ff ff       	jmp    80105f82 <alltraps>

8010662e <vector47>:
.globl vector47
vector47:
  pushl $0
8010662e:	6a 00                	push   $0x0
  pushl $47
80106630:	6a 2f                	push   $0x2f
  jmp alltraps
80106632:	e9 4b f9 ff ff       	jmp    80105f82 <alltraps>

80106637 <vector48>:
.globl vector48
vector48:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $48
80106639:	6a 30                	push   $0x30
  jmp alltraps
8010663b:	e9 42 f9 ff ff       	jmp    80105f82 <alltraps>

80106640 <vector49>:
.globl vector49
vector49:
  pushl $0
80106640:	6a 00                	push   $0x0
  pushl $49
80106642:	6a 31                	push   $0x31
  jmp alltraps
80106644:	e9 39 f9 ff ff       	jmp    80105f82 <alltraps>

80106649 <vector50>:
.globl vector50
vector50:
  pushl $0
80106649:	6a 00                	push   $0x0
  pushl $50
8010664b:	6a 32                	push   $0x32
  jmp alltraps
8010664d:	e9 30 f9 ff ff       	jmp    80105f82 <alltraps>

80106652 <vector51>:
.globl vector51
vector51:
  pushl $0
80106652:	6a 00                	push   $0x0
  pushl $51
80106654:	6a 33                	push   $0x33
  jmp alltraps
80106656:	e9 27 f9 ff ff       	jmp    80105f82 <alltraps>

8010665b <vector52>:
.globl vector52
vector52:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $52
8010665d:	6a 34                	push   $0x34
  jmp alltraps
8010665f:	e9 1e f9 ff ff       	jmp    80105f82 <alltraps>

80106664 <vector53>:
.globl vector53
vector53:
  pushl $0
80106664:	6a 00                	push   $0x0
  pushl $53
80106666:	6a 35                	push   $0x35
  jmp alltraps
80106668:	e9 15 f9 ff ff       	jmp    80105f82 <alltraps>

8010666d <vector54>:
.globl vector54
vector54:
  pushl $0
8010666d:	6a 00                	push   $0x0
  pushl $54
8010666f:	6a 36                	push   $0x36
  jmp alltraps
80106671:	e9 0c f9 ff ff       	jmp    80105f82 <alltraps>

80106676 <vector55>:
.globl vector55
vector55:
  pushl $0
80106676:	6a 00                	push   $0x0
  pushl $55
80106678:	6a 37                	push   $0x37
  jmp alltraps
8010667a:	e9 03 f9 ff ff       	jmp    80105f82 <alltraps>

8010667f <vector56>:
.globl vector56
vector56:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $56
80106681:	6a 38                	push   $0x38
  jmp alltraps
80106683:	e9 fa f8 ff ff       	jmp    80105f82 <alltraps>

80106688 <vector57>:
.globl vector57
vector57:
  pushl $0
80106688:	6a 00                	push   $0x0
  pushl $57
8010668a:	6a 39                	push   $0x39
  jmp alltraps
8010668c:	e9 f1 f8 ff ff       	jmp    80105f82 <alltraps>

80106691 <vector58>:
.globl vector58
vector58:
  pushl $0
80106691:	6a 00                	push   $0x0
  pushl $58
80106693:	6a 3a                	push   $0x3a
  jmp alltraps
80106695:	e9 e8 f8 ff ff       	jmp    80105f82 <alltraps>

8010669a <vector59>:
.globl vector59
vector59:
  pushl $0
8010669a:	6a 00                	push   $0x0
  pushl $59
8010669c:	6a 3b                	push   $0x3b
  jmp alltraps
8010669e:	e9 df f8 ff ff       	jmp    80105f82 <alltraps>

801066a3 <vector60>:
.globl vector60
vector60:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $60
801066a5:	6a 3c                	push   $0x3c
  jmp alltraps
801066a7:	e9 d6 f8 ff ff       	jmp    80105f82 <alltraps>

801066ac <vector61>:
.globl vector61
vector61:
  pushl $0
801066ac:	6a 00                	push   $0x0
  pushl $61
801066ae:	6a 3d                	push   $0x3d
  jmp alltraps
801066b0:	e9 cd f8 ff ff       	jmp    80105f82 <alltraps>

801066b5 <vector62>:
.globl vector62
vector62:
  pushl $0
801066b5:	6a 00                	push   $0x0
  pushl $62
801066b7:	6a 3e                	push   $0x3e
  jmp alltraps
801066b9:	e9 c4 f8 ff ff       	jmp    80105f82 <alltraps>

801066be <vector63>:
.globl vector63
vector63:
  pushl $0
801066be:	6a 00                	push   $0x0
  pushl $63
801066c0:	6a 3f                	push   $0x3f
  jmp alltraps
801066c2:	e9 bb f8 ff ff       	jmp    80105f82 <alltraps>

801066c7 <vector64>:
.globl vector64
vector64:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $64
801066c9:	6a 40                	push   $0x40
  jmp alltraps
801066cb:	e9 b2 f8 ff ff       	jmp    80105f82 <alltraps>

801066d0 <vector65>:
.globl vector65
vector65:
  pushl $0
801066d0:	6a 00                	push   $0x0
  pushl $65
801066d2:	6a 41                	push   $0x41
  jmp alltraps
801066d4:	e9 a9 f8 ff ff       	jmp    80105f82 <alltraps>

801066d9 <vector66>:
.globl vector66
vector66:
  pushl $0
801066d9:	6a 00                	push   $0x0
  pushl $66
801066db:	6a 42                	push   $0x42
  jmp alltraps
801066dd:	e9 a0 f8 ff ff       	jmp    80105f82 <alltraps>

801066e2 <vector67>:
.globl vector67
vector67:
  pushl $0
801066e2:	6a 00                	push   $0x0
  pushl $67
801066e4:	6a 43                	push   $0x43
  jmp alltraps
801066e6:	e9 97 f8 ff ff       	jmp    80105f82 <alltraps>

801066eb <vector68>:
.globl vector68
vector68:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $68
801066ed:	6a 44                	push   $0x44
  jmp alltraps
801066ef:	e9 8e f8 ff ff       	jmp    80105f82 <alltraps>

801066f4 <vector69>:
.globl vector69
vector69:
  pushl $0
801066f4:	6a 00                	push   $0x0
  pushl $69
801066f6:	6a 45                	push   $0x45
  jmp alltraps
801066f8:	e9 85 f8 ff ff       	jmp    80105f82 <alltraps>

801066fd <vector70>:
.globl vector70
vector70:
  pushl $0
801066fd:	6a 00                	push   $0x0
  pushl $70
801066ff:	6a 46                	push   $0x46
  jmp alltraps
80106701:	e9 7c f8 ff ff       	jmp    80105f82 <alltraps>

80106706 <vector71>:
.globl vector71
vector71:
  pushl $0
80106706:	6a 00                	push   $0x0
  pushl $71
80106708:	6a 47                	push   $0x47
  jmp alltraps
8010670a:	e9 73 f8 ff ff       	jmp    80105f82 <alltraps>

8010670f <vector72>:
.globl vector72
vector72:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $72
80106711:	6a 48                	push   $0x48
  jmp alltraps
80106713:	e9 6a f8 ff ff       	jmp    80105f82 <alltraps>

80106718 <vector73>:
.globl vector73
vector73:
  pushl $0
80106718:	6a 00                	push   $0x0
  pushl $73
8010671a:	6a 49                	push   $0x49
  jmp alltraps
8010671c:	e9 61 f8 ff ff       	jmp    80105f82 <alltraps>

80106721 <vector74>:
.globl vector74
vector74:
  pushl $0
80106721:	6a 00                	push   $0x0
  pushl $74
80106723:	6a 4a                	push   $0x4a
  jmp alltraps
80106725:	e9 58 f8 ff ff       	jmp    80105f82 <alltraps>

8010672a <vector75>:
.globl vector75
vector75:
  pushl $0
8010672a:	6a 00                	push   $0x0
  pushl $75
8010672c:	6a 4b                	push   $0x4b
  jmp alltraps
8010672e:	e9 4f f8 ff ff       	jmp    80105f82 <alltraps>

80106733 <vector76>:
.globl vector76
vector76:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $76
80106735:	6a 4c                	push   $0x4c
  jmp alltraps
80106737:	e9 46 f8 ff ff       	jmp    80105f82 <alltraps>

8010673c <vector77>:
.globl vector77
vector77:
  pushl $0
8010673c:	6a 00                	push   $0x0
  pushl $77
8010673e:	6a 4d                	push   $0x4d
  jmp alltraps
80106740:	e9 3d f8 ff ff       	jmp    80105f82 <alltraps>

80106745 <vector78>:
.globl vector78
vector78:
  pushl $0
80106745:	6a 00                	push   $0x0
  pushl $78
80106747:	6a 4e                	push   $0x4e
  jmp alltraps
80106749:	e9 34 f8 ff ff       	jmp    80105f82 <alltraps>

8010674e <vector79>:
.globl vector79
vector79:
  pushl $0
8010674e:	6a 00                	push   $0x0
  pushl $79
80106750:	6a 4f                	push   $0x4f
  jmp alltraps
80106752:	e9 2b f8 ff ff       	jmp    80105f82 <alltraps>

80106757 <vector80>:
.globl vector80
vector80:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $80
80106759:	6a 50                	push   $0x50
  jmp alltraps
8010675b:	e9 22 f8 ff ff       	jmp    80105f82 <alltraps>

80106760 <vector81>:
.globl vector81
vector81:
  pushl $0
80106760:	6a 00                	push   $0x0
  pushl $81
80106762:	6a 51                	push   $0x51
  jmp alltraps
80106764:	e9 19 f8 ff ff       	jmp    80105f82 <alltraps>

80106769 <vector82>:
.globl vector82
vector82:
  pushl $0
80106769:	6a 00                	push   $0x0
  pushl $82
8010676b:	6a 52                	push   $0x52
  jmp alltraps
8010676d:	e9 10 f8 ff ff       	jmp    80105f82 <alltraps>

80106772 <vector83>:
.globl vector83
vector83:
  pushl $0
80106772:	6a 00                	push   $0x0
  pushl $83
80106774:	6a 53                	push   $0x53
  jmp alltraps
80106776:	e9 07 f8 ff ff       	jmp    80105f82 <alltraps>

8010677b <vector84>:
.globl vector84
vector84:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $84
8010677d:	6a 54                	push   $0x54
  jmp alltraps
8010677f:	e9 fe f7 ff ff       	jmp    80105f82 <alltraps>

80106784 <vector85>:
.globl vector85
vector85:
  pushl $0
80106784:	6a 00                	push   $0x0
  pushl $85
80106786:	6a 55                	push   $0x55
  jmp alltraps
80106788:	e9 f5 f7 ff ff       	jmp    80105f82 <alltraps>

8010678d <vector86>:
.globl vector86
vector86:
  pushl $0
8010678d:	6a 00                	push   $0x0
  pushl $86
8010678f:	6a 56                	push   $0x56
  jmp alltraps
80106791:	e9 ec f7 ff ff       	jmp    80105f82 <alltraps>

80106796 <vector87>:
.globl vector87
vector87:
  pushl $0
80106796:	6a 00                	push   $0x0
  pushl $87
80106798:	6a 57                	push   $0x57
  jmp alltraps
8010679a:	e9 e3 f7 ff ff       	jmp    80105f82 <alltraps>

8010679f <vector88>:
.globl vector88
vector88:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $88
801067a1:	6a 58                	push   $0x58
  jmp alltraps
801067a3:	e9 da f7 ff ff       	jmp    80105f82 <alltraps>

801067a8 <vector89>:
.globl vector89
vector89:
  pushl $0
801067a8:	6a 00                	push   $0x0
  pushl $89
801067aa:	6a 59                	push   $0x59
  jmp alltraps
801067ac:	e9 d1 f7 ff ff       	jmp    80105f82 <alltraps>

801067b1 <vector90>:
.globl vector90
vector90:
  pushl $0
801067b1:	6a 00                	push   $0x0
  pushl $90
801067b3:	6a 5a                	push   $0x5a
  jmp alltraps
801067b5:	e9 c8 f7 ff ff       	jmp    80105f82 <alltraps>

801067ba <vector91>:
.globl vector91
vector91:
  pushl $0
801067ba:	6a 00                	push   $0x0
  pushl $91
801067bc:	6a 5b                	push   $0x5b
  jmp alltraps
801067be:	e9 bf f7 ff ff       	jmp    80105f82 <alltraps>

801067c3 <vector92>:
.globl vector92
vector92:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $92
801067c5:	6a 5c                	push   $0x5c
  jmp alltraps
801067c7:	e9 b6 f7 ff ff       	jmp    80105f82 <alltraps>

801067cc <vector93>:
.globl vector93
vector93:
  pushl $0
801067cc:	6a 00                	push   $0x0
  pushl $93
801067ce:	6a 5d                	push   $0x5d
  jmp alltraps
801067d0:	e9 ad f7 ff ff       	jmp    80105f82 <alltraps>

801067d5 <vector94>:
.globl vector94
vector94:
  pushl $0
801067d5:	6a 00                	push   $0x0
  pushl $94
801067d7:	6a 5e                	push   $0x5e
  jmp alltraps
801067d9:	e9 a4 f7 ff ff       	jmp    80105f82 <alltraps>

801067de <vector95>:
.globl vector95
vector95:
  pushl $0
801067de:	6a 00                	push   $0x0
  pushl $95
801067e0:	6a 5f                	push   $0x5f
  jmp alltraps
801067e2:	e9 9b f7 ff ff       	jmp    80105f82 <alltraps>

801067e7 <vector96>:
.globl vector96
vector96:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $96
801067e9:	6a 60                	push   $0x60
  jmp alltraps
801067eb:	e9 92 f7 ff ff       	jmp    80105f82 <alltraps>

801067f0 <vector97>:
.globl vector97
vector97:
  pushl $0
801067f0:	6a 00                	push   $0x0
  pushl $97
801067f2:	6a 61                	push   $0x61
  jmp alltraps
801067f4:	e9 89 f7 ff ff       	jmp    80105f82 <alltraps>

801067f9 <vector98>:
.globl vector98
vector98:
  pushl $0
801067f9:	6a 00                	push   $0x0
  pushl $98
801067fb:	6a 62                	push   $0x62
  jmp alltraps
801067fd:	e9 80 f7 ff ff       	jmp    80105f82 <alltraps>

80106802 <vector99>:
.globl vector99
vector99:
  pushl $0
80106802:	6a 00                	push   $0x0
  pushl $99
80106804:	6a 63                	push   $0x63
  jmp alltraps
80106806:	e9 77 f7 ff ff       	jmp    80105f82 <alltraps>

8010680b <vector100>:
.globl vector100
vector100:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $100
8010680d:	6a 64                	push   $0x64
  jmp alltraps
8010680f:	e9 6e f7 ff ff       	jmp    80105f82 <alltraps>

80106814 <vector101>:
.globl vector101
vector101:
  pushl $0
80106814:	6a 00                	push   $0x0
  pushl $101
80106816:	6a 65                	push   $0x65
  jmp alltraps
80106818:	e9 65 f7 ff ff       	jmp    80105f82 <alltraps>

8010681d <vector102>:
.globl vector102
vector102:
  pushl $0
8010681d:	6a 00                	push   $0x0
  pushl $102
8010681f:	6a 66                	push   $0x66
  jmp alltraps
80106821:	e9 5c f7 ff ff       	jmp    80105f82 <alltraps>

80106826 <vector103>:
.globl vector103
vector103:
  pushl $0
80106826:	6a 00                	push   $0x0
  pushl $103
80106828:	6a 67                	push   $0x67
  jmp alltraps
8010682a:	e9 53 f7 ff ff       	jmp    80105f82 <alltraps>

8010682f <vector104>:
.globl vector104
vector104:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $104
80106831:	6a 68                	push   $0x68
  jmp alltraps
80106833:	e9 4a f7 ff ff       	jmp    80105f82 <alltraps>

80106838 <vector105>:
.globl vector105
vector105:
  pushl $0
80106838:	6a 00                	push   $0x0
  pushl $105
8010683a:	6a 69                	push   $0x69
  jmp alltraps
8010683c:	e9 41 f7 ff ff       	jmp    80105f82 <alltraps>

80106841 <vector106>:
.globl vector106
vector106:
  pushl $0
80106841:	6a 00                	push   $0x0
  pushl $106
80106843:	6a 6a                	push   $0x6a
  jmp alltraps
80106845:	e9 38 f7 ff ff       	jmp    80105f82 <alltraps>

8010684a <vector107>:
.globl vector107
vector107:
  pushl $0
8010684a:	6a 00                	push   $0x0
  pushl $107
8010684c:	6a 6b                	push   $0x6b
  jmp alltraps
8010684e:	e9 2f f7 ff ff       	jmp    80105f82 <alltraps>

80106853 <vector108>:
.globl vector108
vector108:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $108
80106855:	6a 6c                	push   $0x6c
  jmp alltraps
80106857:	e9 26 f7 ff ff       	jmp    80105f82 <alltraps>

8010685c <vector109>:
.globl vector109
vector109:
  pushl $0
8010685c:	6a 00                	push   $0x0
  pushl $109
8010685e:	6a 6d                	push   $0x6d
  jmp alltraps
80106860:	e9 1d f7 ff ff       	jmp    80105f82 <alltraps>

80106865 <vector110>:
.globl vector110
vector110:
  pushl $0
80106865:	6a 00                	push   $0x0
  pushl $110
80106867:	6a 6e                	push   $0x6e
  jmp alltraps
80106869:	e9 14 f7 ff ff       	jmp    80105f82 <alltraps>

8010686e <vector111>:
.globl vector111
vector111:
  pushl $0
8010686e:	6a 00                	push   $0x0
  pushl $111
80106870:	6a 6f                	push   $0x6f
  jmp alltraps
80106872:	e9 0b f7 ff ff       	jmp    80105f82 <alltraps>

80106877 <vector112>:
.globl vector112
vector112:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $112
80106879:	6a 70                	push   $0x70
  jmp alltraps
8010687b:	e9 02 f7 ff ff       	jmp    80105f82 <alltraps>

80106880 <vector113>:
.globl vector113
vector113:
  pushl $0
80106880:	6a 00                	push   $0x0
  pushl $113
80106882:	6a 71                	push   $0x71
  jmp alltraps
80106884:	e9 f9 f6 ff ff       	jmp    80105f82 <alltraps>

80106889 <vector114>:
.globl vector114
vector114:
  pushl $0
80106889:	6a 00                	push   $0x0
  pushl $114
8010688b:	6a 72                	push   $0x72
  jmp alltraps
8010688d:	e9 f0 f6 ff ff       	jmp    80105f82 <alltraps>

80106892 <vector115>:
.globl vector115
vector115:
  pushl $0
80106892:	6a 00                	push   $0x0
  pushl $115
80106894:	6a 73                	push   $0x73
  jmp alltraps
80106896:	e9 e7 f6 ff ff       	jmp    80105f82 <alltraps>

8010689b <vector116>:
.globl vector116
vector116:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $116
8010689d:	6a 74                	push   $0x74
  jmp alltraps
8010689f:	e9 de f6 ff ff       	jmp    80105f82 <alltraps>

801068a4 <vector117>:
.globl vector117
vector117:
  pushl $0
801068a4:	6a 00                	push   $0x0
  pushl $117
801068a6:	6a 75                	push   $0x75
  jmp alltraps
801068a8:	e9 d5 f6 ff ff       	jmp    80105f82 <alltraps>

801068ad <vector118>:
.globl vector118
vector118:
  pushl $0
801068ad:	6a 00                	push   $0x0
  pushl $118
801068af:	6a 76                	push   $0x76
  jmp alltraps
801068b1:	e9 cc f6 ff ff       	jmp    80105f82 <alltraps>

801068b6 <vector119>:
.globl vector119
vector119:
  pushl $0
801068b6:	6a 00                	push   $0x0
  pushl $119
801068b8:	6a 77                	push   $0x77
  jmp alltraps
801068ba:	e9 c3 f6 ff ff       	jmp    80105f82 <alltraps>

801068bf <vector120>:
.globl vector120
vector120:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $120
801068c1:	6a 78                	push   $0x78
  jmp alltraps
801068c3:	e9 ba f6 ff ff       	jmp    80105f82 <alltraps>

801068c8 <vector121>:
.globl vector121
vector121:
  pushl $0
801068c8:	6a 00                	push   $0x0
  pushl $121
801068ca:	6a 79                	push   $0x79
  jmp alltraps
801068cc:	e9 b1 f6 ff ff       	jmp    80105f82 <alltraps>

801068d1 <vector122>:
.globl vector122
vector122:
  pushl $0
801068d1:	6a 00                	push   $0x0
  pushl $122
801068d3:	6a 7a                	push   $0x7a
  jmp alltraps
801068d5:	e9 a8 f6 ff ff       	jmp    80105f82 <alltraps>

801068da <vector123>:
.globl vector123
vector123:
  pushl $0
801068da:	6a 00                	push   $0x0
  pushl $123
801068dc:	6a 7b                	push   $0x7b
  jmp alltraps
801068de:	e9 9f f6 ff ff       	jmp    80105f82 <alltraps>

801068e3 <vector124>:
.globl vector124
vector124:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $124
801068e5:	6a 7c                	push   $0x7c
  jmp alltraps
801068e7:	e9 96 f6 ff ff       	jmp    80105f82 <alltraps>

801068ec <vector125>:
.globl vector125
vector125:
  pushl $0
801068ec:	6a 00                	push   $0x0
  pushl $125
801068ee:	6a 7d                	push   $0x7d
  jmp alltraps
801068f0:	e9 8d f6 ff ff       	jmp    80105f82 <alltraps>

801068f5 <vector126>:
.globl vector126
vector126:
  pushl $0
801068f5:	6a 00                	push   $0x0
  pushl $126
801068f7:	6a 7e                	push   $0x7e
  jmp alltraps
801068f9:	e9 84 f6 ff ff       	jmp    80105f82 <alltraps>

801068fe <vector127>:
.globl vector127
vector127:
  pushl $0
801068fe:	6a 00                	push   $0x0
  pushl $127
80106900:	6a 7f                	push   $0x7f
  jmp alltraps
80106902:	e9 7b f6 ff ff       	jmp    80105f82 <alltraps>

80106907 <vector128>:
.globl vector128
vector128:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $128
80106909:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010690e:	e9 6f f6 ff ff       	jmp    80105f82 <alltraps>

80106913 <vector129>:
.globl vector129
vector129:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $129
80106915:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010691a:	e9 63 f6 ff ff       	jmp    80105f82 <alltraps>

8010691f <vector130>:
.globl vector130
vector130:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $130
80106921:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106926:	e9 57 f6 ff ff       	jmp    80105f82 <alltraps>

8010692b <vector131>:
.globl vector131
vector131:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $131
8010692d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106932:	e9 4b f6 ff ff       	jmp    80105f82 <alltraps>

80106937 <vector132>:
.globl vector132
vector132:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $132
80106939:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010693e:	e9 3f f6 ff ff       	jmp    80105f82 <alltraps>

80106943 <vector133>:
.globl vector133
vector133:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $133
80106945:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010694a:	e9 33 f6 ff ff       	jmp    80105f82 <alltraps>

8010694f <vector134>:
.globl vector134
vector134:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $134
80106951:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106956:	e9 27 f6 ff ff       	jmp    80105f82 <alltraps>

8010695b <vector135>:
.globl vector135
vector135:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $135
8010695d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106962:	e9 1b f6 ff ff       	jmp    80105f82 <alltraps>

80106967 <vector136>:
.globl vector136
vector136:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $136
80106969:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010696e:	e9 0f f6 ff ff       	jmp    80105f82 <alltraps>

80106973 <vector137>:
.globl vector137
vector137:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $137
80106975:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010697a:	e9 03 f6 ff ff       	jmp    80105f82 <alltraps>

8010697f <vector138>:
.globl vector138
vector138:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $138
80106981:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106986:	e9 f7 f5 ff ff       	jmp    80105f82 <alltraps>

8010698b <vector139>:
.globl vector139
vector139:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $139
8010698d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106992:	e9 eb f5 ff ff       	jmp    80105f82 <alltraps>

80106997 <vector140>:
.globl vector140
vector140:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $140
80106999:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010699e:	e9 df f5 ff ff       	jmp    80105f82 <alltraps>

801069a3 <vector141>:
.globl vector141
vector141:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $141
801069a5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801069aa:	e9 d3 f5 ff ff       	jmp    80105f82 <alltraps>

801069af <vector142>:
.globl vector142
vector142:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $142
801069b1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801069b6:	e9 c7 f5 ff ff       	jmp    80105f82 <alltraps>

801069bb <vector143>:
.globl vector143
vector143:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $143
801069bd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801069c2:	e9 bb f5 ff ff       	jmp    80105f82 <alltraps>

801069c7 <vector144>:
.globl vector144
vector144:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $144
801069c9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801069ce:	e9 af f5 ff ff       	jmp    80105f82 <alltraps>

801069d3 <vector145>:
.globl vector145
vector145:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $145
801069d5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801069da:	e9 a3 f5 ff ff       	jmp    80105f82 <alltraps>

801069df <vector146>:
.globl vector146
vector146:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $146
801069e1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801069e6:	e9 97 f5 ff ff       	jmp    80105f82 <alltraps>

801069eb <vector147>:
.globl vector147
vector147:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $147
801069ed:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801069f2:	e9 8b f5 ff ff       	jmp    80105f82 <alltraps>

801069f7 <vector148>:
.globl vector148
vector148:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $148
801069f9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801069fe:	e9 7f f5 ff ff       	jmp    80105f82 <alltraps>

80106a03 <vector149>:
.globl vector149
vector149:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $149
80106a05:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106a0a:	e9 73 f5 ff ff       	jmp    80105f82 <alltraps>

80106a0f <vector150>:
.globl vector150
vector150:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $150
80106a11:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106a16:	e9 67 f5 ff ff       	jmp    80105f82 <alltraps>

80106a1b <vector151>:
.globl vector151
vector151:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $151
80106a1d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106a22:	e9 5b f5 ff ff       	jmp    80105f82 <alltraps>

80106a27 <vector152>:
.globl vector152
vector152:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $152
80106a29:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106a2e:	e9 4f f5 ff ff       	jmp    80105f82 <alltraps>

80106a33 <vector153>:
.globl vector153
vector153:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $153
80106a35:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106a3a:	e9 43 f5 ff ff       	jmp    80105f82 <alltraps>

80106a3f <vector154>:
.globl vector154
vector154:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $154
80106a41:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106a46:	e9 37 f5 ff ff       	jmp    80105f82 <alltraps>

80106a4b <vector155>:
.globl vector155
vector155:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $155
80106a4d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106a52:	e9 2b f5 ff ff       	jmp    80105f82 <alltraps>

80106a57 <vector156>:
.globl vector156
vector156:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $156
80106a59:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106a5e:	e9 1f f5 ff ff       	jmp    80105f82 <alltraps>

80106a63 <vector157>:
.globl vector157
vector157:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $157
80106a65:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106a6a:	e9 13 f5 ff ff       	jmp    80105f82 <alltraps>

80106a6f <vector158>:
.globl vector158
vector158:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $158
80106a71:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106a76:	e9 07 f5 ff ff       	jmp    80105f82 <alltraps>

80106a7b <vector159>:
.globl vector159
vector159:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $159
80106a7d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106a82:	e9 fb f4 ff ff       	jmp    80105f82 <alltraps>

80106a87 <vector160>:
.globl vector160
vector160:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $160
80106a89:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106a8e:	e9 ef f4 ff ff       	jmp    80105f82 <alltraps>

80106a93 <vector161>:
.globl vector161
vector161:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $161
80106a95:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106a9a:	e9 e3 f4 ff ff       	jmp    80105f82 <alltraps>

80106a9f <vector162>:
.globl vector162
vector162:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $162
80106aa1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106aa6:	e9 d7 f4 ff ff       	jmp    80105f82 <alltraps>

80106aab <vector163>:
.globl vector163
vector163:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $163
80106aad:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106ab2:	e9 cb f4 ff ff       	jmp    80105f82 <alltraps>

80106ab7 <vector164>:
.globl vector164
vector164:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $164
80106ab9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106abe:	e9 bf f4 ff ff       	jmp    80105f82 <alltraps>

80106ac3 <vector165>:
.globl vector165
vector165:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $165
80106ac5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106aca:	e9 b3 f4 ff ff       	jmp    80105f82 <alltraps>

80106acf <vector166>:
.globl vector166
vector166:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $166
80106ad1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106ad6:	e9 a7 f4 ff ff       	jmp    80105f82 <alltraps>

80106adb <vector167>:
.globl vector167
vector167:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $167
80106add:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106ae2:	e9 9b f4 ff ff       	jmp    80105f82 <alltraps>

80106ae7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $168
80106ae9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106aee:	e9 8f f4 ff ff       	jmp    80105f82 <alltraps>

80106af3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $169
80106af5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106afa:	e9 83 f4 ff ff       	jmp    80105f82 <alltraps>

80106aff <vector170>:
.globl vector170
vector170:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $170
80106b01:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106b06:	e9 77 f4 ff ff       	jmp    80105f82 <alltraps>

80106b0b <vector171>:
.globl vector171
vector171:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $171
80106b0d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106b12:	e9 6b f4 ff ff       	jmp    80105f82 <alltraps>

80106b17 <vector172>:
.globl vector172
vector172:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $172
80106b19:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106b1e:	e9 5f f4 ff ff       	jmp    80105f82 <alltraps>

80106b23 <vector173>:
.globl vector173
vector173:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $173
80106b25:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106b2a:	e9 53 f4 ff ff       	jmp    80105f82 <alltraps>

80106b2f <vector174>:
.globl vector174
vector174:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $174
80106b31:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106b36:	e9 47 f4 ff ff       	jmp    80105f82 <alltraps>

80106b3b <vector175>:
.globl vector175
vector175:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $175
80106b3d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106b42:	e9 3b f4 ff ff       	jmp    80105f82 <alltraps>

80106b47 <vector176>:
.globl vector176
vector176:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $176
80106b49:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106b4e:	e9 2f f4 ff ff       	jmp    80105f82 <alltraps>

80106b53 <vector177>:
.globl vector177
vector177:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $177
80106b55:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106b5a:	e9 23 f4 ff ff       	jmp    80105f82 <alltraps>

80106b5f <vector178>:
.globl vector178
vector178:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $178
80106b61:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106b66:	e9 17 f4 ff ff       	jmp    80105f82 <alltraps>

80106b6b <vector179>:
.globl vector179
vector179:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $179
80106b6d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106b72:	e9 0b f4 ff ff       	jmp    80105f82 <alltraps>

80106b77 <vector180>:
.globl vector180
vector180:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $180
80106b79:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106b7e:	e9 ff f3 ff ff       	jmp    80105f82 <alltraps>

80106b83 <vector181>:
.globl vector181
vector181:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $181
80106b85:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106b8a:	e9 f3 f3 ff ff       	jmp    80105f82 <alltraps>

80106b8f <vector182>:
.globl vector182
vector182:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $182
80106b91:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106b96:	e9 e7 f3 ff ff       	jmp    80105f82 <alltraps>

80106b9b <vector183>:
.globl vector183
vector183:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $183
80106b9d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106ba2:	e9 db f3 ff ff       	jmp    80105f82 <alltraps>

80106ba7 <vector184>:
.globl vector184
vector184:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $184
80106ba9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106bae:	e9 cf f3 ff ff       	jmp    80105f82 <alltraps>

80106bb3 <vector185>:
.globl vector185
vector185:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $185
80106bb5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106bba:	e9 c3 f3 ff ff       	jmp    80105f82 <alltraps>

80106bbf <vector186>:
.globl vector186
vector186:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $186
80106bc1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106bc6:	e9 b7 f3 ff ff       	jmp    80105f82 <alltraps>

80106bcb <vector187>:
.globl vector187
vector187:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $187
80106bcd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106bd2:	e9 ab f3 ff ff       	jmp    80105f82 <alltraps>

80106bd7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $188
80106bd9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106bde:	e9 9f f3 ff ff       	jmp    80105f82 <alltraps>

80106be3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $189
80106be5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106bea:	e9 93 f3 ff ff       	jmp    80105f82 <alltraps>

80106bef <vector190>:
.globl vector190
vector190:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $190
80106bf1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106bf6:	e9 87 f3 ff ff       	jmp    80105f82 <alltraps>

80106bfb <vector191>:
.globl vector191
vector191:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $191
80106bfd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106c02:	e9 7b f3 ff ff       	jmp    80105f82 <alltraps>

80106c07 <vector192>:
.globl vector192
vector192:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $192
80106c09:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106c0e:	e9 6f f3 ff ff       	jmp    80105f82 <alltraps>

80106c13 <vector193>:
.globl vector193
vector193:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $193
80106c15:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106c1a:	e9 63 f3 ff ff       	jmp    80105f82 <alltraps>

80106c1f <vector194>:
.globl vector194
vector194:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $194
80106c21:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106c26:	e9 57 f3 ff ff       	jmp    80105f82 <alltraps>

80106c2b <vector195>:
.globl vector195
vector195:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $195
80106c2d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106c32:	e9 4b f3 ff ff       	jmp    80105f82 <alltraps>

80106c37 <vector196>:
.globl vector196
vector196:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $196
80106c39:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106c3e:	e9 3f f3 ff ff       	jmp    80105f82 <alltraps>

80106c43 <vector197>:
.globl vector197
vector197:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $197
80106c45:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106c4a:	e9 33 f3 ff ff       	jmp    80105f82 <alltraps>

80106c4f <vector198>:
.globl vector198
vector198:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $198
80106c51:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106c56:	e9 27 f3 ff ff       	jmp    80105f82 <alltraps>

80106c5b <vector199>:
.globl vector199
vector199:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $199
80106c5d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106c62:	e9 1b f3 ff ff       	jmp    80105f82 <alltraps>

80106c67 <vector200>:
.globl vector200
vector200:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $200
80106c69:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106c6e:	e9 0f f3 ff ff       	jmp    80105f82 <alltraps>

80106c73 <vector201>:
.globl vector201
vector201:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $201
80106c75:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106c7a:	e9 03 f3 ff ff       	jmp    80105f82 <alltraps>

80106c7f <vector202>:
.globl vector202
vector202:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $202
80106c81:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106c86:	e9 f7 f2 ff ff       	jmp    80105f82 <alltraps>

80106c8b <vector203>:
.globl vector203
vector203:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $203
80106c8d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106c92:	e9 eb f2 ff ff       	jmp    80105f82 <alltraps>

80106c97 <vector204>:
.globl vector204
vector204:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $204
80106c99:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106c9e:	e9 df f2 ff ff       	jmp    80105f82 <alltraps>

80106ca3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $205
80106ca5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106caa:	e9 d3 f2 ff ff       	jmp    80105f82 <alltraps>

80106caf <vector206>:
.globl vector206
vector206:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $206
80106cb1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106cb6:	e9 c7 f2 ff ff       	jmp    80105f82 <alltraps>

80106cbb <vector207>:
.globl vector207
vector207:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $207
80106cbd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106cc2:	e9 bb f2 ff ff       	jmp    80105f82 <alltraps>

80106cc7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $208
80106cc9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106cce:	e9 af f2 ff ff       	jmp    80105f82 <alltraps>

80106cd3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $209
80106cd5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106cda:	e9 a3 f2 ff ff       	jmp    80105f82 <alltraps>

80106cdf <vector210>:
.globl vector210
vector210:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $210
80106ce1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106ce6:	e9 97 f2 ff ff       	jmp    80105f82 <alltraps>

80106ceb <vector211>:
.globl vector211
vector211:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $211
80106ced:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106cf2:	e9 8b f2 ff ff       	jmp    80105f82 <alltraps>

80106cf7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $212
80106cf9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106cfe:	e9 7f f2 ff ff       	jmp    80105f82 <alltraps>

80106d03 <vector213>:
.globl vector213
vector213:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $213
80106d05:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106d0a:	e9 73 f2 ff ff       	jmp    80105f82 <alltraps>

80106d0f <vector214>:
.globl vector214
vector214:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $214
80106d11:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106d16:	e9 67 f2 ff ff       	jmp    80105f82 <alltraps>

80106d1b <vector215>:
.globl vector215
vector215:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $215
80106d1d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106d22:	e9 5b f2 ff ff       	jmp    80105f82 <alltraps>

80106d27 <vector216>:
.globl vector216
vector216:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $216
80106d29:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106d2e:	e9 4f f2 ff ff       	jmp    80105f82 <alltraps>

80106d33 <vector217>:
.globl vector217
vector217:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $217
80106d35:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106d3a:	e9 43 f2 ff ff       	jmp    80105f82 <alltraps>

80106d3f <vector218>:
.globl vector218
vector218:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $218
80106d41:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106d46:	e9 37 f2 ff ff       	jmp    80105f82 <alltraps>

80106d4b <vector219>:
.globl vector219
vector219:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $219
80106d4d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106d52:	e9 2b f2 ff ff       	jmp    80105f82 <alltraps>

80106d57 <vector220>:
.globl vector220
vector220:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $220
80106d59:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106d5e:	e9 1f f2 ff ff       	jmp    80105f82 <alltraps>

80106d63 <vector221>:
.globl vector221
vector221:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $221
80106d65:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106d6a:	e9 13 f2 ff ff       	jmp    80105f82 <alltraps>

80106d6f <vector222>:
.globl vector222
vector222:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $222
80106d71:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106d76:	e9 07 f2 ff ff       	jmp    80105f82 <alltraps>

80106d7b <vector223>:
.globl vector223
vector223:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $223
80106d7d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106d82:	e9 fb f1 ff ff       	jmp    80105f82 <alltraps>

80106d87 <vector224>:
.globl vector224
vector224:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $224
80106d89:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106d8e:	e9 ef f1 ff ff       	jmp    80105f82 <alltraps>

80106d93 <vector225>:
.globl vector225
vector225:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $225
80106d95:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106d9a:	e9 e3 f1 ff ff       	jmp    80105f82 <alltraps>

80106d9f <vector226>:
.globl vector226
vector226:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $226
80106da1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106da6:	e9 d7 f1 ff ff       	jmp    80105f82 <alltraps>

80106dab <vector227>:
.globl vector227
vector227:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $227
80106dad:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106db2:	e9 cb f1 ff ff       	jmp    80105f82 <alltraps>

80106db7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $228
80106db9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106dbe:	e9 bf f1 ff ff       	jmp    80105f82 <alltraps>

80106dc3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $229
80106dc5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106dca:	e9 b3 f1 ff ff       	jmp    80105f82 <alltraps>

80106dcf <vector230>:
.globl vector230
vector230:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $230
80106dd1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106dd6:	e9 a7 f1 ff ff       	jmp    80105f82 <alltraps>

80106ddb <vector231>:
.globl vector231
vector231:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $231
80106ddd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106de2:	e9 9b f1 ff ff       	jmp    80105f82 <alltraps>

80106de7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $232
80106de9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106dee:	e9 8f f1 ff ff       	jmp    80105f82 <alltraps>

80106df3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $233
80106df5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106dfa:	e9 83 f1 ff ff       	jmp    80105f82 <alltraps>

80106dff <vector234>:
.globl vector234
vector234:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $234
80106e01:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106e06:	e9 77 f1 ff ff       	jmp    80105f82 <alltraps>

80106e0b <vector235>:
.globl vector235
vector235:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $235
80106e0d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106e12:	e9 6b f1 ff ff       	jmp    80105f82 <alltraps>

80106e17 <vector236>:
.globl vector236
vector236:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $236
80106e19:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106e1e:	e9 5f f1 ff ff       	jmp    80105f82 <alltraps>

80106e23 <vector237>:
.globl vector237
vector237:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $237
80106e25:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106e2a:	e9 53 f1 ff ff       	jmp    80105f82 <alltraps>

80106e2f <vector238>:
.globl vector238
vector238:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $238
80106e31:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106e36:	e9 47 f1 ff ff       	jmp    80105f82 <alltraps>

80106e3b <vector239>:
.globl vector239
vector239:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $239
80106e3d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106e42:	e9 3b f1 ff ff       	jmp    80105f82 <alltraps>

80106e47 <vector240>:
.globl vector240
vector240:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $240
80106e49:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106e4e:	e9 2f f1 ff ff       	jmp    80105f82 <alltraps>

80106e53 <vector241>:
.globl vector241
vector241:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $241
80106e55:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106e5a:	e9 23 f1 ff ff       	jmp    80105f82 <alltraps>

80106e5f <vector242>:
.globl vector242
vector242:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $242
80106e61:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106e66:	e9 17 f1 ff ff       	jmp    80105f82 <alltraps>

80106e6b <vector243>:
.globl vector243
vector243:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $243
80106e6d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106e72:	e9 0b f1 ff ff       	jmp    80105f82 <alltraps>

80106e77 <vector244>:
.globl vector244
vector244:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $244
80106e79:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106e7e:	e9 ff f0 ff ff       	jmp    80105f82 <alltraps>

80106e83 <vector245>:
.globl vector245
vector245:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $245
80106e85:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106e8a:	e9 f3 f0 ff ff       	jmp    80105f82 <alltraps>

80106e8f <vector246>:
.globl vector246
vector246:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $246
80106e91:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106e96:	e9 e7 f0 ff ff       	jmp    80105f82 <alltraps>

80106e9b <vector247>:
.globl vector247
vector247:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $247
80106e9d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106ea2:	e9 db f0 ff ff       	jmp    80105f82 <alltraps>

80106ea7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $248
80106ea9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106eae:	e9 cf f0 ff ff       	jmp    80105f82 <alltraps>

80106eb3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $249
80106eb5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106eba:	e9 c3 f0 ff ff       	jmp    80105f82 <alltraps>

80106ebf <vector250>:
.globl vector250
vector250:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $250
80106ec1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106ec6:	e9 b7 f0 ff ff       	jmp    80105f82 <alltraps>

80106ecb <vector251>:
.globl vector251
vector251:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $251
80106ecd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106ed2:	e9 ab f0 ff ff       	jmp    80105f82 <alltraps>

80106ed7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $252
80106ed9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106ede:	e9 9f f0 ff ff       	jmp    80105f82 <alltraps>

80106ee3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $253
80106ee5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106eea:	e9 93 f0 ff ff       	jmp    80105f82 <alltraps>

80106eef <vector254>:
.globl vector254
vector254:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $254
80106ef1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106ef6:	e9 87 f0 ff ff       	jmp    80105f82 <alltraps>

80106efb <vector255>:
.globl vector255
vector255:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $255
80106efd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106f02:	e9 7b f0 ff ff       	jmp    80105f82 <alltraps>
80106f07:	66 90                	xchg   %ax,%ax
80106f09:	66 90                	xchg   %ax,%ax
80106f0b:	66 90                	xchg   %ax,%ax
80106f0d:	66 90                	xchg   %ax,%ax
80106f0f:	90                   	nop

80106f10 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f10:	55                   	push   %ebp
80106f11:	89 e5                	mov    %esp,%ebp
80106f13:	57                   	push   %edi
80106f14:	56                   	push   %esi
80106f15:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106f16:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106f1c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106f22:	83 ec 1c             	sub    $0x1c,%esp
80106f25:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106f28:	39 d3                	cmp    %edx,%ebx
80106f2a:	73 45                	jae    80106f71 <deallocuvm.part.0+0x61>
80106f2c:	89 c7                	mov    %eax,%edi
80106f2e:	eb 0a                	jmp    80106f3a <deallocuvm.part.0+0x2a>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106f30:	8d 59 01             	lea    0x1(%ecx),%ebx
80106f33:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106f36:	39 da                	cmp    %ebx,%edx
80106f38:	76 37                	jbe    80106f71 <deallocuvm.part.0+0x61>
  pde = &pgdir[PDX(va)];
80106f3a:	89 d9                	mov    %ebx,%ecx
80106f3c:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106f3f:	8b 04 8f             	mov    (%edi,%ecx,4),%eax
80106f42:	a8 01                	test   $0x1,%al
80106f44:	74 ea                	je     80106f30 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106f46:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106f48:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106f4d:	c1 ee 0a             	shr    $0xa,%esi
80106f50:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106f56:	8d b4 30 00 00 00 80 	lea    -0x80000000(%eax,%esi,1),%esi
    if(!pte)
80106f5d:	85 f6                	test   %esi,%esi
80106f5f:	74 cf                	je     80106f30 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106f61:	8b 06                	mov    (%esi),%eax
80106f63:	a8 01                	test   $0x1,%al
80106f65:	75 19                	jne    80106f80 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106f67:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f6d:	39 da                	cmp    %ebx,%edx
80106f6f:	77 c9                	ja     80106f3a <deallocuvm.part.0+0x2a>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106f71:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f77:	5b                   	pop    %ebx
80106f78:	5e                   	pop    %esi
80106f79:	5f                   	pop    %edi
80106f7a:	5d                   	pop    %ebp
80106f7b:	c3                   	ret    
80106f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106f80:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f85:	74 25                	je     80106fac <deallocuvm.part.0+0x9c>
      kfree(v);
80106f87:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106f8a:	05 00 00 00 80       	add    $0x80000000,%eax
80106f8f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106f92:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106f98:	50                   	push   %eax
80106f99:	e8 32 b6 ff ff       	call   801025d0 <kfree>
      *pte = 0;
80106f9e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106fa4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106fa7:	83 c4 10             	add    $0x10,%esp
80106faa:	eb 8a                	jmp    80106f36 <deallocuvm.part.0+0x26>
        panic("kfree");
80106fac:	83 ec 0c             	sub    $0xc,%esp
80106faf:	68 66 7b 10 80       	push   $0x80107b66
80106fb4:	e8 c7 93 ff ff       	call   80100380 <panic>
80106fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106fc0 <mappages>:
{
80106fc0:	55                   	push   %ebp
80106fc1:	89 e5                	mov    %esp,%ebp
80106fc3:	57                   	push   %edi
80106fc4:	56                   	push   %esi
80106fc5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106fc6:	89 d3                	mov    %edx,%ebx
80106fc8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106fce:	83 ec 1c             	sub    $0x1c,%esp
80106fd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106fd4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106fd8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106fdd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106fe0:	8b 45 08             	mov    0x8(%ebp),%eax
80106fe3:	29 d8                	sub    %ebx,%eax
80106fe5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106fe8:	eb 3d                	jmp    80107027 <mappages+0x67>
80106fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106ff0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ff2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106ff7:	c1 ea 0a             	shr    $0xa,%edx
80106ffa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107000:	8d 94 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%edx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107007:	85 d2                	test   %edx,%edx
80107009:	74 75                	je     80107080 <mappages+0xc0>
    if(*pte & PTE_P)
8010700b:	f6 02 01             	testb  $0x1,(%edx)
8010700e:	0f 85 86 00 00 00    	jne    8010709a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80107014:	0b 75 0c             	or     0xc(%ebp),%esi
80107017:	83 ce 01             	or     $0x1,%esi
8010701a:	89 32                	mov    %esi,(%edx)
    if(a == last)
8010701c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
8010701f:	74 6f                	je     80107090 <mappages+0xd0>
    a += PGSIZE;
80107021:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107027:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010702a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010702d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107030:	89 d8                	mov    %ebx,%eax
80107032:	c1 e8 16             	shr    $0x16,%eax
80107035:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107038:	8b 07                	mov    (%edi),%eax
8010703a:	a8 01                	test   $0x1,%al
8010703c:	75 b2                	jne    80106ff0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010703e:	e8 4d b7 ff ff       	call   80102790 <kalloc>
80107043:	85 c0                	test   %eax,%eax
80107045:	74 39                	je     80107080 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107047:	83 ec 04             	sub    $0x4,%esp
8010704a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010704d:	68 00 10 00 00       	push   $0x1000
80107052:	6a 00                	push   $0x0
80107054:	50                   	push   %eax
80107055:	e8 76 d9 ff ff       	call   801049d0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010705a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010705d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107060:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107066:	83 c8 07             	or     $0x7,%eax
80107069:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010706b:	89 d8                	mov    %ebx,%eax
8010706d:	c1 e8 0a             	shr    $0xa,%eax
80107070:	25 fc 0f 00 00       	and    $0xffc,%eax
80107075:	01 c2                	add    %eax,%edx
80107077:	eb 92                	jmp    8010700b <mappages+0x4b>
80107079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107080:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107083:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107088:	5b                   	pop    %ebx
80107089:	5e                   	pop    %esi
8010708a:	5f                   	pop    %edi
8010708b:	5d                   	pop    %ebp
8010708c:	c3                   	ret    
8010708d:	8d 76 00             	lea    0x0(%esi),%esi
80107090:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107093:	31 c0                	xor    %eax,%eax
}
80107095:	5b                   	pop    %ebx
80107096:	5e                   	pop    %esi
80107097:	5f                   	pop    %edi
80107098:	5d                   	pop    %ebp
80107099:	c3                   	ret    
      panic("remap");
8010709a:	83 ec 0c             	sub    $0xc,%esp
8010709d:	68 08 83 10 80       	push   $0x80108308
801070a2:	e8 d9 92 ff ff       	call   80100380 <panic>
801070a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ae:	66 90                	xchg   %ax,%ax

801070b0 <seginit>:
{
801070b0:	55                   	push   %ebp
801070b1:	89 e5                	mov    %esp,%ebp
801070b3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
801070b6:	e8 b5 c9 ff ff       	call   80103a70 <cpuid>
  pd[0] = size-1;
801070bb:	ba 2f 00 00 00       	mov    $0x2f,%edx
801070c0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801070c6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801070ca:	c7 80 f8 28 11 80 ff 	movl   $0xffff,-0x7feed708(%eax)
801070d1:	ff 00 00 
801070d4:	c7 80 fc 28 11 80 00 	movl   $0xcf9a00,-0x7feed704(%eax)
801070db:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801070de:	c7 80 00 29 11 80 ff 	movl   $0xffff,-0x7feed700(%eax)
801070e5:	ff 00 00 
801070e8:	c7 80 04 29 11 80 00 	movl   $0xcf9200,-0x7feed6fc(%eax)
801070ef:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801070f2:	c7 80 08 29 11 80 ff 	movl   $0xffff,-0x7feed6f8(%eax)
801070f9:	ff 00 00 
801070fc:	c7 80 0c 29 11 80 00 	movl   $0xcffa00,-0x7feed6f4(%eax)
80107103:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107106:	c7 80 10 29 11 80 ff 	movl   $0xffff,-0x7feed6f0(%eax)
8010710d:	ff 00 00 
80107110:	c7 80 14 29 11 80 00 	movl   $0xcff200,-0x7feed6ec(%eax)
80107117:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010711a:	05 f0 28 11 80       	add    $0x801128f0,%eax
  pd[1] = (uint)p;
8010711f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107123:	c1 e8 10             	shr    $0x10,%eax
80107126:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010712a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010712d:	0f 01 10             	lgdtl  (%eax)
}
80107130:	c9                   	leave  
80107131:	c3                   	ret    
80107132:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107140 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107140:	a1 44 6b 11 80       	mov    0x80116b44,%eax
80107145:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010714a:	0f 22 d8             	mov    %eax,%cr3
}
8010714d:	c3                   	ret    
8010714e:	66 90                	xchg   %ax,%ax

80107150 <switchuvm>:
{
80107150:	55                   	push   %ebp
80107151:	89 e5                	mov    %esp,%ebp
80107153:	57                   	push   %edi
80107154:	56                   	push   %esi
80107155:	53                   	push   %ebx
80107156:	83 ec 1c             	sub    $0x1c,%esp
80107159:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010715c:	85 f6                	test   %esi,%esi
8010715e:	0f 84 cb 00 00 00    	je     8010722f <switchuvm+0xdf>
  if(p->kstack == 0)
80107164:	8b 46 08             	mov    0x8(%esi),%eax
80107167:	85 c0                	test   %eax,%eax
80107169:	0f 84 da 00 00 00    	je     80107249 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010716f:	8b 46 04             	mov    0x4(%esi),%eax
80107172:	85 c0                	test   %eax,%eax
80107174:	0f 84 c2 00 00 00    	je     8010723c <switchuvm+0xec>
  pushcli();
8010717a:	e8 41 d6 ff ff       	call   801047c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010717f:	e8 7c c8 ff ff       	call   80103a00 <mycpu>
80107184:	89 c3                	mov    %eax,%ebx
80107186:	e8 75 c8 ff ff       	call   80103a00 <mycpu>
8010718b:	89 c7                	mov    %eax,%edi
8010718d:	e8 6e c8 ff ff       	call   80103a00 <mycpu>
80107192:	83 c7 08             	add    $0x8,%edi
80107195:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107198:	e8 63 c8 ff ff       	call   80103a00 <mycpu>
8010719d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801071a0:	ba 67 00 00 00       	mov    $0x67,%edx
801071a5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801071ac:	83 c0 08             	add    $0x8,%eax
801071af:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801071b6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801071bb:	83 c1 08             	add    $0x8,%ecx
801071be:	c1 e8 18             	shr    $0x18,%eax
801071c1:	c1 e9 10             	shr    $0x10,%ecx
801071c4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801071ca:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801071d0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801071d5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801071dc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801071e1:	e8 1a c8 ff ff       	call   80103a00 <mycpu>
801071e6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801071ed:	e8 0e c8 ff ff       	call   80103a00 <mycpu>
801071f2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801071f6:	8b 5e 08             	mov    0x8(%esi),%ebx
801071f9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071ff:	e8 fc c7 ff ff       	call   80103a00 <mycpu>
80107204:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107207:	e8 f4 c7 ff ff       	call   80103a00 <mycpu>
8010720c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107210:	b8 28 00 00 00       	mov    $0x28,%eax
80107215:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107218:	8b 46 04             	mov    0x4(%esi),%eax
8010721b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107220:	0f 22 d8             	mov    %eax,%cr3
}
80107223:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107226:	5b                   	pop    %ebx
80107227:	5e                   	pop    %esi
80107228:	5f                   	pop    %edi
80107229:	5d                   	pop    %ebp
  popcli();
8010722a:	e9 e1 d5 ff ff       	jmp    80104810 <popcli>
    panic("switchuvm: no process");
8010722f:	83 ec 0c             	sub    $0xc,%esp
80107232:	68 0e 83 10 80       	push   $0x8010830e
80107237:	e8 44 91 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010723c:	83 ec 0c             	sub    $0xc,%esp
8010723f:	68 39 83 10 80       	push   $0x80108339
80107244:	e8 37 91 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107249:	83 ec 0c             	sub    $0xc,%esp
8010724c:	68 24 83 10 80       	push   $0x80108324
80107251:	e8 2a 91 ff ff       	call   80100380 <panic>
80107256:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010725d:	8d 76 00             	lea    0x0(%esi),%esi

80107260 <inituvm>:
{
80107260:	55                   	push   %ebp
80107261:	89 e5                	mov    %esp,%ebp
80107263:	57                   	push   %edi
80107264:	56                   	push   %esi
80107265:	53                   	push   %ebx
80107266:	83 ec 1c             	sub    $0x1c,%esp
80107269:	8b 45 0c             	mov    0xc(%ebp),%eax
8010726c:	8b 75 10             	mov    0x10(%ebp),%esi
8010726f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107272:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107275:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010727b:	77 4b                	ja     801072c8 <inituvm+0x68>
  mem = kalloc();
8010727d:	e8 0e b5 ff ff       	call   80102790 <kalloc>
  memset(mem, 0, PGSIZE);
80107282:	83 ec 04             	sub    $0x4,%esp
80107285:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010728a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010728c:	6a 00                	push   $0x0
8010728e:	50                   	push   %eax
8010728f:	e8 3c d7 ff ff       	call   801049d0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107294:	58                   	pop    %eax
80107295:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010729b:	5a                   	pop    %edx
8010729c:	6a 06                	push   $0x6
8010729e:	b9 00 10 00 00       	mov    $0x1000,%ecx
801072a3:	31 d2                	xor    %edx,%edx
801072a5:	50                   	push   %eax
801072a6:	89 f8                	mov    %edi,%eax
801072a8:	e8 13 fd ff ff       	call   80106fc0 <mappages>
  memmove(mem, init, sz);
801072ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072b0:	89 75 10             	mov    %esi,0x10(%ebp)
801072b3:	83 c4 10             	add    $0x10,%esp
801072b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801072b9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801072bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072bf:	5b                   	pop    %ebx
801072c0:	5e                   	pop    %esi
801072c1:	5f                   	pop    %edi
801072c2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801072c3:	e9 a8 d7 ff ff       	jmp    80104a70 <memmove>
    panic("inituvm: more than a page");
801072c8:	83 ec 0c             	sub    $0xc,%esp
801072cb:	68 4d 83 10 80       	push   $0x8010834d
801072d0:	e8 ab 90 ff ff       	call   80100380 <panic>
801072d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801072e0 <loaduvm>:
{
801072e0:	55                   	push   %ebp
801072e1:	89 e5                	mov    %esp,%ebp
801072e3:	57                   	push   %edi
801072e4:	56                   	push   %esi
801072e5:	53                   	push   %ebx
801072e6:	83 ec 1c             	sub    $0x1c,%esp
801072e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801072ec:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801072ef:	a9 ff 0f 00 00       	test   $0xfff,%eax
801072f4:	0f 85 bb 00 00 00    	jne    801073b5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
801072fa:	01 f0                	add    %esi,%eax
801072fc:	89 f3                	mov    %esi,%ebx
801072fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107301:	8b 45 14             	mov    0x14(%ebp),%eax
80107304:	01 f0                	add    %esi,%eax
80107306:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107309:	85 f6                	test   %esi,%esi
8010730b:	0f 84 87 00 00 00    	je     80107398 <loaduvm+0xb8>
80107311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107318:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010731b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010731e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107320:	89 c2                	mov    %eax,%edx
80107322:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107325:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107328:	f6 c2 01             	test   $0x1,%dl
8010732b:	75 13                	jne    80107340 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010732d:	83 ec 0c             	sub    $0xc,%esp
80107330:	68 67 83 10 80       	push   $0x80108367
80107335:	e8 46 90 ff ff       	call   80100380 <panic>
8010733a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107340:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107343:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107349:	25 fc 0f 00 00       	and    $0xffc,%eax
8010734e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107355:	85 c0                	test   %eax,%eax
80107357:	74 d4                	je     8010732d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107359:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010735b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010735e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107363:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107368:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010736e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107371:	29 d9                	sub    %ebx,%ecx
80107373:	05 00 00 00 80       	add    $0x80000000,%eax
80107378:	57                   	push   %edi
80107379:	51                   	push   %ecx
8010737a:	50                   	push   %eax
8010737b:	ff 75 10             	pushl  0x10(%ebp)
8010737e:	e8 1d a8 ff ff       	call   80101ba0 <readi>
80107383:	83 c4 10             	add    $0x10,%esp
80107386:	39 f8                	cmp    %edi,%eax
80107388:	75 1e                	jne    801073a8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010738a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107390:	89 f0                	mov    %esi,%eax
80107392:	29 d8                	sub    %ebx,%eax
80107394:	39 c6                	cmp    %eax,%esi
80107396:	77 80                	ja     80107318 <loaduvm+0x38>
}
80107398:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010739b:	31 c0                	xor    %eax,%eax
}
8010739d:	5b                   	pop    %ebx
8010739e:	5e                   	pop    %esi
8010739f:	5f                   	pop    %edi
801073a0:	5d                   	pop    %ebp
801073a1:	c3                   	ret    
801073a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801073a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801073ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073b0:	5b                   	pop    %ebx
801073b1:	5e                   	pop    %esi
801073b2:	5f                   	pop    %edi
801073b3:	5d                   	pop    %ebp
801073b4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
801073b5:	83 ec 0c             	sub    $0xc,%esp
801073b8:	68 08 84 10 80       	push   $0x80108408
801073bd:	e8 be 8f ff ff       	call   80100380 <panic>
801073c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801073d0 <allocuvm>:
{
801073d0:	55                   	push   %ebp
801073d1:	89 e5                	mov    %esp,%ebp
801073d3:	57                   	push   %edi
801073d4:	56                   	push   %esi
801073d5:	53                   	push   %ebx
801073d6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801073d9:	8b 45 10             	mov    0x10(%ebp),%eax
{
801073dc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801073df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801073e2:	85 c0                	test   %eax,%eax
801073e4:	0f 88 b6 00 00 00    	js     801074a0 <allocuvm+0xd0>
  if(newsz < oldsz)
801073ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801073ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801073f0:	0f 82 9a 00 00 00    	jb     80107490 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801073f6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801073fc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107402:	39 75 10             	cmp    %esi,0x10(%ebp)
80107405:	77 44                	ja     8010744b <allocuvm+0x7b>
80107407:	e9 87 00 00 00       	jmp    80107493 <allocuvm+0xc3>
8010740c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107410:	83 ec 04             	sub    $0x4,%esp
80107413:	68 00 10 00 00       	push   $0x1000
80107418:	6a 00                	push   $0x0
8010741a:	50                   	push   %eax
8010741b:	e8 b0 d5 ff ff       	call   801049d0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107420:	58                   	pop    %eax
80107421:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107427:	5a                   	pop    %edx
80107428:	6a 06                	push   $0x6
8010742a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010742f:	89 f2                	mov    %esi,%edx
80107431:	50                   	push   %eax
80107432:	89 f8                	mov    %edi,%eax
80107434:	e8 87 fb ff ff       	call   80106fc0 <mappages>
80107439:	83 c4 10             	add    $0x10,%esp
8010743c:	85 c0                	test   %eax,%eax
8010743e:	78 78                	js     801074b8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107440:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107446:	39 75 10             	cmp    %esi,0x10(%ebp)
80107449:	76 48                	jbe    80107493 <allocuvm+0xc3>
    mem = kalloc();
8010744b:	e8 40 b3 ff ff       	call   80102790 <kalloc>
80107450:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107452:	85 c0                	test   %eax,%eax
80107454:	75 ba                	jne    80107410 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107456:	83 ec 0c             	sub    $0xc,%esp
80107459:	68 85 83 10 80       	push   $0x80108385
8010745e:	e8 1d 92 ff ff       	call   80100680 <cprintf>
  if(newsz >= oldsz)
80107463:	8b 45 0c             	mov    0xc(%ebp),%eax
80107466:	83 c4 10             	add    $0x10,%esp
80107469:	39 45 10             	cmp    %eax,0x10(%ebp)
8010746c:	74 32                	je     801074a0 <allocuvm+0xd0>
8010746e:	8b 55 10             	mov    0x10(%ebp),%edx
80107471:	89 c1                	mov    %eax,%ecx
80107473:	89 f8                	mov    %edi,%eax
80107475:	e8 96 fa ff ff       	call   80106f10 <deallocuvm.part.0>
      return 0;
8010747a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107481:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107484:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107487:	5b                   	pop    %ebx
80107488:	5e                   	pop    %esi
80107489:	5f                   	pop    %edi
8010748a:	5d                   	pop    %ebp
8010748b:	c3                   	ret    
8010748c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107490:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107493:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107496:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107499:	5b                   	pop    %ebx
8010749a:	5e                   	pop    %esi
8010749b:	5f                   	pop    %edi
8010749c:	5d                   	pop    %ebp
8010749d:	c3                   	ret    
8010749e:	66 90                	xchg   %ax,%ax
    return 0;
801074a0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801074a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801074aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074ad:	5b                   	pop    %ebx
801074ae:	5e                   	pop    %esi
801074af:	5f                   	pop    %edi
801074b0:	5d                   	pop    %ebp
801074b1:	c3                   	ret    
801074b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801074b8:	83 ec 0c             	sub    $0xc,%esp
801074bb:	68 9d 83 10 80       	push   $0x8010839d
801074c0:	e8 bb 91 ff ff       	call   80100680 <cprintf>
  if(newsz >= oldsz)
801074c5:	8b 45 0c             	mov    0xc(%ebp),%eax
801074c8:	83 c4 10             	add    $0x10,%esp
801074cb:	39 45 10             	cmp    %eax,0x10(%ebp)
801074ce:	74 0c                	je     801074dc <allocuvm+0x10c>
801074d0:	8b 55 10             	mov    0x10(%ebp),%edx
801074d3:	89 c1                	mov    %eax,%ecx
801074d5:	89 f8                	mov    %edi,%eax
801074d7:	e8 34 fa ff ff       	call   80106f10 <deallocuvm.part.0>
      kfree(mem);
801074dc:	83 ec 0c             	sub    $0xc,%esp
801074df:	53                   	push   %ebx
801074e0:	e8 eb b0 ff ff       	call   801025d0 <kfree>
      return 0;
801074e5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801074ec:	83 c4 10             	add    $0x10,%esp
}
801074ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801074f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074f5:	5b                   	pop    %ebx
801074f6:	5e                   	pop    %esi
801074f7:	5f                   	pop    %edi
801074f8:	5d                   	pop    %ebp
801074f9:	c3                   	ret    
801074fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107500 <deallocuvm>:
{
80107500:	55                   	push   %ebp
80107501:	89 e5                	mov    %esp,%ebp
80107503:	8b 55 0c             	mov    0xc(%ebp),%edx
80107506:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107509:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010750c:	39 d1                	cmp    %edx,%ecx
8010750e:	73 10                	jae    80107520 <deallocuvm+0x20>
}
80107510:	5d                   	pop    %ebp
80107511:	e9 fa f9 ff ff       	jmp    80106f10 <deallocuvm.part.0>
80107516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010751d:	8d 76 00             	lea    0x0(%esi),%esi
80107520:	89 d0                	mov    %edx,%eax
80107522:	5d                   	pop    %ebp
80107523:	c3                   	ret    
80107524:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010752b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010752f:	90                   	nop

80107530 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107530:	55                   	push   %ebp
80107531:	89 e5                	mov    %esp,%ebp
80107533:	57                   	push   %edi
80107534:	56                   	push   %esi
80107535:	53                   	push   %ebx
80107536:	83 ec 0c             	sub    $0xc,%esp
80107539:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010753c:	85 f6                	test   %esi,%esi
8010753e:	74 59                	je     80107599 <freevm+0x69>
  if(newsz >= oldsz)
80107540:	31 c9                	xor    %ecx,%ecx
80107542:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107547:	89 f0                	mov    %esi,%eax
80107549:	89 f3                	mov    %esi,%ebx
8010754b:	e8 c0 f9 ff ff       	call   80106f10 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107550:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107556:	eb 0f                	jmp    80107567 <freevm+0x37>
80107558:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010755f:	90                   	nop
80107560:	83 c3 04             	add    $0x4,%ebx
80107563:	39 df                	cmp    %ebx,%edi
80107565:	74 23                	je     8010758a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107567:	8b 03                	mov    (%ebx),%eax
80107569:	a8 01                	test   $0x1,%al
8010756b:	74 f3                	je     80107560 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010756d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107572:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107575:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107578:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010757d:	50                   	push   %eax
8010757e:	e8 4d b0 ff ff       	call   801025d0 <kfree>
80107583:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107586:	39 df                	cmp    %ebx,%edi
80107588:	75 dd                	jne    80107567 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010758a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010758d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107590:	5b                   	pop    %ebx
80107591:	5e                   	pop    %esi
80107592:	5f                   	pop    %edi
80107593:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107594:	e9 37 b0 ff ff       	jmp    801025d0 <kfree>
    panic("freevm: no pgdir");
80107599:	83 ec 0c             	sub    $0xc,%esp
8010759c:	68 b9 83 10 80       	push   $0x801083b9
801075a1:	e8 da 8d ff ff       	call   80100380 <panic>
801075a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075ad:	8d 76 00             	lea    0x0(%esi),%esi

801075b0 <setupkvm>:
{
801075b0:	55                   	push   %ebp
801075b1:	89 e5                	mov    %esp,%ebp
801075b3:	56                   	push   %esi
801075b4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801075b5:	e8 d6 b1 ff ff       	call   80102790 <kalloc>
801075ba:	89 c6                	mov    %eax,%esi
801075bc:	85 c0                	test   %eax,%eax
801075be:	74 42                	je     80107602 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801075c0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801075c3:	bb 00 b5 10 80       	mov    $0x8010b500,%ebx
  memset(pgdir, 0, PGSIZE);
801075c8:	68 00 10 00 00       	push   $0x1000
801075cd:	6a 00                	push   $0x0
801075cf:	50                   	push   %eax
801075d0:	e8 fb d3 ff ff       	call   801049d0 <memset>
801075d5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801075d8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801075db:	83 ec 08             	sub    $0x8,%esp
801075de:	8b 4b 08             	mov    0x8(%ebx),%ecx
801075e1:	ff 73 0c             	pushl  0xc(%ebx)
801075e4:	8b 13                	mov    (%ebx),%edx
801075e6:	50                   	push   %eax
801075e7:	29 c1                	sub    %eax,%ecx
801075e9:	89 f0                	mov    %esi,%eax
801075eb:	e8 d0 f9 ff ff       	call   80106fc0 <mappages>
801075f0:	83 c4 10             	add    $0x10,%esp
801075f3:	85 c0                	test   %eax,%eax
801075f5:	78 19                	js     80107610 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801075f7:	83 c3 10             	add    $0x10,%ebx
801075fa:	81 fb 40 b5 10 80    	cmp    $0x8010b540,%ebx
80107600:	75 d6                	jne    801075d8 <setupkvm+0x28>
}
80107602:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107605:	89 f0                	mov    %esi,%eax
80107607:	5b                   	pop    %ebx
80107608:	5e                   	pop    %esi
80107609:	5d                   	pop    %ebp
8010760a:	c3                   	ret    
8010760b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010760f:	90                   	nop
      freevm(pgdir);
80107610:	83 ec 0c             	sub    $0xc,%esp
80107613:	56                   	push   %esi
      return 0;
80107614:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107616:	e8 15 ff ff ff       	call   80107530 <freevm>
      return 0;
8010761b:	83 c4 10             	add    $0x10,%esp
}
8010761e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107621:	89 f0                	mov    %esi,%eax
80107623:	5b                   	pop    %ebx
80107624:	5e                   	pop    %esi
80107625:	5d                   	pop    %ebp
80107626:	c3                   	ret    
80107627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010762e:	66 90                	xchg   %ax,%ax

80107630 <kvmalloc>:
{
80107630:	55                   	push   %ebp
80107631:	89 e5                	mov    %esp,%ebp
80107633:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107636:	e8 75 ff ff ff       	call   801075b0 <setupkvm>
8010763b:	a3 44 6b 11 80       	mov    %eax,0x80116b44
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107640:	05 00 00 00 80       	add    $0x80000000,%eax
80107645:	0f 22 d8             	mov    %eax,%cr3
}
80107648:	c9                   	leave  
80107649:	c3                   	ret    
8010764a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107650 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107650:	55                   	push   %ebp
80107651:	89 e5                	mov    %esp,%ebp
80107653:	83 ec 08             	sub    $0x8,%esp
80107656:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107659:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010765c:	89 c1                	mov    %eax,%ecx
8010765e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107661:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107664:	f6 c2 01             	test   $0x1,%dl
80107667:	75 17                	jne    80107680 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107669:	83 ec 0c             	sub    $0xc,%esp
8010766c:	68 ca 83 10 80       	push   $0x801083ca
80107671:	e8 0a 8d ff ff       	call   80100380 <panic>
80107676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010767d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107680:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107683:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107689:	25 fc 0f 00 00       	and    $0xffc,%eax
8010768e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107695:	85 c0                	test   %eax,%eax
80107697:	74 d0                	je     80107669 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107699:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010769c:	c9                   	leave  
8010769d:	c3                   	ret    
8010769e:	66 90                	xchg   %ax,%ax

801076a0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801076a0:	55                   	push   %ebp
801076a1:	89 e5                	mov    %esp,%ebp
801076a3:	57                   	push   %edi
801076a4:	56                   	push   %esi
801076a5:	53                   	push   %ebx
801076a6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801076a9:	e8 02 ff ff ff       	call   801075b0 <setupkvm>
801076ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
801076b1:	85 c0                	test   %eax,%eax
801076b3:	0f 84 bd 00 00 00    	je     80107776 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801076b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801076bc:	85 c9                	test   %ecx,%ecx
801076be:	0f 84 b2 00 00 00    	je     80107776 <copyuvm+0xd6>
801076c4:	31 f6                	xor    %esi,%esi
801076c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076cd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801076d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801076d3:	89 f0                	mov    %esi,%eax
801076d5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801076d8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801076db:	a8 01                	test   $0x1,%al
801076dd:	75 11                	jne    801076f0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801076df:	83 ec 0c             	sub    $0xc,%esp
801076e2:	68 d4 83 10 80       	push   $0x801083d4
801076e7:	e8 94 8c ff ff       	call   80100380 <panic>
801076ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801076f0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801076f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801076f7:	c1 ea 0a             	shr    $0xa,%edx
801076fa:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107700:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107707:	85 c0                	test   %eax,%eax
80107709:	74 d4                	je     801076df <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010770b:	8b 00                	mov    (%eax),%eax
8010770d:	a8 01                	test   $0x1,%al
8010770f:	0f 84 9f 00 00 00    	je     801077b4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107715:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107717:	25 ff 0f 00 00       	and    $0xfff,%eax
8010771c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010771f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107725:	e8 66 b0 ff ff       	call   80102790 <kalloc>
8010772a:	89 c3                	mov    %eax,%ebx
8010772c:	85 c0                	test   %eax,%eax
8010772e:	74 64                	je     80107794 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107730:	83 ec 04             	sub    $0x4,%esp
80107733:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107739:	68 00 10 00 00       	push   $0x1000
8010773e:	57                   	push   %edi
8010773f:	50                   	push   %eax
80107740:	e8 2b d3 ff ff       	call   80104a70 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107745:	58                   	pop    %eax
80107746:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010774c:	5a                   	pop    %edx
8010774d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107750:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107755:	89 f2                	mov    %esi,%edx
80107757:	50                   	push   %eax
80107758:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010775b:	e8 60 f8 ff ff       	call   80106fc0 <mappages>
80107760:	83 c4 10             	add    $0x10,%esp
80107763:	85 c0                	test   %eax,%eax
80107765:	78 21                	js     80107788 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107767:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010776d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107770:	0f 87 5a ff ff ff    	ja     801076d0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107776:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107779:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010777c:	5b                   	pop    %ebx
8010777d:	5e                   	pop    %esi
8010777e:	5f                   	pop    %edi
8010777f:	5d                   	pop    %ebp
80107780:	c3                   	ret    
80107781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107788:	83 ec 0c             	sub    $0xc,%esp
8010778b:	53                   	push   %ebx
8010778c:	e8 3f ae ff ff       	call   801025d0 <kfree>
      goto bad;
80107791:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107794:	83 ec 0c             	sub    $0xc,%esp
80107797:	ff 75 e0             	pushl  -0x20(%ebp)
8010779a:	e8 91 fd ff ff       	call   80107530 <freevm>
  return 0;
8010779f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801077a6:	83 c4 10             	add    $0x10,%esp
}
801077a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801077ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077af:	5b                   	pop    %ebx
801077b0:	5e                   	pop    %esi
801077b1:	5f                   	pop    %edi
801077b2:	5d                   	pop    %ebp
801077b3:	c3                   	ret    
      panic("copyuvm: page not present");
801077b4:	83 ec 0c             	sub    $0xc,%esp
801077b7:	68 ee 83 10 80       	push   $0x801083ee
801077bc:	e8 bf 8b ff ff       	call   80100380 <panic>
801077c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077cf:	90                   	nop

801077d0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801077d0:	55                   	push   %ebp
801077d1:	89 e5                	mov    %esp,%ebp
801077d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801077d6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801077d9:	89 c1                	mov    %eax,%ecx
801077db:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801077de:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801077e1:	f6 c2 01             	test   $0x1,%dl
801077e4:	0f 84 00 01 00 00    	je     801078ea <uva2ka.cold>
  return &pgtab[PTX(va)];
801077ea:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801077ed:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801077f3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801077f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801077f9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107800:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107802:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107807:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010780a:	05 00 00 00 80       	add    $0x80000000,%eax
8010780f:	83 fa 05             	cmp    $0x5,%edx
80107812:	ba 00 00 00 00       	mov    $0x0,%edx
80107817:	0f 45 c2             	cmovne %edx,%eax
}
8010781a:	c3                   	ret    
8010781b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010781f:	90                   	nop

80107820 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107820:	55                   	push   %ebp
80107821:	89 e5                	mov    %esp,%ebp
80107823:	57                   	push   %edi
80107824:	56                   	push   %esi
80107825:	53                   	push   %ebx
80107826:	83 ec 0c             	sub    $0xc,%esp
80107829:	8b 75 14             	mov    0x14(%ebp),%esi
8010782c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010782f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107832:	85 f6                	test   %esi,%esi
80107834:	75 51                	jne    80107887 <copyout+0x67>
80107836:	e9 a5 00 00 00       	jmp    801078e0 <copyout+0xc0>
8010783b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010783f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107840:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107846:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010784c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107852:	74 75                	je     801078c9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107854:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107856:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107859:	29 c3                	sub    %eax,%ebx
8010785b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107861:	39 f3                	cmp    %esi,%ebx
80107863:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107866:	29 f8                	sub    %edi,%eax
80107868:	83 ec 04             	sub    $0x4,%esp
8010786b:	01 c8                	add    %ecx,%eax
8010786d:	53                   	push   %ebx
8010786e:	52                   	push   %edx
8010786f:	50                   	push   %eax
80107870:	e8 fb d1 ff ff       	call   80104a70 <memmove>
    len -= n;
    buf += n;
80107875:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107878:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010787e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107881:	01 da                	add    %ebx,%edx
  while(len > 0){
80107883:	29 de                	sub    %ebx,%esi
80107885:	74 59                	je     801078e0 <copyout+0xc0>
  if(*pde & PTE_P){
80107887:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010788a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010788c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010788e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107891:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107897:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010789a:	f6 c1 01             	test   $0x1,%cl
8010789d:	0f 84 4e 00 00 00    	je     801078f1 <copyout.cold>
  return &pgtab[PTX(va)];
801078a3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801078a5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801078ab:	c1 eb 0c             	shr    $0xc,%ebx
801078ae:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801078b4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801078bb:	89 d9                	mov    %ebx,%ecx
801078bd:	83 e1 05             	and    $0x5,%ecx
801078c0:	83 f9 05             	cmp    $0x5,%ecx
801078c3:	0f 84 77 ff ff ff    	je     80107840 <copyout+0x20>
  }
  return 0;
}
801078c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801078cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801078d1:	5b                   	pop    %ebx
801078d2:	5e                   	pop    %esi
801078d3:	5f                   	pop    %edi
801078d4:	5d                   	pop    %ebp
801078d5:	c3                   	ret    
801078d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078dd:	8d 76 00             	lea    0x0(%esi),%esi
801078e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801078e3:	31 c0                	xor    %eax,%eax
}
801078e5:	5b                   	pop    %ebx
801078e6:	5e                   	pop    %esi
801078e7:	5f                   	pop    %edi
801078e8:	5d                   	pop    %ebp
801078e9:	c3                   	ret    

801078ea <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801078ea:	a1 00 00 00 00       	mov    0x0,%eax
801078ef:	0f 0b                	ud2    

801078f1 <copyout.cold>:
801078f1:	a1 00 00 00 00       	mov    0x0,%eax
801078f6:	0f 0b                	ud2    
