Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5C845F0DC
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 02:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfGDA5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 20:57:18 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:43844 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbfGDA5S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 20:57:18 -0400
Received: by mail-qk1-f195.google.com with SMTP id m14so4343881qka.10;
        Wed, 03 Jul 2019 17:57:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wbnlr4MNFbOiQmkaqdz81ucGEMdNpAtp6Omr2DXzS1A=;
        b=r9cm42hDEDamyfQq03HnoYxq5A/NtpR2+vwXsbAYhLmk+mMFJbzemzVBLg5IG2mIiX
         6WJauX8HE1PP+GJOnsG8X/Kf1M+FiIBHHqYORKLulKUMSUx0sXIy+QJAmClpkrmpWp6K
         ueB+6E0LMuCAVatH5C3Bii1E9zR1K2ETYM2DM2NWCdn3dpXRtVmcYxpoipUOJ813RuFr
         uesT15HQLYpglOOwje+K3VwehgzT6DG+4G6pikW8j/SXuTOjPSpY8pR93jbJX7wZKshy
         PT/3ePAx6KPNPXeC+Ynef16J7U32xZF2EFxLLyjoZy67XEo5L7083J/fPFEc4+4bFqT9
         O5oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wbnlr4MNFbOiQmkaqdz81ucGEMdNpAtp6Omr2DXzS1A=;
        b=Ozb6r+YHw9JmzjRaiPdLKwZcMpHteUoCOaF0iOM6L0A/oG3/zAh9F368s+/Ex2hP5M
         6WJCU6kMRX65AKN0yJbgyK7eCG1UnaQCJ+Ag5hnXpPHjXbn2XxtP6+Z+8IxmxZCw0KwE
         wzUo4ecJGRxvS9+vmc9zexoZUA7wmCkb7zIjSv5pJvAnFD0vGilk5hbu0PwmoQ2/Qejh
         sMrqPyYoJJZyxG9IRNIBui2KVvBgJalXarlfu+4jfMv1VJDFUPuUregyQej8d86JCK7/
         p3qqwdZ1mN2pF4BpENNV8l51ZDzWKQ0Xx3KxmRGySv2vIKthCmvtLGtL6Cod21snIrJA
         sJPA==
X-Gm-Message-State: APjAAAVG/iIsJX8PfGrdJKX5vRn43ODRgQOW+7zMPgN7yMDwM5iD/C6u
        Bpwm6ZbK2Quzhb+lpyCGVaOhqgzae+vrBpLShdI=
X-Google-Smtp-Source: APXvYqyydUyicQXwFhHFIzpqJzxR5LFTIWtKSGu9NgEXyBc62LbXNHs5gIO5T0EoL77LB9FBZB6Lwk3WSJy56T1Pspw=
X-Received: by 2002:a37:660d:: with SMTP id a13mr5149124qkc.36.1562201836524;
 Wed, 03 Jul 2019 17:57:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190701235903.660141-1-andriin@fb.com> <20190701235903.660141-5-andriin@fb.com>
 <5e494d84-5db9-3d57-ccb3-c619cbae7833@iogearbox.net> <CAEf4BzaHM5432VS-1wDxKJXr7U-9zkM+A_XsU+1p77YCd8VRgg@mail.gmail.com>
In-Reply-To: <CAEf4BzaHM5432VS-1wDxKJXr7U-9zkM+A_XsU+1p77YCd8VRgg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 3 Jul 2019 17:57:04 -0700
Message-ID: <CAEf4BzaUeLDgwzBc0EbXnzahe8wxf9CNVFa_isgRp8rwJ0OSjQ@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 4/9] libbpf: add kprobe/uprobe attach API
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 3, 2019 at 9:47 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, Jul 3, 2019 at 5:39 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On 07/02/2019 01:58 AM, Andrii Nakryiko wrote:
> > > Add ability to attach to kernel and user probes and retprobes.
> > > Implementation depends on perf event support for kprobes/uprobes.
> > >
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > Reviewed-by: Stanislav Fomichev <sdf@google.com>
> > > ---

<snip>

> > > +}
> >
> > Hm, this only addresses half the feedback I had in prior version [0]. Patch 2/9
>
> Hi Daniel,
>
> Yes, and I explained why in reply to your original email, please see [1].
>
> I've started with exactly separation you wanted, but it turned out to
> be cumbersome and harder to use user API, while also somewhat more
> complicated to implement. Mostly because in that design bpf_link
> exists in two states: created-but-not-attached and attached. Which
> forces user to do additional clean ups if creation succeeded, but
> attachment failed. It also makes it a bit harder to provide good
> contextual error logging if something goes wrong, because not all
> original parameters are preserved, as some of them might be needed
> only for creation, but not attachment (or we'll have to allocate and
> copy extra stuff just for logging purposes).
>
> On the other hand, having separate generic attach_event method doesn't
> help that much, as there is little common functionality to reuse
> across all kinds of possible bpf_link types.
>
>
>   [1] https://lore.kernel.org/bpf/20190621045555.4152743-4-andriin@fb.com/T/#m6cfc141e7b57970bc948134bf671a46972b95134
>
> > with bpf_link with destructor looks good to me, but my feedback from back then was
> > that all the kprobe/uprobe/tracepoint/raw_tracepoint should be split API-wise, so
> > you'll end up with something like the below, that is, 1) a set of functions that
> > only /create/ the bpf_link handle /once/, and 2) a helper that allows /attaching/
> > progs to one or multiple bpf_links. The set of APIs would look like:
> >
> > struct bpf_link *bpf_link__create_kprobe(bool retprobe, const char *func_name);
> > struct bpf_link *bpf_link__create_uprobe(bool retprobe, pid_t pid,
> >                                          const char *binary_path,
> >                                          size_t func_offset);
> > int bpf_program__attach_to_link(struct bpf_link *link, struct bpf_program *prog);
> > int bpf_link__destroy(struct bpf_link *link);
> >
> > This seems much more natural to me. Right now you sort of do both in one single API.
>
> It felt that way for me as well, until I implemented it and used it in
> selftests. And then it felt unnecessarily verbose without giving any
> benefit. I still have a local patchset with that change, I can post it
> as RFC, if you don't trust my judgement. Please let me know.
>
> > Detangling the bpf_program__attach_{uprobe,kprobe}() would also avoid that you have
> > to redo all the perf_event_open_probe() work over and over in order to get the pfd

So re-reading this again, I wonder if you meant that with separate
bpf_link (or rather bpf_hook in that case) creation and attachment
operations, one would be able to create single bpf_hook for same
kprobe and then attach multiple BPF programs to that single pfd
representing that specific probe.

If that's how I should have read it, I agree that it probably would be
possible for some types of hooks, but not for every type of hook. But
furthermore, how often in practice same application attaches many
different BPF programs to the same hook? And it's also hard to imagine
that hook creation (i.e., creating such FD for BPF hook), would ever
be a bottleneck.

So I still think it's not a strong reason to go with API that's harder
to use for typical use cases just because of hypothetical benefits in
some extreme cases.

>
> What do you mean by "redo all the perf_event_open_probe work"? In
> terms of code, I just reuse the same function, so there is no
> duplicate code. And in either design you'll have to open that
> perf_event, so that work will have to be done one way or another.
>
> > context where you can later attach something to. Given bpf_program__attach_to_link()
> > API, you also wouldn't need to expose the bpf_program__attach_perf_event() from
>
> I'd expose attach_perf_event either way, it's high-level API I want to
> provide, we have use cases where user is creating some specific
> non-kprobe/non-tracepoint perf events and wants to attach to it. E.g.,
> HW counter overflow events for CPU profilers. So that API is not some
> kind of leaked abstraction, it's something I want to have anyway.
>
>
> > patch 3/9. Thoughts?
>
> I believe this hybrid approach provides better usability without
> compromising anything. The only theoretical benefit of complete
> separation of bpf_link creation and attachment is that user code would
> be able to separate those two steps code organization-wise. But it's
> easily doable through custom application code (just encapsulate all
> the parameters and type of attachment and pass it around until you
> actually need to attach), but I don't think it's necessary in practice
> (so far I never needed anything like that).
>
> Hope I convinced you that while elegant, it's not that practical. Also
> hybrid approach isn't inelegant either and doesn't produce code
> duplication (it actually eliminates some unnecessary allocations,
> e.g., for storing tp_name for raw_tracepoint attach) :)
>
> >
> >   [0] https://lore.kernel.org/bpf/a7780057-1d70-9ace-960b-ff65867dc277@iogearbox.net/
> >
> > >  enum bpf_perf_event_ret
> > >  bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
> > >                          void **copy_mem, size_t *copy_size,
> > > diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> > > index 1bf66c4a9330..bd767cc11967 100644
> > > --- a/tools/lib/bpf/libbpf.h
> > > +++ b/tools/lib/bpf/libbpf.h
> > > @@ -171,6 +171,13 @@ LIBBPF_API int bpf_link__destroy(struct bpf_link *link);
> > >
> > >  LIBBPF_API struct bpf_link *
> > >  bpf_program__attach_perf_event(struct bpf_program *prog, int pfd);
> > > +LIBBPF_API struct bpf_link *
> > > +bpf_program__attach_kprobe(struct bpf_program *prog, bool retprobe,
> > > +                        const char *func_name);
> > > +LIBBPF_API struct bpf_link *
> > > +bpf_program__attach_uprobe(struct bpf_program *prog, bool retprobe,
> > > +                        pid_t pid, const char *binary_path,
> > > +                        size_t func_offset);
> > >
> > >  struct bpf_insn;
> > >
> > > diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> > > index 756f5aa802e9..57a40fb60718 100644
> > > --- a/tools/lib/bpf/libbpf.map
> > > +++ b/tools/lib/bpf/libbpf.map
> > > @@ -169,7 +169,9 @@ LIBBPF_0.0.4 {
> > >       global:
> > >               bpf_link__destroy;
> > >               bpf_object__load_xattr;
> > > +             bpf_program__attach_kprobe;
> > >               bpf_program__attach_perf_event;
> > > +             bpf_program__attach_uprobe;
> > >               btf_dump__dump_type;
> > >               btf_dump__free;
> > >               btf_dump__new;
> > >
> >
