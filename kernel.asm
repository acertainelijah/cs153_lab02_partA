
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 30 2f 10 80       	mov    $0x80102f30,%eax
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
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 71 10 80       	push   $0x801071e0
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 15 42 00 00       	call   80104270 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 71 10 80       	push   $0x801071e7
80100097:	50                   	push   %eax
80100098:	e8 c3 40 00 00       	call   80104160 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

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
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 87 42 00 00       	call   80104370 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
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
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 29 43 00 00       	call   80104490 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 2e 40 00 00       	call   801041a0 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 3d 20 00 00       	call   801021c0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 ee 71 10 80       	push   $0x801071ee
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 8d 40 00 00       	call   80104240 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 f7 1f 00 00       	jmp    801021c0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 ff 71 10 80       	push   $0x801071ff
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 4c 40 00 00       	call   80104240 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 fc 3f 00 00       	call   80104200 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 60 41 00 00       	call   80104370 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 2f 42 00 00       	jmp    80104490 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 06 72 10 80       	push   $0x80107206
80100269:	e8 02 01 00 00       	call   80100370 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 9b 15 00 00       	call   80101820 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 df 40 00 00       	call   80104370 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002a6:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 20 a5 10 80       	push   $0x8010a520
801002b8:	68 a0 ff 10 80       	push   $0x8010ffa0
801002bd:	e8 3e 3b 00 00       	call   80103e00 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 79 35 00 00       	call   80103850 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 a5 10 80       	push   $0x8010a520
801002e6:	e8 a5 41 00 00       	call   80104490 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 4d 14 00 00       	call   80101740 <ilock>
        return -1;
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fe:	5b                   	pop    %ebx
801002ff:	5e                   	pop    %esi
80100300:	5f                   	pop    %edi
80100301:	5d                   	pop    %ebp
80100302:	c3                   	ret    
80100303:	90                   	nop
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 20 ff 10 80 	movsbl -0x7fef00e0(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 20 a5 10 80       	push   $0x8010a520
80100346:	e8 45 41 00 00       	call   80104490 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 ed 13 00 00       	call   80101740 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a0                	jmp    801002fb <consoleread+0x8b>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100379:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100380:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 32 24 00 00       	call   801027c0 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 0d 72 10 80       	push   $0x8010720d
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 7f 7b 10 80 	movl   $0x80107b7f,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 d3 3e 00 00       	call   80104290 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 21 72 10 80       	push   $0x80107221
801003cd:	e8 8e 02 00 00       	call   80100660 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003e0:	00 00 00 
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 61 57 00 00       	call   80105b80 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 a8 56 00 00       	call   80105b80 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 9c 56 00 00       	call   80105b80 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 90 56 00 00       	call   80105b80 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 77 40 00 00       	call   80104590 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 b2 3f 00 00       	call   801044e0 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 25 72 10 80       	push   $0x80107225
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 50 72 10 80 	movzbl -0x7fef8db0(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 0c 12 00 00       	call   80101820 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 50 3d 00 00       	call   80104370 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 44 3e 00 00       	call   80104490 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 eb 10 00 00       	call   80101740 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 20 a5 10 80       	push   $0x8010a520
8010070d:	e8 7e 3d 00 00       	call   80104490 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 38 72 10 80       	mov    $0x80107238,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 20 a5 10 80       	push   $0x8010a520
801007c8:	e8 a3 3b 00 00       	call   80104370 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 3f 72 10 80       	push   $0x8010723f
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 20 a5 10 80       	push   $0x8010a520
80100803:	e8 68 3b 00 00       	call   80104370 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100836:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 20 a5 10 80       	push   $0x8010a520
80100868:	e8 23 3c 00 00       	call   80104490 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008f1:	68 a0 ff 10 80       	push   $0x8010ffa0
801008f6:	e8 b5 36 00 00       	call   80103fb0 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010090d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100934:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 24 37 00 00       	jmp    801040a0 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 48 72 10 80       	push   $0x80107248
801009ab:	68 20 a5 10 80       	push   $0x8010a520
801009b0:	e8 bb 38 00 00       	call   80104270 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009b5:	58                   	pop    %eax
801009b6:	5a                   	pop    %edx
801009b7:	6a 00                	push   $0x0
801009b9:	6a 01                	push   $0x1
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bb:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009d6:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009d9:	e8 92 19 00 00       	call   80102370 <ioapicenable>
}
801009de:	83 c4 10             	add    $0x10,%esp
801009e1:	c9                   	leave  
801009e2:	c3                   	ret    
801009e3:	66 90                	xchg   %ax,%ax
801009e5:	66 90                	xchg   %ax,%ax
801009e7:	66 90                	xchg   %ax,%ax
801009e9:	66 90                	xchg   %ax,%ax
801009eb:	66 90                	xchg   %ax,%ax
801009ed:	66 90                	xchg   %ax,%ax
801009ef:	90                   	nop

801009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009fc:	e8 4f 2e 00 00       	call   80103850 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a07:	e8 14 22 00 00       	call   80102c20 <begin_op>

  if((ip = namei(path)) == 0){
80100a0c:	83 ec 0c             	sub    $0xc,%esp
80100a0f:	ff 75 08             	pushl  0x8(%ebp)
80100a12:	e8 79 15 00 00       	call   80101f90 <namei>
80100a17:	83 c4 10             	add    $0x10,%esp
80100a1a:	85 c0                	test   %eax,%eax
80100a1c:	0f 84 c5 01 00 00    	je     80100be7 <exec+0x1f7>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a22:	83 ec 0c             	sub    $0xc,%esp
80100a25:	89 c3                	mov    %eax,%ebx
80100a27:	50                   	push   %eax
80100a28:	e8 13 0d 00 00       	call   80101740 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a33:	6a 34                	push   $0x34
80100a35:	6a 00                	push   $0x0
80100a37:	50                   	push   %eax
80100a38:	53                   	push   %ebx
80100a39:	e8 e2 0f 00 00       	call   80101a20 <readi>
80100a3e:	83 c4 20             	add    $0x20,%esp
80100a41:	83 f8 34             	cmp    $0x34,%eax
80100a44:	74 32                	je     80100a78 <exec+0x88>
  freevm(oldpgdir);
  cprintf("RR");
  return 0;

 bad:
  cprintf("BBAD");
80100a46:	83 ec 0c             	sub    $0xc,%esp
80100a49:	68 70 72 10 80       	push   $0x80107270
80100a4e:	e8 0d fc ff ff       	call   80100660 <cprintf>
80100a53:	83 c4 10             	add    $0x10,%esp
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a56:	83 ec 0c             	sub    $0xc,%esp
80100a59:	53                   	push   %ebx
80100a5a:	e8 71 0f 00 00       	call   801019d0 <iunlockput>
    end_op();
80100a5f:	e8 2c 22 00 00       	call   80102c90 <end_op>
80100a64:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a6f:	5b                   	pop    %ebx
80100a70:	5e                   	pop    %esi
80100a71:	5f                   	pop    %edi
80100a72:	5d                   	pop    %ebp
80100a73:	c3                   	ret    
80100a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a78:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a7f:	45 4c 46 
80100a82:	75 c2                	jne    80100a46 <exec+0x56>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a84:	e8 87 62 00 00       	call   80106d10 <setupkvm>
80100a89:	85 c0                	test   %eax,%eax
80100a8b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a91:	74 b3                	je     80100a46 <exec+0x56>
    goto bad;

  // Load program into memory.
  sz = 0;

  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a93:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a9a:	00 
80100a9b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100aa1:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100aa8:	00 00 00 
80100aab:	0f 84 d7 00 00 00    	je     80100b88 <exec+0x198>
80100ab1:	31 ff                	xor    %edi,%edi
80100ab3:	eb 18                	jmp    80100acd <exec+0xdd>
80100ab5:	8d 76 00             	lea    0x0(%esi),%esi
80100ab8:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100abf:	83 c7 01             	add    $0x1,%edi
80100ac2:	83 c6 20             	add    $0x20,%esi
80100ac5:	39 f8                	cmp    %edi,%eax
80100ac7:	0f 8e bb 00 00 00    	jle    80100b88 <exec+0x198>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100acd:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ad3:	6a 20                	push   $0x20
80100ad5:	56                   	push   %esi
80100ad6:	50                   	push   %eax
80100ad7:	53                   	push   %ebx
80100ad8:	e8 43 0f 00 00       	call   80101a20 <readi>
80100add:	83 c4 10             	add    $0x10,%esp
80100ae0:	83 f8 20             	cmp    $0x20,%eax
80100ae3:	75 7b                	jne    80100b60 <exec+0x170>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ae5:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aec:	75 ca                	jne    80100ab8 <exec+0xc8>
      continue;
    if(ph.memsz < ph.filesz)
80100aee:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100af4:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100afa:	72 64                	jb     80100b60 <exec+0x170>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100afc:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b02:	72 5c                	jb     80100b60 <exec+0x170>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b04:	83 ec 04             	sub    $0x4,%esp
80100b07:	50                   	push   %eax
80100b08:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100b0e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b14:	e8 47 60 00 00       	call   80106b60 <allocuvm>
80100b19:	83 c4 10             	add    $0x10,%esp
80100b1c:	85 c0                	test   %eax,%eax
80100b1e:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b24:	74 3a                	je     80100b60 <exec+0x170>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b26:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b2c:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b31:	75 2d                	jne    80100b60 <exec+0x170>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b33:	83 ec 0c             	sub    $0xc,%esp
80100b36:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b3c:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b42:	53                   	push   %ebx
80100b43:	50                   	push   %eax
80100b44:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b4a:	e8 51 5f 00 00       	call   80106aa0 <loaduvm>
80100b4f:	83 c4 20             	add    $0x20,%esp
80100b52:	85 c0                	test   %eax,%eax
80100b54:	0f 89 5e ff ff ff    	jns    80100ab8 <exec+0xc8>
80100b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  cprintf("RR");
  return 0;

 bad:
  cprintf("BBAD");
80100b60:	83 ec 0c             	sub    $0xc,%esp
80100b63:	68 70 72 10 80       	push   $0x80107270
80100b68:	e8 f3 fa ff ff       	call   80100660 <cprintf>
  if(pgdir)
    freevm(pgdir);
80100b6d:	58                   	pop    %eax
80100b6e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b74:	e8 17 61 00 00       	call   80106c90 <freevm>
80100b79:	83 c4 10             	add    $0x10,%esp
80100b7c:	e9 d5 fe ff ff       	jmp    80100a56 <exec+0x66>
80100b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b88:	83 ec 0c             	sub    $0xc,%esp
80100b8b:	53                   	push   %ebx
80100b8c:	e8 3f 0e 00 00       	call   801019d0 <iunlockput>
  end_op();
80100b91:	e8 fa 20 00 00       	call   80102c90 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  cprintf("AA");
80100b96:	c7 04 24 6d 72 10 80 	movl   $0x8010726d,(%esp)
80100b9d:	e8 be fa ff ff       	call   80100660 <cprintf>
  //sz = PGROUNDUP(sz);
  if((sp = allocuvm(pgdir, (KERNBASE-4)-PGSIZE, (KERNBASE-4))) == 0)//cs153 
80100ba2:	83 c4 0c             	add    $0xc,%esp
80100ba5:	68 fc ff ff 7f       	push   $0x7ffffffc
80100baa:	68 fc ef ff 7f       	push   $0x7fffeffc
80100baf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bb5:	e8 a6 5f 00 00       	call   80106b60 <allocuvm>
80100bba:	83 c4 10             	add    $0x10,%esp
80100bbd:	85 c0                	test   %eax,%eax
80100bbf:	75 45                	jne    80100c06 <exec+0x216>
  freevm(oldpgdir);
  cprintf("RR");
  return 0;

 bad:
  cprintf("BBAD");
80100bc1:	83 ec 0c             	sub    $0xc,%esp
80100bc4:	68 70 72 10 80       	push   $0x80107270
80100bc9:	e8 92 fa ff ff       	call   80100660 <cprintf>
  if(pgdir)
    freevm(pgdir);
80100bce:	58                   	pop    %eax
80100bcf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bd5:	e8 b6 60 00 00       	call   80106c90 <freevm>
80100bda:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100bdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100be2:	e9 85 fe ff ff       	jmp    80100a6c <exec+0x7c>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100be7:	e8 a4 20 00 00       	call   80102c90 <end_op>
    cprintf("exec: fail\n");
80100bec:	83 ec 0c             	sub    $0xc,%esp
80100bef:	68 61 72 10 80       	push   $0x80107261
80100bf4:	e8 67 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100bf9:	83 c4 10             	add    $0x10,%esp
80100bfc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c01:	e9 66 fe ff ff       	jmp    80100a6c <exec+0x7c>
  // Make the first inaccessible.  Use the second as the user stack.
  cprintf("AA");
  //sz = PGROUNDUP(sz);
  if((sp = allocuvm(pgdir, (KERNBASE-4)-PGSIZE, (KERNBASE-4))) == 0)//cs153 
    goto bad;
  cprintf("BB"); 
80100c06:	83 ec 0c             	sub    $0xc,%esp
  sp = KERNBASE-4;//cs153 change stack pointer to top of address space
  //curproc->stack_sz = KERNBASE-4;//cs153 delete? maybe use for bonus
  cprintf("CC");
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c09:	31 db                	xor    %ebx,%ebx
  cprintf("AA");
  //sz = PGROUNDUP(sz);
  if((sp = allocuvm(pgdir, (KERNBASE-4)-PGSIZE, (KERNBASE-4))) == 0)//cs153 
    goto bad;
  cprintf("BB"); 
  sp = KERNBASE-4;//cs153 change stack pointer to top of address space
80100c0b:	be fc ff ff 7f       	mov    $0x7ffffffc,%esi
  // Make the first inaccessible.  Use the second as the user stack.
  cprintf("AA");
  //sz = PGROUNDUP(sz);
  if((sp = allocuvm(pgdir, (KERNBASE-4)-PGSIZE, (KERNBASE-4))) == 0)//cs153 
    goto bad;
  cprintf("BB"); 
80100c10:	68 75 72 10 80       	push   $0x80107275
80100c15:	8d bd 58 ff ff ff    	lea    -0xa8(%ebp),%edi
80100c1b:	e8 40 fa ff ff       	call   80100660 <cprintf>
  sp = KERNBASE-4;//cs153 change stack pointer to top of address space
  //curproc->stack_sz = KERNBASE-4;//cs153 delete? maybe use for bonus
  cprintf("CC");
80100c20:	c7 04 24 78 72 10 80 	movl   $0x80107278,(%esp)
80100c27:	e8 34 fa ff ff       	call   80100660 <cprintf>
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c2f:	83 c4 10             	add    $0x10,%esp
80100c32:	8b 00                	mov    (%eax),%eax
80100c34:	85 c0                	test   %eax,%eax
80100c36:	0f 84 c8 00 00 00    	je     80100d04 <exec+0x314>
    cprintf("FF");
80100c3c:	83 ec 0c             	sub    $0xc,%esp
80100c3f:	be fc ff ff 7f       	mov    $0x7ffffffc,%esi
80100c44:	31 db                	xor    %ebx,%ebx
80100c46:	68 7b 72 10 80       	push   $0x8010727b
80100c4b:	e8 10 fa ff ff       	call   80100660 <cprintf>
80100c50:	83 c4 10             	add    $0x10,%esp
80100c53:	eb 1c                	jmp    80100c71 <exec+0x281>
80100c55:	8d 76 00             	lea    0x0(%esi),%esi
80100c58:	83 ec 0c             	sub    $0xc,%esp
80100c5b:	68 7b 72 10 80       	push   $0x8010727b
80100c60:	e8 fb f9 ff ff       	call   80100660 <cprintf>
    if(argc >= MAXARG)
80100c65:	83 c4 10             	add    $0x10,%esp
80100c68:	83 fb 20             	cmp    $0x20,%ebx
80100c6b:	0f 84 50 ff ff ff    	je     80100bc1 <exec+0x1d1>
      goto bad;
    cprintf("HH");
80100c71:	83 ec 0c             	sub    $0xc,%esp
80100c74:	68 7e 72 10 80       	push   $0x8010727e
80100c79:	e8 e2 f9 ff ff       	call   80100660 <cprintf>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c81:	59                   	pop    %ecx
80100c82:	ff 34 98             	pushl  (%eax,%ebx,4)
80100c85:	e8 96 3a 00 00       	call   80104720 <strlen>
80100c8a:	f7 d0                	not    %eax
    cprintf("II");
80100c8c:	c7 04 24 81 72 10 80 	movl   $0x80107281,(%esp)
  for(argc = 0; argv[argc]; argc++) {
    cprintf("FF");
    if(argc >= MAXARG)
      goto bad;
    cprintf("HH");
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c93:	01 c6                	add    %eax,%esi
    cprintf("II");
80100c95:	e8 c6 f9 ff ff       	call   80100660 <cprintf>
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(argc = 0; argv[argc]; argc++) {
    cprintf("FF");
    if(argc >= MAXARG)
      goto bad;
    cprintf("HH");
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9d:	83 e6 fc             	and    $0xfffffffc,%esi
    cprintf("II");
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ca0:	5f                   	pop    %edi
80100ca1:	ff 34 98             	pushl  (%eax,%ebx,4)
80100ca4:	e8 77 3a 00 00       	call   80104720 <strlen>
80100ca9:	83 c0 01             	add    $0x1,%eax
80100cac:	50                   	push   %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cb0:	ff 34 98             	pushl  (%eax,%ebx,4)
80100cb3:	56                   	push   %esi
80100cb4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100cba:	e8 01 64 00 00       	call   801070c0 <copyout>
80100cbf:	83 c4 20             	add    $0x20,%esp
80100cc2:	85 c0                	test   %eax,%eax
80100cc4:	0f 88 f7 fe ff ff    	js     80100bc1 <exec+0x1d1>
      goto bad;
    cprintf("KK");
80100cca:	83 ec 0c             	sub    $0xc,%esp
    ustack[3+argc] = sp;
80100ccd:	8d bd 58 ff ff ff    	lea    -0xa8(%ebp),%edi
    cprintf("HH");
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    cprintf("II");
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    cprintf("KK");
80100cd3:	68 84 72 10 80       	push   $0x80107284
80100cd8:	e8 83 f9 ff ff       	call   80100660 <cprintf>
    ustack[3+argc] = sp;
80100cdd:	89 b4 9d 64 ff ff ff 	mov    %esi,-0x9c(%ebp,%ebx,4)
	cprintf("LL");
80100ce4:	c7 04 24 87 72 10 80 	movl   $0x80107287,(%esp)
  cprintf("BB"); 
  sp = KERNBASE-4;//cs153 change stack pointer to top of address space
  //curproc->stack_sz = KERNBASE-4;//cs153 delete? maybe use for bonus
  cprintf("CC");
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ceb:	83 c3 01             	add    $0x1,%ebx
    cprintf("II");
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    cprintf("KK");
    ustack[3+argc] = sp;
	cprintf("LL");
80100cee:	e8 6d f9 ff ff       	call   80100660 <cprintf>
  cprintf("BB"); 
  sp = KERNBASE-4;//cs153 change stack pointer to top of address space
  //curproc->stack_sz = KERNBASE-4;//cs153 delete? maybe use for bonus
  cprintf("CC");
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cf6:	83 c4 10             	add    $0x10,%esp
80100cf9:	8b 14 98             	mov    (%eax,%ebx,4),%edx
80100cfc:	85 d2                	test   %edx,%edx
80100cfe:	0f 85 54 ff ff ff    	jne    80100c58 <exec+0x268>
      goto bad;
    cprintf("KK");
    ustack[3+argc] = sp;
	cprintf("LL");
  }
  cprintf("MM");
80100d04:	83 ec 0c             	sub    $0xc,%esp
80100d07:	68 8a 72 10 80       	push   $0x8010728a
80100d0c:	e8 4f f9 ff ff       	call   80100660 <cprintf>
  ustack[3+argc] = 0;
  cprintf("NN");
80100d11:	c7 04 24 8d 72 10 80 	movl   $0x8010728d,(%esp)
    cprintf("KK");
    ustack[3+argc] = sp;
	cprintf("LL");
  }
  cprintf("MM");
  ustack[3+argc] = 0;
80100d18:	c7 84 9d 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%ebx,4)
80100d1f:	00 00 00 00 
  cprintf("NN");
80100d23:	e8 38 f9 ff ff       	call   80100660 <cprintf>

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
80100d28:	89 9d 5c ff ff ff    	mov    %ebx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2e:	8d 1c 9d 04 00 00 00 	lea    0x4(,%ebx,4),%ebx
80100d35:	89 f0                	mov    %esi,%eax
  cprintf("OO");
80100d37:	c7 04 24 90 72 10 80 	movl   $0x80107290,(%esp)
  }
  cprintf("MM");
  ustack[3+argc] = 0;
  cprintf("NN");

  ustack[0] = 0xffffffff;  // fake return PC
80100d3e:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d45:	ff ff ff 
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d48:	29 d8                	sub    %ebx,%eax
80100d4a:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  cprintf("OO");
80100d50:	e8 0b f9 ff ff       	call   80100660 <cprintf>
  sp -= (3+argc+1) * 4;
80100d55:	8d 43 0c             	lea    0xc(%ebx),%eax
80100d58:	29 c6                	sub    %eax,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d5a:	50                   	push   %eax
80100d5b:	57                   	push   %edi
80100d5c:	56                   	push   %esi
80100d5d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100d63:	e8 58 63 00 00       	call   801070c0 <copyout>
80100d68:	83 c4 20             	add    $0x20,%esp
80100d6b:	85 c0                	test   %eax,%eax
80100d6d:	0f 88 4e fe ff ff    	js     80100bc1 <exec+0x1d1>
    goto bad;
  cprintf("PP");
80100d73:	83 ec 0c             	sub    $0xc,%esp
80100d76:	68 93 72 10 80       	push   $0x80107293
80100d7b:	e8 e0 f8 ff ff       	call   80100660 <cprintf>
  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100d80:	8b 45 08             	mov    0x8(%ebp),%eax
80100d83:	83 c4 10             	add    $0x10,%esp
80100d86:	0f b6 10             	movzbl (%eax),%edx
80100d89:	84 d2                	test   %dl,%dl
80100d8b:	74 19                	je     80100da6 <exec+0x3b6>
80100d8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100d90:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100d93:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
  cprintf("PP");
  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100d96:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100d99:	0f 44 c8             	cmove  %eax,%ecx
80100d9c:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
  cprintf("PP");
  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100d9f:	84 d2                	test   %dl,%dl
80100da1:	75 f0                	jne    80100d93 <exec+0x3a3>
80100da3:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  cprintf("QQ");
80100da6:	83 ec 0c             	sub    $0xc,%esp
80100da9:	68 96 72 10 80       	push   $0x80107296
80100dae:	e8 ad f8 ff ff       	call   80100660 <cprintf>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100db3:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100db9:	83 c4 0c             	add    $0xc,%esp
80100dbc:	6a 10                	push   $0x10
80100dbe:	ff 75 08             	pushl  0x8(%ebp)
80100dc1:	89 f8                	mov    %edi,%eax
80100dc3:	83 c0 6c             	add    $0x6c,%eax
80100dc6:	50                   	push   %eax
80100dc7:	e8 14 39 00 00       	call   801046e0 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100dcc:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
      last = s+1;
  cprintf("QQ");
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100dd2:	8b 5f 04             	mov    0x4(%edi),%ebx
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100dd5:	8b 47 18             	mov    0x18(%edi),%eax
  cprintf("QQ");
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100dd8:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100ddb:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100de1:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100de3:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100de9:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dec:	8b 47 18             	mov    0x18(%edi),%eax
80100def:	89 70 44             	mov    %esi,0x44(%eax)
  switchuvm(curproc);
80100df2:	89 3c 24             	mov    %edi,(%esp)
80100df5:	e8 16 5b 00 00       	call   80106910 <switchuvm>
  freevm(oldpgdir);
80100dfa:	89 1c 24             	mov    %ebx,(%esp)
80100dfd:	e8 8e 5e 00 00       	call   80106c90 <freevm>
  cprintf("RR");
80100e02:	c7 04 24 99 72 10 80 	movl   $0x80107299,(%esp)
80100e09:	e8 52 f8 ff ff       	call   80100660 <cprintf>
  return 0;
80100e0e:	83 c4 10             	add    $0x10,%esp
80100e11:	31 c0                	xor    %eax,%eax
80100e13:	e9 54 fc ff ff       	jmp    80100a6c <exec+0x7c>
80100e18:	66 90                	xchg   %ax,%ax
80100e1a:	66 90                	xchg   %ax,%ax
80100e1c:	66 90                	xchg   %ax,%ax
80100e1e:	66 90                	xchg   %ax,%ax

80100e20 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e20:	55                   	push   %ebp
80100e21:	89 e5                	mov    %esp,%ebp
80100e23:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e26:	68 9c 72 10 80       	push   $0x8010729c
80100e2b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e30:	e8 3b 34 00 00       	call   80104270 <initlock>
}
80100e35:	83 c4 10             	add    $0x10,%esp
80100e38:	c9                   	leave  
80100e39:	c3                   	ret    
80100e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e40 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e44:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e49:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100e4c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e51:	e8 1a 35 00 00       	call   80104370 <acquire>
80100e56:	83 c4 10             	add    $0x10,%esp
80100e59:	eb 10                	jmp    80100e6b <filealloc+0x2b>
80100e5b:	90                   	nop
80100e5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e60:	83 c3 18             	add    $0x18,%ebx
80100e63:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e69:	74 25                	je     80100e90 <filealloc+0x50>
    if(f->ref == 0){
80100e6b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e6e:	85 c0                	test   %eax,%eax
80100e70:	75 ee                	jne    80100e60 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e72:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100e75:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e7c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e81:	e8 0a 36 00 00       	call   80104490 <release>
      return f;
80100e86:	89 d8                	mov    %ebx,%eax
80100e88:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e8e:	c9                   	leave  
80100e8f:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100e90:	83 ec 0c             	sub    $0xc,%esp
80100e93:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e98:	e8 f3 35 00 00       	call   80104490 <release>
  return 0;
80100e9d:	83 c4 10             	add    $0x10,%esp
80100ea0:	31 c0                	xor    %eax,%eax
}
80100ea2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ea5:	c9                   	leave  
80100ea6:	c3                   	ret    
80100ea7:	89 f6                	mov    %esi,%esi
80100ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100eb0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100eb0:	55                   	push   %ebp
80100eb1:	89 e5                	mov    %esp,%ebp
80100eb3:	53                   	push   %ebx
80100eb4:	83 ec 10             	sub    $0x10,%esp
80100eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eba:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ebf:	e8 ac 34 00 00       	call   80104370 <acquire>
  if(f->ref < 1)
80100ec4:	8b 43 04             	mov    0x4(%ebx),%eax
80100ec7:	83 c4 10             	add    $0x10,%esp
80100eca:	85 c0                	test   %eax,%eax
80100ecc:	7e 1a                	jle    80100ee8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ece:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ed1:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100ed4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ed7:	68 c0 ff 10 80       	push   $0x8010ffc0
80100edc:	e8 af 35 00 00       	call   80104490 <release>
  return f;
}
80100ee1:	89 d8                	mov    %ebx,%eax
80100ee3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ee6:	c9                   	leave  
80100ee7:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100ee8:	83 ec 0c             	sub    $0xc,%esp
80100eeb:	68 a3 72 10 80       	push   $0x801072a3
80100ef0:	e8 7b f4 ff ff       	call   80100370 <panic>
80100ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f00 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	57                   	push   %edi
80100f04:	56                   	push   %esi
80100f05:	53                   	push   %ebx
80100f06:	83 ec 28             	sub    $0x28,%esp
80100f09:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100f0c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100f11:	e8 5a 34 00 00       	call   80104370 <acquire>
  if(f->ref < 1)
80100f16:	8b 47 04             	mov    0x4(%edi),%eax
80100f19:	83 c4 10             	add    $0x10,%esp
80100f1c:	85 c0                	test   %eax,%eax
80100f1e:	0f 8e 9b 00 00 00    	jle    80100fbf <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100f24:	83 e8 01             	sub    $0x1,%eax
80100f27:	85 c0                	test   %eax,%eax
80100f29:	89 47 04             	mov    %eax,0x4(%edi)
80100f2c:	74 1a                	je     80100f48 <fileclose+0x48>
    release(&ftable.lock);
80100f2e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f38:	5b                   	pop    %ebx
80100f39:	5e                   	pop    %esi
80100f3a:	5f                   	pop    %edi
80100f3b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100f3c:	e9 4f 35 00 00       	jmp    80104490 <release>
80100f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100f48:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100f4c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f4e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f51:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100f54:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f5a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f5d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f60:	68 c0 ff 10 80       	push   $0x8010ffc0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f65:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f68:	e8 23 35 00 00       	call   80104490 <release>

  if(ff.type == FD_PIPE)
80100f6d:	83 c4 10             	add    $0x10,%esp
80100f70:	83 fb 01             	cmp    $0x1,%ebx
80100f73:	74 13                	je     80100f88 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f75:	83 fb 02             	cmp    $0x2,%ebx
80100f78:	74 26                	je     80100fa0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f7d:	5b                   	pop    %ebx
80100f7e:	5e                   	pop    %esi
80100f7f:	5f                   	pop    %edi
80100f80:	5d                   	pop    %ebp
80100f81:	c3                   	ret    
80100f82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100f88:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f8c:	83 ec 08             	sub    $0x8,%esp
80100f8f:	53                   	push   %ebx
80100f90:	56                   	push   %esi
80100f91:	e8 2a 24 00 00       	call   801033c0 <pipeclose>
80100f96:	83 c4 10             	add    $0x10,%esp
80100f99:	eb df                	jmp    80100f7a <fileclose+0x7a>
80100f9b:	90                   	nop
80100f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100fa0:	e8 7b 1c 00 00       	call   80102c20 <begin_op>
    iput(ff.ip);
80100fa5:	83 ec 0c             	sub    $0xc,%esp
80100fa8:	ff 75 e0             	pushl  -0x20(%ebp)
80100fab:	e8 c0 08 00 00       	call   80101870 <iput>
    end_op();
80100fb0:	83 c4 10             	add    $0x10,%esp
  }
}
80100fb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb6:	5b                   	pop    %ebx
80100fb7:	5e                   	pop    %esi
80100fb8:	5f                   	pop    %edi
80100fb9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100fba:	e9 d1 1c 00 00       	jmp    80102c90 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100fbf:	83 ec 0c             	sub    $0xc,%esp
80100fc2:	68 ab 72 10 80       	push   $0x801072ab
80100fc7:	e8 a4 f3 ff ff       	call   80100370 <panic>
80100fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fd0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fd0:	55                   	push   %ebp
80100fd1:	89 e5                	mov    %esp,%ebp
80100fd3:	53                   	push   %ebx
80100fd4:	83 ec 04             	sub    $0x4,%esp
80100fd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fdd:	75 31                	jne    80101010 <filestat+0x40>
    ilock(f->ip);
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	ff 73 10             	pushl  0x10(%ebx)
80100fe5:	e8 56 07 00 00       	call   80101740 <ilock>
    stati(f->ip, st);
80100fea:	58                   	pop    %eax
80100feb:	5a                   	pop    %edx
80100fec:	ff 75 0c             	pushl  0xc(%ebp)
80100fef:	ff 73 10             	pushl  0x10(%ebx)
80100ff2:	e8 f9 09 00 00       	call   801019f0 <stati>
    iunlock(f->ip);
80100ff7:	59                   	pop    %ecx
80100ff8:	ff 73 10             	pushl  0x10(%ebx)
80100ffb:	e8 20 08 00 00       	call   80101820 <iunlock>
    return 0;
80101000:	83 c4 10             	add    $0x10,%esp
80101003:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80101005:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101008:	c9                   	leave  
80101009:	c3                   	ret    
8010100a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80101010:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101015:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101018:	c9                   	leave  
80101019:	c3                   	ret    
8010101a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101020 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101020:	55                   	push   %ebp
80101021:	89 e5                	mov    %esp,%ebp
80101023:	57                   	push   %edi
80101024:	56                   	push   %esi
80101025:	53                   	push   %ebx
80101026:	83 ec 0c             	sub    $0xc,%esp
80101029:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010102c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010102f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101032:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101036:	74 60                	je     80101098 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101038:	8b 03                	mov    (%ebx),%eax
8010103a:	83 f8 01             	cmp    $0x1,%eax
8010103d:	74 41                	je     80101080 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103f:	83 f8 02             	cmp    $0x2,%eax
80101042:	75 5b                	jne    8010109f <fileread+0x7f>
    ilock(f->ip);
80101044:	83 ec 0c             	sub    $0xc,%esp
80101047:	ff 73 10             	pushl  0x10(%ebx)
8010104a:	e8 f1 06 00 00       	call   80101740 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010104f:	57                   	push   %edi
80101050:	ff 73 14             	pushl  0x14(%ebx)
80101053:	56                   	push   %esi
80101054:	ff 73 10             	pushl  0x10(%ebx)
80101057:	e8 c4 09 00 00       	call   80101a20 <readi>
8010105c:	83 c4 20             	add    $0x20,%esp
8010105f:	85 c0                	test   %eax,%eax
80101061:	89 c6                	mov    %eax,%esi
80101063:	7e 03                	jle    80101068 <fileread+0x48>
      f->off += r;
80101065:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	pushl  0x10(%ebx)
8010106e:	e8 ad 07 00 00       	call   80101820 <iunlock>
    return r;
80101073:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101076:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80101078:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010107b:	5b                   	pop    %ebx
8010107c:	5e                   	pop    %esi
8010107d:	5f                   	pop    %edi
8010107e:	5d                   	pop    %ebp
8010107f:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80101080:	8b 43 0c             	mov    0xc(%ebx),%eax
80101083:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80101086:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101089:	5b                   	pop    %ebx
8010108a:	5e                   	pop    %esi
8010108b:	5f                   	pop    %edi
8010108c:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
8010108d:	e9 ce 24 00 00       	jmp    80103560 <piperead>
80101092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80101098:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010109d:	eb d9                	jmp    80101078 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	68 b5 72 10 80       	push   $0x801072b5
801010a7:	e8 c4 f2 ff ff       	call   80100370 <panic>
801010ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010b0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 1c             	sub    $0x1c,%esp
801010b9:	8b 75 08             	mov    0x8(%ebp),%esi
801010bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
801010bf:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010c6:	8b 45 10             	mov    0x10(%ebp),%eax
801010c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
801010cc:	0f 84 aa 00 00 00    	je     8010117c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
801010d2:	8b 06                	mov    (%esi),%eax
801010d4:	83 f8 01             	cmp    $0x1,%eax
801010d7:	0f 84 c2 00 00 00    	je     8010119f <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010dd:	83 f8 02             	cmp    $0x2,%eax
801010e0:	0f 85 d8 00 00 00    	jne    801011be <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801010e9:	31 ff                	xor    %edi,%edi
801010eb:	85 c0                	test   %eax,%eax
801010ed:	7f 34                	jg     80101123 <filewrite+0x73>
801010ef:	e9 9c 00 00 00       	jmp    80101190 <filewrite+0xe0>
801010f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010f8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010fb:	83 ec 0c             	sub    $0xc,%esp
801010fe:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101101:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101104:	e8 17 07 00 00       	call   80101820 <iunlock>
      end_op();
80101109:	e8 82 1b 00 00       	call   80102c90 <end_op>
8010110e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101111:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101114:	39 d8                	cmp    %ebx,%eax
80101116:	0f 85 95 00 00 00    	jne    801011b1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010111c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010111e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101121:	7e 6d                	jle    80101190 <filewrite+0xe0>
      int n1 = n - i;
80101123:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101126:	b8 00 1a 00 00       	mov    $0x1a00,%eax
8010112b:	29 fb                	sub    %edi,%ebx
8010112d:	81 fb 00 1a 00 00    	cmp    $0x1a00,%ebx
80101133:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101136:	e8 e5 1a 00 00       	call   80102c20 <begin_op>
      ilock(f->ip);
8010113b:	83 ec 0c             	sub    $0xc,%esp
8010113e:	ff 76 10             	pushl  0x10(%esi)
80101141:	e8 fa 05 00 00       	call   80101740 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101146:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101149:	53                   	push   %ebx
8010114a:	ff 76 14             	pushl  0x14(%esi)
8010114d:	01 f8                	add    %edi,%eax
8010114f:	50                   	push   %eax
80101150:	ff 76 10             	pushl  0x10(%esi)
80101153:	e8 c8 09 00 00       	call   80101b20 <writei>
80101158:	83 c4 20             	add    $0x20,%esp
8010115b:	85 c0                	test   %eax,%eax
8010115d:	7f 99                	jg     801010f8 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010115f:	83 ec 0c             	sub    $0xc,%esp
80101162:	ff 76 10             	pushl  0x10(%esi)
80101165:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101168:	e8 b3 06 00 00       	call   80101820 <iunlock>
      end_op();
8010116d:	e8 1e 1b 00 00       	call   80102c90 <end_op>

      if(r < 0)
80101172:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101175:	83 c4 10             	add    $0x10,%esp
80101178:	85 c0                	test   %eax,%eax
8010117a:	74 98                	je     80101114 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010117c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010117f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101184:	5b                   	pop    %ebx
80101185:	5e                   	pop    %esi
80101186:	5f                   	pop    %edi
80101187:	5d                   	pop    %ebp
80101188:	c3                   	ret    
80101189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101190:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101193:	75 e7                	jne    8010117c <filewrite+0xcc>
  }
  panic("filewrite");
}
80101195:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101198:	89 f8                	mov    %edi,%eax
8010119a:	5b                   	pop    %ebx
8010119b:	5e                   	pop    %esi
8010119c:	5f                   	pop    %edi
8010119d:	5d                   	pop    %ebp
8010119e:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010119f:	8b 46 0c             	mov    0xc(%esi),%eax
801011a2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801011a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a8:	5b                   	pop    %ebx
801011a9:	5e                   	pop    %esi
801011aa:	5f                   	pop    %edi
801011ab:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801011ac:	e9 af 22 00 00       	jmp    80103460 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801011b1:	83 ec 0c             	sub    $0xc,%esp
801011b4:	68 be 72 10 80       	push   $0x801072be
801011b9:	e8 b2 f1 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801011be:	83 ec 0c             	sub    $0xc,%esp
801011c1:	68 c4 72 10 80       	push   $0x801072c4
801011c6:	e8 a5 f1 ff ff       	call   80100370 <panic>
801011cb:	66 90                	xchg   %ax,%ax
801011cd:	66 90                	xchg   %ax,%ax
801011cf:	90                   	nop

801011d0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011d0:	55                   	push   %ebp
801011d1:	89 e5                	mov    %esp,%ebp
801011d3:	57                   	push   %edi
801011d4:	56                   	push   %esi
801011d5:	53                   	push   %ebx
801011d6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011d9:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011e2:	85 c9                	test   %ecx,%ecx
801011e4:	0f 84 85 00 00 00    	je     8010126f <balloc+0x9f>
801011ea:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011f1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011f4:	83 ec 08             	sub    $0x8,%esp
801011f7:	89 f0                	mov    %esi,%eax
801011f9:	c1 f8 0c             	sar    $0xc,%eax
801011fc:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101202:	50                   	push   %eax
80101203:	ff 75 d8             	pushl  -0x28(%ebp)
80101206:	e8 c5 ee ff ff       	call   801000d0 <bread>
8010120b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010120e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101213:	83 c4 10             	add    $0x10,%esp
80101216:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101219:	31 c0                	xor    %eax,%eax
8010121b:	eb 2d                	jmp    8010124a <balloc+0x7a>
8010121d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101220:	89 c1                	mov    %eax,%ecx
80101222:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101227:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010122a:	83 e1 07             	and    $0x7,%ecx
8010122d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010122f:	89 c1                	mov    %eax,%ecx
80101231:	c1 f9 03             	sar    $0x3,%ecx
80101234:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101239:	85 d7                	test   %edx,%edi
8010123b:	74 43                	je     80101280 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010123d:	83 c0 01             	add    $0x1,%eax
80101240:	83 c6 01             	add    $0x1,%esi
80101243:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101248:	74 05                	je     8010124f <balloc+0x7f>
8010124a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010124d:	72 d1                	jb     80101220 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010124f:	83 ec 0c             	sub    $0xc,%esp
80101252:	ff 75 e4             	pushl  -0x1c(%ebp)
80101255:	e8 86 ef ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010125a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101261:	83 c4 10             	add    $0x10,%esp
80101264:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101267:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010126d:	77 82                	ja     801011f1 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010126f:	83 ec 0c             	sub    $0xc,%esp
80101272:	68 ce 72 10 80       	push   $0x801072ce
80101277:	e8 f4 f0 ff ff       	call   80100370 <panic>
8010127c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101280:	09 fa                	or     %edi,%edx
80101282:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101285:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101288:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010128c:	57                   	push   %edi
8010128d:	e8 6e 1b 00 00       	call   80102e00 <log_write>
        brelse(bp);
80101292:	89 3c 24             	mov    %edi,(%esp)
80101295:	e8 46 ef ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
8010129a:	58                   	pop    %eax
8010129b:	5a                   	pop    %edx
8010129c:	56                   	push   %esi
8010129d:	ff 75 d8             	pushl  -0x28(%ebp)
801012a0:	e8 2b ee ff ff       	call   801000d0 <bread>
801012a5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012a7:	8d 40 5c             	lea    0x5c(%eax),%eax
801012aa:	83 c4 0c             	add    $0xc,%esp
801012ad:	68 00 02 00 00       	push   $0x200
801012b2:	6a 00                	push   $0x0
801012b4:	50                   	push   %eax
801012b5:	e8 26 32 00 00       	call   801044e0 <memset>
  log_write(bp);
801012ba:	89 1c 24             	mov    %ebx,(%esp)
801012bd:	e8 3e 1b 00 00       	call   80102e00 <log_write>
  brelse(bp);
801012c2:	89 1c 24             	mov    %ebx,(%esp)
801012c5:	e8 16 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801012ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012cd:	89 f0                	mov    %esi,%eax
801012cf:	5b                   	pop    %ebx
801012d0:	5e                   	pop    %esi
801012d1:	5f                   	pop    %edi
801012d2:	5d                   	pop    %ebp
801012d3:	c3                   	ret    
801012d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801012da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801012e0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	57                   	push   %edi
801012e4:	56                   	push   %esi
801012e5:	53                   	push   %ebx
801012e6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012e8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012ea:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012ef:	83 ec 28             	sub    $0x28,%esp
801012f2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
801012f5:	68 e0 09 11 80       	push   $0x801109e0
801012fa:	e8 71 30 00 00       	call   80104370 <acquire>
801012ff:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101302:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101305:	eb 1b                	jmp    80101322 <iget+0x42>
80101307:	89 f6                	mov    %esi,%esi
80101309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101310:	85 f6                	test   %esi,%esi
80101312:	74 44                	je     80101358 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101314:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010131a:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101320:	74 4e                	je     80101370 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101322:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101325:	85 c9                	test   %ecx,%ecx
80101327:	7e e7                	jle    80101310 <iget+0x30>
80101329:	39 3b                	cmp    %edi,(%ebx)
8010132b:	75 e3                	jne    80101310 <iget+0x30>
8010132d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101330:	75 de                	jne    80101310 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101332:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101335:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101338:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010133a:	68 e0 09 11 80       	push   $0x801109e0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010133f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101342:	e8 49 31 00 00       	call   80104490 <release>
      return ip;
80101347:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010134a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010134d:	89 f0                	mov    %esi,%eax
8010134f:	5b                   	pop    %ebx
80101350:	5e                   	pop    %esi
80101351:	5f                   	pop    %edi
80101352:	5d                   	pop    %ebp
80101353:	c3                   	ret    
80101354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101358:	85 c9                	test   %ecx,%ecx
8010135a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101363:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101369:	75 b7                	jne    80101322 <iget+0x42>
8010136b:	90                   	nop
8010136c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101370:	85 f6                	test   %esi,%esi
80101372:	74 2d                	je     801013a1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101374:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101377:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101379:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010137c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101383:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010138a:	68 e0 09 11 80       	push   $0x801109e0
8010138f:	e8 fc 30 00 00       	call   80104490 <release>

  return ip;
80101394:	83 c4 10             	add    $0x10,%esp
}
80101397:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010139a:	89 f0                	mov    %esi,%eax
8010139c:	5b                   	pop    %ebx
8010139d:	5e                   	pop    %esi
8010139e:	5f                   	pop    %edi
8010139f:	5d                   	pop    %ebp
801013a0:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801013a1:	83 ec 0c             	sub    $0xc,%esp
801013a4:	68 e4 72 10 80       	push   $0x801072e4
801013a9:	e8 c2 ef ff ff       	call   80100370 <panic>
801013ae:	66 90                	xchg   %ax,%ax

801013b0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	57                   	push   %edi
801013b4:	56                   	push   %esi
801013b5:	53                   	push   %ebx
801013b6:	89 c6                	mov    %eax,%esi
801013b8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801013bb:	83 fa 0b             	cmp    $0xb,%edx
801013be:	77 18                	ja     801013d8 <bmap+0x28>
801013c0:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
801013c3:	8b 43 5c             	mov    0x5c(%ebx),%eax
801013c6:	85 c0                	test   %eax,%eax
801013c8:	74 76                	je     80101440 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801013ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013cd:	5b                   	pop    %ebx
801013ce:	5e                   	pop    %esi
801013cf:	5f                   	pop    %edi
801013d0:	5d                   	pop    %ebp
801013d1:	c3                   	ret    
801013d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801013d8:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801013db:	83 fb 7f             	cmp    $0x7f,%ebx
801013de:	0f 87 83 00 00 00    	ja     80101467 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801013e4:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801013ea:	85 c0                	test   %eax,%eax
801013ec:	74 6a                	je     80101458 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801013ee:	83 ec 08             	sub    $0x8,%esp
801013f1:	50                   	push   %eax
801013f2:	ff 36                	pushl  (%esi)
801013f4:	e8 d7 ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801013f9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013fd:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101400:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101402:	8b 1a                	mov    (%edx),%ebx
80101404:	85 db                	test   %ebx,%ebx
80101406:	75 1d                	jne    80101425 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101408:	8b 06                	mov    (%esi),%eax
8010140a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010140d:	e8 be fd ff ff       	call   801011d0 <balloc>
80101412:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101415:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101418:	89 c3                	mov    %eax,%ebx
8010141a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010141c:	57                   	push   %edi
8010141d:	e8 de 19 00 00       	call   80102e00 <log_write>
80101422:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101425:	83 ec 0c             	sub    $0xc,%esp
80101428:	57                   	push   %edi
80101429:	e8 b2 ed ff ff       	call   801001e0 <brelse>
8010142e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101431:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101434:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101436:	5b                   	pop    %ebx
80101437:	5e                   	pop    %esi
80101438:	5f                   	pop    %edi
80101439:	5d                   	pop    %ebp
8010143a:	c3                   	ret    
8010143b:	90                   	nop
8010143c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101440:	8b 06                	mov    (%esi),%eax
80101442:	e8 89 fd ff ff       	call   801011d0 <balloc>
80101447:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010144a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010144d:	5b                   	pop    %ebx
8010144e:	5e                   	pop    %esi
8010144f:	5f                   	pop    %edi
80101450:	5d                   	pop    %ebp
80101451:	c3                   	ret    
80101452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101458:	8b 06                	mov    (%esi),%eax
8010145a:	e8 71 fd ff ff       	call   801011d0 <balloc>
8010145f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101465:	eb 87                	jmp    801013ee <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101467:	83 ec 0c             	sub    $0xc,%esp
8010146a:	68 f4 72 10 80       	push   $0x801072f4
8010146f:	e8 fc ee ff ff       	call   80100370 <panic>
80101474:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010147a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101480 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	56                   	push   %esi
80101484:	53                   	push   %ebx
80101485:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101488:	83 ec 08             	sub    $0x8,%esp
8010148b:	6a 01                	push   $0x1
8010148d:	ff 75 08             	pushl  0x8(%ebp)
80101490:	e8 3b ec ff ff       	call   801000d0 <bread>
80101495:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101497:	8d 40 5c             	lea    0x5c(%eax),%eax
8010149a:	83 c4 0c             	add    $0xc,%esp
8010149d:	6a 1c                	push   $0x1c
8010149f:	50                   	push   %eax
801014a0:	56                   	push   %esi
801014a1:	e8 ea 30 00 00       	call   80104590 <memmove>
  brelse(bp);
801014a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801014a9:	83 c4 10             	add    $0x10,%esp
}
801014ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014af:	5b                   	pop    %ebx
801014b0:	5e                   	pop    %esi
801014b1:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801014b2:	e9 29 ed ff ff       	jmp    801001e0 <brelse>
801014b7:	89 f6                	mov    %esi,%esi
801014b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	56                   	push   %esi
801014c4:	53                   	push   %ebx
801014c5:	89 d3                	mov    %edx,%ebx
801014c7:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801014c9:	83 ec 08             	sub    $0x8,%esp
801014cc:	68 c0 09 11 80       	push   $0x801109c0
801014d1:	50                   	push   %eax
801014d2:	e8 a9 ff ff ff       	call   80101480 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014d7:	58                   	pop    %eax
801014d8:	5a                   	pop    %edx
801014d9:	89 da                	mov    %ebx,%edx
801014db:	c1 ea 0c             	shr    $0xc,%edx
801014de:	03 15 d8 09 11 80    	add    0x801109d8,%edx
801014e4:	52                   	push   %edx
801014e5:	56                   	push   %esi
801014e6:	e8 e5 eb ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801014eb:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014ed:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
801014f3:	ba 01 00 00 00       	mov    $0x1,%edx
801014f8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014fb:	c1 fb 03             	sar    $0x3,%ebx
801014fe:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101501:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101503:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101508:	85 d1                	test   %edx,%ecx
8010150a:	74 27                	je     80101533 <bfree+0x73>
8010150c:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010150e:	f7 d2                	not    %edx
80101510:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101512:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101515:	21 d0                	and    %edx,%eax
80101517:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010151b:	56                   	push   %esi
8010151c:	e8 df 18 00 00       	call   80102e00 <log_write>
  brelse(bp);
80101521:	89 34 24             	mov    %esi,(%esp)
80101524:	e8 b7 ec ff ff       	call   801001e0 <brelse>
}
80101529:	83 c4 10             	add    $0x10,%esp
8010152c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010152f:	5b                   	pop    %ebx
80101530:	5e                   	pop    %esi
80101531:	5d                   	pop    %ebp
80101532:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101533:	83 ec 0c             	sub    $0xc,%esp
80101536:	68 07 73 10 80       	push   $0x80107307
8010153b:	e8 30 ee ff ff       	call   80100370 <panic>

80101540 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	53                   	push   %ebx
80101544:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101549:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010154c:	68 1a 73 10 80       	push   $0x8010731a
80101551:	68 e0 09 11 80       	push   $0x801109e0
80101556:	e8 15 2d 00 00       	call   80104270 <initlock>
8010155b:	83 c4 10             	add    $0x10,%esp
8010155e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101560:	83 ec 08             	sub    $0x8,%esp
80101563:	68 21 73 10 80       	push   $0x80107321
80101568:	53                   	push   %ebx
80101569:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010156f:	e8 ec 2b 00 00       	call   80104160 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101574:	83 c4 10             	add    $0x10,%esp
80101577:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010157d:	75 e1                	jne    80101560 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
8010157f:	83 ec 08             	sub    $0x8,%esp
80101582:	68 c0 09 11 80       	push   $0x801109c0
80101587:	ff 75 08             	pushl  0x8(%ebp)
8010158a:	e8 f1 fe ff ff       	call   80101480 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010158f:	ff 35 d8 09 11 80    	pushl  0x801109d8
80101595:	ff 35 d4 09 11 80    	pushl  0x801109d4
8010159b:	ff 35 d0 09 11 80    	pushl  0x801109d0
801015a1:	ff 35 cc 09 11 80    	pushl  0x801109cc
801015a7:	ff 35 c8 09 11 80    	pushl  0x801109c8
801015ad:	ff 35 c4 09 11 80    	pushl  0x801109c4
801015b3:	ff 35 c0 09 11 80    	pushl  0x801109c0
801015b9:	68 84 73 10 80       	push   $0x80107384
801015be:	e8 9d f0 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801015c3:	83 c4 30             	add    $0x30,%esp
801015c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015c9:	c9                   	leave  
801015ca:	c3                   	ret    
801015cb:	90                   	nop
801015cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801015d0 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	57                   	push   %edi
801015d4:	56                   	push   %esi
801015d5:	53                   	push   %ebx
801015d6:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801015d9:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801015e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801015e3:	8b 75 08             	mov    0x8(%ebp),%esi
801015e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801015e9:	0f 86 91 00 00 00    	jbe    80101680 <ialloc+0xb0>
801015ef:	bb 01 00 00 00       	mov    $0x1,%ebx
801015f4:	eb 21                	jmp    80101617 <ialloc+0x47>
801015f6:	8d 76 00             	lea    0x0(%esi),%esi
801015f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101600:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101603:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101606:	57                   	push   %edi
80101607:	e8 d4 eb ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010160c:	83 c4 10             	add    $0x10,%esp
8010160f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101615:	76 69                	jbe    80101680 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101617:	89 d8                	mov    %ebx,%eax
80101619:	83 ec 08             	sub    $0x8,%esp
8010161c:	c1 e8 03             	shr    $0x3,%eax
8010161f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101625:	50                   	push   %eax
80101626:	56                   	push   %esi
80101627:	e8 a4 ea ff ff       	call   801000d0 <bread>
8010162c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010162e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101630:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101633:	83 e0 07             	and    $0x7,%eax
80101636:	c1 e0 06             	shl    $0x6,%eax
80101639:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010163d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101641:	75 bd                	jne    80101600 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101643:	83 ec 04             	sub    $0x4,%esp
80101646:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101649:	6a 40                	push   $0x40
8010164b:	6a 00                	push   $0x0
8010164d:	51                   	push   %ecx
8010164e:	e8 8d 2e 00 00       	call   801044e0 <memset>
      dip->type = type;
80101653:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101657:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010165a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010165d:	89 3c 24             	mov    %edi,(%esp)
80101660:	e8 9b 17 00 00       	call   80102e00 <log_write>
      brelse(bp);
80101665:	89 3c 24             	mov    %edi,(%esp)
80101668:	e8 73 eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010166d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101670:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101673:	89 da                	mov    %ebx,%edx
80101675:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101677:	5b                   	pop    %ebx
80101678:	5e                   	pop    %esi
80101679:	5f                   	pop    %edi
8010167a:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010167b:	e9 60 fc ff ff       	jmp    801012e0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101680:	83 ec 0c             	sub    $0xc,%esp
80101683:	68 27 73 10 80       	push   $0x80107327
80101688:	e8 e3 ec ff ff       	call   80100370 <panic>
8010168d:	8d 76 00             	lea    0x0(%esi),%esi

80101690 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	56                   	push   %esi
80101694:	53                   	push   %ebx
80101695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101698:	83 ec 08             	sub    $0x8,%esp
8010169b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010169e:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016a1:	c1 e8 03             	shr    $0x3,%eax
801016a4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016aa:	50                   	push   %eax
801016ab:	ff 73 a4             	pushl  -0x5c(%ebx)
801016ae:	e8 1d ea ff ff       	call   801000d0 <bread>
801016b3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016b5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801016b8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016bc:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016bf:	83 e0 07             	and    $0x7,%eax
801016c2:	c1 e0 06             	shl    $0x6,%eax
801016c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016c9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016cc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016d0:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
801016d3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016d7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016db:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016df:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016e3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016e7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016ea:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016ed:	6a 34                	push   $0x34
801016ef:	53                   	push   %ebx
801016f0:	50                   	push   %eax
801016f1:	e8 9a 2e 00 00       	call   80104590 <memmove>
  log_write(bp);
801016f6:	89 34 24             	mov    %esi,(%esp)
801016f9:	e8 02 17 00 00       	call   80102e00 <log_write>
  brelse(bp);
801016fe:	89 75 08             	mov    %esi,0x8(%ebp)
80101701:	83 c4 10             	add    $0x10,%esp
}
80101704:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101707:	5b                   	pop    %ebx
80101708:	5e                   	pop    %esi
80101709:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
8010170a:	e9 d1 ea ff ff       	jmp    801001e0 <brelse>
8010170f:	90                   	nop

80101710 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101710:	55                   	push   %ebp
80101711:	89 e5                	mov    %esp,%ebp
80101713:	53                   	push   %ebx
80101714:	83 ec 10             	sub    $0x10,%esp
80101717:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010171a:	68 e0 09 11 80       	push   $0x801109e0
8010171f:	e8 4c 2c 00 00       	call   80104370 <acquire>
  ip->ref++;
80101724:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101728:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010172f:	e8 5c 2d 00 00       	call   80104490 <release>
  return ip;
}
80101734:	89 d8                	mov    %ebx,%eax
80101736:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101739:	c9                   	leave  
8010173a:	c3                   	ret    
8010173b:	90                   	nop
8010173c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101740 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	56                   	push   %esi
80101744:	53                   	push   %ebx
80101745:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101748:	85 db                	test   %ebx,%ebx
8010174a:	0f 84 b7 00 00 00    	je     80101807 <ilock+0xc7>
80101750:	8b 53 08             	mov    0x8(%ebx),%edx
80101753:	85 d2                	test   %edx,%edx
80101755:	0f 8e ac 00 00 00    	jle    80101807 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
8010175b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010175e:	83 ec 0c             	sub    $0xc,%esp
80101761:	50                   	push   %eax
80101762:	e8 39 2a 00 00       	call   801041a0 <acquiresleep>

  if(ip->valid == 0){
80101767:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010176a:	83 c4 10             	add    $0x10,%esp
8010176d:	85 c0                	test   %eax,%eax
8010176f:	74 0f                	je     80101780 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101771:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101774:	5b                   	pop    %ebx
80101775:	5e                   	pop    %esi
80101776:	5d                   	pop    %ebp
80101777:	c3                   	ret    
80101778:	90                   	nop
80101779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101780:	8b 43 04             	mov    0x4(%ebx),%eax
80101783:	83 ec 08             	sub    $0x8,%esp
80101786:	c1 e8 03             	shr    $0x3,%eax
80101789:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010178f:	50                   	push   %eax
80101790:	ff 33                	pushl  (%ebx)
80101792:	e8 39 e9 ff ff       	call   801000d0 <bread>
80101797:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101799:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010179c:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010179f:	83 e0 07             	and    $0x7,%eax
801017a2:	c1 e0 06             	shl    $0x6,%eax
801017a5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017a9:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ac:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801017af:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017b3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017b7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017bb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017bf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017c3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017c7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017cb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ce:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d1:	6a 34                	push   $0x34
801017d3:	50                   	push   %eax
801017d4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017d7:	50                   	push   %eax
801017d8:	e8 b3 2d 00 00       	call   80104590 <memmove>
    brelse(bp);
801017dd:	89 34 24             	mov    %esi,(%esp)
801017e0:	e8 fb e9 ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
801017e5:	83 c4 10             	add    $0x10,%esp
801017e8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
801017ed:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801017f4:	0f 85 77 ff ff ff    	jne    80101771 <ilock+0x31>
      panic("ilock: no type");
801017fa:	83 ec 0c             	sub    $0xc,%esp
801017fd:	68 3f 73 10 80       	push   $0x8010733f
80101802:	e8 69 eb ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101807:	83 ec 0c             	sub    $0xc,%esp
8010180a:	68 39 73 10 80       	push   $0x80107339
8010180f:	e8 5c eb ff ff       	call   80100370 <panic>
80101814:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010181a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101820 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101820:	55                   	push   %ebp
80101821:	89 e5                	mov    %esp,%ebp
80101823:	56                   	push   %esi
80101824:	53                   	push   %ebx
80101825:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101828:	85 db                	test   %ebx,%ebx
8010182a:	74 28                	je     80101854 <iunlock+0x34>
8010182c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010182f:	83 ec 0c             	sub    $0xc,%esp
80101832:	56                   	push   %esi
80101833:	e8 08 2a 00 00       	call   80104240 <holdingsleep>
80101838:	83 c4 10             	add    $0x10,%esp
8010183b:	85 c0                	test   %eax,%eax
8010183d:	74 15                	je     80101854 <iunlock+0x34>
8010183f:	8b 43 08             	mov    0x8(%ebx),%eax
80101842:	85 c0                	test   %eax,%eax
80101844:	7e 0e                	jle    80101854 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101846:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101849:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010184c:	5b                   	pop    %ebx
8010184d:	5e                   	pop    %esi
8010184e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010184f:	e9 ac 29 00 00       	jmp    80104200 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101854:	83 ec 0c             	sub    $0xc,%esp
80101857:	68 4e 73 10 80       	push   $0x8010734e
8010185c:	e8 0f eb ff ff       	call   80100370 <panic>
80101861:	eb 0d                	jmp    80101870 <iput>
80101863:	90                   	nop
80101864:	90                   	nop
80101865:	90                   	nop
80101866:	90                   	nop
80101867:	90                   	nop
80101868:	90                   	nop
80101869:	90                   	nop
8010186a:	90                   	nop
8010186b:	90                   	nop
8010186c:	90                   	nop
8010186d:	90                   	nop
8010186e:	90                   	nop
8010186f:	90                   	nop

80101870 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101870:	55                   	push   %ebp
80101871:	89 e5                	mov    %esp,%ebp
80101873:	57                   	push   %edi
80101874:	56                   	push   %esi
80101875:	53                   	push   %ebx
80101876:	83 ec 28             	sub    $0x28,%esp
80101879:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
8010187c:	8d 7e 0c             	lea    0xc(%esi),%edi
8010187f:	57                   	push   %edi
80101880:	e8 1b 29 00 00       	call   801041a0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101885:	8b 56 4c             	mov    0x4c(%esi),%edx
80101888:	83 c4 10             	add    $0x10,%esp
8010188b:	85 d2                	test   %edx,%edx
8010188d:	74 07                	je     80101896 <iput+0x26>
8010188f:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101894:	74 32                	je     801018c8 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
80101896:	83 ec 0c             	sub    $0xc,%esp
80101899:	57                   	push   %edi
8010189a:	e8 61 29 00 00       	call   80104200 <releasesleep>

  acquire(&icache.lock);
8010189f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018a6:	e8 c5 2a 00 00       	call   80104370 <acquire>
  ip->ref--;
801018ab:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801018af:	83 c4 10             	add    $0x10,%esp
801018b2:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801018b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018bc:	5b                   	pop    %ebx
801018bd:	5e                   	pop    %esi
801018be:	5f                   	pop    %edi
801018bf:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
801018c0:	e9 cb 2b 00 00       	jmp    80104490 <release>
801018c5:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
801018c8:	83 ec 0c             	sub    $0xc,%esp
801018cb:	68 e0 09 11 80       	push   $0x801109e0
801018d0:	e8 9b 2a 00 00       	call   80104370 <acquire>
    int r = ip->ref;
801018d5:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
801018d8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018df:	e8 ac 2b 00 00       	call   80104490 <release>
    if(r == 1){
801018e4:	83 c4 10             	add    $0x10,%esp
801018e7:	83 fb 01             	cmp    $0x1,%ebx
801018ea:	75 aa                	jne    80101896 <iput+0x26>
801018ec:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
801018f2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018f5:	8d 5e 5c             	lea    0x5c(%esi),%ebx
801018f8:	89 cf                	mov    %ecx,%edi
801018fa:	eb 0b                	jmp    80101907 <iput+0x97>
801018fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101900:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101903:	39 fb                	cmp    %edi,%ebx
80101905:	74 19                	je     80101920 <iput+0xb0>
    if(ip->addrs[i]){
80101907:	8b 13                	mov    (%ebx),%edx
80101909:	85 d2                	test   %edx,%edx
8010190b:	74 f3                	je     80101900 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010190d:	8b 06                	mov    (%esi),%eax
8010190f:	e8 ac fb ff ff       	call   801014c0 <bfree>
      ip->addrs[i] = 0;
80101914:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010191a:	eb e4                	jmp    80101900 <iput+0x90>
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101920:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101926:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101929:	85 c0                	test   %eax,%eax
8010192b:	75 33                	jne    80101960 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010192d:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101930:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101937:	56                   	push   %esi
80101938:	e8 53 fd ff ff       	call   80101690 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010193d:	31 c0                	xor    %eax,%eax
8010193f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101943:	89 34 24             	mov    %esi,(%esp)
80101946:	e8 45 fd ff ff       	call   80101690 <iupdate>
      ip->valid = 0;
8010194b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101952:	83 c4 10             	add    $0x10,%esp
80101955:	e9 3c ff ff ff       	jmp    80101896 <iput+0x26>
8010195a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101960:	83 ec 08             	sub    $0x8,%esp
80101963:	50                   	push   %eax
80101964:	ff 36                	pushl  (%esi)
80101966:	e8 65 e7 ff ff       	call   801000d0 <bread>
8010196b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101971:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101974:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101977:	8d 58 5c             	lea    0x5c(%eax),%ebx
8010197a:	83 c4 10             	add    $0x10,%esp
8010197d:	89 cf                	mov    %ecx,%edi
8010197f:	eb 0e                	jmp    8010198f <iput+0x11f>
80101981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101988:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
8010198b:	39 fb                	cmp    %edi,%ebx
8010198d:	74 0f                	je     8010199e <iput+0x12e>
      if(a[j])
8010198f:	8b 13                	mov    (%ebx),%edx
80101991:	85 d2                	test   %edx,%edx
80101993:	74 f3                	je     80101988 <iput+0x118>
        bfree(ip->dev, a[j]);
80101995:	8b 06                	mov    (%esi),%eax
80101997:	e8 24 fb ff ff       	call   801014c0 <bfree>
8010199c:	eb ea                	jmp    80101988 <iput+0x118>
    }
    brelse(bp);
8010199e:	83 ec 0c             	sub    $0xc,%esp
801019a1:	ff 75 e4             	pushl  -0x1c(%ebp)
801019a4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019a7:	e8 34 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019ac:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801019b2:	8b 06                	mov    (%esi),%eax
801019b4:	e8 07 fb ff ff       	call   801014c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019b9:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801019c0:	00 00 00 
801019c3:	83 c4 10             	add    $0x10,%esp
801019c6:	e9 62 ff ff ff       	jmp    8010192d <iput+0xbd>
801019cb:	90                   	nop
801019cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019d0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	53                   	push   %ebx
801019d4:	83 ec 10             	sub    $0x10,%esp
801019d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801019da:	53                   	push   %ebx
801019db:	e8 40 fe ff ff       	call   80101820 <iunlock>
  iput(ip);
801019e0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019e3:	83 c4 10             	add    $0x10,%esp
}
801019e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019e9:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
801019ea:	e9 81 fe ff ff       	jmp    80101870 <iput>
801019ef:	90                   	nop

801019f0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801019f0:	55                   	push   %ebp
801019f1:	89 e5                	mov    %esp,%ebp
801019f3:	8b 55 08             	mov    0x8(%ebp),%edx
801019f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019f9:	8b 0a                	mov    (%edx),%ecx
801019fb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019fe:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a01:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a04:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a08:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a0b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a0f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a13:	8b 52 58             	mov    0x58(%edx),%edx
80101a16:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a19:	5d                   	pop    %ebp
80101a1a:	c3                   	ret    
80101a1b:	90                   	nop
80101a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a20 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	57                   	push   %edi
80101a24:	56                   	push   %esi
80101a25:	53                   	push   %ebx
80101a26:	83 ec 1c             	sub    $0x1c,%esp
80101a29:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a2f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a32:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a37:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a3a:	8b 7d 14             	mov    0x14(%ebp),%edi
80101a3d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a40:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a43:	0f 84 a7 00 00 00    	je     80101af0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a4c:	8b 40 58             	mov    0x58(%eax),%eax
80101a4f:	39 f0                	cmp    %esi,%eax
80101a51:	0f 82 c1 00 00 00    	jb     80101b18 <readi+0xf8>
80101a57:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a5a:	89 fa                	mov    %edi,%edx
80101a5c:	01 f2                	add    %esi,%edx
80101a5e:	0f 82 b4 00 00 00    	jb     80101b18 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a64:	89 c1                	mov    %eax,%ecx
80101a66:	29 f1                	sub    %esi,%ecx
80101a68:	39 d0                	cmp    %edx,%eax
80101a6a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a6d:	31 ff                	xor    %edi,%edi
80101a6f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a71:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a74:	74 6d                	je     80101ae3 <readi+0xc3>
80101a76:	8d 76 00             	lea    0x0(%esi),%esi
80101a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a80:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a83:	89 f2                	mov    %esi,%edx
80101a85:	c1 ea 09             	shr    $0x9,%edx
80101a88:	89 d8                	mov    %ebx,%eax
80101a8a:	e8 21 f9 ff ff       	call   801013b0 <bmap>
80101a8f:	83 ec 08             	sub    $0x8,%esp
80101a92:	50                   	push   %eax
80101a93:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a95:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a9a:	e8 31 e6 ff ff       	call   801000d0 <bread>
80101a9f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101aa1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101aa4:	89 f1                	mov    %esi,%ecx
80101aa6:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101aac:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
80101aaf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101ab2:	29 cb                	sub    %ecx,%ebx
80101ab4:	29 f8                	sub    %edi,%eax
80101ab6:	39 c3                	cmp    %eax,%ebx
80101ab8:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101abb:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
80101abf:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ac0:	01 df                	add    %ebx,%edi
80101ac2:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101ac4:	50                   	push   %eax
80101ac5:	ff 75 e0             	pushl  -0x20(%ebp)
80101ac8:	e8 c3 2a 00 00       	call   80104590 <memmove>
    brelse(bp);
80101acd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101ad0:	89 14 24             	mov    %edx,(%esp)
80101ad3:	e8 08 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ad8:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101adb:	83 c4 10             	add    $0x10,%esp
80101ade:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ae1:	77 9d                	ja     80101a80 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101ae3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ae6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ae9:	5b                   	pop    %ebx
80101aea:	5e                   	pop    %esi
80101aeb:	5f                   	pop    %edi
80101aec:	5d                   	pop    %ebp
80101aed:	c3                   	ret    
80101aee:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101af0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101af4:	66 83 f8 09          	cmp    $0x9,%ax
80101af8:	77 1e                	ja     80101b18 <readi+0xf8>
80101afa:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101b01:	85 c0                	test   %eax,%eax
80101b03:	74 13                	je     80101b18 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101b05:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101b08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b0b:	5b                   	pop    %ebx
80101b0c:	5e                   	pop    %esi
80101b0d:	5f                   	pop    %edi
80101b0e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101b0f:	ff e0                	jmp    *%eax
80101b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101b18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b1d:	eb c7                	jmp    80101ae6 <readi+0xc6>
80101b1f:	90                   	nop

80101b20 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b20:	55                   	push   %ebp
80101b21:	89 e5                	mov    %esp,%ebp
80101b23:	57                   	push   %edi
80101b24:	56                   	push   %esi
80101b25:	53                   	push   %ebx
80101b26:	83 ec 1c             	sub    $0x1c,%esp
80101b29:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b2f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b32:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b37:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b3d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b40:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b43:	0f 84 b7 00 00 00    	je     80101c00 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b4c:	39 70 58             	cmp    %esi,0x58(%eax)
80101b4f:	0f 82 eb 00 00 00    	jb     80101c40 <writei+0x120>
80101b55:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b58:	89 f8                	mov    %edi,%eax
80101b5a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b5c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b61:	0f 87 d9 00 00 00    	ja     80101c40 <writei+0x120>
80101b67:	39 c6                	cmp    %eax,%esi
80101b69:	0f 87 d1 00 00 00    	ja     80101c40 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b6f:	85 ff                	test   %edi,%edi
80101b71:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b78:	74 78                	je     80101bf2 <writei+0xd2>
80101b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b80:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b83:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b85:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b8a:	c1 ea 09             	shr    $0x9,%edx
80101b8d:	89 f8                	mov    %edi,%eax
80101b8f:	e8 1c f8 ff ff       	call   801013b0 <bmap>
80101b94:	83 ec 08             	sub    $0x8,%esp
80101b97:	50                   	push   %eax
80101b98:	ff 37                	pushl  (%edi)
80101b9a:	e8 31 e5 ff ff       	call   801000d0 <bread>
80101b9f:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ba1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ba4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101ba7:	89 f1                	mov    %esi,%ecx
80101ba9:	83 c4 0c             	add    $0xc,%esp
80101bac:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101bb2:	29 cb                	sub    %ecx,%ebx
80101bb4:	39 c3                	cmp    %eax,%ebx
80101bb6:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bb9:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101bbd:	53                   	push   %ebx
80101bbe:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bc1:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101bc3:	50                   	push   %eax
80101bc4:	e8 c7 29 00 00       	call   80104590 <memmove>
    log_write(bp);
80101bc9:	89 3c 24             	mov    %edi,(%esp)
80101bcc:	e8 2f 12 00 00       	call   80102e00 <log_write>
    brelse(bp);
80101bd1:	89 3c 24             	mov    %edi,(%esp)
80101bd4:	e8 07 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bd9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101bdc:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101bdf:	83 c4 10             	add    $0x10,%esp
80101be2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101be5:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101be8:	77 96                	ja     80101b80 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101bea:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bed:	3b 70 58             	cmp    0x58(%eax),%esi
80101bf0:	77 36                	ja     80101c28 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101bf2:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101bf5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bf8:	5b                   	pop    %ebx
80101bf9:	5e                   	pop    %esi
80101bfa:	5f                   	pop    %edi
80101bfb:	5d                   	pop    %ebp
80101bfc:	c3                   	ret    
80101bfd:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c00:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c04:	66 83 f8 09          	cmp    $0x9,%ax
80101c08:	77 36                	ja     80101c40 <writei+0x120>
80101c0a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101c11:	85 c0                	test   %eax,%eax
80101c13:	74 2b                	je     80101c40 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101c15:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101c18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c1b:	5b                   	pop    %ebx
80101c1c:	5e                   	pop    %esi
80101c1d:	5f                   	pop    %edi
80101c1e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101c1f:	ff e0                	jmp    *%eax
80101c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101c28:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c2b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101c2e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c31:	50                   	push   %eax
80101c32:	e8 59 fa ff ff       	call   80101690 <iupdate>
80101c37:	83 c4 10             	add    $0x10,%esp
80101c3a:	eb b6                	jmp    80101bf2 <writei+0xd2>
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c45:	eb ae                	jmp    80101bf5 <writei+0xd5>
80101c47:	89 f6                	mov    %esi,%esi
80101c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c50 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c56:	6a 0e                	push   $0xe
80101c58:	ff 75 0c             	pushl  0xc(%ebp)
80101c5b:	ff 75 08             	pushl  0x8(%ebp)
80101c5e:	e8 ad 29 00 00       	call   80104610 <strncmp>
}
80101c63:	c9                   	leave  
80101c64:	c3                   	ret    
80101c65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c70 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	57                   	push   %edi
80101c74:	56                   	push   %esi
80101c75:	53                   	push   %ebx
80101c76:	83 ec 1c             	sub    $0x1c,%esp
80101c79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c7c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c81:	0f 85 80 00 00 00    	jne    80101d07 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c87:	8b 53 58             	mov    0x58(%ebx),%edx
80101c8a:	31 ff                	xor    %edi,%edi
80101c8c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c8f:	85 d2                	test   %edx,%edx
80101c91:	75 0d                	jne    80101ca0 <dirlookup+0x30>
80101c93:	eb 5b                	jmp    80101cf0 <dirlookup+0x80>
80101c95:	8d 76 00             	lea    0x0(%esi),%esi
80101c98:	83 c7 10             	add    $0x10,%edi
80101c9b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101c9e:	76 50                	jbe    80101cf0 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ca0:	6a 10                	push   $0x10
80101ca2:	57                   	push   %edi
80101ca3:	56                   	push   %esi
80101ca4:	53                   	push   %ebx
80101ca5:	e8 76 fd ff ff       	call   80101a20 <readi>
80101caa:	83 c4 10             	add    $0x10,%esp
80101cad:	83 f8 10             	cmp    $0x10,%eax
80101cb0:	75 48                	jne    80101cfa <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101cb2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cb7:	74 df                	je     80101c98 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101cb9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cbc:	83 ec 04             	sub    $0x4,%esp
80101cbf:	6a 0e                	push   $0xe
80101cc1:	50                   	push   %eax
80101cc2:	ff 75 0c             	pushl  0xc(%ebp)
80101cc5:	e8 46 29 00 00       	call   80104610 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101cca:	83 c4 10             	add    $0x10,%esp
80101ccd:	85 c0                	test   %eax,%eax
80101ccf:	75 c7                	jne    80101c98 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101cd1:	8b 45 10             	mov    0x10(%ebp),%eax
80101cd4:	85 c0                	test   %eax,%eax
80101cd6:	74 05                	je     80101cdd <dirlookup+0x6d>
        *poff = off;
80101cd8:	8b 45 10             	mov    0x10(%ebp),%eax
80101cdb:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101cdd:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101ce1:	8b 03                	mov    (%ebx),%eax
80101ce3:	e8 f8 f5 ff ff       	call   801012e0 <iget>
    }
  }

  return 0;
}
80101ce8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ceb:	5b                   	pop    %ebx
80101cec:	5e                   	pop    %esi
80101ced:	5f                   	pop    %edi
80101cee:	5d                   	pop    %ebp
80101cef:	c3                   	ret    
80101cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101cf3:	31 c0                	xor    %eax,%eax
}
80101cf5:	5b                   	pop    %ebx
80101cf6:	5e                   	pop    %esi
80101cf7:	5f                   	pop    %edi
80101cf8:	5d                   	pop    %ebp
80101cf9:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101cfa:	83 ec 0c             	sub    $0xc,%esp
80101cfd:	68 68 73 10 80       	push   $0x80107368
80101d02:	e8 69 e6 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101d07:	83 ec 0c             	sub    $0xc,%esp
80101d0a:	68 56 73 10 80       	push   $0x80107356
80101d0f:	e8 5c e6 ff ff       	call   80100370 <panic>
80101d14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101d20 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d20:	55                   	push   %ebp
80101d21:	89 e5                	mov    %esp,%ebp
80101d23:	57                   	push   %edi
80101d24:	56                   	push   %esi
80101d25:	53                   	push   %ebx
80101d26:	89 cf                	mov    %ecx,%edi
80101d28:	89 c3                	mov    %eax,%ebx
80101d2a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d2d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d30:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101d33:	0f 84 53 01 00 00    	je     80101e8c <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d39:	e8 12 1b 00 00       	call   80103850 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101d3e:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d41:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101d44:	68 e0 09 11 80       	push   $0x801109e0
80101d49:	e8 22 26 00 00       	call   80104370 <acquire>
  ip->ref++;
80101d4e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d52:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101d59:	e8 32 27 00 00       	call   80104490 <release>
80101d5e:	83 c4 10             	add    $0x10,%esp
80101d61:	eb 08                	jmp    80101d6b <namex+0x4b>
80101d63:	90                   	nop
80101d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101d68:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101d6b:	0f b6 03             	movzbl (%ebx),%eax
80101d6e:	3c 2f                	cmp    $0x2f,%al
80101d70:	74 f6                	je     80101d68 <namex+0x48>
    path++;
  if(*path == 0)
80101d72:	84 c0                	test   %al,%al
80101d74:	0f 84 e3 00 00 00    	je     80101e5d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d7a:	0f b6 03             	movzbl (%ebx),%eax
80101d7d:	89 da                	mov    %ebx,%edx
80101d7f:	84 c0                	test   %al,%al
80101d81:	0f 84 ac 00 00 00    	je     80101e33 <namex+0x113>
80101d87:	3c 2f                	cmp    $0x2f,%al
80101d89:	75 09                	jne    80101d94 <namex+0x74>
80101d8b:	e9 a3 00 00 00       	jmp    80101e33 <namex+0x113>
80101d90:	84 c0                	test   %al,%al
80101d92:	74 0a                	je     80101d9e <namex+0x7e>
    path++;
80101d94:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d97:	0f b6 02             	movzbl (%edx),%eax
80101d9a:	3c 2f                	cmp    $0x2f,%al
80101d9c:	75 f2                	jne    80101d90 <namex+0x70>
80101d9e:	89 d1                	mov    %edx,%ecx
80101da0:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101da2:	83 f9 0d             	cmp    $0xd,%ecx
80101da5:	0f 8e 8d 00 00 00    	jle    80101e38 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101dab:	83 ec 04             	sub    $0x4,%esp
80101dae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101db1:	6a 0e                	push   $0xe
80101db3:	53                   	push   %ebx
80101db4:	57                   	push   %edi
80101db5:	e8 d6 27 00 00       	call   80104590 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101dba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101dbd:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101dc0:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101dc2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101dc5:	75 11                	jne    80101dd8 <namex+0xb8>
80101dc7:	89 f6                	mov    %esi,%esi
80101dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101dd0:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101dd3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101dd6:	74 f8                	je     80101dd0 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101dd8:	83 ec 0c             	sub    $0xc,%esp
80101ddb:	56                   	push   %esi
80101ddc:	e8 5f f9 ff ff       	call   80101740 <ilock>
    if(ip->type != T_DIR){
80101de1:	83 c4 10             	add    $0x10,%esp
80101de4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101de9:	0f 85 7f 00 00 00    	jne    80101e6e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101def:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101df2:	85 d2                	test   %edx,%edx
80101df4:	74 09                	je     80101dff <namex+0xdf>
80101df6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101df9:	0f 84 a3 00 00 00    	je     80101ea2 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101dff:	83 ec 04             	sub    $0x4,%esp
80101e02:	6a 00                	push   $0x0
80101e04:	57                   	push   %edi
80101e05:	56                   	push   %esi
80101e06:	e8 65 fe ff ff       	call   80101c70 <dirlookup>
80101e0b:	83 c4 10             	add    $0x10,%esp
80101e0e:	85 c0                	test   %eax,%eax
80101e10:	74 5c                	je     80101e6e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101e12:	83 ec 0c             	sub    $0xc,%esp
80101e15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101e18:	56                   	push   %esi
80101e19:	e8 02 fa ff ff       	call   80101820 <iunlock>
  iput(ip);
80101e1e:	89 34 24             	mov    %esi,(%esp)
80101e21:	e8 4a fa ff ff       	call   80101870 <iput>
80101e26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e29:	83 c4 10             	add    $0x10,%esp
80101e2c:	89 c6                	mov    %eax,%esi
80101e2e:	e9 38 ff ff ff       	jmp    80101d6b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101e33:	31 c9                	xor    %ecx,%ecx
80101e35:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101e38:	83 ec 04             	sub    $0x4,%esp
80101e3b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e3e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101e41:	51                   	push   %ecx
80101e42:	53                   	push   %ebx
80101e43:	57                   	push   %edi
80101e44:	e8 47 27 00 00       	call   80104590 <memmove>
    name[len] = 0;
80101e49:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101e4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e4f:	83 c4 10             	add    $0x10,%esp
80101e52:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101e56:	89 d3                	mov    %edx,%ebx
80101e58:	e9 65 ff ff ff       	jmp    80101dc2 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e60:	85 c0                	test   %eax,%eax
80101e62:	75 54                	jne    80101eb8 <namex+0x198>
80101e64:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101e66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e69:	5b                   	pop    %ebx
80101e6a:	5e                   	pop    %esi
80101e6b:	5f                   	pop    %edi
80101e6c:	5d                   	pop    %ebp
80101e6d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101e6e:	83 ec 0c             	sub    $0xc,%esp
80101e71:	56                   	push   %esi
80101e72:	e8 a9 f9 ff ff       	call   80101820 <iunlock>
  iput(ip);
80101e77:	89 34 24             	mov    %esi,(%esp)
80101e7a:	e8 f1 f9 ff ff       	call   80101870 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101e7f:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e82:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101e85:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e87:	5b                   	pop    %ebx
80101e88:	5e                   	pop    %esi
80101e89:	5f                   	pop    %edi
80101e8a:	5d                   	pop    %ebp
80101e8b:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101e8c:	ba 01 00 00 00       	mov    $0x1,%edx
80101e91:	b8 01 00 00 00       	mov    $0x1,%eax
80101e96:	e8 45 f4 ff ff       	call   801012e0 <iget>
80101e9b:	89 c6                	mov    %eax,%esi
80101e9d:	e9 c9 fe ff ff       	jmp    80101d6b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101ea2:	83 ec 0c             	sub    $0xc,%esp
80101ea5:	56                   	push   %esi
80101ea6:	e8 75 f9 ff ff       	call   80101820 <iunlock>
      return ip;
80101eab:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101eae:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101eb1:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101eb3:	5b                   	pop    %ebx
80101eb4:	5e                   	pop    %esi
80101eb5:	5f                   	pop    %edi
80101eb6:	5d                   	pop    %ebp
80101eb7:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101eb8:	83 ec 0c             	sub    $0xc,%esp
80101ebb:	56                   	push   %esi
80101ebc:	e8 af f9 ff ff       	call   80101870 <iput>
    return 0;
80101ec1:	83 c4 10             	add    $0x10,%esp
80101ec4:	31 c0                	xor    %eax,%eax
80101ec6:	eb 9e                	jmp    80101e66 <namex+0x146>
80101ec8:	90                   	nop
80101ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ed0 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101ed0:	55                   	push   %ebp
80101ed1:	89 e5                	mov    %esp,%ebp
80101ed3:	57                   	push   %edi
80101ed4:	56                   	push   %esi
80101ed5:	53                   	push   %ebx
80101ed6:	83 ec 20             	sub    $0x20,%esp
80101ed9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101edc:	6a 00                	push   $0x0
80101ede:	ff 75 0c             	pushl  0xc(%ebp)
80101ee1:	53                   	push   %ebx
80101ee2:	e8 89 fd ff ff       	call   80101c70 <dirlookup>
80101ee7:	83 c4 10             	add    $0x10,%esp
80101eea:	85 c0                	test   %eax,%eax
80101eec:	75 67                	jne    80101f55 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101eee:	8b 7b 58             	mov    0x58(%ebx),%edi
80101ef1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ef4:	85 ff                	test   %edi,%edi
80101ef6:	74 29                	je     80101f21 <dirlink+0x51>
80101ef8:	31 ff                	xor    %edi,%edi
80101efa:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101efd:	eb 09                	jmp    80101f08 <dirlink+0x38>
80101eff:	90                   	nop
80101f00:	83 c7 10             	add    $0x10,%edi
80101f03:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101f06:	76 19                	jbe    80101f21 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f08:	6a 10                	push   $0x10
80101f0a:	57                   	push   %edi
80101f0b:	56                   	push   %esi
80101f0c:	53                   	push   %ebx
80101f0d:	e8 0e fb ff ff       	call   80101a20 <readi>
80101f12:	83 c4 10             	add    $0x10,%esp
80101f15:	83 f8 10             	cmp    $0x10,%eax
80101f18:	75 4e                	jne    80101f68 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101f1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f1f:	75 df                	jne    80101f00 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101f21:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f24:	83 ec 04             	sub    $0x4,%esp
80101f27:	6a 0e                	push   $0xe
80101f29:	ff 75 0c             	pushl  0xc(%ebp)
80101f2c:	50                   	push   %eax
80101f2d:	e8 4e 27 00 00       	call   80104680 <strncpy>
  de.inum = inum;
80101f32:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f35:	6a 10                	push   $0x10
80101f37:	57                   	push   %edi
80101f38:	56                   	push   %esi
80101f39:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101f3a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f3e:	e8 dd fb ff ff       	call   80101b20 <writei>
80101f43:	83 c4 20             	add    $0x20,%esp
80101f46:	83 f8 10             	cmp    $0x10,%eax
80101f49:	75 2a                	jne    80101f75 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101f4b:	31 c0                	xor    %eax,%eax
}
80101f4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f50:	5b                   	pop    %ebx
80101f51:	5e                   	pop    %esi
80101f52:	5f                   	pop    %edi
80101f53:	5d                   	pop    %ebp
80101f54:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101f55:	83 ec 0c             	sub    $0xc,%esp
80101f58:	50                   	push   %eax
80101f59:	e8 12 f9 ff ff       	call   80101870 <iput>
    return -1;
80101f5e:	83 c4 10             	add    $0x10,%esp
80101f61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f66:	eb e5                	jmp    80101f4d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101f68:	83 ec 0c             	sub    $0xc,%esp
80101f6b:	68 77 73 10 80       	push   $0x80107377
80101f70:	e8 fb e3 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101f75:	83 ec 0c             	sub    $0xc,%esp
80101f78:	68 66 79 10 80       	push   $0x80107966
80101f7d:	e8 ee e3 ff ff       	call   80100370 <panic>
80101f82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f90 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101f90:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f91:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101f93:	89 e5                	mov    %esp,%ebp
80101f95:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f98:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f9e:	e8 7d fd ff ff       	call   80101d20 <namex>
}
80101fa3:	c9                   	leave  
80101fa4:	c3                   	ret    
80101fa5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fb0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101fb0:	55                   	push   %ebp
  return namex(path, 1, name);
80101fb1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101fb6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101fb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101fbb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101fbe:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101fbf:	e9 5c fd ff ff       	jmp    80101d20 <namex>
80101fc4:	66 90                	xchg   %ax,%ax
80101fc6:	66 90                	xchg   %ax,%ax
80101fc8:	66 90                	xchg   %ax,%ax
80101fca:	66 90                	xchg   %ax,%ax
80101fcc:	66 90                	xchg   %ax,%ax
80101fce:	66 90                	xchg   %ax,%ax

80101fd0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101fd0:	55                   	push   %ebp
  if(b == 0)
80101fd1:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101fd3:	89 e5                	mov    %esp,%ebp
80101fd5:	56                   	push   %esi
80101fd6:	53                   	push   %ebx
  if(b == 0)
80101fd7:	0f 84 ad 00 00 00    	je     8010208a <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101fdd:	8b 58 08             	mov    0x8(%eax),%ebx
80101fe0:	89 c1                	mov    %eax,%ecx
80101fe2:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101fe8:	0f 87 8f 00 00 00    	ja     8010207d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fee:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ff3:	90                   	nop
80101ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ff8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101ff9:	83 e0 c0             	and    $0xffffffc0,%eax
80101ffc:	3c 40                	cmp    $0x40,%al
80101ffe:	75 f8                	jne    80101ff8 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102000:	31 f6                	xor    %esi,%esi
80102002:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102007:	89 f0                	mov    %esi,%eax
80102009:	ee                   	out    %al,(%dx)
8010200a:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010200f:	b8 01 00 00 00       	mov    $0x1,%eax
80102014:	ee                   	out    %al,(%dx)
80102015:	ba f3 01 00 00       	mov    $0x1f3,%edx
8010201a:	89 d8                	mov    %ebx,%eax
8010201c:	ee                   	out    %al,(%dx)
8010201d:	89 d8                	mov    %ebx,%eax
8010201f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102024:	c1 f8 08             	sar    $0x8,%eax
80102027:	ee                   	out    %al,(%dx)
80102028:	ba f5 01 00 00       	mov    $0x1f5,%edx
8010202d:	89 f0                	mov    %esi,%eax
8010202f:	ee                   	out    %al,(%dx)
80102030:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80102034:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102039:	83 e0 01             	and    $0x1,%eax
8010203c:	c1 e0 04             	shl    $0x4,%eax
8010203f:	83 c8 e0             	or     $0xffffffe0,%eax
80102042:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80102043:	f6 01 04             	testb  $0x4,(%ecx)
80102046:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010204b:	75 13                	jne    80102060 <idestart+0x90>
8010204d:	b8 20 00 00 00       	mov    $0x20,%eax
80102052:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102053:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102056:	5b                   	pop    %ebx
80102057:	5e                   	pop    %esi
80102058:	5d                   	pop    %ebp
80102059:	c3                   	ret    
8010205a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102060:	b8 30 00 00 00       	mov    $0x30,%eax
80102065:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80102066:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
8010206b:	8d 71 5c             	lea    0x5c(%ecx),%esi
8010206e:	b9 80 00 00 00       	mov    $0x80,%ecx
80102073:	fc                   	cld    
80102074:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102076:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102079:	5b                   	pop    %ebx
8010207a:	5e                   	pop    %esi
8010207b:	5d                   	pop    %ebp
8010207c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
8010207d:	83 ec 0c             	sub    $0xc,%esp
80102080:	68 e0 73 10 80       	push   $0x801073e0
80102085:	e8 e6 e2 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
8010208a:	83 ec 0c             	sub    $0xc,%esp
8010208d:	68 d7 73 10 80       	push   $0x801073d7
80102092:	e8 d9 e2 ff ff       	call   80100370 <panic>
80102097:	89 f6                	mov    %esi,%esi
80102099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801020a0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
801020a0:	55                   	push   %ebp
801020a1:	89 e5                	mov    %esp,%ebp
801020a3:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
801020a6:	68 f2 73 10 80       	push   $0x801073f2
801020ab:	68 80 a5 10 80       	push   $0x8010a580
801020b0:	e8 bb 21 00 00       	call   80104270 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801020b5:	58                   	pop    %eax
801020b6:	a1 00 2d 11 80       	mov    0x80112d00,%eax
801020bb:	5a                   	pop    %edx
801020bc:	83 e8 01             	sub    $0x1,%eax
801020bf:	50                   	push   %eax
801020c0:	6a 0e                	push   $0xe
801020c2:	e8 a9 02 00 00       	call   80102370 <ioapicenable>
801020c7:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020ca:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020cf:	90                   	nop
801020d0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020d1:	83 e0 c0             	and    $0xffffffc0,%eax
801020d4:	3c 40                	cmp    $0x40,%al
801020d6:	75 f8                	jne    801020d0 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020d8:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020dd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801020e2:	ee                   	out    %al,(%dx)
801020e3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020e8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020ed:	eb 06                	jmp    801020f5 <ideinit+0x55>
801020ef:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801020f0:	83 e9 01             	sub    $0x1,%ecx
801020f3:	74 0f                	je     80102104 <ideinit+0x64>
801020f5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801020f6:	84 c0                	test   %al,%al
801020f8:	74 f6                	je     801020f0 <ideinit+0x50>
      havedisk1 = 1;
801020fa:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102101:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102104:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102109:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010210e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010210f:	c9                   	leave  
80102110:	c3                   	ret    
80102111:	eb 0d                	jmp    80102120 <ideintr>
80102113:	90                   	nop
80102114:	90                   	nop
80102115:	90                   	nop
80102116:	90                   	nop
80102117:	90                   	nop
80102118:	90                   	nop
80102119:	90                   	nop
8010211a:	90                   	nop
8010211b:	90                   	nop
8010211c:	90                   	nop
8010211d:	90                   	nop
8010211e:	90                   	nop
8010211f:	90                   	nop

80102120 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102120:	55                   	push   %ebp
80102121:	89 e5                	mov    %esp,%ebp
80102123:	57                   	push   %edi
80102124:	56                   	push   %esi
80102125:	53                   	push   %ebx
80102126:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102129:	68 80 a5 10 80       	push   $0x8010a580
8010212e:	e8 3d 22 00 00       	call   80104370 <acquire>

  if((b = idequeue) == 0){
80102133:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102139:	83 c4 10             	add    $0x10,%esp
8010213c:	85 db                	test   %ebx,%ebx
8010213e:	74 34                	je     80102174 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102140:	8b 43 58             	mov    0x58(%ebx),%eax
80102143:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102148:	8b 33                	mov    (%ebx),%esi
8010214a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102150:	74 3e                	je     80102190 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102152:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102155:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102158:	83 ce 02             	or     $0x2,%esi
8010215b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010215d:	53                   	push   %ebx
8010215e:	e8 4d 1e 00 00       	call   80103fb0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102163:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102168:	83 c4 10             	add    $0x10,%esp
8010216b:	85 c0                	test   %eax,%eax
8010216d:	74 05                	je     80102174 <ideintr+0x54>
    idestart(idequeue);
8010216f:	e8 5c fe ff ff       	call   80101fd0 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
80102174:	83 ec 0c             	sub    $0xc,%esp
80102177:	68 80 a5 10 80       	push   $0x8010a580
8010217c:	e8 0f 23 00 00       	call   80104490 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
80102181:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102184:	5b                   	pop    %ebx
80102185:	5e                   	pop    %esi
80102186:	5f                   	pop    %edi
80102187:	5d                   	pop    %ebp
80102188:	c3                   	ret    
80102189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102190:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102195:	8d 76 00             	lea    0x0(%esi),%esi
80102198:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102199:	89 c1                	mov    %eax,%ecx
8010219b:	83 e1 c0             	and    $0xffffffc0,%ecx
8010219e:	80 f9 40             	cmp    $0x40,%cl
801021a1:	75 f5                	jne    80102198 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801021a3:	a8 21                	test   $0x21,%al
801021a5:	75 ab                	jne    80102152 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801021a7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801021aa:	b9 80 00 00 00       	mov    $0x80,%ecx
801021af:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021b4:	fc                   	cld    
801021b5:	f3 6d                	rep insl (%dx),%es:(%edi)
801021b7:	8b 33                	mov    (%ebx),%esi
801021b9:	eb 97                	jmp    80102152 <ideintr+0x32>
801021bb:	90                   	nop
801021bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801021c0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	53                   	push   %ebx
801021c4:	83 ec 10             	sub    $0x10,%esp
801021c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801021ca:	8d 43 0c             	lea    0xc(%ebx),%eax
801021cd:	50                   	push   %eax
801021ce:	e8 6d 20 00 00       	call   80104240 <holdingsleep>
801021d3:	83 c4 10             	add    $0x10,%esp
801021d6:	85 c0                	test   %eax,%eax
801021d8:	0f 84 ad 00 00 00    	je     8010228b <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801021de:	8b 03                	mov    (%ebx),%eax
801021e0:	83 e0 06             	and    $0x6,%eax
801021e3:	83 f8 02             	cmp    $0x2,%eax
801021e6:	0f 84 b9 00 00 00    	je     801022a5 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801021ec:	8b 53 04             	mov    0x4(%ebx),%edx
801021ef:	85 d2                	test   %edx,%edx
801021f1:	74 0d                	je     80102200 <iderw+0x40>
801021f3:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801021f8:	85 c0                	test   %eax,%eax
801021fa:	0f 84 98 00 00 00    	je     80102298 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102200:	83 ec 0c             	sub    $0xc,%esp
80102203:	68 80 a5 10 80       	push   $0x8010a580
80102208:	e8 63 21 00 00       	call   80104370 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010220d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102213:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102216:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010221d:	85 d2                	test   %edx,%edx
8010221f:	75 09                	jne    8010222a <iderw+0x6a>
80102221:	eb 58                	jmp    8010227b <iderw+0xbb>
80102223:	90                   	nop
80102224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102228:	89 c2                	mov    %eax,%edx
8010222a:	8b 42 58             	mov    0x58(%edx),%eax
8010222d:	85 c0                	test   %eax,%eax
8010222f:	75 f7                	jne    80102228 <iderw+0x68>
80102231:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102234:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102236:	3b 1d 64 a5 10 80    	cmp    0x8010a564,%ebx
8010223c:	74 44                	je     80102282 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010223e:	8b 03                	mov    (%ebx),%eax
80102240:	83 e0 06             	and    $0x6,%eax
80102243:	83 f8 02             	cmp    $0x2,%eax
80102246:	74 23                	je     8010226b <iderw+0xab>
80102248:	90                   	nop
80102249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102250:	83 ec 08             	sub    $0x8,%esp
80102253:	68 80 a5 10 80       	push   $0x8010a580
80102258:	53                   	push   %ebx
80102259:	e8 a2 1b 00 00       	call   80103e00 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010225e:	8b 03                	mov    (%ebx),%eax
80102260:	83 c4 10             	add    $0x10,%esp
80102263:	83 e0 06             	and    $0x6,%eax
80102266:	83 f8 02             	cmp    $0x2,%eax
80102269:	75 e5                	jne    80102250 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
8010226b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102272:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102275:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
80102276:	e9 15 22 00 00       	jmp    80104490 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010227b:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102280:	eb b2                	jmp    80102234 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102282:	89 d8                	mov    %ebx,%eax
80102284:	e8 47 fd ff ff       	call   80101fd0 <idestart>
80102289:	eb b3                	jmp    8010223e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010228b:	83 ec 0c             	sub    $0xc,%esp
8010228e:	68 f6 73 10 80       	push   $0x801073f6
80102293:	e8 d8 e0 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102298:	83 ec 0c             	sub    $0xc,%esp
8010229b:	68 21 74 10 80       	push   $0x80107421
801022a0:	e8 cb e0 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801022a5:	83 ec 0c             	sub    $0xc,%esp
801022a8:	68 0c 74 10 80       	push   $0x8010740c
801022ad:	e8 be e0 ff ff       	call   80100370 <panic>
801022b2:	66 90                	xchg   %ax,%ax
801022b4:	66 90                	xchg   %ax,%ax
801022b6:	66 90                	xchg   %ax,%ax
801022b8:	66 90                	xchg   %ax,%ax
801022ba:	66 90                	xchg   %ax,%ax
801022bc:	66 90                	xchg   %ax,%ax
801022be:	66 90                	xchg   %ax,%ax

801022c0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801022c0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801022c1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801022c8:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
801022cb:	89 e5                	mov    %esp,%ebp
801022cd:	56                   	push   %esi
801022ce:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801022cf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801022d6:	00 00 00 
  return ioapic->data;
801022d9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801022df:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801022e2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801022e8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801022ee:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801022f5:	89 f0                	mov    %esi,%eax
801022f7:	c1 e8 10             	shr    $0x10,%eax
801022fa:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
801022fd:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102300:	c1 e8 18             	shr    $0x18,%eax
80102303:	39 d0                	cmp    %edx,%eax
80102305:	74 16                	je     8010231d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102307:	83 ec 0c             	sub    $0xc,%esp
8010230a:	68 40 74 10 80       	push   $0x80107440
8010230f:	e8 4c e3 ff ff       	call   80100660 <cprintf>
80102314:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010231a:	83 c4 10             	add    $0x10,%esp
8010231d:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102320:	ba 10 00 00 00       	mov    $0x10,%edx
80102325:	b8 20 00 00 00       	mov    $0x20,%eax
8010232a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102330:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102332:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102338:	89 c3                	mov    %eax,%ebx
8010233a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102340:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102343:	89 59 10             	mov    %ebx,0x10(%ecx)
80102346:	8d 5a 01             	lea    0x1(%edx),%ebx
80102349:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010234c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010234e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102350:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102356:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010235d:	75 d1                	jne    80102330 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010235f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102362:	5b                   	pop    %ebx
80102363:	5e                   	pop    %esi
80102364:	5d                   	pop    %ebp
80102365:	c3                   	ret    
80102366:	8d 76 00             	lea    0x0(%esi),%esi
80102369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102370 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102370:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102371:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102377:	89 e5                	mov    %esp,%ebp
80102379:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010237c:	8d 50 20             	lea    0x20(%eax),%edx
8010237f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102383:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102385:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010238b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010238e:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102391:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102394:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102396:	a1 34 26 11 80       	mov    0x80112634,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010239b:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
8010239e:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801023a1:	5d                   	pop    %ebp
801023a2:	c3                   	ret    
801023a3:	66 90                	xchg   %ax,%ax
801023a5:	66 90                	xchg   %ax,%ax
801023a7:	66 90                	xchg   %ax,%ax
801023a9:	66 90                	xchg   %ax,%ax
801023ab:	66 90                	xchg   %ax,%ax
801023ad:	66 90                	xchg   %ax,%ax
801023af:	90                   	nop

801023b0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801023b0:	55                   	push   %ebp
801023b1:	89 e5                	mov    %esp,%ebp
801023b3:	53                   	push   %ebx
801023b4:	83 ec 04             	sub    $0x4,%esp
801023b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801023ba:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801023c0:	75 70                	jne    80102432 <kfree+0x82>
801023c2:	81 fb f4 58 11 80    	cmp    $0x801158f4,%ebx
801023c8:	72 68                	jb     80102432 <kfree+0x82>
801023ca:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801023d0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801023d5:	77 5b                	ja     80102432 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801023d7:	83 ec 04             	sub    $0x4,%esp
801023da:	68 00 10 00 00       	push   $0x1000
801023df:	6a 01                	push   $0x1
801023e1:	53                   	push   %ebx
801023e2:	e8 f9 20 00 00       	call   801044e0 <memset>

  if(kmem.use_lock)
801023e7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801023ed:	83 c4 10             	add    $0x10,%esp
801023f0:	85 d2                	test   %edx,%edx
801023f2:	75 2c                	jne    80102420 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801023f4:	a1 78 26 11 80       	mov    0x80112678,%eax
801023f9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801023fb:	a1 74 26 11 80       	mov    0x80112674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102400:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102406:	85 c0                	test   %eax,%eax
80102408:	75 06                	jne    80102410 <kfree+0x60>
    release(&kmem.lock);
}
8010240a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010240d:	c9                   	leave  
8010240e:	c3                   	ret    
8010240f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102410:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102417:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010241a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010241b:	e9 70 20 00 00       	jmp    80104490 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102420:	83 ec 0c             	sub    $0xc,%esp
80102423:	68 40 26 11 80       	push   $0x80112640
80102428:	e8 43 1f 00 00       	call   80104370 <acquire>
8010242d:	83 c4 10             	add    $0x10,%esp
80102430:	eb c2                	jmp    801023f4 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102432:	83 ec 0c             	sub    $0xc,%esp
80102435:	68 72 74 10 80       	push   $0x80107472
8010243a:	e8 31 df ff ff       	call   80100370 <panic>
8010243f:	90                   	nop

80102440 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	56                   	push   %esi
80102444:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102445:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102448:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010244b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102451:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102457:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010245d:	39 de                	cmp    %ebx,%esi
8010245f:	72 23                	jb     80102484 <freerange+0x44>
80102461:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102468:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010246e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102471:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102477:	50                   	push   %eax
80102478:	e8 33 ff ff ff       	call   801023b0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010247d:	83 c4 10             	add    $0x10,%esp
80102480:	39 f3                	cmp    %esi,%ebx
80102482:	76 e4                	jbe    80102468 <freerange+0x28>
    kfree(p);
}
80102484:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102487:	5b                   	pop    %ebx
80102488:	5e                   	pop    %esi
80102489:	5d                   	pop    %ebp
8010248a:	c3                   	ret    
8010248b:	90                   	nop
8010248c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102490 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	56                   	push   %esi
80102494:	53                   	push   %ebx
80102495:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102498:	83 ec 08             	sub    $0x8,%esp
8010249b:	68 78 74 10 80       	push   $0x80107478
801024a0:	68 40 26 11 80       	push   $0x80112640
801024a5:	e8 c6 1d 00 00       	call   80104270 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801024aa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024ad:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801024b0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801024b7:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801024ba:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801024c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024c6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801024cc:	39 de                	cmp    %ebx,%esi
801024ce:	72 1c                	jb     801024ec <kinit1+0x5c>
    kfree(p);
801024d0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801024d6:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024df:	50                   	push   %eax
801024e0:	e8 cb fe ff ff       	call   801023b0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024e5:	83 c4 10             	add    $0x10,%esp
801024e8:	39 de                	cmp    %ebx,%esi
801024ea:	73 e4                	jae    801024d0 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
801024ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024ef:	5b                   	pop    %ebx
801024f0:	5e                   	pop    %esi
801024f1:	5d                   	pop    %ebp
801024f2:	c3                   	ret    
801024f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801024f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102500 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102500:	55                   	push   %ebp
80102501:	89 e5                	mov    %esp,%ebp
80102503:	56                   	push   %esi
80102504:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102505:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102508:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010250b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102511:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102517:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010251d:	39 de                	cmp    %ebx,%esi
8010251f:	72 23                	jb     80102544 <kinit2+0x44>
80102521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102528:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010252e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102531:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102537:	50                   	push   %eax
80102538:	e8 73 fe ff ff       	call   801023b0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	39 de                	cmp    %ebx,%esi
80102542:	73 e4                	jae    80102528 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102544:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010254b:	00 00 00 
}
8010254e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102551:	5b                   	pop    %ebx
80102552:	5e                   	pop    %esi
80102553:	5d                   	pop    %ebp
80102554:	c3                   	ret    
80102555:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102560 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	53                   	push   %ebx
80102564:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102567:	a1 74 26 11 80       	mov    0x80112674,%eax
8010256c:	85 c0                	test   %eax,%eax
8010256e:	75 30                	jne    801025a0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102570:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102576:	85 db                	test   %ebx,%ebx
80102578:	74 1c                	je     80102596 <kalloc+0x36>
    kmem.freelist = r->next;
8010257a:	8b 13                	mov    (%ebx),%edx
8010257c:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
80102582:	85 c0                	test   %eax,%eax
80102584:	74 10                	je     80102596 <kalloc+0x36>
    release(&kmem.lock);
80102586:	83 ec 0c             	sub    $0xc,%esp
80102589:	68 40 26 11 80       	push   $0x80112640
8010258e:	e8 fd 1e 00 00       	call   80104490 <release>
80102593:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
80102596:	89 d8                	mov    %ebx,%eax
80102598:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010259b:	c9                   	leave  
8010259c:	c3                   	ret    
8010259d:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801025a0:	83 ec 0c             	sub    $0xc,%esp
801025a3:	68 40 26 11 80       	push   $0x80112640
801025a8:	e8 c3 1d 00 00       	call   80104370 <acquire>
  r = kmem.freelist;
801025ad:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801025b3:	83 c4 10             	add    $0x10,%esp
801025b6:	a1 74 26 11 80       	mov    0x80112674,%eax
801025bb:	85 db                	test   %ebx,%ebx
801025bd:	75 bb                	jne    8010257a <kalloc+0x1a>
801025bf:	eb c1                	jmp    80102582 <kalloc+0x22>
801025c1:	66 90                	xchg   %ax,%ax
801025c3:	66 90                	xchg   %ax,%ax
801025c5:	66 90                	xchg   %ax,%ax
801025c7:	66 90                	xchg   %ax,%ax
801025c9:	66 90                	xchg   %ax,%ax
801025cb:	66 90                	xchg   %ax,%ax
801025cd:	66 90                	xchg   %ax,%ax
801025cf:	90                   	nop

801025d0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801025d0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801025d1:	ba 64 00 00 00       	mov    $0x64,%edx
801025d6:	89 e5                	mov    %esp,%ebp
801025d8:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801025d9:	a8 01                	test   $0x1,%al
801025db:	0f 84 af 00 00 00    	je     80102690 <kbdgetc+0xc0>
801025e1:	ba 60 00 00 00       	mov    $0x60,%edx
801025e6:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801025e7:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801025ea:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801025f0:	74 7e                	je     80102670 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801025f2:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801025f4:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801025fa:	79 24                	jns    80102620 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801025fc:	f6 c1 40             	test   $0x40,%cl
801025ff:	75 05                	jne    80102606 <kbdgetc+0x36>
80102601:	89 c2                	mov    %eax,%edx
80102603:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102606:	0f b6 82 a0 75 10 80 	movzbl -0x7fef8a60(%edx),%eax
8010260d:	83 c8 40             	or     $0x40,%eax
80102610:	0f b6 c0             	movzbl %al,%eax
80102613:	f7 d0                	not    %eax
80102615:	21 c8                	and    %ecx,%eax
80102617:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010261c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010261e:	5d                   	pop    %ebp
8010261f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102620:	f6 c1 40             	test   $0x40,%cl
80102623:	74 09                	je     8010262e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102625:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102628:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010262b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010262e:	0f b6 82 a0 75 10 80 	movzbl -0x7fef8a60(%edx),%eax
80102635:	09 c1                	or     %eax,%ecx
80102637:	0f b6 82 a0 74 10 80 	movzbl -0x7fef8b60(%edx),%eax
8010263e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102640:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102642:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102648:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010264b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010264e:	8b 04 85 80 74 10 80 	mov    -0x7fef8b80(,%eax,4),%eax
80102655:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102659:	74 c3                	je     8010261e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010265b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010265e:	83 fa 19             	cmp    $0x19,%edx
80102661:	77 1d                	ja     80102680 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102663:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102666:	5d                   	pop    %ebp
80102667:	c3                   	ret    
80102668:	90                   	nop
80102669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102670:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102672:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102679:	5d                   	pop    %ebp
8010267a:	c3                   	ret    
8010267b:	90                   	nop
8010267c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102680:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102683:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
80102686:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
80102687:	83 f9 19             	cmp    $0x19,%ecx
8010268a:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
8010268d:	c3                   	ret    
8010268e:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102690:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102695:	5d                   	pop    %ebp
80102696:	c3                   	ret    
80102697:	89 f6                	mov    %esi,%esi
80102699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026a0 <kbdintr>:

void
kbdintr(void)
{
801026a0:	55                   	push   %ebp
801026a1:	89 e5                	mov    %esp,%ebp
801026a3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801026a6:	68 d0 25 10 80       	push   $0x801025d0
801026ab:	e8 40 e1 ff ff       	call   801007f0 <consoleintr>
}
801026b0:	83 c4 10             	add    $0x10,%esp
801026b3:	c9                   	leave  
801026b4:	c3                   	ret    
801026b5:	66 90                	xchg   %ax,%ax
801026b7:	66 90                	xchg   %ax,%ax
801026b9:	66 90                	xchg   %ax,%ax
801026bb:	66 90                	xchg   %ax,%ax
801026bd:	66 90                	xchg   %ax,%ax
801026bf:	90                   	nop

801026c0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801026c0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801026c5:	55                   	push   %ebp
801026c6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801026c8:	85 c0                	test   %eax,%eax
801026ca:	0f 84 c8 00 00 00    	je     80102798 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801026d7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026da:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026dd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026ea:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026f1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026f4:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026f7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026fe:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102701:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102704:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010270b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010270e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102711:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102718:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010271b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010271e:	8b 50 30             	mov    0x30(%eax),%edx
80102721:	c1 ea 10             	shr    $0x10,%edx
80102724:	80 fa 03             	cmp    $0x3,%dl
80102727:	77 77                	ja     801027a0 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102729:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102730:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102733:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102736:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010273d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102740:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102743:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010274a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010274d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102750:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102757:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010275a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010275d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102764:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102767:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010276a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102771:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102774:	8b 50 20             	mov    0x20(%eax),%edx
80102777:	89 f6                	mov    %esi,%esi
80102779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102780:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102786:	80 e6 10             	and    $0x10,%dh
80102789:	75 f5                	jne    80102780 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010278b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102792:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102795:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102798:	5d                   	pop    %ebp
80102799:	c3                   	ret    
8010279a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027a0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801027a7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801027aa:	8b 50 20             	mov    0x20(%eax),%edx
801027ad:	e9 77 ff ff ff       	jmp    80102729 <lapicinit+0x69>
801027b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027c0 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
801027c0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
801027c5:	55                   	push   %ebp
801027c6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801027c8:	85 c0                	test   %eax,%eax
801027ca:	74 0c                	je     801027d8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801027cc:	8b 40 20             	mov    0x20(%eax),%eax
}
801027cf:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
801027d0:	c1 e8 18             	shr    $0x18,%eax
}
801027d3:	c3                   	ret    
801027d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
801027d8:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
801027da:	5d                   	pop    %ebp
801027db:	c3                   	ret    
801027dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027e0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801027e0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
801027e5:	55                   	push   %ebp
801027e6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801027e8:	85 c0                	test   %eax,%eax
801027ea:	74 0d                	je     801027f9 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027ec:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027f3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f6:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
801027f9:	5d                   	pop    %ebp
801027fa:	c3                   	ret    
801027fb:	90                   	nop
801027fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102800 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102800:	55                   	push   %ebp
80102801:	89 e5                	mov    %esp,%ebp
}
80102803:	5d                   	pop    %ebp
80102804:	c3                   	ret    
80102805:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102810 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102810:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102811:	ba 70 00 00 00       	mov    $0x70,%edx
80102816:	b8 0f 00 00 00       	mov    $0xf,%eax
8010281b:	89 e5                	mov    %esp,%ebp
8010281d:	53                   	push   %ebx
8010281e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102821:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102824:	ee                   	out    %al,(%dx)
80102825:	ba 71 00 00 00       	mov    $0x71,%edx
8010282a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010282f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102830:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102832:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102835:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010283b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010283d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102840:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102843:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102845:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102848:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010284e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102853:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102859:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010285c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102863:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102866:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102869:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102870:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102873:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102876:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010287c:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010287f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102885:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102888:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010288e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102891:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102897:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010289a:	5b                   	pop    %ebx
8010289b:	5d                   	pop    %ebp
8010289c:	c3                   	ret    
8010289d:	8d 76 00             	lea    0x0(%esi),%esi

801028a0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801028a0:	55                   	push   %ebp
801028a1:	ba 70 00 00 00       	mov    $0x70,%edx
801028a6:	b8 0b 00 00 00       	mov    $0xb,%eax
801028ab:	89 e5                	mov    %esp,%ebp
801028ad:	57                   	push   %edi
801028ae:	56                   	push   %esi
801028af:	53                   	push   %ebx
801028b0:	83 ec 4c             	sub    $0x4c,%esp
801028b3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028b4:	ba 71 00 00 00       	mov    $0x71,%edx
801028b9:	ec                   	in     (%dx),%al
801028ba:	83 e0 04             	and    $0x4,%eax
801028bd:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c0:	31 db                	xor    %ebx,%ebx
801028c2:	88 45 b7             	mov    %al,-0x49(%ebp)
801028c5:	bf 70 00 00 00       	mov    $0x70,%edi
801028ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801028d0:	89 d8                	mov    %ebx,%eax
801028d2:	89 fa                	mov    %edi,%edx
801028d4:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d5:	b9 71 00 00 00       	mov    $0x71,%ecx
801028da:	89 ca                	mov    %ecx,%edx
801028dc:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
801028dd:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028e0:	89 fa                	mov    %edi,%edx
801028e2:	89 45 b8             	mov    %eax,-0x48(%ebp)
801028e5:	b8 02 00 00 00       	mov    $0x2,%eax
801028ea:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028eb:	89 ca                	mov    %ecx,%edx
801028ed:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
801028ee:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f1:	89 fa                	mov    %edi,%edx
801028f3:	89 45 bc             	mov    %eax,-0x44(%ebp)
801028f6:	b8 04 00 00 00       	mov    $0x4,%eax
801028fb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028fc:	89 ca                	mov    %ecx,%edx
801028fe:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
801028ff:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102902:	89 fa                	mov    %edi,%edx
80102904:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102907:	b8 07 00 00 00       	mov    $0x7,%eax
8010290c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010290d:	89 ca                	mov    %ecx,%edx
8010290f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102910:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102913:	89 fa                	mov    %edi,%edx
80102915:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102918:	b8 08 00 00 00       	mov    $0x8,%eax
8010291d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010291e:	89 ca                	mov    %ecx,%edx
80102920:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102921:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102924:	89 fa                	mov    %edi,%edx
80102926:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102929:	b8 09 00 00 00       	mov    $0x9,%eax
8010292e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010292f:	89 ca                	mov    %ecx,%edx
80102931:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102932:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102935:	89 fa                	mov    %edi,%edx
80102937:	89 45 cc             	mov    %eax,-0x34(%ebp)
8010293a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010293f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102940:	89 ca                	mov    %ecx,%edx
80102942:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102943:	84 c0                	test   %al,%al
80102945:	78 89                	js     801028d0 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102947:	89 d8                	mov    %ebx,%eax
80102949:	89 fa                	mov    %edi,%edx
8010294b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010294c:	89 ca                	mov    %ecx,%edx
8010294e:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010294f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102952:	89 fa                	mov    %edi,%edx
80102954:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102957:	b8 02 00 00 00       	mov    $0x2,%eax
8010295c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010295d:	89 ca                	mov    %ecx,%edx
8010295f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102960:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102963:	89 fa                	mov    %edi,%edx
80102965:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102968:	b8 04 00 00 00       	mov    $0x4,%eax
8010296d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010296e:	89 ca                	mov    %ecx,%edx
80102970:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102971:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102974:	89 fa                	mov    %edi,%edx
80102976:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102979:	b8 07 00 00 00       	mov    $0x7,%eax
8010297e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010297f:	89 ca                	mov    %ecx,%edx
80102981:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102982:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102985:	89 fa                	mov    %edi,%edx
80102987:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010298a:	b8 08 00 00 00       	mov    $0x8,%eax
8010298f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102990:	89 ca                	mov    %ecx,%edx
80102992:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102993:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102996:	89 fa                	mov    %edi,%edx
80102998:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010299b:	b8 09 00 00 00       	mov    $0x9,%eax
801029a0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029a1:	89 ca                	mov    %ecx,%edx
801029a3:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
801029a4:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801029a7:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
801029aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801029ad:	8d 45 b8             	lea    -0x48(%ebp),%eax
801029b0:	6a 18                	push   $0x18
801029b2:	56                   	push   %esi
801029b3:	50                   	push   %eax
801029b4:	e8 77 1b 00 00       	call   80104530 <memcmp>
801029b9:	83 c4 10             	add    $0x10,%esp
801029bc:	85 c0                	test   %eax,%eax
801029be:	0f 85 0c ff ff ff    	jne    801028d0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
801029c4:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801029c8:	75 78                	jne    80102a42 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801029ca:	8b 45 b8             	mov    -0x48(%ebp),%eax
801029cd:	89 c2                	mov    %eax,%edx
801029cf:	83 e0 0f             	and    $0xf,%eax
801029d2:	c1 ea 04             	shr    $0x4,%edx
801029d5:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029d8:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029db:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801029de:	8b 45 bc             	mov    -0x44(%ebp),%eax
801029e1:	89 c2                	mov    %eax,%edx
801029e3:	83 e0 0f             	and    $0xf,%eax
801029e6:	c1 ea 04             	shr    $0x4,%edx
801029e9:	8d 14 92             	lea    (%edx,%edx,4),%edx
801029ec:	8d 04 50             	lea    (%eax,%edx,2),%eax
801029ef:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801029f2:	8b 45 c0             	mov    -0x40(%ebp),%eax
801029f5:	89 c2                	mov    %eax,%edx
801029f7:	83 e0 0f             	and    $0xf,%eax
801029fa:	c1 ea 04             	shr    $0x4,%edx
801029fd:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a00:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a03:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102a06:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a09:	89 c2                	mov    %eax,%edx
80102a0b:	83 e0 0f             	and    $0xf,%eax
80102a0e:	c1 ea 04             	shr    $0x4,%edx
80102a11:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a14:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a17:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102a1a:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a1d:	89 c2                	mov    %eax,%edx
80102a1f:	83 e0 0f             	and    $0xf,%eax
80102a22:	c1 ea 04             	shr    $0x4,%edx
80102a25:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a28:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a2b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102a2e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a31:	89 c2                	mov    %eax,%edx
80102a33:	83 e0 0f             	and    $0xf,%eax
80102a36:	c1 ea 04             	shr    $0x4,%edx
80102a39:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a3c:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a3f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102a42:	8b 75 08             	mov    0x8(%ebp),%esi
80102a45:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a48:	89 06                	mov    %eax,(%esi)
80102a4a:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a4d:	89 46 04             	mov    %eax,0x4(%esi)
80102a50:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a53:	89 46 08             	mov    %eax,0x8(%esi)
80102a56:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a59:	89 46 0c             	mov    %eax,0xc(%esi)
80102a5c:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a5f:	89 46 10             	mov    %eax,0x10(%esi)
80102a62:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102a65:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102a68:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102a6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a72:	5b                   	pop    %ebx
80102a73:	5e                   	pop    %esi
80102a74:	5f                   	pop    %edi
80102a75:	5d                   	pop    %ebp
80102a76:	c3                   	ret    
80102a77:	66 90                	xchg   %ax,%ax
80102a79:	66 90                	xchg   %ax,%ax
80102a7b:	66 90                	xchg   %ax,%ax
80102a7d:	66 90                	xchg   %ax,%ax
80102a7f:	90                   	nop

80102a80 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a80:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102a86:	85 c9                	test   %ecx,%ecx
80102a88:	0f 8e 85 00 00 00    	jle    80102b13 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102a8e:	55                   	push   %ebp
80102a8f:	89 e5                	mov    %esp,%ebp
80102a91:	57                   	push   %edi
80102a92:	56                   	push   %esi
80102a93:	53                   	push   %ebx
80102a94:	31 db                	xor    %ebx,%ebx
80102a96:	83 ec 0c             	sub    $0xc,%esp
80102a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102aa0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102aa5:	83 ec 08             	sub    $0x8,%esp
80102aa8:	01 d8                	add    %ebx,%eax
80102aaa:	83 c0 01             	add    $0x1,%eax
80102aad:	50                   	push   %eax
80102aae:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102ab4:	e8 17 d6 ff ff       	call   801000d0 <bread>
80102ab9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102abb:	58                   	pop    %eax
80102abc:	5a                   	pop    %edx
80102abd:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102ac4:	ff 35 c4 26 11 80    	pushl  0x801126c4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102aca:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102acd:	e8 fe d5 ff ff       	call   801000d0 <bread>
80102ad2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102ad4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102ad7:	83 c4 0c             	add    $0xc,%esp
80102ada:	68 00 02 00 00       	push   $0x200
80102adf:	50                   	push   %eax
80102ae0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ae3:	50                   	push   %eax
80102ae4:	e8 a7 1a 00 00       	call   80104590 <memmove>
    bwrite(dbuf);  // write dst to disk
80102ae9:	89 34 24             	mov    %esi,(%esp)
80102aec:	e8 af d6 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102af1:	89 3c 24             	mov    %edi,(%esp)
80102af4:	e8 e7 d6 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102af9:	89 34 24             	mov    %esi,(%esp)
80102afc:	e8 df d6 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102b01:	83 c4 10             	add    $0x10,%esp
80102b04:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102b0a:	7f 94                	jg     80102aa0 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102b0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b0f:	5b                   	pop    %ebx
80102b10:	5e                   	pop    %esi
80102b11:	5f                   	pop    %edi
80102b12:	5d                   	pop    %ebp
80102b13:	f3 c3                	repz ret 
80102b15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b20 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	53                   	push   %ebx
80102b24:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102b27:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102b2d:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102b33:	e8 98 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102b38:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102b3e:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102b41:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102b43:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102b45:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102b48:	7e 1f                	jle    80102b69 <write_head+0x49>
80102b4a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102b51:	31 d2                	xor    %edx,%edx
80102b53:	90                   	nop
80102b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102b58:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102b5e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102b62:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102b65:	39 c2                	cmp    %eax,%edx
80102b67:	75 ef                	jne    80102b58 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102b69:	83 ec 0c             	sub    $0xc,%esp
80102b6c:	53                   	push   %ebx
80102b6d:	e8 2e d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102b72:	89 1c 24             	mov    %ebx,(%esp)
80102b75:	e8 66 d6 ff ff       	call   801001e0 <brelse>
}
80102b7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b7d:	c9                   	leave  
80102b7e:	c3                   	ret    
80102b7f:	90                   	nop

80102b80 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	53                   	push   %ebx
80102b84:	83 ec 2c             	sub    $0x2c,%esp
80102b87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102b8a:	68 a0 76 10 80       	push   $0x801076a0
80102b8f:	68 80 26 11 80       	push   $0x80112680
80102b94:	e8 d7 16 00 00       	call   80104270 <initlock>
  readsb(dev, &sb);
80102b99:	58                   	pop    %eax
80102b9a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102b9d:	5a                   	pop    %edx
80102b9e:	50                   	push   %eax
80102b9f:	53                   	push   %ebx
80102ba0:	e8 db e8 ff ff       	call   80101480 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ba5:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ba8:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102bab:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102bac:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102bb2:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102bb8:	a3 b4 26 11 80       	mov    %eax,0x801126b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102bbd:	5a                   	pop    %edx
80102bbe:	50                   	push   %eax
80102bbf:	53                   	push   %ebx
80102bc0:	e8 0b d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102bc5:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102bc8:	83 c4 10             	add    $0x10,%esp
80102bcb:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102bcd:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102bd3:	7e 1c                	jle    80102bf1 <initlog+0x71>
80102bd5:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102bdc:	31 d2                	xor    %edx,%edx
80102bde:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102be0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102be4:	83 c2 04             	add    $0x4,%edx
80102be7:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102bed:	39 da                	cmp    %ebx,%edx
80102bef:	75 ef                	jne    80102be0 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102bf1:	83 ec 0c             	sub    $0xc,%esp
80102bf4:	50                   	push   %eax
80102bf5:	e8 e6 d5 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102bfa:	e8 81 fe ff ff       	call   80102a80 <install_trans>
  log.lh.n = 0;
80102bff:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c06:	00 00 00 
  write_head(); // clear the log
80102c09:	e8 12 ff ff ff       	call   80102b20 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102c0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c11:	c9                   	leave  
80102c12:	c3                   	ret    
80102c13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c20 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102c20:	55                   	push   %ebp
80102c21:	89 e5                	mov    %esp,%ebp
80102c23:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102c26:	68 80 26 11 80       	push   $0x80112680
80102c2b:	e8 40 17 00 00       	call   80104370 <acquire>
80102c30:	83 c4 10             	add    $0x10,%esp
80102c33:	eb 18                	jmp    80102c4d <begin_op+0x2d>
80102c35:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102c38:	83 ec 08             	sub    $0x8,%esp
80102c3b:	68 80 26 11 80       	push   $0x80112680
80102c40:	68 80 26 11 80       	push   $0x80112680
80102c45:	e8 b6 11 00 00       	call   80103e00 <sleep>
80102c4a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102c4d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102c52:	85 c0                	test   %eax,%eax
80102c54:	75 e2                	jne    80102c38 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102c56:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102c5b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102c61:	83 c0 01             	add    $0x1,%eax
80102c64:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102c67:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102c6a:	83 fa 1e             	cmp    $0x1e,%edx
80102c6d:	7f c9                	jg     80102c38 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102c6f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102c72:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102c77:	68 80 26 11 80       	push   $0x80112680
80102c7c:	e8 0f 18 00 00       	call   80104490 <release>
      break;
    }
  }
}
80102c81:	83 c4 10             	add    $0x10,%esp
80102c84:	c9                   	leave  
80102c85:	c3                   	ret    
80102c86:	8d 76 00             	lea    0x0(%esi),%esi
80102c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102c90 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102c90:	55                   	push   %ebp
80102c91:	89 e5                	mov    %esp,%ebp
80102c93:	57                   	push   %edi
80102c94:	56                   	push   %esi
80102c95:	53                   	push   %ebx
80102c96:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102c99:	68 80 26 11 80       	push   $0x80112680
80102c9e:	e8 cd 16 00 00       	call   80104370 <acquire>
  log.outstanding -= 1;
80102ca3:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102ca8:	8b 1d c0 26 11 80    	mov    0x801126c0,%ebx
80102cae:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102cb1:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102cb4:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102cb6:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102cbb:	0f 85 23 01 00 00    	jne    80102de4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102cc1:	85 c0                	test   %eax,%eax
80102cc3:	0f 85 f7 00 00 00    	jne    80102dc0 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102cc9:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102ccc:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102cd3:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102cd6:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102cd8:	68 80 26 11 80       	push   $0x80112680
80102cdd:	e8 ae 17 00 00       	call   80104490 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ce2:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102ce8:	83 c4 10             	add    $0x10,%esp
80102ceb:	85 c9                	test   %ecx,%ecx
80102ced:	0f 8e 8a 00 00 00    	jle    80102d7d <end_op+0xed>
80102cf3:	90                   	nop
80102cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102cf8:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102cfd:	83 ec 08             	sub    $0x8,%esp
80102d00:	01 d8                	add    %ebx,%eax
80102d02:	83 c0 01             	add    $0x1,%eax
80102d05:	50                   	push   %eax
80102d06:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102d0c:	e8 bf d3 ff ff       	call   801000d0 <bread>
80102d11:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d13:	58                   	pop    %eax
80102d14:	5a                   	pop    %edx
80102d15:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102d1c:	ff 35 c4 26 11 80    	pushl  0x801126c4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d22:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102d25:	e8 a6 d3 ff ff       	call   801000d0 <bread>
80102d2a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102d2c:	8d 40 5c             	lea    0x5c(%eax),%eax
80102d2f:	83 c4 0c             	add    $0xc,%esp
80102d32:	68 00 02 00 00       	push   $0x200
80102d37:	50                   	push   %eax
80102d38:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d3b:	50                   	push   %eax
80102d3c:	e8 4f 18 00 00       	call   80104590 <memmove>
    bwrite(to);  // write the log
80102d41:	89 34 24             	mov    %esi,(%esp)
80102d44:	e8 57 d4 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102d49:	89 3c 24             	mov    %edi,(%esp)
80102d4c:	e8 8f d4 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102d51:	89 34 24             	mov    %esi,(%esp)
80102d54:	e8 87 d4 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102d59:	83 c4 10             	add    $0x10,%esp
80102d5c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102d62:	7c 94                	jl     80102cf8 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102d64:	e8 b7 fd ff ff       	call   80102b20 <write_head>
    install_trans(); // Now install writes to home locations
80102d69:	e8 12 fd ff ff       	call   80102a80 <install_trans>
    log.lh.n = 0;
80102d6e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102d75:	00 00 00 
    write_head();    // Erase the transaction from the log
80102d78:	e8 a3 fd ff ff       	call   80102b20 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102d7d:	83 ec 0c             	sub    $0xc,%esp
80102d80:	68 80 26 11 80       	push   $0x80112680
80102d85:	e8 e6 15 00 00       	call   80104370 <acquire>
    log.committing = 0;
    wakeup(&log);
80102d8a:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102d91:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102d98:	00 00 00 
    wakeup(&log);
80102d9b:	e8 10 12 00 00       	call   80103fb0 <wakeup>
    release(&log.lock);
80102da0:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102da7:	e8 e4 16 00 00       	call   80104490 <release>
80102dac:	83 c4 10             	add    $0x10,%esp
  }
}
80102daf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102db2:	5b                   	pop    %ebx
80102db3:	5e                   	pop    %esi
80102db4:	5f                   	pop    %edi
80102db5:	5d                   	pop    %ebp
80102db6:	c3                   	ret    
80102db7:	89 f6                	mov    %esi,%esi
80102db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80102dc0:	83 ec 0c             	sub    $0xc,%esp
80102dc3:	68 80 26 11 80       	push   $0x80112680
80102dc8:	e8 e3 11 00 00       	call   80103fb0 <wakeup>
  }
  release(&log.lock);
80102dcd:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102dd4:	e8 b7 16 00 00       	call   80104490 <release>
80102dd9:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102ddc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ddf:	5b                   	pop    %ebx
80102de0:	5e                   	pop    %esi
80102de1:	5f                   	pop    %edi
80102de2:	5d                   	pop    %ebp
80102de3:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102de4:	83 ec 0c             	sub    $0xc,%esp
80102de7:	68 a4 76 10 80       	push   $0x801076a4
80102dec:	e8 7f d5 ff ff       	call   80100370 <panic>
80102df1:	eb 0d                	jmp    80102e00 <log_write>
80102df3:	90                   	nop
80102df4:	90                   	nop
80102df5:	90                   	nop
80102df6:	90                   	nop
80102df7:	90                   	nop
80102df8:	90                   	nop
80102df9:	90                   	nop
80102dfa:	90                   	nop
80102dfb:	90                   	nop
80102dfc:	90                   	nop
80102dfd:	90                   	nop
80102dfe:	90                   	nop
80102dff:	90                   	nop

80102e00 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	53                   	push   %ebx
80102e04:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e07:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102e0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e10:	83 fa 1d             	cmp    $0x1d,%edx
80102e13:	0f 8f 97 00 00 00    	jg     80102eb0 <log_write+0xb0>
80102e19:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102e1e:	83 e8 01             	sub    $0x1,%eax
80102e21:	39 c2                	cmp    %eax,%edx
80102e23:	0f 8d 87 00 00 00    	jge    80102eb0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102e29:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102e2e:	85 c0                	test   %eax,%eax
80102e30:	0f 8e 87 00 00 00    	jle    80102ebd <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102e36:	83 ec 0c             	sub    $0xc,%esp
80102e39:	68 80 26 11 80       	push   $0x80112680
80102e3e:	e8 2d 15 00 00       	call   80104370 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102e43:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102e49:	83 c4 10             	add    $0x10,%esp
80102e4c:	83 fa 00             	cmp    $0x0,%edx
80102e4f:	7e 50                	jle    80102ea1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e51:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102e54:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102e56:	3b 0d cc 26 11 80    	cmp    0x801126cc,%ecx
80102e5c:	75 0b                	jne    80102e69 <log_write+0x69>
80102e5e:	eb 38                	jmp    80102e98 <log_write+0x98>
80102e60:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102e67:	74 2f                	je     80102e98 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102e69:	83 c0 01             	add    $0x1,%eax
80102e6c:	39 d0                	cmp    %edx,%eax
80102e6e:	75 f0                	jne    80102e60 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102e70:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102e77:	83 c2 01             	add    $0x1,%edx
80102e7a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102e80:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102e83:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102e8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e8d:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102e8e:	e9 fd 15 00 00       	jmp    80104490 <release>
80102e93:	90                   	nop
80102e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102e98:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102e9f:	eb df                	jmp    80102e80 <log_write+0x80>
80102ea1:	8b 43 08             	mov    0x8(%ebx),%eax
80102ea4:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102ea9:	75 d5                	jne    80102e80 <log_write+0x80>
80102eab:	eb ca                	jmp    80102e77 <log_write+0x77>
80102ead:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102eb0:	83 ec 0c             	sub    $0xc,%esp
80102eb3:	68 b3 76 10 80       	push   $0x801076b3
80102eb8:	e8 b3 d4 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102ebd:	83 ec 0c             	sub    $0xc,%esp
80102ec0:	68 c9 76 10 80       	push   $0x801076c9
80102ec5:	e8 a6 d4 ff ff       	call   80100370 <panic>
80102eca:	66 90                	xchg   %ax,%ax
80102ecc:	66 90                	xchg   %ax,%ax
80102ece:	66 90                	xchg   %ax,%ax

80102ed0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102ed0:	55                   	push   %ebp
80102ed1:	89 e5                	mov    %esp,%ebp
80102ed3:	53                   	push   %ebx
80102ed4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102ed7:	e8 54 09 00 00       	call   80103830 <cpuid>
80102edc:	89 c3                	mov    %eax,%ebx
80102ede:	e8 4d 09 00 00       	call   80103830 <cpuid>
80102ee3:	83 ec 04             	sub    $0x4,%esp
80102ee6:	53                   	push   %ebx
80102ee7:	50                   	push   %eax
80102ee8:	68 e4 76 10 80       	push   $0x801076e4
80102eed:	e8 6e d7 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102ef2:	e8 d9 28 00 00       	call   801057d0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ef7:	e8 b4 08 00 00       	call   801037b0 <mycpu>
80102efc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102efe:	b8 01 00 00 00       	mov    $0x1,%eax
80102f03:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102f0a:	e8 01 0c 00 00       	call   80103b10 <scheduler>
80102f0f:	90                   	nop

80102f10 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102f10:	55                   	push   %ebp
80102f11:	89 e5                	mov    %esp,%ebp
80102f13:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102f16:	e8 d5 39 00 00       	call   801068f0 <switchkvm>
  seginit();
80102f1b:	e8 40 38 00 00       	call   80106760 <seginit>
  lapicinit();
80102f20:	e8 9b f7 ff ff       	call   801026c0 <lapicinit>
  mpmain();
80102f25:	e8 a6 ff ff ff       	call   80102ed0 <mpmain>
80102f2a:	66 90                	xchg   %ax,%ax
80102f2c:	66 90                	xchg   %ax,%ax
80102f2e:	66 90                	xchg   %ax,%ax

80102f30 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102f30:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102f34:	83 e4 f0             	and    $0xfffffff0,%esp
80102f37:	ff 71 fc             	pushl  -0x4(%ecx)
80102f3a:	55                   	push   %ebp
80102f3b:	89 e5                	mov    %esp,%ebp
80102f3d:	53                   	push   %ebx
80102f3e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f3f:	bb 80 27 11 80       	mov    $0x80112780,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102f44:	83 ec 08             	sub    $0x8,%esp
80102f47:	68 00 00 40 80       	push   $0x80400000
80102f4c:	68 f4 58 11 80       	push   $0x801158f4
80102f51:	e8 3a f5 ff ff       	call   80102490 <kinit1>
  kvmalloc();      // kernel page table
80102f56:	e8 35 3e 00 00       	call   80106d90 <kvmalloc>
  mpinit();        // detect other processors
80102f5b:	e8 70 01 00 00       	call   801030d0 <mpinit>
  lapicinit();     // interrupt controller
80102f60:	e8 5b f7 ff ff       	call   801026c0 <lapicinit>
  seginit();       // segment descriptors
80102f65:	e8 f6 37 00 00       	call   80106760 <seginit>
  picinit();       // disable pic
80102f6a:	e8 31 03 00 00       	call   801032a0 <picinit>
  ioapicinit();    // another interrupt controller
80102f6f:	e8 4c f3 ff ff       	call   801022c0 <ioapicinit>
  consoleinit();   // console hardware
80102f74:	e8 27 da ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102f79:	e8 42 2b 00 00       	call   80105ac0 <uartinit>
  pinit();         // process table
80102f7e:	e8 0d 08 00 00       	call   80103790 <pinit>
  shminit();       // shared memory
80102f83:	e8 d8 41 00 00       	call   80107160 <shminit>
  tvinit();        // trap vectors
80102f88:	e8 a3 27 00 00       	call   80105730 <tvinit>
  binit();         // buffer cache
80102f8d:	e8 ae d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102f92:	e8 89 de ff ff       	call   80100e20 <fileinit>
  ideinit();       // disk 
80102f97:	e8 04 f1 ff ff       	call   801020a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102f9c:	83 c4 0c             	add    $0xc,%esp
80102f9f:	68 8a 00 00 00       	push   $0x8a
80102fa4:	68 8c a4 10 80       	push   $0x8010a48c
80102fa9:	68 00 70 00 80       	push   $0x80007000
80102fae:	e8 dd 15 00 00       	call   80104590 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102fb3:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102fba:	00 00 00 
80102fbd:	83 c4 10             	add    $0x10,%esp
80102fc0:	05 80 27 11 80       	add    $0x80112780,%eax
80102fc5:	39 d8                	cmp    %ebx,%eax
80102fc7:	76 6a                	jbe    80103033 <main+0x103>
80102fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102fd0:	e8 db 07 00 00       	call   801037b0 <mycpu>
80102fd5:	39 d8                	cmp    %ebx,%eax
80102fd7:	74 41                	je     8010301a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102fd9:	e8 82 f5 ff ff       	call   80102560 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102fde:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80102fe3:	c7 05 f8 6f 00 80 10 	movl   $0x80102f10,0x80006ff8
80102fea:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102fed:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102ff4:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ff7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102ffc:	0f b6 03             	movzbl (%ebx),%eax
80102fff:	83 ec 08             	sub    $0x8,%esp
80103002:	68 00 70 00 00       	push   $0x7000
80103007:	50                   	push   %eax
80103008:	e8 03 f8 ff ff       	call   80102810 <lapicstartap>
8010300d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103010:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103016:	85 c0                	test   %eax,%eax
80103018:	74 f6                	je     80103010 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010301a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103021:	00 00 00 
80103024:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010302a:	05 80 27 11 80       	add    $0x80112780,%eax
8010302f:	39 c3                	cmp    %eax,%ebx
80103031:	72 9d                	jb     80102fd0 <main+0xa0>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103033:	83 ec 08             	sub    $0x8,%esp
80103036:	68 00 00 00 8e       	push   $0x8e000000
8010303b:	68 00 00 40 80       	push   $0x80400000
80103040:	e8 bb f4 ff ff       	call   80102500 <kinit2>
  userinit();      // first user process
80103045:	e8 36 08 00 00       	call   80103880 <userinit>
  mpmain();        // finish this processor's setup
8010304a:	e8 81 fe ff ff       	call   80102ed0 <mpmain>
8010304f:	90                   	nop

80103050 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	57                   	push   %edi
80103054:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103055:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010305b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
8010305c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
8010305f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103062:	39 de                	cmp    %ebx,%esi
80103064:	73 48                	jae    801030ae <mpsearch1+0x5e>
80103066:	8d 76 00             	lea    0x0(%esi),%esi
80103069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103070:	83 ec 04             	sub    $0x4,%esp
80103073:	8d 7e 10             	lea    0x10(%esi),%edi
80103076:	6a 04                	push   $0x4
80103078:	68 f8 76 10 80       	push   $0x801076f8
8010307d:	56                   	push   %esi
8010307e:	e8 ad 14 00 00       	call   80104530 <memcmp>
80103083:	83 c4 10             	add    $0x10,%esp
80103086:	85 c0                	test   %eax,%eax
80103088:	75 1e                	jne    801030a8 <mpsearch1+0x58>
8010308a:	8d 7e 10             	lea    0x10(%esi),%edi
8010308d:	89 f2                	mov    %esi,%edx
8010308f:	31 c9                	xor    %ecx,%ecx
80103091:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80103098:	0f b6 02             	movzbl (%edx),%eax
8010309b:	83 c2 01             	add    $0x1,%edx
8010309e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030a0:	39 fa                	cmp    %edi,%edx
801030a2:	75 f4                	jne    80103098 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801030a4:	84 c9                	test   %cl,%cl
801030a6:	74 10                	je     801030b8 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801030a8:	39 fb                	cmp    %edi,%ebx
801030aa:	89 fe                	mov    %edi,%esi
801030ac:	77 c2                	ja     80103070 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
801030ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
801030b1:	31 c0                	xor    %eax,%eax
}
801030b3:	5b                   	pop    %ebx
801030b4:	5e                   	pop    %esi
801030b5:	5f                   	pop    %edi
801030b6:	5d                   	pop    %ebp
801030b7:	c3                   	ret    
801030b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030bb:	89 f0                	mov    %esi,%eax
801030bd:	5b                   	pop    %ebx
801030be:	5e                   	pop    %esi
801030bf:	5f                   	pop    %edi
801030c0:	5d                   	pop    %ebp
801030c1:	c3                   	ret    
801030c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801030d0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801030d0:	55                   	push   %ebp
801030d1:	89 e5                	mov    %esp,%ebp
801030d3:	57                   	push   %edi
801030d4:	56                   	push   %esi
801030d5:	53                   	push   %ebx
801030d6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801030d9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801030e0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801030e7:	c1 e0 08             	shl    $0x8,%eax
801030ea:	09 d0                	or     %edx,%eax
801030ec:	c1 e0 04             	shl    $0x4,%eax
801030ef:	85 c0                	test   %eax,%eax
801030f1:	75 1b                	jne    8010310e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
801030f3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801030fa:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103101:	c1 e0 08             	shl    $0x8,%eax
80103104:	09 d0                	or     %edx,%eax
80103106:	c1 e0 0a             	shl    $0xa,%eax
80103109:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010310e:	ba 00 04 00 00       	mov    $0x400,%edx
80103113:	e8 38 ff ff ff       	call   80103050 <mpsearch1>
80103118:	85 c0                	test   %eax,%eax
8010311a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010311d:	0f 84 37 01 00 00    	je     8010325a <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103123:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103126:	8b 58 04             	mov    0x4(%eax),%ebx
80103129:	85 db                	test   %ebx,%ebx
8010312b:	0f 84 43 01 00 00    	je     80103274 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103131:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103137:	83 ec 04             	sub    $0x4,%esp
8010313a:	6a 04                	push   $0x4
8010313c:	68 fd 76 10 80       	push   $0x801076fd
80103141:	56                   	push   %esi
80103142:	e8 e9 13 00 00       	call   80104530 <memcmp>
80103147:	83 c4 10             	add    $0x10,%esp
8010314a:	85 c0                	test   %eax,%eax
8010314c:	0f 85 22 01 00 00    	jne    80103274 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103152:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103159:	3c 01                	cmp    $0x1,%al
8010315b:	74 08                	je     80103165 <mpinit+0x95>
8010315d:	3c 04                	cmp    $0x4,%al
8010315f:	0f 85 0f 01 00 00    	jne    80103274 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103165:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010316c:	85 ff                	test   %edi,%edi
8010316e:	74 21                	je     80103191 <mpinit+0xc1>
80103170:	31 d2                	xor    %edx,%edx
80103172:	31 c0                	xor    %eax,%eax
80103174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103178:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010317f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103180:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103183:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103185:	39 c7                	cmp    %eax,%edi
80103187:	75 ef                	jne    80103178 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103189:	84 d2                	test   %dl,%dl
8010318b:	0f 85 e3 00 00 00    	jne    80103274 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103191:	85 f6                	test   %esi,%esi
80103193:	0f 84 db 00 00 00    	je     80103274 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103199:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010319f:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031a4:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801031ab:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
801031b1:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031b6:	01 d6                	add    %edx,%esi
801031b8:	90                   	nop
801031b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031c0:	39 c6                	cmp    %eax,%esi
801031c2:	76 23                	jbe    801031e7 <mpinit+0x117>
801031c4:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
801031c7:	80 fa 04             	cmp    $0x4,%dl
801031ca:	0f 87 c0 00 00 00    	ja     80103290 <mpinit+0x1c0>
801031d0:	ff 24 95 3c 77 10 80 	jmp    *-0x7fef88c4(,%edx,4)
801031d7:	89 f6                	mov    %esi,%esi
801031d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801031e0:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801031e3:	39 c6                	cmp    %eax,%esi
801031e5:	77 dd                	ja     801031c4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801031e7:	85 db                	test   %ebx,%ebx
801031e9:	0f 84 92 00 00 00    	je     80103281 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801031ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031f2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801031f6:	74 15                	je     8010320d <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031f8:	ba 22 00 00 00       	mov    $0x22,%edx
801031fd:	b8 70 00 00 00       	mov    $0x70,%eax
80103202:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103203:	ba 23 00 00 00       	mov    $0x23,%edx
80103208:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103209:	83 c8 01             	or     $0x1,%eax
8010320c:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010320d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103210:	5b                   	pop    %ebx
80103211:	5e                   	pop    %esi
80103212:	5f                   	pop    %edi
80103213:	5d                   	pop    %ebp
80103214:	c3                   	ret    
80103215:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103218:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
8010321e:	83 f9 07             	cmp    $0x7,%ecx
80103221:	7f 19                	jg     8010323c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103223:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103227:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010322d:	83 c1 01             	add    $0x1,%ecx
80103230:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103236:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010323c:	83 c0 14             	add    $0x14,%eax
      continue;
8010323f:	e9 7c ff ff ff       	jmp    801031c0 <mpinit+0xf0>
80103244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103248:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010324c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
8010324f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      p += sizeof(struct mpioapic);
      continue;
80103255:	e9 66 ff ff ff       	jmp    801031c0 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010325a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010325f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103264:	e8 e7 fd ff ff       	call   80103050 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103269:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010326b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010326e:	0f 85 af fe ff ff    	jne    80103123 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
80103274:	83 ec 0c             	sub    $0xc,%esp
80103277:	68 02 77 10 80       	push   $0x80107702
8010327c:	e8 ef d0 ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
80103281:	83 ec 0c             	sub    $0xc,%esp
80103284:	68 1c 77 10 80       	push   $0x8010771c
80103289:	e8 e2 d0 ff ff       	call   80100370 <panic>
8010328e:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103290:	31 db                	xor    %ebx,%ebx
80103292:	e9 30 ff ff ff       	jmp    801031c7 <mpinit+0xf7>
80103297:	66 90                	xchg   %ax,%ax
80103299:	66 90                	xchg   %ax,%ax
8010329b:	66 90                	xchg   %ax,%ax
8010329d:	66 90                	xchg   %ax,%ax
8010329f:	90                   	nop

801032a0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801032a0:	55                   	push   %ebp
801032a1:	ba 21 00 00 00       	mov    $0x21,%edx
801032a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801032ab:	89 e5                	mov    %esp,%ebp
801032ad:	ee                   	out    %al,(%dx)
801032ae:	ba a1 00 00 00       	mov    $0xa1,%edx
801032b3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801032b4:	5d                   	pop    %ebp
801032b5:	c3                   	ret    
801032b6:	66 90                	xchg   %ax,%ax
801032b8:	66 90                	xchg   %ax,%ax
801032ba:	66 90                	xchg   %ax,%ax
801032bc:	66 90                	xchg   %ax,%ax
801032be:	66 90                	xchg   %ax,%ax

801032c0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801032c0:	55                   	push   %ebp
801032c1:	89 e5                	mov    %esp,%ebp
801032c3:	57                   	push   %edi
801032c4:	56                   	push   %esi
801032c5:	53                   	push   %ebx
801032c6:	83 ec 0c             	sub    $0xc,%esp
801032c9:	8b 75 08             	mov    0x8(%ebp),%esi
801032cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801032cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801032d5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801032db:	e8 60 db ff ff       	call   80100e40 <filealloc>
801032e0:	85 c0                	test   %eax,%eax
801032e2:	89 06                	mov    %eax,(%esi)
801032e4:	0f 84 a8 00 00 00    	je     80103392 <pipealloc+0xd2>
801032ea:	e8 51 db ff ff       	call   80100e40 <filealloc>
801032ef:	85 c0                	test   %eax,%eax
801032f1:	89 03                	mov    %eax,(%ebx)
801032f3:	0f 84 87 00 00 00    	je     80103380 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801032f9:	e8 62 f2 ff ff       	call   80102560 <kalloc>
801032fe:	85 c0                	test   %eax,%eax
80103300:	89 c7                	mov    %eax,%edi
80103302:	0f 84 b0 00 00 00    	je     801033b8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103308:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
8010330b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103312:	00 00 00 
  p->writeopen = 1;
80103315:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010331c:	00 00 00 
  p->nwrite = 0;
8010331f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103326:	00 00 00 
  p->nread = 0;
80103329:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103330:	00 00 00 
  initlock(&p->lock, "pipe");
80103333:	68 50 77 10 80       	push   $0x80107750
80103338:	50                   	push   %eax
80103339:	e8 32 0f 00 00       	call   80104270 <initlock>
  (*f0)->type = FD_PIPE;
8010333e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103340:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103343:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103349:	8b 06                	mov    (%esi),%eax
8010334b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010334f:	8b 06                	mov    (%esi),%eax
80103351:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103355:	8b 06                	mov    (%esi),%eax
80103357:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010335a:	8b 03                	mov    (%ebx),%eax
8010335c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103362:	8b 03                	mov    (%ebx),%eax
80103364:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103368:	8b 03                	mov    (%ebx),%eax
8010336a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010336e:	8b 03                	mov    (%ebx),%eax
80103370:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103373:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103376:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103378:	5b                   	pop    %ebx
80103379:	5e                   	pop    %esi
8010337a:	5f                   	pop    %edi
8010337b:	5d                   	pop    %ebp
8010337c:	c3                   	ret    
8010337d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103380:	8b 06                	mov    (%esi),%eax
80103382:	85 c0                	test   %eax,%eax
80103384:	74 1e                	je     801033a4 <pipealloc+0xe4>
    fileclose(*f0);
80103386:	83 ec 0c             	sub    $0xc,%esp
80103389:	50                   	push   %eax
8010338a:	e8 71 db ff ff       	call   80100f00 <fileclose>
8010338f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103392:	8b 03                	mov    (%ebx),%eax
80103394:	85 c0                	test   %eax,%eax
80103396:	74 0c                	je     801033a4 <pipealloc+0xe4>
    fileclose(*f1);
80103398:	83 ec 0c             	sub    $0xc,%esp
8010339b:	50                   	push   %eax
8010339c:	e8 5f db ff ff       	call   80100f00 <fileclose>
801033a1:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801033a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
801033a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801033ac:	5b                   	pop    %ebx
801033ad:	5e                   	pop    %esi
801033ae:	5f                   	pop    %edi
801033af:	5d                   	pop    %ebp
801033b0:	c3                   	ret    
801033b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801033b8:	8b 06                	mov    (%esi),%eax
801033ba:	85 c0                	test   %eax,%eax
801033bc:	75 c8                	jne    80103386 <pipealloc+0xc6>
801033be:	eb d2                	jmp    80103392 <pipealloc+0xd2>

801033c0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
801033c0:	55                   	push   %ebp
801033c1:	89 e5                	mov    %esp,%ebp
801033c3:	56                   	push   %esi
801033c4:	53                   	push   %ebx
801033c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801033cb:	83 ec 0c             	sub    $0xc,%esp
801033ce:	53                   	push   %ebx
801033cf:	e8 9c 0f 00 00       	call   80104370 <acquire>
  if(writable){
801033d4:	83 c4 10             	add    $0x10,%esp
801033d7:	85 f6                	test   %esi,%esi
801033d9:	74 45                	je     80103420 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801033db:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033e1:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
801033e4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801033eb:	00 00 00 
    wakeup(&p->nread);
801033ee:	50                   	push   %eax
801033ef:	e8 bc 0b 00 00       	call   80103fb0 <wakeup>
801033f4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801033f7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033fd:	85 d2                	test   %edx,%edx
801033ff:	75 0a                	jne    8010340b <pipeclose+0x4b>
80103401:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103407:	85 c0                	test   %eax,%eax
80103409:	74 35                	je     80103440 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010340b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010340e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103411:	5b                   	pop    %ebx
80103412:	5e                   	pop    %esi
80103413:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103414:	e9 77 10 00 00       	jmp    80104490 <release>
80103419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103420:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103426:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103429:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103430:	00 00 00 
    wakeup(&p->nwrite);
80103433:	50                   	push   %eax
80103434:	e8 77 0b 00 00       	call   80103fb0 <wakeup>
80103439:	83 c4 10             	add    $0x10,%esp
8010343c:	eb b9                	jmp    801033f7 <pipeclose+0x37>
8010343e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103440:	83 ec 0c             	sub    $0xc,%esp
80103443:	53                   	push   %ebx
80103444:	e8 47 10 00 00       	call   80104490 <release>
    kfree((char*)p);
80103449:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010344c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010344f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103452:	5b                   	pop    %ebx
80103453:	5e                   	pop    %esi
80103454:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103455:	e9 56 ef ff ff       	jmp    801023b0 <kfree>
8010345a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103460 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103460:	55                   	push   %ebp
80103461:	89 e5                	mov    %esp,%ebp
80103463:	57                   	push   %edi
80103464:	56                   	push   %esi
80103465:	53                   	push   %ebx
80103466:	83 ec 28             	sub    $0x28,%esp
80103469:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010346c:	53                   	push   %ebx
8010346d:	e8 fe 0e 00 00       	call   80104370 <acquire>
  for(i = 0; i < n; i++){
80103472:	8b 45 10             	mov    0x10(%ebp),%eax
80103475:	83 c4 10             	add    $0x10,%esp
80103478:	85 c0                	test   %eax,%eax
8010347a:	0f 8e b9 00 00 00    	jle    80103539 <pipewrite+0xd9>
80103480:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103483:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103489:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010348f:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103495:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103498:	03 4d 10             	add    0x10(%ebp),%ecx
8010349b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010349e:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801034a4:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801034aa:	39 d0                	cmp    %edx,%eax
801034ac:	74 38                	je     801034e6 <pipewrite+0x86>
801034ae:	eb 59                	jmp    80103509 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
801034b0:	e8 9b 03 00 00       	call   80103850 <myproc>
801034b5:	8b 48 24             	mov    0x24(%eax),%ecx
801034b8:	85 c9                	test   %ecx,%ecx
801034ba:	75 34                	jne    801034f0 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801034bc:	83 ec 0c             	sub    $0xc,%esp
801034bf:	57                   	push   %edi
801034c0:	e8 eb 0a 00 00       	call   80103fb0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801034c5:	58                   	pop    %eax
801034c6:	5a                   	pop    %edx
801034c7:	53                   	push   %ebx
801034c8:	56                   	push   %esi
801034c9:	e8 32 09 00 00       	call   80103e00 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801034ce:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801034d4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801034da:	83 c4 10             	add    $0x10,%esp
801034dd:	05 00 02 00 00       	add    $0x200,%eax
801034e2:	39 c2                	cmp    %eax,%edx
801034e4:	75 2a                	jne    80103510 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
801034e6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801034ec:	85 c0                	test   %eax,%eax
801034ee:	75 c0                	jne    801034b0 <pipewrite+0x50>
        release(&p->lock);
801034f0:	83 ec 0c             	sub    $0xc,%esp
801034f3:	53                   	push   %ebx
801034f4:	e8 97 0f 00 00       	call   80104490 <release>
        return -1;
801034f9:	83 c4 10             	add    $0x10,%esp
801034fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103501:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103504:	5b                   	pop    %ebx
80103505:	5e                   	pop    %esi
80103506:	5f                   	pop    %edi
80103507:	5d                   	pop    %ebp
80103508:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103509:	89 c2                	mov    %eax,%edx
8010350b:	90                   	nop
8010350c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103510:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103513:	8d 42 01             	lea    0x1(%edx),%eax
80103516:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010351a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103520:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103526:	0f b6 09             	movzbl (%ecx),%ecx
80103529:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
8010352d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103530:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103533:	0f 85 65 ff ff ff    	jne    8010349e <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103539:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010353f:	83 ec 0c             	sub    $0xc,%esp
80103542:	50                   	push   %eax
80103543:	e8 68 0a 00 00       	call   80103fb0 <wakeup>
  release(&p->lock);
80103548:	89 1c 24             	mov    %ebx,(%esp)
8010354b:	e8 40 0f 00 00       	call   80104490 <release>
  return n;
80103550:	83 c4 10             	add    $0x10,%esp
80103553:	8b 45 10             	mov    0x10(%ebp),%eax
80103556:	eb a9                	jmp    80103501 <pipewrite+0xa1>
80103558:	90                   	nop
80103559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103560 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103560:	55                   	push   %ebp
80103561:	89 e5                	mov    %esp,%ebp
80103563:	57                   	push   %edi
80103564:	56                   	push   %esi
80103565:	53                   	push   %ebx
80103566:	83 ec 18             	sub    $0x18,%esp
80103569:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010356c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010356f:	53                   	push   %ebx
80103570:	e8 fb 0d 00 00       	call   80104370 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103575:	83 c4 10             	add    $0x10,%esp
80103578:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010357e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103584:	75 6a                	jne    801035f0 <piperead+0x90>
80103586:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
8010358c:	85 f6                	test   %esi,%esi
8010358e:	0f 84 cc 00 00 00    	je     80103660 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103594:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010359a:	eb 2d                	jmp    801035c9 <piperead+0x69>
8010359c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035a0:	83 ec 08             	sub    $0x8,%esp
801035a3:	53                   	push   %ebx
801035a4:	56                   	push   %esi
801035a5:	e8 56 08 00 00       	call   80103e00 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801035aa:	83 c4 10             	add    $0x10,%esp
801035ad:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801035b3:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
801035b9:	75 35                	jne    801035f0 <piperead+0x90>
801035bb:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
801035c1:	85 d2                	test   %edx,%edx
801035c3:	0f 84 97 00 00 00    	je     80103660 <piperead+0x100>
    if(myproc()->killed){
801035c9:	e8 82 02 00 00       	call   80103850 <myproc>
801035ce:	8b 48 24             	mov    0x24(%eax),%ecx
801035d1:	85 c9                	test   %ecx,%ecx
801035d3:	74 cb                	je     801035a0 <piperead+0x40>
      release(&p->lock);
801035d5:	83 ec 0c             	sub    $0xc,%esp
801035d8:	53                   	push   %ebx
801035d9:	e8 b2 0e 00 00       	call   80104490 <release>
      return -1;
801035de:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035e1:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
801035e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801035e9:	5b                   	pop    %ebx
801035ea:	5e                   	pop    %esi
801035eb:	5f                   	pop    %edi
801035ec:	5d                   	pop    %ebp
801035ed:	c3                   	ret    
801035ee:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801035f0:	8b 45 10             	mov    0x10(%ebp),%eax
801035f3:	85 c0                	test   %eax,%eax
801035f5:	7e 69                	jle    80103660 <piperead+0x100>
    if(p->nread == p->nwrite)
801035f7:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801035fd:	31 c9                	xor    %ecx,%ecx
801035ff:	eb 15                	jmp    80103616 <piperead+0xb6>
80103601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103608:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010360e:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103614:	74 5a                	je     80103670 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103616:	8d 70 01             	lea    0x1(%eax),%esi
80103619:	25 ff 01 00 00       	and    $0x1ff,%eax
8010361e:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103624:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103629:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010362c:	83 c1 01             	add    $0x1,%ecx
8010362f:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103632:	75 d4                	jne    80103608 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103634:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010363a:	83 ec 0c             	sub    $0xc,%esp
8010363d:	50                   	push   %eax
8010363e:	e8 6d 09 00 00       	call   80103fb0 <wakeup>
  release(&p->lock);
80103643:	89 1c 24             	mov    %ebx,(%esp)
80103646:	e8 45 0e 00 00       	call   80104490 <release>
  return i;
8010364b:	8b 45 10             	mov    0x10(%ebp),%eax
8010364e:	83 c4 10             	add    $0x10,%esp
}
80103651:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103654:	5b                   	pop    %ebx
80103655:	5e                   	pop    %esi
80103656:	5f                   	pop    %edi
80103657:	5d                   	pop    %ebp
80103658:	c3                   	ret    
80103659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103660:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103667:	eb cb                	jmp    80103634 <piperead+0xd4>
80103669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103670:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103673:	eb bf                	jmp    80103634 <piperead+0xd4>
80103675:	66 90                	xchg   %ax,%ax
80103677:	66 90                	xchg   %ax,%ax
80103679:	66 90                	xchg   %ax,%ax
8010367b:	66 90                	xchg   %ax,%ax
8010367d:	66 90                	xchg   %ax,%ax
8010367f:	90                   	nop

80103680 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103684:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103689:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010368c:	68 20 2d 11 80       	push   $0x80112d20
80103691:	e8 da 0c 00 00       	call   80104370 <acquire>
80103696:	83 c4 10             	add    $0x10,%esp
80103699:	eb 10                	jmp    801036ab <allocproc+0x2b>
8010369b:	90                   	nop
8010369c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036a0:	83 eb 80             	sub    $0xffffff80,%ebx
801036a3:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801036a9:	74 75                	je     80103720 <allocproc+0xa0>
    if(p->state == UNUSED)
801036ab:	8b 43 0c             	mov    0xc(%ebx),%eax
801036ae:	85 c0                	test   %eax,%eax
801036b0:	75 ee                	jne    801036a0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801036b2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801036b7:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801036ba:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;

  release(&ptable.lock);
801036c1:	68 20 2d 11 80       	push   $0x80112d20
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801036c6:	8d 50 01             	lea    0x1(%eax),%edx
801036c9:	89 43 10             	mov    %eax,0x10(%ebx)
801036cc:	89 15 04 a0 10 80    	mov    %edx,0x8010a004

  release(&ptable.lock);
801036d2:	e8 b9 0d 00 00       	call   80104490 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801036d7:	e8 84 ee ff ff       	call   80102560 <kalloc>
801036dc:	83 c4 10             	add    $0x10,%esp
801036df:	85 c0                	test   %eax,%eax
801036e1:	89 43 08             	mov    %eax,0x8(%ebx)
801036e4:	74 51                	je     80103737 <allocproc+0xb7>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801036e6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801036ec:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
801036ef:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801036f4:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801036f7:	c7 40 14 22 57 10 80 	movl   $0x80105722,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801036fe:	6a 14                	push   $0x14
80103700:	6a 00                	push   $0x0
80103702:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103703:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103706:	e8 d5 0d 00 00       	call   801044e0 <memset>
  p->context->eip = (uint)forkret;
8010370b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010370e:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
80103711:	c7 40 10 40 37 10 80 	movl   $0x80103740,0x10(%eax)

  return p;
80103718:	89 d8                	mov    %ebx,%eax
}
8010371a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010371d:	c9                   	leave  
8010371e:	c3                   	ret    
8010371f:	90                   	nop

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103720:	83 ec 0c             	sub    $0xc,%esp
80103723:	68 20 2d 11 80       	push   $0x80112d20
80103728:	e8 63 0d 00 00       	call   80104490 <release>
  return 0;
8010372d:	83 c4 10             	add    $0x10,%esp
80103730:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103732:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103735:	c9                   	leave  
80103736:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103737:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010373e:	eb da                	jmp    8010371a <allocproc+0x9a>

80103740 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103746:	68 20 2d 11 80       	push   $0x80112d20
8010374b:	e8 40 0d 00 00       	call   80104490 <release>

  if (first) {
80103750:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103755:	83 c4 10             	add    $0x10,%esp
80103758:	85 c0                	test   %eax,%eax
8010375a:	75 04                	jne    80103760 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010375c:	c9                   	leave  
8010375d:	c3                   	ret    
8010375e:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103760:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103763:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010376a:	00 00 00 
    iinit(ROOTDEV);
8010376d:	6a 01                	push   $0x1
8010376f:	e8 cc dd ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
80103774:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010377b:	e8 00 f4 ff ff       	call   80102b80 <initlog>
80103780:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103783:	c9                   	leave  
80103784:	c3                   	ret    
80103785:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103790 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103796:	68 55 77 10 80       	push   $0x80107755
8010379b:	68 20 2d 11 80       	push   $0x80112d20
801037a0:	e8 cb 0a 00 00       	call   80104270 <initlock>
}
801037a5:	83 c4 10             	add    $0x10,%esp
801037a8:	c9                   	leave  
801037a9:	c3                   	ret    
801037aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801037b0 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	56                   	push   %esi
801037b4:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801037b5:	9c                   	pushf  
801037b6:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
801037b7:	f6 c4 02             	test   $0x2,%ah
801037ba:	75 5b                	jne    80103817 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
801037bc:	e8 ff ef ff ff       	call   801027c0 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801037c1:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801037c7:	85 f6                	test   %esi,%esi
801037c9:	7e 3f                	jle    8010380a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
801037cb:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
801037d2:	39 d0                	cmp    %edx,%eax
801037d4:	74 30                	je     80103806 <mycpu+0x56>
801037d6:	b9 30 28 11 80       	mov    $0x80112830,%ecx
801037db:	31 d2                	xor    %edx,%edx
801037dd:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801037e0:	83 c2 01             	add    $0x1,%edx
801037e3:	39 f2                	cmp    %esi,%edx
801037e5:	74 23                	je     8010380a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
801037e7:	0f b6 19             	movzbl (%ecx),%ebx
801037ea:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801037f0:	39 d8                	cmp    %ebx,%eax
801037f2:	75 ec                	jne    801037e0 <mycpu+0x30>
      return &cpus[i];
801037f4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
801037fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037fd:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
801037fe:	05 80 27 11 80       	add    $0x80112780,%eax
  }
  panic("unknown apicid\n");
}
80103803:	5e                   	pop    %esi
80103804:	5d                   	pop    %ebp
80103805:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103806:	31 d2                	xor    %edx,%edx
80103808:	eb ea                	jmp    801037f4 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
8010380a:	83 ec 0c             	sub    $0xc,%esp
8010380d:	68 5c 77 10 80       	push   $0x8010775c
80103812:	e8 59 cb ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103817:	83 ec 0c             	sub    $0xc,%esp
8010381a:	68 38 78 10 80       	push   $0x80107838
8010381f:	e8 4c cb ff ff       	call   80100370 <panic>
80103824:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010382a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103830 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103836:	e8 75 ff ff ff       	call   801037b0 <mycpu>
8010383b:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103840:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
80103841:	c1 f8 04             	sar    $0x4,%eax
80103844:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010384a:	c3                   	ret    
8010384b:	90                   	nop
8010384c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103850 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	53                   	push   %ebx
80103854:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103857:	e8 d4 0a 00 00       	call   80104330 <pushcli>
  c = mycpu();
8010385c:	e8 4f ff ff ff       	call   801037b0 <mycpu>
  p = c->proc;
80103861:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103867:	e8 b4 0b 00 00       	call   80104420 <popcli>
  return p;
}
8010386c:	83 c4 04             	add    $0x4,%esp
8010386f:	89 d8                	mov    %ebx,%eax
80103871:	5b                   	pop    %ebx
80103872:	5d                   	pop    %ebp
80103873:	c3                   	ret    
80103874:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010387a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103880 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	53                   	push   %ebx
80103884:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103887:	e8 f4 fd ff ff       	call   80103680 <allocproc>
8010388c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
8010388e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103893:	e8 78 34 00 00       	call   80106d10 <setupkvm>
80103898:	85 c0                	test   %eax,%eax
8010389a:	89 43 04             	mov    %eax,0x4(%ebx)
8010389d:	0f 84 bd 00 00 00    	je     80103960 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801038a3:	83 ec 04             	sub    $0x4,%esp
801038a6:	68 2c 00 00 00       	push   $0x2c
801038ab:	68 60 a4 10 80       	push   $0x8010a460
801038b0:	50                   	push   %eax
801038b1:	e8 6a 31 00 00       	call   80106a20 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
801038b6:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
801038b9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801038bf:	6a 4c                	push   $0x4c
801038c1:	6a 00                	push   $0x0
801038c3:	ff 73 18             	pushl  0x18(%ebx)
801038c6:	e8 15 0c 00 00       	call   801044e0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038cb:	8b 43 18             	mov    0x18(%ebx),%eax
801038ce:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038d3:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
801038d8:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801038db:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801038df:	8b 43 18             	mov    0x18(%ebx),%eax
801038e2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801038e6:	8b 43 18             	mov    0x18(%ebx),%eax
801038e9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038ed:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801038f1:	8b 43 18             	mov    0x18(%ebx),%eax
801038f4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801038f8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801038fc:	8b 43 18             	mov    0x18(%ebx),%eax
801038ff:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103906:	8b 43 18             	mov    0x18(%ebx),%eax
80103909:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103910:	8b 43 18             	mov    0x18(%ebx),%eax
80103913:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010391a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010391d:	6a 10                	push   $0x10
8010391f:	68 85 77 10 80       	push   $0x80107785
80103924:	50                   	push   %eax
80103925:	e8 b6 0d 00 00       	call   801046e0 <safestrcpy>
  p->cwd = namei("/");
8010392a:	c7 04 24 8e 77 10 80 	movl   $0x8010778e,(%esp)
80103931:	e8 5a e6 ff ff       	call   80101f90 <namei>
80103936:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103939:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103940:	e8 2b 0a 00 00       	call   80104370 <acquire>

  p->state = RUNNABLE;
80103945:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
8010394c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103953:	e8 38 0b 00 00       	call   80104490 <release>
}
80103958:	83 c4 10             	add    $0x10,%esp
8010395b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010395e:	c9                   	leave  
8010395f:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103960:	83 ec 0c             	sub    $0xc,%esp
80103963:	68 6c 77 10 80       	push   $0x8010776c
80103968:	e8 03 ca ff ff       	call   80100370 <panic>
8010396d:	8d 76 00             	lea    0x0(%esi),%esi

80103970 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103970:	55                   	push   %ebp
80103971:	89 e5                	mov    %esp,%ebp
80103973:	56                   	push   %esi
80103974:	53                   	push   %ebx
80103975:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103978:	e8 b3 09 00 00       	call   80104330 <pushcli>
  c = mycpu();
8010397d:	e8 2e fe ff ff       	call   801037b0 <mycpu>
  p = c->proc;
80103982:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103988:	e8 93 0a 00 00       	call   80104420 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
8010398d:	83 fe 00             	cmp    $0x0,%esi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
80103990:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103992:	7e 34                	jle    801039c8 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103994:	83 ec 04             	sub    $0x4,%esp
80103997:	01 c6                	add    %eax,%esi
80103999:	56                   	push   %esi
8010399a:	50                   	push   %eax
8010399b:	ff 73 04             	pushl  0x4(%ebx)
8010399e:	e8 bd 31 00 00       	call   80106b60 <allocuvm>
801039a3:	83 c4 10             	add    $0x10,%esp
801039a6:	85 c0                	test   %eax,%eax
801039a8:	74 36                	je     801039e0 <growproc+0x70>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
801039aa:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
801039ad:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801039af:	53                   	push   %ebx
801039b0:	e8 5b 2f 00 00       	call   80106910 <switchuvm>
  return 0;
801039b5:	83 c4 10             	add    $0x10,%esp
801039b8:	31 c0                	xor    %eax,%eax
}
801039ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
801039bd:	5b                   	pop    %ebx
801039be:	5e                   	pop    %esi
801039bf:	5d                   	pop    %ebp
801039c0:	c3                   	ret    
801039c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
801039c8:	74 e0                	je     801039aa <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801039ca:	83 ec 04             	sub    $0x4,%esp
801039cd:	01 c6                	add    %eax,%esi
801039cf:	56                   	push   %esi
801039d0:	50                   	push   %eax
801039d1:	ff 73 04             	pushl  0x4(%ebx)
801039d4:	e8 87 32 00 00       	call   80106c60 <deallocuvm>
801039d9:	83 c4 10             	add    $0x10,%esp
801039dc:	85 c0                	test   %eax,%eax
801039de:	75 ca                	jne    801039aa <growproc+0x3a>
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
801039e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039e5:	eb d3                	jmp    801039ba <growproc+0x4a>
801039e7:	89 f6                	mov    %esi,%esi
801039e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801039f0 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	57                   	push   %edi
801039f4:	56                   	push   %esi
801039f5:	53                   	push   %ebx
801039f6:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801039f9:	e8 32 09 00 00       	call   80104330 <pushcli>
  c = mycpu();
801039fe:	e8 ad fd ff ff       	call   801037b0 <mycpu>
  p = c->proc;
80103a03:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a09:	e8 12 0a 00 00       	call   80104420 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
80103a0e:	e8 6d fc ff ff       	call   80103680 <allocproc>
80103a13:	85 c0                	test   %eax,%eax
80103a15:	89 c7                	mov    %eax,%edi
80103a17:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103a1a:	0f 84 bd 00 00 00    	je     80103add <fork+0xed>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz, curproc->stack_sz)) == 0){
80103a20:	83 ec 04             	sub    $0x4,%esp
80103a23:	ff 73 7c             	pushl  0x7c(%ebx)
80103a26:	ff 33                	pushl  (%ebx)
80103a28:	ff 73 04             	pushl  0x4(%ebx)
80103a2b:	e8 b0 33 00 00       	call   80106de0 <copyuvm>
80103a30:	83 c4 10             	add    $0x10,%esp
80103a33:	85 c0                	test   %eax,%eax
80103a35:	89 47 04             	mov    %eax,0x4(%edi)
80103a38:	0f 84 a6 00 00 00    	je     80103ae4 <fork+0xf4>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
80103a3e:	8b 03                	mov    (%ebx),%eax
80103a40:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103a43:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103a45:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103a48:	89 c8                	mov    %ecx,%eax
80103a4a:	8b 79 18             	mov    0x18(%ecx),%edi
80103a4d:	8b 73 18             	mov    0x18(%ebx),%esi
80103a50:	b9 13 00 00 00       	mov    $0x13,%ecx
80103a55:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103a57:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103a59:	8b 40 18             	mov    0x18(%eax),%eax
80103a5c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103a63:	90                   	nop
80103a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103a68:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103a6c:	85 c0                	test   %eax,%eax
80103a6e:	74 13                	je     80103a83 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103a70:	83 ec 0c             	sub    $0xc,%esp
80103a73:	50                   	push   %eax
80103a74:	e8 37 d4 ff ff       	call   80100eb0 <filedup>
80103a79:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103a7c:	83 c4 10             	add    $0x10,%esp
80103a7f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103a83:	83 c6 01             	add    $0x1,%esi
80103a86:	83 fe 10             	cmp    $0x10,%esi
80103a89:	75 dd                	jne    80103a68 <fork+0x78>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103a8b:	83 ec 0c             	sub    $0xc,%esp
80103a8e:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a91:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103a94:	e8 77 dc ff ff       	call   80101710 <idup>
80103a99:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103a9c:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103a9f:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103aa2:	8d 47 6c             	lea    0x6c(%edi),%eax
80103aa5:	6a 10                	push   $0x10
80103aa7:	53                   	push   %ebx
80103aa8:	50                   	push   %eax
80103aa9:	e8 32 0c 00 00       	call   801046e0 <safestrcpy>

  pid = np->pid;
80103aae:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103ab1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ab8:	e8 b3 08 00 00       	call   80104370 <acquire>

  np->state = RUNNABLE;
80103abd:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
80103ac4:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103acb:	e8 c0 09 00 00       	call   80104490 <release>

  return pid;
80103ad0:	83 c4 10             	add    $0x10,%esp
80103ad3:	89 d8                	mov    %ebx,%eax
}
80103ad5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ad8:	5b                   	pop    %ebx
80103ad9:	5e                   	pop    %esi
80103ada:	5f                   	pop    %edi
80103adb:	5d                   	pop    %ebp
80103adc:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103add:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ae2:	eb f1                	jmp    80103ad5 <fork+0xe5>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz, curproc->stack_sz)) == 0){
    kfree(np->kstack);
80103ae4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103ae7:	83 ec 0c             	sub    $0xc,%esp
80103aea:	ff 77 08             	pushl  0x8(%edi)
80103aed:	e8 be e8 ff ff       	call   801023b0 <kfree>
    np->kstack = 0;
80103af2:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103af9:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103b00:	83 c4 10             	add    $0x10,%esp
80103b03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b08:	eb cb                	jmp    80103ad5 <fork+0xe5>
80103b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b10 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	57                   	push   %edi
80103b14:	56                   	push   %esi
80103b15:	53                   	push   %ebx
80103b16:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103b19:	e8 92 fc ff ff       	call   801037b0 <mycpu>
80103b1e:	8d 78 04             	lea    0x4(%eax),%edi
80103b21:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103b23:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103b2a:	00 00 00 
80103b2d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103b30:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103b31:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b34:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103b39:	68 20 2d 11 80       	push   $0x80112d20
80103b3e:	e8 2d 08 00 00       	call   80104370 <acquire>
80103b43:	83 c4 10             	add    $0x10,%esp
80103b46:	eb 13                	jmp    80103b5b <scheduler+0x4b>
80103b48:	90                   	nop
80103b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b50:	83 eb 80             	sub    $0xffffff80,%ebx
80103b53:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103b59:	74 45                	je     80103ba0 <scheduler+0x90>
      if(p->state != RUNNABLE)
80103b5b:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103b5f:	75 ef                	jne    80103b50 <scheduler+0x40>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103b61:	83 ec 0c             	sub    $0xc,%esp
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103b64:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103b6a:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b6b:	83 eb 80             	sub    $0xffffff80,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103b6e:	e8 9d 2d 00 00       	call   80106910 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103b73:	58                   	pop    %eax
80103b74:	5a                   	pop    %edx
80103b75:	ff 73 9c             	pushl  -0x64(%ebx)
80103b78:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103b79:	c7 43 8c 04 00 00 00 	movl   $0x4,-0x74(%ebx)

      swtch(&(c->scheduler), p->context);
80103b80:	e8 b6 0b 00 00       	call   8010473b <swtch>
      switchkvm();
80103b85:	e8 66 2d 00 00       	call   801068f0 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103b8a:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b8d:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103b93:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103b9a:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b9d:	75 bc                	jne    80103b5b <scheduler+0x4b>
80103b9f:	90                   	nop

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103ba0:	83 ec 0c             	sub    $0xc,%esp
80103ba3:	68 20 2d 11 80       	push   $0x80112d20
80103ba8:	e8 e3 08 00 00       	call   80104490 <release>

  }
80103bad:	83 c4 10             	add    $0x10,%esp
80103bb0:	e9 7b ff ff ff       	jmp    80103b30 <scheduler+0x20>
80103bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103bc0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	56                   	push   %esi
80103bc4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103bc5:	e8 66 07 00 00       	call   80104330 <pushcli>
  c = mycpu();
80103bca:	e8 e1 fb ff ff       	call   801037b0 <mycpu>
  p = c->proc;
80103bcf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bd5:	e8 46 08 00 00       	call   80104420 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103bda:	83 ec 0c             	sub    $0xc,%esp
80103bdd:	68 20 2d 11 80       	push   $0x80112d20
80103be2:	e8 09 07 00 00       	call   801042f0 <holding>
80103be7:	83 c4 10             	add    $0x10,%esp
80103bea:	85 c0                	test   %eax,%eax
80103bec:	74 4f                	je     80103c3d <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103bee:	e8 bd fb ff ff       	call   801037b0 <mycpu>
80103bf3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103bfa:	75 68                	jne    80103c64 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
80103bfc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103c00:	74 55                	je     80103c57 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c02:	9c                   	pushf  
80103c03:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103c04:	f6 c4 02             	test   $0x2,%ah
80103c07:	75 41                	jne    80103c4a <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103c09:	e8 a2 fb ff ff       	call   801037b0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103c0e:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103c11:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103c17:	e8 94 fb ff ff       	call   801037b0 <mycpu>
80103c1c:	83 ec 08             	sub    $0x8,%esp
80103c1f:	ff 70 04             	pushl  0x4(%eax)
80103c22:	53                   	push   %ebx
80103c23:	e8 13 0b 00 00       	call   8010473b <swtch>
  mycpu()->intena = intena;
80103c28:	e8 83 fb ff ff       	call   801037b0 <mycpu>
}
80103c2d:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80103c30:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103c36:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c39:	5b                   	pop    %ebx
80103c3a:	5e                   	pop    %esi
80103c3b:	5d                   	pop    %ebp
80103c3c:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103c3d:	83 ec 0c             	sub    $0xc,%esp
80103c40:	68 90 77 10 80       	push   $0x80107790
80103c45:	e8 26 c7 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103c4a:	83 ec 0c             	sub    $0xc,%esp
80103c4d:	68 bc 77 10 80       	push   $0x801077bc
80103c52:	e8 19 c7 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103c57:	83 ec 0c             	sub    $0xc,%esp
80103c5a:	68 ae 77 10 80       	push   $0x801077ae
80103c5f:	e8 0c c7 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103c64:	83 ec 0c             	sub    $0xc,%esp
80103c67:	68 a2 77 10 80       	push   $0x801077a2
80103c6c:	e8 ff c6 ff ff       	call   80100370 <panic>
80103c71:	eb 0d                	jmp    80103c80 <exit>
80103c73:	90                   	nop
80103c74:	90                   	nop
80103c75:	90                   	nop
80103c76:	90                   	nop
80103c77:	90                   	nop
80103c78:	90                   	nop
80103c79:	90                   	nop
80103c7a:	90                   	nop
80103c7b:	90                   	nop
80103c7c:	90                   	nop
80103c7d:	90                   	nop
80103c7e:	90                   	nop
80103c7f:	90                   	nop

80103c80 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	57                   	push   %edi
80103c84:	56                   	push   %esi
80103c85:	53                   	push   %ebx
80103c86:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103c89:	e8 a2 06 00 00       	call   80104330 <pushcli>
  c = mycpu();
80103c8e:	e8 1d fb ff ff       	call   801037b0 <mycpu>
  p = c->proc;
80103c93:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103c99:	e8 82 07 00 00       	call   80104420 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103c9e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103ca4:	8d 5e 28             	lea    0x28(%esi),%ebx
80103ca7:	8d 7e 68             	lea    0x68(%esi),%edi
80103caa:	0f 84 e7 00 00 00    	je     80103d97 <exit+0x117>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103cb0:	8b 03                	mov    (%ebx),%eax
80103cb2:	85 c0                	test   %eax,%eax
80103cb4:	74 12                	je     80103cc8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103cb6:	83 ec 0c             	sub    $0xc,%esp
80103cb9:	50                   	push   %eax
80103cba:	e8 41 d2 ff ff       	call   80100f00 <fileclose>
      curproc->ofile[fd] = 0;
80103cbf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103cc5:	83 c4 10             	add    $0x10,%esp
80103cc8:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103ccb:	39 df                	cmp    %ebx,%edi
80103ccd:	75 e1                	jne    80103cb0 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103ccf:	e8 4c ef ff ff       	call   80102c20 <begin_op>
  iput(curproc->cwd);
80103cd4:	83 ec 0c             	sub    $0xc,%esp
80103cd7:	ff 76 68             	pushl  0x68(%esi)
80103cda:	e8 91 db ff ff       	call   80101870 <iput>
  end_op();
80103cdf:	e8 ac ef ff ff       	call   80102c90 <end_op>
  curproc->cwd = 0;
80103ce4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
80103ceb:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cf2:	e8 79 06 00 00       	call   80104370 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103cf7:	8b 56 14             	mov    0x14(%esi),%edx
80103cfa:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cfd:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d02:	eb 0e                	jmp    80103d12 <exit+0x92>
80103d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d08:	83 e8 80             	sub    $0xffffff80,%eax
80103d0b:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103d10:	74 1c                	je     80103d2e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103d12:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d16:	75 f0                	jne    80103d08 <exit+0x88>
80103d18:	3b 50 20             	cmp    0x20(%eax),%edx
80103d1b:	75 eb                	jne    80103d08 <exit+0x88>
      p->state = RUNNABLE;
80103d1d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d24:	83 e8 80             	sub    $0xffffff80,%eax
80103d27:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103d2c:	75 e4                	jne    80103d12 <exit+0x92>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103d2e:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
80103d34:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103d39:	eb 10                	jmp    80103d4b <exit+0xcb>
80103d3b:	90                   	nop
80103d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d40:	83 ea 80             	sub    $0xffffff80,%edx
80103d43:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103d49:	74 33                	je     80103d7e <exit+0xfe>
    if(p->parent == curproc){
80103d4b:	39 72 14             	cmp    %esi,0x14(%edx)
80103d4e:	75 f0                	jne    80103d40 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103d50:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103d54:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103d57:	75 e7                	jne    80103d40 <exit+0xc0>
80103d59:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d5e:	eb 0a                	jmp    80103d6a <exit+0xea>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d60:	83 e8 80             	sub    $0xffffff80,%eax
80103d63:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103d68:	74 d6                	je     80103d40 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103d6a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d6e:	75 f0                	jne    80103d60 <exit+0xe0>
80103d70:	3b 48 20             	cmp    0x20(%eax),%ecx
80103d73:	75 eb                	jne    80103d60 <exit+0xe0>
      p->state = RUNNABLE;
80103d75:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103d7c:	eb e2                	jmp    80103d60 <exit+0xe0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103d7e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103d85:	e8 36 fe ff ff       	call   80103bc0 <sched>
  panic("zombie exit");
80103d8a:	83 ec 0c             	sub    $0xc,%esp
80103d8d:	68 dd 77 10 80       	push   $0x801077dd
80103d92:	e8 d9 c5 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103d97:	83 ec 0c             	sub    $0xc,%esp
80103d9a:	68 d0 77 10 80       	push   $0x801077d0
80103d9f:	e8 cc c5 ff ff       	call   80100370 <panic>
80103da4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103daa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103db0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	53                   	push   %ebx
80103db4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103db7:	68 20 2d 11 80       	push   $0x80112d20
80103dbc:	e8 af 05 00 00       	call   80104370 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103dc1:	e8 6a 05 00 00       	call   80104330 <pushcli>
  c = mycpu();
80103dc6:	e8 e5 f9 ff ff       	call   801037b0 <mycpu>
  p = c->proc;
80103dcb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103dd1:	e8 4a 06 00 00       	call   80104420 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
80103dd6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103ddd:	e8 de fd ff ff       	call   80103bc0 <sched>
  release(&ptable.lock);
80103de2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103de9:	e8 a2 06 00 00       	call   80104490 <release>
}
80103dee:	83 c4 10             	add    $0x10,%esp
80103df1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103df4:	c9                   	leave  
80103df5:	c3                   	ret    
80103df6:	8d 76 00             	lea    0x0(%esi),%esi
80103df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e00 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	57                   	push   %edi
80103e04:	56                   	push   %esi
80103e05:	53                   	push   %ebx
80103e06:	83 ec 0c             	sub    $0xc,%esp
80103e09:	8b 7d 08             	mov    0x8(%ebp),%edi
80103e0c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103e0f:	e8 1c 05 00 00       	call   80104330 <pushcli>
  c = mycpu();
80103e14:	e8 97 f9 ff ff       	call   801037b0 <mycpu>
  p = c->proc;
80103e19:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e1f:	e8 fc 05 00 00       	call   80104420 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80103e24:	85 db                	test   %ebx,%ebx
80103e26:	0f 84 87 00 00 00    	je     80103eb3 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
80103e2c:	85 f6                	test   %esi,%esi
80103e2e:	74 76                	je     80103ea6 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103e30:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103e36:	74 50                	je     80103e88 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103e38:	83 ec 0c             	sub    $0xc,%esp
80103e3b:	68 20 2d 11 80       	push   $0x80112d20
80103e40:	e8 2b 05 00 00       	call   80104370 <acquire>
    release(lk);
80103e45:	89 34 24             	mov    %esi,(%esp)
80103e48:	e8 43 06 00 00       	call   80104490 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103e4d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e50:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103e57:	e8 64 fd ff ff       	call   80103bc0 <sched>

  // Tidy up.
  p->chan = 0;
80103e5c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103e63:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e6a:	e8 21 06 00 00       	call   80104490 <release>
    acquire(lk);
80103e6f:	89 75 08             	mov    %esi,0x8(%ebp)
80103e72:	83 c4 10             	add    $0x10,%esp
  }
}
80103e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e78:	5b                   	pop    %ebx
80103e79:	5e                   	pop    %esi
80103e7a:	5f                   	pop    %edi
80103e7b:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103e7c:	e9 ef 04 00 00       	jmp    80104370 <acquire>
80103e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103e88:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103e8b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103e92:	e8 29 fd ff ff       	call   80103bc0 <sched>

  // Tidy up.
  p->chan = 0;
80103e97:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103e9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ea1:	5b                   	pop    %ebx
80103ea2:	5e                   	pop    %esi
80103ea3:	5f                   	pop    %edi
80103ea4:	5d                   	pop    %ebp
80103ea5:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103ea6:	83 ec 0c             	sub    $0xc,%esp
80103ea9:	68 ef 77 10 80       	push   $0x801077ef
80103eae:	e8 bd c4 ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103eb3:	83 ec 0c             	sub    $0xc,%esp
80103eb6:	68 e9 77 10 80       	push   $0x801077e9
80103ebb:	e8 b0 c4 ff ff       	call   80100370 <panic>

80103ec0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	56                   	push   %esi
80103ec4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103ec5:	e8 66 04 00 00       	call   80104330 <pushcli>
  c = mycpu();
80103eca:	e8 e1 f8 ff ff       	call   801037b0 <mycpu>
  p = c->proc;
80103ecf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103ed5:	e8 46 05 00 00       	call   80104420 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
80103eda:	83 ec 0c             	sub    $0xc,%esp
80103edd:	68 20 2d 11 80       	push   $0x80112d20
80103ee2:	e8 89 04 00 00       	call   80104370 <acquire>
80103ee7:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103eea:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eec:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103ef1:	eb 10                	jmp    80103f03 <wait+0x43>
80103ef3:	90                   	nop
80103ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ef8:	83 eb 80             	sub    $0xffffff80,%ebx
80103efb:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103f01:	74 1d                	je     80103f20 <wait+0x60>
      if(p->parent != curproc)
80103f03:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f06:	75 f0                	jne    80103ef8 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103f08:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f0c:	74 30                	je     80103f3e <wait+0x7e>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f0e:	83 eb 80             	sub    $0xffffff80,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103f11:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f16:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103f1c:	75 e5                	jne    80103f03 <wait+0x43>
80103f1e:	66 90                	xchg   %ax,%ax
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103f20:	85 c0                	test   %eax,%eax
80103f22:	74 70                	je     80103f94 <wait+0xd4>
80103f24:	8b 46 24             	mov    0x24(%esi),%eax
80103f27:	85 c0                	test   %eax,%eax
80103f29:	75 69                	jne    80103f94 <wait+0xd4>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103f2b:	83 ec 08             	sub    $0x8,%esp
80103f2e:	68 20 2d 11 80       	push   $0x80112d20
80103f33:	56                   	push   %esi
80103f34:	e8 c7 fe ff ff       	call   80103e00 <sleep>
  }
80103f39:	83 c4 10             	add    $0x10,%esp
80103f3c:	eb ac                	jmp    80103eea <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103f3e:	83 ec 0c             	sub    $0xc,%esp
80103f41:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103f44:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103f47:	e8 64 e4 ff ff       	call   801023b0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103f4c:	5a                   	pop    %edx
80103f4d:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103f50:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103f57:	e8 34 2d 00 00       	call   80106c90 <freevm>
        p->pid = 0;
80103f5c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103f63:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103f6a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103f6e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103f75:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103f7c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f83:	e8 08 05 00 00       	call   80104490 <release>
        return pid;
80103f88:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103f8e:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f90:	5b                   	pop    %ebx
80103f91:	5e                   	pop    %esi
80103f92:	5d                   	pop    %ebp
80103f93:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103f94:	83 ec 0c             	sub    $0xc,%esp
80103f97:	68 20 2d 11 80       	push   $0x80112d20
80103f9c:	e8 ef 04 00 00       	call   80104490 <release>
      return -1;
80103fa1:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103fa4:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80103fa7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103fac:	5b                   	pop    %ebx
80103fad:	5e                   	pop    %esi
80103fae:	5d                   	pop    %ebp
80103faf:	c3                   	ret    

80103fb0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103fb0:	55                   	push   %ebp
80103fb1:	89 e5                	mov    %esp,%ebp
80103fb3:	53                   	push   %ebx
80103fb4:	83 ec 10             	sub    $0x10,%esp
80103fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103fba:	68 20 2d 11 80       	push   $0x80112d20
80103fbf:	e8 ac 03 00 00       	call   80104370 <acquire>
80103fc4:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fc7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103fcc:	eb 0c                	jmp    80103fda <wakeup+0x2a>
80103fce:	66 90                	xchg   %ax,%ax
80103fd0:	83 e8 80             	sub    $0xffffff80,%eax
80103fd3:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103fd8:	74 1c                	je     80103ff6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
80103fda:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fde:	75 f0                	jne    80103fd0 <wakeup+0x20>
80103fe0:	3b 58 20             	cmp    0x20(%eax),%ebx
80103fe3:	75 eb                	jne    80103fd0 <wakeup+0x20>
      p->state = RUNNABLE;
80103fe5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fec:	83 e8 80             	sub    $0xffffff80,%eax
80103fef:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103ff4:	75 e4                	jne    80103fda <wakeup+0x2a>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103ff6:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103ffd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104000:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80104001:	e9 8a 04 00 00       	jmp    80104490 <release>
80104006:	8d 76 00             	lea    0x0(%esi),%esi
80104009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104010 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	53                   	push   %ebx
80104014:	83 ec 10             	sub    $0x10,%esp
80104017:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010401a:	68 20 2d 11 80       	push   $0x80112d20
8010401f:	e8 4c 03 00 00       	call   80104370 <acquire>
80104024:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104027:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010402c:	eb 0c                	jmp    8010403a <kill+0x2a>
8010402e:	66 90                	xchg   %ax,%ax
80104030:	83 e8 80             	sub    $0xffffff80,%eax
80104033:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80104038:	74 3e                	je     80104078 <kill+0x68>
    if(p->pid == pid){
8010403a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010403d:	75 f1                	jne    80104030 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010403f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80104043:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010404a:	74 1c                	je     80104068 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
8010404c:	83 ec 0c             	sub    $0xc,%esp
8010404f:	68 20 2d 11 80       	push   $0x80112d20
80104054:	e8 37 04 00 00       	call   80104490 <release>
      return 0;
80104059:	83 c4 10             	add    $0x10,%esp
8010405c:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
8010405e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104061:	c9                   	leave  
80104062:	c3                   	ret    
80104063:	90                   	nop
80104064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80104068:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010406f:	eb db                	jmp    8010404c <kill+0x3c>
80104071:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104078:	83 ec 0c             	sub    $0xc,%esp
8010407b:	68 20 2d 11 80       	push   $0x80112d20
80104080:	e8 0b 04 00 00       	call   80104490 <release>
  return -1;
80104085:	83 c4 10             	add    $0x10,%esp
80104088:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010408d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104090:	c9                   	leave  
80104091:	c3                   	ret    
80104092:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040a0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	57                   	push   %edi
801040a4:	56                   	push   %esi
801040a5:	53                   	push   %ebx
801040a6:	8d 75 e8             	lea    -0x18(%ebp),%esi
801040a9:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
801040ae:	83 ec 3c             	sub    $0x3c,%esp
801040b1:	eb 24                	jmp    801040d7 <procdump+0x37>
801040b3:	90                   	nop
801040b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801040b8:	83 ec 0c             	sub    $0xc,%esp
801040bb:	68 7f 7b 10 80       	push   $0x80107b7f
801040c0:	e8 9b c5 ff ff       	call   80100660 <cprintf>
801040c5:	83 c4 10             	add    $0x10,%esp
801040c8:	83 eb 80             	sub    $0xffffff80,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040cb:	81 fb c0 4d 11 80    	cmp    $0x80114dc0,%ebx
801040d1:	0f 84 81 00 00 00    	je     80104158 <procdump+0xb8>
    if(p->state == UNUSED)
801040d7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801040da:	85 c0                	test   %eax,%eax
801040dc:	74 ea                	je     801040c8 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040de:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
801040e1:	ba 00 78 10 80       	mov    $0x80107800,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801040e6:	77 11                	ja     801040f9 <procdump+0x59>
801040e8:	8b 14 85 60 78 10 80 	mov    -0x7fef87a0(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
801040ef:	b8 00 78 10 80       	mov    $0x80107800,%eax
801040f4:	85 d2                	test   %edx,%edx
801040f6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801040f9:	53                   	push   %ebx
801040fa:	52                   	push   %edx
801040fb:	ff 73 a4             	pushl  -0x5c(%ebx)
801040fe:	68 04 78 10 80       	push   $0x80107804
80104103:	e8 58 c5 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104108:	83 c4 10             	add    $0x10,%esp
8010410b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010410f:	75 a7                	jne    801040b8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104111:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104114:	83 ec 08             	sub    $0x8,%esp
80104117:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010411a:	50                   	push   %eax
8010411b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010411e:	8b 40 0c             	mov    0xc(%eax),%eax
80104121:	83 c0 08             	add    $0x8,%eax
80104124:	50                   	push   %eax
80104125:	e8 66 01 00 00       	call   80104290 <getcallerpcs>
8010412a:	83 c4 10             	add    $0x10,%esp
8010412d:	8d 76 00             	lea    0x0(%esi),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104130:	8b 17                	mov    (%edi),%edx
80104132:	85 d2                	test   %edx,%edx
80104134:	74 82                	je     801040b8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104136:	83 ec 08             	sub    $0x8,%esp
80104139:	83 c7 04             	add    $0x4,%edi
8010413c:	52                   	push   %edx
8010413d:	68 21 72 10 80       	push   $0x80107221
80104142:	e8 19 c5 ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104147:	83 c4 10             	add    $0x10,%esp
8010414a:	39 f7                	cmp    %esi,%edi
8010414c:	75 e2                	jne    80104130 <procdump+0x90>
8010414e:	e9 65 ff ff ff       	jmp    801040b8 <procdump+0x18>
80104153:	90                   	nop
80104154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104158:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010415b:	5b                   	pop    %ebx
8010415c:	5e                   	pop    %esi
8010415d:	5f                   	pop    %edi
8010415e:	5d                   	pop    %ebp
8010415f:	c3                   	ret    

80104160 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	53                   	push   %ebx
80104164:	83 ec 0c             	sub    $0xc,%esp
80104167:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010416a:	68 78 78 10 80       	push   $0x80107878
8010416f:	8d 43 04             	lea    0x4(%ebx),%eax
80104172:	50                   	push   %eax
80104173:	e8 f8 00 00 00       	call   80104270 <initlock>
  lk->name = name;
80104178:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010417b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104181:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104184:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010418b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010418e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104191:	c9                   	leave  
80104192:	c3                   	ret    
80104193:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041a0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	56                   	push   %esi
801041a4:	53                   	push   %ebx
801041a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801041a8:	83 ec 0c             	sub    $0xc,%esp
801041ab:	8d 73 04             	lea    0x4(%ebx),%esi
801041ae:	56                   	push   %esi
801041af:	e8 bc 01 00 00       	call   80104370 <acquire>
  while (lk->locked) {
801041b4:	8b 13                	mov    (%ebx),%edx
801041b6:	83 c4 10             	add    $0x10,%esp
801041b9:	85 d2                	test   %edx,%edx
801041bb:	74 16                	je     801041d3 <acquiresleep+0x33>
801041bd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801041c0:	83 ec 08             	sub    $0x8,%esp
801041c3:	56                   	push   %esi
801041c4:	53                   	push   %ebx
801041c5:	e8 36 fc ff ff       	call   80103e00 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801041ca:	8b 03                	mov    (%ebx),%eax
801041cc:	83 c4 10             	add    $0x10,%esp
801041cf:	85 c0                	test   %eax,%eax
801041d1:	75 ed                	jne    801041c0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801041d3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801041d9:	e8 72 f6 ff ff       	call   80103850 <myproc>
801041de:	8b 40 10             	mov    0x10(%eax),%eax
801041e1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801041e4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801041e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041ea:	5b                   	pop    %ebx
801041eb:	5e                   	pop    %esi
801041ec:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
801041ed:	e9 9e 02 00 00       	jmp    80104490 <release>
801041f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104200 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104200:	55                   	push   %ebp
80104201:	89 e5                	mov    %esp,%ebp
80104203:	56                   	push   %esi
80104204:	53                   	push   %ebx
80104205:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104208:	83 ec 0c             	sub    $0xc,%esp
8010420b:	8d 73 04             	lea    0x4(%ebx),%esi
8010420e:	56                   	push   %esi
8010420f:	e8 5c 01 00 00       	call   80104370 <acquire>
  lk->locked = 0;
80104214:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010421a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104221:	89 1c 24             	mov    %ebx,(%esp)
80104224:	e8 87 fd ff ff       	call   80103fb0 <wakeup>
  release(&lk->lk);
80104229:	89 75 08             	mov    %esi,0x8(%ebp)
8010422c:	83 c4 10             	add    $0x10,%esp
}
8010422f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104232:	5b                   	pop    %ebx
80104233:	5e                   	pop    %esi
80104234:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104235:	e9 56 02 00 00       	jmp    80104490 <release>
8010423a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104240 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	56                   	push   %esi
80104244:	53                   	push   %ebx
80104245:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104248:	83 ec 0c             	sub    $0xc,%esp
8010424b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010424e:	53                   	push   %ebx
8010424f:	e8 1c 01 00 00       	call   80104370 <acquire>
  r = lk->locked;
80104254:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104256:	89 1c 24             	mov    %ebx,(%esp)
80104259:	e8 32 02 00 00       	call   80104490 <release>
  return r;
}
8010425e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104261:	89 f0                	mov    %esi,%eax
80104263:	5b                   	pop    %ebx
80104264:	5e                   	pop    %esi
80104265:	5d                   	pop    %ebp
80104266:	c3                   	ret    
80104267:	66 90                	xchg   %ax,%ax
80104269:	66 90                	xchg   %ax,%ax
8010426b:	66 90                	xchg   %ax,%ax
8010426d:	66 90                	xchg   %ax,%ax
8010426f:	90                   	nop

80104270 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104276:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104279:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010427f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104282:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104289:	5d                   	pop    %ebp
8010428a:	c3                   	ret    
8010428b:	90                   	nop
8010428c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104290 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104290:	55                   	push   %ebp
80104291:	89 e5                	mov    %esp,%ebp
80104293:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104294:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104297:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010429a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010429d:	31 c0                	xor    %eax,%eax
8010429f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801042a0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801042a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801042ac:	77 1a                	ja     801042c8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801042ae:	8b 5a 04             	mov    0x4(%edx),%ebx
801042b1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801042b4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801042b7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801042b9:	83 f8 0a             	cmp    $0xa,%eax
801042bc:	75 e2                	jne    801042a0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801042be:	5b                   	pop    %ebx
801042bf:	5d                   	pop    %ebp
801042c0:	c3                   	ret    
801042c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801042c8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801042cf:	83 c0 01             	add    $0x1,%eax
801042d2:	83 f8 0a             	cmp    $0xa,%eax
801042d5:	74 e7                	je     801042be <getcallerpcs+0x2e>
    pcs[i] = 0;
801042d7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801042de:	83 c0 01             	add    $0x1,%eax
801042e1:	83 f8 0a             	cmp    $0xa,%eax
801042e4:	75 e2                	jne    801042c8 <getcallerpcs+0x38>
801042e6:	eb d6                	jmp    801042be <getcallerpcs+0x2e>
801042e8:	90                   	nop
801042e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042f0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	53                   	push   %ebx
801042f4:	83 ec 04             	sub    $0x4,%esp
801042f7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801042fa:	8b 02                	mov    (%edx),%eax
801042fc:	85 c0                	test   %eax,%eax
801042fe:	75 10                	jne    80104310 <holding+0x20>
}
80104300:	83 c4 04             	add    $0x4,%esp
80104303:	31 c0                	xor    %eax,%eax
80104305:	5b                   	pop    %ebx
80104306:	5d                   	pop    %ebp
80104307:	c3                   	ret    
80104308:	90                   	nop
80104309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104310:	8b 5a 08             	mov    0x8(%edx),%ebx
80104313:	e8 98 f4 ff ff       	call   801037b0 <mycpu>
80104318:	39 c3                	cmp    %eax,%ebx
8010431a:	0f 94 c0             	sete   %al
}
8010431d:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104320:	0f b6 c0             	movzbl %al,%eax
}
80104323:	5b                   	pop    %ebx
80104324:	5d                   	pop    %ebp
80104325:	c3                   	ret    
80104326:	8d 76 00             	lea    0x0(%esi),%esi
80104329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104330 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104330:	55                   	push   %ebp
80104331:	89 e5                	mov    %esp,%ebp
80104333:	53                   	push   %ebx
80104334:	83 ec 04             	sub    $0x4,%esp
80104337:	9c                   	pushf  
80104338:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104339:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010433a:	e8 71 f4 ff ff       	call   801037b0 <mycpu>
8010433f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104345:	85 c0                	test   %eax,%eax
80104347:	75 11                	jne    8010435a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104349:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010434f:	e8 5c f4 ff ff       	call   801037b0 <mycpu>
80104354:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010435a:	e8 51 f4 ff ff       	call   801037b0 <mycpu>
8010435f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104366:	83 c4 04             	add    $0x4,%esp
80104369:	5b                   	pop    %ebx
8010436a:	5d                   	pop    %ebp
8010436b:	c3                   	ret    
8010436c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104370 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	56                   	push   %esi
80104374:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104375:	e8 b6 ff ff ff       	call   80104330 <pushcli>
  if(holding(lk))
8010437a:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010437d:	8b 03                	mov    (%ebx),%eax
8010437f:	85 c0                	test   %eax,%eax
80104381:	75 7d                	jne    80104400 <acquire+0x90>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104383:	ba 01 00 00 00       	mov    $0x1,%edx
80104388:	eb 09                	jmp    80104393 <acquire+0x23>
8010438a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104390:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104393:	89 d0                	mov    %edx,%eax
80104395:	f0 87 03             	lock xchg %eax,(%ebx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104398:	85 c0                	test   %eax,%eax
8010439a:	75 f4                	jne    80104390 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010439c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801043a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801043a4:	e8 07 f4 ff ff       	call   801037b0 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801043a9:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
801043ab:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801043ae:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043b1:	31 c0                	xor    %eax,%eax
801043b3:	90                   	nop
801043b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801043b8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801043be:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801043c4:	77 1a                	ja     801043e0 <acquire+0x70>
      break;
    pcs[i] = ebp[1];     // saved %eip
801043c6:	8b 5a 04             	mov    0x4(%edx),%ebx
801043c9:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043cc:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801043cf:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043d1:	83 f8 0a             	cmp    $0xa,%eax
801043d4:	75 e2                	jne    801043b8 <acquire+0x48>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
801043d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043d9:	5b                   	pop    %ebx
801043da:	5e                   	pop    %esi
801043db:	5d                   	pop    %ebp
801043dc:	c3                   	ret    
801043dd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801043e0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801043e7:	83 c0 01             	add    $0x1,%eax
801043ea:	83 f8 0a             	cmp    $0xa,%eax
801043ed:	74 e7                	je     801043d6 <acquire+0x66>
    pcs[i] = 0;
801043ef:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801043f6:	83 c0 01             	add    $0x1,%eax
801043f9:	83 f8 0a             	cmp    $0xa,%eax
801043fc:	75 e2                	jne    801043e0 <acquire+0x70>
801043fe:	eb d6                	jmp    801043d6 <acquire+0x66>

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104400:	8b 73 08             	mov    0x8(%ebx),%esi
80104403:	e8 a8 f3 ff ff       	call   801037b0 <mycpu>
80104408:	39 c6                	cmp    %eax,%esi
8010440a:	0f 85 73 ff ff ff    	jne    80104383 <acquire+0x13>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104410:	83 ec 0c             	sub    $0xc,%esp
80104413:	68 83 78 10 80       	push   $0x80107883
80104418:	e8 53 bf ff ff       	call   80100370 <panic>
8010441d:	8d 76 00             	lea    0x0(%esi),%esi

80104420 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104426:	9c                   	pushf  
80104427:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104428:	f6 c4 02             	test   $0x2,%ah
8010442b:	75 52                	jne    8010447f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010442d:	e8 7e f3 ff ff       	call   801037b0 <mycpu>
80104432:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104438:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010443b:	85 d2                	test   %edx,%edx
8010443d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104443:	78 2d                	js     80104472 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104445:	e8 66 f3 ff ff       	call   801037b0 <mycpu>
8010444a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104450:	85 d2                	test   %edx,%edx
80104452:	74 0c                	je     80104460 <popcli+0x40>
    sti();
}
80104454:	c9                   	leave  
80104455:	c3                   	ret    
80104456:	8d 76 00             	lea    0x0(%esi),%esi
80104459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104460:	e8 4b f3 ff ff       	call   801037b0 <mycpu>
80104465:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010446b:	85 c0                	test   %eax,%eax
8010446d:	74 e5                	je     80104454 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
8010446f:	fb                   	sti    
    sti();
}
80104470:	c9                   	leave  
80104471:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104472:	83 ec 0c             	sub    $0xc,%esp
80104475:	68 a2 78 10 80       	push   $0x801078a2
8010447a:	e8 f1 be ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
8010447f:	83 ec 0c             	sub    $0xc,%esp
80104482:	68 8b 78 10 80       	push   $0x8010788b
80104487:	e8 e4 be ff ff       	call   80100370 <panic>
8010448c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104490 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	56                   	push   %esi
80104494:	53                   	push   %ebx
80104495:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104498:	8b 03                	mov    (%ebx),%eax
8010449a:	85 c0                	test   %eax,%eax
8010449c:	75 12                	jne    801044b0 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
8010449e:	83 ec 0c             	sub    $0xc,%esp
801044a1:	68 a9 78 10 80       	push   $0x801078a9
801044a6:	e8 c5 be ff ff       	call   80100370 <panic>
801044ab:	90                   	nop
801044ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801044b0:	8b 73 08             	mov    0x8(%ebx),%esi
801044b3:	e8 f8 f2 ff ff       	call   801037b0 <mycpu>
801044b8:	39 c6                	cmp    %eax,%esi
801044ba:	75 e2                	jne    8010449e <release+0xe>
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");

  lk->pcs[0] = 0;
801044bc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801044c3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801044ca:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801044cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
801044d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044d8:	5b                   	pop    %ebx
801044d9:	5e                   	pop    %esi
801044da:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
801044db:	e9 40 ff ff ff       	jmp    80104420 <popcli>

801044e0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801044e0:	55                   	push   %ebp
801044e1:	89 e5                	mov    %esp,%ebp
801044e3:	57                   	push   %edi
801044e4:	53                   	push   %ebx
801044e5:	8b 55 08             	mov    0x8(%ebp),%edx
801044e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801044eb:	f6 c2 03             	test   $0x3,%dl
801044ee:	75 05                	jne    801044f5 <memset+0x15>
801044f0:	f6 c1 03             	test   $0x3,%cl
801044f3:	74 13                	je     80104508 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
801044f5:	89 d7                	mov    %edx,%edi
801044f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801044fa:	fc                   	cld    
801044fb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801044fd:	5b                   	pop    %ebx
801044fe:	89 d0                	mov    %edx,%eax
80104500:	5f                   	pop    %edi
80104501:	5d                   	pop    %ebp
80104502:	c3                   	ret    
80104503:	90                   	nop
80104504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104508:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
8010450c:	c1 e9 02             	shr    $0x2,%ecx
8010450f:	89 fb                	mov    %edi,%ebx
80104511:	89 f8                	mov    %edi,%eax
80104513:	c1 e3 18             	shl    $0x18,%ebx
80104516:	c1 e0 10             	shl    $0x10,%eax
80104519:	09 d8                	or     %ebx,%eax
8010451b:	09 f8                	or     %edi,%eax
8010451d:	c1 e7 08             	shl    $0x8,%edi
80104520:	09 f8                	or     %edi,%eax
80104522:	89 d7                	mov    %edx,%edi
80104524:	fc                   	cld    
80104525:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104527:	5b                   	pop    %ebx
80104528:	89 d0                	mov    %edx,%eax
8010452a:	5f                   	pop    %edi
8010452b:	5d                   	pop    %ebp
8010452c:	c3                   	ret    
8010452d:	8d 76 00             	lea    0x0(%esi),%esi

80104530 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	57                   	push   %edi
80104534:	56                   	push   %esi
80104535:	8b 45 10             	mov    0x10(%ebp),%eax
80104538:	53                   	push   %ebx
80104539:	8b 75 0c             	mov    0xc(%ebp),%esi
8010453c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010453f:	85 c0                	test   %eax,%eax
80104541:	74 29                	je     8010456c <memcmp+0x3c>
    if(*s1 != *s2)
80104543:	0f b6 13             	movzbl (%ebx),%edx
80104546:	0f b6 0e             	movzbl (%esi),%ecx
80104549:	38 d1                	cmp    %dl,%cl
8010454b:	75 2b                	jne    80104578 <memcmp+0x48>
8010454d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104550:	31 c0                	xor    %eax,%eax
80104552:	eb 14                	jmp    80104568 <memcmp+0x38>
80104554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104558:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
8010455d:	83 c0 01             	add    $0x1,%eax
80104560:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104564:	38 ca                	cmp    %cl,%dl
80104566:	75 10                	jne    80104578 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104568:	39 f8                	cmp    %edi,%eax
8010456a:	75 ec                	jne    80104558 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010456c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010456d:	31 c0                	xor    %eax,%eax
}
8010456f:	5e                   	pop    %esi
80104570:	5f                   	pop    %edi
80104571:	5d                   	pop    %ebp
80104572:	c3                   	ret    
80104573:	90                   	nop
80104574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104578:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
8010457b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
8010457c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010457e:	5e                   	pop    %esi
8010457f:	5f                   	pop    %edi
80104580:	5d                   	pop    %ebp
80104581:	c3                   	ret    
80104582:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104590 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	56                   	push   %esi
80104594:	53                   	push   %ebx
80104595:	8b 45 08             	mov    0x8(%ebp),%eax
80104598:	8b 75 0c             	mov    0xc(%ebp),%esi
8010459b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010459e:	39 c6                	cmp    %eax,%esi
801045a0:	73 2e                	jae    801045d0 <memmove+0x40>
801045a2:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
801045a5:	39 c8                	cmp    %ecx,%eax
801045a7:	73 27                	jae    801045d0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
801045a9:	85 db                	test   %ebx,%ebx
801045ab:	8d 53 ff             	lea    -0x1(%ebx),%edx
801045ae:	74 17                	je     801045c7 <memmove+0x37>
      *--d = *--s;
801045b0:	29 d9                	sub    %ebx,%ecx
801045b2:	89 cb                	mov    %ecx,%ebx
801045b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045b8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801045bc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801045bf:	83 ea 01             	sub    $0x1,%edx
801045c2:	83 fa ff             	cmp    $0xffffffff,%edx
801045c5:	75 f1                	jne    801045b8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801045c7:	5b                   	pop    %ebx
801045c8:	5e                   	pop    %esi
801045c9:	5d                   	pop    %ebp
801045ca:	c3                   	ret    
801045cb:	90                   	nop
801045cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801045d0:	31 d2                	xor    %edx,%edx
801045d2:	85 db                	test   %ebx,%ebx
801045d4:	74 f1                	je     801045c7 <memmove+0x37>
801045d6:	8d 76 00             	lea    0x0(%esi),%esi
801045d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
801045e0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801045e4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801045e7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801045ea:	39 d3                	cmp    %edx,%ebx
801045ec:	75 f2                	jne    801045e0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
801045ee:	5b                   	pop    %ebx
801045ef:	5e                   	pop    %esi
801045f0:	5d                   	pop    %ebp
801045f1:	c3                   	ret    
801045f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104600 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104603:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104604:	eb 8a                	jmp    80104590 <memmove>
80104606:	8d 76 00             	lea    0x0(%esi),%esi
80104609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104610 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	57                   	push   %edi
80104614:	56                   	push   %esi
80104615:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104618:	53                   	push   %ebx
80104619:	8b 7d 08             	mov    0x8(%ebp),%edi
8010461c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010461f:	85 c9                	test   %ecx,%ecx
80104621:	74 37                	je     8010465a <strncmp+0x4a>
80104623:	0f b6 17             	movzbl (%edi),%edx
80104626:	0f b6 1e             	movzbl (%esi),%ebx
80104629:	84 d2                	test   %dl,%dl
8010462b:	74 3f                	je     8010466c <strncmp+0x5c>
8010462d:	38 d3                	cmp    %dl,%bl
8010462f:	75 3b                	jne    8010466c <strncmp+0x5c>
80104631:	8d 47 01             	lea    0x1(%edi),%eax
80104634:	01 cf                	add    %ecx,%edi
80104636:	eb 1b                	jmp    80104653 <strncmp+0x43>
80104638:	90                   	nop
80104639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104640:	0f b6 10             	movzbl (%eax),%edx
80104643:	84 d2                	test   %dl,%dl
80104645:	74 21                	je     80104668 <strncmp+0x58>
80104647:	0f b6 19             	movzbl (%ecx),%ebx
8010464a:	83 c0 01             	add    $0x1,%eax
8010464d:	89 ce                	mov    %ecx,%esi
8010464f:	38 da                	cmp    %bl,%dl
80104651:	75 19                	jne    8010466c <strncmp+0x5c>
80104653:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104655:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104658:	75 e6                	jne    80104640 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
8010465a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
8010465b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
8010465d:	5e                   	pop    %esi
8010465e:	5f                   	pop    %edi
8010465f:	5d                   	pop    %ebp
80104660:	c3                   	ret    
80104661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104668:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010466c:	0f b6 c2             	movzbl %dl,%eax
8010466f:	29 d8                	sub    %ebx,%eax
}
80104671:	5b                   	pop    %ebx
80104672:	5e                   	pop    %esi
80104673:	5f                   	pop    %edi
80104674:	5d                   	pop    %ebp
80104675:	c3                   	ret    
80104676:	8d 76 00             	lea    0x0(%esi),%esi
80104679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104680 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	56                   	push   %esi
80104684:	53                   	push   %ebx
80104685:	8b 45 08             	mov    0x8(%ebp),%eax
80104688:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010468b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010468e:	89 c2                	mov    %eax,%edx
80104690:	eb 19                	jmp    801046ab <strncpy+0x2b>
80104692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104698:	83 c3 01             	add    $0x1,%ebx
8010469b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010469f:	83 c2 01             	add    $0x1,%edx
801046a2:	84 c9                	test   %cl,%cl
801046a4:	88 4a ff             	mov    %cl,-0x1(%edx)
801046a7:	74 09                	je     801046b2 <strncpy+0x32>
801046a9:	89 f1                	mov    %esi,%ecx
801046ab:	85 c9                	test   %ecx,%ecx
801046ad:	8d 71 ff             	lea    -0x1(%ecx),%esi
801046b0:	7f e6                	jg     80104698 <strncpy+0x18>
    ;
  while(n-- > 0)
801046b2:	31 c9                	xor    %ecx,%ecx
801046b4:	85 f6                	test   %esi,%esi
801046b6:	7e 17                	jle    801046cf <strncpy+0x4f>
801046b8:	90                   	nop
801046b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801046c0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801046c4:	89 f3                	mov    %esi,%ebx
801046c6:	83 c1 01             	add    $0x1,%ecx
801046c9:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801046cb:	85 db                	test   %ebx,%ebx
801046cd:	7f f1                	jg     801046c0 <strncpy+0x40>
    *s++ = 0;
  return os;
}
801046cf:	5b                   	pop    %ebx
801046d0:	5e                   	pop    %esi
801046d1:	5d                   	pop    %ebp
801046d2:	c3                   	ret    
801046d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801046d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046e0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	56                   	push   %esi
801046e4:	53                   	push   %ebx
801046e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801046e8:	8b 45 08             	mov    0x8(%ebp),%eax
801046eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801046ee:	85 c9                	test   %ecx,%ecx
801046f0:	7e 26                	jle    80104718 <safestrcpy+0x38>
801046f2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801046f6:	89 c1                	mov    %eax,%ecx
801046f8:	eb 17                	jmp    80104711 <safestrcpy+0x31>
801046fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104700:	83 c2 01             	add    $0x1,%edx
80104703:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104707:	83 c1 01             	add    $0x1,%ecx
8010470a:	84 db                	test   %bl,%bl
8010470c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010470f:	74 04                	je     80104715 <safestrcpy+0x35>
80104711:	39 f2                	cmp    %esi,%edx
80104713:	75 eb                	jne    80104700 <safestrcpy+0x20>
    ;
  *s = 0;
80104715:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104718:	5b                   	pop    %ebx
80104719:	5e                   	pop    %esi
8010471a:	5d                   	pop    %ebp
8010471b:	c3                   	ret    
8010471c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104720 <strlen>:

int
strlen(const char *s)
{
80104720:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104721:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104723:	89 e5                	mov    %esp,%ebp
80104725:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104728:	80 3a 00             	cmpb   $0x0,(%edx)
8010472b:	74 0c                	je     80104739 <strlen+0x19>
8010472d:	8d 76 00             	lea    0x0(%esi),%esi
80104730:	83 c0 01             	add    $0x1,%eax
80104733:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104737:	75 f7                	jne    80104730 <strlen+0x10>
    ;
  return n;
}
80104739:	5d                   	pop    %ebp
8010473a:	c3                   	ret    

8010473b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010473b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010473f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104743:	55                   	push   %ebp
  pushl %ebx
80104744:	53                   	push   %ebx
  pushl %esi
80104745:	56                   	push   %esi
  pushl %edi
80104746:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104747:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104749:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010474b:	5f                   	pop    %edi
  popl %esi
8010474c:	5e                   	pop    %esi
  popl %ebx
8010474d:	5b                   	pop    %ebx
  popl %ebp
8010474e:	5d                   	pop    %ebp
  ret
8010474f:	c3                   	ret    

80104750 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
  //cs153 updated sz check
  //if(((addr >= curproc->sz || addr+4 > curproc->sz) && (addr < ((KERNBASE - 1) - curproc->stack_sz))) || addr > (KERNBASE - 1)){
    //return -1;
  //}
  //cs153
  *ip = *(int*)(addr);
80104753:	8b 45 08             	mov    0x8(%ebp),%eax
80104756:	8b 10                	mov    (%eax),%edx
80104758:	8b 45 0c             	mov    0xc(%ebp),%eax
8010475b:	89 10                	mov    %edx,(%eax)
  return 0;
}
8010475d:	31 c0                	xor    %eax,%eax
8010475f:	5d                   	pop    %ebp
80104760:	c3                   	ret    
80104761:	eb 0d                	jmp    80104770 <fetchstr>
80104763:	90                   	nop
80104764:	90                   	nop
80104765:	90                   	nop
80104766:	90                   	nop
80104767:	90                   	nop
80104768:	90                   	nop
80104769:	90                   	nop
8010476a:	90                   	nop
8010476b:	90                   	nop
8010476c:	90                   	nop
8010476d:	90                   	nop
8010476e:	90                   	nop
8010476f:	90                   	nop

80104770 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	53                   	push   %ebx
80104774:	83 ec 04             	sub    $0x4,%esp
80104777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010477a:	e8 d1 f0 ff ff       	call   80103850 <myproc>

  //cs153 removed sz check
  *pp = (char*)addr;
8010477f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104782:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104784:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104786:	39 c3                	cmp    %eax,%ebx
80104788:	73 1a                	jae    801047a4 <fetchstr+0x34>
    if(*s == 0)
8010478a:	80 3b 00             	cmpb   $0x0,(%ebx)
8010478d:	89 da                	mov    %ebx,%edx
8010478f:	75 0c                	jne    8010479d <fetchstr+0x2d>
80104791:	eb 1d                	jmp    801047b0 <fetchstr+0x40>
80104793:	90                   	nop
80104794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104798:	80 3a 00             	cmpb   $0x0,(%edx)
8010479b:	74 13                	je     801047b0 <fetchstr+0x40>
  struct proc *curproc = myproc();

  //cs153 removed sz check
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
8010479d:	83 c2 01             	add    $0x1,%edx
801047a0:	39 d0                	cmp    %edx,%eax
801047a2:	77 f4                	ja     80104798 <fetchstr+0x28>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
801047a4:	83 c4 04             	add    $0x4,%esp
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
801047a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801047ac:	5b                   	pop    %ebx
801047ad:	5d                   	pop    %ebp
801047ae:	c3                   	ret    
801047af:	90                   	nop
801047b0:	83 c4 04             	add    $0x4,%esp
  //cs153 removed sz check
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
801047b3:	89 d0                	mov    %edx,%eax
801047b5:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801047b7:	5b                   	pop    %ebx
801047b8:	5d                   	pop    %ebp
801047b9:	c3                   	ret    
801047ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047c0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{  
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	83 ec 08             	sub    $0x8,%esp
  //cs153
  //if(ip == 0){
    //return -1;
  //}
  //cs153
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801047c6:	e8 85 f0 ff ff       	call   80103850 <myproc>
801047cb:	8b 40 18             	mov    0x18(%eax),%eax
  //cs153 updated sz check
  //if(((addr >= curproc->sz || addr+4 > curproc->sz) && (addr < ((KERNBASE - 1) - curproc->stack_sz))) || addr > (KERNBASE - 1)){
    //return -1;
  //}
  //cs153
  *ip = *(int*)(addr);
801047ce:	8b 55 08             	mov    0x8(%ebp),%edx
801047d1:	8b 40 44             	mov    0x44(%eax),%eax
801047d4:	8b 54 90 04          	mov    0x4(%eax,%edx,4),%edx
801047d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801047db:	89 10                	mov    %edx,(%eax)
  //if(ip == 0){
    //return -1;
  //}
  //cs153
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
801047dd:	31 c0                	xor    %eax,%eax
801047df:	c9                   	leave  
801047e0:	c3                   	ret    
801047e1:	eb 0d                	jmp    801047f0 <argptr>
801047e3:	90                   	nop
801047e4:	90                   	nop
801047e5:	90                   	nop
801047e6:	90                   	nop
801047e7:	90                   	nop
801047e8:	90                   	nop
801047e9:	90                   	nop
801047ea:	90                   	nop
801047eb:	90                   	nop
801047ec:	90                   	nop
801047ed:	90                   	nop
801047ee:	90                   	nop
801047ef:	90                   	nop

801047f0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	83 ec 08             	sub    $0x8,%esp
  //cs153
  //if(ip == 0){
    //return -1;
  //}
  //cs153
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801047f6:	e8 55 f0 ff ff       	call   80103850 <myproc>
801047fb:	8b 40 18             	mov    0x18(%eax),%eax
  //}
  //cs153
  if(argint(n, &i) < 0)
    return -1;
  //cs153 removed sz check
  *pp = (char*)i;
801047fe:	8b 55 08             	mov    0x8(%ebp),%edx
  //cs153 updated sz check
  //if(((addr >= curproc->sz || addr+4 > curproc->sz) && (addr < ((KERNBASE - 1) - curproc->stack_sz))) || addr > (KERNBASE - 1)){
    //return -1;
  //}
  //cs153
  *ip = *(int*)(addr);
80104801:	8b 40 44             	mov    0x44(%eax),%eax
  //}
  //cs153
  if(argint(n, &i) < 0)
    return -1;
  //cs153 removed sz check
  *pp = (char*)i;
80104804:	8b 54 90 04          	mov    0x4(%eax,%edx,4),%edx
80104808:	8b 45 0c             	mov    0xc(%ebp),%eax
8010480b:	89 10                	mov    %edx,(%eax)
  return 0;
}
8010480d:	31 c0                	xor    %eax,%eax
8010480f:	c9                   	leave  
80104810:	c3                   	ret    
80104811:	eb 0d                	jmp    80104820 <argstr>
80104813:	90                   	nop
80104814:	90                   	nop
80104815:	90                   	nop
80104816:	90                   	nop
80104817:	90                   	nop
80104818:	90                   	nop
80104819:	90                   	nop
8010481a:	90                   	nop
8010481b:	90                   	nop
8010481c:	90                   	nop
8010481d:	90                   	nop
8010481e:	90                   	nop
8010481f:	90                   	nop

80104820 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	53                   	push   %ebx
80104824:	83 ec 04             	sub    $0x4,%esp
  //cs153
  //if(ip == 0){
    //return -1;
  //}
  //cs153
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104827:	e8 24 f0 ff ff       	call   80103850 <myproc>
8010482c:	8b 40 18             	mov    0x18(%eax),%eax
  //cs153 updated sz check
  //if(((addr >= curproc->sz || addr+4 > curproc->sz) && (addr < ((KERNBASE - 1) - curproc->stack_sz))) || addr > (KERNBASE - 1)){
    //return -1;
  //}
  //cs153
  *ip = *(int*)(addr);
8010482f:	8b 55 08             	mov    0x8(%ebp),%edx
80104832:	8b 40 44             	mov    0x44(%eax),%eax
80104835:	8b 5c 90 04          	mov    0x4(%eax,%edx,4),%ebx
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;
  struct proc *curproc = myproc();
80104839:	e8 12 f0 ff ff       	call   80103850 <myproc>

  //cs153 removed sz check
  *pp = (char*)addr;
8010483e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104841:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104843:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104845:	39 c3                	cmp    %eax,%ebx
80104847:	73 1b                	jae    80104864 <argstr+0x44>
    if(*s == 0)
80104849:	80 3b 00             	cmpb   $0x0,(%ebx)
8010484c:	89 da                	mov    %ebx,%edx
8010484e:	75 0d                	jne    8010485d <argstr+0x3d>
80104850:	eb 1e                	jmp    80104870 <argstr+0x50>
80104852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104858:	80 3a 00             	cmpb   $0x0,(%edx)
8010485b:	74 13                	je     80104870 <argstr+0x50>
  struct proc *curproc = myproc();

  //cs153 removed sz check
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
8010485d:	83 c2 01             	add    $0x1,%edx
80104860:	39 d0                	cmp    %edx,%eax
80104862:	77 f4                	ja     80104858 <argstr+0x38>
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104864:	83 c4 04             	add    $0x4,%esp
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
80104867:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010486c:	5b                   	pop    %ebx
8010486d:	5d                   	pop    %ebp
8010486e:	c3                   	ret    
8010486f:	90                   	nop
80104870:	83 c4 04             	add    $0x4,%esp
  //cs153 removed sz check
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104873:	89 d0                	mov    %edx,%eax
80104875:	29 d8                	sub    %ebx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104877:	5b                   	pop    %ebx
80104878:	5d                   	pop    %ebp
80104879:	c3                   	ret    
8010487a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104880 <syscall>:
[SYS_shm_close] sys_shm_close
};

void
syscall(void)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	56                   	push   %esi
80104884:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104885:	e8 c6 ef ff ff       	call   80103850 <myproc>

  num = curproc->tf->eax;
8010488a:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
8010488d:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010488f:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104892:	8d 50 ff             	lea    -0x1(%eax),%edx
80104895:	83 fa 16             	cmp    $0x16,%edx
80104898:	77 1e                	ja     801048b8 <syscall+0x38>
8010489a:	8b 14 85 e0 78 10 80 	mov    -0x7fef8720(,%eax,4),%edx
801048a1:	85 d2                	test   %edx,%edx
801048a3:	74 13                	je     801048b8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801048a5:	ff d2                	call   *%edx
801048a7:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801048aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048ad:	5b                   	pop    %ebx
801048ae:	5e                   	pop    %esi
801048af:	5d                   	pop    %ebp
801048b0:	c3                   	ret    
801048b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801048b8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801048b9:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801048bc:	50                   	push   %eax
801048bd:	ff 73 10             	pushl  0x10(%ebx)
801048c0:	68 b1 78 10 80       	push   $0x801078b1
801048c5:	e8 96 bd ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
801048ca:	8b 43 18             	mov    0x18(%ebx),%eax
801048cd:	83 c4 10             	add    $0x10,%esp
801048d0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801048d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048da:	5b                   	pop    %ebx
801048db:	5e                   	pop    %esi
801048dc:	5d                   	pop    %ebp
801048dd:	c3                   	ret    
801048de:	66 90                	xchg   %ax,%ax

801048e0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	57                   	push   %edi
801048e4:	56                   	push   %esi
801048e5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801048e6:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801048e9:	83 ec 44             	sub    $0x44,%esp
801048ec:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801048ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801048f2:	56                   	push   %esi
801048f3:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801048f4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801048f7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801048fa:	e8 b1 d6 ff ff       	call   80101fb0 <nameiparent>
801048ff:	83 c4 10             	add    $0x10,%esp
80104902:	85 c0                	test   %eax,%eax
80104904:	0f 84 f6 00 00 00    	je     80104a00 <create+0x120>
    return 0;
  ilock(dp);
8010490a:	83 ec 0c             	sub    $0xc,%esp
8010490d:	89 c7                	mov    %eax,%edi
8010490f:	50                   	push   %eax
80104910:	e8 2b ce ff ff       	call   80101740 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104915:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104918:	83 c4 0c             	add    $0xc,%esp
8010491b:	50                   	push   %eax
8010491c:	56                   	push   %esi
8010491d:	57                   	push   %edi
8010491e:	e8 4d d3 ff ff       	call   80101c70 <dirlookup>
80104923:	83 c4 10             	add    $0x10,%esp
80104926:	85 c0                	test   %eax,%eax
80104928:	89 c3                	mov    %eax,%ebx
8010492a:	74 54                	je     80104980 <create+0xa0>
    iunlockput(dp);
8010492c:	83 ec 0c             	sub    $0xc,%esp
8010492f:	57                   	push   %edi
80104930:	e8 9b d0 ff ff       	call   801019d0 <iunlockput>
    ilock(ip);
80104935:	89 1c 24             	mov    %ebx,(%esp)
80104938:	e8 03 ce ff ff       	call   80101740 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010493d:	83 c4 10             	add    $0x10,%esp
80104940:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104945:	75 19                	jne    80104960 <create+0x80>
80104947:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
8010494c:	89 d8                	mov    %ebx,%eax
8010494e:	75 10                	jne    80104960 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104950:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104953:	5b                   	pop    %ebx
80104954:	5e                   	pop    %esi
80104955:	5f                   	pop    %edi
80104956:	5d                   	pop    %ebp
80104957:	c3                   	ret    
80104958:	90                   	nop
80104959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104960:	83 ec 0c             	sub    $0xc,%esp
80104963:	53                   	push   %ebx
80104964:	e8 67 d0 ff ff       	call   801019d0 <iunlockput>
    return 0;
80104969:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010496c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
8010496f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104971:	5b                   	pop    %ebx
80104972:	5e                   	pop    %esi
80104973:	5f                   	pop    %edi
80104974:	5d                   	pop    %ebp
80104975:	c3                   	ret    
80104976:	8d 76 00             	lea    0x0(%esi),%esi
80104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104980:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104984:	83 ec 08             	sub    $0x8,%esp
80104987:	50                   	push   %eax
80104988:	ff 37                	pushl  (%edi)
8010498a:	e8 41 cc ff ff       	call   801015d0 <ialloc>
8010498f:	83 c4 10             	add    $0x10,%esp
80104992:	85 c0                	test   %eax,%eax
80104994:	89 c3                	mov    %eax,%ebx
80104996:	0f 84 cc 00 00 00    	je     80104a68 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
8010499c:	83 ec 0c             	sub    $0xc,%esp
8010499f:	50                   	push   %eax
801049a0:	e8 9b cd ff ff       	call   80101740 <ilock>
  ip->major = major;
801049a5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801049a9:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
801049ad:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801049b1:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
801049b5:	b8 01 00 00 00       	mov    $0x1,%eax
801049ba:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801049be:	89 1c 24             	mov    %ebx,(%esp)
801049c1:	e8 ca cc ff ff       	call   80101690 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
801049c6:	83 c4 10             	add    $0x10,%esp
801049c9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801049ce:	74 40                	je     80104a10 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
801049d0:	83 ec 04             	sub    $0x4,%esp
801049d3:	ff 73 04             	pushl  0x4(%ebx)
801049d6:	56                   	push   %esi
801049d7:	57                   	push   %edi
801049d8:	e8 f3 d4 ff ff       	call   80101ed0 <dirlink>
801049dd:	83 c4 10             	add    $0x10,%esp
801049e0:	85 c0                	test   %eax,%eax
801049e2:	78 77                	js     80104a5b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
801049e4:	83 ec 0c             	sub    $0xc,%esp
801049e7:	57                   	push   %edi
801049e8:	e8 e3 cf ff ff       	call   801019d0 <iunlockput>

  return ip;
801049ed:	83 c4 10             	add    $0x10,%esp
}
801049f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
801049f3:	89 d8                	mov    %ebx,%eax
}
801049f5:	5b                   	pop    %ebx
801049f6:	5e                   	pop    %esi
801049f7:	5f                   	pop    %edi
801049f8:	5d                   	pop    %ebp
801049f9:	c3                   	ret    
801049fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104a00:	31 c0                	xor    %eax,%eax
80104a02:	e9 49 ff ff ff       	jmp    80104950 <create+0x70>
80104a07:	89 f6                	mov    %esi,%esi
80104a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104a10:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104a15:	83 ec 0c             	sub    $0xc,%esp
80104a18:	57                   	push   %edi
80104a19:	e8 72 cc ff ff       	call   80101690 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104a1e:	83 c4 0c             	add    $0xc,%esp
80104a21:	ff 73 04             	pushl  0x4(%ebx)
80104a24:	68 5c 79 10 80       	push   $0x8010795c
80104a29:	53                   	push   %ebx
80104a2a:	e8 a1 d4 ff ff       	call   80101ed0 <dirlink>
80104a2f:	83 c4 10             	add    $0x10,%esp
80104a32:	85 c0                	test   %eax,%eax
80104a34:	78 18                	js     80104a4e <create+0x16e>
80104a36:	83 ec 04             	sub    $0x4,%esp
80104a39:	ff 77 04             	pushl  0x4(%edi)
80104a3c:	68 5b 79 10 80       	push   $0x8010795b
80104a41:	53                   	push   %ebx
80104a42:	e8 89 d4 ff ff       	call   80101ed0 <dirlink>
80104a47:	83 c4 10             	add    $0x10,%esp
80104a4a:	85 c0                	test   %eax,%eax
80104a4c:	79 82                	jns    801049d0 <create+0xf0>
      panic("create dots");
80104a4e:	83 ec 0c             	sub    $0xc,%esp
80104a51:	68 4f 79 10 80       	push   $0x8010794f
80104a56:	e8 15 b9 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104a5b:	83 ec 0c             	sub    $0xc,%esp
80104a5e:	68 5e 79 10 80       	push   $0x8010795e
80104a63:	e8 08 b9 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104a68:	83 ec 0c             	sub    $0xc,%esp
80104a6b:	68 40 79 10 80       	push   $0x80107940
80104a70:	e8 fb b8 ff ff       	call   80100370 <panic>
80104a75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a80 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	56                   	push   %esi
80104a84:	53                   	push   %ebx
80104a85:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104a87:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104a8a:	89 d3                	mov    %edx,%ebx
80104a8c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104a8f:	50                   	push   %eax
80104a90:	6a 00                	push   $0x0
80104a92:	e8 29 fd ff ff       	call   801047c0 <argint>
80104a97:	83 c4 10             	add    $0x10,%esp
80104a9a:	85 c0                	test   %eax,%eax
80104a9c:	78 32                	js     80104ad0 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104a9e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104aa2:	77 2c                	ja     80104ad0 <argfd.constprop.0+0x50>
80104aa4:	e8 a7 ed ff ff       	call   80103850 <myproc>
80104aa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104aac:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104ab0:	85 c0                	test   %eax,%eax
80104ab2:	74 1c                	je     80104ad0 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80104ab4:	85 f6                	test   %esi,%esi
80104ab6:	74 02                	je     80104aba <argfd.constprop.0+0x3a>
    *pfd = fd;
80104ab8:	89 16                	mov    %edx,(%esi)
  if(pf)
80104aba:	85 db                	test   %ebx,%ebx
80104abc:	74 22                	je     80104ae0 <argfd.constprop.0+0x60>
    *pf = f;
80104abe:	89 03                	mov    %eax,(%ebx)
  return 0;
80104ac0:	31 c0                	xor    %eax,%eax
}
80104ac2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ac5:	5b                   	pop    %ebx
80104ac6:	5e                   	pop    %esi
80104ac7:	5d                   	pop    %ebp
80104ac8:	c3                   	ret    
80104ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ad0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104ad3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80104ad8:	5b                   	pop    %ebx
80104ad9:	5e                   	pop    %esi
80104ada:	5d                   	pop    %ebp
80104adb:	c3                   	ret    
80104adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104ae0:	31 c0                	xor    %eax,%eax
80104ae2:	eb de                	jmp    80104ac2 <argfd.constprop.0+0x42>
80104ae4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104aea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104af0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104af0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104af1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104af3:	89 e5                	mov    %esp,%ebp
80104af5:	56                   	push   %esi
80104af6:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104af7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
80104afa:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104afd:	e8 7e ff ff ff       	call   80104a80 <argfd.constprop.0>
80104b02:	85 c0                	test   %eax,%eax
80104b04:	78 1a                	js     80104b20 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104b06:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80104b08:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80104b0b:	e8 40 ed ff ff       	call   80103850 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104b10:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104b14:	85 d2                	test   %edx,%edx
80104b16:	74 18                	je     80104b30 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104b18:	83 c3 01             	add    $0x1,%ebx
80104b1b:	83 fb 10             	cmp    $0x10,%ebx
80104b1e:	75 f0                	jne    80104b10 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104b20:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104b23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104b28:	5b                   	pop    %ebx
80104b29:	5e                   	pop    %esi
80104b2a:	5d                   	pop    %ebp
80104b2b:	c3                   	ret    
80104b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104b30:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104b34:	83 ec 0c             	sub    $0xc,%esp
80104b37:	ff 75 f4             	pushl  -0xc(%ebp)
80104b3a:	e8 71 c3 ff ff       	call   80100eb0 <filedup>
  return fd;
80104b3f:	83 c4 10             	add    $0x10,%esp
}
80104b42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80104b45:	89 d8                	mov    %ebx,%eax
}
80104b47:	5b                   	pop    %ebx
80104b48:	5e                   	pop    %esi
80104b49:	5d                   	pop    %ebp
80104b4a:	c3                   	ret    
80104b4b:	90                   	nop
80104b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b50 <sys_read>:

int
sys_read(void)
{
80104b50:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b51:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104b53:	89 e5                	mov    %esp,%ebp
80104b55:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b58:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104b5b:	e8 20 ff ff ff       	call   80104a80 <argfd.constprop.0>
80104b60:	85 c0                	test   %eax,%eax
80104b62:	78 4c                	js     80104bb0 <sys_read+0x60>
80104b64:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b67:	83 ec 08             	sub    $0x8,%esp
80104b6a:	50                   	push   %eax
80104b6b:	6a 02                	push   $0x2
80104b6d:	e8 4e fc ff ff       	call   801047c0 <argint>
80104b72:	83 c4 10             	add    $0x10,%esp
80104b75:	85 c0                	test   %eax,%eax
80104b77:	78 37                	js     80104bb0 <sys_read+0x60>
80104b79:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b7c:	83 ec 04             	sub    $0x4,%esp
80104b7f:	ff 75 f0             	pushl  -0x10(%ebp)
80104b82:	50                   	push   %eax
80104b83:	6a 01                	push   $0x1
80104b85:	e8 66 fc ff ff       	call   801047f0 <argptr>
80104b8a:	83 c4 10             	add    $0x10,%esp
80104b8d:	85 c0                	test   %eax,%eax
80104b8f:	78 1f                	js     80104bb0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104b91:	83 ec 04             	sub    $0x4,%esp
80104b94:	ff 75 f0             	pushl  -0x10(%ebp)
80104b97:	ff 75 f4             	pushl  -0xc(%ebp)
80104b9a:	ff 75 ec             	pushl  -0x14(%ebp)
80104b9d:	e8 7e c4 ff ff       	call   80101020 <fileread>
80104ba2:	83 c4 10             	add    $0x10,%esp
}
80104ba5:	c9                   	leave  
80104ba6:	c3                   	ret    
80104ba7:	89 f6                	mov    %esi,%esi
80104ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104bb5:	c9                   	leave  
80104bb6:	c3                   	ret    
80104bb7:	89 f6                	mov    %esi,%esi
80104bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bc0 <sys_write>:

int
sys_write(void)
{
80104bc0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104bc1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104bc3:	89 e5                	mov    %esp,%ebp
80104bc5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104bc8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104bcb:	e8 b0 fe ff ff       	call   80104a80 <argfd.constprop.0>
80104bd0:	85 c0                	test   %eax,%eax
80104bd2:	78 4c                	js     80104c20 <sys_write+0x60>
80104bd4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bd7:	83 ec 08             	sub    $0x8,%esp
80104bda:	50                   	push   %eax
80104bdb:	6a 02                	push   $0x2
80104bdd:	e8 de fb ff ff       	call   801047c0 <argint>
80104be2:	83 c4 10             	add    $0x10,%esp
80104be5:	85 c0                	test   %eax,%eax
80104be7:	78 37                	js     80104c20 <sys_write+0x60>
80104be9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bec:	83 ec 04             	sub    $0x4,%esp
80104bef:	ff 75 f0             	pushl  -0x10(%ebp)
80104bf2:	50                   	push   %eax
80104bf3:	6a 01                	push   $0x1
80104bf5:	e8 f6 fb ff ff       	call   801047f0 <argptr>
80104bfa:	83 c4 10             	add    $0x10,%esp
80104bfd:	85 c0                	test   %eax,%eax
80104bff:	78 1f                	js     80104c20 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104c01:	83 ec 04             	sub    $0x4,%esp
80104c04:	ff 75 f0             	pushl  -0x10(%ebp)
80104c07:	ff 75 f4             	pushl  -0xc(%ebp)
80104c0a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c0d:	e8 9e c4 ff ff       	call   801010b0 <filewrite>
80104c12:	83 c4 10             	add    $0x10,%esp
}
80104c15:	c9                   	leave  
80104c16:	c3                   	ret    
80104c17:	89 f6                	mov    %esi,%esi
80104c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104c25:	c9                   	leave  
80104c26:	c3                   	ret    
80104c27:	89 f6                	mov    %esi,%esi
80104c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c30 <sys_close>:

int
sys_close(void)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104c36:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104c39:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c3c:	e8 3f fe ff ff       	call   80104a80 <argfd.constprop.0>
80104c41:	85 c0                	test   %eax,%eax
80104c43:	78 2b                	js     80104c70 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80104c45:	e8 06 ec ff ff       	call   80103850 <myproc>
80104c4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104c4d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80104c50:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104c57:	00 
  fileclose(f);
80104c58:	ff 75 f4             	pushl  -0xc(%ebp)
80104c5b:	e8 a0 c2 ff ff       	call   80100f00 <fileclose>
  return 0;
80104c60:	83 c4 10             	add    $0x10,%esp
80104c63:	31 c0                	xor    %eax,%eax
}
80104c65:	c9                   	leave  
80104c66:	c3                   	ret    
80104c67:	89 f6                	mov    %esi,%esi
80104c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104c75:	c9                   	leave  
80104c76:	c3                   	ret    
80104c77:	89 f6                	mov    %esi,%esi
80104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c80 <sys_fstat>:

int
sys_fstat(void)
{
80104c80:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104c81:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104c83:	89 e5                	mov    %esp,%ebp
80104c85:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104c88:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104c8b:	e8 f0 fd ff ff       	call   80104a80 <argfd.constprop.0>
80104c90:	85 c0                	test   %eax,%eax
80104c92:	78 2c                	js     80104cc0 <sys_fstat+0x40>
80104c94:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c97:	83 ec 04             	sub    $0x4,%esp
80104c9a:	6a 14                	push   $0x14
80104c9c:	50                   	push   %eax
80104c9d:	6a 01                	push   $0x1
80104c9f:	e8 4c fb ff ff       	call   801047f0 <argptr>
80104ca4:	83 c4 10             	add    $0x10,%esp
80104ca7:	85 c0                	test   %eax,%eax
80104ca9:	78 15                	js     80104cc0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104cab:	83 ec 08             	sub    $0x8,%esp
80104cae:	ff 75 f4             	pushl  -0xc(%ebp)
80104cb1:	ff 75 f0             	pushl  -0x10(%ebp)
80104cb4:	e8 17 c3 ff ff       	call   80100fd0 <filestat>
80104cb9:	83 c4 10             	add    $0x10,%esp
}
80104cbc:	c9                   	leave  
80104cbd:	c3                   	ret    
80104cbe:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104cc5:	c9                   	leave  
80104cc6:	c3                   	ret    
80104cc7:	89 f6                	mov    %esi,%esi
80104cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cd0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	57                   	push   %edi
80104cd4:	56                   	push   %esi
80104cd5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104cd6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104cd9:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104cdc:	50                   	push   %eax
80104cdd:	6a 00                	push   $0x0
80104cdf:	e8 3c fb ff ff       	call   80104820 <argstr>
80104ce4:	83 c4 10             	add    $0x10,%esp
80104ce7:	85 c0                	test   %eax,%eax
80104ce9:	0f 88 fb 00 00 00    	js     80104dea <sys_link+0x11a>
80104cef:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104cf2:	83 ec 08             	sub    $0x8,%esp
80104cf5:	50                   	push   %eax
80104cf6:	6a 01                	push   $0x1
80104cf8:	e8 23 fb ff ff       	call   80104820 <argstr>
80104cfd:	83 c4 10             	add    $0x10,%esp
80104d00:	85 c0                	test   %eax,%eax
80104d02:	0f 88 e2 00 00 00    	js     80104dea <sys_link+0x11a>
    return -1;

  begin_op();
80104d08:	e8 13 df ff ff       	call   80102c20 <begin_op>
  if((ip = namei(old)) == 0){
80104d0d:	83 ec 0c             	sub    $0xc,%esp
80104d10:	ff 75 d4             	pushl  -0x2c(%ebp)
80104d13:	e8 78 d2 ff ff       	call   80101f90 <namei>
80104d18:	83 c4 10             	add    $0x10,%esp
80104d1b:	85 c0                	test   %eax,%eax
80104d1d:	89 c3                	mov    %eax,%ebx
80104d1f:	0f 84 f3 00 00 00    	je     80104e18 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80104d25:	83 ec 0c             	sub    $0xc,%esp
80104d28:	50                   	push   %eax
80104d29:	e8 12 ca ff ff       	call   80101740 <ilock>
  if(ip->type == T_DIR){
80104d2e:	83 c4 10             	add    $0x10,%esp
80104d31:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d36:	0f 84 c4 00 00 00    	je     80104e00 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104d3c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104d41:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104d44:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104d47:	53                   	push   %ebx
80104d48:	e8 43 c9 ff ff       	call   80101690 <iupdate>
  iunlock(ip);
80104d4d:	89 1c 24             	mov    %ebx,(%esp)
80104d50:	e8 cb ca ff ff       	call   80101820 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104d55:	58                   	pop    %eax
80104d56:	5a                   	pop    %edx
80104d57:	57                   	push   %edi
80104d58:	ff 75 d0             	pushl  -0x30(%ebp)
80104d5b:	e8 50 d2 ff ff       	call   80101fb0 <nameiparent>
80104d60:	83 c4 10             	add    $0x10,%esp
80104d63:	85 c0                	test   %eax,%eax
80104d65:	89 c6                	mov    %eax,%esi
80104d67:	74 5b                	je     80104dc4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80104d69:	83 ec 0c             	sub    $0xc,%esp
80104d6c:	50                   	push   %eax
80104d6d:	e8 ce c9 ff ff       	call   80101740 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104d72:	83 c4 10             	add    $0x10,%esp
80104d75:	8b 03                	mov    (%ebx),%eax
80104d77:	39 06                	cmp    %eax,(%esi)
80104d79:	75 3d                	jne    80104db8 <sys_link+0xe8>
80104d7b:	83 ec 04             	sub    $0x4,%esp
80104d7e:	ff 73 04             	pushl  0x4(%ebx)
80104d81:	57                   	push   %edi
80104d82:	56                   	push   %esi
80104d83:	e8 48 d1 ff ff       	call   80101ed0 <dirlink>
80104d88:	83 c4 10             	add    $0x10,%esp
80104d8b:	85 c0                	test   %eax,%eax
80104d8d:	78 29                	js     80104db8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104d8f:	83 ec 0c             	sub    $0xc,%esp
80104d92:	56                   	push   %esi
80104d93:	e8 38 cc ff ff       	call   801019d0 <iunlockput>
  iput(ip);
80104d98:	89 1c 24             	mov    %ebx,(%esp)
80104d9b:	e8 d0 ca ff ff       	call   80101870 <iput>

  end_op();
80104da0:	e8 eb de ff ff       	call   80102c90 <end_op>

  return 0;
80104da5:	83 c4 10             	add    $0x10,%esp
80104da8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104daa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104dad:	5b                   	pop    %ebx
80104dae:	5e                   	pop    %esi
80104daf:	5f                   	pop    %edi
80104db0:	5d                   	pop    %ebp
80104db1:	c3                   	ret    
80104db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104db8:	83 ec 0c             	sub    $0xc,%esp
80104dbb:	56                   	push   %esi
80104dbc:	e8 0f cc ff ff       	call   801019d0 <iunlockput>
    goto bad;
80104dc1:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80104dc4:	83 ec 0c             	sub    $0xc,%esp
80104dc7:	53                   	push   %ebx
80104dc8:	e8 73 c9 ff ff       	call   80101740 <ilock>
  ip->nlink--;
80104dcd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104dd2:	89 1c 24             	mov    %ebx,(%esp)
80104dd5:	e8 b6 c8 ff ff       	call   80101690 <iupdate>
  iunlockput(ip);
80104dda:	89 1c 24             	mov    %ebx,(%esp)
80104ddd:	e8 ee cb ff ff       	call   801019d0 <iunlockput>
  end_op();
80104de2:	e8 a9 de ff ff       	call   80102c90 <end_op>
  return -1;
80104de7:	83 c4 10             	add    $0x10,%esp
}
80104dea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104ded:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104df2:	5b                   	pop    %ebx
80104df3:	5e                   	pop    %esi
80104df4:	5f                   	pop    %edi
80104df5:	5d                   	pop    %ebp
80104df6:	c3                   	ret    
80104df7:	89 f6                	mov    %esi,%esi
80104df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80104e00:	83 ec 0c             	sub    $0xc,%esp
80104e03:	53                   	push   %ebx
80104e04:	e8 c7 cb ff ff       	call   801019d0 <iunlockput>
    end_op();
80104e09:	e8 82 de ff ff       	call   80102c90 <end_op>
    return -1;
80104e0e:	83 c4 10             	add    $0x10,%esp
80104e11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e16:	eb 92                	jmp    80104daa <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80104e18:	e8 73 de ff ff       	call   80102c90 <end_op>
    return -1;
80104e1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e22:	eb 86                	jmp    80104daa <sys_link+0xda>
80104e24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104e30 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	57                   	push   %edi
80104e34:	56                   	push   %esi
80104e35:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104e36:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104e39:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104e3c:	50                   	push   %eax
80104e3d:	6a 00                	push   $0x0
80104e3f:	e8 dc f9 ff ff       	call   80104820 <argstr>
80104e44:	83 c4 10             	add    $0x10,%esp
80104e47:	85 c0                	test   %eax,%eax
80104e49:	0f 88 82 01 00 00    	js     80104fd1 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80104e4f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80104e52:	e8 c9 dd ff ff       	call   80102c20 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104e57:	83 ec 08             	sub    $0x8,%esp
80104e5a:	53                   	push   %ebx
80104e5b:	ff 75 c0             	pushl  -0x40(%ebp)
80104e5e:	e8 4d d1 ff ff       	call   80101fb0 <nameiparent>
80104e63:	83 c4 10             	add    $0x10,%esp
80104e66:	85 c0                	test   %eax,%eax
80104e68:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104e6b:	0f 84 6a 01 00 00    	je     80104fdb <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80104e71:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104e74:	83 ec 0c             	sub    $0xc,%esp
80104e77:	56                   	push   %esi
80104e78:	e8 c3 c8 ff ff       	call   80101740 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104e7d:	58                   	pop    %eax
80104e7e:	5a                   	pop    %edx
80104e7f:	68 5c 79 10 80       	push   $0x8010795c
80104e84:	53                   	push   %ebx
80104e85:	e8 c6 cd ff ff       	call   80101c50 <namecmp>
80104e8a:	83 c4 10             	add    $0x10,%esp
80104e8d:	85 c0                	test   %eax,%eax
80104e8f:	0f 84 fc 00 00 00    	je     80104f91 <sys_unlink+0x161>
80104e95:	83 ec 08             	sub    $0x8,%esp
80104e98:	68 5b 79 10 80       	push   $0x8010795b
80104e9d:	53                   	push   %ebx
80104e9e:	e8 ad cd ff ff       	call   80101c50 <namecmp>
80104ea3:	83 c4 10             	add    $0x10,%esp
80104ea6:	85 c0                	test   %eax,%eax
80104ea8:	0f 84 e3 00 00 00    	je     80104f91 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104eae:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104eb1:	83 ec 04             	sub    $0x4,%esp
80104eb4:	50                   	push   %eax
80104eb5:	53                   	push   %ebx
80104eb6:	56                   	push   %esi
80104eb7:	e8 b4 cd ff ff       	call   80101c70 <dirlookup>
80104ebc:	83 c4 10             	add    $0x10,%esp
80104ebf:	85 c0                	test   %eax,%eax
80104ec1:	89 c3                	mov    %eax,%ebx
80104ec3:	0f 84 c8 00 00 00    	je     80104f91 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80104ec9:	83 ec 0c             	sub    $0xc,%esp
80104ecc:	50                   	push   %eax
80104ecd:	e8 6e c8 ff ff       	call   80101740 <ilock>

  if(ip->nlink < 1)
80104ed2:	83 c4 10             	add    $0x10,%esp
80104ed5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104eda:	0f 8e 24 01 00 00    	jle    80105004 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104ee0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ee5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104ee8:	74 66                	je     80104f50 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104eea:	83 ec 04             	sub    $0x4,%esp
80104eed:	6a 10                	push   $0x10
80104eef:	6a 00                	push   $0x0
80104ef1:	56                   	push   %esi
80104ef2:	e8 e9 f5 ff ff       	call   801044e0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104ef7:	6a 10                	push   $0x10
80104ef9:	ff 75 c4             	pushl  -0x3c(%ebp)
80104efc:	56                   	push   %esi
80104efd:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f00:	e8 1b cc ff ff       	call   80101b20 <writei>
80104f05:	83 c4 20             	add    $0x20,%esp
80104f08:	83 f8 10             	cmp    $0x10,%eax
80104f0b:	0f 85 e6 00 00 00    	jne    80104ff7 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104f11:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104f16:	0f 84 9c 00 00 00    	je     80104fb8 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104f1c:	83 ec 0c             	sub    $0xc,%esp
80104f1f:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f22:	e8 a9 ca ff ff       	call   801019d0 <iunlockput>

  ip->nlink--;
80104f27:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f2c:	89 1c 24             	mov    %ebx,(%esp)
80104f2f:	e8 5c c7 ff ff       	call   80101690 <iupdate>
  iunlockput(ip);
80104f34:	89 1c 24             	mov    %ebx,(%esp)
80104f37:	e8 94 ca ff ff       	call   801019d0 <iunlockput>

  end_op();
80104f3c:	e8 4f dd ff ff       	call   80102c90 <end_op>

  return 0;
80104f41:	83 c4 10             	add    $0x10,%esp
80104f44:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104f46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f49:	5b                   	pop    %ebx
80104f4a:	5e                   	pop    %esi
80104f4b:	5f                   	pop    %edi
80104f4c:	5d                   	pop    %ebp
80104f4d:	c3                   	ret    
80104f4e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104f50:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104f54:	76 94                	jbe    80104eea <sys_unlink+0xba>
80104f56:	bf 20 00 00 00       	mov    $0x20,%edi
80104f5b:	eb 0f                	jmp    80104f6c <sys_unlink+0x13c>
80104f5d:	8d 76 00             	lea    0x0(%esi),%esi
80104f60:	83 c7 10             	add    $0x10,%edi
80104f63:	3b 7b 58             	cmp    0x58(%ebx),%edi
80104f66:	0f 83 7e ff ff ff    	jae    80104eea <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104f6c:	6a 10                	push   $0x10
80104f6e:	57                   	push   %edi
80104f6f:	56                   	push   %esi
80104f70:	53                   	push   %ebx
80104f71:	e8 aa ca ff ff       	call   80101a20 <readi>
80104f76:	83 c4 10             	add    $0x10,%esp
80104f79:	83 f8 10             	cmp    $0x10,%eax
80104f7c:	75 6c                	jne    80104fea <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104f7e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104f83:	74 db                	je     80104f60 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104f85:	83 ec 0c             	sub    $0xc,%esp
80104f88:	53                   	push   %ebx
80104f89:	e8 42 ca ff ff       	call   801019d0 <iunlockput>
    goto bad;
80104f8e:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104f91:	83 ec 0c             	sub    $0xc,%esp
80104f94:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f97:	e8 34 ca ff ff       	call   801019d0 <iunlockput>
  end_op();
80104f9c:	e8 ef dc ff ff       	call   80102c90 <end_op>
  return -1;
80104fa1:	83 c4 10             	add    $0x10,%esp
}
80104fa4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104fa7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104fac:	5b                   	pop    %ebx
80104fad:	5e                   	pop    %esi
80104fae:	5f                   	pop    %edi
80104faf:	5d                   	pop    %ebp
80104fb0:	c3                   	ret    
80104fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104fb8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80104fbb:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104fbe:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104fc3:	50                   	push   %eax
80104fc4:	e8 c7 c6 ff ff       	call   80101690 <iupdate>
80104fc9:	83 c4 10             	add    $0x10,%esp
80104fcc:	e9 4b ff ff ff       	jmp    80104f1c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80104fd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fd6:	e9 6b ff ff ff       	jmp    80104f46 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
80104fdb:	e8 b0 dc ff ff       	call   80102c90 <end_op>
    return -1;
80104fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fe5:	e9 5c ff ff ff       	jmp    80104f46 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80104fea:	83 ec 0c             	sub    $0xc,%esp
80104fed:	68 80 79 10 80       	push   $0x80107980
80104ff2:	e8 79 b3 ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80104ff7:	83 ec 0c             	sub    $0xc,%esp
80104ffa:	68 92 79 10 80       	push   $0x80107992
80104fff:	e8 6c b3 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80105004:	83 ec 0c             	sub    $0xc,%esp
80105007:	68 6e 79 10 80       	push   $0x8010796e
8010500c:	e8 5f b3 ff ff       	call   80100370 <panic>
80105011:	eb 0d                	jmp    80105020 <sys_open>
80105013:	90                   	nop
80105014:	90                   	nop
80105015:	90                   	nop
80105016:	90                   	nop
80105017:	90                   	nop
80105018:	90                   	nop
80105019:	90                   	nop
8010501a:	90                   	nop
8010501b:	90                   	nop
8010501c:	90                   	nop
8010501d:	90                   	nop
8010501e:	90                   	nop
8010501f:	90                   	nop

80105020 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105020:	55                   	push   %ebp
80105021:	89 e5                	mov    %esp,%ebp
80105023:	57                   	push   %edi
80105024:	56                   	push   %esi
80105025:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105026:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105029:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010502c:	50                   	push   %eax
8010502d:	6a 00                	push   $0x0
8010502f:	e8 ec f7 ff ff       	call   80104820 <argstr>
80105034:	83 c4 10             	add    $0x10,%esp
80105037:	85 c0                	test   %eax,%eax
80105039:	0f 88 9e 00 00 00    	js     801050dd <sys_open+0xbd>
8010503f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105042:	83 ec 08             	sub    $0x8,%esp
80105045:	50                   	push   %eax
80105046:	6a 01                	push   $0x1
80105048:	e8 73 f7 ff ff       	call   801047c0 <argint>
8010504d:	83 c4 10             	add    $0x10,%esp
80105050:	85 c0                	test   %eax,%eax
80105052:	0f 88 85 00 00 00    	js     801050dd <sys_open+0xbd>
    return -1;

  begin_op();
80105058:	e8 c3 db ff ff       	call   80102c20 <begin_op>

  if(omode & O_CREATE){
8010505d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105061:	0f 85 89 00 00 00    	jne    801050f0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105067:	83 ec 0c             	sub    $0xc,%esp
8010506a:	ff 75 e0             	pushl  -0x20(%ebp)
8010506d:	e8 1e cf ff ff       	call   80101f90 <namei>
80105072:	83 c4 10             	add    $0x10,%esp
80105075:	85 c0                	test   %eax,%eax
80105077:	89 c6                	mov    %eax,%esi
80105079:	0f 84 8e 00 00 00    	je     8010510d <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
8010507f:	83 ec 0c             	sub    $0xc,%esp
80105082:	50                   	push   %eax
80105083:	e8 b8 c6 ff ff       	call   80101740 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105088:	83 c4 10             	add    $0x10,%esp
8010508b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105090:	0f 84 d2 00 00 00    	je     80105168 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105096:	e8 a5 bd ff ff       	call   80100e40 <filealloc>
8010509b:	85 c0                	test   %eax,%eax
8010509d:	89 c7                	mov    %eax,%edi
8010509f:	74 2b                	je     801050cc <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801050a1:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801050a3:	e8 a8 e7 ff ff       	call   80103850 <myproc>
801050a8:	90                   	nop
801050a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
801050b0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801050b4:	85 d2                	test   %edx,%edx
801050b6:	74 68                	je     80105120 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801050b8:	83 c3 01             	add    $0x1,%ebx
801050bb:	83 fb 10             	cmp    $0x10,%ebx
801050be:	75 f0                	jne    801050b0 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
801050c0:	83 ec 0c             	sub    $0xc,%esp
801050c3:	57                   	push   %edi
801050c4:	e8 37 be ff ff       	call   80100f00 <fileclose>
801050c9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801050cc:	83 ec 0c             	sub    $0xc,%esp
801050cf:	56                   	push   %esi
801050d0:	e8 fb c8 ff ff       	call   801019d0 <iunlockput>
    end_op();
801050d5:	e8 b6 db ff ff       	call   80102c90 <end_op>
    return -1;
801050da:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801050dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
801050e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801050e5:	5b                   	pop    %ebx
801050e6:	5e                   	pop    %esi
801050e7:	5f                   	pop    %edi
801050e8:	5d                   	pop    %ebp
801050e9:	c3                   	ret    
801050ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801050f0:	83 ec 0c             	sub    $0xc,%esp
801050f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050f6:	31 c9                	xor    %ecx,%ecx
801050f8:	6a 00                	push   $0x0
801050fa:	ba 02 00 00 00       	mov    $0x2,%edx
801050ff:	e8 dc f7 ff ff       	call   801048e0 <create>
    if(ip == 0){
80105104:	83 c4 10             	add    $0x10,%esp
80105107:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105109:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010510b:	75 89                	jne    80105096 <sys_open+0x76>
      end_op();
8010510d:	e8 7e db ff ff       	call   80102c90 <end_op>
      return -1;
80105112:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105117:	eb 43                	jmp    8010515c <sys_open+0x13c>
80105119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105120:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105123:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105127:	56                   	push   %esi
80105128:	e8 f3 c6 ff ff       	call   80101820 <iunlock>
  end_op();
8010512d:	e8 5e db ff ff       	call   80102c90 <end_op>

  f->type = FD_INODE;
80105132:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105138:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010513b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010513e:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105141:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105148:	89 d0                	mov    %edx,%eax
8010514a:	83 e0 01             	and    $0x1,%eax
8010514d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105150:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105153:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105156:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
8010515a:	89 d8                	mov    %ebx,%eax
}
8010515c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010515f:	5b                   	pop    %ebx
80105160:	5e                   	pop    %esi
80105161:	5f                   	pop    %edi
80105162:	5d                   	pop    %ebp
80105163:	c3                   	ret    
80105164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105168:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010516b:	85 c9                	test   %ecx,%ecx
8010516d:	0f 84 23 ff ff ff    	je     80105096 <sys_open+0x76>
80105173:	e9 54 ff ff ff       	jmp    801050cc <sys_open+0xac>
80105178:	90                   	nop
80105179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105180 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105180:	55                   	push   %ebp
80105181:	89 e5                	mov    %esp,%ebp
80105183:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105186:	e8 95 da ff ff       	call   80102c20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010518b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010518e:	83 ec 08             	sub    $0x8,%esp
80105191:	50                   	push   %eax
80105192:	6a 00                	push   $0x0
80105194:	e8 87 f6 ff ff       	call   80104820 <argstr>
80105199:	83 c4 10             	add    $0x10,%esp
8010519c:	85 c0                	test   %eax,%eax
8010519e:	78 30                	js     801051d0 <sys_mkdir+0x50>
801051a0:	83 ec 0c             	sub    $0xc,%esp
801051a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051a6:	31 c9                	xor    %ecx,%ecx
801051a8:	6a 00                	push   $0x0
801051aa:	ba 01 00 00 00       	mov    $0x1,%edx
801051af:	e8 2c f7 ff ff       	call   801048e0 <create>
801051b4:	83 c4 10             	add    $0x10,%esp
801051b7:	85 c0                	test   %eax,%eax
801051b9:	74 15                	je     801051d0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801051bb:	83 ec 0c             	sub    $0xc,%esp
801051be:	50                   	push   %eax
801051bf:	e8 0c c8 ff ff       	call   801019d0 <iunlockput>
  end_op();
801051c4:	e8 c7 da ff ff       	call   80102c90 <end_op>
  return 0;
801051c9:	83 c4 10             	add    $0x10,%esp
801051cc:	31 c0                	xor    %eax,%eax
}
801051ce:	c9                   	leave  
801051cf:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
801051d0:	e8 bb da ff ff       	call   80102c90 <end_op>
    return -1;
801051d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801051da:	c9                   	leave  
801051db:	c3                   	ret    
801051dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051e0 <sys_mknod>:

int
sys_mknod(void)
{
801051e0:	55                   	push   %ebp
801051e1:	89 e5                	mov    %esp,%ebp
801051e3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801051e6:	e8 35 da ff ff       	call   80102c20 <begin_op>
  if((argstr(0, &path)) < 0 ||
801051eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801051ee:	83 ec 08             	sub    $0x8,%esp
801051f1:	50                   	push   %eax
801051f2:	6a 00                	push   $0x0
801051f4:	e8 27 f6 ff ff       	call   80104820 <argstr>
801051f9:	83 c4 10             	add    $0x10,%esp
801051fc:	85 c0                	test   %eax,%eax
801051fe:	78 60                	js     80105260 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105200:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105203:	83 ec 08             	sub    $0x8,%esp
80105206:	50                   	push   %eax
80105207:	6a 01                	push   $0x1
80105209:	e8 b2 f5 ff ff       	call   801047c0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
8010520e:	83 c4 10             	add    $0x10,%esp
80105211:	85 c0                	test   %eax,%eax
80105213:	78 4b                	js     80105260 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105215:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105218:	83 ec 08             	sub    $0x8,%esp
8010521b:	50                   	push   %eax
8010521c:	6a 02                	push   $0x2
8010521e:	e8 9d f5 ff ff       	call   801047c0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105223:	83 c4 10             	add    $0x10,%esp
80105226:	85 c0                	test   %eax,%eax
80105228:	78 36                	js     80105260 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010522a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010522e:	83 ec 0c             	sub    $0xc,%esp
80105231:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105235:	ba 03 00 00 00       	mov    $0x3,%edx
8010523a:	50                   	push   %eax
8010523b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010523e:	e8 9d f6 ff ff       	call   801048e0 <create>
80105243:	83 c4 10             	add    $0x10,%esp
80105246:	85 c0                	test   %eax,%eax
80105248:	74 16                	je     80105260 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010524a:	83 ec 0c             	sub    $0xc,%esp
8010524d:	50                   	push   %eax
8010524e:	e8 7d c7 ff ff       	call   801019d0 <iunlockput>
  end_op();
80105253:	e8 38 da ff ff       	call   80102c90 <end_op>
  return 0;
80105258:	83 c4 10             	add    $0x10,%esp
8010525b:	31 c0                	xor    %eax,%eax
}
8010525d:	c9                   	leave  
8010525e:	c3                   	ret    
8010525f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105260:	e8 2b da ff ff       	call   80102c90 <end_op>
    return -1;
80105265:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010526a:	c9                   	leave  
8010526b:	c3                   	ret    
8010526c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105270 <sys_chdir>:

int
sys_chdir(void)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	56                   	push   %esi
80105274:	53                   	push   %ebx
80105275:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105278:	e8 d3 e5 ff ff       	call   80103850 <myproc>
8010527d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010527f:	e8 9c d9 ff ff       	call   80102c20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105284:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105287:	83 ec 08             	sub    $0x8,%esp
8010528a:	50                   	push   %eax
8010528b:	6a 00                	push   $0x0
8010528d:	e8 8e f5 ff ff       	call   80104820 <argstr>
80105292:	83 c4 10             	add    $0x10,%esp
80105295:	85 c0                	test   %eax,%eax
80105297:	78 77                	js     80105310 <sys_chdir+0xa0>
80105299:	83 ec 0c             	sub    $0xc,%esp
8010529c:	ff 75 f4             	pushl  -0xc(%ebp)
8010529f:	e8 ec cc ff ff       	call   80101f90 <namei>
801052a4:	83 c4 10             	add    $0x10,%esp
801052a7:	85 c0                	test   %eax,%eax
801052a9:	89 c3                	mov    %eax,%ebx
801052ab:	74 63                	je     80105310 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801052ad:	83 ec 0c             	sub    $0xc,%esp
801052b0:	50                   	push   %eax
801052b1:	e8 8a c4 ff ff       	call   80101740 <ilock>
  if(ip->type != T_DIR){
801052b6:	83 c4 10             	add    $0x10,%esp
801052b9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052be:	75 30                	jne    801052f0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801052c0:	83 ec 0c             	sub    $0xc,%esp
801052c3:	53                   	push   %ebx
801052c4:	e8 57 c5 ff ff       	call   80101820 <iunlock>
  iput(curproc->cwd);
801052c9:	58                   	pop    %eax
801052ca:	ff 76 68             	pushl  0x68(%esi)
801052cd:	e8 9e c5 ff ff       	call   80101870 <iput>
  end_op();
801052d2:	e8 b9 d9 ff ff       	call   80102c90 <end_op>
  curproc->cwd = ip;
801052d7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801052da:	83 c4 10             	add    $0x10,%esp
801052dd:	31 c0                	xor    %eax,%eax
}
801052df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052e2:	5b                   	pop    %ebx
801052e3:	5e                   	pop    %esi
801052e4:	5d                   	pop    %ebp
801052e5:	c3                   	ret    
801052e6:	8d 76 00             	lea    0x0(%esi),%esi
801052e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
801052f0:	83 ec 0c             	sub    $0xc,%esp
801052f3:	53                   	push   %ebx
801052f4:	e8 d7 c6 ff ff       	call   801019d0 <iunlockput>
    end_op();
801052f9:	e8 92 d9 ff ff       	call   80102c90 <end_op>
    return -1;
801052fe:	83 c4 10             	add    $0x10,%esp
80105301:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105306:	eb d7                	jmp    801052df <sys_chdir+0x6f>
80105308:	90                   	nop
80105309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105310:	e8 7b d9 ff ff       	call   80102c90 <end_op>
    return -1;
80105315:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010531a:	eb c3                	jmp    801052df <sys_chdir+0x6f>
8010531c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105320 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	57                   	push   %edi
80105324:	56                   	push   %esi
80105325:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105326:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010532c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105332:	50                   	push   %eax
80105333:	6a 00                	push   $0x0
80105335:	e8 e6 f4 ff ff       	call   80104820 <argstr>
8010533a:	83 c4 10             	add    $0x10,%esp
8010533d:	85 c0                	test   %eax,%eax
8010533f:	78 7f                	js     801053c0 <sys_exec+0xa0>
80105341:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105347:	83 ec 08             	sub    $0x8,%esp
8010534a:	50                   	push   %eax
8010534b:	6a 01                	push   $0x1
8010534d:	e8 6e f4 ff ff       	call   801047c0 <argint>
80105352:	83 c4 10             	add    $0x10,%esp
80105355:	85 c0                	test   %eax,%eax
80105357:	78 67                	js     801053c0 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105359:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010535f:	83 ec 04             	sub    $0x4,%esp
80105362:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105368:	68 80 00 00 00       	push   $0x80
8010536d:	6a 00                	push   $0x0
8010536f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105375:	50                   	push   %eax
80105376:	31 db                	xor    %ebx,%ebx
80105378:	e8 63 f1 ff ff       	call   801044e0 <memset>
8010537d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105380:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105386:	83 ec 08             	sub    $0x8,%esp
80105389:	57                   	push   %edi
8010538a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010538d:	50                   	push   %eax
8010538e:	e8 bd f3 ff ff       	call   80104750 <fetchint>
80105393:	83 c4 10             	add    $0x10,%esp
80105396:	85 c0                	test   %eax,%eax
80105398:	78 26                	js     801053c0 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
8010539a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801053a0:	85 c0                	test   %eax,%eax
801053a2:	74 2c                	je     801053d0 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801053a4:	83 ec 08             	sub    $0x8,%esp
801053a7:	56                   	push   %esi
801053a8:	50                   	push   %eax
801053a9:	e8 c2 f3 ff ff       	call   80104770 <fetchstr>
801053ae:	83 c4 10             	add    $0x10,%esp
801053b1:	85 c0                	test   %eax,%eax
801053b3:	78 0b                	js     801053c0 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801053b5:	83 c3 01             	add    $0x1,%ebx
801053b8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801053bb:	83 fb 20             	cmp    $0x20,%ebx
801053be:	75 c0                	jne    80105380 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801053c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801053c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801053c8:	5b                   	pop    %ebx
801053c9:	5e                   	pop    %esi
801053ca:	5f                   	pop    %edi
801053cb:	5d                   	pop    %ebp
801053cc:	c3                   	ret    
801053cd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801053d0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801053d6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801053d9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801053e0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801053e4:	50                   	push   %eax
801053e5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801053eb:	e8 00 b6 ff ff       	call   801009f0 <exec>
801053f0:	83 c4 10             	add    $0x10,%esp
}
801053f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053f6:	5b                   	pop    %ebx
801053f7:	5e                   	pop    %esi
801053f8:	5f                   	pop    %edi
801053f9:	5d                   	pop    %ebp
801053fa:	c3                   	ret    
801053fb:	90                   	nop
801053fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105400 <sys_pipe>:

int
sys_pipe(void)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	57                   	push   %edi
80105404:	56                   	push   %esi
80105405:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105406:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105409:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010540c:	6a 08                	push   $0x8
8010540e:	50                   	push   %eax
8010540f:	6a 00                	push   $0x0
80105411:	e8 da f3 ff ff       	call   801047f0 <argptr>
80105416:	83 c4 10             	add    $0x10,%esp
80105419:	85 c0                	test   %eax,%eax
8010541b:	78 4a                	js     80105467 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010541d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105420:	83 ec 08             	sub    $0x8,%esp
80105423:	50                   	push   %eax
80105424:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105427:	50                   	push   %eax
80105428:	e8 93 de ff ff       	call   801032c0 <pipealloc>
8010542d:	83 c4 10             	add    $0x10,%esp
80105430:	85 c0                	test   %eax,%eax
80105432:	78 33                	js     80105467 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105434:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105436:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105439:	e8 12 e4 ff ff       	call   80103850 <myproc>
8010543e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105440:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105444:	85 f6                	test   %esi,%esi
80105446:	74 30                	je     80105478 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105448:	83 c3 01             	add    $0x1,%ebx
8010544b:	83 fb 10             	cmp    $0x10,%ebx
8010544e:	75 f0                	jne    80105440 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105450:	83 ec 0c             	sub    $0xc,%esp
80105453:	ff 75 e0             	pushl  -0x20(%ebp)
80105456:	e8 a5 ba ff ff       	call   80100f00 <fileclose>
    fileclose(wf);
8010545b:	58                   	pop    %eax
8010545c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010545f:	e8 9c ba ff ff       	call   80100f00 <fileclose>
    return -1;
80105464:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105467:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
8010546a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010546f:	5b                   	pop    %ebx
80105470:	5e                   	pop    %esi
80105471:	5f                   	pop    %edi
80105472:	5d                   	pop    %ebp
80105473:	c3                   	ret    
80105474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105478:	8d 73 08             	lea    0x8(%ebx),%esi
8010547b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010547f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105482:	e8 c9 e3 ff ff       	call   80103850 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105487:	31 d2                	xor    %edx,%edx
80105489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105490:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105494:	85 c9                	test   %ecx,%ecx
80105496:	74 18                	je     801054b0 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105498:	83 c2 01             	add    $0x1,%edx
8010549b:	83 fa 10             	cmp    $0x10,%edx
8010549e:	75 f0                	jne    80105490 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801054a0:	e8 ab e3 ff ff       	call   80103850 <myproc>
801054a5:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801054ac:	00 
801054ad:	eb a1                	jmp    80105450 <sys_pipe+0x50>
801054af:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801054b0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801054b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801054b7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801054b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801054bc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
801054bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
801054c2:	31 c0                	xor    %eax,%eax
}
801054c4:	5b                   	pop    %ebx
801054c5:	5e                   	pop    %esi
801054c6:	5f                   	pop    %edi
801054c7:	5d                   	pop    %ebp
801054c8:	c3                   	ret    
801054c9:	66 90                	xchg   %ax,%ax
801054cb:	66 90                	xchg   %ax,%ax
801054cd:	66 90                	xchg   %ax,%ax
801054cf:	90                   	nop

801054d0 <sys_shm_open>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_shm_open(void) {
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	83 ec 20             	sub    $0x20,%esp
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
801054d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054d9:	50                   	push   %eax
801054da:	6a 00                	push   $0x0
801054dc:	e8 df f2 ff ff       	call   801047c0 <argint>
801054e1:	83 c4 10             	add    $0x10,%esp
801054e4:	85 c0                	test   %eax,%eax
801054e6:	78 30                	js     80105518 <sys_shm_open+0x48>
    return -1;

  if(argptr(1, (char **) (&pointer),4)<0)
801054e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054eb:	83 ec 04             	sub    $0x4,%esp
801054ee:	6a 04                	push   $0x4
801054f0:	50                   	push   %eax
801054f1:	6a 01                	push   $0x1
801054f3:	e8 f8 f2 ff ff       	call   801047f0 <argptr>
801054f8:	83 c4 10             	add    $0x10,%esp
801054fb:	85 c0                	test   %eax,%eax
801054fd:	78 19                	js     80105518 <sys_shm_open+0x48>
    return -1;
  return shm_open(id, pointer);
801054ff:	83 ec 08             	sub    $0x8,%esp
80105502:	ff 75 f4             	pushl  -0xc(%ebp)
80105505:	ff 75 f0             	pushl  -0x10(%ebp)
80105508:	e8 b3 1c 00 00       	call   801071c0 <shm_open>
8010550d:	83 c4 10             	add    $0x10,%esp
}
80105510:	c9                   	leave  
80105511:	c3                   	ret    
80105512:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
int sys_shm_open(void) {
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
    return -1;
80105518:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  if(argptr(1, (char **) (&pointer),4)<0)
    return -1;
  return shm_open(id, pointer);
}
8010551d:	c9                   	leave  
8010551e:	c3                   	ret    
8010551f:	90                   	nop

80105520 <sys_shm_close>:

int sys_shm_close(void) {
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	83 ec 20             	sub    $0x20,%esp
  int id;

  if(argint(0, &id) < 0)
80105526:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105529:	50                   	push   %eax
8010552a:	6a 00                	push   $0x0
8010552c:	e8 8f f2 ff ff       	call   801047c0 <argint>
80105531:	83 c4 10             	add    $0x10,%esp
80105534:	85 c0                	test   %eax,%eax
80105536:	78 18                	js     80105550 <sys_shm_close+0x30>
    return -1;

  
  return shm_close(id);
80105538:	83 ec 0c             	sub    $0xc,%esp
8010553b:	ff 75 f4             	pushl  -0xc(%ebp)
8010553e:	e8 8d 1c 00 00       	call   801071d0 <shm_close>
80105543:	83 c4 10             	add    $0x10,%esp
}
80105546:	c9                   	leave  
80105547:	c3                   	ret    
80105548:	90                   	nop
80105549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

int sys_shm_close(void) {
  int id;

  if(argint(0, &id) < 0)
    return -1;
80105550:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  
  return shm_close(id);
}
80105555:	c9                   	leave  
80105556:	c3                   	ret    
80105557:	89 f6                	mov    %esi,%esi
80105559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105560 <sys_fork>:

int
sys_fork(void)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105563:	5d                   	pop    %ebp
}

int
sys_fork(void)
{
  return fork();
80105564:	e9 87 e4 ff ff       	jmp    801039f0 <fork>
80105569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105570 <sys_exit>:
}

int
sys_exit(void)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	83 ec 08             	sub    $0x8,%esp
  exit();
80105576:	e8 05 e7 ff ff       	call   80103c80 <exit>
  return 0;  // not reached
}
8010557b:	31 c0                	xor    %eax,%eax
8010557d:	c9                   	leave  
8010557e:	c3                   	ret    
8010557f:	90                   	nop

80105580 <sys_wait>:

int
sys_wait(void)
{
80105580:	55                   	push   %ebp
80105581:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105583:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105584:	e9 37 e9 ff ff       	jmp    80103ec0 <wait>
80105589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105590 <sys_kill>:
}

int
sys_kill(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105596:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105599:	50                   	push   %eax
8010559a:	6a 00                	push   $0x0
8010559c:	e8 1f f2 ff ff       	call   801047c0 <argint>
801055a1:	83 c4 10             	add    $0x10,%esp
801055a4:	85 c0                	test   %eax,%eax
801055a6:	78 18                	js     801055c0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801055a8:	83 ec 0c             	sub    $0xc,%esp
801055ab:	ff 75 f4             	pushl  -0xc(%ebp)
801055ae:	e8 5d ea ff ff       	call   80104010 <kill>
801055b3:	83 c4 10             	add    $0x10,%esp
}
801055b6:	c9                   	leave  
801055b7:	c3                   	ret    
801055b8:	90                   	nop
801055b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
801055c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
801055c5:	c9                   	leave  
801055c6:	c3                   	ret    
801055c7:	89 f6                	mov    %esi,%esi
801055c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055d0 <sys_getpid>:

int
sys_getpid(void)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801055d6:	e8 75 e2 ff ff       	call   80103850 <myproc>
801055db:	8b 40 10             	mov    0x10(%eax),%eax
}
801055de:	c9                   	leave  
801055df:	c3                   	ret    

801055e0 <sys_sbrk>:

int
sys_sbrk(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801055e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
801055e7:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801055ea:	50                   	push   %eax
801055eb:	6a 00                	push   $0x0
801055ed:	e8 ce f1 ff ff       	call   801047c0 <argint>
801055f2:	83 c4 10             	add    $0x10,%esp
801055f5:	85 c0                	test   %eax,%eax
801055f7:	78 27                	js     80105620 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801055f9:	e8 52 e2 ff ff       	call   80103850 <myproc>
  if(growproc(n) < 0)
801055fe:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105601:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105603:	ff 75 f4             	pushl  -0xc(%ebp)
80105606:	e8 65 e3 ff ff       	call   80103970 <growproc>
8010560b:	83 c4 10             	add    $0x10,%esp
8010560e:	85 c0                	test   %eax,%eax
80105610:	78 0e                	js     80105620 <sys_sbrk+0x40>
    return -1;
  return addr;
80105612:	89 d8                	mov    %ebx,%eax
}
80105614:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105617:	c9                   	leave  
80105618:	c3                   	ret    
80105619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105620:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105625:	eb ed                	jmp    80105614 <sys_sbrk+0x34>
80105627:	89 f6                	mov    %esi,%esi
80105629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105630 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105634:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80105637:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
8010563a:	50                   	push   %eax
8010563b:	6a 00                	push   $0x0
8010563d:	e8 7e f1 ff ff       	call   801047c0 <argint>
80105642:	83 c4 10             	add    $0x10,%esp
80105645:	85 c0                	test   %eax,%eax
80105647:	0f 88 8a 00 00 00    	js     801056d7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010564d:	83 ec 0c             	sub    $0xc,%esp
80105650:	68 60 4d 11 80       	push   $0x80114d60
80105655:	e8 16 ed ff ff       	call   80104370 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010565a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010565d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105660:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  while(ticks - ticks0 < n){
80105666:	85 d2                	test   %edx,%edx
80105668:	75 27                	jne    80105691 <sys_sleep+0x61>
8010566a:	eb 54                	jmp    801056c0 <sys_sleep+0x90>
8010566c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105670:	83 ec 08             	sub    $0x8,%esp
80105673:	68 60 4d 11 80       	push   $0x80114d60
80105678:	68 a0 55 11 80       	push   $0x801155a0
8010567d:	e8 7e e7 ff ff       	call   80103e00 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105682:	a1 a0 55 11 80       	mov    0x801155a0,%eax
80105687:	83 c4 10             	add    $0x10,%esp
8010568a:	29 d8                	sub    %ebx,%eax
8010568c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010568f:	73 2f                	jae    801056c0 <sys_sleep+0x90>
    if(myproc()->killed){
80105691:	e8 ba e1 ff ff       	call   80103850 <myproc>
80105696:	8b 40 24             	mov    0x24(%eax),%eax
80105699:	85 c0                	test   %eax,%eax
8010569b:	74 d3                	je     80105670 <sys_sleep+0x40>
      release(&tickslock);
8010569d:	83 ec 0c             	sub    $0xc,%esp
801056a0:	68 60 4d 11 80       	push   $0x80114d60
801056a5:	e8 e6 ed ff ff       	call   80104490 <release>
      return -1;
801056aa:	83 c4 10             	add    $0x10,%esp
801056ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
801056b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056b5:	c9                   	leave  
801056b6:	c3                   	ret    
801056b7:	89 f6                	mov    %esi,%esi
801056b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801056c0:	83 ec 0c             	sub    $0xc,%esp
801056c3:	68 60 4d 11 80       	push   $0x80114d60
801056c8:	e8 c3 ed ff ff       	call   80104490 <release>
  return 0;
801056cd:	83 c4 10             	add    $0x10,%esp
801056d0:	31 c0                	xor    %eax,%eax
}
801056d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056d5:	c9                   	leave  
801056d6:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
801056d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056dc:	eb d4                	jmp    801056b2 <sys_sleep+0x82>
801056de:	66 90                	xchg   %ax,%ax

801056e0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801056e0:	55                   	push   %ebp
801056e1:	89 e5                	mov    %esp,%ebp
801056e3:	53                   	push   %ebx
801056e4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801056e7:	68 60 4d 11 80       	push   $0x80114d60
801056ec:	e8 7f ec ff ff       	call   80104370 <acquire>
  xticks = ticks;
801056f1:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  release(&tickslock);
801056f7:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801056fe:	e8 8d ed ff ff       	call   80104490 <release>
  return xticks;
}
80105703:	89 d8                	mov    %ebx,%eax
80105705:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105708:	c9                   	leave  
80105709:	c3                   	ret    

8010570a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010570a:	1e                   	push   %ds
  pushl %es
8010570b:	06                   	push   %es
  pushl %fs
8010570c:	0f a0                	push   %fs
  pushl %gs
8010570e:	0f a8                	push   %gs
  pushal
80105710:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105711:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105715:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105717:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105719:	54                   	push   %esp
  call trap
8010571a:	e8 e1 00 00 00       	call   80105800 <trap>
  addl $4, %esp
8010571f:	83 c4 04             	add    $0x4,%esp

80105722 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105722:	61                   	popa   
  popl %gs
80105723:	0f a9                	pop    %gs
  popl %fs
80105725:	0f a1                	pop    %fs
  popl %es
80105727:	07                   	pop    %es
  popl %ds
80105728:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105729:	83 c4 08             	add    $0x8,%esp
  iret
8010572c:	cf                   	iret   
8010572d:	66 90                	xchg   %ax,%ax
8010572f:	90                   	nop

80105730 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105730:	31 c0                	xor    %eax,%eax
80105732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105738:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010573f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105744:	c6 04 c5 a4 4d 11 80 	movb   $0x0,-0x7feeb25c(,%eax,8)
8010574b:	00 
8010574c:	66 89 0c c5 a2 4d 11 	mov    %cx,-0x7feeb25e(,%eax,8)
80105753:	80 
80105754:	c6 04 c5 a5 4d 11 80 	movb   $0x8e,-0x7feeb25b(,%eax,8)
8010575b:	8e 
8010575c:	66 89 14 c5 a0 4d 11 	mov    %dx,-0x7feeb260(,%eax,8)
80105763:	80 
80105764:	c1 ea 10             	shr    $0x10,%edx
80105767:	66 89 14 c5 a6 4d 11 	mov    %dx,-0x7feeb25a(,%eax,8)
8010576e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010576f:	83 c0 01             	add    $0x1,%eax
80105772:	3d 00 01 00 00       	cmp    $0x100,%eax
80105777:	75 bf                	jne    80105738 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105779:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010577a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010577f:	89 e5                	mov    %esp,%ebp
80105781:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105784:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105789:	68 a1 79 10 80       	push   $0x801079a1
8010578e:	68 60 4d 11 80       	push   $0x80114d60
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105793:	66 89 15 a2 4f 11 80 	mov    %dx,0x80114fa2
8010579a:	c6 05 a4 4f 11 80 00 	movb   $0x0,0x80114fa4
801057a1:	66 a3 a0 4f 11 80    	mov    %ax,0x80114fa0
801057a7:	c1 e8 10             	shr    $0x10,%eax
801057aa:	c6 05 a5 4f 11 80 ef 	movb   $0xef,0x80114fa5
801057b1:	66 a3 a6 4f 11 80    	mov    %ax,0x80114fa6

  initlock(&tickslock, "time");
801057b7:	e8 b4 ea ff ff       	call   80104270 <initlock>
}
801057bc:	83 c4 10             	add    $0x10,%esp
801057bf:	c9                   	leave  
801057c0:	c3                   	ret    
801057c1:	eb 0d                	jmp    801057d0 <idtinit>
801057c3:	90                   	nop
801057c4:	90                   	nop
801057c5:	90                   	nop
801057c6:	90                   	nop
801057c7:	90                   	nop
801057c8:	90                   	nop
801057c9:	90                   	nop
801057ca:	90                   	nop
801057cb:	90                   	nop
801057cc:	90                   	nop
801057cd:	90                   	nop
801057ce:	90                   	nop
801057cf:	90                   	nop

801057d0 <idtinit>:

void
idtinit(void)
{
801057d0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801057d1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801057d6:	89 e5                	mov    %esp,%ebp
801057d8:	83 ec 10             	sub    $0x10,%esp
801057db:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801057df:	b8 a0 4d 11 80       	mov    $0x80114da0,%eax
801057e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801057e8:	c1 e8 10             	shr    $0x10,%eax
801057eb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801057ef:	8d 45 fa             	lea    -0x6(%ebp),%eax
801057f2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801057f5:	c9                   	leave  
801057f6:	c3                   	ret    
801057f7:	89 f6                	mov    %esi,%esi
801057f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105800 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	57                   	push   %edi
80105804:	56                   	push   %esi
80105805:	53                   	push   %ebx
80105806:	83 ec 1c             	sub    $0x1c,%esp
80105809:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010580c:	8b 47 30             	mov    0x30(%edi),%eax
8010580f:	83 f8 40             	cmp    $0x40,%eax
80105812:	0f 84 88 01 00 00    	je     801059a0 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105818:	83 e8 20             	sub    $0x20,%eax
8010581b:	83 f8 1f             	cmp    $0x1f,%eax
8010581e:	77 10                	ja     80105830 <trap+0x30>
80105820:	ff 24 85 48 7a 10 80 	jmp    *-0x7fef85b8(,%eax,4)
80105827:	89 f6                	mov    %esi,%esi
80105829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105830:	e8 1b e0 ff ff       	call   80103850 <myproc>
80105835:	85 c0                	test   %eax,%eax
80105837:	0f 84 d7 01 00 00    	je     80105a14 <trap+0x214>
8010583d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105841:	0f 84 cd 01 00 00    	je     80105a14 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105847:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010584a:	8b 57 38             	mov    0x38(%edi),%edx
8010584d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105850:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105853:	e8 d8 df ff ff       	call   80103830 <cpuid>
80105858:	8b 77 34             	mov    0x34(%edi),%esi
8010585b:	8b 5f 30             	mov    0x30(%edi),%ebx
8010585e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105861:	e8 ea df ff ff       	call   80103850 <myproc>
80105866:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105869:	e8 e2 df ff ff       	call   80103850 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010586e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105871:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105874:	51                   	push   %ecx
80105875:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105876:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105879:	ff 75 e4             	pushl  -0x1c(%ebp)
8010587c:	56                   	push   %esi
8010587d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010587e:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105881:	52                   	push   %edx
80105882:	ff 70 10             	pushl  0x10(%eax)
80105885:	68 04 7a 10 80       	push   $0x80107a04
8010588a:	e8 d1 ad ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010588f:	83 c4 20             	add    $0x20,%esp
80105892:	e8 b9 df ff ff       	call   80103850 <myproc>
80105897:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010589e:	66 90                	xchg   %ax,%ax
    }*/

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801058a0:	e8 ab df ff ff       	call   80103850 <myproc>
801058a5:	85 c0                	test   %eax,%eax
801058a7:	74 0c                	je     801058b5 <trap+0xb5>
801058a9:	e8 a2 df ff ff       	call   80103850 <myproc>
801058ae:	8b 50 24             	mov    0x24(%eax),%edx
801058b1:	85 d2                	test   %edx,%edx
801058b3:	75 4b                	jne    80105900 <trap+0x100>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801058b5:	e8 96 df ff ff       	call   80103850 <myproc>
801058ba:	85 c0                	test   %eax,%eax
801058bc:	74 0b                	je     801058c9 <trap+0xc9>
801058be:	e8 8d df ff ff       	call   80103850 <myproc>
801058c3:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801058c7:	74 4f                	je     80105918 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801058c9:	e8 82 df ff ff       	call   80103850 <myproc>
801058ce:	85 c0                	test   %eax,%eax
801058d0:	74 1d                	je     801058ef <trap+0xef>
801058d2:	e8 79 df ff ff       	call   80103850 <myproc>
801058d7:	8b 40 24             	mov    0x24(%eax),%eax
801058da:	85 c0                	test   %eax,%eax
801058dc:	74 11                	je     801058ef <trap+0xef>
801058de:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801058e2:	83 e0 03             	and    $0x3,%eax
801058e5:	66 83 f8 03          	cmp    $0x3,%ax
801058e9:	0f 84 da 00 00 00    	je     801059c9 <trap+0x1c9>
    exit();
}
801058ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058f2:	5b                   	pop    %ebx
801058f3:	5e                   	pop    %esi
801058f4:	5f                   	pop    %edi
801058f5:	5d                   	pop    %ebp
801058f6:	c3                   	ret    
801058f7:	89 f6                	mov    %esi,%esi
801058f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    }*/

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105900:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105904:	83 e0 03             	and    $0x3,%eax
80105907:	66 83 f8 03          	cmp    $0x3,%ax
8010590b:	75 a8                	jne    801058b5 <trap+0xb5>
    exit();
8010590d:	e8 6e e3 ff ff       	call   80103c80 <exit>
80105912:	eb a1                	jmp    801058b5 <trap+0xb5>
80105914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105918:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
8010591c:	75 ab                	jne    801058c9 <trap+0xc9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
8010591e:	e8 8d e4 ff ff       	call   80103db0 <yield>
80105923:	eb a4                	jmp    801058c9 <trap+0xc9>
80105925:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105928:	e8 03 df ff ff       	call   80103830 <cpuid>
8010592d:	85 c0                	test   %eax,%eax
8010592f:	0f 84 ab 00 00 00    	je     801059e0 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105935:	e8 a6 ce ff ff       	call   801027e0 <lapiceoi>
    break;
8010593a:	e9 61 ff ff ff       	jmp    801058a0 <trap+0xa0>
8010593f:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105940:	e8 5b cd ff ff       	call   801026a0 <kbdintr>
    lapiceoi();
80105945:	e8 96 ce ff ff       	call   801027e0 <lapiceoi>
    break;
8010594a:	e9 51 ff ff ff       	jmp    801058a0 <trap+0xa0>
8010594f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105950:	e8 5b 02 00 00       	call   80105bb0 <uartintr>
    lapiceoi();
80105955:	e8 86 ce ff ff       	call   801027e0 <lapiceoi>
    break;
8010595a:	e9 41 ff ff ff       	jmp    801058a0 <trap+0xa0>
8010595f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105960:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105964:	8b 77 38             	mov    0x38(%edi),%esi
80105967:	e8 c4 de ff ff       	call   80103830 <cpuid>
8010596c:	56                   	push   %esi
8010596d:	53                   	push   %ebx
8010596e:	50                   	push   %eax
8010596f:	68 ac 79 10 80       	push   $0x801079ac
80105974:	e8 e7 ac ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105979:	e8 62 ce ff ff       	call   801027e0 <lapiceoi>
    break;
8010597e:	83 c4 10             	add    $0x10,%esp
80105981:	e9 1a ff ff ff       	jmp    801058a0 <trap+0xa0>
80105986:	8d 76 00             	lea    0x0(%esi),%esi
80105989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105990:	e8 8b c7 ff ff       	call   80102120 <ideintr>
80105995:	eb 9e                	jmp    80105935 <trap+0x135>
80105997:	89 f6                	mov    %esi,%esi
80105999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
801059a0:	e8 ab de ff ff       	call   80103850 <myproc>
801059a5:	8b 58 24             	mov    0x24(%eax),%ebx
801059a8:	85 db                	test   %ebx,%ebx
801059aa:	75 2c                	jne    801059d8 <trap+0x1d8>
      exit();
    myproc()->tf = tf;
801059ac:	e8 9f de ff ff       	call   80103850 <myproc>
801059b1:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
801059b4:	e8 c7 ee ff ff       	call   80104880 <syscall>
    if(myproc()->killed)
801059b9:	e8 92 de ff ff       	call   80103850 <myproc>
801059be:	8b 48 24             	mov    0x24(%eax),%ecx
801059c1:	85 c9                	test   %ecx,%ecx
801059c3:	0f 84 26 ff ff ff    	je     801058ef <trap+0xef>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801059c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059cc:	5b                   	pop    %ebx
801059cd:	5e                   	pop    %esi
801059ce:	5f                   	pop    %edi
801059cf:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
801059d0:	e9 ab e2 ff ff       	jmp    80103c80 <exit>
801059d5:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
801059d8:	e8 a3 e2 ff ff       	call   80103c80 <exit>
801059dd:	eb cd                	jmp    801059ac <trap+0x1ac>
801059df:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
801059e0:	83 ec 0c             	sub    $0xc,%esp
801059e3:	68 60 4d 11 80       	push   $0x80114d60
801059e8:	e8 83 e9 ff ff       	call   80104370 <acquire>
      ticks++;
      wakeup(&ticks);
801059ed:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
801059f4:	83 05 a0 55 11 80 01 	addl   $0x1,0x801155a0
      wakeup(&ticks);
801059fb:	e8 b0 e5 ff ff       	call   80103fb0 <wakeup>
      release(&tickslock);
80105a00:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
80105a07:	e8 84 ea ff ff       	call   80104490 <release>
80105a0c:	83 c4 10             	add    $0x10,%esp
80105a0f:	e9 21 ff ff ff       	jmp    80105935 <trap+0x135>
80105a14:	0f 20 d6             	mov    %cr2,%esi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105a17:	8b 5f 38             	mov    0x38(%edi),%ebx
80105a1a:	e8 11 de ff ff       	call   80103830 <cpuid>
80105a1f:	83 ec 0c             	sub    $0xc,%esp
80105a22:	56                   	push   %esi
80105a23:	53                   	push   %ebx
80105a24:	50                   	push   %eax
80105a25:	ff 77 30             	pushl  0x30(%edi)
80105a28:	68 d0 79 10 80       	push   $0x801079d0
80105a2d:	e8 2e ac ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80105a32:	83 c4 14             	add    $0x14,%esp
80105a35:	68 a6 79 10 80       	push   $0x801079a6
80105a3a:	e8 31 a9 ff ff       	call   80100370 <panic>
80105a3f:	90                   	nop

80105a40 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105a40:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105a45:	55                   	push   %ebp
80105a46:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105a48:	85 c0                	test   %eax,%eax
80105a4a:	74 1c                	je     80105a68 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105a4c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105a51:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105a52:	a8 01                	test   $0x1,%al
80105a54:	74 12                	je     80105a68 <uartgetc+0x28>
80105a56:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a5b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105a5c:	0f b6 c0             	movzbl %al,%eax
}
80105a5f:	5d                   	pop    %ebp
80105a60:	c3                   	ret    
80105a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105a68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105a6d:	5d                   	pop    %ebp
80105a6e:	c3                   	ret    
80105a6f:	90                   	nop

80105a70 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80105a70:	55                   	push   %ebp
80105a71:	89 e5                	mov    %esp,%ebp
80105a73:	57                   	push   %edi
80105a74:	56                   	push   %esi
80105a75:	53                   	push   %ebx
80105a76:	89 c7                	mov    %eax,%edi
80105a78:	bb 80 00 00 00       	mov    $0x80,%ebx
80105a7d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105a82:	83 ec 0c             	sub    $0xc,%esp
80105a85:	eb 1b                	jmp    80105aa2 <uartputc.part.0+0x32>
80105a87:	89 f6                	mov    %esi,%esi
80105a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105a90:	83 ec 0c             	sub    $0xc,%esp
80105a93:	6a 0a                	push   $0xa
80105a95:	e8 66 cd ff ff       	call   80102800 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105a9a:	83 c4 10             	add    $0x10,%esp
80105a9d:	83 eb 01             	sub    $0x1,%ebx
80105aa0:	74 07                	je     80105aa9 <uartputc.part.0+0x39>
80105aa2:	89 f2                	mov    %esi,%edx
80105aa4:	ec                   	in     (%dx),%al
80105aa5:	a8 20                	test   $0x20,%al
80105aa7:	74 e7                	je     80105a90 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105aa9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105aae:	89 f8                	mov    %edi,%eax
80105ab0:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105ab1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ab4:	5b                   	pop    %ebx
80105ab5:	5e                   	pop    %esi
80105ab6:	5f                   	pop    %edi
80105ab7:	5d                   	pop    %ebp
80105ab8:	c3                   	ret    
80105ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ac0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105ac0:	55                   	push   %ebp
80105ac1:	31 c9                	xor    %ecx,%ecx
80105ac3:	89 c8                	mov    %ecx,%eax
80105ac5:	89 e5                	mov    %esp,%ebp
80105ac7:	57                   	push   %edi
80105ac8:	56                   	push   %esi
80105ac9:	53                   	push   %ebx
80105aca:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105acf:	89 da                	mov    %ebx,%edx
80105ad1:	83 ec 0c             	sub    $0xc,%esp
80105ad4:	ee                   	out    %al,(%dx)
80105ad5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105ada:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105adf:	89 fa                	mov    %edi,%edx
80105ae1:	ee                   	out    %al,(%dx)
80105ae2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105ae7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105aec:	ee                   	out    %al,(%dx)
80105aed:	be f9 03 00 00       	mov    $0x3f9,%esi
80105af2:	89 c8                	mov    %ecx,%eax
80105af4:	89 f2                	mov    %esi,%edx
80105af6:	ee                   	out    %al,(%dx)
80105af7:	b8 03 00 00 00       	mov    $0x3,%eax
80105afc:	89 fa                	mov    %edi,%edx
80105afe:	ee                   	out    %al,(%dx)
80105aff:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105b04:	89 c8                	mov    %ecx,%eax
80105b06:	ee                   	out    %al,(%dx)
80105b07:	b8 01 00 00 00       	mov    $0x1,%eax
80105b0c:	89 f2                	mov    %esi,%edx
80105b0e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b0f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105b14:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105b15:	3c ff                	cmp    $0xff,%al
80105b17:	74 5a                	je     80105b73 <uartinit+0xb3>
    return;
  uart = 1;
80105b19:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105b20:	00 00 00 
80105b23:	89 da                	mov    %ebx,%edx
80105b25:	ec                   	in     (%dx),%al
80105b26:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b2b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105b2c:	83 ec 08             	sub    $0x8,%esp
80105b2f:	bb c8 7a 10 80       	mov    $0x80107ac8,%ebx
80105b34:	6a 00                	push   $0x0
80105b36:	6a 04                	push   $0x4
80105b38:	e8 33 c8 ff ff       	call   80102370 <ioapicenable>
80105b3d:	83 c4 10             	add    $0x10,%esp
80105b40:	b8 78 00 00 00       	mov    $0x78,%eax
80105b45:	eb 13                	jmp    80105b5a <uartinit+0x9a>
80105b47:	89 f6                	mov    %esi,%esi
80105b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105b50:	83 c3 01             	add    $0x1,%ebx
80105b53:	0f be 03             	movsbl (%ebx),%eax
80105b56:	84 c0                	test   %al,%al
80105b58:	74 19                	je     80105b73 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
80105b5a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105b60:	85 d2                	test   %edx,%edx
80105b62:	74 ec                	je     80105b50 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105b64:	83 c3 01             	add    $0x1,%ebx
80105b67:	e8 04 ff ff ff       	call   80105a70 <uartputc.part.0>
80105b6c:	0f be 03             	movsbl (%ebx),%eax
80105b6f:	84 c0                	test   %al,%al
80105b71:	75 e7                	jne    80105b5a <uartinit+0x9a>
    uartputc(*p);
}
80105b73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b76:	5b                   	pop    %ebx
80105b77:	5e                   	pop    %esi
80105b78:	5f                   	pop    %edi
80105b79:	5d                   	pop    %ebp
80105b7a:	c3                   	ret    
80105b7b:	90                   	nop
80105b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b80 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105b80:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105b86:	55                   	push   %ebp
80105b87:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80105b89:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
80105b8e:	74 10                	je     80105ba0 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80105b90:	5d                   	pop    %ebp
80105b91:	e9 da fe ff ff       	jmp    80105a70 <uartputc.part.0>
80105b96:	8d 76 00             	lea    0x0(%esi),%esi
80105b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105ba0:	5d                   	pop    %ebp
80105ba1:	c3                   	ret    
80105ba2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bb0 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105bb0:	55                   	push   %ebp
80105bb1:	89 e5                	mov    %esp,%ebp
80105bb3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105bb6:	68 40 5a 10 80       	push   $0x80105a40
80105bbb:	e8 30 ac ff ff       	call   801007f0 <consoleintr>
}
80105bc0:	83 c4 10             	add    $0x10,%esp
80105bc3:	c9                   	leave  
80105bc4:	c3                   	ret    

80105bc5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105bc5:	6a 00                	push   $0x0
  pushl $0
80105bc7:	6a 00                	push   $0x0
  jmp alltraps
80105bc9:	e9 3c fb ff ff       	jmp    8010570a <alltraps>

80105bce <vector1>:
.globl vector1
vector1:
  pushl $0
80105bce:	6a 00                	push   $0x0
  pushl $1
80105bd0:	6a 01                	push   $0x1
  jmp alltraps
80105bd2:	e9 33 fb ff ff       	jmp    8010570a <alltraps>

80105bd7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105bd7:	6a 00                	push   $0x0
  pushl $2
80105bd9:	6a 02                	push   $0x2
  jmp alltraps
80105bdb:	e9 2a fb ff ff       	jmp    8010570a <alltraps>

80105be0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105be0:	6a 00                	push   $0x0
  pushl $3
80105be2:	6a 03                	push   $0x3
  jmp alltraps
80105be4:	e9 21 fb ff ff       	jmp    8010570a <alltraps>

80105be9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105be9:	6a 00                	push   $0x0
  pushl $4
80105beb:	6a 04                	push   $0x4
  jmp alltraps
80105bed:	e9 18 fb ff ff       	jmp    8010570a <alltraps>

80105bf2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105bf2:	6a 00                	push   $0x0
  pushl $5
80105bf4:	6a 05                	push   $0x5
  jmp alltraps
80105bf6:	e9 0f fb ff ff       	jmp    8010570a <alltraps>

80105bfb <vector6>:
.globl vector6
vector6:
  pushl $0
80105bfb:	6a 00                	push   $0x0
  pushl $6
80105bfd:	6a 06                	push   $0x6
  jmp alltraps
80105bff:	e9 06 fb ff ff       	jmp    8010570a <alltraps>

80105c04 <vector7>:
.globl vector7
vector7:
  pushl $0
80105c04:	6a 00                	push   $0x0
  pushl $7
80105c06:	6a 07                	push   $0x7
  jmp alltraps
80105c08:	e9 fd fa ff ff       	jmp    8010570a <alltraps>

80105c0d <vector8>:
.globl vector8
vector8:
  pushl $8
80105c0d:	6a 08                	push   $0x8
  jmp alltraps
80105c0f:	e9 f6 fa ff ff       	jmp    8010570a <alltraps>

80105c14 <vector9>:
.globl vector9
vector9:
  pushl $0
80105c14:	6a 00                	push   $0x0
  pushl $9
80105c16:	6a 09                	push   $0x9
  jmp alltraps
80105c18:	e9 ed fa ff ff       	jmp    8010570a <alltraps>

80105c1d <vector10>:
.globl vector10
vector10:
  pushl $10
80105c1d:	6a 0a                	push   $0xa
  jmp alltraps
80105c1f:	e9 e6 fa ff ff       	jmp    8010570a <alltraps>

80105c24 <vector11>:
.globl vector11
vector11:
  pushl $11
80105c24:	6a 0b                	push   $0xb
  jmp alltraps
80105c26:	e9 df fa ff ff       	jmp    8010570a <alltraps>

80105c2b <vector12>:
.globl vector12
vector12:
  pushl $12
80105c2b:	6a 0c                	push   $0xc
  jmp alltraps
80105c2d:	e9 d8 fa ff ff       	jmp    8010570a <alltraps>

80105c32 <vector13>:
.globl vector13
vector13:
  pushl $13
80105c32:	6a 0d                	push   $0xd
  jmp alltraps
80105c34:	e9 d1 fa ff ff       	jmp    8010570a <alltraps>

80105c39 <vector14>:
.globl vector14
vector14:
  pushl $14
80105c39:	6a 0e                	push   $0xe
  jmp alltraps
80105c3b:	e9 ca fa ff ff       	jmp    8010570a <alltraps>

80105c40 <vector15>:
.globl vector15
vector15:
  pushl $0
80105c40:	6a 00                	push   $0x0
  pushl $15
80105c42:	6a 0f                	push   $0xf
  jmp alltraps
80105c44:	e9 c1 fa ff ff       	jmp    8010570a <alltraps>

80105c49 <vector16>:
.globl vector16
vector16:
  pushl $0
80105c49:	6a 00                	push   $0x0
  pushl $16
80105c4b:	6a 10                	push   $0x10
  jmp alltraps
80105c4d:	e9 b8 fa ff ff       	jmp    8010570a <alltraps>

80105c52 <vector17>:
.globl vector17
vector17:
  pushl $17
80105c52:	6a 11                	push   $0x11
  jmp alltraps
80105c54:	e9 b1 fa ff ff       	jmp    8010570a <alltraps>

80105c59 <vector18>:
.globl vector18
vector18:
  pushl $0
80105c59:	6a 00                	push   $0x0
  pushl $18
80105c5b:	6a 12                	push   $0x12
  jmp alltraps
80105c5d:	e9 a8 fa ff ff       	jmp    8010570a <alltraps>

80105c62 <vector19>:
.globl vector19
vector19:
  pushl $0
80105c62:	6a 00                	push   $0x0
  pushl $19
80105c64:	6a 13                	push   $0x13
  jmp alltraps
80105c66:	e9 9f fa ff ff       	jmp    8010570a <alltraps>

80105c6b <vector20>:
.globl vector20
vector20:
  pushl $0
80105c6b:	6a 00                	push   $0x0
  pushl $20
80105c6d:	6a 14                	push   $0x14
  jmp alltraps
80105c6f:	e9 96 fa ff ff       	jmp    8010570a <alltraps>

80105c74 <vector21>:
.globl vector21
vector21:
  pushl $0
80105c74:	6a 00                	push   $0x0
  pushl $21
80105c76:	6a 15                	push   $0x15
  jmp alltraps
80105c78:	e9 8d fa ff ff       	jmp    8010570a <alltraps>

80105c7d <vector22>:
.globl vector22
vector22:
  pushl $0
80105c7d:	6a 00                	push   $0x0
  pushl $22
80105c7f:	6a 16                	push   $0x16
  jmp alltraps
80105c81:	e9 84 fa ff ff       	jmp    8010570a <alltraps>

80105c86 <vector23>:
.globl vector23
vector23:
  pushl $0
80105c86:	6a 00                	push   $0x0
  pushl $23
80105c88:	6a 17                	push   $0x17
  jmp alltraps
80105c8a:	e9 7b fa ff ff       	jmp    8010570a <alltraps>

80105c8f <vector24>:
.globl vector24
vector24:
  pushl $0
80105c8f:	6a 00                	push   $0x0
  pushl $24
80105c91:	6a 18                	push   $0x18
  jmp alltraps
80105c93:	e9 72 fa ff ff       	jmp    8010570a <alltraps>

80105c98 <vector25>:
.globl vector25
vector25:
  pushl $0
80105c98:	6a 00                	push   $0x0
  pushl $25
80105c9a:	6a 19                	push   $0x19
  jmp alltraps
80105c9c:	e9 69 fa ff ff       	jmp    8010570a <alltraps>

80105ca1 <vector26>:
.globl vector26
vector26:
  pushl $0
80105ca1:	6a 00                	push   $0x0
  pushl $26
80105ca3:	6a 1a                	push   $0x1a
  jmp alltraps
80105ca5:	e9 60 fa ff ff       	jmp    8010570a <alltraps>

80105caa <vector27>:
.globl vector27
vector27:
  pushl $0
80105caa:	6a 00                	push   $0x0
  pushl $27
80105cac:	6a 1b                	push   $0x1b
  jmp alltraps
80105cae:	e9 57 fa ff ff       	jmp    8010570a <alltraps>

80105cb3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105cb3:	6a 00                	push   $0x0
  pushl $28
80105cb5:	6a 1c                	push   $0x1c
  jmp alltraps
80105cb7:	e9 4e fa ff ff       	jmp    8010570a <alltraps>

80105cbc <vector29>:
.globl vector29
vector29:
  pushl $0
80105cbc:	6a 00                	push   $0x0
  pushl $29
80105cbe:	6a 1d                	push   $0x1d
  jmp alltraps
80105cc0:	e9 45 fa ff ff       	jmp    8010570a <alltraps>

80105cc5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105cc5:	6a 00                	push   $0x0
  pushl $30
80105cc7:	6a 1e                	push   $0x1e
  jmp alltraps
80105cc9:	e9 3c fa ff ff       	jmp    8010570a <alltraps>

80105cce <vector31>:
.globl vector31
vector31:
  pushl $0
80105cce:	6a 00                	push   $0x0
  pushl $31
80105cd0:	6a 1f                	push   $0x1f
  jmp alltraps
80105cd2:	e9 33 fa ff ff       	jmp    8010570a <alltraps>

80105cd7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105cd7:	6a 00                	push   $0x0
  pushl $32
80105cd9:	6a 20                	push   $0x20
  jmp alltraps
80105cdb:	e9 2a fa ff ff       	jmp    8010570a <alltraps>

80105ce0 <vector33>:
.globl vector33
vector33:
  pushl $0
80105ce0:	6a 00                	push   $0x0
  pushl $33
80105ce2:	6a 21                	push   $0x21
  jmp alltraps
80105ce4:	e9 21 fa ff ff       	jmp    8010570a <alltraps>

80105ce9 <vector34>:
.globl vector34
vector34:
  pushl $0
80105ce9:	6a 00                	push   $0x0
  pushl $34
80105ceb:	6a 22                	push   $0x22
  jmp alltraps
80105ced:	e9 18 fa ff ff       	jmp    8010570a <alltraps>

80105cf2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105cf2:	6a 00                	push   $0x0
  pushl $35
80105cf4:	6a 23                	push   $0x23
  jmp alltraps
80105cf6:	e9 0f fa ff ff       	jmp    8010570a <alltraps>

80105cfb <vector36>:
.globl vector36
vector36:
  pushl $0
80105cfb:	6a 00                	push   $0x0
  pushl $36
80105cfd:	6a 24                	push   $0x24
  jmp alltraps
80105cff:	e9 06 fa ff ff       	jmp    8010570a <alltraps>

80105d04 <vector37>:
.globl vector37
vector37:
  pushl $0
80105d04:	6a 00                	push   $0x0
  pushl $37
80105d06:	6a 25                	push   $0x25
  jmp alltraps
80105d08:	e9 fd f9 ff ff       	jmp    8010570a <alltraps>

80105d0d <vector38>:
.globl vector38
vector38:
  pushl $0
80105d0d:	6a 00                	push   $0x0
  pushl $38
80105d0f:	6a 26                	push   $0x26
  jmp alltraps
80105d11:	e9 f4 f9 ff ff       	jmp    8010570a <alltraps>

80105d16 <vector39>:
.globl vector39
vector39:
  pushl $0
80105d16:	6a 00                	push   $0x0
  pushl $39
80105d18:	6a 27                	push   $0x27
  jmp alltraps
80105d1a:	e9 eb f9 ff ff       	jmp    8010570a <alltraps>

80105d1f <vector40>:
.globl vector40
vector40:
  pushl $0
80105d1f:	6a 00                	push   $0x0
  pushl $40
80105d21:	6a 28                	push   $0x28
  jmp alltraps
80105d23:	e9 e2 f9 ff ff       	jmp    8010570a <alltraps>

80105d28 <vector41>:
.globl vector41
vector41:
  pushl $0
80105d28:	6a 00                	push   $0x0
  pushl $41
80105d2a:	6a 29                	push   $0x29
  jmp alltraps
80105d2c:	e9 d9 f9 ff ff       	jmp    8010570a <alltraps>

80105d31 <vector42>:
.globl vector42
vector42:
  pushl $0
80105d31:	6a 00                	push   $0x0
  pushl $42
80105d33:	6a 2a                	push   $0x2a
  jmp alltraps
80105d35:	e9 d0 f9 ff ff       	jmp    8010570a <alltraps>

80105d3a <vector43>:
.globl vector43
vector43:
  pushl $0
80105d3a:	6a 00                	push   $0x0
  pushl $43
80105d3c:	6a 2b                	push   $0x2b
  jmp alltraps
80105d3e:	e9 c7 f9 ff ff       	jmp    8010570a <alltraps>

80105d43 <vector44>:
.globl vector44
vector44:
  pushl $0
80105d43:	6a 00                	push   $0x0
  pushl $44
80105d45:	6a 2c                	push   $0x2c
  jmp alltraps
80105d47:	e9 be f9 ff ff       	jmp    8010570a <alltraps>

80105d4c <vector45>:
.globl vector45
vector45:
  pushl $0
80105d4c:	6a 00                	push   $0x0
  pushl $45
80105d4e:	6a 2d                	push   $0x2d
  jmp alltraps
80105d50:	e9 b5 f9 ff ff       	jmp    8010570a <alltraps>

80105d55 <vector46>:
.globl vector46
vector46:
  pushl $0
80105d55:	6a 00                	push   $0x0
  pushl $46
80105d57:	6a 2e                	push   $0x2e
  jmp alltraps
80105d59:	e9 ac f9 ff ff       	jmp    8010570a <alltraps>

80105d5e <vector47>:
.globl vector47
vector47:
  pushl $0
80105d5e:	6a 00                	push   $0x0
  pushl $47
80105d60:	6a 2f                	push   $0x2f
  jmp alltraps
80105d62:	e9 a3 f9 ff ff       	jmp    8010570a <alltraps>

80105d67 <vector48>:
.globl vector48
vector48:
  pushl $0
80105d67:	6a 00                	push   $0x0
  pushl $48
80105d69:	6a 30                	push   $0x30
  jmp alltraps
80105d6b:	e9 9a f9 ff ff       	jmp    8010570a <alltraps>

80105d70 <vector49>:
.globl vector49
vector49:
  pushl $0
80105d70:	6a 00                	push   $0x0
  pushl $49
80105d72:	6a 31                	push   $0x31
  jmp alltraps
80105d74:	e9 91 f9 ff ff       	jmp    8010570a <alltraps>

80105d79 <vector50>:
.globl vector50
vector50:
  pushl $0
80105d79:	6a 00                	push   $0x0
  pushl $50
80105d7b:	6a 32                	push   $0x32
  jmp alltraps
80105d7d:	e9 88 f9 ff ff       	jmp    8010570a <alltraps>

80105d82 <vector51>:
.globl vector51
vector51:
  pushl $0
80105d82:	6a 00                	push   $0x0
  pushl $51
80105d84:	6a 33                	push   $0x33
  jmp alltraps
80105d86:	e9 7f f9 ff ff       	jmp    8010570a <alltraps>

80105d8b <vector52>:
.globl vector52
vector52:
  pushl $0
80105d8b:	6a 00                	push   $0x0
  pushl $52
80105d8d:	6a 34                	push   $0x34
  jmp alltraps
80105d8f:	e9 76 f9 ff ff       	jmp    8010570a <alltraps>

80105d94 <vector53>:
.globl vector53
vector53:
  pushl $0
80105d94:	6a 00                	push   $0x0
  pushl $53
80105d96:	6a 35                	push   $0x35
  jmp alltraps
80105d98:	e9 6d f9 ff ff       	jmp    8010570a <alltraps>

80105d9d <vector54>:
.globl vector54
vector54:
  pushl $0
80105d9d:	6a 00                	push   $0x0
  pushl $54
80105d9f:	6a 36                	push   $0x36
  jmp alltraps
80105da1:	e9 64 f9 ff ff       	jmp    8010570a <alltraps>

80105da6 <vector55>:
.globl vector55
vector55:
  pushl $0
80105da6:	6a 00                	push   $0x0
  pushl $55
80105da8:	6a 37                	push   $0x37
  jmp alltraps
80105daa:	e9 5b f9 ff ff       	jmp    8010570a <alltraps>

80105daf <vector56>:
.globl vector56
vector56:
  pushl $0
80105daf:	6a 00                	push   $0x0
  pushl $56
80105db1:	6a 38                	push   $0x38
  jmp alltraps
80105db3:	e9 52 f9 ff ff       	jmp    8010570a <alltraps>

80105db8 <vector57>:
.globl vector57
vector57:
  pushl $0
80105db8:	6a 00                	push   $0x0
  pushl $57
80105dba:	6a 39                	push   $0x39
  jmp alltraps
80105dbc:	e9 49 f9 ff ff       	jmp    8010570a <alltraps>

80105dc1 <vector58>:
.globl vector58
vector58:
  pushl $0
80105dc1:	6a 00                	push   $0x0
  pushl $58
80105dc3:	6a 3a                	push   $0x3a
  jmp alltraps
80105dc5:	e9 40 f9 ff ff       	jmp    8010570a <alltraps>

80105dca <vector59>:
.globl vector59
vector59:
  pushl $0
80105dca:	6a 00                	push   $0x0
  pushl $59
80105dcc:	6a 3b                	push   $0x3b
  jmp alltraps
80105dce:	e9 37 f9 ff ff       	jmp    8010570a <alltraps>

80105dd3 <vector60>:
.globl vector60
vector60:
  pushl $0
80105dd3:	6a 00                	push   $0x0
  pushl $60
80105dd5:	6a 3c                	push   $0x3c
  jmp alltraps
80105dd7:	e9 2e f9 ff ff       	jmp    8010570a <alltraps>

80105ddc <vector61>:
.globl vector61
vector61:
  pushl $0
80105ddc:	6a 00                	push   $0x0
  pushl $61
80105dde:	6a 3d                	push   $0x3d
  jmp alltraps
80105de0:	e9 25 f9 ff ff       	jmp    8010570a <alltraps>

80105de5 <vector62>:
.globl vector62
vector62:
  pushl $0
80105de5:	6a 00                	push   $0x0
  pushl $62
80105de7:	6a 3e                	push   $0x3e
  jmp alltraps
80105de9:	e9 1c f9 ff ff       	jmp    8010570a <alltraps>

80105dee <vector63>:
.globl vector63
vector63:
  pushl $0
80105dee:	6a 00                	push   $0x0
  pushl $63
80105df0:	6a 3f                	push   $0x3f
  jmp alltraps
80105df2:	e9 13 f9 ff ff       	jmp    8010570a <alltraps>

80105df7 <vector64>:
.globl vector64
vector64:
  pushl $0
80105df7:	6a 00                	push   $0x0
  pushl $64
80105df9:	6a 40                	push   $0x40
  jmp alltraps
80105dfb:	e9 0a f9 ff ff       	jmp    8010570a <alltraps>

80105e00 <vector65>:
.globl vector65
vector65:
  pushl $0
80105e00:	6a 00                	push   $0x0
  pushl $65
80105e02:	6a 41                	push   $0x41
  jmp alltraps
80105e04:	e9 01 f9 ff ff       	jmp    8010570a <alltraps>

80105e09 <vector66>:
.globl vector66
vector66:
  pushl $0
80105e09:	6a 00                	push   $0x0
  pushl $66
80105e0b:	6a 42                	push   $0x42
  jmp alltraps
80105e0d:	e9 f8 f8 ff ff       	jmp    8010570a <alltraps>

80105e12 <vector67>:
.globl vector67
vector67:
  pushl $0
80105e12:	6a 00                	push   $0x0
  pushl $67
80105e14:	6a 43                	push   $0x43
  jmp alltraps
80105e16:	e9 ef f8 ff ff       	jmp    8010570a <alltraps>

80105e1b <vector68>:
.globl vector68
vector68:
  pushl $0
80105e1b:	6a 00                	push   $0x0
  pushl $68
80105e1d:	6a 44                	push   $0x44
  jmp alltraps
80105e1f:	e9 e6 f8 ff ff       	jmp    8010570a <alltraps>

80105e24 <vector69>:
.globl vector69
vector69:
  pushl $0
80105e24:	6a 00                	push   $0x0
  pushl $69
80105e26:	6a 45                	push   $0x45
  jmp alltraps
80105e28:	e9 dd f8 ff ff       	jmp    8010570a <alltraps>

80105e2d <vector70>:
.globl vector70
vector70:
  pushl $0
80105e2d:	6a 00                	push   $0x0
  pushl $70
80105e2f:	6a 46                	push   $0x46
  jmp alltraps
80105e31:	e9 d4 f8 ff ff       	jmp    8010570a <alltraps>

80105e36 <vector71>:
.globl vector71
vector71:
  pushl $0
80105e36:	6a 00                	push   $0x0
  pushl $71
80105e38:	6a 47                	push   $0x47
  jmp alltraps
80105e3a:	e9 cb f8 ff ff       	jmp    8010570a <alltraps>

80105e3f <vector72>:
.globl vector72
vector72:
  pushl $0
80105e3f:	6a 00                	push   $0x0
  pushl $72
80105e41:	6a 48                	push   $0x48
  jmp alltraps
80105e43:	e9 c2 f8 ff ff       	jmp    8010570a <alltraps>

80105e48 <vector73>:
.globl vector73
vector73:
  pushl $0
80105e48:	6a 00                	push   $0x0
  pushl $73
80105e4a:	6a 49                	push   $0x49
  jmp alltraps
80105e4c:	e9 b9 f8 ff ff       	jmp    8010570a <alltraps>

80105e51 <vector74>:
.globl vector74
vector74:
  pushl $0
80105e51:	6a 00                	push   $0x0
  pushl $74
80105e53:	6a 4a                	push   $0x4a
  jmp alltraps
80105e55:	e9 b0 f8 ff ff       	jmp    8010570a <alltraps>

80105e5a <vector75>:
.globl vector75
vector75:
  pushl $0
80105e5a:	6a 00                	push   $0x0
  pushl $75
80105e5c:	6a 4b                	push   $0x4b
  jmp alltraps
80105e5e:	e9 a7 f8 ff ff       	jmp    8010570a <alltraps>

80105e63 <vector76>:
.globl vector76
vector76:
  pushl $0
80105e63:	6a 00                	push   $0x0
  pushl $76
80105e65:	6a 4c                	push   $0x4c
  jmp alltraps
80105e67:	e9 9e f8 ff ff       	jmp    8010570a <alltraps>

80105e6c <vector77>:
.globl vector77
vector77:
  pushl $0
80105e6c:	6a 00                	push   $0x0
  pushl $77
80105e6e:	6a 4d                	push   $0x4d
  jmp alltraps
80105e70:	e9 95 f8 ff ff       	jmp    8010570a <alltraps>

80105e75 <vector78>:
.globl vector78
vector78:
  pushl $0
80105e75:	6a 00                	push   $0x0
  pushl $78
80105e77:	6a 4e                	push   $0x4e
  jmp alltraps
80105e79:	e9 8c f8 ff ff       	jmp    8010570a <alltraps>

80105e7e <vector79>:
.globl vector79
vector79:
  pushl $0
80105e7e:	6a 00                	push   $0x0
  pushl $79
80105e80:	6a 4f                	push   $0x4f
  jmp alltraps
80105e82:	e9 83 f8 ff ff       	jmp    8010570a <alltraps>

80105e87 <vector80>:
.globl vector80
vector80:
  pushl $0
80105e87:	6a 00                	push   $0x0
  pushl $80
80105e89:	6a 50                	push   $0x50
  jmp alltraps
80105e8b:	e9 7a f8 ff ff       	jmp    8010570a <alltraps>

80105e90 <vector81>:
.globl vector81
vector81:
  pushl $0
80105e90:	6a 00                	push   $0x0
  pushl $81
80105e92:	6a 51                	push   $0x51
  jmp alltraps
80105e94:	e9 71 f8 ff ff       	jmp    8010570a <alltraps>

80105e99 <vector82>:
.globl vector82
vector82:
  pushl $0
80105e99:	6a 00                	push   $0x0
  pushl $82
80105e9b:	6a 52                	push   $0x52
  jmp alltraps
80105e9d:	e9 68 f8 ff ff       	jmp    8010570a <alltraps>

80105ea2 <vector83>:
.globl vector83
vector83:
  pushl $0
80105ea2:	6a 00                	push   $0x0
  pushl $83
80105ea4:	6a 53                	push   $0x53
  jmp alltraps
80105ea6:	e9 5f f8 ff ff       	jmp    8010570a <alltraps>

80105eab <vector84>:
.globl vector84
vector84:
  pushl $0
80105eab:	6a 00                	push   $0x0
  pushl $84
80105ead:	6a 54                	push   $0x54
  jmp alltraps
80105eaf:	e9 56 f8 ff ff       	jmp    8010570a <alltraps>

80105eb4 <vector85>:
.globl vector85
vector85:
  pushl $0
80105eb4:	6a 00                	push   $0x0
  pushl $85
80105eb6:	6a 55                	push   $0x55
  jmp alltraps
80105eb8:	e9 4d f8 ff ff       	jmp    8010570a <alltraps>

80105ebd <vector86>:
.globl vector86
vector86:
  pushl $0
80105ebd:	6a 00                	push   $0x0
  pushl $86
80105ebf:	6a 56                	push   $0x56
  jmp alltraps
80105ec1:	e9 44 f8 ff ff       	jmp    8010570a <alltraps>

80105ec6 <vector87>:
.globl vector87
vector87:
  pushl $0
80105ec6:	6a 00                	push   $0x0
  pushl $87
80105ec8:	6a 57                	push   $0x57
  jmp alltraps
80105eca:	e9 3b f8 ff ff       	jmp    8010570a <alltraps>

80105ecf <vector88>:
.globl vector88
vector88:
  pushl $0
80105ecf:	6a 00                	push   $0x0
  pushl $88
80105ed1:	6a 58                	push   $0x58
  jmp alltraps
80105ed3:	e9 32 f8 ff ff       	jmp    8010570a <alltraps>

80105ed8 <vector89>:
.globl vector89
vector89:
  pushl $0
80105ed8:	6a 00                	push   $0x0
  pushl $89
80105eda:	6a 59                	push   $0x59
  jmp alltraps
80105edc:	e9 29 f8 ff ff       	jmp    8010570a <alltraps>

80105ee1 <vector90>:
.globl vector90
vector90:
  pushl $0
80105ee1:	6a 00                	push   $0x0
  pushl $90
80105ee3:	6a 5a                	push   $0x5a
  jmp alltraps
80105ee5:	e9 20 f8 ff ff       	jmp    8010570a <alltraps>

80105eea <vector91>:
.globl vector91
vector91:
  pushl $0
80105eea:	6a 00                	push   $0x0
  pushl $91
80105eec:	6a 5b                	push   $0x5b
  jmp alltraps
80105eee:	e9 17 f8 ff ff       	jmp    8010570a <alltraps>

80105ef3 <vector92>:
.globl vector92
vector92:
  pushl $0
80105ef3:	6a 00                	push   $0x0
  pushl $92
80105ef5:	6a 5c                	push   $0x5c
  jmp alltraps
80105ef7:	e9 0e f8 ff ff       	jmp    8010570a <alltraps>

80105efc <vector93>:
.globl vector93
vector93:
  pushl $0
80105efc:	6a 00                	push   $0x0
  pushl $93
80105efe:	6a 5d                	push   $0x5d
  jmp alltraps
80105f00:	e9 05 f8 ff ff       	jmp    8010570a <alltraps>

80105f05 <vector94>:
.globl vector94
vector94:
  pushl $0
80105f05:	6a 00                	push   $0x0
  pushl $94
80105f07:	6a 5e                	push   $0x5e
  jmp alltraps
80105f09:	e9 fc f7 ff ff       	jmp    8010570a <alltraps>

80105f0e <vector95>:
.globl vector95
vector95:
  pushl $0
80105f0e:	6a 00                	push   $0x0
  pushl $95
80105f10:	6a 5f                	push   $0x5f
  jmp alltraps
80105f12:	e9 f3 f7 ff ff       	jmp    8010570a <alltraps>

80105f17 <vector96>:
.globl vector96
vector96:
  pushl $0
80105f17:	6a 00                	push   $0x0
  pushl $96
80105f19:	6a 60                	push   $0x60
  jmp alltraps
80105f1b:	e9 ea f7 ff ff       	jmp    8010570a <alltraps>

80105f20 <vector97>:
.globl vector97
vector97:
  pushl $0
80105f20:	6a 00                	push   $0x0
  pushl $97
80105f22:	6a 61                	push   $0x61
  jmp alltraps
80105f24:	e9 e1 f7 ff ff       	jmp    8010570a <alltraps>

80105f29 <vector98>:
.globl vector98
vector98:
  pushl $0
80105f29:	6a 00                	push   $0x0
  pushl $98
80105f2b:	6a 62                	push   $0x62
  jmp alltraps
80105f2d:	e9 d8 f7 ff ff       	jmp    8010570a <alltraps>

80105f32 <vector99>:
.globl vector99
vector99:
  pushl $0
80105f32:	6a 00                	push   $0x0
  pushl $99
80105f34:	6a 63                	push   $0x63
  jmp alltraps
80105f36:	e9 cf f7 ff ff       	jmp    8010570a <alltraps>

80105f3b <vector100>:
.globl vector100
vector100:
  pushl $0
80105f3b:	6a 00                	push   $0x0
  pushl $100
80105f3d:	6a 64                	push   $0x64
  jmp alltraps
80105f3f:	e9 c6 f7 ff ff       	jmp    8010570a <alltraps>

80105f44 <vector101>:
.globl vector101
vector101:
  pushl $0
80105f44:	6a 00                	push   $0x0
  pushl $101
80105f46:	6a 65                	push   $0x65
  jmp alltraps
80105f48:	e9 bd f7 ff ff       	jmp    8010570a <alltraps>

80105f4d <vector102>:
.globl vector102
vector102:
  pushl $0
80105f4d:	6a 00                	push   $0x0
  pushl $102
80105f4f:	6a 66                	push   $0x66
  jmp alltraps
80105f51:	e9 b4 f7 ff ff       	jmp    8010570a <alltraps>

80105f56 <vector103>:
.globl vector103
vector103:
  pushl $0
80105f56:	6a 00                	push   $0x0
  pushl $103
80105f58:	6a 67                	push   $0x67
  jmp alltraps
80105f5a:	e9 ab f7 ff ff       	jmp    8010570a <alltraps>

80105f5f <vector104>:
.globl vector104
vector104:
  pushl $0
80105f5f:	6a 00                	push   $0x0
  pushl $104
80105f61:	6a 68                	push   $0x68
  jmp alltraps
80105f63:	e9 a2 f7 ff ff       	jmp    8010570a <alltraps>

80105f68 <vector105>:
.globl vector105
vector105:
  pushl $0
80105f68:	6a 00                	push   $0x0
  pushl $105
80105f6a:	6a 69                	push   $0x69
  jmp alltraps
80105f6c:	e9 99 f7 ff ff       	jmp    8010570a <alltraps>

80105f71 <vector106>:
.globl vector106
vector106:
  pushl $0
80105f71:	6a 00                	push   $0x0
  pushl $106
80105f73:	6a 6a                	push   $0x6a
  jmp alltraps
80105f75:	e9 90 f7 ff ff       	jmp    8010570a <alltraps>

80105f7a <vector107>:
.globl vector107
vector107:
  pushl $0
80105f7a:	6a 00                	push   $0x0
  pushl $107
80105f7c:	6a 6b                	push   $0x6b
  jmp alltraps
80105f7e:	e9 87 f7 ff ff       	jmp    8010570a <alltraps>

80105f83 <vector108>:
.globl vector108
vector108:
  pushl $0
80105f83:	6a 00                	push   $0x0
  pushl $108
80105f85:	6a 6c                	push   $0x6c
  jmp alltraps
80105f87:	e9 7e f7 ff ff       	jmp    8010570a <alltraps>

80105f8c <vector109>:
.globl vector109
vector109:
  pushl $0
80105f8c:	6a 00                	push   $0x0
  pushl $109
80105f8e:	6a 6d                	push   $0x6d
  jmp alltraps
80105f90:	e9 75 f7 ff ff       	jmp    8010570a <alltraps>

80105f95 <vector110>:
.globl vector110
vector110:
  pushl $0
80105f95:	6a 00                	push   $0x0
  pushl $110
80105f97:	6a 6e                	push   $0x6e
  jmp alltraps
80105f99:	e9 6c f7 ff ff       	jmp    8010570a <alltraps>

80105f9e <vector111>:
.globl vector111
vector111:
  pushl $0
80105f9e:	6a 00                	push   $0x0
  pushl $111
80105fa0:	6a 6f                	push   $0x6f
  jmp alltraps
80105fa2:	e9 63 f7 ff ff       	jmp    8010570a <alltraps>

80105fa7 <vector112>:
.globl vector112
vector112:
  pushl $0
80105fa7:	6a 00                	push   $0x0
  pushl $112
80105fa9:	6a 70                	push   $0x70
  jmp alltraps
80105fab:	e9 5a f7 ff ff       	jmp    8010570a <alltraps>

80105fb0 <vector113>:
.globl vector113
vector113:
  pushl $0
80105fb0:	6a 00                	push   $0x0
  pushl $113
80105fb2:	6a 71                	push   $0x71
  jmp alltraps
80105fb4:	e9 51 f7 ff ff       	jmp    8010570a <alltraps>

80105fb9 <vector114>:
.globl vector114
vector114:
  pushl $0
80105fb9:	6a 00                	push   $0x0
  pushl $114
80105fbb:	6a 72                	push   $0x72
  jmp alltraps
80105fbd:	e9 48 f7 ff ff       	jmp    8010570a <alltraps>

80105fc2 <vector115>:
.globl vector115
vector115:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $115
80105fc4:	6a 73                	push   $0x73
  jmp alltraps
80105fc6:	e9 3f f7 ff ff       	jmp    8010570a <alltraps>

80105fcb <vector116>:
.globl vector116
vector116:
  pushl $0
80105fcb:	6a 00                	push   $0x0
  pushl $116
80105fcd:	6a 74                	push   $0x74
  jmp alltraps
80105fcf:	e9 36 f7 ff ff       	jmp    8010570a <alltraps>

80105fd4 <vector117>:
.globl vector117
vector117:
  pushl $0
80105fd4:	6a 00                	push   $0x0
  pushl $117
80105fd6:	6a 75                	push   $0x75
  jmp alltraps
80105fd8:	e9 2d f7 ff ff       	jmp    8010570a <alltraps>

80105fdd <vector118>:
.globl vector118
vector118:
  pushl $0
80105fdd:	6a 00                	push   $0x0
  pushl $118
80105fdf:	6a 76                	push   $0x76
  jmp alltraps
80105fe1:	e9 24 f7 ff ff       	jmp    8010570a <alltraps>

80105fe6 <vector119>:
.globl vector119
vector119:
  pushl $0
80105fe6:	6a 00                	push   $0x0
  pushl $119
80105fe8:	6a 77                	push   $0x77
  jmp alltraps
80105fea:	e9 1b f7 ff ff       	jmp    8010570a <alltraps>

80105fef <vector120>:
.globl vector120
vector120:
  pushl $0
80105fef:	6a 00                	push   $0x0
  pushl $120
80105ff1:	6a 78                	push   $0x78
  jmp alltraps
80105ff3:	e9 12 f7 ff ff       	jmp    8010570a <alltraps>

80105ff8 <vector121>:
.globl vector121
vector121:
  pushl $0
80105ff8:	6a 00                	push   $0x0
  pushl $121
80105ffa:	6a 79                	push   $0x79
  jmp alltraps
80105ffc:	e9 09 f7 ff ff       	jmp    8010570a <alltraps>

80106001 <vector122>:
.globl vector122
vector122:
  pushl $0
80106001:	6a 00                	push   $0x0
  pushl $122
80106003:	6a 7a                	push   $0x7a
  jmp alltraps
80106005:	e9 00 f7 ff ff       	jmp    8010570a <alltraps>

8010600a <vector123>:
.globl vector123
vector123:
  pushl $0
8010600a:	6a 00                	push   $0x0
  pushl $123
8010600c:	6a 7b                	push   $0x7b
  jmp alltraps
8010600e:	e9 f7 f6 ff ff       	jmp    8010570a <alltraps>

80106013 <vector124>:
.globl vector124
vector124:
  pushl $0
80106013:	6a 00                	push   $0x0
  pushl $124
80106015:	6a 7c                	push   $0x7c
  jmp alltraps
80106017:	e9 ee f6 ff ff       	jmp    8010570a <alltraps>

8010601c <vector125>:
.globl vector125
vector125:
  pushl $0
8010601c:	6a 00                	push   $0x0
  pushl $125
8010601e:	6a 7d                	push   $0x7d
  jmp alltraps
80106020:	e9 e5 f6 ff ff       	jmp    8010570a <alltraps>

80106025 <vector126>:
.globl vector126
vector126:
  pushl $0
80106025:	6a 00                	push   $0x0
  pushl $126
80106027:	6a 7e                	push   $0x7e
  jmp alltraps
80106029:	e9 dc f6 ff ff       	jmp    8010570a <alltraps>

8010602e <vector127>:
.globl vector127
vector127:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $127
80106030:	6a 7f                	push   $0x7f
  jmp alltraps
80106032:	e9 d3 f6 ff ff       	jmp    8010570a <alltraps>

80106037 <vector128>:
.globl vector128
vector128:
  pushl $0
80106037:	6a 00                	push   $0x0
  pushl $128
80106039:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010603e:	e9 c7 f6 ff ff       	jmp    8010570a <alltraps>

80106043 <vector129>:
.globl vector129
vector129:
  pushl $0
80106043:	6a 00                	push   $0x0
  pushl $129
80106045:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010604a:	e9 bb f6 ff ff       	jmp    8010570a <alltraps>

8010604f <vector130>:
.globl vector130
vector130:
  pushl $0
8010604f:	6a 00                	push   $0x0
  pushl $130
80106051:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106056:	e9 af f6 ff ff       	jmp    8010570a <alltraps>

8010605b <vector131>:
.globl vector131
vector131:
  pushl $0
8010605b:	6a 00                	push   $0x0
  pushl $131
8010605d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106062:	e9 a3 f6 ff ff       	jmp    8010570a <alltraps>

80106067 <vector132>:
.globl vector132
vector132:
  pushl $0
80106067:	6a 00                	push   $0x0
  pushl $132
80106069:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010606e:	e9 97 f6 ff ff       	jmp    8010570a <alltraps>

80106073 <vector133>:
.globl vector133
vector133:
  pushl $0
80106073:	6a 00                	push   $0x0
  pushl $133
80106075:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010607a:	e9 8b f6 ff ff       	jmp    8010570a <alltraps>

8010607f <vector134>:
.globl vector134
vector134:
  pushl $0
8010607f:	6a 00                	push   $0x0
  pushl $134
80106081:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106086:	e9 7f f6 ff ff       	jmp    8010570a <alltraps>

8010608b <vector135>:
.globl vector135
vector135:
  pushl $0
8010608b:	6a 00                	push   $0x0
  pushl $135
8010608d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106092:	e9 73 f6 ff ff       	jmp    8010570a <alltraps>

80106097 <vector136>:
.globl vector136
vector136:
  pushl $0
80106097:	6a 00                	push   $0x0
  pushl $136
80106099:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010609e:	e9 67 f6 ff ff       	jmp    8010570a <alltraps>

801060a3 <vector137>:
.globl vector137
vector137:
  pushl $0
801060a3:	6a 00                	push   $0x0
  pushl $137
801060a5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801060aa:	e9 5b f6 ff ff       	jmp    8010570a <alltraps>

801060af <vector138>:
.globl vector138
vector138:
  pushl $0
801060af:	6a 00                	push   $0x0
  pushl $138
801060b1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801060b6:	e9 4f f6 ff ff       	jmp    8010570a <alltraps>

801060bb <vector139>:
.globl vector139
vector139:
  pushl $0
801060bb:	6a 00                	push   $0x0
  pushl $139
801060bd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801060c2:	e9 43 f6 ff ff       	jmp    8010570a <alltraps>

801060c7 <vector140>:
.globl vector140
vector140:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $140
801060c9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801060ce:	e9 37 f6 ff ff       	jmp    8010570a <alltraps>

801060d3 <vector141>:
.globl vector141
vector141:
  pushl $0
801060d3:	6a 00                	push   $0x0
  pushl $141
801060d5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801060da:	e9 2b f6 ff ff       	jmp    8010570a <alltraps>

801060df <vector142>:
.globl vector142
vector142:
  pushl $0
801060df:	6a 00                	push   $0x0
  pushl $142
801060e1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801060e6:	e9 1f f6 ff ff       	jmp    8010570a <alltraps>

801060eb <vector143>:
.globl vector143
vector143:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $143
801060ed:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801060f2:	e9 13 f6 ff ff       	jmp    8010570a <alltraps>

801060f7 <vector144>:
.globl vector144
vector144:
  pushl $0
801060f7:	6a 00                	push   $0x0
  pushl $144
801060f9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801060fe:	e9 07 f6 ff ff       	jmp    8010570a <alltraps>

80106103 <vector145>:
.globl vector145
vector145:
  pushl $0
80106103:	6a 00                	push   $0x0
  pushl $145
80106105:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010610a:	e9 fb f5 ff ff       	jmp    8010570a <alltraps>

8010610f <vector146>:
.globl vector146
vector146:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $146
80106111:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106116:	e9 ef f5 ff ff       	jmp    8010570a <alltraps>

8010611b <vector147>:
.globl vector147
vector147:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $147
8010611d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106122:	e9 e3 f5 ff ff       	jmp    8010570a <alltraps>

80106127 <vector148>:
.globl vector148
vector148:
  pushl $0
80106127:	6a 00                	push   $0x0
  pushl $148
80106129:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010612e:	e9 d7 f5 ff ff       	jmp    8010570a <alltraps>

80106133 <vector149>:
.globl vector149
vector149:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $149
80106135:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010613a:	e9 cb f5 ff ff       	jmp    8010570a <alltraps>

8010613f <vector150>:
.globl vector150
vector150:
  pushl $0
8010613f:	6a 00                	push   $0x0
  pushl $150
80106141:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106146:	e9 bf f5 ff ff       	jmp    8010570a <alltraps>

8010614b <vector151>:
.globl vector151
vector151:
  pushl $0
8010614b:	6a 00                	push   $0x0
  pushl $151
8010614d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106152:	e9 b3 f5 ff ff       	jmp    8010570a <alltraps>

80106157 <vector152>:
.globl vector152
vector152:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $152
80106159:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010615e:	e9 a7 f5 ff ff       	jmp    8010570a <alltraps>

80106163 <vector153>:
.globl vector153
vector153:
  pushl $0
80106163:	6a 00                	push   $0x0
  pushl $153
80106165:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010616a:	e9 9b f5 ff ff       	jmp    8010570a <alltraps>

8010616f <vector154>:
.globl vector154
vector154:
  pushl $0
8010616f:	6a 00                	push   $0x0
  pushl $154
80106171:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106176:	e9 8f f5 ff ff       	jmp    8010570a <alltraps>

8010617b <vector155>:
.globl vector155
vector155:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $155
8010617d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106182:	e9 83 f5 ff ff       	jmp    8010570a <alltraps>

80106187 <vector156>:
.globl vector156
vector156:
  pushl $0
80106187:	6a 00                	push   $0x0
  pushl $156
80106189:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010618e:	e9 77 f5 ff ff       	jmp    8010570a <alltraps>

80106193 <vector157>:
.globl vector157
vector157:
  pushl $0
80106193:	6a 00                	push   $0x0
  pushl $157
80106195:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010619a:	e9 6b f5 ff ff       	jmp    8010570a <alltraps>

8010619f <vector158>:
.globl vector158
vector158:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $158
801061a1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801061a6:	e9 5f f5 ff ff       	jmp    8010570a <alltraps>

801061ab <vector159>:
.globl vector159
vector159:
  pushl $0
801061ab:	6a 00                	push   $0x0
  pushl $159
801061ad:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801061b2:	e9 53 f5 ff ff       	jmp    8010570a <alltraps>

801061b7 <vector160>:
.globl vector160
vector160:
  pushl $0
801061b7:	6a 00                	push   $0x0
  pushl $160
801061b9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801061be:	e9 47 f5 ff ff       	jmp    8010570a <alltraps>

801061c3 <vector161>:
.globl vector161
vector161:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $161
801061c5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801061ca:	e9 3b f5 ff ff       	jmp    8010570a <alltraps>

801061cf <vector162>:
.globl vector162
vector162:
  pushl $0
801061cf:	6a 00                	push   $0x0
  pushl $162
801061d1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801061d6:	e9 2f f5 ff ff       	jmp    8010570a <alltraps>

801061db <vector163>:
.globl vector163
vector163:
  pushl $0
801061db:	6a 00                	push   $0x0
  pushl $163
801061dd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801061e2:	e9 23 f5 ff ff       	jmp    8010570a <alltraps>

801061e7 <vector164>:
.globl vector164
vector164:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $164
801061e9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801061ee:	e9 17 f5 ff ff       	jmp    8010570a <alltraps>

801061f3 <vector165>:
.globl vector165
vector165:
  pushl $0
801061f3:	6a 00                	push   $0x0
  pushl $165
801061f5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801061fa:	e9 0b f5 ff ff       	jmp    8010570a <alltraps>

801061ff <vector166>:
.globl vector166
vector166:
  pushl $0
801061ff:	6a 00                	push   $0x0
  pushl $166
80106201:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106206:	e9 ff f4 ff ff       	jmp    8010570a <alltraps>

8010620b <vector167>:
.globl vector167
vector167:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $167
8010620d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106212:	e9 f3 f4 ff ff       	jmp    8010570a <alltraps>

80106217 <vector168>:
.globl vector168
vector168:
  pushl $0
80106217:	6a 00                	push   $0x0
  pushl $168
80106219:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010621e:	e9 e7 f4 ff ff       	jmp    8010570a <alltraps>

80106223 <vector169>:
.globl vector169
vector169:
  pushl $0
80106223:	6a 00                	push   $0x0
  pushl $169
80106225:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010622a:	e9 db f4 ff ff       	jmp    8010570a <alltraps>

8010622f <vector170>:
.globl vector170
vector170:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $170
80106231:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106236:	e9 cf f4 ff ff       	jmp    8010570a <alltraps>

8010623b <vector171>:
.globl vector171
vector171:
  pushl $0
8010623b:	6a 00                	push   $0x0
  pushl $171
8010623d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106242:	e9 c3 f4 ff ff       	jmp    8010570a <alltraps>

80106247 <vector172>:
.globl vector172
vector172:
  pushl $0
80106247:	6a 00                	push   $0x0
  pushl $172
80106249:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010624e:	e9 b7 f4 ff ff       	jmp    8010570a <alltraps>

80106253 <vector173>:
.globl vector173
vector173:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $173
80106255:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010625a:	e9 ab f4 ff ff       	jmp    8010570a <alltraps>

8010625f <vector174>:
.globl vector174
vector174:
  pushl $0
8010625f:	6a 00                	push   $0x0
  pushl $174
80106261:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106266:	e9 9f f4 ff ff       	jmp    8010570a <alltraps>

8010626b <vector175>:
.globl vector175
vector175:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $175
8010626d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106272:	e9 93 f4 ff ff       	jmp    8010570a <alltraps>

80106277 <vector176>:
.globl vector176
vector176:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $176
80106279:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010627e:	e9 87 f4 ff ff       	jmp    8010570a <alltraps>

80106283 <vector177>:
.globl vector177
vector177:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $177
80106285:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010628a:	e9 7b f4 ff ff       	jmp    8010570a <alltraps>

8010628f <vector178>:
.globl vector178
vector178:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $178
80106291:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106296:	e9 6f f4 ff ff       	jmp    8010570a <alltraps>

8010629b <vector179>:
.globl vector179
vector179:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $179
8010629d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801062a2:	e9 63 f4 ff ff       	jmp    8010570a <alltraps>

801062a7 <vector180>:
.globl vector180
vector180:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $180
801062a9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801062ae:	e9 57 f4 ff ff       	jmp    8010570a <alltraps>

801062b3 <vector181>:
.globl vector181
vector181:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $181
801062b5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801062ba:	e9 4b f4 ff ff       	jmp    8010570a <alltraps>

801062bf <vector182>:
.globl vector182
vector182:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $182
801062c1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801062c6:	e9 3f f4 ff ff       	jmp    8010570a <alltraps>

801062cb <vector183>:
.globl vector183
vector183:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $183
801062cd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801062d2:	e9 33 f4 ff ff       	jmp    8010570a <alltraps>

801062d7 <vector184>:
.globl vector184
vector184:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $184
801062d9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801062de:	e9 27 f4 ff ff       	jmp    8010570a <alltraps>

801062e3 <vector185>:
.globl vector185
vector185:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $185
801062e5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801062ea:	e9 1b f4 ff ff       	jmp    8010570a <alltraps>

801062ef <vector186>:
.globl vector186
vector186:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $186
801062f1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801062f6:	e9 0f f4 ff ff       	jmp    8010570a <alltraps>

801062fb <vector187>:
.globl vector187
vector187:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $187
801062fd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106302:	e9 03 f4 ff ff       	jmp    8010570a <alltraps>

80106307 <vector188>:
.globl vector188
vector188:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $188
80106309:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010630e:	e9 f7 f3 ff ff       	jmp    8010570a <alltraps>

80106313 <vector189>:
.globl vector189
vector189:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $189
80106315:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010631a:	e9 eb f3 ff ff       	jmp    8010570a <alltraps>

8010631f <vector190>:
.globl vector190
vector190:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $190
80106321:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106326:	e9 df f3 ff ff       	jmp    8010570a <alltraps>

8010632b <vector191>:
.globl vector191
vector191:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $191
8010632d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106332:	e9 d3 f3 ff ff       	jmp    8010570a <alltraps>

80106337 <vector192>:
.globl vector192
vector192:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $192
80106339:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010633e:	e9 c7 f3 ff ff       	jmp    8010570a <alltraps>

80106343 <vector193>:
.globl vector193
vector193:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $193
80106345:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010634a:	e9 bb f3 ff ff       	jmp    8010570a <alltraps>

8010634f <vector194>:
.globl vector194
vector194:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $194
80106351:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106356:	e9 af f3 ff ff       	jmp    8010570a <alltraps>

8010635b <vector195>:
.globl vector195
vector195:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $195
8010635d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106362:	e9 a3 f3 ff ff       	jmp    8010570a <alltraps>

80106367 <vector196>:
.globl vector196
vector196:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $196
80106369:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010636e:	e9 97 f3 ff ff       	jmp    8010570a <alltraps>

80106373 <vector197>:
.globl vector197
vector197:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $197
80106375:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010637a:	e9 8b f3 ff ff       	jmp    8010570a <alltraps>

8010637f <vector198>:
.globl vector198
vector198:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $198
80106381:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106386:	e9 7f f3 ff ff       	jmp    8010570a <alltraps>

8010638b <vector199>:
.globl vector199
vector199:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $199
8010638d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106392:	e9 73 f3 ff ff       	jmp    8010570a <alltraps>

80106397 <vector200>:
.globl vector200
vector200:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $200
80106399:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010639e:	e9 67 f3 ff ff       	jmp    8010570a <alltraps>

801063a3 <vector201>:
.globl vector201
vector201:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $201
801063a5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801063aa:	e9 5b f3 ff ff       	jmp    8010570a <alltraps>

801063af <vector202>:
.globl vector202
vector202:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $202
801063b1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801063b6:	e9 4f f3 ff ff       	jmp    8010570a <alltraps>

801063bb <vector203>:
.globl vector203
vector203:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $203
801063bd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801063c2:	e9 43 f3 ff ff       	jmp    8010570a <alltraps>

801063c7 <vector204>:
.globl vector204
vector204:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $204
801063c9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801063ce:	e9 37 f3 ff ff       	jmp    8010570a <alltraps>

801063d3 <vector205>:
.globl vector205
vector205:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $205
801063d5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801063da:	e9 2b f3 ff ff       	jmp    8010570a <alltraps>

801063df <vector206>:
.globl vector206
vector206:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $206
801063e1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801063e6:	e9 1f f3 ff ff       	jmp    8010570a <alltraps>

801063eb <vector207>:
.globl vector207
vector207:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $207
801063ed:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801063f2:	e9 13 f3 ff ff       	jmp    8010570a <alltraps>

801063f7 <vector208>:
.globl vector208
vector208:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $208
801063f9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801063fe:	e9 07 f3 ff ff       	jmp    8010570a <alltraps>

80106403 <vector209>:
.globl vector209
vector209:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $209
80106405:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010640a:	e9 fb f2 ff ff       	jmp    8010570a <alltraps>

8010640f <vector210>:
.globl vector210
vector210:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $210
80106411:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106416:	e9 ef f2 ff ff       	jmp    8010570a <alltraps>

8010641b <vector211>:
.globl vector211
vector211:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $211
8010641d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106422:	e9 e3 f2 ff ff       	jmp    8010570a <alltraps>

80106427 <vector212>:
.globl vector212
vector212:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $212
80106429:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010642e:	e9 d7 f2 ff ff       	jmp    8010570a <alltraps>

80106433 <vector213>:
.globl vector213
vector213:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $213
80106435:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010643a:	e9 cb f2 ff ff       	jmp    8010570a <alltraps>

8010643f <vector214>:
.globl vector214
vector214:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $214
80106441:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106446:	e9 bf f2 ff ff       	jmp    8010570a <alltraps>

8010644b <vector215>:
.globl vector215
vector215:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $215
8010644d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106452:	e9 b3 f2 ff ff       	jmp    8010570a <alltraps>

80106457 <vector216>:
.globl vector216
vector216:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $216
80106459:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010645e:	e9 a7 f2 ff ff       	jmp    8010570a <alltraps>

80106463 <vector217>:
.globl vector217
vector217:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $217
80106465:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010646a:	e9 9b f2 ff ff       	jmp    8010570a <alltraps>

8010646f <vector218>:
.globl vector218
vector218:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $218
80106471:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106476:	e9 8f f2 ff ff       	jmp    8010570a <alltraps>

8010647b <vector219>:
.globl vector219
vector219:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $219
8010647d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106482:	e9 83 f2 ff ff       	jmp    8010570a <alltraps>

80106487 <vector220>:
.globl vector220
vector220:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $220
80106489:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010648e:	e9 77 f2 ff ff       	jmp    8010570a <alltraps>

80106493 <vector221>:
.globl vector221
vector221:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $221
80106495:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010649a:	e9 6b f2 ff ff       	jmp    8010570a <alltraps>

8010649f <vector222>:
.globl vector222
vector222:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $222
801064a1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801064a6:	e9 5f f2 ff ff       	jmp    8010570a <alltraps>

801064ab <vector223>:
.globl vector223
vector223:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $223
801064ad:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801064b2:	e9 53 f2 ff ff       	jmp    8010570a <alltraps>

801064b7 <vector224>:
.globl vector224
vector224:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $224
801064b9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801064be:	e9 47 f2 ff ff       	jmp    8010570a <alltraps>

801064c3 <vector225>:
.globl vector225
vector225:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $225
801064c5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801064ca:	e9 3b f2 ff ff       	jmp    8010570a <alltraps>

801064cf <vector226>:
.globl vector226
vector226:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $226
801064d1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801064d6:	e9 2f f2 ff ff       	jmp    8010570a <alltraps>

801064db <vector227>:
.globl vector227
vector227:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $227
801064dd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801064e2:	e9 23 f2 ff ff       	jmp    8010570a <alltraps>

801064e7 <vector228>:
.globl vector228
vector228:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $228
801064e9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801064ee:	e9 17 f2 ff ff       	jmp    8010570a <alltraps>

801064f3 <vector229>:
.globl vector229
vector229:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $229
801064f5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801064fa:	e9 0b f2 ff ff       	jmp    8010570a <alltraps>

801064ff <vector230>:
.globl vector230
vector230:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $230
80106501:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106506:	e9 ff f1 ff ff       	jmp    8010570a <alltraps>

8010650b <vector231>:
.globl vector231
vector231:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $231
8010650d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106512:	e9 f3 f1 ff ff       	jmp    8010570a <alltraps>

80106517 <vector232>:
.globl vector232
vector232:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $232
80106519:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010651e:	e9 e7 f1 ff ff       	jmp    8010570a <alltraps>

80106523 <vector233>:
.globl vector233
vector233:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $233
80106525:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010652a:	e9 db f1 ff ff       	jmp    8010570a <alltraps>

8010652f <vector234>:
.globl vector234
vector234:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $234
80106531:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106536:	e9 cf f1 ff ff       	jmp    8010570a <alltraps>

8010653b <vector235>:
.globl vector235
vector235:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $235
8010653d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106542:	e9 c3 f1 ff ff       	jmp    8010570a <alltraps>

80106547 <vector236>:
.globl vector236
vector236:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $236
80106549:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010654e:	e9 b7 f1 ff ff       	jmp    8010570a <alltraps>

80106553 <vector237>:
.globl vector237
vector237:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $237
80106555:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010655a:	e9 ab f1 ff ff       	jmp    8010570a <alltraps>

8010655f <vector238>:
.globl vector238
vector238:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $238
80106561:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106566:	e9 9f f1 ff ff       	jmp    8010570a <alltraps>

8010656b <vector239>:
.globl vector239
vector239:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $239
8010656d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106572:	e9 93 f1 ff ff       	jmp    8010570a <alltraps>

80106577 <vector240>:
.globl vector240
vector240:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $240
80106579:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010657e:	e9 87 f1 ff ff       	jmp    8010570a <alltraps>

80106583 <vector241>:
.globl vector241
vector241:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $241
80106585:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010658a:	e9 7b f1 ff ff       	jmp    8010570a <alltraps>

8010658f <vector242>:
.globl vector242
vector242:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $242
80106591:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106596:	e9 6f f1 ff ff       	jmp    8010570a <alltraps>

8010659b <vector243>:
.globl vector243
vector243:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $243
8010659d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801065a2:	e9 63 f1 ff ff       	jmp    8010570a <alltraps>

801065a7 <vector244>:
.globl vector244
vector244:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $244
801065a9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801065ae:	e9 57 f1 ff ff       	jmp    8010570a <alltraps>

801065b3 <vector245>:
.globl vector245
vector245:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $245
801065b5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801065ba:	e9 4b f1 ff ff       	jmp    8010570a <alltraps>

801065bf <vector246>:
.globl vector246
vector246:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $246
801065c1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801065c6:	e9 3f f1 ff ff       	jmp    8010570a <alltraps>

801065cb <vector247>:
.globl vector247
vector247:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $247
801065cd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801065d2:	e9 33 f1 ff ff       	jmp    8010570a <alltraps>

801065d7 <vector248>:
.globl vector248
vector248:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $248
801065d9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801065de:	e9 27 f1 ff ff       	jmp    8010570a <alltraps>

801065e3 <vector249>:
.globl vector249
vector249:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $249
801065e5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801065ea:	e9 1b f1 ff ff       	jmp    8010570a <alltraps>

801065ef <vector250>:
.globl vector250
vector250:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $250
801065f1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801065f6:	e9 0f f1 ff ff       	jmp    8010570a <alltraps>

801065fb <vector251>:
.globl vector251
vector251:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $251
801065fd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106602:	e9 03 f1 ff ff       	jmp    8010570a <alltraps>

80106607 <vector252>:
.globl vector252
vector252:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $252
80106609:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010660e:	e9 f7 f0 ff ff       	jmp    8010570a <alltraps>

80106613 <vector253>:
.globl vector253
vector253:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $253
80106615:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010661a:	e9 eb f0 ff ff       	jmp    8010570a <alltraps>

8010661f <vector254>:
.globl vector254
vector254:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $254
80106621:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106626:	e9 df f0 ff ff       	jmp    8010570a <alltraps>

8010662b <vector255>:
.globl vector255
vector255:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $255
8010662d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106632:	e9 d3 f0 ff ff       	jmp    8010570a <alltraps>
80106637:	66 90                	xchg   %ax,%ax
80106639:	66 90                	xchg   %ax,%ax
8010663b:	66 90                	xchg   %ax,%ax
8010663d:	66 90                	xchg   %ax,%ax
8010663f:	90                   	nop

80106640 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106640:	55                   	push   %ebp
80106641:	89 e5                	mov    %esp,%ebp
80106643:	57                   	push   %edi
80106644:	56                   	push   %esi
80106645:	53                   	push   %ebx
80106646:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106648:	c1 ea 16             	shr    $0x16,%edx
8010664b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010664e:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106651:	8b 07                	mov    (%edi),%eax
80106653:	a8 01                	test   $0x1,%al
80106655:	74 29                	je     80106680 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106657:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010665c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106662:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106665:	c1 eb 0a             	shr    $0xa,%ebx
80106668:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
8010666e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106671:	5b                   	pop    %ebx
80106672:	5e                   	pop    %esi
80106673:	5f                   	pop    %edi
80106674:	5d                   	pop    %ebp
80106675:	c3                   	ret    
80106676:	8d 76 00             	lea    0x0(%esi),%esi
80106679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106680:	85 c9                	test   %ecx,%ecx
80106682:	74 2c                	je     801066b0 <walkpgdir+0x70>
80106684:	e8 d7 be ff ff       	call   80102560 <kalloc>
80106689:	85 c0                	test   %eax,%eax
8010668b:	89 c6                	mov    %eax,%esi
8010668d:	74 21                	je     801066b0 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010668f:	83 ec 04             	sub    $0x4,%esp
80106692:	68 00 10 00 00       	push   $0x1000
80106697:	6a 00                	push   $0x0
80106699:	50                   	push   %eax
8010669a:	e8 41 de ff ff       	call   801044e0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010669f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801066a5:	83 c4 10             	add    $0x10,%esp
801066a8:	83 c8 07             	or     $0x7,%eax
801066ab:	89 07                	mov    %eax,(%edi)
801066ad:	eb b3                	jmp    80106662 <walkpgdir+0x22>
801066af:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
801066b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
801066b3:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801066b5:	5b                   	pop    %ebx
801066b6:	5e                   	pop    %esi
801066b7:	5f                   	pop    %edi
801066b8:	5d                   	pop    %ebp
801066b9:	c3                   	ret    
801066ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801066c0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801066c0:	55                   	push   %ebp
801066c1:	89 e5                	mov    %esp,%ebp
801066c3:	57                   	push   %edi
801066c4:	56                   	push   %esi
801066c5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801066c6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801066cc:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801066ce:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801066d4:	83 ec 1c             	sub    $0x1c,%esp
801066d7:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801066da:	39 d3                	cmp    %edx,%ebx
801066dc:	73 66                	jae    80106744 <deallocuvm.part.0+0x84>
801066de:	89 d6                	mov    %edx,%esi
801066e0:	eb 3d                	jmp    8010671f <deallocuvm.part.0+0x5f>
801066e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801066e8:	8b 10                	mov    (%eax),%edx
801066ea:	f6 c2 01             	test   $0x1,%dl
801066ed:	74 26                	je     80106715 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801066ef:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801066f5:	74 58                	je     8010674f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801066f7:	83 ec 0c             	sub    $0xc,%esp
801066fa:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106700:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106703:	52                   	push   %edx
80106704:	e8 a7 bc ff ff       	call   801023b0 <kfree>
      *pte = 0;
80106709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010670c:	83 c4 10             	add    $0x10,%esp
8010670f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106715:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010671b:	39 f3                	cmp    %esi,%ebx
8010671d:	73 25                	jae    80106744 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010671f:	31 c9                	xor    %ecx,%ecx
80106721:	89 da                	mov    %ebx,%edx
80106723:	89 f8                	mov    %edi,%eax
80106725:	e8 16 ff ff ff       	call   80106640 <walkpgdir>
    if(!pte)
8010672a:	85 c0                	test   %eax,%eax
8010672c:	75 ba                	jne    801066e8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010672e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106734:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010673a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106740:	39 f3                	cmp    %esi,%ebx
80106742:	72 db                	jb     8010671f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106744:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106747:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010674a:	5b                   	pop    %ebx
8010674b:	5e                   	pop    %esi
8010674c:	5f                   	pop    %edi
8010674d:	5d                   	pop    %ebp
8010674e:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010674f:	83 ec 0c             	sub    $0xc,%esp
80106752:	68 72 74 10 80       	push   $0x80107472
80106757:	e8 14 9c ff ff       	call   80100370 <panic>
8010675c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106760 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106760:	55                   	push   %ebp
80106761:	89 e5                	mov    %esp,%ebp
80106763:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106766:	e8 c5 d0 ff ff       	call   80103830 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010676b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106771:	31 c9                	xor    %ecx,%ecx
80106773:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106778:	66 89 90 f8 27 11 80 	mov    %dx,-0x7feed808(%eax)
8010677f:	66 89 88 fa 27 11 80 	mov    %cx,-0x7feed806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106786:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010678b:	31 c9                	xor    %ecx,%ecx
8010678d:	66 89 90 00 28 11 80 	mov    %dx,-0x7feed800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106794:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106799:	66 89 88 02 28 11 80 	mov    %cx,-0x7feed7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801067a0:	31 c9                	xor    %ecx,%ecx
801067a2:	66 89 90 08 28 11 80 	mov    %dx,-0x7feed7f8(%eax)
801067a9:	66 89 88 0a 28 11 80 	mov    %cx,-0x7feed7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801067b0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801067b5:	31 c9                	xor    %ecx,%ecx
801067b7:	66 89 90 10 28 11 80 	mov    %dx,-0x7feed7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801067be:	c6 80 fc 27 11 80 00 	movb   $0x0,-0x7feed804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801067c5:	ba 2f 00 00 00       	mov    $0x2f,%edx
801067ca:	c6 80 fd 27 11 80 9a 	movb   $0x9a,-0x7feed803(%eax)
801067d1:	c6 80 fe 27 11 80 cf 	movb   $0xcf,-0x7feed802(%eax)
801067d8:	c6 80 ff 27 11 80 00 	movb   $0x0,-0x7feed801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801067df:	c6 80 04 28 11 80 00 	movb   $0x0,-0x7feed7fc(%eax)
801067e6:	c6 80 05 28 11 80 92 	movb   $0x92,-0x7feed7fb(%eax)
801067ed:	c6 80 06 28 11 80 cf 	movb   $0xcf,-0x7feed7fa(%eax)
801067f4:	c6 80 07 28 11 80 00 	movb   $0x0,-0x7feed7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801067fb:	c6 80 0c 28 11 80 00 	movb   $0x0,-0x7feed7f4(%eax)
80106802:	c6 80 0d 28 11 80 fa 	movb   $0xfa,-0x7feed7f3(%eax)
80106809:	c6 80 0e 28 11 80 cf 	movb   $0xcf,-0x7feed7f2(%eax)
80106810:	c6 80 0f 28 11 80 00 	movb   $0x0,-0x7feed7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106817:	66 89 88 12 28 11 80 	mov    %cx,-0x7feed7ee(%eax)
8010681e:	c6 80 14 28 11 80 00 	movb   $0x0,-0x7feed7ec(%eax)
80106825:	c6 80 15 28 11 80 f2 	movb   $0xf2,-0x7feed7eb(%eax)
8010682c:	c6 80 16 28 11 80 cf 	movb   $0xcf,-0x7feed7ea(%eax)
80106833:	c6 80 17 28 11 80 00 	movb   $0x0,-0x7feed7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010683a:	05 f0 27 11 80       	add    $0x801127f0,%eax
8010683f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106843:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106847:	c1 e8 10             	shr    $0x10,%eax
8010684a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010684e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106851:	0f 01 10             	lgdtl  (%eax)
}
80106854:	c9                   	leave  
80106855:	c3                   	ret    
80106856:	8d 76 00             	lea    0x0(%esi),%esi
80106859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106860 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106860:	55                   	push   %ebp
80106861:	89 e5                	mov    %esp,%ebp
80106863:	57                   	push   %edi
80106864:	56                   	push   %esi
80106865:	53                   	push   %ebx
80106866:	83 ec 1c             	sub    $0x1c,%esp
80106869:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010686c:	8b 55 10             	mov    0x10(%ebp),%edx
8010686f:	8b 7d 14             	mov    0x14(%ebp),%edi
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106872:	89 c3                	mov    %eax,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106874:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106878:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010687e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106883:	29 df                	sub    %ebx,%edi
80106885:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106888:	8b 45 18             	mov    0x18(%ebp),%eax
8010688b:	83 c8 01             	or     $0x1,%eax
8010688e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106891:	eb 1a                	jmp    801068ad <mappages+0x4d>
80106893:	90                   	nop
80106894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106898:	f6 00 01             	testb  $0x1,(%eax)
8010689b:	75 3d                	jne    801068da <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
8010689d:	0b 75 e0             	or     -0x20(%ebp),%esi
    if(a == last)
801068a0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801068a3:	89 30                	mov    %esi,(%eax)
    if(a == last)
801068a5:	74 29                	je     801068d0 <mappages+0x70>
      break;
    a += PGSIZE;
801068a7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801068ad:	8b 45 08             	mov    0x8(%ebp),%eax
801068b0:	b9 01 00 00 00       	mov    $0x1,%ecx
801068b5:	89 da                	mov    %ebx,%edx
801068b7:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801068ba:	e8 81 fd ff ff       	call   80106640 <walkpgdir>
801068bf:	85 c0                	test   %eax,%eax
801068c1:	75 d5                	jne    80106898 <mappages+0x38>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801068c3:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
801068c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801068cb:	5b                   	pop    %ebx
801068cc:	5e                   	pop    %esi
801068cd:	5f                   	pop    %edi
801068ce:	5d                   	pop    %ebp
801068cf:	c3                   	ret    
801068d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801068d3:	31 c0                	xor    %eax,%eax
}
801068d5:	5b                   	pop    %ebx
801068d6:	5e                   	pop    %esi
801068d7:	5f                   	pop    %edi
801068d8:	5d                   	pop    %ebp
801068d9:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
801068da:	83 ec 0c             	sub    $0xc,%esp
801068dd:	68 d0 7a 10 80       	push   $0x80107ad0
801068e2:	e8 89 9a ff ff       	call   80100370 <panic>
801068e7:	89 f6                	mov    %esi,%esi
801068e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068f0 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801068f0:	a1 a4 55 11 80       	mov    0x801155a4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801068f5:	55                   	push   %ebp
801068f6:	89 e5                	mov    %esp,%ebp
801068f8:	05 00 00 00 80       	add    $0x80000000,%eax
801068fd:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
80106900:	5d                   	pop    %ebp
80106901:	c3                   	ret    
80106902:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106910 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	57                   	push   %edi
80106914:	56                   	push   %esi
80106915:	53                   	push   %ebx
80106916:	83 ec 1c             	sub    $0x1c,%esp
80106919:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010691c:	85 f6                	test   %esi,%esi
8010691e:	0f 84 cd 00 00 00    	je     801069f1 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106924:	8b 46 08             	mov    0x8(%esi),%eax
80106927:	85 c0                	test   %eax,%eax
80106929:	0f 84 dc 00 00 00    	je     80106a0b <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010692f:	8b 7e 04             	mov    0x4(%esi),%edi
80106932:	85 ff                	test   %edi,%edi
80106934:	0f 84 c4 00 00 00    	je     801069fe <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
8010693a:	e8 f1 d9 ff ff       	call   80104330 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010693f:	e8 6c ce ff ff       	call   801037b0 <mycpu>
80106944:	89 c3                	mov    %eax,%ebx
80106946:	e8 65 ce ff ff       	call   801037b0 <mycpu>
8010694b:	89 c7                	mov    %eax,%edi
8010694d:	e8 5e ce ff ff       	call   801037b0 <mycpu>
80106952:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106955:	83 c7 08             	add    $0x8,%edi
80106958:	e8 53 ce ff ff       	call   801037b0 <mycpu>
8010695d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106960:	83 c0 08             	add    $0x8,%eax
80106963:	ba 67 00 00 00       	mov    $0x67,%edx
80106968:	c1 e8 18             	shr    $0x18,%eax
8010696b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106972:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106979:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106980:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106987:	83 c1 08             	add    $0x8,%ecx
8010698a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106990:	c1 e9 10             	shr    $0x10,%ecx
80106993:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106999:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010699e:	e8 0d ce ff ff       	call   801037b0 <mycpu>
801069a3:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801069aa:	e8 01 ce ff ff       	call   801037b0 <mycpu>
801069af:	b9 10 00 00 00       	mov    $0x10,%ecx
801069b4:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801069b8:	e8 f3 cd ff ff       	call   801037b0 <mycpu>
801069bd:	8b 56 08             	mov    0x8(%esi),%edx
801069c0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
801069c6:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801069c9:	e8 e2 cd ff ff       	call   801037b0 <mycpu>
801069ce:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
801069d2:	b8 28 00 00 00       	mov    $0x28,%eax
801069d7:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801069da:	8b 46 04             	mov    0x4(%esi),%eax
801069dd:	05 00 00 00 80       	add    $0x80000000,%eax
801069e2:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
801069e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069e8:	5b                   	pop    %ebx
801069e9:	5e                   	pop    %esi
801069ea:	5f                   	pop    %edi
801069eb:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
801069ec:	e9 2f da ff ff       	jmp    80104420 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
801069f1:	83 ec 0c             	sub    $0xc,%esp
801069f4:	68 d6 7a 10 80       	push   $0x80107ad6
801069f9:	e8 72 99 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
801069fe:	83 ec 0c             	sub    $0xc,%esp
80106a01:	68 01 7b 10 80       	push   $0x80107b01
80106a06:	e8 65 99 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80106a0b:	83 ec 0c             	sub    $0xc,%esp
80106a0e:	68 ec 7a 10 80       	push   $0x80107aec
80106a13:	e8 58 99 ff ff       	call   80100370 <panic>
80106a18:	90                   	nop
80106a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106a20 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106a20:	55                   	push   %ebp
80106a21:	89 e5                	mov    %esp,%ebp
80106a23:	57                   	push   %edi
80106a24:	56                   	push   %esi
80106a25:	53                   	push   %ebx
80106a26:	83 ec 1c             	sub    $0x1c,%esp
80106a29:	8b 75 10             	mov    0x10(%ebp),%esi
80106a2c:	8b 55 08             	mov    0x8(%ebp),%edx
80106a2f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106a32:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106a38:	77 50                	ja     80106a8a <inituvm+0x6a>
80106a3a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    panic("inituvm: more than a page");
  mem = kalloc();
80106a3d:	e8 1e bb ff ff       	call   80102560 <kalloc>
  memset(mem, 0, PGSIZE);
80106a42:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106a45:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106a47:	68 00 10 00 00       	push   $0x1000
80106a4c:	6a 00                	push   $0x0
80106a4e:	50                   	push   %eax
80106a4f:	e8 8c da ff ff       	call   801044e0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106a54:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106a57:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106a5d:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106a64:	50                   	push   %eax
80106a65:	68 00 10 00 00       	push   $0x1000
80106a6a:	6a 00                	push   $0x0
80106a6c:	52                   	push   %edx
80106a6d:	e8 ee fd ff ff       	call   80106860 <mappages>
  memmove(mem, init, sz);
80106a72:	89 75 10             	mov    %esi,0x10(%ebp)
80106a75:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106a78:	83 c4 20             	add    $0x20,%esp
80106a7b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106a7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a81:	5b                   	pop    %ebx
80106a82:	5e                   	pop    %esi
80106a83:	5f                   	pop    %edi
80106a84:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106a85:	e9 06 db ff ff       	jmp    80104590 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106a8a:	83 ec 0c             	sub    $0xc,%esp
80106a8d:	68 15 7b 10 80       	push   $0x80107b15
80106a92:	e8 d9 98 ff ff       	call   80100370 <panic>
80106a97:	89 f6                	mov    %esi,%esi
80106a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106aa0 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	57                   	push   %edi
80106aa4:	56                   	push   %esi
80106aa5:	53                   	push   %ebx
80106aa6:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106aa9:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106ab0:	0f 85 91 00 00 00    	jne    80106b47 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106ab6:	8b 75 18             	mov    0x18(%ebp),%esi
80106ab9:	31 db                	xor    %ebx,%ebx
80106abb:	85 f6                	test   %esi,%esi
80106abd:	75 1a                	jne    80106ad9 <loaduvm+0x39>
80106abf:	eb 6f                	jmp    80106b30 <loaduvm+0x90>
80106ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ac8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ace:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106ad4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106ad7:	76 57                	jbe    80106b30 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ad9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106adc:	8b 45 08             	mov    0x8(%ebp),%eax
80106adf:	31 c9                	xor    %ecx,%ecx
80106ae1:	01 da                	add    %ebx,%edx
80106ae3:	e8 58 fb ff ff       	call   80106640 <walkpgdir>
80106ae8:	85 c0                	test   %eax,%eax
80106aea:	74 4e                	je     80106b3a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106aec:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106aee:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80106af1:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106af6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106afb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106b01:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b04:	01 d9                	add    %ebx,%ecx
80106b06:	05 00 00 00 80       	add    $0x80000000,%eax
80106b0b:	57                   	push   %edi
80106b0c:	51                   	push   %ecx
80106b0d:	50                   	push   %eax
80106b0e:	ff 75 10             	pushl  0x10(%ebp)
80106b11:	e8 0a af ff ff       	call   80101a20 <readi>
80106b16:	83 c4 10             	add    $0x10,%esp
80106b19:	39 c7                	cmp    %eax,%edi
80106b1b:	74 ab                	je     80106ac8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106b1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106b20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106b25:	5b                   	pop    %ebx
80106b26:	5e                   	pop    %esi
80106b27:	5f                   	pop    %edi
80106b28:	5d                   	pop    %ebp
80106b29:	c3                   	ret    
80106b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b30:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106b33:	31 c0                	xor    %eax,%eax
}
80106b35:	5b                   	pop    %ebx
80106b36:	5e                   	pop    %esi
80106b37:	5f                   	pop    %edi
80106b38:	5d                   	pop    %ebp
80106b39:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106b3a:	83 ec 0c             	sub    $0xc,%esp
80106b3d:	68 2f 7b 10 80       	push   $0x80107b2f
80106b42:	e8 29 98 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106b47:	83 ec 0c             	sub    $0xc,%esp
80106b4a:	68 2c 7c 10 80       	push   $0x80107c2c
80106b4f:	e8 1c 98 ff ff       	call   80100370 <panic>
80106b54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106b60 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106b60:	55                   	push   %ebp
80106b61:	89 e5                	mov    %esp,%ebp
80106b63:	57                   	push   %edi
80106b64:	56                   	push   %esi
80106b65:	53                   	push   %ebx
80106b66:	83 ec 0c             	sub    $0xc,%esp
80106b69:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106b6c:	85 ff                	test   %edi,%edi
80106b6e:	0f 88 ca 00 00 00    	js     80106c3e <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80106b74:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106b77:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106b7a:	0f 82 84 00 00 00    	jb     80106c04 <allocuvm+0xa4>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106b80:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106b86:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106b8c:	39 df                	cmp    %ebx,%edi
80106b8e:	77 45                	ja     80106bd5 <allocuvm+0x75>
80106b90:	e9 bb 00 00 00       	jmp    80106c50 <allocuvm+0xf0>
80106b95:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106b98:	83 ec 04             	sub    $0x4,%esp
80106b9b:	68 00 10 00 00       	push   $0x1000
80106ba0:	6a 00                	push   $0x0
80106ba2:	50                   	push   %eax
80106ba3:	e8 38 d9 ff ff       	call   801044e0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106ba8:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106bae:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106bb5:	50                   	push   %eax
80106bb6:	68 00 10 00 00       	push   $0x1000
80106bbb:	53                   	push   %ebx
80106bbc:	ff 75 08             	pushl  0x8(%ebp)
80106bbf:	e8 9c fc ff ff       	call   80106860 <mappages>
80106bc4:	83 c4 20             	add    $0x20,%esp
80106bc7:	85 c0                	test   %eax,%eax
80106bc9:	78 45                	js     80106c10 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106bcb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bd1:	39 df                	cmp    %ebx,%edi
80106bd3:	76 7b                	jbe    80106c50 <allocuvm+0xf0>
    mem = kalloc();
80106bd5:	e8 86 b9 ff ff       	call   80102560 <kalloc>
    if(mem == 0){
80106bda:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106bdc:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106bde:	75 b8                	jne    80106b98 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106be0:	83 ec 0c             	sub    $0xc,%esp
80106be3:	68 4d 7b 10 80       	push   $0x80107b4d
80106be8:	e8 73 9a ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106bed:	83 c4 10             	add    $0x10,%esp
80106bf0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106bf3:	76 49                	jbe    80106c3e <allocuvm+0xde>
80106bf5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106bf8:	8b 45 08             	mov    0x8(%ebp),%eax
80106bfb:	89 fa                	mov    %edi,%edx
80106bfd:	e8 be fa ff ff       	call   801066c0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106c02:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106c04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c07:	5b                   	pop    %ebx
80106c08:	5e                   	pop    %esi
80106c09:	5f                   	pop    %edi
80106c0a:	5d                   	pop    %ebp
80106c0b:	c3                   	ret    
80106c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106c10:	83 ec 0c             	sub    $0xc,%esp
80106c13:	68 65 7b 10 80       	push   $0x80107b65
80106c18:	e8 43 9a ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106c1d:	83 c4 10             	add    $0x10,%esp
80106c20:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106c23:	76 0d                	jbe    80106c32 <allocuvm+0xd2>
80106c25:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106c28:	8b 45 08             	mov    0x8(%ebp),%eax
80106c2b:	89 fa                	mov    %edi,%edx
80106c2d:	e8 8e fa ff ff       	call   801066c0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106c32:	83 ec 0c             	sub    $0xc,%esp
80106c35:	56                   	push   %esi
80106c36:	e8 75 b7 ff ff       	call   801023b0 <kfree>
      return 0;
80106c3b:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
80106c3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106c41:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106c43:	5b                   	pop    %ebx
80106c44:	5e                   	pop    %esi
80106c45:	5f                   	pop    %edi
80106c46:	5d                   	pop    %ebp
80106c47:	c3                   	ret    
80106c48:	90                   	nop
80106c49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106c53:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106c55:	5b                   	pop    %ebx
80106c56:	5e                   	pop    %esi
80106c57:	5f                   	pop    %edi
80106c58:	5d                   	pop    %ebp
80106c59:	c3                   	ret    
80106c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c60 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106c60:	55                   	push   %ebp
80106c61:	89 e5                	mov    %esp,%ebp
80106c63:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c66:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106c69:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106c6c:	39 d1                	cmp    %edx,%ecx
80106c6e:	73 10                	jae    80106c80 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106c70:	5d                   	pop    %ebp
80106c71:	e9 4a fa ff ff       	jmp    801066c0 <deallocuvm.part.0>
80106c76:	8d 76 00             	lea    0x0(%esi),%esi
80106c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106c80:	89 d0                	mov    %edx,%eax
80106c82:	5d                   	pop    %ebp
80106c83:	c3                   	ret    
80106c84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c90 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	57                   	push   %edi
80106c94:	56                   	push   %esi
80106c95:	53                   	push   %ebx
80106c96:	83 ec 0c             	sub    $0xc,%esp
80106c99:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106c9c:	85 f6                	test   %esi,%esi
80106c9e:	74 59                	je     80106cf9 <freevm+0x69>
80106ca0:	31 c9                	xor    %ecx,%ecx
80106ca2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106ca7:	89 f0                	mov    %esi,%eax
80106ca9:	e8 12 fa ff ff       	call   801066c0 <deallocuvm.part.0>
80106cae:	89 f3                	mov    %esi,%ebx
80106cb0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106cb6:	eb 0f                	jmp    80106cc7 <freevm+0x37>
80106cb8:	90                   	nop
80106cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cc0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106cc3:	39 fb                	cmp    %edi,%ebx
80106cc5:	74 23                	je     80106cea <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106cc7:	8b 03                	mov    (%ebx),%eax
80106cc9:	a8 01                	test   $0x1,%al
80106ccb:	74 f3                	je     80106cc0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106ccd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106cd2:	83 ec 0c             	sub    $0xc,%esp
80106cd5:	83 c3 04             	add    $0x4,%ebx
80106cd8:	05 00 00 00 80       	add    $0x80000000,%eax
80106cdd:	50                   	push   %eax
80106cde:	e8 cd b6 ff ff       	call   801023b0 <kfree>
80106ce3:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ce6:	39 fb                	cmp    %edi,%ebx
80106ce8:	75 dd                	jne    80106cc7 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106cea:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106ced:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106cf0:	5b                   	pop    %ebx
80106cf1:	5e                   	pop    %esi
80106cf2:	5f                   	pop    %edi
80106cf3:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106cf4:	e9 b7 b6 ff ff       	jmp    801023b0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106cf9:	83 ec 0c             	sub    $0xc,%esp
80106cfc:	68 81 7b 10 80       	push   $0x80107b81
80106d01:	e8 6a 96 ff ff       	call   80100370 <panic>
80106d06:	8d 76 00             	lea    0x0(%esi),%esi
80106d09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d10 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	56                   	push   %esi
80106d14:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106d15:	e8 46 b8 ff ff       	call   80102560 <kalloc>
80106d1a:	85 c0                	test   %eax,%eax
80106d1c:	74 6a                	je     80106d88 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106d1e:	83 ec 04             	sub    $0x4,%esp
80106d21:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d23:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106d28:	68 00 10 00 00       	push   $0x1000
80106d2d:	6a 00                	push   $0x0
80106d2f:	50                   	push   %eax
80106d30:	e8 ab d7 ff ff       	call   801044e0 <memset>
80106d35:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106d38:	8b 43 04             	mov    0x4(%ebx),%eax
80106d3b:	8b 53 08             	mov    0x8(%ebx),%edx
80106d3e:	83 ec 0c             	sub    $0xc,%esp
80106d41:	ff 73 0c             	pushl  0xc(%ebx)
80106d44:	29 c2                	sub    %eax,%edx
80106d46:	50                   	push   %eax
80106d47:	52                   	push   %edx
80106d48:	ff 33                	pushl  (%ebx)
80106d4a:	56                   	push   %esi
80106d4b:	e8 10 fb ff ff       	call   80106860 <mappages>
80106d50:	83 c4 20             	add    $0x20,%esp
80106d53:	85 c0                	test   %eax,%eax
80106d55:	78 19                	js     80106d70 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d57:	83 c3 10             	add    $0x10,%ebx
80106d5a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106d60:	75 d6                	jne    80106d38 <setupkvm+0x28>
80106d62:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106d64:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106d67:	5b                   	pop    %ebx
80106d68:	5e                   	pop    %esi
80106d69:	5d                   	pop    %ebp
80106d6a:	c3                   	ret    
80106d6b:	90                   	nop
80106d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106d70:	83 ec 0c             	sub    $0xc,%esp
80106d73:	56                   	push   %esi
80106d74:	e8 17 ff ff ff       	call   80106c90 <freevm>
      return 0;
80106d79:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
80106d7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80106d7f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80106d81:	5b                   	pop    %ebx
80106d82:	5e                   	pop    %esi
80106d83:	5d                   	pop    %ebp
80106d84:	c3                   	ret    
80106d85:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106d88:	31 c0                	xor    %eax,%eax
80106d8a:	eb d8                	jmp    80106d64 <setupkvm+0x54>
80106d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d90 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106d90:	55                   	push   %ebp
80106d91:	89 e5                	mov    %esp,%ebp
80106d93:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106d96:	e8 75 ff ff ff       	call   80106d10 <setupkvm>
80106d9b:	a3 a4 55 11 80       	mov    %eax,0x801155a4
80106da0:	05 00 00 00 80       	add    $0x80000000,%eax
80106da5:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80106da8:	c9                   	leave  
80106da9:	c3                   	ret    
80106daa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106db0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106db0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106db1:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106db3:	89 e5                	mov    %esp,%ebp
80106db5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106db8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106dbb:	8b 45 08             	mov    0x8(%ebp),%eax
80106dbe:	e8 7d f8 ff ff       	call   80106640 <walkpgdir>
  if(pte == 0)
80106dc3:	85 c0                	test   %eax,%eax
80106dc5:	74 05                	je     80106dcc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106dc7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106dca:	c9                   	leave  
80106dcb:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106dcc:	83 ec 0c             	sub    $0xc,%esp
80106dcf:	68 92 7b 10 80       	push   $0x80107b92
80106dd4:	e8 97 95 ff ff       	call   80100370 <panic>
80106dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106de0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz, uint stack_sz)//cs153 add stack size parameter
{
80106de0:	55                   	push   %ebp
80106de1:	89 e5                	mov    %esp,%ebp
80106de3:	57                   	push   %edi
80106de4:	56                   	push   %esi
80106de5:	53                   	push   %ebx
80106de6:	83 ec 1c             	sub    $0x1c,%esp
  pte_t *pte;
  uint pa, i, flags;
  char *mem;
  //struct proc *curproc = myproc();

  if((d = setupkvm()) == 0)
80106de9:	e8 22 ff ff ff       	call   80106d10 <setupkvm>
80106dee:	85 c0                	test   %eax,%eax
80106df0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106df3:	0f 84 44 02 00 00    	je     8010703d <copyuvm+0x25d>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){//cs153
80106df9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dfc:	85 c0                	test   %eax,%eax
80106dfe:	0f 84 0c 01 00 00    	je     80106f10 <copyuvm+0x130>
80106e04:	31 ff                	xor    %edi,%edi
80106e06:	eb 6e                	jmp    80106e76 <copyuvm+0x96>
80106e08:	90                   	nop
80106e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
   cprintf("55"); 
   if((mem = kalloc()) == 0)
      goto bad;
    cprintf("66");
80106e10:	83 ec 0c             	sub    $0xc,%esp
80106e13:	68 d9 7b 10 80       	push   $0x80107bd9
80106e18:	e8 43 98 ff ff       	call   80100660 <cprintf>
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106e1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e20:	83 c4 0c             	add    $0xc,%esp
80106e23:	68 00 10 00 00       	push   $0x1000
80106e28:	05 00 00 00 80       	add    $0x80000000,%eax
80106e2d:	50                   	push   %eax
80106e2e:	53                   	push   %ebx
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106e2f:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    flags = PTE_FLAGS(*pte);
   cprintf("55"); 
   if((mem = kalloc()) == 0)
      goto bad;
    cprintf("66");
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106e35:	e8 56 d7 ff ff       	call   80104590 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106e3a:	89 34 24             	mov    %esi,(%esp)
80106e3d:	53                   	push   %ebx
80106e3e:	68 00 10 00 00       	push   $0x1000
80106e43:	57                   	push   %edi
80106e44:	ff 75 e0             	pushl  -0x20(%ebp)
80106e47:	e8 14 fa ff ff       	call   80106860 <mappages>
80106e4c:	83 c4 20             	add    $0x20,%esp
80106e4f:	85 c0                	test   %eax,%eax
80106e51:	0f 88 9b 00 00 00    	js     80106ef2 <copyuvm+0x112>
      goto bad;
    cprintf("77");
80106e57:	83 ec 0c             	sub    $0xc,%esp
  char *mem;
  //struct proc *curproc = myproc();

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){//cs153
80106e5a:	81 c7 00 10 00 00    	add    $0x1000,%edi
      goto bad;
    cprintf("66");
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
    cprintf("77");
80106e60:	68 d5 7b 10 80       	push   $0x80107bd5
80106e65:	e8 f6 97 ff ff       	call   80100660 <cprintf>
  char *mem;
  //struct proc *curproc = myproc();

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){//cs153
80106e6a:	83 c4 10             	add    $0x10,%esp
80106e6d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106e70:	0f 86 9a 00 00 00    	jbe    80106f10 <copyuvm+0x130>
    cprintf("22");
80106e76:	83 ec 0c             	sub    $0xc,%esp
80106e79:	68 1a 7c 10 80       	push   $0x80107c1a
80106e7e:	e8 dd 97 ff ff       	call   80100660 <cprintf>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106e83:	8b 45 08             	mov    0x8(%ebp),%eax
80106e86:	31 c9                	xor    %ecx,%ecx
80106e88:	89 fa                	mov    %edi,%edx
80106e8a:	e8 b1 f7 ff ff       	call   80106640 <walkpgdir>
80106e8f:	83 c4 10             	add    $0x10,%esp
80106e92:	85 c0                	test   %eax,%eax
80106e94:	89 c3                	mov    %eax,%ebx
80106e96:	0f 84 b5 01 00 00    	je     80107051 <copyuvm+0x271>
      panic("copyuvm: pte should exist1");
    cprintf("33");
80106e9c:	83 ec 0c             	sub    $0xc,%esp
80106e9f:	68 1e 7c 10 80       	push   $0x80107c1e
80106ea4:	e8 b7 97 ff ff       	call   80100660 <cprintf>
    if(!(*pte & PTE_P))
80106ea9:	83 c4 10             	add    $0x10,%esp
80106eac:	f6 03 01             	testb  $0x1,(%ebx)
80106eaf:	0f 84 8f 01 00 00    	je     80107044 <copyuvm+0x264>
      panic("copyuvm: page not present1");
    cprintf("44");
80106eb5:	83 ec 0c             	sub    $0xc,%esp
80106eb8:	68 22 7c 10 80       	push   $0x80107c22
80106ebd:	e8 9e 97 ff ff       	call   80100660 <cprintf>
    pa = PTE_ADDR(*pte);
80106ec2:	8b 33                	mov    (%ebx),%esi
    flags = PTE_FLAGS(*pte);
   cprintf("55"); 
80106ec4:	c7 04 24 26 7c 10 80 	movl   $0x80107c26,(%esp)
      panic("copyuvm: pte should exist1");
    cprintf("33");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present1");
    cprintf("44");
    pa = PTE_ADDR(*pte);
80106ecb:	89 f0                	mov    %esi,%eax
    flags = PTE_FLAGS(*pte);
80106ecd:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
      panic("copyuvm: pte should exist1");
    cprintf("33");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present1");
    cprintf("44");
    pa = PTE_ADDR(*pte);
80106ed3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ed8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    flags = PTE_FLAGS(*pte);
   cprintf("55"); 
80106edb:	e8 80 97 ff ff       	call   80100660 <cprintf>
   if((mem = kalloc()) == 0)
80106ee0:	e8 7b b6 ff ff       	call   80102560 <kalloc>
80106ee5:	83 c4 10             	add    $0x10,%esp
80106ee8:	85 c0                	test   %eax,%eax
80106eea:	89 c3                	mov    %eax,%ebx
80106eec:	0f 85 1e ff ff ff    	jne    80106e10 <copyuvm+0x30>
  cprintf("666");
  //cs153
  return d;

bad:
  freevm(d);
80106ef2:	83 ec 0c             	sub    $0xc,%esp
80106ef5:	ff 75 e0             	pushl  -0x20(%ebp)
80106ef8:	e8 93 fd ff ff       	call   80106c90 <freevm>
  return 0;
80106efd:	83 c4 10             	add    $0x10,%esp
80106f00:	31 c0                	xor    %eax,%eax
}
80106f02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f05:	5b                   	pop    %ebx
80106f06:	5e                   	pop    %esi
80106f07:	5f                   	pop    %edi
80106f08:	5d                   	pop    %ebp
80106f09:	c3                   	ret    
80106f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
    cprintf("77");
  }
  cprintf("88");
80106f10:	83 ec 0c             	sub    $0xc,%esp
80106f13:	68 9c 7b 10 80       	push   $0x80107b9c
80106f18:	e8 43 97 ff ff       	call   80100660 <cprintf>

  //cs153 add other for loop to copy last page
  for(i=PGROUNDDOWN(myproc()->tf->esp);i<KERNBASE-4;i+=PGSIZE){
80106f1d:	e8 2e c9 ff ff       	call   80103850 <myproc>
80106f22:	8b 40 18             	mov    0x18(%eax),%eax
80106f25:	83 c4 10             	add    $0x10,%esp
80106f28:	8b 70 44             	mov    0x44(%eax),%esi
80106f2b:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80106f31:	81 fe fb ff ff 7f    	cmp    $0x7ffffffb,%esi
80106f37:	76 78                	jbe    80106fb1 <copyuvm+0x1d1>
80106f39:	e9 e4 00 00 00       	jmp    80107022 <copyuvm+0x242>
80106f3e:	66 90                	xchg   %ax,%ax
    cprintf("222");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    cprintf("333");
80106f40:	83 ec 0c             	sub    $0xc,%esp
80106f43:	68 1d 7c 10 80       	push   $0x80107c1d
80106f48:	e8 13 97 ff ff       	call   80100660 <cprintf>
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106f4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f50:	83 c4 0c             	add    $0xc,%esp
80106f53:	68 00 10 00 00       	push   $0x1000
80106f58:	05 00 00 00 80       	add    $0x80000000,%eax
80106f5d:	50                   	push   %eax
80106f5e:	53                   	push   %ebx
    cprintf("444");
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106f5f:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    cprintf("333");
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106f65:	e8 26 d6 ff ff       	call   80104590 <memmove>
    cprintf("444");
80106f6a:	c7 04 24 21 7c 10 80 	movl   $0x80107c21,(%esp)
80106f71:	e8 ea 96 ff ff       	call   80100660 <cprintf>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106f76:	89 3c 24             	mov    %edi,(%esp)
80106f79:	53                   	push   %ebx
80106f7a:	68 00 10 00 00       	push   $0x1000
80106f7f:	56                   	push   %esi
80106f80:	ff 75 e0             	pushl  -0x20(%ebp)
80106f83:	e8 d8 f8 ff ff       	call   80106860 <mappages>
80106f88:	83 c4 20             	add    $0x20,%esp
80106f8b:	85 c0                	test   %eax,%eax
80106f8d:	0f 88 5f ff ff ff    	js     80106ef2 <copyuvm+0x112>
      goto bad; 
    cprintf("555");
80106f93:	83 ec 0c             	sub    $0xc,%esp
    cprintf("77");
  }
  cprintf("88");

  //cs153 add other for loop to copy last page
  for(i=PGROUNDDOWN(myproc()->tf->esp);i<KERNBASE-4;i+=PGSIZE){
80106f96:	81 c6 00 10 00 00    	add    $0x1000,%esi
    cprintf("333");
    memmove(mem, (char*)P2V(pa), PGSIZE);
    cprintf("444");
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad; 
    cprintf("555");
80106f9c:	68 25 7c 10 80       	push   $0x80107c25
80106fa1:	e8 ba 96 ff ff       	call   80100660 <cprintf>
    cprintf("77");
  }
  cprintf("88");

  //cs153 add other for loop to copy last page
  for(i=PGROUNDDOWN(myproc()->tf->esp);i<KERNBASE-4;i+=PGSIZE){
80106fa6:	83 c4 10             	add    $0x10,%esp
80106fa9:	81 fe fb ff ff 7f    	cmp    $0x7ffffffb,%esi
80106faf:	77 71                	ja     80107022 <copyuvm+0x242>
    cprintf("99");
80106fb1:	83 ec 0c             	sub    $0xc,%esp
80106fb4:	68 dc 7b 10 80       	push   $0x80107bdc
80106fb9:	e8 a2 96 ff ff       	call   80100660 <cprintf>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106fbe:	8b 45 08             	mov    0x8(%ebp),%eax
80106fc1:	31 c9                	xor    %ecx,%ecx
80106fc3:	89 f2                	mov    %esi,%edx
80106fc5:	e8 76 f6 ff ff       	call   80106640 <walkpgdir>
80106fca:	83 c4 10             	add    $0x10,%esp
80106fcd:	85 c0                	test   %eax,%eax
80106fcf:	89 c3                	mov    %eax,%ebx
80106fd1:	0f 84 87 00 00 00    	je     8010705e <copyuvm+0x27e>
      panic("copyuvm: pte should exist2");
    cprintf("111");
80106fd7:	83 ec 0c             	sub    $0xc,%esp
80106fda:	68 fa 7b 10 80       	push   $0x80107bfa
80106fdf:	e8 7c 96 ff ff       	call   80100660 <cprintf>
    if(!(*pte & PTE_P))
80106fe4:	83 c4 10             	add    $0x10,%esp
80106fe7:	f6 03 01             	testb  $0x1,(%ebx)
80106fea:	74 7f                	je     8010706b <copyuvm+0x28b>
      panic("copyuvm: page not present2");
    cprintf("222");
80106fec:	83 ec 0c             	sub    $0xc,%esp
80106fef:	68 19 7c 10 80       	push   $0x80107c19
80106ff4:	e8 67 96 ff ff       	call   80100660 <cprintf>
    pa = PTE_ADDR(*pte);
80106ff9:	8b 3b                	mov    (%ebx),%edi
80106ffb:	89 f8                	mov    %edi,%eax
    flags = PTE_FLAGS(*pte);
80106ffd:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
      panic("copyuvm: pte should exist2");
    cprintf("111");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present2");
    cprintf("222");
    pa = PTE_ADDR(*pte);
80107003:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107008:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
8010700b:	e8 50 b5 ff ff       	call   80102560 <kalloc>
80107010:	83 c4 10             	add    $0x10,%esp
80107013:	85 c0                	test   %eax,%eax
80107015:	89 c3                	mov    %eax,%ebx
80107017:	0f 85 23 ff ff ff    	jne    80106f40 <copyuvm+0x160>
8010701d:	e9 d0 fe ff ff       	jmp    80106ef2 <copyuvm+0x112>
    cprintf("444");
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad; 
    cprintf("555");
  }
  cprintf("666");
80107022:	83 ec 0c             	sub    $0xc,%esp
80107025:	68 d8 7b 10 80       	push   $0x80107bd8
8010702a:	e8 31 96 ff ff       	call   80100660 <cprintf>
  //cs153
  return d;
8010702f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107032:	83 c4 10             	add    $0x10,%esp

bad:
  freevm(d);
  return 0;
}
80107035:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107038:	5b                   	pop    %ebx
80107039:	5e                   	pop    %esi
8010703a:	5f                   	pop    %edi
8010703b:	5d                   	pop    %ebp
8010703c:	c3                   	ret    
  uint pa, i, flags;
  char *mem;
  //struct proc *curproc = myproc();

  if((d = setupkvm()) == 0)
    return 0;
8010703d:	31 c0                	xor    %eax,%eax
8010703f:	e9 be fe ff ff       	jmp    80106f02 <copyuvm+0x122>
    cprintf("22");
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist1");
    cprintf("33");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present1");
80107044:	83 ec 0c             	sub    $0xc,%esp
80107047:	68 ba 7b 10 80       	push   $0x80107bba
8010704c:	e8 1f 93 ff ff       	call   80100370 <panic>
  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){//cs153
    cprintf("22");
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist1");
80107051:	83 ec 0c             	sub    $0xc,%esp
80107054:	68 9f 7b 10 80       	push   $0x80107b9f
80107059:	e8 12 93 ff ff       	call   80100370 <panic>

  //cs153 add other for loop to copy last page
  for(i=PGROUNDDOWN(myproc()->tf->esp);i<KERNBASE-4;i+=PGSIZE){
    cprintf("99");
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist2");
8010705e:	83 ec 0c             	sub    $0xc,%esp
80107061:	68 df 7b 10 80       	push   $0x80107bdf
80107066:	e8 05 93 ff ff       	call   80100370 <panic>
    cprintf("111");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present2");
8010706b:	83 ec 0c             	sub    $0xc,%esp
8010706e:	68 fe 7b 10 80       	push   $0x80107bfe
80107073:	e8 f8 92 ff ff       	call   80100370 <panic>
80107078:	90                   	nop
80107079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107080 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107080:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107081:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107083:	89 e5                	mov    %esp,%ebp
80107085:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107088:	8b 55 0c             	mov    0xc(%ebp),%edx
8010708b:	8b 45 08             	mov    0x8(%ebp),%eax
8010708e:	e8 ad f5 ff ff       	call   80106640 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107093:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80107095:	89 c2                	mov    %eax,%edx
80107097:	83 e2 05             	and    $0x5,%edx
8010709a:	83 fa 05             	cmp    $0x5,%edx
8010709d:	75 11                	jne    801070b0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010709f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
801070a4:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801070a5:	05 00 00 00 80       	add    $0x80000000,%eax
}
801070aa:	c3                   	ret    
801070ab:	90                   	nop
801070ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
801070b0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
801070b2:	c9                   	leave  
801070b3:	c3                   	ret    
801070b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801070ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801070c0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	57                   	push   %edi
801070c4:	56                   	push   %esi
801070c5:	53                   	push   %ebx
801070c6:	83 ec 1c             	sub    $0x1c,%esp
801070c9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801070cc:	8b 55 0c             	mov    0xc(%ebp),%edx
801070cf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801070d2:	85 db                	test   %ebx,%ebx
801070d4:	75 40                	jne    80107116 <copyout+0x56>
801070d6:	eb 70                	jmp    80107148 <copyout+0x88>
801070d8:	90                   	nop
801070d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801070e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801070e3:	89 f1                	mov    %esi,%ecx
801070e5:	29 d1                	sub    %edx,%ecx
801070e7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801070ed:	39 d9                	cmp    %ebx,%ecx
801070ef:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801070f2:	29 f2                	sub    %esi,%edx
801070f4:	83 ec 04             	sub    $0x4,%esp
801070f7:	01 d0                	add    %edx,%eax
801070f9:	51                   	push   %ecx
801070fa:	57                   	push   %edi
801070fb:	50                   	push   %eax
801070fc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801070ff:	e8 8c d4 ff ff       	call   80104590 <memmove>
    len -= n;
    buf += n;
80107104:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107107:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
8010710a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107110:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107112:	29 cb                	sub    %ecx,%ebx
80107114:	74 32                	je     80107148 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107116:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107118:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010711b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010711e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107124:	56                   	push   %esi
80107125:	ff 75 08             	pushl  0x8(%ebp)
80107128:	e8 53 ff ff ff       	call   80107080 <uva2ka>
    if(pa0 == 0)
8010712d:	83 c4 10             	add    $0x10,%esp
80107130:	85 c0                	test   %eax,%eax
80107132:	75 ac                	jne    801070e0 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107134:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107137:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010713c:	5b                   	pop    %ebx
8010713d:	5e                   	pop    %esi
8010713e:	5f                   	pop    %edi
8010713f:	5d                   	pop    %ebp
80107140:	c3                   	ret    
80107141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107148:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010714b:	31 c0                	xor    %eax,%eax
}
8010714d:	5b                   	pop    %ebx
8010714e:	5e                   	pop    %esi
8010714f:	5f                   	pop    %edi
80107150:	5d                   	pop    %ebp
80107151:	c3                   	ret    
80107152:	66 90                	xchg   %ax,%ax
80107154:	66 90                	xchg   %ax,%ax
80107156:	66 90                	xchg   %ax,%ax
80107158:	66 90                	xchg   %ax,%ax
8010715a:	66 90                	xchg   %ax,%ax
8010715c:	66 90                	xchg   %ax,%ax
8010715e:	66 90                	xchg   %ax,%ax

80107160 <shminit>:
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
80107160:	55                   	push   %ebp
80107161:	89 e5                	mov    %esp,%ebp
80107163:	83 ec 10             	sub    $0x10,%esp
  int i;
  initlock(&(shm_table.lock), "SHM lock");
80107166:	68 50 7c 10 80       	push   $0x80107c50
8010716b:	68 c0 55 11 80       	push   $0x801155c0
80107170:	e8 fb d0 ff ff       	call   80104270 <initlock>
  acquire(&(shm_table.lock));
80107175:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
8010717c:	e8 ef d1 ff ff       	call   80104370 <acquire>
80107181:	b8 f4 55 11 80       	mov    $0x801155f4,%eax
80107186:	83 c4 10             	add    $0x10,%esp
80107189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id =0;
80107190:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    shm_table.shm_pages[i].frame =0;
80107196:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
8010719d:	83 c0 0c             	add    $0xc,%eax
    shm_table.shm_pages[i].refcnt =0;
801071a0:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)

void shminit() {
  int i;
  initlock(&(shm_table.lock), "SHM lock");
  acquire(&(shm_table.lock));
  for (i = 0; i< 64; i++) {
801071a7:	3d f4 58 11 80       	cmp    $0x801158f4,%eax
801071ac:	75 e2                	jne    80107190 <shminit+0x30>
    shm_table.shm_pages[i].id =0;
    shm_table.shm_pages[i].frame =0;
    shm_table.shm_pages[i].refcnt =0;
  }
  release(&(shm_table.lock));
801071ae:	83 ec 0c             	sub    $0xc,%esp
801071b1:	68 c0 55 11 80       	push   $0x801155c0
801071b6:	e8 d5 d2 ff ff       	call   80104490 <release>
}
801071bb:	83 c4 10             	add    $0x10,%esp
801071be:	c9                   	leave  
801071bf:	c3                   	ret    

801071c0 <shm_open>:

int shm_open(int id, char **pointer) {
801071c0:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
801071c1:	31 c0                	xor    %eax,%eax
    shm_table.shm_pages[i].refcnt =0;
  }
  release(&(shm_table.lock));
}

int shm_open(int id, char **pointer) {
801071c3:	89 e5                	mov    %esp,%ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
801071c5:	5d                   	pop    %ebp
801071c6:	c3                   	ret    
801071c7:	89 f6                	mov    %esi,%esi
801071c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801071d0 <shm_close>:


int shm_close(int id) {
801071d0:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
801071d1:	31 c0                	xor    %eax,%eax

return 0; //added to remove compiler warning -- you should decide what to return
}


int shm_close(int id) {
801071d3:	89 e5                	mov    %esp,%ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
801071d5:	5d                   	pop    %ebp
801071d6:	c3                   	ret    
