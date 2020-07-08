Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E81217CDD
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 03:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729096AbgGHB4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 21:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728191AbgGHB4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 21:56:36 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8116DC061755;
        Tue,  7 Jul 2020 18:56:35 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id a15so6681879ybs.8;
        Tue, 07 Jul 2020 18:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t5M9JPUM1j5qrEGwQrDEhxL8yvysp3tc5eFEm3iD0IM=;
        b=HQlNN60WOTFKIJL3AIqB0WmM995JEINeFgLZl4r+AglI92f4iKGlFf0epxqaciLc3l
         o25ptkw/cL05d2aIrD9n/VvRDM9ELASm4Yn1+fEpb7M8PEgz2hQn2cgTpv0ARxg7noik
         qj3F3yxhjdFpKPQ6Qd76yjdv9t4sxbjTo2rLK9gjcjtme9FTtgUF4l5CDgvOJbIB17c2
         LN8wq/PNAbfjEGj0TIZg6yz19QeN9hLGfB5yrcDgV1v9WQJYkNhOwe8qYXQ+2aRaA5On
         rAyMUZEPY3MQRxWHqNqbaptakF+oy3zc0As1JOmCpSqCv3j4o69ZQBIcRAaCv4INGEHF
         lfYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t5M9JPUM1j5qrEGwQrDEhxL8yvysp3tc5eFEm3iD0IM=;
        b=Nx7p7A6E4AV1H0bmnOB3q7auBT+LgFkjM7ozzAinLfvXijit03WagqOdGQkJda5CZv
         15RVfRFahvfotQpXgSJxMD7hjZpet4WHrY3cAj51a8v0jEatghb9uDWVnEZt9Ur41aAt
         PoC2ypBeLGPuKi7384CIGwFte/nGHp1m0IWYLxgZjjVvkN5BCZTBMmGLncTEutz/cY0h
         89XtXRaU8AqAbW36nviiF11hJWB2jUzmblGlwSPRHGrpvBFAkTm8hk4J/hC32V5zAZ1n
         BvZChO6QyDkDaLRozmP9CGvIk8fBIOiYyw2/6g8JJo4fwo4XMWrz8i6VwDXcIxLf2TBG
         ziIg==
X-Gm-Message-State: AOAM533wcgEVFn0/H0nr6HPdetGvAyt3Ld4AT5AMwoKvtT+cJXv1Ukcy
        UhiRZ1+Rq1Ocx7q17Sg1jVh1YUUe6jOBfsRl7q+etyhR1w==
X-Google-Smtp-Source: ABdhPJxITtvsBJerF5nQ+bSEq52bar4lO39tfO/pSfvkYA4tNIFJ5jlSCw1JMQ9SL5CrMZajdZgBoFI70LmCKBVT0/w=
X-Received: by 2002:a25:a505:: with SMTP id h5mr8431292ybi.419.1594173393738;
 Tue, 07 Jul 2020 18:56:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200707184855.30968-1-danieltimlee@gmail.com>
 <20200707184855.30968-5-danieltimlee@gmail.com> <CAEf4Bzb5QKJcbTd+etoERgfzrNW47VxxC3Z=p_+OJrJMmYz4XQ@mail.gmail.com>
In-Reply-To: <CAEf4Bzb5QKJcbTd+etoERgfzrNW47VxxC3Z=p_+OJrJMmYz4XQ@mail.gmail.com>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Wed, 8 Jul 2020 10:56:14 +0900
Message-ID: <CAEKGpzh3WeC7xctBXBq0xFMVqSkDrmxOBpdJgMO3yXR3a3zJGQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 4/4] selftests: bpf: remove unused
 bpf_map_def_legacy struct
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 8, 2020 at 4:00 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Tue, Jul 7, 2020 at 11:49 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
> >
> > samples/bpf no longer use bpf_map_def_legacy and instead use the
> > libbpf's bpf_map_def or new BTF-defined MAP format. This commit removes
> > unused bpf_map_def_legacy struct from selftests/bpf/bpf_legacy.h.
> >
> > Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> > ---
>
> Next time please don't forget to keep Ack's you've received on
> previous revision.
>

I'll keep that in mind.

Thank you for your time and effort for the review.
Daniel.

> >  tools/testing/selftests/bpf/bpf_legacy.h | 14 --------------
> >  1 file changed, 14 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/bpf_legacy.h b/tools/testing/selftests/bpf/bpf_legacy.h
> > index 6f8988738bc1..719ab56cdb5d 100644
> > --- a/tools/testing/selftests/bpf/bpf_legacy.h
> > +++ b/tools/testing/selftests/bpf/bpf_legacy.h
> > @@ -2,20 +2,6 @@
> >  #ifndef __BPF_LEGACY__
> >  #define __BPF_LEGACY__
> >
> > -/*
> > - * legacy bpf_map_def with extra fields supported only by bpf_load(), do not
> > - * use outside of samples/bpf
> > - */
> > -struct bpf_map_def_legacy {
> > -       unsigned int type;
> > -       unsigned int key_size;
> > -       unsigned int value_size;
> > -       unsigned int max_entries;
> > -       unsigned int map_flags;
> > -       unsigned int inner_map_idx;
> > -       unsigned int numa_node;
> > -};
> > -
> >  #define BPF_ANNOTATE_KV_PAIR(name, type_key, type_val)         \
> >         struct ____btf_map_##name {                             \
> >                 type_key key;                                   \
> > --
> > 2.25.1
> >
