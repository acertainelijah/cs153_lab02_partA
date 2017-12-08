
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
8010002d:	b8 20 2e 10 80       	mov    $0x80102e20,%eax
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
8010004c:	68 00 70 10 80       	push   $0x80107000
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 05 41 00 00       	call   80104160 <initlock>

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
80100092:	68 07 70 10 80       	push   $0x80107007
80100097:	50                   	push   %eax
80100098:	e8 b3 3f 00 00       	call   80104050 <initsleeplock>
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
801000e4:	e8 77 41 00 00       	call   80104260 <acquire>

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
80100162:	e8 19 42 00 00       	call   80104380 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 3f 00 00       	call   80104090 <acquiresleep>
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
8010017e:	e8 2d 1f 00 00       	call   801020b0 <iderw>
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
80100193:	68 0e 70 10 80       	push   $0x8010700e
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
801001ae:	e8 7d 3f 00 00       	call   80104130 <holdingsleep>
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
801001c4:	e9 e7 1e 00 00       	jmp    801020b0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 1f 70 10 80       	push   $0x8010701f
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
801001ef:	e8 3c 3f 00 00       	call   80104130 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ec 3e 00 00       	call   801040f0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 50 40 00 00       	call   80104260 <acquire>
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
8010025c:	e9 1f 41 00 00       	jmp    80104380 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 26 70 10 80       	push   $0x80107026
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
80100280:	e8 8b 14 00 00       	call   80101710 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 cf 3f 00 00       	call   80104260 <acquire>
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
801002bd:	e8 2e 3a 00 00       	call   80103cf0 <sleep>

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
801002d2:	e8 69 34 00 00       	call   80103740 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 a5 10 80       	push   $0x8010a520
801002e6:	e8 95 40 00 00       	call   80104380 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 3d 13 00 00       	call   80101630 <ilock>
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
80100346:	e8 35 40 00 00       	call   80104380 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 dd 12 00 00       	call   80101630 <ilock>

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
80100389:	e8 22 23 00 00       	call   801026b0 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 2d 70 10 80       	push   $0x8010702d
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 7f 79 10 80 	movl   $0x8010797f,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 c3 3d 00 00       	call   80104180 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 41 70 10 80       	push   $0x80107041
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
8010041a:	e8 51 56 00 00       	call   80105a70 <uartputc>
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
801004d3:	e8 98 55 00 00       	call   80105a70 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 8c 55 00 00       	call   80105a70 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 80 55 00 00       	call   80105a70 <uartputc>
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
80100514:	e8 67 3f 00 00       	call   80104480 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 a2 3e 00 00       	call   801043d0 <memset>
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
80100540:	68 45 70 10 80       	push   $0x80107045
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
801005b1:	0f b6 92 70 70 10 80 	movzbl -0x7fef8f90(%edx),%edx
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
8010060f:	e8 fc 10 00 00       	call   80101710 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 40 3c 00 00       	call   80104260 <acquire>
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
80100647:	e8 34 3d 00 00       	call   80104380 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 db 0f 00 00       	call   80101630 <ilock>

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
8010070d:	e8 6e 3c 00 00       	call   80104380 <release>
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
80100788:	b8 58 70 10 80       	mov    $0x80107058,%eax
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
801007c8:	e8 93 3a 00 00       	call   80104260 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 5f 70 10 80       	push   $0x8010705f
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
80100803:	e8 58 3a 00 00       	call   80104260 <acquire>
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
80100868:	e8 13 3b 00 00       	call   80104380 <release>
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
801008f6:	e8 a5 35 00 00       	call   80103ea0 <wakeup>
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
80100977:	e9 14 36 00 00       	jmp    80103f90 <procdump>
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
801009a6:	68 68 70 10 80       	push   $0x80107068
801009ab:	68 20 a5 10 80       	push   $0x8010a520
801009b0:	e8 ab 37 00 00       	call   80104160 <initlock>

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
801009d9:	e8 82 18 00 00       	call   80102260 <ioapicenable>
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
801009fc:	e8 3f 2d 00 00       	call   80103740 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a07:	e8 04 21 00 00       	call   80102b10 <begin_op>

  if((ip = namei(path)) == 0){
80100a0c:	83 ec 0c             	sub    $0xc,%esp
80100a0f:	ff 75 08             	pushl  0x8(%ebp)
80100a12:	e8 69 14 00 00       	call   80101e80 <namei>
80100a17:	83 c4 10             	add    $0x10,%esp
80100a1a:	85 c0                	test   %eax,%eax
80100a1c:	0f 84 06 02 00 00    	je     80100c28 <exec+0x238>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a22:	83 ec 0c             	sub    $0xc,%esp
80100a25:	89 c3                	mov    %eax,%ebx
80100a27:	50                   	push   %eax
80100a28:	e8 03 0c 00 00       	call   80101630 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a33:	6a 34                	push   $0x34
80100a35:	6a 00                	push   $0x0
80100a37:	50                   	push   %eax
80100a38:	53                   	push   %ebx
80100a39:	e8 d2 0e 00 00       	call   80101910 <readi>
80100a3e:	83 c4 20             	add    $0x20,%esp
80100a41:	83 f8 34             	cmp    $0x34,%eax
80100a44:	74 22                	je     80100a68 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a46:	83 ec 0c             	sub    $0xc,%esp
80100a49:	53                   	push   %ebx
80100a4a:	e8 71 0e 00 00       	call   801018c0 <iunlockput>
    end_op();
80100a4f:	e8 2c 21 00 00       	call   80102b80 <end_op>
80100a54:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a5f:	5b                   	pop    %ebx
80100a60:	5e                   	pop    %esi
80100a61:	5f                   	pop    %edi
80100a62:	5d                   	pop    %ebp
80100a63:	c3                   	ret    
80100a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a68:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a6f:	45 4c 46 
80100a72:	75 d2                	jne    80100a46 <exec+0x56>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a74:	e8 87 61 00 00       	call   80106c00 <setupkvm>
80100a79:	85 c0                	test   %eax,%eax
80100a7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a81:	74 c3                	je     80100a46 <exec+0x56>
    goto bad;

  // Load program into memory.
  sz = 0;

  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a83:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a8a:	00 
80100a8b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a91:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a98:	00 00 00 
80100a9b:	0f 84 c5 00 00 00    	je     80100b66 <exec+0x176>
80100aa1:	31 ff                	xor    %edi,%edi
80100aa3:	eb 18                	jmp    80100abd <exec+0xcd>
80100aa5:	8d 76 00             	lea    0x0(%esi),%esi
80100aa8:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100aaf:	83 c7 01             	add    $0x1,%edi
80100ab2:	83 c6 20             	add    $0x20,%esi
80100ab5:	39 f8                	cmp    %edi,%eax
80100ab7:	0f 8e a9 00 00 00    	jle    80100b66 <exec+0x176>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100abd:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ac3:	6a 20                	push   $0x20
80100ac5:	56                   	push   %esi
80100ac6:	50                   	push   %eax
80100ac7:	53                   	push   %ebx
80100ac8:	e8 43 0e 00 00       	call   80101910 <readi>
80100acd:	83 c4 10             	add    $0x10,%esp
80100ad0:	83 f8 20             	cmp    $0x20,%eax
80100ad3:	75 7b                	jne    80100b50 <exec+0x160>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ad5:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100adc:	75 ca                	jne    80100aa8 <exec+0xb8>
      continue;
    if(ph.memsz < ph.filesz)
80100ade:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ae4:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100aea:	72 64                	jb     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100aec:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100af2:	72 5c                	jb     80100b50 <exec+0x160>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100af4:	83 ec 04             	sub    $0x4,%esp
80100af7:	50                   	push   %eax
80100af8:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100afe:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b04:	e8 47 5f 00 00       	call   80106a50 <allocuvm>
80100b09:	83 c4 10             	add    $0x10,%esp
80100b0c:	85 c0                	test   %eax,%eax
80100b0e:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b14:	74 3a                	je     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b16:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b1c:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b21:	75 2d                	jne    80100b50 <exec+0x160>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b23:	83 ec 0c             	sub    $0xc,%esp
80100b26:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b2c:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b32:	53                   	push   %ebx
80100b33:	50                   	push   %eax
80100b34:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b3a:	e8 51 5e 00 00       	call   80106990 <loaduvm>
80100b3f:	83 c4 20             	add    $0x20,%esp
80100b42:	85 c0                	test   %eax,%eax
80100b44:	0f 89 5e ff ff ff    	jns    80100aa8 <exec+0xb8>
80100b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b50:	83 ec 0c             	sub    $0xc,%esp
80100b53:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b59:	e8 22 60 00 00       	call   80106b80 <freevm>
80100b5e:	83 c4 10             	add    $0x10,%esp
80100b61:	e9 e0 fe ff ff       	jmp    80100a46 <exec+0x56>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b66:	83 ec 0c             	sub    $0xc,%esp
80100b69:	53                   	push   %ebx
80100b6a:	e8 51 0d 00 00       	call   801018c0 <iunlockput>
  end_op();
80100b6f:	e8 0c 20 00 00       	call   80102b80 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  //sz = PGROUNDUP(sz);
  if((sp = allocuvm(pgdir, (KERNBASE-4)-PGSIZE, (KERNBASE-4))) == 0)//cs153 bottom (K-4)*PGSZ, top stack(K-4)
80100b74:	83 c4 0c             	add    $0xc,%esp
80100b77:	68 fc ff ff 7f       	push   $0x7ffffffc
80100b7c:	68 fc ef ff 7f       	push   $0x7fffeffc
80100b81:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b87:	e8 c4 5e 00 00       	call   80106a50 <allocuvm>
80100b8c:	83 c4 10             	add    $0x10,%esp
80100b8f:	85 c0                	test   %eax,%eax
80100b91:	74 7a                	je     80100c0d <exec+0x21d>
    goto bad;
  sp = KERNBASE-4;//cs153 change stack pointer to top of address space
  //curproc->stack_sz = KERNBASE-4;//cs153 delete? maybe use for bonus

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100b93:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b96:	31 f6                	xor    %esi,%esi
80100b98:	bb fc ff ff 7f       	mov    $0x7ffffffc,%ebx
80100b9d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100ba3:	8b 00                	mov    (%eax),%eax
80100ba5:	85 c0                	test   %eax,%eax
80100ba7:	0f 84 9a 00 00 00    	je     80100c47 <exec+0x257>
80100bad:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100bb3:	eb 22                	jmp    80100bd7 <exec+0x1e7>
80100bb5:	8d 76 00             	lea    0x0(%esi),%esi
80100bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100bbb:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
    goto bad;
  sp = KERNBASE-4;//cs153 change stack pointer to top of address space
  //curproc->stack_sz = KERNBASE-4;//cs153 delete? maybe use for bonus

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bc2:	83 c6 01             	add    $0x1,%esi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100bc5:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  sp = KERNBASE-4;//cs153 change stack pointer to top of address space
  //curproc->stack_sz = KERNBASE-4;//cs153 delete? maybe use for bonus

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bcb:	8b 04 b0             	mov    (%eax,%esi,4),%eax
80100bce:	85 c0                	test   %eax,%eax
80100bd0:	74 75                	je     80100c47 <exec+0x257>
    if(argc >= MAXARG)
80100bd2:	83 fe 20             	cmp    $0x20,%esi
80100bd5:	74 36                	je     80100c0d <exec+0x21d>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bd7:	83 ec 0c             	sub    $0xc,%esp
80100bda:	50                   	push   %eax
80100bdb:	e8 30 3a 00 00       	call   80104610 <strlen>
80100be0:	f7 d0                	not    %eax
80100be2:	01 d8                	add    %ebx,%eax
80100be4:	83 e0 fc             	and    $0xfffffffc,%eax
80100be7:	89 c3                	mov    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100be9:	58                   	pop    %eax
80100bea:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bed:	ff 34 b0             	pushl  (%eax,%esi,4)
80100bf0:	e8 1b 3a 00 00       	call   80104610 <strlen>
80100bf5:	83 c0 01             	add    $0x1,%eax
80100bf8:	50                   	push   %eax
80100bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bfc:	ff 34 b0             	pushl  (%eax,%esi,4)
80100bff:	53                   	push   %ebx
80100c00:	57                   	push   %edi
80100c01:	e8 ca 62 00 00       	call   80106ed0 <copyout>
80100c06:	83 c4 20             	add    $0x20,%esp
80100c09:	85 c0                	test   %eax,%eax
80100c0b:	79 ab                	jns    80100bb8 <exec+0x1c8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c0d:	83 ec 0c             	sub    $0xc,%esp
80100c10:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c16:	e8 65 5f 00 00       	call   80106b80 <freevm>
80100c1b:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100c1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c23:	e9 34 fe ff ff       	jmp    80100a5c <exec+0x6c>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100c28:	e8 53 1f 00 00       	call   80102b80 <end_op>
    cprintf("exec: fail\n");
80100c2d:	83 ec 0c             	sub    $0xc,%esp
80100c30:	68 81 70 10 80       	push   $0x80107081
80100c35:	e8 26 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100c3a:	83 c4 10             	add    $0x10,%esp
80100c3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c42:	e9 15 fe ff ff       	jmp    80100a5c <exec+0x6c>
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c47:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100c4e:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c50:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100c57:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100c5b:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c62:	ff ff ff 
  ustack[1] = argc;
80100c65:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c6b:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100c6d:	83 c0 0c             	add    $0xc,%eax
80100c70:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c72:	50                   	push   %eax
80100c73:	52                   	push   %edx
80100c74:	53                   	push   %ebx
80100c75:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c7b:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c81:	e8 4a 62 00 00       	call   80106ed0 <copyout>
80100c86:	83 c4 10             	add    $0x10,%esp
80100c89:	85 c0                	test   %eax,%eax
80100c8b:	78 80                	js     80100c0d <exec+0x21d>
    goto bad;
  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100c8d:	8b 45 08             	mov    0x8(%ebp),%eax
80100c90:	0f b6 10             	movzbl (%eax),%edx
80100c93:	84 d2                	test   %dl,%dl
80100c95:	74 1c                	je     80100cb3 <exec+0x2c3>
80100c97:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100c9a:	83 c0 01             	add    $0x1,%eax
80100c9d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s == '/')
      last = s+1;
80100ca0:	80 fa 2f             	cmp    $0x2f,%dl
  ustack[2] = sp - (argc+1)*4;  // argv pointer
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ca3:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100ca6:	0f 44 c8             	cmove  %eax,%ecx
80100ca9:	83 c0 01             	add    $0x1,%eax
  ustack[2] = sp - (argc+1)*4;  // argv pointer
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cac:	84 d2                	test   %dl,%dl
80100cae:	75 f0                	jne    80100ca0 <exec+0x2b0>
80100cb0:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cb3:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cb9:	83 ec 04             	sub    $0x4,%esp
80100cbc:	6a 10                	push   $0x10
80100cbe:	ff 75 08             	pushl  0x8(%ebp)
80100cc1:	89 f8                	mov    %edi,%eax
80100cc3:	83 c0 6c             	add    $0x6c,%eax
80100cc6:	50                   	push   %eax
80100cc7:	e8 04 39 00 00       	call   801045d0 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100ccc:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100cd2:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100cd5:	8b 47 18             	mov    0x18(%edi),%eax
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100cd8:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100cdb:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100ce1:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100ce3:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100ce9:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100cec:	8b 47 18             	mov    0x18(%edi),%eax
80100cef:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100cf2:	89 3c 24             	mov    %edi,(%esp)
80100cf5:	e8 06 5b 00 00       	call   80106800 <switchuvm>
  freevm(oldpgdir);
80100cfa:	89 34 24             	mov    %esi,(%esp)
80100cfd:	e8 7e 5e 00 00       	call   80106b80 <freevm>
  return 0;
80100d02:	83 c4 10             	add    $0x10,%esp
80100d05:	31 c0                	xor    %eax,%eax
80100d07:	e9 50 fd ff ff       	jmp    80100a5c <exec+0x6c>
80100d0c:	66 90                	xchg   %ax,%ax
80100d0e:	66 90                	xchg   %ax,%ax

80100d10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d10:	55                   	push   %ebp
80100d11:	89 e5                	mov    %esp,%ebp
80100d13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d16:	68 8d 70 10 80       	push   $0x8010708d
80100d1b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d20:	e8 3b 34 00 00       	call   80104160 <initlock>
}
80100d25:	83 c4 10             	add    $0x10,%esp
80100d28:	c9                   	leave  
80100d29:	c3                   	ret    
80100d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d30:	55                   	push   %ebp
80100d31:	89 e5                	mov    %esp,%ebp
80100d33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d34:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d39:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d3c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d41:	e8 1a 35 00 00       	call   80104260 <acquire>
80100d46:	83 c4 10             	add    $0x10,%esp
80100d49:	eb 10                	jmp    80100d5b <filealloc+0x2b>
80100d4b:	90                   	nop
80100d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d50:	83 c3 18             	add    $0x18,%ebx
80100d53:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d59:	74 25                	je     80100d80 <filealloc+0x50>
    if(f->ref == 0){
80100d5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d5e:	85 c0                	test   %eax,%eax
80100d60:	75 ee                	jne    80100d50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100d62:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100d65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100d6c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d71:	e8 0a 36 00 00       	call   80104380 <release>
      return f;
80100d76:	89 d8                	mov    %ebx,%eax
80100d78:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100d7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d7e:	c9                   	leave  
80100d7f:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100d80:	83 ec 0c             	sub    $0xc,%esp
80100d83:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d88:	e8 f3 35 00 00       	call   80104380 <release>
  return 0;
80100d8d:	83 c4 10             	add    $0x10,%esp
80100d90:	31 c0                	xor    %eax,%eax
}
80100d92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d95:	c9                   	leave  
80100d96:	c3                   	ret    
80100d97:	89 f6                	mov    %esi,%esi
80100d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100da0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100da0:	55                   	push   %ebp
80100da1:	89 e5                	mov    %esp,%ebp
80100da3:	53                   	push   %ebx
80100da4:	83 ec 10             	sub    $0x10,%esp
80100da7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100daa:	68 c0 ff 10 80       	push   $0x8010ffc0
80100daf:	e8 ac 34 00 00       	call   80104260 <acquire>
  if(f->ref < 1)
80100db4:	8b 43 04             	mov    0x4(%ebx),%eax
80100db7:	83 c4 10             	add    $0x10,%esp
80100dba:	85 c0                	test   %eax,%eax
80100dbc:	7e 1a                	jle    80100dd8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dbe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100dc1:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100dc4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100dc7:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dcc:	e8 af 35 00 00       	call   80104380 <release>
  return f;
}
80100dd1:	89 d8                	mov    %ebx,%eax
80100dd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dd6:	c9                   	leave  
80100dd7:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100dd8:	83 ec 0c             	sub    $0xc,%esp
80100ddb:	68 94 70 10 80       	push   $0x80107094
80100de0:	e8 8b f5 ff ff       	call   80100370 <panic>
80100de5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100df0 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	57                   	push   %edi
80100df4:	56                   	push   %esi
80100df5:	53                   	push   %ebx
80100df6:	83 ec 28             	sub    $0x28,%esp
80100df9:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100dfc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e01:	e8 5a 34 00 00       	call   80104260 <acquire>
  if(f->ref < 1)
80100e06:	8b 47 04             	mov    0x4(%edi),%eax
80100e09:	83 c4 10             	add    $0x10,%esp
80100e0c:	85 c0                	test   %eax,%eax
80100e0e:	0f 8e 9b 00 00 00    	jle    80100eaf <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e14:	83 e8 01             	sub    $0x1,%eax
80100e17:	85 c0                	test   %eax,%eax
80100e19:	89 47 04             	mov    %eax,0x4(%edi)
80100e1c:	74 1a                	je     80100e38 <fileclose+0x48>
    release(&ftable.lock);
80100e1e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e28:	5b                   	pop    %ebx
80100e29:	5e                   	pop    %esi
80100e2a:	5f                   	pop    %edi
80100e2b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e2c:	e9 4f 35 00 00       	jmp    80104380 <release>
80100e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e38:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e3c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e3e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e41:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e44:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e4a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e4d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e50:	68 c0 ff 10 80       	push   $0x8010ffc0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e55:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e58:	e8 23 35 00 00       	call   80104380 <release>

  if(ff.type == FD_PIPE)
80100e5d:	83 c4 10             	add    $0x10,%esp
80100e60:	83 fb 01             	cmp    $0x1,%ebx
80100e63:	74 13                	je     80100e78 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e65:	83 fb 02             	cmp    $0x2,%ebx
80100e68:	74 26                	je     80100e90 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e6d:	5b                   	pop    %ebx
80100e6e:	5e                   	pop    %esi
80100e6f:	5f                   	pop    %edi
80100e70:	5d                   	pop    %ebp
80100e71:	c3                   	ret    
80100e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100e78:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100e7c:	83 ec 08             	sub    $0x8,%esp
80100e7f:	53                   	push   %ebx
80100e80:	56                   	push   %esi
80100e81:	e8 2a 24 00 00       	call   801032b0 <pipeclose>
80100e86:	83 c4 10             	add    $0x10,%esp
80100e89:	eb df                	jmp    80100e6a <fileclose+0x7a>
80100e8b:	90                   	nop
80100e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100e90:	e8 7b 1c 00 00       	call   80102b10 <begin_op>
    iput(ff.ip);
80100e95:	83 ec 0c             	sub    $0xc,%esp
80100e98:	ff 75 e0             	pushl  -0x20(%ebp)
80100e9b:	e8 c0 08 00 00       	call   80101760 <iput>
    end_op();
80100ea0:	83 c4 10             	add    $0x10,%esp
  }
}
80100ea3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ea6:	5b                   	pop    %ebx
80100ea7:	5e                   	pop    %esi
80100ea8:	5f                   	pop    %edi
80100ea9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100eaa:	e9 d1 1c 00 00       	jmp    80102b80 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100eaf:	83 ec 0c             	sub    $0xc,%esp
80100eb2:	68 9c 70 10 80       	push   $0x8010709c
80100eb7:	e8 b4 f4 ff ff       	call   80100370 <panic>
80100ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	53                   	push   %ebx
80100ec4:	83 ec 04             	sub    $0x4,%esp
80100ec7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100eca:	83 3b 02             	cmpl   $0x2,(%ebx)
80100ecd:	75 31                	jne    80100f00 <filestat+0x40>
    ilock(f->ip);
80100ecf:	83 ec 0c             	sub    $0xc,%esp
80100ed2:	ff 73 10             	pushl  0x10(%ebx)
80100ed5:	e8 56 07 00 00       	call   80101630 <ilock>
    stati(f->ip, st);
80100eda:	58                   	pop    %eax
80100edb:	5a                   	pop    %edx
80100edc:	ff 75 0c             	pushl  0xc(%ebp)
80100edf:	ff 73 10             	pushl  0x10(%ebx)
80100ee2:	e8 f9 09 00 00       	call   801018e0 <stati>
    iunlock(f->ip);
80100ee7:	59                   	pop    %ecx
80100ee8:	ff 73 10             	pushl  0x10(%ebx)
80100eeb:	e8 20 08 00 00       	call   80101710 <iunlock>
    return 0;
80100ef0:	83 c4 10             	add    $0x10,%esp
80100ef3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100ef5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ef8:	c9                   	leave  
80100ef9:	c3                   	ret    
80100efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f08:	c9                   	leave  
80100f09:	c3                   	ret    
80100f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f10 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	57                   	push   %edi
80100f14:	56                   	push   %esi
80100f15:	53                   	push   %ebx
80100f16:	83 ec 0c             	sub    $0xc,%esp
80100f19:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f1c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f1f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f22:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f26:	74 60                	je     80100f88 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f28:	8b 03                	mov    (%ebx),%eax
80100f2a:	83 f8 01             	cmp    $0x1,%eax
80100f2d:	74 41                	je     80100f70 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f2f:	83 f8 02             	cmp    $0x2,%eax
80100f32:	75 5b                	jne    80100f8f <fileread+0x7f>
    ilock(f->ip);
80100f34:	83 ec 0c             	sub    $0xc,%esp
80100f37:	ff 73 10             	pushl  0x10(%ebx)
80100f3a:	e8 f1 06 00 00       	call   80101630 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f3f:	57                   	push   %edi
80100f40:	ff 73 14             	pushl  0x14(%ebx)
80100f43:	56                   	push   %esi
80100f44:	ff 73 10             	pushl  0x10(%ebx)
80100f47:	e8 c4 09 00 00       	call   80101910 <readi>
80100f4c:	83 c4 20             	add    $0x20,%esp
80100f4f:	85 c0                	test   %eax,%eax
80100f51:	89 c6                	mov    %eax,%esi
80100f53:	7e 03                	jle    80100f58 <fileread+0x48>
      f->off += r;
80100f55:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f58:	83 ec 0c             	sub    $0xc,%esp
80100f5b:	ff 73 10             	pushl  0x10(%ebx)
80100f5e:	e8 ad 07 00 00       	call   80101710 <iunlock>
    return r;
80100f63:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f66:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6b:	5b                   	pop    %ebx
80100f6c:	5e                   	pop    %esi
80100f6d:	5f                   	pop    %edi
80100f6e:	5d                   	pop    %ebp
80100f6f:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f70:	8b 43 0c             	mov    0xc(%ebx),%eax
80100f73:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f76:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f79:	5b                   	pop    %ebx
80100f7a:	5e                   	pop    %esi
80100f7b:	5f                   	pop    %edi
80100f7c:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f7d:	e9 ce 24 00 00       	jmp    80103450 <piperead>
80100f82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100f88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f8d:	eb d9                	jmp    80100f68 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100f8f:	83 ec 0c             	sub    $0xc,%esp
80100f92:	68 a6 70 10 80       	push   $0x801070a6
80100f97:	e8 d4 f3 ff ff       	call   80100370 <panic>
80100f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fa0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fa0:	55                   	push   %ebp
80100fa1:	89 e5                	mov    %esp,%ebp
80100fa3:	57                   	push   %edi
80100fa4:	56                   	push   %esi
80100fa5:	53                   	push   %ebx
80100fa6:	83 ec 1c             	sub    $0x1c,%esp
80100fa9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fac:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100faf:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fb3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fb6:	8b 45 10             	mov    0x10(%ebp),%eax
80100fb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100fbc:	0f 84 aa 00 00 00    	je     8010106c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80100fc2:	8b 06                	mov    (%esi),%eax
80100fc4:	83 f8 01             	cmp    $0x1,%eax
80100fc7:	0f 84 c2 00 00 00    	je     8010108f <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fcd:	83 f8 02             	cmp    $0x2,%eax
80100fd0:	0f 85 d8 00 00 00    	jne    801010ae <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100fd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100fd9:	31 ff                	xor    %edi,%edi
80100fdb:	85 c0                	test   %eax,%eax
80100fdd:	7f 34                	jg     80101013 <filewrite+0x73>
80100fdf:	e9 9c 00 00 00       	jmp    80101080 <filewrite+0xe0>
80100fe4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80100fe8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80100feb:	83 ec 0c             	sub    $0xc,%esp
80100fee:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80100ff1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80100ff4:	e8 17 07 00 00       	call   80101710 <iunlock>
      end_op();
80100ff9:	e8 82 1b 00 00       	call   80102b80 <end_op>
80100ffe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101001:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101004:	39 d8                	cmp    %ebx,%eax
80101006:	0f 85 95 00 00 00    	jne    801010a1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010100c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010100e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101011:	7e 6d                	jle    80101080 <filewrite+0xe0>
      int n1 = n - i;
80101013:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101016:	b8 00 1a 00 00       	mov    $0x1a00,%eax
8010101b:	29 fb                	sub    %edi,%ebx
8010101d:	81 fb 00 1a 00 00    	cmp    $0x1a00,%ebx
80101023:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101026:	e8 e5 1a 00 00       	call   80102b10 <begin_op>
      ilock(f->ip);
8010102b:	83 ec 0c             	sub    $0xc,%esp
8010102e:	ff 76 10             	pushl  0x10(%esi)
80101031:	e8 fa 05 00 00       	call   80101630 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101036:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101039:	53                   	push   %ebx
8010103a:	ff 76 14             	pushl  0x14(%esi)
8010103d:	01 f8                	add    %edi,%eax
8010103f:	50                   	push   %eax
80101040:	ff 76 10             	pushl  0x10(%esi)
80101043:	e8 c8 09 00 00       	call   80101a10 <writei>
80101048:	83 c4 20             	add    $0x20,%esp
8010104b:	85 c0                	test   %eax,%eax
8010104d:	7f 99                	jg     80100fe8 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010104f:	83 ec 0c             	sub    $0xc,%esp
80101052:	ff 76 10             	pushl  0x10(%esi)
80101055:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101058:	e8 b3 06 00 00       	call   80101710 <iunlock>
      end_op();
8010105d:	e8 1e 1b 00 00       	call   80102b80 <end_op>

      if(r < 0)
80101062:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101065:	83 c4 10             	add    $0x10,%esp
80101068:	85 c0                	test   %eax,%eax
8010106a:	74 98                	je     80101004 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010106c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010106f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101074:	5b                   	pop    %ebx
80101075:	5e                   	pop    %esi
80101076:	5f                   	pop    %edi
80101077:	5d                   	pop    %ebp
80101078:	c3                   	ret    
80101079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101080:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101083:	75 e7                	jne    8010106c <filewrite+0xcc>
  }
  panic("filewrite");
}
80101085:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101088:	89 f8                	mov    %edi,%eax
8010108a:	5b                   	pop    %ebx
8010108b:	5e                   	pop    %esi
8010108c:	5f                   	pop    %edi
8010108d:	5d                   	pop    %ebp
8010108e:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010108f:	8b 46 0c             	mov    0xc(%esi),%eax
80101092:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80101095:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101098:	5b                   	pop    %ebx
80101099:	5e                   	pop    %esi
8010109a:	5f                   	pop    %edi
8010109b:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010109c:	e9 af 22 00 00       	jmp    80103350 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010a1:	83 ec 0c             	sub    $0xc,%esp
801010a4:	68 af 70 10 80       	push   $0x801070af
801010a9:	e8 c2 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ae:	83 ec 0c             	sub    $0xc,%esp
801010b1:	68 b5 70 10 80       	push   $0x801070b5
801010b6:	e8 b5 f2 ff ff       	call   80100370 <panic>
801010bb:	66 90                	xchg   %ax,%ax
801010bd:	66 90                	xchg   %ax,%ax
801010bf:	90                   	nop

801010c0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010c0:	55                   	push   %ebp
801010c1:	89 e5                	mov    %esp,%ebp
801010c3:	57                   	push   %edi
801010c4:	56                   	push   %esi
801010c5:	53                   	push   %ebx
801010c6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010c9:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010d2:	85 c9                	test   %ecx,%ecx
801010d4:	0f 84 85 00 00 00    	je     8010115f <balloc+0x9f>
801010da:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801010e1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801010e4:	83 ec 08             	sub    $0x8,%esp
801010e7:	89 f0                	mov    %esi,%eax
801010e9:	c1 f8 0c             	sar    $0xc,%eax
801010ec:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801010f2:	50                   	push   %eax
801010f3:	ff 75 d8             	pushl  -0x28(%ebp)
801010f6:	e8 d5 ef ff ff       	call   801000d0 <bread>
801010fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801010fe:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101103:	83 c4 10             	add    $0x10,%esp
80101106:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101109:	31 c0                	xor    %eax,%eax
8010110b:	eb 2d                	jmp    8010113a <balloc+0x7a>
8010110d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101110:	89 c1                	mov    %eax,%ecx
80101112:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101117:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010111a:	83 e1 07             	and    $0x7,%ecx
8010111d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010111f:	89 c1                	mov    %eax,%ecx
80101121:	c1 f9 03             	sar    $0x3,%ecx
80101124:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101129:	85 d7                	test   %edx,%edi
8010112b:	74 43                	je     80101170 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010112d:	83 c0 01             	add    $0x1,%eax
80101130:	83 c6 01             	add    $0x1,%esi
80101133:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101138:	74 05                	je     8010113f <balloc+0x7f>
8010113a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010113d:	72 d1                	jb     80101110 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010113f:	83 ec 0c             	sub    $0xc,%esp
80101142:	ff 75 e4             	pushl  -0x1c(%ebp)
80101145:	e8 96 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010114a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101151:	83 c4 10             	add    $0x10,%esp
80101154:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101157:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010115d:	77 82                	ja     801010e1 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010115f:	83 ec 0c             	sub    $0xc,%esp
80101162:	68 bf 70 10 80       	push   $0x801070bf
80101167:	e8 04 f2 ff ff       	call   80100370 <panic>
8010116c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101170:	09 fa                	or     %edi,%edx
80101172:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101175:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101178:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010117c:	57                   	push   %edi
8010117d:	e8 6e 1b 00 00       	call   80102cf0 <log_write>
        brelse(bp);
80101182:	89 3c 24             	mov    %edi,(%esp)
80101185:	e8 56 f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
8010118a:	58                   	pop    %eax
8010118b:	5a                   	pop    %edx
8010118c:	56                   	push   %esi
8010118d:	ff 75 d8             	pushl  -0x28(%ebp)
80101190:	e8 3b ef ff ff       	call   801000d0 <bread>
80101195:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101197:	8d 40 5c             	lea    0x5c(%eax),%eax
8010119a:	83 c4 0c             	add    $0xc,%esp
8010119d:	68 00 02 00 00       	push   $0x200
801011a2:	6a 00                	push   $0x0
801011a4:	50                   	push   %eax
801011a5:	e8 26 32 00 00       	call   801043d0 <memset>
  log_write(bp);
801011aa:	89 1c 24             	mov    %ebx,(%esp)
801011ad:	e8 3e 1b 00 00       	call   80102cf0 <log_write>
  brelse(bp);
801011b2:	89 1c 24             	mov    %ebx,(%esp)
801011b5:	e8 26 f0 ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801011ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011bd:	89 f0                	mov    %esi,%eax
801011bf:	5b                   	pop    %ebx
801011c0:	5e                   	pop    %esi
801011c1:	5f                   	pop    %edi
801011c2:	5d                   	pop    %ebp
801011c3:	c3                   	ret    
801011c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801011ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801011d0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011d0:	55                   	push   %ebp
801011d1:	89 e5                	mov    %esp,%ebp
801011d3:	57                   	push   %edi
801011d4:	56                   	push   %esi
801011d5:	53                   	push   %ebx
801011d6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801011d8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011da:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011df:	83 ec 28             	sub    $0x28,%esp
801011e2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
801011e5:	68 e0 09 11 80       	push   $0x801109e0
801011ea:	e8 71 30 00 00       	call   80104260 <acquire>
801011ef:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801011f5:	eb 1b                	jmp    80101212 <iget+0x42>
801011f7:	89 f6                	mov    %esi,%esi
801011f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101200:	85 f6                	test   %esi,%esi
80101202:	74 44                	je     80101248 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101204:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010120a:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101210:	74 4e                	je     80101260 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101212:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101215:	85 c9                	test   %ecx,%ecx
80101217:	7e e7                	jle    80101200 <iget+0x30>
80101219:	39 3b                	cmp    %edi,(%ebx)
8010121b:	75 e3                	jne    80101200 <iget+0x30>
8010121d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101220:	75 de                	jne    80101200 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101222:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101225:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101228:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010122a:	68 e0 09 11 80       	push   $0x801109e0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010122f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101232:	e8 49 31 00 00       	call   80104380 <release>
      return ip;
80101237:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010123a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010123d:	89 f0                	mov    %esi,%eax
8010123f:	5b                   	pop    %ebx
80101240:	5e                   	pop    %esi
80101241:	5f                   	pop    %edi
80101242:	5d                   	pop    %ebp
80101243:	c3                   	ret    
80101244:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101248:	85 c9                	test   %ecx,%ecx
8010124a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010124d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101253:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101259:	75 b7                	jne    80101212 <iget+0x42>
8010125b:	90                   	nop
8010125c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101260:	85 f6                	test   %esi,%esi
80101262:	74 2d                	je     80101291 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101264:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101267:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101269:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010126c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101273:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010127a:	68 e0 09 11 80       	push   $0x801109e0
8010127f:	e8 fc 30 00 00       	call   80104380 <release>

  return ip;
80101284:	83 c4 10             	add    $0x10,%esp
}
80101287:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010128a:	89 f0                	mov    %esi,%eax
8010128c:	5b                   	pop    %ebx
8010128d:	5e                   	pop    %esi
8010128e:	5f                   	pop    %edi
8010128f:	5d                   	pop    %ebp
80101290:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
80101291:	83 ec 0c             	sub    $0xc,%esp
80101294:	68 d5 70 10 80       	push   $0x801070d5
80101299:	e8 d2 f0 ff ff       	call   80100370 <panic>
8010129e:	66 90                	xchg   %ax,%ax

801012a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012a0:	55                   	push   %ebp
801012a1:	89 e5                	mov    %esp,%ebp
801012a3:	57                   	push   %edi
801012a4:	56                   	push   %esi
801012a5:	53                   	push   %ebx
801012a6:	89 c6                	mov    %eax,%esi
801012a8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012ab:	83 fa 0b             	cmp    $0xb,%edx
801012ae:	77 18                	ja     801012c8 <bmap+0x28>
801012b0:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
801012b3:	8b 43 5c             	mov    0x5c(%ebx),%eax
801012b6:	85 c0                	test   %eax,%eax
801012b8:	74 76                	je     80101330 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012bd:	5b                   	pop    %ebx
801012be:	5e                   	pop    %esi
801012bf:	5f                   	pop    %edi
801012c0:	5d                   	pop    %ebp
801012c1:	c3                   	ret    
801012c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801012c8:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801012cb:	83 fb 7f             	cmp    $0x7f,%ebx
801012ce:	0f 87 83 00 00 00    	ja     80101357 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801012d4:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801012da:	85 c0                	test   %eax,%eax
801012dc:	74 6a                	je     80101348 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801012de:	83 ec 08             	sub    $0x8,%esp
801012e1:	50                   	push   %eax
801012e2:	ff 36                	pushl  (%esi)
801012e4:	e8 e7 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801012e9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801012ed:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801012f0:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801012f2:	8b 1a                	mov    (%edx),%ebx
801012f4:	85 db                	test   %ebx,%ebx
801012f6:	75 1d                	jne    80101315 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
801012f8:	8b 06                	mov    (%esi),%eax
801012fa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801012fd:	e8 be fd ff ff       	call   801010c0 <balloc>
80101302:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101305:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101308:	89 c3                	mov    %eax,%ebx
8010130a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010130c:	57                   	push   %edi
8010130d:	e8 de 19 00 00       	call   80102cf0 <log_write>
80101312:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101315:	83 ec 0c             	sub    $0xc,%esp
80101318:	57                   	push   %edi
80101319:	e8 c2 ee ff ff       	call   801001e0 <brelse>
8010131e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101321:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101324:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101326:	5b                   	pop    %ebx
80101327:	5e                   	pop    %esi
80101328:	5f                   	pop    %edi
80101329:	5d                   	pop    %ebp
8010132a:	c3                   	ret    
8010132b:	90                   	nop
8010132c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101330:	8b 06                	mov    (%esi),%eax
80101332:	e8 89 fd ff ff       	call   801010c0 <balloc>
80101337:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010133a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010133d:	5b                   	pop    %ebx
8010133e:	5e                   	pop    %esi
8010133f:	5f                   	pop    %edi
80101340:	5d                   	pop    %ebp
80101341:	c3                   	ret    
80101342:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101348:	8b 06                	mov    (%esi),%eax
8010134a:	e8 71 fd ff ff       	call   801010c0 <balloc>
8010134f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101355:	eb 87                	jmp    801012de <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101357:	83 ec 0c             	sub    $0xc,%esp
8010135a:	68 e5 70 10 80       	push   $0x801070e5
8010135f:	e8 0c f0 ff ff       	call   80100370 <panic>
80101364:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010136a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101370 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101370:	55                   	push   %ebp
80101371:	89 e5                	mov    %esp,%ebp
80101373:	56                   	push   %esi
80101374:	53                   	push   %ebx
80101375:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101378:	83 ec 08             	sub    $0x8,%esp
8010137b:	6a 01                	push   $0x1
8010137d:	ff 75 08             	pushl  0x8(%ebp)
80101380:	e8 4b ed ff ff       	call   801000d0 <bread>
80101385:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101387:	8d 40 5c             	lea    0x5c(%eax),%eax
8010138a:	83 c4 0c             	add    $0xc,%esp
8010138d:	6a 1c                	push   $0x1c
8010138f:	50                   	push   %eax
80101390:	56                   	push   %esi
80101391:	e8 ea 30 00 00       	call   80104480 <memmove>
  brelse(bp);
80101396:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101399:	83 c4 10             	add    $0x10,%esp
}
8010139c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010139f:	5b                   	pop    %ebx
801013a0:	5e                   	pop    %esi
801013a1:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013a2:	e9 39 ee ff ff       	jmp    801001e0 <brelse>
801013a7:	89 f6                	mov    %esi,%esi
801013a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	56                   	push   %esi
801013b4:	53                   	push   %ebx
801013b5:	89 d3                	mov    %edx,%ebx
801013b7:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013b9:	83 ec 08             	sub    $0x8,%esp
801013bc:	68 c0 09 11 80       	push   $0x801109c0
801013c1:	50                   	push   %eax
801013c2:	e8 a9 ff ff ff       	call   80101370 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801013c7:	58                   	pop    %eax
801013c8:	5a                   	pop    %edx
801013c9:	89 da                	mov    %ebx,%edx
801013cb:	c1 ea 0c             	shr    $0xc,%edx
801013ce:	03 15 d8 09 11 80    	add    0x801109d8,%edx
801013d4:	52                   	push   %edx
801013d5:	56                   	push   %esi
801013d6:	e8 f5 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801013db:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801013dd:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
801013e3:	ba 01 00 00 00       	mov    $0x1,%edx
801013e8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801013eb:	c1 fb 03             	sar    $0x3,%ebx
801013ee:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
801013f1:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801013f3:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801013f8:	85 d1                	test   %edx,%ecx
801013fa:	74 27                	je     80101423 <bfree+0x73>
801013fc:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801013fe:	f7 d2                	not    %edx
80101400:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101402:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101405:	21 d0                	and    %edx,%eax
80101407:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010140b:	56                   	push   %esi
8010140c:	e8 df 18 00 00       	call   80102cf0 <log_write>
  brelse(bp);
80101411:	89 34 24             	mov    %esi,(%esp)
80101414:	e8 c7 ed ff ff       	call   801001e0 <brelse>
}
80101419:	83 c4 10             	add    $0x10,%esp
8010141c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010141f:	5b                   	pop    %ebx
80101420:	5e                   	pop    %esi
80101421:	5d                   	pop    %ebp
80101422:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101423:	83 ec 0c             	sub    $0xc,%esp
80101426:	68 f8 70 10 80       	push   $0x801070f8
8010142b:	e8 40 ef ff ff       	call   80100370 <panic>

80101430 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	53                   	push   %ebx
80101434:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101439:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010143c:	68 0b 71 10 80       	push   $0x8010710b
80101441:	68 e0 09 11 80       	push   $0x801109e0
80101446:	e8 15 2d 00 00       	call   80104160 <initlock>
8010144b:	83 c4 10             	add    $0x10,%esp
8010144e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101450:	83 ec 08             	sub    $0x8,%esp
80101453:	68 12 71 10 80       	push   $0x80107112
80101458:	53                   	push   %ebx
80101459:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010145f:	e8 ec 2b 00 00       	call   80104050 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101464:	83 c4 10             	add    $0x10,%esp
80101467:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010146d:	75 e1                	jne    80101450 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
8010146f:	83 ec 08             	sub    $0x8,%esp
80101472:	68 c0 09 11 80       	push   $0x801109c0
80101477:	ff 75 08             	pushl  0x8(%ebp)
8010147a:	e8 f1 fe ff ff       	call   80101370 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010147f:	ff 35 d8 09 11 80    	pushl  0x801109d8
80101485:	ff 35 d4 09 11 80    	pushl  0x801109d4
8010148b:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101491:	ff 35 cc 09 11 80    	pushl  0x801109cc
80101497:	ff 35 c8 09 11 80    	pushl  0x801109c8
8010149d:	ff 35 c4 09 11 80    	pushl  0x801109c4
801014a3:	ff 35 c0 09 11 80    	pushl  0x801109c0
801014a9:	68 78 71 10 80       	push   $0x80107178
801014ae:	e8 ad f1 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801014b3:	83 c4 30             	add    $0x30,%esp
801014b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014b9:	c9                   	leave  
801014ba:	c3                   	ret    
801014bb:	90                   	nop
801014bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801014c0 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	57                   	push   %edi
801014c4:	56                   	push   %esi
801014c5:	53                   	push   %ebx
801014c6:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014c9:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801014d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801014d3:	8b 75 08             	mov    0x8(%ebp),%esi
801014d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014d9:	0f 86 91 00 00 00    	jbe    80101570 <ialloc+0xb0>
801014df:	bb 01 00 00 00       	mov    $0x1,%ebx
801014e4:	eb 21                	jmp    80101507 <ialloc+0x47>
801014e6:	8d 76 00             	lea    0x0(%esi),%esi
801014e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801014f0:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014f3:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
801014f6:	57                   	push   %edi
801014f7:	e8 e4 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014fc:	83 c4 10             	add    $0x10,%esp
801014ff:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101505:	76 69                	jbe    80101570 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101507:	89 d8                	mov    %ebx,%eax
80101509:	83 ec 08             	sub    $0x8,%esp
8010150c:	c1 e8 03             	shr    $0x3,%eax
8010150f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101515:	50                   	push   %eax
80101516:	56                   	push   %esi
80101517:	e8 b4 eb ff ff       	call   801000d0 <bread>
8010151c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010151e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101520:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101523:	83 e0 07             	and    $0x7,%eax
80101526:	c1 e0 06             	shl    $0x6,%eax
80101529:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010152d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101531:	75 bd                	jne    801014f0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101533:	83 ec 04             	sub    $0x4,%esp
80101536:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101539:	6a 40                	push   $0x40
8010153b:	6a 00                	push   $0x0
8010153d:	51                   	push   %ecx
8010153e:	e8 8d 2e 00 00       	call   801043d0 <memset>
      dip->type = type;
80101543:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101547:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010154a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010154d:	89 3c 24             	mov    %edi,(%esp)
80101550:	e8 9b 17 00 00       	call   80102cf0 <log_write>
      brelse(bp);
80101555:	89 3c 24             	mov    %edi,(%esp)
80101558:	e8 83 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010155d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101560:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101563:	89 da                	mov    %ebx,%edx
80101565:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101567:	5b                   	pop    %ebx
80101568:	5e                   	pop    %esi
80101569:	5f                   	pop    %edi
8010156a:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010156b:	e9 60 fc ff ff       	jmp    801011d0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101570:	83 ec 0c             	sub    $0xc,%esp
80101573:	68 18 71 10 80       	push   $0x80107118
80101578:	e8 f3 ed ff ff       	call   80100370 <panic>
8010157d:	8d 76 00             	lea    0x0(%esi),%esi

80101580 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	56                   	push   %esi
80101584:	53                   	push   %ebx
80101585:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101588:	83 ec 08             	sub    $0x8,%esp
8010158b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010158e:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101591:	c1 e8 03             	shr    $0x3,%eax
80101594:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010159a:	50                   	push   %eax
8010159b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010159e:	e8 2d eb ff ff       	call   801000d0 <bread>
801015a3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015a5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015a8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ac:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015af:	83 e0 07             	and    $0x7,%eax
801015b2:	c1 e0 06             	shl    $0x6,%eax
801015b5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801015b9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801015bc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015c0:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
801015c3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801015c7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801015cb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801015cf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801015d3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801015d7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801015da:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015dd:	6a 34                	push   $0x34
801015df:	53                   	push   %ebx
801015e0:	50                   	push   %eax
801015e1:	e8 9a 2e 00 00       	call   80104480 <memmove>
  log_write(bp);
801015e6:	89 34 24             	mov    %esi,(%esp)
801015e9:	e8 02 17 00 00       	call   80102cf0 <log_write>
  brelse(bp);
801015ee:	89 75 08             	mov    %esi,0x8(%ebp)
801015f1:	83 c4 10             	add    $0x10,%esp
}
801015f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015f7:	5b                   	pop    %ebx
801015f8:	5e                   	pop    %esi
801015f9:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
801015fa:	e9 e1 eb ff ff       	jmp    801001e0 <brelse>
801015ff:	90                   	nop

80101600 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	53                   	push   %ebx
80101604:	83 ec 10             	sub    $0x10,%esp
80101607:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010160a:	68 e0 09 11 80       	push   $0x801109e0
8010160f:	e8 4c 2c 00 00       	call   80104260 <acquire>
  ip->ref++;
80101614:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101618:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010161f:	e8 5c 2d 00 00       	call   80104380 <release>
  return ip;
}
80101624:	89 d8                	mov    %ebx,%eax
80101626:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101629:	c9                   	leave  
8010162a:	c3                   	ret    
8010162b:	90                   	nop
8010162c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101630 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	56                   	push   %esi
80101634:	53                   	push   %ebx
80101635:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101638:	85 db                	test   %ebx,%ebx
8010163a:	0f 84 b7 00 00 00    	je     801016f7 <ilock+0xc7>
80101640:	8b 53 08             	mov    0x8(%ebx),%edx
80101643:	85 d2                	test   %edx,%edx
80101645:	0f 8e ac 00 00 00    	jle    801016f7 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
8010164b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010164e:	83 ec 0c             	sub    $0xc,%esp
80101651:	50                   	push   %eax
80101652:	e8 39 2a 00 00       	call   80104090 <acquiresleep>

  if(ip->valid == 0){
80101657:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010165a:	83 c4 10             	add    $0x10,%esp
8010165d:	85 c0                	test   %eax,%eax
8010165f:	74 0f                	je     80101670 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101661:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101664:	5b                   	pop    %ebx
80101665:	5e                   	pop    %esi
80101666:	5d                   	pop    %ebp
80101667:	c3                   	ret    
80101668:	90                   	nop
80101669:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101670:	8b 43 04             	mov    0x4(%ebx),%eax
80101673:	83 ec 08             	sub    $0x8,%esp
80101676:	c1 e8 03             	shr    $0x3,%eax
80101679:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010167f:	50                   	push   %eax
80101680:	ff 33                	pushl  (%ebx)
80101682:	e8 49 ea ff ff       	call   801000d0 <bread>
80101687:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101689:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010168c:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010168f:	83 e0 07             	and    $0x7,%eax
80101692:	c1 e0 06             	shl    $0x6,%eax
80101695:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101699:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010169c:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
8010169f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016a3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016a7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016ab:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016af:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801016b3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801016b7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801016bb:	8b 50 fc             	mov    -0x4(%eax),%edx
801016be:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016c1:	6a 34                	push   $0x34
801016c3:	50                   	push   %eax
801016c4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801016c7:	50                   	push   %eax
801016c8:	e8 b3 2d 00 00       	call   80104480 <memmove>
    brelse(bp);
801016cd:	89 34 24             	mov    %esi,(%esp)
801016d0:	e8 0b eb ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
801016d5:	83 c4 10             	add    $0x10,%esp
801016d8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
801016dd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801016e4:	0f 85 77 ff ff ff    	jne    80101661 <ilock+0x31>
      panic("ilock: no type");
801016ea:	83 ec 0c             	sub    $0xc,%esp
801016ed:	68 30 71 10 80       	push   $0x80107130
801016f2:	e8 79 ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
801016f7:	83 ec 0c             	sub    $0xc,%esp
801016fa:	68 2a 71 10 80       	push   $0x8010712a
801016ff:	e8 6c ec ff ff       	call   80100370 <panic>
80101704:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010170a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101710 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101710:	55                   	push   %ebp
80101711:	89 e5                	mov    %esp,%ebp
80101713:	56                   	push   %esi
80101714:	53                   	push   %ebx
80101715:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101718:	85 db                	test   %ebx,%ebx
8010171a:	74 28                	je     80101744 <iunlock+0x34>
8010171c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010171f:	83 ec 0c             	sub    $0xc,%esp
80101722:	56                   	push   %esi
80101723:	e8 08 2a 00 00       	call   80104130 <holdingsleep>
80101728:	83 c4 10             	add    $0x10,%esp
8010172b:	85 c0                	test   %eax,%eax
8010172d:	74 15                	je     80101744 <iunlock+0x34>
8010172f:	8b 43 08             	mov    0x8(%ebx),%eax
80101732:	85 c0                	test   %eax,%eax
80101734:	7e 0e                	jle    80101744 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101736:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101739:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010173c:	5b                   	pop    %ebx
8010173d:	5e                   	pop    %esi
8010173e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010173f:	e9 ac 29 00 00       	jmp    801040f0 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101744:	83 ec 0c             	sub    $0xc,%esp
80101747:	68 3f 71 10 80       	push   $0x8010713f
8010174c:	e8 1f ec ff ff       	call   80100370 <panic>
80101751:	eb 0d                	jmp    80101760 <iput>
80101753:	90                   	nop
80101754:	90                   	nop
80101755:	90                   	nop
80101756:	90                   	nop
80101757:	90                   	nop
80101758:	90                   	nop
80101759:	90                   	nop
8010175a:	90                   	nop
8010175b:	90                   	nop
8010175c:	90                   	nop
8010175d:	90                   	nop
8010175e:	90                   	nop
8010175f:	90                   	nop

80101760 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	57                   	push   %edi
80101764:	56                   	push   %esi
80101765:	53                   	push   %ebx
80101766:	83 ec 28             	sub    $0x28,%esp
80101769:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
8010176c:	8d 7e 0c             	lea    0xc(%esi),%edi
8010176f:	57                   	push   %edi
80101770:	e8 1b 29 00 00       	call   80104090 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101775:	8b 56 4c             	mov    0x4c(%esi),%edx
80101778:	83 c4 10             	add    $0x10,%esp
8010177b:	85 d2                	test   %edx,%edx
8010177d:	74 07                	je     80101786 <iput+0x26>
8010177f:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101784:	74 32                	je     801017b8 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
80101786:	83 ec 0c             	sub    $0xc,%esp
80101789:	57                   	push   %edi
8010178a:	e8 61 29 00 00       	call   801040f0 <releasesleep>

  acquire(&icache.lock);
8010178f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101796:	e8 c5 2a 00 00       	call   80104260 <acquire>
  ip->ref--;
8010179b:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010179f:	83 c4 10             	add    $0x10,%esp
801017a2:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801017a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017ac:	5b                   	pop    %ebx
801017ad:	5e                   	pop    %esi
801017ae:	5f                   	pop    %edi
801017af:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
801017b0:	e9 cb 2b 00 00       	jmp    80104380 <release>
801017b5:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
801017b8:	83 ec 0c             	sub    $0xc,%esp
801017bb:	68 e0 09 11 80       	push   $0x801109e0
801017c0:	e8 9b 2a 00 00       	call   80104260 <acquire>
    int r = ip->ref;
801017c5:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
801017c8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017cf:	e8 ac 2b 00 00       	call   80104380 <release>
    if(r == 1){
801017d4:	83 c4 10             	add    $0x10,%esp
801017d7:	83 fb 01             	cmp    $0x1,%ebx
801017da:	75 aa                	jne    80101786 <iput+0x26>
801017dc:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
801017e2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801017e5:	8d 5e 5c             	lea    0x5c(%esi),%ebx
801017e8:	89 cf                	mov    %ecx,%edi
801017ea:	eb 0b                	jmp    801017f7 <iput+0x97>
801017ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017f0:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801017f3:	39 fb                	cmp    %edi,%ebx
801017f5:	74 19                	je     80101810 <iput+0xb0>
    if(ip->addrs[i]){
801017f7:	8b 13                	mov    (%ebx),%edx
801017f9:	85 d2                	test   %edx,%edx
801017fb:	74 f3                	je     801017f0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801017fd:	8b 06                	mov    (%esi),%eax
801017ff:	e8 ac fb ff ff       	call   801013b0 <bfree>
      ip->addrs[i] = 0;
80101804:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010180a:	eb e4                	jmp    801017f0 <iput+0x90>
8010180c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101810:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101816:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101819:	85 c0                	test   %eax,%eax
8010181b:	75 33                	jne    80101850 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010181d:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101820:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101827:	56                   	push   %esi
80101828:	e8 53 fd ff ff       	call   80101580 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010182d:	31 c0                	xor    %eax,%eax
8010182f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101833:	89 34 24             	mov    %esi,(%esp)
80101836:	e8 45 fd ff ff       	call   80101580 <iupdate>
      ip->valid = 0;
8010183b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101842:	83 c4 10             	add    $0x10,%esp
80101845:	e9 3c ff ff ff       	jmp    80101786 <iput+0x26>
8010184a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101850:	83 ec 08             	sub    $0x8,%esp
80101853:	50                   	push   %eax
80101854:	ff 36                	pushl  (%esi)
80101856:	e8 75 e8 ff ff       	call   801000d0 <bread>
8010185b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101861:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101864:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101867:	8d 58 5c             	lea    0x5c(%eax),%ebx
8010186a:	83 c4 10             	add    $0x10,%esp
8010186d:	89 cf                	mov    %ecx,%edi
8010186f:	eb 0e                	jmp    8010187f <iput+0x11f>
80101871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101878:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
8010187b:	39 fb                	cmp    %edi,%ebx
8010187d:	74 0f                	je     8010188e <iput+0x12e>
      if(a[j])
8010187f:	8b 13                	mov    (%ebx),%edx
80101881:	85 d2                	test   %edx,%edx
80101883:	74 f3                	je     80101878 <iput+0x118>
        bfree(ip->dev, a[j]);
80101885:	8b 06                	mov    (%esi),%eax
80101887:	e8 24 fb ff ff       	call   801013b0 <bfree>
8010188c:	eb ea                	jmp    80101878 <iput+0x118>
    }
    brelse(bp);
8010188e:	83 ec 0c             	sub    $0xc,%esp
80101891:	ff 75 e4             	pushl  -0x1c(%ebp)
80101894:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101897:	e8 44 e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010189c:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018a2:	8b 06                	mov    (%esi),%eax
801018a4:	e8 07 fb ff ff       	call   801013b0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018a9:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018b0:	00 00 00 
801018b3:	83 c4 10             	add    $0x10,%esp
801018b6:	e9 62 ff ff ff       	jmp    8010181d <iput+0xbd>
801018bb:	90                   	nop
801018bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018c0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
801018c0:	55                   	push   %ebp
801018c1:	89 e5                	mov    %esp,%ebp
801018c3:	53                   	push   %ebx
801018c4:	83 ec 10             	sub    $0x10,%esp
801018c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801018ca:	53                   	push   %ebx
801018cb:	e8 40 fe ff ff       	call   80101710 <iunlock>
  iput(ip);
801018d0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801018d3:	83 c4 10             	add    $0x10,%esp
}
801018d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018d9:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
801018da:	e9 81 fe ff ff       	jmp    80101760 <iput>
801018df:	90                   	nop

801018e0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801018e0:	55                   	push   %ebp
801018e1:	89 e5                	mov    %esp,%ebp
801018e3:	8b 55 08             	mov    0x8(%ebp),%edx
801018e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801018e9:	8b 0a                	mov    (%edx),%ecx
801018eb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801018ee:	8b 4a 04             	mov    0x4(%edx),%ecx
801018f1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801018f4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801018f8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801018fb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801018ff:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101903:	8b 52 58             	mov    0x58(%edx),%edx
80101906:	89 50 10             	mov    %edx,0x10(%eax)
}
80101909:	5d                   	pop    %ebp
8010190a:	c3                   	ret    
8010190b:	90                   	nop
8010190c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101910 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	57                   	push   %edi
80101914:	56                   	push   %esi
80101915:	53                   	push   %ebx
80101916:	83 ec 1c             	sub    $0x1c,%esp
80101919:	8b 45 08             	mov    0x8(%ebp),%eax
8010191c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010191f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101922:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101927:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010192a:	8b 7d 14             	mov    0x14(%ebp),%edi
8010192d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101930:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101933:	0f 84 a7 00 00 00    	je     801019e0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101939:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010193c:	8b 40 58             	mov    0x58(%eax),%eax
8010193f:	39 f0                	cmp    %esi,%eax
80101941:	0f 82 c1 00 00 00    	jb     80101a08 <readi+0xf8>
80101947:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010194a:	89 fa                	mov    %edi,%edx
8010194c:	01 f2                	add    %esi,%edx
8010194e:	0f 82 b4 00 00 00    	jb     80101a08 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101954:	89 c1                	mov    %eax,%ecx
80101956:	29 f1                	sub    %esi,%ecx
80101958:	39 d0                	cmp    %edx,%eax
8010195a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010195d:	31 ff                	xor    %edi,%edi
8010195f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101961:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101964:	74 6d                	je     801019d3 <readi+0xc3>
80101966:	8d 76 00             	lea    0x0(%esi),%esi
80101969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101970:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101973:	89 f2                	mov    %esi,%edx
80101975:	c1 ea 09             	shr    $0x9,%edx
80101978:	89 d8                	mov    %ebx,%eax
8010197a:	e8 21 f9 ff ff       	call   801012a0 <bmap>
8010197f:	83 ec 08             	sub    $0x8,%esp
80101982:	50                   	push   %eax
80101983:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
80101985:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010198a:	e8 41 e7 ff ff       	call   801000d0 <bread>
8010198f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101991:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101994:	89 f1                	mov    %esi,%ecx
80101996:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
8010199c:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
8010199f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019a2:	29 cb                	sub    %ecx,%ebx
801019a4:	29 f8                	sub    %edi,%eax
801019a6:	39 c3                	cmp    %eax,%ebx
801019a8:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019ab:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
801019af:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019b0:	01 df                	add    %ebx,%edi
801019b2:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
801019b4:	50                   	push   %eax
801019b5:	ff 75 e0             	pushl  -0x20(%ebp)
801019b8:	e8 c3 2a 00 00       	call   80104480 <memmove>
    brelse(bp);
801019bd:	8b 55 dc             	mov    -0x24(%ebp),%edx
801019c0:	89 14 24             	mov    %edx,(%esp)
801019c3:	e8 18 e8 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019c8:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019cb:	83 c4 10             	add    $0x10,%esp
801019ce:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801019d1:	77 9d                	ja     80101970 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
801019d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801019d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019d9:	5b                   	pop    %ebx
801019da:	5e                   	pop    %esi
801019db:	5f                   	pop    %edi
801019dc:	5d                   	pop    %ebp
801019dd:	c3                   	ret    
801019de:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801019e0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801019e4:	66 83 f8 09          	cmp    $0x9,%ax
801019e8:	77 1e                	ja     80101a08 <readi+0xf8>
801019ea:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
801019f1:	85 c0                	test   %eax,%eax
801019f3:	74 13                	je     80101a08 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
801019f5:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
801019f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019fb:	5b                   	pop    %ebx
801019fc:	5e                   	pop    %esi
801019fd:	5f                   	pop    %edi
801019fe:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
801019ff:	ff e0                	jmp    *%eax
80101a01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a0d:	eb c7                	jmp    801019d6 <readi+0xc6>
80101a0f:	90                   	nop

80101a10 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a10:	55                   	push   %ebp
80101a11:	89 e5                	mov    %esp,%ebp
80101a13:	57                   	push   %edi
80101a14:	56                   	push   %esi
80101a15:	53                   	push   %ebx
80101a16:	83 ec 1c             	sub    $0x1c,%esp
80101a19:	8b 45 08             	mov    0x8(%ebp),%eax
80101a1c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a1f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a22:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a27:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a2d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a30:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a33:	0f 84 b7 00 00 00    	je     80101af0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a3c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a3f:	0f 82 eb 00 00 00    	jb     80101b30 <writei+0x120>
80101a45:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a48:	89 f8                	mov    %edi,%eax
80101a4a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a4c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a51:	0f 87 d9 00 00 00    	ja     80101b30 <writei+0x120>
80101a57:	39 c6                	cmp    %eax,%esi
80101a59:	0f 87 d1 00 00 00    	ja     80101b30 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a5f:	85 ff                	test   %edi,%edi
80101a61:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101a68:	74 78                	je     80101ae2 <writei+0xd2>
80101a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a70:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101a73:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a75:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a7a:	c1 ea 09             	shr    $0x9,%edx
80101a7d:	89 f8                	mov    %edi,%eax
80101a7f:	e8 1c f8 ff ff       	call   801012a0 <bmap>
80101a84:	83 ec 08             	sub    $0x8,%esp
80101a87:	50                   	push   %eax
80101a88:	ff 37                	pushl  (%edi)
80101a8a:	e8 41 e6 ff ff       	call   801000d0 <bread>
80101a8f:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101a91:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a94:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101a97:	89 f1                	mov    %esi,%ecx
80101a99:	83 c4 0c             	add    $0xc,%esp
80101a9c:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101aa2:	29 cb                	sub    %ecx,%ebx
80101aa4:	39 c3                	cmp    %eax,%ebx
80101aa6:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101aa9:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101aad:	53                   	push   %ebx
80101aae:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ab1:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101ab3:	50                   	push   %eax
80101ab4:	e8 c7 29 00 00       	call   80104480 <memmove>
    log_write(bp);
80101ab9:	89 3c 24             	mov    %edi,(%esp)
80101abc:	e8 2f 12 00 00       	call   80102cf0 <log_write>
    brelse(bp);
80101ac1:	89 3c 24             	mov    %edi,(%esp)
80101ac4:	e8 17 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ac9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101acc:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101acf:	83 c4 10             	add    $0x10,%esp
80101ad2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ad5:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101ad8:	77 96                	ja     80101a70 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101ada:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101add:	3b 70 58             	cmp    0x58(%eax),%esi
80101ae0:	77 36                	ja     80101b18 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101ae2:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ae5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ae8:	5b                   	pop    %ebx
80101ae9:	5e                   	pop    %esi
80101aea:	5f                   	pop    %edi
80101aeb:	5d                   	pop    %ebp
80101aec:	c3                   	ret    
80101aed:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101af0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101af4:	66 83 f8 09          	cmp    $0x9,%ax
80101af8:	77 36                	ja     80101b30 <writei+0x120>
80101afa:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b01:	85 c0                	test   %eax,%eax
80101b03:	74 2b                	je     80101b30 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b05:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
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
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b0f:	ff e0                	jmp    *%eax
80101b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b18:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b1b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b1e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b21:	50                   	push   %eax
80101b22:	e8 59 fa ff ff       	call   80101580 <iupdate>
80101b27:	83 c4 10             	add    $0x10,%esp
80101b2a:	eb b6                	jmp    80101ae2 <writei+0xd2>
80101b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b35:	eb ae                	jmp    80101ae5 <writei+0xd5>
80101b37:	89 f6                	mov    %esi,%esi
80101b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b40 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b40:	55                   	push   %ebp
80101b41:	89 e5                	mov    %esp,%ebp
80101b43:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b46:	6a 0e                	push   $0xe
80101b48:	ff 75 0c             	pushl  0xc(%ebp)
80101b4b:	ff 75 08             	pushl  0x8(%ebp)
80101b4e:	e8 ad 29 00 00       	call   80104500 <strncmp>
}
80101b53:	c9                   	leave  
80101b54:	c3                   	ret    
80101b55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b60 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101b60:	55                   	push   %ebp
80101b61:	89 e5                	mov    %esp,%ebp
80101b63:	57                   	push   %edi
80101b64:	56                   	push   %esi
80101b65:	53                   	push   %ebx
80101b66:	83 ec 1c             	sub    $0x1c,%esp
80101b69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101b6c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101b71:	0f 85 80 00 00 00    	jne    80101bf7 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101b77:	8b 53 58             	mov    0x58(%ebx),%edx
80101b7a:	31 ff                	xor    %edi,%edi
80101b7c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101b7f:	85 d2                	test   %edx,%edx
80101b81:	75 0d                	jne    80101b90 <dirlookup+0x30>
80101b83:	eb 5b                	jmp    80101be0 <dirlookup+0x80>
80101b85:	8d 76 00             	lea    0x0(%esi),%esi
80101b88:	83 c7 10             	add    $0x10,%edi
80101b8b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101b8e:	76 50                	jbe    80101be0 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101b90:	6a 10                	push   $0x10
80101b92:	57                   	push   %edi
80101b93:	56                   	push   %esi
80101b94:	53                   	push   %ebx
80101b95:	e8 76 fd ff ff       	call   80101910 <readi>
80101b9a:	83 c4 10             	add    $0x10,%esp
80101b9d:	83 f8 10             	cmp    $0x10,%eax
80101ba0:	75 48                	jne    80101bea <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101ba2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101ba7:	74 df                	je     80101b88 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101ba9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bac:	83 ec 04             	sub    $0x4,%esp
80101baf:	6a 0e                	push   $0xe
80101bb1:	50                   	push   %eax
80101bb2:	ff 75 0c             	pushl  0xc(%ebp)
80101bb5:	e8 46 29 00 00       	call   80104500 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101bba:	83 c4 10             	add    $0x10,%esp
80101bbd:	85 c0                	test   %eax,%eax
80101bbf:	75 c7                	jne    80101b88 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101bc1:	8b 45 10             	mov    0x10(%ebp),%eax
80101bc4:	85 c0                	test   %eax,%eax
80101bc6:	74 05                	je     80101bcd <dirlookup+0x6d>
        *poff = off;
80101bc8:	8b 45 10             	mov    0x10(%ebp),%eax
80101bcb:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101bcd:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101bd1:	8b 03                	mov    (%ebx),%eax
80101bd3:	e8 f8 f5 ff ff       	call   801011d0 <iget>
    }
  }

  return 0;
}
80101bd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bdb:	5b                   	pop    %ebx
80101bdc:	5e                   	pop    %esi
80101bdd:	5f                   	pop    %edi
80101bde:	5d                   	pop    %ebp
80101bdf:	c3                   	ret    
80101be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101be3:	31 c0                	xor    %eax,%eax
}
80101be5:	5b                   	pop    %ebx
80101be6:	5e                   	pop    %esi
80101be7:	5f                   	pop    %edi
80101be8:	5d                   	pop    %ebp
80101be9:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101bea:	83 ec 0c             	sub    $0xc,%esp
80101bed:	68 59 71 10 80       	push   $0x80107159
80101bf2:	e8 79 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101bf7:	83 ec 0c             	sub    $0xc,%esp
80101bfa:	68 47 71 10 80       	push   $0x80107147
80101bff:	e8 6c e7 ff ff       	call   80100370 <panic>
80101c04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101c10 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c10:	55                   	push   %ebp
80101c11:	89 e5                	mov    %esp,%ebp
80101c13:	57                   	push   %edi
80101c14:	56                   	push   %esi
80101c15:	53                   	push   %ebx
80101c16:	89 cf                	mov    %ecx,%edi
80101c18:	89 c3                	mov    %eax,%ebx
80101c1a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c1d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c20:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c23:	0f 84 53 01 00 00    	je     80101d7c <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c29:	e8 12 1b 00 00       	call   80103740 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c2e:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c31:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c34:	68 e0 09 11 80       	push   $0x801109e0
80101c39:	e8 22 26 00 00       	call   80104260 <acquire>
  ip->ref++;
80101c3e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c42:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101c49:	e8 32 27 00 00       	call   80104380 <release>
80101c4e:	83 c4 10             	add    $0x10,%esp
80101c51:	eb 08                	jmp    80101c5b <namex+0x4b>
80101c53:	90                   	nop
80101c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101c58:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101c5b:	0f b6 03             	movzbl (%ebx),%eax
80101c5e:	3c 2f                	cmp    $0x2f,%al
80101c60:	74 f6                	je     80101c58 <namex+0x48>
    path++;
  if(*path == 0)
80101c62:	84 c0                	test   %al,%al
80101c64:	0f 84 e3 00 00 00    	je     80101d4d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101c6a:	0f b6 03             	movzbl (%ebx),%eax
80101c6d:	89 da                	mov    %ebx,%edx
80101c6f:	84 c0                	test   %al,%al
80101c71:	0f 84 ac 00 00 00    	je     80101d23 <namex+0x113>
80101c77:	3c 2f                	cmp    $0x2f,%al
80101c79:	75 09                	jne    80101c84 <namex+0x74>
80101c7b:	e9 a3 00 00 00       	jmp    80101d23 <namex+0x113>
80101c80:	84 c0                	test   %al,%al
80101c82:	74 0a                	je     80101c8e <namex+0x7e>
    path++;
80101c84:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101c87:	0f b6 02             	movzbl (%edx),%eax
80101c8a:	3c 2f                	cmp    $0x2f,%al
80101c8c:	75 f2                	jne    80101c80 <namex+0x70>
80101c8e:	89 d1                	mov    %edx,%ecx
80101c90:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101c92:	83 f9 0d             	cmp    $0xd,%ecx
80101c95:	0f 8e 8d 00 00 00    	jle    80101d28 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101c9b:	83 ec 04             	sub    $0x4,%esp
80101c9e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101ca1:	6a 0e                	push   $0xe
80101ca3:	53                   	push   %ebx
80101ca4:	57                   	push   %edi
80101ca5:	e8 d6 27 00 00       	call   80104480 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101caa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101cad:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cb0:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101cb2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101cb5:	75 11                	jne    80101cc8 <namex+0xb8>
80101cb7:	89 f6                	mov    %esi,%esi
80101cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101cc0:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101cc3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101cc6:	74 f8                	je     80101cc0 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101cc8:	83 ec 0c             	sub    $0xc,%esp
80101ccb:	56                   	push   %esi
80101ccc:	e8 5f f9 ff ff       	call   80101630 <ilock>
    if(ip->type != T_DIR){
80101cd1:	83 c4 10             	add    $0x10,%esp
80101cd4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101cd9:	0f 85 7f 00 00 00    	jne    80101d5e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101cdf:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ce2:	85 d2                	test   %edx,%edx
80101ce4:	74 09                	je     80101cef <namex+0xdf>
80101ce6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ce9:	0f 84 a3 00 00 00    	je     80101d92 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101cef:	83 ec 04             	sub    $0x4,%esp
80101cf2:	6a 00                	push   $0x0
80101cf4:	57                   	push   %edi
80101cf5:	56                   	push   %esi
80101cf6:	e8 65 fe ff ff       	call   80101b60 <dirlookup>
80101cfb:	83 c4 10             	add    $0x10,%esp
80101cfe:	85 c0                	test   %eax,%eax
80101d00:	74 5c                	je     80101d5e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d02:	83 ec 0c             	sub    $0xc,%esp
80101d05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d08:	56                   	push   %esi
80101d09:	e8 02 fa ff ff       	call   80101710 <iunlock>
  iput(ip);
80101d0e:	89 34 24             	mov    %esi,(%esp)
80101d11:	e8 4a fa ff ff       	call   80101760 <iput>
80101d16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d19:	83 c4 10             	add    $0x10,%esp
80101d1c:	89 c6                	mov    %eax,%esi
80101d1e:	e9 38 ff ff ff       	jmp    80101c5b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d23:	31 c9                	xor    %ecx,%ecx
80101d25:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d28:	83 ec 04             	sub    $0x4,%esp
80101d2b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d2e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d31:	51                   	push   %ecx
80101d32:	53                   	push   %ebx
80101d33:	57                   	push   %edi
80101d34:	e8 47 27 00 00       	call   80104480 <memmove>
    name[len] = 0;
80101d39:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d3c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d3f:	83 c4 10             	add    $0x10,%esp
80101d42:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d46:	89 d3                	mov    %edx,%ebx
80101d48:	e9 65 ff ff ff       	jmp    80101cb2 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d50:	85 c0                	test   %eax,%eax
80101d52:	75 54                	jne    80101da8 <namex+0x198>
80101d54:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101d56:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d59:	5b                   	pop    %ebx
80101d5a:	5e                   	pop    %esi
80101d5b:	5f                   	pop    %edi
80101d5c:	5d                   	pop    %ebp
80101d5d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d5e:	83 ec 0c             	sub    $0xc,%esp
80101d61:	56                   	push   %esi
80101d62:	e8 a9 f9 ff ff       	call   80101710 <iunlock>
  iput(ip);
80101d67:	89 34 24             	mov    %esi,(%esp)
80101d6a:	e8 f1 f9 ff ff       	call   80101760 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101d6f:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101d72:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101d75:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101d77:	5b                   	pop    %ebx
80101d78:	5e                   	pop    %esi
80101d79:	5f                   	pop    %edi
80101d7a:	5d                   	pop    %ebp
80101d7b:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101d7c:	ba 01 00 00 00       	mov    $0x1,%edx
80101d81:	b8 01 00 00 00       	mov    $0x1,%eax
80101d86:	e8 45 f4 ff ff       	call   801011d0 <iget>
80101d8b:	89 c6                	mov    %eax,%esi
80101d8d:	e9 c9 fe ff ff       	jmp    80101c5b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101d92:	83 ec 0c             	sub    $0xc,%esp
80101d95:	56                   	push   %esi
80101d96:	e8 75 f9 ff ff       	call   80101710 <iunlock>
      return ip;
80101d9b:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101d9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101da1:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101da3:	5b                   	pop    %ebx
80101da4:	5e                   	pop    %esi
80101da5:	5f                   	pop    %edi
80101da6:	5d                   	pop    %ebp
80101da7:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101da8:	83 ec 0c             	sub    $0xc,%esp
80101dab:	56                   	push   %esi
80101dac:	e8 af f9 ff ff       	call   80101760 <iput>
    return 0;
80101db1:	83 c4 10             	add    $0x10,%esp
80101db4:	31 c0                	xor    %eax,%eax
80101db6:	eb 9e                	jmp    80101d56 <namex+0x146>
80101db8:	90                   	nop
80101db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101dc0 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101dc0:	55                   	push   %ebp
80101dc1:	89 e5                	mov    %esp,%ebp
80101dc3:	57                   	push   %edi
80101dc4:	56                   	push   %esi
80101dc5:	53                   	push   %ebx
80101dc6:	83 ec 20             	sub    $0x20,%esp
80101dc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101dcc:	6a 00                	push   $0x0
80101dce:	ff 75 0c             	pushl  0xc(%ebp)
80101dd1:	53                   	push   %ebx
80101dd2:	e8 89 fd ff ff       	call   80101b60 <dirlookup>
80101dd7:	83 c4 10             	add    $0x10,%esp
80101dda:	85 c0                	test   %eax,%eax
80101ddc:	75 67                	jne    80101e45 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101dde:	8b 7b 58             	mov    0x58(%ebx),%edi
80101de1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101de4:	85 ff                	test   %edi,%edi
80101de6:	74 29                	je     80101e11 <dirlink+0x51>
80101de8:	31 ff                	xor    %edi,%edi
80101dea:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ded:	eb 09                	jmp    80101df8 <dirlink+0x38>
80101def:	90                   	nop
80101df0:	83 c7 10             	add    $0x10,%edi
80101df3:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101df6:	76 19                	jbe    80101e11 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101df8:	6a 10                	push   $0x10
80101dfa:	57                   	push   %edi
80101dfb:	56                   	push   %esi
80101dfc:	53                   	push   %ebx
80101dfd:	e8 0e fb ff ff       	call   80101910 <readi>
80101e02:	83 c4 10             	add    $0x10,%esp
80101e05:	83 f8 10             	cmp    $0x10,%eax
80101e08:	75 4e                	jne    80101e58 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101e0a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e0f:	75 df                	jne    80101df0 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e11:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e14:	83 ec 04             	sub    $0x4,%esp
80101e17:	6a 0e                	push   $0xe
80101e19:	ff 75 0c             	pushl  0xc(%ebp)
80101e1c:	50                   	push   %eax
80101e1d:	e8 4e 27 00 00       	call   80104570 <strncpy>
  de.inum = inum;
80101e22:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e25:	6a 10                	push   $0x10
80101e27:	57                   	push   %edi
80101e28:	56                   	push   %esi
80101e29:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101e2a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e2e:	e8 dd fb ff ff       	call   80101a10 <writei>
80101e33:	83 c4 20             	add    $0x20,%esp
80101e36:	83 f8 10             	cmp    $0x10,%eax
80101e39:	75 2a                	jne    80101e65 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101e3b:	31 c0                	xor    %eax,%eax
}
80101e3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e40:	5b                   	pop    %ebx
80101e41:	5e                   	pop    %esi
80101e42:	5f                   	pop    %edi
80101e43:	5d                   	pop    %ebp
80101e44:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101e45:	83 ec 0c             	sub    $0xc,%esp
80101e48:	50                   	push   %eax
80101e49:	e8 12 f9 ff ff       	call   80101760 <iput>
    return -1;
80101e4e:	83 c4 10             	add    $0x10,%esp
80101e51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e56:	eb e5                	jmp    80101e3d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101e58:	83 ec 0c             	sub    $0xc,%esp
80101e5b:	68 68 71 10 80       	push   $0x80107168
80101e60:	e8 0b e5 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101e65:	83 ec 0c             	sub    $0xc,%esp
80101e68:	68 66 77 10 80       	push   $0x80107766
80101e6d:	e8 fe e4 ff ff       	call   80100370 <panic>
80101e72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e80 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101e80:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101e81:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101e83:	89 e5                	mov    %esp,%ebp
80101e85:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101e88:	8b 45 08             	mov    0x8(%ebp),%eax
80101e8b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101e8e:	e8 7d fd ff ff       	call   80101c10 <namex>
}
80101e93:	c9                   	leave  
80101e94:	c3                   	ret    
80101e95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ea0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101ea0:	55                   	push   %ebp
  return namex(path, 1, name);
80101ea1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101ea6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101ea8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101eab:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101eae:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101eaf:	e9 5c fd ff ff       	jmp    80101c10 <namex>
80101eb4:	66 90                	xchg   %ax,%ax
80101eb6:	66 90                	xchg   %ax,%ax
80101eb8:	66 90                	xchg   %ax,%ax
80101eba:	66 90                	xchg   %ax,%ax
80101ebc:	66 90                	xchg   %ax,%ax
80101ebe:	66 90                	xchg   %ax,%ax

80101ec0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ec0:	55                   	push   %ebp
  if(b == 0)
80101ec1:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ec3:	89 e5                	mov    %esp,%ebp
80101ec5:	56                   	push   %esi
80101ec6:	53                   	push   %ebx
  if(b == 0)
80101ec7:	0f 84 ad 00 00 00    	je     80101f7a <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101ecd:	8b 58 08             	mov    0x8(%eax),%ebx
80101ed0:	89 c1                	mov    %eax,%ecx
80101ed2:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101ed8:	0f 87 8f 00 00 00    	ja     80101f6d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101ede:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ee3:	90                   	nop
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ee8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101ee9:	83 e0 c0             	and    $0xffffffc0,%eax
80101eec:	3c 40                	cmp    $0x40,%al
80101eee:	75 f8                	jne    80101ee8 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101ef0:	31 f6                	xor    %esi,%esi
80101ef2:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101ef7:	89 f0                	mov    %esi,%eax
80101ef9:	ee                   	out    %al,(%dx)
80101efa:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101eff:	b8 01 00 00 00       	mov    $0x1,%eax
80101f04:	ee                   	out    %al,(%dx)
80101f05:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f0a:	89 d8                	mov    %ebx,%eax
80101f0c:	ee                   	out    %al,(%dx)
80101f0d:	89 d8                	mov    %ebx,%eax
80101f0f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f14:	c1 f8 08             	sar    $0x8,%eax
80101f17:	ee                   	out    %al,(%dx)
80101f18:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f1d:	89 f0                	mov    %esi,%eax
80101f1f:	ee                   	out    %al,(%dx)
80101f20:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101f24:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f29:	83 e0 01             	and    $0x1,%eax
80101f2c:	c1 e0 04             	shl    $0x4,%eax
80101f2f:	83 c8 e0             	or     $0xffffffe0,%eax
80101f32:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80101f33:	f6 01 04             	testb  $0x4,(%ecx)
80101f36:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f3b:	75 13                	jne    80101f50 <idestart+0x90>
80101f3d:	b8 20 00 00 00       	mov    $0x20,%eax
80101f42:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f43:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f46:	5b                   	pop    %ebx
80101f47:	5e                   	pop    %esi
80101f48:	5d                   	pop    %ebp
80101f49:	c3                   	ret    
80101f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f50:	b8 30 00 00 00       	mov    $0x30,%eax
80101f55:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101f56:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101f5b:	8d 71 5c             	lea    0x5c(%ecx),%esi
80101f5e:	b9 80 00 00 00       	mov    $0x80,%ecx
80101f63:	fc                   	cld    
80101f64:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f66:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f69:	5b                   	pop    %ebx
80101f6a:	5e                   	pop    %esi
80101f6b:	5d                   	pop    %ebp
80101f6c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101f6d:	83 ec 0c             	sub    $0xc,%esp
80101f70:	68 d4 71 10 80       	push   $0x801071d4
80101f75:	e8 f6 e3 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101f7a:	83 ec 0c             	sub    $0xc,%esp
80101f7d:	68 cb 71 10 80       	push   $0x801071cb
80101f82:	e8 e9 e3 ff ff       	call   80100370 <panic>
80101f87:	89 f6                	mov    %esi,%esi
80101f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f90 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101f90:	55                   	push   %ebp
80101f91:	89 e5                	mov    %esp,%ebp
80101f93:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80101f96:	68 e6 71 10 80       	push   $0x801071e6
80101f9b:	68 80 a5 10 80       	push   $0x8010a580
80101fa0:	e8 bb 21 00 00       	call   80104160 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101fa5:	58                   	pop    %eax
80101fa6:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80101fab:	5a                   	pop    %edx
80101fac:	83 e8 01             	sub    $0x1,%eax
80101faf:	50                   	push   %eax
80101fb0:	6a 0e                	push   $0xe
80101fb2:	e8 a9 02 00 00       	call   80102260 <ioapicenable>
80101fb7:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fba:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fbf:	90                   	nop
80101fc0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101fc1:	83 e0 c0             	and    $0xffffffc0,%eax
80101fc4:	3c 40                	cmp    $0x40,%al
80101fc6:	75 f8                	jne    80101fc0 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fc8:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fcd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101fd2:	ee                   	out    %al,(%dx)
80101fd3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fd8:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fdd:	eb 06                	jmp    80101fe5 <ideinit+0x55>
80101fdf:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80101fe0:	83 e9 01             	sub    $0x1,%ecx
80101fe3:	74 0f                	je     80101ff4 <ideinit+0x64>
80101fe5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101fe6:	84 c0                	test   %al,%al
80101fe8:	74 f6                	je     80101fe0 <ideinit+0x50>
      havedisk1 = 1;
80101fea:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80101ff1:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101ff4:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101ff9:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80101ffe:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
80101fff:	c9                   	leave  
80102000:	c3                   	ret    
80102001:	eb 0d                	jmp    80102010 <ideintr>
80102003:	90                   	nop
80102004:	90                   	nop
80102005:	90                   	nop
80102006:	90                   	nop
80102007:	90                   	nop
80102008:	90                   	nop
80102009:	90                   	nop
8010200a:	90                   	nop
8010200b:	90                   	nop
8010200c:	90                   	nop
8010200d:	90                   	nop
8010200e:	90                   	nop
8010200f:	90                   	nop

80102010 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	57                   	push   %edi
80102014:	56                   	push   %esi
80102015:	53                   	push   %ebx
80102016:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102019:	68 80 a5 10 80       	push   $0x8010a580
8010201e:	e8 3d 22 00 00       	call   80104260 <acquire>

  if((b = idequeue) == 0){
80102023:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102029:	83 c4 10             	add    $0x10,%esp
8010202c:	85 db                	test   %ebx,%ebx
8010202e:	74 34                	je     80102064 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102030:	8b 43 58             	mov    0x58(%ebx),%eax
80102033:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102038:	8b 33                	mov    (%ebx),%esi
8010203a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102040:	74 3e                	je     80102080 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102042:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102045:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102048:	83 ce 02             	or     $0x2,%esi
8010204b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010204d:	53                   	push   %ebx
8010204e:	e8 4d 1e 00 00       	call   80103ea0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102053:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102058:	83 c4 10             	add    $0x10,%esp
8010205b:	85 c0                	test   %eax,%eax
8010205d:	74 05                	je     80102064 <ideintr+0x54>
    idestart(idequeue);
8010205f:	e8 5c fe ff ff       	call   80101ec0 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
80102064:	83 ec 0c             	sub    $0xc,%esp
80102067:	68 80 a5 10 80       	push   $0x8010a580
8010206c:	e8 0f 23 00 00       	call   80104380 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
80102071:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102074:	5b                   	pop    %ebx
80102075:	5e                   	pop    %esi
80102076:	5f                   	pop    %edi
80102077:	5d                   	pop    %ebp
80102078:	c3                   	ret    
80102079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102080:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102085:	8d 76 00             	lea    0x0(%esi),%esi
80102088:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102089:	89 c1                	mov    %eax,%ecx
8010208b:	83 e1 c0             	and    $0xffffffc0,%ecx
8010208e:	80 f9 40             	cmp    $0x40,%cl
80102091:	75 f5                	jne    80102088 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102093:	a8 21                	test   $0x21,%al
80102095:	75 ab                	jne    80102042 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
80102097:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
8010209a:	b9 80 00 00 00       	mov    $0x80,%ecx
8010209f:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020a4:	fc                   	cld    
801020a5:	f3 6d                	rep insl (%dx),%es:(%edi)
801020a7:	8b 33                	mov    (%ebx),%esi
801020a9:	eb 97                	jmp    80102042 <ideintr+0x32>
801020ab:	90                   	nop
801020ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020b0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801020b0:	55                   	push   %ebp
801020b1:	89 e5                	mov    %esp,%ebp
801020b3:	53                   	push   %ebx
801020b4:	83 ec 10             	sub    $0x10,%esp
801020b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801020ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801020bd:	50                   	push   %eax
801020be:	e8 6d 20 00 00       	call   80104130 <holdingsleep>
801020c3:	83 c4 10             	add    $0x10,%esp
801020c6:	85 c0                	test   %eax,%eax
801020c8:	0f 84 ad 00 00 00    	je     8010217b <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801020ce:	8b 03                	mov    (%ebx),%eax
801020d0:	83 e0 06             	and    $0x6,%eax
801020d3:	83 f8 02             	cmp    $0x2,%eax
801020d6:	0f 84 b9 00 00 00    	je     80102195 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801020dc:	8b 53 04             	mov    0x4(%ebx),%edx
801020df:	85 d2                	test   %edx,%edx
801020e1:	74 0d                	je     801020f0 <iderw+0x40>
801020e3:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801020e8:	85 c0                	test   %eax,%eax
801020ea:	0f 84 98 00 00 00    	je     80102188 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801020f0:	83 ec 0c             	sub    $0xc,%esp
801020f3:	68 80 a5 10 80       	push   $0x8010a580
801020f8:	e8 63 21 00 00       	call   80104260 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801020fd:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102103:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102106:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010210d:	85 d2                	test   %edx,%edx
8010210f:	75 09                	jne    8010211a <iderw+0x6a>
80102111:	eb 58                	jmp    8010216b <iderw+0xbb>
80102113:	90                   	nop
80102114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102118:	89 c2                	mov    %eax,%edx
8010211a:	8b 42 58             	mov    0x58(%edx),%eax
8010211d:	85 c0                	test   %eax,%eax
8010211f:	75 f7                	jne    80102118 <iderw+0x68>
80102121:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102124:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102126:	3b 1d 64 a5 10 80    	cmp    0x8010a564,%ebx
8010212c:	74 44                	je     80102172 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010212e:	8b 03                	mov    (%ebx),%eax
80102130:	83 e0 06             	and    $0x6,%eax
80102133:	83 f8 02             	cmp    $0x2,%eax
80102136:	74 23                	je     8010215b <iderw+0xab>
80102138:	90                   	nop
80102139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102140:	83 ec 08             	sub    $0x8,%esp
80102143:	68 80 a5 10 80       	push   $0x8010a580
80102148:	53                   	push   %ebx
80102149:	e8 a2 1b 00 00       	call   80103cf0 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010214e:	8b 03                	mov    (%ebx),%eax
80102150:	83 c4 10             	add    $0x10,%esp
80102153:	83 e0 06             	and    $0x6,%eax
80102156:	83 f8 02             	cmp    $0x2,%eax
80102159:	75 e5                	jne    80102140 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
8010215b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102162:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102165:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
80102166:	e9 15 22 00 00       	jmp    80104380 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010216b:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102170:	eb b2                	jmp    80102124 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102172:	89 d8                	mov    %ebx,%eax
80102174:	e8 47 fd ff ff       	call   80101ec0 <idestart>
80102179:	eb b3                	jmp    8010212e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010217b:	83 ec 0c             	sub    $0xc,%esp
8010217e:	68 ea 71 10 80       	push   $0x801071ea
80102183:	e8 e8 e1 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102188:	83 ec 0c             	sub    $0xc,%esp
8010218b:	68 15 72 10 80       	push   $0x80107215
80102190:	e8 db e1 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102195:	83 ec 0c             	sub    $0xc,%esp
80102198:	68 00 72 10 80       	push   $0x80107200
8010219d:	e8 ce e1 ff ff       	call   80100370 <panic>
801021a2:	66 90                	xchg   %ax,%ax
801021a4:	66 90                	xchg   %ax,%ax
801021a6:	66 90                	xchg   %ax,%ax
801021a8:	66 90                	xchg   %ax,%ax
801021aa:	66 90                	xchg   %ax,%ax
801021ac:	66 90                	xchg   %ax,%ax
801021ae:	66 90                	xchg   %ax,%ax

801021b0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021b0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021b1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801021b8:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021bb:	89 e5                	mov    %esp,%ebp
801021bd:	56                   	push   %esi
801021be:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021bf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801021c6:	00 00 00 
  return ioapic->data;
801021c9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801021cf:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021d2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801021d8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801021de:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801021e5:	89 f0                	mov    %esi,%eax
801021e7:	c1 e8 10             	shr    $0x10,%eax
801021ea:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
801021ed:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801021f0:	c1 e8 18             	shr    $0x18,%eax
801021f3:	39 d0                	cmp    %edx,%eax
801021f5:	74 16                	je     8010220d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801021f7:	83 ec 0c             	sub    $0xc,%esp
801021fa:	68 34 72 10 80       	push   $0x80107234
801021ff:	e8 5c e4 ff ff       	call   80100660 <cprintf>
80102204:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010220a:	83 c4 10             	add    $0x10,%esp
8010220d:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102210:	ba 10 00 00 00       	mov    $0x10,%edx
80102215:	b8 20 00 00 00       	mov    $0x20,%eax
8010221a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102220:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102222:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102228:	89 c3                	mov    %eax,%ebx
8010222a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102230:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102233:	89 59 10             	mov    %ebx,0x10(%ecx)
80102236:	8d 5a 01             	lea    0x1(%edx),%ebx
80102239:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010223c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010223e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102240:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102246:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010224d:	75 d1                	jne    80102220 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010224f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102252:	5b                   	pop    %ebx
80102253:	5e                   	pop    %esi
80102254:	5d                   	pop    %ebp
80102255:	c3                   	ret    
80102256:	8d 76 00             	lea    0x0(%esi),%esi
80102259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102260 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102260:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102261:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102267:	89 e5                	mov    %esp,%ebp
80102269:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010226c:	8d 50 20             	lea    0x20(%eax),%edx
8010226f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102273:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102275:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010227b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010227e:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102281:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102284:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102286:	a1 34 26 11 80       	mov    0x80112634,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010228b:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
8010228e:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102291:	5d                   	pop    %ebp
80102292:	c3                   	ret    
80102293:	66 90                	xchg   %ax,%ax
80102295:	66 90                	xchg   %ax,%ax
80102297:	66 90                	xchg   %ax,%ax
80102299:	66 90                	xchg   %ax,%ax
8010229b:	66 90                	xchg   %ax,%ax
8010229d:	66 90                	xchg   %ax,%ax
8010229f:	90                   	nop

801022a0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	53                   	push   %ebx
801022a4:	83 ec 04             	sub    $0x4,%esp
801022a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022aa:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022b0:	75 70                	jne    80102322 <kfree+0x82>
801022b2:	81 fb f4 58 11 80    	cmp    $0x801158f4,%ebx
801022b8:	72 68                	jb     80102322 <kfree+0x82>
801022ba:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801022c0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801022c5:	77 5b                	ja     80102322 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801022c7:	83 ec 04             	sub    $0x4,%esp
801022ca:	68 00 10 00 00       	push   $0x1000
801022cf:	6a 01                	push   $0x1
801022d1:	53                   	push   %ebx
801022d2:	e8 f9 20 00 00       	call   801043d0 <memset>

  if(kmem.use_lock)
801022d7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801022dd:	83 c4 10             	add    $0x10,%esp
801022e0:	85 d2                	test   %edx,%edx
801022e2:	75 2c                	jne    80102310 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801022e4:	a1 78 26 11 80       	mov    0x80112678,%eax
801022e9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801022eb:	a1 74 26 11 80       	mov    0x80112674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
801022f0:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
801022f6:	85 c0                	test   %eax,%eax
801022f8:	75 06                	jne    80102300 <kfree+0x60>
    release(&kmem.lock);
}
801022fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801022fd:	c9                   	leave  
801022fe:	c3                   	ret    
801022ff:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102300:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102307:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010230a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010230b:	e9 70 20 00 00       	jmp    80104380 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102310:	83 ec 0c             	sub    $0xc,%esp
80102313:	68 40 26 11 80       	push   $0x80112640
80102318:	e8 43 1f 00 00       	call   80104260 <acquire>
8010231d:	83 c4 10             	add    $0x10,%esp
80102320:	eb c2                	jmp    801022e4 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102322:	83 ec 0c             	sub    $0xc,%esp
80102325:	68 66 72 10 80       	push   $0x80107266
8010232a:	e8 41 e0 ff ff       	call   80100370 <panic>
8010232f:	90                   	nop

80102330 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102330:	55                   	push   %ebp
80102331:	89 e5                	mov    %esp,%ebp
80102333:	56                   	push   %esi
80102334:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102335:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102338:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010233b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102341:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102347:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010234d:	39 de                	cmp    %ebx,%esi
8010234f:	72 23                	jb     80102374 <freerange+0x44>
80102351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102358:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010235e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102361:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102367:	50                   	push   %eax
80102368:	e8 33 ff ff ff       	call   801022a0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010236d:	83 c4 10             	add    $0x10,%esp
80102370:	39 f3                	cmp    %esi,%ebx
80102372:	76 e4                	jbe    80102358 <freerange+0x28>
    kfree(p);
}
80102374:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102377:	5b                   	pop    %ebx
80102378:	5e                   	pop    %esi
80102379:	5d                   	pop    %ebp
8010237a:	c3                   	ret    
8010237b:	90                   	nop
8010237c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102380 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	56                   	push   %esi
80102384:	53                   	push   %ebx
80102385:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102388:	83 ec 08             	sub    $0x8,%esp
8010238b:	68 6c 72 10 80       	push   $0x8010726c
80102390:	68 40 26 11 80       	push   $0x80112640
80102395:	e8 c6 1d 00 00       	call   80104160 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010239a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010239d:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801023a0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801023a7:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023aa:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023b0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023b6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023bc:	39 de                	cmp    %ebx,%esi
801023be:	72 1c                	jb     801023dc <kinit1+0x5c>
    kfree(p);
801023c0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023c6:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023c9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023cf:	50                   	push   %eax
801023d0:	e8 cb fe ff ff       	call   801022a0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d5:	83 c4 10             	add    $0x10,%esp
801023d8:	39 de                	cmp    %ebx,%esi
801023da:	73 e4                	jae    801023c0 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
801023dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023df:	5b                   	pop    %ebx
801023e0:	5e                   	pop    %esi
801023e1:	5d                   	pop    %ebp
801023e2:	c3                   	ret    
801023e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801023e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023f0 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023f5:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
801023f8:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023fb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102401:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102407:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010240d:	39 de                	cmp    %ebx,%esi
8010240f:	72 23                	jb     80102434 <kinit2+0x44>
80102411:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102418:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010241e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102421:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102427:	50                   	push   %eax
80102428:	e8 73 fe ff ff       	call   801022a0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010242d:	83 c4 10             	add    $0x10,%esp
80102430:	39 de                	cmp    %ebx,%esi
80102432:	73 e4                	jae    80102418 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102434:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010243b:	00 00 00 
}
8010243e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102441:	5b                   	pop    %ebx
80102442:	5e                   	pop    %esi
80102443:	5d                   	pop    %ebp
80102444:	c3                   	ret    
80102445:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102450 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	53                   	push   %ebx
80102454:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102457:	a1 74 26 11 80       	mov    0x80112674,%eax
8010245c:	85 c0                	test   %eax,%eax
8010245e:	75 30                	jne    80102490 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102460:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102466:	85 db                	test   %ebx,%ebx
80102468:	74 1c                	je     80102486 <kalloc+0x36>
    kmem.freelist = r->next;
8010246a:	8b 13                	mov    (%ebx),%edx
8010246c:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
80102472:	85 c0                	test   %eax,%eax
80102474:	74 10                	je     80102486 <kalloc+0x36>
    release(&kmem.lock);
80102476:	83 ec 0c             	sub    $0xc,%esp
80102479:	68 40 26 11 80       	push   $0x80112640
8010247e:	e8 fd 1e 00 00       	call   80104380 <release>
80102483:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
80102486:	89 d8                	mov    %ebx,%eax
80102488:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010248b:	c9                   	leave  
8010248c:	c3                   	ret    
8010248d:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102490:	83 ec 0c             	sub    $0xc,%esp
80102493:	68 40 26 11 80       	push   $0x80112640
80102498:	e8 c3 1d 00 00       	call   80104260 <acquire>
  r = kmem.freelist;
8010249d:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024a3:	83 c4 10             	add    $0x10,%esp
801024a6:	a1 74 26 11 80       	mov    0x80112674,%eax
801024ab:	85 db                	test   %ebx,%ebx
801024ad:	75 bb                	jne    8010246a <kalloc+0x1a>
801024af:	eb c1                	jmp    80102472 <kalloc+0x22>
801024b1:	66 90                	xchg   %ax,%ax
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801024c0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024c1:	ba 64 00 00 00       	mov    $0x64,%edx
801024c6:	89 e5                	mov    %esp,%ebp
801024c8:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801024c9:	a8 01                	test   $0x1,%al
801024cb:	0f 84 af 00 00 00    	je     80102580 <kbdgetc+0xc0>
801024d1:	ba 60 00 00 00       	mov    $0x60,%edx
801024d6:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801024d7:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801024da:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801024e0:	74 7e                	je     80102560 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801024e2:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801024e4:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801024ea:	79 24                	jns    80102510 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801024ec:	f6 c1 40             	test   $0x40,%cl
801024ef:	75 05                	jne    801024f6 <kbdgetc+0x36>
801024f1:	89 c2                	mov    %eax,%edx
801024f3:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
801024f6:	0f b6 82 a0 73 10 80 	movzbl -0x7fef8c60(%edx),%eax
801024fd:	83 c8 40             	or     $0x40,%eax
80102500:	0f b6 c0             	movzbl %al,%eax
80102503:	f7 d0                	not    %eax
80102505:	21 c8                	and    %ecx,%eax
80102507:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010250c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010250e:	5d                   	pop    %ebp
8010250f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102510:	f6 c1 40             	test   $0x40,%cl
80102513:	74 09                	je     8010251e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102515:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102518:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010251b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010251e:	0f b6 82 a0 73 10 80 	movzbl -0x7fef8c60(%edx),%eax
80102525:	09 c1                	or     %eax,%ecx
80102527:	0f b6 82 a0 72 10 80 	movzbl -0x7fef8d60(%edx),%eax
8010252e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102530:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102532:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102538:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010253b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010253e:	8b 04 85 80 72 10 80 	mov    -0x7fef8d80(,%eax,4),%eax
80102545:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102549:	74 c3                	je     8010250e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010254b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010254e:	83 fa 19             	cmp    $0x19,%edx
80102551:	77 1d                	ja     80102570 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102553:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102556:	5d                   	pop    %ebp
80102557:	c3                   	ret    
80102558:	90                   	nop
80102559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102560:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102562:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102569:	5d                   	pop    %ebp
8010256a:	c3                   	ret    
8010256b:	90                   	nop
8010256c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102570:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102573:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
80102576:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
80102577:	83 f9 19             	cmp    $0x19,%ecx
8010257a:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
8010257d:	c3                   	ret    
8010257e:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102585:	5d                   	pop    %ebp
80102586:	c3                   	ret    
80102587:	89 f6                	mov    %esi,%esi
80102589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102590 <kbdintr>:

void
kbdintr(void)
{
80102590:	55                   	push   %ebp
80102591:	89 e5                	mov    %esp,%ebp
80102593:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102596:	68 c0 24 10 80       	push   $0x801024c0
8010259b:	e8 50 e2 ff ff       	call   801007f0 <consoleintr>
}
801025a0:	83 c4 10             	add    $0x10,%esp
801025a3:	c9                   	leave  
801025a4:	c3                   	ret    
801025a5:	66 90                	xchg   %ax,%ax
801025a7:	66 90                	xchg   %ax,%ax
801025a9:	66 90                	xchg   %ax,%ax
801025ab:	66 90                	xchg   %ax,%ax
801025ad:	66 90                	xchg   %ax,%ax
801025af:	90                   	nop

801025b0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801025b0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801025b5:	55                   	push   %ebp
801025b6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801025b8:	85 c0                	test   %eax,%eax
801025ba:	0f 84 c8 00 00 00    	je     80102688 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025c0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801025c7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025ca:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025cd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801025d4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025d7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025da:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801025e1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801025e4:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025e7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801025ee:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801025f1:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025f4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801025fb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801025fe:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102601:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102608:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010260b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010260e:	8b 50 30             	mov    0x30(%eax),%edx
80102611:	c1 ea 10             	shr    $0x10,%edx
80102614:	80 fa 03             	cmp    $0x3,%dl
80102617:	77 77                	ja     80102690 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102619:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102620:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102623:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102626:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010262d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102630:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102633:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010263a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010263d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102640:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102647:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010264a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010264d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102654:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102657:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010265a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102661:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102664:	8b 50 20             	mov    0x20(%eax),%edx
80102667:	89 f6                	mov    %esi,%esi
80102669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102670:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102676:	80 e6 10             	and    $0x10,%dh
80102679:	75 f5                	jne    80102670 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010267b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102682:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102685:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102688:	5d                   	pop    %ebp
80102689:	c3                   	ret    
8010268a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102690:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102697:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010269a:	8b 50 20             	mov    0x20(%eax),%edx
8010269d:	e9 77 ff ff ff       	jmp    80102619 <lapicinit+0x69>
801026a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026b0 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
801026b0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
801026b5:	55                   	push   %ebp
801026b6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801026b8:	85 c0                	test   %eax,%eax
801026ba:	74 0c                	je     801026c8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801026bc:	8b 40 20             	mov    0x20(%eax),%eax
}
801026bf:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
801026c0:	c1 e8 18             	shr    $0x18,%eax
}
801026c3:	c3                   	ret    
801026c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
801026c8:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
801026ca:	5d                   	pop    %ebp
801026cb:	c3                   	ret    
801026cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801026d0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801026d0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
801026d5:	55                   	push   %ebp
801026d6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801026d8:	85 c0                	test   %eax,%eax
801026da:	74 0d                	je     801026e9 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026dc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026e3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026e6:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
801026e9:	5d                   	pop    %ebp
801026ea:	c3                   	ret    
801026eb:	90                   	nop
801026ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801026f0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801026f0:	55                   	push   %ebp
801026f1:	89 e5                	mov    %esp,%ebp
}
801026f3:	5d                   	pop    %ebp
801026f4:	c3                   	ret    
801026f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102700 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102700:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102701:	ba 70 00 00 00       	mov    $0x70,%edx
80102706:	b8 0f 00 00 00       	mov    $0xf,%eax
8010270b:	89 e5                	mov    %esp,%ebp
8010270d:	53                   	push   %ebx
8010270e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102711:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102714:	ee                   	out    %al,(%dx)
80102715:	ba 71 00 00 00       	mov    $0x71,%edx
8010271a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010271f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102720:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102722:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102725:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010272b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010272d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102730:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102733:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102735:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102738:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010273e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102743:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102749:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010274c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102753:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102756:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102759:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102760:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102763:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102766:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010276c:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010276f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102775:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102778:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010277e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102781:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102787:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010278a:	5b                   	pop    %ebx
8010278b:	5d                   	pop    %ebp
8010278c:	c3                   	ret    
8010278d:	8d 76 00             	lea    0x0(%esi),%esi

80102790 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102790:	55                   	push   %ebp
80102791:	ba 70 00 00 00       	mov    $0x70,%edx
80102796:	b8 0b 00 00 00       	mov    $0xb,%eax
8010279b:	89 e5                	mov    %esp,%ebp
8010279d:	57                   	push   %edi
8010279e:	56                   	push   %esi
8010279f:	53                   	push   %ebx
801027a0:	83 ec 4c             	sub    $0x4c,%esp
801027a3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027a4:	ba 71 00 00 00       	mov    $0x71,%edx
801027a9:	ec                   	in     (%dx),%al
801027aa:	83 e0 04             	and    $0x4,%eax
801027ad:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027b0:	31 db                	xor    %ebx,%ebx
801027b2:	88 45 b7             	mov    %al,-0x49(%ebp)
801027b5:	bf 70 00 00 00       	mov    $0x70,%edi
801027ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801027c0:	89 d8                	mov    %ebx,%eax
801027c2:	89 fa                	mov    %edi,%edx
801027c4:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027c5:	b9 71 00 00 00       	mov    $0x71,%ecx
801027ca:	89 ca                	mov    %ecx,%edx
801027cc:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
801027cd:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027d0:	89 fa                	mov    %edi,%edx
801027d2:	89 45 b8             	mov    %eax,-0x48(%ebp)
801027d5:	b8 02 00 00 00       	mov    $0x2,%eax
801027da:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027db:	89 ca                	mov    %ecx,%edx
801027dd:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
801027de:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027e1:	89 fa                	mov    %edi,%edx
801027e3:	89 45 bc             	mov    %eax,-0x44(%ebp)
801027e6:	b8 04 00 00 00       	mov    $0x4,%eax
801027eb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027ec:	89 ca                	mov    %ecx,%edx
801027ee:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
801027ef:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027f2:	89 fa                	mov    %edi,%edx
801027f4:	89 45 c0             	mov    %eax,-0x40(%ebp)
801027f7:	b8 07 00 00 00       	mov    $0x7,%eax
801027fc:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027fd:	89 ca                	mov    %ecx,%edx
801027ff:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102800:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102803:	89 fa                	mov    %edi,%edx
80102805:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102808:	b8 08 00 00 00       	mov    $0x8,%eax
8010280d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010280e:	89 ca                	mov    %ecx,%edx
80102810:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102811:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102814:	89 fa                	mov    %edi,%edx
80102816:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102819:	b8 09 00 00 00       	mov    $0x9,%eax
8010281e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010281f:	89 ca                	mov    %ecx,%edx
80102821:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102822:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102825:	89 fa                	mov    %edi,%edx
80102827:	89 45 cc             	mov    %eax,-0x34(%ebp)
8010282a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010282f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102830:	89 ca                	mov    %ecx,%edx
80102832:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102833:	84 c0                	test   %al,%al
80102835:	78 89                	js     801027c0 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102837:	89 d8                	mov    %ebx,%eax
80102839:	89 fa                	mov    %edi,%edx
8010283b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010283c:	89 ca                	mov    %ecx,%edx
8010283e:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010283f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102842:	89 fa                	mov    %edi,%edx
80102844:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102847:	b8 02 00 00 00       	mov    $0x2,%eax
8010284c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010284d:	89 ca                	mov    %ecx,%edx
8010284f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102850:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102853:	89 fa                	mov    %edi,%edx
80102855:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102858:	b8 04 00 00 00       	mov    $0x4,%eax
8010285d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285e:	89 ca                	mov    %ecx,%edx
80102860:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102861:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102864:	89 fa                	mov    %edi,%edx
80102866:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102869:	b8 07 00 00 00       	mov    $0x7,%eax
8010286e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286f:	89 ca                	mov    %ecx,%edx
80102871:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102872:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102875:	89 fa                	mov    %edi,%edx
80102877:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010287a:	b8 08 00 00 00       	mov    $0x8,%eax
8010287f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102880:	89 ca                	mov    %ecx,%edx
80102882:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102883:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102886:	89 fa                	mov    %edi,%edx
80102888:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010288b:	b8 09 00 00 00       	mov    $0x9,%eax
80102890:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102891:	89 ca                	mov    %ecx,%edx
80102893:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102894:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102897:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
8010289a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010289d:	8d 45 b8             	lea    -0x48(%ebp),%eax
801028a0:	6a 18                	push   $0x18
801028a2:	56                   	push   %esi
801028a3:	50                   	push   %eax
801028a4:	e8 77 1b 00 00       	call   80104420 <memcmp>
801028a9:	83 c4 10             	add    $0x10,%esp
801028ac:	85 c0                	test   %eax,%eax
801028ae:	0f 85 0c ff ff ff    	jne    801027c0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
801028b4:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028b8:	75 78                	jne    80102932 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028ba:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028bd:	89 c2                	mov    %eax,%edx
801028bf:	83 e0 0f             	and    $0xf,%eax
801028c2:	c1 ea 04             	shr    $0x4,%edx
801028c5:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028c8:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028cb:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028ce:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028d1:	89 c2                	mov    %eax,%edx
801028d3:	83 e0 0f             	and    $0xf,%eax
801028d6:	c1 ea 04             	shr    $0x4,%edx
801028d9:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028dc:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028df:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801028e2:	8b 45 c0             	mov    -0x40(%ebp),%eax
801028e5:	89 c2                	mov    %eax,%edx
801028e7:	83 e0 0f             	and    $0xf,%eax
801028ea:	c1 ea 04             	shr    $0x4,%edx
801028ed:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028f0:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028f3:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801028f6:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801028f9:	89 c2                	mov    %eax,%edx
801028fb:	83 e0 0f             	and    $0xf,%eax
801028fe:	c1 ea 04             	shr    $0x4,%edx
80102901:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102904:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102907:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010290a:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010290d:	89 c2                	mov    %eax,%edx
8010290f:	83 e0 0f             	and    $0xf,%eax
80102912:	c1 ea 04             	shr    $0x4,%edx
80102915:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102918:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010291b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010291e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102921:	89 c2                	mov    %eax,%edx
80102923:	83 e0 0f             	and    $0xf,%eax
80102926:	c1 ea 04             	shr    $0x4,%edx
80102929:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010292c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010292f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102932:	8b 75 08             	mov    0x8(%ebp),%esi
80102935:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102938:	89 06                	mov    %eax,(%esi)
8010293a:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010293d:	89 46 04             	mov    %eax,0x4(%esi)
80102940:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102943:	89 46 08             	mov    %eax,0x8(%esi)
80102946:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102949:	89 46 0c             	mov    %eax,0xc(%esi)
8010294c:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010294f:	89 46 10             	mov    %eax,0x10(%esi)
80102952:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102955:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102958:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010295f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102962:	5b                   	pop    %ebx
80102963:	5e                   	pop    %esi
80102964:	5f                   	pop    %edi
80102965:	5d                   	pop    %ebp
80102966:	c3                   	ret    
80102967:	66 90                	xchg   %ax,%ax
80102969:	66 90                	xchg   %ax,%ax
8010296b:	66 90                	xchg   %ax,%ax
8010296d:	66 90                	xchg   %ax,%ax
8010296f:	90                   	nop

80102970 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102970:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102976:	85 c9                	test   %ecx,%ecx
80102978:	0f 8e 85 00 00 00    	jle    80102a03 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
8010297e:	55                   	push   %ebp
8010297f:	89 e5                	mov    %esp,%ebp
80102981:	57                   	push   %edi
80102982:	56                   	push   %esi
80102983:	53                   	push   %ebx
80102984:	31 db                	xor    %ebx,%ebx
80102986:	83 ec 0c             	sub    $0xc,%esp
80102989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102990:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102995:	83 ec 08             	sub    $0x8,%esp
80102998:	01 d8                	add    %ebx,%eax
8010299a:	83 c0 01             	add    $0x1,%eax
8010299d:	50                   	push   %eax
8010299e:	ff 35 c4 26 11 80    	pushl  0x801126c4
801029a4:	e8 27 d7 ff ff       	call   801000d0 <bread>
801029a9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029ab:	58                   	pop    %eax
801029ac:	5a                   	pop    %edx
801029ad:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
801029b4:	ff 35 c4 26 11 80    	pushl  0x801126c4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029ba:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029bd:	e8 0e d7 ff ff       	call   801000d0 <bread>
801029c2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029c4:	8d 47 5c             	lea    0x5c(%edi),%eax
801029c7:	83 c4 0c             	add    $0xc,%esp
801029ca:	68 00 02 00 00       	push   $0x200
801029cf:	50                   	push   %eax
801029d0:	8d 46 5c             	lea    0x5c(%esi),%eax
801029d3:	50                   	push   %eax
801029d4:	e8 a7 1a 00 00       	call   80104480 <memmove>
    bwrite(dbuf);  // write dst to disk
801029d9:	89 34 24             	mov    %esi,(%esp)
801029dc:	e8 bf d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801029e1:	89 3c 24             	mov    %edi,(%esp)
801029e4:	e8 f7 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801029e9:	89 34 24             	mov    %esi,(%esp)
801029ec:	e8 ef d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029f1:	83 c4 10             	add    $0x10,%esp
801029f4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
801029fa:	7f 94                	jg     80102990 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
801029fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029ff:	5b                   	pop    %ebx
80102a00:	5e                   	pop    %esi
80102a01:	5f                   	pop    %edi
80102a02:	5d                   	pop    %ebp
80102a03:	f3 c3                	repz ret 
80102a05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a10 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a10:	55                   	push   %ebp
80102a11:	89 e5                	mov    %esp,%ebp
80102a13:	53                   	push   %ebx
80102a14:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a17:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102a1d:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102a23:	e8 a8 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a28:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102a2e:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a31:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a33:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a35:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102a38:	7e 1f                	jle    80102a59 <write_head+0x49>
80102a3a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102a41:	31 d2                	xor    %edx,%edx
80102a43:	90                   	nop
80102a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a48:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102a4e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102a52:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a55:	39 c2                	cmp    %eax,%edx
80102a57:	75 ef                	jne    80102a48 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102a59:	83 ec 0c             	sub    $0xc,%esp
80102a5c:	53                   	push   %ebx
80102a5d:	e8 3e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a62:	89 1c 24             	mov    %ebx,(%esp)
80102a65:	e8 76 d7 ff ff       	call   801001e0 <brelse>
}
80102a6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a6d:	c9                   	leave  
80102a6e:	c3                   	ret    
80102a6f:	90                   	nop

80102a70 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102a70:	55                   	push   %ebp
80102a71:	89 e5                	mov    %esp,%ebp
80102a73:	53                   	push   %ebx
80102a74:	83 ec 2c             	sub    $0x2c,%esp
80102a77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102a7a:	68 a0 74 10 80       	push   $0x801074a0
80102a7f:	68 80 26 11 80       	push   $0x80112680
80102a84:	e8 d7 16 00 00       	call   80104160 <initlock>
  readsb(dev, &sb);
80102a89:	58                   	pop    %eax
80102a8a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102a8d:	5a                   	pop    %edx
80102a8e:	50                   	push   %eax
80102a8f:	53                   	push   %ebx
80102a90:	e8 db e8 ff ff       	call   80101370 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102a95:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102a98:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a9b:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102a9c:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102aa2:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102aa8:	a3 b4 26 11 80       	mov    %eax,0x801126b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102aad:	5a                   	pop    %edx
80102aae:	50                   	push   %eax
80102aaf:	53                   	push   %ebx
80102ab0:	e8 1b d6 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102ab5:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ab8:	83 c4 10             	add    $0x10,%esp
80102abb:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102abd:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102ac3:	7e 1c                	jle    80102ae1 <initlog+0x71>
80102ac5:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102acc:	31 d2                	xor    %edx,%edx
80102ace:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102ad0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102ad4:	83 c2 04             	add    $0x4,%edx
80102ad7:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102add:	39 da                	cmp    %ebx,%edx
80102adf:	75 ef                	jne    80102ad0 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102ae1:	83 ec 0c             	sub    $0xc,%esp
80102ae4:	50                   	push   %eax
80102ae5:	e8 f6 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102aea:	e8 81 fe ff ff       	call   80102970 <install_trans>
  log.lh.n = 0;
80102aef:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102af6:	00 00 00 
  write_head(); // clear the log
80102af9:	e8 12 ff ff ff       	call   80102a10 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102afe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b01:	c9                   	leave  
80102b02:	c3                   	ret    
80102b03:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b10 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
80102b13:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102b16:	68 80 26 11 80       	push   $0x80112680
80102b1b:	e8 40 17 00 00       	call   80104260 <acquire>
80102b20:	83 c4 10             	add    $0x10,%esp
80102b23:	eb 18                	jmp    80102b3d <begin_op+0x2d>
80102b25:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b28:	83 ec 08             	sub    $0x8,%esp
80102b2b:	68 80 26 11 80       	push   $0x80112680
80102b30:	68 80 26 11 80       	push   $0x80112680
80102b35:	e8 b6 11 00 00       	call   80103cf0 <sleep>
80102b3a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102b3d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b42:	85 c0                	test   %eax,%eax
80102b44:	75 e2                	jne    80102b28 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b46:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b4b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b51:	83 c0 01             	add    $0x1,%eax
80102b54:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b57:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b5a:	83 fa 1e             	cmp    $0x1e,%edx
80102b5d:	7f c9                	jg     80102b28 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b5f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102b62:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102b67:	68 80 26 11 80       	push   $0x80112680
80102b6c:	e8 0f 18 00 00       	call   80104380 <release>
      break;
    }
  }
}
80102b71:	83 c4 10             	add    $0x10,%esp
80102b74:	c9                   	leave  
80102b75:	c3                   	ret    
80102b76:	8d 76 00             	lea    0x0(%esi),%esi
80102b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b80 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102b80:	55                   	push   %ebp
80102b81:	89 e5                	mov    %esp,%ebp
80102b83:	57                   	push   %edi
80102b84:	56                   	push   %esi
80102b85:	53                   	push   %ebx
80102b86:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102b89:	68 80 26 11 80       	push   $0x80112680
80102b8e:	e8 cd 16 00 00       	call   80104260 <acquire>
  log.outstanding -= 1;
80102b93:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102b98:	8b 1d c0 26 11 80    	mov    0x801126c0,%ebx
80102b9e:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102ba1:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102ba4:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102ba6:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102bab:	0f 85 23 01 00 00    	jne    80102cd4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102bb1:	85 c0                	test   %eax,%eax
80102bb3:	0f 85 f7 00 00 00    	jne    80102cb0 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bb9:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102bbc:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102bc3:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bc6:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bc8:	68 80 26 11 80       	push   $0x80112680
80102bcd:	e8 ae 17 00 00       	call   80104380 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bd2:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102bd8:	83 c4 10             	add    $0x10,%esp
80102bdb:	85 c9                	test   %ecx,%ecx
80102bdd:	0f 8e 8a 00 00 00    	jle    80102c6d <end_op+0xed>
80102be3:	90                   	nop
80102be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102be8:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102bed:	83 ec 08             	sub    $0x8,%esp
80102bf0:	01 d8                	add    %ebx,%eax
80102bf2:	83 c0 01             	add    $0x1,%eax
80102bf5:	50                   	push   %eax
80102bf6:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102bfc:	e8 cf d4 ff ff       	call   801000d0 <bread>
80102c01:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c03:	58                   	pop    %eax
80102c04:	5a                   	pop    %edx
80102c05:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102c0c:	ff 35 c4 26 11 80    	pushl  0x801126c4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c12:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c15:	e8 b6 d4 ff ff       	call   801000d0 <bread>
80102c1a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c1c:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c1f:	83 c4 0c             	add    $0xc,%esp
80102c22:	68 00 02 00 00       	push   $0x200
80102c27:	50                   	push   %eax
80102c28:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c2b:	50                   	push   %eax
80102c2c:	e8 4f 18 00 00       	call   80104480 <memmove>
    bwrite(to);  // write the log
80102c31:	89 34 24             	mov    %esi,(%esp)
80102c34:	e8 67 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c39:	89 3c 24             	mov    %edi,(%esp)
80102c3c:	e8 9f d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c41:	89 34 24             	mov    %esi,(%esp)
80102c44:	e8 97 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c49:	83 c4 10             	add    $0x10,%esp
80102c4c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c52:	7c 94                	jl     80102be8 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c54:	e8 b7 fd ff ff       	call   80102a10 <write_head>
    install_trans(); // Now install writes to home locations
80102c59:	e8 12 fd ff ff       	call   80102970 <install_trans>
    log.lh.n = 0;
80102c5e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c65:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c68:	e8 a3 fd ff ff       	call   80102a10 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102c6d:	83 ec 0c             	sub    $0xc,%esp
80102c70:	68 80 26 11 80       	push   $0x80112680
80102c75:	e8 e6 15 00 00       	call   80104260 <acquire>
    log.committing = 0;
    wakeup(&log);
80102c7a:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102c81:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102c88:	00 00 00 
    wakeup(&log);
80102c8b:	e8 10 12 00 00       	call   80103ea0 <wakeup>
    release(&log.lock);
80102c90:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c97:	e8 e4 16 00 00       	call   80104380 <release>
80102c9c:	83 c4 10             	add    $0x10,%esp
  }
}
80102c9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ca2:	5b                   	pop    %ebx
80102ca3:	5e                   	pop    %esi
80102ca4:	5f                   	pop    %edi
80102ca5:	5d                   	pop    %ebp
80102ca6:	c3                   	ret    
80102ca7:	89 f6                	mov    %esi,%esi
80102ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80102cb0:	83 ec 0c             	sub    $0xc,%esp
80102cb3:	68 80 26 11 80       	push   $0x80112680
80102cb8:	e8 e3 11 00 00       	call   80103ea0 <wakeup>
  }
  release(&log.lock);
80102cbd:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cc4:	e8 b7 16 00 00       	call   80104380 <release>
80102cc9:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102ccc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ccf:	5b                   	pop    %ebx
80102cd0:	5e                   	pop    %esi
80102cd1:	5f                   	pop    %edi
80102cd2:	5d                   	pop    %ebp
80102cd3:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102cd4:	83 ec 0c             	sub    $0xc,%esp
80102cd7:	68 a4 74 10 80       	push   $0x801074a4
80102cdc:	e8 8f d6 ff ff       	call   80100370 <panic>
80102ce1:	eb 0d                	jmp    80102cf0 <log_write>
80102ce3:	90                   	nop
80102ce4:	90                   	nop
80102ce5:	90                   	nop
80102ce6:	90                   	nop
80102ce7:	90                   	nop
80102ce8:	90                   	nop
80102ce9:	90                   	nop
80102cea:	90                   	nop
80102ceb:	90                   	nop
80102cec:	90                   	nop
80102ced:	90                   	nop
80102cee:	90                   	nop
80102cef:	90                   	nop

80102cf0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102cf0:	55                   	push   %ebp
80102cf1:	89 e5                	mov    %esp,%ebp
80102cf3:	53                   	push   %ebx
80102cf4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102cf7:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102cfd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d00:	83 fa 1d             	cmp    $0x1d,%edx
80102d03:	0f 8f 97 00 00 00    	jg     80102da0 <log_write+0xb0>
80102d09:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102d0e:	83 e8 01             	sub    $0x1,%eax
80102d11:	39 c2                	cmp    %eax,%edx
80102d13:	0f 8d 87 00 00 00    	jge    80102da0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d19:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d1e:	85 c0                	test   %eax,%eax
80102d20:	0f 8e 87 00 00 00    	jle    80102dad <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d26:	83 ec 0c             	sub    $0xc,%esp
80102d29:	68 80 26 11 80       	push   $0x80112680
80102d2e:	e8 2d 15 00 00       	call   80104260 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d33:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d39:	83 c4 10             	add    $0x10,%esp
80102d3c:	83 fa 00             	cmp    $0x0,%edx
80102d3f:	7e 50                	jle    80102d91 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d41:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d44:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d46:	3b 0d cc 26 11 80    	cmp    0x801126cc,%ecx
80102d4c:	75 0b                	jne    80102d59 <log_write+0x69>
80102d4e:	eb 38                	jmp    80102d88 <log_write+0x98>
80102d50:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d57:	74 2f                	je     80102d88 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d59:	83 c0 01             	add    $0x1,%eax
80102d5c:	39 d0                	cmp    %edx,%eax
80102d5e:	75 f0                	jne    80102d50 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d60:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d67:	83 c2 01             	add    $0x1,%edx
80102d6a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102d70:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d73:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102d7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d7d:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102d7e:	e9 fd 15 00 00       	jmp    80104380 <release>
80102d83:	90                   	nop
80102d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d88:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102d8f:	eb df                	jmp    80102d70 <log_write+0x80>
80102d91:	8b 43 08             	mov    0x8(%ebx),%eax
80102d94:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102d99:	75 d5                	jne    80102d70 <log_write+0x80>
80102d9b:	eb ca                	jmp    80102d67 <log_write+0x77>
80102d9d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102da0:	83 ec 0c             	sub    $0xc,%esp
80102da3:	68 b3 74 10 80       	push   $0x801074b3
80102da8:	e8 c3 d5 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102dad:	83 ec 0c             	sub    $0xc,%esp
80102db0:	68 c9 74 10 80       	push   $0x801074c9
80102db5:	e8 b6 d5 ff ff       	call   80100370 <panic>
80102dba:	66 90                	xchg   %ax,%ax
80102dbc:	66 90                	xchg   %ax,%ax
80102dbe:	66 90                	xchg   %ax,%ax

80102dc0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102dc0:	55                   	push   %ebp
80102dc1:	89 e5                	mov    %esp,%ebp
80102dc3:	53                   	push   %ebx
80102dc4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102dc7:	e8 54 09 00 00       	call   80103720 <cpuid>
80102dcc:	89 c3                	mov    %eax,%ebx
80102dce:	e8 4d 09 00 00       	call   80103720 <cpuid>
80102dd3:	83 ec 04             	sub    $0x4,%esp
80102dd6:	53                   	push   %ebx
80102dd7:	50                   	push   %eax
80102dd8:	68 e4 74 10 80       	push   $0x801074e4
80102ddd:	e8 7e d8 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102de2:	e8 d9 28 00 00       	call   801056c0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102de7:	e8 b4 08 00 00       	call   801036a0 <mycpu>
80102dec:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102dee:	b8 01 00 00 00       	mov    $0x1,%eax
80102df3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102dfa:	e8 01 0c 00 00       	call   80103a00 <scheduler>
80102dff:	90                   	nop

80102e00 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e06:	e8 d5 39 00 00       	call   801067e0 <switchkvm>
  seginit();
80102e0b:	e8 40 38 00 00       	call   80106650 <seginit>
  lapicinit();
80102e10:	e8 9b f7 ff ff       	call   801025b0 <lapicinit>
  mpmain();
80102e15:	e8 a6 ff ff ff       	call   80102dc0 <mpmain>
80102e1a:	66 90                	xchg   %ax,%ax
80102e1c:	66 90                	xchg   %ax,%ax
80102e1e:	66 90                	xchg   %ax,%ax

80102e20 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e20:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102e24:	83 e4 f0             	and    $0xfffffff0,%esp
80102e27:	ff 71 fc             	pushl  -0x4(%ecx)
80102e2a:	55                   	push   %ebp
80102e2b:	89 e5                	mov    %esp,%ebp
80102e2d:	53                   	push   %ebx
80102e2e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e2f:	bb 80 27 11 80       	mov    $0x80112780,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e34:	83 ec 08             	sub    $0x8,%esp
80102e37:	68 00 00 40 80       	push   $0x80400000
80102e3c:	68 f4 58 11 80       	push   $0x801158f4
80102e41:	e8 3a f5 ff ff       	call   80102380 <kinit1>
  kvmalloc();      // kernel page table
80102e46:	e8 35 3e 00 00       	call   80106c80 <kvmalloc>
  mpinit();        // detect other processors
80102e4b:	e8 70 01 00 00       	call   80102fc0 <mpinit>
  lapicinit();     // interrupt controller
80102e50:	e8 5b f7 ff ff       	call   801025b0 <lapicinit>
  seginit();       // segment descriptors
80102e55:	e8 f6 37 00 00       	call   80106650 <seginit>
  picinit();       // disable pic
80102e5a:	e8 31 03 00 00       	call   80103190 <picinit>
  ioapicinit();    // another interrupt controller
80102e5f:	e8 4c f3 ff ff       	call   801021b0 <ioapicinit>
  consoleinit();   // console hardware
80102e64:	e8 37 db ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102e69:	e8 42 2b 00 00       	call   801059b0 <uartinit>
  pinit();         // process table
80102e6e:	e8 0d 08 00 00       	call   80103680 <pinit>
  shminit();       // shared memory
80102e73:	e8 f8 40 00 00       	call   80106f70 <shminit>
  tvinit();        // trap vectors
80102e78:	e8 a3 27 00 00       	call   80105620 <tvinit>
  binit();         // buffer cache
80102e7d:	e8 be d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102e82:	e8 89 de ff ff       	call   80100d10 <fileinit>
  ideinit();       // disk 
80102e87:	e8 04 f1 ff ff       	call   80101f90 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e8c:	83 c4 0c             	add    $0xc,%esp
80102e8f:	68 8a 00 00 00       	push   $0x8a
80102e94:	68 8c a4 10 80       	push   $0x8010a48c
80102e99:	68 00 70 00 80       	push   $0x80007000
80102e9e:	e8 dd 15 00 00       	call   80104480 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102ea3:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102eaa:	00 00 00 
80102ead:	83 c4 10             	add    $0x10,%esp
80102eb0:	05 80 27 11 80       	add    $0x80112780,%eax
80102eb5:	39 d8                	cmp    %ebx,%eax
80102eb7:	76 6a                	jbe    80102f23 <main+0x103>
80102eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102ec0:	e8 db 07 00 00       	call   801036a0 <mycpu>
80102ec5:	39 d8                	cmp    %ebx,%eax
80102ec7:	74 41                	je     80102f0a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102ec9:	e8 82 f5 ff ff       	call   80102450 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ece:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80102ed3:	c7 05 f8 6f 00 80 00 	movl   $0x80102e00,0x80006ff8
80102eda:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102edd:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102ee4:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ee7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102eec:	0f b6 03             	movzbl (%ebx),%eax
80102eef:	83 ec 08             	sub    $0x8,%esp
80102ef2:	68 00 70 00 00       	push   $0x7000
80102ef7:	50                   	push   %eax
80102ef8:	e8 03 f8 ff ff       	call   80102700 <lapicstartap>
80102efd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f00:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f06:	85 c0                	test   %eax,%eax
80102f08:	74 f6                	je     80102f00 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f0a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f11:	00 00 00 
80102f14:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f1a:	05 80 27 11 80       	add    $0x80112780,%eax
80102f1f:	39 c3                	cmp    %eax,%ebx
80102f21:	72 9d                	jb     80102ec0 <main+0xa0>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f23:	83 ec 08             	sub    $0x8,%esp
80102f26:	68 00 00 00 8e       	push   $0x8e000000
80102f2b:	68 00 00 40 80       	push   $0x80400000
80102f30:	e8 bb f4 ff ff       	call   801023f0 <kinit2>
  userinit();      // first user process
80102f35:	e8 36 08 00 00       	call   80103770 <userinit>
  mpmain();        // finish this processor's setup
80102f3a:	e8 81 fe ff ff       	call   80102dc0 <mpmain>
80102f3f:	90                   	nop

80102f40 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	57                   	push   %edi
80102f44:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f45:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f4b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102f4c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f4f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f52:	39 de                	cmp    %ebx,%esi
80102f54:	73 48                	jae    80102f9e <mpsearch1+0x5e>
80102f56:	8d 76 00             	lea    0x0(%esi),%esi
80102f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f60:	83 ec 04             	sub    $0x4,%esp
80102f63:	8d 7e 10             	lea    0x10(%esi),%edi
80102f66:	6a 04                	push   $0x4
80102f68:	68 f8 74 10 80       	push   $0x801074f8
80102f6d:	56                   	push   %esi
80102f6e:	e8 ad 14 00 00       	call   80104420 <memcmp>
80102f73:	83 c4 10             	add    $0x10,%esp
80102f76:	85 c0                	test   %eax,%eax
80102f78:	75 1e                	jne    80102f98 <mpsearch1+0x58>
80102f7a:	8d 7e 10             	lea    0x10(%esi),%edi
80102f7d:	89 f2                	mov    %esi,%edx
80102f7f:	31 c9                	xor    %ecx,%ecx
80102f81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102f88:	0f b6 02             	movzbl (%edx),%eax
80102f8b:	83 c2 01             	add    $0x1,%edx
80102f8e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102f90:	39 fa                	cmp    %edi,%edx
80102f92:	75 f4                	jne    80102f88 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f94:	84 c9                	test   %cl,%cl
80102f96:	74 10                	je     80102fa8 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f98:	39 fb                	cmp    %edi,%ebx
80102f9a:	89 fe                	mov    %edi,%esi
80102f9c:	77 c2                	ja     80102f60 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102f9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102fa1:	31 c0                	xor    %eax,%eax
}
80102fa3:	5b                   	pop    %ebx
80102fa4:	5e                   	pop    %esi
80102fa5:	5f                   	pop    %edi
80102fa6:	5d                   	pop    %ebp
80102fa7:	c3                   	ret    
80102fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fab:	89 f0                	mov    %esi,%eax
80102fad:	5b                   	pop    %ebx
80102fae:	5e                   	pop    %esi
80102faf:	5f                   	pop    %edi
80102fb0:	5d                   	pop    %ebp
80102fb1:	c3                   	ret    
80102fb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fc0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	57                   	push   %edi
80102fc4:	56                   	push   %esi
80102fc5:	53                   	push   %ebx
80102fc6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102fc9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102fd0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102fd7:	c1 e0 08             	shl    $0x8,%eax
80102fda:	09 d0                	or     %edx,%eax
80102fdc:	c1 e0 04             	shl    $0x4,%eax
80102fdf:	85 c0                	test   %eax,%eax
80102fe1:	75 1b                	jne    80102ffe <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80102fe3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102fea:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102ff1:	c1 e0 08             	shl    $0x8,%eax
80102ff4:	09 d0                	or     %edx,%eax
80102ff6:	c1 e0 0a             	shl    $0xa,%eax
80102ff9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
80102ffe:	ba 00 04 00 00       	mov    $0x400,%edx
80103003:	e8 38 ff ff ff       	call   80102f40 <mpsearch1>
80103008:	85 c0                	test   %eax,%eax
8010300a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010300d:	0f 84 37 01 00 00    	je     8010314a <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103013:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103016:	8b 58 04             	mov    0x4(%eax),%ebx
80103019:	85 db                	test   %ebx,%ebx
8010301b:	0f 84 43 01 00 00    	je     80103164 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103021:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103027:	83 ec 04             	sub    $0x4,%esp
8010302a:	6a 04                	push   $0x4
8010302c:	68 fd 74 10 80       	push   $0x801074fd
80103031:	56                   	push   %esi
80103032:	e8 e9 13 00 00       	call   80104420 <memcmp>
80103037:	83 c4 10             	add    $0x10,%esp
8010303a:	85 c0                	test   %eax,%eax
8010303c:	0f 85 22 01 00 00    	jne    80103164 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103042:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103049:	3c 01                	cmp    $0x1,%al
8010304b:	74 08                	je     80103055 <mpinit+0x95>
8010304d:	3c 04                	cmp    $0x4,%al
8010304f:	0f 85 0f 01 00 00    	jne    80103164 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103055:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010305c:	85 ff                	test   %edi,%edi
8010305e:	74 21                	je     80103081 <mpinit+0xc1>
80103060:	31 d2                	xor    %edx,%edx
80103062:	31 c0                	xor    %eax,%eax
80103064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103068:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010306f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103070:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103073:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103075:	39 c7                	cmp    %eax,%edi
80103077:	75 ef                	jne    80103068 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103079:	84 d2                	test   %dl,%dl
8010307b:	0f 85 e3 00 00 00    	jne    80103164 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103081:	85 f6                	test   %esi,%esi
80103083:	0f 84 db 00 00 00    	je     80103164 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103089:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010308f:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103094:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
8010309b:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
801030a1:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030a6:	01 d6                	add    %edx,%esi
801030a8:	90                   	nop
801030a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030b0:	39 c6                	cmp    %eax,%esi
801030b2:	76 23                	jbe    801030d7 <mpinit+0x117>
801030b4:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
801030b7:	80 fa 04             	cmp    $0x4,%dl
801030ba:	0f 87 c0 00 00 00    	ja     80103180 <mpinit+0x1c0>
801030c0:	ff 24 95 3c 75 10 80 	jmp    *-0x7fef8ac4(,%edx,4)
801030c7:	89 f6                	mov    %esi,%esi
801030c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801030d0:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030d3:	39 c6                	cmp    %eax,%esi
801030d5:	77 dd                	ja     801030b4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801030d7:	85 db                	test   %ebx,%ebx
801030d9:	0f 84 92 00 00 00    	je     80103171 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801030df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030e2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801030e6:	74 15                	je     801030fd <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030e8:	ba 22 00 00 00       	mov    $0x22,%edx
801030ed:	b8 70 00 00 00       	mov    $0x70,%eax
801030f2:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030f3:	ba 23 00 00 00       	mov    $0x23,%edx
801030f8:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030f9:	83 c8 01             	or     $0x1,%eax
801030fc:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801030fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103100:	5b                   	pop    %ebx
80103101:	5e                   	pop    %esi
80103102:	5f                   	pop    %edi
80103103:	5d                   	pop    %ebp
80103104:	c3                   	ret    
80103105:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103108:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
8010310e:	83 f9 07             	cmp    $0x7,%ecx
80103111:	7f 19                	jg     8010312c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103113:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103117:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010311d:	83 c1 01             	add    $0x1,%ecx
80103120:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103126:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010312c:	83 c0 14             	add    $0x14,%eax
      continue;
8010312f:	e9 7c ff ff ff       	jmp    801030b0 <mpinit+0xf0>
80103134:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103138:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010313c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
8010313f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      p += sizeof(struct mpioapic);
      continue;
80103145:	e9 66 ff ff ff       	jmp    801030b0 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010314a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010314f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103154:	e8 e7 fd ff ff       	call   80102f40 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103159:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010315b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010315e:	0f 85 af fe ff ff    	jne    80103013 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
80103164:	83 ec 0c             	sub    $0xc,%esp
80103167:	68 02 75 10 80       	push   $0x80107502
8010316c:	e8 ff d1 ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
80103171:	83 ec 0c             	sub    $0xc,%esp
80103174:	68 1c 75 10 80       	push   $0x8010751c
80103179:	e8 f2 d1 ff ff       	call   80100370 <panic>
8010317e:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103180:	31 db                	xor    %ebx,%ebx
80103182:	e9 30 ff ff ff       	jmp    801030b7 <mpinit+0xf7>
80103187:	66 90                	xchg   %ax,%ax
80103189:	66 90                	xchg   %ax,%ax
8010318b:	66 90                	xchg   %ax,%ax
8010318d:	66 90                	xchg   %ax,%ax
8010318f:	90                   	nop

80103190 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103190:	55                   	push   %ebp
80103191:	ba 21 00 00 00       	mov    $0x21,%edx
80103196:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010319b:	89 e5                	mov    %esp,%ebp
8010319d:	ee                   	out    %al,(%dx)
8010319e:	ba a1 00 00 00       	mov    $0xa1,%edx
801031a3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801031a4:	5d                   	pop    %ebp
801031a5:	c3                   	ret    
801031a6:	66 90                	xchg   %ax,%ax
801031a8:	66 90                	xchg   %ax,%ax
801031aa:	66 90                	xchg   %ax,%ax
801031ac:	66 90                	xchg   %ax,%ax
801031ae:	66 90                	xchg   %ax,%ax

801031b0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801031b0:	55                   	push   %ebp
801031b1:	89 e5                	mov    %esp,%ebp
801031b3:	57                   	push   %edi
801031b4:	56                   	push   %esi
801031b5:	53                   	push   %ebx
801031b6:	83 ec 0c             	sub    $0xc,%esp
801031b9:	8b 75 08             	mov    0x8(%ebp),%esi
801031bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801031bf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801031c5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801031cb:	e8 60 db ff ff       	call   80100d30 <filealloc>
801031d0:	85 c0                	test   %eax,%eax
801031d2:	89 06                	mov    %eax,(%esi)
801031d4:	0f 84 a8 00 00 00    	je     80103282 <pipealloc+0xd2>
801031da:	e8 51 db ff ff       	call   80100d30 <filealloc>
801031df:	85 c0                	test   %eax,%eax
801031e1:	89 03                	mov    %eax,(%ebx)
801031e3:	0f 84 87 00 00 00    	je     80103270 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801031e9:	e8 62 f2 ff ff       	call   80102450 <kalloc>
801031ee:	85 c0                	test   %eax,%eax
801031f0:	89 c7                	mov    %eax,%edi
801031f2:	0f 84 b0 00 00 00    	je     801032a8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801031f8:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
801031fb:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103202:	00 00 00 
  p->writeopen = 1;
80103205:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010320c:	00 00 00 
  p->nwrite = 0;
8010320f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103216:	00 00 00 
  p->nread = 0;
80103219:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103220:	00 00 00 
  initlock(&p->lock, "pipe");
80103223:	68 50 75 10 80       	push   $0x80107550
80103228:	50                   	push   %eax
80103229:	e8 32 0f 00 00       	call   80104160 <initlock>
  (*f0)->type = FD_PIPE;
8010322e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103230:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103233:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103239:	8b 06                	mov    (%esi),%eax
8010323b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010323f:	8b 06                	mov    (%esi),%eax
80103241:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103245:	8b 06                	mov    (%esi),%eax
80103247:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010324a:	8b 03                	mov    (%ebx),%eax
8010324c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103252:	8b 03                	mov    (%ebx),%eax
80103254:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103258:	8b 03                	mov    (%ebx),%eax
8010325a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010325e:	8b 03                	mov    (%ebx),%eax
80103260:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103263:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103266:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103268:	5b                   	pop    %ebx
80103269:	5e                   	pop    %esi
8010326a:	5f                   	pop    %edi
8010326b:	5d                   	pop    %ebp
8010326c:	c3                   	ret    
8010326d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103270:	8b 06                	mov    (%esi),%eax
80103272:	85 c0                	test   %eax,%eax
80103274:	74 1e                	je     80103294 <pipealloc+0xe4>
    fileclose(*f0);
80103276:	83 ec 0c             	sub    $0xc,%esp
80103279:	50                   	push   %eax
8010327a:	e8 71 db ff ff       	call   80100df0 <fileclose>
8010327f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103282:	8b 03                	mov    (%ebx),%eax
80103284:	85 c0                	test   %eax,%eax
80103286:	74 0c                	je     80103294 <pipealloc+0xe4>
    fileclose(*f1);
80103288:	83 ec 0c             	sub    $0xc,%esp
8010328b:	50                   	push   %eax
8010328c:	e8 5f db ff ff       	call   80100df0 <fileclose>
80103291:	83 c4 10             	add    $0x10,%esp
  return -1;
}
80103294:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
80103297:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010329c:	5b                   	pop    %ebx
8010329d:	5e                   	pop    %esi
8010329e:	5f                   	pop    %edi
8010329f:	5d                   	pop    %ebp
801032a0:	c3                   	ret    
801032a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032a8:	8b 06                	mov    (%esi),%eax
801032aa:	85 c0                	test   %eax,%eax
801032ac:	75 c8                	jne    80103276 <pipealloc+0xc6>
801032ae:	eb d2                	jmp    80103282 <pipealloc+0xd2>

801032b0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
801032b0:	55                   	push   %ebp
801032b1:	89 e5                	mov    %esp,%ebp
801032b3:	56                   	push   %esi
801032b4:	53                   	push   %ebx
801032b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801032bb:	83 ec 0c             	sub    $0xc,%esp
801032be:	53                   	push   %ebx
801032bf:	e8 9c 0f 00 00       	call   80104260 <acquire>
  if(writable){
801032c4:	83 c4 10             	add    $0x10,%esp
801032c7:	85 f6                	test   %esi,%esi
801032c9:	74 45                	je     80103310 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801032cb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801032d1:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
801032d4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801032db:	00 00 00 
    wakeup(&p->nread);
801032de:	50                   	push   %eax
801032df:	e8 bc 0b 00 00       	call   80103ea0 <wakeup>
801032e4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801032e7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801032ed:	85 d2                	test   %edx,%edx
801032ef:	75 0a                	jne    801032fb <pipeclose+0x4b>
801032f1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801032f7:	85 c0                	test   %eax,%eax
801032f9:	74 35                	je     80103330 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032fb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103301:	5b                   	pop    %ebx
80103302:	5e                   	pop    %esi
80103303:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103304:	e9 77 10 00 00       	jmp    80104380 <release>
80103309:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103310:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103316:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103319:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103320:	00 00 00 
    wakeup(&p->nwrite);
80103323:	50                   	push   %eax
80103324:	e8 77 0b 00 00       	call   80103ea0 <wakeup>
80103329:	83 c4 10             	add    $0x10,%esp
8010332c:	eb b9                	jmp    801032e7 <pipeclose+0x37>
8010332e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103330:	83 ec 0c             	sub    $0xc,%esp
80103333:	53                   	push   %ebx
80103334:	e8 47 10 00 00       	call   80104380 <release>
    kfree((char*)p);
80103339:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010333c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010333f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103342:	5b                   	pop    %ebx
80103343:	5e                   	pop    %esi
80103344:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103345:	e9 56 ef ff ff       	jmp    801022a0 <kfree>
8010334a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103350 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103350:	55                   	push   %ebp
80103351:	89 e5                	mov    %esp,%ebp
80103353:	57                   	push   %edi
80103354:	56                   	push   %esi
80103355:	53                   	push   %ebx
80103356:	83 ec 28             	sub    $0x28,%esp
80103359:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010335c:	53                   	push   %ebx
8010335d:	e8 fe 0e 00 00       	call   80104260 <acquire>
  for(i = 0; i < n; i++){
80103362:	8b 45 10             	mov    0x10(%ebp),%eax
80103365:	83 c4 10             	add    $0x10,%esp
80103368:	85 c0                	test   %eax,%eax
8010336a:	0f 8e b9 00 00 00    	jle    80103429 <pipewrite+0xd9>
80103370:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103373:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103379:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010337f:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103385:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103388:	03 4d 10             	add    0x10(%ebp),%ecx
8010338b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010338e:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103394:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
8010339a:	39 d0                	cmp    %edx,%eax
8010339c:	74 38                	je     801033d6 <pipewrite+0x86>
8010339e:	eb 59                	jmp    801033f9 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
801033a0:	e8 9b 03 00 00       	call   80103740 <myproc>
801033a5:	8b 48 24             	mov    0x24(%eax),%ecx
801033a8:	85 c9                	test   %ecx,%ecx
801033aa:	75 34                	jne    801033e0 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033ac:	83 ec 0c             	sub    $0xc,%esp
801033af:	57                   	push   %edi
801033b0:	e8 eb 0a 00 00       	call   80103ea0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033b5:	58                   	pop    %eax
801033b6:	5a                   	pop    %edx
801033b7:	53                   	push   %ebx
801033b8:	56                   	push   %esi
801033b9:	e8 32 09 00 00       	call   80103cf0 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033be:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801033c4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801033ca:	83 c4 10             	add    $0x10,%esp
801033cd:	05 00 02 00 00       	add    $0x200,%eax
801033d2:	39 c2                	cmp    %eax,%edx
801033d4:	75 2a                	jne    80103400 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
801033d6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801033dc:	85 c0                	test   %eax,%eax
801033de:	75 c0                	jne    801033a0 <pipewrite+0x50>
        release(&p->lock);
801033e0:	83 ec 0c             	sub    $0xc,%esp
801033e3:	53                   	push   %ebx
801033e4:	e8 97 0f 00 00       	call   80104380 <release>
        return -1;
801033e9:	83 c4 10             	add    $0x10,%esp
801033ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801033f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033f4:	5b                   	pop    %ebx
801033f5:	5e                   	pop    %esi
801033f6:	5f                   	pop    %edi
801033f7:	5d                   	pop    %ebp
801033f8:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033f9:	89 c2                	mov    %eax,%edx
801033fb:	90                   	nop
801033fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103400:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103403:	8d 42 01             	lea    0x1(%edx),%eax
80103406:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010340a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103410:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103416:	0f b6 09             	movzbl (%ecx),%ecx
80103419:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
8010341d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103420:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103423:	0f 85 65 ff ff ff    	jne    8010338e <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103429:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010342f:	83 ec 0c             	sub    $0xc,%esp
80103432:	50                   	push   %eax
80103433:	e8 68 0a 00 00       	call   80103ea0 <wakeup>
  release(&p->lock);
80103438:	89 1c 24             	mov    %ebx,(%esp)
8010343b:	e8 40 0f 00 00       	call   80104380 <release>
  return n;
80103440:	83 c4 10             	add    $0x10,%esp
80103443:	8b 45 10             	mov    0x10(%ebp),%eax
80103446:	eb a9                	jmp    801033f1 <pipewrite+0xa1>
80103448:	90                   	nop
80103449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103450 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103450:	55                   	push   %ebp
80103451:	89 e5                	mov    %esp,%ebp
80103453:	57                   	push   %edi
80103454:	56                   	push   %esi
80103455:	53                   	push   %ebx
80103456:	83 ec 18             	sub    $0x18,%esp
80103459:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010345c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010345f:	53                   	push   %ebx
80103460:	e8 fb 0d 00 00       	call   80104260 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103465:	83 c4 10             	add    $0x10,%esp
80103468:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010346e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103474:	75 6a                	jne    801034e0 <piperead+0x90>
80103476:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
8010347c:	85 f6                	test   %esi,%esi
8010347e:	0f 84 cc 00 00 00    	je     80103550 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103484:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010348a:	eb 2d                	jmp    801034b9 <piperead+0x69>
8010348c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103490:	83 ec 08             	sub    $0x8,%esp
80103493:	53                   	push   %ebx
80103494:	56                   	push   %esi
80103495:	e8 56 08 00 00       	call   80103cf0 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010349a:	83 c4 10             	add    $0x10,%esp
8010349d:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801034a3:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
801034a9:	75 35                	jne    801034e0 <piperead+0x90>
801034ab:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
801034b1:	85 d2                	test   %edx,%edx
801034b3:	0f 84 97 00 00 00    	je     80103550 <piperead+0x100>
    if(myproc()->killed){
801034b9:	e8 82 02 00 00       	call   80103740 <myproc>
801034be:	8b 48 24             	mov    0x24(%eax),%ecx
801034c1:	85 c9                	test   %ecx,%ecx
801034c3:	74 cb                	je     80103490 <piperead+0x40>
      release(&p->lock);
801034c5:	83 ec 0c             	sub    $0xc,%esp
801034c8:	53                   	push   %ebx
801034c9:	e8 b2 0e 00 00       	call   80104380 <release>
      return -1;
801034ce:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801034d1:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
801034d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801034d9:	5b                   	pop    %ebx
801034da:	5e                   	pop    %esi
801034db:	5f                   	pop    %edi
801034dc:	5d                   	pop    %ebp
801034dd:	c3                   	ret    
801034de:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034e0:	8b 45 10             	mov    0x10(%ebp),%eax
801034e3:	85 c0                	test   %eax,%eax
801034e5:	7e 69                	jle    80103550 <piperead+0x100>
    if(p->nread == p->nwrite)
801034e7:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801034ed:	31 c9                	xor    %ecx,%ecx
801034ef:	eb 15                	jmp    80103506 <piperead+0xb6>
801034f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034f8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801034fe:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103504:	74 5a                	je     80103560 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103506:	8d 70 01             	lea    0x1(%eax),%esi
80103509:	25 ff 01 00 00       	and    $0x1ff,%eax
8010350e:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103514:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103519:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010351c:	83 c1 01             	add    $0x1,%ecx
8010351f:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103522:	75 d4                	jne    801034f8 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103524:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010352a:	83 ec 0c             	sub    $0xc,%esp
8010352d:	50                   	push   %eax
8010352e:	e8 6d 09 00 00       	call   80103ea0 <wakeup>
  release(&p->lock);
80103533:	89 1c 24             	mov    %ebx,(%esp)
80103536:	e8 45 0e 00 00       	call   80104380 <release>
  return i;
8010353b:	8b 45 10             	mov    0x10(%ebp),%eax
8010353e:	83 c4 10             	add    $0x10,%esp
}
80103541:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103544:	5b                   	pop    %ebx
80103545:	5e                   	pop    %esi
80103546:	5f                   	pop    %edi
80103547:	5d                   	pop    %ebp
80103548:	c3                   	ret    
80103549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103550:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103557:	eb cb                	jmp    80103524 <piperead+0xd4>
80103559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103560:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103563:	eb bf                	jmp    80103524 <piperead+0xd4>
80103565:	66 90                	xchg   %ax,%ax
80103567:	66 90                	xchg   %ax,%ax
80103569:	66 90                	xchg   %ax,%ax
8010356b:	66 90                	xchg   %ax,%ax
8010356d:	66 90                	xchg   %ax,%ax
8010356f:	90                   	nop

80103570 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103570:	55                   	push   %ebp
80103571:	89 e5                	mov    %esp,%ebp
80103573:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103574:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103579:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010357c:	68 20 2d 11 80       	push   $0x80112d20
80103581:	e8 da 0c 00 00       	call   80104260 <acquire>
80103586:	83 c4 10             	add    $0x10,%esp
80103589:	eb 10                	jmp    8010359b <allocproc+0x2b>
8010358b:	90                   	nop
8010358c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103590:	83 eb 80             	sub    $0xffffff80,%ebx
80103593:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103599:	74 75                	je     80103610 <allocproc+0xa0>
    if(p->state == UNUSED)
8010359b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010359e:	85 c0                	test   %eax,%eax
801035a0:	75 ee                	jne    80103590 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801035a2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801035a7:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801035aa:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;

  release(&ptable.lock);
801035b1:	68 20 2d 11 80       	push   $0x80112d20
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801035b6:	8d 50 01             	lea    0x1(%eax),%edx
801035b9:	89 43 10             	mov    %eax,0x10(%ebx)
801035bc:	89 15 04 a0 10 80    	mov    %edx,0x8010a004

  release(&ptable.lock);
801035c2:	e8 b9 0d 00 00       	call   80104380 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801035c7:	e8 84 ee ff ff       	call   80102450 <kalloc>
801035cc:	83 c4 10             	add    $0x10,%esp
801035cf:	85 c0                	test   %eax,%eax
801035d1:	89 43 08             	mov    %eax,0x8(%ebx)
801035d4:	74 51                	je     80103627 <allocproc+0xb7>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801035d6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801035dc:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
801035df:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801035e4:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801035e7:	c7 40 14 12 56 10 80 	movl   $0x80105612,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801035ee:	6a 14                	push   $0x14
801035f0:	6a 00                	push   $0x0
801035f2:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
801035f3:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801035f6:	e8 d5 0d 00 00       	call   801043d0 <memset>
  p->context->eip = (uint)forkret;
801035fb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801035fe:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
80103601:	c7 40 10 30 36 10 80 	movl   $0x80103630,0x10(%eax)

  return p;
80103608:	89 d8                	mov    %ebx,%eax
}
8010360a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010360d:	c9                   	leave  
8010360e:	c3                   	ret    
8010360f:	90                   	nop

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103610:	83 ec 0c             	sub    $0xc,%esp
80103613:	68 20 2d 11 80       	push   $0x80112d20
80103618:	e8 63 0d 00 00       	call   80104380 <release>
  return 0;
8010361d:	83 c4 10             	add    $0x10,%esp
80103620:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103622:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103625:	c9                   	leave  
80103626:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103627:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010362e:	eb da                	jmp    8010360a <allocproc+0x9a>

80103630 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103636:	68 20 2d 11 80       	push   $0x80112d20
8010363b:	e8 40 0d 00 00       	call   80104380 <release>

  if (first) {
80103640:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103645:	83 c4 10             	add    $0x10,%esp
80103648:	85 c0                	test   %eax,%eax
8010364a:	75 04                	jne    80103650 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010364c:	c9                   	leave  
8010364d:	c3                   	ret    
8010364e:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103650:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103653:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010365a:	00 00 00 
    iinit(ROOTDEV);
8010365d:	6a 01                	push   $0x1
8010365f:	e8 cc dd ff ff       	call   80101430 <iinit>
    initlog(ROOTDEV);
80103664:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010366b:	e8 00 f4 ff ff       	call   80102a70 <initlog>
80103670:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103673:	c9                   	leave  
80103674:	c3                   	ret    
80103675:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103680 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103686:	68 55 75 10 80       	push   $0x80107555
8010368b:	68 20 2d 11 80       	push   $0x80112d20
80103690:	e8 cb 0a 00 00       	call   80104160 <initlock>
}
80103695:	83 c4 10             	add    $0x10,%esp
80103698:	c9                   	leave  
80103699:	c3                   	ret    
8010369a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801036a0 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	56                   	push   %esi
801036a4:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801036a5:	9c                   	pushf  
801036a6:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
801036a7:	f6 c4 02             	test   $0x2,%ah
801036aa:	75 5b                	jne    80103707 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
801036ac:	e8 ff ef ff ff       	call   801026b0 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801036b1:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801036b7:	85 f6                	test   %esi,%esi
801036b9:	7e 3f                	jle    801036fa <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
801036bb:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
801036c2:	39 d0                	cmp    %edx,%eax
801036c4:	74 30                	je     801036f6 <mycpu+0x56>
801036c6:	b9 30 28 11 80       	mov    $0x80112830,%ecx
801036cb:	31 d2                	xor    %edx,%edx
801036cd:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801036d0:	83 c2 01             	add    $0x1,%edx
801036d3:	39 f2                	cmp    %esi,%edx
801036d5:	74 23                	je     801036fa <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
801036d7:	0f b6 19             	movzbl (%ecx),%ebx
801036da:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801036e0:	39 d8                	cmp    %ebx,%eax
801036e2:	75 ec                	jne    801036d0 <mycpu+0x30>
      return &cpus[i];
801036e4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
801036ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036ed:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
801036ee:	05 80 27 11 80       	add    $0x80112780,%eax
  }
  panic("unknown apicid\n");
}
801036f3:	5e                   	pop    %esi
801036f4:	5d                   	pop    %ebp
801036f5:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801036f6:	31 d2                	xor    %edx,%edx
801036f8:	eb ea                	jmp    801036e4 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
801036fa:	83 ec 0c             	sub    $0xc,%esp
801036fd:	68 5c 75 10 80       	push   $0x8010755c
80103702:	e8 69 cc ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103707:	83 ec 0c             	sub    $0xc,%esp
8010370a:	68 38 76 10 80       	push   $0x80107638
8010370f:	e8 5c cc ff ff       	call   80100370 <panic>
80103714:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010371a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103720 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103720:	55                   	push   %ebp
80103721:	89 e5                	mov    %esp,%ebp
80103723:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103726:	e8 75 ff ff ff       	call   801036a0 <mycpu>
8010372b:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103730:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
80103731:	c1 f8 04             	sar    $0x4,%eax
80103734:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010373a:	c3                   	ret    
8010373b:	90                   	nop
8010373c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103740 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103740:	55                   	push   %ebp
80103741:	89 e5                	mov    %esp,%ebp
80103743:	53                   	push   %ebx
80103744:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103747:	e8 d4 0a 00 00       	call   80104220 <pushcli>
  c = mycpu();
8010374c:	e8 4f ff ff ff       	call   801036a0 <mycpu>
  p = c->proc;
80103751:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103757:	e8 b4 0b 00 00       	call   80104310 <popcli>
  return p;
}
8010375c:	83 c4 04             	add    $0x4,%esp
8010375f:	89 d8                	mov    %ebx,%eax
80103761:	5b                   	pop    %ebx
80103762:	5d                   	pop    %ebp
80103763:	c3                   	ret    
80103764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010376a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103770 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103770:	55                   	push   %ebp
80103771:	89 e5                	mov    %esp,%ebp
80103773:	53                   	push   %ebx
80103774:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103777:	e8 f4 fd ff ff       	call   80103570 <allocproc>
8010377c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
8010377e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103783:	e8 78 34 00 00       	call   80106c00 <setupkvm>
80103788:	85 c0                	test   %eax,%eax
8010378a:	89 43 04             	mov    %eax,0x4(%ebx)
8010378d:	0f 84 bd 00 00 00    	je     80103850 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103793:	83 ec 04             	sub    $0x4,%esp
80103796:	68 2c 00 00 00       	push   $0x2c
8010379b:	68 60 a4 10 80       	push   $0x8010a460
801037a0:	50                   	push   %eax
801037a1:	e8 6a 31 00 00       	call   80106910 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
801037a6:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
801037a9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801037af:	6a 4c                	push   $0x4c
801037b1:	6a 00                	push   $0x0
801037b3:	ff 73 18             	pushl  0x18(%ebx)
801037b6:	e8 15 0c 00 00       	call   801043d0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801037bb:	8b 43 18             	mov    0x18(%ebx),%eax
801037be:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801037c3:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
801037c8:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801037cb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801037cf:	8b 43 18             	mov    0x18(%ebx),%eax
801037d2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801037d6:	8b 43 18             	mov    0x18(%ebx),%eax
801037d9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801037dd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801037e1:	8b 43 18             	mov    0x18(%ebx),%eax
801037e4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801037e8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801037ec:	8b 43 18             	mov    0x18(%ebx),%eax
801037ef:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801037f6:	8b 43 18             	mov    0x18(%ebx),%eax
801037f9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103800:	8b 43 18             	mov    0x18(%ebx),%eax
80103803:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010380a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010380d:	6a 10                	push   $0x10
8010380f:	68 85 75 10 80       	push   $0x80107585
80103814:	50                   	push   %eax
80103815:	e8 b6 0d 00 00       	call   801045d0 <safestrcpy>
  p->cwd = namei("/");
8010381a:	c7 04 24 8e 75 10 80 	movl   $0x8010758e,(%esp)
80103821:	e8 5a e6 ff ff       	call   80101e80 <namei>
80103826:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103829:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103830:	e8 2b 0a 00 00       	call   80104260 <acquire>

  p->state = RUNNABLE;
80103835:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
8010383c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103843:	e8 38 0b 00 00       	call   80104380 <release>
}
80103848:	83 c4 10             	add    $0x10,%esp
8010384b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010384e:	c9                   	leave  
8010384f:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103850:	83 ec 0c             	sub    $0xc,%esp
80103853:	68 6c 75 10 80       	push   $0x8010756c
80103858:	e8 13 cb ff ff       	call   80100370 <panic>
8010385d:	8d 76 00             	lea    0x0(%esi),%esi

80103860 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	56                   	push   %esi
80103864:	53                   	push   %ebx
80103865:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103868:	e8 b3 09 00 00       	call   80104220 <pushcli>
  c = mycpu();
8010386d:	e8 2e fe ff ff       	call   801036a0 <mycpu>
  p = c->proc;
80103872:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103878:	e8 93 0a 00 00       	call   80104310 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
8010387d:	83 fe 00             	cmp    $0x0,%esi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
80103880:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103882:	7e 34                	jle    801038b8 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103884:	83 ec 04             	sub    $0x4,%esp
80103887:	01 c6                	add    %eax,%esi
80103889:	56                   	push   %esi
8010388a:	50                   	push   %eax
8010388b:	ff 73 04             	pushl  0x4(%ebx)
8010388e:	e8 bd 31 00 00       	call   80106a50 <allocuvm>
80103893:	83 c4 10             	add    $0x10,%esp
80103896:	85 c0                	test   %eax,%eax
80103898:	74 36                	je     801038d0 <growproc+0x70>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
8010389a:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
8010389d:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010389f:	53                   	push   %ebx
801038a0:	e8 5b 2f 00 00       	call   80106800 <switchuvm>
  return 0;
801038a5:	83 c4 10             	add    $0x10,%esp
801038a8:	31 c0                	xor    %eax,%eax
}
801038aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038ad:	5b                   	pop    %ebx
801038ae:	5e                   	pop    %esi
801038af:	5d                   	pop    %ebp
801038b0:	c3                   	ret    
801038b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
801038b8:	74 e0                	je     8010389a <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801038ba:	83 ec 04             	sub    $0x4,%esp
801038bd:	01 c6                	add    %eax,%esi
801038bf:	56                   	push   %esi
801038c0:	50                   	push   %eax
801038c1:	ff 73 04             	pushl  0x4(%ebx)
801038c4:	e8 87 32 00 00       	call   80106b50 <deallocuvm>
801038c9:	83 c4 10             	add    $0x10,%esp
801038cc:	85 c0                	test   %eax,%eax
801038ce:	75 ca                	jne    8010389a <growproc+0x3a>
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
801038d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038d5:	eb d3                	jmp    801038aa <growproc+0x4a>
801038d7:	89 f6                	mov    %esi,%esi
801038d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038e0 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	57                   	push   %edi
801038e4:	56                   	push   %esi
801038e5:	53                   	push   %ebx
801038e6:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801038e9:	e8 32 09 00 00       	call   80104220 <pushcli>
  c = mycpu();
801038ee:	e8 ad fd ff ff       	call   801036a0 <mycpu>
  p = c->proc;
801038f3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801038f9:	e8 12 0a 00 00       	call   80104310 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
801038fe:	e8 6d fc ff ff       	call   80103570 <allocproc>
80103903:	85 c0                	test   %eax,%eax
80103905:	89 c7                	mov    %eax,%edi
80103907:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010390a:	0f 84 bd 00 00 00    	je     801039cd <fork+0xed>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz, curproc->stack_sz)) == 0){
80103910:	83 ec 04             	sub    $0x4,%esp
80103913:	ff 73 7c             	pushl  0x7c(%ebx)
80103916:	ff 33                	pushl  (%ebx)
80103918:	ff 73 04             	pushl  0x4(%ebx)
8010391b:	e8 b0 33 00 00       	call   80106cd0 <copyuvm>
80103920:	83 c4 10             	add    $0x10,%esp
80103923:	85 c0                	test   %eax,%eax
80103925:	89 47 04             	mov    %eax,0x4(%edi)
80103928:	0f 84 a6 00 00 00    	je     801039d4 <fork+0xf4>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
8010392e:	8b 03                	mov    (%ebx),%eax
80103930:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103933:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103935:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103938:	89 c8                	mov    %ecx,%eax
8010393a:	8b 79 18             	mov    0x18(%ecx),%edi
8010393d:	8b 73 18             	mov    0x18(%ebx),%esi
80103940:	b9 13 00 00 00       	mov    $0x13,%ecx
80103945:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103947:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103949:	8b 40 18             	mov    0x18(%eax),%eax
8010394c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103953:	90                   	nop
80103954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103958:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010395c:	85 c0                	test   %eax,%eax
8010395e:	74 13                	je     80103973 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103960:	83 ec 0c             	sub    $0xc,%esp
80103963:	50                   	push   %eax
80103964:	e8 37 d4 ff ff       	call   80100da0 <filedup>
80103969:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010396c:	83 c4 10             	add    $0x10,%esp
8010396f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103973:	83 c6 01             	add    $0x1,%esi
80103976:	83 fe 10             	cmp    $0x10,%esi
80103979:	75 dd                	jne    80103958 <fork+0x78>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
8010397b:	83 ec 0c             	sub    $0xc,%esp
8010397e:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103981:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103984:	e8 77 dc ff ff       	call   80101600 <idup>
80103989:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010398c:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
8010398f:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103992:	8d 47 6c             	lea    0x6c(%edi),%eax
80103995:	6a 10                	push   $0x10
80103997:	53                   	push   %ebx
80103998:	50                   	push   %eax
80103999:	e8 32 0c 00 00       	call   801045d0 <safestrcpy>

  pid = np->pid;
8010399e:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
801039a1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039a8:	e8 b3 08 00 00       	call   80104260 <acquire>

  np->state = RUNNABLE;
801039ad:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
801039b4:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039bb:	e8 c0 09 00 00       	call   80104380 <release>

  return pid;
801039c0:	83 c4 10             	add    $0x10,%esp
801039c3:	89 d8                	mov    %ebx,%eax
}
801039c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039c8:	5b                   	pop    %ebx
801039c9:	5e                   	pop    %esi
801039ca:	5f                   	pop    %edi
801039cb:	5d                   	pop    %ebp
801039cc:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
801039cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039d2:	eb f1                	jmp    801039c5 <fork+0xe5>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz, curproc->stack_sz)) == 0){
    kfree(np->kstack);
801039d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801039d7:	83 ec 0c             	sub    $0xc,%esp
801039da:	ff 77 08             	pushl  0x8(%edi)
801039dd:	e8 be e8 ff ff       	call   801022a0 <kfree>
    np->kstack = 0;
801039e2:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
801039e9:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
801039f0:	83 c4 10             	add    $0x10,%esp
801039f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039f8:	eb cb                	jmp    801039c5 <fork+0xe5>
801039fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a00 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103a00:	55                   	push   %ebp
80103a01:	89 e5                	mov    %esp,%ebp
80103a03:	57                   	push   %edi
80103a04:	56                   	push   %esi
80103a05:	53                   	push   %ebx
80103a06:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103a09:	e8 92 fc ff ff       	call   801036a0 <mycpu>
80103a0e:	8d 78 04             	lea    0x4(%eax),%edi
80103a11:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103a13:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103a1a:	00 00 00 
80103a1d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103a20:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a21:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a24:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a29:	68 20 2d 11 80       	push   $0x80112d20
80103a2e:	e8 2d 08 00 00       	call   80104260 <acquire>
80103a33:	83 c4 10             	add    $0x10,%esp
80103a36:	eb 13                	jmp    80103a4b <scheduler+0x4b>
80103a38:	90                   	nop
80103a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a40:	83 eb 80             	sub    $0xffffff80,%ebx
80103a43:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103a49:	74 45                	je     80103a90 <scheduler+0x90>
      if(p->state != RUNNABLE)
80103a4b:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103a4f:	75 ef                	jne    80103a40 <scheduler+0x40>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103a51:	83 ec 0c             	sub    $0xc,%esp
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103a54:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103a5a:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a5b:	83 eb 80             	sub    $0xffffff80,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103a5e:	e8 9d 2d 00 00       	call   80106800 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103a63:	58                   	pop    %eax
80103a64:	5a                   	pop    %edx
80103a65:	ff 73 9c             	pushl  -0x64(%ebx)
80103a68:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103a69:	c7 43 8c 04 00 00 00 	movl   $0x4,-0x74(%ebx)

      swtch(&(c->scheduler), p->context);
80103a70:	e8 b6 0b 00 00       	call   8010462b <swtch>
      switchkvm();
80103a75:	e8 66 2d 00 00       	call   801067e0 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103a7a:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a7d:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103a83:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103a8a:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a8d:	75 bc                	jne    80103a4b <scheduler+0x4b>
80103a8f:	90                   	nop

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103a90:	83 ec 0c             	sub    $0xc,%esp
80103a93:	68 20 2d 11 80       	push   $0x80112d20
80103a98:	e8 e3 08 00 00       	call   80104380 <release>

  }
80103a9d:	83 c4 10             	add    $0x10,%esp
80103aa0:	e9 7b ff ff ff       	jmp    80103a20 <scheduler+0x20>
80103aa5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ab0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	56                   	push   %esi
80103ab4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103ab5:	e8 66 07 00 00       	call   80104220 <pushcli>
  c = mycpu();
80103aba:	e8 e1 fb ff ff       	call   801036a0 <mycpu>
  p = c->proc;
80103abf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ac5:	e8 46 08 00 00       	call   80104310 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103aca:	83 ec 0c             	sub    $0xc,%esp
80103acd:	68 20 2d 11 80       	push   $0x80112d20
80103ad2:	e8 09 07 00 00       	call   801041e0 <holding>
80103ad7:	83 c4 10             	add    $0x10,%esp
80103ada:	85 c0                	test   %eax,%eax
80103adc:	74 4f                	je     80103b2d <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103ade:	e8 bd fb ff ff       	call   801036a0 <mycpu>
80103ae3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103aea:	75 68                	jne    80103b54 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
80103aec:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103af0:	74 55                	je     80103b47 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103af2:	9c                   	pushf  
80103af3:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103af4:	f6 c4 02             	test   $0x2,%ah
80103af7:	75 41                	jne    80103b3a <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103af9:	e8 a2 fb ff ff       	call   801036a0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103afe:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103b01:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103b07:	e8 94 fb ff ff       	call   801036a0 <mycpu>
80103b0c:	83 ec 08             	sub    $0x8,%esp
80103b0f:	ff 70 04             	pushl  0x4(%eax)
80103b12:	53                   	push   %ebx
80103b13:	e8 13 0b 00 00       	call   8010462b <swtch>
  mycpu()->intena = intena;
80103b18:	e8 83 fb ff ff       	call   801036a0 <mycpu>
}
80103b1d:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80103b20:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103b26:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b29:	5b                   	pop    %ebx
80103b2a:	5e                   	pop    %esi
80103b2b:	5d                   	pop    %ebp
80103b2c:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103b2d:	83 ec 0c             	sub    $0xc,%esp
80103b30:	68 90 75 10 80       	push   $0x80107590
80103b35:	e8 36 c8 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103b3a:	83 ec 0c             	sub    $0xc,%esp
80103b3d:	68 bc 75 10 80       	push   $0x801075bc
80103b42:	e8 29 c8 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103b47:	83 ec 0c             	sub    $0xc,%esp
80103b4a:	68 ae 75 10 80       	push   $0x801075ae
80103b4f:	e8 1c c8 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103b54:	83 ec 0c             	sub    $0xc,%esp
80103b57:	68 a2 75 10 80       	push   $0x801075a2
80103b5c:	e8 0f c8 ff ff       	call   80100370 <panic>
80103b61:	eb 0d                	jmp    80103b70 <exit>
80103b63:	90                   	nop
80103b64:	90                   	nop
80103b65:	90                   	nop
80103b66:	90                   	nop
80103b67:	90                   	nop
80103b68:	90                   	nop
80103b69:	90                   	nop
80103b6a:	90                   	nop
80103b6b:	90                   	nop
80103b6c:	90                   	nop
80103b6d:	90                   	nop
80103b6e:	90                   	nop
80103b6f:	90                   	nop

80103b70 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	57                   	push   %edi
80103b74:	56                   	push   %esi
80103b75:	53                   	push   %ebx
80103b76:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103b79:	e8 a2 06 00 00       	call   80104220 <pushcli>
  c = mycpu();
80103b7e:	e8 1d fb ff ff       	call   801036a0 <mycpu>
  p = c->proc;
80103b83:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103b89:	e8 82 07 00 00       	call   80104310 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103b8e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103b94:	8d 5e 28             	lea    0x28(%esi),%ebx
80103b97:	8d 7e 68             	lea    0x68(%esi),%edi
80103b9a:	0f 84 e7 00 00 00    	je     80103c87 <exit+0x117>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103ba0:	8b 03                	mov    (%ebx),%eax
80103ba2:	85 c0                	test   %eax,%eax
80103ba4:	74 12                	je     80103bb8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103ba6:	83 ec 0c             	sub    $0xc,%esp
80103ba9:	50                   	push   %eax
80103baa:	e8 41 d2 ff ff       	call   80100df0 <fileclose>
      curproc->ofile[fd] = 0;
80103baf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103bb5:	83 c4 10             	add    $0x10,%esp
80103bb8:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103bbb:	39 df                	cmp    %ebx,%edi
80103bbd:	75 e1                	jne    80103ba0 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103bbf:	e8 4c ef ff ff       	call   80102b10 <begin_op>
  iput(curproc->cwd);
80103bc4:	83 ec 0c             	sub    $0xc,%esp
80103bc7:	ff 76 68             	pushl  0x68(%esi)
80103bca:	e8 91 db ff ff       	call   80101760 <iput>
  end_op();
80103bcf:	e8 ac ef ff ff       	call   80102b80 <end_op>
  curproc->cwd = 0;
80103bd4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
80103bdb:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103be2:	e8 79 06 00 00       	call   80104260 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103be7:	8b 56 14             	mov    0x14(%esi),%edx
80103bea:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bed:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103bf2:	eb 0e                	jmp    80103c02 <exit+0x92>
80103bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103bf8:	83 e8 80             	sub    $0xffffff80,%eax
80103bfb:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103c00:	74 1c                	je     80103c1e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103c02:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103c06:	75 f0                	jne    80103bf8 <exit+0x88>
80103c08:	3b 50 20             	cmp    0x20(%eax),%edx
80103c0b:	75 eb                	jne    80103bf8 <exit+0x88>
      p->state = RUNNABLE;
80103c0d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c14:	83 e8 80             	sub    $0xffffff80,%eax
80103c17:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103c1c:	75 e4                	jne    80103c02 <exit+0x92>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103c1e:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
80103c24:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103c29:	eb 10                	jmp    80103c3b <exit+0xcb>
80103c2b:	90                   	nop
80103c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c30:	83 ea 80             	sub    $0xffffff80,%edx
80103c33:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103c39:	74 33                	je     80103c6e <exit+0xfe>
    if(p->parent == curproc){
80103c3b:	39 72 14             	cmp    %esi,0x14(%edx)
80103c3e:	75 f0                	jne    80103c30 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103c40:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103c44:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103c47:	75 e7                	jne    80103c30 <exit+0xc0>
80103c49:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103c4e:	eb 0a                	jmp    80103c5a <exit+0xea>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c50:	83 e8 80             	sub    $0xffffff80,%eax
80103c53:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103c58:	74 d6                	je     80103c30 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103c5a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103c5e:	75 f0                	jne    80103c50 <exit+0xe0>
80103c60:	3b 48 20             	cmp    0x20(%eax),%ecx
80103c63:	75 eb                	jne    80103c50 <exit+0xe0>
      p->state = RUNNABLE;
80103c65:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103c6c:	eb e2                	jmp    80103c50 <exit+0xe0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103c6e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103c75:	e8 36 fe ff ff       	call   80103ab0 <sched>
  panic("zombie exit");
80103c7a:	83 ec 0c             	sub    $0xc,%esp
80103c7d:	68 dd 75 10 80       	push   $0x801075dd
80103c82:	e8 e9 c6 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103c87:	83 ec 0c             	sub    $0xc,%esp
80103c8a:	68 d0 75 10 80       	push   $0x801075d0
80103c8f:	e8 dc c6 ff ff       	call   80100370 <panic>
80103c94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103ca0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	53                   	push   %ebx
80103ca4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103ca7:	68 20 2d 11 80       	push   $0x80112d20
80103cac:	e8 af 05 00 00       	call   80104260 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103cb1:	e8 6a 05 00 00       	call   80104220 <pushcli>
  c = mycpu();
80103cb6:	e8 e5 f9 ff ff       	call   801036a0 <mycpu>
  p = c->proc;
80103cbb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cc1:	e8 4a 06 00 00       	call   80104310 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
80103cc6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103ccd:	e8 de fd ff ff       	call   80103ab0 <sched>
  release(&ptable.lock);
80103cd2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103cd9:	e8 a2 06 00 00       	call   80104380 <release>
}
80103cde:	83 c4 10             	add    $0x10,%esp
80103ce1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ce4:	c9                   	leave  
80103ce5:	c3                   	ret    
80103ce6:	8d 76 00             	lea    0x0(%esi),%esi
80103ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103cf0 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	57                   	push   %edi
80103cf4:	56                   	push   %esi
80103cf5:	53                   	push   %ebx
80103cf6:	83 ec 0c             	sub    $0xc,%esp
80103cf9:	8b 7d 08             	mov    0x8(%ebp),%edi
80103cfc:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103cff:	e8 1c 05 00 00       	call   80104220 <pushcli>
  c = mycpu();
80103d04:	e8 97 f9 ff ff       	call   801036a0 <mycpu>
  p = c->proc;
80103d09:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d0f:	e8 fc 05 00 00       	call   80104310 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80103d14:	85 db                	test   %ebx,%ebx
80103d16:	0f 84 87 00 00 00    	je     80103da3 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
80103d1c:	85 f6                	test   %esi,%esi
80103d1e:	74 76                	je     80103d96 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103d20:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103d26:	74 50                	je     80103d78 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103d28:	83 ec 0c             	sub    $0xc,%esp
80103d2b:	68 20 2d 11 80       	push   $0x80112d20
80103d30:	e8 2b 05 00 00       	call   80104260 <acquire>
    release(lk);
80103d35:	89 34 24             	mov    %esi,(%esp)
80103d38:	e8 43 06 00 00       	call   80104380 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103d3d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103d40:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103d47:	e8 64 fd ff ff       	call   80103ab0 <sched>

  // Tidy up.
  p->chan = 0;
80103d4c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103d53:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d5a:	e8 21 06 00 00       	call   80104380 <release>
    acquire(lk);
80103d5f:	89 75 08             	mov    %esi,0x8(%ebp)
80103d62:	83 c4 10             	add    $0x10,%esp
  }
}
80103d65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d68:	5b                   	pop    %ebx
80103d69:	5e                   	pop    %esi
80103d6a:	5f                   	pop    %edi
80103d6b:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103d6c:	e9 ef 04 00 00       	jmp    80104260 <acquire>
80103d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103d78:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103d7b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103d82:	e8 29 fd ff ff       	call   80103ab0 <sched>

  // Tidy up.
  p->chan = 0;
80103d87:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103d8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d91:	5b                   	pop    %ebx
80103d92:	5e                   	pop    %esi
80103d93:	5f                   	pop    %edi
80103d94:	5d                   	pop    %ebp
80103d95:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103d96:	83 ec 0c             	sub    $0xc,%esp
80103d99:	68 ef 75 10 80       	push   $0x801075ef
80103d9e:	e8 cd c5 ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103da3:	83 ec 0c             	sub    $0xc,%esp
80103da6:	68 e9 75 10 80       	push   $0x801075e9
80103dab:	e8 c0 c5 ff ff       	call   80100370 <panic>

80103db0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103db0:	55                   	push   %ebp
80103db1:	89 e5                	mov    %esp,%ebp
80103db3:	56                   	push   %esi
80103db4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103db5:	e8 66 04 00 00       	call   80104220 <pushcli>
  c = mycpu();
80103dba:	e8 e1 f8 ff ff       	call   801036a0 <mycpu>
  p = c->proc;
80103dbf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103dc5:	e8 46 05 00 00       	call   80104310 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
80103dca:	83 ec 0c             	sub    $0xc,%esp
80103dcd:	68 20 2d 11 80       	push   $0x80112d20
80103dd2:	e8 89 04 00 00       	call   80104260 <acquire>
80103dd7:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103dda:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ddc:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103de1:	eb 10                	jmp    80103df3 <wait+0x43>
80103de3:	90                   	nop
80103de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103de8:	83 eb 80             	sub    $0xffffff80,%ebx
80103deb:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103df1:	74 1d                	je     80103e10 <wait+0x60>
      if(p->parent != curproc)
80103df3:	39 73 14             	cmp    %esi,0x14(%ebx)
80103df6:	75 f0                	jne    80103de8 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103df8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103dfc:	74 30                	je     80103e2e <wait+0x7e>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dfe:	83 eb 80             	sub    $0xffffff80,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103e01:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e06:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103e0c:	75 e5                	jne    80103df3 <wait+0x43>
80103e0e:	66 90                	xchg   %ax,%ax
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103e10:	85 c0                	test   %eax,%eax
80103e12:	74 70                	je     80103e84 <wait+0xd4>
80103e14:	8b 46 24             	mov    0x24(%esi),%eax
80103e17:	85 c0                	test   %eax,%eax
80103e19:	75 69                	jne    80103e84 <wait+0xd4>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103e1b:	83 ec 08             	sub    $0x8,%esp
80103e1e:	68 20 2d 11 80       	push   $0x80112d20
80103e23:	56                   	push   %esi
80103e24:	e8 c7 fe ff ff       	call   80103cf0 <sleep>
  }
80103e29:	83 c4 10             	add    $0x10,%esp
80103e2c:	eb ac                	jmp    80103dda <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103e2e:	83 ec 0c             	sub    $0xc,%esp
80103e31:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103e34:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103e37:	e8 64 e4 ff ff       	call   801022a0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103e3c:	5a                   	pop    %edx
80103e3d:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103e40:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103e47:	e8 34 2d 00 00       	call   80106b80 <freevm>
        p->pid = 0;
80103e4c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103e53:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103e5a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103e5e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103e65:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103e6c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e73:	e8 08 05 00 00       	call   80104380 <release>
        return pid;
80103e78:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103e7e:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e80:	5b                   	pop    %ebx
80103e81:	5e                   	pop    %esi
80103e82:	5d                   	pop    %ebp
80103e83:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103e84:	83 ec 0c             	sub    $0xc,%esp
80103e87:	68 20 2d 11 80       	push   $0x80112d20
80103e8c:	e8 ef 04 00 00       	call   80104380 <release>
      return -1;
80103e91:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e94:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80103e97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e9c:	5b                   	pop    %ebx
80103e9d:	5e                   	pop    %esi
80103e9e:	5d                   	pop    %ebp
80103e9f:	c3                   	ret    

80103ea0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103ea0:	55                   	push   %ebp
80103ea1:	89 e5                	mov    %esp,%ebp
80103ea3:	53                   	push   %ebx
80103ea4:	83 ec 10             	sub    $0x10,%esp
80103ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103eaa:	68 20 2d 11 80       	push   $0x80112d20
80103eaf:	e8 ac 03 00 00       	call   80104260 <acquire>
80103eb4:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103eb7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103ebc:	eb 0c                	jmp    80103eca <wakeup+0x2a>
80103ebe:	66 90                	xchg   %ax,%ax
80103ec0:	83 e8 80             	sub    $0xffffff80,%eax
80103ec3:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103ec8:	74 1c                	je     80103ee6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
80103eca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ece:	75 f0                	jne    80103ec0 <wakeup+0x20>
80103ed0:	3b 58 20             	cmp    0x20(%eax),%ebx
80103ed3:	75 eb                	jne    80103ec0 <wakeup+0x20>
      p->state = RUNNABLE;
80103ed5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103edc:	83 e8 80             	sub    $0xffffff80,%eax
80103edf:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103ee4:	75 e4                	jne    80103eca <wakeup+0x2a>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103ee6:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103eed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ef0:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103ef1:	e9 8a 04 00 00       	jmp    80104380 <release>
80103ef6:	8d 76 00             	lea    0x0(%esi),%esi
80103ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f00 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	53                   	push   %ebx
80103f04:	83 ec 10             	sub    $0x10,%esp
80103f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103f0a:	68 20 2d 11 80       	push   $0x80112d20
80103f0f:	e8 4c 03 00 00       	call   80104260 <acquire>
80103f14:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f17:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f1c:	eb 0c                	jmp    80103f2a <kill+0x2a>
80103f1e:	66 90                	xchg   %ax,%ax
80103f20:	83 e8 80             	sub    $0xffffff80,%eax
80103f23:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103f28:	74 3e                	je     80103f68 <kill+0x68>
    if(p->pid == pid){
80103f2a:	39 58 10             	cmp    %ebx,0x10(%eax)
80103f2d:	75 f1                	jne    80103f20 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f2f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80103f33:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f3a:	74 1c                	je     80103f58 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103f3c:	83 ec 0c             	sub    $0xc,%esp
80103f3f:	68 20 2d 11 80       	push   $0x80112d20
80103f44:	e8 37 04 00 00       	call   80104380 <release>
      return 0;
80103f49:	83 c4 10             	add    $0x10,%esp
80103f4c:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103f4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f51:	c9                   	leave  
80103f52:	c3                   	ret    
80103f53:	90                   	nop
80103f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80103f58:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f5f:	eb db                	jmp    80103f3c <kill+0x3c>
80103f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80103f68:	83 ec 0c             	sub    $0xc,%esp
80103f6b:	68 20 2d 11 80       	push   $0x80112d20
80103f70:	e8 0b 04 00 00       	call   80104380 <release>
  return -1;
80103f75:	83 c4 10             	add    $0x10,%esp
80103f78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f80:	c9                   	leave  
80103f81:	c3                   	ret    
80103f82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f90 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	57                   	push   %edi
80103f94:	56                   	push   %esi
80103f95:	53                   	push   %ebx
80103f96:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103f99:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80103f9e:	83 ec 3c             	sub    $0x3c,%esp
80103fa1:	eb 24                	jmp    80103fc7 <procdump+0x37>
80103fa3:	90                   	nop
80103fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103fa8:	83 ec 0c             	sub    $0xc,%esp
80103fab:	68 7f 79 10 80       	push   $0x8010797f
80103fb0:	e8 ab c6 ff ff       	call   80100660 <cprintf>
80103fb5:	83 c4 10             	add    $0x10,%esp
80103fb8:	83 eb 80             	sub    $0xffffff80,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fbb:	81 fb c0 4d 11 80    	cmp    $0x80114dc0,%ebx
80103fc1:	0f 84 81 00 00 00    	je     80104048 <procdump+0xb8>
    if(p->state == UNUSED)
80103fc7:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103fca:	85 c0                	test   %eax,%eax
80103fcc:	74 ea                	je     80103fb8 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103fce:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80103fd1:	ba 00 76 10 80       	mov    $0x80107600,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103fd6:	77 11                	ja     80103fe9 <procdump+0x59>
80103fd8:	8b 14 85 60 76 10 80 	mov    -0x7fef89a0(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80103fdf:	b8 00 76 10 80       	mov    $0x80107600,%eax
80103fe4:	85 d2                	test   %edx,%edx
80103fe6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103fe9:	53                   	push   %ebx
80103fea:	52                   	push   %edx
80103feb:	ff 73 a4             	pushl  -0x5c(%ebx)
80103fee:	68 04 76 10 80       	push   $0x80107604
80103ff3:	e8 68 c6 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80103ff8:	83 c4 10             	add    $0x10,%esp
80103ffb:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103fff:	75 a7                	jne    80103fa8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104001:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104004:	83 ec 08             	sub    $0x8,%esp
80104007:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010400a:	50                   	push   %eax
8010400b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010400e:	8b 40 0c             	mov    0xc(%eax),%eax
80104011:	83 c0 08             	add    $0x8,%eax
80104014:	50                   	push   %eax
80104015:	e8 66 01 00 00       	call   80104180 <getcallerpcs>
8010401a:	83 c4 10             	add    $0x10,%esp
8010401d:	8d 76 00             	lea    0x0(%esi),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104020:	8b 17                	mov    (%edi),%edx
80104022:	85 d2                	test   %edx,%edx
80104024:	74 82                	je     80103fa8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104026:	83 ec 08             	sub    $0x8,%esp
80104029:	83 c7 04             	add    $0x4,%edi
8010402c:	52                   	push   %edx
8010402d:	68 41 70 10 80       	push   $0x80107041
80104032:	e8 29 c6 ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104037:	83 c4 10             	add    $0x10,%esp
8010403a:	39 f7                	cmp    %esi,%edi
8010403c:	75 e2                	jne    80104020 <procdump+0x90>
8010403e:	e9 65 ff ff ff       	jmp    80103fa8 <procdump+0x18>
80104043:	90                   	nop
80104044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104048:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010404b:	5b                   	pop    %ebx
8010404c:	5e                   	pop    %esi
8010404d:	5f                   	pop    %edi
8010404e:	5d                   	pop    %ebp
8010404f:	c3                   	ret    

80104050 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104050:	55                   	push   %ebp
80104051:	89 e5                	mov    %esp,%ebp
80104053:	53                   	push   %ebx
80104054:	83 ec 0c             	sub    $0xc,%esp
80104057:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010405a:	68 78 76 10 80       	push   $0x80107678
8010405f:	8d 43 04             	lea    0x4(%ebx),%eax
80104062:	50                   	push   %eax
80104063:	e8 f8 00 00 00       	call   80104160 <initlock>
  lk->name = name;
80104068:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010406b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104071:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104074:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010407b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010407e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104081:	c9                   	leave  
80104082:	c3                   	ret    
80104083:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104090 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104090:	55                   	push   %ebp
80104091:	89 e5                	mov    %esp,%ebp
80104093:	56                   	push   %esi
80104094:	53                   	push   %ebx
80104095:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104098:	83 ec 0c             	sub    $0xc,%esp
8010409b:	8d 73 04             	lea    0x4(%ebx),%esi
8010409e:	56                   	push   %esi
8010409f:	e8 bc 01 00 00       	call   80104260 <acquire>
  while (lk->locked) {
801040a4:	8b 13                	mov    (%ebx),%edx
801040a6:	83 c4 10             	add    $0x10,%esp
801040a9:	85 d2                	test   %edx,%edx
801040ab:	74 16                	je     801040c3 <acquiresleep+0x33>
801040ad:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801040b0:	83 ec 08             	sub    $0x8,%esp
801040b3:	56                   	push   %esi
801040b4:	53                   	push   %ebx
801040b5:	e8 36 fc ff ff       	call   80103cf0 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801040ba:	8b 03                	mov    (%ebx),%eax
801040bc:	83 c4 10             	add    $0x10,%esp
801040bf:	85 c0                	test   %eax,%eax
801040c1:	75 ed                	jne    801040b0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801040c3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801040c9:	e8 72 f6 ff ff       	call   80103740 <myproc>
801040ce:	8b 40 10             	mov    0x10(%eax),%eax
801040d1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801040d4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801040d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040da:	5b                   	pop    %ebx
801040db:	5e                   	pop    %esi
801040dc:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
801040dd:	e9 9e 02 00 00       	jmp    80104380 <release>
801040e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040f0 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
801040f0:	55                   	push   %ebp
801040f1:	89 e5                	mov    %esp,%ebp
801040f3:	56                   	push   %esi
801040f4:	53                   	push   %ebx
801040f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801040f8:	83 ec 0c             	sub    $0xc,%esp
801040fb:	8d 73 04             	lea    0x4(%ebx),%esi
801040fe:	56                   	push   %esi
801040ff:	e8 5c 01 00 00       	call   80104260 <acquire>
  lk->locked = 0;
80104104:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010410a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104111:	89 1c 24             	mov    %ebx,(%esp)
80104114:	e8 87 fd ff ff       	call   80103ea0 <wakeup>
  release(&lk->lk);
80104119:	89 75 08             	mov    %esi,0x8(%ebp)
8010411c:	83 c4 10             	add    $0x10,%esp
}
8010411f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104122:	5b                   	pop    %ebx
80104123:	5e                   	pop    %esi
80104124:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104125:	e9 56 02 00 00       	jmp    80104380 <release>
8010412a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104130 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	56                   	push   %esi
80104134:	53                   	push   %ebx
80104135:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104138:	83 ec 0c             	sub    $0xc,%esp
8010413b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010413e:	53                   	push   %ebx
8010413f:	e8 1c 01 00 00       	call   80104260 <acquire>
  r = lk->locked;
80104144:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104146:	89 1c 24             	mov    %ebx,(%esp)
80104149:	e8 32 02 00 00       	call   80104380 <release>
  return r;
}
8010414e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104151:	89 f0                	mov    %esi,%eax
80104153:	5b                   	pop    %ebx
80104154:	5e                   	pop    %esi
80104155:	5d                   	pop    %ebp
80104156:	c3                   	ret    
80104157:	66 90                	xchg   %ax,%ax
80104159:	66 90                	xchg   %ax,%ax
8010415b:	66 90                	xchg   %ax,%ax
8010415d:	66 90                	xchg   %ax,%ax
8010415f:	90                   	nop

80104160 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104166:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104169:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010416f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104172:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104179:	5d                   	pop    %ebp
8010417a:	c3                   	ret    
8010417b:	90                   	nop
8010417c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104180 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104184:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104187:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010418a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010418d:	31 c0                	xor    %eax,%eax
8010418f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104190:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104196:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010419c:	77 1a                	ja     801041b8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010419e:	8b 5a 04             	mov    0x4(%edx),%ebx
801041a1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801041a4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801041a7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801041a9:	83 f8 0a             	cmp    $0xa,%eax
801041ac:	75 e2                	jne    80104190 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801041ae:	5b                   	pop    %ebx
801041af:	5d                   	pop    %ebp
801041b0:	c3                   	ret    
801041b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801041b8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801041bf:	83 c0 01             	add    $0x1,%eax
801041c2:	83 f8 0a             	cmp    $0xa,%eax
801041c5:	74 e7                	je     801041ae <getcallerpcs+0x2e>
    pcs[i] = 0;
801041c7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801041ce:	83 c0 01             	add    $0x1,%eax
801041d1:	83 f8 0a             	cmp    $0xa,%eax
801041d4:	75 e2                	jne    801041b8 <getcallerpcs+0x38>
801041d6:	eb d6                	jmp    801041ae <getcallerpcs+0x2e>
801041d8:	90                   	nop
801041d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041e0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	53                   	push   %ebx
801041e4:	83 ec 04             	sub    $0x4,%esp
801041e7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801041ea:	8b 02                	mov    (%edx),%eax
801041ec:	85 c0                	test   %eax,%eax
801041ee:	75 10                	jne    80104200 <holding+0x20>
}
801041f0:	83 c4 04             	add    $0x4,%esp
801041f3:	31 c0                	xor    %eax,%eax
801041f5:	5b                   	pop    %ebx
801041f6:	5d                   	pop    %ebp
801041f7:	c3                   	ret    
801041f8:	90                   	nop
801041f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104200:	8b 5a 08             	mov    0x8(%edx),%ebx
80104203:	e8 98 f4 ff ff       	call   801036a0 <mycpu>
80104208:	39 c3                	cmp    %eax,%ebx
8010420a:	0f 94 c0             	sete   %al
}
8010420d:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104210:	0f b6 c0             	movzbl %al,%eax
}
80104213:	5b                   	pop    %ebx
80104214:	5d                   	pop    %ebp
80104215:	c3                   	ret    
80104216:	8d 76 00             	lea    0x0(%esi),%esi
80104219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104220 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	53                   	push   %ebx
80104224:	83 ec 04             	sub    $0x4,%esp
80104227:	9c                   	pushf  
80104228:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104229:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010422a:	e8 71 f4 ff ff       	call   801036a0 <mycpu>
8010422f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104235:	85 c0                	test   %eax,%eax
80104237:	75 11                	jne    8010424a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104239:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010423f:	e8 5c f4 ff ff       	call   801036a0 <mycpu>
80104244:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010424a:	e8 51 f4 ff ff       	call   801036a0 <mycpu>
8010424f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104256:	83 c4 04             	add    $0x4,%esp
80104259:	5b                   	pop    %ebx
8010425a:	5d                   	pop    %ebp
8010425b:	c3                   	ret    
8010425c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104260 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
80104263:	56                   	push   %esi
80104264:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104265:	e8 b6 ff ff ff       	call   80104220 <pushcli>
  if(holding(lk))
8010426a:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010426d:	8b 03                	mov    (%ebx),%eax
8010426f:	85 c0                	test   %eax,%eax
80104271:	75 7d                	jne    801042f0 <acquire+0x90>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104273:	ba 01 00 00 00       	mov    $0x1,%edx
80104278:	eb 09                	jmp    80104283 <acquire+0x23>
8010427a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104280:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104283:	89 d0                	mov    %edx,%eax
80104285:	f0 87 03             	lock xchg %eax,(%ebx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104288:	85 c0                	test   %eax,%eax
8010428a:	75 f4                	jne    80104280 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010428c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104291:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104294:	e8 07 f4 ff ff       	call   801036a0 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104299:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
8010429b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
8010429e:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801042a1:	31 c0                	xor    %eax,%eax
801042a3:	90                   	nop
801042a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801042a8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801042ae:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801042b4:	77 1a                	ja     801042d0 <acquire+0x70>
      break;
    pcs[i] = ebp[1];     // saved %eip
801042b6:	8b 5a 04             	mov    0x4(%edx),%ebx
801042b9:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801042bc:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801042bf:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801042c1:	83 f8 0a             	cmp    $0xa,%eax
801042c4:	75 e2                	jne    801042a8 <acquire+0x48>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
801042c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042c9:	5b                   	pop    %ebx
801042ca:	5e                   	pop    %esi
801042cb:	5d                   	pop    %ebp
801042cc:	c3                   	ret    
801042cd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801042d0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801042d7:	83 c0 01             	add    $0x1,%eax
801042da:	83 f8 0a             	cmp    $0xa,%eax
801042dd:	74 e7                	je     801042c6 <acquire+0x66>
    pcs[i] = 0;
801042df:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801042e6:	83 c0 01             	add    $0x1,%eax
801042e9:	83 f8 0a             	cmp    $0xa,%eax
801042ec:	75 e2                	jne    801042d0 <acquire+0x70>
801042ee:	eb d6                	jmp    801042c6 <acquire+0x66>

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801042f0:	8b 73 08             	mov    0x8(%ebx),%esi
801042f3:	e8 a8 f3 ff ff       	call   801036a0 <mycpu>
801042f8:	39 c6                	cmp    %eax,%esi
801042fa:	0f 85 73 ff ff ff    	jne    80104273 <acquire+0x13>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104300:	83 ec 0c             	sub    $0xc,%esp
80104303:	68 83 76 10 80       	push   $0x80107683
80104308:	e8 63 c0 ff ff       	call   80100370 <panic>
8010430d:	8d 76 00             	lea    0x0(%esi),%esi

80104310 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104316:	9c                   	pushf  
80104317:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104318:	f6 c4 02             	test   $0x2,%ah
8010431b:	75 52                	jne    8010436f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010431d:	e8 7e f3 ff ff       	call   801036a0 <mycpu>
80104322:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104328:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010432b:	85 d2                	test   %edx,%edx
8010432d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104333:	78 2d                	js     80104362 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104335:	e8 66 f3 ff ff       	call   801036a0 <mycpu>
8010433a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104340:	85 d2                	test   %edx,%edx
80104342:	74 0c                	je     80104350 <popcli+0x40>
    sti();
}
80104344:	c9                   	leave  
80104345:	c3                   	ret    
80104346:	8d 76 00             	lea    0x0(%esi),%esi
80104349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104350:	e8 4b f3 ff ff       	call   801036a0 <mycpu>
80104355:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010435b:	85 c0                	test   %eax,%eax
8010435d:	74 e5                	je     80104344 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
8010435f:	fb                   	sti    
    sti();
}
80104360:	c9                   	leave  
80104361:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104362:	83 ec 0c             	sub    $0xc,%esp
80104365:	68 a2 76 10 80       	push   $0x801076a2
8010436a:	e8 01 c0 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
8010436f:	83 ec 0c             	sub    $0xc,%esp
80104372:	68 8b 76 10 80       	push   $0x8010768b
80104377:	e8 f4 bf ff ff       	call   80100370 <panic>
8010437c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104380 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104380:	55                   	push   %ebp
80104381:	89 e5                	mov    %esp,%ebp
80104383:	56                   	push   %esi
80104384:	53                   	push   %ebx
80104385:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104388:	8b 03                	mov    (%ebx),%eax
8010438a:	85 c0                	test   %eax,%eax
8010438c:	75 12                	jne    801043a0 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
8010438e:	83 ec 0c             	sub    $0xc,%esp
80104391:	68 a9 76 10 80       	push   $0x801076a9
80104396:	e8 d5 bf ff ff       	call   80100370 <panic>
8010439b:	90                   	nop
8010439c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801043a0:	8b 73 08             	mov    0x8(%ebx),%esi
801043a3:	e8 f8 f2 ff ff       	call   801036a0 <mycpu>
801043a8:	39 c6                	cmp    %eax,%esi
801043aa:	75 e2                	jne    8010438e <release+0xe>
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");

  lk->pcs[0] = 0;
801043ac:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801043b3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801043ba:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801043bf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
801043c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043c8:	5b                   	pop    %ebx
801043c9:	5e                   	pop    %esi
801043ca:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
801043cb:	e9 40 ff ff ff       	jmp    80104310 <popcli>

801043d0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801043d0:	55                   	push   %ebp
801043d1:	89 e5                	mov    %esp,%ebp
801043d3:	57                   	push   %edi
801043d4:	53                   	push   %ebx
801043d5:	8b 55 08             	mov    0x8(%ebp),%edx
801043d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801043db:	f6 c2 03             	test   $0x3,%dl
801043de:	75 05                	jne    801043e5 <memset+0x15>
801043e0:	f6 c1 03             	test   $0x3,%cl
801043e3:	74 13                	je     801043f8 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
801043e5:	89 d7                	mov    %edx,%edi
801043e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801043ea:	fc                   	cld    
801043eb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801043ed:	5b                   	pop    %ebx
801043ee:	89 d0                	mov    %edx,%eax
801043f0:	5f                   	pop    %edi
801043f1:	5d                   	pop    %ebp
801043f2:	c3                   	ret    
801043f3:	90                   	nop
801043f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
801043f8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
801043fc:	c1 e9 02             	shr    $0x2,%ecx
801043ff:	89 fb                	mov    %edi,%ebx
80104401:	89 f8                	mov    %edi,%eax
80104403:	c1 e3 18             	shl    $0x18,%ebx
80104406:	c1 e0 10             	shl    $0x10,%eax
80104409:	09 d8                	or     %ebx,%eax
8010440b:	09 f8                	or     %edi,%eax
8010440d:	c1 e7 08             	shl    $0x8,%edi
80104410:	09 f8                	or     %edi,%eax
80104412:	89 d7                	mov    %edx,%edi
80104414:	fc                   	cld    
80104415:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104417:	5b                   	pop    %ebx
80104418:	89 d0                	mov    %edx,%eax
8010441a:	5f                   	pop    %edi
8010441b:	5d                   	pop    %ebp
8010441c:	c3                   	ret    
8010441d:	8d 76 00             	lea    0x0(%esi),%esi

80104420 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	57                   	push   %edi
80104424:	56                   	push   %esi
80104425:	8b 45 10             	mov    0x10(%ebp),%eax
80104428:	53                   	push   %ebx
80104429:	8b 75 0c             	mov    0xc(%ebp),%esi
8010442c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010442f:	85 c0                	test   %eax,%eax
80104431:	74 29                	je     8010445c <memcmp+0x3c>
    if(*s1 != *s2)
80104433:	0f b6 13             	movzbl (%ebx),%edx
80104436:	0f b6 0e             	movzbl (%esi),%ecx
80104439:	38 d1                	cmp    %dl,%cl
8010443b:	75 2b                	jne    80104468 <memcmp+0x48>
8010443d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104440:	31 c0                	xor    %eax,%eax
80104442:	eb 14                	jmp    80104458 <memcmp+0x38>
80104444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104448:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
8010444d:	83 c0 01             	add    $0x1,%eax
80104450:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104454:	38 ca                	cmp    %cl,%dl
80104456:	75 10                	jne    80104468 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104458:	39 f8                	cmp    %edi,%eax
8010445a:	75 ec                	jne    80104448 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010445c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010445d:	31 c0                	xor    %eax,%eax
}
8010445f:	5e                   	pop    %esi
80104460:	5f                   	pop    %edi
80104461:	5d                   	pop    %ebp
80104462:	c3                   	ret    
80104463:	90                   	nop
80104464:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104468:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
8010446b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
8010446c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010446e:	5e                   	pop    %esi
8010446f:	5f                   	pop    %edi
80104470:	5d                   	pop    %ebp
80104471:	c3                   	ret    
80104472:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104480 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	56                   	push   %esi
80104484:	53                   	push   %ebx
80104485:	8b 45 08             	mov    0x8(%ebp),%eax
80104488:	8b 75 0c             	mov    0xc(%ebp),%esi
8010448b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010448e:	39 c6                	cmp    %eax,%esi
80104490:	73 2e                	jae    801044c0 <memmove+0x40>
80104492:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104495:	39 c8                	cmp    %ecx,%eax
80104497:	73 27                	jae    801044c0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104499:	85 db                	test   %ebx,%ebx
8010449b:	8d 53 ff             	lea    -0x1(%ebx),%edx
8010449e:	74 17                	je     801044b7 <memmove+0x37>
      *--d = *--s;
801044a0:	29 d9                	sub    %ebx,%ecx
801044a2:	89 cb                	mov    %ecx,%ebx
801044a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044a8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801044ac:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801044af:	83 ea 01             	sub    $0x1,%edx
801044b2:	83 fa ff             	cmp    $0xffffffff,%edx
801044b5:	75 f1                	jne    801044a8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801044b7:	5b                   	pop    %ebx
801044b8:	5e                   	pop    %esi
801044b9:	5d                   	pop    %ebp
801044ba:	c3                   	ret    
801044bb:	90                   	nop
801044bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801044c0:	31 d2                	xor    %edx,%edx
801044c2:	85 db                	test   %ebx,%ebx
801044c4:	74 f1                	je     801044b7 <memmove+0x37>
801044c6:	8d 76 00             	lea    0x0(%esi),%esi
801044c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
801044d0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801044d4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801044d7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801044da:	39 d3                	cmp    %edx,%ebx
801044dc:	75 f2                	jne    801044d0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
801044de:	5b                   	pop    %ebx
801044df:	5e                   	pop    %esi
801044e0:	5d                   	pop    %ebp
801044e1:	c3                   	ret    
801044e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801044f0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801044f0:	55                   	push   %ebp
801044f1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801044f3:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801044f4:	eb 8a                	jmp    80104480 <memmove>
801044f6:	8d 76 00             	lea    0x0(%esi),%esi
801044f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104500 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	57                   	push   %edi
80104504:	56                   	push   %esi
80104505:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104508:	53                   	push   %ebx
80104509:	8b 7d 08             	mov    0x8(%ebp),%edi
8010450c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010450f:	85 c9                	test   %ecx,%ecx
80104511:	74 37                	je     8010454a <strncmp+0x4a>
80104513:	0f b6 17             	movzbl (%edi),%edx
80104516:	0f b6 1e             	movzbl (%esi),%ebx
80104519:	84 d2                	test   %dl,%dl
8010451b:	74 3f                	je     8010455c <strncmp+0x5c>
8010451d:	38 d3                	cmp    %dl,%bl
8010451f:	75 3b                	jne    8010455c <strncmp+0x5c>
80104521:	8d 47 01             	lea    0x1(%edi),%eax
80104524:	01 cf                	add    %ecx,%edi
80104526:	eb 1b                	jmp    80104543 <strncmp+0x43>
80104528:	90                   	nop
80104529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104530:	0f b6 10             	movzbl (%eax),%edx
80104533:	84 d2                	test   %dl,%dl
80104535:	74 21                	je     80104558 <strncmp+0x58>
80104537:	0f b6 19             	movzbl (%ecx),%ebx
8010453a:	83 c0 01             	add    $0x1,%eax
8010453d:	89 ce                	mov    %ecx,%esi
8010453f:	38 da                	cmp    %bl,%dl
80104541:	75 19                	jne    8010455c <strncmp+0x5c>
80104543:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104545:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104548:	75 e6                	jne    80104530 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
8010454a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
8010454b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
8010454d:	5e                   	pop    %esi
8010454e:	5f                   	pop    %edi
8010454f:	5d                   	pop    %ebp
80104550:	c3                   	ret    
80104551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104558:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010455c:	0f b6 c2             	movzbl %dl,%eax
8010455f:	29 d8                	sub    %ebx,%eax
}
80104561:	5b                   	pop    %ebx
80104562:	5e                   	pop    %esi
80104563:	5f                   	pop    %edi
80104564:	5d                   	pop    %ebp
80104565:	c3                   	ret    
80104566:	8d 76 00             	lea    0x0(%esi),%esi
80104569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104570 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
80104573:	56                   	push   %esi
80104574:	53                   	push   %ebx
80104575:	8b 45 08             	mov    0x8(%ebp),%eax
80104578:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010457b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010457e:	89 c2                	mov    %eax,%edx
80104580:	eb 19                	jmp    8010459b <strncpy+0x2b>
80104582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104588:	83 c3 01             	add    $0x1,%ebx
8010458b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010458f:	83 c2 01             	add    $0x1,%edx
80104592:	84 c9                	test   %cl,%cl
80104594:	88 4a ff             	mov    %cl,-0x1(%edx)
80104597:	74 09                	je     801045a2 <strncpy+0x32>
80104599:	89 f1                	mov    %esi,%ecx
8010459b:	85 c9                	test   %ecx,%ecx
8010459d:	8d 71 ff             	lea    -0x1(%ecx),%esi
801045a0:	7f e6                	jg     80104588 <strncpy+0x18>
    ;
  while(n-- > 0)
801045a2:	31 c9                	xor    %ecx,%ecx
801045a4:	85 f6                	test   %esi,%esi
801045a6:	7e 17                	jle    801045bf <strncpy+0x4f>
801045a8:	90                   	nop
801045a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801045b0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801045b4:	89 f3                	mov    %esi,%ebx
801045b6:	83 c1 01             	add    $0x1,%ecx
801045b9:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801045bb:	85 db                	test   %ebx,%ebx
801045bd:	7f f1                	jg     801045b0 <strncpy+0x40>
    *s++ = 0;
  return os;
}
801045bf:	5b                   	pop    %ebx
801045c0:	5e                   	pop    %esi
801045c1:	5d                   	pop    %ebp
801045c2:	c3                   	ret    
801045c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045d0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	56                   	push   %esi
801045d4:	53                   	push   %ebx
801045d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801045d8:	8b 45 08             	mov    0x8(%ebp),%eax
801045db:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801045de:	85 c9                	test   %ecx,%ecx
801045e0:	7e 26                	jle    80104608 <safestrcpy+0x38>
801045e2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801045e6:	89 c1                	mov    %eax,%ecx
801045e8:	eb 17                	jmp    80104601 <safestrcpy+0x31>
801045ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801045f0:	83 c2 01             	add    $0x1,%edx
801045f3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801045f7:	83 c1 01             	add    $0x1,%ecx
801045fa:	84 db                	test   %bl,%bl
801045fc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801045ff:	74 04                	je     80104605 <safestrcpy+0x35>
80104601:	39 f2                	cmp    %esi,%edx
80104603:	75 eb                	jne    801045f0 <safestrcpy+0x20>
    ;
  *s = 0;
80104605:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104608:	5b                   	pop    %ebx
80104609:	5e                   	pop    %esi
8010460a:	5d                   	pop    %ebp
8010460b:	c3                   	ret    
8010460c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104610 <strlen>:

int
strlen(const char *s)
{
80104610:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104611:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104613:	89 e5                	mov    %esp,%ebp
80104615:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104618:	80 3a 00             	cmpb   $0x0,(%edx)
8010461b:	74 0c                	je     80104629 <strlen+0x19>
8010461d:	8d 76 00             	lea    0x0(%esi),%esi
80104620:	83 c0 01             	add    $0x1,%eax
80104623:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104627:	75 f7                	jne    80104620 <strlen+0x10>
    ;
  return n;
}
80104629:	5d                   	pop    %ebp
8010462a:	c3                   	ret    

8010462b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010462b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010462f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104633:	55                   	push   %ebp
  pushl %ebx
80104634:	53                   	push   %ebx
  pushl %esi
80104635:	56                   	push   %esi
  pushl %edi
80104636:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104637:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104639:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010463b:	5f                   	pop    %edi
  popl %esi
8010463c:	5e                   	pop    %esi
  popl %ebx
8010463d:	5b                   	pop    %ebx
  popl %ebp
8010463e:	5d                   	pop    %ebp
  ret
8010463f:	c3                   	ret    

80104640 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
  //cs153 updated sz check
  //if(((addr >= curproc->sz || addr+4 > curproc->sz) && (addr < ((KERNBASE - 1) - curproc->stack_sz))) || addr > (KERNBASE - 1)){
    //return -1;
  //}
  //cs153
  *ip = *(int*)(addr);
80104643:	8b 45 08             	mov    0x8(%ebp),%eax
80104646:	8b 10                	mov    (%eax),%edx
80104648:	8b 45 0c             	mov    0xc(%ebp),%eax
8010464b:	89 10                	mov    %edx,(%eax)
  return 0;
}
8010464d:	31 c0                	xor    %eax,%eax
8010464f:	5d                   	pop    %ebp
80104650:	c3                   	ret    
80104651:	eb 0d                	jmp    80104660 <fetchstr>
80104653:	90                   	nop
80104654:	90                   	nop
80104655:	90                   	nop
80104656:	90                   	nop
80104657:	90                   	nop
80104658:	90                   	nop
80104659:	90                   	nop
8010465a:	90                   	nop
8010465b:	90                   	nop
8010465c:	90                   	nop
8010465d:	90                   	nop
8010465e:	90                   	nop
8010465f:	90                   	nop

80104660 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	53                   	push   %ebx
80104664:	83 ec 04             	sub    $0x4,%esp
80104667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010466a:	e8 d1 f0 ff ff       	call   80103740 <myproc>

  //cs153 removed sz check
  *pp = (char*)addr;
8010466f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104672:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104674:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104676:	39 c3                	cmp    %eax,%ebx
80104678:	73 1a                	jae    80104694 <fetchstr+0x34>
    if(*s == 0)
8010467a:	80 3b 00             	cmpb   $0x0,(%ebx)
8010467d:	89 da                	mov    %ebx,%edx
8010467f:	75 0c                	jne    8010468d <fetchstr+0x2d>
80104681:	eb 1d                	jmp    801046a0 <fetchstr+0x40>
80104683:	90                   	nop
80104684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104688:	80 3a 00             	cmpb   $0x0,(%edx)
8010468b:	74 13                	je     801046a0 <fetchstr+0x40>
  struct proc *curproc = myproc();

  //cs153 removed sz check
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
8010468d:	83 c2 01             	add    $0x1,%edx
80104690:	39 d0                	cmp    %edx,%eax
80104692:	77 f4                	ja     80104688 <fetchstr+0x28>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104694:	83 c4 04             	add    $0x4,%esp
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
80104697:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010469c:	5b                   	pop    %ebx
8010469d:	5d                   	pop    %ebp
8010469e:	c3                   	ret    
8010469f:	90                   	nop
801046a0:	83 c4 04             	add    $0x4,%esp
  //cs153 removed sz check
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
801046a3:	89 d0                	mov    %edx,%eax
801046a5:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801046a7:	5b                   	pop    %ebx
801046a8:	5d                   	pop    %ebp
801046a9:	c3                   	ret    
801046aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046b0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{  
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	83 ec 08             	sub    $0x8,%esp
  //cs153
  //if(ip == 0){
    //return -1;
  //}
  //cs153
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801046b6:	e8 85 f0 ff ff       	call   80103740 <myproc>
801046bb:	8b 40 18             	mov    0x18(%eax),%eax
  //cs153 updated sz check
  //if(((addr >= curproc->sz || addr+4 > curproc->sz) && (addr < ((KERNBASE - 1) - curproc->stack_sz))) || addr > (KERNBASE - 1)){
    //return -1;
  //}
  //cs153
  *ip = *(int*)(addr);
801046be:	8b 55 08             	mov    0x8(%ebp),%edx
801046c1:	8b 40 44             	mov    0x44(%eax),%eax
801046c4:	8b 54 90 04          	mov    0x4(%eax,%edx,4),%edx
801046c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801046cb:	89 10                	mov    %edx,(%eax)
  //if(ip == 0){
    //return -1;
  //}
  //cs153
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
801046cd:	31 c0                	xor    %eax,%eax
801046cf:	c9                   	leave  
801046d0:	c3                   	ret    
801046d1:	eb 0d                	jmp    801046e0 <argptr>
801046d3:	90                   	nop
801046d4:	90                   	nop
801046d5:	90                   	nop
801046d6:	90                   	nop
801046d7:	90                   	nop
801046d8:	90                   	nop
801046d9:	90                   	nop
801046da:	90                   	nop
801046db:	90                   	nop
801046dc:	90                   	nop
801046dd:	90                   	nop
801046de:	90                   	nop
801046df:	90                   	nop

801046e0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	83 ec 08             	sub    $0x8,%esp
  //cs153
  //if(ip == 0){
    //return -1;
  //}
  //cs153
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801046e6:	e8 55 f0 ff ff       	call   80103740 <myproc>
801046eb:	8b 40 18             	mov    0x18(%eax),%eax
  //}
  //cs153
  if(argint(n, &i) < 0)
    return -1;
  //cs153 removed sz check
  *pp = (char*)i;
801046ee:	8b 55 08             	mov    0x8(%ebp),%edx
  //cs153 updated sz check
  //if(((addr >= curproc->sz || addr+4 > curproc->sz) && (addr < ((KERNBASE - 1) - curproc->stack_sz))) || addr > (KERNBASE - 1)){
    //return -1;
  //}
  //cs153
  *ip = *(int*)(addr);
801046f1:	8b 40 44             	mov    0x44(%eax),%eax
  //}
  //cs153
  if(argint(n, &i) < 0)
    return -1;
  //cs153 removed sz check
  *pp = (char*)i;
801046f4:	8b 54 90 04          	mov    0x4(%eax,%edx,4),%edx
801046f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801046fb:	89 10                	mov    %edx,(%eax)
  return 0;
}
801046fd:	31 c0                	xor    %eax,%eax
801046ff:	c9                   	leave  
80104700:	c3                   	ret    
80104701:	eb 0d                	jmp    80104710 <argstr>
80104703:	90                   	nop
80104704:	90                   	nop
80104705:	90                   	nop
80104706:	90                   	nop
80104707:	90                   	nop
80104708:	90                   	nop
80104709:	90                   	nop
8010470a:	90                   	nop
8010470b:	90                   	nop
8010470c:	90                   	nop
8010470d:	90                   	nop
8010470e:	90                   	nop
8010470f:	90                   	nop

80104710 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	53                   	push   %ebx
80104714:	83 ec 04             	sub    $0x4,%esp
  //cs153
  //if(ip == 0){
    //return -1;
  //}
  //cs153
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104717:	e8 24 f0 ff ff       	call   80103740 <myproc>
8010471c:	8b 40 18             	mov    0x18(%eax),%eax
  //cs153 updated sz check
  //if(((addr >= curproc->sz || addr+4 > curproc->sz) && (addr < ((KERNBASE - 1) - curproc->stack_sz))) || addr > (KERNBASE - 1)){
    //return -1;
  //}
  //cs153
  *ip = *(int*)(addr);
8010471f:	8b 55 08             	mov    0x8(%ebp),%edx
80104722:	8b 40 44             	mov    0x44(%eax),%eax
80104725:	8b 5c 90 04          	mov    0x4(%eax,%edx,4),%ebx
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;
  struct proc *curproc = myproc();
80104729:	e8 12 f0 ff ff       	call   80103740 <myproc>

  //cs153 removed sz check
  *pp = (char*)addr;
8010472e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104731:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104733:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104735:	39 c3                	cmp    %eax,%ebx
80104737:	73 1b                	jae    80104754 <argstr+0x44>
    if(*s == 0)
80104739:	80 3b 00             	cmpb   $0x0,(%ebx)
8010473c:	89 da                	mov    %ebx,%edx
8010473e:	75 0d                	jne    8010474d <argstr+0x3d>
80104740:	eb 1e                	jmp    80104760 <argstr+0x50>
80104742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104748:	80 3a 00             	cmpb   $0x0,(%edx)
8010474b:	74 13                	je     80104760 <argstr+0x50>
  struct proc *curproc = myproc();

  //cs153 removed sz check
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
8010474d:	83 c2 01             	add    $0x1,%edx
80104750:	39 d0                	cmp    %edx,%eax
80104752:	77 f4                	ja     80104748 <argstr+0x38>
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104754:	83 c4 04             	add    $0x4,%esp
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
80104757:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010475c:	5b                   	pop    %ebx
8010475d:	5d                   	pop    %ebp
8010475e:	c3                   	ret    
8010475f:	90                   	nop
80104760:	83 c4 04             	add    $0x4,%esp
  //cs153 removed sz check
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104763:	89 d0                	mov    %edx,%eax
80104765:	29 d8                	sub    %ebx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104767:	5b                   	pop    %ebx
80104768:	5d                   	pop    %ebp
80104769:	c3                   	ret    
8010476a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104770 <syscall>:
[SYS_shm_close] sys_shm_close
};

void
syscall(void)
{
80104770:	55                   	push   %ebp
80104771:	89 e5                	mov    %esp,%ebp
80104773:	56                   	push   %esi
80104774:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104775:	e8 c6 ef ff ff       	call   80103740 <myproc>

  num = curproc->tf->eax;
8010477a:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
8010477d:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010477f:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104782:	8d 50 ff             	lea    -0x1(%eax),%edx
80104785:	83 fa 16             	cmp    $0x16,%edx
80104788:	77 1e                	ja     801047a8 <syscall+0x38>
8010478a:	8b 14 85 e0 76 10 80 	mov    -0x7fef8920(,%eax,4),%edx
80104791:	85 d2                	test   %edx,%edx
80104793:	74 13                	je     801047a8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104795:	ff d2                	call   *%edx
80104797:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010479a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010479d:	5b                   	pop    %ebx
8010479e:	5e                   	pop    %esi
8010479f:	5d                   	pop    %ebp
801047a0:	c3                   	ret    
801047a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801047a8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801047a9:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801047ac:	50                   	push   %eax
801047ad:	ff 73 10             	pushl  0x10(%ebx)
801047b0:	68 b1 76 10 80       	push   $0x801076b1
801047b5:	e8 a6 be ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
801047ba:	8b 43 18             	mov    0x18(%ebx),%eax
801047bd:	83 c4 10             	add    $0x10,%esp
801047c0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801047c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047ca:	5b                   	pop    %ebx
801047cb:	5e                   	pop    %esi
801047cc:	5d                   	pop    %ebp
801047cd:	c3                   	ret    
801047ce:	66 90                	xchg   %ax,%ax

801047d0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	57                   	push   %edi
801047d4:	56                   	push   %esi
801047d5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801047d6:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801047d9:	83 ec 44             	sub    $0x44,%esp
801047dc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801047df:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801047e2:	56                   	push   %esi
801047e3:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801047e4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801047e7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801047ea:	e8 b1 d6 ff ff       	call   80101ea0 <nameiparent>
801047ef:	83 c4 10             	add    $0x10,%esp
801047f2:	85 c0                	test   %eax,%eax
801047f4:	0f 84 f6 00 00 00    	je     801048f0 <create+0x120>
    return 0;
  ilock(dp);
801047fa:	83 ec 0c             	sub    $0xc,%esp
801047fd:	89 c7                	mov    %eax,%edi
801047ff:	50                   	push   %eax
80104800:	e8 2b ce ff ff       	call   80101630 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104805:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104808:	83 c4 0c             	add    $0xc,%esp
8010480b:	50                   	push   %eax
8010480c:	56                   	push   %esi
8010480d:	57                   	push   %edi
8010480e:	e8 4d d3 ff ff       	call   80101b60 <dirlookup>
80104813:	83 c4 10             	add    $0x10,%esp
80104816:	85 c0                	test   %eax,%eax
80104818:	89 c3                	mov    %eax,%ebx
8010481a:	74 54                	je     80104870 <create+0xa0>
    iunlockput(dp);
8010481c:	83 ec 0c             	sub    $0xc,%esp
8010481f:	57                   	push   %edi
80104820:	e8 9b d0 ff ff       	call   801018c0 <iunlockput>
    ilock(ip);
80104825:	89 1c 24             	mov    %ebx,(%esp)
80104828:	e8 03 ce ff ff       	call   80101630 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010482d:	83 c4 10             	add    $0x10,%esp
80104830:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104835:	75 19                	jne    80104850 <create+0x80>
80104837:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
8010483c:	89 d8                	mov    %ebx,%eax
8010483e:	75 10                	jne    80104850 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104840:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104843:	5b                   	pop    %ebx
80104844:	5e                   	pop    %esi
80104845:	5f                   	pop    %edi
80104846:	5d                   	pop    %ebp
80104847:	c3                   	ret    
80104848:	90                   	nop
80104849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104850:	83 ec 0c             	sub    $0xc,%esp
80104853:	53                   	push   %ebx
80104854:	e8 67 d0 ff ff       	call   801018c0 <iunlockput>
    return 0;
80104859:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010485c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
8010485f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104861:	5b                   	pop    %ebx
80104862:	5e                   	pop    %esi
80104863:	5f                   	pop    %edi
80104864:	5d                   	pop    %ebp
80104865:	c3                   	ret    
80104866:	8d 76 00             	lea    0x0(%esi),%esi
80104869:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104870:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104874:	83 ec 08             	sub    $0x8,%esp
80104877:	50                   	push   %eax
80104878:	ff 37                	pushl  (%edi)
8010487a:	e8 41 cc ff ff       	call   801014c0 <ialloc>
8010487f:	83 c4 10             	add    $0x10,%esp
80104882:	85 c0                	test   %eax,%eax
80104884:	89 c3                	mov    %eax,%ebx
80104886:	0f 84 cc 00 00 00    	je     80104958 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
8010488c:	83 ec 0c             	sub    $0xc,%esp
8010488f:	50                   	push   %eax
80104890:	e8 9b cd ff ff       	call   80101630 <ilock>
  ip->major = major;
80104895:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104899:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010489d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801048a1:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
801048a5:	b8 01 00 00 00       	mov    $0x1,%eax
801048aa:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801048ae:	89 1c 24             	mov    %ebx,(%esp)
801048b1:	e8 ca cc ff ff       	call   80101580 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
801048b6:	83 c4 10             	add    $0x10,%esp
801048b9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801048be:	74 40                	je     80104900 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
801048c0:	83 ec 04             	sub    $0x4,%esp
801048c3:	ff 73 04             	pushl  0x4(%ebx)
801048c6:	56                   	push   %esi
801048c7:	57                   	push   %edi
801048c8:	e8 f3 d4 ff ff       	call   80101dc0 <dirlink>
801048cd:	83 c4 10             	add    $0x10,%esp
801048d0:	85 c0                	test   %eax,%eax
801048d2:	78 77                	js     8010494b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
801048d4:	83 ec 0c             	sub    $0xc,%esp
801048d7:	57                   	push   %edi
801048d8:	e8 e3 cf ff ff       	call   801018c0 <iunlockput>

  return ip;
801048dd:	83 c4 10             	add    $0x10,%esp
}
801048e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
801048e3:	89 d8                	mov    %ebx,%eax
}
801048e5:	5b                   	pop    %ebx
801048e6:	5e                   	pop    %esi
801048e7:	5f                   	pop    %edi
801048e8:	5d                   	pop    %ebp
801048e9:	c3                   	ret    
801048ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
801048f0:	31 c0                	xor    %eax,%eax
801048f2:	e9 49 ff ff ff       	jmp    80104840 <create+0x70>
801048f7:	89 f6                	mov    %esi,%esi
801048f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104900:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104905:	83 ec 0c             	sub    $0xc,%esp
80104908:	57                   	push   %edi
80104909:	e8 72 cc ff ff       	call   80101580 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010490e:	83 c4 0c             	add    $0xc,%esp
80104911:	ff 73 04             	pushl  0x4(%ebx)
80104914:	68 5c 77 10 80       	push   $0x8010775c
80104919:	53                   	push   %ebx
8010491a:	e8 a1 d4 ff ff       	call   80101dc0 <dirlink>
8010491f:	83 c4 10             	add    $0x10,%esp
80104922:	85 c0                	test   %eax,%eax
80104924:	78 18                	js     8010493e <create+0x16e>
80104926:	83 ec 04             	sub    $0x4,%esp
80104929:	ff 77 04             	pushl  0x4(%edi)
8010492c:	68 5b 77 10 80       	push   $0x8010775b
80104931:	53                   	push   %ebx
80104932:	e8 89 d4 ff ff       	call   80101dc0 <dirlink>
80104937:	83 c4 10             	add    $0x10,%esp
8010493a:	85 c0                	test   %eax,%eax
8010493c:	79 82                	jns    801048c0 <create+0xf0>
      panic("create dots");
8010493e:	83 ec 0c             	sub    $0xc,%esp
80104941:	68 4f 77 10 80       	push   $0x8010774f
80104946:	e8 25 ba ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010494b:	83 ec 0c             	sub    $0xc,%esp
8010494e:	68 5e 77 10 80       	push   $0x8010775e
80104953:	e8 18 ba ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104958:	83 ec 0c             	sub    $0xc,%esp
8010495b:	68 40 77 10 80       	push   $0x80107740
80104960:	e8 0b ba ff ff       	call   80100370 <panic>
80104965:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104969:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104970 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104970:	55                   	push   %ebp
80104971:	89 e5                	mov    %esp,%ebp
80104973:	56                   	push   %esi
80104974:	53                   	push   %ebx
80104975:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104977:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
8010497a:	89 d3                	mov    %edx,%ebx
8010497c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010497f:	50                   	push   %eax
80104980:	6a 00                	push   $0x0
80104982:	e8 29 fd ff ff       	call   801046b0 <argint>
80104987:	83 c4 10             	add    $0x10,%esp
8010498a:	85 c0                	test   %eax,%eax
8010498c:	78 32                	js     801049c0 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010498e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104992:	77 2c                	ja     801049c0 <argfd.constprop.0+0x50>
80104994:	e8 a7 ed ff ff       	call   80103740 <myproc>
80104999:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010499c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801049a0:	85 c0                	test   %eax,%eax
801049a2:	74 1c                	je     801049c0 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
801049a4:	85 f6                	test   %esi,%esi
801049a6:	74 02                	je     801049aa <argfd.constprop.0+0x3a>
    *pfd = fd;
801049a8:	89 16                	mov    %edx,(%esi)
  if(pf)
801049aa:	85 db                	test   %ebx,%ebx
801049ac:	74 22                	je     801049d0 <argfd.constprop.0+0x60>
    *pf = f;
801049ae:	89 03                	mov    %eax,(%ebx)
  return 0;
801049b0:	31 c0                	xor    %eax,%eax
}
801049b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049b5:	5b                   	pop    %ebx
801049b6:	5e                   	pop    %esi
801049b7:	5d                   	pop    %ebp
801049b8:	c3                   	ret    
801049b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
801049c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
801049c8:	5b                   	pop    %ebx
801049c9:	5e                   	pop    %esi
801049ca:	5d                   	pop    %ebp
801049cb:	c3                   	ret    
801049cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
801049d0:	31 c0                	xor    %eax,%eax
801049d2:	eb de                	jmp    801049b2 <argfd.constprop.0+0x42>
801049d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801049e0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801049e0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801049e1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
801049e3:	89 e5                	mov    %esp,%ebp
801049e5:	56                   	push   %esi
801049e6:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801049e7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
801049ea:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801049ed:	e8 7e ff ff ff       	call   80104970 <argfd.constprop.0>
801049f2:	85 c0                	test   %eax,%eax
801049f4:	78 1a                	js     80104a10 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
801049f6:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
801049f8:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
801049fb:	e8 40 ed ff ff       	call   80103740 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104a00:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104a04:	85 d2                	test   %edx,%edx
80104a06:	74 18                	je     80104a20 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104a08:	83 c3 01             	add    $0x1,%ebx
80104a0b:	83 fb 10             	cmp    $0x10,%ebx
80104a0e:	75 f0                	jne    80104a00 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104a10:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104a13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104a18:	5b                   	pop    %ebx
80104a19:	5e                   	pop    %esi
80104a1a:	5d                   	pop    %ebp
80104a1b:	c3                   	ret    
80104a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104a20:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104a24:	83 ec 0c             	sub    $0xc,%esp
80104a27:	ff 75 f4             	pushl  -0xc(%ebp)
80104a2a:	e8 71 c3 ff ff       	call   80100da0 <filedup>
  return fd;
80104a2f:	83 c4 10             	add    $0x10,%esp
}
80104a32:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80104a35:	89 d8                	mov    %ebx,%eax
}
80104a37:	5b                   	pop    %ebx
80104a38:	5e                   	pop    %esi
80104a39:	5d                   	pop    %ebp
80104a3a:	c3                   	ret    
80104a3b:	90                   	nop
80104a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a40 <sys_read>:

int
sys_read(void)
{
80104a40:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a41:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104a43:	89 e5                	mov    %esp,%ebp
80104a45:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a48:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104a4b:	e8 20 ff ff ff       	call   80104970 <argfd.constprop.0>
80104a50:	85 c0                	test   %eax,%eax
80104a52:	78 4c                	js     80104aa0 <sys_read+0x60>
80104a54:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a57:	83 ec 08             	sub    $0x8,%esp
80104a5a:	50                   	push   %eax
80104a5b:	6a 02                	push   $0x2
80104a5d:	e8 4e fc ff ff       	call   801046b0 <argint>
80104a62:	83 c4 10             	add    $0x10,%esp
80104a65:	85 c0                	test   %eax,%eax
80104a67:	78 37                	js     80104aa0 <sys_read+0x60>
80104a69:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a6c:	83 ec 04             	sub    $0x4,%esp
80104a6f:	ff 75 f0             	pushl  -0x10(%ebp)
80104a72:	50                   	push   %eax
80104a73:	6a 01                	push   $0x1
80104a75:	e8 66 fc ff ff       	call   801046e0 <argptr>
80104a7a:	83 c4 10             	add    $0x10,%esp
80104a7d:	85 c0                	test   %eax,%eax
80104a7f:	78 1f                	js     80104aa0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104a81:	83 ec 04             	sub    $0x4,%esp
80104a84:	ff 75 f0             	pushl  -0x10(%ebp)
80104a87:	ff 75 f4             	pushl  -0xc(%ebp)
80104a8a:	ff 75 ec             	pushl  -0x14(%ebp)
80104a8d:	e8 7e c4 ff ff       	call   80100f10 <fileread>
80104a92:	83 c4 10             	add    $0x10,%esp
}
80104a95:	c9                   	leave  
80104a96:	c3                   	ret    
80104a97:	89 f6                	mov    %esi,%esi
80104a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104aa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104aa5:	c9                   	leave  
80104aa6:	c3                   	ret    
80104aa7:	89 f6                	mov    %esi,%esi
80104aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ab0 <sys_write>:

int
sys_write(void)
{
80104ab0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ab1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104ab3:	89 e5                	mov    %esp,%ebp
80104ab5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ab8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104abb:	e8 b0 fe ff ff       	call   80104970 <argfd.constprop.0>
80104ac0:	85 c0                	test   %eax,%eax
80104ac2:	78 4c                	js     80104b10 <sys_write+0x60>
80104ac4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ac7:	83 ec 08             	sub    $0x8,%esp
80104aca:	50                   	push   %eax
80104acb:	6a 02                	push   $0x2
80104acd:	e8 de fb ff ff       	call   801046b0 <argint>
80104ad2:	83 c4 10             	add    $0x10,%esp
80104ad5:	85 c0                	test   %eax,%eax
80104ad7:	78 37                	js     80104b10 <sys_write+0x60>
80104ad9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104adc:	83 ec 04             	sub    $0x4,%esp
80104adf:	ff 75 f0             	pushl  -0x10(%ebp)
80104ae2:	50                   	push   %eax
80104ae3:	6a 01                	push   $0x1
80104ae5:	e8 f6 fb ff ff       	call   801046e0 <argptr>
80104aea:	83 c4 10             	add    $0x10,%esp
80104aed:	85 c0                	test   %eax,%eax
80104aef:	78 1f                	js     80104b10 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104af1:	83 ec 04             	sub    $0x4,%esp
80104af4:	ff 75 f0             	pushl  -0x10(%ebp)
80104af7:	ff 75 f4             	pushl  -0xc(%ebp)
80104afa:	ff 75 ec             	pushl  -0x14(%ebp)
80104afd:	e8 9e c4 ff ff       	call   80100fa0 <filewrite>
80104b02:	83 c4 10             	add    $0x10,%esp
}
80104b05:	c9                   	leave  
80104b06:	c3                   	ret    
80104b07:	89 f6                	mov    %esi,%esi
80104b09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104b10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104b15:	c9                   	leave  
80104b16:	c3                   	ret    
80104b17:	89 f6                	mov    %esi,%esi
80104b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b20 <sys_close>:

int
sys_close(void)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104b26:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104b29:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b2c:	e8 3f fe ff ff       	call   80104970 <argfd.constprop.0>
80104b31:	85 c0                	test   %eax,%eax
80104b33:	78 2b                	js     80104b60 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80104b35:	e8 06 ec ff ff       	call   80103740 <myproc>
80104b3a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104b3d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80104b40:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104b47:	00 
  fileclose(f);
80104b48:	ff 75 f4             	pushl  -0xc(%ebp)
80104b4b:	e8 a0 c2 ff ff       	call   80100df0 <fileclose>
  return 0;
80104b50:	83 c4 10             	add    $0x10,%esp
80104b53:	31 c0                	xor    %eax,%eax
}
80104b55:	c9                   	leave  
80104b56:	c3                   	ret    
80104b57:	89 f6                	mov    %esi,%esi
80104b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104b60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104b65:	c9                   	leave  
80104b66:	c3                   	ret    
80104b67:	89 f6                	mov    %esi,%esi
80104b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b70 <sys_fstat>:

int
sys_fstat(void)
{
80104b70:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b71:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104b73:	89 e5                	mov    %esp,%ebp
80104b75:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b78:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104b7b:	e8 f0 fd ff ff       	call   80104970 <argfd.constprop.0>
80104b80:	85 c0                	test   %eax,%eax
80104b82:	78 2c                	js     80104bb0 <sys_fstat+0x40>
80104b84:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b87:	83 ec 04             	sub    $0x4,%esp
80104b8a:	6a 14                	push   $0x14
80104b8c:	50                   	push   %eax
80104b8d:	6a 01                	push   $0x1
80104b8f:	e8 4c fb ff ff       	call   801046e0 <argptr>
80104b94:	83 c4 10             	add    $0x10,%esp
80104b97:	85 c0                	test   %eax,%eax
80104b99:	78 15                	js     80104bb0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104b9b:	83 ec 08             	sub    $0x8,%esp
80104b9e:	ff 75 f4             	pushl  -0xc(%ebp)
80104ba1:	ff 75 f0             	pushl  -0x10(%ebp)
80104ba4:	e8 17 c3 ff ff       	call   80100ec0 <filestat>
80104ba9:	83 c4 10             	add    $0x10,%esp
}
80104bac:	c9                   	leave  
80104bad:	c3                   	ret    
80104bae:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104bb5:	c9                   	leave  
80104bb6:	c3                   	ret    
80104bb7:	89 f6                	mov    %esi,%esi
80104bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bc0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	57                   	push   %edi
80104bc4:	56                   	push   %esi
80104bc5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104bc6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104bc9:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104bcc:	50                   	push   %eax
80104bcd:	6a 00                	push   $0x0
80104bcf:	e8 3c fb ff ff       	call   80104710 <argstr>
80104bd4:	83 c4 10             	add    $0x10,%esp
80104bd7:	85 c0                	test   %eax,%eax
80104bd9:	0f 88 fb 00 00 00    	js     80104cda <sys_link+0x11a>
80104bdf:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104be2:	83 ec 08             	sub    $0x8,%esp
80104be5:	50                   	push   %eax
80104be6:	6a 01                	push   $0x1
80104be8:	e8 23 fb ff ff       	call   80104710 <argstr>
80104bed:	83 c4 10             	add    $0x10,%esp
80104bf0:	85 c0                	test   %eax,%eax
80104bf2:	0f 88 e2 00 00 00    	js     80104cda <sys_link+0x11a>
    return -1;

  begin_op();
80104bf8:	e8 13 df ff ff       	call   80102b10 <begin_op>
  if((ip = namei(old)) == 0){
80104bfd:	83 ec 0c             	sub    $0xc,%esp
80104c00:	ff 75 d4             	pushl  -0x2c(%ebp)
80104c03:	e8 78 d2 ff ff       	call   80101e80 <namei>
80104c08:	83 c4 10             	add    $0x10,%esp
80104c0b:	85 c0                	test   %eax,%eax
80104c0d:	89 c3                	mov    %eax,%ebx
80104c0f:	0f 84 f3 00 00 00    	je     80104d08 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80104c15:	83 ec 0c             	sub    $0xc,%esp
80104c18:	50                   	push   %eax
80104c19:	e8 12 ca ff ff       	call   80101630 <ilock>
  if(ip->type == T_DIR){
80104c1e:	83 c4 10             	add    $0x10,%esp
80104c21:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c26:	0f 84 c4 00 00 00    	je     80104cf0 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104c2c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104c31:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104c34:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104c37:	53                   	push   %ebx
80104c38:	e8 43 c9 ff ff       	call   80101580 <iupdate>
  iunlock(ip);
80104c3d:	89 1c 24             	mov    %ebx,(%esp)
80104c40:	e8 cb ca ff ff       	call   80101710 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104c45:	58                   	pop    %eax
80104c46:	5a                   	pop    %edx
80104c47:	57                   	push   %edi
80104c48:	ff 75 d0             	pushl  -0x30(%ebp)
80104c4b:	e8 50 d2 ff ff       	call   80101ea0 <nameiparent>
80104c50:	83 c4 10             	add    $0x10,%esp
80104c53:	85 c0                	test   %eax,%eax
80104c55:	89 c6                	mov    %eax,%esi
80104c57:	74 5b                	je     80104cb4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80104c59:	83 ec 0c             	sub    $0xc,%esp
80104c5c:	50                   	push   %eax
80104c5d:	e8 ce c9 ff ff       	call   80101630 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104c62:	83 c4 10             	add    $0x10,%esp
80104c65:	8b 03                	mov    (%ebx),%eax
80104c67:	39 06                	cmp    %eax,(%esi)
80104c69:	75 3d                	jne    80104ca8 <sys_link+0xe8>
80104c6b:	83 ec 04             	sub    $0x4,%esp
80104c6e:	ff 73 04             	pushl  0x4(%ebx)
80104c71:	57                   	push   %edi
80104c72:	56                   	push   %esi
80104c73:	e8 48 d1 ff ff       	call   80101dc0 <dirlink>
80104c78:	83 c4 10             	add    $0x10,%esp
80104c7b:	85 c0                	test   %eax,%eax
80104c7d:	78 29                	js     80104ca8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104c7f:	83 ec 0c             	sub    $0xc,%esp
80104c82:	56                   	push   %esi
80104c83:	e8 38 cc ff ff       	call   801018c0 <iunlockput>
  iput(ip);
80104c88:	89 1c 24             	mov    %ebx,(%esp)
80104c8b:	e8 d0 ca ff ff       	call   80101760 <iput>

  end_op();
80104c90:	e8 eb de ff ff       	call   80102b80 <end_op>

  return 0;
80104c95:	83 c4 10             	add    $0x10,%esp
80104c98:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104c9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c9d:	5b                   	pop    %ebx
80104c9e:	5e                   	pop    %esi
80104c9f:	5f                   	pop    %edi
80104ca0:	5d                   	pop    %ebp
80104ca1:	c3                   	ret    
80104ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104ca8:	83 ec 0c             	sub    $0xc,%esp
80104cab:	56                   	push   %esi
80104cac:	e8 0f cc ff ff       	call   801018c0 <iunlockput>
    goto bad;
80104cb1:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80104cb4:	83 ec 0c             	sub    $0xc,%esp
80104cb7:	53                   	push   %ebx
80104cb8:	e8 73 c9 ff ff       	call   80101630 <ilock>
  ip->nlink--;
80104cbd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104cc2:	89 1c 24             	mov    %ebx,(%esp)
80104cc5:	e8 b6 c8 ff ff       	call   80101580 <iupdate>
  iunlockput(ip);
80104cca:	89 1c 24             	mov    %ebx,(%esp)
80104ccd:	e8 ee cb ff ff       	call   801018c0 <iunlockput>
  end_op();
80104cd2:	e8 a9 de ff ff       	call   80102b80 <end_op>
  return -1;
80104cd7:	83 c4 10             	add    $0x10,%esp
}
80104cda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104cdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ce2:	5b                   	pop    %ebx
80104ce3:	5e                   	pop    %esi
80104ce4:	5f                   	pop    %edi
80104ce5:	5d                   	pop    %ebp
80104ce6:	c3                   	ret    
80104ce7:	89 f6                	mov    %esi,%esi
80104ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80104cf0:	83 ec 0c             	sub    $0xc,%esp
80104cf3:	53                   	push   %ebx
80104cf4:	e8 c7 cb ff ff       	call   801018c0 <iunlockput>
    end_op();
80104cf9:	e8 82 de ff ff       	call   80102b80 <end_op>
    return -1;
80104cfe:	83 c4 10             	add    $0x10,%esp
80104d01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d06:	eb 92                	jmp    80104c9a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80104d08:	e8 73 de ff ff       	call   80102b80 <end_op>
    return -1;
80104d0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d12:	eb 86                	jmp    80104c9a <sys_link+0xda>
80104d14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104d20 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	57                   	push   %edi
80104d24:	56                   	push   %esi
80104d25:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104d26:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104d29:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104d2c:	50                   	push   %eax
80104d2d:	6a 00                	push   $0x0
80104d2f:	e8 dc f9 ff ff       	call   80104710 <argstr>
80104d34:	83 c4 10             	add    $0x10,%esp
80104d37:	85 c0                	test   %eax,%eax
80104d39:	0f 88 82 01 00 00    	js     80104ec1 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80104d3f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80104d42:	e8 c9 dd ff ff       	call   80102b10 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104d47:	83 ec 08             	sub    $0x8,%esp
80104d4a:	53                   	push   %ebx
80104d4b:	ff 75 c0             	pushl  -0x40(%ebp)
80104d4e:	e8 4d d1 ff ff       	call   80101ea0 <nameiparent>
80104d53:	83 c4 10             	add    $0x10,%esp
80104d56:	85 c0                	test   %eax,%eax
80104d58:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104d5b:	0f 84 6a 01 00 00    	je     80104ecb <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80104d61:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104d64:	83 ec 0c             	sub    $0xc,%esp
80104d67:	56                   	push   %esi
80104d68:	e8 c3 c8 ff ff       	call   80101630 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104d6d:	58                   	pop    %eax
80104d6e:	5a                   	pop    %edx
80104d6f:	68 5c 77 10 80       	push   $0x8010775c
80104d74:	53                   	push   %ebx
80104d75:	e8 c6 cd ff ff       	call   80101b40 <namecmp>
80104d7a:	83 c4 10             	add    $0x10,%esp
80104d7d:	85 c0                	test   %eax,%eax
80104d7f:	0f 84 fc 00 00 00    	je     80104e81 <sys_unlink+0x161>
80104d85:	83 ec 08             	sub    $0x8,%esp
80104d88:	68 5b 77 10 80       	push   $0x8010775b
80104d8d:	53                   	push   %ebx
80104d8e:	e8 ad cd ff ff       	call   80101b40 <namecmp>
80104d93:	83 c4 10             	add    $0x10,%esp
80104d96:	85 c0                	test   %eax,%eax
80104d98:	0f 84 e3 00 00 00    	je     80104e81 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104d9e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104da1:	83 ec 04             	sub    $0x4,%esp
80104da4:	50                   	push   %eax
80104da5:	53                   	push   %ebx
80104da6:	56                   	push   %esi
80104da7:	e8 b4 cd ff ff       	call   80101b60 <dirlookup>
80104dac:	83 c4 10             	add    $0x10,%esp
80104daf:	85 c0                	test   %eax,%eax
80104db1:	89 c3                	mov    %eax,%ebx
80104db3:	0f 84 c8 00 00 00    	je     80104e81 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80104db9:	83 ec 0c             	sub    $0xc,%esp
80104dbc:	50                   	push   %eax
80104dbd:	e8 6e c8 ff ff       	call   80101630 <ilock>

  if(ip->nlink < 1)
80104dc2:	83 c4 10             	add    $0x10,%esp
80104dc5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104dca:	0f 8e 24 01 00 00    	jle    80104ef4 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104dd0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104dd5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104dd8:	74 66                	je     80104e40 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104dda:	83 ec 04             	sub    $0x4,%esp
80104ddd:	6a 10                	push   $0x10
80104ddf:	6a 00                	push   $0x0
80104de1:	56                   	push   %esi
80104de2:	e8 e9 f5 ff ff       	call   801043d0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104de7:	6a 10                	push   $0x10
80104de9:	ff 75 c4             	pushl  -0x3c(%ebp)
80104dec:	56                   	push   %esi
80104ded:	ff 75 b4             	pushl  -0x4c(%ebp)
80104df0:	e8 1b cc ff ff       	call   80101a10 <writei>
80104df5:	83 c4 20             	add    $0x20,%esp
80104df8:	83 f8 10             	cmp    $0x10,%eax
80104dfb:	0f 85 e6 00 00 00    	jne    80104ee7 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104e01:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e06:	0f 84 9c 00 00 00    	je     80104ea8 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104e0c:	83 ec 0c             	sub    $0xc,%esp
80104e0f:	ff 75 b4             	pushl  -0x4c(%ebp)
80104e12:	e8 a9 ca ff ff       	call   801018c0 <iunlockput>

  ip->nlink--;
80104e17:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104e1c:	89 1c 24             	mov    %ebx,(%esp)
80104e1f:	e8 5c c7 ff ff       	call   80101580 <iupdate>
  iunlockput(ip);
80104e24:	89 1c 24             	mov    %ebx,(%esp)
80104e27:	e8 94 ca ff ff       	call   801018c0 <iunlockput>

  end_op();
80104e2c:	e8 4f dd ff ff       	call   80102b80 <end_op>

  return 0;
80104e31:	83 c4 10             	add    $0x10,%esp
80104e34:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104e36:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e39:	5b                   	pop    %ebx
80104e3a:	5e                   	pop    %esi
80104e3b:	5f                   	pop    %edi
80104e3c:	5d                   	pop    %ebp
80104e3d:	c3                   	ret    
80104e3e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104e40:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104e44:	76 94                	jbe    80104dda <sys_unlink+0xba>
80104e46:	bf 20 00 00 00       	mov    $0x20,%edi
80104e4b:	eb 0f                	jmp    80104e5c <sys_unlink+0x13c>
80104e4d:	8d 76 00             	lea    0x0(%esi),%esi
80104e50:	83 c7 10             	add    $0x10,%edi
80104e53:	3b 7b 58             	cmp    0x58(%ebx),%edi
80104e56:	0f 83 7e ff ff ff    	jae    80104dda <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104e5c:	6a 10                	push   $0x10
80104e5e:	57                   	push   %edi
80104e5f:	56                   	push   %esi
80104e60:	53                   	push   %ebx
80104e61:	e8 aa ca ff ff       	call   80101910 <readi>
80104e66:	83 c4 10             	add    $0x10,%esp
80104e69:	83 f8 10             	cmp    $0x10,%eax
80104e6c:	75 6c                	jne    80104eda <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104e6e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104e73:	74 db                	je     80104e50 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104e75:	83 ec 0c             	sub    $0xc,%esp
80104e78:	53                   	push   %ebx
80104e79:	e8 42 ca ff ff       	call   801018c0 <iunlockput>
    goto bad;
80104e7e:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104e81:	83 ec 0c             	sub    $0xc,%esp
80104e84:	ff 75 b4             	pushl  -0x4c(%ebp)
80104e87:	e8 34 ca ff ff       	call   801018c0 <iunlockput>
  end_op();
80104e8c:	e8 ef dc ff ff       	call   80102b80 <end_op>
  return -1;
80104e91:	83 c4 10             	add    $0x10,%esp
}
80104e94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104e97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e9c:	5b                   	pop    %ebx
80104e9d:	5e                   	pop    %esi
80104e9e:	5f                   	pop    %edi
80104e9f:	5d                   	pop    %ebp
80104ea0:	c3                   	ret    
80104ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104ea8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80104eab:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104eae:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104eb3:	50                   	push   %eax
80104eb4:	e8 c7 c6 ff ff       	call   80101580 <iupdate>
80104eb9:	83 c4 10             	add    $0x10,%esp
80104ebc:	e9 4b ff ff ff       	jmp    80104e0c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80104ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ec6:	e9 6b ff ff ff       	jmp    80104e36 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
80104ecb:	e8 b0 dc ff ff       	call   80102b80 <end_op>
    return -1;
80104ed0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ed5:	e9 5c ff ff ff       	jmp    80104e36 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80104eda:	83 ec 0c             	sub    $0xc,%esp
80104edd:	68 80 77 10 80       	push   $0x80107780
80104ee2:	e8 89 b4 ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80104ee7:	83 ec 0c             	sub    $0xc,%esp
80104eea:	68 92 77 10 80       	push   $0x80107792
80104eef:	e8 7c b4 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80104ef4:	83 ec 0c             	sub    $0xc,%esp
80104ef7:	68 6e 77 10 80       	push   $0x8010776e
80104efc:	e8 6f b4 ff ff       	call   80100370 <panic>
80104f01:	eb 0d                	jmp    80104f10 <sys_open>
80104f03:	90                   	nop
80104f04:	90                   	nop
80104f05:	90                   	nop
80104f06:	90                   	nop
80104f07:	90                   	nop
80104f08:	90                   	nop
80104f09:	90                   	nop
80104f0a:	90                   	nop
80104f0b:	90                   	nop
80104f0c:	90                   	nop
80104f0d:	90                   	nop
80104f0e:	90                   	nop
80104f0f:	90                   	nop

80104f10 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80104f10:	55                   	push   %ebp
80104f11:	89 e5                	mov    %esp,%ebp
80104f13:	57                   	push   %edi
80104f14:	56                   	push   %esi
80104f15:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104f16:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80104f19:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104f1c:	50                   	push   %eax
80104f1d:	6a 00                	push   $0x0
80104f1f:	e8 ec f7 ff ff       	call   80104710 <argstr>
80104f24:	83 c4 10             	add    $0x10,%esp
80104f27:	85 c0                	test   %eax,%eax
80104f29:	0f 88 9e 00 00 00    	js     80104fcd <sys_open+0xbd>
80104f2f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104f32:	83 ec 08             	sub    $0x8,%esp
80104f35:	50                   	push   %eax
80104f36:	6a 01                	push   $0x1
80104f38:	e8 73 f7 ff ff       	call   801046b0 <argint>
80104f3d:	83 c4 10             	add    $0x10,%esp
80104f40:	85 c0                	test   %eax,%eax
80104f42:	0f 88 85 00 00 00    	js     80104fcd <sys_open+0xbd>
    return -1;

  begin_op();
80104f48:	e8 c3 db ff ff       	call   80102b10 <begin_op>

  if(omode & O_CREATE){
80104f4d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104f51:	0f 85 89 00 00 00    	jne    80104fe0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104f57:	83 ec 0c             	sub    $0xc,%esp
80104f5a:	ff 75 e0             	pushl  -0x20(%ebp)
80104f5d:	e8 1e cf ff ff       	call   80101e80 <namei>
80104f62:	83 c4 10             	add    $0x10,%esp
80104f65:	85 c0                	test   %eax,%eax
80104f67:	89 c6                	mov    %eax,%esi
80104f69:	0f 84 8e 00 00 00    	je     80104ffd <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
80104f6f:	83 ec 0c             	sub    $0xc,%esp
80104f72:	50                   	push   %eax
80104f73:	e8 b8 c6 ff ff       	call   80101630 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104f78:	83 c4 10             	add    $0x10,%esp
80104f7b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104f80:	0f 84 d2 00 00 00    	je     80105058 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104f86:	e8 a5 bd ff ff       	call   80100d30 <filealloc>
80104f8b:	85 c0                	test   %eax,%eax
80104f8d:	89 c7                	mov    %eax,%edi
80104f8f:	74 2b                	je     80104fbc <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104f91:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80104f93:	e8 a8 e7 ff ff       	call   80103740 <myproc>
80104f98:	90                   	nop
80104f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104fa0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104fa4:	85 d2                	test   %edx,%edx
80104fa6:	74 68                	je     80105010 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104fa8:	83 c3 01             	add    $0x1,%ebx
80104fab:	83 fb 10             	cmp    $0x10,%ebx
80104fae:	75 f0                	jne    80104fa0 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80104fb0:	83 ec 0c             	sub    $0xc,%esp
80104fb3:	57                   	push   %edi
80104fb4:	e8 37 be ff ff       	call   80100df0 <fileclose>
80104fb9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104fbc:	83 ec 0c             	sub    $0xc,%esp
80104fbf:	56                   	push   %esi
80104fc0:	e8 fb c8 ff ff       	call   801018c0 <iunlockput>
    end_op();
80104fc5:	e8 b6 db ff ff       	call   80102b80 <end_op>
    return -1;
80104fca:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104fcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80104fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104fd5:	5b                   	pop    %ebx
80104fd6:	5e                   	pop    %esi
80104fd7:	5f                   	pop    %edi
80104fd8:	5d                   	pop    %ebp
80104fd9:	c3                   	ret    
80104fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104fe0:	83 ec 0c             	sub    $0xc,%esp
80104fe3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104fe6:	31 c9                	xor    %ecx,%ecx
80104fe8:	6a 00                	push   $0x0
80104fea:	ba 02 00 00 00       	mov    $0x2,%edx
80104fef:	e8 dc f7 ff ff       	call   801047d0 <create>
    if(ip == 0){
80104ff4:	83 c4 10             	add    $0x10,%esp
80104ff7:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104ff9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104ffb:	75 89                	jne    80104f86 <sys_open+0x76>
      end_op();
80104ffd:	e8 7e db ff ff       	call   80102b80 <end_op>
      return -1;
80105002:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105007:	eb 43                	jmp    8010504c <sys_open+0x13c>
80105009:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105010:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105013:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105017:	56                   	push   %esi
80105018:	e8 f3 c6 ff ff       	call   80101710 <iunlock>
  end_op();
8010501d:	e8 5e db ff ff       	call   80102b80 <end_op>

  f->type = FD_INODE;
80105022:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105028:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010502b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010502e:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105031:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105038:	89 d0                	mov    %edx,%eax
8010503a:	83 e0 01             	and    $0x1,%eax
8010503d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105040:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105043:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105046:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
8010504a:	89 d8                	mov    %ebx,%eax
}
8010504c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010504f:	5b                   	pop    %ebx
80105050:	5e                   	pop    %esi
80105051:	5f                   	pop    %edi
80105052:	5d                   	pop    %ebp
80105053:	c3                   	ret    
80105054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105058:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010505b:	85 c9                	test   %ecx,%ecx
8010505d:	0f 84 23 ff ff ff    	je     80104f86 <sys_open+0x76>
80105063:	e9 54 ff ff ff       	jmp    80104fbc <sys_open+0xac>
80105068:	90                   	nop
80105069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105070 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105076:	e8 95 da ff ff       	call   80102b10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010507b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010507e:	83 ec 08             	sub    $0x8,%esp
80105081:	50                   	push   %eax
80105082:	6a 00                	push   $0x0
80105084:	e8 87 f6 ff ff       	call   80104710 <argstr>
80105089:	83 c4 10             	add    $0x10,%esp
8010508c:	85 c0                	test   %eax,%eax
8010508e:	78 30                	js     801050c0 <sys_mkdir+0x50>
80105090:	83 ec 0c             	sub    $0xc,%esp
80105093:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105096:	31 c9                	xor    %ecx,%ecx
80105098:	6a 00                	push   $0x0
8010509a:	ba 01 00 00 00       	mov    $0x1,%edx
8010509f:	e8 2c f7 ff ff       	call   801047d0 <create>
801050a4:	83 c4 10             	add    $0x10,%esp
801050a7:	85 c0                	test   %eax,%eax
801050a9:	74 15                	je     801050c0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801050ab:	83 ec 0c             	sub    $0xc,%esp
801050ae:	50                   	push   %eax
801050af:	e8 0c c8 ff ff       	call   801018c0 <iunlockput>
  end_op();
801050b4:	e8 c7 da ff ff       	call   80102b80 <end_op>
  return 0;
801050b9:	83 c4 10             	add    $0x10,%esp
801050bc:	31 c0                	xor    %eax,%eax
}
801050be:	c9                   	leave  
801050bf:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
801050c0:	e8 bb da ff ff       	call   80102b80 <end_op>
    return -1;
801050c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801050ca:	c9                   	leave  
801050cb:	c3                   	ret    
801050cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050d0 <sys_mknod>:

int
sys_mknod(void)
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801050d6:	e8 35 da ff ff       	call   80102b10 <begin_op>
  if((argstr(0, &path)) < 0 ||
801050db:	8d 45 ec             	lea    -0x14(%ebp),%eax
801050de:	83 ec 08             	sub    $0x8,%esp
801050e1:	50                   	push   %eax
801050e2:	6a 00                	push   $0x0
801050e4:	e8 27 f6 ff ff       	call   80104710 <argstr>
801050e9:	83 c4 10             	add    $0x10,%esp
801050ec:	85 c0                	test   %eax,%eax
801050ee:	78 60                	js     80105150 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801050f0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050f3:	83 ec 08             	sub    $0x8,%esp
801050f6:	50                   	push   %eax
801050f7:	6a 01                	push   $0x1
801050f9:	e8 b2 f5 ff ff       	call   801046b0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801050fe:	83 c4 10             	add    $0x10,%esp
80105101:	85 c0                	test   %eax,%eax
80105103:	78 4b                	js     80105150 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105105:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105108:	83 ec 08             	sub    $0x8,%esp
8010510b:	50                   	push   %eax
8010510c:	6a 02                	push   $0x2
8010510e:	e8 9d f5 ff ff       	call   801046b0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105113:	83 c4 10             	add    $0x10,%esp
80105116:	85 c0                	test   %eax,%eax
80105118:	78 36                	js     80105150 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010511a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010511e:	83 ec 0c             	sub    $0xc,%esp
80105121:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105125:	ba 03 00 00 00       	mov    $0x3,%edx
8010512a:	50                   	push   %eax
8010512b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010512e:	e8 9d f6 ff ff       	call   801047d0 <create>
80105133:	83 c4 10             	add    $0x10,%esp
80105136:	85 c0                	test   %eax,%eax
80105138:	74 16                	je     80105150 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010513a:	83 ec 0c             	sub    $0xc,%esp
8010513d:	50                   	push   %eax
8010513e:	e8 7d c7 ff ff       	call   801018c0 <iunlockput>
  end_op();
80105143:	e8 38 da ff ff       	call   80102b80 <end_op>
  return 0;
80105148:	83 c4 10             	add    $0x10,%esp
8010514b:	31 c0                	xor    %eax,%eax
}
8010514d:	c9                   	leave  
8010514e:	c3                   	ret    
8010514f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105150:	e8 2b da ff ff       	call   80102b80 <end_op>
    return -1;
80105155:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010515a:	c9                   	leave  
8010515b:	c3                   	ret    
8010515c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105160 <sys_chdir>:

int
sys_chdir(void)
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	56                   	push   %esi
80105164:	53                   	push   %ebx
80105165:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105168:	e8 d3 e5 ff ff       	call   80103740 <myproc>
8010516d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010516f:	e8 9c d9 ff ff       	call   80102b10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105174:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105177:	83 ec 08             	sub    $0x8,%esp
8010517a:	50                   	push   %eax
8010517b:	6a 00                	push   $0x0
8010517d:	e8 8e f5 ff ff       	call   80104710 <argstr>
80105182:	83 c4 10             	add    $0x10,%esp
80105185:	85 c0                	test   %eax,%eax
80105187:	78 77                	js     80105200 <sys_chdir+0xa0>
80105189:	83 ec 0c             	sub    $0xc,%esp
8010518c:	ff 75 f4             	pushl  -0xc(%ebp)
8010518f:	e8 ec cc ff ff       	call   80101e80 <namei>
80105194:	83 c4 10             	add    $0x10,%esp
80105197:	85 c0                	test   %eax,%eax
80105199:	89 c3                	mov    %eax,%ebx
8010519b:	74 63                	je     80105200 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010519d:	83 ec 0c             	sub    $0xc,%esp
801051a0:	50                   	push   %eax
801051a1:	e8 8a c4 ff ff       	call   80101630 <ilock>
  if(ip->type != T_DIR){
801051a6:	83 c4 10             	add    $0x10,%esp
801051a9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051ae:	75 30                	jne    801051e0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801051b0:	83 ec 0c             	sub    $0xc,%esp
801051b3:	53                   	push   %ebx
801051b4:	e8 57 c5 ff ff       	call   80101710 <iunlock>
  iput(curproc->cwd);
801051b9:	58                   	pop    %eax
801051ba:	ff 76 68             	pushl  0x68(%esi)
801051bd:	e8 9e c5 ff ff       	call   80101760 <iput>
  end_op();
801051c2:	e8 b9 d9 ff ff       	call   80102b80 <end_op>
  curproc->cwd = ip;
801051c7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801051ca:	83 c4 10             	add    $0x10,%esp
801051cd:	31 c0                	xor    %eax,%eax
}
801051cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051d2:	5b                   	pop    %ebx
801051d3:	5e                   	pop    %esi
801051d4:	5d                   	pop    %ebp
801051d5:	c3                   	ret    
801051d6:	8d 76 00             	lea    0x0(%esi),%esi
801051d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
801051e0:	83 ec 0c             	sub    $0xc,%esp
801051e3:	53                   	push   %ebx
801051e4:	e8 d7 c6 ff ff       	call   801018c0 <iunlockput>
    end_op();
801051e9:	e8 92 d9 ff ff       	call   80102b80 <end_op>
    return -1;
801051ee:	83 c4 10             	add    $0x10,%esp
801051f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051f6:	eb d7                	jmp    801051cf <sys_chdir+0x6f>
801051f8:	90                   	nop
801051f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105200:	e8 7b d9 ff ff       	call   80102b80 <end_op>
    return -1;
80105205:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010520a:	eb c3                	jmp    801051cf <sys_chdir+0x6f>
8010520c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105210 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105210:	55                   	push   %ebp
80105211:	89 e5                	mov    %esp,%ebp
80105213:	57                   	push   %edi
80105214:	56                   	push   %esi
80105215:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105216:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010521c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105222:	50                   	push   %eax
80105223:	6a 00                	push   $0x0
80105225:	e8 e6 f4 ff ff       	call   80104710 <argstr>
8010522a:	83 c4 10             	add    $0x10,%esp
8010522d:	85 c0                	test   %eax,%eax
8010522f:	78 7f                	js     801052b0 <sys_exec+0xa0>
80105231:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105237:	83 ec 08             	sub    $0x8,%esp
8010523a:	50                   	push   %eax
8010523b:	6a 01                	push   $0x1
8010523d:	e8 6e f4 ff ff       	call   801046b0 <argint>
80105242:	83 c4 10             	add    $0x10,%esp
80105245:	85 c0                	test   %eax,%eax
80105247:	78 67                	js     801052b0 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105249:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010524f:	83 ec 04             	sub    $0x4,%esp
80105252:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105258:	68 80 00 00 00       	push   $0x80
8010525d:	6a 00                	push   $0x0
8010525f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105265:	50                   	push   %eax
80105266:	31 db                	xor    %ebx,%ebx
80105268:	e8 63 f1 ff ff       	call   801043d0 <memset>
8010526d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105270:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105276:	83 ec 08             	sub    $0x8,%esp
80105279:	57                   	push   %edi
8010527a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010527d:	50                   	push   %eax
8010527e:	e8 bd f3 ff ff       	call   80104640 <fetchint>
80105283:	83 c4 10             	add    $0x10,%esp
80105286:	85 c0                	test   %eax,%eax
80105288:	78 26                	js     801052b0 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
8010528a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105290:	85 c0                	test   %eax,%eax
80105292:	74 2c                	je     801052c0 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105294:	83 ec 08             	sub    $0x8,%esp
80105297:	56                   	push   %esi
80105298:	50                   	push   %eax
80105299:	e8 c2 f3 ff ff       	call   80104660 <fetchstr>
8010529e:	83 c4 10             	add    $0x10,%esp
801052a1:	85 c0                	test   %eax,%eax
801052a3:	78 0b                	js     801052b0 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801052a5:	83 c3 01             	add    $0x1,%ebx
801052a8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801052ab:	83 fb 20             	cmp    $0x20,%ebx
801052ae:	75 c0                	jne    80105270 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801052b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801052b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801052b8:	5b                   	pop    %ebx
801052b9:	5e                   	pop    %esi
801052ba:	5f                   	pop    %edi
801052bb:	5d                   	pop    %ebp
801052bc:	c3                   	ret    
801052bd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801052c0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801052c6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801052c9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801052d0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801052d4:	50                   	push   %eax
801052d5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801052db:	e8 10 b7 ff ff       	call   801009f0 <exec>
801052e0:	83 c4 10             	add    $0x10,%esp
}
801052e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052e6:	5b                   	pop    %ebx
801052e7:	5e                   	pop    %esi
801052e8:	5f                   	pop    %edi
801052e9:	5d                   	pop    %ebp
801052ea:	c3                   	ret    
801052eb:	90                   	nop
801052ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801052f0 <sys_pipe>:

int
sys_pipe(void)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	57                   	push   %edi
801052f4:	56                   	push   %esi
801052f5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801052f6:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
801052f9:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801052fc:	6a 08                	push   $0x8
801052fe:	50                   	push   %eax
801052ff:	6a 00                	push   $0x0
80105301:	e8 da f3 ff ff       	call   801046e0 <argptr>
80105306:	83 c4 10             	add    $0x10,%esp
80105309:	85 c0                	test   %eax,%eax
8010530b:	78 4a                	js     80105357 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010530d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105310:	83 ec 08             	sub    $0x8,%esp
80105313:	50                   	push   %eax
80105314:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105317:	50                   	push   %eax
80105318:	e8 93 de ff ff       	call   801031b0 <pipealloc>
8010531d:	83 c4 10             	add    $0x10,%esp
80105320:	85 c0                	test   %eax,%eax
80105322:	78 33                	js     80105357 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105324:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105326:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105329:	e8 12 e4 ff ff       	call   80103740 <myproc>
8010532e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105330:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105334:	85 f6                	test   %esi,%esi
80105336:	74 30                	je     80105368 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105338:	83 c3 01             	add    $0x1,%ebx
8010533b:	83 fb 10             	cmp    $0x10,%ebx
8010533e:	75 f0                	jne    80105330 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105340:	83 ec 0c             	sub    $0xc,%esp
80105343:	ff 75 e0             	pushl  -0x20(%ebp)
80105346:	e8 a5 ba ff ff       	call   80100df0 <fileclose>
    fileclose(wf);
8010534b:	58                   	pop    %eax
8010534c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010534f:	e8 9c ba ff ff       	call   80100df0 <fileclose>
    return -1;
80105354:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105357:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
8010535a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010535f:	5b                   	pop    %ebx
80105360:	5e                   	pop    %esi
80105361:	5f                   	pop    %edi
80105362:	5d                   	pop    %ebp
80105363:	c3                   	ret    
80105364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105368:	8d 73 08             	lea    0x8(%ebx),%esi
8010536b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010536f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105372:	e8 c9 e3 ff ff       	call   80103740 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105377:	31 d2                	xor    %edx,%edx
80105379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105380:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105384:	85 c9                	test   %ecx,%ecx
80105386:	74 18                	je     801053a0 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105388:	83 c2 01             	add    $0x1,%edx
8010538b:	83 fa 10             	cmp    $0x10,%edx
8010538e:	75 f0                	jne    80105380 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105390:	e8 ab e3 ff ff       	call   80103740 <myproc>
80105395:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
8010539c:	00 
8010539d:	eb a1                	jmp    80105340 <sys_pipe+0x50>
8010539f:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801053a0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801053a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801053a7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801053a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801053ac:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
801053af:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
801053b2:	31 c0                	xor    %eax,%eax
}
801053b4:	5b                   	pop    %ebx
801053b5:	5e                   	pop    %esi
801053b6:	5f                   	pop    %edi
801053b7:	5d                   	pop    %ebp
801053b8:	c3                   	ret    
801053b9:	66 90                	xchg   %ax,%ax
801053bb:	66 90                	xchg   %ax,%ax
801053bd:	66 90                	xchg   %ax,%ax
801053bf:	90                   	nop

801053c0 <sys_shm_open>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_shm_open(void) {
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	83 ec 20             	sub    $0x20,%esp
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
801053c6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053c9:	50                   	push   %eax
801053ca:	6a 00                	push   $0x0
801053cc:	e8 df f2 ff ff       	call   801046b0 <argint>
801053d1:	83 c4 10             	add    $0x10,%esp
801053d4:	85 c0                	test   %eax,%eax
801053d6:	78 30                	js     80105408 <sys_shm_open+0x48>
    return -1;

  if(argptr(1, (char **) (&pointer),4)<0)
801053d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053db:	83 ec 04             	sub    $0x4,%esp
801053de:	6a 04                	push   $0x4
801053e0:	50                   	push   %eax
801053e1:	6a 01                	push   $0x1
801053e3:	e8 f8 f2 ff ff       	call   801046e0 <argptr>
801053e8:	83 c4 10             	add    $0x10,%esp
801053eb:	85 c0                	test   %eax,%eax
801053ed:	78 19                	js     80105408 <sys_shm_open+0x48>
    return -1;
  return shm_open(id, pointer);
801053ef:	83 ec 08             	sub    $0x8,%esp
801053f2:	ff 75 f4             	pushl  -0xc(%ebp)
801053f5:	ff 75 f0             	pushl  -0x10(%ebp)
801053f8:	e8 d3 1b 00 00       	call   80106fd0 <shm_open>
801053fd:	83 c4 10             	add    $0x10,%esp
}
80105400:	c9                   	leave  
80105401:	c3                   	ret    
80105402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
int sys_shm_open(void) {
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
    return -1;
80105408:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  if(argptr(1, (char **) (&pointer),4)<0)
    return -1;
  return shm_open(id, pointer);
}
8010540d:	c9                   	leave  
8010540e:	c3                   	ret    
8010540f:	90                   	nop

80105410 <sys_shm_close>:

int sys_shm_close(void) {
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	83 ec 20             	sub    $0x20,%esp
  int id;

  if(argint(0, &id) < 0)
80105416:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105419:	50                   	push   %eax
8010541a:	6a 00                	push   $0x0
8010541c:	e8 8f f2 ff ff       	call   801046b0 <argint>
80105421:	83 c4 10             	add    $0x10,%esp
80105424:	85 c0                	test   %eax,%eax
80105426:	78 18                	js     80105440 <sys_shm_close+0x30>
    return -1;

  
  return shm_close(id);
80105428:	83 ec 0c             	sub    $0xc,%esp
8010542b:	ff 75 f4             	pushl  -0xc(%ebp)
8010542e:	e8 ad 1b 00 00       	call   80106fe0 <shm_close>
80105433:	83 c4 10             	add    $0x10,%esp
}
80105436:	c9                   	leave  
80105437:	c3                   	ret    
80105438:	90                   	nop
80105439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

int sys_shm_close(void) {
  int id;

  if(argint(0, &id) < 0)
    return -1;
80105440:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  
  return shm_close(id);
}
80105445:	c9                   	leave  
80105446:	c3                   	ret    
80105447:	89 f6                	mov    %esi,%esi
80105449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105450 <sys_fork>:

int
sys_fork(void)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105453:	5d                   	pop    %ebp
}

int
sys_fork(void)
{
  return fork();
80105454:	e9 87 e4 ff ff       	jmp    801038e0 <fork>
80105459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105460 <sys_exit>:
}

int
sys_exit(void)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	83 ec 08             	sub    $0x8,%esp
  exit();
80105466:	e8 05 e7 ff ff       	call   80103b70 <exit>
  return 0;  // not reached
}
8010546b:	31 c0                	xor    %eax,%eax
8010546d:	c9                   	leave  
8010546e:	c3                   	ret    
8010546f:	90                   	nop

80105470 <sys_wait>:

int
sys_wait(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105473:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105474:	e9 37 e9 ff ff       	jmp    80103db0 <wait>
80105479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105480 <sys_kill>:
}

int
sys_kill(void)
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
80105483:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105486:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105489:	50                   	push   %eax
8010548a:	6a 00                	push   $0x0
8010548c:	e8 1f f2 ff ff       	call   801046b0 <argint>
80105491:	83 c4 10             	add    $0x10,%esp
80105494:	85 c0                	test   %eax,%eax
80105496:	78 18                	js     801054b0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105498:	83 ec 0c             	sub    $0xc,%esp
8010549b:	ff 75 f4             	pushl  -0xc(%ebp)
8010549e:	e8 5d ea ff ff       	call   80103f00 <kill>
801054a3:	83 c4 10             	add    $0x10,%esp
}
801054a6:	c9                   	leave  
801054a7:	c3                   	ret    
801054a8:	90                   	nop
801054a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
801054b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
801054b5:	c9                   	leave  
801054b6:	c3                   	ret    
801054b7:	89 f6                	mov    %esi,%esi
801054b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054c0 <sys_getpid>:

int
sys_getpid(void)
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801054c6:	e8 75 e2 ff ff       	call   80103740 <myproc>
801054cb:	8b 40 10             	mov    0x10(%eax),%eax
}
801054ce:	c9                   	leave  
801054cf:	c3                   	ret    

801054d0 <sys_sbrk>:

int
sys_sbrk(void)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801054d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
801054d7:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801054da:	50                   	push   %eax
801054db:	6a 00                	push   $0x0
801054dd:	e8 ce f1 ff ff       	call   801046b0 <argint>
801054e2:	83 c4 10             	add    $0x10,%esp
801054e5:	85 c0                	test   %eax,%eax
801054e7:	78 27                	js     80105510 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801054e9:	e8 52 e2 ff ff       	call   80103740 <myproc>
  if(growproc(n) < 0)
801054ee:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
801054f1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801054f3:	ff 75 f4             	pushl  -0xc(%ebp)
801054f6:	e8 65 e3 ff ff       	call   80103860 <growproc>
801054fb:	83 c4 10             	add    $0x10,%esp
801054fe:	85 c0                	test   %eax,%eax
80105500:	78 0e                	js     80105510 <sys_sbrk+0x40>
    return -1;
  return addr;
80105502:	89 d8                	mov    %ebx,%eax
}
80105504:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105507:	c9                   	leave  
80105508:	c3                   	ret    
80105509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105510:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105515:	eb ed                	jmp    80105504 <sys_sbrk+0x34>
80105517:	89 f6                	mov    %esi,%esi
80105519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105520 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105520:	55                   	push   %ebp
80105521:	89 e5                	mov    %esp,%ebp
80105523:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105524:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80105527:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
8010552a:	50                   	push   %eax
8010552b:	6a 00                	push   $0x0
8010552d:	e8 7e f1 ff ff       	call   801046b0 <argint>
80105532:	83 c4 10             	add    $0x10,%esp
80105535:	85 c0                	test   %eax,%eax
80105537:	0f 88 8a 00 00 00    	js     801055c7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010553d:	83 ec 0c             	sub    $0xc,%esp
80105540:	68 60 4d 11 80       	push   $0x80114d60
80105545:	e8 16 ed ff ff       	call   80104260 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010554a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010554d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105550:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  while(ticks - ticks0 < n){
80105556:	85 d2                	test   %edx,%edx
80105558:	75 27                	jne    80105581 <sys_sleep+0x61>
8010555a:	eb 54                	jmp    801055b0 <sys_sleep+0x90>
8010555c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105560:	83 ec 08             	sub    $0x8,%esp
80105563:	68 60 4d 11 80       	push   $0x80114d60
80105568:	68 a0 55 11 80       	push   $0x801155a0
8010556d:	e8 7e e7 ff ff       	call   80103cf0 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105572:	a1 a0 55 11 80       	mov    0x801155a0,%eax
80105577:	83 c4 10             	add    $0x10,%esp
8010557a:	29 d8                	sub    %ebx,%eax
8010557c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010557f:	73 2f                	jae    801055b0 <sys_sleep+0x90>
    if(myproc()->killed){
80105581:	e8 ba e1 ff ff       	call   80103740 <myproc>
80105586:	8b 40 24             	mov    0x24(%eax),%eax
80105589:	85 c0                	test   %eax,%eax
8010558b:	74 d3                	je     80105560 <sys_sleep+0x40>
      release(&tickslock);
8010558d:	83 ec 0c             	sub    $0xc,%esp
80105590:	68 60 4d 11 80       	push   $0x80114d60
80105595:	e8 e6 ed ff ff       	call   80104380 <release>
      return -1;
8010559a:	83 c4 10             	add    $0x10,%esp
8010559d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
801055a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055a5:	c9                   	leave  
801055a6:	c3                   	ret    
801055a7:	89 f6                	mov    %esi,%esi
801055a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801055b0:	83 ec 0c             	sub    $0xc,%esp
801055b3:	68 60 4d 11 80       	push   $0x80114d60
801055b8:	e8 c3 ed ff ff       	call   80104380 <release>
  return 0;
801055bd:	83 c4 10             	add    $0x10,%esp
801055c0:	31 c0                	xor    %eax,%eax
}
801055c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055c5:	c9                   	leave  
801055c6:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
801055c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055cc:	eb d4                	jmp    801055a2 <sys_sleep+0x82>
801055ce:	66 90                	xchg   %ax,%ax

801055d0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	53                   	push   %ebx
801055d4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801055d7:	68 60 4d 11 80       	push   $0x80114d60
801055dc:	e8 7f ec ff ff       	call   80104260 <acquire>
  xticks = ticks;
801055e1:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  release(&tickslock);
801055e7:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801055ee:	e8 8d ed ff ff       	call   80104380 <release>
  return xticks;
}
801055f3:	89 d8                	mov    %ebx,%eax
801055f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055f8:	c9                   	leave  
801055f9:	c3                   	ret    

801055fa <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801055fa:	1e                   	push   %ds
  pushl %es
801055fb:	06                   	push   %es
  pushl %fs
801055fc:	0f a0                	push   %fs
  pushl %gs
801055fe:	0f a8                	push   %gs
  pushal
80105600:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105601:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105605:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105607:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105609:	54                   	push   %esp
  call trap
8010560a:	e8 e1 00 00 00       	call   801056f0 <trap>
  addl $4, %esp
8010560f:	83 c4 04             	add    $0x4,%esp

80105612 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105612:	61                   	popa   
  popl %gs
80105613:	0f a9                	pop    %gs
  popl %fs
80105615:	0f a1                	pop    %fs
  popl %es
80105617:	07                   	pop    %es
  popl %ds
80105618:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105619:	83 c4 08             	add    $0x8,%esp
  iret
8010561c:	cf                   	iret   
8010561d:	66 90                	xchg   %ax,%ax
8010561f:	90                   	nop

80105620 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105620:	31 c0                	xor    %eax,%eax
80105622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105628:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010562f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105634:	c6 04 c5 a4 4d 11 80 	movb   $0x0,-0x7feeb25c(,%eax,8)
8010563b:	00 
8010563c:	66 89 0c c5 a2 4d 11 	mov    %cx,-0x7feeb25e(,%eax,8)
80105643:	80 
80105644:	c6 04 c5 a5 4d 11 80 	movb   $0x8e,-0x7feeb25b(,%eax,8)
8010564b:	8e 
8010564c:	66 89 14 c5 a0 4d 11 	mov    %dx,-0x7feeb260(,%eax,8)
80105653:	80 
80105654:	c1 ea 10             	shr    $0x10,%edx
80105657:	66 89 14 c5 a6 4d 11 	mov    %dx,-0x7feeb25a(,%eax,8)
8010565e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010565f:	83 c0 01             	add    $0x1,%eax
80105662:	3d 00 01 00 00       	cmp    $0x100,%eax
80105667:	75 bf                	jne    80105628 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105669:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010566a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010566f:	89 e5                	mov    %esp,%ebp
80105671:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105674:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105679:	68 a1 77 10 80       	push   $0x801077a1
8010567e:	68 60 4d 11 80       	push   $0x80114d60
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105683:	66 89 15 a2 4f 11 80 	mov    %dx,0x80114fa2
8010568a:	c6 05 a4 4f 11 80 00 	movb   $0x0,0x80114fa4
80105691:	66 a3 a0 4f 11 80    	mov    %ax,0x80114fa0
80105697:	c1 e8 10             	shr    $0x10,%eax
8010569a:	c6 05 a5 4f 11 80 ef 	movb   $0xef,0x80114fa5
801056a1:	66 a3 a6 4f 11 80    	mov    %ax,0x80114fa6

  initlock(&tickslock, "time");
801056a7:	e8 b4 ea ff ff       	call   80104160 <initlock>
}
801056ac:	83 c4 10             	add    $0x10,%esp
801056af:	c9                   	leave  
801056b0:	c3                   	ret    
801056b1:	eb 0d                	jmp    801056c0 <idtinit>
801056b3:	90                   	nop
801056b4:	90                   	nop
801056b5:	90                   	nop
801056b6:	90                   	nop
801056b7:	90                   	nop
801056b8:	90                   	nop
801056b9:	90                   	nop
801056ba:	90                   	nop
801056bb:	90                   	nop
801056bc:	90                   	nop
801056bd:	90                   	nop
801056be:	90                   	nop
801056bf:	90                   	nop

801056c0 <idtinit>:

void
idtinit(void)
{
801056c0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801056c1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801056c6:	89 e5                	mov    %esp,%ebp
801056c8:	83 ec 10             	sub    $0x10,%esp
801056cb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801056cf:	b8 a0 4d 11 80       	mov    $0x80114da0,%eax
801056d4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801056d8:	c1 e8 10             	shr    $0x10,%eax
801056db:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801056df:	8d 45 fa             	lea    -0x6(%ebp),%eax
801056e2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801056e5:	c9                   	leave  
801056e6:	c3                   	ret    
801056e7:	89 f6                	mov    %esi,%esi
801056e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056f0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	57                   	push   %edi
801056f4:	56                   	push   %esi
801056f5:	53                   	push   %ebx
801056f6:	83 ec 1c             	sub    $0x1c,%esp
801056f9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801056fc:	8b 47 30             	mov    0x30(%edi),%eax
801056ff:	83 f8 40             	cmp    $0x40,%eax
80105702:	0f 84 88 01 00 00    	je     80105890 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105708:	83 e8 20             	sub    $0x20,%eax
8010570b:	83 f8 1f             	cmp    $0x1f,%eax
8010570e:	77 10                	ja     80105720 <trap+0x30>
80105710:	ff 24 85 48 78 10 80 	jmp    *-0x7fef87b8(,%eax,4)
80105717:	89 f6                	mov    %esi,%esi
80105719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105720:	e8 1b e0 ff ff       	call   80103740 <myproc>
80105725:	85 c0                	test   %eax,%eax
80105727:	0f 84 d7 01 00 00    	je     80105904 <trap+0x214>
8010572d:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105731:	0f 84 cd 01 00 00    	je     80105904 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105737:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010573a:	8b 57 38             	mov    0x38(%edi),%edx
8010573d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105740:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105743:	e8 d8 df ff ff       	call   80103720 <cpuid>
80105748:	8b 77 34             	mov    0x34(%edi),%esi
8010574b:	8b 5f 30             	mov    0x30(%edi),%ebx
8010574e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105751:	e8 ea df ff ff       	call   80103740 <myproc>
80105756:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105759:	e8 e2 df ff ff       	call   80103740 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010575e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105761:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105764:	51                   	push   %ecx
80105765:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105766:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105769:	ff 75 e4             	pushl  -0x1c(%ebp)
8010576c:	56                   	push   %esi
8010576d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010576e:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105771:	52                   	push   %edx
80105772:	ff 70 10             	pushl  0x10(%eax)
80105775:	68 04 78 10 80       	push   $0x80107804
8010577a:	e8 e1 ae ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010577f:	83 c4 20             	add    $0x20,%esp
80105782:	e8 b9 df ff ff       	call   80103740 <myproc>
80105787:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010578e:	66 90                	xchg   %ax,%ax
    }*/

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105790:	e8 ab df ff ff       	call   80103740 <myproc>
80105795:	85 c0                	test   %eax,%eax
80105797:	74 0c                	je     801057a5 <trap+0xb5>
80105799:	e8 a2 df ff ff       	call   80103740 <myproc>
8010579e:	8b 50 24             	mov    0x24(%eax),%edx
801057a1:	85 d2                	test   %edx,%edx
801057a3:	75 4b                	jne    801057f0 <trap+0x100>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801057a5:	e8 96 df ff ff       	call   80103740 <myproc>
801057aa:	85 c0                	test   %eax,%eax
801057ac:	74 0b                	je     801057b9 <trap+0xc9>
801057ae:	e8 8d df ff ff       	call   80103740 <myproc>
801057b3:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801057b7:	74 4f                	je     80105808 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801057b9:	e8 82 df ff ff       	call   80103740 <myproc>
801057be:	85 c0                	test   %eax,%eax
801057c0:	74 1d                	je     801057df <trap+0xef>
801057c2:	e8 79 df ff ff       	call   80103740 <myproc>
801057c7:	8b 40 24             	mov    0x24(%eax),%eax
801057ca:	85 c0                	test   %eax,%eax
801057cc:	74 11                	je     801057df <trap+0xef>
801057ce:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801057d2:	83 e0 03             	and    $0x3,%eax
801057d5:	66 83 f8 03          	cmp    $0x3,%ax
801057d9:	0f 84 da 00 00 00    	je     801058b9 <trap+0x1c9>
    exit();
}
801057df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801057e2:	5b                   	pop    %ebx
801057e3:	5e                   	pop    %esi
801057e4:	5f                   	pop    %edi
801057e5:	5d                   	pop    %ebp
801057e6:	c3                   	ret    
801057e7:	89 f6                	mov    %esi,%esi
801057e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    }*/

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801057f0:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801057f4:	83 e0 03             	and    $0x3,%eax
801057f7:	66 83 f8 03          	cmp    $0x3,%ax
801057fb:	75 a8                	jne    801057a5 <trap+0xb5>
    exit();
801057fd:	e8 6e e3 ff ff       	call   80103b70 <exit>
80105802:	eb a1                	jmp    801057a5 <trap+0xb5>
80105804:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105808:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
8010580c:	75 ab                	jne    801057b9 <trap+0xc9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
8010580e:	e8 8d e4 ff ff       	call   80103ca0 <yield>
80105813:	eb a4                	jmp    801057b9 <trap+0xc9>
80105815:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105818:	e8 03 df ff ff       	call   80103720 <cpuid>
8010581d:	85 c0                	test   %eax,%eax
8010581f:	0f 84 ab 00 00 00    	je     801058d0 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105825:	e8 a6 ce ff ff       	call   801026d0 <lapiceoi>
    break;
8010582a:	e9 61 ff ff ff       	jmp    80105790 <trap+0xa0>
8010582f:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105830:	e8 5b cd ff ff       	call   80102590 <kbdintr>
    lapiceoi();
80105835:	e8 96 ce ff ff       	call   801026d0 <lapiceoi>
    break;
8010583a:	e9 51 ff ff ff       	jmp    80105790 <trap+0xa0>
8010583f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105840:	e8 5b 02 00 00       	call   80105aa0 <uartintr>
    lapiceoi();
80105845:	e8 86 ce ff ff       	call   801026d0 <lapiceoi>
    break;
8010584a:	e9 41 ff ff ff       	jmp    80105790 <trap+0xa0>
8010584f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105850:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105854:	8b 77 38             	mov    0x38(%edi),%esi
80105857:	e8 c4 de ff ff       	call   80103720 <cpuid>
8010585c:	56                   	push   %esi
8010585d:	53                   	push   %ebx
8010585e:	50                   	push   %eax
8010585f:	68 ac 77 10 80       	push   $0x801077ac
80105864:	e8 f7 ad ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105869:	e8 62 ce ff ff       	call   801026d0 <lapiceoi>
    break;
8010586e:	83 c4 10             	add    $0x10,%esp
80105871:	e9 1a ff ff ff       	jmp    80105790 <trap+0xa0>
80105876:	8d 76 00             	lea    0x0(%esi),%esi
80105879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105880:	e8 8b c7 ff ff       	call   80102010 <ideintr>
80105885:	eb 9e                	jmp    80105825 <trap+0x135>
80105887:	89 f6                	mov    %esi,%esi
80105889:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80105890:	e8 ab de ff ff       	call   80103740 <myproc>
80105895:	8b 58 24             	mov    0x24(%eax),%ebx
80105898:	85 db                	test   %ebx,%ebx
8010589a:	75 2c                	jne    801058c8 <trap+0x1d8>
      exit();
    myproc()->tf = tf;
8010589c:	e8 9f de ff ff       	call   80103740 <myproc>
801058a1:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
801058a4:	e8 c7 ee ff ff       	call   80104770 <syscall>
    if(myproc()->killed)
801058a9:	e8 92 de ff ff       	call   80103740 <myproc>
801058ae:	8b 48 24             	mov    0x24(%eax),%ecx
801058b1:	85 c9                	test   %ecx,%ecx
801058b3:	0f 84 26 ff ff ff    	je     801057df <trap+0xef>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801058b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058bc:	5b                   	pop    %ebx
801058bd:	5e                   	pop    %esi
801058be:	5f                   	pop    %edi
801058bf:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
801058c0:	e9 ab e2 ff ff       	jmp    80103b70 <exit>
801058c5:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
801058c8:	e8 a3 e2 ff ff       	call   80103b70 <exit>
801058cd:	eb cd                	jmp    8010589c <trap+0x1ac>
801058cf:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
801058d0:	83 ec 0c             	sub    $0xc,%esp
801058d3:	68 60 4d 11 80       	push   $0x80114d60
801058d8:	e8 83 e9 ff ff       	call   80104260 <acquire>
      ticks++;
      wakeup(&ticks);
801058dd:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
801058e4:	83 05 a0 55 11 80 01 	addl   $0x1,0x801155a0
      wakeup(&ticks);
801058eb:	e8 b0 e5 ff ff       	call   80103ea0 <wakeup>
      release(&tickslock);
801058f0:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801058f7:	e8 84 ea ff ff       	call   80104380 <release>
801058fc:	83 c4 10             	add    $0x10,%esp
801058ff:	e9 21 ff ff ff       	jmp    80105825 <trap+0x135>
80105904:	0f 20 d6             	mov    %cr2,%esi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105907:	8b 5f 38             	mov    0x38(%edi),%ebx
8010590a:	e8 11 de ff ff       	call   80103720 <cpuid>
8010590f:	83 ec 0c             	sub    $0xc,%esp
80105912:	56                   	push   %esi
80105913:	53                   	push   %ebx
80105914:	50                   	push   %eax
80105915:	ff 77 30             	pushl  0x30(%edi)
80105918:	68 d0 77 10 80       	push   $0x801077d0
8010591d:	e8 3e ad ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80105922:	83 c4 14             	add    $0x14,%esp
80105925:	68 a6 77 10 80       	push   $0x801077a6
8010592a:	e8 41 aa ff ff       	call   80100370 <panic>
8010592f:	90                   	nop

80105930 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105930:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105935:	55                   	push   %ebp
80105936:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105938:	85 c0                	test   %eax,%eax
8010593a:	74 1c                	je     80105958 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010593c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105941:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105942:	a8 01                	test   $0x1,%al
80105944:	74 12                	je     80105958 <uartgetc+0x28>
80105946:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010594b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010594c:	0f b6 c0             	movzbl %al,%eax
}
8010594f:	5d                   	pop    %ebp
80105950:	c3                   	ret    
80105951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105958:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
8010595d:	5d                   	pop    %ebp
8010595e:	c3                   	ret    
8010595f:	90                   	nop

80105960 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	57                   	push   %edi
80105964:	56                   	push   %esi
80105965:	53                   	push   %ebx
80105966:	89 c7                	mov    %eax,%edi
80105968:	bb 80 00 00 00       	mov    $0x80,%ebx
8010596d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105972:	83 ec 0c             	sub    $0xc,%esp
80105975:	eb 1b                	jmp    80105992 <uartputc.part.0+0x32>
80105977:	89 f6                	mov    %esi,%esi
80105979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105980:	83 ec 0c             	sub    $0xc,%esp
80105983:	6a 0a                	push   $0xa
80105985:	e8 66 cd ff ff       	call   801026f0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010598a:	83 c4 10             	add    $0x10,%esp
8010598d:	83 eb 01             	sub    $0x1,%ebx
80105990:	74 07                	je     80105999 <uartputc.part.0+0x39>
80105992:	89 f2                	mov    %esi,%edx
80105994:	ec                   	in     (%dx),%al
80105995:	a8 20                	test   $0x20,%al
80105997:	74 e7                	je     80105980 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105999:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010599e:	89 f8                	mov    %edi,%eax
801059a0:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
801059a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059a4:	5b                   	pop    %ebx
801059a5:	5e                   	pop    %esi
801059a6:	5f                   	pop    %edi
801059a7:	5d                   	pop    %ebp
801059a8:	c3                   	ret    
801059a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059b0 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
801059b0:	55                   	push   %ebp
801059b1:	31 c9                	xor    %ecx,%ecx
801059b3:	89 c8                	mov    %ecx,%eax
801059b5:	89 e5                	mov    %esp,%ebp
801059b7:	57                   	push   %edi
801059b8:	56                   	push   %esi
801059b9:	53                   	push   %ebx
801059ba:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801059bf:	89 da                	mov    %ebx,%edx
801059c1:	83 ec 0c             	sub    $0xc,%esp
801059c4:	ee                   	out    %al,(%dx)
801059c5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801059ca:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801059cf:	89 fa                	mov    %edi,%edx
801059d1:	ee                   	out    %al,(%dx)
801059d2:	b8 0c 00 00 00       	mov    $0xc,%eax
801059d7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801059dc:	ee                   	out    %al,(%dx)
801059dd:	be f9 03 00 00       	mov    $0x3f9,%esi
801059e2:	89 c8                	mov    %ecx,%eax
801059e4:	89 f2                	mov    %esi,%edx
801059e6:	ee                   	out    %al,(%dx)
801059e7:	b8 03 00 00 00       	mov    $0x3,%eax
801059ec:	89 fa                	mov    %edi,%edx
801059ee:	ee                   	out    %al,(%dx)
801059ef:	ba fc 03 00 00       	mov    $0x3fc,%edx
801059f4:	89 c8                	mov    %ecx,%eax
801059f6:	ee                   	out    %al,(%dx)
801059f7:	b8 01 00 00 00       	mov    $0x1,%eax
801059fc:	89 f2                	mov    %esi,%edx
801059fe:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801059ff:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105a04:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105a05:	3c ff                	cmp    $0xff,%al
80105a07:	74 5a                	je     80105a63 <uartinit+0xb3>
    return;
  uart = 1;
80105a09:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105a10:	00 00 00 
80105a13:	89 da                	mov    %ebx,%edx
80105a15:	ec                   	in     (%dx),%al
80105a16:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a1b:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105a1c:	83 ec 08             	sub    $0x8,%esp
80105a1f:	bb c8 78 10 80       	mov    $0x801078c8,%ebx
80105a24:	6a 00                	push   $0x0
80105a26:	6a 04                	push   $0x4
80105a28:	e8 33 c8 ff ff       	call   80102260 <ioapicenable>
80105a2d:	83 c4 10             	add    $0x10,%esp
80105a30:	b8 78 00 00 00       	mov    $0x78,%eax
80105a35:	eb 13                	jmp    80105a4a <uartinit+0x9a>
80105a37:	89 f6                	mov    %esi,%esi
80105a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105a40:	83 c3 01             	add    $0x1,%ebx
80105a43:	0f be 03             	movsbl (%ebx),%eax
80105a46:	84 c0                	test   %al,%al
80105a48:	74 19                	je     80105a63 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
80105a4a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105a50:	85 d2                	test   %edx,%edx
80105a52:	74 ec                	je     80105a40 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105a54:	83 c3 01             	add    $0x1,%ebx
80105a57:	e8 04 ff ff ff       	call   80105960 <uartputc.part.0>
80105a5c:	0f be 03             	movsbl (%ebx),%eax
80105a5f:	84 c0                	test   %al,%al
80105a61:	75 e7                	jne    80105a4a <uartinit+0x9a>
    uartputc(*p);
}
80105a63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a66:	5b                   	pop    %ebx
80105a67:	5e                   	pop    %esi
80105a68:	5f                   	pop    %edi
80105a69:	5d                   	pop    %ebp
80105a6a:	c3                   	ret    
80105a6b:	90                   	nop
80105a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a70 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105a70:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105a76:	55                   	push   %ebp
80105a77:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80105a79:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
80105a7e:	74 10                	je     80105a90 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80105a80:	5d                   	pop    %ebp
80105a81:	e9 da fe ff ff       	jmp    80105960 <uartputc.part.0>
80105a86:	8d 76 00             	lea    0x0(%esi),%esi
80105a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105a90:	5d                   	pop    %ebp
80105a91:	c3                   	ret    
80105a92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105aa0 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
80105aa3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105aa6:	68 30 59 10 80       	push   $0x80105930
80105aab:	e8 40 ad ff ff       	call   801007f0 <consoleintr>
}
80105ab0:	83 c4 10             	add    $0x10,%esp
80105ab3:	c9                   	leave  
80105ab4:	c3                   	ret    

80105ab5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105ab5:	6a 00                	push   $0x0
  pushl $0
80105ab7:	6a 00                	push   $0x0
  jmp alltraps
80105ab9:	e9 3c fb ff ff       	jmp    801055fa <alltraps>

80105abe <vector1>:
.globl vector1
vector1:
  pushl $0
80105abe:	6a 00                	push   $0x0
  pushl $1
80105ac0:	6a 01                	push   $0x1
  jmp alltraps
80105ac2:	e9 33 fb ff ff       	jmp    801055fa <alltraps>

80105ac7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105ac7:	6a 00                	push   $0x0
  pushl $2
80105ac9:	6a 02                	push   $0x2
  jmp alltraps
80105acb:	e9 2a fb ff ff       	jmp    801055fa <alltraps>

80105ad0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105ad0:	6a 00                	push   $0x0
  pushl $3
80105ad2:	6a 03                	push   $0x3
  jmp alltraps
80105ad4:	e9 21 fb ff ff       	jmp    801055fa <alltraps>

80105ad9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105ad9:	6a 00                	push   $0x0
  pushl $4
80105adb:	6a 04                	push   $0x4
  jmp alltraps
80105add:	e9 18 fb ff ff       	jmp    801055fa <alltraps>

80105ae2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105ae2:	6a 00                	push   $0x0
  pushl $5
80105ae4:	6a 05                	push   $0x5
  jmp alltraps
80105ae6:	e9 0f fb ff ff       	jmp    801055fa <alltraps>

80105aeb <vector6>:
.globl vector6
vector6:
  pushl $0
80105aeb:	6a 00                	push   $0x0
  pushl $6
80105aed:	6a 06                	push   $0x6
  jmp alltraps
80105aef:	e9 06 fb ff ff       	jmp    801055fa <alltraps>

80105af4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105af4:	6a 00                	push   $0x0
  pushl $7
80105af6:	6a 07                	push   $0x7
  jmp alltraps
80105af8:	e9 fd fa ff ff       	jmp    801055fa <alltraps>

80105afd <vector8>:
.globl vector8
vector8:
  pushl $8
80105afd:	6a 08                	push   $0x8
  jmp alltraps
80105aff:	e9 f6 fa ff ff       	jmp    801055fa <alltraps>

80105b04 <vector9>:
.globl vector9
vector9:
  pushl $0
80105b04:	6a 00                	push   $0x0
  pushl $9
80105b06:	6a 09                	push   $0x9
  jmp alltraps
80105b08:	e9 ed fa ff ff       	jmp    801055fa <alltraps>

80105b0d <vector10>:
.globl vector10
vector10:
  pushl $10
80105b0d:	6a 0a                	push   $0xa
  jmp alltraps
80105b0f:	e9 e6 fa ff ff       	jmp    801055fa <alltraps>

80105b14 <vector11>:
.globl vector11
vector11:
  pushl $11
80105b14:	6a 0b                	push   $0xb
  jmp alltraps
80105b16:	e9 df fa ff ff       	jmp    801055fa <alltraps>

80105b1b <vector12>:
.globl vector12
vector12:
  pushl $12
80105b1b:	6a 0c                	push   $0xc
  jmp alltraps
80105b1d:	e9 d8 fa ff ff       	jmp    801055fa <alltraps>

80105b22 <vector13>:
.globl vector13
vector13:
  pushl $13
80105b22:	6a 0d                	push   $0xd
  jmp alltraps
80105b24:	e9 d1 fa ff ff       	jmp    801055fa <alltraps>

80105b29 <vector14>:
.globl vector14
vector14:
  pushl $14
80105b29:	6a 0e                	push   $0xe
  jmp alltraps
80105b2b:	e9 ca fa ff ff       	jmp    801055fa <alltraps>

80105b30 <vector15>:
.globl vector15
vector15:
  pushl $0
80105b30:	6a 00                	push   $0x0
  pushl $15
80105b32:	6a 0f                	push   $0xf
  jmp alltraps
80105b34:	e9 c1 fa ff ff       	jmp    801055fa <alltraps>

80105b39 <vector16>:
.globl vector16
vector16:
  pushl $0
80105b39:	6a 00                	push   $0x0
  pushl $16
80105b3b:	6a 10                	push   $0x10
  jmp alltraps
80105b3d:	e9 b8 fa ff ff       	jmp    801055fa <alltraps>

80105b42 <vector17>:
.globl vector17
vector17:
  pushl $17
80105b42:	6a 11                	push   $0x11
  jmp alltraps
80105b44:	e9 b1 fa ff ff       	jmp    801055fa <alltraps>

80105b49 <vector18>:
.globl vector18
vector18:
  pushl $0
80105b49:	6a 00                	push   $0x0
  pushl $18
80105b4b:	6a 12                	push   $0x12
  jmp alltraps
80105b4d:	e9 a8 fa ff ff       	jmp    801055fa <alltraps>

80105b52 <vector19>:
.globl vector19
vector19:
  pushl $0
80105b52:	6a 00                	push   $0x0
  pushl $19
80105b54:	6a 13                	push   $0x13
  jmp alltraps
80105b56:	e9 9f fa ff ff       	jmp    801055fa <alltraps>

80105b5b <vector20>:
.globl vector20
vector20:
  pushl $0
80105b5b:	6a 00                	push   $0x0
  pushl $20
80105b5d:	6a 14                	push   $0x14
  jmp alltraps
80105b5f:	e9 96 fa ff ff       	jmp    801055fa <alltraps>

80105b64 <vector21>:
.globl vector21
vector21:
  pushl $0
80105b64:	6a 00                	push   $0x0
  pushl $21
80105b66:	6a 15                	push   $0x15
  jmp alltraps
80105b68:	e9 8d fa ff ff       	jmp    801055fa <alltraps>

80105b6d <vector22>:
.globl vector22
vector22:
  pushl $0
80105b6d:	6a 00                	push   $0x0
  pushl $22
80105b6f:	6a 16                	push   $0x16
  jmp alltraps
80105b71:	e9 84 fa ff ff       	jmp    801055fa <alltraps>

80105b76 <vector23>:
.globl vector23
vector23:
  pushl $0
80105b76:	6a 00                	push   $0x0
  pushl $23
80105b78:	6a 17                	push   $0x17
  jmp alltraps
80105b7a:	e9 7b fa ff ff       	jmp    801055fa <alltraps>

80105b7f <vector24>:
.globl vector24
vector24:
  pushl $0
80105b7f:	6a 00                	push   $0x0
  pushl $24
80105b81:	6a 18                	push   $0x18
  jmp alltraps
80105b83:	e9 72 fa ff ff       	jmp    801055fa <alltraps>

80105b88 <vector25>:
.globl vector25
vector25:
  pushl $0
80105b88:	6a 00                	push   $0x0
  pushl $25
80105b8a:	6a 19                	push   $0x19
  jmp alltraps
80105b8c:	e9 69 fa ff ff       	jmp    801055fa <alltraps>

80105b91 <vector26>:
.globl vector26
vector26:
  pushl $0
80105b91:	6a 00                	push   $0x0
  pushl $26
80105b93:	6a 1a                	push   $0x1a
  jmp alltraps
80105b95:	e9 60 fa ff ff       	jmp    801055fa <alltraps>

80105b9a <vector27>:
.globl vector27
vector27:
  pushl $0
80105b9a:	6a 00                	push   $0x0
  pushl $27
80105b9c:	6a 1b                	push   $0x1b
  jmp alltraps
80105b9e:	e9 57 fa ff ff       	jmp    801055fa <alltraps>

80105ba3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105ba3:	6a 00                	push   $0x0
  pushl $28
80105ba5:	6a 1c                	push   $0x1c
  jmp alltraps
80105ba7:	e9 4e fa ff ff       	jmp    801055fa <alltraps>

80105bac <vector29>:
.globl vector29
vector29:
  pushl $0
80105bac:	6a 00                	push   $0x0
  pushl $29
80105bae:	6a 1d                	push   $0x1d
  jmp alltraps
80105bb0:	e9 45 fa ff ff       	jmp    801055fa <alltraps>

80105bb5 <vector30>:
.globl vector30
vector30:
  pushl $0
80105bb5:	6a 00                	push   $0x0
  pushl $30
80105bb7:	6a 1e                	push   $0x1e
  jmp alltraps
80105bb9:	e9 3c fa ff ff       	jmp    801055fa <alltraps>

80105bbe <vector31>:
.globl vector31
vector31:
  pushl $0
80105bbe:	6a 00                	push   $0x0
  pushl $31
80105bc0:	6a 1f                	push   $0x1f
  jmp alltraps
80105bc2:	e9 33 fa ff ff       	jmp    801055fa <alltraps>

80105bc7 <vector32>:
.globl vector32
vector32:
  pushl $0
80105bc7:	6a 00                	push   $0x0
  pushl $32
80105bc9:	6a 20                	push   $0x20
  jmp alltraps
80105bcb:	e9 2a fa ff ff       	jmp    801055fa <alltraps>

80105bd0 <vector33>:
.globl vector33
vector33:
  pushl $0
80105bd0:	6a 00                	push   $0x0
  pushl $33
80105bd2:	6a 21                	push   $0x21
  jmp alltraps
80105bd4:	e9 21 fa ff ff       	jmp    801055fa <alltraps>

80105bd9 <vector34>:
.globl vector34
vector34:
  pushl $0
80105bd9:	6a 00                	push   $0x0
  pushl $34
80105bdb:	6a 22                	push   $0x22
  jmp alltraps
80105bdd:	e9 18 fa ff ff       	jmp    801055fa <alltraps>

80105be2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105be2:	6a 00                	push   $0x0
  pushl $35
80105be4:	6a 23                	push   $0x23
  jmp alltraps
80105be6:	e9 0f fa ff ff       	jmp    801055fa <alltraps>

80105beb <vector36>:
.globl vector36
vector36:
  pushl $0
80105beb:	6a 00                	push   $0x0
  pushl $36
80105bed:	6a 24                	push   $0x24
  jmp alltraps
80105bef:	e9 06 fa ff ff       	jmp    801055fa <alltraps>

80105bf4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105bf4:	6a 00                	push   $0x0
  pushl $37
80105bf6:	6a 25                	push   $0x25
  jmp alltraps
80105bf8:	e9 fd f9 ff ff       	jmp    801055fa <alltraps>

80105bfd <vector38>:
.globl vector38
vector38:
  pushl $0
80105bfd:	6a 00                	push   $0x0
  pushl $38
80105bff:	6a 26                	push   $0x26
  jmp alltraps
80105c01:	e9 f4 f9 ff ff       	jmp    801055fa <alltraps>

80105c06 <vector39>:
.globl vector39
vector39:
  pushl $0
80105c06:	6a 00                	push   $0x0
  pushl $39
80105c08:	6a 27                	push   $0x27
  jmp alltraps
80105c0a:	e9 eb f9 ff ff       	jmp    801055fa <alltraps>

80105c0f <vector40>:
.globl vector40
vector40:
  pushl $0
80105c0f:	6a 00                	push   $0x0
  pushl $40
80105c11:	6a 28                	push   $0x28
  jmp alltraps
80105c13:	e9 e2 f9 ff ff       	jmp    801055fa <alltraps>

80105c18 <vector41>:
.globl vector41
vector41:
  pushl $0
80105c18:	6a 00                	push   $0x0
  pushl $41
80105c1a:	6a 29                	push   $0x29
  jmp alltraps
80105c1c:	e9 d9 f9 ff ff       	jmp    801055fa <alltraps>

80105c21 <vector42>:
.globl vector42
vector42:
  pushl $0
80105c21:	6a 00                	push   $0x0
  pushl $42
80105c23:	6a 2a                	push   $0x2a
  jmp alltraps
80105c25:	e9 d0 f9 ff ff       	jmp    801055fa <alltraps>

80105c2a <vector43>:
.globl vector43
vector43:
  pushl $0
80105c2a:	6a 00                	push   $0x0
  pushl $43
80105c2c:	6a 2b                	push   $0x2b
  jmp alltraps
80105c2e:	e9 c7 f9 ff ff       	jmp    801055fa <alltraps>

80105c33 <vector44>:
.globl vector44
vector44:
  pushl $0
80105c33:	6a 00                	push   $0x0
  pushl $44
80105c35:	6a 2c                	push   $0x2c
  jmp alltraps
80105c37:	e9 be f9 ff ff       	jmp    801055fa <alltraps>

80105c3c <vector45>:
.globl vector45
vector45:
  pushl $0
80105c3c:	6a 00                	push   $0x0
  pushl $45
80105c3e:	6a 2d                	push   $0x2d
  jmp alltraps
80105c40:	e9 b5 f9 ff ff       	jmp    801055fa <alltraps>

80105c45 <vector46>:
.globl vector46
vector46:
  pushl $0
80105c45:	6a 00                	push   $0x0
  pushl $46
80105c47:	6a 2e                	push   $0x2e
  jmp alltraps
80105c49:	e9 ac f9 ff ff       	jmp    801055fa <alltraps>

80105c4e <vector47>:
.globl vector47
vector47:
  pushl $0
80105c4e:	6a 00                	push   $0x0
  pushl $47
80105c50:	6a 2f                	push   $0x2f
  jmp alltraps
80105c52:	e9 a3 f9 ff ff       	jmp    801055fa <alltraps>

80105c57 <vector48>:
.globl vector48
vector48:
  pushl $0
80105c57:	6a 00                	push   $0x0
  pushl $48
80105c59:	6a 30                	push   $0x30
  jmp alltraps
80105c5b:	e9 9a f9 ff ff       	jmp    801055fa <alltraps>

80105c60 <vector49>:
.globl vector49
vector49:
  pushl $0
80105c60:	6a 00                	push   $0x0
  pushl $49
80105c62:	6a 31                	push   $0x31
  jmp alltraps
80105c64:	e9 91 f9 ff ff       	jmp    801055fa <alltraps>

80105c69 <vector50>:
.globl vector50
vector50:
  pushl $0
80105c69:	6a 00                	push   $0x0
  pushl $50
80105c6b:	6a 32                	push   $0x32
  jmp alltraps
80105c6d:	e9 88 f9 ff ff       	jmp    801055fa <alltraps>

80105c72 <vector51>:
.globl vector51
vector51:
  pushl $0
80105c72:	6a 00                	push   $0x0
  pushl $51
80105c74:	6a 33                	push   $0x33
  jmp alltraps
80105c76:	e9 7f f9 ff ff       	jmp    801055fa <alltraps>

80105c7b <vector52>:
.globl vector52
vector52:
  pushl $0
80105c7b:	6a 00                	push   $0x0
  pushl $52
80105c7d:	6a 34                	push   $0x34
  jmp alltraps
80105c7f:	e9 76 f9 ff ff       	jmp    801055fa <alltraps>

80105c84 <vector53>:
.globl vector53
vector53:
  pushl $0
80105c84:	6a 00                	push   $0x0
  pushl $53
80105c86:	6a 35                	push   $0x35
  jmp alltraps
80105c88:	e9 6d f9 ff ff       	jmp    801055fa <alltraps>

80105c8d <vector54>:
.globl vector54
vector54:
  pushl $0
80105c8d:	6a 00                	push   $0x0
  pushl $54
80105c8f:	6a 36                	push   $0x36
  jmp alltraps
80105c91:	e9 64 f9 ff ff       	jmp    801055fa <alltraps>

80105c96 <vector55>:
.globl vector55
vector55:
  pushl $0
80105c96:	6a 00                	push   $0x0
  pushl $55
80105c98:	6a 37                	push   $0x37
  jmp alltraps
80105c9a:	e9 5b f9 ff ff       	jmp    801055fa <alltraps>

80105c9f <vector56>:
.globl vector56
vector56:
  pushl $0
80105c9f:	6a 00                	push   $0x0
  pushl $56
80105ca1:	6a 38                	push   $0x38
  jmp alltraps
80105ca3:	e9 52 f9 ff ff       	jmp    801055fa <alltraps>

80105ca8 <vector57>:
.globl vector57
vector57:
  pushl $0
80105ca8:	6a 00                	push   $0x0
  pushl $57
80105caa:	6a 39                	push   $0x39
  jmp alltraps
80105cac:	e9 49 f9 ff ff       	jmp    801055fa <alltraps>

80105cb1 <vector58>:
.globl vector58
vector58:
  pushl $0
80105cb1:	6a 00                	push   $0x0
  pushl $58
80105cb3:	6a 3a                	push   $0x3a
  jmp alltraps
80105cb5:	e9 40 f9 ff ff       	jmp    801055fa <alltraps>

80105cba <vector59>:
.globl vector59
vector59:
  pushl $0
80105cba:	6a 00                	push   $0x0
  pushl $59
80105cbc:	6a 3b                	push   $0x3b
  jmp alltraps
80105cbe:	e9 37 f9 ff ff       	jmp    801055fa <alltraps>

80105cc3 <vector60>:
.globl vector60
vector60:
  pushl $0
80105cc3:	6a 00                	push   $0x0
  pushl $60
80105cc5:	6a 3c                	push   $0x3c
  jmp alltraps
80105cc7:	e9 2e f9 ff ff       	jmp    801055fa <alltraps>

80105ccc <vector61>:
.globl vector61
vector61:
  pushl $0
80105ccc:	6a 00                	push   $0x0
  pushl $61
80105cce:	6a 3d                	push   $0x3d
  jmp alltraps
80105cd0:	e9 25 f9 ff ff       	jmp    801055fa <alltraps>

80105cd5 <vector62>:
.globl vector62
vector62:
  pushl $0
80105cd5:	6a 00                	push   $0x0
  pushl $62
80105cd7:	6a 3e                	push   $0x3e
  jmp alltraps
80105cd9:	e9 1c f9 ff ff       	jmp    801055fa <alltraps>

80105cde <vector63>:
.globl vector63
vector63:
  pushl $0
80105cde:	6a 00                	push   $0x0
  pushl $63
80105ce0:	6a 3f                	push   $0x3f
  jmp alltraps
80105ce2:	e9 13 f9 ff ff       	jmp    801055fa <alltraps>

80105ce7 <vector64>:
.globl vector64
vector64:
  pushl $0
80105ce7:	6a 00                	push   $0x0
  pushl $64
80105ce9:	6a 40                	push   $0x40
  jmp alltraps
80105ceb:	e9 0a f9 ff ff       	jmp    801055fa <alltraps>

80105cf0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105cf0:	6a 00                	push   $0x0
  pushl $65
80105cf2:	6a 41                	push   $0x41
  jmp alltraps
80105cf4:	e9 01 f9 ff ff       	jmp    801055fa <alltraps>

80105cf9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105cf9:	6a 00                	push   $0x0
  pushl $66
80105cfb:	6a 42                	push   $0x42
  jmp alltraps
80105cfd:	e9 f8 f8 ff ff       	jmp    801055fa <alltraps>

80105d02 <vector67>:
.globl vector67
vector67:
  pushl $0
80105d02:	6a 00                	push   $0x0
  pushl $67
80105d04:	6a 43                	push   $0x43
  jmp alltraps
80105d06:	e9 ef f8 ff ff       	jmp    801055fa <alltraps>

80105d0b <vector68>:
.globl vector68
vector68:
  pushl $0
80105d0b:	6a 00                	push   $0x0
  pushl $68
80105d0d:	6a 44                	push   $0x44
  jmp alltraps
80105d0f:	e9 e6 f8 ff ff       	jmp    801055fa <alltraps>

80105d14 <vector69>:
.globl vector69
vector69:
  pushl $0
80105d14:	6a 00                	push   $0x0
  pushl $69
80105d16:	6a 45                	push   $0x45
  jmp alltraps
80105d18:	e9 dd f8 ff ff       	jmp    801055fa <alltraps>

80105d1d <vector70>:
.globl vector70
vector70:
  pushl $0
80105d1d:	6a 00                	push   $0x0
  pushl $70
80105d1f:	6a 46                	push   $0x46
  jmp alltraps
80105d21:	e9 d4 f8 ff ff       	jmp    801055fa <alltraps>

80105d26 <vector71>:
.globl vector71
vector71:
  pushl $0
80105d26:	6a 00                	push   $0x0
  pushl $71
80105d28:	6a 47                	push   $0x47
  jmp alltraps
80105d2a:	e9 cb f8 ff ff       	jmp    801055fa <alltraps>

80105d2f <vector72>:
.globl vector72
vector72:
  pushl $0
80105d2f:	6a 00                	push   $0x0
  pushl $72
80105d31:	6a 48                	push   $0x48
  jmp alltraps
80105d33:	e9 c2 f8 ff ff       	jmp    801055fa <alltraps>

80105d38 <vector73>:
.globl vector73
vector73:
  pushl $0
80105d38:	6a 00                	push   $0x0
  pushl $73
80105d3a:	6a 49                	push   $0x49
  jmp alltraps
80105d3c:	e9 b9 f8 ff ff       	jmp    801055fa <alltraps>

80105d41 <vector74>:
.globl vector74
vector74:
  pushl $0
80105d41:	6a 00                	push   $0x0
  pushl $74
80105d43:	6a 4a                	push   $0x4a
  jmp alltraps
80105d45:	e9 b0 f8 ff ff       	jmp    801055fa <alltraps>

80105d4a <vector75>:
.globl vector75
vector75:
  pushl $0
80105d4a:	6a 00                	push   $0x0
  pushl $75
80105d4c:	6a 4b                	push   $0x4b
  jmp alltraps
80105d4e:	e9 a7 f8 ff ff       	jmp    801055fa <alltraps>

80105d53 <vector76>:
.globl vector76
vector76:
  pushl $0
80105d53:	6a 00                	push   $0x0
  pushl $76
80105d55:	6a 4c                	push   $0x4c
  jmp alltraps
80105d57:	e9 9e f8 ff ff       	jmp    801055fa <alltraps>

80105d5c <vector77>:
.globl vector77
vector77:
  pushl $0
80105d5c:	6a 00                	push   $0x0
  pushl $77
80105d5e:	6a 4d                	push   $0x4d
  jmp alltraps
80105d60:	e9 95 f8 ff ff       	jmp    801055fa <alltraps>

80105d65 <vector78>:
.globl vector78
vector78:
  pushl $0
80105d65:	6a 00                	push   $0x0
  pushl $78
80105d67:	6a 4e                	push   $0x4e
  jmp alltraps
80105d69:	e9 8c f8 ff ff       	jmp    801055fa <alltraps>

80105d6e <vector79>:
.globl vector79
vector79:
  pushl $0
80105d6e:	6a 00                	push   $0x0
  pushl $79
80105d70:	6a 4f                	push   $0x4f
  jmp alltraps
80105d72:	e9 83 f8 ff ff       	jmp    801055fa <alltraps>

80105d77 <vector80>:
.globl vector80
vector80:
  pushl $0
80105d77:	6a 00                	push   $0x0
  pushl $80
80105d79:	6a 50                	push   $0x50
  jmp alltraps
80105d7b:	e9 7a f8 ff ff       	jmp    801055fa <alltraps>

80105d80 <vector81>:
.globl vector81
vector81:
  pushl $0
80105d80:	6a 00                	push   $0x0
  pushl $81
80105d82:	6a 51                	push   $0x51
  jmp alltraps
80105d84:	e9 71 f8 ff ff       	jmp    801055fa <alltraps>

80105d89 <vector82>:
.globl vector82
vector82:
  pushl $0
80105d89:	6a 00                	push   $0x0
  pushl $82
80105d8b:	6a 52                	push   $0x52
  jmp alltraps
80105d8d:	e9 68 f8 ff ff       	jmp    801055fa <alltraps>

80105d92 <vector83>:
.globl vector83
vector83:
  pushl $0
80105d92:	6a 00                	push   $0x0
  pushl $83
80105d94:	6a 53                	push   $0x53
  jmp alltraps
80105d96:	e9 5f f8 ff ff       	jmp    801055fa <alltraps>

80105d9b <vector84>:
.globl vector84
vector84:
  pushl $0
80105d9b:	6a 00                	push   $0x0
  pushl $84
80105d9d:	6a 54                	push   $0x54
  jmp alltraps
80105d9f:	e9 56 f8 ff ff       	jmp    801055fa <alltraps>

80105da4 <vector85>:
.globl vector85
vector85:
  pushl $0
80105da4:	6a 00                	push   $0x0
  pushl $85
80105da6:	6a 55                	push   $0x55
  jmp alltraps
80105da8:	e9 4d f8 ff ff       	jmp    801055fa <alltraps>

80105dad <vector86>:
.globl vector86
vector86:
  pushl $0
80105dad:	6a 00                	push   $0x0
  pushl $86
80105daf:	6a 56                	push   $0x56
  jmp alltraps
80105db1:	e9 44 f8 ff ff       	jmp    801055fa <alltraps>

80105db6 <vector87>:
.globl vector87
vector87:
  pushl $0
80105db6:	6a 00                	push   $0x0
  pushl $87
80105db8:	6a 57                	push   $0x57
  jmp alltraps
80105dba:	e9 3b f8 ff ff       	jmp    801055fa <alltraps>

80105dbf <vector88>:
.globl vector88
vector88:
  pushl $0
80105dbf:	6a 00                	push   $0x0
  pushl $88
80105dc1:	6a 58                	push   $0x58
  jmp alltraps
80105dc3:	e9 32 f8 ff ff       	jmp    801055fa <alltraps>

80105dc8 <vector89>:
.globl vector89
vector89:
  pushl $0
80105dc8:	6a 00                	push   $0x0
  pushl $89
80105dca:	6a 59                	push   $0x59
  jmp alltraps
80105dcc:	e9 29 f8 ff ff       	jmp    801055fa <alltraps>

80105dd1 <vector90>:
.globl vector90
vector90:
  pushl $0
80105dd1:	6a 00                	push   $0x0
  pushl $90
80105dd3:	6a 5a                	push   $0x5a
  jmp alltraps
80105dd5:	e9 20 f8 ff ff       	jmp    801055fa <alltraps>

80105dda <vector91>:
.globl vector91
vector91:
  pushl $0
80105dda:	6a 00                	push   $0x0
  pushl $91
80105ddc:	6a 5b                	push   $0x5b
  jmp alltraps
80105dde:	e9 17 f8 ff ff       	jmp    801055fa <alltraps>

80105de3 <vector92>:
.globl vector92
vector92:
  pushl $0
80105de3:	6a 00                	push   $0x0
  pushl $92
80105de5:	6a 5c                	push   $0x5c
  jmp alltraps
80105de7:	e9 0e f8 ff ff       	jmp    801055fa <alltraps>

80105dec <vector93>:
.globl vector93
vector93:
  pushl $0
80105dec:	6a 00                	push   $0x0
  pushl $93
80105dee:	6a 5d                	push   $0x5d
  jmp alltraps
80105df0:	e9 05 f8 ff ff       	jmp    801055fa <alltraps>

80105df5 <vector94>:
.globl vector94
vector94:
  pushl $0
80105df5:	6a 00                	push   $0x0
  pushl $94
80105df7:	6a 5e                	push   $0x5e
  jmp alltraps
80105df9:	e9 fc f7 ff ff       	jmp    801055fa <alltraps>

80105dfe <vector95>:
.globl vector95
vector95:
  pushl $0
80105dfe:	6a 00                	push   $0x0
  pushl $95
80105e00:	6a 5f                	push   $0x5f
  jmp alltraps
80105e02:	e9 f3 f7 ff ff       	jmp    801055fa <alltraps>

80105e07 <vector96>:
.globl vector96
vector96:
  pushl $0
80105e07:	6a 00                	push   $0x0
  pushl $96
80105e09:	6a 60                	push   $0x60
  jmp alltraps
80105e0b:	e9 ea f7 ff ff       	jmp    801055fa <alltraps>

80105e10 <vector97>:
.globl vector97
vector97:
  pushl $0
80105e10:	6a 00                	push   $0x0
  pushl $97
80105e12:	6a 61                	push   $0x61
  jmp alltraps
80105e14:	e9 e1 f7 ff ff       	jmp    801055fa <alltraps>

80105e19 <vector98>:
.globl vector98
vector98:
  pushl $0
80105e19:	6a 00                	push   $0x0
  pushl $98
80105e1b:	6a 62                	push   $0x62
  jmp alltraps
80105e1d:	e9 d8 f7 ff ff       	jmp    801055fa <alltraps>

80105e22 <vector99>:
.globl vector99
vector99:
  pushl $0
80105e22:	6a 00                	push   $0x0
  pushl $99
80105e24:	6a 63                	push   $0x63
  jmp alltraps
80105e26:	e9 cf f7 ff ff       	jmp    801055fa <alltraps>

80105e2b <vector100>:
.globl vector100
vector100:
  pushl $0
80105e2b:	6a 00                	push   $0x0
  pushl $100
80105e2d:	6a 64                	push   $0x64
  jmp alltraps
80105e2f:	e9 c6 f7 ff ff       	jmp    801055fa <alltraps>

80105e34 <vector101>:
.globl vector101
vector101:
  pushl $0
80105e34:	6a 00                	push   $0x0
  pushl $101
80105e36:	6a 65                	push   $0x65
  jmp alltraps
80105e38:	e9 bd f7 ff ff       	jmp    801055fa <alltraps>

80105e3d <vector102>:
.globl vector102
vector102:
  pushl $0
80105e3d:	6a 00                	push   $0x0
  pushl $102
80105e3f:	6a 66                	push   $0x66
  jmp alltraps
80105e41:	e9 b4 f7 ff ff       	jmp    801055fa <alltraps>

80105e46 <vector103>:
.globl vector103
vector103:
  pushl $0
80105e46:	6a 00                	push   $0x0
  pushl $103
80105e48:	6a 67                	push   $0x67
  jmp alltraps
80105e4a:	e9 ab f7 ff ff       	jmp    801055fa <alltraps>

80105e4f <vector104>:
.globl vector104
vector104:
  pushl $0
80105e4f:	6a 00                	push   $0x0
  pushl $104
80105e51:	6a 68                	push   $0x68
  jmp alltraps
80105e53:	e9 a2 f7 ff ff       	jmp    801055fa <alltraps>

80105e58 <vector105>:
.globl vector105
vector105:
  pushl $0
80105e58:	6a 00                	push   $0x0
  pushl $105
80105e5a:	6a 69                	push   $0x69
  jmp alltraps
80105e5c:	e9 99 f7 ff ff       	jmp    801055fa <alltraps>

80105e61 <vector106>:
.globl vector106
vector106:
  pushl $0
80105e61:	6a 00                	push   $0x0
  pushl $106
80105e63:	6a 6a                	push   $0x6a
  jmp alltraps
80105e65:	e9 90 f7 ff ff       	jmp    801055fa <alltraps>

80105e6a <vector107>:
.globl vector107
vector107:
  pushl $0
80105e6a:	6a 00                	push   $0x0
  pushl $107
80105e6c:	6a 6b                	push   $0x6b
  jmp alltraps
80105e6e:	e9 87 f7 ff ff       	jmp    801055fa <alltraps>

80105e73 <vector108>:
.globl vector108
vector108:
  pushl $0
80105e73:	6a 00                	push   $0x0
  pushl $108
80105e75:	6a 6c                	push   $0x6c
  jmp alltraps
80105e77:	e9 7e f7 ff ff       	jmp    801055fa <alltraps>

80105e7c <vector109>:
.globl vector109
vector109:
  pushl $0
80105e7c:	6a 00                	push   $0x0
  pushl $109
80105e7e:	6a 6d                	push   $0x6d
  jmp alltraps
80105e80:	e9 75 f7 ff ff       	jmp    801055fa <alltraps>

80105e85 <vector110>:
.globl vector110
vector110:
  pushl $0
80105e85:	6a 00                	push   $0x0
  pushl $110
80105e87:	6a 6e                	push   $0x6e
  jmp alltraps
80105e89:	e9 6c f7 ff ff       	jmp    801055fa <alltraps>

80105e8e <vector111>:
.globl vector111
vector111:
  pushl $0
80105e8e:	6a 00                	push   $0x0
  pushl $111
80105e90:	6a 6f                	push   $0x6f
  jmp alltraps
80105e92:	e9 63 f7 ff ff       	jmp    801055fa <alltraps>

80105e97 <vector112>:
.globl vector112
vector112:
  pushl $0
80105e97:	6a 00                	push   $0x0
  pushl $112
80105e99:	6a 70                	push   $0x70
  jmp alltraps
80105e9b:	e9 5a f7 ff ff       	jmp    801055fa <alltraps>

80105ea0 <vector113>:
.globl vector113
vector113:
  pushl $0
80105ea0:	6a 00                	push   $0x0
  pushl $113
80105ea2:	6a 71                	push   $0x71
  jmp alltraps
80105ea4:	e9 51 f7 ff ff       	jmp    801055fa <alltraps>

80105ea9 <vector114>:
.globl vector114
vector114:
  pushl $0
80105ea9:	6a 00                	push   $0x0
  pushl $114
80105eab:	6a 72                	push   $0x72
  jmp alltraps
80105ead:	e9 48 f7 ff ff       	jmp    801055fa <alltraps>

80105eb2 <vector115>:
.globl vector115
vector115:
  pushl $0
80105eb2:	6a 00                	push   $0x0
  pushl $115
80105eb4:	6a 73                	push   $0x73
  jmp alltraps
80105eb6:	e9 3f f7 ff ff       	jmp    801055fa <alltraps>

80105ebb <vector116>:
.globl vector116
vector116:
  pushl $0
80105ebb:	6a 00                	push   $0x0
  pushl $116
80105ebd:	6a 74                	push   $0x74
  jmp alltraps
80105ebf:	e9 36 f7 ff ff       	jmp    801055fa <alltraps>

80105ec4 <vector117>:
.globl vector117
vector117:
  pushl $0
80105ec4:	6a 00                	push   $0x0
  pushl $117
80105ec6:	6a 75                	push   $0x75
  jmp alltraps
80105ec8:	e9 2d f7 ff ff       	jmp    801055fa <alltraps>

80105ecd <vector118>:
.globl vector118
vector118:
  pushl $0
80105ecd:	6a 00                	push   $0x0
  pushl $118
80105ecf:	6a 76                	push   $0x76
  jmp alltraps
80105ed1:	e9 24 f7 ff ff       	jmp    801055fa <alltraps>

80105ed6 <vector119>:
.globl vector119
vector119:
  pushl $0
80105ed6:	6a 00                	push   $0x0
  pushl $119
80105ed8:	6a 77                	push   $0x77
  jmp alltraps
80105eda:	e9 1b f7 ff ff       	jmp    801055fa <alltraps>

80105edf <vector120>:
.globl vector120
vector120:
  pushl $0
80105edf:	6a 00                	push   $0x0
  pushl $120
80105ee1:	6a 78                	push   $0x78
  jmp alltraps
80105ee3:	e9 12 f7 ff ff       	jmp    801055fa <alltraps>

80105ee8 <vector121>:
.globl vector121
vector121:
  pushl $0
80105ee8:	6a 00                	push   $0x0
  pushl $121
80105eea:	6a 79                	push   $0x79
  jmp alltraps
80105eec:	e9 09 f7 ff ff       	jmp    801055fa <alltraps>

80105ef1 <vector122>:
.globl vector122
vector122:
  pushl $0
80105ef1:	6a 00                	push   $0x0
  pushl $122
80105ef3:	6a 7a                	push   $0x7a
  jmp alltraps
80105ef5:	e9 00 f7 ff ff       	jmp    801055fa <alltraps>

80105efa <vector123>:
.globl vector123
vector123:
  pushl $0
80105efa:	6a 00                	push   $0x0
  pushl $123
80105efc:	6a 7b                	push   $0x7b
  jmp alltraps
80105efe:	e9 f7 f6 ff ff       	jmp    801055fa <alltraps>

80105f03 <vector124>:
.globl vector124
vector124:
  pushl $0
80105f03:	6a 00                	push   $0x0
  pushl $124
80105f05:	6a 7c                	push   $0x7c
  jmp alltraps
80105f07:	e9 ee f6 ff ff       	jmp    801055fa <alltraps>

80105f0c <vector125>:
.globl vector125
vector125:
  pushl $0
80105f0c:	6a 00                	push   $0x0
  pushl $125
80105f0e:	6a 7d                	push   $0x7d
  jmp alltraps
80105f10:	e9 e5 f6 ff ff       	jmp    801055fa <alltraps>

80105f15 <vector126>:
.globl vector126
vector126:
  pushl $0
80105f15:	6a 00                	push   $0x0
  pushl $126
80105f17:	6a 7e                	push   $0x7e
  jmp alltraps
80105f19:	e9 dc f6 ff ff       	jmp    801055fa <alltraps>

80105f1e <vector127>:
.globl vector127
vector127:
  pushl $0
80105f1e:	6a 00                	push   $0x0
  pushl $127
80105f20:	6a 7f                	push   $0x7f
  jmp alltraps
80105f22:	e9 d3 f6 ff ff       	jmp    801055fa <alltraps>

80105f27 <vector128>:
.globl vector128
vector128:
  pushl $0
80105f27:	6a 00                	push   $0x0
  pushl $128
80105f29:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105f2e:	e9 c7 f6 ff ff       	jmp    801055fa <alltraps>

80105f33 <vector129>:
.globl vector129
vector129:
  pushl $0
80105f33:	6a 00                	push   $0x0
  pushl $129
80105f35:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105f3a:	e9 bb f6 ff ff       	jmp    801055fa <alltraps>

80105f3f <vector130>:
.globl vector130
vector130:
  pushl $0
80105f3f:	6a 00                	push   $0x0
  pushl $130
80105f41:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105f46:	e9 af f6 ff ff       	jmp    801055fa <alltraps>

80105f4b <vector131>:
.globl vector131
vector131:
  pushl $0
80105f4b:	6a 00                	push   $0x0
  pushl $131
80105f4d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80105f52:	e9 a3 f6 ff ff       	jmp    801055fa <alltraps>

80105f57 <vector132>:
.globl vector132
vector132:
  pushl $0
80105f57:	6a 00                	push   $0x0
  pushl $132
80105f59:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105f5e:	e9 97 f6 ff ff       	jmp    801055fa <alltraps>

80105f63 <vector133>:
.globl vector133
vector133:
  pushl $0
80105f63:	6a 00                	push   $0x0
  pushl $133
80105f65:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80105f6a:	e9 8b f6 ff ff       	jmp    801055fa <alltraps>

80105f6f <vector134>:
.globl vector134
vector134:
  pushl $0
80105f6f:	6a 00                	push   $0x0
  pushl $134
80105f71:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80105f76:	e9 7f f6 ff ff       	jmp    801055fa <alltraps>

80105f7b <vector135>:
.globl vector135
vector135:
  pushl $0
80105f7b:	6a 00                	push   $0x0
  pushl $135
80105f7d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105f82:	e9 73 f6 ff ff       	jmp    801055fa <alltraps>

80105f87 <vector136>:
.globl vector136
vector136:
  pushl $0
80105f87:	6a 00                	push   $0x0
  pushl $136
80105f89:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105f8e:	e9 67 f6 ff ff       	jmp    801055fa <alltraps>

80105f93 <vector137>:
.globl vector137
vector137:
  pushl $0
80105f93:	6a 00                	push   $0x0
  pushl $137
80105f95:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105f9a:	e9 5b f6 ff ff       	jmp    801055fa <alltraps>

80105f9f <vector138>:
.globl vector138
vector138:
  pushl $0
80105f9f:	6a 00                	push   $0x0
  pushl $138
80105fa1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105fa6:	e9 4f f6 ff ff       	jmp    801055fa <alltraps>

80105fab <vector139>:
.globl vector139
vector139:
  pushl $0
80105fab:	6a 00                	push   $0x0
  pushl $139
80105fad:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105fb2:	e9 43 f6 ff ff       	jmp    801055fa <alltraps>

80105fb7 <vector140>:
.globl vector140
vector140:
  pushl $0
80105fb7:	6a 00                	push   $0x0
  pushl $140
80105fb9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105fbe:	e9 37 f6 ff ff       	jmp    801055fa <alltraps>

80105fc3 <vector141>:
.globl vector141
vector141:
  pushl $0
80105fc3:	6a 00                	push   $0x0
  pushl $141
80105fc5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105fca:	e9 2b f6 ff ff       	jmp    801055fa <alltraps>

80105fcf <vector142>:
.globl vector142
vector142:
  pushl $0
80105fcf:	6a 00                	push   $0x0
  pushl $142
80105fd1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105fd6:	e9 1f f6 ff ff       	jmp    801055fa <alltraps>

80105fdb <vector143>:
.globl vector143
vector143:
  pushl $0
80105fdb:	6a 00                	push   $0x0
  pushl $143
80105fdd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105fe2:	e9 13 f6 ff ff       	jmp    801055fa <alltraps>

80105fe7 <vector144>:
.globl vector144
vector144:
  pushl $0
80105fe7:	6a 00                	push   $0x0
  pushl $144
80105fe9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105fee:	e9 07 f6 ff ff       	jmp    801055fa <alltraps>

80105ff3 <vector145>:
.globl vector145
vector145:
  pushl $0
80105ff3:	6a 00                	push   $0x0
  pushl $145
80105ff5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105ffa:	e9 fb f5 ff ff       	jmp    801055fa <alltraps>

80105fff <vector146>:
.globl vector146
vector146:
  pushl $0
80105fff:	6a 00                	push   $0x0
  pushl $146
80106001:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106006:	e9 ef f5 ff ff       	jmp    801055fa <alltraps>

8010600b <vector147>:
.globl vector147
vector147:
  pushl $0
8010600b:	6a 00                	push   $0x0
  pushl $147
8010600d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106012:	e9 e3 f5 ff ff       	jmp    801055fa <alltraps>

80106017 <vector148>:
.globl vector148
vector148:
  pushl $0
80106017:	6a 00                	push   $0x0
  pushl $148
80106019:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010601e:	e9 d7 f5 ff ff       	jmp    801055fa <alltraps>

80106023 <vector149>:
.globl vector149
vector149:
  pushl $0
80106023:	6a 00                	push   $0x0
  pushl $149
80106025:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010602a:	e9 cb f5 ff ff       	jmp    801055fa <alltraps>

8010602f <vector150>:
.globl vector150
vector150:
  pushl $0
8010602f:	6a 00                	push   $0x0
  pushl $150
80106031:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106036:	e9 bf f5 ff ff       	jmp    801055fa <alltraps>

8010603b <vector151>:
.globl vector151
vector151:
  pushl $0
8010603b:	6a 00                	push   $0x0
  pushl $151
8010603d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106042:	e9 b3 f5 ff ff       	jmp    801055fa <alltraps>

80106047 <vector152>:
.globl vector152
vector152:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $152
80106049:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010604e:	e9 a7 f5 ff ff       	jmp    801055fa <alltraps>

80106053 <vector153>:
.globl vector153
vector153:
  pushl $0
80106053:	6a 00                	push   $0x0
  pushl $153
80106055:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010605a:	e9 9b f5 ff ff       	jmp    801055fa <alltraps>

8010605f <vector154>:
.globl vector154
vector154:
  pushl $0
8010605f:	6a 00                	push   $0x0
  pushl $154
80106061:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106066:	e9 8f f5 ff ff       	jmp    801055fa <alltraps>

8010606b <vector155>:
.globl vector155
vector155:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $155
8010606d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106072:	e9 83 f5 ff ff       	jmp    801055fa <alltraps>

80106077 <vector156>:
.globl vector156
vector156:
  pushl $0
80106077:	6a 00                	push   $0x0
  pushl $156
80106079:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010607e:	e9 77 f5 ff ff       	jmp    801055fa <alltraps>

80106083 <vector157>:
.globl vector157
vector157:
  pushl $0
80106083:	6a 00                	push   $0x0
  pushl $157
80106085:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010608a:	e9 6b f5 ff ff       	jmp    801055fa <alltraps>

8010608f <vector158>:
.globl vector158
vector158:
  pushl $0
8010608f:	6a 00                	push   $0x0
  pushl $158
80106091:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106096:	e9 5f f5 ff ff       	jmp    801055fa <alltraps>

8010609b <vector159>:
.globl vector159
vector159:
  pushl $0
8010609b:	6a 00                	push   $0x0
  pushl $159
8010609d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801060a2:	e9 53 f5 ff ff       	jmp    801055fa <alltraps>

801060a7 <vector160>:
.globl vector160
vector160:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $160
801060a9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801060ae:	e9 47 f5 ff ff       	jmp    801055fa <alltraps>

801060b3 <vector161>:
.globl vector161
vector161:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $161
801060b5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801060ba:	e9 3b f5 ff ff       	jmp    801055fa <alltraps>

801060bf <vector162>:
.globl vector162
vector162:
  pushl $0
801060bf:	6a 00                	push   $0x0
  pushl $162
801060c1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801060c6:	e9 2f f5 ff ff       	jmp    801055fa <alltraps>

801060cb <vector163>:
.globl vector163
vector163:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $163
801060cd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801060d2:	e9 23 f5 ff ff       	jmp    801055fa <alltraps>

801060d7 <vector164>:
.globl vector164
vector164:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $164
801060d9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801060de:	e9 17 f5 ff ff       	jmp    801055fa <alltraps>

801060e3 <vector165>:
.globl vector165
vector165:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $165
801060e5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801060ea:	e9 0b f5 ff ff       	jmp    801055fa <alltraps>

801060ef <vector166>:
.globl vector166
vector166:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $166
801060f1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801060f6:	e9 ff f4 ff ff       	jmp    801055fa <alltraps>

801060fb <vector167>:
.globl vector167
vector167:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $167
801060fd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106102:	e9 f3 f4 ff ff       	jmp    801055fa <alltraps>

80106107 <vector168>:
.globl vector168
vector168:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $168
80106109:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010610e:	e9 e7 f4 ff ff       	jmp    801055fa <alltraps>

80106113 <vector169>:
.globl vector169
vector169:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $169
80106115:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010611a:	e9 db f4 ff ff       	jmp    801055fa <alltraps>

8010611f <vector170>:
.globl vector170
vector170:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $170
80106121:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106126:	e9 cf f4 ff ff       	jmp    801055fa <alltraps>

8010612b <vector171>:
.globl vector171
vector171:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $171
8010612d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106132:	e9 c3 f4 ff ff       	jmp    801055fa <alltraps>

80106137 <vector172>:
.globl vector172
vector172:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $172
80106139:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010613e:	e9 b7 f4 ff ff       	jmp    801055fa <alltraps>

80106143 <vector173>:
.globl vector173
vector173:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $173
80106145:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010614a:	e9 ab f4 ff ff       	jmp    801055fa <alltraps>

8010614f <vector174>:
.globl vector174
vector174:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $174
80106151:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106156:	e9 9f f4 ff ff       	jmp    801055fa <alltraps>

8010615b <vector175>:
.globl vector175
vector175:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $175
8010615d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106162:	e9 93 f4 ff ff       	jmp    801055fa <alltraps>

80106167 <vector176>:
.globl vector176
vector176:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $176
80106169:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010616e:	e9 87 f4 ff ff       	jmp    801055fa <alltraps>

80106173 <vector177>:
.globl vector177
vector177:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $177
80106175:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010617a:	e9 7b f4 ff ff       	jmp    801055fa <alltraps>

8010617f <vector178>:
.globl vector178
vector178:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $178
80106181:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106186:	e9 6f f4 ff ff       	jmp    801055fa <alltraps>

8010618b <vector179>:
.globl vector179
vector179:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $179
8010618d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106192:	e9 63 f4 ff ff       	jmp    801055fa <alltraps>

80106197 <vector180>:
.globl vector180
vector180:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $180
80106199:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010619e:	e9 57 f4 ff ff       	jmp    801055fa <alltraps>

801061a3 <vector181>:
.globl vector181
vector181:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $181
801061a5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801061aa:	e9 4b f4 ff ff       	jmp    801055fa <alltraps>

801061af <vector182>:
.globl vector182
vector182:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $182
801061b1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801061b6:	e9 3f f4 ff ff       	jmp    801055fa <alltraps>

801061bb <vector183>:
.globl vector183
vector183:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $183
801061bd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801061c2:	e9 33 f4 ff ff       	jmp    801055fa <alltraps>

801061c7 <vector184>:
.globl vector184
vector184:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $184
801061c9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801061ce:	e9 27 f4 ff ff       	jmp    801055fa <alltraps>

801061d3 <vector185>:
.globl vector185
vector185:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $185
801061d5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801061da:	e9 1b f4 ff ff       	jmp    801055fa <alltraps>

801061df <vector186>:
.globl vector186
vector186:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $186
801061e1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801061e6:	e9 0f f4 ff ff       	jmp    801055fa <alltraps>

801061eb <vector187>:
.globl vector187
vector187:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $187
801061ed:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801061f2:	e9 03 f4 ff ff       	jmp    801055fa <alltraps>

801061f7 <vector188>:
.globl vector188
vector188:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $188
801061f9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801061fe:	e9 f7 f3 ff ff       	jmp    801055fa <alltraps>

80106203 <vector189>:
.globl vector189
vector189:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $189
80106205:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010620a:	e9 eb f3 ff ff       	jmp    801055fa <alltraps>

8010620f <vector190>:
.globl vector190
vector190:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $190
80106211:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106216:	e9 df f3 ff ff       	jmp    801055fa <alltraps>

8010621b <vector191>:
.globl vector191
vector191:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $191
8010621d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106222:	e9 d3 f3 ff ff       	jmp    801055fa <alltraps>

80106227 <vector192>:
.globl vector192
vector192:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $192
80106229:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010622e:	e9 c7 f3 ff ff       	jmp    801055fa <alltraps>

80106233 <vector193>:
.globl vector193
vector193:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $193
80106235:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010623a:	e9 bb f3 ff ff       	jmp    801055fa <alltraps>

8010623f <vector194>:
.globl vector194
vector194:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $194
80106241:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106246:	e9 af f3 ff ff       	jmp    801055fa <alltraps>

8010624b <vector195>:
.globl vector195
vector195:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $195
8010624d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106252:	e9 a3 f3 ff ff       	jmp    801055fa <alltraps>

80106257 <vector196>:
.globl vector196
vector196:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $196
80106259:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010625e:	e9 97 f3 ff ff       	jmp    801055fa <alltraps>

80106263 <vector197>:
.globl vector197
vector197:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $197
80106265:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010626a:	e9 8b f3 ff ff       	jmp    801055fa <alltraps>

8010626f <vector198>:
.globl vector198
vector198:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $198
80106271:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106276:	e9 7f f3 ff ff       	jmp    801055fa <alltraps>

8010627b <vector199>:
.globl vector199
vector199:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $199
8010627d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106282:	e9 73 f3 ff ff       	jmp    801055fa <alltraps>

80106287 <vector200>:
.globl vector200
vector200:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $200
80106289:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010628e:	e9 67 f3 ff ff       	jmp    801055fa <alltraps>

80106293 <vector201>:
.globl vector201
vector201:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $201
80106295:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010629a:	e9 5b f3 ff ff       	jmp    801055fa <alltraps>

8010629f <vector202>:
.globl vector202
vector202:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $202
801062a1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801062a6:	e9 4f f3 ff ff       	jmp    801055fa <alltraps>

801062ab <vector203>:
.globl vector203
vector203:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $203
801062ad:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801062b2:	e9 43 f3 ff ff       	jmp    801055fa <alltraps>

801062b7 <vector204>:
.globl vector204
vector204:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $204
801062b9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801062be:	e9 37 f3 ff ff       	jmp    801055fa <alltraps>

801062c3 <vector205>:
.globl vector205
vector205:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $205
801062c5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801062ca:	e9 2b f3 ff ff       	jmp    801055fa <alltraps>

801062cf <vector206>:
.globl vector206
vector206:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $206
801062d1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801062d6:	e9 1f f3 ff ff       	jmp    801055fa <alltraps>

801062db <vector207>:
.globl vector207
vector207:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $207
801062dd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801062e2:	e9 13 f3 ff ff       	jmp    801055fa <alltraps>

801062e7 <vector208>:
.globl vector208
vector208:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $208
801062e9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801062ee:	e9 07 f3 ff ff       	jmp    801055fa <alltraps>

801062f3 <vector209>:
.globl vector209
vector209:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $209
801062f5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801062fa:	e9 fb f2 ff ff       	jmp    801055fa <alltraps>

801062ff <vector210>:
.globl vector210
vector210:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $210
80106301:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106306:	e9 ef f2 ff ff       	jmp    801055fa <alltraps>

8010630b <vector211>:
.globl vector211
vector211:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $211
8010630d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106312:	e9 e3 f2 ff ff       	jmp    801055fa <alltraps>

80106317 <vector212>:
.globl vector212
vector212:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $212
80106319:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010631e:	e9 d7 f2 ff ff       	jmp    801055fa <alltraps>

80106323 <vector213>:
.globl vector213
vector213:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $213
80106325:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010632a:	e9 cb f2 ff ff       	jmp    801055fa <alltraps>

8010632f <vector214>:
.globl vector214
vector214:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $214
80106331:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106336:	e9 bf f2 ff ff       	jmp    801055fa <alltraps>

8010633b <vector215>:
.globl vector215
vector215:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $215
8010633d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106342:	e9 b3 f2 ff ff       	jmp    801055fa <alltraps>

80106347 <vector216>:
.globl vector216
vector216:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $216
80106349:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010634e:	e9 a7 f2 ff ff       	jmp    801055fa <alltraps>

80106353 <vector217>:
.globl vector217
vector217:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $217
80106355:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010635a:	e9 9b f2 ff ff       	jmp    801055fa <alltraps>

8010635f <vector218>:
.globl vector218
vector218:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $218
80106361:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106366:	e9 8f f2 ff ff       	jmp    801055fa <alltraps>

8010636b <vector219>:
.globl vector219
vector219:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $219
8010636d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106372:	e9 83 f2 ff ff       	jmp    801055fa <alltraps>

80106377 <vector220>:
.globl vector220
vector220:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $220
80106379:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010637e:	e9 77 f2 ff ff       	jmp    801055fa <alltraps>

80106383 <vector221>:
.globl vector221
vector221:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $221
80106385:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010638a:	e9 6b f2 ff ff       	jmp    801055fa <alltraps>

8010638f <vector222>:
.globl vector222
vector222:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $222
80106391:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106396:	e9 5f f2 ff ff       	jmp    801055fa <alltraps>

8010639b <vector223>:
.globl vector223
vector223:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $223
8010639d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801063a2:	e9 53 f2 ff ff       	jmp    801055fa <alltraps>

801063a7 <vector224>:
.globl vector224
vector224:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $224
801063a9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801063ae:	e9 47 f2 ff ff       	jmp    801055fa <alltraps>

801063b3 <vector225>:
.globl vector225
vector225:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $225
801063b5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801063ba:	e9 3b f2 ff ff       	jmp    801055fa <alltraps>

801063bf <vector226>:
.globl vector226
vector226:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $226
801063c1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801063c6:	e9 2f f2 ff ff       	jmp    801055fa <alltraps>

801063cb <vector227>:
.globl vector227
vector227:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $227
801063cd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801063d2:	e9 23 f2 ff ff       	jmp    801055fa <alltraps>

801063d7 <vector228>:
.globl vector228
vector228:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $228
801063d9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801063de:	e9 17 f2 ff ff       	jmp    801055fa <alltraps>

801063e3 <vector229>:
.globl vector229
vector229:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $229
801063e5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801063ea:	e9 0b f2 ff ff       	jmp    801055fa <alltraps>

801063ef <vector230>:
.globl vector230
vector230:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $230
801063f1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801063f6:	e9 ff f1 ff ff       	jmp    801055fa <alltraps>

801063fb <vector231>:
.globl vector231
vector231:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $231
801063fd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106402:	e9 f3 f1 ff ff       	jmp    801055fa <alltraps>

80106407 <vector232>:
.globl vector232
vector232:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $232
80106409:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010640e:	e9 e7 f1 ff ff       	jmp    801055fa <alltraps>

80106413 <vector233>:
.globl vector233
vector233:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $233
80106415:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010641a:	e9 db f1 ff ff       	jmp    801055fa <alltraps>

8010641f <vector234>:
.globl vector234
vector234:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $234
80106421:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106426:	e9 cf f1 ff ff       	jmp    801055fa <alltraps>

8010642b <vector235>:
.globl vector235
vector235:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $235
8010642d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106432:	e9 c3 f1 ff ff       	jmp    801055fa <alltraps>

80106437 <vector236>:
.globl vector236
vector236:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $236
80106439:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010643e:	e9 b7 f1 ff ff       	jmp    801055fa <alltraps>

80106443 <vector237>:
.globl vector237
vector237:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $237
80106445:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010644a:	e9 ab f1 ff ff       	jmp    801055fa <alltraps>

8010644f <vector238>:
.globl vector238
vector238:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $238
80106451:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106456:	e9 9f f1 ff ff       	jmp    801055fa <alltraps>

8010645b <vector239>:
.globl vector239
vector239:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $239
8010645d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106462:	e9 93 f1 ff ff       	jmp    801055fa <alltraps>

80106467 <vector240>:
.globl vector240
vector240:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $240
80106469:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010646e:	e9 87 f1 ff ff       	jmp    801055fa <alltraps>

80106473 <vector241>:
.globl vector241
vector241:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $241
80106475:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010647a:	e9 7b f1 ff ff       	jmp    801055fa <alltraps>

8010647f <vector242>:
.globl vector242
vector242:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $242
80106481:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106486:	e9 6f f1 ff ff       	jmp    801055fa <alltraps>

8010648b <vector243>:
.globl vector243
vector243:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $243
8010648d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106492:	e9 63 f1 ff ff       	jmp    801055fa <alltraps>

80106497 <vector244>:
.globl vector244
vector244:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $244
80106499:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010649e:	e9 57 f1 ff ff       	jmp    801055fa <alltraps>

801064a3 <vector245>:
.globl vector245
vector245:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $245
801064a5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801064aa:	e9 4b f1 ff ff       	jmp    801055fa <alltraps>

801064af <vector246>:
.globl vector246
vector246:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $246
801064b1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801064b6:	e9 3f f1 ff ff       	jmp    801055fa <alltraps>

801064bb <vector247>:
.globl vector247
vector247:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $247
801064bd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801064c2:	e9 33 f1 ff ff       	jmp    801055fa <alltraps>

801064c7 <vector248>:
.globl vector248
vector248:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $248
801064c9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801064ce:	e9 27 f1 ff ff       	jmp    801055fa <alltraps>

801064d3 <vector249>:
.globl vector249
vector249:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $249
801064d5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801064da:	e9 1b f1 ff ff       	jmp    801055fa <alltraps>

801064df <vector250>:
.globl vector250
vector250:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $250
801064e1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801064e6:	e9 0f f1 ff ff       	jmp    801055fa <alltraps>

801064eb <vector251>:
.globl vector251
vector251:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $251
801064ed:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801064f2:	e9 03 f1 ff ff       	jmp    801055fa <alltraps>

801064f7 <vector252>:
.globl vector252
vector252:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $252
801064f9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801064fe:	e9 f7 f0 ff ff       	jmp    801055fa <alltraps>

80106503 <vector253>:
.globl vector253
vector253:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $253
80106505:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010650a:	e9 eb f0 ff ff       	jmp    801055fa <alltraps>

8010650f <vector254>:
.globl vector254
vector254:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $254
80106511:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106516:	e9 df f0 ff ff       	jmp    801055fa <alltraps>

8010651b <vector255>:
.globl vector255
vector255:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $255
8010651d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106522:	e9 d3 f0 ff ff       	jmp    801055fa <alltraps>
80106527:	66 90                	xchg   %ax,%ax
80106529:	66 90                	xchg   %ax,%ax
8010652b:	66 90                	xchg   %ax,%ax
8010652d:	66 90                	xchg   %ax,%ax
8010652f:	90                   	nop

80106530 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106530:	55                   	push   %ebp
80106531:	89 e5                	mov    %esp,%ebp
80106533:	57                   	push   %edi
80106534:	56                   	push   %esi
80106535:	53                   	push   %ebx
80106536:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106538:	c1 ea 16             	shr    $0x16,%edx
8010653b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010653e:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106541:	8b 07                	mov    (%edi),%eax
80106543:	a8 01                	test   $0x1,%al
80106545:	74 29                	je     80106570 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106547:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010654c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106552:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106555:	c1 eb 0a             	shr    $0xa,%ebx
80106558:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
8010655e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106561:	5b                   	pop    %ebx
80106562:	5e                   	pop    %esi
80106563:	5f                   	pop    %edi
80106564:	5d                   	pop    %ebp
80106565:	c3                   	ret    
80106566:	8d 76 00             	lea    0x0(%esi),%esi
80106569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106570:	85 c9                	test   %ecx,%ecx
80106572:	74 2c                	je     801065a0 <walkpgdir+0x70>
80106574:	e8 d7 be ff ff       	call   80102450 <kalloc>
80106579:	85 c0                	test   %eax,%eax
8010657b:	89 c6                	mov    %eax,%esi
8010657d:	74 21                	je     801065a0 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010657f:	83 ec 04             	sub    $0x4,%esp
80106582:	68 00 10 00 00       	push   $0x1000
80106587:	6a 00                	push   $0x0
80106589:	50                   	push   %eax
8010658a:	e8 41 de ff ff       	call   801043d0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010658f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106595:	83 c4 10             	add    $0x10,%esp
80106598:	83 c8 07             	or     $0x7,%eax
8010659b:	89 07                	mov    %eax,(%edi)
8010659d:	eb b3                	jmp    80106552 <walkpgdir+0x22>
8010659f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
801065a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
801065a3:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801065a5:	5b                   	pop    %ebx
801065a6:	5e                   	pop    %esi
801065a7:	5f                   	pop    %edi
801065a8:	5d                   	pop    %ebp
801065a9:	c3                   	ret    
801065aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801065b0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801065b0:	55                   	push   %ebp
801065b1:	89 e5                	mov    %esp,%ebp
801065b3:	57                   	push   %edi
801065b4:	56                   	push   %esi
801065b5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801065b6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801065bc:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801065be:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801065c4:	83 ec 1c             	sub    $0x1c,%esp
801065c7:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801065ca:	39 d3                	cmp    %edx,%ebx
801065cc:	73 66                	jae    80106634 <deallocuvm.part.0+0x84>
801065ce:	89 d6                	mov    %edx,%esi
801065d0:	eb 3d                	jmp    8010660f <deallocuvm.part.0+0x5f>
801065d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801065d8:	8b 10                	mov    (%eax),%edx
801065da:	f6 c2 01             	test   $0x1,%dl
801065dd:	74 26                	je     80106605 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801065df:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801065e5:	74 58                	je     8010663f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801065e7:	83 ec 0c             	sub    $0xc,%esp
801065ea:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801065f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801065f3:	52                   	push   %edx
801065f4:	e8 a7 bc ff ff       	call   801022a0 <kfree>
      *pte = 0;
801065f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801065fc:	83 c4 10             	add    $0x10,%esp
801065ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106605:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010660b:	39 f3                	cmp    %esi,%ebx
8010660d:	73 25                	jae    80106634 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010660f:	31 c9                	xor    %ecx,%ecx
80106611:	89 da                	mov    %ebx,%edx
80106613:	89 f8                	mov    %edi,%eax
80106615:	e8 16 ff ff ff       	call   80106530 <walkpgdir>
    if(!pte)
8010661a:	85 c0                	test   %eax,%eax
8010661c:	75 ba                	jne    801065d8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010661e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106624:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010662a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106630:	39 f3                	cmp    %esi,%ebx
80106632:	72 db                	jb     8010660f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106634:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106637:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010663a:	5b                   	pop    %ebx
8010663b:	5e                   	pop    %esi
8010663c:	5f                   	pop    %edi
8010663d:	5d                   	pop    %ebp
8010663e:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010663f:	83 ec 0c             	sub    $0xc,%esp
80106642:	68 66 72 10 80       	push   $0x80107266
80106647:	e8 24 9d ff ff       	call   80100370 <panic>
8010664c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106650 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106650:	55                   	push   %ebp
80106651:	89 e5                	mov    %esp,%ebp
80106653:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106656:	e8 c5 d0 ff ff       	call   80103720 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010665b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106661:	31 c9                	xor    %ecx,%ecx
80106663:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106668:	66 89 90 f8 27 11 80 	mov    %dx,-0x7feed808(%eax)
8010666f:	66 89 88 fa 27 11 80 	mov    %cx,-0x7feed806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106676:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010667b:	31 c9                	xor    %ecx,%ecx
8010667d:	66 89 90 00 28 11 80 	mov    %dx,-0x7feed800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106684:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106689:	66 89 88 02 28 11 80 	mov    %cx,-0x7feed7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106690:	31 c9                	xor    %ecx,%ecx
80106692:	66 89 90 08 28 11 80 	mov    %dx,-0x7feed7f8(%eax)
80106699:	66 89 88 0a 28 11 80 	mov    %cx,-0x7feed7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801066a0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801066a5:	31 c9                	xor    %ecx,%ecx
801066a7:	66 89 90 10 28 11 80 	mov    %dx,-0x7feed7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801066ae:	c6 80 fc 27 11 80 00 	movb   $0x0,-0x7feed804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801066b5:	ba 2f 00 00 00       	mov    $0x2f,%edx
801066ba:	c6 80 fd 27 11 80 9a 	movb   $0x9a,-0x7feed803(%eax)
801066c1:	c6 80 fe 27 11 80 cf 	movb   $0xcf,-0x7feed802(%eax)
801066c8:	c6 80 ff 27 11 80 00 	movb   $0x0,-0x7feed801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801066cf:	c6 80 04 28 11 80 00 	movb   $0x0,-0x7feed7fc(%eax)
801066d6:	c6 80 05 28 11 80 92 	movb   $0x92,-0x7feed7fb(%eax)
801066dd:	c6 80 06 28 11 80 cf 	movb   $0xcf,-0x7feed7fa(%eax)
801066e4:	c6 80 07 28 11 80 00 	movb   $0x0,-0x7feed7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801066eb:	c6 80 0c 28 11 80 00 	movb   $0x0,-0x7feed7f4(%eax)
801066f2:	c6 80 0d 28 11 80 fa 	movb   $0xfa,-0x7feed7f3(%eax)
801066f9:	c6 80 0e 28 11 80 cf 	movb   $0xcf,-0x7feed7f2(%eax)
80106700:	c6 80 0f 28 11 80 00 	movb   $0x0,-0x7feed7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106707:	66 89 88 12 28 11 80 	mov    %cx,-0x7feed7ee(%eax)
8010670e:	c6 80 14 28 11 80 00 	movb   $0x0,-0x7feed7ec(%eax)
80106715:	c6 80 15 28 11 80 f2 	movb   $0xf2,-0x7feed7eb(%eax)
8010671c:	c6 80 16 28 11 80 cf 	movb   $0xcf,-0x7feed7ea(%eax)
80106723:	c6 80 17 28 11 80 00 	movb   $0x0,-0x7feed7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010672a:	05 f0 27 11 80       	add    $0x801127f0,%eax
8010672f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106733:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106737:	c1 e8 10             	shr    $0x10,%eax
8010673a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010673e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106741:	0f 01 10             	lgdtl  (%eax)
}
80106744:	c9                   	leave  
80106745:	c3                   	ret    
80106746:	8d 76 00             	lea    0x0(%esi),%esi
80106749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106750 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106750:	55                   	push   %ebp
80106751:	89 e5                	mov    %esp,%ebp
80106753:	57                   	push   %edi
80106754:	56                   	push   %esi
80106755:	53                   	push   %ebx
80106756:	83 ec 1c             	sub    $0x1c,%esp
80106759:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010675c:	8b 55 10             	mov    0x10(%ebp),%edx
8010675f:	8b 7d 14             	mov    0x14(%ebp),%edi
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106762:	89 c3                	mov    %eax,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106764:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106768:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010676e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106773:	29 df                	sub    %ebx,%edi
80106775:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106778:	8b 45 18             	mov    0x18(%ebp),%eax
8010677b:	83 c8 01             	or     $0x1,%eax
8010677e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106781:	eb 1a                	jmp    8010679d <mappages+0x4d>
80106783:	90                   	nop
80106784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106788:	f6 00 01             	testb  $0x1,(%eax)
8010678b:	75 3d                	jne    801067ca <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
8010678d:	0b 75 e0             	or     -0x20(%ebp),%esi
    if(a == last)
80106790:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106793:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106795:	74 29                	je     801067c0 <mappages+0x70>
      break;
    a += PGSIZE;
80106797:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010679d:	8b 45 08             	mov    0x8(%ebp),%eax
801067a0:	b9 01 00 00 00       	mov    $0x1,%ecx
801067a5:	89 da                	mov    %ebx,%edx
801067a7:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801067aa:	e8 81 fd ff ff       	call   80106530 <walkpgdir>
801067af:	85 c0                	test   %eax,%eax
801067b1:	75 d5                	jne    80106788 <mappages+0x38>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801067b3:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
801067b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801067bb:	5b                   	pop    %ebx
801067bc:	5e                   	pop    %esi
801067bd:	5f                   	pop    %edi
801067be:	5d                   	pop    %ebp
801067bf:	c3                   	ret    
801067c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801067c3:	31 c0                	xor    %eax,%eax
}
801067c5:	5b                   	pop    %ebx
801067c6:	5e                   	pop    %esi
801067c7:	5f                   	pop    %edi
801067c8:	5d                   	pop    %ebp
801067c9:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
801067ca:	83 ec 0c             	sub    $0xc,%esp
801067cd:	68 d0 78 10 80       	push   $0x801078d0
801067d2:	e8 99 9b ff ff       	call   80100370 <panic>
801067d7:	89 f6                	mov    %esi,%esi
801067d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801067e0 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801067e0:	a1 a4 55 11 80       	mov    0x801155a4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801067e5:	55                   	push   %ebp
801067e6:	89 e5                	mov    %esp,%ebp
801067e8:	05 00 00 00 80       	add    $0x80000000,%eax
801067ed:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
801067f0:	5d                   	pop    %ebp
801067f1:	c3                   	ret    
801067f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106800 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106800:	55                   	push   %ebp
80106801:	89 e5                	mov    %esp,%ebp
80106803:	57                   	push   %edi
80106804:	56                   	push   %esi
80106805:	53                   	push   %ebx
80106806:	83 ec 1c             	sub    $0x1c,%esp
80106809:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010680c:	85 f6                	test   %esi,%esi
8010680e:	0f 84 cd 00 00 00    	je     801068e1 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106814:	8b 46 08             	mov    0x8(%esi),%eax
80106817:	85 c0                	test   %eax,%eax
80106819:	0f 84 dc 00 00 00    	je     801068fb <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010681f:	8b 7e 04             	mov    0x4(%esi),%edi
80106822:	85 ff                	test   %edi,%edi
80106824:	0f 84 c4 00 00 00    	je     801068ee <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
8010682a:	e8 f1 d9 ff ff       	call   80104220 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010682f:	e8 6c ce ff ff       	call   801036a0 <mycpu>
80106834:	89 c3                	mov    %eax,%ebx
80106836:	e8 65 ce ff ff       	call   801036a0 <mycpu>
8010683b:	89 c7                	mov    %eax,%edi
8010683d:	e8 5e ce ff ff       	call   801036a0 <mycpu>
80106842:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106845:	83 c7 08             	add    $0x8,%edi
80106848:	e8 53 ce ff ff       	call   801036a0 <mycpu>
8010684d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106850:	83 c0 08             	add    $0x8,%eax
80106853:	ba 67 00 00 00       	mov    $0x67,%edx
80106858:	c1 e8 18             	shr    $0x18,%eax
8010685b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106862:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106869:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106870:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106877:	83 c1 08             	add    $0x8,%ecx
8010687a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106880:	c1 e9 10             	shr    $0x10,%ecx
80106883:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106889:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010688e:	e8 0d ce ff ff       	call   801036a0 <mycpu>
80106893:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010689a:	e8 01 ce ff ff       	call   801036a0 <mycpu>
8010689f:	b9 10 00 00 00       	mov    $0x10,%ecx
801068a4:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801068a8:	e8 f3 cd ff ff       	call   801036a0 <mycpu>
801068ad:	8b 56 08             	mov    0x8(%esi),%edx
801068b0:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
801068b6:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801068b9:	e8 e2 cd ff ff       	call   801036a0 <mycpu>
801068be:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
801068c2:	b8 28 00 00 00       	mov    $0x28,%eax
801068c7:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801068ca:	8b 46 04             	mov    0x4(%esi),%eax
801068cd:	05 00 00 00 80       	add    $0x80000000,%eax
801068d2:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
801068d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068d8:	5b                   	pop    %ebx
801068d9:	5e                   	pop    %esi
801068da:	5f                   	pop    %edi
801068db:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
801068dc:	e9 2f da ff ff       	jmp    80104310 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
801068e1:	83 ec 0c             	sub    $0xc,%esp
801068e4:	68 d6 78 10 80       	push   $0x801078d6
801068e9:	e8 82 9a ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
801068ee:	83 ec 0c             	sub    $0xc,%esp
801068f1:	68 01 79 10 80       	push   $0x80107901
801068f6:	e8 75 9a ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
801068fb:	83 ec 0c             	sub    $0xc,%esp
801068fe:	68 ec 78 10 80       	push   $0x801078ec
80106903:	e8 68 9a ff ff       	call   80100370 <panic>
80106908:	90                   	nop
80106909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106910 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	57                   	push   %edi
80106914:	56                   	push   %esi
80106915:	53                   	push   %ebx
80106916:	83 ec 1c             	sub    $0x1c,%esp
80106919:	8b 75 10             	mov    0x10(%ebp),%esi
8010691c:	8b 55 08             	mov    0x8(%ebp),%edx
8010691f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106922:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106928:	77 50                	ja     8010697a <inituvm+0x6a>
8010692a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    panic("inituvm: more than a page");
  mem = kalloc();
8010692d:	e8 1e bb ff ff       	call   80102450 <kalloc>
  memset(mem, 0, PGSIZE);
80106932:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106935:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106937:	68 00 10 00 00       	push   $0x1000
8010693c:	6a 00                	push   $0x0
8010693e:	50                   	push   %eax
8010693f:	e8 8c da ff ff       	call   801043d0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106944:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106947:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010694d:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106954:	50                   	push   %eax
80106955:	68 00 10 00 00       	push   $0x1000
8010695a:	6a 00                	push   $0x0
8010695c:	52                   	push   %edx
8010695d:	e8 ee fd ff ff       	call   80106750 <mappages>
  memmove(mem, init, sz);
80106962:	89 75 10             	mov    %esi,0x10(%ebp)
80106965:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106968:	83 c4 20             	add    $0x20,%esp
8010696b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010696e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106971:	5b                   	pop    %ebx
80106972:	5e                   	pop    %esi
80106973:	5f                   	pop    %edi
80106974:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106975:	e9 06 db ff ff       	jmp    80104480 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
8010697a:	83 ec 0c             	sub    $0xc,%esp
8010697d:	68 15 79 10 80       	push   $0x80107915
80106982:	e8 e9 99 ff ff       	call   80100370 <panic>
80106987:	89 f6                	mov    %esi,%esi
80106989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106990 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106990:	55                   	push   %ebp
80106991:	89 e5                	mov    %esp,%ebp
80106993:	57                   	push   %edi
80106994:	56                   	push   %esi
80106995:	53                   	push   %ebx
80106996:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106999:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
801069a0:	0f 85 91 00 00 00    	jne    80106a37 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801069a6:	8b 75 18             	mov    0x18(%ebp),%esi
801069a9:	31 db                	xor    %ebx,%ebx
801069ab:	85 f6                	test   %esi,%esi
801069ad:	75 1a                	jne    801069c9 <loaduvm+0x39>
801069af:	eb 6f                	jmp    80106a20 <loaduvm+0x90>
801069b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069b8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801069be:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801069c4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801069c7:	76 57                	jbe    80106a20 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801069c9:	8b 55 0c             	mov    0xc(%ebp),%edx
801069cc:	8b 45 08             	mov    0x8(%ebp),%eax
801069cf:	31 c9                	xor    %ecx,%ecx
801069d1:	01 da                	add    %ebx,%edx
801069d3:	e8 58 fb ff ff       	call   80106530 <walkpgdir>
801069d8:	85 c0                	test   %eax,%eax
801069da:	74 4e                	je     80106a2a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801069dc:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801069de:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
801069e1:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
801069e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801069eb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801069f1:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801069f4:	01 d9                	add    %ebx,%ecx
801069f6:	05 00 00 00 80       	add    $0x80000000,%eax
801069fb:	57                   	push   %edi
801069fc:	51                   	push   %ecx
801069fd:	50                   	push   %eax
801069fe:	ff 75 10             	pushl  0x10(%ebp)
80106a01:	e8 0a af ff ff       	call   80101910 <readi>
80106a06:	83 c4 10             	add    $0x10,%esp
80106a09:	39 c7                	cmp    %eax,%edi
80106a0b:	74 ab                	je     801069b8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106a0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106a10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106a15:	5b                   	pop    %ebx
80106a16:	5e                   	pop    %esi
80106a17:	5f                   	pop    %edi
80106a18:	5d                   	pop    %ebp
80106a19:	c3                   	ret    
80106a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a20:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106a23:	31 c0                	xor    %eax,%eax
}
80106a25:	5b                   	pop    %ebx
80106a26:	5e                   	pop    %esi
80106a27:	5f                   	pop    %edi
80106a28:	5d                   	pop    %ebp
80106a29:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106a2a:	83 ec 0c             	sub    $0xc,%esp
80106a2d:	68 2f 79 10 80       	push   $0x8010792f
80106a32:	e8 39 99 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106a37:	83 ec 0c             	sub    $0xc,%esp
80106a3a:	68 08 7a 10 80       	push   $0x80107a08
80106a3f:	e8 2c 99 ff ff       	call   80100370 <panic>
80106a44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106a4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106a50 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	57                   	push   %edi
80106a54:	56                   	push   %esi
80106a55:	53                   	push   %ebx
80106a56:	83 ec 0c             	sub    $0xc,%esp
80106a59:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106a5c:	85 ff                	test   %edi,%edi
80106a5e:	0f 88 ca 00 00 00    	js     80106b2e <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80106a64:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106a6a:	0f 82 84 00 00 00    	jb     80106af4 <allocuvm+0xa4>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106a70:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106a76:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106a7c:	39 df                	cmp    %ebx,%edi
80106a7e:	77 45                	ja     80106ac5 <allocuvm+0x75>
80106a80:	e9 bb 00 00 00       	jmp    80106b40 <allocuvm+0xf0>
80106a85:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106a88:	83 ec 04             	sub    $0x4,%esp
80106a8b:	68 00 10 00 00       	push   $0x1000
80106a90:	6a 00                	push   $0x0
80106a92:	50                   	push   %eax
80106a93:	e8 38 d9 ff ff       	call   801043d0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106a98:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106a9e:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106aa5:	50                   	push   %eax
80106aa6:	68 00 10 00 00       	push   $0x1000
80106aab:	53                   	push   %ebx
80106aac:	ff 75 08             	pushl  0x8(%ebp)
80106aaf:	e8 9c fc ff ff       	call   80106750 <mappages>
80106ab4:	83 c4 20             	add    $0x20,%esp
80106ab7:	85 c0                	test   %eax,%eax
80106ab9:	78 45                	js     80106b00 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106abb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106ac1:	39 df                	cmp    %ebx,%edi
80106ac3:	76 7b                	jbe    80106b40 <allocuvm+0xf0>
    mem = kalloc();
80106ac5:	e8 86 b9 ff ff       	call   80102450 <kalloc>
    if(mem == 0){
80106aca:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106acc:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106ace:	75 b8                	jne    80106a88 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106ad0:	83 ec 0c             	sub    $0xc,%esp
80106ad3:	68 4d 79 10 80       	push   $0x8010794d
80106ad8:	e8 83 9b ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106add:	83 c4 10             	add    $0x10,%esp
80106ae0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106ae3:	76 49                	jbe    80106b2e <allocuvm+0xde>
80106ae5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106ae8:	8b 45 08             	mov    0x8(%ebp),%eax
80106aeb:	89 fa                	mov    %edi,%edx
80106aed:	e8 be fa ff ff       	call   801065b0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106af2:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106af4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106af7:	5b                   	pop    %ebx
80106af8:	5e                   	pop    %esi
80106af9:	5f                   	pop    %edi
80106afa:	5d                   	pop    %ebp
80106afb:	c3                   	ret    
80106afc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106b00:	83 ec 0c             	sub    $0xc,%esp
80106b03:	68 65 79 10 80       	push   $0x80107965
80106b08:	e8 53 9b ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106b0d:	83 c4 10             	add    $0x10,%esp
80106b10:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106b13:	76 0d                	jbe    80106b22 <allocuvm+0xd2>
80106b15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106b18:	8b 45 08             	mov    0x8(%ebp),%eax
80106b1b:	89 fa                	mov    %edi,%edx
80106b1d:	e8 8e fa ff ff       	call   801065b0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106b22:	83 ec 0c             	sub    $0xc,%esp
80106b25:	56                   	push   %esi
80106b26:	e8 75 b7 ff ff       	call   801022a0 <kfree>
      return 0;
80106b2b:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
80106b2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106b31:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106b33:	5b                   	pop    %ebx
80106b34:	5e                   	pop    %esi
80106b35:	5f                   	pop    %edi
80106b36:	5d                   	pop    %ebp
80106b37:	c3                   	ret    
80106b38:	90                   	nop
80106b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106b43:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106b45:	5b                   	pop    %ebx
80106b46:	5e                   	pop    %esi
80106b47:	5f                   	pop    %edi
80106b48:	5d                   	pop    %ebp
80106b49:	c3                   	ret    
80106b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106b50 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
80106b53:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b56:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106b59:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106b5c:	39 d1                	cmp    %edx,%ecx
80106b5e:	73 10                	jae    80106b70 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106b60:	5d                   	pop    %ebp
80106b61:	e9 4a fa ff ff       	jmp    801065b0 <deallocuvm.part.0>
80106b66:	8d 76 00             	lea    0x0(%esi),%esi
80106b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106b70:	89 d0                	mov    %edx,%eax
80106b72:	5d                   	pop    %ebp
80106b73:	c3                   	ret    
80106b74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106b80 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106b80:	55                   	push   %ebp
80106b81:	89 e5                	mov    %esp,%ebp
80106b83:	57                   	push   %edi
80106b84:	56                   	push   %esi
80106b85:	53                   	push   %ebx
80106b86:	83 ec 0c             	sub    $0xc,%esp
80106b89:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106b8c:	85 f6                	test   %esi,%esi
80106b8e:	74 59                	je     80106be9 <freevm+0x69>
80106b90:	31 c9                	xor    %ecx,%ecx
80106b92:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106b97:	89 f0                	mov    %esi,%eax
80106b99:	e8 12 fa ff ff       	call   801065b0 <deallocuvm.part.0>
80106b9e:	89 f3                	mov    %esi,%ebx
80106ba0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106ba6:	eb 0f                	jmp    80106bb7 <freevm+0x37>
80106ba8:	90                   	nop
80106ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106bb0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106bb3:	39 fb                	cmp    %edi,%ebx
80106bb5:	74 23                	je     80106bda <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106bb7:	8b 03                	mov    (%ebx),%eax
80106bb9:	a8 01                	test   $0x1,%al
80106bbb:	74 f3                	je     80106bb0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106bbd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106bc2:	83 ec 0c             	sub    $0xc,%esp
80106bc5:	83 c3 04             	add    $0x4,%ebx
80106bc8:	05 00 00 00 80       	add    $0x80000000,%eax
80106bcd:	50                   	push   %eax
80106bce:	e8 cd b6 ff ff       	call   801022a0 <kfree>
80106bd3:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106bd6:	39 fb                	cmp    %edi,%ebx
80106bd8:	75 dd                	jne    80106bb7 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106bda:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106bdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106be0:	5b                   	pop    %ebx
80106be1:	5e                   	pop    %esi
80106be2:	5f                   	pop    %edi
80106be3:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106be4:	e9 b7 b6 ff ff       	jmp    801022a0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106be9:	83 ec 0c             	sub    $0xc,%esp
80106bec:	68 81 79 10 80       	push   $0x80107981
80106bf1:	e8 7a 97 ff ff       	call   80100370 <panic>
80106bf6:	8d 76 00             	lea    0x0(%esi),%esi
80106bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c00 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	56                   	push   %esi
80106c04:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106c05:	e8 46 b8 ff ff       	call   80102450 <kalloc>
80106c0a:	85 c0                	test   %eax,%eax
80106c0c:	74 6a                	je     80106c78 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106c0e:	83 ec 04             	sub    $0x4,%esp
80106c11:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106c13:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106c18:	68 00 10 00 00       	push   $0x1000
80106c1d:	6a 00                	push   $0x0
80106c1f:	50                   	push   %eax
80106c20:	e8 ab d7 ff ff       	call   801043d0 <memset>
80106c25:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106c28:	8b 43 04             	mov    0x4(%ebx),%eax
80106c2b:	8b 53 08             	mov    0x8(%ebx),%edx
80106c2e:	83 ec 0c             	sub    $0xc,%esp
80106c31:	ff 73 0c             	pushl  0xc(%ebx)
80106c34:	29 c2                	sub    %eax,%edx
80106c36:	50                   	push   %eax
80106c37:	52                   	push   %edx
80106c38:	ff 33                	pushl  (%ebx)
80106c3a:	56                   	push   %esi
80106c3b:	e8 10 fb ff ff       	call   80106750 <mappages>
80106c40:	83 c4 20             	add    $0x20,%esp
80106c43:	85 c0                	test   %eax,%eax
80106c45:	78 19                	js     80106c60 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106c47:	83 c3 10             	add    $0x10,%ebx
80106c4a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106c50:	75 d6                	jne    80106c28 <setupkvm+0x28>
80106c52:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106c54:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106c57:	5b                   	pop    %ebx
80106c58:	5e                   	pop    %esi
80106c59:	5d                   	pop    %ebp
80106c5a:	c3                   	ret    
80106c5b:	90                   	nop
80106c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106c60:	83 ec 0c             	sub    $0xc,%esp
80106c63:	56                   	push   %esi
80106c64:	e8 17 ff ff ff       	call   80106b80 <freevm>
      return 0;
80106c69:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
80106c6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80106c6f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80106c71:	5b                   	pop    %ebx
80106c72:	5e                   	pop    %esi
80106c73:	5d                   	pop    %ebp
80106c74:	c3                   	ret    
80106c75:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106c78:	31 c0                	xor    %eax,%eax
80106c7a:	eb d8                	jmp    80106c54 <setupkvm+0x54>
80106c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c80 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106c80:	55                   	push   %ebp
80106c81:	89 e5                	mov    %esp,%ebp
80106c83:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106c86:	e8 75 ff ff ff       	call   80106c00 <setupkvm>
80106c8b:	a3 a4 55 11 80       	mov    %eax,0x801155a4
80106c90:	05 00 00 00 80       	add    $0x80000000,%eax
80106c95:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80106c98:	c9                   	leave  
80106c99:	c3                   	ret    
80106c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ca0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106ca0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ca1:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106ca3:	89 e5                	mov    %esp,%ebp
80106ca5:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106ca8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106cab:	8b 45 08             	mov    0x8(%ebp),%eax
80106cae:	e8 7d f8 ff ff       	call   80106530 <walkpgdir>
  if(pte == 0)
80106cb3:	85 c0                	test   %eax,%eax
80106cb5:	74 05                	je     80106cbc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106cb7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106cba:	c9                   	leave  
80106cbb:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106cbc:	83 ec 0c             	sub    $0xc,%esp
80106cbf:	68 92 79 10 80       	push   $0x80107992
80106cc4:	e8 a7 96 ff ff       	call   80100370 <panic>
80106cc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106cd0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz, uint stack_sz)//cs153 add stack size parameter
{
80106cd0:	55                   	push   %ebp
80106cd1:	89 e5                	mov    %esp,%ebp
80106cd3:	57                   	push   %edi
80106cd4:	56                   	push   %esi
80106cd5:	53                   	push   %ebx
80106cd6:	83 ec 1c             	sub    $0x1c,%esp
  pte_t *pte;
  uint pa, i, flags;
  char *mem;
  //struct proc *curproc = myproc();

  if((d = setupkvm()) == 0)
80106cd9:	e8 22 ff ff ff       	call   80106c00 <setupkvm>
80106cde:	85 c0                	test   %eax,%eax
80106ce0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106ce3:	0f 84 5d 01 00 00    	je     80106e46 <copyuvm+0x176>
    return 0;

  for(i = 0; i < sz; i += PGSIZE){
80106ce9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106cec:	85 c9                	test   %ecx,%ecx
80106cee:	0f 84 a4 00 00 00    	je     80106d98 <copyuvm+0xc8>
80106cf4:	31 f6                	xor    %esi,%esi
80106cf6:	eb 48                	jmp    80106d40 <copyuvm+0x70>
80106cf8:	90                   	nop
80106cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present1");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
   if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106d00:	83 ec 04             	sub    $0x4,%esp
80106d03:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106d09:	68 00 10 00 00       	push   $0x1000
80106d0e:	57                   	push   %edi
80106d0f:	50                   	push   %eax
80106d10:	e8 6b d7 ff ff       	call   80104480 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106d15:	5a                   	pop    %edx
80106d16:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
80106d1c:	ff 75 e4             	pushl  -0x1c(%ebp)
80106d1f:	52                   	push   %edx
80106d20:	68 00 10 00 00       	push   $0x1000
80106d25:	56                   	push   %esi
80106d26:	ff 75 e0             	pushl  -0x20(%ebp)
80106d29:	e8 22 fa ff ff       	call   80106750 <mappages>
80106d2e:	83 c4 20             	add    $0x20,%esp
80106d31:	85 c0                	test   %eax,%eax
80106d33:	78 46                	js     80106d7b <copyuvm+0xab>
  //struct proc *curproc = myproc();

  if((d = setupkvm()) == 0)
    return 0;

  for(i = 0; i < sz; i += PGSIZE){
80106d35:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106d3b:	39 75 0c             	cmp    %esi,0xc(%ebp)
80106d3e:	76 58                	jbe    80106d98 <copyuvm+0xc8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106d40:	8b 45 08             	mov    0x8(%ebp),%eax
80106d43:	31 c9                	xor    %ecx,%ecx
80106d45:	89 f2                	mov    %esi,%edx
80106d47:	e8 e4 f7 ff ff       	call   80106530 <walkpgdir>
80106d4c:	85 c0                	test   %eax,%eax
80106d4e:	0f 84 06 01 00 00    	je     80106e5a <copyuvm+0x18a>
      panic("copyuvm: pte should exist1");
    if(!(*pte & PTE_P))
80106d54:	8b 18                	mov    (%eax),%ebx
80106d56:	f6 c3 01             	test   $0x1,%bl
80106d59:	0f 84 ee 00 00 00    	je     80106e4d <copyuvm+0x17d>
      panic("copyuvm: page not present1");
    pa = PTE_ADDR(*pte);
80106d5f:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80106d61:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80106d67:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist1");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present1");
    pa = PTE_ADDR(*pte);
80106d6a:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
   if((mem = kalloc()) == 0)
80106d70:	e8 db b6 ff ff       	call   80102450 <kalloc>
80106d75:	85 c0                	test   %eax,%eax
80106d77:	89 c3                	mov    %eax,%ebx
80106d79:	75 85                	jne    80106d00 <copyuvm+0x30>
      goto bad; 
  }
  return d;

bad:
  freevm(d);
80106d7b:	83 ec 0c             	sub    $0xc,%esp
80106d7e:	ff 75 e0             	pushl  -0x20(%ebp)
80106d81:	e8 fa fd ff ff       	call   80106b80 <freevm>
  return 0;
80106d86:	83 c4 10             	add    $0x10,%esp
80106d89:	31 c0                	xor    %eax,%eax
}
80106d8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d8e:	5b                   	pop    %ebx
80106d8f:	5e                   	pop    %esi
80106d90:	5f                   	pop    %edi
80106d91:	5d                   	pop    %ebp
80106d92:	c3                   	ret    
80106d93:	90                   	nop
80106d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }

  //cs153 add other for loop to copy last page
  for(i=PGROUNDDOWN(myproc()->tf->esp);i<KERNBASE-4;i+=PGSIZE){
80106d98:	e8 a3 c9 ff ff       	call   80103740 <myproc>
80106d9d:	8b 40 18             	mov    0x18(%eax),%eax
80106da0:	8b 70 44             	mov    0x44(%eax),%esi
80106da3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80106da9:	81 fe fb ff ff 7f    	cmp    $0x7ffffffb,%esi
80106daf:	76 52                	jbe    80106e03 <copyuvm+0x133>
80106db1:	e9 85 00 00 00       	jmp    80106e3b <copyuvm+0x16b>
80106db6:	8d 76 00             	lea    0x0(%esi),%esi
80106db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      panic("copyuvm: page not present2");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106dc0:	83 ec 04             	sub    $0x4,%esp
80106dc3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106dc9:	68 00 10 00 00       	push   $0x1000
80106dce:	57                   	push   %edi
80106dcf:	50                   	push   %eax
80106dd0:	e8 ab d6 ff ff       	call   80104480 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106dd5:	58                   	pop    %eax
80106dd6:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
80106ddc:	ff 75 e4             	pushl  -0x1c(%ebp)
80106ddf:	52                   	push   %edx
80106de0:	68 00 10 00 00       	push   $0x1000
80106de5:	56                   	push   %esi
80106de6:	ff 75 e0             	pushl  -0x20(%ebp)
80106de9:	e8 62 f9 ff ff       	call   80106750 <mappages>
80106dee:	83 c4 20             	add    $0x20,%esp
80106df1:	85 c0                	test   %eax,%eax
80106df3:	78 86                	js     80106d7b <copyuvm+0xab>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }

  //cs153 add other for loop to copy last page
  for(i=PGROUNDDOWN(myproc()->tf->esp);i<KERNBASE-4;i+=PGSIZE){
80106df5:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106dfb:	81 fe fb ff ff 7f    	cmp    $0x7ffffffb,%esi
80106e01:	77 38                	ja     80106e3b <copyuvm+0x16b>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106e03:	8b 45 08             	mov    0x8(%ebp),%eax
80106e06:	31 c9                	xor    %ecx,%ecx
80106e08:	89 f2                	mov    %esi,%edx
80106e0a:	e8 21 f7 ff ff       	call   80106530 <walkpgdir>
80106e0f:	85 c0                	test   %eax,%eax
80106e11:	74 54                	je     80106e67 <copyuvm+0x197>
      panic("copyuvm: pte should exist2");
    if(!(*pte & PTE_P))
80106e13:	8b 18                	mov    (%eax),%ebx
80106e15:	f6 c3 01             	test   $0x1,%bl
80106e18:	74 5a                	je     80106e74 <copyuvm+0x1a4>
      panic("copyuvm: page not present2");
    pa = PTE_ADDR(*pte);
80106e1a:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80106e1c:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80106e22:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(i=PGROUNDDOWN(myproc()->tf->esp);i<KERNBASE-4;i+=PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist2");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present2");
    pa = PTE_ADDR(*pte);
80106e25:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106e2b:	e8 20 b6 ff ff       	call   80102450 <kalloc>
80106e30:	85 c0                	test   %eax,%eax
80106e32:	89 c3                	mov    %eax,%ebx
80106e34:	75 8a                	jne    80106dc0 <copyuvm+0xf0>
80106e36:	e9 40 ff ff ff       	jmp    80106d7b <copyuvm+0xab>
80106e3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80106e3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e41:	5b                   	pop    %ebx
80106e42:	5e                   	pop    %esi
80106e43:	5f                   	pop    %edi
80106e44:	5d                   	pop    %ebp
80106e45:	c3                   	ret    
  uint pa, i, flags;
  char *mem;
  //struct proc *curproc = myproc();

  if((d = setupkvm()) == 0)
    return 0;
80106e46:	31 c0                	xor    %eax,%eax
80106e48:	e9 3e ff ff ff       	jmp    80106d8b <copyuvm+0xbb>

  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist1");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present1");
80106e4d:	83 ec 0c             	sub    $0xc,%esp
80106e50:	68 b7 79 10 80       	push   $0x801079b7
80106e55:	e8 16 95 ff ff       	call   80100370 <panic>
  if((d = setupkvm()) == 0)
    return 0;

  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist1");
80106e5a:	83 ec 0c             	sub    $0xc,%esp
80106e5d:	68 9c 79 10 80       	push   $0x8010799c
80106e62:	e8 09 95 ff ff       	call   80100370 <panic>
  }

  //cs153 add other for loop to copy last page
  for(i=PGROUNDDOWN(myproc()->tf->esp);i<KERNBASE-4;i+=PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist2");
80106e67:	83 ec 0c             	sub    $0xc,%esp
80106e6a:	68 d2 79 10 80       	push   $0x801079d2
80106e6f:	e8 fc 94 ff ff       	call   80100370 <panic>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present2");
80106e74:	83 ec 0c             	sub    $0xc,%esp
80106e77:	68 ed 79 10 80       	push   $0x801079ed
80106e7c:	e8 ef 94 ff ff       	call   80100370 <panic>
80106e81:	eb 0d                	jmp    80106e90 <uva2ka>
80106e83:	90                   	nop
80106e84:	90                   	nop
80106e85:	90                   	nop
80106e86:	90                   	nop
80106e87:	90                   	nop
80106e88:	90                   	nop
80106e89:	90                   	nop
80106e8a:	90                   	nop
80106e8b:	90                   	nop
80106e8c:	90                   	nop
80106e8d:	90                   	nop
80106e8e:	90                   	nop
80106e8f:	90                   	nop

80106e90 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106e90:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e91:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106e93:	89 e5                	mov    %esp,%ebp
80106e95:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e98:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e9b:	8b 45 08             	mov    0x8(%ebp),%eax
80106e9e:	e8 8d f6 ff ff       	call   80106530 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106ea3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80106ea5:	89 c2                	mov    %eax,%edx
80106ea7:	83 e2 05             	and    $0x5,%edx
80106eaa:	83 fa 05             	cmp    $0x5,%edx
80106ead:	75 11                	jne    80106ec0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106eaf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80106eb4:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106eb5:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106eba:	c3                   	ret    
80106ebb:	90                   	nop
80106ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106ec0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106ec2:	c9                   	leave  
80106ec3:	c3                   	ret    
80106ec4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106eca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106ed0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106ed0:	55                   	push   %ebp
80106ed1:	89 e5                	mov    %esp,%ebp
80106ed3:	57                   	push   %edi
80106ed4:	56                   	push   %esi
80106ed5:	53                   	push   %ebx
80106ed6:	83 ec 1c             	sub    $0x1c,%esp
80106ed9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106edc:	8b 55 0c             	mov    0xc(%ebp),%edx
80106edf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106ee2:	85 db                	test   %ebx,%ebx
80106ee4:	75 40                	jne    80106f26 <copyout+0x56>
80106ee6:	eb 70                	jmp    80106f58 <copyout+0x88>
80106ee8:	90                   	nop
80106ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106ef0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106ef3:	89 f1                	mov    %esi,%ecx
80106ef5:	29 d1                	sub    %edx,%ecx
80106ef7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80106efd:	39 d9                	cmp    %ebx,%ecx
80106eff:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106f02:	29 f2                	sub    %esi,%edx
80106f04:	83 ec 04             	sub    $0x4,%esp
80106f07:	01 d0                	add    %edx,%eax
80106f09:	51                   	push   %ecx
80106f0a:	57                   	push   %edi
80106f0b:	50                   	push   %eax
80106f0c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106f0f:	e8 6c d5 ff ff       	call   80104480 <memmove>
    len -= n;
    buf += n;
80106f14:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f17:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
80106f1a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80106f20:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f22:	29 cb                	sub    %ecx,%ebx
80106f24:	74 32                	je     80106f58 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80106f26:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f28:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106f2b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106f2e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f34:	56                   	push   %esi
80106f35:	ff 75 08             	pushl  0x8(%ebp)
80106f38:	e8 53 ff ff ff       	call   80106e90 <uva2ka>
    if(pa0 == 0)
80106f3d:	83 c4 10             	add    $0x10,%esp
80106f40:	85 c0                	test   %eax,%eax
80106f42:	75 ac                	jne    80106ef0 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106f44:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80106f47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80106f4c:	5b                   	pop    %ebx
80106f4d:	5e                   	pop    %esi
80106f4e:	5f                   	pop    %edi
80106f4f:	5d                   	pop    %ebp
80106f50:	c3                   	ret    
80106f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f58:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80106f5b:	31 c0                	xor    %eax,%eax
}
80106f5d:	5b                   	pop    %ebx
80106f5e:	5e                   	pop    %esi
80106f5f:	5f                   	pop    %edi
80106f60:	5d                   	pop    %ebp
80106f61:	c3                   	ret    
80106f62:	66 90                	xchg   %ax,%ax
80106f64:	66 90                	xchg   %ax,%ax
80106f66:	66 90                	xchg   %ax,%ax
80106f68:	66 90                	xchg   %ax,%ax
80106f6a:	66 90                	xchg   %ax,%ax
80106f6c:	66 90                	xchg   %ax,%ax
80106f6e:	66 90                	xchg   %ax,%ax

80106f70 <shminit>:
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
80106f70:	55                   	push   %ebp
80106f71:	89 e5                	mov    %esp,%ebp
80106f73:	83 ec 10             	sub    $0x10,%esp
  int i;
  initlock(&(shm_table.lock), "SHM lock");
80106f76:	68 2c 7a 10 80       	push   $0x80107a2c
80106f7b:	68 c0 55 11 80       	push   $0x801155c0
80106f80:	e8 db d1 ff ff       	call   80104160 <initlock>
  acquire(&(shm_table.lock));
80106f85:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
80106f8c:	e8 cf d2 ff ff       	call   80104260 <acquire>
80106f91:	b8 f4 55 11 80       	mov    $0x801155f4,%eax
80106f96:	83 c4 10             	add    $0x10,%esp
80106f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id =0;
80106fa0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    shm_table.shm_pages[i].frame =0;
80106fa6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
80106fad:	83 c0 0c             	add    $0xc,%eax
    shm_table.shm_pages[i].refcnt =0;
80106fb0:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)

void shminit() {
  int i;
  initlock(&(shm_table.lock), "SHM lock");
  acquire(&(shm_table.lock));
  for (i = 0; i< 64; i++) {
80106fb7:	3d f4 58 11 80       	cmp    $0x801158f4,%eax
80106fbc:	75 e2                	jne    80106fa0 <shminit+0x30>
    shm_table.shm_pages[i].id =0;
    shm_table.shm_pages[i].frame =0;
    shm_table.shm_pages[i].refcnt =0;
  }
  release(&(shm_table.lock));
80106fbe:	83 ec 0c             	sub    $0xc,%esp
80106fc1:	68 c0 55 11 80       	push   $0x801155c0
80106fc6:	e8 b5 d3 ff ff       	call   80104380 <release>
}
80106fcb:	83 c4 10             	add    $0x10,%esp
80106fce:	c9                   	leave  
80106fcf:	c3                   	ret    

80106fd0 <shm_open>:

int shm_open(int id, char **pointer) {
80106fd0:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106fd1:	31 c0                	xor    %eax,%eax
    shm_table.shm_pages[i].refcnt =0;
  }
  release(&(shm_table.lock));
}

int shm_open(int id, char **pointer) {
80106fd3:	89 e5                	mov    %esp,%ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106fd5:	5d                   	pop    %ebp
80106fd6:	c3                   	ret    
80106fd7:	89 f6                	mov    %esi,%esi
80106fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106fe0 <shm_close>:


int shm_close(int id) {
80106fe0:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106fe1:	31 c0                	xor    %eax,%eax

return 0; //added to remove compiler warning -- you should decide what to return
}


int shm_close(int id) {
80106fe3:	89 e5                	mov    %esp,%ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80106fe5:	5d                   	pop    %ebp
80106fe6:	c3                   	ret    
