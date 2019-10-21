Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69F91DF5DD
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 21:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730125AbfJUTSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 15:18:46 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:33426 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730057AbfJUTSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 15:18:46 -0400
Received: by mail-qt1-f196.google.com with SMTP id r5so22862502qtd.0;
        Mon, 21 Oct 2019 12:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VfnDb/zq0ubkvSmBH9Xjbewqwm4bLsA3kSGFNJnQEKk=;
        b=KsX5yEjftCnBCXyDmEypT+gOhpwexr6tRUxlQuJTdqsvus9V6gAzlxhtmK0GlL4vS3
         DXtXCuQUipnNLsZybWX8iqQYYZj5i5sfc3nGLRbYzweMaSfzAtO4LxQH5HEO818TWZrW
         51a/mfMfwc/A1KxrLgNVaDO4nN0lw/uje82gN/2weQg//DxQrJRGwhjturSZCYFLscxq
         dksjFqQLM6hze7MEiQulkMCXtnr6l4IcqK92um1+xGFOgmkSEW0HTa+Q3LDtayXamWvh
         ARF8ITb/gi9wcpAZ3lxE0CkaUGQbtChptkS7Nm0kNDmk9k7r7Yc4kNmVprR9sjY0qJ3P
         W+fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VfnDb/zq0ubkvSmBH9Xjbewqwm4bLsA3kSGFNJnQEKk=;
        b=E441JxV0bZCf+62SizU1AJYzsuGO5SzBA9ZzmfEOZi6V4OrHbB0uq19a9HZB0Fl3R5
         lDaFuATgisM2m3twvfY0aoPBrqoX/uNl3y1x69SzYu2K1N0g1FaB8QRFSeQ7auQkVjWy
         FqQdlmWd8AdlqMTcQsJlC42xOIWSGRHd8W20sJ+kzxMOGLO5mm7IEm+MmlytcfQP5TCC
         RSsaeCaKNhGMLz4w8d+Y5bK7HoKq5ppbf/KBs8YU1xh37V5+fTz+jnXvPfjsMp/oASTu
         cgpo93QAUKx01W8RM2XXAASeZnmcFKJvF0TxAvpQQGPttWhRmlf/zLzftOb/wWy7WhBY
         Q2dA==
X-Gm-Message-State: APjAAAXmug4pW93IjRkxlezWMfetKFBT7Mmy6pe4cs/tw3ct2enviFtC
        Dp0tJn6gAWQmjW3HguHNCs2drBurE9RjsRtzYxQdZOWT
X-Google-Smtp-Source: APXvYqwSsQu5LcFTruiehJrueTCy/e9ggYWyd/Bx2OmrKgPfS0PuebNPttFRa5qeXFG7YKgNm+vKox4ourc6vKqsUCc=
X-Received: by 2002:ac8:1242:: with SMTP id g2mr25772527qtj.141.1571685524859;
 Mon, 21 Oct 2019 12:18:44 -0700 (PDT)
MIME-Version: 1.0
References: <20191017150032.14359-1-cneirabustos@gmail.com>
 <20191017150032.14359-5-cneirabustos@gmail.com> <d88ce3ca-d235-cd9c-c1a9-c2d01a01541d@fb.com>
 <CAEf4BzbsDbxjALMJ119B-nweD1xEZ_PHX9r9k8qDpekraaHR2w@mail.gmail.com> <20191021191449.GA16484@ebpf00.byteswizards.com>
In-Reply-To: <20191021191449.GA16484@ebpf00.byteswizards.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Oct 2019 12:18:33 -0700
Message-ID: <CAEf4BzY5ZMQJYwU5p-r4bnOcZLGsR1_1iY3-0KKnZyttRbyr6g@mail.gmail.com>
Subject: Re: [PATCH v14 4/5] tools/testing/selftests/bpf: Add self-tests for
 new helper.
To:     Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 21, 2019 at 12:14 PM Carlos Antonio Neira Bustos
<cneirabustos@gmail.com> wrote:
>
> On Mon, Oct 21, 2019 at 11:20:01AM -0700, Andrii Nakryiko wrote:
> > On Sat, Oct 19, 2019 at 1:58 AM Yonghong Song <yhs@fb.com> wrote:
> > >
> > >
> > >
> > > On 10/17/19 8:00 AM, Carlos Neira wrote:
> > > > Self tests added for new helper
> > > >
> > > > Signed-off-by: Carlos Neira <cneirabustos@gmail.com>
> > > > ---
> > > >   .../bpf/prog_tests/get_ns_current_pid_tgid.c  | 96 +++++++++++++++++++
> > > >   .../bpf/progs/get_ns_current_pid_tgid_kern.c  | 53 ++++++++++
> >
> > It looks like typical naming convention is:
> >
> > prog_test/<something>.c
> > progs/test_<something>.c
> >
> > Let's keep this consistent. I'm about to do a bit smarter Makefile
> > that will capture this convention, so it's good to have less exception
> > to create. Thanks!
> >
> > Otherwise, besides what Yonghong mentioned, this look good to me.
> >
> >
> > > >   2 files changed, 149 insertions(+)
> > > >   create mode 100644 tools/testing/selftests/bpf/prog_tests/get_ns_current_pid_tgid.c
> > > >   create mode 100644 tools/testing/selftests/bpf/progs/get_ns_current_pid_tgid_kern.c
> > > >
> >
> > [...]
> >
> > > > +     prog = bpf_object__find_program_by_title(obj, probe_name);
> > > > +     if (CHECK(!prog, "find_probe",
> > > > +               "prog '%s' not found\n", probe_name))
> > > > +             goto cleanup;
> > > > +
> > > > +     bpf_program__set_type(prog, BPF_PROG_TYPE_RAW_TRACEPOINT);
> > >
> > > Do we need this? I thought libbpf should automatically
> > > infer program type from section name?
> >
> > We used to, until the patch set that Daniel landed today. Now it can be dropped.
> >
> > >
> > > > +
> > > > +     load_attr.obj = obj;
> > > > +     load_attr.log_level = 0;
> > > > +     load_attr.target_btf_path = NULL;
> > > > +     err = bpf_object__load_xattr(&load_attr);
> > > > +     if (CHECK(err, "obj_load",
> > > > +               "failed to load prog '%s': %d\n",
> > > > +               probe_name, err))
> > > > +             goto cleanup;
> > >
> >
> > [...]
>
> Thanks Andrii,
> I have a doubt, I don't find in prog_tests/rdonly_map.c  where is "test_rdo.bss" defined ?, is called in line 43 but I'm missing how to is it used as I don't see it defined.
>

This map is created by libbpf implicitly from global variables used by
BPF object. You just look it up by name, set its value to whatever you
need global variables to be set up to, and that value will be
available to BPF program. From BPF program side, when you update
global variable, that value can be read from user space using that
same test_rdo.bss map. Does it make sense?

> Bests
