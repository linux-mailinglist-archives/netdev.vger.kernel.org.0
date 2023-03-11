Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 064866B58A0
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 06:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjCKFaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 00:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjCKFaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 00:30:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647F9EFBC;
        Fri, 10 Mar 2023 21:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB63360B8B;
        Sat, 11 Mar 2023 05:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41BCEC4339B;
        Sat, 11 Mar 2023 05:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678512618;
        bh=3+Ta+VNtj5TCpBKMi8HoiTqPZaCmqC9kogedGvqUJZw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SXW0A3EZ3aSWwlXdjPeEveItwkvG9POUjujbJ5FS5amRS6ujxNKH/uadNVuQ6Pt0J
         N55lSV9Qi1HaWNZC5srDwc2zbIYqFZUxhJycnuSeOx2fB2kHtdhowm4vzINda9wfm1
         F48kJqA7mKivy7rz0SMkk5j8Y3pUTnyySvZAiLh6YzZ7kpF5iUZ3i0q05DS0VbPB70
         iswoYeaYL/6MNXptt5YZy9xtT9QCR7csplKMG6JO9c2TTXv8G61jEUNNTzlGOFB2oG
         +EHsU+Qzy52LzmjpLr/gW9AaFF/N7Sve+gknddQ1GdmsmyMaTf3GHVY5AQMnROaNNe
         MsAVKdUOU8Xcw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 23276E61B75;
        Sat, 11 Mar 2023 05:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: nxp-c45-tja11xx: fix MII_BASIC_CONFIG_REV bit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167851261813.13546.16770328057425233343.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Mar 2023 05:30:18 +0000
References: <20230309100111.1246214-1-radu-nicolae.pirea@oss.nxp.com>
In-Reply-To: <20230309100111.1246214-1-radu-nicolae.pirea@oss.nxp.com>
To:     Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Mar 2023 12:01:11 +0200 you wrote:
> According to the TJA1103 user manual, the bit for the reversed role in MII
> or RMII modes is bit 4.
> 
> Cc: <stable@vger.kernel.org> # 5.15+
> Signed-off-by: Radu Pirea (OSS) <radu-nicolae.pirea@oss.nxp.com>
> ---
>  drivers/net/phy/nxp-c45-tja11xx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] net: phy: nxp-c45-tja11xx: fix MII_BASIC_CONFIG_REV bit
    https://git.kernel.org/netdev/net/c/8ba572052a4b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


