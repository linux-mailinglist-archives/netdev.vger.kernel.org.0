Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C510164A946
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 22:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233800AbiLLVL2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 16:11:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233707AbiLLVLO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 16:11:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB2E186EA;
        Mon, 12 Dec 2022 13:11:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7BBA61232;
        Mon, 12 Dec 2022 21:11:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 46F0BC433AE;
        Mon, 12 Dec 2022 21:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670879473;
        bh=9blLkkOjD8Bcolq83bGySvku3ewQgjiu1BEhR8H2mhw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U0WmhgbMIZKLNIJlMTAWwLuufl6VdVpoRe8WreIDrGT1SUZw/IrSWP6obZ7wrRnyJ
         GTW6N/8ErSM99JRYwfCoN1f0QTXxU0ASY+y+uIaiEqYYwweOX/hU/u6zKnTWA/wOi0
         hmbCEARST6V4yXpRmbIfL6jGfFO980ypho6OHCZtBXEYXeADhXzWXMvSvvXDftiEX/
         ic/b6Ge1Mim/JjrxC9vbWOSCqMh5zCpu1xHdRdM1Jss2RdiDV2glc81il9NRAP8mX/
         lzDPDclVMpplQ9O9orReK+MgK2DeGxCWBxgKGgBTZ5TAzTD6/pg8BWg75IzJt6FU0O
         K4qFODhVI6V5g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 33733C00448;
        Mon, 12 Dec 2022 21:11:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] Update Joakim Zhang entries
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167087947320.28989.16734382104361853007.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 21:11:13 +0000
References: <20221209220519.1542872-1-f.fainelli@gmail.com>
In-Reply-To: <20221209220519.1542872-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, tglx@linutronix.de, maz@kernel.org,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        shawnguo@kernel.org, linux-imx@nxp.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        s.hauer@pengutronix.de, kernel@pengutronix.de, festevam@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, xiaoning.wang@nxp.com,
        wei.fang@nxp.com, shenwei.wang@nxp.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  9 Dec 2022 14:05:17 -0800 you wrote:
> Shawn, since you are the i.MX maintainer I added you and the NXP Linux
> Team as the de-facto maintainers for those entries, however there may be
> other people to list, thanks!
> 
> Changes in v2:
> 
> - update the maintainers entry per Clark Wang's recommendations
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] MAINTAINERS: Update NXP FEC maintainer
    https://git.kernel.org/netdev/net/c/4e81462a45ce
  - [net,v2,2/2] dt-bindings: FEC/i.MX DWMAC and INTMUX maintainer
    https://git.kernel.org/netdev/net/c/fb21cad28489

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


