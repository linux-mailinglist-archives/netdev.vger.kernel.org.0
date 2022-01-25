Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026C049B932
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 17:51:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1585158AbiAYQup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 11:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1586330AbiAYQsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 11:48:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB9BC061783;
        Tue, 25 Jan 2022 08:46:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8B3B60B47;
        Tue, 25 Jan 2022 16:46:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4CA27C340EC;
        Tue, 25 Jan 2022 16:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643129174;
        bh=E6nb9O5phzVJO80Rxm8R+fHyUvq0B/Pzt/JBMopH6iU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Aj6lWgOhJpgv3x1BncmUdCyFRng8SiLmfGyPTCxHkfMUR1JMn6Twk+8WePAKRGPic
         IbhUu7r5A8Ifu5WTwgFrBBgPhQUt5JfvELDSnKgXRpYaGYNnph6TIarRtiTYgWkD1G
         VGG/aePlYwnTn/jf+y+NvCp7XweWNkBLAanmL7CFiBcggNrsdeUyXwWqYdp7uQMI9P
         zgFapGX43/V2d2XrCNnJi29JVtcL5XH99FSxT8iU0fAFQ1R5VQ9fZAhcCH6y6EC/fl
         GqIoiP3cDoLYacwhY+z/ezyJ/0bGrzAGVVgz623zzL1Qm9L6HCS8eeNNTBlLfQs22V
         eqt7QKWi1WFNw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 31E2FE5D087;
        Tue, 25 Jan 2022 16:46:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: reduce unnecessary wakeups from eee sw timer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164312917420.15904.15680846947944122595.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Jan 2022 16:46:14 +0000
References: <20220123155458.2288-1-jszhang@kernel.org>
In-Reply-To: <20220123155458.2288-1-jszhang@kernel.org>
To:     Jisheng Zhang <jszhang@kernel.org>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 23 Jan 2022 23:54:58 +0800 you wrote:
> Currently, on EEE capable platforms, if EEE SW timer is used, the SW
> timer cause 1 wakeup/s even if the TX has successfully entered EEE.
> Remove this unnecessary wakeup by only calling mod_timer() if we
> haven't successfully entered EEE.
> 
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
> 
> [...]

Here is the summary with links:
  - net: stmmac: reduce unnecessary wakeups from eee sw timer
    https://git.kernel.org/netdev/net/c/c74ead223deb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


