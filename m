Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902AC4351E4
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 19:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbhJTRua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 13:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbhJTRua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 13:50:30 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925F4C06161C;
        Wed, 20 Oct 2021 10:48:15 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id o134so12234024ybc.2;
        Wed, 20 Oct 2021 10:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9it6yRx0Dy5jek9mfIinBGo3kKz2j0Pzxy4NyrmiiyQ=;
        b=kjmHnDL0KIfrh3TiyhvUFE0ArVTiLuDPfZz24yIGSU9vVk9GtFks4KgLmiqo5Fa3yy
         4WD0ijbK2004U8ccR7kNEDJK/i1o/cU8GIkvlLbGwA/JRcJQ4m3Z9dJc15v45G1khCrn
         sIPHW1tJ1sZVubGKC1XV5xYHZNFjyUjyK8AmxpIX8R2NajHh8Wn56DPLQz4Eis3NiEk5
         elbr8mpEYOXrRmu4dudCsAXC3XC9a30hwUtOH4xj5cqng8n4K0YTLLB0WYQ7bj7L1W5m
         s8uDGBX0Xvkzx88O0rKBPVAMCFbKohrErYPxRgiOrnbTvp9xqvO92jXuCE9O0qoR9QQW
         Er3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9it6yRx0Dy5jek9mfIinBGo3kKz2j0Pzxy4NyrmiiyQ=;
        b=7Dd23XNvGx4TUVhphoQ1nfBfUClJ8Ael4pyGNnDWANBl+narIFSMUjocvpqQTt6xfD
         PcGoXbOE6dmdEvFcaBt/4qUqugzc8muadS6qU4dnn26zb3n4Hmoc5tFgr3tRzP8Vb8Ov
         6Wdgv/m5Y1A1Pt0f5pYFnQWsJWrfyPrZ0yViobzSyy0/Iy/eSIF0wddKLWJ/HBipkttW
         iP7jAnbqoYr4ey5Ftov+74oO/MSyKpsJ8wdGs9w7b5JExNNjfvCIlhCTkYIRQD7nSQWf
         eIgKP/bCNOivyjbxCgb4RHI0mC/hIWKk0gM0Lu4FDUTrxD3eeXvX/fkZWXZFOseyA+Gz
         5eCQ==
X-Gm-Message-State: AOAM530VtxVMRNfXHbc7AqiHuysaSwZ7UKp7GcsXuLfxd7aAFPmWP9Ym
        u6uoNIOT+X8ND30cvgeMF8R7Vd5sUse3ZI3U5vs=
X-Google-Smtp-Source: ABdhPJxdJtmTIcLdhvm+FFM0wHc/o9aZ9TvLHRJKKFQdqaKQ/GTjc07lRyMESDpGr3ArgMGfdb5yoeeyqqyL+6JiNjw=
X-Received: by 2002:a25:afcd:: with SMTP id d13mr523625ybj.504.1634752094832;
 Wed, 20 Oct 2021 10:48:14 -0700 (PDT)
MIME-Version: 1.0
References: <20211020094826.16046-1-quentin@isovalent.com>
In-Reply-To: <20211020094826.16046-1-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Oct 2021 10:48:03 -0700
Message-ID: <CAEf4BzYjer110+RfsHjoRRbVwKpzMQs=XY+qMTzZh9eHe5KiSw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpftool: remove useless #include to <perf-sys.h>
 from map_perf_ring.c
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20, 2021 at 2:48 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> The header is no longer needed since the event_pipe implementation
> was updated to rely on libbpf's perf_buffer. This makes bpftool free of
> dependencies to perf files, and we can update the Makefile accordingly.
>
> Fixes: 9b190f185d2f ("tools/bpftool: switch map event_pipe to libbpf's perf_buffer")
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---


Great, thanks. It's in bpf-next.

>  tools/bpf/bpftool/Makefile        | 3 +--
>  tools/bpf/bpftool/map_perf_ring.c | 1 -
>  2 files changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> index abcef1f72d65..098d762e111a 100644
> --- a/tools/bpf/bpftool/Makefile
> +++ b/tools/bpf/bpftool/Makefile
> @@ -73,8 +73,7 @@ CFLAGS += -DPACKAGE='"bpftool"' -D__EXPORTED_HEADERS__ \
>         -I$(LIBBPF_INCLUDE) \
>         -I$(srctree)/kernel/bpf/ \
>         -I$(srctree)/tools/include \
> -       -I$(srctree)/tools/include/uapi \
> -       -I$(srctree)/tools/perf
> +       -I$(srctree)/tools/include/uapi
>  CFLAGS += -DBPFTOOL_VERSION='"$(BPFTOOL_VERSION)"'
>  ifneq ($(EXTRA_CFLAGS),)
>  CFLAGS += $(EXTRA_CFLAGS)
> diff --git a/tools/bpf/bpftool/map_perf_ring.c b/tools/bpf/bpftool/map_perf_ring.c
> index 825f29f93a57..b98ea702d284 100644
> --- a/tools/bpf/bpftool/map_perf_ring.c
> +++ b/tools/bpf/bpftool/map_perf_ring.c
> @@ -22,7 +22,6 @@
>  #include <sys/syscall.h>
>
>  #include <bpf/bpf.h>
> -#include <perf-sys.h>
>
>  #include "main.h"
>
> --
> 2.30.2
>
