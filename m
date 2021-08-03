Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A833DE394
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 02:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbhHCAc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 20:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232311AbhHCAc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 20:32:27 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBCC7C06175F;
        Mon,  2 Aug 2021 17:32:17 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id j77so29343001ybj.3;
        Mon, 02 Aug 2021 17:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+J/NRBqgp4eQdgy7zu9yODt0BzKfVTRnQ1yDUmLKIpY=;
        b=TQDVx7Wjh7HGvG2C05iVzt46/IfyWS/nrB+YQ66+Ft4dBtMY0UkakP4FMNhl84kRjH
         3I571Hn6eWbLTlVbZUUgdO0Ry3ay3DQcpCVZ5lFiCBYrRJRryfIK29nLtOsgdz8wXlbM
         p1fIid/YOsPXFw+MZGQg2afFSxW+Uf1eJVlc+S287809b5l+RyWhmv/iwVbZQ8NsPG21
         IvhWfh3S91jRP9d9hS1iYlLaQsnkcNwgiKzyVQIU1zrcOBpJZFV5CJ9vLyUGEmIlVeCH
         hmeVptZwKuQUOybbnvO6zYUjoEKhbD4/dK+CxezdMlB7meQIwP0m/9G48GiCdbqF0SKY
         bLIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+J/NRBqgp4eQdgy7zu9yODt0BzKfVTRnQ1yDUmLKIpY=;
        b=so6/ea1M5HrVruIXyPhe9CDW5fgxS6N3/zkVgzWbu8Sz1tdEU2NRttW7e/GQCe8Esc
         I6DVtSssb4stSrew/EjklGLIfXVbknnCvhzF5vhr4CZF4qRfAcr/8caJQ7abMFNPWRTz
         rorOKq4Ofh7twLWyEhTE6x52Wn/Ts7d60KDaDe7Maeu8gddW1kqJYXh5xNMWufpSmr/Q
         F0p6kc/Ktz39mgmknokkVJtKJ0++vtg+LubSvbXVY+43lBF+Kc0ChWkujZHpmUCPAK8o
         M5KNGJXw9Kpxj6C0m+naJWPCHtC1J7krgjyhX0xKtH7yYrwiKKAT97ENubDsSqqHzA4A
         vEKg==
X-Gm-Message-State: AOAM5319fALDkDWMhAkMAw/YhdV4DHnyJ/6Z9F6WVlQiiNLVG+QAa/K0
        9Q4V7Dg8a+UV0Jn0qREmwnCaPpU5JjENZzT2JdU=
X-Google-Smtp-Source: ABdhPJy2jaBke2HZtOr6VF17cH6k9AnBXI+7op0hwCKgspv99pOAEUhTvaeqOCQxYn8uouXO1taCGyYSDPOZj2hHqYQ=
X-Received: by 2002:a25:2901:: with SMTP id p1mr24771104ybp.459.1627950737150;
 Mon, 02 Aug 2021 17:32:17 -0700 (PDT)
MIME-Version: 1.0
References: <20210802173951.2818349-1-sdf@google.com>
In-Reply-To: <20210802173951.2818349-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 2 Aug 2021 17:32:06 -0700
Message-ID: <CAEf4BzZZCzfywqLRK8Jodzf-XmRrKHRTsqGGE_erXdxm+coxqg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] selftests/bpf: move netcnt test under test_progs
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 2, 2021 at 10:39 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Rewrite to skel and ASSERT macros as well while we are at it.
>
> v2:
> - don't check result of bpf_map__fd (Yonghong Song)
> - remove from .gitignore (Andrii Nakryiko)
> - move ping_command into network_helpers (Andrii Nakryiko)
> - remove assert() (Andrii Nakryiko)
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> Acked-by: Yonghong Song <yhs@fb.com>
> ---

netcnt selftest is failing in our CI ([0]), PTAL. xdp_context_test_run
failure is unrelated, ignore that one.

  [0] https://github.com/kernel-patches/bpf/runs/3225481504?check_suite_focus=true

>  tools/testing/selftests/bpf/.gitignore        |   1 -
>  tools/testing/selftests/bpf/Makefile          |   3 +-
>  tools/testing/selftests/bpf/network_helpers.c |  12 ++
>  tools/testing/selftests/bpf/network_helpers.h |   1 +
>  .../testing/selftests/bpf/prog_tests/netcnt.c |  82 ++++++++++
>  .../selftests/bpf/prog_tests/tc_redirect.c    |  12 --
>  tools/testing/selftests/bpf/test_netcnt.c     | 148 ------------------
>  7 files changed, 96 insertions(+), 163 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/netcnt.c
>  delete mode 100644 tools/testing/selftests/bpf/test_netcnt.c
>

[...]
