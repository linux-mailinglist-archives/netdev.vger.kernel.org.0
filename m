Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4011A424AB9
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 01:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232100AbhJFXzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 19:55:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:39936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230513AbhJFXy6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 19:54:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A239260F5A;
        Wed,  6 Oct 2021 23:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633564385;
        bh=FmnTfErOQoC2jzCTOxRXZYunXlyp3Js7AWi3J8NWV8Q=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iyF9zOQEuqxADuxJ3mB58tDAk5ZlTSGO6K/dPWA6Bv1eP/1h+OrMfnSM6N5JS6YfG
         Z6oCMndGHPPfxcTOEv1CMqHgpnCWhpzfG1+wYBcb50W8plIQZbvPAR9mKjli7CKY2Y
         +XxR/bMhhu0PLUP6g2HRx686R6pOaMUGiVR4pKQ+sdItWkXqxpd97Pzv5fL8cIWoFG
         L5tDAaHAERA35Yq7NF6OrHuSu9rtFN9/NHAvByHb0rupLcPPcIPnRZ6sp2HIQAR/B3
         7Xl/qxX5+23kD88Ukkue/2LYZIfRQg9jSVzap6IDf9rfdNYa2SHoEUBgaqsGGJjtPj
         /y4TMmGjbRgEA==
Received: by mail-lf1-f52.google.com with SMTP id x27so17196245lfu.5;
        Wed, 06 Oct 2021 16:53:05 -0700 (PDT)
X-Gm-Message-State: AOAM532gPIrZsCPW335aYpUswqGHtpFc7fC42MbK1qiVmytcSh++rSSw
        XJPdtNVBMC9EUcsLDYM0Tl/AGid2bukATWiwvc4=
X-Google-Smtp-Source: ABdhPJz6zk+uh1wpYY5SSzcex9Lr+N7cSJDVBtO7ZmfhW7T+kyLLcMFWM4y+3hr9/MVXl0OZRoaeR4lTcOz5mQhPQIk=
X-Received: by 2002:ac2:5582:: with SMTP id v2mr982504lfg.143.1633564384017;
 Wed, 06 Oct 2021 16:53:04 -0700 (PDT)
MIME-Version: 1.0
References: <20211006230543.3928580-1-joannekoong@fb.com> <20211006230543.3928580-4-joannekoong@fb.com>
In-Reply-To: <20211006230543.3928580-4-joannekoong@fb.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 6 Oct 2021 16:52:52 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5neNhDFXaUJOaS=Ju4o_gEyXNLyTc6_av802bc2JRGSQ@mail.gmail.com>
Message-ID: <CAPhsuW5neNhDFXaUJOaS=Ju4o_gEyXNLyTc6_av802bc2JRGSQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 3/3] bpf/selftests: Add xdp
 bpf_load_tcp_hdr_options tests
To:     Joanne Koong <joannekoong@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 6, 2021 at 4:09 PM Joanne Koong <joannekoong@fb.com> wrote:
>
> This patch adds tests for bpf_load_tcp_hdr_options used by xdp
> programs.
>
> test_xdp_tcp_hdr_options.c:
> - Tests ipv4 and ipv6 packets with TCPOPT_EXP and non-TCPOPT_EXP
> tcp options set. Verify that options can be parsed and loaded
> successfully.
> - Tests error paths: TCPOPT_EXP with invalid magic, option with
> invalid kind_len, non-existent option, invalid flags, option size
> smaller than kind_len, invalid packet
>
> Signed-off-by: Joanne Koong <joannekoong@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>
