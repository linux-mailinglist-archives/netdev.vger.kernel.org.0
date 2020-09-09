Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5CA2625F8
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 05:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbgIIDtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 23:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725984AbgIIDtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 23:49:13 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBDEC061573;
        Tue,  8 Sep 2020 20:49:12 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id 195so853950ybl.9;
        Tue, 08 Sep 2020 20:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6207Vqm3b/hyRnAf2FUzL7/ef2fg52ABc8XVE2tAvVM=;
        b=dqW1PRdIgEwLrVkExrbtrWTJSWZvACbdYTtjIFbzuVd0E90kA8q4T37ArYqgTT3KR7
         UW3Inxhhc1gjV/e6UPI4Z20cvF74ja9mgBBYFjYHid3LPVD3mPNtebe0crX00f/LVZq+
         VymmVmDALtwMlEAVk2tRUo90S9Bvcl2vGphgeqg7/41qNlOPh24+ItyGNW3UWPgIlpZU
         VyXmadQyoqJ6I9itkiJIqy9AupV75wPHMZkvnbR3U9MRp3kBgS14KUqkOsB6XHYviEc3
         BTefqbyBRr3+woDNEBSlv9pvHqVHSwx9DWBjNlUhJpHwF/TRQBY1WCP9n5/llw4B2gsD
         llpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6207Vqm3b/hyRnAf2FUzL7/ef2fg52ABc8XVE2tAvVM=;
        b=ScQJBZcXHKBj4use7OjOPicRCkEqOjZeTWD8oGavpjv6LRPgYCVwKcBsR5svZNZMMk
         oJhUlpoPJ2olk9ftE24FoWKDW62sDj9hH7tYnpeGTShH0j92U95iLgUZZLDJmfE5dQZd
         fgdI/74+8UFGMFj1QupWYiefYMBpS/EcVTEMNpTgRYN2+FS2f/iADZKwDXfmIjOUQfpR
         6J1Z0KFlRvJ0jvH+7ucLdbjAQI0yrVgUhbnddTsy1QWuSQ4KHg18fl6oIaEJuv8b/BdV
         sLW0M0ieb2UGCa1gcuotX5ygiGl0uMAhYp+XOriXC8f4sy+yDZmzPdInb5Ym3QfUp9R/
         zxag==
X-Gm-Message-State: AOAM532x4AcTd6+Azr9APFGZbiThAGa4+idzDIfMk/550ijHW2PAoyTy
        S0QZaXpnLe7IQDG/bOsuG3D4aFwLUDW4ycYlhe0=
X-Google-Smtp-Source: ABdhPJy0auTP317rV03+xpGYHMcsrHt/z48nYExaNtMyvmPNJPTlDBhW6je5fPX9+m9aHFItH7GEhEoxIyscIOTBjdE=
X-Received: by 2002:a25:aa8f:: with SMTP id t15mr2894605ybi.459.1599623349688;
 Tue, 08 Sep 2020 20:49:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200907164017.30644-1-quentin@isovalent.com>
In-Reply-To: <20200907164017.30644-1-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Sep 2020 20:48:58 -0700
Message-ID: <CAEf4BzZNfsSyeJv7VXv-Z0p8EKV=pdDjfQVzNY3X8Y1=oWMwaQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] bpf: detect build errors for man pages for
 bpftool and eBPF helpers
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 7, 2020 at 9:40 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> This set aims at improving the checks for building bpftool's documentation
> (including the man page for eBPF helper functions). The first patch lowers
> the log-level from rst2man and fix the reported informational messages. The
> second one extends the script used to build bpftool in the eBPF selftests,
> so that we also check a documentation build.
>
> This is after a suggestion from Andrii Nakryiko.
>
> Quentin Monnet (2):
>   tools: bpftool: log info-level messages when building bpftool man
>     pages
>   selftests, bpftool: add bpftool (and eBPF helpers) documentation build
>
>  tools/bpf/bpftool/Documentation/Makefile      |  2 +-
>  .../bpf/bpftool/Documentation/bpftool-btf.rst |  3 +++
>  .../bpf/bpftool/Documentation/bpftool-gen.rst |  4 ++++
>  .../bpf/bpftool/Documentation/bpftool-map.rst |  3 +++
>  .../selftests/bpf/test_bpftool_build.sh       | 23 +++++++++++++++++++
>  5 files changed, 34 insertions(+), 1 deletion(-)
>
> --
> 2.25.1
>

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

But this still won't be run every time someone makes selftests. We do
build bpftool during selftests build, so it would be good to run doc
build there as well to ensure everyone is executing this. But this is
a good first step for sure.
