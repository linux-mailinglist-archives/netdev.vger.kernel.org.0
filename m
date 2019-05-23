Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92BB128B7B
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 22:28:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387589AbfEWU2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 16:28:48 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43583 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbfEWU2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 16:28:48 -0400
Received: by mail-pf1-f193.google.com with SMTP id c6so3865615pfa.10;
        Thu, 23 May 2019 13:28:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3LWXAg2JAqUAn8KpFRq4/w58Tb8mZHmIEoAeBv3lseg=;
        b=Arw/XfxennsrGx6pknQ7CQuhlzgcdk1EyRrs3eVlXWQjHkYC6KaGRxAijUNocVM5pW
         QpsJMKld4dhmsTx7QobGJ/GTl1F8A5sepiLEGBq/uiiFoqp5S0UOVu4LgRBdWMG19e4o
         gBZAT/0hdT/Z/ccXvg7+cXZrmKSu6UPB9j/Yk7wne7e5xmbYGKnzm9lCiahz+dV/m6R1
         E9KxjEJRv2E7R1O3tXjdDR+0qmWwZHER6TlziTut1oeJE+jdi+4UZK3eglQovU3JdtWa
         /QtMwDoMWcXywgy/LE1ol1wry+dgl232qjWyoVcLJwdpQ3qJFIZow5fMtFkmY3h+qsyn
         a4Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3LWXAg2JAqUAn8KpFRq4/w58Tb8mZHmIEoAeBv3lseg=;
        b=Ymv6aFiTy7zKPGHyIaB266qarE9rsWdhSsSV5P/b7CA6bgd++yQKUDPppQ/0/MPyMk
         PlDM+U2VpQK3sy6tpygGQakw/jma74VGKWkpto/FYqpm3XO1iaEwix+eKTEELapRdWqx
         KveVBdVBdLZJJw2YhiXUTeqo88vh1nBN349rILOJAU33Wl+gYj/lHR7XXuqUo5A5XSWw
         2BGYmLcTjePVVNHnbRB63kqLKUaVoGLJYahUCnbOXTdRBNSgoomqUwJ1CyIyEsgmKM+S
         WwNV7qnQoxw1yYL7S0u5tBpWAo8vvBGJ+4Qw14TLMakk3tmRnrAE86+xXMpUwynw+2CY
         S2cA==
X-Gm-Message-State: APjAAAWZrts6BBG2TcwAklWuW3xWadbmB60Y4slm0eqdySbl6/OGqRdy
        vIe9GrX97+M/EkOdG9xYcZI4XLPW
X-Google-Smtp-Source: APXvYqxIZDKtQqdaI9Nm9CGCcxgYYAY1lBcrqoWj1UEkFHegr8aobwLpF9HtMxfj0FhGNTYKCT8UYg==
X-Received: by 2002:a63:7d18:: with SMTP id y24mr87436299pgc.101.1558643327470;
        Thu, 23 May 2019 13:28:47 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:d5a9])
        by smtp.gmail.com with ESMTPSA id y10sm323358pff.4.2019.05.23.13.28.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 13:28:46 -0700 (PDT)
Date:   Thu, 23 May 2019 13:28:44 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kris Van Hees <kris.van.hees@oracle.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        dtrace-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, mhiramat@kernel.org, acme@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, peterz@infradead.org
Subject: Re: [RFC PATCH 00/11] bpf, trace, dtrace: DTrace BPF program type
 implementation and sample use
Message-ID: <20190523202842.ij2quhpmem3nabii@ast-mbp.dhcp.thefacebook.com>
References: <201905202347.x4KNl0cs030532@aserv0121.oracle.com>
 <20190521175617.ipry6ue7o24a2e6n@ast-mbp.dhcp.thefacebook.com>
 <20190521184137.GH2422@oracle.com>
 <20190521205533.evfszcjvdouby7vp@ast-mbp.dhcp.thefacebook.com>
 <20190521213648.GK2422@oracle.com>
 <20190521232618.xyo6w3e6nkwu3h5v@ast-mbp.dhcp.thefacebook.com>
 <20190522041253.GM2422@oracle.com>
 <20190522201624.eza3pe2v55sn2t2w@ast-mbp.dhcp.thefacebook.com>
 <20190523051608.GP2422@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523051608.GP2422@oracle.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 01:16:08AM -0400, Kris Van Hees wrote:
> On Wed, May 22, 2019 at 01:16:25PM -0700, Alexei Starovoitov wrote:
> > On Wed, May 22, 2019 at 12:12:53AM -0400, Kris Van Hees wrote:
> > > 
> > > Could you elaborate on why you believe my patches are not adding generic
> > > features?  I can certainly agree that the DTrace-specific portions are less
> > > generic (although they are certainly available for anyone to use), but I
> > > don't quite understand why the new features are deemed non-generic and why
> > > you believe no one else can use this?
> > 
> > And once again your statement above contradicts your own patches.
> > The patch 2 adds new prog type BPF_PROG_TYPE_DTRACE and the rest of the patches
> > are tying everything to it.
> > This approach contradicts bpf philosophy of being generic execution engine
> > and not favoriting one program type vs another.
> 
> I am not sure I understand where you see a contradiction.  What I posted is
> a generic feature, and sample code that demonstrates how it can be used based
> on the use-case that I am currently working on.  So yes, the sample code is
> very specific but it does not restrict the use of the cross-prog-type tail-call
> feature.  That feature is designed to be generic.
> 
> Probes come in different types (kprobe, tracepoint, perf event, ...) and they
> each have their own very specific data associated with them.  I agree 100%
> with you on that.  And sometimes tracing makes use of those specifics.  But
> even from looking at the implementation of the various probe related prog
> types (and e.g. the list of helpers they each support) it shows that there is
> a lot of commonality as well.  That common functionality is common to all the
> probe program types, and that is where I suggest introducing a program type
> that captures the common concept of a probe, so perhaps a better name would
> be BPF_PROG_TYPE_PROBE.
> 
> The principle remains the same though...  I am proposing adding support for
> program types that provide common functionality so that programs for various
> program types can make use of the more generic programs stored in prog arrays.

Except that prog array is indirect call based and got awfully slow due
to retpoline and we're trying to redesign the whole tail_call approach.
So more extensions to tail_call facility is the opposite of that direction.

> > I have nothing against dtrace language and dtrace scripts.
> > Go ahead and compile them into bpf.
> > All patches to improve bpf infrastructure are very welcomed.
> > 
> > In particular you brought up a good point that there is a use case
> > for sharing a piece of bpf program between kprobe and tracepoint events.
> > The better way to do that is via bpf2bpf call.
> > Example:
> > void bpf_subprog(arbitrary args)
> > {
> > }
> > 
> > SEC("kprobe/__set_task_comm")
> > int bpf_prog_kprobe(struct pt_regs *ctx)
> > {
> >   bpf_subprog(...);
> > }
> > 
> > SEC("tracepoint/sched/sched_switch")
> > int bpf_prog_tracepoint(struct sched_switch_args *ctx)
> > {
> >   bpf_subprog(...);
> > }
> > 
> > Such configuration is not supported by the verifier yet.
> > We've been discussing it for some time, but no work has started,
> > since there was no concrete use case.
> > If you can work on adding support for it everyone will benefit.
> > 
> > Could you please consider doing that as a step forward?
> 
> This definitely looks to be an interesting addition and I am happy to look into
> that further.  I have a few questions that I hope you can shed light on...
> 
> 1. What context would bpf_subprog execute with?  If it can be called from
>    multiple different prog types, would it see whichever context the caller
>    is executing with?  Or would you envision bpf_subprog to not be allowed to
>    access the execution context because it cannot know which one is in use?

bpf_subprog() won't be able to access 'ctx' pointer _if_ it's ambiguous.
The verifier already smart enough to track all the data flow, so it's fine to
pass 'struct pt_regs *ctx' as long as it's accessed safely.
For example:
void bpf_subprog(int kind, struct pt_regs *ctx1, struct sched_switch_args *ctx2)
{
  if (kind == 1)
     bpf_printk("%d", ctx1->pc);
  if (kind == 2)
     bpf_printk("%d", ctx2->next_pid);
}

SEC("kprobe/__set_task_comm")
int bpf_prog_kprobe(struct pt_regs *ctx)
{
  bpf_subprog(1, ctx, NULL);
}

SEC("tracepoint/sched/sched_switch")
int bpf_prog_tracepoint(struct sched_switch_args *ctx)
{
  bpf_subprog(2, NULL, ctx);
}

The verifier should be able to prove that the above is correct.
It can do so already if s/ctx1/map_value1/, s/ctx2/map_value2/
What's missing is an ability to have more than one 'starting' or 'root caller'
program.

Now replace SEC("tracepoint/sched/sched_switch") with SEC("cgroup/ingress")
and it's becoming clear that BPF_PROG_TYPE_PROBE approach is not good enough, right?
Folks are already sharing the bpf progs between kprobe and networking.
Currently it's done via code duplication and actual sharing happens via maps.
That's not ideal, hence we've been discussing 'shared library' approach for
quite some time. We need a way to support common bpf functions that can be called
from networking and from tracing programs.

> 2. Given that BPF programs are loaded with a specification of the prog type, 
>    how would one load a code construct as the one you outline above?  How can
>    you load a BPF function and have it be used as subprog from programs that
>    are loaded separately?  I.e. in the sample above, if bpf_subprog is loaded
>    as part of loading bpf_prog_kprobe (prog type KPROBE), how can it be
>    referenced from bpf_prog_tracepoint (prog type TRACEPOINT) which would be
>    loaded separately?

The api to support shared libraries was discussed, but not yet implemented.
We've discussed 'FD + name' approach.
FD identifies a loaded program (which is root program + a set of subprogs)
and other programs can be loaded at any time later. The BPF_CALL instructions
in such later program would refer to older subprogs via FD + name.
Note that both tracing and networking progs can be part of single elf file.
libbpf has to be smart to load progs into kernel step by step
and reusing subprogs that are already loaded.

Note that libbpf work for such feature can begin _without_ kernel changes.
libbpf can pass bpf_prog_kprobe+bpf_subprog as a single program first,
then pass bpf_prog_tracepoint+bpf_subprog second (as a separate program).
The bpf_subprog will be duplicated and JITed twice, but sharing will happen
because data structures (maps, global and static data) will be shared.
This way the support for 'pseudo shared libraries' can begin.
(later accompanied by FD+name kernel support)

There are other things we discsused. Ideally the body of bpf_subprog()
wouldn't need to be kept around for future verification when this bpf
function is called by a different program. The idea was to
use BTF and similar mechanism to ongoing 'bounded loop' work.
So the verifier can analyze bpf_subprog() once and reuse that knowledge
for dynamic linking with progs that will be loaded later.
This is more long term work.
A simple short term would be to verify the full call chain every time
the subprog (bpf function) is reused.

All that aside the kernel support for shared libraries is an awesome
feature to have and a bunch of folks want to see it happen, but
it's not a blocker for 'dtrace to bpf' user space work.
libbpf can be taught to do this 'pseudo shared library' feature
while 'dtrace to bpf' side doesn't need to do anything special.
It can generate normal elf file with bpf functions calling each other
and have tracing, kprobes, etc in one .c file.
Or don't generate .c file if you don't want to use clang/llvm.
If you think "dtrace to bpf" can generate bpf directly then go for that.
All such decisions are in user space and there is a freedom to course
correct when direct bpf generation will turn out to be underperforming
comparing to llvm generated code.

