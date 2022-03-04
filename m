Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3E1F4CCCFB
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 06:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238111AbiCDFVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 00:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238163AbiCDFVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 00:21:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC7B18622C;
        Thu,  3 Mar 2022 21:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A62561BF3;
        Fri,  4 Mar 2022 05:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C6A45C340F0;
        Fri,  4 Mar 2022 05:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646371210;
        bh=fw8LvDDEkBIRcXW4kPuLNdyzjFmpOiNs/8aXuZoaJns=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HNC86c3Ku3dH+e156uAMZAy04Kbm9pTymwBzaJEgJkr8WlEVT/pDR3k2SiioEHYd9
         BZ2/DOaobSuBgfYokxIVDiVdTFsgkf8tjTFqo4rlAZSCFwS26ALJsMVvVjzn66J0fZ
         nVGEx9Zn9pr/5XfLgNI6ZSWWaKPN851GwH8EZ7dNc6bGgw5vOhQMmKrBXx8fd5VupZ
         9o6liU7/Veu7wjA7C32pjZJIC9BUdAMTQjdFJ6xlNVwmBCQp7lZSLH93XPq9VDUgPD
         oV1m9+u6bFBcsMCms6UoZuN3J4h0YsG5VxH44HEvB0+hKMvhJqUgoIYjyvCaDNT+73
         M1J7K5Ttp0KSQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AD548E6D4BB;
        Fri,  4 Mar 2022 05:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] [PATCH v3] net: marvell: Use min() instead of doing it
 manually
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164637121070.13388.16594174172027181154.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Mar 2022 05:20:10 +0000
References: <1646271529-7659-1-git-send-email-baihaowen88@gmail.com>
In-Reply-To: <1646271529-7659-1-git-send-email-baihaowen88@gmail.com>
To:     Haowen Bai <baihaowen88@gmail.com>
Cc:     sebastian.hesselbarth@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu,  3 Mar 2022 09:38:49 +0800 you wrote:
> Fix following coccicheck warning:
> drivers/net/ethernet/marvell/mv643xx_eth.c:1664:35-36: WARNING opportunity for min()
> 
> Signed-off-by: Haowen Bai <baihaowen88@gmail.com>
> ---
>  drivers/net/ethernet/marvell/mv643xx_eth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [v3] net: marvell: Use min() instead of doing it manually
    https://git.kernel.org/netdev/net-next/c/2f5e65de0496

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


