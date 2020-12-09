Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A4B02D4EB2
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 00:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730633AbgLIXWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 18:22:44 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:35774 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLIXWn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 18:22:43 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9NJeFV092648;
        Wed, 9 Dec 2020 23:21:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=os2tjc6ZENkqIupXpeArIU0898ZzATBtxVzyRO9TfgQ=;
 b=ZBLBkfbtSYAISKWzRYSyJdJiRY3rDhd8d0qlGQ6bnGLJclJAAyySlmybnlTnHF+f5mNT
 cKqJe2ANocOaQnsuoWDLgoRsyMbAwOTTxQ8IrJYmQ1gYRBEATWAAuG3weebAYPUgOz2a
 ndJ7Ty0FcdSngNHc9U1JsJSFRAsJryLoX63DeyRu4w+IinKuGrz6rkyzf+inyR3ArOm9
 tWGnC+Ja1EmsyR6QtJLc4tuXWCviwyjX5trBvw4rBZtQFsyrlodGmaS1Y6K24BXg8tyu
 jXQYhsJMhyhAJGIyhe1wZ9Vjcvv2Uf0gAE25obvMQlBiMcbb9EJgTt6eijKeGxaDsq5X CQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 357yqc2xg0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 09 Dec 2020 23:21:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B9NFmqC139802;
        Wed, 9 Dec 2020 23:21:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 358m51bwsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Dec 2020 23:21:48 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0B9NLlFF006958;
        Wed, 9 Dec 2020 23:21:47 GMT
Received: from dhcp-10-175-171-125.vpn.oracle.com (/10.175.171.125)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Dec 2020 15:21:46 -0800
Date:   Wed, 9 Dec 2020 23:21:43 +0000 (GMT)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
cc:     Alan Maguire <alan.maguire@oracle.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: support module BTF for BPF_TYPE_ID_TARGET
 CO-RE relocation
In-Reply-To: <20201208233920.qgrluwoafckvq476@ast-mbp>
Message-ID: <alpine.LRH.2.23.451.2012092308240.26400@localhost>
References: <20201205025140.443115-1-andrii@kernel.org> <alpine.LRH.2.23.451.2012071623080.3652@localhost> <20201208031206.26mpjdbrvqljj7vl@ast-mbp> <CAEf4BzaXvFQzoYXbfutVn7A9ndQc9472SCK8Gj8R_Yj7=+rTcg@mail.gmail.com> <alpine.LRH.2.23.451.2012082202450.25628@localhost>
 <20201208233920.qgrluwoafckvq476@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9830 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=10
 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012090160
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9830 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=10 mlxlogscore=999
 clxscore=1015 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090160
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Dec 2020, Alexei Starovoitov wrote:

> On Tue, Dec 08, 2020 at 10:13:35PM +0000, Alan Maguire wrote:
> > 
> > Does this approach prevent more complex run-time specification of BTF 
> > object fd though?  For example, I've been working on a simple tracer 
> > focused on kernel debugging; it uses a BPF map entry for each kernel 
> > function that is traced. User-space populates the map entry with BTF type 
> > ids for the function arguments/return value, and when the BPF program 
> > runs it uses the instruction pointer to look up the map entry for that
> > function, and uses bpf_snprintf_btf() to write the string representations 
> > of the function arguments/return values.  I'll send out an RFC soon, 
> > but longer-term I was hoping to extend it to support module-specific 
> > types.  Would a dynamic case like that - where the BTF module fd is looked 
> > up in a map entry during program execution (rather than derived via 
> > __btf_builtin_type_id()) work too? Thanks!
> 
> fd has to be resolved in the process context. bpf prog can read fd
> number from the map, but that number is meaningless.
> Say we allow using btf_obj_id+btf_id, how user space will know these
> two numbers? Some new libbpf api that searches for it?
> An extension to libbpf_find_vmlinux_btf_id() ? I was hoping that this api
> will stay semi-internal. But say it's extended.
> The user space will store a pair of numbers into a map and
> what program are going to do with it?
> If it's printing struct veth_stats contents it should have attached to
> a corresponding function in the veth module via fentry or something.
> The prog has hard coded logic in C with specific pointer to print.
> The prog has its type right there. Why would the prog take a pointer
> from one place, but it's type_id from the map? That's not realistic.
> Where it would potentially make sense is what I think you're descring
> where single kprobe style prog attached to many places and args of
> those places are stored in a map and the prog selects them with
> map_lookup with key=PT_REGS_IP ?

Right, that's exactly it.  A pair of generic tracing BPF programs are
used, and they attach to kprobe/kretprobes, and when they run they use 
the arguments plus the map details about BTF ids of those arguments to 
run bpf_snprintf_btf(), and send perf events to userspace containing
the results.

> And passes pointers into bpf_snprintf_btf() from PT_REGS_PARM1() ?

Exactly.

> I see why that is useful, but it's so racy. By the time the map
> is populated those btf_obj_id+btf_id could be invalid.
> I think instead of doing this in user space the program needs an access
> to vmlinux+mods BTFs. Sort-of like proposed bpf helper to return ksym
> based on IP there could be a helper to figure out btf_id+btf_obj_POINTER
> based on IP. Then there will no need for external map to populate.
> Would that solve your use case?

That would be fantastic! We could do that from the context passed into a
kprobe program as the IP in struct pt_regs points at the function.  
kretprobes seems a bit trickier as in that case the IP in struct pt_regs 
is actually set to kretprobe_trampoline rather than the function we're
returning from due to how kretprobes work; maybe there's another way to 
get it in that case though..

Alan
