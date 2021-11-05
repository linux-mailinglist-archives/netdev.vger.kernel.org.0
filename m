Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8374C446ADD
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 23:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbhKEWYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 18:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230498AbhKEWYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Nov 2021 18:24:23 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC788C061570;
        Fri,  5 Nov 2021 15:21:43 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id v64so26297343ybi.5;
        Fri, 05 Nov 2021 15:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WUR7lyaLNzjhSqpNUpmhgYKLntdMUM0FjSkCZaOy0zA=;
        b=fMepmD8OhjvftffT1vA64RvtqE4M8jk2SjX7e4VcjZnVNz1gI4n1FH4g7DjXRpSW4A
         w6xzLBbbn342dZjLBfMHxi781O4E6J5l9vTnBmGgc7d1QhebXMebELCjzGoRmJ1oM45r
         KZIOWMLqpa8TE1tVcafVsNxuKkfjCqebrOZZbR1Z4IVdXRP/dlIs/8QJYzMNSLFX3MWd
         T04KYWm178OHCw1gYifS1k1kBRJtxeU5ZECboPhGOvwXBsBNaQ7Tor1Rv7kvDlN7gN7e
         7AddKx37R5fr0/EnJgoXiWUomBamyMg9xWwHnuRGuCGd+J7KWzxrb9DyPiVVImuNviqU
         8wVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WUR7lyaLNzjhSqpNUpmhgYKLntdMUM0FjSkCZaOy0zA=;
        b=HXczuFwxgpCq06w0jNJoEmhZb6QH2pIKWvnI2kLzL1eyC97cTaHN2ePmKUHbw3pG5W
         irJGfB3o+xFLnwrFxteoWIDzimW9P11cTO+58q8SpKivpC0K4KPQXPP4+jkzaEkmHB7C
         WsOWxOY8Mg5L0uq0EMdh/M8LCClDMmH6y9H0Wzj1SI2HYi1P3Rml2PW6YabJKnx+hzic
         naDdBBFDsAeH+k1bylqtSIwI6b9x4AKPhxTCwsR63YXZ6Uk7dpccWqUx4bwX3Gsqdixe
         IGURpzYciIzIigKbl4PX/3q6whxhnjCt3k8FURuxbg84Yiwbu/nS5IyEciH7TX2N3Crv
         sMMg==
X-Gm-Message-State: AOAM530Gv1XNQl9OzZpOGAw+xIA3AH9Mn68gm1hBjmReKmt3ynT0qHmW
        olXouizYwJjeM0CHc+DzNGbdhIr56GYzhf/ivwk=
X-Google-Smtp-Source: ABdhPJy9lvBILyrYvibxFtmUDuwf/AHMJIxZg7IgNSsDEt6pXsto9YrvYEUNAGCvFMZ0WKl21TO6fHsbIiVJr4Za9bE=
X-Received: by 2002:a05:6902:1023:: with SMTP id x3mr36837887ybt.267.1636150903228;
 Fri, 05 Nov 2021 15:21:43 -0700 (PDT)
MIME-Version: 1.0
References: <20211105221904.3536-1-quentin@isovalent.com>
In-Reply-To: <20211105221904.3536-1-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 5 Nov 2021 15:21:32 -0700
Message-ID: <CAEf4BzYfw3OjvDRU1GcuNQXtTgBcTkAwBJGCmO5UA7s9fSQgdw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpftool: Fix SPDX tag for Makefiles and .gitignore
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>, Joe Stringer <joe@cilium.io>,
        Peter Wu <peter@lekensteyn.nl>, Roman Gushchin <guro@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Tobias Klauser <tklauser@distanz.ch>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 5, 2021 at 3:19 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Bpftool is dual-licensed under GPLv2 and BSD-2-Clause. In commit
> 907b22365115 ("tools: bpftool: dual license all files") we made sure
> that all its source files were indeed covered by the two licenses, and
> that they had the correct SPDX tags.
>
> However, bpftool's Makefile, the Makefile for its documentation, and the
> .gitignore file were skipped at the time (their GPL-2.0-only tag was
> added later). Let's update the tags.
>
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Andrii Nakryiko <andriin@fb.com>

Acked-by: Andrii Nakryiko <andrii@kernel.org>

> Cc: Ilya Leoshkevich <iii@linux.ibm.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Joe Stringer <joe@cilium.io>
> Cc: Peter Wu <peter@lekensteyn.nl>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Song Liu <songliubraving@fb.com>
> Cc: Stanislav Fomichev <sdf@google.com>
> Cc: Tobias Klauser <tklauser@distanz.ch>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/bpf/bpftool/.gitignore             | 2 +-
>  tools/bpf/bpftool/Documentation/Makefile | 2 +-
>  tools/bpf/bpftool/Makefile               | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/bpf/bpftool/.gitignore b/tools/bpf/bpftool/.gitignore
> index 05ce4446b780..a736f64dc5dc 100644
> --- a/tools/bpf/bpftool/.gitignore
> +++ b/tools/bpf/bpftool/.gitignore
> @@ -1,4 +1,4 @@
> -# SPDX-License-Identifier: GPL-2.0-only
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>  *.d
>  /bootstrap/
>  /bpftool
> diff --git a/tools/bpf/bpftool/Documentation/Makefile b/tools/bpf/bpftool/Documentation/Makefile
> index c49487905ceb..44b60784847b 100644
> --- a/tools/bpf/bpftool/Documentation/Makefile
> +++ b/tools/bpf/bpftool/Documentation/Makefile
> @@ -1,4 +1,4 @@
> -# SPDX-License-Identifier: GPL-2.0-only
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>  include ../../../scripts/Makefile.include
>  include ../../../scripts/utilities.mak
>
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index c0c30e56988f..622568c7a9b8 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -1,4 +1,4 @@
> -# SPDX-License-Identifier: GPL-2.0-only
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>  include ../../scripts/Makefile.include
>  include ../../scripts/utilities.mak
>
> --
> 2.32.0
>
