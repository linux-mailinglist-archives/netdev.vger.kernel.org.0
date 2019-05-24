Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64FF429CEF
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 19:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732008AbfEXRZS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 13:25:18 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:39472 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731998AbfEXRZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 13:25:17 -0400
Received: by mail-qk1-f196.google.com with SMTP id i125so6524410qkd.6;
        Fri, 24 May 2019 10:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DaeZ/MXkF284l7J0bMp1V7E0HxSfavsCwFtla6oxrYM=;
        b=ULNBVdMc9JeNHSF7c11D4oYhn6iu4Fny69i4TOWuwDm1NuB1VUvzhlBNwwUAq9idoa
         rwo/8qB3DdTSwu6V98xD3Cd6JshykraFKdGAy+hgDvIh4nDmvM2LbmzYdnto73zt1ySe
         T41ZbC2Jlep0q6IRfW8LbiGtLwGpBjcKfLjq/5jUnBVhEPG4HtWznz85ETqLJUcn1YYZ
         nb6WCmovJ+wo2KETHnzC3lR31Q5DV9oqvf92WBQSjQIeEKpiq2Dm9uxEkQhLWQX3o/tx
         RuZvY4zC+kGDRIbLXGbd3gQ0Hchp0FzsDUPd37TzUWK+EOo1M9qMSVejMUdQrqHQ67zx
         reRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DaeZ/MXkF284l7J0bMp1V7E0HxSfavsCwFtla6oxrYM=;
        b=JY5OXlQSgpWVq0DrHlYzZj+TZ4n737sBt/LspCXRxgCnSjZmaaupOIkMZprzBNT8SN
         vd0IAwmK8F07YlSAOccmRN4Bx7/M0pVwwZAIgRdxorsxHOk9WsQk0Z9t1ERqzpMXPELh
         VfBkZDLdjdrZ4H0M7/5qCk+fLT7ABfiVeumvrY8qDQdGkFhFzG3bMbpYDXjVFddonF4J
         IfmvHeEsNBmKWAdlBFvokiN5OoKbNan6vH4hZzoK7dqa5DThXfSkIlt10xCnMOgc1sLM
         /5a+74KQfrsh9wqNPskx172JJs0wfGO7pHYzFbN0Lbdu6Fz/gCO0eNfbW4Y0olZKF02K
         QzlQ==
X-Gm-Message-State: APjAAAUhDdc8F+TtSa08+auREFenU6S4t12JGsHe5YS1r2sv1iz3+QON
        3bYsQB9BA+++daiEVkH+k8B8v2JIaYSG3aD0j/0=
X-Google-Smtp-Source: APXvYqwa0dJCv4WAWCPT7Yoggn/w1V9Zoadc3EPfFy23oNwi3GxUsoM12jTQC8QnNl7q65Qfu6jVB67uCBJ7eprw1Nw=
X-Received: by 2002:ac8:30d3:: with SMTP id w19mr84677525qta.171.1558718716600;
 Fri, 24 May 2019 10:25:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190523204222.3998365-1-andriin@fb.com> <20190523204222.3998365-12-andriin@fb.com>
 <062aa21a-f14a-faf7-adf1-cd2e5023fc90@netronome.com>
In-Reply-To: <062aa21a-f14a-faf7-adf1-cd2e5023fc90@netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 24 May 2019 10:25:05 -0700
Message-ID: <CAEf4BzZSLSDv-Hr47HrrboDAscW166JCERGs6eRPijkCqzzb7g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 11/12] bpftool/docs: add description of btf
 dump C option
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 24, 2019 at 2:14 AM Quentin Monnet
<quentin.monnet@netronome.com> wrote:
>
> 2019-05-23 13:42 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
> > Document optional **c** option for btf dump subcommand.
> >
> > Cc: Quentin Monnet <quentin.monnet@netronome.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/bpf/bpftool/Documentation/bpftool-btf.rst | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/bpf/bpftool/Documentation/bpftool-btf.rst b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
> > index 2dbc1413fabd..1aec7dc039e9 100644
> > --- a/tools/bpf/bpftool/Documentation/bpftool-btf.rst
> > +++ b/tools/bpf/bpftool/Documentation/bpftool-btf.rst
> > @@ -19,10 +19,11 @@ SYNOPSIS
> >  BTF COMMANDS
> >  =============
> >
> > -|    **bpftool** **btf dump** *BTF_SRC*
> > +|    **bpftool** **btf dump** *BTF_SRC* [**format** *FORMAT*]
> >  |    **bpftool** **btf help**
> >  |
> >  |    *BTF_SRC* := { **id** *BTF_ID* | **prog** *PROG* | **map** *MAP* [{**key** | **value** | **kv** | **all**}] | **file** *FILE* }
> > +|       *FORMAT* := { **raw** | **c** }
>
> Nit: This line should use a tab for indent (Do not respin just for that,
> though!).

Oh, I didn't notice that. My vim setup very aggressively refuses to
insert tabs, so I had to literaly copy/paste pieces of tabulations :)
Fixed it.

>
> >  |    *MAP* := { **id** *MAP_ID* | **pinned** *FILE* }
> >  |    *PROG* := { **id** *PROG_ID* | **pinned** *FILE* | **tag** *PROG_TAG* }
> >
> > @@ -49,6 +50,10 @@ DESCRIPTION
> >                    .BTF section with well-defined BTF binary format data,
> >                    typically produced by clang or pahole.
> >
> > +                  **format** option can be used to override default (raw)
> > +                  output format. Raw (**raw**) or C-syntax (**c**) output
> > +                  formats are supported.
> > +
>
> Other files use tabs here as well, but most of the description here
> already uses spaces, so ok.

Yeah, thanks for pointing out, fixed everything to tabs + 2 spaces, as
in other files (unclear why we have extra 2 spaces, but not going to
change that).

>
> >       **bpftool btf help**
> >                 Print short help message.
> >
> >
>
