Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EC6C4617DF
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbhK2OXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241453AbhK2OVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:21:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC500C08EB32;
        Mon, 29 Nov 2021 05:00:12 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1EEF9CE117C;
        Mon, 29 Nov 2021 13:00:11 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 90CC160E53;
        Mon, 29 Nov 2021 13:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638190809;
        bh=Yep6juX3dr70RFGPzR/Jlksgnykb9sOvAdKAVTBJ5gY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KS+TnMKkDMlgcPs48dQUg3esiv1Z03vh3H0uG35NJknDbp+Q4qv2AUplrcHl83QzW
         7z5yoXPh4XIWJIFaK/zZMqlWOF/Ji3AUvtIa55E2nSbAzuAHuAZQ02shpqG42fTcCv
         tPVyMH27NPgIAH2JNOboO0L3YatiyGIGnoQDFveUy9GlNLAYRzrI5TDwh0jITTmq/B
         WaectOTI7ZOY781Pq89oVMVs0b/2fRLhXvCnq2iuWjXKHLZTsOfKo7LPAcJx8MhviO
         nrOPM7m9PsmZOhiQWAbyVW971WyBpej9rPSCiO4ia6jwRRuqT501DmxPkZzpmawQNb
         g5ZvSdvFWqLiA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7D882609D5;
        Mon, 29 Nov 2021 13:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/2 v3] dt-bindings: net: Add bindings for IXP4xx
 V.35 WAN HSS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163819080951.6089.4488606400072664861.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 13:00:09 +0000
References: <20211122223530.3346264-1-linus.walleij@linaro.org>
In-Reply-To: <20211122223530.3346264-1-linus.walleij@linaro.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        devicetree@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 22 Nov 2021 23:35:29 +0100 you wrote:
> This adds device tree bindings for the IXP4xx V.35 WAN high
> speed serial (HSS) link.
> 
> An example is added to the NPE example where the HSS appears
> as a child.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> 
> [...]

Here is the summary with links:
  - [net-next,1/2,v3] dt-bindings: net: Add bindings for IXP4xx V.35 WAN HSS
    https://git.kernel.org/netdev/net-next/c/9c37b09d3a9a
  - [net-next,2/2,v3] net: ixp4xx_hss: Convert to use DT probing
    https://git.kernel.org/netdev/net-next/c/35aefaad326b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


