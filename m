Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271C31BF4D7
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 12:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgD3KEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 06:04:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:39042 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbgD3KEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 06:04:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U9wt5a044012;
        Thu, 30 Apr 2020 10:04:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=mime-version :
 message-id : date : from : to : cc : subject : references : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=DSSzKp3mUVTKXxhiuVUGdx3G2Yd34m/wqtsKlf9cY6c=;
 b=lZ6kuWQpNxDDH63AFqEDLZZujA6OxaKmoRiIDaU9YVCAuZNMZAGZ7DByCmMPwmo6MTgP
 AhFhANnzBfT6OLpFMb4Ej2tjK+KffgujNANhW7AGJM+Db4GMBc9c1+JtThSBBD4r3kXS
 y5Q5JYJQ1MDzqcp8TeNpcnMH9n8dYv8Z3MAm0D1NwabuNNIVxUL54sCvr2ty0BFYagBs
 kAS1u59mdRIo8gX1wKpF7OYep6Kexl6PYMe/3UJS9Ldej/lw3iydr5vfFkx4lDcqmao8
 4pbAD8FdUgdr7OKLj0FkgUKKO0tb/fo/mN18POuzGZdjerj2ZEda4m+uXvd2n+dAYKaV Lw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 30nucgahn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 10:04:01 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03U9wE5u176717;
        Thu, 30 Apr 2020 10:04:00 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 30qtg0gu6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 Apr 2020 10:04:00 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03UA3wEa019145;
        Thu, 30 Apr 2020 10:03:58 GMT
Received: from dhcp-10-175-187-247.vpn.oracle.com (/10.175.187.247) by default
 (Oracle Beehive Gateway v4.0) with ESMTP ; Thu, 30 Apr 2020 03:03:45 -0700
X-X-SENDER: alan@localhost
USER-AGENT: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Message-ID: <alpine.LRH.2.21.2004301010520.23084@localhost>
Date:   Thu, 30 Apr 2020 03:03:36 -0700 (PDT)
From:   Alan Maguire <alan.maguire@oracle.com>
To:     Joe Perches <joe@perches.com>
Cc:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        ast@kernel.org, daniel@iogearbox.net, yhs@fb.com, kafai@fb.com,
        songliubraving@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next 0/6] bpf, printk: add BTF-based type printing
References: <1587120160-3030-1-git-send-email-alan.maguire@oracle.com>
 <20200418160536.4mrvqh2lasqbyk77@ast-mbp>
 <alpine.LRH.2.21.2004201623390.12711@localhost>
 <7d6019da19d52c851d884731b1f16328fdbe2e3d.camel@perches.com>
In-Reply-To: <7d6019da19d52c851d884731b1f16328fdbe2e3d.camel@perches.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 adultscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300081
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9606 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 priorityscore=1501
 mlxlogscore=999 impostorscore=0 suspectscore=3 malwarescore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004300081
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 20 Apr 2020, Joe Perches wrote:

> On Mon, 2020-04-20 at 16:29 +0100, Alan Maguire wrote:
> > On Sat, 18 Apr 2020, Alexei Starovoitov wrote:
> > 
> > > On Fri, Apr 17, 2020 at 11:42:34AM +0100, Alan Maguire wrote:
> > > > The printk family of functions support printing specific pointer types
> > > > using %p format specifiers (MAC addresses, IP addresses, etc).  For
> > > > full details see Documentation/core-api/printk-formats.rst.
> > > > 
> > > > This RFC patchset proposes introducing a "print typed pointer" format
> > > > specifier "%pT<type>"; the type specified is then looked up in the BPF
> > > > Type Format (BTF) information provided for vmlinux to support display.
> > > 
> > > This is great idea! Love it.
> > > 
> > 
> > Thanks for taking a look!
> >  
> > > > The above potential use cases hint at a potential reply to
> > > > a reasonable objection that such typed display should be
> > > > solved by tracing programs, where the in kernel tracing records
> > > > data and the userspace program prints it out.  While this
> > > > is certainly the recommended approach for most cases, I
> > > > believe having an in-kernel mechanism would be valuable
> > > > also.
> > > 
> > > yep. This is useful for general purpose printk.
> > > The only piece that must be highlighted in the printk documentation
> > > that unlike the rest of BPF there are zero safety guarantees here.
> > > The programmer can pass wrong pointer to printk() and the kernel _will_ crash.
> > > 
> > 
> > Good point; I'll highlight the fact that we aren't
> > executing in BPF context, no verifier etc.
> > 
> > > >   struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);
> > > > 
> > > >   pr_info("%pTN<struct sk_buff>", skb);
> > > 
> > > why follow "TN" convention?
> > > I think "%p<struct sk_buff>" is much more obvious, unambiguous, and
> > > equally easy to parse.
> > > 
> > 
> > That was my first choice, but the first character
> > after the 'p' in the '%p' specifier signifies the
> > pointer format specifier. If we use '<', and have
> > '%p<', where do we put the modifiers? '%p<xYz struct foo>'
> > seems clunky to me.
> 
> While I don't really like the %p<struct type> block,
> it's at least obvious what's being attempted.
> 
> Modifiers could easily go after the <struct type> block.
>

Good idea; I'll go with that approach for v2.
 
> It appears a %p<struct type> output might be a lot of
> total characters so another potential issue might be
> the maximum length of each individual printk.
>

Right, that's a concern. On the other side, it turns out
that with the "omit zeroed values" behaviour by default,
the output trims down nicely.  The omit zero functionality
works for nested types too, so a freshly-allocated skb
fits easily inside the printk limit now.  The in-progress
output looks like this now (v2 coming shortly I hope):

printk(KERN_INFO "%p<struct sk_buff>", skb);

(struct sk_buff){
 .transport_header = (__u16)65535,
 .mac_header = (__u16)65535,
 .end = (sk_buff_data_t)192,
 .head = (unsigned char *)000000007524fd8b,
 .data = (unsigned char *)000000007524fd8b,
 .truesize = (unsigned int)768,
 .users = (refcount_t){
  .refs = (atomic_t){
   .counter = (int)1,
  },
 },
}

Of course as structures get used and values get set
(precisely when we need to see them!) more fields will
be displayed and we will bump against printk limits.

The modifiers I'm working on for v2 are

'c' - compact mode (no pretty-printing), i.e.

(struct sk_buff){.transport_header = (__u16)65535,.mac_header = (__u16)65535,.end = (sk_buff_data_t)192,.head = (unsigned char *)000000007524fd8b,.data = (unsigned char *)000000007524fd8b,.truesize = (unsigned int)768,.users = (refcount_t){.refs = (atomic_t){.counter = (int)1,},},}

      This saves a fair few characters, especially for highly-indented
      data structures.

'T' - omit type/member names.
'x' - avoid pointer obfuscation
'0' - show zeroed values, as suggested by Arnaldo and Alexei

...so the default output of "%p<struct sk_buff>"
will be like the above example.

I was hoping to punt on pointer obfuscation and just
use %p[K] since obfuscation can be sysctl-controlled;
however that control assumes a controlling process context
as I understand it.  Since BTF printk can be invoked
anywhere (especially via trace_printk() in BPF programs),
those settings aren't hugely relevant, so I _think_ we need
a way to directly control obfuscation for this use case.

> > > I like the choice of C style output, but please format it similar to drgn. Like:
> > > *(struct task_struct *)0xffff889ff8a08000 = {
> > > 	.thread_info = (struct thread_info){
> > > 		.flags = (unsigned long)0,
> > > 		.status = (u32)0,
> > > 	},
> > > 	.state = (volatile long)1,
> > > 	.stack = (void *)0xffffc9000c4dc000,
> > > 	.usage = (refcount_t){
> > > 		.refs = (atomic_t){
> > > 			.counter = (int)2,
> > > 		},
> > > 	},
> > > 	.flags = (unsigned int)4194560,
> > > 	.ptrace = (unsigned int)0,
> 
> And here, the issue might be duplicating the log level
> for each line of output and/or prefixing each line with
> whatever struct type is being dumped as interleaving
> with other concurrent logging is possible.
> 

That's a good idea but sadly it makes the problem of longer
display worse.  Compact/type-omitted options help for
the particularly bad cases at least I suppose.

> Here as well the individual field types don't contain
> enough information to determine if a field should be
> output as %x or %u.
> 
>

Right, we could add some more format modifiers for cases
like that I guess.  Currently the display formats used are

- numbers are represented as decimal
- bitfields are represented in hex
- pointers are obfuscated unless the 'x' option is used
- char arrays are printed as chars if printable,
  [ 'l', 'i', 'k', 'e', ' ', 't', 'h', 'i', 's' ]

I'd be happy to add more format specifiers to control
these options, or tweak the defaults if needed. A
"print numbers in hex" option seems worthwhile perhaps?

Thanks for the feedback!

Alan
