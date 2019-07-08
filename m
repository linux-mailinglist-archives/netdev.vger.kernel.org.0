Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9C106269C
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389945AbfGHQtJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:49:09 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:60566 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727947AbfGHQtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:49:08 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x68GXiNe119534;
        Mon, 8 Jul 2019 16:48:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=cEtJkchxm/CjuC6l1G66NpijImPVQgkeETLZuKZJEv8=;
 b=TP6ivQdEDPaBTCKTPnY4jtIQ7t+jdzPpUfUR9/h8jVU2k1B4HC/4a+NDLflTtSyR5pJO
 jMp9C39FkhUffmBePCWibW3lo8w0k0mYJ1js3D5aTPqIOAriC59+ynAe5nauqnsZjLta
 p8uWNgarIZaHxeheYLNHFiHJHMq2+w+iUFDy+QtJIAVhTV9fHs5B6NSl/DotaBxryHuM
 2FgLpFvICPVAwbxOtaqRuSrHBf18nA/b5v46y/FWWSErWEI2NnUXj1R5/UmLDitdijcg
 xHs8d1sGR/jsijyzQGE6Vt/mfVMXqsNTkcEi+yFrZ9NT8NB7HMewEzZYMijdgm7BME8e Pg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2tjk2tfkpf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jul 2019 16:48:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x68Gm8aK056663;
        Mon, 8 Jul 2019 16:48:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 2tjhpckdb1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 08 Jul 2019 16:48:14 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x68GmEqI057135;
        Mon, 8 Jul 2019 16:48:14 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2tjhpckdat-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jul 2019 16:48:14 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x68GmDMb022507;
        Mon, 8 Jul 2019 16:48:13 GMT
Received: from localhost (/10.159.211.102)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jul 2019 09:48:13 -0700
Date:   Mon, 8 Jul 2019 12:48:10 -0400
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Kris Van Hees <kris.van.hees@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, acme@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, Chris Mason <clm@fb.com>
Subject: Re: [PATCH 1/1] tools/dtrace: initial implementation of DTrace
Message-ID: <20190708164810.GC20847@oracle.com>
References: <201907040313.x643D8Pg025951@userv0121.oracle.com>
 <201907040314.x643EUoA017906@aserv0122.oracle.com>
 <20190704130336.GN3402@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704130336.GN3402@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9312 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907080206
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 04, 2019 at 03:03:36PM +0200, Peter Zijlstra wrote:
> On Wed, Jul 03, 2019 at 08:14:30PM -0700, Kris Van Hees wrote:
> > +/*
> > + * Read the data_head offset from the header page of the ring buffer.  The
> > + * argument is declared 'volatile' because it references a memory mapped page
> > + * that the kernel may be writing to while we access it here.
> > + */
> > +static u64 read_rb_head(volatile struct perf_event_mmap_page *rb_page)
> > +{
> > +	u64	head = rb_page->data_head;
> > +
> > +	asm volatile("" ::: "memory");
> > +
> > +	return head;
> > +}
> > +
> > +/*
> > + * Write the data_tail offset in the header page of the ring buffer.  The
> > + * argument is declared 'volatile' because it references a memory mapped page
> > + * that the kernel may be writing to while we access it here.
> 
> s/writing/reading/

Thanks!

> > + */
> > +static void write_rb_tail(volatile struct perf_event_mmap_page *rb_page,
> > +			  u64 tail)
> > +{
> > +	asm volatile("" ::: "memory");
> > +
> > +	rb_page->data_tail = tail;
> > +}
> 
> That volatile usage is atrocious (kernel style would have you use
> {READ,WRITE}_ONCE()). Also your comments fail to mark these as
> load_acquire and store_release. And by only using a compiler barrier
> you're hard assuming TSO, which is somewhat fragile at best.
> 
> Alternatively, you can use the C11 bits and write:
> 
> 	return __atomic_load_n(&rb_page->data_head, __ATOMIC_ACQUIRE);
> 
> 	__atomic_store_n(&rb_page->data_tail, tail, __ATOMIC_RELEASE);

Perhaps I should just use ring_buffer_read_head() and ring_buffer_write_tail()
since they are provided in tools/include/linux/ring_buffer.h?  I expect that
would be even more preferable over __atomic_load_n() and __atomic_store_n()?

> > +/*
> > + * Process and output the probe data at the supplied address.
> > + */
> > +static int output_event(int cpu, u64 *buf)
> > +{
> > +	u8				*data = (u8 *)buf;
> > +	struct perf_event_header	*hdr;
> > +
> > +	hdr = (struct perf_event_header *)data;
> > +	data += sizeof(struct perf_event_header);
> > +
> > +	if (hdr->type == PERF_RECORD_SAMPLE) {
> > +		u8		*ptr = data;
> > +		u32		i, size, probe_id;
> > +
> > +		/*
> > +		 * struct {
> > +		 *	struct perf_event_header	header;
> > +		 *	u32				size;
> > +		 *	u32				probe_id;
> > +		 *	u32				gap;
> > +		 *	u64				data[n];
> > +		 * }
> > +		 * and data points to the 'size' member at this point.
> > +		 */
> > +		if (ptr > (u8 *)buf + hdr->size) {
> > +			fprintf(stderr, "BAD: corrupted sample header\n");
> > +			goto out;
> > +		}
> > +
> > +		size = *(u32 *)data;
> > +		data += sizeof(size);
> > +		ptr += sizeof(size) + size;
> > +		if (ptr != (u8 *)buf + hdr->size) {
> > +			fprintf(stderr, "BAD: invalid sample size\n");
> > +			goto out;
> > +		}
> > +
> > +		probe_id = *(u32 *)data;
> > +		data += sizeof(probe_id);
> > +		size -= sizeof(probe_id);
> > +		data += sizeof(u32);		/* skip 32-bit gap */
> > +		size -= sizeof(u32);
> > +		buf = (u64 *)data;
> > +
> > +		printf("%3d %6d ", cpu, probe_id);
> > +		for (i = 0, size /= sizeof(u64); i < size; i++)
> > +			printf("%#016lx ", buf[i]);
> > +		printf("\n");
> > +	} else if (hdr->type == PERF_RECORD_LOST) {
> > +		u64	lost;
> > +
> > +		/*
> > +		 * struct {
> > +		 *	struct perf_event_header	header;
> > +		 *	u64				id;
> > +		 *	u64				lost;
> > +		 * }
> > +		 * and data points to the 'id' member at this point.
> > +		 */
> > +		lost = *(u64 *)(data + sizeof(u64));
> > +
> > +		printf("[%ld probes dropped]\n", lost);
> > +	} else
> > +		fprintf(stderr, "UNKNOWN: record type %d\n", hdr->type);
> > +
> > +out:
> > +	return hdr->size;
> > +}
> 
> I see a distinct lack of wrapping support. AFAICT when buf+hdr->size
> wraps you're doing out-of-bounds accesses.

Yes, that is correct.  I'm actually trying to figure out why it didn't actually
cause a SEGV when I tested this because I'm clearly reading past the end of
the mmap'd memory.  Thank you for noticing this - I was trying to be too
minimal in the code I was putting out and really didn't pay attention to this.

Fixed in the V2 I am preparing.

> > +/*
> > + * Process the available probe data in the given buffer.
> > + */
> > +static void process_data(struct dtrace_buffer *buf)
> > +{
> > +	/* This is volatile because the kernel may be updating the content. */
> > +	volatile struct perf_event_mmap_page	*rb_page = buf->base;
> > +	u8					*base = (u8 *)buf->base +
> > +							buf->page_size;
> > +	u64					head = read_rb_head(rb_page);
> > +
> > +	while (rb_page->data_tail != head) {
> > +		u64	tail = rb_page->data_tail;
> > +		u64	*ptr = (u64 *)(base + tail % buf->data_size);
> > +		int	len;
> > +
> > +		len = output_event(buf->cpu, ptr);
> > +
> > +		write_rb_tail(rb_page, tail + len);
> > +		head = read_rb_head(rb_page);
> > +	}
> > +}
> 
> more volatile yuck.
> 
> Also:
> 
> 	for (;;) {
> 		head = __atomic_load_n(&rb_page->data_head, __ATOMIC_ACQUIRE);
> 		tail = __atomic_load_n(&rb_page->data_tail, __ATOMIC_RELAXED);
> 
> 		if (head == tail)
> 			break;
> 
> 		do {
> 			hdr = buf->base + (tail & ((1UL << buf->data_shift) - 1));
> 			if ((tail >> buf->data_shift) !=
> 			    ((tail + hdr->size) >> buf->data_shift))
> 				/* handle wrap case */
> 			else
> 				/* normal case */
> 
> 			tail += hdr->size;
> 		} while (tail != head);
> 
> 		__atomic_store_n(&rb_page->data_tail, tail, __ATOMIC_RELEASE);
> 	}
> 
> Or something.

Thank you for this suggestion.  As mentioned above, I lean towards using the
provided ring_buffer_(read_head,write_tail) implementations since that is the
'other end' of the ring buffer head/tail mechanism that is going to be kept
in sync with any changes that might happen on the kernel side, right?

> > +/*
> > + * Wait for data to become available in any of the buffers.
> > + */
> > +int dt_buffer_poll(int epoll_fd, int timeout)
> > +{
> > +	struct epoll_event	events[dt_numcpus];
> > +	int			i, cnt;
> > +
> > +	cnt = epoll_wait(epoll_fd, events, dt_numcpus, timeout);
> > +	if (cnt < 0)
> > +		return -errno;
> > +
> > +	for (i = 0; i < cnt; i++)
> > +		process_data((struct dtrace_buffer *)events[i].data.ptr);
> > +
> > +	return cnt;
> > +}
> 
> Or make sure to read on the CPU by having a poll thread per CPU, then
> you can do away with the memory barriers.

That is definitely something for the todo list for future optimizations.

Thanks for your review and code suggestions.

	Kris
