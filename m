Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB3F711BD85
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 20:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbfLKTyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 14:54:35 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:45482 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbfLKTyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 14:54:35 -0500
Received: by mail-io1-f65.google.com with SMTP id i11so55516ioi.12;
        Wed, 11 Dec 2019 11:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WTN4Ye2+CRxlUcQe0wEgZgBDtQHNK88rbIzuw474fPQ=;
        b=WgtT1PRc35/Z+QmN5T6nXWlDvvZ9VBdtCAs8nHgutWWPAWf0Lqu6m0WfgjR+2EYzeg
         F0GAxa8bz+urWC74lCcgK+sISRhRmOOSqq93kho12fgLgsnzaFvf3qbWERlTN/gYsfsq
         F0yAIyN/lWw0stpiyTwmja5TsUIc4kDfuuMhCt+ytgD52z8hcDRwczN60dZEk52FFKZ1
         ly36+HgGqpHyQyMLX1oR23BhhjZLAKE/dD5e7NtywMZ5x6A16DAtF5jk9jKKr2XVKxHA
         DxqaR0RSVnm6F+rlcC1PpfEWN14SjgsPhEQntzdBK38ia4oD8YoumyA8UWv8TJn52yZl
         1pfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WTN4Ye2+CRxlUcQe0wEgZgBDtQHNK88rbIzuw474fPQ=;
        b=NfU8jwlydCZZEZs1eYY21QdQ8l4sm6GZNvZ+2PgTURcwBqlpowl3vzRck2HKkdONi1
         F3kSLpiZZru1N6cY5v+ucgJSMscxaXh/xQ0uwFK73kg885S5kwlW7gI5a4R0i+d/J5zX
         7PR5wM6WTzQOIHPmlKQBao6TiiB3VCXHlU4Egi5HsYC3ygq6Yyr6Heo+gptGUfHiAm5b
         7muPNEOCSHd4SIZJv1T0sshNoyXPU7kfkjAIVWMTKFbIzPbAMhJPLwJA3noT4dvcHSRN
         YW/JAV7JOKpPbhS1wZGiO0lHUH9HPGPfk9qm8G2JVvjHjLiwC92jjoUSVPkNHVDVgcn0
         hgTA==
X-Gm-Message-State: APjAAAWcvzLcZ/nfQhmqOrTi+To6mGr0uwCPAFYnO2oV+kiIwdeRrVUE
        rXJQxqZqYb68B9SfMXs9qobjIdburcOofpuUUZw=
X-Google-Smtp-Source: APXvYqwHN7ESQR57rcOzbEbDxN/rYgewldiLQjauN8rkJL2+CHrhrr4t6TMQJCkX1+b5JOweztUFAgHR+88AY0/g0Es=
X-Received: by 2002:a6b:e404:: with SMTP id u4mr3224445iog.120.1576094074526;
 Wed, 11 Dec 2019 11:54:34 -0800 (PST)
MIME-Version: 1.0
References: <20191210011438.4182911-1-andriin@fb.com> <20191210011438.4182911-7-andriin@fb.com>
 <20191211193807.raz42oiqmrm763tr@kafai-mbp>
In-Reply-To: <20191211193807.raz42oiqmrm763tr@kafai-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 11 Dec 2019 11:54:23 -0800
Message-ID: <CAEf4BzaGMUBL0jTeVRudG-E6D6gNZjgCHz4WM4o3Z0tifeWm0A@mail.gmail.com>
Subject: Re: [Potential Spoof] [PATCH bpf-next 06/15] libbpf: expose BPF
 program's function name
To:     Martin Lau <kafai@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 11:38 AM Martin Lau <kafai@fb.com> wrote:
>
> On Mon, Dec 09, 2019 at 05:14:29PM -0800, Andrii Nakryiko wrote:
> > Add APIs to get BPF program function name, as opposed to bpf_program__title(),
> > which returns BPF program function's section name. Function name has a benefit
> > of being a valid C identifier and uniquely identifies a specific BPF program,
> > while section name can be duplicated across multiple independent BPF programs.
> >
> > Add also bpf_object__find_program_by_name(), similar to
> > bpf_object__find_program_by_title(), to facilitate looking up BPF programs by
> > their C function names.
> >
> > Convert one of selftests to new API for look up.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/libbpf.c                        | 28 +++++++++++++++----
> >  tools/lib/bpf/libbpf.h                        |  9 ++++--
> >  tools/lib/bpf/libbpf.map                      |  2 ++
> >  .../selftests/bpf/prog_tests/rdonly_maps.c    | 11 +++-----
> >  4 files changed, 36 insertions(+), 14 deletions(-)
> >
> > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> > index edfe1cf1e940..f13752c4d271 100644
> > --- a/tools/lib/bpf/libbpf.c
> > +++ b/tools/lib/bpf/libbpf.c
> > @@ -209,8 +209,8 @@ static const char * const libbpf_type_to_btf_name[] = {
> >  };
> >
> >  struct bpf_map {
> > -     int fd;
> >       char *name;
> > +     int fd;
> This change, and

Oh, no reason beyond eliminating completely unnecessary 4 byte
padding. This one I didn't think is worth mentioning at all, it's just
an internal struct rearrangement.

>
> >       int sec_idx;
> >       size_t sec_offset;
> >       int map_ifindex;
> > @@ -1384,7 +1384,7 @@ static int bpf_object__init_user_btf_maps(struct bpf_object *obj, bool strict,
> >  }
> >
> >  static int bpf_object__init_maps(struct bpf_object *obj,
> > -                              struct bpf_object_open_opts *opts)
> > +                              const struct bpf_object_open_opts *opts)
> here, and a few other const changes,
>
> are all good changes.  If they are not in a separate patch, it will be useful
> to the reviewer if there is commit messages mentioning there are some
> unrelated cleanup changes.  I have been looking at where it may cause
> compiler warning because of this change, or I missed something?

My bad. I could split it out into a separate patch but didn't bother.
The reason for this change is that those opts were always supposed to
be passed as pointer to const struct and it was just an ommision on my
side to not declare them as such. But not doing it in this patch set
would mean that bpf_object__open_skeleton API would have to stick to
non-const opts as well, and I didn't want to proliferate this blunt.

>
> >  {
> >       const char *pin_root_path = OPTS_GET(opts, pin_root_path, NULL);
> >       bool strict = !OPTS_GET(opts, relaxed_maps, false);
> > @@ -1748,6 +1748,19 @@ bpf_object__find_program_by_title(const struct bpf_object *obj,
> >       return NULL;
> >  }
> >

trimming irrelevant parts ;)

[...]
