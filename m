Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2F7E4D149E
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 11:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245721AbiCHKVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 05:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231727AbiCHKVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 05:21:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E26E220CC;
        Tue,  8 Mar 2022 02:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B517FB81834;
        Tue,  8 Mar 2022 10:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 628CCC340F7;
        Tue,  8 Mar 2022 10:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646734810;
        bh=i76oHQ0C5f4GBfGiEGFGvXRNpDOAwk4b13OzHamTflc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MnlUgXm/2la4P4yOWdRkx7zHoIIlruYUdAAMfvY2WcBcXB3j6RTfU9Eksl61UT4UC
         pnMoPdpa9I3e3Qa0Swp1+K0QKopZ7swWDMoYFcHk4GA4diB72S8yF/5NP7dSqQDyLi
         viI1AJ6ZQ6/RW33SrW1Jt5G4lQX45oZB/7InsmX9sAiCIpABGwO0hvTrqF6yMVgmmX
         B9EbSjUz4wEbapULPVCems4tyGnlgL5DiH3yqYMtDPNDVpmkT2HPW7y/kvgrktLrkF
         +8+h+Qy7+q/P/SDeuxczcHHIyVdpHpCRMZD3z0UI/lHjlrpmp7HXwTPBby4MvRWjuO
         NNg1aZ5/GGU/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4A81AF0383B;
        Tue,  8 Mar 2022 10:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: lan966x: allow offloading timestamp operations
 to the PHY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164673481030.27128.11283309005963582516.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Mar 2022 10:20:10 +0000
References: <20220307094632.3764266-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220307094632.3764266-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 7 Mar 2022 10:46:32 +0100 you wrote:
> In case the MAC is using 'netif_rx()' to deliver the skb up the network
> stack, it needs to check whether 'skb_defer_rx_timestmap()' is necessary
> or not. In case is needed then don't call 'netif_rx()'
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: lan966x: allow offloading timestamp operations to the PHY
    https://git.kernel.org/netdev/net-next/c/328c621b95cd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


