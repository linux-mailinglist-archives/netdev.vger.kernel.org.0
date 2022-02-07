Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9FC4ABEF9
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 14:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbiBGNBs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 08:01:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442700AbiBGMjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 07:39:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD59FC1DE9E1
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 04:30:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28D4961137
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 12:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 86CC4C340EF;
        Mon,  7 Feb 2022 12:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644237009;
        bh=0TC7idMjyFz9D4JRsLA42CSV0nHm9aUnSrRU1HXiWfU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ngOLNotcJCPuXHBiF4m0SXTSjpMV2Ovb+GXT5MVDthSdnA4tCzWsHf33eWUuHBmJP
         9hgYs9EqlsrT0MJbf4TcjbMHrhKILAn4TUMEgkM452cMJCnVp2L9VIdWwlnWcU3xQP
         Zy/4yXRpiiuzx8tenZQg6mEURXOvsnfskiLzphwD8W4D7NrmqjsTp2+Bb1YQgjLjYK
         IAZegM3FiJDGJ2i9TPpd3jX57WpXs5Z/lCQWPHk4xun3YYjRUYNFm9WBz8MtRjHfA9
         5gtmexsIuxRfLAhP2YTryV+it9ftwKhaOOpCT+4XlBGd7l8vRsMmVTZN5ksT0h97wR
         hNGIRHUY+Cibw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 70FB2E6BB3D;
        Mon,  7 Feb 2022 12:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: factor out redundant RTL8168d PHY config
 functionality to rtl8168d_1_common()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164423700945.1174.12061091122944185852.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Feb 2022 12:30:09 +0000
References: <467ee9c1-4587-08c0-60ca-e653d31cbc9f@gmail.com>
In-Reply-To: <467ee9c1-4587-08c0-60ca-e653d31cbc9f@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Sun, 6 Feb 2022 17:07:13 +0100 you wrote:
> rtl8168d_2_hw_phy_config() shares quite some functionality with
> rtl8168d_1_hw_phy_config(), so let's factor out the common part to a
> new function rtl8168d_1_common(). In addition improve the code a little.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  .../net/ethernet/realtek/r8169_phy_config.c   | 71 +++++++------------
>  1 file changed, 25 insertions(+), 46 deletions(-)

Here is the summary with links:
  - [net-next] r8169: factor out redundant RTL8168d PHY config functionality to rtl8168d_1_common()
    https://git.kernel.org/netdev/net-next/c/b845bac8edb1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


