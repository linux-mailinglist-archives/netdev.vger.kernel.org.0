Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C6F2DD68D
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 18:49:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729657AbgLQRrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 12:47:47 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:46554 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729070AbgLQRrr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 12:47:47 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BHHhlmO045183;
        Thu, 17 Dec 2020 17:46:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=y5K/Vi8tmH6Yvp7BKtFvQ4m8kTjmzRYG7lDR6yEjfa4=;
 b=iF8jDv6jOUayqFrGTT5P3bHpaOZOseFOSz8AspwirVpPbjCGp5dxxr/3lLicyCrS3nGw
 p3mNNTufRyUa+UzT1tq258zuVZj9g/3AWS2FfhDUzyMYSgY6vz6/Qxx9Rs6pMuoMAK5P
 wXEQNIK708mnNezL6ZoZbQ9x1DskDag0UKIGfIZrx/yVu7nA1behplX+uPLwa9OtTzoM
 CI3iLvh6im7F4lBv7AZN+eK3wJHOXIHXsBCej0cTZXQUOoHftqpfhAf6Ita7UXiBLKY6
 g1sKSNzapZgdVQBCDzOAkm+OZKBkoNGBdY9CxRZLqp4SwpX9Lb5A+DWYMNYuWuIfdiJh Ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 35cntmemj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 17 Dec 2020 17:46:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BHHjI5t010479;
        Thu, 17 Dec 2020 17:46:50 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 35g3reyq73-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 17 Dec 2020 17:46:50 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0BHHkmhT003567;
        Thu, 17 Dec 2020 17:46:48 GMT
Received: from dhcp-10-175-174-14.vpn.oracle.com (/10.175.174.14)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 17 Dec 2020 09:46:48 -0800
Date:   Thu, 17 Dec 2020 17:46:42 +0000 (GMT)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: one prog multi fentry. Was: [PATCH bpf-next] libbpf: support
 module BTF for BPF_TYPE_ID_TARGET CO-RE relocation
In-Reply-To: <20201217071620.j3uehcshue3ug7fy@ast-mbp>
Message-ID: <alpine.LRH.2.23.451.2012171732410.2929@localhost>
References: <20201205025140.443115-1-andrii@kernel.org> <alpine.LRH.2.23.451.2012071623080.3652@localhost> <20201208031206.26mpjdbrvqljj7vl@ast-mbp> <CAEf4BzaXvFQzoYXbfutVn7A9ndQc9472SCK8Gj8R_Yj7=+rTcg@mail.gmail.com> <alpine.LRH.2.23.451.2012082202450.25628@localhost>
 <20201208233920.qgrluwoafckvq476@ast-mbp> <alpine.LRH.2.23.451.2012092308240.26400@localhost> <8d483a31-71a4-1d8c-6fc3-603233be545b@fb.com> <alpine.LRH.2.23.451.2012161457030.27611@localhost> <CAEf4BzZ0_iGqnzqz3qAEggdTRhXkddtdYRUgs0XxibUyA_KH3w@mail.gmail.com>
 <20201217071620.j3uehcshue3ug7fy@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9838 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 impostorscore=0 priorityscore=1501 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012170122
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Wed, 16 Dec 2020, Alexei Starovoitov wrote:

> > > $ ksnoop "ip_send_skb(skb->sk)"
> > >
> > > ...will trace the skb->sk value.  The user-space side of the program
> > > matches the function/arg name and looks up the referenced type, setting it
> > > in the function's map.  For field references such as skb->sk, it also
> > > records offset and whether that offset is a pointer (as is the case for
> > > skb->sk) - in such cases we need to read the offset value via bpf_probe_read()
> > > and use it in bpf_snprintf_btf() along with the referenced type.  Only a
> > > single simple reference like the above is supported currently, but
> > > multiple levels of reference could be made to work too.
> 
> Alan,
> 
> I'm not sure why the last example is so different form the first two.
> I think ksnoop tool will generate the program on the fly, right?

Nope, the BPF program is hard-coded; it adapts to different functions
through use of the map entries describing function signatures and their
BTF ids, and other associated tracing info.  The aim is to provide a
generic tracing tool which displays kernel function arguments but
doesn't require LLVM/clang on the target, just a kernel built with BTF 
and libbpf.  Sorry this wasn't clearer in my explanation; I'm working
on rewriting the code and will send it out ASAP.

> So it can generate normal LDX insn with CO-RE relocation (instead of bpf_probe_read)
> to access skb->sk. It can also add relo for that LDX to point to
> struct sk_buff's btf_id defined inside prog's BTF.
> The 'sk' offset inside bpf program and inside BTF can be anything: 0, 4, ...
> libbpf relocation logic will find the right offset in kernel's sk_buff.
> If ksnoop doesn't have an ability to parse vmlinux.h file or kernel's BTF
> it can 'cheat'.
> If the cmdline looks like:
> $ ksnoop "ip_send_skb(skb->sk)"
> It can generate BTF:
> struct sk_buff {
>    struct sock *sk;
> };
> 
> If cmdline looks like:
> $ ksnoop "ip_send_skb(skb->sock)"
> It can generate BTF:
> struct sk_buff {
>    struct sock *sock;
> };
> Obviously there is no 'sock' field inside kernel's struct sk_buff, but tool
> doesn't need to care. It can let libbpf do the checking and match
> fields properly.
> 
> > > into that a bit more if you don't mind because I think some form of
> > > user-space-specified BTF ids may be the easiest approach for more flexible
> > > generic tracing that covers more than function arguments.
> 
> I think you're trying to figure out kernel's btf_ids in ksnoop tool.

Yep.

> I suggest to leave that job to libbpf. Generate local BTFs in ksnoop
> with CO-RE relocs and let libbpf handle insn patching.
> No FDs to worry about from ksnoop side either.
> 

The current approach doesn't rely on instruction patching outside
of limited CORE use around struct pt_regs fields (args, IP, etc)
which shouldn't require LLVM/clang availability on the target system. 
I'll try and get it ready for RFC submission by the weekend so you
can see more details of the approach.

Thanks!

Alan
