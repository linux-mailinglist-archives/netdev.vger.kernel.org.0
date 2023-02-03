Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDBE268941E
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 10:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233055AbjBCJks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 04:40:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232856AbjBCJkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 04:40:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D552A16C;
        Fri,  3 Feb 2023 01:40:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F58EB82A23;
        Fri,  3 Feb 2023 09:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 069BCC4339B;
        Fri,  3 Feb 2023 09:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675417221;
        bh=hmycklV4GOyS2Lbpz8VpqhHvoYvV/SDnIuyG9A0OJyg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QWiDslwkVrpEIWhT1rHocyh5BPGQviydQQVo6+EGpLrqkOrmWH+jBaS6QYxBMQbib
         ZVDy//tHLnMTCKN2qq8hherHwUJjAEocjRgGx12LGVDnwmPxqHgvBU6Pexsvcb5eoG
         fq4aYQHUPZfDROfhkCWF84tcsRQlAlZ437FVJacGD47my1GHQ6G1gVl+qmOuRS091V
         cmIvJk04hdHvCH3DKd6nOXvsBCmmHf6S1KSJjufIE/Q4U8hRASkhrCdjEq4WeY/2QJ
         Qo9l49HVwfxvplwtKyoD2VLw8nj4pBH6finOggdEHyAi82zETzMLY+BWK48TvIHuPB
         EO7YYI9d1HJqA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DFE6EE270CA;
        Fri,  3 Feb 2023 09:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 0/5] net: renesas: rswitch: Modify initialization
 for SERDES and PHY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167541722091.18212.1127362990288512461.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Feb 2023 09:40:20 +0000
References: <20230201131454.1928136-1-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20230201131454.1928136-1-yoshihiro.shimoda.uh@renesas.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  1 Feb 2023 22:14:49 +0900 you wrote:
> - My platform has the 88x2110.
> - The MACTYPE setting of strap pin on the platform is SXGMII.
> - However, we realized that the SoC cannot communicate the PHY with SXGMII
>   because of mismatching hardware specification.
> - We have a lot of boards which mismatch the MACTYPE setting.
> 
> So, I would like to change the MACTYPE as SGMII by software for the platform.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/5] net: renesas: rswitch: Simplify struct phy * handling
    https://git.kernel.org/netdev/net-next/c/b46f1e579329
  - [net-next,v5,2/5] net: renesas: rswitch: Convert to phy_device
    https://git.kernel.org/netdev/net-next/c/c16a5033f77b
  - [net-next,v5,3/5] net: renesas: rswitch: Add host_interfaces setting
    https://git.kernel.org/netdev/net-next/c/0df024d0f1d3
  - [net-next,v5,4/5] net: renesas: rswitch: Add phy_power_{on,off}() calling
    https://git.kernel.org/netdev/net-next/c/5cb630925b49
  - [net-next,v5,5/5] net: renesas: rswitch: Add "max-speed" handling
    https://git.kernel.org/netdev/net-next/c/04c77d9130b6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


