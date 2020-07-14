Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E589E220058
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 23:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727978AbgGNV6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 17:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726361AbgGNV6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 17:58:14 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7987EC061755;
        Tue, 14 Jul 2020 14:58:14 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id z63so17130236qkb.8;
        Tue, 14 Jul 2020 14:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=okKraaXHWpaVXbZir4SLmPTXWMUq2GT5fFMNHwneQsM=;
        b=d5Y9zZ9axjSlL/bFlFvx41DGeZGNbjS2OND6d6IXgrddgf54blaPbkNU9nrDTKDi+v
         RdXu4fYrXHxWUSN7nXc9avSTZBT5AFzVSF8RSBq5C3x5+qq0sQheLX093ENwX2AlJXaa
         tpA62/UoZZyPNLHCikPBx6Dv8s1uZ3ExzYJ/2IQsMSpfJG0BidmGfqL4a2gpaoJGMt9N
         ecATLsgRdV6dxBLlfW/iBjvnBtNHnWr7BCeFLAjxXLi5QJe9z6nBE/471ppptJjpTWii
         0ognzt/Y6g6N0VPB49p2/GOGOZYbvq2vfGfZNtZj0Ef9ZOM+PlcC0emHsjOppHTQF32C
         Cydw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=okKraaXHWpaVXbZir4SLmPTXWMUq2GT5fFMNHwneQsM=;
        b=nf+x57rO1ui40p3WwKgTnJvRSuvhMgONsgMbKHd8HO/+lfMyHUX3rTWbZu6ovlQN8l
         ESEo/CLGVSl8WB2yQzftJBtxdOt4ScnT/Q52i/AKEz11O7vDPXBGndSFNjfECQQUHDIF
         0Xczq+lrd3cju8uLezcDbnfgUIqq8iWUKa2FxnMDw9oLjGsA4WkWsMDuNr101FHQiEAc
         sVi8s/86YGF7IRzNqU0a1ZTRMWRjUy/V1gbEMdePP0dIuzfMzvE51FAg2IyKn8YanxUr
         bWh6sBwBrATzIYEVulKgGu2QQ3Zhn5BaVMNIqLh4uoTWmn09YX9jUhgTHpTsmJkqHNYb
         pOjQ==
X-Gm-Message-State: AOAM531vX9HTA55r+Xsiljr8+lkmK1oL5thteY7nKbq8JYFU9PduHn2B
        Zg63mDwiakIP1BhbfEPPLfyNoZLhFD9cdqwR8F0=
X-Google-Smtp-Source: ABdhPJwbP8GUKEoVSW+dT/cMJdSWyNxMG6auh19e2hjSoXhcJ256uDbTPKGNXDfJGyX8deDWJfGBDLkmwLKrkFOsTuU=
X-Received: by 2002:a37:270e:: with SMTP id n14mr6593279qkn.92.1594763893467;
 Tue, 14 Jul 2020 14:58:13 -0700 (PDT)
MIME-Version: 1.0
References: <159467113970.370286.17656404860101110795.stgit@toke.dk>
 <159467114405.370286.1690821122507970067.stgit@toke.dk> <CAEf4BzZ_-vXP_3hSEjuceW10VX_H+EeuXMiV=_meBPZn7izK8A@mail.gmail.com>
 <87r1tegusj.fsf@toke.dk> <CAEf4Bzbu1wnwWFOWYA3e6KFeSmfg8oANPWD9LsUMRy2E_zrQ0w@mail.gmail.com>
 <87pn8xg6x7.fsf@toke.dk>
In-Reply-To: <87pn8xg6x7.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Jul 2020 14:58:02 -0700
Message-ID: <CAEf4BzYAoetyfyofTX45RQjtz3M-c9=YNeH1uRDbYgK4Ae0TwA@mail.gmail.com>
Subject: Re: BPF logging infrastructure. Was: [PATCH bpf-next 4/6] tools: add
 new members to bpf_attr.raw_tracepoint in bpf.h
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 1:47 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Tue, Jul 14, 2020 at 5:12 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>
> >> > On Mon, Jul 13, 2020 at 1:13 PM Toke H=C3=B8iland-J=C3=B8rgensen <to=
ke@redhat.com> wrote:
> >> >>
> >> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> >>
> >> >> Sync addition of new members from main kernel tree.
> >> >>
> >> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> >> ---
> >> >>  tools/include/uapi/linux/bpf.h |    9 +++++++--
> >> >>  1 file changed, 7 insertions(+), 2 deletions(-)
> >> >>
> >> >> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/li=
nux/bpf.h
> >> >> index da9bf35a26f8..662a15e4a1a1 100644
> >> >> --- a/tools/include/uapi/linux/bpf.h
> >> >> +++ b/tools/include/uapi/linux/bpf.h
> >> >> @@ -573,8 +573,13 @@ union bpf_attr {
> >> >>         } query;
> >> >>
> >> >>         struct { /* anonymous struct used by BPF_RAW_TRACEPOINT_OPE=
N command */
> >> >> -               __u64 name;
> >> >> -               __u32 prog_fd;
> >> >> +               __u64           name;
> >> >> +               __u32           prog_fd;
> >> >> +               __u32           log_level;      /* verbosity level =
of log */
> >> >> +               __u32           log_size;       /* size of user buf=
fer */
> >> >> +               __aligned_u64   log_buf;        /* user supplied bu=
ffer */
> >> >> +               __u32           tgt_prog_fd;
> >> >> +               __u32           tgt_btf_id;
> >> >>         } raw_tracepoint;
> >> >>
> >> >>         struct { /* anonymous struct for BPF_BTF_LOAD */
> >> >>
> >> >
> >> > I think BPF syscall would benefit from common/generalized log suppor=
t
> >> > across all commands, given how powerful/complex it already is.
> >> > Sometimes it's literally impossible to understand why one gets -EINV=
AL
> >> > without adding printk()s in the kernel.
> >>
> >> Yes, I agree! This is horrible UI!
> >
> > UI?.. It's a perfectly fine and extensible API for all functionality
> > it provides, it just needs a better human-readable feedback mechanism,
> > which is what I'm proposing. Error codes are not working when you have
> > so many different situations that can result in error.
>
> Yes. I was agreeing with you: the lack of understandable error messages
> means you have to play "guess where this EINVAL came from", which is a
> terrible user experience (should have been UX instead of UI, I guess,
> sorry about that).

Ah, ok, the term confused me :)

>
> >> > But it feels wrong to add log_level/log_size/log_buf fields to every
> >> > section of bpf_attr and require the user to specify it differently f=
or
> >> > each command. So before we go and start adding per-command fields,
> >> > let's discuss how we can do this more generically. I wonder if we ca=
n
> >> > come up with a good way to do it in one common way and then graduall=
y
> >> > support that way throughout all BPF commands.
> >> >
> >> > Unfortunately it's too late to just add a few common fields to
> >> > bpf_attr in front of all other per-command fields, but here's two mo=
re
> >> > ideas just to start discussion. I hope someone can come up with
> >> > something nicer.
> >> >
> >> > 1. Currently bpf syscall accepts 3 input arguments (cmd, uattr, size=
).
> >> > We can extend it with two more optional arguments: one for pointer t=
o
> >> > log-defining attr (for log_buf pointer, log_size, log_level, maybe
> >> > something more later) and another for the size of that log attr.
> >> > Beyond that we'd need some way to specify that the user actually mea=
nt
> >> > to provide those 2 optional args. The most straightforward way would
> >> > be to use the highest bit of cmd argument. So instead of calling bpf=
()
> >> > with BPF_MAP_CREATE command, you'd call it with BPF_MAP_CREATE |
> >> > BPF_LOGGED, where BPF_LOGGED =3D 1<<31.
> >>
> >> Well, if only we'd had a 'flags' argument to the syscall... I don't
> >> suppose we want a bpf2()? :)
> >>
> >> I like your idea of just using the top bits of the 'cmd' field as flag
> >> bits, but in that case we should just define this explicitly, say
> >> '#define BPF_CMD_FLAGS_MASK 0xFFFF0000'?
> >
> > sure
> >
> >>
> >> And instead of adding new arguments, why not just change the meaning o=
f
> >> the 'attr' argument? Say we define:
> >>
> >> struct bpf_extended_attr {
> >>        __u32 log_level;
> >>        __u32 log_size;
> >>        __aligned_u64 log_buf;
> >>        __u8 reserved[48];
> >>        union bpf_attr attr;
> >> };
> >
> > because this is a major PITA for libraries, plus it's not very
> > extensible, once you run out of 48 bytes? And when you don't need
> > those 48 bytes, you still need to zero them out, the kernel still
> > needs to copy them, etc. It just feels unclean to me.
> >
> > But before we argue that, is there a problem adding 2 more arguments
> > which are never used/read unless we have an extra bit set in cmd?
> > Honest question, are there any implications to user-space with such an
> > approach? Backwards-compatibility issues or anything?
>
> No idea; I don't know enough about how the lower-level details of the
> syscall interface works to tell either way. Is it even *possible* to add
> arguments like that in a backwards-compatible way?
>
> However, assuming it *is* possible, my larger point was that we
> shouldn't add just a 'logging struct', but rather a 'common options
> struct' which can be extended further as needed. And if it is *not*
> possible to add new arguments to a syscall like you're proposing, my
> suggestion above would be a different way to achieve basically the same
> (at the cost of having to specify the maximum reserved space in advance).
>

yeah-yeah, I agree, it's less a "logging attr", more of "common attr
across all commands".

> >> And then define a new flag BPF_USES_EXTENDED_ATTR which will cause the
> >> kernel to interpret the second argument of the syscall as a pointer to
> >> that struct instead of to the bpf_attr union?
> >>
> >> > 2. A more "stateful" approach, would be to have an extra BPF command
> >> > to set log buffer (and level) per thread. And if such a log is set, =
it
> >> > would be overwritten with content on each bpf() syscall invocation
> >> > (i.e., log position would be reset to 0 on each BPF syscall).
> >>
> >> I don't think adding something stateful is a good idea; that's bound t=
o
> >> lead to weird issues when someone messes up the state management in
> >> userspace.
> >
> > I agree, I'd prefer a stateless approach, but wanted to lay out a
> > stateful one for completeness as well.
>
> OK, cool.
>
> >>
> >> > Of course, the existing BPF_LOAD_PROG command would keep working wit=
h
> >> > existing log, but could fall back to the "common one", if
> >> > BPF_LOAD_PROG-specific one is not set.
> >> >
> >> > It also doesn't seem to be all that critical to signal when the log
> >> > buffer is overflown. It's pretty easy to detect from user-space:
> >> > - either last byte would be non-zero, if we don't care about
> >> > guaranteeing zero-termination for truncated log;
> >> > - of second-to-last byte would be non-zero, if BPF syscall will alwa=
ys
> >> > zero-terminate the log.
> >>
> >> I think if we're doing this we should think about making the contents =
of
> >> the log machine-readable, so applications can figure out what's going =
on
> >> without having to parse the text strings. The simplest would be to mak=
e
> >> this new log buffer use TLV-style messaging, say we define the log
> >> buffer output to be a series of messages like these:
> >>
> >> struct bpf_log_msg {
> >>        __u16 type;
> >>        __u32 len;
> >>        __u8 contents[]; /* of size 'len' */
> >> } __attribute__((packed));
> >>
> >> To begin with we could define two types:
> >>
> >> struct bpf_log_msg_string {
> >>        __u16 type; /* BPF_LOG_MSG_TYPE_STRING */
> >>        __u32 len;
> >>        char message[];
> >> }  __attribute__((packed));
> >>
> >> struct bpf_log_msg_end {
> >>        __u16 type; /* BPF_LOG_MSG_TYPE_END */
> >>        __u32 len;
> >>        __u16 num_truncations;
> >> }  __attribute__((packed));
> >>
> >> The TYPE_STRING would just be a wrapper for the existing text-based
> >> messages, but delimited so userspace can pick them apart. And the seco=
nd
> >> one would solve your 'has the log been truncated' issue above; the
> >> kernel simply always reserves eight bytes at the end of the buffer and
> >> ends with writing a TYPE_END message with the number of messages that
> >> were dropped due to lack of space. That would make it trivial for
> >> userspace to detect truncation.
> >>
> >
> > Log truncation is not an issue, we can make bpf syscall to write back
> > the actual size of emitted log (and optionally extra bool to mean
> > "truncated") into the original log_size field.
>
> So what was all that you were talking about with "check the
> second-to-last byte" in your previous email? I understood that to be
> about detecting truncation?

Yeah, ignore my initial rambling. One can do that (detecting
truncationg) without any extra "feedback" from bpf syscall, but I
think returning filled length is probably a better approach and
doesn't hamper any other aspects.

>
> >> We could then add new message types later for machine-consumption. Say=
,
> >> and extended error code, or offsets into the BTF information, or
> >> whatever we end up needing. But just wrapping the existing log message=
s
> >> in TLVs like the ones above could be fairly straight-forwardly
> >> implemented with the existing bpf_log() infrastructure in the kernel,
> >> without having to settle on which machine-readable information is usef=
ul
> >> ahead of time... And the TLV format makes it easy for userspace to jus=
t
> >> skip message types it doesn't understand.
> >>
> >> WDYT?
> >
> > I think it's taking it a bit too far and adds more API on top of
> > existing API. Now all those types become a fixed API, messages become
> > an API, etc. Just more backwards compatibility stuff we need to
> > support forever, for, what I believe, very little gain.
> >
> > In practice, using human-readable strings works just fine. If there is
> > any kind of real issue, usually it involves humans reading debug logs
> > and understanding what's going on.
>
> Let me give an example of what I want to be able to do. Just today I
> helped someone debug getting xdp-filter to run, and they were getting
> output like this:
>
>       libbpf: -- BEGIN DUMP LOG ---
>       libbpf:
>       xdpfilt_alw_all() is not a global function
>       processed 0 insns (limit 1000000) max_states_per_insn 0 total_state=
s 0
>       peak_states 0 mark_read 0
>
>       libbpf: -- END LOG --
>
> I would like to have xdp-filter catch that, and turn it into a
> friendlier "your compiler is too old" message. Having to effectively
> grep through the free-form log output to pick out that message feels
> brittle and error prone, as opposed to just having the kernel add a
> machine-readable id ("err_func_linkage_not_global" or somesuch) and
> stick it in a machine-parsable TLV.

Yeah, I guessed as much, but I still think it's unnecessarily
restrictive (for BPF kernel developers) to adhere to such a rigorous
error format. We'll have a few hundred different failure reasons, and
with the verifier constantly evolving some of them might get
deprecated, others will be constantly added, some other might change
the meaning, etc. I don't see this realistically working long term. So
at that point, free-form text-delimited text is as good as we should
(and, realistically, would) probably go. Library, if it wants to be
extra-helpful, can still reasonably easily parse line-delimited text,
even if that's not an ideal setup (especially if error messages will
get periodically changed).

But I'd be happy to hear what others think on this matter as well, of cours=
e.

>
> > Also adopting these packet-like messages is not as straightforward
> > through BPF code, as now you can't just construct a single log line
> > with few calls to bpf_log().
>
> Why not? bpf_log() could just transparently write the four bytes of
> header (TYPE_STRING, followed by strlen(msg)) into the buffer before the
> string? And in the future, an enhanced version could take (say) an error
> ID as another parameter and transparently add that as a separate message.

I mean when you construct one error message with few printf-like
functions. We do have that in libbpf, but I haven't checked the
verifier code. Basically, assuming one bpf_log() call is a complete
"message" might not be true.

>
> >> > Of course, if user code cares about such detection of log truncation=
,
> >> > it will need to set last/second-to-last bytes to zero before each
> >> > syscall.
> >> >
> >> > Both approaches have their pros/cons, we can dig into those later, b=
ut
> >> > I'd like to start this discussion and see what other people think. I
> >> > also wonder if there are other syscalls with similarly advanced inpu=
t
> >> > arguments (like bpf_attr) and common logging, we could learn from
> >> > those.
> >>
> >> The first one that comes to mind is netlink extacks. Of course it's no=
t
> >> quite comparable since netlink already has message-based semantics, bu=
t
> >> it does do sorta-kinda the same thing from a user PoV. The TLV format =
is
> >> obviously inspired by netlink (or, well, binary networking protocols i=
n
> >> general).
> >>
> >
> > Yeah, I'm aware of extack, but as you said, TLV is more of a netlink
> > format, extack messages themselves are just strings. But my question
> > was more of how this log could be done for complicated API calls using
> > similar extendable attrs, like perf_event_open, clone3, openat2, etc.
>
> Ah, right, no idea :)
>
> -Toke
>
