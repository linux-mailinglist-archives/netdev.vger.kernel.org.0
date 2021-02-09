Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74CA314846
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 06:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhBIFhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 00:37:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhBIFhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 00:37:31 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0BA0C061786;
        Mon,  8 Feb 2021 21:36:51 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id b187so16983444ybg.9;
        Mon, 08 Feb 2021 21:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MbDud3Swt6Nxldjl0CSMmeYE9ZrcLgVuLfO+M3p0K2U=;
        b=F29tNo7QeIIo9Mc8d+Jz8GvV13vdKS1AxyOplmVOoROBYPGCR7aaYUrya1Gk14fJNC
         XIc8T0ABoabkguGSWl22Y1RQXdYeCYM9U742Iwqi4RC7A1uYlZZzviRJ+f+qT7w9cVNO
         KTtgixwS055TUcGhAgTQ8gS/zRre6f8+LfrLOt8WNB4PuFsy0RZNCCKscIFoM+pFLU0L
         diA+ywAXKtlMgX0ZasCQZhXOAbJl4Bv/9Q4AA8+uauItnL8leJUwmDeu1Iak5IZzl36c
         xK5I24rT0dEIGnIR+n+2d1K9Ck8GN1TC35anDY5x1Q5CdRBB42LNni1kveszCJWP6sPr
         /rqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MbDud3Swt6Nxldjl0CSMmeYE9ZrcLgVuLfO+M3p0K2U=;
        b=KqDaTiys4Yt1ic5mBCviqLgMSzU6mNQWXWznofRNMYlSROrnYA9EFKiNn4MCZsclbR
         s69cSiGy3kzn7SAVtFx7bFj904t8LwxaOMXSqtGmqpjT6LJHqok5MAdW22fLLwyo3PQ2
         eh7+aP8d2YPQJD/jT7NHjYwqcQhF1YJ4lmEVuTjr0Gi3w2aIN5GY3EQ6Y1bCdn3dqTCB
         RaEpVvcVzs4Q5OXrARJ9L2ChjwFW2YqRjHLIFC0NCjHv+fgh39HkUri+tca+ClP1xfYr
         fkuk7Gcz38URnDgCPlhVKMcz08fQM9pkZA8YhRpmPjNWkubsGehuEs5xl10A2WGuBV3v
         9WrQ==
X-Gm-Message-State: AOAM530byI9+LvniT3XU+q5r8SydKa+l4R4aqG3HjjdPcZwGw131wCA3
        5iXRJvtLwqP3Br8X0bes6UkJ1mbI2YNhoSH0/c8=
X-Google-Smtp-Source: ABdhPJz1W+D0YIFC3g2uGdc+ZyUbc70eko9Kc2xx9F6llrE0xTguh/7CH8ufNEQnxPb4gCtcdN45JDKBM/0ac/WJFhQ=
X-Received: by 2002:a25:a183:: with SMTP id a3mr29634573ybi.459.1612849011093;
 Mon, 08 Feb 2021 21:36:51 -0800 (PST)
MIME-Version: 1.0
References: <20210205124020.683286-1-jolsa@kernel.org>
In-Reply-To: <20210205124020.683286-1-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 8 Feb 2021 21:36:40 -0800
Message-ID: <CAEf4Bza09-H+-iE8Ksd15GjXGArDubOrHorvdwBN=yh9TwTpKA@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 0/4] kbuild/resolve_btfids: Invoke
 resolve_btfids clean in root Makefile
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 5, 2021 at 4:45 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> hi,
> resolve_btfids tool is used during the kernel build,
> so we should clean it on kernel's make clean.
>
> v2 changes:
>   - add Song's acks on patches 1 and 4 (others changed) [Song]
>   - add missing / [Andrii]
>   - change srctree variable initialization [Andrii]
>   - shifted ifdef for clean target [Andrii]
>
> thanks,
> jirka
>
>
> ---
> Jiri Olsa (4):
>       tools/resolve_btfids: Build libbpf and libsubcmd in separate directories
>       tools/resolve_btfids: Check objects before removing
>       tools/resolve_btfids: Set srctree variable unconditionally
>       kbuild: Add resolve_btfids clean to root clean target
>
>  Makefile                            |  7 ++++++-
>  tools/bpf/resolve_btfids/.gitignore |  2 --
>  tools/bpf/resolve_btfids/Makefile   | 44 ++++++++++++++++++++++----------------------
>  3 files changed, 28 insertions(+), 25 deletions(-)
>

I've applied the changes to the bpf-next tree. Thanks.

Next time please make sure that each patch in the series has a v2 tag
in [PATCH] section, it was a bit confusing to figure out which one is
the actual v2 version. Our tooling (CI) also expects the format [PATCH
v2 bpf-next], so try not to merge v2 with PATCH.
