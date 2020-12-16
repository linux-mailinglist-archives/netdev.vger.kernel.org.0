Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 442192DC3E8
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 17:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgLPQT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 11:19:57 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:49048 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgLPQTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 11:19:41 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BGGAVLg052622;
        Wed, 16 Dec 2020 16:18:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : in-reply-to : message-id : references : mime-version :
 content-type; s=corp-2020-01-29;
 bh=re/aI2fDMWGF30Md61TwWVGiHxw2BS1EGri0QGH2ZjA=;
 b=Zb66kinQJQnM34RnSrwh6ye6bwQ0iRhJ03HmGsjCwZndNoSOb+4onKl4WP4YuLnmhHQk
 TOnlnHzRkElVt+R3Qkw53Vb46z3rgP97xxazlnNtkp9VXCQYbRH3XtDnDfnQa33Vlvt4
 glz1Xo5QfLisxOpdkqN55jH4pIj6gpfOZUum3CXbR6ldD4eTkCUNWTC2oPgW4y3ZNFCK
 wIZAQUB7hwArVGof5xtc2tRq1FTqOlfKAp/36vjt4gpSO/hrWLzdeaHd1JsekCyD3Z88
 kt8+JKMRxF3OS/JihnhFVW4xdLh421d8HRYQegxSrtCJJ4SyBnnH92NvEch7KTN6oHi0 kw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 35cn9rh54s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 16 Dec 2020 16:18:43 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0BGG6Emf139320;
        Wed, 16 Dec 2020 16:18:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 35d7sy037j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Dec 2020 16:18:42 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0BGGIfCZ021631;
        Wed, 16 Dec 2020 16:18:41 GMT
Received: from dhcp-10-175-181-136.vpn.oracle.com (/10.175.181.136)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 16 Dec 2020 08:18:40 -0800
Date:   Wed, 16 Dec 2020 16:18:34 +0000 (GMT)
From:   Alan Maguire <alan.maguire@oracle.com>
X-X-Sender: alan@localhost
To:     Alexei Starovoitov <ast@fb.com>
cc:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: one prog multi fentry. Was: [PATCH bpf-next] libbpf: support
 module BTF for BPF_TYPE_ID_TARGET CO-RE relocation
In-Reply-To: <8d483a31-71a4-1d8c-6fc3-603233be545b@fb.com>
Message-ID: <alpine.LRH.2.23.451.2012161457030.27611@localhost>
References: <20201205025140.443115-1-andrii@kernel.org> <alpine.LRH.2.23.451.2012071623080.3652@localhost> <20201208031206.26mpjdbrvqljj7vl@ast-mbp> <CAEf4BzaXvFQzoYXbfutVn7A9ndQc9472SCK8Gj8R_Yj7=+rTcg@mail.gmail.com> <alpine.LRH.2.23.451.2012082202450.25628@localhost>
 <20201208233920.qgrluwoafckvq476@ast-mbp> <alpine.LRH.2.23.451.2012092308240.26400@localhost> <8d483a31-71a4-1d8c-6fc3-603233be545b@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9837 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160108
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9836 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012160108
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020, Alexei Starovoitov wrote:

> On Wed, Dec 09, 2020 at 11:21:43PM +0000, Alan Maguire wrote:
> > Right, that's exactly it.  A pair of generic tracing BPF programs are
> > used, and they attach to kprobe/kretprobes, and when they run they
> > use the arguments plus the map details about BTF ids of those arguments to
> > run bpf_snprintf_btf(), and send perf events to userspace containing the
> > results.
> ...
> > That would be fantastic! We could do that from the context passed into a
> > kprobe program as the IP in struct pt_regs points at the function.
> > kretprobes seems a bit trickier as in that case the IP in struct pt_regs is
> > actually set to kretprobe_trampoline rather than the function we're
> > returning from due to how kretprobes work; maybe there's another way to get
> > it in that case though..
> 
> Yeah. kprobe's IP doesn't match kretprobe's IP which makes such tracing
> use cases more complicated. Also kretprobe is quite slow. See
> prog_tests/test_overhead and selftests/bpf/bench.
> I think the key realization is that the user space knows all IPs
> it will attach to. It has to know all IPs otherwise
> hashmap{key=ip, value=btf_data} is not possible.
> Obvious, right ? What it means that we can use this key observation
> to build better interfaces at all layers. kprobes are slow to
> setup one by one. It's also slow to execute. fentry/fexit is slow
> to setup, but fast to execute. Jiri proposed a batching api for
> fentry, but it doesn't quite make sense from api perspective
> since user space has to give different bpf prog for every fentry.
> bpf trampoline is unique for every target fentry kernel function.
> The batched attach would make sense for kprobe because one prog
> can be attached everywhere. But kprobe is slow.
> This thought process justifies an addition of a new program
> type where one program can attach to multiple fentry.
> Since fentry ctx is no longer fixed the verifier won't be able to
> track btf_id-s of arguments, but btf based pointer walking is fast
> and powerful, so if btf is passed into the program there could
> be a helper that does dynamic cast from long to PTR_TO_BTF_ID.
> Since such new fentry prog will have btf in the context and
> there will be no need for user space to populate hashmap and
> mess with IPs. And the best part that batched attach will not
> only be desired, but mandatory part of the api.
> So I'm proposing to extend BPF_PROG_LOAD cmd with an array of
> pairs (attach_obj_fd, attach_btf_id).
> The fentry prog in .c file might even have a regex in attach pattern:
> SEC("fentry/sys_*")
> int BPF_PROG(test, struct btf *btf_obj, __u32 btf_id, __u64 arg1,
>              __u64 arg2, ...__u64 arg6)
> {
>   struct btf_ptr ptr1 = {
>     .ptr = arg1,
>     .type_id = bpf_core_type_id_kernel(struct foo),
>     .btf_obj = btf_obj,
>   },
>   ptr2 = {
>     .ptr = arg2,
>     .type_id = bpf_core_type_id_kernel(struct bar),
>     .btf_obj = btf_obj,
>   };
>   bpf_snprintf_btf(,, &ptr1, sizeof(ptr1), );
>   bpf_snprintf_btf(,, &ptr1, sizeof(ptr2), );
> }
> 
> libbpf will process the attach regex and find all matching functions in
> the kernel and in the kernel modules. Then it will pass this list of
> (fd,btf_id) pairs to the kernel. The kernel will find IP addresses and
> BTFs of all functions. It will generate single bpf trampoline to handle
> all the functions. Either one trampoline or multiple trampolines is an
> implementation detail. It could be one trampoline that does lookup based
> on IP to find btf_obj, btf_id to pass into the program or multiple
> trampolines that share most of the code with N unique trampoline
> prefixes with hardcoded btf_obj, btf_id. The argument save/restore code
> can be the same for all fentries. The same way we can support single
> fexit prog attaching to multiple kernel functions. And even single
> fmod_ret prog attaching to multiple. The batching part will make
> attaching to thousands of functions efficient. We can use batched
> text_poke_bp, etc.
> 
> As far as dynamic btf casting helper we could do something like this:
> SEC("fentry/sys_*")
> int BPF_PROG(test, struct btf *btf_obj, __u32 btf_id, __u64 arg1, __u64
> arg2, ...__u64 arg6)
> {
>   struct sk_buff *skb;
>   struct task_struct *task;
> 
>   skb = bpf_dynamic_cast(btf_obj, btf_id, 1, arg1,
>                          bpf_core_type_id_kernel(skb));
>   task = bpf_dynamic_cast(btf_obj, btf_id, 2, arg2,
>                           bpf_core_type_id_kernel(task));
>   skb->len + task->status;
> }
> The dynamic part of the helper will walk btf of func_proto that was
> pointed to by 'btf_id' argument. It will find Nth argument and
> if argument's btf_id matches the last u32 passed into bpf_dynamic_cast()
> it will return ptr_to_btf_id. The verifier needs 5th u32 arg to know
> const value of btf_id during verification.
> The execution time of this casting helper will be pretty fast.
> Thoughts?
> 
> 

From a bpf programmer's perspective, the above sounds fantastic and opens 
up a bunch of new possibilities.  For example, a program that attaches to 
a bunch of networking functions at once and uses dynamic casts to find the 
skb argument could help trace packet flow through the stack without having 
to match exact function signatures.  From a mechanics perspective I 
wonder if we could take a similar approach to the cgroup storage, and use 
the bpf prog array structure to store a struct btf * and any other 
site-specific metadata at attach time? Then when the array runs we could 
set a per-cpu variable such that helpers could pick up that info if 
needed.

Having the function argument BTF ids gets us nearly the whole way there 
from a generic tracer perspective - I can now attach my generic tracing 
program to an arbitrary function via fentry/fexit and get the BTF ids 
of the arguments or return value, and even better can do it with wildcarding.
There is an additional use case though - at least for the ksnoop program
I'm working on at least - and it's where we access members and need their 
type ids too.  The ksnoop program (which I wanted to send out last week but due 
to a system move I'm temporarily not able to access the code, sorry about that,
hoping it'll be back online early next week) operates in two modes;

- default mode where we trace function arguments for kprobe and return value
  for kretprobe; that's covered by the above; and
- a mode where the user specifies what they want. For example running

$ ksnoop "ip_send_skb" 

...is an example of default mode, this will trace entry/return and print 
arguments and return values, while

$ ksnoop "ip_send_skb(skb)"

...will trace the skb argument only, and

$ ksnoop "ip_send_skb(skb->sk)"

...will trace the skb->sk value.  The user-space side of the program 
matches the function/arg name and looks up the referenced type, setting it 
in the function's map.  For field references such as skb->sk, it also 
records offset and whether that offset is a pointer (as is the case for 
skb->sk) - in such cases we need to read the offset value via bpf_probe_read()
and use it in bpf_snprintf_btf() along with the referenced type.  Only a
single simple reference like the above is supported currently, but 
multiple levels of reference could be made to work too.

This latter case would be awkward to support programmatically in BPF 
program context I think, though I'm sure it could be done.  To turn back 
to our earlier conversation, your concern as I understand it was that 
pre-specifying module BTF type ids in a map is racy, and I'd like to dig 
into that a bit more if you don't mind because I think some form of
user-space-specified BTF ids may be the easiest approach for more flexible
generic tracing that covers more than function arguments.

I assume the race you're concerned about is caused by the module unloading 
after the BTF ids have been set in the map? And then the module reappears 
with different BTF/type id mappings? Perhaps a helper for retrieving
the struct btf * which was set at attach time would be enough?

So for example something like


	struct btf_ptr ptr;

	ptr.type_id = /* retrieve from map */
	ptr.obj_id = bpf_get_btf(THIS_MODULE);

...where we don't actually specify a type but a libbpf-specified fd
is used to stash the associated "struct btf *" for the module in the 
prog array at attach.  Are there still race conditions we need to worry
about in a scenario like this? Thanks!

Alan
