Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566ED37306E
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 21:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbhEDTLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 15:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:37654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231849AbhEDTLF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 May 2021 15:11:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3F4DE613C5;
        Tue,  4 May 2021 19:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620155410;
        bh=zQ5tGZ5Hh/ioec69X8R6/Vz+zmx9Hw8bOukdh3Gxngs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NwIR7Jvc2PmOJ31w03rJU64hRVA1S1gHCU6FpgEXfJCH6zfNdMQj8V6AJvrdgRg0w
         BA+D6MWmaR8TipK/g1uQdYhTlo/0lGKMC0x2o9EmffP03ahQyRjVYtHOJIGJaDsQs8
         QHxf22U2rFGcJZ5oHK0Ct5tIRgIHkWlXD/o9qawpoTNtRXKKURGUM4Pd2V0J8yJEQs
         +d9MbNAaNnJ86Xi84KL/zV9tRHCD66f115ffM6h82D94fkYOZnujDKo/nkF8Dlm11U
         7euPg89OHjn+c6wegItbw0Tzh9O7zoPGdz8VsciAdWgFkeWkzJYWJDAwITGbjvXzEY
         BNA1rAhxlGa+Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2F7B260A0E;
        Tue,  4 May 2021 19:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: Only allow init netns to set default tcp cong to a
 restricted algo
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162015541019.23495.17170028584023189192.git-patchwork-notify@kernel.org>
Date:   Tue, 04 May 2021 19:10:10 +0000
References: <20210501082822.726-1-jonathon.reinhart@gmail.com>
In-Reply-To: <20210501082822.726-1-jonathon.reinhart@gmail.com>
To:     Jonathon Reinhart <jonathon.reinhart@gmail.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        stephen@networkplumber.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat,  1 May 2021 04:28:22 -0400 you wrote:
> tcp_set_default_congestion_control() is netns-safe in that it writes
> to &net->ipv4.tcp_congestion_control, but it also sets
> ca->flags |= TCP_CONG_NON_RESTRICTED which is not namespaced.
> This has the unintended side-effect of changing the global
> net.ipv4.tcp_allowed_congestion_control sysctl, despite the fact that it
> is read-only: 97684f0970f6 ("net: Make tcp_allowed_congestion_control
> readonly in non-init netns")
> 
> [...]

Here is the summary with links:
  - net: Only allow init netns to set default tcp cong to a restricted algo
    https://git.kernel.org/netdev/net/c/8d432592f30f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


