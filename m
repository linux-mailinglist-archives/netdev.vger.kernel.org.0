Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3514B1B1035
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 17:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgDTPcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 11:32:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52116 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbgDTPcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 11:32:18 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KFISef189074;
        Mon, 20 Apr 2020 15:31:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=Yql0IcIqHpszKXnVsmou87K4Wd/Z21X1vdlTa/+vIIg=;
 b=qM3kAztqgggIdXYZZ3y6FSDE7zVrMXkTvBV89ziEWf8JxRePc7xXaCA8dppDwT/NsYEI
 d/4cZpfhy61OCWjktB+cbZoDOwQSgwqhgvMz8Hvj5I8Nb4DN9DY9cKMLYZIvqjQIJ7Vr
 1fdUUj6zqDZpqWw5H4+DtBPXRNwaQISadno2k+OnRAj/IB51VjcRToMg8mMRwuzGgCyl
 r0JltMu8IP9/4qHz7wMTaII36C/1L/8DFQ0/PyYPwam2v681r6oGhe/X7yCXnRzaZMBX
 NedzQpkamt6fiBqO3kqfgz6gZi6pvkkk7ED+LsD+aGtRlqZFbKOmJS4d5q9f0TR2ah1u Gw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30grpgcdug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 15:31:59 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03KFIPF2037527;
        Mon, 20 Apr 2020 15:29:58 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 30gbbavtuc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 20 Apr 2020 15:29:58 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03KFTvmn003913;
        Mon, 20 Apr 2020 15:29:57 GMT
Received: from dhcp-10-175-219-85.vpn.oracle.com (/10.175.219.85)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 20 Apr 2020 08:29:56 -0700
Date:   Mon, 20 Apr 2020 16:29:49 +0100 (BST)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
cc:     Alan Maguire <alan.maguire@oracle.com>, ast@kernel.org,
        daniel@iogearbox.net, yhs@fb.com, kafai@fb.com,
        songliubraving@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next 0/6] bpf, printk: add BTF-based type
 printing
In-Reply-To: <20200418160536.4mrvqh2lasqbyk77@ast-mbp>
Message-ID: <alpine.LRH.2.21.2004201623390.12711@localhost>
References: <1587120160-3030-1-git-send-email-alan.maguire@oracle.com> <20200418160536.4mrvqh2lasqbyk77@ast-mbp>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9596 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004200130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9596 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 bulkscore=0 clxscore=1015
 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004200130
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 18 Apr 2020, Alexei Starovoitov wrote:

> On Fri, Apr 17, 2020 at 11:42:34AM +0100, Alan Maguire wrote:
> > The printk family of functions support printing specific pointer types
> > using %p format specifiers (MAC addresses, IP addresses, etc).  For
> > full details see Documentation/core-api/printk-formats.rst.
> > 
> > This RFC patchset proposes introducing a "print typed pointer" format
> > specifier "%pT<type>"; the type specified is then looked up in the BPF
> > Type Format (BTF) information provided for vmlinux to support display.
> 
> This is great idea! Love it.
>

Thanks for taking a look!
 
> > The above potential use cases hint at a potential reply to
> > a reasonable objection that such typed display should be
> > solved by tracing programs, where the in kernel tracing records
> > data and the userspace program prints it out.  While this
> > is certainly the recommended approach for most cases, I
> > believe having an in-kernel mechanism would be valuable
> > also.
> 
> yep. This is useful for general purpose printk.
> The only piece that must be highlighted in the printk documentation
> that unlike the rest of BPF there are zero safety guarantees here.
> The programmer can pass wrong pointer to printk() and the kernel _will_ crash.
> 

Good point; I'll highlight the fact that we aren't
executing in BPF context, no verifier etc.

> >   struct sk_buff *skb = alloc_skb(64, GFP_KERNEL);
> > 
> >   pr_info("%pTN<struct sk_buff>", skb);
> 
> why follow "TN" convention?
> I think "%p<struct sk_buff>" is much more obvious, unambiguous, and
> equally easy to parse.
> 

That was my first choice, but the first character
after the 'p' in the '%p' specifier signifies the
pointer format specifier. If we use '<', and have
'%p<', where do we put the modifiers? '%p<xYz struct foo>'
seems clunky to me.

> > ...gives us:
> > 
> > {{{.next=00000000c7916e9c,.prev=00000000c7916e9c,{.dev=00000000c7916e9c|.dev_scratch=0}}|.rbnode={.__rb_parent_color=0,
> 
> This is unreadable.
> I like the choice of C style output, but please format it similar to drgn. Like:
> *(struct task_struct *)0xffff889ff8a08000 = {
> 	.thread_info = (struct thread_info){
> 		.flags = (unsigned long)0,
> 		.status = (u32)0,
> 	},
> 	.state = (volatile long)1,
> 	.stack = (void *)0xffffc9000c4dc000,
> 	.usage = (refcount_t){
> 		.refs = (atomic_t){
> 			.counter = (int)2,
> 		},
> 	},
> 	.flags = (unsigned int)4194560,
> 	.ptrace = (unsigned int)0,
> 
> I like Arnaldo's idea as well, but I prefer zeros to be dropped by default.
> Just like %d doesn't print leading zeros by default.
> "%p0<struct sk_buff>" would print them.
> 

I'll try and match the above as closely as possible for v2
while retaining the compact form for the verifier's use.

> > The patches are marked RFC for several reasons
> > 
> > - There's already an RFC patchset in flight dealing with BTF dumping;
> > 
> > https://www.spinics.net/lists/netdev/msg644412.html
> > 
> >   The reason I'm posting this is the approach is a bit different 
> >   and there may be ways of synthesizing the approaches.
> 
> I see no overlap between patch sets whatsoever.
> Why do you think there is?
>

Because I hadn't read through Yonghong's patchset properly ;-)
I see potential future overlap in having a dumper support a 
"raw" mode using BTF-based display if needed, but no actual
overlap in what's there (and here) today.
 
> > - The mechanism of vmlinux BTF initialization is not fit for purpose
> >   in a printk() setting as I understand it (it uses mutex locking
> >   to prevent multiple initializations of the BTF info).  A simple
> >   approach to support printk might be to simply initialize the
> >   BTF vmlinux case early in boot; it only needs to happen once.
> >   Any suggestions here would be great.
> > - BTF-based rendering is more complex than other printk() format
> >   specifier-driven methods; that said, because of its generality it
> >   does provide significant value I think
> > - More tests are needed.
> 
> yep. Please make sure to add one to selftest/bpf as well.
> bpf maintainers don't run printk tests as part of workflow, so
> future BTF changes will surely break it if there are no selftests/bpf.
> 

Absolutely.

> Patch 2 isn't quite correct. Early parse of vmlinux BTF does not compute
> resolved_ids to save kernel memory. The trade off is execution time vs kernel
> memory. I believe that saving memory is more important here, since execution is
> not in critical path. There is __get_type_size(). It should be used in later
> patches instead of btf_type_id_size() that relies on pre-computed
> resolved_sizes and resolved_ids.
>

Thanks for the info, will fix for v2!

Alan 
