
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
8010002d:	b8 30 2e 10 80       	mov    $0x80102e30,%eax
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
8010004c:	68 c0 70 10 80       	push   $0x801070c0
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 15 41 00 00       	call   80104170 <initlock>

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
80100092:	68 c7 70 10 80       	push   $0x801070c7
80100097:	50                   	push   %eax
80100098:	e8 c3 3f 00 00       	call   80104060 <initsleeplock>
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
801000e4:	e8 87 41 00 00       	call   80104270 <acquire>

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
80100162:	e8 29 42 00 00       	call   80104390 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 2e 3f 00 00       	call   801040a0 <acquiresleep>
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
8010017e:	e8 3d 1f 00 00       	call   801020c0 <iderw>
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
80100193:	68 ce 70 10 80       	push   $0x801070ce
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
801001ae:	e8 8d 3f 00 00       	call   80104140 <holdingsleep>
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
801001c4:	e9 f7 1e 00 00       	jmp    801020c0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 df 70 10 80       	push   $0x801070df
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
801001ef:	e8 4c 3f 00 00       	call   80104140 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 fc 3e 00 00       	call   80104100 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 60 40 00 00       	call   80104270 <acquire>
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
8010025c:	e9 2f 41 00 00       	jmp    80104390 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 e6 70 10 80       	push   $0x801070e6
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
80100280:	e8 9b 14 00 00       	call   80101720 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 df 3f 00 00       	call   80104270 <acquire>
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
801002bd:	e8 3e 3a 00 00       	call   80103d00 <sleep>

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
801002d2:	e8 79 34 00 00       	call   80103750 <myproc>
801002d7:	8b 40 24             	mov    0x24(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 20 a5 10 80       	push   $0x8010a520
801002e6:	e8 a5 40 00 00       	call   80104390 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 4d 13 00 00       	call   80101640 <ilock>
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
80100346:	e8 45 40 00 00       	call   80104390 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 ed 12 00 00       	call   80101640 <ilock>

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
80100389:	e8 32 23 00 00       	call   801026c0 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 ed 70 10 80       	push   $0x801070ed
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 6f 7a 10 80 	movl   $0x80107a6f,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 d3 3d 00 00       	call   80104190 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 01 71 10 80       	push   $0x80107101
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
8010041a:	e8 11 57 00 00       	call   80105b30 <uartputc>
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
801004d3:	e8 58 56 00 00       	call   80105b30 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 4c 56 00 00       	call   80105b30 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 40 56 00 00       	call   80105b30 <uartputc>
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
80100514:	e8 77 3f 00 00       	call   80104490 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 b2 3e 00 00       	call   801043e0 <memset>
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
80100540:	68 05 71 10 80       	push   $0x80107105
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
801005b1:	0f b6 92 30 71 10 80 	movzbl -0x7fef8ed0(%edx),%edx
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
8010060f:	e8 0c 11 00 00       	call   80101720 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 50 3c 00 00       	call   80104270 <acquire>
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
80100647:	e8 44 3d 00 00       	call   80104390 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 eb 0f 00 00       	call   80101640 <ilock>

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
8010070d:	e8 7e 3c 00 00       	call   80104390 <release>
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
80100788:	b8 18 71 10 80       	mov    $0x80107118,%eax
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
801007c8:	e8 a3 3a 00 00       	call   80104270 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 1f 71 10 80       	push   $0x8010711f
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
80100803:	e8 68 3a 00 00       	call   80104270 <acquire>
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
80100868:	e8 23 3b 00 00       	call   80104390 <release>
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
801008f6:	e8 b5 35 00 00       	call   80103eb0 <wakeup>
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
80100977:	e9 24 36 00 00       	jmp    80103fa0 <procdump>
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
801009a6:	68 28 71 10 80       	push   $0x80107128
801009ab:	68 20 a5 10 80       	push   $0x8010a520
801009b0:	e8 bb 37 00 00       	call   80104170 <initlock>

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
801009d9:	e8 92 18 00 00       	call   80102270 <ioapicenable>
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
801009fc:	e8 4f 2d 00 00       	call   80103750 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a07:	e8 14 21 00 00       	call   80102b20 <begin_op>

  if((ip = namei(path)) == 0){
80100a0c:	83 ec 0c             	sub    $0xc,%esp
80100a0f:	ff 75 08             	pushl  0x8(%ebp)
80100a12:	e8 79 14 00 00       	call   80101e90 <namei>
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
80100a28:	e8 13 0c 00 00       	call   80101640 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a33:	6a 34                	push   $0x34
80100a35:	6a 00                	push   $0x0
80100a37:	50                   	push   %eax
80100a38:	53                   	push   %ebx
80100a39:	e8 e2 0e 00 00       	call   80101920 <readi>
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
80100a4a:	e8 81 0e 00 00       	call   801018d0 <iunlockput>
    end_op();
80100a4f:	e8 3c 21 00 00       	call   80102b90 <end_op>
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
80100a74:	e8 47 62 00 00       	call   80106cc0 <setupkvm>
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
80100ac8:	e8 53 0e 00 00       	call   80101920 <readi>
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
80100b04:	e8 07 60 00 00       	call   80106b10 <allocuvm>
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
80100b3a:	e8 11 5f 00 00       	call   80106a50 <loaduvm>
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
80100b59:	e8 e2 60 00 00       	call   80106c40 <freevm>
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
80100b6a:	e8 61 0d 00 00       	call   801018d0 <iunlockput>
  end_op();
80100b6f:	e8 1c 20 00 00       	call   80102b90 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  //sz = PGROUNDUP(sz);
  if((sp = allocuvm(pgdir, (KERNBASE-4)-PGSIZE, (KERNBASE-4))) == 0)//cs153 bottom (K-4)*PGSZ, top stack(K-4)
80100b74:	83 c4 0c             	add    $0xc,%esp
80100b77:	68 fc ff ff 7f       	push   $0x7ffffffc
80100b7c:	68 fc ef ff 7f       	push   $0x7fffeffc
80100b81:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b87:	e8 84 5f 00 00       	call   80106b10 <allocuvm>
80100b8c:	83 c4 10             	add    $0x10,%esp
80100b8f:	85 c0                	test   %eax,%eax
80100b91:	74 7a                	je     80100c0d <exec+0x21d>
    goto bad;
  sp = KERNBASE-4;//cs153 change stack pointer to top of address space

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
  if((sp = allocuvm(pgdir, (KERNBASE-4)-PGSIZE, (KERNBASE-4))) == 0)//cs153 bottom (K-4)*PGSZ, top stack(K-4)
    goto bad;
  sp = KERNBASE-4;//cs153 change stack pointer to top of address space

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
  if((sp = allocuvm(pgdir, (KERNBASE-4)-PGSIZE, (KERNBASE-4))) == 0)//cs153 bottom (K-4)*PGSZ, top stack(K-4)
    goto bad;
  sp = KERNBASE-4;//cs153 change stack pointer to top of address space

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
80100bdb:	e8 40 3a 00 00       	call   80104620 <strlen>
80100be0:	f7 d0                	not    %eax
80100be2:	01 d8                	add    %ebx,%eax
80100be4:	83 e0 fc             	and    $0xfffffffc,%eax
80100be7:	89 c3                	mov    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100be9:	58                   	pop    %eax
80100bea:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bed:	ff 34 b0             	pushl  (%eax,%esi,4)
80100bf0:	e8 2b 3a 00 00       	call   80104620 <strlen>
80100bf5:	83 c0 01             	add    $0x1,%eax
80100bf8:	50                   	push   %eax
80100bf9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bfc:	ff 34 b0             	pushl  (%eax,%esi,4)
80100bff:	53                   	push   %ebx
80100c00:	57                   	push   %edi
80100c01:	e8 8a 63 00 00       	call   80106f90 <copyout>
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
80100c16:	e8 25 60 00 00       	call   80106c40 <freevm>
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
80100c28:	e8 63 1f 00 00       	call   80102b90 <end_op>
    cprintf("exec: fail\n");
80100c2d:	83 ec 0c             	sub    $0xc,%esp
80100c30:	68 41 71 10 80       	push   $0x80107141
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
80100c81:	e8 0a 63 00 00       	call   80106f90 <copyout>
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
80100cc7:	e8 14 39 00 00       	call   801045e0 <safestrcpy>

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
  curproc->stack_sz = (PGROUNDDOWN(myproc()->tf->esp));//cs153 keep track of bottom of stack
80100cf2:	e8 59 2a 00 00       	call   80103750 <myproc>
80100cf7:	8b 40 18             	mov    0x18(%eax),%eax
80100cfa:	8b 40 44             	mov    0x44(%eax),%eax
80100cfd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d02:	89 47 7c             	mov    %eax,0x7c(%edi)
  switchuvm(curproc);
80100d05:	89 3c 24             	mov    %edi,(%esp)
80100d08:	e8 b3 5b 00 00       	call   801068c0 <switchuvm>
  freevm(oldpgdir);
80100d0d:	89 34 24             	mov    %esi,(%esp)
80100d10:	e8 2b 5f 00 00       	call   80106c40 <freevm>
  return 0;
80100d15:	83 c4 10             	add    $0x10,%esp
80100d18:	31 c0                	xor    %eax,%eax
80100d1a:	e9 3d fd ff ff       	jmp    80100a5c <exec+0x6c>
80100d1f:	90                   	nop

80100d20 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d20:	55                   	push   %ebp
80100d21:	89 e5                	mov    %esp,%ebp
80100d23:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d26:	68 4d 71 10 80       	push   $0x8010714d
80100d2b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d30:	e8 3b 34 00 00       	call   80104170 <initlock>
}
80100d35:	83 c4 10             	add    $0x10,%esp
80100d38:	c9                   	leave  
80100d39:	c3                   	ret    
80100d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d40 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d40:	55                   	push   %ebp
80100d41:	89 e5                	mov    %esp,%ebp
80100d43:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d44:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d49:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d4c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d51:	e8 1a 35 00 00       	call   80104270 <acquire>
80100d56:	83 c4 10             	add    $0x10,%esp
80100d59:	eb 10                	jmp    80100d6b <filealloc+0x2b>
80100d5b:	90                   	nop
80100d5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d60:	83 c3 18             	add    $0x18,%ebx
80100d63:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d69:	74 25                	je     80100d90 <filealloc+0x50>
    if(f->ref == 0){
80100d6b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d6e:	85 c0                	test   %eax,%eax
80100d70:	75 ee                	jne    80100d60 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100d72:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100d75:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100d7c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d81:	e8 0a 36 00 00       	call   80104390 <release>
      return f;
80100d86:	89 d8                	mov    %ebx,%eax
80100d88:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100d8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100d8e:	c9                   	leave  
80100d8f:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100d90:	83 ec 0c             	sub    $0xc,%esp
80100d93:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d98:	e8 f3 35 00 00       	call   80104390 <release>
  return 0;
80100d9d:	83 c4 10             	add    $0x10,%esp
80100da0:	31 c0                	xor    %eax,%eax
}
80100da2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100da5:	c9                   	leave  
80100da6:	c3                   	ret    
80100da7:	89 f6                	mov    %esi,%esi
80100da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100db0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100db0:	55                   	push   %ebp
80100db1:	89 e5                	mov    %esp,%ebp
80100db3:	53                   	push   %ebx
80100db4:	83 ec 10             	sub    $0x10,%esp
80100db7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dba:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dbf:	e8 ac 34 00 00       	call   80104270 <acquire>
  if(f->ref < 1)
80100dc4:	8b 43 04             	mov    0x4(%ebx),%eax
80100dc7:	83 c4 10             	add    $0x10,%esp
80100dca:	85 c0                	test   %eax,%eax
80100dcc:	7e 1a                	jle    80100de8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dce:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100dd1:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100dd4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100dd7:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ddc:	e8 af 35 00 00       	call   80104390 <release>
  return f;
}
80100de1:	89 d8                	mov    %ebx,%eax
80100de3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de6:	c9                   	leave  
80100de7:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100de8:	83 ec 0c             	sub    $0xc,%esp
80100deb:	68 54 71 10 80       	push   $0x80107154
80100df0:	e8 7b f5 ff ff       	call   80100370 <panic>
80100df5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e00 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e00:	55                   	push   %ebp
80100e01:	89 e5                	mov    %esp,%ebp
80100e03:	57                   	push   %edi
80100e04:	56                   	push   %esi
80100e05:	53                   	push   %ebx
80100e06:	83 ec 28             	sub    $0x28,%esp
80100e09:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e0c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e11:	e8 5a 34 00 00       	call   80104270 <acquire>
  if(f->ref < 1)
80100e16:	8b 47 04             	mov    0x4(%edi),%eax
80100e19:	83 c4 10             	add    $0x10,%esp
80100e1c:	85 c0                	test   %eax,%eax
80100e1e:	0f 8e 9b 00 00 00    	jle    80100ebf <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e24:	83 e8 01             	sub    $0x1,%eax
80100e27:	85 c0                	test   %eax,%eax
80100e29:	89 47 04             	mov    %eax,0x4(%edi)
80100e2c:	74 1a                	je     80100e48 <fileclose+0x48>
    release(&ftable.lock);
80100e2e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e38:	5b                   	pop    %ebx
80100e39:	5e                   	pop    %esi
80100e3a:	5f                   	pop    %edi
80100e3b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e3c:	e9 4f 35 00 00       	jmp    80104390 <release>
80100e41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e48:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e4c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e4e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e51:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e54:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e5a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e5d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e60:	68 c0 ff 10 80       	push   $0x8010ffc0
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e65:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e68:	e8 23 35 00 00       	call   80104390 <release>

  if(ff.type == FD_PIPE)
80100e6d:	83 c4 10             	add    $0x10,%esp
80100e70:	83 fb 01             	cmp    $0x1,%ebx
80100e73:	74 13                	je     80100e88 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e75:	83 fb 02             	cmp    $0x2,%ebx
80100e78:	74 26                	je     80100ea0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e7d:	5b                   	pop    %ebx
80100e7e:	5e                   	pop    %esi
80100e7f:	5f                   	pop    %edi
80100e80:	5d                   	pop    %ebp
80100e81:	c3                   	ret    
80100e82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100e88:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100e8c:	83 ec 08             	sub    $0x8,%esp
80100e8f:	53                   	push   %ebx
80100e90:	56                   	push   %esi
80100e91:	e8 2a 24 00 00       	call   801032c0 <pipeclose>
80100e96:	83 c4 10             	add    $0x10,%esp
80100e99:	eb df                	jmp    80100e7a <fileclose+0x7a>
80100e9b:	90                   	nop
80100e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ea0:	e8 7b 1c 00 00       	call   80102b20 <begin_op>
    iput(ff.ip);
80100ea5:	83 ec 0c             	sub    $0xc,%esp
80100ea8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eab:	e8 c0 08 00 00       	call   80101770 <iput>
    end_op();
80100eb0:	83 c4 10             	add    $0x10,%esp
  }
}
80100eb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100eb6:	5b                   	pop    %ebx
80100eb7:	5e                   	pop    %esi
80100eb8:	5f                   	pop    %edi
80100eb9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100eba:	e9 d1 1c 00 00       	jmp    80102b90 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100ebf:	83 ec 0c             	sub    $0xc,%esp
80100ec2:	68 5c 71 10 80       	push   $0x8010715c
80100ec7:	e8 a4 f4 ff ff       	call   80100370 <panic>
80100ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ed0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ed0:	55                   	push   %ebp
80100ed1:	89 e5                	mov    %esp,%ebp
80100ed3:	53                   	push   %ebx
80100ed4:	83 ec 04             	sub    $0x4,%esp
80100ed7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100eda:	83 3b 02             	cmpl   $0x2,(%ebx)
80100edd:	75 31                	jne    80100f10 <filestat+0x40>
    ilock(f->ip);
80100edf:	83 ec 0c             	sub    $0xc,%esp
80100ee2:	ff 73 10             	pushl  0x10(%ebx)
80100ee5:	e8 56 07 00 00       	call   80101640 <ilock>
    stati(f->ip, st);
80100eea:	58                   	pop    %eax
80100eeb:	5a                   	pop    %edx
80100eec:	ff 75 0c             	pushl  0xc(%ebp)
80100eef:	ff 73 10             	pushl  0x10(%ebx)
80100ef2:	e8 f9 09 00 00       	call   801018f0 <stati>
    iunlock(f->ip);
80100ef7:	59                   	pop    %ecx
80100ef8:	ff 73 10             	pushl  0x10(%ebx)
80100efb:	e8 20 08 00 00       	call   80101720 <iunlock>
    return 0;
80100f00:	83 c4 10             	add    $0x10,%esp
80100f03:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f05:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f08:	c9                   	leave  
80100f09:	c3                   	ret    
80100f0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f18:	c9                   	leave  
80100f19:	c3                   	ret    
80100f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f20 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	57                   	push   %edi
80100f24:	56                   	push   %esi
80100f25:	53                   	push   %ebx
80100f26:	83 ec 0c             	sub    $0xc,%esp
80100f29:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f2f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f32:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f36:	74 60                	je     80100f98 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f38:	8b 03                	mov    (%ebx),%eax
80100f3a:	83 f8 01             	cmp    $0x1,%eax
80100f3d:	74 41                	je     80100f80 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f3f:	83 f8 02             	cmp    $0x2,%eax
80100f42:	75 5b                	jne    80100f9f <fileread+0x7f>
    ilock(f->ip);
80100f44:	83 ec 0c             	sub    $0xc,%esp
80100f47:	ff 73 10             	pushl  0x10(%ebx)
80100f4a:	e8 f1 06 00 00       	call   80101640 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f4f:	57                   	push   %edi
80100f50:	ff 73 14             	pushl  0x14(%ebx)
80100f53:	56                   	push   %esi
80100f54:	ff 73 10             	pushl  0x10(%ebx)
80100f57:	e8 c4 09 00 00       	call   80101920 <readi>
80100f5c:	83 c4 20             	add    $0x20,%esp
80100f5f:	85 c0                	test   %eax,%eax
80100f61:	89 c6                	mov    %eax,%esi
80100f63:	7e 03                	jle    80100f68 <fileread+0x48>
      f->off += r;
80100f65:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f68:	83 ec 0c             	sub    $0xc,%esp
80100f6b:	ff 73 10             	pushl  0x10(%ebx)
80100f6e:	e8 ad 07 00 00       	call   80101720 <iunlock>
    return r;
80100f73:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f76:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f7b:	5b                   	pop    %ebx
80100f7c:	5e                   	pop    %esi
80100f7d:	5f                   	pop    %edi
80100f7e:	5d                   	pop    %ebp
80100f7f:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f80:	8b 43 0c             	mov    0xc(%ebx),%eax
80100f83:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f89:	5b                   	pop    %ebx
80100f8a:	5e                   	pop    %esi
80100f8b:	5f                   	pop    %edi
80100f8c:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100f8d:	e9 ce 24 00 00       	jmp    80103460 <piperead>
80100f92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100f98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f9d:	eb d9                	jmp    80100f78 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100f9f:	83 ec 0c             	sub    $0xc,%esp
80100fa2:	68 66 71 10 80       	push   $0x80107166
80100fa7:	e8 c4 f3 ff ff       	call   80100370 <panic>
80100fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fb0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fb0:	55                   	push   %ebp
80100fb1:	89 e5                	mov    %esp,%ebp
80100fb3:	57                   	push   %edi
80100fb4:	56                   	push   %esi
80100fb5:	53                   	push   %ebx
80100fb6:	83 ec 1c             	sub    $0x1c,%esp
80100fb9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fbf:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fc3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100fc6:	8b 45 10             	mov    0x10(%ebp),%eax
80100fc9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100fcc:	0f 84 aa 00 00 00    	je     8010107c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80100fd2:	8b 06                	mov    (%esi),%eax
80100fd4:	83 f8 01             	cmp    $0x1,%eax
80100fd7:	0f 84 c2 00 00 00    	je     8010109f <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100fdd:	83 f8 02             	cmp    $0x2,%eax
80100fe0:	0f 85 d8 00 00 00    	jne    801010be <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100fe6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100fe9:	31 ff                	xor    %edi,%edi
80100feb:	85 c0                	test   %eax,%eax
80100fed:	7f 34                	jg     80101023 <filewrite+0x73>
80100fef:	e9 9c 00 00 00       	jmp    80101090 <filewrite+0xe0>
80100ff4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80100ff8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80100ffb:	83 ec 0c             	sub    $0xc,%esp
80100ffe:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101001:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101004:	e8 17 07 00 00       	call   80101720 <iunlock>
      end_op();
80101009:	e8 82 1b 00 00       	call   80102b90 <end_op>
8010100e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101011:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101014:	39 d8                	cmp    %ebx,%eax
80101016:	0f 85 95 00 00 00    	jne    801010b1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010101c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010101e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101021:	7e 6d                	jle    80101090 <filewrite+0xe0>
      int n1 = n - i;
80101023:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101026:	b8 00 1a 00 00       	mov    $0x1a00,%eax
8010102b:	29 fb                	sub    %edi,%ebx
8010102d:	81 fb 00 1a 00 00    	cmp    $0x1a00,%ebx
80101033:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101036:	e8 e5 1a 00 00       	call   80102b20 <begin_op>
      ilock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
80101041:	e8 fa 05 00 00       	call   80101640 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101046:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101049:	53                   	push   %ebx
8010104a:	ff 76 14             	pushl  0x14(%esi)
8010104d:	01 f8                	add    %edi,%eax
8010104f:	50                   	push   %eax
80101050:	ff 76 10             	pushl  0x10(%esi)
80101053:	e8 c8 09 00 00       	call   80101a20 <writei>
80101058:	83 c4 20             	add    $0x20,%esp
8010105b:	85 c0                	test   %eax,%eax
8010105d:	7f 99                	jg     80100ff8 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010105f:	83 ec 0c             	sub    $0xc,%esp
80101062:	ff 76 10             	pushl  0x10(%esi)
80101065:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101068:	e8 b3 06 00 00       	call   80101720 <iunlock>
      end_op();
8010106d:	e8 1e 1b 00 00       	call   80102b90 <end_op>

      if(r < 0)
80101072:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101075:	83 c4 10             	add    $0x10,%esp
80101078:	85 c0                	test   %eax,%eax
8010107a:	74 98                	je     80101014 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010107c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
8010107f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101084:	5b                   	pop    %ebx
80101085:	5e                   	pop    %esi
80101086:	5f                   	pop    %edi
80101087:	5d                   	pop    %ebp
80101088:	c3                   	ret    
80101089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101090:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101093:	75 e7                	jne    8010107c <filewrite+0xcc>
  }
  panic("filewrite");
}
80101095:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101098:	89 f8                	mov    %edi,%eax
8010109a:	5b                   	pop    %ebx
8010109b:	5e                   	pop    %esi
8010109c:	5f                   	pop    %edi
8010109d:	5d                   	pop    %ebp
8010109e:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
8010109f:	8b 46 0c             	mov    0xc(%esi),%eax
801010a2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a8:	5b                   	pop    %ebx
801010a9:	5e                   	pop    %esi
801010aa:	5f                   	pop    %edi
801010ab:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010ac:	e9 af 22 00 00       	jmp    80103360 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010b1:	83 ec 0c             	sub    $0xc,%esp
801010b4:	68 6f 71 10 80       	push   $0x8010716f
801010b9:	e8 b2 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010be:	83 ec 0c             	sub    $0xc,%esp
801010c1:	68 75 71 10 80       	push   $0x80107175
801010c6:	e8 a5 f2 ff ff       	call   80100370 <panic>
801010cb:	66 90                	xchg   %ax,%ax
801010cd:	66 90                	xchg   %ax,%ax
801010cf:	90                   	nop

801010d0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010d0:	55                   	push   %ebp
801010d1:	89 e5                	mov    %esp,%ebp
801010d3:	57                   	push   %edi
801010d4:	56                   	push   %esi
801010d5:	53                   	push   %ebx
801010d6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010d9:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801010df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801010e2:	85 c9                	test   %ecx,%ecx
801010e4:	0f 84 85 00 00 00    	je     8010116f <balloc+0x9f>
801010ea:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801010f1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801010f4:	83 ec 08             	sub    $0x8,%esp
801010f7:	89 f0                	mov    %esi,%eax
801010f9:	c1 f8 0c             	sar    $0xc,%eax
801010fc:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101102:	50                   	push   %eax
80101103:	ff 75 d8             	pushl  -0x28(%ebp)
80101106:	e8 c5 ef ff ff       	call   801000d0 <bread>
8010110b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010110e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101113:	83 c4 10             	add    $0x10,%esp
80101116:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101119:	31 c0                	xor    %eax,%eax
8010111b:	eb 2d                	jmp    8010114a <balloc+0x7a>
8010111d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101120:	89 c1                	mov    %eax,%ecx
80101122:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101127:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010112a:	83 e1 07             	and    $0x7,%ecx
8010112d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010112f:	89 c1                	mov    %eax,%ecx
80101131:	c1 f9 03             	sar    $0x3,%ecx
80101134:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101139:	85 d7                	test   %edx,%edi
8010113b:	74 43                	je     80101180 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010113d:	83 c0 01             	add    $0x1,%eax
80101140:	83 c6 01             	add    $0x1,%esi
80101143:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101148:	74 05                	je     8010114f <balloc+0x7f>
8010114a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010114d:	72 d1                	jb     80101120 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010114f:	83 ec 0c             	sub    $0xc,%esp
80101152:	ff 75 e4             	pushl  -0x1c(%ebp)
80101155:	e8 86 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010115a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101161:	83 c4 10             	add    $0x10,%esp
80101164:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101167:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010116d:	77 82                	ja     801010f1 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010116f:	83 ec 0c             	sub    $0xc,%esp
80101172:	68 7f 71 10 80       	push   $0x8010717f
80101177:	e8 f4 f1 ff ff       	call   80100370 <panic>
8010117c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101180:	09 fa                	or     %edi,%edx
80101182:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101185:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
80101188:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010118c:	57                   	push   %edi
8010118d:	e8 6e 1b 00 00       	call   80102d00 <log_write>
        brelse(bp);
80101192:	89 3c 24             	mov    %edi,(%esp)
80101195:	e8 46 f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
8010119a:	58                   	pop    %eax
8010119b:	5a                   	pop    %edx
8010119c:	56                   	push   %esi
8010119d:	ff 75 d8             	pushl  -0x28(%ebp)
801011a0:	e8 2b ef ff ff       	call   801000d0 <bread>
801011a5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011a7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011aa:	83 c4 0c             	add    $0xc,%esp
801011ad:	68 00 02 00 00       	push   $0x200
801011b2:	6a 00                	push   $0x0
801011b4:	50                   	push   %eax
801011b5:	e8 26 32 00 00       	call   801043e0 <memset>
  log_write(bp);
801011ba:	89 1c 24             	mov    %ebx,(%esp)
801011bd:	e8 3e 1b 00 00       	call   80102d00 <log_write>
  brelse(bp);
801011c2:	89 1c 24             	mov    %ebx,(%esp)
801011c5:	e8 16 f0 ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801011ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011cd:	89 f0                	mov    %esi,%eax
801011cf:	5b                   	pop    %ebx
801011d0:	5e                   	pop    %esi
801011d1:	5f                   	pop    %edi
801011d2:	5d                   	pop    %ebp
801011d3:	c3                   	ret    
801011d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801011da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801011e0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011e0:	55                   	push   %ebp
801011e1:	89 e5                	mov    %esp,%ebp
801011e3:	57                   	push   %edi
801011e4:	56                   	push   %esi
801011e5:	53                   	push   %ebx
801011e6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801011e8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011ea:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801011ef:	83 ec 28             	sub    $0x28,%esp
801011f2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
801011f5:	68 e0 09 11 80       	push   $0x801109e0
801011fa:	e8 71 30 00 00       	call   80104270 <acquire>
801011ff:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101202:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101205:	eb 1b                	jmp    80101222 <iget+0x42>
80101207:	89 f6                	mov    %esi,%esi
80101209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101210:	85 f6                	test   %esi,%esi
80101212:	74 44                	je     80101258 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101214:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010121a:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101220:	74 4e                	je     80101270 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101222:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101225:	85 c9                	test   %ecx,%ecx
80101227:	7e e7                	jle    80101210 <iget+0x30>
80101229:	39 3b                	cmp    %edi,(%ebx)
8010122b:	75 e3                	jne    80101210 <iget+0x30>
8010122d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101230:	75 de                	jne    80101210 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101232:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101235:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101238:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010123a:	68 e0 09 11 80       	push   $0x801109e0

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010123f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101242:	e8 49 31 00 00       	call   80104390 <release>
      return ip;
80101247:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010124a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010124d:	89 f0                	mov    %esi,%eax
8010124f:	5b                   	pop    %ebx
80101250:	5e                   	pop    %esi
80101251:	5f                   	pop    %edi
80101252:	5d                   	pop    %ebp
80101253:	c3                   	ret    
80101254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101258:	85 c9                	test   %ecx,%ecx
8010125a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010125d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101263:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101269:	75 b7                	jne    80101222 <iget+0x42>
8010126b:	90                   	nop
8010126c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101270:	85 f6                	test   %esi,%esi
80101272:	74 2d                	je     801012a1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101274:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
80101277:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101279:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010127c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101283:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010128a:	68 e0 09 11 80       	push   $0x801109e0
8010128f:	e8 fc 30 00 00       	call   80104390 <release>

  return ip;
80101294:	83 c4 10             	add    $0x10,%esp
}
80101297:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010129a:	89 f0                	mov    %esi,%eax
8010129c:	5b                   	pop    %ebx
8010129d:	5e                   	pop    %esi
8010129e:	5f                   	pop    %edi
8010129f:	5d                   	pop    %ebp
801012a0:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012a1:	83 ec 0c             	sub    $0xc,%esp
801012a4:	68 95 71 10 80       	push   $0x80107195
801012a9:	e8 c2 f0 ff ff       	call   80100370 <panic>
801012ae:	66 90                	xchg   %ax,%ax

801012b0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012b0:	55                   	push   %ebp
801012b1:	89 e5                	mov    %esp,%ebp
801012b3:	57                   	push   %edi
801012b4:	56                   	push   %esi
801012b5:	53                   	push   %ebx
801012b6:	89 c6                	mov    %eax,%esi
801012b8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012bb:	83 fa 0b             	cmp    $0xb,%edx
801012be:	77 18                	ja     801012d8 <bmap+0x28>
801012c0:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
801012c3:	8b 43 5c             	mov    0x5c(%ebx),%eax
801012c6:	85 c0                	test   %eax,%eax
801012c8:	74 76                	je     80101340 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012cd:	5b                   	pop    %ebx
801012ce:	5e                   	pop    %esi
801012cf:	5f                   	pop    %edi
801012d0:	5d                   	pop    %ebp
801012d1:	c3                   	ret    
801012d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801012d8:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801012db:	83 fb 7f             	cmp    $0x7f,%ebx
801012de:	0f 87 83 00 00 00    	ja     80101367 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801012e4:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801012ea:	85 c0                	test   %eax,%eax
801012ec:	74 6a                	je     80101358 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801012ee:	83 ec 08             	sub    $0x8,%esp
801012f1:	50                   	push   %eax
801012f2:	ff 36                	pushl  (%esi)
801012f4:	e8 d7 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801012f9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801012fd:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101300:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101302:	8b 1a                	mov    (%edx),%ebx
80101304:	85 db                	test   %ebx,%ebx
80101306:	75 1d                	jne    80101325 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101308:	8b 06                	mov    (%esi),%eax
8010130a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010130d:	e8 be fd ff ff       	call   801010d0 <balloc>
80101312:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101315:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101318:	89 c3                	mov    %eax,%ebx
8010131a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010131c:	57                   	push   %edi
8010131d:	e8 de 19 00 00       	call   80102d00 <log_write>
80101322:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101325:	83 ec 0c             	sub    $0xc,%esp
80101328:	57                   	push   %edi
80101329:	e8 b2 ee ff ff       	call   801001e0 <brelse>
8010132e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101331:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101334:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101336:	5b                   	pop    %ebx
80101337:	5e                   	pop    %esi
80101338:	5f                   	pop    %edi
80101339:	5d                   	pop    %ebp
8010133a:	c3                   	ret    
8010133b:	90                   	nop
8010133c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101340:	8b 06                	mov    (%esi),%eax
80101342:	e8 89 fd ff ff       	call   801010d0 <balloc>
80101347:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010134a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010134d:	5b                   	pop    %ebx
8010134e:	5e                   	pop    %esi
8010134f:	5f                   	pop    %edi
80101350:	5d                   	pop    %ebp
80101351:	c3                   	ret    
80101352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101358:	8b 06                	mov    (%esi),%eax
8010135a:	e8 71 fd ff ff       	call   801010d0 <balloc>
8010135f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101365:	eb 87                	jmp    801012ee <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101367:	83 ec 0c             	sub    $0xc,%esp
8010136a:	68 a5 71 10 80       	push   $0x801071a5
8010136f:	e8 fc ef ff ff       	call   80100370 <panic>
80101374:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010137a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101380 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101380:	55                   	push   %ebp
80101381:	89 e5                	mov    %esp,%ebp
80101383:	56                   	push   %esi
80101384:	53                   	push   %ebx
80101385:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
80101388:	83 ec 08             	sub    $0x8,%esp
8010138b:	6a 01                	push   $0x1
8010138d:	ff 75 08             	pushl  0x8(%ebp)
80101390:	e8 3b ed ff ff       	call   801000d0 <bread>
80101395:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101397:	8d 40 5c             	lea    0x5c(%eax),%eax
8010139a:	83 c4 0c             	add    $0xc,%esp
8010139d:	6a 1c                	push   $0x1c
8010139f:	50                   	push   %eax
801013a0:	56                   	push   %esi
801013a1:	e8 ea 30 00 00       	call   80104490 <memmove>
  brelse(bp);
801013a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013a9:	83 c4 10             	add    $0x10,%esp
}
801013ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013af:	5b                   	pop    %ebx
801013b0:	5e                   	pop    %esi
801013b1:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013b2:	e9 29 ee ff ff       	jmp    801001e0 <brelse>
801013b7:	89 f6                	mov    %esi,%esi
801013b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013c0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013c0:	55                   	push   %ebp
801013c1:	89 e5                	mov    %esp,%ebp
801013c3:	56                   	push   %esi
801013c4:	53                   	push   %ebx
801013c5:	89 d3                	mov    %edx,%ebx
801013c7:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013c9:	83 ec 08             	sub    $0x8,%esp
801013cc:	68 c0 09 11 80       	push   $0x801109c0
801013d1:	50                   	push   %eax
801013d2:	e8 a9 ff ff ff       	call   80101380 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801013d7:	58                   	pop    %eax
801013d8:	5a                   	pop    %edx
801013d9:	89 da                	mov    %ebx,%edx
801013db:	c1 ea 0c             	shr    $0xc,%edx
801013de:	03 15 d8 09 11 80    	add    0x801109d8,%edx
801013e4:	52                   	push   %edx
801013e5:	56                   	push   %esi
801013e6:	e8 e5 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801013eb:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801013ed:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
801013f3:	ba 01 00 00 00       	mov    $0x1,%edx
801013f8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801013fb:	c1 fb 03             	sar    $0x3,%ebx
801013fe:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101401:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101403:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101408:	85 d1                	test   %edx,%ecx
8010140a:	74 27                	je     80101433 <bfree+0x73>
8010140c:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010140e:	f7 d2                	not    %edx
80101410:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101412:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101415:	21 d0                	and    %edx,%eax
80101417:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010141b:	56                   	push   %esi
8010141c:	e8 df 18 00 00       	call   80102d00 <log_write>
  brelse(bp);
80101421:	89 34 24             	mov    %esi,(%esp)
80101424:	e8 b7 ed ff ff       	call   801001e0 <brelse>
}
80101429:	83 c4 10             	add    $0x10,%esp
8010142c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010142f:	5b                   	pop    %ebx
80101430:	5e                   	pop    %esi
80101431:	5d                   	pop    %ebp
80101432:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101433:	83 ec 0c             	sub    $0xc,%esp
80101436:	68 b8 71 10 80       	push   $0x801071b8
8010143b:	e8 30 ef ff ff       	call   80100370 <panic>

80101440 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101440:	55                   	push   %ebp
80101441:	89 e5                	mov    %esp,%ebp
80101443:	53                   	push   %ebx
80101444:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101449:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010144c:	68 cb 71 10 80       	push   $0x801071cb
80101451:	68 e0 09 11 80       	push   $0x801109e0
80101456:	e8 15 2d 00 00       	call   80104170 <initlock>
8010145b:	83 c4 10             	add    $0x10,%esp
8010145e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101460:	83 ec 08             	sub    $0x8,%esp
80101463:	68 d2 71 10 80       	push   $0x801071d2
80101468:	53                   	push   %ebx
80101469:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010146f:	e8 ec 2b 00 00       	call   80104060 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
80101474:	83 c4 10             	add    $0x10,%esp
80101477:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010147d:	75 e1                	jne    80101460 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
8010147f:	83 ec 08             	sub    $0x8,%esp
80101482:	68 c0 09 11 80       	push   $0x801109c0
80101487:	ff 75 08             	pushl  0x8(%ebp)
8010148a:	e8 f1 fe ff ff       	call   80101380 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010148f:	ff 35 d8 09 11 80    	pushl  0x801109d8
80101495:	ff 35 d4 09 11 80    	pushl  0x801109d4
8010149b:	ff 35 d0 09 11 80    	pushl  0x801109d0
801014a1:	ff 35 cc 09 11 80    	pushl  0x801109cc
801014a7:	ff 35 c8 09 11 80    	pushl  0x801109c8
801014ad:	ff 35 c4 09 11 80    	pushl  0x801109c4
801014b3:	ff 35 c0 09 11 80    	pushl  0x801109c0
801014b9:	68 38 72 10 80       	push   $0x80107238
801014be:	e8 9d f1 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801014c3:	83 c4 30             	add    $0x30,%esp
801014c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014c9:	c9                   	leave  
801014ca:	c3                   	ret    
801014cb:	90                   	nop
801014cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801014d0 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801014d0:	55                   	push   %ebp
801014d1:	89 e5                	mov    %esp,%ebp
801014d3:	57                   	push   %edi
801014d4:	56                   	push   %esi
801014d5:	53                   	push   %ebx
801014d6:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014d9:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801014e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801014e3:	8b 75 08             	mov    0x8(%ebp),%esi
801014e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801014e9:	0f 86 91 00 00 00    	jbe    80101580 <ialloc+0xb0>
801014ef:	bb 01 00 00 00       	mov    $0x1,%ebx
801014f4:	eb 21                	jmp    80101517 <ialloc+0x47>
801014f6:	8d 76 00             	lea    0x0(%esi),%esi
801014f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101500:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101503:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101506:	57                   	push   %edi
80101507:	e8 d4 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010150c:	83 c4 10             	add    $0x10,%esp
8010150f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101515:	76 69                	jbe    80101580 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101517:	89 d8                	mov    %ebx,%eax
80101519:	83 ec 08             	sub    $0x8,%esp
8010151c:	c1 e8 03             	shr    $0x3,%eax
8010151f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101525:	50                   	push   %eax
80101526:	56                   	push   %esi
80101527:	e8 a4 eb ff ff       	call   801000d0 <bread>
8010152c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010152e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101530:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101533:	83 e0 07             	and    $0x7,%eax
80101536:	c1 e0 06             	shl    $0x6,%eax
80101539:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010153d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101541:	75 bd                	jne    80101500 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101543:	83 ec 04             	sub    $0x4,%esp
80101546:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101549:	6a 40                	push   $0x40
8010154b:	6a 00                	push   $0x0
8010154d:	51                   	push   %ecx
8010154e:	e8 8d 2e 00 00       	call   801043e0 <memset>
      dip->type = type;
80101553:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101557:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010155a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010155d:	89 3c 24             	mov    %edi,(%esp)
80101560:	e8 9b 17 00 00       	call   80102d00 <log_write>
      brelse(bp);
80101565:	89 3c 24             	mov    %edi,(%esp)
80101568:	e8 73 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010156d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101570:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
80101573:	89 da                	mov    %ebx,%edx
80101575:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101577:	5b                   	pop    %ebx
80101578:	5e                   	pop    %esi
80101579:	5f                   	pop    %edi
8010157a:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
8010157b:	e9 60 fc ff ff       	jmp    801011e0 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
80101580:	83 ec 0c             	sub    $0xc,%esp
80101583:	68 d8 71 10 80       	push   $0x801071d8
80101588:	e8 e3 ed ff ff       	call   80100370 <panic>
8010158d:	8d 76 00             	lea    0x0(%esi),%esi

80101590 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101590:	55                   	push   %ebp
80101591:	89 e5                	mov    %esp,%ebp
80101593:	56                   	push   %esi
80101594:	53                   	push   %ebx
80101595:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101598:	83 ec 08             	sub    $0x8,%esp
8010159b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010159e:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015a1:	c1 e8 03             	shr    $0x3,%eax
801015a4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015aa:	50                   	push   %eax
801015ab:	ff 73 a4             	pushl  -0x5c(%ebx)
801015ae:	e8 1d eb ff ff       	call   801000d0 <bread>
801015b3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015b5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015b8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015bc:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015bf:	83 e0 07             	and    $0x7,%eax
801015c2:	c1 e0 06             	shl    $0x6,%eax
801015c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801015c9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801015cc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015d0:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
801015d3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801015d7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801015db:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801015df:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801015e3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801015e7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801015ea:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ed:	6a 34                	push   $0x34
801015ef:	53                   	push   %ebx
801015f0:	50                   	push   %eax
801015f1:	e8 9a 2e 00 00       	call   80104490 <memmove>
  log_write(bp);
801015f6:	89 34 24             	mov    %esi,(%esp)
801015f9:	e8 02 17 00 00       	call   80102d00 <log_write>
  brelse(bp);
801015fe:	89 75 08             	mov    %esi,0x8(%ebp)
80101601:	83 c4 10             	add    $0x10,%esp
}
80101604:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101607:	5b                   	pop    %ebx
80101608:	5e                   	pop    %esi
80101609:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
8010160a:	e9 d1 eb ff ff       	jmp    801001e0 <brelse>
8010160f:	90                   	nop

80101610 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	53                   	push   %ebx
80101614:	83 ec 10             	sub    $0x10,%esp
80101617:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010161a:	68 e0 09 11 80       	push   $0x801109e0
8010161f:	e8 4c 2c 00 00       	call   80104270 <acquire>
  ip->ref++;
80101624:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101628:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010162f:	e8 5c 2d 00 00       	call   80104390 <release>
  return ip;
}
80101634:	89 d8                	mov    %ebx,%eax
80101636:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101639:	c9                   	leave  
8010163a:	c3                   	ret    
8010163b:	90                   	nop
8010163c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101640 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	56                   	push   %esi
80101644:	53                   	push   %ebx
80101645:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101648:	85 db                	test   %ebx,%ebx
8010164a:	0f 84 b7 00 00 00    	je     80101707 <ilock+0xc7>
80101650:	8b 53 08             	mov    0x8(%ebx),%edx
80101653:	85 d2                	test   %edx,%edx
80101655:	0f 8e ac 00 00 00    	jle    80101707 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
8010165b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010165e:	83 ec 0c             	sub    $0xc,%esp
80101661:	50                   	push   %eax
80101662:	e8 39 2a 00 00       	call   801040a0 <acquiresleep>

  if(ip->valid == 0){
80101667:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010166a:	83 c4 10             	add    $0x10,%esp
8010166d:	85 c0                	test   %eax,%eax
8010166f:	74 0f                	je     80101680 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
80101671:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101674:	5b                   	pop    %ebx
80101675:	5e                   	pop    %esi
80101676:	5d                   	pop    %ebp
80101677:	c3                   	ret    
80101678:	90                   	nop
80101679:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101680:	8b 43 04             	mov    0x4(%ebx),%eax
80101683:	83 ec 08             	sub    $0x8,%esp
80101686:	c1 e8 03             	shr    $0x3,%eax
80101689:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010168f:	50                   	push   %eax
80101690:	ff 33                	pushl  (%ebx)
80101692:	e8 39 ea ff ff       	call   801000d0 <bread>
80101697:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101699:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010169c:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010169f:	83 e0 07             	and    $0x7,%eax
801016a2:	c1 e0 06             	shl    $0x6,%eax
801016a5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016a9:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ac:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801016af:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016b3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016b7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016bb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016bf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801016c3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801016c7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801016cb:	8b 50 fc             	mov    -0x4(%eax),%edx
801016ce:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016d1:	6a 34                	push   $0x34
801016d3:	50                   	push   %eax
801016d4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801016d7:	50                   	push   %eax
801016d8:	e8 b3 2d 00 00       	call   80104490 <memmove>
    brelse(bp);
801016dd:	89 34 24             	mov    %esi,(%esp)
801016e0:	e8 fb ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
801016e5:	83 c4 10             	add    $0x10,%esp
801016e8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
801016ed:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801016f4:	0f 85 77 ff ff ff    	jne    80101671 <ilock+0x31>
      panic("ilock: no type");
801016fa:	83 ec 0c             	sub    $0xc,%esp
801016fd:	68 f0 71 10 80       	push   $0x801071f0
80101702:	e8 69 ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101707:	83 ec 0c             	sub    $0xc,%esp
8010170a:	68 ea 71 10 80       	push   $0x801071ea
8010170f:	e8 5c ec ff ff       	call   80100370 <panic>
80101714:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010171a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101720 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	56                   	push   %esi
80101724:	53                   	push   %ebx
80101725:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101728:	85 db                	test   %ebx,%ebx
8010172a:	74 28                	je     80101754 <iunlock+0x34>
8010172c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010172f:	83 ec 0c             	sub    $0xc,%esp
80101732:	56                   	push   %esi
80101733:	e8 08 2a 00 00       	call   80104140 <holdingsleep>
80101738:	83 c4 10             	add    $0x10,%esp
8010173b:	85 c0                	test   %eax,%eax
8010173d:	74 15                	je     80101754 <iunlock+0x34>
8010173f:	8b 43 08             	mov    0x8(%ebx),%eax
80101742:	85 c0                	test   %eax,%eax
80101744:	7e 0e                	jle    80101754 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101746:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101749:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010174c:	5b                   	pop    %ebx
8010174d:	5e                   	pop    %esi
8010174e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010174f:	e9 ac 29 00 00       	jmp    80104100 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101754:	83 ec 0c             	sub    $0xc,%esp
80101757:	68 ff 71 10 80       	push   $0x801071ff
8010175c:	e8 0f ec ff ff       	call   80100370 <panic>
80101761:	eb 0d                	jmp    80101770 <iput>
80101763:	90                   	nop
80101764:	90                   	nop
80101765:	90                   	nop
80101766:	90                   	nop
80101767:	90                   	nop
80101768:	90                   	nop
80101769:	90                   	nop
8010176a:	90                   	nop
8010176b:	90                   	nop
8010176c:	90                   	nop
8010176d:	90                   	nop
8010176e:	90                   	nop
8010176f:	90                   	nop

80101770 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	57                   	push   %edi
80101774:	56                   	push   %esi
80101775:	53                   	push   %ebx
80101776:	83 ec 28             	sub    $0x28,%esp
80101779:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
8010177c:	8d 7e 0c             	lea    0xc(%esi),%edi
8010177f:	57                   	push   %edi
80101780:	e8 1b 29 00 00       	call   801040a0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101785:	8b 56 4c             	mov    0x4c(%esi),%edx
80101788:	83 c4 10             	add    $0x10,%esp
8010178b:	85 d2                	test   %edx,%edx
8010178d:	74 07                	je     80101796 <iput+0x26>
8010178f:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101794:	74 32                	je     801017c8 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
80101796:	83 ec 0c             	sub    $0xc,%esp
80101799:	57                   	push   %edi
8010179a:	e8 61 29 00 00       	call   80104100 <releasesleep>

  acquire(&icache.lock);
8010179f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017a6:	e8 c5 2a 00 00       	call   80104270 <acquire>
  ip->ref--;
801017ab:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801017af:	83 c4 10             	add    $0x10,%esp
801017b2:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801017b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017bc:	5b                   	pop    %ebx
801017bd:	5e                   	pop    %esi
801017be:	5f                   	pop    %edi
801017bf:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
801017c0:	e9 cb 2b 00 00       	jmp    80104390 <release>
801017c5:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
801017c8:	83 ec 0c             	sub    $0xc,%esp
801017cb:	68 e0 09 11 80       	push   $0x801109e0
801017d0:	e8 9b 2a 00 00       	call   80104270 <acquire>
    int r = ip->ref;
801017d5:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
801017d8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017df:	e8 ac 2b 00 00       	call   80104390 <release>
    if(r == 1){
801017e4:	83 c4 10             	add    $0x10,%esp
801017e7:	83 fb 01             	cmp    $0x1,%ebx
801017ea:	75 aa                	jne    80101796 <iput+0x26>
801017ec:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
801017f2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801017f5:	8d 5e 5c             	lea    0x5c(%esi),%ebx
801017f8:	89 cf                	mov    %ecx,%edi
801017fa:	eb 0b                	jmp    80101807 <iput+0x97>
801017fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101800:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101803:	39 fb                	cmp    %edi,%ebx
80101805:	74 19                	je     80101820 <iput+0xb0>
    if(ip->addrs[i]){
80101807:	8b 13                	mov    (%ebx),%edx
80101809:	85 d2                	test   %edx,%edx
8010180b:	74 f3                	je     80101800 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010180d:	8b 06                	mov    (%esi),%eax
8010180f:	e8 ac fb ff ff       	call   801013c0 <bfree>
      ip->addrs[i] = 0;
80101814:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010181a:	eb e4                	jmp    80101800 <iput+0x90>
8010181c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101820:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101826:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101829:	85 c0                	test   %eax,%eax
8010182b:	75 33                	jne    80101860 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010182d:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101830:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101837:	56                   	push   %esi
80101838:	e8 53 fd ff ff       	call   80101590 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010183d:	31 c0                	xor    %eax,%eax
8010183f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101843:	89 34 24             	mov    %esi,(%esp)
80101846:	e8 45 fd ff ff       	call   80101590 <iupdate>
      ip->valid = 0;
8010184b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101852:	83 c4 10             	add    $0x10,%esp
80101855:	e9 3c ff ff ff       	jmp    80101796 <iput+0x26>
8010185a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101860:	83 ec 08             	sub    $0x8,%esp
80101863:	50                   	push   %eax
80101864:	ff 36                	pushl  (%esi)
80101866:	e8 65 e8 ff ff       	call   801000d0 <bread>
8010186b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101871:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101874:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101877:	8d 58 5c             	lea    0x5c(%eax),%ebx
8010187a:	83 c4 10             	add    $0x10,%esp
8010187d:	89 cf                	mov    %ecx,%edi
8010187f:	eb 0e                	jmp    8010188f <iput+0x11f>
80101881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101888:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
8010188b:	39 fb                	cmp    %edi,%ebx
8010188d:	74 0f                	je     8010189e <iput+0x12e>
      if(a[j])
8010188f:	8b 13                	mov    (%ebx),%edx
80101891:	85 d2                	test   %edx,%edx
80101893:	74 f3                	je     80101888 <iput+0x118>
        bfree(ip->dev, a[j]);
80101895:	8b 06                	mov    (%esi),%eax
80101897:	e8 24 fb ff ff       	call   801013c0 <bfree>
8010189c:	eb ea                	jmp    80101888 <iput+0x118>
    }
    brelse(bp);
8010189e:	83 ec 0c             	sub    $0xc,%esp
801018a1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018a4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018a7:	e8 34 e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018ac:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018b2:	8b 06                	mov    (%esi),%eax
801018b4:	e8 07 fb ff ff       	call   801013c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018b9:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018c0:	00 00 00 
801018c3:	83 c4 10             	add    $0x10,%esp
801018c6:	e9 62 ff ff ff       	jmp    8010182d <iput+0xbd>
801018cb:	90                   	nop
801018cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018d0 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
801018d0:	55                   	push   %ebp
801018d1:	89 e5                	mov    %esp,%ebp
801018d3:	53                   	push   %ebx
801018d4:	83 ec 10             	sub    $0x10,%esp
801018d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801018da:	53                   	push   %ebx
801018db:	e8 40 fe ff ff       	call   80101720 <iunlock>
  iput(ip);
801018e0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801018e3:	83 c4 10             	add    $0x10,%esp
}
801018e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801018e9:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
801018ea:	e9 81 fe ff ff       	jmp    80101770 <iput>
801018ef:	90                   	nop

801018f0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	8b 55 08             	mov    0x8(%ebp),%edx
801018f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801018f9:	8b 0a                	mov    (%edx),%ecx
801018fb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801018fe:	8b 4a 04             	mov    0x4(%edx),%ecx
80101901:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101904:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101908:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010190b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010190f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101913:	8b 52 58             	mov    0x58(%edx),%edx
80101916:	89 50 10             	mov    %edx,0x10(%eax)
}
80101919:	5d                   	pop    %ebp
8010191a:	c3                   	ret    
8010191b:	90                   	nop
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101920 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	57                   	push   %edi
80101924:	56                   	push   %esi
80101925:	53                   	push   %ebx
80101926:	83 ec 1c             	sub    $0x1c,%esp
80101929:	8b 45 08             	mov    0x8(%ebp),%eax
8010192c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010192f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101932:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101937:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010193a:	8b 7d 14             	mov    0x14(%ebp),%edi
8010193d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101940:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101943:	0f 84 a7 00 00 00    	je     801019f0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101949:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010194c:	8b 40 58             	mov    0x58(%eax),%eax
8010194f:	39 f0                	cmp    %esi,%eax
80101951:	0f 82 c1 00 00 00    	jb     80101a18 <readi+0xf8>
80101957:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010195a:	89 fa                	mov    %edi,%edx
8010195c:	01 f2                	add    %esi,%edx
8010195e:	0f 82 b4 00 00 00    	jb     80101a18 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101964:	89 c1                	mov    %eax,%ecx
80101966:	29 f1                	sub    %esi,%ecx
80101968:	39 d0                	cmp    %edx,%eax
8010196a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010196d:	31 ff                	xor    %edi,%edi
8010196f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101971:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101974:	74 6d                	je     801019e3 <readi+0xc3>
80101976:	8d 76 00             	lea    0x0(%esi),%esi
80101979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101980:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101983:	89 f2                	mov    %esi,%edx
80101985:	c1 ea 09             	shr    $0x9,%edx
80101988:	89 d8                	mov    %ebx,%eax
8010198a:	e8 21 f9 ff ff       	call   801012b0 <bmap>
8010198f:	83 ec 08             	sub    $0x8,%esp
80101992:	50                   	push   %eax
80101993:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
80101995:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010199a:	e8 31 e7 ff ff       	call   801000d0 <bread>
8010199f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019a4:	89 f1                	mov    %esi,%ecx
801019a6:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801019ac:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
801019af:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019b2:	29 cb                	sub    %ecx,%ebx
801019b4:	29 f8                	sub    %edi,%eax
801019b6:	39 c3                	cmp    %eax,%ebx
801019b8:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019bb:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
801019bf:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019c0:	01 df                	add    %ebx,%edi
801019c2:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
801019c4:	50                   	push   %eax
801019c5:	ff 75 e0             	pushl  -0x20(%ebp)
801019c8:	e8 c3 2a 00 00       	call   80104490 <memmove>
    brelse(bp);
801019cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
801019d0:	89 14 24             	mov    %edx,(%esp)
801019d3:	e8 08 e8 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019d8:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019db:	83 c4 10             	add    $0x10,%esp
801019de:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801019e1:	77 9d                	ja     80101980 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
801019e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
801019e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019e9:	5b                   	pop    %ebx
801019ea:	5e                   	pop    %esi
801019eb:	5f                   	pop    %edi
801019ec:	5d                   	pop    %ebp
801019ed:	c3                   	ret    
801019ee:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801019f0:	0f bf 40 52          	movswl 0x52(%eax),%eax
801019f4:	66 83 f8 09          	cmp    $0x9,%ax
801019f8:	77 1e                	ja     80101a18 <readi+0xf8>
801019fa:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a01:	85 c0                	test   %eax,%eax
80101a03:	74 13                	je     80101a18 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a05:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a0b:	5b                   	pop    %ebx
80101a0c:	5e                   	pop    %esi
80101a0d:	5f                   	pop    %edi
80101a0e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a0f:	ff e0                	jmp    *%eax
80101a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a1d:	eb c7                	jmp    801019e6 <readi+0xc6>
80101a1f:	90                   	nop

80101a20 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	57                   	push   %edi
80101a24:	56                   	push   %esi
80101a25:	53                   	push   %ebx
80101a26:	83 ec 1c             	sub    $0x1c,%esp
80101a29:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a2f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a32:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a37:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a3d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a40:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a43:	0f 84 b7 00 00 00    	je     80101b00 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a4c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a4f:	0f 82 eb 00 00 00    	jb     80101b40 <writei+0x120>
80101a55:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a58:	89 f8                	mov    %edi,%eax
80101a5a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a5c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a61:	0f 87 d9 00 00 00    	ja     80101b40 <writei+0x120>
80101a67:	39 c6                	cmp    %eax,%esi
80101a69:	0f 87 d1 00 00 00    	ja     80101b40 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a6f:	85 ff                	test   %edi,%edi
80101a71:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101a78:	74 78                	je     80101af2 <writei+0xd2>
80101a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a80:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101a83:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a85:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a8a:	c1 ea 09             	shr    $0x9,%edx
80101a8d:	89 f8                	mov    %edi,%eax
80101a8f:	e8 1c f8 ff ff       	call   801012b0 <bmap>
80101a94:	83 ec 08             	sub    $0x8,%esp
80101a97:	50                   	push   %eax
80101a98:	ff 37                	pushl  (%edi)
80101a9a:	e8 31 e6 ff ff       	call   801000d0 <bread>
80101a9f:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101aa1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101aa4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101aa7:	89 f1                	mov    %esi,%ecx
80101aa9:	83 c4 0c             	add    $0xc,%esp
80101aac:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101ab2:	29 cb                	sub    %ecx,%ebx
80101ab4:	39 c3                	cmp    %eax,%ebx
80101ab6:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ab9:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101abd:	53                   	push   %ebx
80101abe:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ac1:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101ac3:	50                   	push   %eax
80101ac4:	e8 c7 29 00 00       	call   80104490 <memmove>
    log_write(bp);
80101ac9:	89 3c 24             	mov    %edi,(%esp)
80101acc:	e8 2f 12 00 00       	call   80102d00 <log_write>
    brelse(bp);
80101ad1:	89 3c 24             	mov    %edi,(%esp)
80101ad4:	e8 07 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ad9:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101adc:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101adf:	83 c4 10             	add    $0x10,%esp
80101ae2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ae5:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101ae8:	77 96                	ja     80101a80 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101aea:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101aed:	3b 70 58             	cmp    0x58(%eax),%esi
80101af0:	77 36                	ja     80101b28 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101af2:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101af5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101af8:	5b                   	pop    %ebx
80101af9:	5e                   	pop    %esi
80101afa:	5f                   	pop    %edi
80101afb:	5d                   	pop    %ebp
80101afc:	c3                   	ret    
80101afd:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b00:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b04:	66 83 f8 09          	cmp    $0x9,%ax
80101b08:	77 36                	ja     80101b40 <writei+0x120>
80101b0a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b11:	85 c0                	test   %eax,%eax
80101b13:	74 2b                	je     80101b40 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b15:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b1b:	5b                   	pop    %ebx
80101b1c:	5e                   	pop    %esi
80101b1d:	5f                   	pop    %edi
80101b1e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b1f:	ff e0                	jmp    *%eax
80101b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b28:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b2b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b2e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b31:	50                   	push   %eax
80101b32:	e8 59 fa ff ff       	call   80101590 <iupdate>
80101b37:	83 c4 10             	add    $0x10,%esp
80101b3a:	eb b6                	jmp    80101af2 <writei+0xd2>
80101b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b45:	eb ae                	jmp    80101af5 <writei+0xd5>
80101b47:	89 f6                	mov    %esi,%esi
80101b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b50 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b50:	55                   	push   %ebp
80101b51:	89 e5                	mov    %esp,%ebp
80101b53:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b56:	6a 0e                	push   $0xe
80101b58:	ff 75 0c             	pushl  0xc(%ebp)
80101b5b:	ff 75 08             	pushl  0x8(%ebp)
80101b5e:	e8 ad 29 00 00       	call   80104510 <strncmp>
}
80101b63:	c9                   	leave  
80101b64:	c3                   	ret    
80101b65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b70 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	57                   	push   %edi
80101b74:	56                   	push   %esi
80101b75:	53                   	push   %ebx
80101b76:	83 ec 1c             	sub    $0x1c,%esp
80101b79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101b7c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101b81:	0f 85 80 00 00 00    	jne    80101c07 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101b87:	8b 53 58             	mov    0x58(%ebx),%edx
80101b8a:	31 ff                	xor    %edi,%edi
80101b8c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101b8f:	85 d2                	test   %edx,%edx
80101b91:	75 0d                	jne    80101ba0 <dirlookup+0x30>
80101b93:	eb 5b                	jmp    80101bf0 <dirlookup+0x80>
80101b95:	8d 76 00             	lea    0x0(%esi),%esi
80101b98:	83 c7 10             	add    $0x10,%edi
80101b9b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101b9e:	76 50                	jbe    80101bf0 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ba0:	6a 10                	push   $0x10
80101ba2:	57                   	push   %edi
80101ba3:	56                   	push   %esi
80101ba4:	53                   	push   %ebx
80101ba5:	e8 76 fd ff ff       	call   80101920 <readi>
80101baa:	83 c4 10             	add    $0x10,%esp
80101bad:	83 f8 10             	cmp    $0x10,%eax
80101bb0:	75 48                	jne    80101bfa <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101bb2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bb7:	74 df                	je     80101b98 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101bb9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bbc:	83 ec 04             	sub    $0x4,%esp
80101bbf:	6a 0e                	push   $0xe
80101bc1:	50                   	push   %eax
80101bc2:	ff 75 0c             	pushl  0xc(%ebp)
80101bc5:	e8 46 29 00 00       	call   80104510 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101bca:	83 c4 10             	add    $0x10,%esp
80101bcd:	85 c0                	test   %eax,%eax
80101bcf:	75 c7                	jne    80101b98 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101bd1:	8b 45 10             	mov    0x10(%ebp),%eax
80101bd4:	85 c0                	test   %eax,%eax
80101bd6:	74 05                	je     80101bdd <dirlookup+0x6d>
        *poff = off;
80101bd8:	8b 45 10             	mov    0x10(%ebp),%eax
80101bdb:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101bdd:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101be1:	8b 03                	mov    (%ebx),%eax
80101be3:	e8 f8 f5 ff ff       	call   801011e0 <iget>
    }
  }

  return 0;
}
80101be8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101beb:	5b                   	pop    %ebx
80101bec:	5e                   	pop    %esi
80101bed:	5f                   	pop    %edi
80101bee:	5d                   	pop    %ebp
80101bef:	c3                   	ret    
80101bf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101bf3:	31 c0                	xor    %eax,%eax
}
80101bf5:	5b                   	pop    %ebx
80101bf6:	5e                   	pop    %esi
80101bf7:	5f                   	pop    %edi
80101bf8:	5d                   	pop    %ebp
80101bf9:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101bfa:	83 ec 0c             	sub    $0xc,%esp
80101bfd:	68 19 72 10 80       	push   $0x80107219
80101c02:	e8 69 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c07:	83 ec 0c             	sub    $0xc,%esp
80101c0a:	68 07 72 10 80       	push   $0x80107207
80101c0f:	e8 5c e7 ff ff       	call   80100370 <panic>
80101c14:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c1a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101c20 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c20:	55                   	push   %ebp
80101c21:	89 e5                	mov    %esp,%ebp
80101c23:	57                   	push   %edi
80101c24:	56                   	push   %esi
80101c25:	53                   	push   %ebx
80101c26:	89 cf                	mov    %ecx,%edi
80101c28:	89 c3                	mov    %eax,%ebx
80101c2a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c2d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c30:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c33:	0f 84 53 01 00 00    	je     80101d8c <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c39:	e8 12 1b 00 00       	call   80103750 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c3e:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c41:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c44:	68 e0 09 11 80       	push   $0x801109e0
80101c49:	e8 22 26 00 00       	call   80104270 <acquire>
  ip->ref++;
80101c4e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c52:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101c59:	e8 32 27 00 00       	call   80104390 <release>
80101c5e:	83 c4 10             	add    $0x10,%esp
80101c61:	eb 08                	jmp    80101c6b <namex+0x4b>
80101c63:	90                   	nop
80101c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101c68:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101c6b:	0f b6 03             	movzbl (%ebx),%eax
80101c6e:	3c 2f                	cmp    $0x2f,%al
80101c70:	74 f6                	je     80101c68 <namex+0x48>
    path++;
  if(*path == 0)
80101c72:	84 c0                	test   %al,%al
80101c74:	0f 84 e3 00 00 00    	je     80101d5d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101c7a:	0f b6 03             	movzbl (%ebx),%eax
80101c7d:	89 da                	mov    %ebx,%edx
80101c7f:	84 c0                	test   %al,%al
80101c81:	0f 84 ac 00 00 00    	je     80101d33 <namex+0x113>
80101c87:	3c 2f                	cmp    $0x2f,%al
80101c89:	75 09                	jne    80101c94 <namex+0x74>
80101c8b:	e9 a3 00 00 00       	jmp    80101d33 <namex+0x113>
80101c90:	84 c0                	test   %al,%al
80101c92:	74 0a                	je     80101c9e <namex+0x7e>
    path++;
80101c94:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101c97:	0f b6 02             	movzbl (%edx),%eax
80101c9a:	3c 2f                	cmp    $0x2f,%al
80101c9c:	75 f2                	jne    80101c90 <namex+0x70>
80101c9e:	89 d1                	mov    %edx,%ecx
80101ca0:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101ca2:	83 f9 0d             	cmp    $0xd,%ecx
80101ca5:	0f 8e 8d 00 00 00    	jle    80101d38 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101cab:	83 ec 04             	sub    $0x4,%esp
80101cae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101cb1:	6a 0e                	push   $0xe
80101cb3:	53                   	push   %ebx
80101cb4:	57                   	push   %edi
80101cb5:	e8 d6 27 00 00       	call   80104490 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101cbd:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cc0:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101cc2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101cc5:	75 11                	jne    80101cd8 <namex+0xb8>
80101cc7:	89 f6                	mov    %esi,%esi
80101cc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101cd0:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101cd3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101cd6:	74 f8                	je     80101cd0 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101cd8:	83 ec 0c             	sub    $0xc,%esp
80101cdb:	56                   	push   %esi
80101cdc:	e8 5f f9 ff ff       	call   80101640 <ilock>
    if(ip->type != T_DIR){
80101ce1:	83 c4 10             	add    $0x10,%esp
80101ce4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ce9:	0f 85 7f 00 00 00    	jne    80101d6e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101cef:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101cf2:	85 d2                	test   %edx,%edx
80101cf4:	74 09                	je     80101cff <namex+0xdf>
80101cf6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101cf9:	0f 84 a3 00 00 00    	je     80101da2 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101cff:	83 ec 04             	sub    $0x4,%esp
80101d02:	6a 00                	push   $0x0
80101d04:	57                   	push   %edi
80101d05:	56                   	push   %esi
80101d06:	e8 65 fe ff ff       	call   80101b70 <dirlookup>
80101d0b:	83 c4 10             	add    $0x10,%esp
80101d0e:	85 c0                	test   %eax,%eax
80101d10:	74 5c                	je     80101d6e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d12:	83 ec 0c             	sub    $0xc,%esp
80101d15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d18:	56                   	push   %esi
80101d19:	e8 02 fa ff ff       	call   80101720 <iunlock>
  iput(ip);
80101d1e:	89 34 24             	mov    %esi,(%esp)
80101d21:	e8 4a fa ff ff       	call   80101770 <iput>
80101d26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d29:	83 c4 10             	add    $0x10,%esp
80101d2c:	89 c6                	mov    %eax,%esi
80101d2e:	e9 38 ff ff ff       	jmp    80101c6b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d33:	31 c9                	xor    %ecx,%ecx
80101d35:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d38:	83 ec 04             	sub    $0x4,%esp
80101d3b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d3e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d41:	51                   	push   %ecx
80101d42:	53                   	push   %ebx
80101d43:	57                   	push   %edi
80101d44:	e8 47 27 00 00       	call   80104490 <memmove>
    name[len] = 0;
80101d49:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d4f:	83 c4 10             	add    $0x10,%esp
80101d52:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d56:	89 d3                	mov    %edx,%ebx
80101d58:	e9 65 ff ff ff       	jmp    80101cc2 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d5d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d60:	85 c0                	test   %eax,%eax
80101d62:	75 54                	jne    80101db8 <namex+0x198>
80101d64:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101d66:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d69:	5b                   	pop    %ebx
80101d6a:	5e                   	pop    %esi
80101d6b:	5f                   	pop    %edi
80101d6c:	5d                   	pop    %ebp
80101d6d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d6e:	83 ec 0c             	sub    $0xc,%esp
80101d71:	56                   	push   %esi
80101d72:	e8 a9 f9 ff ff       	call   80101720 <iunlock>
  iput(ip);
80101d77:	89 34 24             	mov    %esi,(%esp)
80101d7a:	e8 f1 f9 ff ff       	call   80101770 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101d7f:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101d82:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101d85:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101d87:	5b                   	pop    %ebx
80101d88:	5e                   	pop    %esi
80101d89:	5f                   	pop    %edi
80101d8a:	5d                   	pop    %ebp
80101d8b:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101d8c:	ba 01 00 00 00       	mov    $0x1,%edx
80101d91:	b8 01 00 00 00       	mov    $0x1,%eax
80101d96:	e8 45 f4 ff ff       	call   801011e0 <iget>
80101d9b:	89 c6                	mov    %eax,%esi
80101d9d:	e9 c9 fe ff ff       	jmp    80101c6b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101da2:	83 ec 0c             	sub    $0xc,%esp
80101da5:	56                   	push   %esi
80101da6:	e8 75 f9 ff ff       	call   80101720 <iunlock>
      return ip;
80101dab:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dae:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101db1:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101db3:	5b                   	pop    %ebx
80101db4:	5e                   	pop    %esi
80101db5:	5f                   	pop    %edi
80101db6:	5d                   	pop    %ebp
80101db7:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101db8:	83 ec 0c             	sub    $0xc,%esp
80101dbb:	56                   	push   %esi
80101dbc:	e8 af f9 ff ff       	call   80101770 <iput>
    return 0;
80101dc1:	83 c4 10             	add    $0x10,%esp
80101dc4:	31 c0                	xor    %eax,%eax
80101dc6:	eb 9e                	jmp    80101d66 <namex+0x146>
80101dc8:	90                   	nop
80101dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101dd0 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101dd0:	55                   	push   %ebp
80101dd1:	89 e5                	mov    %esp,%ebp
80101dd3:	57                   	push   %edi
80101dd4:	56                   	push   %esi
80101dd5:	53                   	push   %ebx
80101dd6:	83 ec 20             	sub    $0x20,%esp
80101dd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101ddc:	6a 00                	push   $0x0
80101dde:	ff 75 0c             	pushl  0xc(%ebp)
80101de1:	53                   	push   %ebx
80101de2:	e8 89 fd ff ff       	call   80101b70 <dirlookup>
80101de7:	83 c4 10             	add    $0x10,%esp
80101dea:	85 c0                	test   %eax,%eax
80101dec:	75 67                	jne    80101e55 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101dee:	8b 7b 58             	mov    0x58(%ebx),%edi
80101df1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101df4:	85 ff                	test   %edi,%edi
80101df6:	74 29                	je     80101e21 <dirlink+0x51>
80101df8:	31 ff                	xor    %edi,%edi
80101dfa:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101dfd:	eb 09                	jmp    80101e08 <dirlink+0x38>
80101dff:	90                   	nop
80101e00:	83 c7 10             	add    $0x10,%edi
80101e03:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101e06:	76 19                	jbe    80101e21 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e08:	6a 10                	push   $0x10
80101e0a:	57                   	push   %edi
80101e0b:	56                   	push   %esi
80101e0c:	53                   	push   %ebx
80101e0d:	e8 0e fb ff ff       	call   80101920 <readi>
80101e12:	83 c4 10             	add    $0x10,%esp
80101e15:	83 f8 10             	cmp    $0x10,%eax
80101e18:	75 4e                	jne    80101e68 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101e1a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e1f:	75 df                	jne    80101e00 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e21:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e24:	83 ec 04             	sub    $0x4,%esp
80101e27:	6a 0e                	push   $0xe
80101e29:	ff 75 0c             	pushl  0xc(%ebp)
80101e2c:	50                   	push   %eax
80101e2d:	e8 4e 27 00 00       	call   80104580 <strncpy>
  de.inum = inum;
80101e32:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e35:	6a 10                	push   $0x10
80101e37:	57                   	push   %edi
80101e38:	56                   	push   %esi
80101e39:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101e3a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e3e:	e8 dd fb ff ff       	call   80101a20 <writei>
80101e43:	83 c4 20             	add    $0x20,%esp
80101e46:	83 f8 10             	cmp    $0x10,%eax
80101e49:	75 2a                	jne    80101e75 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101e4b:	31 c0                	xor    %eax,%eax
}
80101e4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e50:	5b                   	pop    %ebx
80101e51:	5e                   	pop    %esi
80101e52:	5f                   	pop    %edi
80101e53:	5d                   	pop    %ebp
80101e54:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101e55:	83 ec 0c             	sub    $0xc,%esp
80101e58:	50                   	push   %eax
80101e59:	e8 12 f9 ff ff       	call   80101770 <iput>
    return -1;
80101e5e:	83 c4 10             	add    $0x10,%esp
80101e61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e66:	eb e5                	jmp    80101e4d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101e68:	83 ec 0c             	sub    $0xc,%esp
80101e6b:	68 28 72 10 80       	push   $0x80107228
80101e70:	e8 fb e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101e75:	83 ec 0c             	sub    $0xc,%esp
80101e78:	68 26 78 10 80       	push   $0x80107826
80101e7d:	e8 ee e4 ff ff       	call   80100370 <panic>
80101e82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101e90 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101e90:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101e91:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101e93:	89 e5                	mov    %esp,%ebp
80101e95:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101e98:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101e9e:	e8 7d fd ff ff       	call   80101c20 <namex>
}
80101ea3:	c9                   	leave  
80101ea4:	c3                   	ret    
80101ea5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101eb0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101eb0:	55                   	push   %ebp
  return namex(path, 1, name);
80101eb1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101eb6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101eb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101ebb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101ebe:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101ebf:	e9 5c fd ff ff       	jmp    80101c20 <namex>
80101ec4:	66 90                	xchg   %ax,%ax
80101ec6:	66 90                	xchg   %ax,%ax
80101ec8:	66 90                	xchg   %ax,%ax
80101eca:	66 90                	xchg   %ax,%ax
80101ecc:	66 90                	xchg   %ax,%ax
80101ece:	66 90                	xchg   %ax,%ax

80101ed0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ed0:	55                   	push   %ebp
  if(b == 0)
80101ed1:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ed3:	89 e5                	mov    %esp,%ebp
80101ed5:	56                   	push   %esi
80101ed6:	53                   	push   %ebx
  if(b == 0)
80101ed7:	0f 84 ad 00 00 00    	je     80101f8a <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101edd:	8b 58 08             	mov    0x8(%eax),%ebx
80101ee0:	89 c1                	mov    %eax,%ecx
80101ee2:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101ee8:	0f 87 8f 00 00 00    	ja     80101f7d <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101eee:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ef3:	90                   	nop
80101ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ef8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101ef9:	83 e0 c0             	and    $0xffffffc0,%eax
80101efc:	3c 40                	cmp    $0x40,%al
80101efe:	75 f8                	jne    80101ef8 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f00:	31 f6                	xor    %esi,%esi
80101f02:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f07:	89 f0                	mov    %esi,%eax
80101f09:	ee                   	out    %al,(%dx)
80101f0a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f0f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f14:	ee                   	out    %al,(%dx)
80101f15:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f1a:	89 d8                	mov    %ebx,%eax
80101f1c:	ee                   	out    %al,(%dx)
80101f1d:	89 d8                	mov    %ebx,%eax
80101f1f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f24:	c1 f8 08             	sar    $0x8,%eax
80101f27:	ee                   	out    %al,(%dx)
80101f28:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f2d:	89 f0                	mov    %esi,%eax
80101f2f:	ee                   	out    %al,(%dx)
80101f30:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101f34:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f39:	83 e0 01             	and    $0x1,%eax
80101f3c:	c1 e0 04             	shl    $0x4,%eax
80101f3f:	83 c8 e0             	or     $0xffffffe0,%eax
80101f42:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80101f43:	f6 01 04             	testb  $0x4,(%ecx)
80101f46:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f4b:	75 13                	jne    80101f60 <idestart+0x90>
80101f4d:	b8 20 00 00 00       	mov    $0x20,%eax
80101f52:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f53:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f56:	5b                   	pop    %ebx
80101f57:	5e                   	pop    %esi
80101f58:	5d                   	pop    %ebp
80101f59:	c3                   	ret    
80101f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f60:	b8 30 00 00 00       	mov    $0x30,%eax
80101f65:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101f66:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101f6b:	8d 71 5c             	lea    0x5c(%ecx),%esi
80101f6e:	b9 80 00 00 00       	mov    $0x80,%ecx
80101f73:	fc                   	cld    
80101f74:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f76:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f79:	5b                   	pop    %ebx
80101f7a:	5e                   	pop    %esi
80101f7b:	5d                   	pop    %ebp
80101f7c:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101f7d:	83 ec 0c             	sub    $0xc,%esp
80101f80:	68 94 72 10 80       	push   $0x80107294
80101f85:	e8 e6 e3 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101f8a:	83 ec 0c             	sub    $0xc,%esp
80101f8d:	68 8b 72 10 80       	push   $0x8010728b
80101f92:	e8 d9 e3 ff ff       	call   80100370 <panic>
80101f97:	89 f6                	mov    %esi,%esi
80101f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fa0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101fa0:	55                   	push   %ebp
80101fa1:	89 e5                	mov    %esp,%ebp
80101fa3:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80101fa6:	68 a6 72 10 80       	push   $0x801072a6
80101fab:	68 80 a5 10 80       	push   $0x8010a580
80101fb0:	e8 bb 21 00 00       	call   80104170 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101fb5:	58                   	pop    %eax
80101fb6:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80101fbb:	5a                   	pop    %edx
80101fbc:	83 e8 01             	sub    $0x1,%eax
80101fbf:	50                   	push   %eax
80101fc0:	6a 0e                	push   $0xe
80101fc2:	e8 a9 02 00 00       	call   80102270 <ioapicenable>
80101fc7:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fca:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fcf:	90                   	nop
80101fd0:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101fd1:	83 e0 c0             	and    $0xffffffc0,%eax
80101fd4:	3c 40                	cmp    $0x40,%al
80101fd6:	75 f8                	jne    80101fd0 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fd8:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101fdd:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101fe2:	ee                   	out    %al,(%dx)
80101fe3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101fe8:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fed:	eb 06                	jmp    80101ff5 <ideinit+0x55>
80101fef:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80101ff0:	83 e9 01             	sub    $0x1,%ecx
80101ff3:	74 0f                	je     80102004 <ideinit+0x64>
80101ff5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101ff6:	84 c0                	test   %al,%al
80101ff8:	74 f6                	je     80101ff0 <ideinit+0x50>
      havedisk1 = 1;
80101ffa:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102001:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102004:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102009:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010200e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010200f:	c9                   	leave  
80102010:	c3                   	ret    
80102011:	eb 0d                	jmp    80102020 <ideintr>
80102013:	90                   	nop
80102014:	90                   	nop
80102015:	90                   	nop
80102016:	90                   	nop
80102017:	90                   	nop
80102018:	90                   	nop
80102019:	90                   	nop
8010201a:	90                   	nop
8010201b:	90                   	nop
8010201c:	90                   	nop
8010201d:	90                   	nop
8010201e:	90                   	nop
8010201f:	90                   	nop

80102020 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102020:	55                   	push   %ebp
80102021:	89 e5                	mov    %esp,%ebp
80102023:	57                   	push   %edi
80102024:	56                   	push   %esi
80102025:	53                   	push   %ebx
80102026:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102029:	68 80 a5 10 80       	push   $0x8010a580
8010202e:	e8 3d 22 00 00       	call   80104270 <acquire>

  if((b = idequeue) == 0){
80102033:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102039:	83 c4 10             	add    $0x10,%esp
8010203c:	85 db                	test   %ebx,%ebx
8010203e:	74 34                	je     80102074 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102040:	8b 43 58             	mov    0x58(%ebx),%eax
80102043:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102048:	8b 33                	mov    (%ebx),%esi
8010204a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102050:	74 3e                	je     80102090 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102052:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102055:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102058:	83 ce 02             	or     $0x2,%esi
8010205b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010205d:	53                   	push   %ebx
8010205e:	e8 4d 1e 00 00       	call   80103eb0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102063:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80102068:	83 c4 10             	add    $0x10,%esp
8010206b:	85 c0                	test   %eax,%eax
8010206d:	74 05                	je     80102074 <ideintr+0x54>
    idestart(idequeue);
8010206f:	e8 5c fe ff ff       	call   80101ed0 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
80102074:	83 ec 0c             	sub    $0xc,%esp
80102077:	68 80 a5 10 80       	push   $0x8010a580
8010207c:	e8 0f 23 00 00       	call   80104390 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
80102081:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102084:	5b                   	pop    %ebx
80102085:	5e                   	pop    %esi
80102086:	5f                   	pop    %edi
80102087:	5d                   	pop    %ebp
80102088:	c3                   	ret    
80102089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102090:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102095:	8d 76 00             	lea    0x0(%esi),%esi
80102098:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102099:	89 c1                	mov    %eax,%ecx
8010209b:	83 e1 c0             	and    $0xffffffc0,%ecx
8010209e:	80 f9 40             	cmp    $0x40,%cl
801020a1:	75 f5                	jne    80102098 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020a3:	a8 21                	test   $0x21,%al
801020a5:	75 ab                	jne    80102052 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020a7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801020aa:	b9 80 00 00 00       	mov    $0x80,%ecx
801020af:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020b4:	fc                   	cld    
801020b5:	f3 6d                	rep insl (%dx),%es:(%edi)
801020b7:	8b 33                	mov    (%ebx),%esi
801020b9:	eb 97                	jmp    80102052 <ideintr+0x32>
801020bb:	90                   	nop
801020bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020c0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	53                   	push   %ebx
801020c4:	83 ec 10             	sub    $0x10,%esp
801020c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801020ca:	8d 43 0c             	lea    0xc(%ebx),%eax
801020cd:	50                   	push   %eax
801020ce:	e8 6d 20 00 00       	call   80104140 <holdingsleep>
801020d3:	83 c4 10             	add    $0x10,%esp
801020d6:	85 c0                	test   %eax,%eax
801020d8:	0f 84 ad 00 00 00    	je     8010218b <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801020de:	8b 03                	mov    (%ebx),%eax
801020e0:	83 e0 06             	and    $0x6,%eax
801020e3:	83 f8 02             	cmp    $0x2,%eax
801020e6:	0f 84 b9 00 00 00    	je     801021a5 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801020ec:	8b 53 04             	mov    0x4(%ebx),%edx
801020ef:	85 d2                	test   %edx,%edx
801020f1:	74 0d                	je     80102100 <iderw+0x40>
801020f3:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801020f8:	85 c0                	test   %eax,%eax
801020fa:	0f 84 98 00 00 00    	je     80102198 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102100:	83 ec 0c             	sub    $0xc,%esp
80102103:	68 80 a5 10 80       	push   $0x8010a580
80102108:	e8 63 21 00 00       	call   80104270 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010210d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102113:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102116:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010211d:	85 d2                	test   %edx,%edx
8010211f:	75 09                	jne    8010212a <iderw+0x6a>
80102121:	eb 58                	jmp    8010217b <iderw+0xbb>
80102123:	90                   	nop
80102124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102128:	89 c2                	mov    %eax,%edx
8010212a:	8b 42 58             	mov    0x58(%edx),%eax
8010212d:	85 c0                	test   %eax,%eax
8010212f:	75 f7                	jne    80102128 <iderw+0x68>
80102131:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102134:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102136:	3b 1d 64 a5 10 80    	cmp    0x8010a564,%ebx
8010213c:	74 44                	je     80102182 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010213e:	8b 03                	mov    (%ebx),%eax
80102140:	83 e0 06             	and    $0x6,%eax
80102143:	83 f8 02             	cmp    $0x2,%eax
80102146:	74 23                	je     8010216b <iderw+0xab>
80102148:	90                   	nop
80102149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102150:	83 ec 08             	sub    $0x8,%esp
80102153:	68 80 a5 10 80       	push   $0x8010a580
80102158:	53                   	push   %ebx
80102159:	e8 a2 1b 00 00       	call   80103d00 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010215e:	8b 03                	mov    (%ebx),%eax
80102160:	83 c4 10             	add    $0x10,%esp
80102163:	83 e0 06             	and    $0x6,%eax
80102166:	83 f8 02             	cmp    $0x2,%eax
80102169:	75 e5                	jne    80102150 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
8010216b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102172:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102175:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
80102176:	e9 15 22 00 00       	jmp    80104390 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217b:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102180:	eb b2                	jmp    80102134 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
80102182:	89 d8                	mov    %ebx,%eax
80102184:	e8 47 fd ff ff       	call   80101ed0 <idestart>
80102189:	eb b3                	jmp    8010213e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
8010218b:	83 ec 0c             	sub    $0xc,%esp
8010218e:	68 aa 72 10 80       	push   $0x801072aa
80102193:	e8 d8 e1 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
80102198:	83 ec 0c             	sub    $0xc,%esp
8010219b:	68 d5 72 10 80       	push   $0x801072d5
801021a0:	e8 cb e1 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021a5:	83 ec 0c             	sub    $0xc,%esp
801021a8:	68 c0 72 10 80       	push   $0x801072c0
801021ad:	e8 be e1 ff ff       	call   80100370 <panic>
801021b2:	66 90                	xchg   %ax,%ax
801021b4:	66 90                	xchg   %ax,%ax
801021b6:	66 90                	xchg   %ax,%ax
801021b8:	66 90                	xchg   %ax,%ax
801021ba:	66 90                	xchg   %ax,%ax
801021bc:	66 90                	xchg   %ax,%ax
801021be:	66 90                	xchg   %ax,%ax

801021c0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021c0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021c1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801021c8:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021cb:	89 e5                	mov    %esp,%ebp
801021cd:	56                   	push   %esi
801021ce:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021cf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801021d6:	00 00 00 
  return ioapic->data;
801021d9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801021df:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021e2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801021e8:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801021ee:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801021f5:	89 f0                	mov    %esi,%eax
801021f7:	c1 e8 10             	shr    $0x10,%eax
801021fa:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
801021fd:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102200:	c1 e8 18             	shr    $0x18,%eax
80102203:	39 d0                	cmp    %edx,%eax
80102205:	74 16                	je     8010221d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102207:	83 ec 0c             	sub    $0xc,%esp
8010220a:	68 f4 72 10 80       	push   $0x801072f4
8010220f:	e8 4c e4 ff ff       	call   80100660 <cprintf>
80102214:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010221a:	83 c4 10             	add    $0x10,%esp
8010221d:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102220:	ba 10 00 00 00       	mov    $0x10,%edx
80102225:	b8 20 00 00 00       	mov    $0x20,%eax
8010222a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102230:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102232:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102238:	89 c3                	mov    %eax,%ebx
8010223a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102240:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102243:	89 59 10             	mov    %ebx,0x10(%ecx)
80102246:	8d 5a 01             	lea    0x1(%edx),%ebx
80102249:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010224c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010224e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102250:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102256:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010225d:	75 d1                	jne    80102230 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010225f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102262:	5b                   	pop    %ebx
80102263:	5e                   	pop    %esi
80102264:	5d                   	pop    %ebp
80102265:	c3                   	ret    
80102266:	8d 76 00             	lea    0x0(%esi),%esi
80102269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102270 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102270:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102271:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
80102277:	89 e5                	mov    %esp,%ebp
80102279:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010227c:	8d 50 20             	lea    0x20(%eax),%edx
8010227f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102283:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102285:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010228b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010228e:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102291:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102294:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102296:	a1 34 26 11 80       	mov    0x80112634,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010229b:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
8010229e:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022a1:	5d                   	pop    %ebp
801022a2:	c3                   	ret    
801022a3:	66 90                	xchg   %ax,%ax
801022a5:	66 90                	xchg   %ax,%ax
801022a7:	66 90                	xchg   %ax,%ax
801022a9:	66 90                	xchg   %ax,%ax
801022ab:	66 90                	xchg   %ax,%ax
801022ad:	66 90                	xchg   %ax,%ax
801022af:	90                   	nop

801022b0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	53                   	push   %ebx
801022b4:	83 ec 04             	sub    $0x4,%esp
801022b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022ba:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022c0:	75 70                	jne    80102332 <kfree+0x82>
801022c2:	81 fb f4 58 11 80    	cmp    $0x801158f4,%ebx
801022c8:	72 68                	jb     80102332 <kfree+0x82>
801022ca:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801022d0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801022d5:	77 5b                	ja     80102332 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801022d7:	83 ec 04             	sub    $0x4,%esp
801022da:	68 00 10 00 00       	push   $0x1000
801022df:	6a 01                	push   $0x1
801022e1:	53                   	push   %ebx
801022e2:	e8 f9 20 00 00       	call   801043e0 <memset>

  if(kmem.use_lock)
801022e7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801022ed:	83 c4 10             	add    $0x10,%esp
801022f0:	85 d2                	test   %edx,%edx
801022f2:	75 2c                	jne    80102320 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801022f4:	a1 78 26 11 80       	mov    0x80112678,%eax
801022f9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801022fb:	a1 74 26 11 80       	mov    0x80112674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102300:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102306:	85 c0                	test   %eax,%eax
80102308:	75 06                	jne    80102310 <kfree+0x60>
    release(&kmem.lock);
}
8010230a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010230d:	c9                   	leave  
8010230e:	c3                   	ret    
8010230f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102310:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102317:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010231a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010231b:	e9 70 20 00 00       	jmp    80104390 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102320:	83 ec 0c             	sub    $0xc,%esp
80102323:	68 40 26 11 80       	push   $0x80112640
80102328:	e8 43 1f 00 00       	call   80104270 <acquire>
8010232d:	83 c4 10             	add    $0x10,%esp
80102330:	eb c2                	jmp    801022f4 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102332:	83 ec 0c             	sub    $0xc,%esp
80102335:	68 26 73 10 80       	push   $0x80107326
8010233a:	e8 31 e0 ff ff       	call   80100370 <panic>
8010233f:	90                   	nop

80102340 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102340:	55                   	push   %ebp
80102341:	89 e5                	mov    %esp,%ebp
80102343:	56                   	push   %esi
80102344:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102345:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102348:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010234b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102351:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102357:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010235d:	39 de                	cmp    %ebx,%esi
8010235f:	72 23                	jb     80102384 <freerange+0x44>
80102361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102368:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010236e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102371:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102377:	50                   	push   %eax
80102378:	e8 33 ff ff ff       	call   801022b0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010237d:	83 c4 10             	add    $0x10,%esp
80102380:	39 f3                	cmp    %esi,%ebx
80102382:	76 e4                	jbe    80102368 <freerange+0x28>
    kfree(p);
}
80102384:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102387:	5b                   	pop    %ebx
80102388:	5e                   	pop    %esi
80102389:	5d                   	pop    %ebp
8010238a:	c3                   	ret    
8010238b:	90                   	nop
8010238c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102390 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102390:	55                   	push   %ebp
80102391:	89 e5                	mov    %esp,%ebp
80102393:	56                   	push   %esi
80102394:	53                   	push   %ebx
80102395:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102398:	83 ec 08             	sub    $0x8,%esp
8010239b:	68 2c 73 10 80       	push   $0x8010732c
801023a0:	68 40 26 11 80       	push   $0x80112640
801023a5:	e8 c6 1d 00 00       	call   80104170 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023aa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ad:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801023b0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801023b7:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ba:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023c6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023cc:	39 de                	cmp    %ebx,%esi
801023ce:	72 1c                	jb     801023ec <kinit1+0x5c>
    kfree(p);
801023d0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801023d6:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023df:	50                   	push   %eax
801023e0:	e8 cb fe ff ff       	call   801022b0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023e5:	83 c4 10             	add    $0x10,%esp
801023e8:	39 de                	cmp    %ebx,%esi
801023ea:	73 e4                	jae    801023d0 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
801023ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023ef:	5b                   	pop    %ebx
801023f0:	5e                   	pop    %esi
801023f1:	5d                   	pop    %ebp
801023f2:	c3                   	ret    
801023f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801023f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102400 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102400:	55                   	push   %ebp
80102401:	89 e5                	mov    %esp,%ebp
80102403:	56                   	push   %esi
80102404:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102405:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102408:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010240b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102411:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102417:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010241d:	39 de                	cmp    %ebx,%esi
8010241f:	72 23                	jb     80102444 <kinit2+0x44>
80102421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102428:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010242e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102431:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102437:	50                   	push   %eax
80102438:	e8 73 fe ff ff       	call   801022b0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010243d:	83 c4 10             	add    $0x10,%esp
80102440:	39 de                	cmp    %ebx,%esi
80102442:	73 e4                	jae    80102428 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102444:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010244b:	00 00 00 
}
8010244e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102451:	5b                   	pop    %ebx
80102452:	5e                   	pop    %esi
80102453:	5d                   	pop    %ebp
80102454:	c3                   	ret    
80102455:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102460 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	53                   	push   %ebx
80102464:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102467:	a1 74 26 11 80       	mov    0x80112674,%eax
8010246c:	85 c0                	test   %eax,%eax
8010246e:	75 30                	jne    801024a0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102470:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
80102476:	85 db                	test   %ebx,%ebx
80102478:	74 1c                	je     80102496 <kalloc+0x36>
    kmem.freelist = r->next;
8010247a:	8b 13                	mov    (%ebx),%edx
8010247c:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
80102482:	85 c0                	test   %eax,%eax
80102484:	74 10                	je     80102496 <kalloc+0x36>
    release(&kmem.lock);
80102486:	83 ec 0c             	sub    $0xc,%esp
80102489:	68 40 26 11 80       	push   $0x80112640
8010248e:	e8 fd 1e 00 00       	call   80104390 <release>
80102493:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
80102496:	89 d8                	mov    %ebx,%eax
80102498:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010249b:	c9                   	leave  
8010249c:	c3                   	ret    
8010249d:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024a0:	83 ec 0c             	sub    $0xc,%esp
801024a3:	68 40 26 11 80       	push   $0x80112640
801024a8:	e8 c3 1d 00 00       	call   80104270 <acquire>
  r = kmem.freelist;
801024ad:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024b3:	83 c4 10             	add    $0x10,%esp
801024b6:	a1 74 26 11 80       	mov    0x80112674,%eax
801024bb:	85 db                	test   %ebx,%ebx
801024bd:	75 bb                	jne    8010247a <kalloc+0x1a>
801024bf:	eb c1                	jmp    80102482 <kalloc+0x22>
801024c1:	66 90                	xchg   %ax,%ax
801024c3:	66 90                	xchg   %ax,%ax
801024c5:	66 90                	xchg   %ax,%ax
801024c7:	66 90                	xchg   %ax,%ax
801024c9:	66 90                	xchg   %ax,%ax
801024cb:	66 90                	xchg   %ax,%ax
801024cd:	66 90                	xchg   %ax,%ax
801024cf:	90                   	nop

801024d0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801024d0:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024d1:	ba 64 00 00 00       	mov    $0x64,%edx
801024d6:	89 e5                	mov    %esp,%ebp
801024d8:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801024d9:	a8 01                	test   $0x1,%al
801024db:	0f 84 af 00 00 00    	je     80102590 <kbdgetc+0xc0>
801024e1:	ba 60 00 00 00       	mov    $0x60,%edx
801024e6:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801024e7:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801024ea:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801024f0:	74 7e                	je     80102570 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801024f2:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801024f4:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801024fa:	79 24                	jns    80102520 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801024fc:	f6 c1 40             	test   $0x40,%cl
801024ff:	75 05                	jne    80102506 <kbdgetc+0x36>
80102501:	89 c2                	mov    %eax,%edx
80102503:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102506:	0f b6 82 60 74 10 80 	movzbl -0x7fef8ba0(%edx),%eax
8010250d:	83 c8 40             	or     $0x40,%eax
80102510:	0f b6 c0             	movzbl %al,%eax
80102513:	f7 d0                	not    %eax
80102515:	21 c8                	and    %ecx,%eax
80102517:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010251c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010251e:	5d                   	pop    %ebp
8010251f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102520:	f6 c1 40             	test   $0x40,%cl
80102523:	74 09                	je     8010252e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102525:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102528:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010252b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010252e:	0f b6 82 60 74 10 80 	movzbl -0x7fef8ba0(%edx),%eax
80102535:	09 c1                	or     %eax,%ecx
80102537:	0f b6 82 60 73 10 80 	movzbl -0x7fef8ca0(%edx),%eax
8010253e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102540:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102542:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102548:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010254b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010254e:	8b 04 85 40 73 10 80 	mov    -0x7fef8cc0(,%eax,4),%eax
80102555:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102559:	74 c3                	je     8010251e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010255b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010255e:	83 fa 19             	cmp    $0x19,%edx
80102561:	77 1d                	ja     80102580 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102563:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102566:	5d                   	pop    %ebp
80102567:	c3                   	ret    
80102568:	90                   	nop
80102569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
80102570:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102572:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102579:	5d                   	pop    %ebp
8010257a:	c3                   	ret    
8010257b:	90                   	nop
8010257c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
80102580:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102583:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
80102586:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
80102587:	83 f9 19             	cmp    $0x19,%ecx
8010258a:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
8010258d:	c3                   	ret    
8010258e:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
80102590:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102595:	5d                   	pop    %ebp
80102596:	c3                   	ret    
80102597:	89 f6                	mov    %esi,%esi
80102599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025a0 <kbdintr>:

void
kbdintr(void)
{
801025a0:	55                   	push   %ebp
801025a1:	89 e5                	mov    %esp,%ebp
801025a3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801025a6:	68 d0 24 10 80       	push   $0x801024d0
801025ab:	e8 40 e2 ff ff       	call   801007f0 <consoleintr>
}
801025b0:	83 c4 10             	add    $0x10,%esp
801025b3:	c9                   	leave  
801025b4:	c3                   	ret    
801025b5:	66 90                	xchg   %ax,%ax
801025b7:	66 90                	xchg   %ax,%ax
801025b9:	66 90                	xchg   %ax,%ax
801025bb:	66 90                	xchg   %ax,%ax
801025bd:	66 90                	xchg   %ax,%ax
801025bf:	90                   	nop

801025c0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801025c0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801025c5:	55                   	push   %ebp
801025c6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801025c8:	85 c0                	test   %eax,%eax
801025ca:	0f 84 c8 00 00 00    	je     80102698 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025d0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801025d7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025da:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025dd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801025e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801025e7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025ea:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801025f1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801025f4:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801025f7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801025fe:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102601:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102604:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010260b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010260e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102611:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102618:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010261b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010261e:	8b 50 30             	mov    0x30(%eax),%edx
80102621:	c1 ea 10             	shr    $0x10,%edx
80102624:	80 fa 03             	cmp    $0x3,%dl
80102627:	77 77                	ja     801026a0 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102629:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102630:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102633:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102636:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010263d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102640:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102643:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010264a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010264d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102650:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102657:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010265a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010265d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102664:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102667:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010266a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102671:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102674:	8b 50 20             	mov    0x20(%eax),%edx
80102677:	89 f6                	mov    %esi,%esi
80102679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102680:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102686:	80 e6 10             	and    $0x10,%dh
80102689:	75 f5                	jne    80102680 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010268b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102692:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102695:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102698:	5d                   	pop    %ebp
80102699:	c3                   	ret    
8010269a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026a0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801026a7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026aa:	8b 50 20             	mov    0x20(%eax),%edx
801026ad:	e9 77 ff ff ff       	jmp    80102629 <lapicinit+0x69>
801026b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026c0 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
801026c0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
801026c5:	55                   	push   %ebp
801026c6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801026c8:	85 c0                	test   %eax,%eax
801026ca:	74 0c                	je     801026d8 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801026cc:	8b 40 20             	mov    0x20(%eax),%eax
}
801026cf:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
801026d0:	c1 e8 18             	shr    $0x18,%eax
}
801026d3:	c3                   	ret    
801026d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
801026d8:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
801026da:	5d                   	pop    %ebp
801026db:	c3                   	ret    
801026dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801026e0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801026e0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
801026e5:	55                   	push   %ebp
801026e6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801026e8:	85 c0                	test   %eax,%eax
801026ea:	74 0d                	je     801026f9 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026ec:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801026f3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f6:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
801026f9:	5d                   	pop    %ebp
801026fa:	c3                   	ret    
801026fb:	90                   	nop
801026fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102700 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102700:	55                   	push   %ebp
80102701:	89 e5                	mov    %esp,%ebp
}
80102703:	5d                   	pop    %ebp
80102704:	c3                   	ret    
80102705:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102710 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102710:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102711:	ba 70 00 00 00       	mov    $0x70,%edx
80102716:	b8 0f 00 00 00       	mov    $0xf,%eax
8010271b:	89 e5                	mov    %esp,%ebp
8010271d:	53                   	push   %ebx
8010271e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102721:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102724:	ee                   	out    %al,(%dx)
80102725:	ba 71 00 00 00       	mov    $0x71,%edx
8010272a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010272f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102730:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102732:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102735:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010273b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010273d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102740:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102743:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102745:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102748:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010274e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102753:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102759:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010275c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102763:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102766:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102769:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102770:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102773:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102776:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010277c:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010277f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102785:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102788:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010278e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102791:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102797:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010279a:	5b                   	pop    %ebx
8010279b:	5d                   	pop    %ebp
8010279c:	c3                   	ret    
8010279d:	8d 76 00             	lea    0x0(%esi),%esi

801027a0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801027a0:	55                   	push   %ebp
801027a1:	ba 70 00 00 00       	mov    $0x70,%edx
801027a6:	b8 0b 00 00 00       	mov    $0xb,%eax
801027ab:	89 e5                	mov    %esp,%ebp
801027ad:	57                   	push   %edi
801027ae:	56                   	push   %esi
801027af:	53                   	push   %ebx
801027b0:	83 ec 4c             	sub    $0x4c,%esp
801027b3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027b4:	ba 71 00 00 00       	mov    $0x71,%edx
801027b9:	ec                   	in     (%dx),%al
801027ba:	83 e0 04             	and    $0x4,%eax
801027bd:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027c0:	31 db                	xor    %ebx,%ebx
801027c2:	88 45 b7             	mov    %al,-0x49(%ebp)
801027c5:	bf 70 00 00 00       	mov    $0x70,%edi
801027ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801027d0:	89 d8                	mov    %ebx,%eax
801027d2:	89 fa                	mov    %edi,%edx
801027d4:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027d5:	b9 71 00 00 00       	mov    $0x71,%ecx
801027da:	89 ca                	mov    %ecx,%edx
801027dc:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
801027dd:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027e0:	89 fa                	mov    %edi,%edx
801027e2:	89 45 b8             	mov    %eax,-0x48(%ebp)
801027e5:	b8 02 00 00 00       	mov    $0x2,%eax
801027ea:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027eb:	89 ca                	mov    %ecx,%edx
801027ed:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
801027ee:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027f1:	89 fa                	mov    %edi,%edx
801027f3:	89 45 bc             	mov    %eax,-0x44(%ebp)
801027f6:	b8 04 00 00 00       	mov    $0x4,%eax
801027fb:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027fc:	89 ca                	mov    %ecx,%edx
801027fe:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
801027ff:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102802:	89 fa                	mov    %edi,%edx
80102804:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102807:	b8 07 00 00 00       	mov    $0x7,%eax
8010280c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010280d:	89 ca                	mov    %ecx,%edx
8010280f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102810:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102813:	89 fa                	mov    %edi,%edx
80102815:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102818:	b8 08 00 00 00       	mov    $0x8,%eax
8010281d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010281e:	89 ca                	mov    %ecx,%edx
80102820:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102821:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102824:	89 fa                	mov    %edi,%edx
80102826:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102829:	b8 09 00 00 00       	mov    $0x9,%eax
8010282e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010282f:	89 ca                	mov    %ecx,%edx
80102831:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102832:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102835:	89 fa                	mov    %edi,%edx
80102837:	89 45 cc             	mov    %eax,-0x34(%ebp)
8010283a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010283f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102840:	89 ca                	mov    %ecx,%edx
80102842:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102843:	84 c0                	test   %al,%al
80102845:	78 89                	js     801027d0 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102847:	89 d8                	mov    %ebx,%eax
80102849:	89 fa                	mov    %edi,%edx
8010284b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010284c:	89 ca                	mov    %ecx,%edx
8010284e:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010284f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102852:	89 fa                	mov    %edi,%edx
80102854:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102857:	b8 02 00 00 00       	mov    $0x2,%eax
8010285c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285d:	89 ca                	mov    %ecx,%edx
8010285f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102860:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102863:	89 fa                	mov    %edi,%edx
80102865:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102868:	b8 04 00 00 00       	mov    $0x4,%eax
8010286d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010286e:	89 ca                	mov    %ecx,%edx
80102870:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
80102871:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102874:	89 fa                	mov    %edi,%edx
80102876:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102879:	b8 07 00 00 00       	mov    $0x7,%eax
8010287e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287f:	89 ca                	mov    %ecx,%edx
80102881:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102882:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102885:	89 fa                	mov    %edi,%edx
80102887:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010288a:	b8 08 00 00 00       	mov    $0x8,%eax
8010288f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102890:	89 ca                	mov    %ecx,%edx
80102892:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102893:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102896:	89 fa                	mov    %edi,%edx
80102898:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010289b:	b8 09 00 00 00       	mov    $0x9,%eax
801028a0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028a1:	89 ca                	mov    %ecx,%edx
801028a3:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
801028a4:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028a7:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
801028aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028ad:	8d 45 b8             	lea    -0x48(%ebp),%eax
801028b0:	6a 18                	push   $0x18
801028b2:	56                   	push   %esi
801028b3:	50                   	push   %eax
801028b4:	e8 77 1b 00 00       	call   80104430 <memcmp>
801028b9:	83 c4 10             	add    $0x10,%esp
801028bc:	85 c0                	test   %eax,%eax
801028be:	0f 85 0c ff ff ff    	jne    801027d0 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
801028c4:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028c8:	75 78                	jne    80102942 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028ca:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028cd:	89 c2                	mov    %eax,%edx
801028cf:	83 e0 0f             	and    $0xf,%eax
801028d2:	c1 ea 04             	shr    $0x4,%edx
801028d5:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028d8:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028db:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028de:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028e1:	89 c2                	mov    %eax,%edx
801028e3:	83 e0 0f             	and    $0xf,%eax
801028e6:	c1 ea 04             	shr    $0x4,%edx
801028e9:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028ec:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028ef:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801028f2:	8b 45 c0             	mov    -0x40(%ebp),%eax
801028f5:	89 c2                	mov    %eax,%edx
801028f7:	83 e0 0f             	and    $0xf,%eax
801028fa:	c1 ea 04             	shr    $0x4,%edx
801028fd:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102900:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102903:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102906:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102909:	89 c2                	mov    %eax,%edx
8010290b:	83 e0 0f             	and    $0xf,%eax
8010290e:	c1 ea 04             	shr    $0x4,%edx
80102911:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102914:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102917:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010291a:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010291d:	89 c2                	mov    %eax,%edx
8010291f:	83 e0 0f             	and    $0xf,%eax
80102922:	c1 ea 04             	shr    $0x4,%edx
80102925:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102928:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010292b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010292e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102931:	89 c2                	mov    %eax,%edx
80102933:	83 e0 0f             	and    $0xf,%eax
80102936:	c1 ea 04             	shr    $0x4,%edx
80102939:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010293c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010293f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102942:	8b 75 08             	mov    0x8(%ebp),%esi
80102945:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102948:	89 06                	mov    %eax,(%esi)
8010294a:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010294d:	89 46 04             	mov    %eax,0x4(%esi)
80102950:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102953:	89 46 08             	mov    %eax,0x8(%esi)
80102956:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102959:	89 46 0c             	mov    %eax,0xc(%esi)
8010295c:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010295f:	89 46 10             	mov    %eax,0x10(%esi)
80102962:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102965:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102968:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010296f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102972:	5b                   	pop    %ebx
80102973:	5e                   	pop    %esi
80102974:	5f                   	pop    %edi
80102975:	5d                   	pop    %ebp
80102976:	c3                   	ret    
80102977:	66 90                	xchg   %ax,%ax
80102979:	66 90                	xchg   %ax,%ax
8010297b:	66 90                	xchg   %ax,%ax
8010297d:	66 90                	xchg   %ax,%ax
8010297f:	90                   	nop

80102980 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102980:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102986:	85 c9                	test   %ecx,%ecx
80102988:	0f 8e 85 00 00 00    	jle    80102a13 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
8010298e:	55                   	push   %ebp
8010298f:	89 e5                	mov    %esp,%ebp
80102991:	57                   	push   %edi
80102992:	56                   	push   %esi
80102993:	53                   	push   %ebx
80102994:	31 db                	xor    %ebx,%ebx
80102996:	83 ec 0c             	sub    $0xc,%esp
80102999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029a0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
801029a5:	83 ec 08             	sub    $0x8,%esp
801029a8:	01 d8                	add    %ebx,%eax
801029aa:	83 c0 01             	add    $0x1,%eax
801029ad:	50                   	push   %eax
801029ae:	ff 35 c4 26 11 80    	pushl  0x801126c4
801029b4:	e8 17 d7 ff ff       	call   801000d0 <bread>
801029b9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029bb:	58                   	pop    %eax
801029bc:	5a                   	pop    %edx
801029bd:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
801029c4:	ff 35 c4 26 11 80    	pushl  0x801126c4
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029ca:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029cd:	e8 fe d6 ff ff       	call   801000d0 <bread>
801029d2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029d4:	8d 47 5c             	lea    0x5c(%edi),%eax
801029d7:	83 c4 0c             	add    $0xc,%esp
801029da:	68 00 02 00 00       	push   $0x200
801029df:	50                   	push   %eax
801029e0:	8d 46 5c             	lea    0x5c(%esi),%eax
801029e3:	50                   	push   %eax
801029e4:	e8 a7 1a 00 00       	call   80104490 <memmove>
    bwrite(dbuf);  // write dst to disk
801029e9:	89 34 24             	mov    %esi,(%esp)
801029ec:	e8 af d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801029f1:	89 3c 24             	mov    %edi,(%esp)
801029f4:	e8 e7 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801029f9:	89 34 24             	mov    %esi,(%esp)
801029fc:	e8 df d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a01:	83 c4 10             	add    $0x10,%esp
80102a04:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102a0a:	7f 94                	jg     801029a0 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a0f:	5b                   	pop    %ebx
80102a10:	5e                   	pop    %esi
80102a11:	5f                   	pop    %edi
80102a12:	5d                   	pop    %ebp
80102a13:	f3 c3                	repz ret 
80102a15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a20 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a20:	55                   	push   %ebp
80102a21:	89 e5                	mov    %esp,%ebp
80102a23:	53                   	push   %ebx
80102a24:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a27:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102a2d:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102a33:	e8 98 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a38:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102a3e:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a41:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a43:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a45:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102a48:	7e 1f                	jle    80102a69 <write_head+0x49>
80102a4a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102a51:	31 d2                	xor    %edx,%edx
80102a53:	90                   	nop
80102a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a58:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102a5e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102a62:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a65:	39 c2                	cmp    %eax,%edx
80102a67:	75 ef                	jne    80102a58 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102a69:	83 ec 0c             	sub    $0xc,%esp
80102a6c:	53                   	push   %ebx
80102a6d:	e8 2e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a72:	89 1c 24             	mov    %ebx,(%esp)
80102a75:	e8 66 d7 ff ff       	call   801001e0 <brelse>
}
80102a7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a7d:	c9                   	leave  
80102a7e:	c3                   	ret    
80102a7f:	90                   	nop

80102a80 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102a80:	55                   	push   %ebp
80102a81:	89 e5                	mov    %esp,%ebp
80102a83:	53                   	push   %ebx
80102a84:	83 ec 2c             	sub    $0x2c,%esp
80102a87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102a8a:	68 60 75 10 80       	push   $0x80107560
80102a8f:	68 80 26 11 80       	push   $0x80112680
80102a94:	e8 d7 16 00 00       	call   80104170 <initlock>
  readsb(dev, &sb);
80102a99:	58                   	pop    %eax
80102a9a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102a9d:	5a                   	pop    %edx
80102a9e:	50                   	push   %eax
80102a9f:	53                   	push   %ebx
80102aa0:	e8 db e8 ff ff       	call   80101380 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102aa5:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102aa8:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102aab:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102aac:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ab2:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ab8:	a3 b4 26 11 80       	mov    %eax,0x801126b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102abd:	5a                   	pop    %edx
80102abe:	50                   	push   %eax
80102abf:	53                   	push   %ebx
80102ac0:	e8 0b d6 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102ac5:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ac8:	83 c4 10             	add    $0x10,%esp
80102acb:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102acd:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102ad3:	7e 1c                	jle    80102af1 <initlog+0x71>
80102ad5:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102adc:	31 d2                	xor    %edx,%edx
80102ade:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102ae0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102ae4:	83 c2 04             	add    $0x4,%edx
80102ae7:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102aed:	39 da                	cmp    %ebx,%edx
80102aef:	75 ef                	jne    80102ae0 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102af1:	83 ec 0c             	sub    $0xc,%esp
80102af4:	50                   	push   %eax
80102af5:	e8 e6 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102afa:	e8 81 fe ff ff       	call   80102980 <install_trans>
  log.lh.n = 0;
80102aff:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b06:	00 00 00 
  write_head(); // clear the log
80102b09:	e8 12 ff ff ff       	call   80102a20 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b11:	c9                   	leave  
80102b12:	c3                   	ret    
80102b13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b20 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102b26:	68 80 26 11 80       	push   $0x80112680
80102b2b:	e8 40 17 00 00       	call   80104270 <acquire>
80102b30:	83 c4 10             	add    $0x10,%esp
80102b33:	eb 18                	jmp    80102b4d <begin_op+0x2d>
80102b35:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b38:	83 ec 08             	sub    $0x8,%esp
80102b3b:	68 80 26 11 80       	push   $0x80112680
80102b40:	68 80 26 11 80       	push   $0x80112680
80102b45:	e8 b6 11 00 00       	call   80103d00 <sleep>
80102b4a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102b4d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b52:	85 c0                	test   %eax,%eax
80102b54:	75 e2                	jne    80102b38 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b56:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b5b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b61:	83 c0 01             	add    $0x1,%eax
80102b64:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b67:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b6a:	83 fa 1e             	cmp    $0x1e,%edx
80102b6d:	7f c9                	jg     80102b38 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b6f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102b72:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102b77:	68 80 26 11 80       	push   $0x80112680
80102b7c:	e8 0f 18 00 00       	call   80104390 <release>
      break;
    }
  }
}
80102b81:	83 c4 10             	add    $0x10,%esp
80102b84:	c9                   	leave  
80102b85:	c3                   	ret    
80102b86:	8d 76 00             	lea    0x0(%esi),%esi
80102b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b90 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102b90:	55                   	push   %ebp
80102b91:	89 e5                	mov    %esp,%ebp
80102b93:	57                   	push   %edi
80102b94:	56                   	push   %esi
80102b95:	53                   	push   %ebx
80102b96:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102b99:	68 80 26 11 80       	push   $0x80112680
80102b9e:	e8 cd 16 00 00       	call   80104270 <acquire>
  log.outstanding -= 1;
80102ba3:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102ba8:	8b 1d c0 26 11 80    	mov    0x801126c0,%ebx
80102bae:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102bb1:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102bb4:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102bb6:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102bbb:	0f 85 23 01 00 00    	jne    80102ce4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102bc1:	85 c0                	test   %eax,%eax
80102bc3:	0f 85 f7 00 00 00    	jne    80102cc0 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bc9:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102bcc:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102bd3:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bd6:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bd8:	68 80 26 11 80       	push   $0x80112680
80102bdd:	e8 ae 17 00 00       	call   80104390 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102be2:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102be8:	83 c4 10             	add    $0x10,%esp
80102beb:	85 c9                	test   %ecx,%ecx
80102bed:	0f 8e 8a 00 00 00    	jle    80102c7d <end_op+0xed>
80102bf3:	90                   	nop
80102bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102bf8:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102bfd:	83 ec 08             	sub    $0x8,%esp
80102c00:	01 d8                	add    %ebx,%eax
80102c02:	83 c0 01             	add    $0x1,%eax
80102c05:	50                   	push   %eax
80102c06:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102c0c:	e8 bf d4 ff ff       	call   801000d0 <bread>
80102c11:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c13:	58                   	pop    %eax
80102c14:	5a                   	pop    %edx
80102c15:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102c1c:	ff 35 c4 26 11 80    	pushl  0x801126c4
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c22:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c25:	e8 a6 d4 ff ff       	call   801000d0 <bread>
80102c2a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c2c:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c2f:	83 c4 0c             	add    $0xc,%esp
80102c32:	68 00 02 00 00       	push   $0x200
80102c37:	50                   	push   %eax
80102c38:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c3b:	50                   	push   %eax
80102c3c:	e8 4f 18 00 00       	call   80104490 <memmove>
    bwrite(to);  // write the log
80102c41:	89 34 24             	mov    %esi,(%esp)
80102c44:	e8 57 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c49:	89 3c 24             	mov    %edi,(%esp)
80102c4c:	e8 8f d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c51:	89 34 24             	mov    %esi,(%esp)
80102c54:	e8 87 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c59:	83 c4 10             	add    $0x10,%esp
80102c5c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c62:	7c 94                	jl     80102bf8 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c64:	e8 b7 fd ff ff       	call   80102a20 <write_head>
    install_trans(); // Now install writes to home locations
80102c69:	e8 12 fd ff ff       	call   80102980 <install_trans>
    log.lh.n = 0;
80102c6e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c75:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c78:	e8 a3 fd ff ff       	call   80102a20 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102c7d:	83 ec 0c             	sub    $0xc,%esp
80102c80:	68 80 26 11 80       	push   $0x80112680
80102c85:	e8 e6 15 00 00       	call   80104270 <acquire>
    log.committing = 0;
    wakeup(&log);
80102c8a:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102c91:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102c98:	00 00 00 
    wakeup(&log);
80102c9b:	e8 10 12 00 00       	call   80103eb0 <wakeup>
    release(&log.lock);
80102ca0:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ca7:	e8 e4 16 00 00       	call   80104390 <release>
80102cac:	83 c4 10             	add    $0x10,%esp
  }
}
80102caf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cb2:	5b                   	pop    %ebx
80102cb3:	5e                   	pop    %esi
80102cb4:	5f                   	pop    %edi
80102cb5:	5d                   	pop    %ebp
80102cb6:	c3                   	ret    
80102cb7:	89 f6                	mov    %esi,%esi
80102cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80102cc0:	83 ec 0c             	sub    $0xc,%esp
80102cc3:	68 80 26 11 80       	push   $0x80112680
80102cc8:	e8 e3 11 00 00       	call   80103eb0 <wakeup>
  }
  release(&log.lock);
80102ccd:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cd4:	e8 b7 16 00 00       	call   80104390 <release>
80102cd9:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102cdc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cdf:	5b                   	pop    %ebx
80102ce0:	5e                   	pop    %esi
80102ce1:	5f                   	pop    %edi
80102ce2:	5d                   	pop    %ebp
80102ce3:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102ce4:	83 ec 0c             	sub    $0xc,%esp
80102ce7:	68 64 75 10 80       	push   $0x80107564
80102cec:	e8 7f d6 ff ff       	call   80100370 <panic>
80102cf1:	eb 0d                	jmp    80102d00 <log_write>
80102cf3:	90                   	nop
80102cf4:	90                   	nop
80102cf5:	90                   	nop
80102cf6:	90                   	nop
80102cf7:	90                   	nop
80102cf8:	90                   	nop
80102cf9:	90                   	nop
80102cfa:	90                   	nop
80102cfb:	90                   	nop
80102cfc:	90                   	nop
80102cfd:	90                   	nop
80102cfe:	90                   	nop
80102cff:	90                   	nop

80102d00 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d00:	55                   	push   %ebp
80102d01:	89 e5                	mov    %esp,%ebp
80102d03:	53                   	push   %ebx
80102d04:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d07:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d10:	83 fa 1d             	cmp    $0x1d,%edx
80102d13:	0f 8f 97 00 00 00    	jg     80102db0 <log_write+0xb0>
80102d19:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102d1e:	83 e8 01             	sub    $0x1,%eax
80102d21:	39 c2                	cmp    %eax,%edx
80102d23:	0f 8d 87 00 00 00    	jge    80102db0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d29:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d2e:	85 c0                	test   %eax,%eax
80102d30:	0f 8e 87 00 00 00    	jle    80102dbd <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d36:	83 ec 0c             	sub    $0xc,%esp
80102d39:	68 80 26 11 80       	push   $0x80112680
80102d3e:	e8 2d 15 00 00       	call   80104270 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d43:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d49:	83 c4 10             	add    $0x10,%esp
80102d4c:	83 fa 00             	cmp    $0x0,%edx
80102d4f:	7e 50                	jle    80102da1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d51:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d54:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d56:	3b 0d cc 26 11 80    	cmp    0x801126cc,%ecx
80102d5c:	75 0b                	jne    80102d69 <log_write+0x69>
80102d5e:	eb 38                	jmp    80102d98 <log_write+0x98>
80102d60:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d67:	74 2f                	je     80102d98 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d69:	83 c0 01             	add    $0x1,%eax
80102d6c:	39 d0                	cmp    %edx,%eax
80102d6e:	75 f0                	jne    80102d60 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d70:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d77:	83 c2 01             	add    $0x1,%edx
80102d7a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102d80:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d83:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102d8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d8d:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102d8e:	e9 fd 15 00 00       	jmp    80104390 <release>
80102d93:	90                   	nop
80102d94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d98:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102d9f:	eb df                	jmp    80102d80 <log_write+0x80>
80102da1:	8b 43 08             	mov    0x8(%ebx),%eax
80102da4:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102da9:	75 d5                	jne    80102d80 <log_write+0x80>
80102dab:	eb ca                	jmp    80102d77 <log_write+0x77>
80102dad:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102db0:	83 ec 0c             	sub    $0xc,%esp
80102db3:	68 73 75 10 80       	push   $0x80107573
80102db8:	e8 b3 d5 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102dbd:	83 ec 0c             	sub    $0xc,%esp
80102dc0:	68 89 75 10 80       	push   $0x80107589
80102dc5:	e8 a6 d5 ff ff       	call   80100370 <panic>
80102dca:	66 90                	xchg   %ax,%ax
80102dcc:	66 90                	xchg   %ax,%ax
80102dce:	66 90                	xchg   %ax,%ax

80102dd0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	53                   	push   %ebx
80102dd4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102dd7:	e8 54 09 00 00       	call   80103730 <cpuid>
80102ddc:	89 c3                	mov    %eax,%ebx
80102dde:	e8 4d 09 00 00       	call   80103730 <cpuid>
80102de3:	83 ec 04             	sub    $0x4,%esp
80102de6:	53                   	push   %ebx
80102de7:	50                   	push   %eax
80102de8:	68 a4 75 10 80       	push   $0x801075a4
80102ded:	e8 6e d8 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102df2:	e8 d9 28 00 00       	call   801056d0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102df7:	e8 b4 08 00 00       	call   801036b0 <mycpu>
80102dfc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102dfe:	b8 01 00 00 00       	mov    $0x1,%eax
80102e03:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e0a:	e8 01 0c 00 00       	call   80103a10 <scheduler>
80102e0f:	90                   	nop

80102e10 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e16:	e8 85 3a 00 00       	call   801068a0 <switchkvm>
  seginit();
80102e1b:	e8 f0 38 00 00       	call   80106710 <seginit>
  lapicinit();
80102e20:	e8 9b f7 ff ff       	call   801025c0 <lapicinit>
  mpmain();
80102e25:	e8 a6 ff ff ff       	call   80102dd0 <mpmain>
80102e2a:	66 90                	xchg   %ax,%ax
80102e2c:	66 90                	xchg   %ax,%ax
80102e2e:	66 90                	xchg   %ax,%ax

80102e30 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e30:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102e34:	83 e4 f0             	and    $0xfffffff0,%esp
80102e37:	ff 71 fc             	pushl  -0x4(%ecx)
80102e3a:	55                   	push   %ebp
80102e3b:	89 e5                	mov    %esp,%ebp
80102e3d:	53                   	push   %ebx
80102e3e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e3f:	bb 80 27 11 80       	mov    $0x80112780,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e44:	83 ec 08             	sub    $0x8,%esp
80102e47:	68 00 00 40 80       	push   $0x80400000
80102e4c:	68 f4 58 11 80       	push   $0x801158f4
80102e51:	e8 3a f5 ff ff       	call   80102390 <kinit1>
  kvmalloc();      // kernel page table
80102e56:	e8 e5 3e 00 00       	call   80106d40 <kvmalloc>
  mpinit();        // detect other processors
80102e5b:	e8 70 01 00 00       	call   80102fd0 <mpinit>
  lapicinit();     // interrupt controller
80102e60:	e8 5b f7 ff ff       	call   801025c0 <lapicinit>
  seginit();       // segment descriptors
80102e65:	e8 a6 38 00 00       	call   80106710 <seginit>
  picinit();       // disable pic
80102e6a:	e8 31 03 00 00       	call   801031a0 <picinit>
  ioapicinit();    // another interrupt controller
80102e6f:	e8 4c f3 ff ff       	call   801021c0 <ioapicinit>
  consoleinit();   // console hardware
80102e74:	e8 27 db ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102e79:	e8 f2 2b 00 00       	call   80105a70 <uartinit>
  pinit();         // process table
80102e7e:	e8 0d 08 00 00       	call   80103690 <pinit>
  shminit();       // shared memory
80102e83:	e8 a8 41 00 00       	call   80107030 <shminit>
  tvinit();        // trap vectors
80102e88:	e8 a3 27 00 00       	call   80105630 <tvinit>
  binit();         // buffer cache
80102e8d:	e8 ae d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102e92:	e8 89 de ff ff       	call   80100d20 <fileinit>
  ideinit();       // disk 
80102e97:	e8 04 f1 ff ff       	call   80101fa0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e9c:	83 c4 0c             	add    $0xc,%esp
80102e9f:	68 8a 00 00 00       	push   $0x8a
80102ea4:	68 8c a4 10 80       	push   $0x8010a48c
80102ea9:	68 00 70 00 80       	push   $0x80007000
80102eae:	e8 dd 15 00 00       	call   80104490 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102eb3:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102eba:	00 00 00 
80102ebd:	83 c4 10             	add    $0x10,%esp
80102ec0:	05 80 27 11 80       	add    $0x80112780,%eax
80102ec5:	39 d8                	cmp    %ebx,%eax
80102ec7:	76 6a                	jbe    80102f33 <main+0x103>
80102ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102ed0:	e8 db 07 00 00       	call   801036b0 <mycpu>
80102ed5:	39 d8                	cmp    %ebx,%eax
80102ed7:	74 41                	je     80102f1a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102ed9:	e8 82 f5 ff ff       	call   80102460 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ede:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
80102ee3:	c7 05 f8 6f 00 80 10 	movl   $0x80102e10,0x80006ff8
80102eea:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102eed:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102ef4:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ef7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102efc:	0f b6 03             	movzbl (%ebx),%eax
80102eff:	83 ec 08             	sub    $0x8,%esp
80102f02:	68 00 70 00 00       	push   $0x7000
80102f07:	50                   	push   %eax
80102f08:	e8 03 f8 ff ff       	call   80102710 <lapicstartap>
80102f0d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f10:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f16:	85 c0                	test   %eax,%eax
80102f18:	74 f6                	je     80102f10 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f1a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f21:	00 00 00 
80102f24:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f2a:	05 80 27 11 80       	add    $0x80112780,%eax
80102f2f:	39 c3                	cmp    %eax,%ebx
80102f31:	72 9d                	jb     80102ed0 <main+0xa0>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f33:	83 ec 08             	sub    $0x8,%esp
80102f36:	68 00 00 00 8e       	push   $0x8e000000
80102f3b:	68 00 00 40 80       	push   $0x80400000
80102f40:	e8 bb f4 ff ff       	call   80102400 <kinit2>
  userinit();      // first user process
80102f45:	e8 36 08 00 00       	call   80103780 <userinit>
  mpmain();        // finish this processor's setup
80102f4a:	e8 81 fe ff ff       	call   80102dd0 <mpmain>
80102f4f:	90                   	nop

80102f50 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	57                   	push   %edi
80102f54:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f55:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f5b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102f5c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f5f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f62:	39 de                	cmp    %ebx,%esi
80102f64:	73 48                	jae    80102fae <mpsearch1+0x5e>
80102f66:	8d 76 00             	lea    0x0(%esi),%esi
80102f69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f70:	83 ec 04             	sub    $0x4,%esp
80102f73:	8d 7e 10             	lea    0x10(%esi),%edi
80102f76:	6a 04                	push   $0x4
80102f78:	68 b8 75 10 80       	push   $0x801075b8
80102f7d:	56                   	push   %esi
80102f7e:	e8 ad 14 00 00       	call   80104430 <memcmp>
80102f83:	83 c4 10             	add    $0x10,%esp
80102f86:	85 c0                	test   %eax,%eax
80102f88:	75 1e                	jne    80102fa8 <mpsearch1+0x58>
80102f8a:	8d 7e 10             	lea    0x10(%esi),%edi
80102f8d:	89 f2                	mov    %esi,%edx
80102f8f:	31 c9                	xor    %ecx,%ecx
80102f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102f98:	0f b6 02             	movzbl (%edx),%eax
80102f9b:	83 c2 01             	add    $0x1,%edx
80102f9e:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102fa0:	39 fa                	cmp    %edi,%edx
80102fa2:	75 f4                	jne    80102f98 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fa4:	84 c9                	test   %cl,%cl
80102fa6:	74 10                	je     80102fb8 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fa8:	39 fb                	cmp    %edi,%ebx
80102faa:	89 fe                	mov    %edi,%esi
80102fac:	77 c2                	ja     80102f70 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102fae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102fb1:	31 c0                	xor    %eax,%eax
}
80102fb3:	5b                   	pop    %ebx
80102fb4:	5e                   	pop    %esi
80102fb5:	5f                   	pop    %edi
80102fb6:	5d                   	pop    %ebp
80102fb7:	c3                   	ret    
80102fb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fbb:	89 f0                	mov    %esi,%eax
80102fbd:	5b                   	pop    %ebx
80102fbe:	5e                   	pop    %esi
80102fbf:	5f                   	pop    %edi
80102fc0:	5d                   	pop    %ebp
80102fc1:	c3                   	ret    
80102fc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fd0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102fd0:	55                   	push   %ebp
80102fd1:	89 e5                	mov    %esp,%ebp
80102fd3:	57                   	push   %edi
80102fd4:	56                   	push   %esi
80102fd5:	53                   	push   %ebx
80102fd6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102fd9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102fe0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102fe7:	c1 e0 08             	shl    $0x8,%eax
80102fea:	09 d0                	or     %edx,%eax
80102fec:	c1 e0 04             	shl    $0x4,%eax
80102fef:	85 c0                	test   %eax,%eax
80102ff1:	75 1b                	jne    8010300e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80102ff3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102ffa:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103001:	c1 e0 08             	shl    $0x8,%eax
80103004:	09 d0                	or     %edx,%eax
80103006:	c1 e0 0a             	shl    $0xa,%eax
80103009:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010300e:	ba 00 04 00 00       	mov    $0x400,%edx
80103013:	e8 38 ff ff ff       	call   80102f50 <mpsearch1>
80103018:	85 c0                	test   %eax,%eax
8010301a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010301d:	0f 84 37 01 00 00    	je     8010315a <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103023:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103026:	8b 58 04             	mov    0x4(%eax),%ebx
80103029:	85 db                	test   %ebx,%ebx
8010302b:	0f 84 43 01 00 00    	je     80103174 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103031:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103037:	83 ec 04             	sub    $0x4,%esp
8010303a:	6a 04                	push   $0x4
8010303c:	68 bd 75 10 80       	push   $0x801075bd
80103041:	56                   	push   %esi
80103042:	e8 e9 13 00 00       	call   80104430 <memcmp>
80103047:	83 c4 10             	add    $0x10,%esp
8010304a:	85 c0                	test   %eax,%eax
8010304c:	0f 85 22 01 00 00    	jne    80103174 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103052:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103059:	3c 01                	cmp    $0x1,%al
8010305b:	74 08                	je     80103065 <mpinit+0x95>
8010305d:	3c 04                	cmp    $0x4,%al
8010305f:	0f 85 0f 01 00 00    	jne    80103174 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103065:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010306c:	85 ff                	test   %edi,%edi
8010306e:	74 21                	je     80103091 <mpinit+0xc1>
80103070:	31 d2                	xor    %edx,%edx
80103072:	31 c0                	xor    %eax,%eax
80103074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103078:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
8010307f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103080:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103083:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103085:	39 c7                	cmp    %eax,%edi
80103087:	75 ef                	jne    80103078 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103089:	84 d2                	test   %dl,%dl
8010308b:	0f 85 e3 00 00 00    	jne    80103174 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103091:	85 f6                	test   %esi,%esi
80103093:	0f 84 db 00 00 00    	je     80103174 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103099:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010309f:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030a4:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801030ab:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
801030b1:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030b6:	01 d6                	add    %edx,%esi
801030b8:	90                   	nop
801030b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030c0:	39 c6                	cmp    %eax,%esi
801030c2:	76 23                	jbe    801030e7 <mpinit+0x117>
801030c4:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
801030c7:	80 fa 04             	cmp    $0x4,%dl
801030ca:	0f 87 c0 00 00 00    	ja     80103190 <mpinit+0x1c0>
801030d0:	ff 24 95 fc 75 10 80 	jmp    *-0x7fef8a04(,%edx,4)
801030d7:	89 f6                	mov    %esi,%esi
801030d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801030e0:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030e3:	39 c6                	cmp    %eax,%esi
801030e5:	77 dd                	ja     801030c4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801030e7:	85 db                	test   %ebx,%ebx
801030e9:	0f 84 92 00 00 00    	je     80103181 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801030ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801030f2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801030f6:	74 15                	je     8010310d <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030f8:	ba 22 00 00 00       	mov    $0x22,%edx
801030fd:	b8 70 00 00 00       	mov    $0x70,%eax
80103102:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103103:	ba 23 00 00 00       	mov    $0x23,%edx
80103108:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103109:	83 c8 01             	or     $0x1,%eax
8010310c:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010310d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103110:	5b                   	pop    %ebx
80103111:	5e                   	pop    %esi
80103112:	5f                   	pop    %edi
80103113:	5d                   	pop    %ebp
80103114:	c3                   	ret    
80103115:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103118:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
8010311e:	83 f9 07             	cmp    $0x7,%ecx
80103121:	7f 19                	jg     8010313c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103123:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103127:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010312d:	83 c1 01             	add    $0x1,%ecx
80103130:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103136:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010313c:	83 c0 14             	add    $0x14,%eax
      continue;
8010313f:	e9 7c ff ff ff       	jmp    801030c0 <mpinit+0xf0>
80103144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103148:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010314c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
8010314f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      p += sizeof(struct mpioapic);
      continue;
80103155:	e9 66 ff ff ff       	jmp    801030c0 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010315a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010315f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103164:	e8 e7 fd ff ff       	call   80102f50 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103169:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010316b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010316e:	0f 85 af fe ff ff    	jne    80103023 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
80103174:	83 ec 0c             	sub    $0xc,%esp
80103177:	68 c2 75 10 80       	push   $0x801075c2
8010317c:	e8 ef d1 ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
80103181:	83 ec 0c             	sub    $0xc,%esp
80103184:	68 dc 75 10 80       	push   $0x801075dc
80103189:	e8 e2 d1 ff ff       	call   80100370 <panic>
8010318e:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103190:	31 db                	xor    %ebx,%ebx
80103192:	e9 30 ff ff ff       	jmp    801030c7 <mpinit+0xf7>
80103197:	66 90                	xchg   %ax,%ax
80103199:	66 90                	xchg   %ax,%ax
8010319b:	66 90                	xchg   %ax,%ax
8010319d:	66 90                	xchg   %ax,%ax
8010319f:	90                   	nop

801031a0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801031a0:	55                   	push   %ebp
801031a1:	ba 21 00 00 00       	mov    $0x21,%edx
801031a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801031ab:	89 e5                	mov    %esp,%ebp
801031ad:	ee                   	out    %al,(%dx)
801031ae:	ba a1 00 00 00       	mov    $0xa1,%edx
801031b3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801031b4:	5d                   	pop    %ebp
801031b5:	c3                   	ret    
801031b6:	66 90                	xchg   %ax,%ax
801031b8:	66 90                	xchg   %ax,%ax
801031ba:	66 90                	xchg   %ax,%ax
801031bc:	66 90                	xchg   %ax,%ax
801031be:	66 90                	xchg   %ax,%ax

801031c0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801031c0:	55                   	push   %ebp
801031c1:	89 e5                	mov    %esp,%ebp
801031c3:	57                   	push   %edi
801031c4:	56                   	push   %esi
801031c5:	53                   	push   %ebx
801031c6:	83 ec 0c             	sub    $0xc,%esp
801031c9:	8b 75 08             	mov    0x8(%ebp),%esi
801031cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801031cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801031d5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801031db:	e8 60 db ff ff       	call   80100d40 <filealloc>
801031e0:	85 c0                	test   %eax,%eax
801031e2:	89 06                	mov    %eax,(%esi)
801031e4:	0f 84 a8 00 00 00    	je     80103292 <pipealloc+0xd2>
801031ea:	e8 51 db ff ff       	call   80100d40 <filealloc>
801031ef:	85 c0                	test   %eax,%eax
801031f1:	89 03                	mov    %eax,(%ebx)
801031f3:	0f 84 87 00 00 00    	je     80103280 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801031f9:	e8 62 f2 ff ff       	call   80102460 <kalloc>
801031fe:	85 c0                	test   %eax,%eax
80103200:	89 c7                	mov    %eax,%edi
80103202:	0f 84 b0 00 00 00    	je     801032b8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103208:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
8010320b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103212:	00 00 00 
  p->writeopen = 1;
80103215:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010321c:	00 00 00 
  p->nwrite = 0;
8010321f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103226:	00 00 00 
  p->nread = 0;
80103229:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103230:	00 00 00 
  initlock(&p->lock, "pipe");
80103233:	68 10 76 10 80       	push   $0x80107610
80103238:	50                   	push   %eax
80103239:	e8 32 0f 00 00       	call   80104170 <initlock>
  (*f0)->type = FD_PIPE;
8010323e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103240:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103243:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103249:	8b 06                	mov    (%esi),%eax
8010324b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010324f:	8b 06                	mov    (%esi),%eax
80103251:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103255:	8b 06                	mov    (%esi),%eax
80103257:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010325a:	8b 03                	mov    (%ebx),%eax
8010325c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103262:	8b 03                	mov    (%ebx),%eax
80103264:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103268:	8b 03                	mov    (%ebx),%eax
8010326a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010326e:	8b 03                	mov    (%ebx),%eax
80103270:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103273:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103276:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103278:	5b                   	pop    %ebx
80103279:	5e                   	pop    %esi
8010327a:	5f                   	pop    %edi
8010327b:	5d                   	pop    %ebp
8010327c:	c3                   	ret    
8010327d:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103280:	8b 06                	mov    (%esi),%eax
80103282:	85 c0                	test   %eax,%eax
80103284:	74 1e                	je     801032a4 <pipealloc+0xe4>
    fileclose(*f0);
80103286:	83 ec 0c             	sub    $0xc,%esp
80103289:	50                   	push   %eax
8010328a:	e8 71 db ff ff       	call   80100e00 <fileclose>
8010328f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103292:	8b 03                	mov    (%ebx),%eax
80103294:	85 c0                	test   %eax,%eax
80103296:	74 0c                	je     801032a4 <pipealloc+0xe4>
    fileclose(*f1);
80103298:	83 ec 0c             	sub    $0xc,%esp
8010329b:	50                   	push   %eax
8010329c:	e8 5f db ff ff       	call   80100e00 <fileclose>
801032a1:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
801032a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032ac:	5b                   	pop    %ebx
801032ad:	5e                   	pop    %esi
801032ae:	5f                   	pop    %edi
801032af:	5d                   	pop    %ebp
801032b0:	c3                   	ret    
801032b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032b8:	8b 06                	mov    (%esi),%eax
801032ba:	85 c0                	test   %eax,%eax
801032bc:	75 c8                	jne    80103286 <pipealloc+0xc6>
801032be:	eb d2                	jmp    80103292 <pipealloc+0xd2>

801032c0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
801032c0:	55                   	push   %ebp
801032c1:	89 e5                	mov    %esp,%ebp
801032c3:	56                   	push   %esi
801032c4:	53                   	push   %ebx
801032c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801032cb:	83 ec 0c             	sub    $0xc,%esp
801032ce:	53                   	push   %ebx
801032cf:	e8 9c 0f 00 00       	call   80104270 <acquire>
  if(writable){
801032d4:	83 c4 10             	add    $0x10,%esp
801032d7:	85 f6                	test   %esi,%esi
801032d9:	74 45                	je     80103320 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801032db:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801032e1:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
801032e4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801032eb:	00 00 00 
    wakeup(&p->nread);
801032ee:	50                   	push   %eax
801032ef:	e8 bc 0b 00 00       	call   80103eb0 <wakeup>
801032f4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801032f7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801032fd:	85 d2                	test   %edx,%edx
801032ff:	75 0a                	jne    8010330b <pipeclose+0x4b>
80103301:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103307:	85 c0                	test   %eax,%eax
80103309:	74 35                	je     80103340 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010330b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010330e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103311:	5b                   	pop    %ebx
80103312:	5e                   	pop    %esi
80103313:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103314:	e9 77 10 00 00       	jmp    80104390 <release>
80103319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103320:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103326:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103329:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103330:	00 00 00 
    wakeup(&p->nwrite);
80103333:	50                   	push   %eax
80103334:	e8 77 0b 00 00       	call   80103eb0 <wakeup>
80103339:	83 c4 10             	add    $0x10,%esp
8010333c:	eb b9                	jmp    801032f7 <pipeclose+0x37>
8010333e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103340:	83 ec 0c             	sub    $0xc,%esp
80103343:	53                   	push   %ebx
80103344:	e8 47 10 00 00       	call   80104390 <release>
    kfree((char*)p);
80103349:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010334c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010334f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103352:	5b                   	pop    %ebx
80103353:	5e                   	pop    %esi
80103354:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103355:	e9 56 ef ff ff       	jmp    801022b0 <kfree>
8010335a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103360 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	57                   	push   %edi
80103364:	56                   	push   %esi
80103365:	53                   	push   %ebx
80103366:	83 ec 28             	sub    $0x28,%esp
80103369:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010336c:	53                   	push   %ebx
8010336d:	e8 fe 0e 00 00       	call   80104270 <acquire>
  for(i = 0; i < n; i++){
80103372:	8b 45 10             	mov    0x10(%ebp),%eax
80103375:	83 c4 10             	add    $0x10,%esp
80103378:	85 c0                	test   %eax,%eax
8010337a:	0f 8e b9 00 00 00    	jle    80103439 <pipewrite+0xd9>
80103380:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103383:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103389:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010338f:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103395:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103398:	03 4d 10             	add    0x10(%ebp),%ecx
8010339b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010339e:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801033a4:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801033aa:	39 d0                	cmp    %edx,%eax
801033ac:	74 38                	je     801033e6 <pipewrite+0x86>
801033ae:	eb 59                	jmp    80103409 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
801033b0:	e8 9b 03 00 00       	call   80103750 <myproc>
801033b5:	8b 48 24             	mov    0x24(%eax),%ecx
801033b8:	85 c9                	test   %ecx,%ecx
801033ba:	75 34                	jne    801033f0 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033bc:	83 ec 0c             	sub    $0xc,%esp
801033bf:	57                   	push   %edi
801033c0:	e8 eb 0a 00 00       	call   80103eb0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033c5:	58                   	pop    %eax
801033c6:	5a                   	pop    %edx
801033c7:	53                   	push   %ebx
801033c8:	56                   	push   %esi
801033c9:	e8 32 09 00 00       	call   80103d00 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033ce:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801033d4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801033da:	83 c4 10             	add    $0x10,%esp
801033dd:	05 00 02 00 00       	add    $0x200,%eax
801033e2:	39 c2                	cmp    %eax,%edx
801033e4:	75 2a                	jne    80103410 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
801033e6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801033ec:	85 c0                	test   %eax,%eax
801033ee:	75 c0                	jne    801033b0 <pipewrite+0x50>
        release(&p->lock);
801033f0:	83 ec 0c             	sub    $0xc,%esp
801033f3:	53                   	push   %ebx
801033f4:	e8 97 0f 00 00       	call   80104390 <release>
        return -1;
801033f9:	83 c4 10             	add    $0x10,%esp
801033fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103401:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103404:	5b                   	pop    %ebx
80103405:	5e                   	pop    %esi
80103406:	5f                   	pop    %edi
80103407:	5d                   	pop    %ebp
80103408:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103409:	89 c2                	mov    %eax,%edx
8010340b:	90                   	nop
8010340c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103410:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103413:	8d 42 01             	lea    0x1(%edx),%eax
80103416:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010341a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103420:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103426:	0f b6 09             	movzbl (%ecx),%ecx
80103429:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
8010342d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103430:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103433:	0f 85 65 ff ff ff    	jne    8010339e <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103439:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010343f:	83 ec 0c             	sub    $0xc,%esp
80103442:	50                   	push   %eax
80103443:	e8 68 0a 00 00       	call   80103eb0 <wakeup>
  release(&p->lock);
80103448:	89 1c 24             	mov    %ebx,(%esp)
8010344b:	e8 40 0f 00 00       	call   80104390 <release>
  return n;
80103450:	83 c4 10             	add    $0x10,%esp
80103453:	8b 45 10             	mov    0x10(%ebp),%eax
80103456:	eb a9                	jmp    80103401 <pipewrite+0xa1>
80103458:	90                   	nop
80103459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103460 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103460:	55                   	push   %ebp
80103461:	89 e5                	mov    %esp,%ebp
80103463:	57                   	push   %edi
80103464:	56                   	push   %esi
80103465:	53                   	push   %ebx
80103466:	83 ec 18             	sub    $0x18,%esp
80103469:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010346c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010346f:	53                   	push   %ebx
80103470:	e8 fb 0d 00 00       	call   80104270 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103475:	83 c4 10             	add    $0x10,%esp
80103478:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010347e:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
80103484:	75 6a                	jne    801034f0 <piperead+0x90>
80103486:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
8010348c:	85 f6                	test   %esi,%esi
8010348e:	0f 84 cc 00 00 00    	je     80103560 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103494:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
8010349a:	eb 2d                	jmp    801034c9 <piperead+0x69>
8010349c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034a0:	83 ec 08             	sub    $0x8,%esp
801034a3:	53                   	push   %ebx
801034a4:	56                   	push   %esi
801034a5:	e8 56 08 00 00       	call   80103d00 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034aa:	83 c4 10             	add    $0x10,%esp
801034ad:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801034b3:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
801034b9:	75 35                	jne    801034f0 <piperead+0x90>
801034bb:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
801034c1:	85 d2                	test   %edx,%edx
801034c3:	0f 84 97 00 00 00    	je     80103560 <piperead+0x100>
    if(myproc()->killed){
801034c9:	e8 82 02 00 00       	call   80103750 <myproc>
801034ce:	8b 48 24             	mov    0x24(%eax),%ecx
801034d1:	85 c9                	test   %ecx,%ecx
801034d3:	74 cb                	je     801034a0 <piperead+0x40>
      release(&p->lock);
801034d5:	83 ec 0c             	sub    $0xc,%esp
801034d8:	53                   	push   %ebx
801034d9:	e8 b2 0e 00 00       	call   80104390 <release>
      return -1;
801034de:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801034e1:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
801034e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801034e9:	5b                   	pop    %ebx
801034ea:	5e                   	pop    %esi
801034eb:	5f                   	pop    %edi
801034ec:	5d                   	pop    %ebp
801034ed:	c3                   	ret    
801034ee:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034f0:	8b 45 10             	mov    0x10(%ebp),%eax
801034f3:	85 c0                	test   %eax,%eax
801034f5:	7e 69                	jle    80103560 <piperead+0x100>
    if(p->nread == p->nwrite)
801034f7:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801034fd:	31 c9                	xor    %ecx,%ecx
801034ff:	eb 15                	jmp    80103516 <piperead+0xb6>
80103501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103508:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010350e:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103514:	74 5a                	je     80103570 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103516:	8d 70 01             	lea    0x1(%eax),%esi
80103519:	25 ff 01 00 00       	and    $0x1ff,%eax
8010351e:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103524:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103529:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010352c:	83 c1 01             	add    $0x1,%ecx
8010352f:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103532:	75 d4                	jne    80103508 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103534:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010353a:	83 ec 0c             	sub    $0xc,%esp
8010353d:	50                   	push   %eax
8010353e:	e8 6d 09 00 00       	call   80103eb0 <wakeup>
  release(&p->lock);
80103543:	89 1c 24             	mov    %ebx,(%esp)
80103546:	e8 45 0e 00 00       	call   80104390 <release>
  return i;
8010354b:	8b 45 10             	mov    0x10(%ebp),%eax
8010354e:	83 c4 10             	add    $0x10,%esp
}
80103551:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103554:	5b                   	pop    %ebx
80103555:	5e                   	pop    %esi
80103556:	5f                   	pop    %edi
80103557:	5d                   	pop    %ebp
80103558:	c3                   	ret    
80103559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103560:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103567:	eb cb                	jmp    80103534 <piperead+0xd4>
80103569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103570:	89 4d 10             	mov    %ecx,0x10(%ebp)
80103573:	eb bf                	jmp    80103534 <piperead+0xd4>
80103575:	66 90                	xchg   %ax,%ax
80103577:	66 90                	xchg   %ax,%ax
80103579:	66 90                	xchg   %ax,%ax
8010357b:	66 90                	xchg   %ax,%ax
8010357d:	66 90                	xchg   %ax,%ax
8010357f:	90                   	nop

80103580 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103580:	55                   	push   %ebp
80103581:	89 e5                	mov    %esp,%ebp
80103583:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103584:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103589:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010358c:	68 20 2d 11 80       	push   $0x80112d20
80103591:	e8 da 0c 00 00       	call   80104270 <acquire>
80103596:	83 c4 10             	add    $0x10,%esp
80103599:	eb 10                	jmp    801035ab <allocproc+0x2b>
8010359b:	90                   	nop
8010359c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035a0:	83 eb 80             	sub    $0xffffff80,%ebx
801035a3:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
801035a9:	74 75                	je     80103620 <allocproc+0xa0>
    if(p->state == UNUSED)
801035ab:	8b 43 0c             	mov    0xc(%ebx),%eax
801035ae:	85 c0                	test   %eax,%eax
801035b0:	75 ee                	jne    801035a0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801035b2:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801035b7:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801035ba:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;

  release(&ptable.lock);
801035c1:	68 20 2d 11 80       	push   $0x80112d20
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801035c6:	8d 50 01             	lea    0x1(%eax),%edx
801035c9:	89 43 10             	mov    %eax,0x10(%ebx)
801035cc:	89 15 04 a0 10 80    	mov    %edx,0x8010a004

  release(&ptable.lock);
801035d2:	e8 b9 0d 00 00       	call   80104390 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801035d7:	e8 84 ee ff ff       	call   80102460 <kalloc>
801035dc:	83 c4 10             	add    $0x10,%esp
801035df:	85 c0                	test   %eax,%eax
801035e1:	89 43 08             	mov    %eax,0x8(%ebx)
801035e4:	74 51                	je     80103637 <allocproc+0xb7>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801035e6:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801035ec:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
801035ef:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801035f4:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
801035f7:	c7 40 14 22 56 10 80 	movl   $0x80105622,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801035fe:	6a 14                	push   $0x14
80103600:	6a 00                	push   $0x0
80103602:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
80103603:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103606:	e8 d5 0d 00 00       	call   801043e0 <memset>
  p->context->eip = (uint)forkret;
8010360b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010360e:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
80103611:	c7 40 10 40 36 10 80 	movl   $0x80103640,0x10(%eax)

  return p;
80103618:	89 d8                	mov    %ebx,%eax
}
8010361a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010361d:	c9                   	leave  
8010361e:	c3                   	ret    
8010361f:	90                   	nop

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103620:	83 ec 0c             	sub    $0xc,%esp
80103623:	68 20 2d 11 80       	push   $0x80112d20
80103628:	e8 63 0d 00 00       	call   80104390 <release>
  return 0;
8010362d:	83 c4 10             	add    $0x10,%esp
80103630:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103632:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103635:	c9                   	leave  
80103636:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
80103637:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
8010363e:	eb da                	jmp    8010361a <allocproc+0x9a>

80103640 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103646:	68 20 2d 11 80       	push   $0x80112d20
8010364b:	e8 40 0d 00 00       	call   80104390 <release>

  if (first) {
80103650:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103655:	83 c4 10             	add    $0x10,%esp
80103658:	85 c0                	test   %eax,%eax
8010365a:	75 04                	jne    80103660 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010365c:	c9                   	leave  
8010365d:	c3                   	ret    
8010365e:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
80103660:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80103663:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010366a:	00 00 00 
    iinit(ROOTDEV);
8010366d:	6a 01                	push   $0x1
8010366f:	e8 cc dd ff ff       	call   80101440 <iinit>
    initlog(ROOTDEV);
80103674:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010367b:	e8 00 f4 ff ff       	call   80102a80 <initlog>
80103680:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103683:	c9                   	leave  
80103684:	c3                   	ret    
80103685:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103690 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103696:	68 15 76 10 80       	push   $0x80107615
8010369b:	68 20 2d 11 80       	push   $0x80112d20
801036a0:	e8 cb 0a 00 00       	call   80104170 <initlock>
}
801036a5:	83 c4 10             	add    $0x10,%esp
801036a8:	c9                   	leave  
801036a9:	c3                   	ret    
801036aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801036b0 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
801036b0:	55                   	push   %ebp
801036b1:	89 e5                	mov    %esp,%ebp
801036b3:	56                   	push   %esi
801036b4:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801036b5:	9c                   	pushf  
801036b6:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
801036b7:	f6 c4 02             	test   $0x2,%ah
801036ba:	75 5b                	jne    80103717 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
801036bc:	e8 ff ef ff ff       	call   801026c0 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801036c1:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801036c7:	85 f6                	test   %esi,%esi
801036c9:	7e 3f                	jle    8010370a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
801036cb:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
801036d2:	39 d0                	cmp    %edx,%eax
801036d4:	74 30                	je     80103706 <mycpu+0x56>
801036d6:	b9 30 28 11 80       	mov    $0x80112830,%ecx
801036db:	31 d2                	xor    %edx,%edx
801036dd:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
801036e0:	83 c2 01             	add    $0x1,%edx
801036e3:	39 f2                	cmp    %esi,%edx
801036e5:	74 23                	je     8010370a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
801036e7:	0f b6 19             	movzbl (%ecx),%ebx
801036ea:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801036f0:	39 d8                	cmp    %ebx,%eax
801036f2:	75 ec                	jne    801036e0 <mycpu+0x30>
      return &cpus[i];
801036f4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
801036fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036fd:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
801036fe:	05 80 27 11 80       	add    $0x80112780,%eax
  }
  panic("unknown apicid\n");
}
80103703:	5e                   	pop    %esi
80103704:	5d                   	pop    %ebp
80103705:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103706:	31 d2                	xor    %edx,%edx
80103708:	eb ea                	jmp    801036f4 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
8010370a:	83 ec 0c             	sub    $0xc,%esp
8010370d:	68 1c 76 10 80       	push   $0x8010761c
80103712:	e8 59 cc ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103717:	83 ec 0c             	sub    $0xc,%esp
8010371a:	68 f8 76 10 80       	push   $0x801076f8
8010371f:	e8 4c cc ff ff       	call   80100370 <panic>
80103724:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010372a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103730 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103736:	e8 75 ff ff ff       	call   801036b0 <mycpu>
8010373b:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103740:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
80103741:	c1 f8 04             	sar    $0x4,%eax
80103744:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010374a:	c3                   	ret    
8010374b:	90                   	nop
8010374c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103750 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80103750:	55                   	push   %ebp
80103751:	89 e5                	mov    %esp,%ebp
80103753:	53                   	push   %ebx
80103754:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80103757:	e8 d4 0a 00 00       	call   80104230 <pushcli>
  c = mycpu();
8010375c:	e8 4f ff ff ff       	call   801036b0 <mycpu>
  p = c->proc;
80103761:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103767:	e8 b4 0b 00 00       	call   80104320 <popcli>
  return p;
}
8010376c:	83 c4 04             	add    $0x4,%esp
8010376f:	89 d8                	mov    %ebx,%eax
80103771:	5b                   	pop    %ebx
80103772:	5d                   	pop    %ebp
80103773:	c3                   	ret    
80103774:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010377a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103780 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	53                   	push   %ebx
80103784:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80103787:	e8 f4 fd ff ff       	call   80103580 <allocproc>
8010378c:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
8010378e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103793:	e8 28 35 00 00       	call   80106cc0 <setupkvm>
80103798:	85 c0                	test   %eax,%eax
8010379a:	89 43 04             	mov    %eax,0x4(%ebx)
8010379d:	0f 84 bd 00 00 00    	je     80103860 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801037a3:	83 ec 04             	sub    $0x4,%esp
801037a6:	68 2c 00 00 00       	push   $0x2c
801037ab:	68 60 a4 10 80       	push   $0x8010a460
801037b0:	50                   	push   %eax
801037b1:	e8 1a 32 00 00       	call   801069d0 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
801037b6:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
801037b9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801037bf:	6a 4c                	push   $0x4c
801037c1:	6a 00                	push   $0x0
801037c3:	ff 73 18             	pushl  0x18(%ebx)
801037c6:	e8 15 0c 00 00       	call   801043e0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801037cb:	8b 43 18             	mov    0x18(%ebx),%eax
801037ce:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801037d3:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
801037d8:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801037db:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801037df:	8b 43 18             	mov    0x18(%ebx),%eax
801037e2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
801037e6:	8b 43 18             	mov    0x18(%ebx),%eax
801037e9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801037ed:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801037f1:	8b 43 18             	mov    0x18(%ebx),%eax
801037f4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801037f8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801037fc:	8b 43 18             	mov    0x18(%ebx),%eax
801037ff:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103806:	8b 43 18             	mov    0x18(%ebx),%eax
80103809:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103810:	8b 43 18             	mov    0x18(%ebx),%eax
80103813:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010381a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010381d:	6a 10                	push   $0x10
8010381f:	68 45 76 10 80       	push   $0x80107645
80103824:	50                   	push   %eax
80103825:	e8 b6 0d 00 00       	call   801045e0 <safestrcpy>
  p->cwd = namei("/");
8010382a:	c7 04 24 4e 76 10 80 	movl   $0x8010764e,(%esp)
80103831:	e8 5a e6 ff ff       	call   80101e90 <namei>
80103836:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103839:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103840:	e8 2b 0a 00 00       	call   80104270 <acquire>

  p->state = RUNNABLE;
80103845:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
8010384c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103853:	e8 38 0b 00 00       	call   80104390 <release>
}
80103858:	83 c4 10             	add    $0x10,%esp
8010385b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010385e:	c9                   	leave  
8010385f:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
80103860:	83 ec 0c             	sub    $0xc,%esp
80103863:	68 2c 76 10 80       	push   $0x8010762c
80103868:	e8 03 cb ff ff       	call   80100370 <panic>
8010386d:	8d 76 00             	lea    0x0(%esi),%esi

80103870 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80103870:	55                   	push   %ebp
80103871:	89 e5                	mov    %esp,%ebp
80103873:	56                   	push   %esi
80103874:	53                   	push   %ebx
80103875:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103878:	e8 b3 09 00 00       	call   80104230 <pushcli>
  c = mycpu();
8010387d:	e8 2e fe ff ff       	call   801036b0 <mycpu>
  p = c->proc;
80103882:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103888:	e8 93 0a 00 00       	call   80104320 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
8010388d:	83 fe 00             	cmp    $0x0,%esi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
80103890:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103892:	7e 34                	jle    801038c8 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103894:	83 ec 04             	sub    $0x4,%esp
80103897:	01 c6                	add    %eax,%esi
80103899:	56                   	push   %esi
8010389a:	50                   	push   %eax
8010389b:	ff 73 04             	pushl  0x4(%ebx)
8010389e:	e8 6d 32 00 00       	call   80106b10 <allocuvm>
801038a3:	83 c4 10             	add    $0x10,%esp
801038a6:	85 c0                	test   %eax,%eax
801038a8:	74 36                	je     801038e0 <growproc+0x70>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
801038aa:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
801038ad:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801038af:	53                   	push   %ebx
801038b0:	e8 0b 30 00 00       	call   801068c0 <switchuvm>
  return 0;
801038b5:	83 c4 10             	add    $0x10,%esp
801038b8:	31 c0                	xor    %eax,%eax
}
801038ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038bd:	5b                   	pop    %ebx
801038be:	5e                   	pop    %esi
801038bf:	5d                   	pop    %ebp
801038c0:	c3                   	ret    
801038c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
801038c8:	74 e0                	je     801038aa <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801038ca:	83 ec 04             	sub    $0x4,%esp
801038cd:	01 c6                	add    %eax,%esi
801038cf:	56                   	push   %esi
801038d0:	50                   	push   %eax
801038d1:	ff 73 04             	pushl  0x4(%ebx)
801038d4:	e8 37 33 00 00       	call   80106c10 <deallocuvm>
801038d9:	83 c4 10             	add    $0x10,%esp
801038dc:	85 c0                	test   %eax,%eax
801038de:	75 ca                	jne    801038aa <growproc+0x3a>
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
801038e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801038e5:	eb d3                	jmp    801038ba <growproc+0x4a>
801038e7:	89 f6                	mov    %esi,%esi
801038e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038f0 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	57                   	push   %edi
801038f4:	56                   	push   %esi
801038f5:	53                   	push   %ebx
801038f6:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801038f9:	e8 32 09 00 00       	call   80104230 <pushcli>
  c = mycpu();
801038fe:	e8 ad fd ff ff       	call   801036b0 <mycpu>
  p = c->proc;
80103903:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103909:	e8 12 0a 00 00       	call   80104320 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
8010390e:	e8 6d fc ff ff       	call   80103580 <allocproc>
80103913:	85 c0                	test   %eax,%eax
80103915:	89 c7                	mov    %eax,%edi
80103917:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010391a:	0f 84 bd 00 00 00    	je     801039dd <fork+0xed>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz, curproc->stack_sz)) == 0){
80103920:	83 ec 04             	sub    $0x4,%esp
80103923:	ff 73 7c             	pushl  0x7c(%ebx)
80103926:	ff 33                	pushl  (%ebx)
80103928:	ff 73 04             	pushl  0x4(%ebx)
8010392b:	e8 60 34 00 00       	call   80106d90 <copyuvm>
80103930:	83 c4 10             	add    $0x10,%esp
80103933:	85 c0                	test   %eax,%eax
80103935:	89 47 04             	mov    %eax,0x4(%edi)
80103938:	0f 84 a6 00 00 00    	je     801039e4 <fork+0xf4>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
8010393e:	8b 03                	mov    (%ebx),%eax
80103940:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103943:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103945:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103948:	89 c8                	mov    %ecx,%eax
8010394a:	8b 79 18             	mov    0x18(%ecx),%edi
8010394d:	8b 73 18             	mov    0x18(%ebx),%esi
80103950:	b9 13 00 00 00       	mov    $0x13,%ecx
80103955:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103957:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80103959:	8b 40 18             	mov    0x18(%eax),%eax
8010395c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103963:	90                   	nop
80103964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
80103968:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010396c:	85 c0                	test   %eax,%eax
8010396e:	74 13                	je     80103983 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103970:	83 ec 0c             	sub    $0xc,%esp
80103973:	50                   	push   %eax
80103974:	e8 37 d4 ff ff       	call   80100db0 <filedup>
80103979:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010397c:	83 c4 10             	add    $0x10,%esp
8010397f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80103983:	83 c6 01             	add    $0x1,%esi
80103986:	83 fe 10             	cmp    $0x10,%esi
80103989:	75 dd                	jne    80103968 <fork+0x78>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
8010398b:	83 ec 0c             	sub    $0xc,%esp
8010398e:	ff 73 68             	pushl  0x68(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103991:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
80103994:	e8 77 dc ff ff       	call   80101610 <idup>
80103999:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010399c:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
8010399f:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801039a2:	8d 47 6c             	lea    0x6c(%edi),%eax
801039a5:	6a 10                	push   $0x10
801039a7:	53                   	push   %ebx
801039a8:	50                   	push   %eax
801039a9:	e8 32 0c 00 00       	call   801045e0 <safestrcpy>

  pid = np->pid;
801039ae:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
801039b1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039b8:	e8 b3 08 00 00       	call   80104270 <acquire>

  np->state = RUNNABLE;
801039bd:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

  release(&ptable.lock);
801039c4:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039cb:	e8 c0 09 00 00       	call   80104390 <release>

  return pid;
801039d0:	83 c4 10             	add    $0x10,%esp
801039d3:	89 d8                	mov    %ebx,%eax
}
801039d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039d8:	5b                   	pop    %ebx
801039d9:	5e                   	pop    %esi
801039da:	5f                   	pop    %edi
801039db:	5d                   	pop    %ebp
801039dc:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
801039dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039e2:	eb f1                	jmp    801039d5 <fork+0xe5>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz, curproc->stack_sz)) == 0){
    kfree(np->kstack);
801039e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801039e7:	83 ec 0c             	sub    $0xc,%esp
801039ea:	ff 77 08             	pushl  0x8(%edi)
801039ed:	e8 be e8 ff ff       	call   801022b0 <kfree>
    np->kstack = 0;
801039f2:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
801039f9:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103a00:	83 c4 10             	add    $0x10,%esp
80103a03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a08:	eb cb                	jmp    801039d5 <fork+0xe5>
80103a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a10 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	57                   	push   %edi
80103a14:	56                   	push   %esi
80103a15:	53                   	push   %ebx
80103a16:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103a19:	e8 92 fc ff ff       	call   801036b0 <mycpu>
80103a1e:	8d 78 04             	lea    0x4(%eax),%edi
80103a21:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103a23:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103a2a:	00 00 00 
80103a2d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103a30:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a31:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a34:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a39:	68 20 2d 11 80       	push   $0x80112d20
80103a3e:	e8 2d 08 00 00       	call   80104270 <acquire>
80103a43:	83 c4 10             	add    $0x10,%esp
80103a46:	eb 13                	jmp    80103a5b <scheduler+0x4b>
80103a48:	90                   	nop
80103a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a50:	83 eb 80             	sub    $0xffffff80,%ebx
80103a53:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103a59:	74 45                	je     80103aa0 <scheduler+0x90>
      if(p->state != RUNNABLE)
80103a5b:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103a5f:	75 ef                	jne    80103a50 <scheduler+0x40>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103a61:	83 ec 0c             	sub    $0xc,%esp
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103a64:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103a6a:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a6b:	83 eb 80             	sub    $0xffffff80,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103a6e:	e8 4d 2e 00 00       	call   801068c0 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103a73:	58                   	pop    %eax
80103a74:	5a                   	pop    %edx
80103a75:	ff 73 9c             	pushl  -0x64(%ebx)
80103a78:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103a79:	c7 43 8c 04 00 00 00 	movl   $0x4,-0x74(%ebx)

      swtch(&(c->scheduler), p->context);
80103a80:	e8 b6 0b 00 00       	call   8010463b <swtch>
      switchkvm();
80103a85:	e8 16 2e 00 00       	call   801068a0 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103a8a:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a8d:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103a93:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103a9a:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a9d:	75 bc                	jne    80103a5b <scheduler+0x4b>
80103a9f:	90                   	nop

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103aa0:	83 ec 0c             	sub    $0xc,%esp
80103aa3:	68 20 2d 11 80       	push   $0x80112d20
80103aa8:	e8 e3 08 00 00       	call   80104390 <release>

  }
80103aad:	83 c4 10             	add    $0x10,%esp
80103ab0:	e9 7b ff ff ff       	jmp    80103a30 <scheduler+0x20>
80103ab5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ac0 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	56                   	push   %esi
80103ac4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103ac5:	e8 66 07 00 00       	call   80104230 <pushcli>
  c = mycpu();
80103aca:	e8 e1 fb ff ff       	call   801036b0 <mycpu>
  p = c->proc;
80103acf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ad5:	e8 46 08 00 00       	call   80104320 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103ada:	83 ec 0c             	sub    $0xc,%esp
80103add:	68 20 2d 11 80       	push   $0x80112d20
80103ae2:	e8 09 07 00 00       	call   801041f0 <holding>
80103ae7:	83 c4 10             	add    $0x10,%esp
80103aea:	85 c0                	test   %eax,%eax
80103aec:	74 4f                	je     80103b3d <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103aee:	e8 bd fb ff ff       	call   801036b0 <mycpu>
80103af3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103afa:	75 68                	jne    80103b64 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
80103afc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103b00:	74 55                	je     80103b57 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b02:	9c                   	pushf  
80103b03:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103b04:	f6 c4 02             	test   $0x2,%ah
80103b07:	75 41                	jne    80103b4a <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103b09:	e8 a2 fb ff ff       	call   801036b0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103b0e:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103b11:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103b17:	e8 94 fb ff ff       	call   801036b0 <mycpu>
80103b1c:	83 ec 08             	sub    $0x8,%esp
80103b1f:	ff 70 04             	pushl  0x4(%eax)
80103b22:	53                   	push   %ebx
80103b23:	e8 13 0b 00 00       	call   8010463b <swtch>
  mycpu()->intena = intena;
80103b28:	e8 83 fb ff ff       	call   801036b0 <mycpu>
}
80103b2d:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80103b30:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103b36:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b39:	5b                   	pop    %ebx
80103b3a:	5e                   	pop    %esi
80103b3b:	5d                   	pop    %ebp
80103b3c:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103b3d:	83 ec 0c             	sub    $0xc,%esp
80103b40:	68 50 76 10 80       	push   $0x80107650
80103b45:	e8 26 c8 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103b4a:	83 ec 0c             	sub    $0xc,%esp
80103b4d:	68 7c 76 10 80       	push   $0x8010767c
80103b52:	e8 19 c8 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103b57:	83 ec 0c             	sub    $0xc,%esp
80103b5a:	68 6e 76 10 80       	push   $0x8010766e
80103b5f:	e8 0c c8 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103b64:	83 ec 0c             	sub    $0xc,%esp
80103b67:	68 62 76 10 80       	push   $0x80107662
80103b6c:	e8 ff c7 ff ff       	call   80100370 <panic>
80103b71:	eb 0d                	jmp    80103b80 <exit>
80103b73:	90                   	nop
80103b74:	90                   	nop
80103b75:	90                   	nop
80103b76:	90                   	nop
80103b77:	90                   	nop
80103b78:	90                   	nop
80103b79:	90                   	nop
80103b7a:	90                   	nop
80103b7b:	90                   	nop
80103b7c:	90                   	nop
80103b7d:	90                   	nop
80103b7e:	90                   	nop
80103b7f:	90                   	nop

80103b80 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	57                   	push   %edi
80103b84:	56                   	push   %esi
80103b85:	53                   	push   %ebx
80103b86:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103b89:	e8 a2 06 00 00       	call   80104230 <pushcli>
  c = mycpu();
80103b8e:	e8 1d fb ff ff       	call   801036b0 <mycpu>
  p = c->proc;
80103b93:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103b99:	e8 82 07 00 00       	call   80104320 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103b9e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103ba4:	8d 5e 28             	lea    0x28(%esi),%ebx
80103ba7:	8d 7e 68             	lea    0x68(%esi),%edi
80103baa:	0f 84 e7 00 00 00    	je     80103c97 <exit+0x117>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103bb0:	8b 03                	mov    (%ebx),%eax
80103bb2:	85 c0                	test   %eax,%eax
80103bb4:	74 12                	je     80103bc8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103bb6:	83 ec 0c             	sub    $0xc,%esp
80103bb9:	50                   	push   %eax
80103bba:	e8 41 d2 ff ff       	call   80100e00 <fileclose>
      curproc->ofile[fd] = 0;
80103bbf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103bc5:	83 c4 10             	add    $0x10,%esp
80103bc8:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103bcb:	39 df                	cmp    %ebx,%edi
80103bcd:	75 e1                	jne    80103bb0 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103bcf:	e8 4c ef ff ff       	call   80102b20 <begin_op>
  iput(curproc->cwd);
80103bd4:	83 ec 0c             	sub    $0xc,%esp
80103bd7:	ff 76 68             	pushl  0x68(%esi)
80103bda:	e8 91 db ff ff       	call   80101770 <iput>
  end_op();
80103bdf:	e8 ac ef ff ff       	call   80102b90 <end_op>
  curproc->cwd = 0;
80103be4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)

  acquire(&ptable.lock);
80103beb:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bf2:	e8 79 06 00 00       	call   80104270 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103bf7:	8b 56 14             	mov    0x14(%esi),%edx
80103bfa:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103bfd:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103c02:	eb 0e                	jmp    80103c12 <exit+0x92>
80103c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c08:	83 e8 80             	sub    $0xffffff80,%eax
80103c0b:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103c10:	74 1c                	je     80103c2e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103c12:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103c16:	75 f0                	jne    80103c08 <exit+0x88>
80103c18:	3b 50 20             	cmp    0x20(%eax),%edx
80103c1b:	75 eb                	jne    80103c08 <exit+0x88>
      p->state = RUNNABLE;
80103c1d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c24:	83 e8 80             	sub    $0xffffff80,%eax
80103c27:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103c2c:	75 e4                	jne    80103c12 <exit+0x92>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103c2e:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
80103c34:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103c39:	eb 10                	jmp    80103c4b <exit+0xcb>
80103c3b:	90                   	nop
80103c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c40:	83 ea 80             	sub    $0xffffff80,%edx
80103c43:	81 fa 54 4d 11 80    	cmp    $0x80114d54,%edx
80103c49:	74 33                	je     80103c7e <exit+0xfe>
    if(p->parent == curproc){
80103c4b:	39 72 14             	cmp    %esi,0x14(%edx)
80103c4e:	75 f0                	jne    80103c40 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103c50:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103c54:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103c57:	75 e7                	jne    80103c40 <exit+0xc0>
80103c59:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103c5e:	eb 0a                	jmp    80103c6a <exit+0xea>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c60:	83 e8 80             	sub    $0xffffff80,%eax
80103c63:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103c68:	74 d6                	je     80103c40 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103c6a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103c6e:	75 f0                	jne    80103c60 <exit+0xe0>
80103c70:	3b 48 20             	cmp    0x20(%eax),%ecx
80103c73:	75 eb                	jne    80103c60 <exit+0xe0>
      p->state = RUNNABLE;
80103c75:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103c7c:	eb e2                	jmp    80103c60 <exit+0xe0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103c7e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103c85:	e8 36 fe ff ff       	call   80103ac0 <sched>
  panic("zombie exit");
80103c8a:	83 ec 0c             	sub    $0xc,%esp
80103c8d:	68 9d 76 10 80       	push   $0x8010769d
80103c92:	e8 d9 c6 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103c97:	83 ec 0c             	sub    $0xc,%esp
80103c9a:	68 90 76 10 80       	push   $0x80107690
80103c9f:	e8 cc c6 ff ff       	call   80100370 <panic>
80103ca4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103caa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103cb0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103cb0:	55                   	push   %ebp
80103cb1:	89 e5                	mov    %esp,%ebp
80103cb3:	53                   	push   %ebx
80103cb4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103cb7:	68 20 2d 11 80       	push   $0x80112d20
80103cbc:	e8 af 05 00 00       	call   80104270 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103cc1:	e8 6a 05 00 00       	call   80104230 <pushcli>
  c = mycpu();
80103cc6:	e8 e5 f9 ff ff       	call   801036b0 <mycpu>
  p = c->proc;
80103ccb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cd1:	e8 4a 06 00 00       	call   80104320 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
80103cd6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103cdd:	e8 de fd ff ff       	call   80103ac0 <sched>
  release(&ptable.lock);
80103ce2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ce9:	e8 a2 06 00 00       	call   80104390 <release>
}
80103cee:	83 c4 10             	add    $0x10,%esp
80103cf1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cf4:	c9                   	leave  
80103cf5:	c3                   	ret    
80103cf6:	8d 76 00             	lea    0x0(%esi),%esi
80103cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d00 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	57                   	push   %edi
80103d04:	56                   	push   %esi
80103d05:	53                   	push   %ebx
80103d06:	83 ec 0c             	sub    $0xc,%esp
80103d09:	8b 7d 08             	mov    0x8(%ebp),%edi
80103d0c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103d0f:	e8 1c 05 00 00       	call   80104230 <pushcli>
  c = mycpu();
80103d14:	e8 97 f9 ff ff       	call   801036b0 <mycpu>
  p = c->proc;
80103d19:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d1f:	e8 fc 05 00 00       	call   80104320 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80103d24:	85 db                	test   %ebx,%ebx
80103d26:	0f 84 87 00 00 00    	je     80103db3 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
80103d2c:	85 f6                	test   %esi,%esi
80103d2e:	74 76                	je     80103da6 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103d30:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103d36:	74 50                	je     80103d88 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103d38:	83 ec 0c             	sub    $0xc,%esp
80103d3b:	68 20 2d 11 80       	push   $0x80112d20
80103d40:	e8 2b 05 00 00       	call   80104270 <acquire>
    release(lk);
80103d45:	89 34 24             	mov    %esi,(%esp)
80103d48:	e8 43 06 00 00       	call   80104390 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103d4d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103d50:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103d57:	e8 64 fd ff ff       	call   80103ac0 <sched>

  // Tidy up.
  p->chan = 0;
80103d5c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103d63:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d6a:	e8 21 06 00 00       	call   80104390 <release>
    acquire(lk);
80103d6f:	89 75 08             	mov    %esi,0x8(%ebp)
80103d72:	83 c4 10             	add    $0x10,%esp
  }
}
80103d75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d78:	5b                   	pop    %ebx
80103d79:	5e                   	pop    %esi
80103d7a:	5f                   	pop    %edi
80103d7b:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103d7c:	e9 ef 04 00 00       	jmp    80104270 <acquire>
80103d81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103d88:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103d8b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103d92:	e8 29 fd ff ff       	call   80103ac0 <sched>

  // Tidy up.
  p->chan = 0;
80103d97:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103d9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103da1:	5b                   	pop    %ebx
80103da2:	5e                   	pop    %esi
80103da3:	5f                   	pop    %edi
80103da4:	5d                   	pop    %ebp
80103da5:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103da6:	83 ec 0c             	sub    $0xc,%esp
80103da9:	68 af 76 10 80       	push   $0x801076af
80103dae:	e8 bd c5 ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103db3:	83 ec 0c             	sub    $0xc,%esp
80103db6:	68 a9 76 10 80       	push   $0x801076a9
80103dbb:	e8 b0 c5 ff ff       	call   80100370 <panic>

80103dc0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	56                   	push   %esi
80103dc4:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103dc5:	e8 66 04 00 00       	call   80104230 <pushcli>
  c = mycpu();
80103dca:	e8 e1 f8 ff ff       	call   801036b0 <mycpu>
  p = c->proc;
80103dcf:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103dd5:	e8 46 05 00 00       	call   80104320 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
80103dda:	83 ec 0c             	sub    $0xc,%esp
80103ddd:	68 20 2d 11 80       	push   $0x80112d20
80103de2:	e8 89 04 00 00       	call   80104270 <acquire>
80103de7:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103dea:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dec:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103df1:	eb 10                	jmp    80103e03 <wait+0x43>
80103df3:	90                   	nop
80103df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103df8:	83 eb 80             	sub    $0xffffff80,%ebx
80103dfb:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103e01:	74 1d                	je     80103e20 <wait+0x60>
      if(p->parent != curproc)
80103e03:	39 73 14             	cmp    %esi,0x14(%ebx)
80103e06:	75 f0                	jne    80103df8 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103e08:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103e0c:	74 30                	je     80103e3e <wait+0x7e>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e0e:	83 eb 80             	sub    $0xffffff80,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103e11:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e16:	81 fb 54 4d 11 80    	cmp    $0x80114d54,%ebx
80103e1c:	75 e5                	jne    80103e03 <wait+0x43>
80103e1e:	66 90                	xchg   %ax,%ax
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103e20:	85 c0                	test   %eax,%eax
80103e22:	74 70                	je     80103e94 <wait+0xd4>
80103e24:	8b 46 24             	mov    0x24(%esi),%eax
80103e27:	85 c0                	test   %eax,%eax
80103e29:	75 69                	jne    80103e94 <wait+0xd4>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103e2b:	83 ec 08             	sub    $0x8,%esp
80103e2e:	68 20 2d 11 80       	push   $0x80112d20
80103e33:	56                   	push   %esi
80103e34:	e8 c7 fe ff ff       	call   80103d00 <sleep>
  }
80103e39:	83 c4 10             	add    $0x10,%esp
80103e3c:	eb ac                	jmp    80103dea <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103e3e:	83 ec 0c             	sub    $0xc,%esp
80103e41:	ff 73 08             	pushl  0x8(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103e44:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103e47:	e8 64 e4 ff ff       	call   801022b0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103e4c:	5a                   	pop    %edx
80103e4d:	ff 73 04             	pushl  0x4(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103e50:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103e57:	e8 e4 2d 00 00       	call   80106c40 <freevm>
        p->pid = 0;
80103e5c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103e63:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103e6a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103e6e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103e75:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103e7c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e83:	e8 08 05 00 00       	call   80104390 <release>
        return pid;
80103e88:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e8b:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103e8e:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103e90:	5b                   	pop    %ebx
80103e91:	5e                   	pop    %esi
80103e92:	5d                   	pop    %ebp
80103e93:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103e94:	83 ec 0c             	sub    $0xc,%esp
80103e97:	68 20 2d 11 80       	push   $0x80112d20
80103e9c:	e8 ef 04 00 00       	call   80104390 <release>
      return -1;
80103ea1:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103ea4:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80103ea7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103eac:	5b                   	pop    %ebx
80103ead:	5e                   	pop    %esi
80103eae:	5d                   	pop    %ebp
80103eaf:	c3                   	ret    

80103eb0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103eb0:	55                   	push   %ebp
80103eb1:	89 e5                	mov    %esp,%ebp
80103eb3:	53                   	push   %ebx
80103eb4:	83 ec 10             	sub    $0x10,%esp
80103eb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103eba:	68 20 2d 11 80       	push   $0x80112d20
80103ebf:	e8 ac 03 00 00       	call   80104270 <acquire>
80103ec4:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ec7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103ecc:	eb 0c                	jmp    80103eda <wakeup+0x2a>
80103ece:	66 90                	xchg   %ax,%ax
80103ed0:	83 e8 80             	sub    $0xffffff80,%eax
80103ed3:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103ed8:	74 1c                	je     80103ef6 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
80103eda:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ede:	75 f0                	jne    80103ed0 <wakeup+0x20>
80103ee0:	3b 58 20             	cmp    0x20(%eax),%ebx
80103ee3:	75 eb                	jne    80103ed0 <wakeup+0x20>
      p->state = RUNNABLE;
80103ee5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103eec:	83 e8 80             	sub    $0xffffff80,%eax
80103eef:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103ef4:	75 e4                	jne    80103eda <wakeup+0x2a>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103ef6:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103efd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f00:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103f01:	e9 8a 04 00 00       	jmp    80104390 <release>
80103f06:	8d 76 00             	lea    0x0(%esi),%esi
80103f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f10 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	53                   	push   %ebx
80103f14:	83 ec 10             	sub    $0x10,%esp
80103f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103f1a:	68 20 2d 11 80       	push   $0x80112d20
80103f1f:	e8 4c 03 00 00       	call   80104270 <acquire>
80103f24:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f27:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f2c:	eb 0c                	jmp    80103f3a <kill+0x2a>
80103f2e:	66 90                	xchg   %ax,%ax
80103f30:	83 e8 80             	sub    $0xffffff80,%eax
80103f33:	3d 54 4d 11 80       	cmp    $0x80114d54,%eax
80103f38:	74 3e                	je     80103f78 <kill+0x68>
    if(p->pid == pid){
80103f3a:	39 58 10             	cmp    %ebx,0x10(%eax)
80103f3d:	75 f1                	jne    80103f30 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f3f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80103f43:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103f4a:	74 1c                	je     80103f68 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103f4c:	83 ec 0c             	sub    $0xc,%esp
80103f4f:	68 20 2d 11 80       	push   $0x80112d20
80103f54:	e8 37 04 00 00       	call   80104390 <release>
      return 0;
80103f59:	83 c4 10             	add    $0x10,%esp
80103f5c:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103f5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f61:	c9                   	leave  
80103f62:	c3                   	ret    
80103f63:	90                   	nop
80103f64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80103f68:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f6f:	eb db                	jmp    80103f4c <kill+0x3c>
80103f71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80103f78:	83 ec 0c             	sub    $0xc,%esp
80103f7b:	68 20 2d 11 80       	push   $0x80112d20
80103f80:	e8 0b 04 00 00       	call   80104390 <release>
  return -1;
80103f85:	83 c4 10             	add    $0x10,%esp
80103f88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f8d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f90:	c9                   	leave  
80103f91:	c3                   	ret    
80103f92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fa0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	57                   	push   %edi
80103fa4:	56                   	push   %esi
80103fa5:	53                   	push   %ebx
80103fa6:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103fa9:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80103fae:	83 ec 3c             	sub    $0x3c,%esp
80103fb1:	eb 24                	jmp    80103fd7 <procdump+0x37>
80103fb3:	90                   	nop
80103fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103fb8:	83 ec 0c             	sub    $0xc,%esp
80103fbb:	68 6f 7a 10 80       	push   $0x80107a6f
80103fc0:	e8 9b c6 ff ff       	call   80100660 <cprintf>
80103fc5:	83 c4 10             	add    $0x10,%esp
80103fc8:	83 eb 80             	sub    $0xffffff80,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fcb:	81 fb c0 4d 11 80    	cmp    $0x80114dc0,%ebx
80103fd1:	0f 84 81 00 00 00    	je     80104058 <procdump+0xb8>
    if(p->state == UNUSED)
80103fd7:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103fda:	85 c0                	test   %eax,%eax
80103fdc:	74 ea                	je     80103fc8 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103fde:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80103fe1:	ba c0 76 10 80       	mov    $0x801076c0,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103fe6:	77 11                	ja     80103ff9 <procdump+0x59>
80103fe8:	8b 14 85 20 77 10 80 	mov    -0x7fef88e0(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80103fef:	b8 c0 76 10 80       	mov    $0x801076c0,%eax
80103ff4:	85 d2                	test   %edx,%edx
80103ff6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103ff9:	53                   	push   %ebx
80103ffa:	52                   	push   %edx
80103ffb:	ff 73 a4             	pushl  -0x5c(%ebx)
80103ffe:	68 c4 76 10 80       	push   $0x801076c4
80104003:	e8 58 c6 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104008:	83 c4 10             	add    $0x10,%esp
8010400b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010400f:	75 a7                	jne    80103fb8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104011:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104014:	83 ec 08             	sub    $0x8,%esp
80104017:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010401a:	50                   	push   %eax
8010401b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010401e:	8b 40 0c             	mov    0xc(%eax),%eax
80104021:	83 c0 08             	add    $0x8,%eax
80104024:	50                   	push   %eax
80104025:	e8 66 01 00 00       	call   80104190 <getcallerpcs>
8010402a:	83 c4 10             	add    $0x10,%esp
8010402d:	8d 76 00             	lea    0x0(%esi),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104030:	8b 17                	mov    (%edi),%edx
80104032:	85 d2                	test   %edx,%edx
80104034:	74 82                	je     80103fb8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104036:	83 ec 08             	sub    $0x8,%esp
80104039:	83 c7 04             	add    $0x4,%edi
8010403c:	52                   	push   %edx
8010403d:	68 01 71 10 80       	push   $0x80107101
80104042:	e8 19 c6 ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104047:	83 c4 10             	add    $0x10,%esp
8010404a:	39 f7                	cmp    %esi,%edi
8010404c:	75 e2                	jne    80104030 <procdump+0x90>
8010404e:	e9 65 ff ff ff       	jmp    80103fb8 <procdump+0x18>
80104053:	90                   	nop
80104054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104058:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010405b:	5b                   	pop    %ebx
8010405c:	5e                   	pop    %esi
8010405d:	5f                   	pop    %edi
8010405e:	5d                   	pop    %ebp
8010405f:	c3                   	ret    

80104060 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	53                   	push   %ebx
80104064:	83 ec 0c             	sub    $0xc,%esp
80104067:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010406a:	68 38 77 10 80       	push   $0x80107738
8010406f:	8d 43 04             	lea    0x4(%ebx),%eax
80104072:	50                   	push   %eax
80104073:	e8 f8 00 00 00       	call   80104170 <initlock>
  lk->name = name;
80104078:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010407b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104081:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
80104084:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
8010408b:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
8010408e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104091:	c9                   	leave  
80104092:	c3                   	ret    
80104093:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801040a0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801040a0:	55                   	push   %ebp
801040a1:	89 e5                	mov    %esp,%ebp
801040a3:	56                   	push   %esi
801040a4:	53                   	push   %ebx
801040a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801040a8:	83 ec 0c             	sub    $0xc,%esp
801040ab:	8d 73 04             	lea    0x4(%ebx),%esi
801040ae:	56                   	push   %esi
801040af:	e8 bc 01 00 00       	call   80104270 <acquire>
  while (lk->locked) {
801040b4:	8b 13                	mov    (%ebx),%edx
801040b6:	83 c4 10             	add    $0x10,%esp
801040b9:	85 d2                	test   %edx,%edx
801040bb:	74 16                	je     801040d3 <acquiresleep+0x33>
801040bd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801040c0:	83 ec 08             	sub    $0x8,%esp
801040c3:	56                   	push   %esi
801040c4:	53                   	push   %ebx
801040c5:	e8 36 fc ff ff       	call   80103d00 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
801040ca:	8b 03                	mov    (%ebx),%eax
801040cc:	83 c4 10             	add    $0x10,%esp
801040cf:	85 c0                	test   %eax,%eax
801040d1:	75 ed                	jne    801040c0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
801040d3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801040d9:	e8 72 f6 ff ff       	call   80103750 <myproc>
801040de:	8b 40 10             	mov    0x10(%eax),%eax
801040e1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801040e4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801040e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801040ea:	5b                   	pop    %ebx
801040eb:	5e                   	pop    %esi
801040ec:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
801040ed:	e9 9e 02 00 00       	jmp    80104390 <release>
801040f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104100 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	56                   	push   %esi
80104104:	53                   	push   %ebx
80104105:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104108:	83 ec 0c             	sub    $0xc,%esp
8010410b:	8d 73 04             	lea    0x4(%ebx),%esi
8010410e:	56                   	push   %esi
8010410f:	e8 5c 01 00 00       	call   80104270 <acquire>
  lk->locked = 0;
80104114:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010411a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104121:	89 1c 24             	mov    %ebx,(%esp)
80104124:	e8 87 fd ff ff       	call   80103eb0 <wakeup>
  release(&lk->lk);
80104129:	89 75 08             	mov    %esi,0x8(%ebp)
8010412c:	83 c4 10             	add    $0x10,%esp
}
8010412f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104132:	5b                   	pop    %ebx
80104133:	5e                   	pop    %esi
80104134:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104135:	e9 56 02 00 00       	jmp    80104390 <release>
8010413a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104140 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	56                   	push   %esi
80104144:	53                   	push   %ebx
80104145:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104148:	83 ec 0c             	sub    $0xc,%esp
8010414b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010414e:	53                   	push   %ebx
8010414f:	e8 1c 01 00 00       	call   80104270 <acquire>
  r = lk->locked;
80104154:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104156:	89 1c 24             	mov    %ebx,(%esp)
80104159:	e8 32 02 00 00       	call   80104390 <release>
  return r;
}
8010415e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104161:	89 f0                	mov    %esi,%eax
80104163:	5b                   	pop    %ebx
80104164:	5e                   	pop    %esi
80104165:	5d                   	pop    %ebp
80104166:	c3                   	ret    
80104167:	66 90                	xchg   %ax,%ax
80104169:	66 90                	xchg   %ax,%ax
8010416b:	66 90                	xchg   %ax,%ax
8010416d:	66 90                	xchg   %ax,%ax
8010416f:	90                   	nop

80104170 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104170:	55                   	push   %ebp
80104171:	89 e5                	mov    %esp,%ebp
80104173:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104176:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104179:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
8010417f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104182:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104189:	5d                   	pop    %ebp
8010418a:	c3                   	ret    
8010418b:	90                   	nop
8010418c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104190 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104194:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104197:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010419a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010419d:	31 c0                	xor    %eax,%eax
8010419f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801041a0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801041a6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801041ac:	77 1a                	ja     801041c8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801041ae:	8b 5a 04             	mov    0x4(%edx),%ebx
801041b1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801041b4:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801041b7:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801041b9:	83 f8 0a             	cmp    $0xa,%eax
801041bc:	75 e2                	jne    801041a0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801041be:	5b                   	pop    %ebx
801041bf:	5d                   	pop    %ebp
801041c0:	c3                   	ret    
801041c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801041c8:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801041cf:	83 c0 01             	add    $0x1,%eax
801041d2:	83 f8 0a             	cmp    $0xa,%eax
801041d5:	74 e7                	je     801041be <getcallerpcs+0x2e>
    pcs[i] = 0;
801041d7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801041de:	83 c0 01             	add    $0x1,%eax
801041e1:	83 f8 0a             	cmp    $0xa,%eax
801041e4:	75 e2                	jne    801041c8 <getcallerpcs+0x38>
801041e6:	eb d6                	jmp    801041be <getcallerpcs+0x2e>
801041e8:	90                   	nop
801041e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041f0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	53                   	push   %ebx
801041f4:	83 ec 04             	sub    $0x4,%esp
801041f7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801041fa:	8b 02                	mov    (%edx),%eax
801041fc:	85 c0                	test   %eax,%eax
801041fe:	75 10                	jne    80104210 <holding+0x20>
}
80104200:	83 c4 04             	add    $0x4,%esp
80104203:	31 c0                	xor    %eax,%eax
80104205:	5b                   	pop    %ebx
80104206:	5d                   	pop    %ebp
80104207:	c3                   	ret    
80104208:	90                   	nop
80104209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104210:	8b 5a 08             	mov    0x8(%edx),%ebx
80104213:	e8 98 f4 ff ff       	call   801036b0 <mycpu>
80104218:	39 c3                	cmp    %eax,%ebx
8010421a:	0f 94 c0             	sete   %al
}
8010421d:	83 c4 04             	add    $0x4,%esp

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104220:	0f b6 c0             	movzbl %al,%eax
}
80104223:	5b                   	pop    %ebx
80104224:	5d                   	pop    %ebp
80104225:	c3                   	ret    
80104226:	8d 76 00             	lea    0x0(%esi),%esi
80104229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104230 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	53                   	push   %ebx
80104234:	83 ec 04             	sub    $0x4,%esp
80104237:	9c                   	pushf  
80104238:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104239:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010423a:	e8 71 f4 ff ff       	call   801036b0 <mycpu>
8010423f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104245:	85 c0                	test   %eax,%eax
80104247:	75 11                	jne    8010425a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104249:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010424f:	e8 5c f4 ff ff       	call   801036b0 <mycpu>
80104254:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010425a:	e8 51 f4 ff ff       	call   801036b0 <mycpu>
8010425f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104266:	83 c4 04             	add    $0x4,%esp
80104269:	5b                   	pop    %ebx
8010426a:	5d                   	pop    %ebp
8010426b:	c3                   	ret    
8010426c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104270 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	56                   	push   %esi
80104274:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104275:	e8 b6 ff ff ff       	call   80104230 <pushcli>
  if(holding(lk))
8010427a:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
8010427d:	8b 03                	mov    (%ebx),%eax
8010427f:	85 c0                	test   %eax,%eax
80104281:	75 7d                	jne    80104300 <acquire+0x90>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104283:	ba 01 00 00 00       	mov    $0x1,%edx
80104288:	eb 09                	jmp    80104293 <acquire+0x23>
8010428a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104290:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104293:	89 d0                	mov    %edx,%eax
80104295:	f0 87 03             	lock xchg %eax,(%ebx)
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104298:	85 c0                	test   %eax,%eax
8010429a:	75 f4                	jne    80104290 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010429c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801042a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801042a4:	e8 07 f4 ff ff       	call   801036b0 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801042a9:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
801042ab:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801042ae:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801042b1:	31 c0                	xor    %eax,%eax
801042b3:	90                   	nop
801042b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801042b8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801042be:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801042c4:	77 1a                	ja     801042e0 <acquire+0x70>
      break;
    pcs[i] = ebp[1];     // saved %eip
801042c6:	8b 5a 04             	mov    0x4(%edx),%ebx
801042c9:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801042cc:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801042cf:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801042d1:	83 f8 0a             	cmp    $0xa,%eax
801042d4:	75 e2                	jne    801042b8 <acquire+0x48>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
801042d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042d9:	5b                   	pop    %ebx
801042da:	5e                   	pop    %esi
801042db:	5d                   	pop    %ebp
801042dc:	c3                   	ret    
801042dd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801042e0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801042e7:	83 c0 01             	add    $0x1,%eax
801042ea:	83 f8 0a             	cmp    $0xa,%eax
801042ed:	74 e7                	je     801042d6 <acquire+0x66>
    pcs[i] = 0;
801042ef:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801042f6:	83 c0 01             	add    $0x1,%eax
801042f9:	83 f8 0a             	cmp    $0xa,%eax
801042fc:	75 e2                	jne    801042e0 <acquire+0x70>
801042fe:	eb d6                	jmp    801042d6 <acquire+0x66>

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104300:	8b 73 08             	mov    0x8(%ebx),%esi
80104303:	e8 a8 f3 ff ff       	call   801036b0 <mycpu>
80104308:	39 c6                	cmp    %eax,%esi
8010430a:	0f 85 73 ff ff ff    	jne    80104283 <acquire+0x13>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104310:	83 ec 0c             	sub    $0xc,%esp
80104313:	68 43 77 10 80       	push   $0x80107743
80104318:	e8 53 c0 ff ff       	call   80100370 <panic>
8010431d:	8d 76 00             	lea    0x0(%esi),%esi

80104320 <popcli>:
  mycpu()->ncli += 1;
}

void
popcli(void)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104326:	9c                   	pushf  
80104327:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104328:	f6 c4 02             	test   $0x2,%ah
8010432b:	75 52                	jne    8010437f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010432d:	e8 7e f3 ff ff       	call   801036b0 <mycpu>
80104332:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104338:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010433b:	85 d2                	test   %edx,%edx
8010433d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104343:	78 2d                	js     80104372 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104345:	e8 66 f3 ff ff       	call   801036b0 <mycpu>
8010434a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104350:	85 d2                	test   %edx,%edx
80104352:	74 0c                	je     80104360 <popcli+0x40>
    sti();
}
80104354:	c9                   	leave  
80104355:	c3                   	ret    
80104356:	8d 76 00             	lea    0x0(%esi),%esi
80104359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104360:	e8 4b f3 ff ff       	call   801036b0 <mycpu>
80104365:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010436b:	85 c0                	test   %eax,%eax
8010436d:	74 e5                	je     80104354 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
8010436f:	fb                   	sti    
    sti();
}
80104370:	c9                   	leave  
80104371:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104372:	83 ec 0c             	sub    $0xc,%esp
80104375:	68 62 77 10 80       	push   $0x80107762
8010437a:	e8 f1 bf ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
8010437f:	83 ec 0c             	sub    $0xc,%esp
80104382:	68 4b 77 10 80       	push   $0x8010774b
80104387:	e8 e4 bf ff ff       	call   80100370 <panic>
8010438c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104390 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	56                   	push   %esi
80104394:	53                   	push   %ebx
80104395:	8b 5d 08             	mov    0x8(%ebp),%ebx

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
80104398:	8b 03                	mov    (%ebx),%eax
8010439a:	85 c0                	test   %eax,%eax
8010439c:	75 12                	jne    801043b0 <release+0x20>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
8010439e:	83 ec 0c             	sub    $0xc,%esp
801043a1:	68 69 77 10 80       	push   $0x80107769
801043a6:	e8 c5 bf ff ff       	call   80100370 <panic>
801043ab:	90                   	nop
801043ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
  return lock->locked && lock->cpu == mycpu();
801043b0:	8b 73 08             	mov    0x8(%ebx),%esi
801043b3:	e8 f8 f2 ff ff       	call   801036b0 <mycpu>
801043b8:	39 c6                	cmp    %eax,%esi
801043ba:	75 e2                	jne    8010439e <release+0xe>
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");

  lk->pcs[0] = 0;
801043bc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801043c3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801043ca:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801043cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
801043d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043d8:	5b                   	pop    %ebx
801043d9:	5e                   	pop    %esi
801043da:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
801043db:	e9 40 ff ff ff       	jmp    80104320 <popcli>

801043e0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	57                   	push   %edi
801043e4:	53                   	push   %ebx
801043e5:	8b 55 08             	mov    0x8(%ebp),%edx
801043e8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801043eb:	f6 c2 03             	test   $0x3,%dl
801043ee:	75 05                	jne    801043f5 <memset+0x15>
801043f0:	f6 c1 03             	test   $0x3,%cl
801043f3:	74 13                	je     80104408 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
801043f5:	89 d7                	mov    %edx,%edi
801043f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801043fa:	fc                   	cld    
801043fb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801043fd:	5b                   	pop    %ebx
801043fe:	89 d0                	mov    %edx,%eax
80104400:	5f                   	pop    %edi
80104401:	5d                   	pop    %ebp
80104402:	c3                   	ret    
80104403:	90                   	nop
80104404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104408:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
8010440c:	c1 e9 02             	shr    $0x2,%ecx
8010440f:	89 fb                	mov    %edi,%ebx
80104411:	89 f8                	mov    %edi,%eax
80104413:	c1 e3 18             	shl    $0x18,%ebx
80104416:	c1 e0 10             	shl    $0x10,%eax
80104419:	09 d8                	or     %ebx,%eax
8010441b:	09 f8                	or     %edi,%eax
8010441d:	c1 e7 08             	shl    $0x8,%edi
80104420:	09 f8                	or     %edi,%eax
80104422:	89 d7                	mov    %edx,%edi
80104424:	fc                   	cld    
80104425:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104427:	5b                   	pop    %ebx
80104428:	89 d0                	mov    %edx,%eax
8010442a:	5f                   	pop    %edi
8010442b:	5d                   	pop    %ebp
8010442c:	c3                   	ret    
8010442d:	8d 76 00             	lea    0x0(%esi),%esi

80104430 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	57                   	push   %edi
80104434:	56                   	push   %esi
80104435:	8b 45 10             	mov    0x10(%ebp),%eax
80104438:	53                   	push   %ebx
80104439:	8b 75 0c             	mov    0xc(%ebp),%esi
8010443c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010443f:	85 c0                	test   %eax,%eax
80104441:	74 29                	je     8010446c <memcmp+0x3c>
    if(*s1 != *s2)
80104443:	0f b6 13             	movzbl (%ebx),%edx
80104446:	0f b6 0e             	movzbl (%esi),%ecx
80104449:	38 d1                	cmp    %dl,%cl
8010444b:	75 2b                	jne    80104478 <memcmp+0x48>
8010444d:	8d 78 ff             	lea    -0x1(%eax),%edi
80104450:	31 c0                	xor    %eax,%eax
80104452:	eb 14                	jmp    80104468 <memcmp+0x38>
80104454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104458:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
8010445d:	83 c0 01             	add    $0x1,%eax
80104460:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104464:	38 ca                	cmp    %cl,%dl
80104466:	75 10                	jne    80104478 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104468:	39 f8                	cmp    %edi,%eax
8010446a:	75 ec                	jne    80104458 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010446c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010446d:	31 c0                	xor    %eax,%eax
}
8010446f:	5e                   	pop    %esi
80104470:	5f                   	pop    %edi
80104471:	5d                   	pop    %ebp
80104472:	c3                   	ret    
80104473:	90                   	nop
80104474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104478:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
8010447b:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
8010447c:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010447e:	5e                   	pop    %esi
8010447f:	5f                   	pop    %edi
80104480:	5d                   	pop    %ebp
80104481:	c3                   	ret    
80104482:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104490 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	56                   	push   %esi
80104494:	53                   	push   %ebx
80104495:	8b 45 08             	mov    0x8(%ebp),%eax
80104498:	8b 75 0c             	mov    0xc(%ebp),%esi
8010449b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010449e:	39 c6                	cmp    %eax,%esi
801044a0:	73 2e                	jae    801044d0 <memmove+0x40>
801044a2:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
801044a5:	39 c8                	cmp    %ecx,%eax
801044a7:	73 27                	jae    801044d0 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
801044a9:	85 db                	test   %ebx,%ebx
801044ab:	8d 53 ff             	lea    -0x1(%ebx),%edx
801044ae:	74 17                	je     801044c7 <memmove+0x37>
      *--d = *--s;
801044b0:	29 d9                	sub    %ebx,%ecx
801044b2:	89 cb                	mov    %ecx,%ebx
801044b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044b8:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801044bc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801044bf:	83 ea 01             	sub    $0x1,%edx
801044c2:	83 fa ff             	cmp    $0xffffffff,%edx
801044c5:	75 f1                	jne    801044b8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801044c7:	5b                   	pop    %ebx
801044c8:	5e                   	pop    %esi
801044c9:	5d                   	pop    %ebp
801044ca:	c3                   	ret    
801044cb:	90                   	nop
801044cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801044d0:	31 d2                	xor    %edx,%edx
801044d2:	85 db                	test   %ebx,%ebx
801044d4:	74 f1                	je     801044c7 <memmove+0x37>
801044d6:	8d 76 00             	lea    0x0(%esi),%esi
801044d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
801044e0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801044e4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801044e7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801044ea:	39 d3                	cmp    %edx,%ebx
801044ec:	75 f2                	jne    801044e0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
801044ee:	5b                   	pop    %ebx
801044ef:	5e                   	pop    %esi
801044f0:	5d                   	pop    %ebp
801044f1:	c3                   	ret    
801044f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104500 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104503:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104504:	eb 8a                	jmp    80104490 <memmove>
80104506:	8d 76 00             	lea    0x0(%esi),%esi
80104509:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104510 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	57                   	push   %edi
80104514:	56                   	push   %esi
80104515:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104518:	53                   	push   %ebx
80104519:	8b 7d 08             	mov    0x8(%ebp),%edi
8010451c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010451f:	85 c9                	test   %ecx,%ecx
80104521:	74 37                	je     8010455a <strncmp+0x4a>
80104523:	0f b6 17             	movzbl (%edi),%edx
80104526:	0f b6 1e             	movzbl (%esi),%ebx
80104529:	84 d2                	test   %dl,%dl
8010452b:	74 3f                	je     8010456c <strncmp+0x5c>
8010452d:	38 d3                	cmp    %dl,%bl
8010452f:	75 3b                	jne    8010456c <strncmp+0x5c>
80104531:	8d 47 01             	lea    0x1(%edi),%eax
80104534:	01 cf                	add    %ecx,%edi
80104536:	eb 1b                	jmp    80104553 <strncmp+0x43>
80104538:	90                   	nop
80104539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104540:	0f b6 10             	movzbl (%eax),%edx
80104543:	84 d2                	test   %dl,%dl
80104545:	74 21                	je     80104568 <strncmp+0x58>
80104547:	0f b6 19             	movzbl (%ecx),%ebx
8010454a:	83 c0 01             	add    $0x1,%eax
8010454d:	89 ce                	mov    %ecx,%esi
8010454f:	38 da                	cmp    %bl,%dl
80104551:	75 19                	jne    8010456c <strncmp+0x5c>
80104553:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
80104555:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104558:	75 e6                	jne    80104540 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
8010455a:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
8010455b:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
8010455d:	5e                   	pop    %esi
8010455e:	5f                   	pop    %edi
8010455f:	5d                   	pop    %ebp
80104560:	c3                   	ret    
80104561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104568:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
8010456c:	0f b6 c2             	movzbl %dl,%eax
8010456f:	29 d8                	sub    %ebx,%eax
}
80104571:	5b                   	pop    %ebx
80104572:	5e                   	pop    %esi
80104573:	5f                   	pop    %edi
80104574:	5d                   	pop    %ebp
80104575:	c3                   	ret    
80104576:	8d 76 00             	lea    0x0(%esi),%esi
80104579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104580 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	56                   	push   %esi
80104584:	53                   	push   %ebx
80104585:	8b 45 08             	mov    0x8(%ebp),%eax
80104588:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010458b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010458e:	89 c2                	mov    %eax,%edx
80104590:	eb 19                	jmp    801045ab <strncpy+0x2b>
80104592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104598:	83 c3 01             	add    $0x1,%ebx
8010459b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010459f:	83 c2 01             	add    $0x1,%edx
801045a2:	84 c9                	test   %cl,%cl
801045a4:	88 4a ff             	mov    %cl,-0x1(%edx)
801045a7:	74 09                	je     801045b2 <strncpy+0x32>
801045a9:	89 f1                	mov    %esi,%ecx
801045ab:	85 c9                	test   %ecx,%ecx
801045ad:	8d 71 ff             	lea    -0x1(%ecx),%esi
801045b0:	7f e6                	jg     80104598 <strncpy+0x18>
    ;
  while(n-- > 0)
801045b2:	31 c9                	xor    %ecx,%ecx
801045b4:	85 f6                	test   %esi,%esi
801045b6:	7e 17                	jle    801045cf <strncpy+0x4f>
801045b8:	90                   	nop
801045b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
801045c0:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801045c4:	89 f3                	mov    %esi,%ebx
801045c6:	83 c1 01             	add    $0x1,%ecx
801045c9:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801045cb:	85 db                	test   %ebx,%ebx
801045cd:	7f f1                	jg     801045c0 <strncpy+0x40>
    *s++ = 0;
  return os;
}
801045cf:	5b                   	pop    %ebx
801045d0:	5e                   	pop    %esi
801045d1:	5d                   	pop    %ebp
801045d2:	c3                   	ret    
801045d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801045d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045e0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	56                   	push   %esi
801045e4:	53                   	push   %ebx
801045e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801045e8:	8b 45 08             	mov    0x8(%ebp),%eax
801045eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801045ee:	85 c9                	test   %ecx,%ecx
801045f0:	7e 26                	jle    80104618 <safestrcpy+0x38>
801045f2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801045f6:	89 c1                	mov    %eax,%ecx
801045f8:	eb 17                	jmp    80104611 <safestrcpy+0x31>
801045fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104600:	83 c2 01             	add    $0x1,%edx
80104603:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104607:	83 c1 01             	add    $0x1,%ecx
8010460a:	84 db                	test   %bl,%bl
8010460c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010460f:	74 04                	je     80104615 <safestrcpy+0x35>
80104611:	39 f2                	cmp    %esi,%edx
80104613:	75 eb                	jne    80104600 <safestrcpy+0x20>
    ;
  *s = 0;
80104615:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104618:	5b                   	pop    %ebx
80104619:	5e                   	pop    %esi
8010461a:	5d                   	pop    %ebp
8010461b:	c3                   	ret    
8010461c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104620 <strlen>:

int
strlen(const char *s)
{
80104620:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104621:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104623:	89 e5                	mov    %esp,%ebp
80104625:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104628:	80 3a 00             	cmpb   $0x0,(%edx)
8010462b:	74 0c                	je     80104639 <strlen+0x19>
8010462d:	8d 76 00             	lea    0x0(%esi),%esi
80104630:	83 c0 01             	add    $0x1,%eax
80104633:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104637:	75 f7                	jne    80104630 <strlen+0x10>
    ;
  return n;
}
80104639:	5d                   	pop    %ebp
8010463a:	c3                   	ret    

8010463b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010463b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010463f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104643:	55                   	push   %ebp
  pushl %ebx
80104644:	53                   	push   %ebx
  pushl %esi
80104645:	56                   	push   %esi
  pushl %edi
80104646:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104647:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104649:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010464b:	5f                   	pop    %edi
  popl %esi
8010464c:	5e                   	pop    %esi
  popl %ebx
8010464d:	5b                   	pop    %ebx
  popl %ebp
8010464e:	5d                   	pop    %ebp
  ret
8010464f:	c3                   	ret    

80104650 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
  //cs153 updated sz check
  //if(((addr >= curproc->sz || addr+4 > curproc->sz) && (addr < ((KERNBASE - 1) - curproc->stack_sz))) || addr > (KERNBASE - 1)){
    //return -1;
  //}
  //cs153
  *ip = *(int*)(addr);
80104653:	8b 45 08             	mov    0x8(%ebp),%eax
80104656:	8b 10                	mov    (%eax),%edx
80104658:	8b 45 0c             	mov    0xc(%ebp),%eax
8010465b:	89 10                	mov    %edx,(%eax)
  return 0;
}
8010465d:	31 c0                	xor    %eax,%eax
8010465f:	5d                   	pop    %ebp
80104660:	c3                   	ret    
80104661:	eb 0d                	jmp    80104670 <fetchstr>
80104663:	90                   	nop
80104664:	90                   	nop
80104665:	90                   	nop
80104666:	90                   	nop
80104667:	90                   	nop
80104668:	90                   	nop
80104669:	90                   	nop
8010466a:	90                   	nop
8010466b:	90                   	nop
8010466c:	90                   	nop
8010466d:	90                   	nop
8010466e:	90                   	nop
8010466f:	90                   	nop

80104670 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	53                   	push   %ebx
80104674:	83 ec 04             	sub    $0x4,%esp
80104677:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010467a:	e8 d1 f0 ff ff       	call   80103750 <myproc>

  //cs153 removed sz check
  *pp = (char*)addr;
8010467f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104682:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104684:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104686:	39 c3                	cmp    %eax,%ebx
80104688:	73 1a                	jae    801046a4 <fetchstr+0x34>
    if(*s == 0)
8010468a:	80 3b 00             	cmpb   $0x0,(%ebx)
8010468d:	89 da                	mov    %ebx,%edx
8010468f:	75 0c                	jne    8010469d <fetchstr+0x2d>
80104691:	eb 1d                	jmp    801046b0 <fetchstr+0x40>
80104693:	90                   	nop
80104694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104698:	80 3a 00             	cmpb   $0x0,(%edx)
8010469b:	74 13                	je     801046b0 <fetchstr+0x40>
  struct proc *curproc = myproc();

  //cs153 removed sz check
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
8010469d:	83 c2 01             	add    $0x1,%edx
801046a0:	39 d0                	cmp    %edx,%eax
801046a2:	77 f4                	ja     80104698 <fetchstr+0x28>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
801046a4:	83 c4 04             	add    $0x4,%esp
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
801046a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801046ac:	5b                   	pop    %ebx
801046ad:	5d                   	pop    %ebp
801046ae:	c3                   	ret    
801046af:	90                   	nop
801046b0:	83 c4 04             	add    $0x4,%esp
  //cs153 removed sz check
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
801046b3:	89 d0                	mov    %edx,%eax
801046b5:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801046b7:	5b                   	pop    %ebx
801046b8:	5d                   	pop    %ebp
801046b9:	c3                   	ret    
801046ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046c0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{  
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	83 ec 08             	sub    $0x8,%esp
  //cs153
  //if(ip == 0){
    //return -1;
  //}
  //cs153
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801046c6:	e8 85 f0 ff ff       	call   80103750 <myproc>
801046cb:	8b 40 18             	mov    0x18(%eax),%eax
  //cs153 updated sz check
  //if(((addr >= curproc->sz || addr+4 > curproc->sz) && (addr < ((KERNBASE - 1) - curproc->stack_sz))) || addr > (KERNBASE - 1)){
    //return -1;
  //}
  //cs153
  *ip = *(int*)(addr);
801046ce:	8b 55 08             	mov    0x8(%ebp),%edx
801046d1:	8b 40 44             	mov    0x44(%eax),%eax
801046d4:	8b 54 90 04          	mov    0x4(%eax,%edx,4),%edx
801046d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801046db:	89 10                	mov    %edx,(%eax)
  //if(ip == 0){
    //return -1;
  //}
  //cs153
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
801046dd:	31 c0                	xor    %eax,%eax
801046df:	c9                   	leave  
801046e0:	c3                   	ret    
801046e1:	eb 0d                	jmp    801046f0 <argptr>
801046e3:	90                   	nop
801046e4:	90                   	nop
801046e5:	90                   	nop
801046e6:	90                   	nop
801046e7:	90                   	nop
801046e8:	90                   	nop
801046e9:	90                   	nop
801046ea:	90                   	nop
801046eb:	90                   	nop
801046ec:	90                   	nop
801046ed:	90                   	nop
801046ee:	90                   	nop
801046ef:	90                   	nop

801046f0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	83 ec 08             	sub    $0x8,%esp
  //cs153
  //if(ip == 0){
    //return -1;
  //}
  //cs153
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801046f6:	e8 55 f0 ff ff       	call   80103750 <myproc>
801046fb:	8b 40 18             	mov    0x18(%eax),%eax
  //}
  //cs153
  if(argint(n, &i) < 0)
    return -1;
  //cs153 removed sz check
  *pp = (char*)i;
801046fe:	8b 55 08             	mov    0x8(%ebp),%edx
  //cs153 updated sz check
  //if(((addr >= curproc->sz || addr+4 > curproc->sz) && (addr < ((KERNBASE - 1) - curproc->stack_sz))) || addr > (KERNBASE - 1)){
    //return -1;
  //}
  //cs153
  *ip = *(int*)(addr);
80104701:	8b 40 44             	mov    0x44(%eax),%eax
  //}
  //cs153
  if(argint(n, &i) < 0)
    return -1;
  //cs153 removed sz check
  *pp = (char*)i;
80104704:	8b 54 90 04          	mov    0x4(%eax,%edx,4),%edx
80104708:	8b 45 0c             	mov    0xc(%ebp),%eax
8010470b:	89 10                	mov    %edx,(%eax)
  return 0;
}
8010470d:	31 c0                	xor    %eax,%eax
8010470f:	c9                   	leave  
80104710:	c3                   	ret    
80104711:	eb 0d                	jmp    80104720 <argstr>
80104713:	90                   	nop
80104714:	90                   	nop
80104715:	90                   	nop
80104716:	90                   	nop
80104717:	90                   	nop
80104718:	90                   	nop
80104719:	90                   	nop
8010471a:	90                   	nop
8010471b:	90                   	nop
8010471c:	90                   	nop
8010471d:	90                   	nop
8010471e:	90                   	nop
8010471f:	90                   	nop

80104720 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	53                   	push   %ebx
80104724:	83 ec 04             	sub    $0x4,%esp
  //cs153
  //if(ip == 0){
    //return -1;
  //}
  //cs153
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104727:	e8 24 f0 ff ff       	call   80103750 <myproc>
8010472c:	8b 40 18             	mov    0x18(%eax),%eax
  //cs153 updated sz check
  //if(((addr >= curproc->sz || addr+4 > curproc->sz) && (addr < ((KERNBASE - 1) - curproc->stack_sz))) || addr > (KERNBASE - 1)){
    //return -1;
  //}
  //cs153
  *ip = *(int*)(addr);
8010472f:	8b 55 08             	mov    0x8(%ebp),%edx
80104732:	8b 40 44             	mov    0x44(%eax),%eax
80104735:	8b 5c 90 04          	mov    0x4(%eax,%edx,4),%ebx
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;
  struct proc *curproc = myproc();
80104739:	e8 12 f0 ff ff       	call   80103750 <myproc>

  //cs153 removed sz check
  *pp = (char*)addr;
8010473e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104741:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104743:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104745:	39 c3                	cmp    %eax,%ebx
80104747:	73 1b                	jae    80104764 <argstr+0x44>
    if(*s == 0)
80104749:	80 3b 00             	cmpb   $0x0,(%ebx)
8010474c:	89 da                	mov    %ebx,%edx
8010474e:	75 0d                	jne    8010475d <argstr+0x3d>
80104750:	eb 1e                	jmp    80104770 <argstr+0x50>
80104752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104758:	80 3a 00             	cmpb   $0x0,(%edx)
8010475b:	74 13                	je     80104770 <argstr+0x50>
  struct proc *curproc = myproc();

  //cs153 removed sz check
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
8010475d:	83 c2 01             	add    $0x1,%edx
80104760:	39 d0                	cmp    %edx,%eax
80104762:	77 f4                	ja     80104758 <argstr+0x38>
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104764:	83 c4 04             	add    $0x4,%esp
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
80104767:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010476c:	5b                   	pop    %ebx
8010476d:	5d                   	pop    %ebp
8010476e:	c3                   	ret    
8010476f:	90                   	nop
80104770:	83 c4 04             	add    $0x4,%esp
  //cs153 removed sz check
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104773:	89 d0                	mov    %edx,%eax
80104775:	29 d8                	sub    %ebx,%eax
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104777:	5b                   	pop    %ebx
80104778:	5d                   	pop    %ebp
80104779:	c3                   	ret    
8010477a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104780 <syscall>:
[SYS_shm_close] sys_shm_close
};

void
syscall(void)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	56                   	push   %esi
80104784:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104785:	e8 c6 ef ff ff       	call   80103750 <myproc>

  num = curproc->tf->eax;
8010478a:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
8010478d:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010478f:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104792:	8d 50 ff             	lea    -0x1(%eax),%edx
80104795:	83 fa 16             	cmp    $0x16,%edx
80104798:	77 1e                	ja     801047b8 <syscall+0x38>
8010479a:	8b 14 85 a0 77 10 80 	mov    -0x7fef8860(,%eax,4),%edx
801047a1:	85 d2                	test   %edx,%edx
801047a3:	74 13                	je     801047b8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801047a5:	ff d2                	call   *%edx
801047a7:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801047aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047ad:	5b                   	pop    %ebx
801047ae:	5e                   	pop    %esi
801047af:	5d                   	pop    %ebp
801047b0:	c3                   	ret    
801047b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801047b8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801047b9:	8d 43 6c             	lea    0x6c(%ebx),%eax

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801047bc:	50                   	push   %eax
801047bd:	ff 73 10             	pushl  0x10(%ebx)
801047c0:	68 71 77 10 80       	push   $0x80107771
801047c5:	e8 96 be ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
801047ca:	8b 43 18             	mov    0x18(%ebx),%eax
801047cd:	83 c4 10             	add    $0x10,%esp
801047d0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801047d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047da:	5b                   	pop    %ebx
801047db:	5e                   	pop    %esi
801047dc:	5d                   	pop    %ebp
801047dd:	c3                   	ret    
801047de:	66 90                	xchg   %ax,%ax

801047e0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	57                   	push   %edi
801047e4:	56                   	push   %esi
801047e5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801047e6:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801047e9:	83 ec 44             	sub    $0x44,%esp
801047ec:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801047ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801047f2:	56                   	push   %esi
801047f3:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801047f4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801047f7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801047fa:	e8 b1 d6 ff ff       	call   80101eb0 <nameiparent>
801047ff:	83 c4 10             	add    $0x10,%esp
80104802:	85 c0                	test   %eax,%eax
80104804:	0f 84 f6 00 00 00    	je     80104900 <create+0x120>
    return 0;
  ilock(dp);
8010480a:	83 ec 0c             	sub    $0xc,%esp
8010480d:	89 c7                	mov    %eax,%edi
8010480f:	50                   	push   %eax
80104810:	e8 2b ce ff ff       	call   80101640 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104815:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104818:	83 c4 0c             	add    $0xc,%esp
8010481b:	50                   	push   %eax
8010481c:	56                   	push   %esi
8010481d:	57                   	push   %edi
8010481e:	e8 4d d3 ff ff       	call   80101b70 <dirlookup>
80104823:	83 c4 10             	add    $0x10,%esp
80104826:	85 c0                	test   %eax,%eax
80104828:	89 c3                	mov    %eax,%ebx
8010482a:	74 54                	je     80104880 <create+0xa0>
    iunlockput(dp);
8010482c:	83 ec 0c             	sub    $0xc,%esp
8010482f:	57                   	push   %edi
80104830:	e8 9b d0 ff ff       	call   801018d0 <iunlockput>
    ilock(ip);
80104835:	89 1c 24             	mov    %ebx,(%esp)
80104838:	e8 03 ce ff ff       	call   80101640 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010483d:	83 c4 10             	add    $0x10,%esp
80104840:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104845:	75 19                	jne    80104860 <create+0x80>
80104847:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
8010484c:	89 d8                	mov    %ebx,%eax
8010484e:	75 10                	jne    80104860 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104850:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104853:	5b                   	pop    %ebx
80104854:	5e                   	pop    %esi
80104855:	5f                   	pop    %edi
80104856:	5d                   	pop    %ebp
80104857:	c3                   	ret    
80104858:	90                   	nop
80104859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104860:	83 ec 0c             	sub    $0xc,%esp
80104863:	53                   	push   %ebx
80104864:	e8 67 d0 ff ff       	call   801018d0 <iunlockput>
    return 0;
80104869:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010486c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
8010486f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104871:	5b                   	pop    %ebx
80104872:	5e                   	pop    %esi
80104873:	5f                   	pop    %edi
80104874:	5d                   	pop    %ebp
80104875:	c3                   	ret    
80104876:	8d 76 00             	lea    0x0(%esi),%esi
80104879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104880:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104884:	83 ec 08             	sub    $0x8,%esp
80104887:	50                   	push   %eax
80104888:	ff 37                	pushl  (%edi)
8010488a:	e8 41 cc ff ff       	call   801014d0 <ialloc>
8010488f:	83 c4 10             	add    $0x10,%esp
80104892:	85 c0                	test   %eax,%eax
80104894:	89 c3                	mov    %eax,%ebx
80104896:	0f 84 cc 00 00 00    	je     80104968 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
8010489c:	83 ec 0c             	sub    $0xc,%esp
8010489f:	50                   	push   %eax
801048a0:	e8 9b cd ff ff       	call   80101640 <ilock>
  ip->major = major;
801048a5:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
801048a9:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
801048ad:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
801048b1:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
801048b5:	b8 01 00 00 00       	mov    $0x1,%eax
801048ba:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801048be:	89 1c 24             	mov    %ebx,(%esp)
801048c1:	e8 ca cc ff ff       	call   80101590 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
801048c6:	83 c4 10             	add    $0x10,%esp
801048c9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801048ce:	74 40                	je     80104910 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
801048d0:	83 ec 04             	sub    $0x4,%esp
801048d3:	ff 73 04             	pushl  0x4(%ebx)
801048d6:	56                   	push   %esi
801048d7:	57                   	push   %edi
801048d8:	e8 f3 d4 ff ff       	call   80101dd0 <dirlink>
801048dd:	83 c4 10             	add    $0x10,%esp
801048e0:	85 c0                	test   %eax,%eax
801048e2:	78 77                	js     8010495b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
801048e4:	83 ec 0c             	sub    $0xc,%esp
801048e7:	57                   	push   %edi
801048e8:	e8 e3 cf ff ff       	call   801018d0 <iunlockput>

  return ip;
801048ed:	83 c4 10             	add    $0x10,%esp
}
801048f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
801048f3:	89 d8                	mov    %ebx,%eax
}
801048f5:	5b                   	pop    %ebx
801048f6:	5e                   	pop    %esi
801048f7:	5f                   	pop    %edi
801048f8:	5d                   	pop    %ebp
801048f9:	c3                   	ret    
801048fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104900:	31 c0                	xor    %eax,%eax
80104902:	e9 49 ff ff ff       	jmp    80104850 <create+0x70>
80104907:	89 f6                	mov    %esi,%esi
80104909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104910:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104915:	83 ec 0c             	sub    $0xc,%esp
80104918:	57                   	push   %edi
80104919:	e8 72 cc ff ff       	call   80101590 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010491e:	83 c4 0c             	add    $0xc,%esp
80104921:	ff 73 04             	pushl  0x4(%ebx)
80104924:	68 1c 78 10 80       	push   $0x8010781c
80104929:	53                   	push   %ebx
8010492a:	e8 a1 d4 ff ff       	call   80101dd0 <dirlink>
8010492f:	83 c4 10             	add    $0x10,%esp
80104932:	85 c0                	test   %eax,%eax
80104934:	78 18                	js     8010494e <create+0x16e>
80104936:	83 ec 04             	sub    $0x4,%esp
80104939:	ff 77 04             	pushl  0x4(%edi)
8010493c:	68 1b 78 10 80       	push   $0x8010781b
80104941:	53                   	push   %ebx
80104942:	e8 89 d4 ff ff       	call   80101dd0 <dirlink>
80104947:	83 c4 10             	add    $0x10,%esp
8010494a:	85 c0                	test   %eax,%eax
8010494c:	79 82                	jns    801048d0 <create+0xf0>
      panic("create dots");
8010494e:	83 ec 0c             	sub    $0xc,%esp
80104951:	68 0f 78 10 80       	push   $0x8010780f
80104956:	e8 15 ba ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
8010495b:	83 ec 0c             	sub    $0xc,%esp
8010495e:	68 1e 78 10 80       	push   $0x8010781e
80104963:	e8 08 ba ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104968:	83 ec 0c             	sub    $0xc,%esp
8010496b:	68 00 78 10 80       	push   $0x80107800
80104970:	e8 fb b9 ff ff       	call   80100370 <panic>
80104975:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104980 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	56                   	push   %esi
80104984:	53                   	push   %ebx
80104985:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104987:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
8010498a:	89 d3                	mov    %edx,%ebx
8010498c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
8010498f:	50                   	push   %eax
80104990:	6a 00                	push   $0x0
80104992:	e8 29 fd ff ff       	call   801046c0 <argint>
80104997:	83 c4 10             	add    $0x10,%esp
8010499a:	85 c0                	test   %eax,%eax
8010499c:	78 32                	js     801049d0 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010499e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801049a2:	77 2c                	ja     801049d0 <argfd.constprop.0+0x50>
801049a4:	e8 a7 ed ff ff       	call   80103750 <myproc>
801049a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801049ac:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801049b0:	85 c0                	test   %eax,%eax
801049b2:	74 1c                	je     801049d0 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
801049b4:	85 f6                	test   %esi,%esi
801049b6:	74 02                	je     801049ba <argfd.constprop.0+0x3a>
    *pfd = fd;
801049b8:	89 16                	mov    %edx,(%esi)
  if(pf)
801049ba:	85 db                	test   %ebx,%ebx
801049bc:	74 22                	je     801049e0 <argfd.constprop.0+0x60>
    *pf = f;
801049be:	89 03                	mov    %eax,(%ebx)
  return 0;
801049c0:	31 c0                	xor    %eax,%eax
}
801049c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049c5:	5b                   	pop    %ebx
801049c6:	5e                   	pop    %esi
801049c7:	5d                   	pop    %ebp
801049c8:	c3                   	ret    
801049c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
801049d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
801049d8:	5b                   	pop    %ebx
801049d9:	5e                   	pop    %esi
801049da:	5d                   	pop    %ebp
801049db:	c3                   	ret    
801049dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
801049e0:	31 c0                	xor    %eax,%eax
801049e2:	eb de                	jmp    801049c2 <argfd.constprop.0+0x42>
801049e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801049ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801049f0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
801049f0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801049f1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
801049f3:	89 e5                	mov    %esp,%ebp
801049f5:	56                   	push   %esi
801049f6:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801049f7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
801049fa:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
801049fd:	e8 7e ff ff ff       	call   80104980 <argfd.constprop.0>
80104a02:	85 c0                	test   %eax,%eax
80104a04:	78 1a                	js     80104a20 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104a06:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80104a08:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80104a0b:	e8 40 ed ff ff       	call   80103750 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104a10:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104a14:	85 d2                	test   %edx,%edx
80104a16:	74 18                	je     80104a30 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104a18:	83 c3 01             	add    $0x1,%ebx
80104a1b:	83 fb 10             	cmp    $0x10,%ebx
80104a1e:	75 f0                	jne    80104a10 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104a20:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104a23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104a28:	5b                   	pop    %ebx
80104a29:	5e                   	pop    %esi
80104a2a:	5d                   	pop    %ebp
80104a2b:	c3                   	ret    
80104a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104a30:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104a34:	83 ec 0c             	sub    $0xc,%esp
80104a37:	ff 75 f4             	pushl  -0xc(%ebp)
80104a3a:	e8 71 c3 ff ff       	call   80100db0 <filedup>
  return fd;
80104a3f:	83 c4 10             	add    $0x10,%esp
}
80104a42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80104a45:	89 d8                	mov    %ebx,%eax
}
80104a47:	5b                   	pop    %ebx
80104a48:	5e                   	pop    %esi
80104a49:	5d                   	pop    %ebp
80104a4a:	c3                   	ret    
80104a4b:	90                   	nop
80104a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a50 <sys_read>:

int
sys_read(void)
{
80104a50:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a51:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104a53:	89 e5                	mov    %esp,%ebp
80104a55:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a58:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104a5b:	e8 20 ff ff ff       	call   80104980 <argfd.constprop.0>
80104a60:	85 c0                	test   %eax,%eax
80104a62:	78 4c                	js     80104ab0 <sys_read+0x60>
80104a64:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a67:	83 ec 08             	sub    $0x8,%esp
80104a6a:	50                   	push   %eax
80104a6b:	6a 02                	push   $0x2
80104a6d:	e8 4e fc ff ff       	call   801046c0 <argint>
80104a72:	83 c4 10             	add    $0x10,%esp
80104a75:	85 c0                	test   %eax,%eax
80104a77:	78 37                	js     80104ab0 <sys_read+0x60>
80104a79:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a7c:	83 ec 04             	sub    $0x4,%esp
80104a7f:	ff 75 f0             	pushl  -0x10(%ebp)
80104a82:	50                   	push   %eax
80104a83:	6a 01                	push   $0x1
80104a85:	e8 66 fc ff ff       	call   801046f0 <argptr>
80104a8a:	83 c4 10             	add    $0x10,%esp
80104a8d:	85 c0                	test   %eax,%eax
80104a8f:	78 1f                	js     80104ab0 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104a91:	83 ec 04             	sub    $0x4,%esp
80104a94:	ff 75 f0             	pushl  -0x10(%ebp)
80104a97:	ff 75 f4             	pushl  -0xc(%ebp)
80104a9a:	ff 75 ec             	pushl  -0x14(%ebp)
80104a9d:	e8 7e c4 ff ff       	call   80100f20 <fileread>
80104aa2:	83 c4 10             	add    $0x10,%esp
}
80104aa5:	c9                   	leave  
80104aa6:	c3                   	ret    
80104aa7:	89 f6                	mov    %esi,%esi
80104aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104ab0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104ab5:	c9                   	leave  
80104ab6:	c3                   	ret    
80104ab7:	89 f6                	mov    %esi,%esi
80104ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ac0 <sys_write>:

int
sys_write(void)
{
80104ac0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ac1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104ac3:	89 e5                	mov    %esp,%ebp
80104ac5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ac8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104acb:	e8 b0 fe ff ff       	call   80104980 <argfd.constprop.0>
80104ad0:	85 c0                	test   %eax,%eax
80104ad2:	78 4c                	js     80104b20 <sys_write+0x60>
80104ad4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ad7:	83 ec 08             	sub    $0x8,%esp
80104ada:	50                   	push   %eax
80104adb:	6a 02                	push   $0x2
80104add:	e8 de fb ff ff       	call   801046c0 <argint>
80104ae2:	83 c4 10             	add    $0x10,%esp
80104ae5:	85 c0                	test   %eax,%eax
80104ae7:	78 37                	js     80104b20 <sys_write+0x60>
80104ae9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104aec:	83 ec 04             	sub    $0x4,%esp
80104aef:	ff 75 f0             	pushl  -0x10(%ebp)
80104af2:	50                   	push   %eax
80104af3:	6a 01                	push   $0x1
80104af5:	e8 f6 fb ff ff       	call   801046f0 <argptr>
80104afa:	83 c4 10             	add    $0x10,%esp
80104afd:	85 c0                	test   %eax,%eax
80104aff:	78 1f                	js     80104b20 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104b01:	83 ec 04             	sub    $0x4,%esp
80104b04:	ff 75 f0             	pushl  -0x10(%ebp)
80104b07:	ff 75 f4             	pushl  -0xc(%ebp)
80104b0a:	ff 75 ec             	pushl  -0x14(%ebp)
80104b0d:	e8 9e c4 ff ff       	call   80100fb0 <filewrite>
80104b12:	83 c4 10             	add    $0x10,%esp
}
80104b15:	c9                   	leave  
80104b16:	c3                   	ret    
80104b17:	89 f6                	mov    %esi,%esi
80104b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104b20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104b25:	c9                   	leave  
80104b26:	c3                   	ret    
80104b27:	89 f6                	mov    %esi,%esi
80104b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b30 <sys_close>:

int
sys_close(void)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104b36:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104b39:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b3c:	e8 3f fe ff ff       	call   80104980 <argfd.constprop.0>
80104b41:	85 c0                	test   %eax,%eax
80104b43:	78 2b                	js     80104b70 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80104b45:	e8 06 ec ff ff       	call   80103750 <myproc>
80104b4a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104b4d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80104b50:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104b57:	00 
  fileclose(f);
80104b58:	ff 75 f4             	pushl  -0xc(%ebp)
80104b5b:	e8 a0 c2 ff ff       	call   80100e00 <fileclose>
  return 0;
80104b60:	83 c4 10             	add    $0x10,%esp
80104b63:	31 c0                	xor    %eax,%eax
}
80104b65:	c9                   	leave  
80104b66:	c3                   	ret    
80104b67:	89 f6                	mov    %esi,%esi
80104b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104b75:	c9                   	leave  
80104b76:	c3                   	ret    
80104b77:	89 f6                	mov    %esi,%esi
80104b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b80 <sys_fstat>:

int
sys_fstat(void)
{
80104b80:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b81:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104b83:	89 e5                	mov    %esp,%ebp
80104b85:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104b88:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104b8b:	e8 f0 fd ff ff       	call   80104980 <argfd.constprop.0>
80104b90:	85 c0                	test   %eax,%eax
80104b92:	78 2c                	js     80104bc0 <sys_fstat+0x40>
80104b94:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b97:	83 ec 04             	sub    $0x4,%esp
80104b9a:	6a 14                	push   $0x14
80104b9c:	50                   	push   %eax
80104b9d:	6a 01                	push   $0x1
80104b9f:	e8 4c fb ff ff       	call   801046f0 <argptr>
80104ba4:	83 c4 10             	add    $0x10,%esp
80104ba7:	85 c0                	test   %eax,%eax
80104ba9:	78 15                	js     80104bc0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104bab:	83 ec 08             	sub    $0x8,%esp
80104bae:	ff 75 f4             	pushl  -0xc(%ebp)
80104bb1:	ff 75 f0             	pushl  -0x10(%ebp)
80104bb4:	e8 17 c3 ff ff       	call   80100ed0 <filestat>
80104bb9:	83 c4 10             	add    $0x10,%esp
}
80104bbc:	c9                   	leave  
80104bbd:	c3                   	ret    
80104bbe:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104bc5:	c9                   	leave  
80104bc6:	c3                   	ret    
80104bc7:	89 f6                	mov    %esi,%esi
80104bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bd0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	57                   	push   %edi
80104bd4:	56                   	push   %esi
80104bd5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104bd6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104bd9:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104bdc:	50                   	push   %eax
80104bdd:	6a 00                	push   $0x0
80104bdf:	e8 3c fb ff ff       	call   80104720 <argstr>
80104be4:	83 c4 10             	add    $0x10,%esp
80104be7:	85 c0                	test   %eax,%eax
80104be9:	0f 88 fb 00 00 00    	js     80104cea <sys_link+0x11a>
80104bef:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104bf2:	83 ec 08             	sub    $0x8,%esp
80104bf5:	50                   	push   %eax
80104bf6:	6a 01                	push   $0x1
80104bf8:	e8 23 fb ff ff       	call   80104720 <argstr>
80104bfd:	83 c4 10             	add    $0x10,%esp
80104c00:	85 c0                	test   %eax,%eax
80104c02:	0f 88 e2 00 00 00    	js     80104cea <sys_link+0x11a>
    return -1;

  begin_op();
80104c08:	e8 13 df ff ff       	call   80102b20 <begin_op>
  if((ip = namei(old)) == 0){
80104c0d:	83 ec 0c             	sub    $0xc,%esp
80104c10:	ff 75 d4             	pushl  -0x2c(%ebp)
80104c13:	e8 78 d2 ff ff       	call   80101e90 <namei>
80104c18:	83 c4 10             	add    $0x10,%esp
80104c1b:	85 c0                	test   %eax,%eax
80104c1d:	89 c3                	mov    %eax,%ebx
80104c1f:	0f 84 f3 00 00 00    	je     80104d18 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80104c25:	83 ec 0c             	sub    $0xc,%esp
80104c28:	50                   	push   %eax
80104c29:	e8 12 ca ff ff       	call   80101640 <ilock>
  if(ip->type == T_DIR){
80104c2e:	83 c4 10             	add    $0x10,%esp
80104c31:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104c36:	0f 84 c4 00 00 00    	je     80104d00 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104c3c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104c41:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104c44:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104c47:	53                   	push   %ebx
80104c48:	e8 43 c9 ff ff       	call   80101590 <iupdate>
  iunlock(ip);
80104c4d:	89 1c 24             	mov    %ebx,(%esp)
80104c50:	e8 cb ca ff ff       	call   80101720 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104c55:	58                   	pop    %eax
80104c56:	5a                   	pop    %edx
80104c57:	57                   	push   %edi
80104c58:	ff 75 d0             	pushl  -0x30(%ebp)
80104c5b:	e8 50 d2 ff ff       	call   80101eb0 <nameiparent>
80104c60:	83 c4 10             	add    $0x10,%esp
80104c63:	85 c0                	test   %eax,%eax
80104c65:	89 c6                	mov    %eax,%esi
80104c67:	74 5b                	je     80104cc4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80104c69:	83 ec 0c             	sub    $0xc,%esp
80104c6c:	50                   	push   %eax
80104c6d:	e8 ce c9 ff ff       	call   80101640 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104c72:	83 c4 10             	add    $0x10,%esp
80104c75:	8b 03                	mov    (%ebx),%eax
80104c77:	39 06                	cmp    %eax,(%esi)
80104c79:	75 3d                	jne    80104cb8 <sys_link+0xe8>
80104c7b:	83 ec 04             	sub    $0x4,%esp
80104c7e:	ff 73 04             	pushl  0x4(%ebx)
80104c81:	57                   	push   %edi
80104c82:	56                   	push   %esi
80104c83:	e8 48 d1 ff ff       	call   80101dd0 <dirlink>
80104c88:	83 c4 10             	add    $0x10,%esp
80104c8b:	85 c0                	test   %eax,%eax
80104c8d:	78 29                	js     80104cb8 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104c8f:	83 ec 0c             	sub    $0xc,%esp
80104c92:	56                   	push   %esi
80104c93:	e8 38 cc ff ff       	call   801018d0 <iunlockput>
  iput(ip);
80104c98:	89 1c 24             	mov    %ebx,(%esp)
80104c9b:	e8 d0 ca ff ff       	call   80101770 <iput>

  end_op();
80104ca0:	e8 eb de ff ff       	call   80102b90 <end_op>

  return 0;
80104ca5:	83 c4 10             	add    $0x10,%esp
80104ca8:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104caa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104cad:	5b                   	pop    %ebx
80104cae:	5e                   	pop    %esi
80104caf:	5f                   	pop    %edi
80104cb0:	5d                   	pop    %ebp
80104cb1:	c3                   	ret    
80104cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104cb8:	83 ec 0c             	sub    $0xc,%esp
80104cbb:	56                   	push   %esi
80104cbc:	e8 0f cc ff ff       	call   801018d0 <iunlockput>
    goto bad;
80104cc1:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80104cc4:	83 ec 0c             	sub    $0xc,%esp
80104cc7:	53                   	push   %ebx
80104cc8:	e8 73 c9 ff ff       	call   80101640 <ilock>
  ip->nlink--;
80104ccd:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104cd2:	89 1c 24             	mov    %ebx,(%esp)
80104cd5:	e8 b6 c8 ff ff       	call   80101590 <iupdate>
  iunlockput(ip);
80104cda:	89 1c 24             	mov    %ebx,(%esp)
80104cdd:	e8 ee cb ff ff       	call   801018d0 <iunlockput>
  end_op();
80104ce2:	e8 a9 de ff ff       	call   80102b90 <end_op>
  return -1;
80104ce7:	83 c4 10             	add    $0x10,%esp
}
80104cea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104ced:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cf2:	5b                   	pop    %ebx
80104cf3:	5e                   	pop    %esi
80104cf4:	5f                   	pop    %edi
80104cf5:	5d                   	pop    %ebp
80104cf6:	c3                   	ret    
80104cf7:	89 f6                	mov    %esi,%esi
80104cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80104d00:	83 ec 0c             	sub    $0xc,%esp
80104d03:	53                   	push   %ebx
80104d04:	e8 c7 cb ff ff       	call   801018d0 <iunlockput>
    end_op();
80104d09:	e8 82 de ff ff       	call   80102b90 <end_op>
    return -1;
80104d0e:	83 c4 10             	add    $0x10,%esp
80104d11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d16:	eb 92                	jmp    80104caa <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80104d18:	e8 73 de ff ff       	call   80102b90 <end_op>
    return -1;
80104d1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d22:	eb 86                	jmp    80104caa <sys_link+0xda>
80104d24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104d30 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	57                   	push   %edi
80104d34:	56                   	push   %esi
80104d35:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104d36:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104d39:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104d3c:	50                   	push   %eax
80104d3d:	6a 00                	push   $0x0
80104d3f:	e8 dc f9 ff ff       	call   80104720 <argstr>
80104d44:	83 c4 10             	add    $0x10,%esp
80104d47:	85 c0                	test   %eax,%eax
80104d49:	0f 88 82 01 00 00    	js     80104ed1 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80104d4f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80104d52:	e8 c9 dd ff ff       	call   80102b20 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104d57:	83 ec 08             	sub    $0x8,%esp
80104d5a:	53                   	push   %ebx
80104d5b:	ff 75 c0             	pushl  -0x40(%ebp)
80104d5e:	e8 4d d1 ff ff       	call   80101eb0 <nameiparent>
80104d63:	83 c4 10             	add    $0x10,%esp
80104d66:	85 c0                	test   %eax,%eax
80104d68:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104d6b:	0f 84 6a 01 00 00    	je     80104edb <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80104d71:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104d74:	83 ec 0c             	sub    $0xc,%esp
80104d77:	56                   	push   %esi
80104d78:	e8 c3 c8 ff ff       	call   80101640 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104d7d:	58                   	pop    %eax
80104d7e:	5a                   	pop    %edx
80104d7f:	68 1c 78 10 80       	push   $0x8010781c
80104d84:	53                   	push   %ebx
80104d85:	e8 c6 cd ff ff       	call   80101b50 <namecmp>
80104d8a:	83 c4 10             	add    $0x10,%esp
80104d8d:	85 c0                	test   %eax,%eax
80104d8f:	0f 84 fc 00 00 00    	je     80104e91 <sys_unlink+0x161>
80104d95:	83 ec 08             	sub    $0x8,%esp
80104d98:	68 1b 78 10 80       	push   $0x8010781b
80104d9d:	53                   	push   %ebx
80104d9e:	e8 ad cd ff ff       	call   80101b50 <namecmp>
80104da3:	83 c4 10             	add    $0x10,%esp
80104da6:	85 c0                	test   %eax,%eax
80104da8:	0f 84 e3 00 00 00    	je     80104e91 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104dae:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104db1:	83 ec 04             	sub    $0x4,%esp
80104db4:	50                   	push   %eax
80104db5:	53                   	push   %ebx
80104db6:	56                   	push   %esi
80104db7:	e8 b4 cd ff ff       	call   80101b70 <dirlookup>
80104dbc:	83 c4 10             	add    $0x10,%esp
80104dbf:	85 c0                	test   %eax,%eax
80104dc1:	89 c3                	mov    %eax,%ebx
80104dc3:	0f 84 c8 00 00 00    	je     80104e91 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80104dc9:	83 ec 0c             	sub    $0xc,%esp
80104dcc:	50                   	push   %eax
80104dcd:	e8 6e c8 ff ff       	call   80101640 <ilock>

  if(ip->nlink < 1)
80104dd2:	83 c4 10             	add    $0x10,%esp
80104dd5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104dda:	0f 8e 24 01 00 00    	jle    80104f04 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104de0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104de5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104de8:	74 66                	je     80104e50 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104dea:	83 ec 04             	sub    $0x4,%esp
80104ded:	6a 10                	push   $0x10
80104def:	6a 00                	push   $0x0
80104df1:	56                   	push   %esi
80104df2:	e8 e9 f5 ff ff       	call   801043e0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104df7:	6a 10                	push   $0x10
80104df9:	ff 75 c4             	pushl  -0x3c(%ebp)
80104dfc:	56                   	push   %esi
80104dfd:	ff 75 b4             	pushl  -0x4c(%ebp)
80104e00:	e8 1b cc ff ff       	call   80101a20 <writei>
80104e05:	83 c4 20             	add    $0x20,%esp
80104e08:	83 f8 10             	cmp    $0x10,%eax
80104e0b:	0f 85 e6 00 00 00    	jne    80104ef7 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104e11:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e16:	0f 84 9c 00 00 00    	je     80104eb8 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104e1c:	83 ec 0c             	sub    $0xc,%esp
80104e1f:	ff 75 b4             	pushl  -0x4c(%ebp)
80104e22:	e8 a9 ca ff ff       	call   801018d0 <iunlockput>

  ip->nlink--;
80104e27:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104e2c:	89 1c 24             	mov    %ebx,(%esp)
80104e2f:	e8 5c c7 ff ff       	call   80101590 <iupdate>
  iunlockput(ip);
80104e34:	89 1c 24             	mov    %ebx,(%esp)
80104e37:	e8 94 ca ff ff       	call   801018d0 <iunlockput>

  end_op();
80104e3c:	e8 4f dd ff ff       	call   80102b90 <end_op>

  return 0;
80104e41:	83 c4 10             	add    $0x10,%esp
80104e44:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104e46:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e49:	5b                   	pop    %ebx
80104e4a:	5e                   	pop    %esi
80104e4b:	5f                   	pop    %edi
80104e4c:	5d                   	pop    %ebp
80104e4d:	c3                   	ret    
80104e4e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104e50:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104e54:	76 94                	jbe    80104dea <sys_unlink+0xba>
80104e56:	bf 20 00 00 00       	mov    $0x20,%edi
80104e5b:	eb 0f                	jmp    80104e6c <sys_unlink+0x13c>
80104e5d:	8d 76 00             	lea    0x0(%esi),%esi
80104e60:	83 c7 10             	add    $0x10,%edi
80104e63:	3b 7b 58             	cmp    0x58(%ebx),%edi
80104e66:	0f 83 7e ff ff ff    	jae    80104dea <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104e6c:	6a 10                	push   $0x10
80104e6e:	57                   	push   %edi
80104e6f:	56                   	push   %esi
80104e70:	53                   	push   %ebx
80104e71:	e8 aa ca ff ff       	call   80101920 <readi>
80104e76:	83 c4 10             	add    $0x10,%esp
80104e79:	83 f8 10             	cmp    $0x10,%eax
80104e7c:	75 6c                	jne    80104eea <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104e7e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104e83:	74 db                	je     80104e60 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104e85:	83 ec 0c             	sub    $0xc,%esp
80104e88:	53                   	push   %ebx
80104e89:	e8 42 ca ff ff       	call   801018d0 <iunlockput>
    goto bad;
80104e8e:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104e91:	83 ec 0c             	sub    $0xc,%esp
80104e94:	ff 75 b4             	pushl  -0x4c(%ebp)
80104e97:	e8 34 ca ff ff       	call   801018d0 <iunlockput>
  end_op();
80104e9c:	e8 ef dc ff ff       	call   80102b90 <end_op>
  return -1;
80104ea1:	83 c4 10             	add    $0x10,%esp
}
80104ea4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104ea7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104eac:	5b                   	pop    %ebx
80104ead:	5e                   	pop    %esi
80104eae:	5f                   	pop    %edi
80104eaf:	5d                   	pop    %ebp
80104eb0:	c3                   	ret    
80104eb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104eb8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80104ebb:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104ebe:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104ec3:	50                   	push   %eax
80104ec4:	e8 c7 c6 ff ff       	call   80101590 <iupdate>
80104ec9:	83 c4 10             	add    $0x10,%esp
80104ecc:	e9 4b ff ff ff       	jmp    80104e1c <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80104ed1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ed6:	e9 6b ff ff ff       	jmp    80104e46 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
80104edb:	e8 b0 dc ff ff       	call   80102b90 <end_op>
    return -1;
80104ee0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ee5:	e9 5c ff ff ff       	jmp    80104e46 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80104eea:	83 ec 0c             	sub    $0xc,%esp
80104eed:	68 40 78 10 80       	push   $0x80107840
80104ef2:	e8 79 b4 ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80104ef7:	83 ec 0c             	sub    $0xc,%esp
80104efa:	68 52 78 10 80       	push   $0x80107852
80104eff:	e8 6c b4 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80104f04:	83 ec 0c             	sub    $0xc,%esp
80104f07:	68 2e 78 10 80       	push   $0x8010782e
80104f0c:	e8 5f b4 ff ff       	call   80100370 <panic>
80104f11:	eb 0d                	jmp    80104f20 <sys_open>
80104f13:	90                   	nop
80104f14:	90                   	nop
80104f15:	90                   	nop
80104f16:	90                   	nop
80104f17:	90                   	nop
80104f18:	90                   	nop
80104f19:	90                   	nop
80104f1a:	90                   	nop
80104f1b:	90                   	nop
80104f1c:	90                   	nop
80104f1d:	90                   	nop
80104f1e:	90                   	nop
80104f1f:	90                   	nop

80104f20 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	57                   	push   %edi
80104f24:	56                   	push   %esi
80104f25:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104f26:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80104f29:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104f2c:	50                   	push   %eax
80104f2d:	6a 00                	push   $0x0
80104f2f:	e8 ec f7 ff ff       	call   80104720 <argstr>
80104f34:	83 c4 10             	add    $0x10,%esp
80104f37:	85 c0                	test   %eax,%eax
80104f39:	0f 88 9e 00 00 00    	js     80104fdd <sys_open+0xbd>
80104f3f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104f42:	83 ec 08             	sub    $0x8,%esp
80104f45:	50                   	push   %eax
80104f46:	6a 01                	push   $0x1
80104f48:	e8 73 f7 ff ff       	call   801046c0 <argint>
80104f4d:	83 c4 10             	add    $0x10,%esp
80104f50:	85 c0                	test   %eax,%eax
80104f52:	0f 88 85 00 00 00    	js     80104fdd <sys_open+0xbd>
    return -1;

  begin_op();
80104f58:	e8 c3 db ff ff       	call   80102b20 <begin_op>

  if(omode & O_CREATE){
80104f5d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104f61:	0f 85 89 00 00 00    	jne    80104ff0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104f67:	83 ec 0c             	sub    $0xc,%esp
80104f6a:	ff 75 e0             	pushl  -0x20(%ebp)
80104f6d:	e8 1e cf ff ff       	call   80101e90 <namei>
80104f72:	83 c4 10             	add    $0x10,%esp
80104f75:	85 c0                	test   %eax,%eax
80104f77:	89 c6                	mov    %eax,%esi
80104f79:	0f 84 8e 00 00 00    	je     8010500d <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
80104f7f:	83 ec 0c             	sub    $0xc,%esp
80104f82:	50                   	push   %eax
80104f83:	e8 b8 c6 ff ff       	call   80101640 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104f88:	83 c4 10             	add    $0x10,%esp
80104f8b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104f90:	0f 84 d2 00 00 00    	je     80105068 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104f96:	e8 a5 bd ff ff       	call   80100d40 <filealloc>
80104f9b:	85 c0                	test   %eax,%eax
80104f9d:	89 c7                	mov    %eax,%edi
80104f9f:	74 2b                	je     80104fcc <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104fa1:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80104fa3:	e8 a8 e7 ff ff       	call   80103750 <myproc>
80104fa8:	90                   	nop
80104fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104fb0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104fb4:	85 d2                	test   %edx,%edx
80104fb6:	74 68                	je     80105020 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104fb8:	83 c3 01             	add    $0x1,%ebx
80104fbb:	83 fb 10             	cmp    $0x10,%ebx
80104fbe:	75 f0                	jne    80104fb0 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80104fc0:	83 ec 0c             	sub    $0xc,%esp
80104fc3:	57                   	push   %edi
80104fc4:	e8 37 be ff ff       	call   80100e00 <fileclose>
80104fc9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80104fcc:	83 ec 0c             	sub    $0xc,%esp
80104fcf:	56                   	push   %esi
80104fd0:	e8 fb c8 ff ff       	call   801018d0 <iunlockput>
    end_op();
80104fd5:	e8 b6 db ff ff       	call   80102b90 <end_op>
    return -1;
80104fda:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104fdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80104fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104fe5:	5b                   	pop    %ebx
80104fe6:	5e                   	pop    %esi
80104fe7:	5f                   	pop    %edi
80104fe8:	5d                   	pop    %ebp
80104fe9:	c3                   	ret    
80104fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104ff0:	83 ec 0c             	sub    $0xc,%esp
80104ff3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ff6:	31 c9                	xor    %ecx,%ecx
80104ff8:	6a 00                	push   $0x0
80104ffa:	ba 02 00 00 00       	mov    $0x2,%edx
80104fff:	e8 dc f7 ff ff       	call   801047e0 <create>
    if(ip == 0){
80105004:	83 c4 10             	add    $0x10,%esp
80105007:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80105009:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010500b:	75 89                	jne    80104f96 <sys_open+0x76>
      end_op();
8010500d:	e8 7e db ff ff       	call   80102b90 <end_op>
      return -1;
80105012:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105017:	eb 43                	jmp    8010505c <sys_open+0x13c>
80105019:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105020:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105023:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105027:	56                   	push   %esi
80105028:	e8 f3 c6 ff ff       	call   80101720 <iunlock>
  end_op();
8010502d:	e8 5e db ff ff       	call   80102b90 <end_op>

  f->type = FD_INODE;
80105032:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105038:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010503b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010503e:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105041:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105048:	89 d0                	mov    %edx,%eax
8010504a:	83 e0 01             	and    $0x1,%eax
8010504d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105050:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105053:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105056:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
8010505a:	89 d8                	mov    %ebx,%eax
}
8010505c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010505f:	5b                   	pop    %ebx
80105060:	5e                   	pop    %esi
80105061:	5f                   	pop    %edi
80105062:	5d                   	pop    %ebp
80105063:	c3                   	ret    
80105064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105068:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010506b:	85 c9                	test   %ecx,%ecx
8010506d:	0f 84 23 ff ff ff    	je     80104f96 <sys_open+0x76>
80105073:	e9 54 ff ff ff       	jmp    80104fcc <sys_open+0xac>
80105078:	90                   	nop
80105079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105080 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105086:	e8 95 da ff ff       	call   80102b20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010508b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010508e:	83 ec 08             	sub    $0x8,%esp
80105091:	50                   	push   %eax
80105092:	6a 00                	push   $0x0
80105094:	e8 87 f6 ff ff       	call   80104720 <argstr>
80105099:	83 c4 10             	add    $0x10,%esp
8010509c:	85 c0                	test   %eax,%eax
8010509e:	78 30                	js     801050d0 <sys_mkdir+0x50>
801050a0:	83 ec 0c             	sub    $0xc,%esp
801050a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050a6:	31 c9                	xor    %ecx,%ecx
801050a8:	6a 00                	push   $0x0
801050aa:	ba 01 00 00 00       	mov    $0x1,%edx
801050af:	e8 2c f7 ff ff       	call   801047e0 <create>
801050b4:	83 c4 10             	add    $0x10,%esp
801050b7:	85 c0                	test   %eax,%eax
801050b9:	74 15                	je     801050d0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801050bb:	83 ec 0c             	sub    $0xc,%esp
801050be:	50                   	push   %eax
801050bf:	e8 0c c8 ff ff       	call   801018d0 <iunlockput>
  end_op();
801050c4:	e8 c7 da ff ff       	call   80102b90 <end_op>
  return 0;
801050c9:	83 c4 10             	add    $0x10,%esp
801050cc:	31 c0                	xor    %eax,%eax
}
801050ce:	c9                   	leave  
801050cf:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
801050d0:	e8 bb da ff ff       	call   80102b90 <end_op>
    return -1;
801050d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801050da:	c9                   	leave  
801050db:	c3                   	ret    
801050dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050e0 <sys_mknod>:

int
sys_mknod(void)
{
801050e0:	55                   	push   %ebp
801050e1:	89 e5                	mov    %esp,%ebp
801050e3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801050e6:	e8 35 da ff ff       	call   80102b20 <begin_op>
  if((argstr(0, &path)) < 0 ||
801050eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801050ee:	83 ec 08             	sub    $0x8,%esp
801050f1:	50                   	push   %eax
801050f2:	6a 00                	push   $0x0
801050f4:	e8 27 f6 ff ff       	call   80104720 <argstr>
801050f9:	83 c4 10             	add    $0x10,%esp
801050fc:	85 c0                	test   %eax,%eax
801050fe:	78 60                	js     80105160 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105100:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105103:	83 ec 08             	sub    $0x8,%esp
80105106:	50                   	push   %eax
80105107:	6a 01                	push   $0x1
80105109:	e8 b2 f5 ff ff       	call   801046c0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
8010510e:	83 c4 10             	add    $0x10,%esp
80105111:	85 c0                	test   %eax,%eax
80105113:	78 4b                	js     80105160 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105115:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105118:	83 ec 08             	sub    $0x8,%esp
8010511b:	50                   	push   %eax
8010511c:	6a 02                	push   $0x2
8010511e:	e8 9d f5 ff ff       	call   801046c0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105123:	83 c4 10             	add    $0x10,%esp
80105126:	85 c0                	test   %eax,%eax
80105128:	78 36                	js     80105160 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010512a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010512e:	83 ec 0c             	sub    $0xc,%esp
80105131:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105135:	ba 03 00 00 00       	mov    $0x3,%edx
8010513a:	50                   	push   %eax
8010513b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010513e:	e8 9d f6 ff ff       	call   801047e0 <create>
80105143:	83 c4 10             	add    $0x10,%esp
80105146:	85 c0                	test   %eax,%eax
80105148:	74 16                	je     80105160 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010514a:	83 ec 0c             	sub    $0xc,%esp
8010514d:	50                   	push   %eax
8010514e:	e8 7d c7 ff ff       	call   801018d0 <iunlockput>
  end_op();
80105153:	e8 38 da ff ff       	call   80102b90 <end_op>
  return 0;
80105158:	83 c4 10             	add    $0x10,%esp
8010515b:	31 c0                	xor    %eax,%eax
}
8010515d:	c9                   	leave  
8010515e:	c3                   	ret    
8010515f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105160:	e8 2b da ff ff       	call   80102b90 <end_op>
    return -1;
80105165:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010516a:	c9                   	leave  
8010516b:	c3                   	ret    
8010516c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105170 <sys_chdir>:

int
sys_chdir(void)
{
80105170:	55                   	push   %ebp
80105171:	89 e5                	mov    %esp,%ebp
80105173:	56                   	push   %esi
80105174:	53                   	push   %ebx
80105175:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105178:	e8 d3 e5 ff ff       	call   80103750 <myproc>
8010517d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010517f:	e8 9c d9 ff ff       	call   80102b20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105184:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105187:	83 ec 08             	sub    $0x8,%esp
8010518a:	50                   	push   %eax
8010518b:	6a 00                	push   $0x0
8010518d:	e8 8e f5 ff ff       	call   80104720 <argstr>
80105192:	83 c4 10             	add    $0x10,%esp
80105195:	85 c0                	test   %eax,%eax
80105197:	78 77                	js     80105210 <sys_chdir+0xa0>
80105199:	83 ec 0c             	sub    $0xc,%esp
8010519c:	ff 75 f4             	pushl  -0xc(%ebp)
8010519f:	e8 ec cc ff ff       	call   80101e90 <namei>
801051a4:	83 c4 10             	add    $0x10,%esp
801051a7:	85 c0                	test   %eax,%eax
801051a9:	89 c3                	mov    %eax,%ebx
801051ab:	74 63                	je     80105210 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801051ad:	83 ec 0c             	sub    $0xc,%esp
801051b0:	50                   	push   %eax
801051b1:	e8 8a c4 ff ff       	call   80101640 <ilock>
  if(ip->type != T_DIR){
801051b6:	83 c4 10             	add    $0x10,%esp
801051b9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051be:	75 30                	jne    801051f0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801051c0:	83 ec 0c             	sub    $0xc,%esp
801051c3:	53                   	push   %ebx
801051c4:	e8 57 c5 ff ff       	call   80101720 <iunlock>
  iput(curproc->cwd);
801051c9:	58                   	pop    %eax
801051ca:	ff 76 68             	pushl  0x68(%esi)
801051cd:	e8 9e c5 ff ff       	call   80101770 <iput>
  end_op();
801051d2:	e8 b9 d9 ff ff       	call   80102b90 <end_op>
  curproc->cwd = ip;
801051d7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801051da:	83 c4 10             	add    $0x10,%esp
801051dd:	31 c0                	xor    %eax,%eax
}
801051df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051e2:	5b                   	pop    %ebx
801051e3:	5e                   	pop    %esi
801051e4:	5d                   	pop    %ebp
801051e5:	c3                   	ret    
801051e6:	8d 76 00             	lea    0x0(%esi),%esi
801051e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
801051f0:	83 ec 0c             	sub    $0xc,%esp
801051f3:	53                   	push   %ebx
801051f4:	e8 d7 c6 ff ff       	call   801018d0 <iunlockput>
    end_op();
801051f9:	e8 92 d9 ff ff       	call   80102b90 <end_op>
    return -1;
801051fe:	83 c4 10             	add    $0x10,%esp
80105201:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105206:	eb d7                	jmp    801051df <sys_chdir+0x6f>
80105208:	90                   	nop
80105209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
80105210:	e8 7b d9 ff ff       	call   80102b90 <end_op>
    return -1;
80105215:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010521a:	eb c3                	jmp    801051df <sys_chdir+0x6f>
8010521c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105220 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	57                   	push   %edi
80105224:	56                   	push   %esi
80105225:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105226:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010522c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105232:	50                   	push   %eax
80105233:	6a 00                	push   $0x0
80105235:	e8 e6 f4 ff ff       	call   80104720 <argstr>
8010523a:	83 c4 10             	add    $0x10,%esp
8010523d:	85 c0                	test   %eax,%eax
8010523f:	78 7f                	js     801052c0 <sys_exec+0xa0>
80105241:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105247:	83 ec 08             	sub    $0x8,%esp
8010524a:	50                   	push   %eax
8010524b:	6a 01                	push   $0x1
8010524d:	e8 6e f4 ff ff       	call   801046c0 <argint>
80105252:	83 c4 10             	add    $0x10,%esp
80105255:	85 c0                	test   %eax,%eax
80105257:	78 67                	js     801052c0 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105259:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010525f:	83 ec 04             	sub    $0x4,%esp
80105262:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105268:	68 80 00 00 00       	push   $0x80
8010526d:	6a 00                	push   $0x0
8010526f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105275:	50                   	push   %eax
80105276:	31 db                	xor    %ebx,%ebx
80105278:	e8 63 f1 ff ff       	call   801043e0 <memset>
8010527d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105280:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105286:	83 ec 08             	sub    $0x8,%esp
80105289:	57                   	push   %edi
8010528a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010528d:	50                   	push   %eax
8010528e:	e8 bd f3 ff ff       	call   80104650 <fetchint>
80105293:	83 c4 10             	add    $0x10,%esp
80105296:	85 c0                	test   %eax,%eax
80105298:	78 26                	js     801052c0 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
8010529a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801052a0:	85 c0                	test   %eax,%eax
801052a2:	74 2c                	je     801052d0 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801052a4:	83 ec 08             	sub    $0x8,%esp
801052a7:	56                   	push   %esi
801052a8:	50                   	push   %eax
801052a9:	e8 c2 f3 ff ff       	call   80104670 <fetchstr>
801052ae:	83 c4 10             	add    $0x10,%esp
801052b1:	85 c0                	test   %eax,%eax
801052b3:	78 0b                	js     801052c0 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
801052b5:	83 c3 01             	add    $0x1,%ebx
801052b8:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801052bb:	83 fb 20             	cmp    $0x20,%ebx
801052be:	75 c0                	jne    80105280 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801052c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801052c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801052c8:	5b                   	pop    %ebx
801052c9:	5e                   	pop    %esi
801052ca:	5f                   	pop    %edi
801052cb:	5d                   	pop    %ebp
801052cc:	c3                   	ret    
801052cd:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801052d0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801052d6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801052d9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801052e0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801052e4:	50                   	push   %eax
801052e5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801052eb:	e8 00 b7 ff ff       	call   801009f0 <exec>
801052f0:	83 c4 10             	add    $0x10,%esp
}
801052f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052f6:	5b                   	pop    %ebx
801052f7:	5e                   	pop    %esi
801052f8:	5f                   	pop    %edi
801052f9:	5d                   	pop    %ebp
801052fa:	c3                   	ret    
801052fb:	90                   	nop
801052fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105300 <sys_pipe>:

int
sys_pipe(void)
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	57                   	push   %edi
80105304:	56                   	push   %esi
80105305:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105306:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
80105309:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010530c:	6a 08                	push   $0x8
8010530e:	50                   	push   %eax
8010530f:	6a 00                	push   $0x0
80105311:	e8 da f3 ff ff       	call   801046f0 <argptr>
80105316:	83 c4 10             	add    $0x10,%esp
80105319:	85 c0                	test   %eax,%eax
8010531b:	78 4a                	js     80105367 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
8010531d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105320:	83 ec 08             	sub    $0x8,%esp
80105323:	50                   	push   %eax
80105324:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105327:	50                   	push   %eax
80105328:	e8 93 de ff ff       	call   801031c0 <pipealloc>
8010532d:	83 c4 10             	add    $0x10,%esp
80105330:	85 c0                	test   %eax,%eax
80105332:	78 33                	js     80105367 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105334:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105336:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105339:	e8 12 e4 ff ff       	call   80103750 <myproc>
8010533e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105340:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105344:	85 f6                	test   %esi,%esi
80105346:	74 30                	je     80105378 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105348:	83 c3 01             	add    $0x1,%ebx
8010534b:	83 fb 10             	cmp    $0x10,%ebx
8010534e:	75 f0                	jne    80105340 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105350:	83 ec 0c             	sub    $0xc,%esp
80105353:	ff 75 e0             	pushl  -0x20(%ebp)
80105356:	e8 a5 ba ff ff       	call   80100e00 <fileclose>
    fileclose(wf);
8010535b:	58                   	pop    %eax
8010535c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010535f:	e8 9c ba ff ff       	call   80100e00 <fileclose>
    return -1;
80105364:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105367:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
8010536a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010536f:	5b                   	pop    %ebx
80105370:	5e                   	pop    %esi
80105371:	5f                   	pop    %edi
80105372:	5d                   	pop    %ebp
80105373:	c3                   	ret    
80105374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105378:	8d 73 08             	lea    0x8(%ebx),%esi
8010537b:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010537f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105382:	e8 c9 e3 ff ff       	call   80103750 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105387:	31 d2                	xor    %edx,%edx
80105389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105390:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105394:	85 c9                	test   %ecx,%ecx
80105396:	74 18                	je     801053b0 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105398:	83 c2 01             	add    $0x1,%edx
8010539b:	83 fa 10             	cmp    $0x10,%edx
8010539e:	75 f0                	jne    80105390 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
801053a0:	e8 ab e3 ff ff       	call   80103750 <myproc>
801053a5:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
801053ac:	00 
801053ad:	eb a1                	jmp    80105350 <sys_pipe+0x50>
801053af:	90                   	nop
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
801053b0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801053b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801053b7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801053b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801053bc:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
801053bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
801053c2:	31 c0                	xor    %eax,%eax
}
801053c4:	5b                   	pop    %ebx
801053c5:	5e                   	pop    %esi
801053c6:	5f                   	pop    %edi
801053c7:	5d                   	pop    %ebp
801053c8:	c3                   	ret    
801053c9:	66 90                	xchg   %ax,%ax
801053cb:	66 90                	xchg   %ax,%ax
801053cd:	66 90                	xchg   %ax,%ax
801053cf:	90                   	nop

801053d0 <sys_shm_open>:
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_shm_open(void) {
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	83 ec 20             	sub    $0x20,%esp
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
801053d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
801053d9:	50                   	push   %eax
801053da:	6a 00                	push   $0x0
801053dc:	e8 df f2 ff ff       	call   801046c0 <argint>
801053e1:	83 c4 10             	add    $0x10,%esp
801053e4:	85 c0                	test   %eax,%eax
801053e6:	78 30                	js     80105418 <sys_shm_open+0x48>
    return -1;

  if(argptr(1, (char **) (&pointer),4)<0)
801053e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801053eb:	83 ec 04             	sub    $0x4,%esp
801053ee:	6a 04                	push   $0x4
801053f0:	50                   	push   %eax
801053f1:	6a 01                	push   $0x1
801053f3:	e8 f8 f2 ff ff       	call   801046f0 <argptr>
801053f8:	83 c4 10             	add    $0x10,%esp
801053fb:	85 c0                	test   %eax,%eax
801053fd:	78 19                	js     80105418 <sys_shm_open+0x48>
    return -1;
  return shm_open(id, pointer);
801053ff:	83 ec 08             	sub    $0x8,%esp
80105402:	ff 75 f4             	pushl  -0xc(%ebp)
80105405:	ff 75 f0             	pushl  -0x10(%ebp)
80105408:	e8 83 1c 00 00       	call   80107090 <shm_open>
8010540d:	83 c4 10             	add    $0x10,%esp
}
80105410:	c9                   	leave  
80105411:	c3                   	ret    
80105412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
int sys_shm_open(void) {
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
    return -1;
80105418:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  if(argptr(1, (char **) (&pointer),4)<0)
    return -1;
  return shm_open(id, pointer);
}
8010541d:	c9                   	leave  
8010541e:	c3                   	ret    
8010541f:	90                   	nop

80105420 <sys_shm_close>:

int sys_shm_close(void) {
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	83 ec 20             	sub    $0x20,%esp
  int id;

  if(argint(0, &id) < 0)
80105426:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105429:	50                   	push   %eax
8010542a:	6a 00                	push   $0x0
8010542c:	e8 8f f2 ff ff       	call   801046c0 <argint>
80105431:	83 c4 10             	add    $0x10,%esp
80105434:	85 c0                	test   %eax,%eax
80105436:	78 18                	js     80105450 <sys_shm_close+0x30>
    return -1;

  
  return shm_close(id);
80105438:	83 ec 0c             	sub    $0xc,%esp
8010543b:	ff 75 f4             	pushl  -0xc(%ebp)
8010543e:	e8 5d 1c 00 00       	call   801070a0 <shm_close>
80105443:	83 c4 10             	add    $0x10,%esp
}
80105446:	c9                   	leave  
80105447:	c3                   	ret    
80105448:	90                   	nop
80105449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

int sys_shm_close(void) {
  int id;

  if(argint(0, &id) < 0)
    return -1;
80105450:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

  
  return shm_close(id);
}
80105455:	c9                   	leave  
80105456:	c3                   	ret    
80105457:	89 f6                	mov    %esi,%esi
80105459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105460 <sys_fork>:

int
sys_fork(void)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105463:	5d                   	pop    %ebp
}

int
sys_fork(void)
{
  return fork();
80105464:	e9 87 e4 ff ff       	jmp    801038f0 <fork>
80105469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105470 <sys_exit>:
}

int
sys_exit(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	83 ec 08             	sub    $0x8,%esp
  exit();
80105476:	e8 05 e7 ff ff       	call   80103b80 <exit>
  return 0;  // not reached
}
8010547b:	31 c0                	xor    %eax,%eax
8010547d:	c9                   	leave  
8010547e:	c3                   	ret    
8010547f:	90                   	nop

80105480 <sys_wait>:

int
sys_wait(void)
{
80105480:	55                   	push   %ebp
80105481:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105483:	5d                   	pop    %ebp
}

int
sys_wait(void)
{
  return wait();
80105484:	e9 37 e9 ff ff       	jmp    80103dc0 <wait>
80105489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105490 <sys_kill>:
}

int
sys_kill(void)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105496:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105499:	50                   	push   %eax
8010549a:	6a 00                	push   $0x0
8010549c:	e8 1f f2 ff ff       	call   801046c0 <argint>
801054a1:	83 c4 10             	add    $0x10,%esp
801054a4:	85 c0                	test   %eax,%eax
801054a6:	78 18                	js     801054c0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801054a8:	83 ec 0c             	sub    $0xc,%esp
801054ab:	ff 75 f4             	pushl  -0xc(%ebp)
801054ae:	e8 5d ea ff ff       	call   80103f10 <kill>
801054b3:	83 c4 10             	add    $0x10,%esp
}
801054b6:	c9                   	leave  
801054b7:	c3                   	ret    
801054b8:	90                   	nop
801054b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
801054c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
801054c5:	c9                   	leave  
801054c6:	c3                   	ret    
801054c7:	89 f6                	mov    %esi,%esi
801054c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054d0 <sys_getpid>:

int
sys_getpid(void)
{
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801054d6:	e8 75 e2 ff ff       	call   80103750 <myproc>
801054db:	8b 40 10             	mov    0x10(%eax),%eax
}
801054de:	c9                   	leave  
801054df:	c3                   	ret    

801054e0 <sys_sbrk>:

int
sys_sbrk(void)
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801054e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return myproc()->pid;
}

int
sys_sbrk(void)
{
801054e7:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
801054ea:	50                   	push   %eax
801054eb:	6a 00                	push   $0x0
801054ed:	e8 ce f1 ff ff       	call   801046c0 <argint>
801054f2:	83 c4 10             	add    $0x10,%esp
801054f5:	85 c0                	test   %eax,%eax
801054f7:	78 27                	js     80105520 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801054f9:	e8 52 e2 ff ff       	call   80103750 <myproc>
  if(growproc(n) < 0)
801054fe:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105501:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105503:	ff 75 f4             	pushl  -0xc(%ebp)
80105506:	e8 65 e3 ff ff       	call   80103870 <growproc>
8010550b:	83 c4 10             	add    $0x10,%esp
8010550e:	85 c0                	test   %eax,%eax
80105510:	78 0e                	js     80105520 <sys_sbrk+0x40>
    return -1;
  return addr;
80105512:	89 d8                	mov    %ebx,%eax
}
80105514:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105517:	c9                   	leave  
80105518:	c3                   	ret    
80105519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
80105520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105525:	eb ed                	jmp    80105514 <sys_sbrk+0x34>
80105527:	89 f6                	mov    %esi,%esi
80105529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105530 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105534:	8d 45 f4             	lea    -0xc(%ebp),%eax
  return addr;
}

int
sys_sleep(void)
{
80105537:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
8010553a:	50                   	push   %eax
8010553b:	6a 00                	push   $0x0
8010553d:	e8 7e f1 ff ff       	call   801046c0 <argint>
80105542:	83 c4 10             	add    $0x10,%esp
80105545:	85 c0                	test   %eax,%eax
80105547:	0f 88 8a 00 00 00    	js     801055d7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010554d:	83 ec 0c             	sub    $0xc,%esp
80105550:	68 60 4d 11 80       	push   $0x80114d60
80105555:	e8 16 ed ff ff       	call   80104270 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010555a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010555d:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105560:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  while(ticks - ticks0 < n){
80105566:	85 d2                	test   %edx,%edx
80105568:	75 27                	jne    80105591 <sys_sleep+0x61>
8010556a:	eb 54                	jmp    801055c0 <sys_sleep+0x90>
8010556c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105570:	83 ec 08             	sub    $0x8,%esp
80105573:	68 60 4d 11 80       	push   $0x80114d60
80105578:	68 a0 55 11 80       	push   $0x801155a0
8010557d:	e8 7e e7 ff ff       	call   80103d00 <sleep>

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105582:	a1 a0 55 11 80       	mov    0x801155a0,%eax
80105587:	83 c4 10             	add    $0x10,%esp
8010558a:	29 d8                	sub    %ebx,%eax
8010558c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010558f:	73 2f                	jae    801055c0 <sys_sleep+0x90>
    if(myproc()->killed){
80105591:	e8 ba e1 ff ff       	call   80103750 <myproc>
80105596:	8b 40 24             	mov    0x24(%eax),%eax
80105599:	85 c0                	test   %eax,%eax
8010559b:	74 d3                	je     80105570 <sys_sleep+0x40>
      release(&tickslock);
8010559d:	83 ec 0c             	sub    $0xc,%esp
801055a0:	68 60 4d 11 80       	push   $0x80114d60
801055a5:	e8 e6 ed ff ff       	call   80104390 <release>
      return -1;
801055aa:	83 c4 10             	add    $0x10,%esp
801055ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
801055b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055b5:	c9                   	leave  
801055b6:	c3                   	ret    
801055b7:	89 f6                	mov    %esi,%esi
801055b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801055c0:	83 ec 0c             	sub    $0xc,%esp
801055c3:	68 60 4d 11 80       	push   $0x80114d60
801055c8:	e8 c3 ed ff ff       	call   80104390 <release>
  return 0;
801055cd:	83 c4 10             	add    $0x10,%esp
801055d0:	31 c0                	xor    %eax,%eax
}
801055d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801055d5:	c9                   	leave  
801055d6:	c3                   	ret    
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
801055d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055dc:	eb d4                	jmp    801055b2 <sys_sleep+0x82>
801055de:	66 90                	xchg   %ax,%ax

801055e0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	53                   	push   %ebx
801055e4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801055e7:	68 60 4d 11 80       	push   $0x80114d60
801055ec:	e8 7f ec ff ff       	call   80104270 <acquire>
  xticks = ticks;
801055f1:	8b 1d a0 55 11 80    	mov    0x801155a0,%ebx
  release(&tickslock);
801055f7:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801055fe:	e8 8d ed ff ff       	call   80104390 <release>
  return xticks;
}
80105603:	89 d8                	mov    %ebx,%eax
80105605:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105608:	c9                   	leave  
80105609:	c3                   	ret    

8010560a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010560a:	1e                   	push   %ds
  pushl %es
8010560b:	06                   	push   %es
  pushl %fs
8010560c:	0f a0                	push   %fs
  pushl %gs
8010560e:	0f a8                	push   %gs
  pushal
80105610:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105611:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105615:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105617:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105619:	54                   	push   %esp
  call trap
8010561a:	e8 e1 00 00 00       	call   80105700 <trap>
  addl $4, %esp
8010561f:	83 c4 04             	add    $0x4,%esp

80105622 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105622:	61                   	popa   
  popl %gs
80105623:	0f a9                	pop    %gs
  popl %fs
80105625:	0f a1                	pop    %fs
  popl %es
80105627:	07                   	pop    %es
  popl %ds
80105628:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105629:	83 c4 08             	add    $0x8,%esp
  iret
8010562c:	cf                   	iret   
8010562d:	66 90                	xchg   %ax,%ax
8010562f:	90                   	nop

80105630 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105630:	31 c0                	xor    %eax,%eax
80105632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105638:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010563f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105644:	c6 04 c5 a4 4d 11 80 	movb   $0x0,-0x7feeb25c(,%eax,8)
8010564b:	00 
8010564c:	66 89 0c c5 a2 4d 11 	mov    %cx,-0x7feeb25e(,%eax,8)
80105653:	80 
80105654:	c6 04 c5 a5 4d 11 80 	movb   $0x8e,-0x7feeb25b(,%eax,8)
8010565b:	8e 
8010565c:	66 89 14 c5 a0 4d 11 	mov    %dx,-0x7feeb260(,%eax,8)
80105663:	80 
80105664:	c1 ea 10             	shr    $0x10,%edx
80105667:	66 89 14 c5 a6 4d 11 	mov    %dx,-0x7feeb25a(,%eax,8)
8010566e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010566f:	83 c0 01             	add    $0x1,%eax
80105672:	3d 00 01 00 00       	cmp    $0x100,%eax
80105677:	75 bf                	jne    80105638 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105679:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010567a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010567f:	89 e5                	mov    %esp,%ebp
80105681:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105684:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105689:	68 61 78 10 80       	push   $0x80107861
8010568e:	68 60 4d 11 80       	push   $0x80114d60
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105693:	66 89 15 a2 4f 11 80 	mov    %dx,0x80114fa2
8010569a:	c6 05 a4 4f 11 80 00 	movb   $0x0,0x80114fa4
801056a1:	66 a3 a0 4f 11 80    	mov    %ax,0x80114fa0
801056a7:	c1 e8 10             	shr    $0x10,%eax
801056aa:	c6 05 a5 4f 11 80 ef 	movb   $0xef,0x80114fa5
801056b1:	66 a3 a6 4f 11 80    	mov    %ax,0x80114fa6

  initlock(&tickslock, "time");
801056b7:	e8 b4 ea ff ff       	call   80104170 <initlock>
}
801056bc:	83 c4 10             	add    $0x10,%esp
801056bf:	c9                   	leave  
801056c0:	c3                   	ret    
801056c1:	eb 0d                	jmp    801056d0 <idtinit>
801056c3:	90                   	nop
801056c4:	90                   	nop
801056c5:	90                   	nop
801056c6:	90                   	nop
801056c7:	90                   	nop
801056c8:	90                   	nop
801056c9:	90                   	nop
801056ca:	90                   	nop
801056cb:	90                   	nop
801056cc:	90                   	nop
801056cd:	90                   	nop
801056ce:	90                   	nop
801056cf:	90                   	nop

801056d0 <idtinit>:

void
idtinit(void)
{
801056d0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801056d1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801056d6:	89 e5                	mov    %esp,%ebp
801056d8:	83 ec 10             	sub    $0x10,%esp
801056db:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801056df:	b8 a0 4d 11 80       	mov    $0x80114da0,%eax
801056e4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801056e8:	c1 e8 10             	shr    $0x10,%eax
801056eb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
801056ef:	8d 45 fa             	lea    -0x6(%ebp),%eax
801056f2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801056f5:	c9                   	leave  
801056f6:	c3                   	ret    
801056f7:	89 f6                	mov    %esi,%esi
801056f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105700 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	57                   	push   %edi
80105704:	56                   	push   %esi
80105705:	53                   	push   %ebx
80105706:	83 ec 1c             	sub    $0x1c,%esp
80105709:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010570c:	8b 47 30             	mov    0x30(%edi),%eax
8010570f:	83 f8 40             	cmp    $0x40,%eax
80105712:	0f 84 18 02 00 00    	je     80105930 <trap+0x230>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105718:	83 e8 20             	sub    $0x20,%eax
8010571b:	83 f8 1f             	cmp    $0x1f,%eax
8010571e:	0f 87 94 01 00 00    	ja     801058b8 <trap+0x1b8>
80105724:	ff 24 85 38 79 10 80 	jmp    *-0x7fef86c8(,%eax,4)
8010572b:	90                   	nop
8010572c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105730:	e8 1b e0 ff ff       	call   80103750 <myproc>
80105735:	85 c0                	test   %eax,%eax
80105737:	74 1d                	je     80105756 <trap+0x56>
80105739:	e8 12 e0 ff ff       	call   80103750 <myproc>
8010573e:	8b 50 24             	mov    0x24(%eax),%edx
80105741:	85 d2                	test   %edx,%edx
80105743:	74 11                	je     80105756 <trap+0x56>
80105745:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105749:	83 e0 03             	and    $0x3,%eax
8010574c:	66 83 f8 03          	cmp    $0x3,%ax
80105750:	0f 84 12 02 00 00    	je     80105968 <trap+0x268>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105756:	e8 f5 df ff ff       	call   80103750 <myproc>
8010575b:	85 c0                	test   %eax,%eax
8010575d:	74 0f                	je     8010576e <trap+0x6e>
8010575f:	e8 ec df ff ff       	call   80103750 <myproc>
80105764:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105768:	0f 84 32 01 00 00    	je     801058a0 <trap+0x1a0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010576e:	e8 dd df ff ff       	call   80103750 <myproc>
80105773:	85 c0                	test   %eax,%eax
80105775:	74 1d                	je     80105794 <trap+0x94>
80105777:	e8 d4 df ff ff       	call   80103750 <myproc>
8010577c:	8b 40 24             	mov    0x24(%eax),%eax
8010577f:	85 c0                	test   %eax,%eax
80105781:	74 11                	je     80105794 <trap+0x94>
80105783:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105787:	83 e0 03             	and    $0x3,%eax
8010578a:	66 83 f8 03          	cmp    $0x3,%ax
8010578e:	0f 84 c5 01 00 00    	je     80105959 <trap+0x259>
    exit();
}
80105794:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105797:	5b                   	pop    %ebx
80105798:	5e                   	pop    %esi
80105799:	5f                   	pop    %edi
8010579a:	5d                   	pop    %ebp
8010579b:	c3                   	ret    
8010579c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801057a0:	e8 7b c8 ff ff       	call   80102020 <ideintr>
    lapiceoi();
801057a5:	e8 36 cf ff ff       	call   801026e0 <lapiceoi>
801057aa:	8b 47 30             	mov    0x30(%edi),%eax
801057ad:	8d 76 00             	lea    0x0(%esi),%esi
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  if(tf->trapno == T_PGFLT){//cs153
801057b0:	83 f8 0e             	cmp    $0xe,%eax
801057b3:	0f 85 77 ff ff ff    	jne    80105730 <trap+0x30>
    cprintf("In trap 14");
801057b9:	83 ec 0c             	sub    $0xc,%esp
801057bc:	68 6b 78 10 80       	push   $0x8010786b
801057c1:	e8 9a ae ff ff       	call   80100660 <cprintf>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801057c6:	0f 20 d0             	mov    %cr2,%eax
    char* new_page;
    uint page_bottom;
    page_bottom = PGROUNDDOWN(rcr2());
801057c9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801057ce:	89 c6                	mov    %eax,%esi
    new_page = kalloc();//returns physical page
801057d0:	e8 8b cc ff ff       	call   80102460 <kalloc>
    if(new_page == 0){
801057d5:	83 c4 10             	add    $0x10,%esp
801057d8:	85 c0                	test   %eax,%eax
  if(tf->trapno == T_PGFLT){//cs153
    cprintf("In trap 14");
    char* new_page;
    uint page_bottom;
    page_bottom = PGROUNDDOWN(rcr2());
    new_page = kalloc();//returns physical page
801057da:	89 c3                	mov    %eax,%ebx
    if(new_page == 0){
801057dc:	0f 84 9e 01 00 00    	je     80105980 <trap+0x280>
      cprintf("no memory left");
    }
    else{
      memset(new_page, 0, PGSIZE);
801057e2:	83 ec 04             	sub    $0x4,%esp
      mappages(myproc()->pgdir, (void*) page_bottom, PGSIZE, V2P(new_page), PTE_W|PTE_U);
801057e5:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    new_page = kalloc();//returns physical page
    if(new_page == 0){
      cprintf("no memory left");
    }
    else{
      memset(new_page, 0, PGSIZE);
801057eb:	68 00 10 00 00       	push   $0x1000
801057f0:	6a 00                	push   $0x0
801057f2:	50                   	push   %eax
801057f3:	e8 e8 eb ff ff       	call   801043e0 <memset>
      mappages(myproc()->pgdir, (void*) page_bottom, PGSIZE, V2P(new_page), PTE_W|PTE_U);
801057f8:	e8 53 df ff ff       	call   80103750 <myproc>
801057fd:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80105804:	53                   	push   %ebx
80105805:	68 00 10 00 00       	push   $0x1000
8010580a:	56                   	push   %esi
8010580b:	ff 70 04             	pushl  0x4(%eax)
8010580e:	e8 fd 0f 00 00       	call   80106810 <mappages>
      cprintf("Allocated a new page");
80105813:	83 c4 20             	add    $0x20,%esp
80105816:	c7 45 08 85 78 10 80 	movl   $0x80107885,0x8(%ebp)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
8010581d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105820:	5b                   	pop    %ebx
80105821:	5e                   	pop    %esi
80105822:	5f                   	pop    %edi
80105823:	5d                   	pop    %ebp
      cprintf("no memory left");
    }
    else{
      memset(new_page, 0, PGSIZE);
      mappages(myproc()->pgdir, (void*) page_bottom, PGSIZE, V2P(new_page), PTE_W|PTE_U);
      cprintf("Allocated a new page");
80105824:	e9 37 ae ff ff       	jmp    80100660 <cprintf>
80105829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105830:	e8 fb de ff ff       	call   80103730 <cpuid>
80105835:	85 c0                	test   %eax,%eax
80105837:	0f 84 53 01 00 00    	je     80105990 <trap+0x290>
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
8010583d:	e8 9e ce ff ff       	call   801026e0 <lapiceoi>
80105842:	8b 47 30             	mov    0x30(%edi),%eax
    break;
80105845:	e9 66 ff ff ff       	jmp    801057b0 <trap+0xb0>
8010584a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105850:	e8 4b cd ff ff       	call   801025a0 <kbdintr>
    lapiceoi();
80105855:	e8 86 ce ff ff       	call   801026e0 <lapiceoi>
8010585a:	8b 47 30             	mov    0x30(%edi),%eax
    break;
8010585d:	e9 4e ff ff ff       	jmp    801057b0 <trap+0xb0>
80105862:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105868:	e8 f3 02 00 00       	call   80105b60 <uartintr>
8010586d:	eb ce                	jmp    8010583d <trap+0x13d>
8010586f:	90                   	nop
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105870:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105874:	8b 77 38             	mov    0x38(%edi),%esi
80105877:	e8 b4 de ff ff       	call   80103730 <cpuid>
8010587c:	56                   	push   %esi
8010587d:	53                   	push   %ebx
8010587e:	50                   	push   %eax
8010587f:	68 9c 78 10 80       	push   $0x8010789c
80105884:	e8 d7 ad ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105889:	e8 52 ce ff ff       	call   801026e0 <lapiceoi>
8010588e:	8b 47 30             	mov    0x30(%edi),%eax
    break;
80105891:	83 c4 10             	add    $0x10,%esp
80105894:	e9 17 ff ff ff       	jmp    801057b0 <trap+0xb0>
80105899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801058a0:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801058a4:	0f 85 c4 fe ff ff    	jne    8010576e <trap+0x6e>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
801058aa:	e8 01 e4 ff ff       	call   80103cb0 <yield>
801058af:	e9 ba fe ff ff       	jmp    8010576e <trap+0x6e>
801058b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801058b8:	e8 93 de ff ff       	call   80103750 <myproc>
801058bd:	85 c0                	test   %eax,%eax
801058bf:	0f 84 ff 00 00 00    	je     801059c4 <trap+0x2c4>
801058c5:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801058c9:	0f 84 f5 00 00 00    	je     801059c4 <trap+0x2c4>
801058cf:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058d2:	8b 57 38             	mov    0x38(%edi),%edx
801058d5:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801058d8:	89 55 dc             	mov    %edx,-0x24(%ebp)
801058db:	e8 50 de ff ff       	call   80103730 <cpuid>
801058e0:	8b 77 34             	mov    0x34(%edi),%esi
801058e3:	8b 5f 30             	mov    0x30(%edi),%ebx
801058e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801058e9:	e8 62 de ff ff       	call   80103750 <myproc>
801058ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
801058f1:	e8 5a de ff ff       	call   80103750 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058f6:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801058f9:	8b 55 dc             	mov    -0x24(%ebp),%edx
801058fc:	51                   	push   %ecx
801058fd:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801058fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105901:	ff 75 e4             	pushl  -0x1c(%ebp)
80105904:	56                   	push   %esi
80105905:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105906:	83 c2 6c             	add    $0x6c,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105909:	52                   	push   %edx
8010590a:	ff 70 10             	pushl  0x10(%eax)
8010590d:	68 f4 78 10 80       	push   $0x801078f4
80105912:	e8 49 ad ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105917:	83 c4 20             	add    $0x20,%esp
8010591a:	e8 31 de ff ff       	call   80103750 <myproc>
8010591f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105926:	8b 47 30             	mov    0x30(%edi),%eax
80105929:	e9 82 fe ff ff       	jmp    801057b0 <trap+0xb0>
8010592e:	66 90                	xchg   %ax,%ax
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80105930:	e8 1b de ff ff       	call   80103750 <myproc>
80105935:	8b 58 24             	mov    0x24(%eax),%ebx
80105938:	85 db                	test   %ebx,%ebx
8010593a:	75 3c                	jne    80105978 <trap+0x278>
      exit();
    myproc()->tf = tf;
8010593c:	e8 0f de ff ff       	call   80103750 <myproc>
80105941:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105944:	e8 37 ee ff ff       	call   80104780 <syscall>
    if(myproc()->killed)
80105949:	e8 02 de ff ff       	call   80103750 <myproc>
8010594e:	8b 48 24             	mov    0x24(%eax),%ecx
80105951:	85 c9                	test   %ecx,%ecx
80105953:	0f 84 3b fe ff ff    	je     80105794 <trap+0x94>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105959:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010595c:	5b                   	pop    %ebx
8010595d:	5e                   	pop    %esi
8010595e:	5f                   	pop    %edi
8010595f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80105960:	e9 1b e2 ff ff       	jmp    80103b80 <exit>
80105965:	8d 76 00             	lea    0x0(%esi),%esi

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
80105968:	e8 13 e2 ff ff       	call   80103b80 <exit>
8010596d:	e9 e4 fd ff ff       	jmp    80105756 <trap+0x56>
80105972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80105978:	e8 03 e2 ff ff       	call   80103b80 <exit>
8010597d:	eb bd                	jmp    8010593c <trap+0x23c>
8010597f:	90                   	nop
    char* new_page;
    uint page_bottom;
    page_bottom = PGROUNDDOWN(rcr2());
    new_page = kalloc();//returns physical page
    if(new_page == 0){
      cprintf("no memory left");
80105980:	c7 45 08 76 78 10 80 	movl   $0x80107876,0x8(%ebp)
80105987:	e9 91 fe ff ff       	jmp    8010581d <trap+0x11d>
8010598c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80105990:	83 ec 0c             	sub    $0xc,%esp
80105993:	68 60 4d 11 80       	push   $0x80114d60
80105998:	e8 d3 e8 ff ff       	call   80104270 <acquire>
      ticks++;
      wakeup(&ticks);
8010599d:	c7 04 24 a0 55 11 80 	movl   $0x801155a0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
801059a4:	83 05 a0 55 11 80 01 	addl   $0x1,0x801155a0
      wakeup(&ticks);
801059ab:	e8 00 e5 ff ff       	call   80103eb0 <wakeup>
      release(&tickslock);
801059b0:	c7 04 24 60 4d 11 80 	movl   $0x80114d60,(%esp)
801059b7:	e8 d4 e9 ff ff       	call   80104390 <release>
801059bc:	83 c4 10             	add    $0x10,%esp
801059bf:	e9 79 fe ff ff       	jmp    8010583d <trap+0x13d>
801059c4:	0f 20 d6             	mov    %cr2,%esi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801059c7:	8b 5f 38             	mov    0x38(%edi),%ebx
801059ca:	e8 61 dd ff ff       	call   80103730 <cpuid>
801059cf:	83 ec 0c             	sub    $0xc,%esp
801059d2:	56                   	push   %esi
801059d3:	53                   	push   %ebx
801059d4:	50                   	push   %eax
801059d5:	ff 77 30             	pushl  0x30(%edi)
801059d8:	68 c0 78 10 80       	push   $0x801078c0
801059dd:	e8 7e ac ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
801059e2:	83 c4 14             	add    $0x14,%esp
801059e5:	68 66 78 10 80       	push   $0x80107866
801059ea:	e8 81 a9 ff ff       	call   80100370 <panic>
801059ef:	90                   	nop

801059f0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801059f0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801059f5:	55                   	push   %ebp
801059f6:	89 e5                	mov    %esp,%ebp
  if(!uart)
801059f8:	85 c0                	test   %eax,%eax
801059fa:	74 1c                	je     80105a18 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801059fc:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105a01:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105a02:	a8 01                	test   $0x1,%al
80105a04:	74 12                	je     80105a18 <uartgetc+0x28>
80105a06:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a0b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105a0c:	0f b6 c0             	movzbl %al,%eax
}
80105a0f:	5d                   	pop    %ebp
80105a10:	c3                   	ret    
80105a11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105a18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105a1d:	5d                   	pop    %ebp
80105a1e:	c3                   	ret    
80105a1f:	90                   	nop

80105a20 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	57                   	push   %edi
80105a24:	56                   	push   %esi
80105a25:	53                   	push   %ebx
80105a26:	89 c7                	mov    %eax,%edi
80105a28:	bb 80 00 00 00       	mov    $0x80,%ebx
80105a2d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105a32:	83 ec 0c             	sub    $0xc,%esp
80105a35:	eb 1b                	jmp    80105a52 <uartputc.part.0+0x32>
80105a37:	89 f6                	mov    %esi,%esi
80105a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105a40:	83 ec 0c             	sub    $0xc,%esp
80105a43:	6a 0a                	push   $0xa
80105a45:	e8 b6 cc ff ff       	call   80102700 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105a4a:	83 c4 10             	add    $0x10,%esp
80105a4d:	83 eb 01             	sub    $0x1,%ebx
80105a50:	74 07                	je     80105a59 <uartputc.part.0+0x39>
80105a52:	89 f2                	mov    %esi,%edx
80105a54:	ec                   	in     (%dx),%al
80105a55:	a8 20                	test   $0x20,%al
80105a57:	74 e7                	je     80105a40 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105a59:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a5e:	89 f8                	mov    %edi,%eax
80105a60:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105a61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a64:	5b                   	pop    %ebx
80105a65:	5e                   	pop    %esi
80105a66:	5f                   	pop    %edi
80105a67:	5d                   	pop    %ebp
80105a68:	c3                   	ret    
80105a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105a70 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105a70:	55                   	push   %ebp
80105a71:	31 c9                	xor    %ecx,%ecx
80105a73:	89 c8                	mov    %ecx,%eax
80105a75:	89 e5                	mov    %esp,%ebp
80105a77:	57                   	push   %edi
80105a78:	56                   	push   %esi
80105a79:	53                   	push   %ebx
80105a7a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105a7f:	89 da                	mov    %ebx,%edx
80105a81:	83 ec 0c             	sub    $0xc,%esp
80105a84:	ee                   	out    %al,(%dx)
80105a85:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105a8a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105a8f:	89 fa                	mov    %edi,%edx
80105a91:	ee                   	out    %al,(%dx)
80105a92:	b8 0c 00 00 00       	mov    $0xc,%eax
80105a97:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105a9c:	ee                   	out    %al,(%dx)
80105a9d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105aa2:	89 c8                	mov    %ecx,%eax
80105aa4:	89 f2                	mov    %esi,%edx
80105aa6:	ee                   	out    %al,(%dx)
80105aa7:	b8 03 00 00 00       	mov    $0x3,%eax
80105aac:	89 fa                	mov    %edi,%edx
80105aae:	ee                   	out    %al,(%dx)
80105aaf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105ab4:	89 c8                	mov    %ecx,%eax
80105ab6:	ee                   	out    %al,(%dx)
80105ab7:	b8 01 00 00 00       	mov    $0x1,%eax
80105abc:	89 f2                	mov    %esi,%edx
80105abe:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105abf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ac4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105ac5:	3c ff                	cmp    $0xff,%al
80105ac7:	74 5a                	je     80105b23 <uartinit+0xb3>
    return;
  uart = 1;
80105ac9:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105ad0:	00 00 00 
80105ad3:	89 da                	mov    %ebx,%edx
80105ad5:	ec                   	in     (%dx),%al
80105ad6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105adb:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105adc:	83 ec 08             	sub    $0x8,%esp
80105adf:	bb b8 79 10 80       	mov    $0x801079b8,%ebx
80105ae4:	6a 00                	push   $0x0
80105ae6:	6a 04                	push   $0x4
80105ae8:	e8 83 c7 ff ff       	call   80102270 <ioapicenable>
80105aed:	83 c4 10             	add    $0x10,%esp
80105af0:	b8 78 00 00 00       	mov    $0x78,%eax
80105af5:	eb 13                	jmp    80105b0a <uartinit+0x9a>
80105af7:	89 f6                	mov    %esi,%esi
80105af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105b00:	83 c3 01             	add    $0x1,%ebx
80105b03:	0f be 03             	movsbl (%ebx),%eax
80105b06:	84 c0                	test   %al,%al
80105b08:	74 19                	je     80105b23 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
80105b0a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105b10:	85 d2                	test   %edx,%edx
80105b12:	74 ec                	je     80105b00 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105b14:	83 c3 01             	add    $0x1,%ebx
80105b17:	e8 04 ff ff ff       	call   80105a20 <uartputc.part.0>
80105b1c:	0f be 03             	movsbl (%ebx),%eax
80105b1f:	84 c0                	test   %al,%al
80105b21:	75 e7                	jne    80105b0a <uartinit+0x9a>
    uartputc(*p);
}
80105b23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b26:	5b                   	pop    %ebx
80105b27:	5e                   	pop    %esi
80105b28:	5f                   	pop    %edi
80105b29:	5d                   	pop    %ebp
80105b2a:	c3                   	ret    
80105b2b:	90                   	nop
80105b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b30 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105b30:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105b36:	55                   	push   %ebp
80105b37:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80105b39:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
80105b3e:	74 10                	je     80105b50 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80105b40:	5d                   	pop    %ebp
80105b41:	e9 da fe ff ff       	jmp    80105a20 <uartputc.part.0>
80105b46:	8d 76 00             	lea    0x0(%esi),%esi
80105b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105b50:	5d                   	pop    %ebp
80105b51:	c3                   	ret    
80105b52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b60 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105b66:	68 f0 59 10 80       	push   $0x801059f0
80105b6b:	e8 80 ac ff ff       	call   801007f0 <consoleintr>
}
80105b70:	83 c4 10             	add    $0x10,%esp
80105b73:	c9                   	leave  
80105b74:	c3                   	ret    

80105b75 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105b75:	6a 00                	push   $0x0
  pushl $0
80105b77:	6a 00                	push   $0x0
  jmp alltraps
80105b79:	e9 8c fa ff ff       	jmp    8010560a <alltraps>

80105b7e <vector1>:
.globl vector1
vector1:
  pushl $0
80105b7e:	6a 00                	push   $0x0
  pushl $1
80105b80:	6a 01                	push   $0x1
  jmp alltraps
80105b82:	e9 83 fa ff ff       	jmp    8010560a <alltraps>

80105b87 <vector2>:
.globl vector2
vector2:
  pushl $0
80105b87:	6a 00                	push   $0x0
  pushl $2
80105b89:	6a 02                	push   $0x2
  jmp alltraps
80105b8b:	e9 7a fa ff ff       	jmp    8010560a <alltraps>

80105b90 <vector3>:
.globl vector3
vector3:
  pushl $0
80105b90:	6a 00                	push   $0x0
  pushl $3
80105b92:	6a 03                	push   $0x3
  jmp alltraps
80105b94:	e9 71 fa ff ff       	jmp    8010560a <alltraps>

80105b99 <vector4>:
.globl vector4
vector4:
  pushl $0
80105b99:	6a 00                	push   $0x0
  pushl $4
80105b9b:	6a 04                	push   $0x4
  jmp alltraps
80105b9d:	e9 68 fa ff ff       	jmp    8010560a <alltraps>

80105ba2 <vector5>:
.globl vector5
vector5:
  pushl $0
80105ba2:	6a 00                	push   $0x0
  pushl $5
80105ba4:	6a 05                	push   $0x5
  jmp alltraps
80105ba6:	e9 5f fa ff ff       	jmp    8010560a <alltraps>

80105bab <vector6>:
.globl vector6
vector6:
  pushl $0
80105bab:	6a 00                	push   $0x0
  pushl $6
80105bad:	6a 06                	push   $0x6
  jmp alltraps
80105baf:	e9 56 fa ff ff       	jmp    8010560a <alltraps>

80105bb4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105bb4:	6a 00                	push   $0x0
  pushl $7
80105bb6:	6a 07                	push   $0x7
  jmp alltraps
80105bb8:	e9 4d fa ff ff       	jmp    8010560a <alltraps>

80105bbd <vector8>:
.globl vector8
vector8:
  pushl $8
80105bbd:	6a 08                	push   $0x8
  jmp alltraps
80105bbf:	e9 46 fa ff ff       	jmp    8010560a <alltraps>

80105bc4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105bc4:	6a 00                	push   $0x0
  pushl $9
80105bc6:	6a 09                	push   $0x9
  jmp alltraps
80105bc8:	e9 3d fa ff ff       	jmp    8010560a <alltraps>

80105bcd <vector10>:
.globl vector10
vector10:
  pushl $10
80105bcd:	6a 0a                	push   $0xa
  jmp alltraps
80105bcf:	e9 36 fa ff ff       	jmp    8010560a <alltraps>

80105bd4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105bd4:	6a 0b                	push   $0xb
  jmp alltraps
80105bd6:	e9 2f fa ff ff       	jmp    8010560a <alltraps>

80105bdb <vector12>:
.globl vector12
vector12:
  pushl $12
80105bdb:	6a 0c                	push   $0xc
  jmp alltraps
80105bdd:	e9 28 fa ff ff       	jmp    8010560a <alltraps>

80105be2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105be2:	6a 0d                	push   $0xd
  jmp alltraps
80105be4:	e9 21 fa ff ff       	jmp    8010560a <alltraps>

80105be9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105be9:	6a 0e                	push   $0xe
  jmp alltraps
80105beb:	e9 1a fa ff ff       	jmp    8010560a <alltraps>

80105bf0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105bf0:	6a 00                	push   $0x0
  pushl $15
80105bf2:	6a 0f                	push   $0xf
  jmp alltraps
80105bf4:	e9 11 fa ff ff       	jmp    8010560a <alltraps>

80105bf9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105bf9:	6a 00                	push   $0x0
  pushl $16
80105bfb:	6a 10                	push   $0x10
  jmp alltraps
80105bfd:	e9 08 fa ff ff       	jmp    8010560a <alltraps>

80105c02 <vector17>:
.globl vector17
vector17:
  pushl $17
80105c02:	6a 11                	push   $0x11
  jmp alltraps
80105c04:	e9 01 fa ff ff       	jmp    8010560a <alltraps>

80105c09 <vector18>:
.globl vector18
vector18:
  pushl $0
80105c09:	6a 00                	push   $0x0
  pushl $18
80105c0b:	6a 12                	push   $0x12
  jmp alltraps
80105c0d:	e9 f8 f9 ff ff       	jmp    8010560a <alltraps>

80105c12 <vector19>:
.globl vector19
vector19:
  pushl $0
80105c12:	6a 00                	push   $0x0
  pushl $19
80105c14:	6a 13                	push   $0x13
  jmp alltraps
80105c16:	e9 ef f9 ff ff       	jmp    8010560a <alltraps>

80105c1b <vector20>:
.globl vector20
vector20:
  pushl $0
80105c1b:	6a 00                	push   $0x0
  pushl $20
80105c1d:	6a 14                	push   $0x14
  jmp alltraps
80105c1f:	e9 e6 f9 ff ff       	jmp    8010560a <alltraps>

80105c24 <vector21>:
.globl vector21
vector21:
  pushl $0
80105c24:	6a 00                	push   $0x0
  pushl $21
80105c26:	6a 15                	push   $0x15
  jmp alltraps
80105c28:	e9 dd f9 ff ff       	jmp    8010560a <alltraps>

80105c2d <vector22>:
.globl vector22
vector22:
  pushl $0
80105c2d:	6a 00                	push   $0x0
  pushl $22
80105c2f:	6a 16                	push   $0x16
  jmp alltraps
80105c31:	e9 d4 f9 ff ff       	jmp    8010560a <alltraps>

80105c36 <vector23>:
.globl vector23
vector23:
  pushl $0
80105c36:	6a 00                	push   $0x0
  pushl $23
80105c38:	6a 17                	push   $0x17
  jmp alltraps
80105c3a:	e9 cb f9 ff ff       	jmp    8010560a <alltraps>

80105c3f <vector24>:
.globl vector24
vector24:
  pushl $0
80105c3f:	6a 00                	push   $0x0
  pushl $24
80105c41:	6a 18                	push   $0x18
  jmp alltraps
80105c43:	e9 c2 f9 ff ff       	jmp    8010560a <alltraps>

80105c48 <vector25>:
.globl vector25
vector25:
  pushl $0
80105c48:	6a 00                	push   $0x0
  pushl $25
80105c4a:	6a 19                	push   $0x19
  jmp alltraps
80105c4c:	e9 b9 f9 ff ff       	jmp    8010560a <alltraps>

80105c51 <vector26>:
.globl vector26
vector26:
  pushl $0
80105c51:	6a 00                	push   $0x0
  pushl $26
80105c53:	6a 1a                	push   $0x1a
  jmp alltraps
80105c55:	e9 b0 f9 ff ff       	jmp    8010560a <alltraps>

80105c5a <vector27>:
.globl vector27
vector27:
  pushl $0
80105c5a:	6a 00                	push   $0x0
  pushl $27
80105c5c:	6a 1b                	push   $0x1b
  jmp alltraps
80105c5e:	e9 a7 f9 ff ff       	jmp    8010560a <alltraps>

80105c63 <vector28>:
.globl vector28
vector28:
  pushl $0
80105c63:	6a 00                	push   $0x0
  pushl $28
80105c65:	6a 1c                	push   $0x1c
  jmp alltraps
80105c67:	e9 9e f9 ff ff       	jmp    8010560a <alltraps>

80105c6c <vector29>:
.globl vector29
vector29:
  pushl $0
80105c6c:	6a 00                	push   $0x0
  pushl $29
80105c6e:	6a 1d                	push   $0x1d
  jmp alltraps
80105c70:	e9 95 f9 ff ff       	jmp    8010560a <alltraps>

80105c75 <vector30>:
.globl vector30
vector30:
  pushl $0
80105c75:	6a 00                	push   $0x0
  pushl $30
80105c77:	6a 1e                	push   $0x1e
  jmp alltraps
80105c79:	e9 8c f9 ff ff       	jmp    8010560a <alltraps>

80105c7e <vector31>:
.globl vector31
vector31:
  pushl $0
80105c7e:	6a 00                	push   $0x0
  pushl $31
80105c80:	6a 1f                	push   $0x1f
  jmp alltraps
80105c82:	e9 83 f9 ff ff       	jmp    8010560a <alltraps>

80105c87 <vector32>:
.globl vector32
vector32:
  pushl $0
80105c87:	6a 00                	push   $0x0
  pushl $32
80105c89:	6a 20                	push   $0x20
  jmp alltraps
80105c8b:	e9 7a f9 ff ff       	jmp    8010560a <alltraps>

80105c90 <vector33>:
.globl vector33
vector33:
  pushl $0
80105c90:	6a 00                	push   $0x0
  pushl $33
80105c92:	6a 21                	push   $0x21
  jmp alltraps
80105c94:	e9 71 f9 ff ff       	jmp    8010560a <alltraps>

80105c99 <vector34>:
.globl vector34
vector34:
  pushl $0
80105c99:	6a 00                	push   $0x0
  pushl $34
80105c9b:	6a 22                	push   $0x22
  jmp alltraps
80105c9d:	e9 68 f9 ff ff       	jmp    8010560a <alltraps>

80105ca2 <vector35>:
.globl vector35
vector35:
  pushl $0
80105ca2:	6a 00                	push   $0x0
  pushl $35
80105ca4:	6a 23                	push   $0x23
  jmp alltraps
80105ca6:	e9 5f f9 ff ff       	jmp    8010560a <alltraps>

80105cab <vector36>:
.globl vector36
vector36:
  pushl $0
80105cab:	6a 00                	push   $0x0
  pushl $36
80105cad:	6a 24                	push   $0x24
  jmp alltraps
80105caf:	e9 56 f9 ff ff       	jmp    8010560a <alltraps>

80105cb4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105cb4:	6a 00                	push   $0x0
  pushl $37
80105cb6:	6a 25                	push   $0x25
  jmp alltraps
80105cb8:	e9 4d f9 ff ff       	jmp    8010560a <alltraps>

80105cbd <vector38>:
.globl vector38
vector38:
  pushl $0
80105cbd:	6a 00                	push   $0x0
  pushl $38
80105cbf:	6a 26                	push   $0x26
  jmp alltraps
80105cc1:	e9 44 f9 ff ff       	jmp    8010560a <alltraps>

80105cc6 <vector39>:
.globl vector39
vector39:
  pushl $0
80105cc6:	6a 00                	push   $0x0
  pushl $39
80105cc8:	6a 27                	push   $0x27
  jmp alltraps
80105cca:	e9 3b f9 ff ff       	jmp    8010560a <alltraps>

80105ccf <vector40>:
.globl vector40
vector40:
  pushl $0
80105ccf:	6a 00                	push   $0x0
  pushl $40
80105cd1:	6a 28                	push   $0x28
  jmp alltraps
80105cd3:	e9 32 f9 ff ff       	jmp    8010560a <alltraps>

80105cd8 <vector41>:
.globl vector41
vector41:
  pushl $0
80105cd8:	6a 00                	push   $0x0
  pushl $41
80105cda:	6a 29                	push   $0x29
  jmp alltraps
80105cdc:	e9 29 f9 ff ff       	jmp    8010560a <alltraps>

80105ce1 <vector42>:
.globl vector42
vector42:
  pushl $0
80105ce1:	6a 00                	push   $0x0
  pushl $42
80105ce3:	6a 2a                	push   $0x2a
  jmp alltraps
80105ce5:	e9 20 f9 ff ff       	jmp    8010560a <alltraps>

80105cea <vector43>:
.globl vector43
vector43:
  pushl $0
80105cea:	6a 00                	push   $0x0
  pushl $43
80105cec:	6a 2b                	push   $0x2b
  jmp alltraps
80105cee:	e9 17 f9 ff ff       	jmp    8010560a <alltraps>

80105cf3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105cf3:	6a 00                	push   $0x0
  pushl $44
80105cf5:	6a 2c                	push   $0x2c
  jmp alltraps
80105cf7:	e9 0e f9 ff ff       	jmp    8010560a <alltraps>

80105cfc <vector45>:
.globl vector45
vector45:
  pushl $0
80105cfc:	6a 00                	push   $0x0
  pushl $45
80105cfe:	6a 2d                	push   $0x2d
  jmp alltraps
80105d00:	e9 05 f9 ff ff       	jmp    8010560a <alltraps>

80105d05 <vector46>:
.globl vector46
vector46:
  pushl $0
80105d05:	6a 00                	push   $0x0
  pushl $46
80105d07:	6a 2e                	push   $0x2e
  jmp alltraps
80105d09:	e9 fc f8 ff ff       	jmp    8010560a <alltraps>

80105d0e <vector47>:
.globl vector47
vector47:
  pushl $0
80105d0e:	6a 00                	push   $0x0
  pushl $47
80105d10:	6a 2f                	push   $0x2f
  jmp alltraps
80105d12:	e9 f3 f8 ff ff       	jmp    8010560a <alltraps>

80105d17 <vector48>:
.globl vector48
vector48:
  pushl $0
80105d17:	6a 00                	push   $0x0
  pushl $48
80105d19:	6a 30                	push   $0x30
  jmp alltraps
80105d1b:	e9 ea f8 ff ff       	jmp    8010560a <alltraps>

80105d20 <vector49>:
.globl vector49
vector49:
  pushl $0
80105d20:	6a 00                	push   $0x0
  pushl $49
80105d22:	6a 31                	push   $0x31
  jmp alltraps
80105d24:	e9 e1 f8 ff ff       	jmp    8010560a <alltraps>

80105d29 <vector50>:
.globl vector50
vector50:
  pushl $0
80105d29:	6a 00                	push   $0x0
  pushl $50
80105d2b:	6a 32                	push   $0x32
  jmp alltraps
80105d2d:	e9 d8 f8 ff ff       	jmp    8010560a <alltraps>

80105d32 <vector51>:
.globl vector51
vector51:
  pushl $0
80105d32:	6a 00                	push   $0x0
  pushl $51
80105d34:	6a 33                	push   $0x33
  jmp alltraps
80105d36:	e9 cf f8 ff ff       	jmp    8010560a <alltraps>

80105d3b <vector52>:
.globl vector52
vector52:
  pushl $0
80105d3b:	6a 00                	push   $0x0
  pushl $52
80105d3d:	6a 34                	push   $0x34
  jmp alltraps
80105d3f:	e9 c6 f8 ff ff       	jmp    8010560a <alltraps>

80105d44 <vector53>:
.globl vector53
vector53:
  pushl $0
80105d44:	6a 00                	push   $0x0
  pushl $53
80105d46:	6a 35                	push   $0x35
  jmp alltraps
80105d48:	e9 bd f8 ff ff       	jmp    8010560a <alltraps>

80105d4d <vector54>:
.globl vector54
vector54:
  pushl $0
80105d4d:	6a 00                	push   $0x0
  pushl $54
80105d4f:	6a 36                	push   $0x36
  jmp alltraps
80105d51:	e9 b4 f8 ff ff       	jmp    8010560a <alltraps>

80105d56 <vector55>:
.globl vector55
vector55:
  pushl $0
80105d56:	6a 00                	push   $0x0
  pushl $55
80105d58:	6a 37                	push   $0x37
  jmp alltraps
80105d5a:	e9 ab f8 ff ff       	jmp    8010560a <alltraps>

80105d5f <vector56>:
.globl vector56
vector56:
  pushl $0
80105d5f:	6a 00                	push   $0x0
  pushl $56
80105d61:	6a 38                	push   $0x38
  jmp alltraps
80105d63:	e9 a2 f8 ff ff       	jmp    8010560a <alltraps>

80105d68 <vector57>:
.globl vector57
vector57:
  pushl $0
80105d68:	6a 00                	push   $0x0
  pushl $57
80105d6a:	6a 39                	push   $0x39
  jmp alltraps
80105d6c:	e9 99 f8 ff ff       	jmp    8010560a <alltraps>

80105d71 <vector58>:
.globl vector58
vector58:
  pushl $0
80105d71:	6a 00                	push   $0x0
  pushl $58
80105d73:	6a 3a                	push   $0x3a
  jmp alltraps
80105d75:	e9 90 f8 ff ff       	jmp    8010560a <alltraps>

80105d7a <vector59>:
.globl vector59
vector59:
  pushl $0
80105d7a:	6a 00                	push   $0x0
  pushl $59
80105d7c:	6a 3b                	push   $0x3b
  jmp alltraps
80105d7e:	e9 87 f8 ff ff       	jmp    8010560a <alltraps>

80105d83 <vector60>:
.globl vector60
vector60:
  pushl $0
80105d83:	6a 00                	push   $0x0
  pushl $60
80105d85:	6a 3c                	push   $0x3c
  jmp alltraps
80105d87:	e9 7e f8 ff ff       	jmp    8010560a <alltraps>

80105d8c <vector61>:
.globl vector61
vector61:
  pushl $0
80105d8c:	6a 00                	push   $0x0
  pushl $61
80105d8e:	6a 3d                	push   $0x3d
  jmp alltraps
80105d90:	e9 75 f8 ff ff       	jmp    8010560a <alltraps>

80105d95 <vector62>:
.globl vector62
vector62:
  pushl $0
80105d95:	6a 00                	push   $0x0
  pushl $62
80105d97:	6a 3e                	push   $0x3e
  jmp alltraps
80105d99:	e9 6c f8 ff ff       	jmp    8010560a <alltraps>

80105d9e <vector63>:
.globl vector63
vector63:
  pushl $0
80105d9e:	6a 00                	push   $0x0
  pushl $63
80105da0:	6a 3f                	push   $0x3f
  jmp alltraps
80105da2:	e9 63 f8 ff ff       	jmp    8010560a <alltraps>

80105da7 <vector64>:
.globl vector64
vector64:
  pushl $0
80105da7:	6a 00                	push   $0x0
  pushl $64
80105da9:	6a 40                	push   $0x40
  jmp alltraps
80105dab:	e9 5a f8 ff ff       	jmp    8010560a <alltraps>

80105db0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105db0:	6a 00                	push   $0x0
  pushl $65
80105db2:	6a 41                	push   $0x41
  jmp alltraps
80105db4:	e9 51 f8 ff ff       	jmp    8010560a <alltraps>

80105db9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105db9:	6a 00                	push   $0x0
  pushl $66
80105dbb:	6a 42                	push   $0x42
  jmp alltraps
80105dbd:	e9 48 f8 ff ff       	jmp    8010560a <alltraps>

80105dc2 <vector67>:
.globl vector67
vector67:
  pushl $0
80105dc2:	6a 00                	push   $0x0
  pushl $67
80105dc4:	6a 43                	push   $0x43
  jmp alltraps
80105dc6:	e9 3f f8 ff ff       	jmp    8010560a <alltraps>

80105dcb <vector68>:
.globl vector68
vector68:
  pushl $0
80105dcb:	6a 00                	push   $0x0
  pushl $68
80105dcd:	6a 44                	push   $0x44
  jmp alltraps
80105dcf:	e9 36 f8 ff ff       	jmp    8010560a <alltraps>

80105dd4 <vector69>:
.globl vector69
vector69:
  pushl $0
80105dd4:	6a 00                	push   $0x0
  pushl $69
80105dd6:	6a 45                	push   $0x45
  jmp alltraps
80105dd8:	e9 2d f8 ff ff       	jmp    8010560a <alltraps>

80105ddd <vector70>:
.globl vector70
vector70:
  pushl $0
80105ddd:	6a 00                	push   $0x0
  pushl $70
80105ddf:	6a 46                	push   $0x46
  jmp alltraps
80105de1:	e9 24 f8 ff ff       	jmp    8010560a <alltraps>

80105de6 <vector71>:
.globl vector71
vector71:
  pushl $0
80105de6:	6a 00                	push   $0x0
  pushl $71
80105de8:	6a 47                	push   $0x47
  jmp alltraps
80105dea:	e9 1b f8 ff ff       	jmp    8010560a <alltraps>

80105def <vector72>:
.globl vector72
vector72:
  pushl $0
80105def:	6a 00                	push   $0x0
  pushl $72
80105df1:	6a 48                	push   $0x48
  jmp alltraps
80105df3:	e9 12 f8 ff ff       	jmp    8010560a <alltraps>

80105df8 <vector73>:
.globl vector73
vector73:
  pushl $0
80105df8:	6a 00                	push   $0x0
  pushl $73
80105dfa:	6a 49                	push   $0x49
  jmp alltraps
80105dfc:	e9 09 f8 ff ff       	jmp    8010560a <alltraps>

80105e01 <vector74>:
.globl vector74
vector74:
  pushl $0
80105e01:	6a 00                	push   $0x0
  pushl $74
80105e03:	6a 4a                	push   $0x4a
  jmp alltraps
80105e05:	e9 00 f8 ff ff       	jmp    8010560a <alltraps>

80105e0a <vector75>:
.globl vector75
vector75:
  pushl $0
80105e0a:	6a 00                	push   $0x0
  pushl $75
80105e0c:	6a 4b                	push   $0x4b
  jmp alltraps
80105e0e:	e9 f7 f7 ff ff       	jmp    8010560a <alltraps>

80105e13 <vector76>:
.globl vector76
vector76:
  pushl $0
80105e13:	6a 00                	push   $0x0
  pushl $76
80105e15:	6a 4c                	push   $0x4c
  jmp alltraps
80105e17:	e9 ee f7 ff ff       	jmp    8010560a <alltraps>

80105e1c <vector77>:
.globl vector77
vector77:
  pushl $0
80105e1c:	6a 00                	push   $0x0
  pushl $77
80105e1e:	6a 4d                	push   $0x4d
  jmp alltraps
80105e20:	e9 e5 f7 ff ff       	jmp    8010560a <alltraps>

80105e25 <vector78>:
.globl vector78
vector78:
  pushl $0
80105e25:	6a 00                	push   $0x0
  pushl $78
80105e27:	6a 4e                	push   $0x4e
  jmp alltraps
80105e29:	e9 dc f7 ff ff       	jmp    8010560a <alltraps>

80105e2e <vector79>:
.globl vector79
vector79:
  pushl $0
80105e2e:	6a 00                	push   $0x0
  pushl $79
80105e30:	6a 4f                	push   $0x4f
  jmp alltraps
80105e32:	e9 d3 f7 ff ff       	jmp    8010560a <alltraps>

80105e37 <vector80>:
.globl vector80
vector80:
  pushl $0
80105e37:	6a 00                	push   $0x0
  pushl $80
80105e39:	6a 50                	push   $0x50
  jmp alltraps
80105e3b:	e9 ca f7 ff ff       	jmp    8010560a <alltraps>

80105e40 <vector81>:
.globl vector81
vector81:
  pushl $0
80105e40:	6a 00                	push   $0x0
  pushl $81
80105e42:	6a 51                	push   $0x51
  jmp alltraps
80105e44:	e9 c1 f7 ff ff       	jmp    8010560a <alltraps>

80105e49 <vector82>:
.globl vector82
vector82:
  pushl $0
80105e49:	6a 00                	push   $0x0
  pushl $82
80105e4b:	6a 52                	push   $0x52
  jmp alltraps
80105e4d:	e9 b8 f7 ff ff       	jmp    8010560a <alltraps>

80105e52 <vector83>:
.globl vector83
vector83:
  pushl $0
80105e52:	6a 00                	push   $0x0
  pushl $83
80105e54:	6a 53                	push   $0x53
  jmp alltraps
80105e56:	e9 af f7 ff ff       	jmp    8010560a <alltraps>

80105e5b <vector84>:
.globl vector84
vector84:
  pushl $0
80105e5b:	6a 00                	push   $0x0
  pushl $84
80105e5d:	6a 54                	push   $0x54
  jmp alltraps
80105e5f:	e9 a6 f7 ff ff       	jmp    8010560a <alltraps>

80105e64 <vector85>:
.globl vector85
vector85:
  pushl $0
80105e64:	6a 00                	push   $0x0
  pushl $85
80105e66:	6a 55                	push   $0x55
  jmp alltraps
80105e68:	e9 9d f7 ff ff       	jmp    8010560a <alltraps>

80105e6d <vector86>:
.globl vector86
vector86:
  pushl $0
80105e6d:	6a 00                	push   $0x0
  pushl $86
80105e6f:	6a 56                	push   $0x56
  jmp alltraps
80105e71:	e9 94 f7 ff ff       	jmp    8010560a <alltraps>

80105e76 <vector87>:
.globl vector87
vector87:
  pushl $0
80105e76:	6a 00                	push   $0x0
  pushl $87
80105e78:	6a 57                	push   $0x57
  jmp alltraps
80105e7a:	e9 8b f7 ff ff       	jmp    8010560a <alltraps>

80105e7f <vector88>:
.globl vector88
vector88:
  pushl $0
80105e7f:	6a 00                	push   $0x0
  pushl $88
80105e81:	6a 58                	push   $0x58
  jmp alltraps
80105e83:	e9 82 f7 ff ff       	jmp    8010560a <alltraps>

80105e88 <vector89>:
.globl vector89
vector89:
  pushl $0
80105e88:	6a 00                	push   $0x0
  pushl $89
80105e8a:	6a 59                	push   $0x59
  jmp alltraps
80105e8c:	e9 79 f7 ff ff       	jmp    8010560a <alltraps>

80105e91 <vector90>:
.globl vector90
vector90:
  pushl $0
80105e91:	6a 00                	push   $0x0
  pushl $90
80105e93:	6a 5a                	push   $0x5a
  jmp alltraps
80105e95:	e9 70 f7 ff ff       	jmp    8010560a <alltraps>

80105e9a <vector91>:
.globl vector91
vector91:
  pushl $0
80105e9a:	6a 00                	push   $0x0
  pushl $91
80105e9c:	6a 5b                	push   $0x5b
  jmp alltraps
80105e9e:	e9 67 f7 ff ff       	jmp    8010560a <alltraps>

80105ea3 <vector92>:
.globl vector92
vector92:
  pushl $0
80105ea3:	6a 00                	push   $0x0
  pushl $92
80105ea5:	6a 5c                	push   $0x5c
  jmp alltraps
80105ea7:	e9 5e f7 ff ff       	jmp    8010560a <alltraps>

80105eac <vector93>:
.globl vector93
vector93:
  pushl $0
80105eac:	6a 00                	push   $0x0
  pushl $93
80105eae:	6a 5d                	push   $0x5d
  jmp alltraps
80105eb0:	e9 55 f7 ff ff       	jmp    8010560a <alltraps>

80105eb5 <vector94>:
.globl vector94
vector94:
  pushl $0
80105eb5:	6a 00                	push   $0x0
  pushl $94
80105eb7:	6a 5e                	push   $0x5e
  jmp alltraps
80105eb9:	e9 4c f7 ff ff       	jmp    8010560a <alltraps>

80105ebe <vector95>:
.globl vector95
vector95:
  pushl $0
80105ebe:	6a 00                	push   $0x0
  pushl $95
80105ec0:	6a 5f                	push   $0x5f
  jmp alltraps
80105ec2:	e9 43 f7 ff ff       	jmp    8010560a <alltraps>

80105ec7 <vector96>:
.globl vector96
vector96:
  pushl $0
80105ec7:	6a 00                	push   $0x0
  pushl $96
80105ec9:	6a 60                	push   $0x60
  jmp alltraps
80105ecb:	e9 3a f7 ff ff       	jmp    8010560a <alltraps>

80105ed0 <vector97>:
.globl vector97
vector97:
  pushl $0
80105ed0:	6a 00                	push   $0x0
  pushl $97
80105ed2:	6a 61                	push   $0x61
  jmp alltraps
80105ed4:	e9 31 f7 ff ff       	jmp    8010560a <alltraps>

80105ed9 <vector98>:
.globl vector98
vector98:
  pushl $0
80105ed9:	6a 00                	push   $0x0
  pushl $98
80105edb:	6a 62                	push   $0x62
  jmp alltraps
80105edd:	e9 28 f7 ff ff       	jmp    8010560a <alltraps>

80105ee2 <vector99>:
.globl vector99
vector99:
  pushl $0
80105ee2:	6a 00                	push   $0x0
  pushl $99
80105ee4:	6a 63                	push   $0x63
  jmp alltraps
80105ee6:	e9 1f f7 ff ff       	jmp    8010560a <alltraps>

80105eeb <vector100>:
.globl vector100
vector100:
  pushl $0
80105eeb:	6a 00                	push   $0x0
  pushl $100
80105eed:	6a 64                	push   $0x64
  jmp alltraps
80105eef:	e9 16 f7 ff ff       	jmp    8010560a <alltraps>

80105ef4 <vector101>:
.globl vector101
vector101:
  pushl $0
80105ef4:	6a 00                	push   $0x0
  pushl $101
80105ef6:	6a 65                	push   $0x65
  jmp alltraps
80105ef8:	e9 0d f7 ff ff       	jmp    8010560a <alltraps>

80105efd <vector102>:
.globl vector102
vector102:
  pushl $0
80105efd:	6a 00                	push   $0x0
  pushl $102
80105eff:	6a 66                	push   $0x66
  jmp alltraps
80105f01:	e9 04 f7 ff ff       	jmp    8010560a <alltraps>

80105f06 <vector103>:
.globl vector103
vector103:
  pushl $0
80105f06:	6a 00                	push   $0x0
  pushl $103
80105f08:	6a 67                	push   $0x67
  jmp alltraps
80105f0a:	e9 fb f6 ff ff       	jmp    8010560a <alltraps>

80105f0f <vector104>:
.globl vector104
vector104:
  pushl $0
80105f0f:	6a 00                	push   $0x0
  pushl $104
80105f11:	6a 68                	push   $0x68
  jmp alltraps
80105f13:	e9 f2 f6 ff ff       	jmp    8010560a <alltraps>

80105f18 <vector105>:
.globl vector105
vector105:
  pushl $0
80105f18:	6a 00                	push   $0x0
  pushl $105
80105f1a:	6a 69                	push   $0x69
  jmp alltraps
80105f1c:	e9 e9 f6 ff ff       	jmp    8010560a <alltraps>

80105f21 <vector106>:
.globl vector106
vector106:
  pushl $0
80105f21:	6a 00                	push   $0x0
  pushl $106
80105f23:	6a 6a                	push   $0x6a
  jmp alltraps
80105f25:	e9 e0 f6 ff ff       	jmp    8010560a <alltraps>

80105f2a <vector107>:
.globl vector107
vector107:
  pushl $0
80105f2a:	6a 00                	push   $0x0
  pushl $107
80105f2c:	6a 6b                	push   $0x6b
  jmp alltraps
80105f2e:	e9 d7 f6 ff ff       	jmp    8010560a <alltraps>

80105f33 <vector108>:
.globl vector108
vector108:
  pushl $0
80105f33:	6a 00                	push   $0x0
  pushl $108
80105f35:	6a 6c                	push   $0x6c
  jmp alltraps
80105f37:	e9 ce f6 ff ff       	jmp    8010560a <alltraps>

80105f3c <vector109>:
.globl vector109
vector109:
  pushl $0
80105f3c:	6a 00                	push   $0x0
  pushl $109
80105f3e:	6a 6d                	push   $0x6d
  jmp alltraps
80105f40:	e9 c5 f6 ff ff       	jmp    8010560a <alltraps>

80105f45 <vector110>:
.globl vector110
vector110:
  pushl $0
80105f45:	6a 00                	push   $0x0
  pushl $110
80105f47:	6a 6e                	push   $0x6e
  jmp alltraps
80105f49:	e9 bc f6 ff ff       	jmp    8010560a <alltraps>

80105f4e <vector111>:
.globl vector111
vector111:
  pushl $0
80105f4e:	6a 00                	push   $0x0
  pushl $111
80105f50:	6a 6f                	push   $0x6f
  jmp alltraps
80105f52:	e9 b3 f6 ff ff       	jmp    8010560a <alltraps>

80105f57 <vector112>:
.globl vector112
vector112:
  pushl $0
80105f57:	6a 00                	push   $0x0
  pushl $112
80105f59:	6a 70                	push   $0x70
  jmp alltraps
80105f5b:	e9 aa f6 ff ff       	jmp    8010560a <alltraps>

80105f60 <vector113>:
.globl vector113
vector113:
  pushl $0
80105f60:	6a 00                	push   $0x0
  pushl $113
80105f62:	6a 71                	push   $0x71
  jmp alltraps
80105f64:	e9 a1 f6 ff ff       	jmp    8010560a <alltraps>

80105f69 <vector114>:
.globl vector114
vector114:
  pushl $0
80105f69:	6a 00                	push   $0x0
  pushl $114
80105f6b:	6a 72                	push   $0x72
  jmp alltraps
80105f6d:	e9 98 f6 ff ff       	jmp    8010560a <alltraps>

80105f72 <vector115>:
.globl vector115
vector115:
  pushl $0
80105f72:	6a 00                	push   $0x0
  pushl $115
80105f74:	6a 73                	push   $0x73
  jmp alltraps
80105f76:	e9 8f f6 ff ff       	jmp    8010560a <alltraps>

80105f7b <vector116>:
.globl vector116
vector116:
  pushl $0
80105f7b:	6a 00                	push   $0x0
  pushl $116
80105f7d:	6a 74                	push   $0x74
  jmp alltraps
80105f7f:	e9 86 f6 ff ff       	jmp    8010560a <alltraps>

80105f84 <vector117>:
.globl vector117
vector117:
  pushl $0
80105f84:	6a 00                	push   $0x0
  pushl $117
80105f86:	6a 75                	push   $0x75
  jmp alltraps
80105f88:	e9 7d f6 ff ff       	jmp    8010560a <alltraps>

80105f8d <vector118>:
.globl vector118
vector118:
  pushl $0
80105f8d:	6a 00                	push   $0x0
  pushl $118
80105f8f:	6a 76                	push   $0x76
  jmp alltraps
80105f91:	e9 74 f6 ff ff       	jmp    8010560a <alltraps>

80105f96 <vector119>:
.globl vector119
vector119:
  pushl $0
80105f96:	6a 00                	push   $0x0
  pushl $119
80105f98:	6a 77                	push   $0x77
  jmp alltraps
80105f9a:	e9 6b f6 ff ff       	jmp    8010560a <alltraps>

80105f9f <vector120>:
.globl vector120
vector120:
  pushl $0
80105f9f:	6a 00                	push   $0x0
  pushl $120
80105fa1:	6a 78                	push   $0x78
  jmp alltraps
80105fa3:	e9 62 f6 ff ff       	jmp    8010560a <alltraps>

80105fa8 <vector121>:
.globl vector121
vector121:
  pushl $0
80105fa8:	6a 00                	push   $0x0
  pushl $121
80105faa:	6a 79                	push   $0x79
  jmp alltraps
80105fac:	e9 59 f6 ff ff       	jmp    8010560a <alltraps>

80105fb1 <vector122>:
.globl vector122
vector122:
  pushl $0
80105fb1:	6a 00                	push   $0x0
  pushl $122
80105fb3:	6a 7a                	push   $0x7a
  jmp alltraps
80105fb5:	e9 50 f6 ff ff       	jmp    8010560a <alltraps>

80105fba <vector123>:
.globl vector123
vector123:
  pushl $0
80105fba:	6a 00                	push   $0x0
  pushl $123
80105fbc:	6a 7b                	push   $0x7b
  jmp alltraps
80105fbe:	e9 47 f6 ff ff       	jmp    8010560a <alltraps>

80105fc3 <vector124>:
.globl vector124
vector124:
  pushl $0
80105fc3:	6a 00                	push   $0x0
  pushl $124
80105fc5:	6a 7c                	push   $0x7c
  jmp alltraps
80105fc7:	e9 3e f6 ff ff       	jmp    8010560a <alltraps>

80105fcc <vector125>:
.globl vector125
vector125:
  pushl $0
80105fcc:	6a 00                	push   $0x0
  pushl $125
80105fce:	6a 7d                	push   $0x7d
  jmp alltraps
80105fd0:	e9 35 f6 ff ff       	jmp    8010560a <alltraps>

80105fd5 <vector126>:
.globl vector126
vector126:
  pushl $0
80105fd5:	6a 00                	push   $0x0
  pushl $126
80105fd7:	6a 7e                	push   $0x7e
  jmp alltraps
80105fd9:	e9 2c f6 ff ff       	jmp    8010560a <alltraps>

80105fde <vector127>:
.globl vector127
vector127:
  pushl $0
80105fde:	6a 00                	push   $0x0
  pushl $127
80105fe0:	6a 7f                	push   $0x7f
  jmp alltraps
80105fe2:	e9 23 f6 ff ff       	jmp    8010560a <alltraps>

80105fe7 <vector128>:
.globl vector128
vector128:
  pushl $0
80105fe7:	6a 00                	push   $0x0
  pushl $128
80105fe9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105fee:	e9 17 f6 ff ff       	jmp    8010560a <alltraps>

80105ff3 <vector129>:
.globl vector129
vector129:
  pushl $0
80105ff3:	6a 00                	push   $0x0
  pushl $129
80105ff5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105ffa:	e9 0b f6 ff ff       	jmp    8010560a <alltraps>

80105fff <vector130>:
.globl vector130
vector130:
  pushl $0
80105fff:	6a 00                	push   $0x0
  pushl $130
80106001:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106006:	e9 ff f5 ff ff       	jmp    8010560a <alltraps>

8010600b <vector131>:
.globl vector131
vector131:
  pushl $0
8010600b:	6a 00                	push   $0x0
  pushl $131
8010600d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106012:	e9 f3 f5 ff ff       	jmp    8010560a <alltraps>

80106017 <vector132>:
.globl vector132
vector132:
  pushl $0
80106017:	6a 00                	push   $0x0
  pushl $132
80106019:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010601e:	e9 e7 f5 ff ff       	jmp    8010560a <alltraps>

80106023 <vector133>:
.globl vector133
vector133:
  pushl $0
80106023:	6a 00                	push   $0x0
  pushl $133
80106025:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010602a:	e9 db f5 ff ff       	jmp    8010560a <alltraps>

8010602f <vector134>:
.globl vector134
vector134:
  pushl $0
8010602f:	6a 00                	push   $0x0
  pushl $134
80106031:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106036:	e9 cf f5 ff ff       	jmp    8010560a <alltraps>

8010603b <vector135>:
.globl vector135
vector135:
  pushl $0
8010603b:	6a 00                	push   $0x0
  pushl $135
8010603d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106042:	e9 c3 f5 ff ff       	jmp    8010560a <alltraps>

80106047 <vector136>:
.globl vector136
vector136:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $136
80106049:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010604e:	e9 b7 f5 ff ff       	jmp    8010560a <alltraps>

80106053 <vector137>:
.globl vector137
vector137:
  pushl $0
80106053:	6a 00                	push   $0x0
  pushl $137
80106055:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010605a:	e9 ab f5 ff ff       	jmp    8010560a <alltraps>

8010605f <vector138>:
.globl vector138
vector138:
  pushl $0
8010605f:	6a 00                	push   $0x0
  pushl $138
80106061:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106066:	e9 9f f5 ff ff       	jmp    8010560a <alltraps>

8010606b <vector139>:
.globl vector139
vector139:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $139
8010606d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106072:	e9 93 f5 ff ff       	jmp    8010560a <alltraps>

80106077 <vector140>:
.globl vector140
vector140:
  pushl $0
80106077:	6a 00                	push   $0x0
  pushl $140
80106079:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010607e:	e9 87 f5 ff ff       	jmp    8010560a <alltraps>

80106083 <vector141>:
.globl vector141
vector141:
  pushl $0
80106083:	6a 00                	push   $0x0
  pushl $141
80106085:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010608a:	e9 7b f5 ff ff       	jmp    8010560a <alltraps>

8010608f <vector142>:
.globl vector142
vector142:
  pushl $0
8010608f:	6a 00                	push   $0x0
  pushl $142
80106091:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106096:	e9 6f f5 ff ff       	jmp    8010560a <alltraps>

8010609b <vector143>:
.globl vector143
vector143:
  pushl $0
8010609b:	6a 00                	push   $0x0
  pushl $143
8010609d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801060a2:	e9 63 f5 ff ff       	jmp    8010560a <alltraps>

801060a7 <vector144>:
.globl vector144
vector144:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $144
801060a9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801060ae:	e9 57 f5 ff ff       	jmp    8010560a <alltraps>

801060b3 <vector145>:
.globl vector145
vector145:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $145
801060b5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801060ba:	e9 4b f5 ff ff       	jmp    8010560a <alltraps>

801060bf <vector146>:
.globl vector146
vector146:
  pushl $0
801060bf:	6a 00                	push   $0x0
  pushl $146
801060c1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801060c6:	e9 3f f5 ff ff       	jmp    8010560a <alltraps>

801060cb <vector147>:
.globl vector147
vector147:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $147
801060cd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801060d2:	e9 33 f5 ff ff       	jmp    8010560a <alltraps>

801060d7 <vector148>:
.globl vector148
vector148:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $148
801060d9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801060de:	e9 27 f5 ff ff       	jmp    8010560a <alltraps>

801060e3 <vector149>:
.globl vector149
vector149:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $149
801060e5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801060ea:	e9 1b f5 ff ff       	jmp    8010560a <alltraps>

801060ef <vector150>:
.globl vector150
vector150:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $150
801060f1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801060f6:	e9 0f f5 ff ff       	jmp    8010560a <alltraps>

801060fb <vector151>:
.globl vector151
vector151:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $151
801060fd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106102:	e9 03 f5 ff ff       	jmp    8010560a <alltraps>

80106107 <vector152>:
.globl vector152
vector152:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $152
80106109:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010610e:	e9 f7 f4 ff ff       	jmp    8010560a <alltraps>

80106113 <vector153>:
.globl vector153
vector153:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $153
80106115:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010611a:	e9 eb f4 ff ff       	jmp    8010560a <alltraps>

8010611f <vector154>:
.globl vector154
vector154:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $154
80106121:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106126:	e9 df f4 ff ff       	jmp    8010560a <alltraps>

8010612b <vector155>:
.globl vector155
vector155:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $155
8010612d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106132:	e9 d3 f4 ff ff       	jmp    8010560a <alltraps>

80106137 <vector156>:
.globl vector156
vector156:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $156
80106139:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010613e:	e9 c7 f4 ff ff       	jmp    8010560a <alltraps>

80106143 <vector157>:
.globl vector157
vector157:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $157
80106145:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010614a:	e9 bb f4 ff ff       	jmp    8010560a <alltraps>

8010614f <vector158>:
.globl vector158
vector158:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $158
80106151:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106156:	e9 af f4 ff ff       	jmp    8010560a <alltraps>

8010615b <vector159>:
.globl vector159
vector159:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $159
8010615d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106162:	e9 a3 f4 ff ff       	jmp    8010560a <alltraps>

80106167 <vector160>:
.globl vector160
vector160:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $160
80106169:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010616e:	e9 97 f4 ff ff       	jmp    8010560a <alltraps>

80106173 <vector161>:
.globl vector161
vector161:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $161
80106175:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010617a:	e9 8b f4 ff ff       	jmp    8010560a <alltraps>

8010617f <vector162>:
.globl vector162
vector162:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $162
80106181:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106186:	e9 7f f4 ff ff       	jmp    8010560a <alltraps>

8010618b <vector163>:
.globl vector163
vector163:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $163
8010618d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106192:	e9 73 f4 ff ff       	jmp    8010560a <alltraps>

80106197 <vector164>:
.globl vector164
vector164:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $164
80106199:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010619e:	e9 67 f4 ff ff       	jmp    8010560a <alltraps>

801061a3 <vector165>:
.globl vector165
vector165:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $165
801061a5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801061aa:	e9 5b f4 ff ff       	jmp    8010560a <alltraps>

801061af <vector166>:
.globl vector166
vector166:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $166
801061b1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801061b6:	e9 4f f4 ff ff       	jmp    8010560a <alltraps>

801061bb <vector167>:
.globl vector167
vector167:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $167
801061bd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801061c2:	e9 43 f4 ff ff       	jmp    8010560a <alltraps>

801061c7 <vector168>:
.globl vector168
vector168:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $168
801061c9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801061ce:	e9 37 f4 ff ff       	jmp    8010560a <alltraps>

801061d3 <vector169>:
.globl vector169
vector169:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $169
801061d5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801061da:	e9 2b f4 ff ff       	jmp    8010560a <alltraps>

801061df <vector170>:
.globl vector170
vector170:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $170
801061e1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801061e6:	e9 1f f4 ff ff       	jmp    8010560a <alltraps>

801061eb <vector171>:
.globl vector171
vector171:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $171
801061ed:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801061f2:	e9 13 f4 ff ff       	jmp    8010560a <alltraps>

801061f7 <vector172>:
.globl vector172
vector172:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $172
801061f9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801061fe:	e9 07 f4 ff ff       	jmp    8010560a <alltraps>

80106203 <vector173>:
.globl vector173
vector173:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $173
80106205:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010620a:	e9 fb f3 ff ff       	jmp    8010560a <alltraps>

8010620f <vector174>:
.globl vector174
vector174:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $174
80106211:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106216:	e9 ef f3 ff ff       	jmp    8010560a <alltraps>

8010621b <vector175>:
.globl vector175
vector175:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $175
8010621d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106222:	e9 e3 f3 ff ff       	jmp    8010560a <alltraps>

80106227 <vector176>:
.globl vector176
vector176:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $176
80106229:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010622e:	e9 d7 f3 ff ff       	jmp    8010560a <alltraps>

80106233 <vector177>:
.globl vector177
vector177:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $177
80106235:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010623a:	e9 cb f3 ff ff       	jmp    8010560a <alltraps>

8010623f <vector178>:
.globl vector178
vector178:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $178
80106241:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106246:	e9 bf f3 ff ff       	jmp    8010560a <alltraps>

8010624b <vector179>:
.globl vector179
vector179:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $179
8010624d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106252:	e9 b3 f3 ff ff       	jmp    8010560a <alltraps>

80106257 <vector180>:
.globl vector180
vector180:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $180
80106259:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010625e:	e9 a7 f3 ff ff       	jmp    8010560a <alltraps>

80106263 <vector181>:
.globl vector181
vector181:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $181
80106265:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010626a:	e9 9b f3 ff ff       	jmp    8010560a <alltraps>

8010626f <vector182>:
.globl vector182
vector182:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $182
80106271:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106276:	e9 8f f3 ff ff       	jmp    8010560a <alltraps>

8010627b <vector183>:
.globl vector183
vector183:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $183
8010627d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106282:	e9 83 f3 ff ff       	jmp    8010560a <alltraps>

80106287 <vector184>:
.globl vector184
vector184:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $184
80106289:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010628e:	e9 77 f3 ff ff       	jmp    8010560a <alltraps>

80106293 <vector185>:
.globl vector185
vector185:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $185
80106295:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010629a:	e9 6b f3 ff ff       	jmp    8010560a <alltraps>

8010629f <vector186>:
.globl vector186
vector186:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $186
801062a1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801062a6:	e9 5f f3 ff ff       	jmp    8010560a <alltraps>

801062ab <vector187>:
.globl vector187
vector187:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $187
801062ad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801062b2:	e9 53 f3 ff ff       	jmp    8010560a <alltraps>

801062b7 <vector188>:
.globl vector188
vector188:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $188
801062b9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801062be:	e9 47 f3 ff ff       	jmp    8010560a <alltraps>

801062c3 <vector189>:
.globl vector189
vector189:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $189
801062c5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801062ca:	e9 3b f3 ff ff       	jmp    8010560a <alltraps>

801062cf <vector190>:
.globl vector190
vector190:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $190
801062d1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801062d6:	e9 2f f3 ff ff       	jmp    8010560a <alltraps>

801062db <vector191>:
.globl vector191
vector191:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $191
801062dd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801062e2:	e9 23 f3 ff ff       	jmp    8010560a <alltraps>

801062e7 <vector192>:
.globl vector192
vector192:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $192
801062e9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801062ee:	e9 17 f3 ff ff       	jmp    8010560a <alltraps>

801062f3 <vector193>:
.globl vector193
vector193:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $193
801062f5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801062fa:	e9 0b f3 ff ff       	jmp    8010560a <alltraps>

801062ff <vector194>:
.globl vector194
vector194:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $194
80106301:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106306:	e9 ff f2 ff ff       	jmp    8010560a <alltraps>

8010630b <vector195>:
.globl vector195
vector195:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $195
8010630d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106312:	e9 f3 f2 ff ff       	jmp    8010560a <alltraps>

80106317 <vector196>:
.globl vector196
vector196:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $196
80106319:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010631e:	e9 e7 f2 ff ff       	jmp    8010560a <alltraps>

80106323 <vector197>:
.globl vector197
vector197:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $197
80106325:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010632a:	e9 db f2 ff ff       	jmp    8010560a <alltraps>

8010632f <vector198>:
.globl vector198
vector198:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $198
80106331:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106336:	e9 cf f2 ff ff       	jmp    8010560a <alltraps>

8010633b <vector199>:
.globl vector199
vector199:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $199
8010633d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106342:	e9 c3 f2 ff ff       	jmp    8010560a <alltraps>

80106347 <vector200>:
.globl vector200
vector200:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $200
80106349:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010634e:	e9 b7 f2 ff ff       	jmp    8010560a <alltraps>

80106353 <vector201>:
.globl vector201
vector201:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $201
80106355:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010635a:	e9 ab f2 ff ff       	jmp    8010560a <alltraps>

8010635f <vector202>:
.globl vector202
vector202:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $202
80106361:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106366:	e9 9f f2 ff ff       	jmp    8010560a <alltraps>

8010636b <vector203>:
.globl vector203
vector203:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $203
8010636d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106372:	e9 93 f2 ff ff       	jmp    8010560a <alltraps>

80106377 <vector204>:
.globl vector204
vector204:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $204
80106379:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010637e:	e9 87 f2 ff ff       	jmp    8010560a <alltraps>

80106383 <vector205>:
.globl vector205
vector205:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $205
80106385:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010638a:	e9 7b f2 ff ff       	jmp    8010560a <alltraps>

8010638f <vector206>:
.globl vector206
vector206:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $206
80106391:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106396:	e9 6f f2 ff ff       	jmp    8010560a <alltraps>

8010639b <vector207>:
.globl vector207
vector207:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $207
8010639d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801063a2:	e9 63 f2 ff ff       	jmp    8010560a <alltraps>

801063a7 <vector208>:
.globl vector208
vector208:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $208
801063a9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801063ae:	e9 57 f2 ff ff       	jmp    8010560a <alltraps>

801063b3 <vector209>:
.globl vector209
vector209:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $209
801063b5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801063ba:	e9 4b f2 ff ff       	jmp    8010560a <alltraps>

801063bf <vector210>:
.globl vector210
vector210:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $210
801063c1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801063c6:	e9 3f f2 ff ff       	jmp    8010560a <alltraps>

801063cb <vector211>:
.globl vector211
vector211:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $211
801063cd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801063d2:	e9 33 f2 ff ff       	jmp    8010560a <alltraps>

801063d7 <vector212>:
.globl vector212
vector212:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $212
801063d9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801063de:	e9 27 f2 ff ff       	jmp    8010560a <alltraps>

801063e3 <vector213>:
.globl vector213
vector213:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $213
801063e5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801063ea:	e9 1b f2 ff ff       	jmp    8010560a <alltraps>

801063ef <vector214>:
.globl vector214
vector214:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $214
801063f1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801063f6:	e9 0f f2 ff ff       	jmp    8010560a <alltraps>

801063fb <vector215>:
.globl vector215
vector215:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $215
801063fd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106402:	e9 03 f2 ff ff       	jmp    8010560a <alltraps>

80106407 <vector216>:
.globl vector216
vector216:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $216
80106409:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010640e:	e9 f7 f1 ff ff       	jmp    8010560a <alltraps>

80106413 <vector217>:
.globl vector217
vector217:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $217
80106415:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010641a:	e9 eb f1 ff ff       	jmp    8010560a <alltraps>

8010641f <vector218>:
.globl vector218
vector218:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $218
80106421:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106426:	e9 df f1 ff ff       	jmp    8010560a <alltraps>

8010642b <vector219>:
.globl vector219
vector219:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $219
8010642d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106432:	e9 d3 f1 ff ff       	jmp    8010560a <alltraps>

80106437 <vector220>:
.globl vector220
vector220:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $220
80106439:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010643e:	e9 c7 f1 ff ff       	jmp    8010560a <alltraps>

80106443 <vector221>:
.globl vector221
vector221:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $221
80106445:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010644a:	e9 bb f1 ff ff       	jmp    8010560a <alltraps>

8010644f <vector222>:
.globl vector222
vector222:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $222
80106451:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106456:	e9 af f1 ff ff       	jmp    8010560a <alltraps>

8010645b <vector223>:
.globl vector223
vector223:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $223
8010645d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106462:	e9 a3 f1 ff ff       	jmp    8010560a <alltraps>

80106467 <vector224>:
.globl vector224
vector224:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $224
80106469:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010646e:	e9 97 f1 ff ff       	jmp    8010560a <alltraps>

80106473 <vector225>:
.globl vector225
vector225:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $225
80106475:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010647a:	e9 8b f1 ff ff       	jmp    8010560a <alltraps>

8010647f <vector226>:
.globl vector226
vector226:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $226
80106481:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106486:	e9 7f f1 ff ff       	jmp    8010560a <alltraps>

8010648b <vector227>:
.globl vector227
vector227:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $227
8010648d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106492:	e9 73 f1 ff ff       	jmp    8010560a <alltraps>

80106497 <vector228>:
.globl vector228
vector228:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $228
80106499:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010649e:	e9 67 f1 ff ff       	jmp    8010560a <alltraps>

801064a3 <vector229>:
.globl vector229
vector229:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $229
801064a5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801064aa:	e9 5b f1 ff ff       	jmp    8010560a <alltraps>

801064af <vector230>:
.globl vector230
vector230:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $230
801064b1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801064b6:	e9 4f f1 ff ff       	jmp    8010560a <alltraps>

801064bb <vector231>:
.globl vector231
vector231:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $231
801064bd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801064c2:	e9 43 f1 ff ff       	jmp    8010560a <alltraps>

801064c7 <vector232>:
.globl vector232
vector232:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $232
801064c9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801064ce:	e9 37 f1 ff ff       	jmp    8010560a <alltraps>

801064d3 <vector233>:
.globl vector233
vector233:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $233
801064d5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801064da:	e9 2b f1 ff ff       	jmp    8010560a <alltraps>

801064df <vector234>:
.globl vector234
vector234:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $234
801064e1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801064e6:	e9 1f f1 ff ff       	jmp    8010560a <alltraps>

801064eb <vector235>:
.globl vector235
vector235:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $235
801064ed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801064f2:	e9 13 f1 ff ff       	jmp    8010560a <alltraps>

801064f7 <vector236>:
.globl vector236
vector236:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $236
801064f9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801064fe:	e9 07 f1 ff ff       	jmp    8010560a <alltraps>

80106503 <vector237>:
.globl vector237
vector237:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $237
80106505:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010650a:	e9 fb f0 ff ff       	jmp    8010560a <alltraps>

8010650f <vector238>:
.globl vector238
vector238:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $238
80106511:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106516:	e9 ef f0 ff ff       	jmp    8010560a <alltraps>

8010651b <vector239>:
.globl vector239
vector239:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $239
8010651d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106522:	e9 e3 f0 ff ff       	jmp    8010560a <alltraps>

80106527 <vector240>:
.globl vector240
vector240:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $240
80106529:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010652e:	e9 d7 f0 ff ff       	jmp    8010560a <alltraps>

80106533 <vector241>:
.globl vector241
vector241:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $241
80106535:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010653a:	e9 cb f0 ff ff       	jmp    8010560a <alltraps>

8010653f <vector242>:
.globl vector242
vector242:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $242
80106541:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106546:	e9 bf f0 ff ff       	jmp    8010560a <alltraps>

8010654b <vector243>:
.globl vector243
vector243:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $243
8010654d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106552:	e9 b3 f0 ff ff       	jmp    8010560a <alltraps>

80106557 <vector244>:
.globl vector244
vector244:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $244
80106559:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010655e:	e9 a7 f0 ff ff       	jmp    8010560a <alltraps>

80106563 <vector245>:
.globl vector245
vector245:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $245
80106565:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010656a:	e9 9b f0 ff ff       	jmp    8010560a <alltraps>

8010656f <vector246>:
.globl vector246
vector246:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $246
80106571:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106576:	e9 8f f0 ff ff       	jmp    8010560a <alltraps>

8010657b <vector247>:
.globl vector247
vector247:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $247
8010657d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106582:	e9 83 f0 ff ff       	jmp    8010560a <alltraps>

80106587 <vector248>:
.globl vector248
vector248:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $248
80106589:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010658e:	e9 77 f0 ff ff       	jmp    8010560a <alltraps>

80106593 <vector249>:
.globl vector249
vector249:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $249
80106595:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010659a:	e9 6b f0 ff ff       	jmp    8010560a <alltraps>

8010659f <vector250>:
.globl vector250
vector250:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $250
801065a1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801065a6:	e9 5f f0 ff ff       	jmp    8010560a <alltraps>

801065ab <vector251>:
.globl vector251
vector251:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $251
801065ad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801065b2:	e9 53 f0 ff ff       	jmp    8010560a <alltraps>

801065b7 <vector252>:
.globl vector252
vector252:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $252
801065b9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801065be:	e9 47 f0 ff ff       	jmp    8010560a <alltraps>

801065c3 <vector253>:
.globl vector253
vector253:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $253
801065c5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801065ca:	e9 3b f0 ff ff       	jmp    8010560a <alltraps>

801065cf <vector254>:
.globl vector254
vector254:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $254
801065d1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801065d6:	e9 2f f0 ff ff       	jmp    8010560a <alltraps>

801065db <vector255>:
.globl vector255
vector255:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $255
801065dd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801065e2:	e9 23 f0 ff ff       	jmp    8010560a <alltraps>
801065e7:	66 90                	xchg   %ax,%ax
801065e9:	66 90                	xchg   %ax,%ax
801065eb:	66 90                	xchg   %ax,%ax
801065ed:	66 90                	xchg   %ax,%ax
801065ef:	90                   	nop

801065f0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801065f0:	55                   	push   %ebp
801065f1:	89 e5                	mov    %esp,%ebp
801065f3:	57                   	push   %edi
801065f4:	56                   	push   %esi
801065f5:	53                   	push   %ebx
801065f6:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801065f8:	c1 ea 16             	shr    $0x16,%edx
801065fb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801065fe:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106601:	8b 07                	mov    (%edi),%eax
80106603:	a8 01                	test   $0x1,%al
80106605:	74 29                	je     80106630 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106607:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010660c:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106612:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106615:	c1 eb 0a             	shr    $0xa,%ebx
80106618:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
8010661e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106621:	5b                   	pop    %ebx
80106622:	5e                   	pop    %esi
80106623:	5f                   	pop    %edi
80106624:	5d                   	pop    %ebp
80106625:	c3                   	ret    
80106626:	8d 76 00             	lea    0x0(%esi),%esi
80106629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106630:	85 c9                	test   %ecx,%ecx
80106632:	74 2c                	je     80106660 <walkpgdir+0x70>
80106634:	e8 27 be ff ff       	call   80102460 <kalloc>
80106639:	85 c0                	test   %eax,%eax
8010663b:	89 c6                	mov    %eax,%esi
8010663d:	74 21                	je     80106660 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010663f:	83 ec 04             	sub    $0x4,%esp
80106642:	68 00 10 00 00       	push   $0x1000
80106647:	6a 00                	push   $0x0
80106649:	50                   	push   %eax
8010664a:	e8 91 dd ff ff       	call   801043e0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010664f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106655:	83 c4 10             	add    $0x10,%esp
80106658:	83 c8 07             	or     $0x7,%eax
8010665b:	89 07                	mov    %eax,(%edi)
8010665d:	eb b3                	jmp    80106612 <walkpgdir+0x22>
8010665f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106660:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106663:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106665:	5b                   	pop    %ebx
80106666:	5e                   	pop    %esi
80106667:	5f                   	pop    %edi
80106668:	5d                   	pop    %ebp
80106669:	c3                   	ret    
8010666a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106670 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106670:	55                   	push   %ebp
80106671:	89 e5                	mov    %esp,%ebp
80106673:	57                   	push   %edi
80106674:	56                   	push   %esi
80106675:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106676:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010667c:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010667e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106684:	83 ec 1c             	sub    $0x1c,%esp
80106687:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010668a:	39 d3                	cmp    %edx,%ebx
8010668c:	73 66                	jae    801066f4 <deallocuvm.part.0+0x84>
8010668e:	89 d6                	mov    %edx,%esi
80106690:	eb 3d                	jmp    801066cf <deallocuvm.part.0+0x5f>
80106692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106698:	8b 10                	mov    (%eax),%edx
8010669a:	f6 c2 01             	test   $0x1,%dl
8010669d:	74 26                	je     801066c5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010669f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801066a5:	74 58                	je     801066ff <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801066a7:	83 ec 0c             	sub    $0xc,%esp
801066aa:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801066b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801066b3:	52                   	push   %edx
801066b4:	e8 f7 bb ff ff       	call   801022b0 <kfree>
      *pte = 0;
801066b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801066bc:	83 c4 10             	add    $0x10,%esp
801066bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801066c5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801066cb:	39 f3                	cmp    %esi,%ebx
801066cd:	73 25                	jae    801066f4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
801066cf:	31 c9                	xor    %ecx,%ecx
801066d1:	89 da                	mov    %ebx,%edx
801066d3:	89 f8                	mov    %edi,%eax
801066d5:	e8 16 ff ff ff       	call   801065f0 <walkpgdir>
    if(!pte)
801066da:	85 c0                	test   %eax,%eax
801066dc:	75 ba                	jne    80106698 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801066de:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801066e4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801066ea:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801066f0:	39 f3                	cmp    %esi,%ebx
801066f2:	72 db                	jb     801066cf <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801066f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801066f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066fa:	5b                   	pop    %ebx
801066fb:	5e                   	pop    %esi
801066fc:	5f                   	pop    %edi
801066fd:	5d                   	pop    %ebp
801066fe:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
801066ff:	83 ec 0c             	sub    $0xc,%esp
80106702:	68 26 73 10 80       	push   $0x80107326
80106707:	e8 64 9c ff ff       	call   80100370 <panic>
8010670c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106710 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106710:	55                   	push   %ebp
80106711:	89 e5                	mov    %esp,%ebp
80106713:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106716:	e8 15 d0 ff ff       	call   80103730 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010671b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106721:	31 c9                	xor    %ecx,%ecx
80106723:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106728:	66 89 90 f8 27 11 80 	mov    %dx,-0x7feed808(%eax)
8010672f:	66 89 88 fa 27 11 80 	mov    %cx,-0x7feed806(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106736:	ba ff ff ff ff       	mov    $0xffffffff,%edx
8010673b:	31 c9                	xor    %ecx,%ecx
8010673d:	66 89 90 00 28 11 80 	mov    %dx,-0x7feed800(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106744:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106749:	66 89 88 02 28 11 80 	mov    %cx,-0x7feed7fe(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106750:	31 c9                	xor    %ecx,%ecx
80106752:	66 89 90 08 28 11 80 	mov    %dx,-0x7feed7f8(%eax)
80106759:	66 89 88 0a 28 11 80 	mov    %cx,-0x7feed7f6(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106760:	ba ff ff ff ff       	mov    $0xffffffff,%edx
80106765:	31 c9                	xor    %ecx,%ecx
80106767:	66 89 90 10 28 11 80 	mov    %dx,-0x7feed7f0(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010676e:	c6 80 fc 27 11 80 00 	movb   $0x0,-0x7feed804(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106775:	ba 2f 00 00 00       	mov    $0x2f,%edx
8010677a:	c6 80 fd 27 11 80 9a 	movb   $0x9a,-0x7feed803(%eax)
80106781:	c6 80 fe 27 11 80 cf 	movb   $0xcf,-0x7feed802(%eax)
80106788:	c6 80 ff 27 11 80 00 	movb   $0x0,-0x7feed801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010678f:	c6 80 04 28 11 80 00 	movb   $0x0,-0x7feed7fc(%eax)
80106796:	c6 80 05 28 11 80 92 	movb   $0x92,-0x7feed7fb(%eax)
8010679d:	c6 80 06 28 11 80 cf 	movb   $0xcf,-0x7feed7fa(%eax)
801067a4:	c6 80 07 28 11 80 00 	movb   $0x0,-0x7feed7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801067ab:	c6 80 0c 28 11 80 00 	movb   $0x0,-0x7feed7f4(%eax)
801067b2:	c6 80 0d 28 11 80 fa 	movb   $0xfa,-0x7feed7f3(%eax)
801067b9:	c6 80 0e 28 11 80 cf 	movb   $0xcf,-0x7feed7f2(%eax)
801067c0:	c6 80 0f 28 11 80 00 	movb   $0x0,-0x7feed7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801067c7:	66 89 88 12 28 11 80 	mov    %cx,-0x7feed7ee(%eax)
801067ce:	c6 80 14 28 11 80 00 	movb   $0x0,-0x7feed7ec(%eax)
801067d5:	c6 80 15 28 11 80 f2 	movb   $0xf2,-0x7feed7eb(%eax)
801067dc:	c6 80 16 28 11 80 cf 	movb   $0xcf,-0x7feed7ea(%eax)
801067e3:	c6 80 17 28 11 80 00 	movb   $0x0,-0x7feed7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
801067ea:	05 f0 27 11 80       	add    $0x801127f0,%eax
801067ef:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
801067f3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801067f7:	c1 e8 10             	shr    $0x10,%eax
801067fa:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
801067fe:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106801:	0f 01 10             	lgdtl  (%eax)
}
80106804:	c9                   	leave  
80106805:	c3                   	ret    
80106806:	8d 76 00             	lea    0x0(%esi),%esi
80106809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106810 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106810:	55                   	push   %ebp
80106811:	89 e5                	mov    %esp,%ebp
80106813:	57                   	push   %edi
80106814:	56                   	push   %esi
80106815:	53                   	push   %ebx
80106816:	83 ec 1c             	sub    $0x1c,%esp
80106819:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010681c:	8b 55 10             	mov    0x10(%ebp),%edx
8010681f:	8b 7d 14             	mov    0x14(%ebp),%edi
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106822:	89 c3                	mov    %eax,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106824:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106828:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010682e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106833:	29 df                	sub    %ebx,%edi
80106835:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106838:	8b 45 18             	mov    0x18(%ebp),%eax
8010683b:	83 c8 01             	or     $0x1,%eax
8010683e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106841:	eb 1a                	jmp    8010685d <mappages+0x4d>
80106843:	90                   	nop
80106844:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106848:	f6 00 01             	testb  $0x1,(%eax)
8010684b:	75 3d                	jne    8010688a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
8010684d:	0b 75 e0             	or     -0x20(%ebp),%esi
    if(a == last)
80106850:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106853:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106855:	74 29                	je     80106880 <mappages+0x70>
      break;
    a += PGSIZE;
80106857:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010685d:	8b 45 08             	mov    0x8(%ebp),%eax
80106860:	b9 01 00 00 00       	mov    $0x1,%ecx
80106865:	89 da                	mov    %ebx,%edx
80106867:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
8010686a:	e8 81 fd ff ff       	call   801065f0 <walkpgdir>
8010686f:	85 c0                	test   %eax,%eax
80106871:	75 d5                	jne    80106848 <mappages+0x38>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106873:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
80106876:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010687b:	5b                   	pop    %ebx
8010687c:	5e                   	pop    %esi
8010687d:	5f                   	pop    %edi
8010687e:	5d                   	pop    %ebp
8010687f:	c3                   	ret    
80106880:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80106883:	31 c0                	xor    %eax,%eax
}
80106885:	5b                   	pop    %ebx
80106886:	5e                   	pop    %esi
80106887:	5f                   	pop    %edi
80106888:	5d                   	pop    %ebp
80106889:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
8010688a:	83 ec 0c             	sub    $0xc,%esp
8010688d:	68 c0 79 10 80       	push   $0x801079c0
80106892:	e8 d9 9a ff ff       	call   80100370 <panic>
80106897:	89 f6                	mov    %esi,%esi
80106899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068a0 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801068a0:	a1 a4 55 11 80       	mov    0x801155a4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801068a5:	55                   	push   %ebp
801068a6:	89 e5                	mov    %esp,%ebp
801068a8:	05 00 00 00 80       	add    $0x80000000,%eax
801068ad:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
801068b0:	5d                   	pop    %ebp
801068b1:	c3                   	ret    
801068b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068c0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801068c0:	55                   	push   %ebp
801068c1:	89 e5                	mov    %esp,%ebp
801068c3:	57                   	push   %edi
801068c4:	56                   	push   %esi
801068c5:	53                   	push   %ebx
801068c6:	83 ec 1c             	sub    $0x1c,%esp
801068c9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801068cc:	85 f6                	test   %esi,%esi
801068ce:	0f 84 cd 00 00 00    	je     801069a1 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801068d4:	8b 46 08             	mov    0x8(%esi),%eax
801068d7:	85 c0                	test   %eax,%eax
801068d9:	0f 84 dc 00 00 00    	je     801069bb <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801068df:	8b 7e 04             	mov    0x4(%esi),%edi
801068e2:	85 ff                	test   %edi,%edi
801068e4:	0f 84 c4 00 00 00    	je     801069ae <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
801068ea:	e8 41 d9 ff ff       	call   80104230 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801068ef:	e8 bc cd ff ff       	call   801036b0 <mycpu>
801068f4:	89 c3                	mov    %eax,%ebx
801068f6:	e8 b5 cd ff ff       	call   801036b0 <mycpu>
801068fb:	89 c7                	mov    %eax,%edi
801068fd:	e8 ae cd ff ff       	call   801036b0 <mycpu>
80106902:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106905:	83 c7 08             	add    $0x8,%edi
80106908:	e8 a3 cd ff ff       	call   801036b0 <mycpu>
8010690d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106910:	83 c0 08             	add    $0x8,%eax
80106913:	ba 67 00 00 00       	mov    $0x67,%edx
80106918:	c1 e8 18             	shr    $0x18,%eax
8010691b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106922:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106929:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106930:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106937:	83 c1 08             	add    $0x8,%ecx
8010693a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106940:	c1 e9 10             	shr    $0x10,%ecx
80106943:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106949:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010694e:	e8 5d cd ff ff       	call   801036b0 <mycpu>
80106953:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010695a:	e8 51 cd ff ff       	call   801036b0 <mycpu>
8010695f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106964:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106968:	e8 43 cd ff ff       	call   801036b0 <mycpu>
8010696d:	8b 56 08             	mov    0x8(%esi),%edx
80106970:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106976:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106979:	e8 32 cd ff ff       	call   801036b0 <mycpu>
8010697e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106982:	b8 28 00 00 00       	mov    $0x28,%eax
80106987:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010698a:	8b 46 04             	mov    0x4(%esi),%eax
8010698d:	05 00 00 00 80       	add    $0x80000000,%eax
80106992:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80106995:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106998:	5b                   	pop    %ebx
80106999:	5e                   	pop    %esi
8010699a:	5f                   	pop    %edi
8010699b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
8010699c:	e9 7f d9 ff ff       	jmp    80104320 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
801069a1:	83 ec 0c             	sub    $0xc,%esp
801069a4:	68 c6 79 10 80       	push   $0x801079c6
801069a9:	e8 c2 99 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
801069ae:	83 ec 0c             	sub    $0xc,%esp
801069b1:	68 f1 79 10 80       	push   $0x801079f1
801069b6:	e8 b5 99 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
801069bb:	83 ec 0c             	sub    $0xc,%esp
801069be:	68 dc 79 10 80       	push   $0x801079dc
801069c3:	e8 a8 99 ff ff       	call   80100370 <panic>
801069c8:	90                   	nop
801069c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801069d0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801069d0:	55                   	push   %ebp
801069d1:	89 e5                	mov    %esp,%ebp
801069d3:	57                   	push   %edi
801069d4:	56                   	push   %esi
801069d5:	53                   	push   %ebx
801069d6:	83 ec 1c             	sub    $0x1c,%esp
801069d9:	8b 75 10             	mov    0x10(%ebp),%esi
801069dc:	8b 55 08             	mov    0x8(%ebp),%edx
801069df:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
801069e2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801069e8:	77 50                	ja     80106a3a <inituvm+0x6a>
801069ea:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    panic("inituvm: more than a page");
  mem = kalloc();
801069ed:	e8 6e ba ff ff       	call   80102460 <kalloc>
  memset(mem, 0, PGSIZE);
801069f2:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
801069f5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801069f7:	68 00 10 00 00       	push   $0x1000
801069fc:	6a 00                	push   $0x0
801069fe:	50                   	push   %eax
801069ff:	e8 dc d9 ff ff       	call   801043e0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106a04:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106a07:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106a0d:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106a14:	50                   	push   %eax
80106a15:	68 00 10 00 00       	push   $0x1000
80106a1a:	6a 00                	push   $0x0
80106a1c:	52                   	push   %edx
80106a1d:	e8 ee fd ff ff       	call   80106810 <mappages>
  memmove(mem, init, sz);
80106a22:	89 75 10             	mov    %esi,0x10(%ebp)
80106a25:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106a28:	83 c4 20             	add    $0x20,%esp
80106a2b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106a2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a31:	5b                   	pop    %ebx
80106a32:	5e                   	pop    %esi
80106a33:	5f                   	pop    %edi
80106a34:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106a35:	e9 56 da ff ff       	jmp    80104490 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106a3a:	83 ec 0c             	sub    $0xc,%esp
80106a3d:	68 05 7a 10 80       	push   $0x80107a05
80106a42:	e8 29 99 ff ff       	call   80100370 <panic>
80106a47:	89 f6                	mov    %esi,%esi
80106a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106a50 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	57                   	push   %edi
80106a54:	56                   	push   %esi
80106a55:	53                   	push   %ebx
80106a56:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106a59:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106a60:	0f 85 91 00 00 00    	jne    80106af7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106a66:	8b 75 18             	mov    0x18(%ebp),%esi
80106a69:	31 db                	xor    %ebx,%ebx
80106a6b:	85 f6                	test   %esi,%esi
80106a6d:	75 1a                	jne    80106a89 <loaduvm+0x39>
80106a6f:	eb 6f                	jmp    80106ae0 <loaduvm+0x90>
80106a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a78:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a7e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106a84:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106a87:	76 57                	jbe    80106ae0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106a89:	8b 55 0c             	mov    0xc(%ebp),%edx
80106a8c:	8b 45 08             	mov    0x8(%ebp),%eax
80106a8f:	31 c9                	xor    %ecx,%ecx
80106a91:	01 da                	add    %ebx,%edx
80106a93:	e8 58 fb ff ff       	call   801065f0 <walkpgdir>
80106a98:	85 c0                	test   %eax,%eax
80106a9a:	74 4e                	je     80106aea <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106a9c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106a9e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80106aa1:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106aa6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106aab:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106ab1:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ab4:	01 d9                	add    %ebx,%ecx
80106ab6:	05 00 00 00 80       	add    $0x80000000,%eax
80106abb:	57                   	push   %edi
80106abc:	51                   	push   %ecx
80106abd:	50                   	push   %eax
80106abe:	ff 75 10             	pushl  0x10(%ebp)
80106ac1:	e8 5a ae ff ff       	call   80101920 <readi>
80106ac6:	83 c4 10             	add    $0x10,%esp
80106ac9:	39 c7                	cmp    %eax,%edi
80106acb:	74 ab                	je     80106a78 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106acd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106ad0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106ad5:	5b                   	pop    %ebx
80106ad6:	5e                   	pop    %esi
80106ad7:	5f                   	pop    %edi
80106ad8:	5d                   	pop    %ebp
80106ad9:	c3                   	ret    
80106ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ae0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106ae3:	31 c0                	xor    %eax,%eax
}
80106ae5:	5b                   	pop    %ebx
80106ae6:	5e                   	pop    %esi
80106ae7:	5f                   	pop    %edi
80106ae8:	5d                   	pop    %ebp
80106ae9:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106aea:	83 ec 0c             	sub    $0xc,%esp
80106aed:	68 1f 7a 10 80       	push   $0x80107a1f
80106af2:	e8 79 98 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106af7:	83 ec 0c             	sub    $0xc,%esp
80106afa:	68 f8 7a 10 80       	push   $0x80107af8
80106aff:	e8 6c 98 ff ff       	call   80100370 <panic>
80106b04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106b10 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106b10:	55                   	push   %ebp
80106b11:	89 e5                	mov    %esp,%ebp
80106b13:	57                   	push   %edi
80106b14:	56                   	push   %esi
80106b15:	53                   	push   %ebx
80106b16:	83 ec 0c             	sub    $0xc,%esp
80106b19:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106b1c:	85 ff                	test   %edi,%edi
80106b1e:	0f 88 ca 00 00 00    	js     80106bee <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80106b24:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106b27:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106b2a:	0f 82 84 00 00 00    	jb     80106bb4 <allocuvm+0xa4>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106b30:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106b36:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106b3c:	39 df                	cmp    %ebx,%edi
80106b3e:	77 45                	ja     80106b85 <allocuvm+0x75>
80106b40:	e9 bb 00 00 00       	jmp    80106c00 <allocuvm+0xf0>
80106b45:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106b48:	83 ec 04             	sub    $0x4,%esp
80106b4b:	68 00 10 00 00       	push   $0x1000
80106b50:	6a 00                	push   $0x0
80106b52:	50                   	push   %eax
80106b53:	e8 88 d8 ff ff       	call   801043e0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106b58:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106b5e:	c7 04 24 06 00 00 00 	movl   $0x6,(%esp)
80106b65:	50                   	push   %eax
80106b66:	68 00 10 00 00       	push   $0x1000
80106b6b:	53                   	push   %ebx
80106b6c:	ff 75 08             	pushl  0x8(%ebp)
80106b6f:	e8 9c fc ff ff       	call   80106810 <mappages>
80106b74:	83 c4 20             	add    $0x20,%esp
80106b77:	85 c0                	test   %eax,%eax
80106b79:	78 45                	js     80106bc0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106b7b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b81:	39 df                	cmp    %ebx,%edi
80106b83:	76 7b                	jbe    80106c00 <allocuvm+0xf0>
    mem = kalloc();
80106b85:	e8 d6 b8 ff ff       	call   80102460 <kalloc>
    if(mem == 0){
80106b8a:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106b8c:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106b8e:	75 b8                	jne    80106b48 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106b90:	83 ec 0c             	sub    $0xc,%esp
80106b93:	68 3d 7a 10 80       	push   $0x80107a3d
80106b98:	e8 c3 9a ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106b9d:	83 c4 10             	add    $0x10,%esp
80106ba0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106ba3:	76 49                	jbe    80106bee <allocuvm+0xde>
80106ba5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106ba8:	8b 45 08             	mov    0x8(%ebp),%eax
80106bab:	89 fa                	mov    %edi,%edx
80106bad:	e8 be fa ff ff       	call   80106670 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106bb2:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106bb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bb7:	5b                   	pop    %ebx
80106bb8:	5e                   	pop    %esi
80106bb9:	5f                   	pop    %edi
80106bba:	5d                   	pop    %ebp
80106bbb:	c3                   	ret    
80106bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106bc0:	83 ec 0c             	sub    $0xc,%esp
80106bc3:	68 55 7a 10 80       	push   $0x80107a55
80106bc8:	e8 93 9a ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106bcd:	83 c4 10             	add    $0x10,%esp
80106bd0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106bd3:	76 0d                	jbe    80106be2 <allocuvm+0xd2>
80106bd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106bd8:	8b 45 08             	mov    0x8(%ebp),%eax
80106bdb:	89 fa                	mov    %edi,%edx
80106bdd:	e8 8e fa ff ff       	call   80106670 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106be2:	83 ec 0c             	sub    $0xc,%esp
80106be5:	56                   	push   %esi
80106be6:	e8 c5 b6 ff ff       	call   801022b0 <kfree>
      return 0;
80106beb:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
80106bee:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106bf1:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106bf3:	5b                   	pop    %ebx
80106bf4:	5e                   	pop    %esi
80106bf5:	5f                   	pop    %edi
80106bf6:	5d                   	pop    %ebp
80106bf7:	c3                   	ret    
80106bf8:	90                   	nop
80106bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106c03:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106c05:	5b                   	pop    %ebx
80106c06:	5e                   	pop    %esi
80106c07:	5f                   	pop    %edi
80106c08:	5d                   	pop    %ebp
80106c09:	c3                   	ret    
80106c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c10 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106c10:	55                   	push   %ebp
80106c11:	89 e5                	mov    %esp,%ebp
80106c13:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c16:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106c19:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106c1c:	39 d1                	cmp    %edx,%ecx
80106c1e:	73 10                	jae    80106c30 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106c20:	5d                   	pop    %ebp
80106c21:	e9 4a fa ff ff       	jmp    80106670 <deallocuvm.part.0>
80106c26:	8d 76 00             	lea    0x0(%esi),%esi
80106c29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106c30:	89 d0                	mov    %edx,%eax
80106c32:	5d                   	pop    %ebp
80106c33:	c3                   	ret    
80106c34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106c3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c40 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106c40:	55                   	push   %ebp
80106c41:	89 e5                	mov    %esp,%ebp
80106c43:	57                   	push   %edi
80106c44:	56                   	push   %esi
80106c45:	53                   	push   %ebx
80106c46:	83 ec 0c             	sub    $0xc,%esp
80106c49:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106c4c:	85 f6                	test   %esi,%esi
80106c4e:	74 59                	je     80106ca9 <freevm+0x69>
80106c50:	31 c9                	xor    %ecx,%ecx
80106c52:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106c57:	89 f0                	mov    %esi,%eax
80106c59:	e8 12 fa ff ff       	call   80106670 <deallocuvm.part.0>
80106c5e:	89 f3                	mov    %esi,%ebx
80106c60:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106c66:	eb 0f                	jmp    80106c77 <freevm+0x37>
80106c68:	90                   	nop
80106c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c70:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106c73:	39 fb                	cmp    %edi,%ebx
80106c75:	74 23                	je     80106c9a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106c77:	8b 03                	mov    (%ebx),%eax
80106c79:	a8 01                	test   $0x1,%al
80106c7b:	74 f3                	je     80106c70 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106c7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c82:	83 ec 0c             	sub    $0xc,%esp
80106c85:	83 c3 04             	add    $0x4,%ebx
80106c88:	05 00 00 00 80       	add    $0x80000000,%eax
80106c8d:	50                   	push   %eax
80106c8e:	e8 1d b6 ff ff       	call   801022b0 <kfree>
80106c93:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106c96:	39 fb                	cmp    %edi,%ebx
80106c98:	75 dd                	jne    80106c77 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106c9a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106c9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ca0:	5b                   	pop    %ebx
80106ca1:	5e                   	pop    %esi
80106ca2:	5f                   	pop    %edi
80106ca3:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106ca4:	e9 07 b6 ff ff       	jmp    801022b0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106ca9:	83 ec 0c             	sub    $0xc,%esp
80106cac:	68 71 7a 10 80       	push   $0x80107a71
80106cb1:	e8 ba 96 ff ff       	call   80100370 <panic>
80106cb6:	8d 76 00             	lea    0x0(%esi),%esi
80106cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cc0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106cc0:	55                   	push   %ebp
80106cc1:	89 e5                	mov    %esp,%ebp
80106cc3:	56                   	push   %esi
80106cc4:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106cc5:	e8 96 b7 ff ff       	call   80102460 <kalloc>
80106cca:	85 c0                	test   %eax,%eax
80106ccc:	74 6a                	je     80106d38 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106cce:	83 ec 04             	sub    $0x4,%esp
80106cd1:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106cd3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106cd8:	68 00 10 00 00       	push   $0x1000
80106cdd:	6a 00                	push   $0x0
80106cdf:	50                   	push   %eax
80106ce0:	e8 fb d6 ff ff       	call   801043e0 <memset>
80106ce5:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106ce8:	8b 43 04             	mov    0x4(%ebx),%eax
80106ceb:	8b 53 08             	mov    0x8(%ebx),%edx
80106cee:	83 ec 0c             	sub    $0xc,%esp
80106cf1:	ff 73 0c             	pushl  0xc(%ebx)
80106cf4:	29 c2                	sub    %eax,%edx
80106cf6:	50                   	push   %eax
80106cf7:	52                   	push   %edx
80106cf8:	ff 33                	pushl  (%ebx)
80106cfa:	56                   	push   %esi
80106cfb:	e8 10 fb ff ff       	call   80106810 <mappages>
80106d00:	83 c4 20             	add    $0x20,%esp
80106d03:	85 c0                	test   %eax,%eax
80106d05:	78 19                	js     80106d20 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d07:	83 c3 10             	add    $0x10,%ebx
80106d0a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106d10:	75 d6                	jne    80106ce8 <setupkvm+0x28>
80106d12:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106d14:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106d17:	5b                   	pop    %ebx
80106d18:	5e                   	pop    %esi
80106d19:	5d                   	pop    %ebp
80106d1a:	c3                   	ret    
80106d1b:	90                   	nop
80106d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106d20:	83 ec 0c             	sub    $0xc,%esp
80106d23:	56                   	push   %esi
80106d24:	e8 17 ff ff ff       	call   80106c40 <freevm>
      return 0;
80106d29:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
80106d2c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80106d2f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80106d31:	5b                   	pop    %ebx
80106d32:	5e                   	pop    %esi
80106d33:	5d                   	pop    %ebp
80106d34:	c3                   	ret    
80106d35:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106d38:	31 c0                	xor    %eax,%eax
80106d3a:	eb d8                	jmp    80106d14 <setupkvm+0x54>
80106d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d40 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106d46:	e8 75 ff ff ff       	call   80106cc0 <setupkvm>
80106d4b:	a3 a4 55 11 80       	mov    %eax,0x801155a4
80106d50:	05 00 00 00 80       	add    $0x80000000,%eax
80106d55:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80106d58:	c9                   	leave  
80106d59:	c3                   	ret    
80106d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d60 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106d60:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106d61:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106d63:	89 e5                	mov    %esp,%ebp
80106d65:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106d68:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d6b:	8b 45 08             	mov    0x8(%ebp),%eax
80106d6e:	e8 7d f8 ff ff       	call   801065f0 <walkpgdir>
  if(pte == 0)
80106d73:	85 c0                	test   %eax,%eax
80106d75:	74 05                	je     80106d7c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106d77:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106d7a:	c9                   	leave  
80106d7b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106d7c:	83 ec 0c             	sub    $0xc,%esp
80106d7f:	68 82 7a 10 80       	push   $0x80107a82
80106d84:	e8 e7 95 ff ff       	call   80100370 <panic>
80106d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106d90 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz, uint stack_sz)//cs153 add stack size parameter
{
80106d90:	55                   	push   %ebp
80106d91:	89 e5                	mov    %esp,%ebp
80106d93:	57                   	push   %edi
80106d94:	56                   	push   %esi
80106d95:	53                   	push   %ebx
80106d96:	83 ec 1c             	sub    $0x1c,%esp
  pte_t *pte;
  uint pa, i, flags;
  char *mem;
  //struct proc *curproc = myproc();

  if((d = setupkvm()) == 0)
80106d99:	e8 22 ff ff ff       	call   80106cc0 <setupkvm>
80106d9e:	85 c0                	test   %eax,%eax
80106da0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106da3:	0f 84 5d 01 00 00    	je     80106f06 <copyuvm+0x176>
    return 0;

  for(i = 0; i < sz; i += PGSIZE){
80106da9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106dac:	85 c9                	test   %ecx,%ecx
80106dae:	0f 84 a4 00 00 00    	je     80106e58 <copyuvm+0xc8>
80106db4:	31 f6                	xor    %esi,%esi
80106db6:	eb 48                	jmp    80106e00 <copyuvm+0x70>
80106db8:	90                   	nop
80106db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present1");
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
80106dd0:	e8 bb d6 ff ff       	call   80104490 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106dd5:	5a                   	pop    %edx
80106dd6:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
80106ddc:	ff 75 e4             	pushl  -0x1c(%ebp)
80106ddf:	52                   	push   %edx
80106de0:	68 00 10 00 00       	push   $0x1000
80106de5:	56                   	push   %esi
80106de6:	ff 75 e0             	pushl  -0x20(%ebp)
80106de9:	e8 22 fa ff ff       	call   80106810 <mappages>
80106dee:	83 c4 20             	add    $0x20,%esp
80106df1:	85 c0                	test   %eax,%eax
80106df3:	78 46                	js     80106e3b <copyuvm+0xab>
  //struct proc *curproc = myproc();

  if((d = setupkvm()) == 0)
    return 0;

  for(i = 0; i < sz; i += PGSIZE){
80106df5:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106dfb:	39 75 0c             	cmp    %esi,0xc(%ebp)
80106dfe:	76 58                	jbe    80106e58 <copyuvm+0xc8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106e00:	8b 45 08             	mov    0x8(%ebp),%eax
80106e03:	31 c9                	xor    %ecx,%ecx
80106e05:	89 f2                	mov    %esi,%edx
80106e07:	e8 e4 f7 ff ff       	call   801065f0 <walkpgdir>
80106e0c:	85 c0                	test   %eax,%eax
80106e0e:	0f 84 06 01 00 00    	je     80106f1a <copyuvm+0x18a>
      panic("copyuvm: pte should exist1");
    if(!(*pte & PTE_P))
80106e14:	8b 18                	mov    (%eax),%ebx
80106e16:	f6 c3 01             	test   $0x1,%bl
80106e19:	0f 84 ee 00 00 00    	je     80106f0d <copyuvm+0x17d>
      panic("copyuvm: page not present1");
    pa = PTE_ADDR(*pte);
80106e1f:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80106e21:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80106e27:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist1");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present1");
    pa = PTE_ADDR(*pte);
80106e2a:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
   if((mem = kalloc()) == 0)
80106e30:	e8 2b b6 ff ff       	call   80102460 <kalloc>
80106e35:	85 c0                	test   %eax,%eax
80106e37:	89 c3                	mov    %eax,%ebx
80106e39:	75 85                	jne    80106dc0 <copyuvm+0x30>
      goto bad; 
  }
  return d;

bad:
  freevm(d);
80106e3b:	83 ec 0c             	sub    $0xc,%esp
80106e3e:	ff 75 e0             	pushl  -0x20(%ebp)
80106e41:	e8 fa fd ff ff       	call   80106c40 <freevm>
  return 0;
80106e46:	83 c4 10             	add    $0x10,%esp
80106e49:	31 c0                	xor    %eax,%eax
}
80106e4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e4e:	5b                   	pop    %ebx
80106e4f:	5e                   	pop    %esi
80106e50:	5f                   	pop    %edi
80106e51:	5d                   	pop    %ebp
80106e52:	c3                   	ret    
80106e53:	90                   	nop
80106e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }

  //cs153 add other for loop to copy last page
  for(i=PGROUNDDOWN(myproc()->tf->esp);i<KERNBASE-4;i+=PGSIZE){
80106e58:	e8 f3 c8 ff ff       	call   80103750 <myproc>
80106e5d:	8b 40 18             	mov    0x18(%eax),%eax
80106e60:	8b 70 44             	mov    0x44(%eax),%esi
80106e63:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80106e69:	81 fe fb ff ff 7f    	cmp    $0x7ffffffb,%esi
80106e6f:	76 52                	jbe    80106ec3 <copyuvm+0x133>
80106e71:	e9 85 00 00 00       	jmp    80106efb <copyuvm+0x16b>
80106e76:	8d 76 00             	lea    0x0(%esi),%esi
80106e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      panic("copyuvm: page not present2");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106e80:	83 ec 04             	sub    $0x4,%esp
80106e83:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80106e89:	68 00 10 00 00       	push   $0x1000
80106e8e:	57                   	push   %edi
80106e8f:	50                   	push   %eax
80106e90:	e8 fb d5 ff ff       	call   80104490 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80106e95:	58                   	pop    %eax
80106e96:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
80106e9c:	ff 75 e4             	pushl  -0x1c(%ebp)
80106e9f:	52                   	push   %edx
80106ea0:	68 00 10 00 00       	push   $0x1000
80106ea5:	56                   	push   %esi
80106ea6:	ff 75 e0             	pushl  -0x20(%ebp)
80106ea9:	e8 62 f9 ff ff       	call   80106810 <mappages>
80106eae:	83 c4 20             	add    $0x20,%esp
80106eb1:	85 c0                	test   %eax,%eax
80106eb3:	78 86                	js     80106e3b <copyuvm+0xab>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }

  //cs153 add other for loop to copy last page
  for(i=PGROUNDDOWN(myproc()->tf->esp);i<KERNBASE-4;i+=PGSIZE){
80106eb5:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106ebb:	81 fe fb ff ff 7f    	cmp    $0x7ffffffb,%esi
80106ec1:	77 38                	ja     80106efb <copyuvm+0x16b>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106ec3:	8b 45 08             	mov    0x8(%ebp),%eax
80106ec6:	31 c9                	xor    %ecx,%ecx
80106ec8:	89 f2                	mov    %esi,%edx
80106eca:	e8 21 f7 ff ff       	call   801065f0 <walkpgdir>
80106ecf:	85 c0                	test   %eax,%eax
80106ed1:	74 54                	je     80106f27 <copyuvm+0x197>
      panic("copyuvm: pte should exist2");
    if(!(*pte & PTE_P))
80106ed3:	8b 18                	mov    (%eax),%ebx
80106ed5:	f6 c3 01             	test   $0x1,%bl
80106ed8:	74 5a                	je     80106f34 <copyuvm+0x1a4>
      panic("copyuvm: page not present2");
    pa = PTE_ADDR(*pte);
80106eda:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80106edc:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
80106ee2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  for(i=PGROUNDDOWN(myproc()->tf->esp);i<KERNBASE-4;i+=PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist2");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present2");
    pa = PTE_ADDR(*pte);
80106ee5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106eeb:	e8 70 b5 ff ff       	call   80102460 <kalloc>
80106ef0:	85 c0                	test   %eax,%eax
80106ef2:	89 c3                	mov    %eax,%ebx
80106ef4:	75 8a                	jne    80106e80 <copyuvm+0xf0>
80106ef6:	e9 40 ff ff ff       	jmp    80106e3b <copyuvm+0xab>
80106efb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80106efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f01:	5b                   	pop    %ebx
80106f02:	5e                   	pop    %esi
80106f03:	5f                   	pop    %edi
80106f04:	5d                   	pop    %ebp
80106f05:	c3                   	ret    
  uint pa, i, flags;
  char *mem;
  //struct proc *curproc = myproc();

  if((d = setupkvm()) == 0)
    return 0;
80106f06:	31 c0                	xor    %eax,%eax
80106f08:	e9 3e ff ff ff       	jmp    80106e4b <copyuvm+0xbb>

  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist1");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present1");
80106f0d:	83 ec 0c             	sub    $0xc,%esp
80106f10:	68 a7 7a 10 80       	push   $0x80107aa7
80106f15:	e8 56 94 ff ff       	call   80100370 <panic>
  if((d = setupkvm()) == 0)
    return 0;

  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist1");
80106f1a:	83 ec 0c             	sub    $0xc,%esp
80106f1d:	68 8c 7a 10 80       	push   $0x80107a8c
80106f22:	e8 49 94 ff ff       	call   80100370 <panic>
  }

  //cs153 add other for loop to copy last page
  for(i=PGROUNDDOWN(myproc()->tf->esp);i<KERNBASE-4;i+=PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist2");
80106f27:	83 ec 0c             	sub    $0xc,%esp
80106f2a:	68 c2 7a 10 80       	push   $0x80107ac2
80106f2f:	e8 3c 94 ff ff       	call   80100370 <panic>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present2");
80106f34:	83 ec 0c             	sub    $0xc,%esp
80106f37:	68 dd 7a 10 80       	push   $0x80107add
80106f3c:	e8 2f 94 ff ff       	call   80100370 <panic>
80106f41:	eb 0d                	jmp    80106f50 <uva2ka>
80106f43:	90                   	nop
80106f44:	90                   	nop
80106f45:	90                   	nop
80106f46:	90                   	nop
80106f47:	90                   	nop
80106f48:	90                   	nop
80106f49:	90                   	nop
80106f4a:	90                   	nop
80106f4b:	90                   	nop
80106f4c:	90                   	nop
80106f4d:	90                   	nop
80106f4e:	90                   	nop
80106f4f:	90                   	nop

80106f50 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106f50:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f51:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106f53:	89 e5                	mov    %esp,%ebp
80106f55:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f58:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f5b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f5e:	e8 8d f6 ff ff       	call   801065f0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106f63:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80106f65:	89 c2                	mov    %eax,%edx
80106f67:	83 e2 05             	and    $0x5,%edx
80106f6a:	83 fa 05             	cmp    $0x5,%edx
80106f6d:	75 11                	jne    80106f80 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106f6f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80106f74:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106f75:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106f7a:	c3                   	ret    
80106f7b:	90                   	nop
80106f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106f80:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106f82:	c9                   	leave  
80106f83:	c3                   	ret    
80106f84:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f8a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f90 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	57                   	push   %edi
80106f94:	56                   	push   %esi
80106f95:	53                   	push   %ebx
80106f96:	83 ec 1c             	sub    $0x1c,%esp
80106f99:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106f9c:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f9f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106fa2:	85 db                	test   %ebx,%ebx
80106fa4:	75 40                	jne    80106fe6 <copyout+0x56>
80106fa6:	eb 70                	jmp    80107018 <copyout+0x88>
80106fa8:	90                   	nop
80106fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106fb0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106fb3:	89 f1                	mov    %esi,%ecx
80106fb5:	29 d1                	sub    %edx,%ecx
80106fb7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80106fbd:	39 d9                	cmp    %ebx,%ecx
80106fbf:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106fc2:	29 f2                	sub    %esi,%edx
80106fc4:	83 ec 04             	sub    $0x4,%esp
80106fc7:	01 d0                	add    %edx,%eax
80106fc9:	51                   	push   %ecx
80106fca:	57                   	push   %edi
80106fcb:	50                   	push   %eax
80106fcc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106fcf:	e8 bc d4 ff ff       	call   80104490 <memmove>
    len -= n;
    buf += n;
80106fd4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106fd7:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
80106fda:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80106fe0:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106fe2:	29 cb                	sub    %ecx,%ebx
80106fe4:	74 32                	je     80107018 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80106fe6:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106fe8:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80106feb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106fee:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106ff4:	56                   	push   %esi
80106ff5:	ff 75 08             	pushl  0x8(%ebp)
80106ff8:	e8 53 ff ff ff       	call   80106f50 <uva2ka>
    if(pa0 == 0)
80106ffd:	83 c4 10             	add    $0x10,%esp
80107000:	85 c0                	test   %eax,%eax
80107002:	75 ac                	jne    80106fb0 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107004:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107007:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010700c:	5b                   	pop    %ebx
8010700d:	5e                   	pop    %esi
8010700e:	5f                   	pop    %edi
8010700f:	5d                   	pop    %ebp
80107010:	c3                   	ret    
80107011:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107018:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010701b:	31 c0                	xor    %eax,%eax
}
8010701d:	5b                   	pop    %ebx
8010701e:	5e                   	pop    %esi
8010701f:	5f                   	pop    %edi
80107020:	5d                   	pop    %ebp
80107021:	c3                   	ret    
80107022:	66 90                	xchg   %ax,%ax
80107024:	66 90                	xchg   %ax,%ax
80107026:	66 90                	xchg   %ax,%ax
80107028:	66 90                	xchg   %ax,%ax
8010702a:	66 90                	xchg   %ax,%ax
8010702c:	66 90                	xchg   %ax,%ax
8010702e:	66 90                	xchg   %ax,%ax

80107030 <shminit>:
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
80107030:	55                   	push   %ebp
80107031:	89 e5                	mov    %esp,%ebp
80107033:	83 ec 10             	sub    $0x10,%esp
  int i;
  initlock(&(shm_table.lock), "SHM lock");
80107036:	68 1c 7b 10 80       	push   $0x80107b1c
8010703b:	68 c0 55 11 80       	push   $0x801155c0
80107040:	e8 2b d1 ff ff       	call   80104170 <initlock>
  acquire(&(shm_table.lock));
80107045:	c7 04 24 c0 55 11 80 	movl   $0x801155c0,(%esp)
8010704c:	e8 1f d2 ff ff       	call   80104270 <acquire>
80107051:	b8 f4 55 11 80       	mov    $0x801155f4,%eax
80107056:	83 c4 10             	add    $0x10,%esp
80107059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id =0;
80107060:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    shm_table.shm_pages[i].frame =0;
80107066:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
8010706d:	83 c0 0c             	add    $0xc,%eax
    shm_table.shm_pages[i].refcnt =0;
80107070:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)

void shminit() {
  int i;
  initlock(&(shm_table.lock), "SHM lock");
  acquire(&(shm_table.lock));
  for (i = 0; i< 64; i++) {
80107077:	3d f4 58 11 80       	cmp    $0x801158f4,%eax
8010707c:	75 e2                	jne    80107060 <shminit+0x30>
    shm_table.shm_pages[i].id =0;
    shm_table.shm_pages[i].frame =0;
    shm_table.shm_pages[i].refcnt =0;
  }
  release(&(shm_table.lock));
8010707e:	83 ec 0c             	sub    $0xc,%esp
80107081:	68 c0 55 11 80       	push   $0x801155c0
80107086:	e8 05 d3 ff ff       	call   80104390 <release>
}
8010708b:	83 c4 10             	add    $0x10,%esp
8010708e:	c9                   	leave  
8010708f:	c3                   	ret    

80107090 <shm_open>:

int shm_open(int id, char **pointer) {
80107090:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80107091:	31 c0                	xor    %eax,%eax
    shm_table.shm_pages[i].refcnt =0;
  }
  release(&(shm_table.lock));
}

int shm_open(int id, char **pointer) {
80107093:	89 e5                	mov    %esp,%ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
80107095:	5d                   	pop    %ebp
80107096:	c3                   	ret    
80107097:	89 f6                	mov    %esi,%esi
80107099:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070a0 <shm_close>:


int shm_close(int id) {
801070a0:	55                   	push   %ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
801070a1:	31 c0                	xor    %eax,%eax

return 0; //added to remove compiler warning -- you should decide what to return
}


int shm_close(int id) {
801070a3:	89 e5                	mov    %esp,%ebp




return 0; //added to remove compiler warning -- you should decide what to return
}
801070a5:	5d                   	pop    %ebp
801070a6:	c3                   	ret    
