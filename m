Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B347617863E
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 00:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgCCXYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 18:24:42 -0500
Received: from mail-qv1-f67.google.com ([209.85.219.67]:44283 "EHLO
        mail-qv1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727942AbgCCXYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 18:24:42 -0500
Received: by mail-qv1-f67.google.com with SMTP id b13so150260qvt.11;
        Tue, 03 Mar 2020 15:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bWN5IUJGOQfIUGMad4x8J8i4hJVW+OFlm5YQcMXxXmo=;
        b=tArsZ0554C/9yj1OCkC4GgHlHTLbqTX4oe0lFHYDh2g9OXg3wWAAsF5RzA/t436KKW
         +m26YtM9u3epLL5ZoIuL14nHFAGJH9R34EJZ2ZDnDLIA3IRos1U6gGiRVpeie+jCLu1U
         c47dFetOnp1OHYsvTVmJct4qweb+2rh/Y+2tRX35djUIVz8kjcFfor+MBY5BlAj0zLQY
         TLAAlIensp4Z/5A5/YsGvADzbTH4bMxtEqRLOvXJxZzRHHMiPrPCpZX5B1D9/Yluv6rl
         BPSYeF+5HMsdcSQCmG5cfNl/4J/RlWzF0GAtOLhsAPSipcEPqTGdvm1DBaI+tbdVF3n+
         WZ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bWN5IUJGOQfIUGMad4x8J8i4hJVW+OFlm5YQcMXxXmo=;
        b=qLZijARRaID6YH+TYyqBZA8eIPrORwjcF/a86JEZ9rD3ms8FVZpeJ23Ldxt919C4pc
         15ZIrjfYMJT5iUoH+wnpy2y+9WLDYV0wxlUaX+JK0tpriJ7E+7wsVdnAdauaQ89bsEwc
         50P5Jfk3qoxD4H4O9OmpvzX9ebwQj9ODb4DqCAw4Pa1s3TQJztUPPmTgEAnDneFcVJXK
         RglCixxoVic+VV/0s66yyZcX2PpEuohWWy+Q7p8GgMvRW1e/SMXvJ0EJaS8V9MEhJbZc
         +0mG2l/KJMqoJThd+u+MkItrZcnStiEGSI+WBJNKW7URqoMCQwnssr9g1KPcf9PgrSlI
         cCFg==
X-Gm-Message-State: ANhLgQ0P70rtx25zhWLzWtupxgjqMiXhtfPRvVjmQM6ZFUcqpa3TlAZF
        H4NiDpC1j6WJWXwnj8Zv7XKa4J3y5l9U3J+Fb4mcm5VQfmk=
X-Google-Smtp-Source: ADFU+vvSp6YzuA5U30PquYoTMXERG6Im6u0XXWEAHK4kLMETxistbaJyuOr2YoSuvXcRNpyMO3K3TldkGSUEHG7usiE=
X-Received: by 2002:ad4:4993:: with SMTP id t19mr6112366qvx.224.1583277879690;
 Tue, 03 Mar 2020 15:24:39 -0800 (PST)
MIME-Version: 1.0
References: <20200303003233.3496043-1-andriin@fb.com> <20200303003233.3496043-2-andriin@fb.com>
 <fb80ddac-d104-d0b7-8bed-694d20b62d61@iogearbox.net>
In-Reply-To: <fb80ddac-d104-d0b7-8bed-694d20b62d61@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 3 Mar 2020 15:24:28 -0800
Message-ID: <CAEf4BzZWXRX_TrFSPb=ORcfun8B+GdGOAF6C29B-3xB=NaJO7A@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/3] bpf: switch BPF UAPI #define constants
 used from BPF program side to enums
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

On Tue, Mar 3, 2020 at 3:01 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 3/3/20 1:32 AM, Andrii Nakryiko wrote:
> > Switch BPF UAPI constants, previously defined as #define macro, to anonymous
> > enum values. This preserves constants values and behavior in expressions, but
> > has added advantaged of being captured as part of DWARF and, subsequently, BTF
> > type info. Which, in turn, greatly improves usefulness of generated vmlinux.h
> > for BPF applications, as it will not require BPF users to copy/paste various
> > flags and constants, which are frequently used with BPF helpers. Only those
> > constants that are used/useful from BPF program side are converted.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
>
> Just thinking out loud, is there some way this could be resolved generically
> either from compiler side or via additional tooling where this ends up as BTF
> data and thus inside vmlinux.h as anon enum eventually? bpf.h is one single
> header and worst case libbpf could also ship a copy of it (?), but what about
> all the other things one would need to redefine e.g. for tracing? Small example
> that comes to mind are all these TASK_* defines in sched.h etc, and there's
> probably dozens of other similar stuff needed too depending on the particular
> case; would be nice to have some generic catch-all, hmm.

Enum convertion seems to be the simplest and cleanest way,
unfortunately (as far as I know). DWARF has some extensions capturing
#defines, but values are strings (and need to be parsed, which is pain
already for "1 << 1ULL"), and it's some obscure extension, not a
standard thing. I agree would be nice not to have and change all UAPI
headers for this, but I'm not aware of the solution like that.

>
> > ---
> >   include/uapi/linux/bpf.h       | 175 ++++++++++++++++++++------------
> >   tools/include/uapi/linux/bpf.h | 177 ++++++++++++++++++++-------------
> >   2 files changed, 219 insertions(+), 133 deletions(-)
> >
> > diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> > index 8e98ced0963b..3ce4e8759661 100644
> > --- a/include/uapi/linux/bpf.h
> > +++ b/include/uapi/linux/bpf.h
> > @@ -325,44 +325,46 @@ enum bpf_attach_type {
> >   #define BPF_PSEUDO_CALL             1
> >
> >   /* flags for BPF_MAP_UPDATE_ELEM command */
> > -#define BPF_ANY              0 /* create new element or update existing */
> > -#define BPF_NOEXIST  1 /* create new element if it didn't exist */
> > -#define BPF_EXIST    2 /* update existing element */
> > -#define BPF_F_LOCK   4 /* spin_lock-ed map_lookup/map_update */
> > +enum {
> > +     BPF_ANY         = 0, /* create new element or update existing */
> > +     BPF_NOEXIST     = 1, /* create new element if it didn't exist */
> > +     BPF_EXIST       = 2, /* update existing element */
> > +     BPF_F_LOCK      = 4, /* spin_lock-ed map_lookup/map_update */
> > +};
> [...]
