Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 834FD55A12C
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 20:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiFXSaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 14:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiFXSaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 14:30:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97497C529;
        Fri, 24 Jun 2022 11:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45F5F62032;
        Fri, 24 Jun 2022 18:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 99764C341CF;
        Fri, 24 Jun 2022 18:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656095414;
        bh=44XM+lRvA2SOEd3O80z8bjMMecmfwNnkJPlbx+1fFeg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l+7dO/LekLDiD6qr6BD6EkyGN1RkktgWkR+wmQPJA05koLtknc1dV1+3p9ZSbRMhJ
         hySf9cK0s3JnQTd27PakvLHgCJrMv84hR3mn5WXNMo56I2p0u8lBjUiNL9mepuIxgF
         +kXQMX/A4PQTgEFXGXlOZKx+g0n9c7FDEkLokBV7pkO41ra3dgw1z/SHkY2ENNdWFx
         8TedKo0FTHyrnEmh/Bke/fmdGvjkj9MahV5adD25WOXiiuoDOgwIvLVNxAvF9qR4/m
         pgyl90Sd1l/YmA8BXJ9V/NLFc2ZR3w3EGEyMkssah5GWObToMAaDSwDW6GIrV44HkZ
         nWWocDPi+uq2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 83829E85C6D;
        Fri, 24 Jun 2022 18:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lan743x: Use correct variable in
 lan743x_sgmii_config()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165609541453.17645.1224478113135634240.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Jun 2022 18:30:14 +0000
References: <YrRry7K66BzKezl8@kili>
In-Reply-To: <YrRry7K66BzKezl8@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     bryan.whitehead@microchip.com, Raju.Lakkaraju@microchip.com,
        UNGLinuxDriver@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        andrew@lunn.ch, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Jun 2022 16:34:03 +0300 you wrote:
> There is a copy and paste bug in lan743x_sgmii_config() so it checks
> if (ret < 0) instead of if (mii_ctl < 0).
> 
> Fixes: 46b777ad9a8c ("net: lan743x: Add support to SGMII 1G and 2.5G")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/microchip/lan743x_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] net: lan743x: Use correct variable in lan743x_sgmii_config()
    https://git.kernel.org/netdev/net-next/c/b4cbd7a9339f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


