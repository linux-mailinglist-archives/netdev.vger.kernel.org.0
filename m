Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784556C002F
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 09:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbjCSIuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 04:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjCSIuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 04:50:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 975AE1A969;
        Sun, 19 Mar 2023 01:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9759FB80AD9;
        Sun, 19 Mar 2023 08:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5021CC433A7;
        Sun, 19 Mar 2023 08:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679215817;
        bh=NCVUJ3Va8Kno8VRwUEU+c26vQrHi8E8gDD37BwunRTA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L4zfoY02ni07YvsZWLOnybUdedP4E2oIrxaK5QBgLXYRLquKNd2EYtysQyAWLWNA7
         ycdn/Hs6TnjeQoIGsT9SdMwhBWIWZUFcdCjGbFZwHjnqleWdf3ogfUCiQjQmd8oWCz
         4tmh4yx/0WK0GcEDMjZzgFvVY1/MpCIKqIDbUTIOV1/9bZFUu8RflnNOWCbvL/PZXX
         AIMjLx/kIy8d6af5kgwMLsjNnNX8/rFY/nEHlHuZWkDM5gQawkR0lNCDWAptW+SlaI
         mP5L44h/8YugdM4zlkeQkD71e9KVu7WnQeyxZNoXlwEoZhQ3fq5gBbX6otLEdeDgnY
         wObu4PMbBKlTw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3AEA0E21EE6;
        Sun, 19 Mar 2023 08:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: macb: Set MDIO clock divisor for pclk higher than 160MHz
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167921581723.28457.7163593490569442150.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Mar 2023 08:50:17 +0000
References: <20230316100339.1302212-1-bwawrzyn@cisco.com>
In-Reply-To: <20230316100339.1302212-1-bwawrzyn@cisco.com>
To:     Bartosz Wawrzyniak <bwawrzyn@cisco.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nicolas.ferre@microchip.com,
        claudiu.beznea@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xe-linux-external@cisco.com,
        danielwa@cisco.com, olicht@cisco.com, mawierzb@cisco.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 16 Mar 2023 10:03:39 +0000 you wrote:
> Currently macb sets clock divisor for pclk up to 160 MHz.
> Function gem_mdc_clk_div was updated to enable divisor
> for higher values of pclk.
> 
> Signed-off-by: Bartosz Wawrzyniak <bwawrzyn@cisco.com>
> ---
>  drivers/net/ethernet/cadence/macb.h      | 2 ++
>  drivers/net/ethernet/cadence/macb_main.c | 6 +++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)

Here is the summary with links:
  - net: macb: Set MDIO clock divisor for pclk higher than 160MHz
    https://git.kernel.org/netdev/net-next/c/b31587feaa01

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


