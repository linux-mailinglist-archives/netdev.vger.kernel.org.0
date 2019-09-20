Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E851EB95E4
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 18:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbfITQmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 12:42:07 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:33558 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729069AbfITQmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Sep 2019 12:42:06 -0400
Received: by mail-qt1-f195.google.com with SMTP id r5so9430821qtd.0;
        Fri, 20 Sep 2019 09:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kqT5lIVpsBt9QgotSREzEDcmUdKvdLEfcdlmXuAx+xk=;
        b=bCKyfITEKTXsbQLWL/X7tZ3LWMdwmrHZUwtTYcuA+LHSnQDaeCPy+Wy/PMqWOOTLOa
         VKn5Hzm4PIfK4m4yrkFrTf+WA1Sn1nRK06DdEbtV5HmX6Hq60mpscbjAfsEZ0q3InPIF
         kpuozEjIWvfPAGBw60M3DF53gURbxxmXZhQvjuQVzh7ypy9tIaQ0UwDlO36Q2wAbT96t
         fN3vRrefgW/a64cH1/Fk9HDQq3XeuSIa9IgVuF55jjkFRPEoZaZ4rHzgBlFiGYNJm+CK
         05thmQqLc5n8gEK+Xs38wTd7UDJBbF5y9F9a3X3InXr1xDxLFoLygZ4lQqZBSrSs8M5A
         CRdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kqT5lIVpsBt9QgotSREzEDcmUdKvdLEfcdlmXuAx+xk=;
        b=uEMQF+YMCghP3DFXxDfiVAHKFLx7NxgWk5UlPkKGjJYeU7w21rFBbYW5fkRbSzzKJs
         ZLuNk0v5y2MkFNVKEp4POzLDyzXdvMet9YmVKBFAyq1LlrXsccSwfkHwMuQWkdQpLgin
         vgO8ORGJWWooHJkrBLwcvQzFGpvAT/ktO3ycZWnzszeWgiUbiiTQeqrs/lhhQzeR631H
         6OXtOIW61kMdlLdmvS8ovPgzZS53rMsESeQX8hHjr6WJ48khLG3UsyLokMDLS3hq1AD/
         vAunxmps4CowH+IRx7f6itViugXWG+bSqylyTQO2mK7H54a6o7tvOBYec+56wvBX5dCJ
         nDUA==
X-Gm-Message-State: APjAAAXrHgvaXdJqU+uCbxPWom38GbSpvasjZz4+Up8LzOrulH0r0XOG
        OET0mwn9fpSFlhejjbGo4kd7ehlw33oZ3AoN/dI=
X-Google-Smtp-Source: APXvYqwHlEZPBHp6TKMq1Bn/wdXI2AU0A7FFVFNUPrCMEWbLJufkAEjZObSWazLl9RrBYJT3ie5Lgd1RVV4XtK9V9EU=
X-Received: by 2002:a0c:e48b:: with SMTP id n11mr14252983qvl.38.1568997725782;
 Fri, 20 Sep 2019 09:42:05 -0700 (PDT)
MIME-Version: 1.0
References: <20190919160518.25901-1-ivan.khoronzhuk@linaro.org>
 <CAEf4BzbCjCYr5NMPctDkUggwpehnqZPVBSqZOsd9MvSq6WmnZQ@mail.gmail.com> <20190920082204.GC8870@khorivan>
In-Reply-To: <20190920082204.GC8870@khorivan>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 Sep 2019 09:41:54 -0700
Message-ID: <CAEf4BzaVuaN3HhMu8W_i9z4n-2zfjqxBXyOEOaQHexxZq7b3qg@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix version identification on busybox
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 20, 2019 at 1:22 AM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> On Thu, Sep 19, 2019 at 01:02:40PM -0700, Andrii Nakryiko wrote:
> >On Thu, Sep 19, 2019 at 11:22 AM Ivan Khoronzhuk
> ><ivan.khoronzhuk@linaro.org> wrote:
> >>
> >> It's very often for embedded to have stripped version of sort in
> >> busybox, when no -V option present. It breaks build natively on target
> >> board causing recursive loop.
> >>
> >> BusyBox v1.24.1 (2019-04-06 04:09:16 UTC) multi-call binary. \
> >> Usage: sort [-nrugMcszbdfimSTokt] [-o FILE] [-k \
> >> start[.offset][opts][,end[.offset][opts]] [-t CHAR] [FILE]...
> >>
> >> Lets modify command a little to avoid -V option.
> >>
> >> Fixes: dadb81d0afe732 ("libbpf: make libbpf.map source of truth for libbpf version")
> >>
> >> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> >> ---
> >>
> >> Based on bpf/master
> >>
> >>  tools/lib/bpf/Makefile | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> >> index c6f94cffe06e..a12490ad6215 100644
> >> --- a/tools/lib/bpf/Makefile
> >> +++ b/tools/lib/bpf/Makefile
> >> @@ -3,7 +3,7 @@
> >>
> >>  LIBBPF_VERSION := $(shell \
> >>         grep -oE '^LIBBPF_([0-9.]+)' libbpf.map | \
> >> -       sort -rV | head -n1 | cut -d'_' -f2)
> >> +       cut -d'_' -f2 | sort -r | head -n1)
> >
> >You can't just sort alphabetically, because:
> >
> >1.2
> >1.11
> >
> >should be in that order. See discussion on mailing thread for original commit.
>
> if X1.X2.X3, where X = {0,1,....99999}
> Then it can be:
>
> -LIBBPF_VERSION := $(shell \
> -       grep -oE '^LIBBPF_([0-9.]+)' libbpf.map | \
> -       sort -rV | head -n1 | cut -d'_' -f2)
> +_LBPFLIST := $(patsubst %;,%,$(patsubst LIBBPF_%,%,$(filter LIBBPF_%, \
> +           $(shell cat libbpf.map))))
> +_LBPFLIST2 := $(foreach v,$(_LBPFLIST), \
> +               $(subst $() $(),,$(foreach n,$(subst .,$() $(),$(v)), \
> +                       $(shell printf "%05d" $(n)))))
> +_LBPF_VER := $(word $(words $(sort $(_LBPFLIST2))), $(sort $(_LBPFLIST2)))
> +LIBBPF_VERSION := $(patsubst %_$(_LBPF_VER),%,$(filter %_$(_LBPF_VER), \
> +        $(join $(addsuffix _, $(_LBPFLIST)),$(_LBPFLIST2))))
>
> It's bigger but avoids invocations of grep/sort/cut/head, only cat/printf
> , thus -V option also.
>

No way, this is way too ugly (and still unreliable, if we ever have
X.Y.Z.W or something). I'd rather go with my original approach of
fetching the last version in libbpf.map file. See
https://www.spinics.net/lists/netdev/msg592703.html.

> >
> >>  LIBBPF_MAJOR_VERSION := $(firstword $(subst ., ,$(LIBBPF_VERSION)))
> >>
> >>  MAKEFLAGS += --no-print-directory
> >> --
> >> 2.17.1
> >>
>
> --
> Regards,
> Ivan Khoronzhuk
