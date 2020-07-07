Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20748217591
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 19:49:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbgGGRth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 13:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728404AbgGGRte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 13:49:34 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DCA2C061755;
        Tue,  7 Jul 2020 10:49:34 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id h18so19216558qvl.3;
        Tue, 07 Jul 2020 10:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3A9pj/+sDYtaBhomGrTHi/WUOTb74PSiC/HfOmJjW14=;
        b=gJPHZ3UWU8w8Dm/sJn1RXPqHp3zQGIHQFn+jZnl/eGc3uXdlDvsMZrWp5Xe/iTOOzJ
         9WZBaxX4tAq6LSWVbNX55qYHrmmiyuo+cpTUuPqJQ4QAQ3oIKzypnahVOxIYK4jTXxyH
         wjUCZUtWMqa5fEkNwSypDiF3jL0jnckLAk2ibxvRbhBV8IxOJtea0X/S8ztq1VGMmLJD
         vtjYvs2BL/QopwGX2m2gySyY+CiWrQwdbV9k5P98AT/+Zt7HhFbBytZhqtlcuKoqMnnO
         oZrwuPFnwB1Uny82nCL+oj04zi7Wv+uxQ50vA/Fu05FMtHW4yVEFnaTTzNrIi6oh34vi
         2nRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3A9pj/+sDYtaBhomGrTHi/WUOTb74PSiC/HfOmJjW14=;
        b=J9r3j7D4RExs3/dINshuNHRqD6PH0c2I+Ep5+F5W7JTjFIzdGdd3OVBIvIiQ4mKjw5
         3bj/5Umdow4pYDdadFLKXeOKqu1LTslok1+PsxxAdhSy0l/iIyZd54GNwWeFF6hQWfrJ
         +BSQqyvgONguMjfP/Iyn/xUwQsq2Tgl/QilF+MUXN/oZOmY5QvMOWdjAh4LHV4m6Mqe6
         xrRlQxKHvDpt9iYOKj3RADEAzJrf6cVoQbTnhhU9+Bv0JzOt1TutfSaKOSIudyVVh8V4
         6sIt7+/7NbGNvvwY7wPrOJBidR8DjxMHt8KNP19xxPMl3CwQTrlY5kdgjIm8gG5pnEnO
         0PkA==
X-Gm-Message-State: AOAM532i8NhL8dFGhLkjrIT3X9ugH5PQuiv6+Epdrv8OT15rNYx4MA0H
        sVLGxcnORB0WkVqBI1S76k661v3S0L2/2Oq4z4A=
X-Google-Smtp-Source: ABdhPJwpgAdg0XLESfNsVoQN5Z+oZOVlu1shESUM6aVfeAdDbkXBFf4Q3RogUcHlbqlcS62CELGU7SQ0tDXp4DyOuxw=
X-Received: by 2002:a05:6214:8f4:: with SMTP id dr20mr50215654qvb.228.1594144173515;
 Tue, 07 Jul 2020 10:49:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200703095111.3268961-1-jolsa@kernel.org> <20200703095111.3268961-10-jolsa@kernel.org>
 <CAEf4BzYuDU2mARcP5GVAv+WiknSnWuzGyNqQx0TiJ23CWA8NiA@mail.gmail.com> <20200707155720.GI3424581@krava>
In-Reply-To: <20200707155720.GI3424581@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 7 Jul 2020 10:49:22 -0700
Message-ID: <CAEf4BzYYHEwDZ9YqqyfzSZsk-8=DrL-WVEee-gisBLQRZWUTHw@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 9/9] selftests/bpf: Add test for resolve_btfids
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 7, 2020 at 8:57 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Mon, Jul 06, 2020 at 06:26:28PM -0700, Andrii Nakryiko wrote:
> > On Fri, Jul 3, 2020 at 2:54 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > >
> > > Adding resolve_btfids test under test_progs suite.
> > >
> > > It's possible to use btf_ids.h header and its logic in
> > > user space application, so we can add easy test for it.
> > >
> > > The test defines BTF_ID_LIST and checks it gets properly
> > > resolved.
> > >
> > > For this reason the test_progs binary (and other binaries
> > > that use TRUNNER* macros) is processed with resolve_btfids
> > > tool, which resolves BTF IDs in .BTF.ids section.
> > >
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  tools/testing/selftests/bpf/Makefile          |  22 ++-
> > >  .../selftests/bpf/prog_tests/resolve_btfids.c | 170 ++++++++++++++++++
> > >  2 files changed, 190 insertions(+), 2 deletions(-)
> > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
> > >
> > > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > > index 1f9c696b3edf..b47a685d12bd 100644
> > > --- a/tools/testing/selftests/bpf/Makefile
> > > +++ b/tools/testing/selftests/bpf/Makefile
> > > @@ -190,6 +190,16 @@ else
> > >         cp "$(VMLINUX_H)" $@
> > >  endif
> > >
> > > +$(SCRATCH_DIR)/resolve_btfids: $(BPFOBJ)                               \
> > > +                              $(TOOLSDIR)/bpf/resolve_btfids/main.c    \
> > > +                              $(TOOLSDIR)/lib/rbtree.c                 \
> > > +                              $(TOOLSDIR)/lib/zalloc.c                 \
> > > +                              $(TOOLSDIR)/lib/string.c                 \
> > > +                              $(TOOLSDIR)/lib/ctype.c                  \
> > > +                              $(TOOLSDIR)/lib/str_error_r.c
> > > +       $(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/resolve_btfids \
> > > +       OUTPUT=$(SCRATCH_DIR)/ BPFOBJ=$(BPFOBJ)
> > > +
> >
> > please indent OUTPUT, so it doesn't look like it's a separate command
>
> ok
>
> >
> > >  # Get Clang's default includes on this system, as opposed to those seen by
> > >  # '-target bpf'. This fixes "missing" files on some architectures/distros,
> > >  # such as asm/byteorder.h, asm/socket.h, asm/sockios.h, sys/cdefs.h etc.
> > > @@ -333,7 +343,8 @@ $(TRUNNER_TEST_OBJS): $(TRUNNER_OUTPUT)/%.test.o:                   \
> > >                       $(TRUNNER_BPF_SKELS)                              \
> > >                       $$(BPFOBJ) | $(TRUNNER_OUTPUT)
> > >         $$(call msg,TEST-OBJ,$(TRUNNER_BINARY),$$@)
> > > -       cd $$(@D) && $$(CC) -I. $$(CFLAGS) -c $(CURDIR)/$$< $$(LDLIBS) -o $$(@F)
> > > +       cd $$(@D) && $$(CC) -I. $$(CFLAGS) $(TRUNNER_EXTRA_CFLAGS)      \
> > > +       -c $(CURDIR)/$$< $$(LDLIBS) -o $$(@F)
> > >
> > >  $(TRUNNER_EXTRA_OBJS): $(TRUNNER_OUTPUT)/%.o:                          \
> > >                        %.c                                              \
> > > @@ -355,6 +366,7 @@ $(OUTPUT)/$(TRUNNER_BINARY): $(TRUNNER_TEST_OBJS)                   \
> > >                              | $(TRUNNER_BINARY)-extras
> > >         $$(call msg,BINARY,,$$@)
> > >         $$(CC) $$(CFLAGS) $$(filter %.a %.o,$$^) $$(LDLIBS) -o $$@
> > > +       $(TRUNNER_BINARY_EXTRA_CMD)
> >
> > no need to make this generic, just write out resolve_btfids here explicitly
>
> currently resolve_btfids fails if there's no .BTF.ids section found,
> but we can make it silently pass i nthis case and then we can invoke
> it for all the binaries

ah, I see. Yeah, either we can add an option to resolve_btfids to not
error when .BTF_ids is missing (probably best), or we can check
whether the test has .BTF_ids section, and if it does - run
resolve_btfids on it. Just ignoring errors always is more error-prone,
because we won't know if it's a real problem we are ignoring, or
missing .BTF_ids.

>
> >
> > >
> > >  endef
> > >
> > > @@ -365,7 +377,10 @@ TRUNNER_EXTRA_SOURCES := test_progs.c cgroup_helpers.c trace_helpers.c     \
> > >                          network_helpers.c testing_helpers.c            \
> > >                          flow_dissector_load.h
> > >  TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read                          \
> > > -                      $(wildcard progs/btf_dump_test_case_*.c)
> > > +                      $(wildcard progs/btf_dump_test_case_*.c)         \
> > > +                      $(SCRATCH_DIR)/resolve_btfids
> > > +TRUNNER_EXTRA_CFLAGS := -D"BUILD_STR(s)=\#s" -DVMLINUX_BTF="BUILD_STR($(VMLINUX_BTF))"
> > > +TRUNNER_BINARY_EXTRA_CMD := $(SCRATCH_DIR)/resolve_btfids --btf $(VMLINUX_BTF) test_progs
> >
> > I hope we can get rid of this, see suggestion below.
> >
> > >  TRUNNER_BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
> > >  TRUNNER_BPF_CFLAGS := $(BPF_CFLAGS) $(CLANG_CFLAGS)
> > >  TRUNNER_BPF_LDFLAGS := -mattr=+alu32
> > > @@ -373,6 +388,7 @@ $(eval $(call DEFINE_TEST_RUNNER,test_progs))
> > >
> >
> > [...]
> >
> > > +
> > > +static int duration;
> > > +
> > > +static struct btf *btf__parse_raw(const char *file)
> >
> > another copy here...
>
> ok
>
> >
> > > +{
> > > +       struct btf *btf;
> > > +       struct stat st;
> > > +       __u8 *buf;
> > > +       FILE *f;
> > > +
> >
> > [...]
> >
> > > +
> > > +BTF_ID_LIST(test_list)
> > > +BTF_ID_UNUSED
> > > +BTF_ID(typedef, pid_t)
> > > +BTF_ID(struct,  sk_buff)
> > > +BTF_ID(union,   thread_union)
> > > +BTF_ID(func,    memcpy)
> > > +
> > > +struct symbol {
> > > +       const char      *name;
> > > +       int              type;
> > > +       int              id;
> > > +};
> > > +
> > > +struct symbol test_symbols[] = {
> > > +       { "unused",       -1,                0 },
> >
> > could use BTF_KIND_UNKN here instead of -1
>
> ok
>
> >
> > > +       { "pid_t",        BTF_KIND_TYPEDEF, -1 },
> > > +       { "sk_buff",      BTF_KIND_STRUCT,  -1 },
> > > +       { "thread_union", BTF_KIND_UNION,   -1 },
> > > +       { "memcpy",       BTF_KIND_FUNC,    -1 },
> > > +};
> > > +
> >
> > [...]
> >
> > > +
> > > +static int resolve_symbols(void)
> > > +{
> > > +       const char *path = VMLINUX_BTF;
> >
> >
> > This build-time parameter passing to find the original VMLINUX_BTF
> > really sucks, IMO.
> >
> > Why not use the btf_dump tests approach and have our own small
> > "vmlinux BTF", which resolve_btfids would use to resolve these IDs?
> > See how btf_dump_xxx.c files define BTFs that are used in tests. You
> > can do something similar here, and use a well-known BPF object file as
> > a source of BTF, both here in a test and in Makefile for --btf param
> > to resolve_btfids?
>
> well VMLINUX_BTF is there and those types are used are not going
> away any time soon ;-) but yea, we can do that.. we do this also
> for bpftrace, it's nicer


"VMLINUX_BTF is there" is not really true in a lot of more complicated
setups, which is why I'd like to avoid that assumption. E.g., for
libbpf Travis CI, we build self-tests in one VM, but run the binary in
a different VM. So either vmlinux itself or the path to it might
change.

Also, having full control over **small** BTF allows to create various
test situations that might be harder to pinpoint in real vmlinux BTF,
e.g., same-named entities with different KINDS (typedef vs struct,
etc). Then if that fails, debugging this on a small BTF is much-much
easier than on a real thing. Real vmlinux BTF is being tested each
time you build a kernel and run selftests inside VM either way, so I
don't think we lose anything in terms of coverage.


>
> jirka
>
