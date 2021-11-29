Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44F7D4614F1
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 13:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347229AbhK2MZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 07:25:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60828 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244644AbhK2MX3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 07:23:29 -0500
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F2746137B;
        Mon, 29 Nov 2021 12:20:11 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id DA9DF60187;
        Mon, 29 Nov 2021 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638188410;
        bh=3dz4afOlmwavUqRWSWmY4mghzZ91U/hXH/Y5D1YaZNo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B404iPjF0gv8zoZLFY0KsVcxpMrHOtjOSrphr2F0IRNcU0XlQPx5tJ906CkniuEnL
         spIK69024xyFAq84ktbTHDeeSJNhkJ+tu/7dEWRP3ecNuUZLq/P1wjnTcGNOe/X42+
         IQSMUwZ35jHA05aqQ0XwPH5ZFvnaW+EADYUNvNafxltG9DPYG62pajZi9uHQkrceGZ
         uWps24EetffAcuty2SzdClJ10V+KOBZTWhb85J1ZeIxb8in1ZjK3JGCbYFAy2c3a9p
         9AHUq5ur3EhW2f80m3qsSQjLZ6HNwY7jBe95ukit9wE7GBrSTXpTEqxgplihwcA4Pi
         M3BbJCknrqw7g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D43AC60A4D;
        Mon, 29 Nov 2021 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/4] net: mvneta: mqprio cleanups and shaping
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163818841086.20614.1395556484776103965.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 12:20:10 +0000
References: <20211126112056.849123-1-maxime.chevallier@bootlin.com>
In-Reply-To: <20211126112056.849123-1-maxime.chevallier@bootlin.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        gregory.clement@bootlin.com, andrew@lunn.ch, pali@kernel.org,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 26 Nov 2021 12:20:52 +0100 you wrote:
> Hello everyone,
> 
> This is the second version of the series that adds some improvements to the
> existing mqprio implementation in mvneta, and adds support for
> egress shaping offload.
> 
> The first 3 patches are some minor cleanups, such as using the
> tc_mqprio_qopt_offload structure to get access to more offloading
> options, cleaning the logic to detect whether or not we should offload
> mqprio setting, and allowing to have a 1 to N mapping between TCs and
> queues.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/4] net: mvneta: Use struct tc_mqprio_qopt_offload for MQPrio configuration
    https://git.kernel.org/netdev/net-next/c/75fa71e3acad
  - [net-next,v2,2/4] net: mvneta: Don't force-set the offloading flag
    https://git.kernel.org/netdev/net-next/c/e7ca75fe6662
  - [net-next,v2,3/4] net: mvneta: Allow having more than one queue per TC
    https://git.kernel.org/netdev/net-next/c/e9f7099d0730
  - [net-next,v2,4/4] net: mvneta: Add TC traffic shaping offload
    https://git.kernel.org/netdev/net-next/c/2551dc9e398c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


