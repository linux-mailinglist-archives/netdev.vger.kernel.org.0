Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17DF725E36F
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 23:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgIDVqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 17:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbgIDVqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 17:46:52 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1110C061244;
        Fri,  4 Sep 2020 14:46:51 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id v78so5368388ybv.5;
        Fri, 04 Sep 2020 14:46:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gHr8gw6RwEh8mVD6dSwh+7l3wd8eDVz8VTITOsqsCDE=;
        b=iN9VoF0Y15Kst623jppBrvyPF0+Xoy/SlDtnqXuUFmdBWetdjMKD5b++1ANbFnI1nK
         u/H8BQYLTjG33/Jv9QVxCkQPFX7VAP+GomA1QP+YspN+3ZhGPXpQX2yXYQIqW+56KdMp
         LtFD21ZDRKl6cP/gyS8DFL0Z1xgQyb9vsQFHWcM2EYL47z0sdL2ZA7w80ho1lkTTH3AJ
         nbpap9uecnjFv2bpvD6lPQ6uGfCJLx9sM7VLkcVhjF9XOre+8PmmJiP6vNqIfGaGdTHD
         ju4EkVWLqWY9F6TSoMfKD3wuJB908f8JcNEVALUDzXmfd6/mf0XiKiRQgzdHaCJJrECE
         L2Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gHr8gw6RwEh8mVD6dSwh+7l3wd8eDVz8VTITOsqsCDE=;
        b=n7HuMWgVgoSGS5cgw1RqhUSYGSnxMiPiSfZ8VWw2ZZLUnV7X2b8xqkApdyOUTfmBQz
         3QMChWaa1TDGImc5HxcayN6P7uxOzL/fTP0QgZyg4IRLcW20SiJOfH3SeG0BHYnJqQbm
         GsI2Fdz/wA1B6s7c5zuRHmx+/FyQetW/pG2lz7aIEISvfr7JPCxEFOrfTE181hitgqkH
         Ab/eTYm1hriBSdNpaw5XrydeiXE8ei7L8LiOiLIyJiQ0AbRNVHaf6IUTlUXE5yGvY+6a
         1MSO8JFnbcGPUyGyYMLOPFgzYtsG/7P9QoKRIO/1ZfjMvoffJFZrQxP44RaHL36b5v4z
         5YvQ==
X-Gm-Message-State: AOAM53258lKd0cNR3zTvx3meOZnVPqaEeS0mfl54ueh6lffyfqkacfe0
        +nQAw/M5DbyBvuXMhEYShTAK5qIYPbyqAb0UOTE=
X-Google-Smtp-Source: ABdhPJyEEW8KCey7eANoA8tgaVe4od/2SQR6fjdyZSiaDD9QAYAF7B4GZg6AQ86G2OgRwweCXhPUNBL2yhp/T0tUNx8=
X-Received: by 2002:a25:c4c2:: with SMTP id u185mr13741013ybf.347.1599256011062;
 Fri, 04 Sep 2020 14:46:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200904205657.27922-1-quentin@isovalent.com> <20200904205657.27922-3-quentin@isovalent.com>
In-Reply-To: <20200904205657.27922-3-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Sep 2020 14:46:40 -0700
Message-ID: <CAEf4BzasomX-SL6TLULaA=Qi61RbYbvnjYVH=bmbAWGPdXzALg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] tools: bpftool: include common options from
 separate file
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 4, 2020 at 1:57 PM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Nearly all man pages for bpftool have the same common set of option
> flags (--help, --version, --json, --pretty, --debug). The description is
> duplicated across all the pages, which is more difficult to maintain if
> the description of an option changes. It may also be confusing to sort
> out what options are not "common" and should not be copied when creating
> new manual pages.
>
> Let's move the description for those common options to a separate file,
> which is included with a RST directive when generating the man pages.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/bpf/bpftool/Documentation/Makefile      |  2 +-
>  .../bpf/bpftool/Documentation/bpftool-btf.rst | 17 +------------
>  .../bpftool/Documentation/bpftool-cgroup.rst  | 17 +------------
>  .../bpftool/Documentation/bpftool-feature.rst | 17 +------------
>  .../bpf/bpftool/Documentation/bpftool-gen.rst | 17 +------------
>  .../bpftool/Documentation/bpftool-iter.rst    | 11 +--------
>  .../bpftool/Documentation/bpftool-link.rst    | 17 +------------
>  .../bpf/bpftool/Documentation/bpftool-map.rst | 17 +------------
>  .../bpf/bpftool/Documentation/bpftool-net.rst | 17 +------------
>  .../bpftool/Documentation/bpftool-perf.rst    | 17 +------------
>  .../bpftool/Documentation/bpftool-prog.rst    | 18 +-------------
>  .../Documentation/bpftool-struct_ops.rst      | 18 +-------------
>  tools/bpf/bpftool/Documentation/bpftool.rst   | 24 +------------------
>  .../bpftool/Documentation/common_options.rst  | 22 +++++++++++++++++
>  14 files changed, 35 insertions(+), 196 deletions(-)
>  create mode 100644 tools/bpf/bpftool/Documentation/common_options.rst
>

[...]
