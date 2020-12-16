Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEFA2DC685
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 19:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730864AbgLPSaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 13:30:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:40006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730854AbgLPSav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 13:30:51 -0500
X-Gm-Message-State: AOAM530YEyIjwPkvbSe8WbKdr6vYfZxWnuiYq3QVokgPkK7v9Eg/wBif
        X49Ub27o+SBYUxWRb6RLiJnr4vhwn1dIAIBeJbq20g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608141616;
        bh=ZVmGOfuWNRxphCHLsLZLlsW2gAxpwmSu8Jk37lfpSek=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=T+6BdTJhN9tCapIr0ds1KE3lWy8zMbaamwvNU3DVrs0aQOhfgBxp8vOr86l83Ncg2
         07F5qChHK0ZxbskQM95G7esbP9KSg08ZOcMgXRvdjaahcNPtV0QjBGx13tV4VLAXbQ
         fnYCH5zU+rrTC36OoRjwKconZ+pEWe/qq01tDNocYJs0qE1RAU3YF9rF7ssbu90kKv
         9Vvt4Qc0d3V710JBet6l1Lsyvh1XvjqSyCUekDvvBlaDgR0ZovorKrz32Xu8R967As
         iA9EOKuUupW/ft7MeEzoEGKVdkihyA1Yddhn/wCwfS93OLLQpswQpa2FrZnpZVqnTI
         GItMiogHFfEtA==
X-Google-Smtp-Source: ABdhPJyKdUoaTkH3IgSb6xMSAU4vsRVyw0KKwtUy//5eJ7rOJREZOobDRKrUY+yAR1ZokCejQ7NoCMZHK1/zDeZt63Q=
X-Received: by 2002:a05:651c:1047:: with SMTP id x7mr15762220ljm.114.1608141614691;
 Wed, 16 Dec 2020 10:00:14 -0800 (PST)
MIME-Version: 1.0
References: <20201215233702.3301881-1-songliubraving@fb.com>
 <20201215233702.3301881-4-songliubraving@fb.com> <bfa216a2-3692-dfdb-99e1-06b270564b78@fb.com>
In-Reply-To: <bfa216a2-3692-dfdb-99e1-06b270564b78@fb.com>
From:   KP Singh <kpsingh@kernel.org>
Date:   Wed, 16 Dec 2020 19:00:04 +0100
X-Gmail-Original-Message-ID: <CANA3-0edc_tuXWYWXiK0h3FJ8QTvAquqfruFnOnX-f8qseqnrA@mail.gmail.com>
Message-ID: <CANA3-0edc_tuXWYWXiK0h3FJ8QTvAquqfruFnOnX-f8qseqnrA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/4] libbpf: introduce section "iter.s/" for
 sleepable bpf_iter program
To:     Yonghong Song <yhs@fb.com>
Cc:     Song Liu <songliubraving@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 16, 2020 at 6:44 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 12/15/20 3:37 PM, Song Liu wrote:
> > Sleepable iterator program have access to helper functions like bpf_d_path.
> >
> > Signed-off-by: Song Liu <songliubraving@fb.com>
>
> Acked-by: Yonghong Song <yhs@fb.com>

Acked-by: KP Singh <kpsingh@kernel.org>
