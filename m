Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26A463000F
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 18:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbfE3QQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 12:16:49 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58102 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726253AbfE3QQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 12:16:49 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4UGDiS5076973;
        Thu, 30 May 2019 16:15:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2018-07-02;
 bh=iHS7ndNvviyNhe/9xLnFYqUmNJoidOdk0Rk9WZjZMCE=;
 b=S4QhmiZel3YX/DNZKXYTg5n7LGkwMBEe7zhliF4Pf4Scn9d046EBBxvIh5GRKOfLZSR4
 yMEHE0mi2zi+V2VRlCZ4uODSMMQkGAVhWSGjoHnWcyknXQ/mu3rCnDj0m315p+BQ6b/j
 ioeWWxrgaEKLqLbI63rB8n7tfkjd2YhEE/I3GdNQeGX1PPuVg3HBYWTI7u3C8fHWnnm2
 bgCgDKj/TBDHdKTjhCkHMN7/B6NCXz0IbOY71MPA1/hnr32gFBHQNU5Hpwc0irHf/59h
 LYkkP/QMQlzrE2p9F9eM5iX5lVLDcGuad0JaHE+a/tOXG/IRtEBDS3BCdy4LmZue8RTO Jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2spxbqh38a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 May 2019 16:15:49 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x4UGEQAZ022629;
        Thu, 30 May 2019 16:15:48 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 2sqh74dm3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 30 May 2019 16:15:48 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x4UGFmU4026533;
        Thu, 30 May 2019 16:15:48 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2sqh74dm3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 30 May 2019 16:15:48 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x4UGFkmK000821;
        Thu, 30 May 2019 16:15:46 GMT
Received: from localhost (/10.159.211.102)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 30 May 2019 09:15:46 -0700
Date:   Thu, 30 May 2019 12:15:43 -0400
From:   Kris Van Hees <kris.van.hees@oracle.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kris Van Hees <kris.van.hees@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, dtrace-devel@oss.oracle.com,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        mhiramat@kernel.org, acme@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, peterz@infradead.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190530161543.GA1835@oracle.com>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
 <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
 <20190521184137.GH2422@oracle.com>
 <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
 <20190521213648.GK2422@oracle.com>
 <20190521232618.xyo6w3e6nkwu3h5v@ast-mbp.dhcp.thefacebook.com>
 <20190522041253.GM2422@oracle.com>
 <20190522201624.eza3pe2v55sn2t2w@ast-mbp.dhcp.thefacebook.com>
 <20190523051608.GP2422@oracle.com>
 <20190523202842.ij2quhpmem3nabii@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523202842.ij2quhpmem3nabii@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9272 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905300115
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 01:28:44PM -0700, Alexei Starovoitov wrote:
> On Thu, May 23, 2019 at 01:16:08AM -0400, Kris Van Hees wrote:
> > On Wed, May 22, 2019 at 01:16:25PM -0700, Alexei Starovoitov wrote:
> > > On Wed, May 22, 2019 at 12:12:53AM -0400, Kris Van Hees wrote:
> > > > 
> > > > Could you elaborate on why you believe my patches are not adding generic
> > > > features?  I can certainly agree that the DTrace-specific portions are less
> > > > generic (although they are certainly available for anyone to use), but I
> > > > don't quite understand why the new features are deemed non-generic and why
> > > > you believe no one else can use this?
> > > 
> > > And once again your statement above contradicts your own patches.
> > > The patch 2 adds new prog type BPF_PROG_TYPE_DTRACE and the rest of the patches
> > > are tying everything to it.
> > > This approach contradicts bpf philosophy of being generic execution engine
> > > and not favoriting one program type vs another.
> > 
> > I am not sure I understand where you see a contradiction.  What I posted is
> > a generic feature, and sample code that demonstrates how it can be used based
> > on the use-case that I am currently working on.  So yes, the sample code is
> > very specific but it does not restrict the use of the cross-prog-type tail-call
> > feature.  That feature is designed to be generic.
> > 
> > Probes come in different types (kprobe, tracepoint, perf event, ...) and they
> > each have their own very specific data associated with them.  I agree 100%
> > with you on that.  And sometimes tracing makes use of those specifics.  But
> > even from looking at the implementation of the various probe related prog
> > types (and e.g. the list of helpers they each support) it shows that there is
> > a lot of commonality as well.  That common functionality is common to all the
> > probe program types, and that is where I suggest introducing a program type
> > that captures the common concept of a probe, so perhaps a better name would
> > be BPF_PROG_TYPE_PROBE.
> > 
> > The principle remains the same though...  I am proposing adding support for
> > program types that provide common functionality so that programs for various
> > program types can make use of the more generic programs stored in prog arrays.
> 
> Except that prog array is indirect call based and got awfully slow due
> to retpoline and we're trying to redesign the whole tail_call approach.
> So more extensions to tail_call facility is the opposite of that direction.

OK, I see the point of retpoline having slowed down tail_call.  Do you have
any suggestions in how to accomplish the concept that I am proposing in a
different way?  I believe that the discussion that has been going on in other
emails has shown that while introducing a program type that provides a
generic (abstracted) context is a different approach from what has been done
so far, it is a new use case that provides for additional ways in which BPF
can be used.

> > > I have nothing against dtrace language and dtrace scripts.
> > > Go ahead and compile them into bpf.
> > > All patches to improve bpf infrastructure are very welcomed.
> > > 
> > > In particular you brought up a good point that there is a use case
> > > for sharing a piece of bpf program between kprobe and tracepoint events.
> > > The better way to do that is via bpf2bpf call.
> > > Example:
> > > void bpf_subprog(arbitrary args)
> > > {
> > > }
> > > 
> > > SEC("kprobe/__set_task_comm")
> > > int bpf_prog_kprobe(struct pt_regs *ctx)
> > > {
> > >   bpf_subprog(...);
> > > }
> > > 
> > > SEC("tracepoint/sched/sched_switch")
> > > int bpf_prog_tracepoint(struct sched_switch_args *ctx)
> > > {
> > >   bpf_subprog(...);
> > > }
> > > 
> > > Such configuration is not supported by the verifier yet.
> > > We've been discussing it for some time, but no work has started,
> > > since there was no concrete use case.
> > > If you can work on adding support for it everyone will benefit.
> > > 
> > > Could you please consider doing that as a step forward?
> > 
> > This definitely looks to be an interesting addition and I am happy to look into
> > that further.  I have a few questions that I hope you can shed light on...
> > 
> > 1. What context would bpf_subprog execute with?  If it can be called from
> >    multiple different prog types, would it see whichever context the caller
> >    is executing with?  Or would you envision bpf_subprog to not be allowed to
> >    access the execution context because it cannot know which one is in use?
> 
> bpf_subprog() won't be able to access 'ctx' pointer _if_ it's ambiguous.
> The verifier already smart enough to track all the data flow, so it's fine to
> pass 'struct pt_regs *ctx' as long as it's accessed safely.
> For example:
> void bpf_subprog(int kind, struct pt_regs *ctx1, struct sched_switch_args *ctx2)
> {
>   if (kind == 1)
>      bpf_printk("%d", ctx1->pc);
>   if (kind == 2)
>      bpf_printk("%d", ctx2->next_pid);
> }
> 
> SEC("kprobe/__set_task_comm")
> int bpf_prog_kprobe(struct pt_regs *ctx)
> {
>   bpf_subprog(1, ctx, NULL);
> }
> 
> SEC("tracepoint/sched/sched_switch")
> int bpf_prog_tracepoint(struct sched_switch_args *ctx)
> {
>   bpf_subprog(2, NULL, ctx);
> }
> 
> The verifier should be able to prove that the above is correct.
> It can do so already if s/ctx1/map_value1/, s/ctx2/map_value2/
> What's missing is an ability to have more than one 'starting' or 'root caller'
> program.
> 
> Now replace SEC("tracepoint/sched/sched_switch") with SEC("cgroup/ingress")
> and it's becoming clear that BPF_PROG_TYPE_PROBE approach is not good enough, right?

Yes and no.  It depends on what you are trying to do with the BPF program that
is attached to the different events.  From a tracing perspective, providing a
single BPF program with an abstract context would make sense in your example
when you are collecting the same kind of information about the task and system
state at the time the event happens.

In the tracing model that provides the use cases I am concerned with, a probe
or event triggering execution is equivalent to making a function call like
(in pseudo-code):

    process_probe(probe_id, args, ...)

where the probe_id identifies the actual probe that fired (and can be used to
access meta data about the probe, etc) and args captures the parameters that
are provided by the probe.

In this model kprobe/ksys_write and tracepoint/syscalls/sys_enter_write are
equivalent for most tracing purposes (because we provide function arguments
as args in the first one, and we provide the tracepoint parameters as args
in the second one).  When you are tracing the use of writes, it doesn't really
matter which of these two you attach the program to.

> Folks are already sharing the bpf progs between kprobe and networking.
> Currently it's done via code duplication and actual sharing happens via maps.
> That's not ideal, hence we've been discussing 'shared library' approach for
> quite some time. We need a way to support common bpf functions that can be called
> from networking and from tracing programs.

I agree with what you are saying but I am presenting an additional use case
that goes beyond providing providing a library of functions (though I
definitely have a use for that also).  I am hoping you have some suggestions
on how to accomplish that in view of your comment that tail_call isn't the way
to go. 

> > 2. Given that BPF programs are loaded with a specification of the prog type, 
> >    how would one load a code construct as the one you outline above?  How can
> >    you load a BPF function and have it be used as subprog from programs that
> >    are loaded separately?  I.e. in the sample above, if bpf_subprog is loaded
> >    as part of loading bpf_prog_kprobe (prog type KPROBE), how can it be
> >    referenced from bpf_prog_tracepoint (prog type TRACEPOINT) which would be
> >    loaded separately?
> 
> The api to support shared libraries was discussed, but not yet implemented.
> We've discussed 'FD + name' approach.
> FD identifies a loaded program (which is root program + a set of subprogs)
> and other programs can be loaded at any time later. The BPF_CALL instructions
> in such later program would refer to older subprogs via FD + name.
> Note that both tracing and networking progs can be part of single elf file.
> libbpf has to be smart to load progs into kernel step by step
> and reusing subprogs that are already loaded.

OK.

> Note that libbpf work for such feature can begin _without_ kernel changes.
> libbpf can pass bpf_prog_kprobe+bpf_subprog as a single program first,
> then pass bpf_prog_tracepoint+bpf_subprog second (as a separate program).
> The bpf_subprog will be duplicated and JITed twice, but sharing will happen
> because data structures (maps, global and static data) will be shared.
> This way the support for 'pseudo shared libraries' can begin.
> (later accompanied by FD+name kernel support)

Makes sense.

> There are other things we discsused. Ideally the body of bpf_subprog()
> wouldn't need to be kept around for future verification when this bpf
> function is called by a different program. The idea was to
> use BTF and similar mechanism to ongoing 'bounded loop' work.
> So the verifier can analyze bpf_subprog() once and reuse that knowledge
> for dynamic linking with progs that will be loaded later.
> This is more long term work.

Hm, yes.  You should be able to get away with just storing the access
constraints of pointer (ctx, map_value) arguments passed to the functions,
and verify whether they are compatible with the information obtained while
running the verifier on the caller.  For loop detection you're likely to
need more information as well though.  Definitely longer term work.

> A simple short term would be to verify the full call chain every time
> the subprog (bpf function) is reused.
> 
> All that aside the kernel support for shared libraries is an awesome
> feature to have and a bunch of folks want to see it happen, but
> it's not a blocker for 'dtrace to bpf' user space work.
> libbpf can be taught to do this 'pseudo shared library' feature
> while 'dtrace to bpf' side doesn't need to do anything special.
> It can generate normal elf file with bpf functions calling each other
> and have tracing, kprobes, etc in one .c file.
> Or don't generate .c file if you don't want to use clang/llvm.
> If you think "dtrace to bpf" can generate bpf directly then go for that.
> All such decisions are in user space and there is a freedom to course
> correct when direct bpf generation will turn out to be underperforming
> comparing to llvm generated code.

So you are basically saying that I should redesign DTrace?  The ability to
use shared functions is not sufficient for this use case.  It is also putting
a burden on the users where a single piece of script code may have to be
compiled into different BPF code because it is going to be attached to two
different probe types.

In my example earlier in this email, a simple script that would collect the
3 arguments to a write would (right now) require very different BPF code to
get to those arguments (let's assume we're on x86):

  kprobe: get them from the pt_regs structure and possibly the stack
  tracepoint: get them from the parameters stored in the context

If something breaks, you suddenly put the burden on the user to try to debug
two (or more) generated BPF programs, despite the fact that they came from
the same source code.  And on top of that the problem may turn out to be that
the tracepoint changed in the kernel, and the code generation wasn't updated
yet.

As you said before...  userspace shouldn't block kernel changes.  In addition,
I think that isolating kernel changes from userspace changes is a benefit to
both camps.  That's why the bpf syscall is a great benefit because you can
change how things are done at the kernel level, and userspace often doesn't
need to know you changed the implementation of e.g. attaching programs.
