Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD7A4ABF0F
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 14:23:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386356AbiBGNBu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 08:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446548AbiBGMn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 07:43:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E7C9C033256;
        Mon,  7 Feb 2022 04:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AA03B81247;
        Mon,  7 Feb 2022 12:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 87459C340EF;
        Mon,  7 Feb 2022 12:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644237609;
        bh=xFqWxcO0ZOFW/A0bFuTO/amUCZo5jjYUv6KiZcjHi5Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rFKREdmAVUEy93hgb+e2gXnS3oD4Lif8PJ9dBEKp4dIjT0SXhX6zYy0pvaSdbznMI
         gB/8qV56WzbndURDcLYY+Il5NrsD6bmnpmXRFsgPkPVRe5YgWLZaAiZdAQ9zkhTb/U
         7MULBDGE8Ze9fGX2S84GKTWlqNv1GVz9oEJn0FrRYFo4LGgByONUUwVv8zBvXC5REi
         kyvaUJwbgsD+QQkdG4FQeFOJG3h3Xz6uc/b6DaV4vlZRr/vtf3NTip5Y9ONHF3ord4
         iu6o2rN7KujIfsyQEvsEZdWvnJ6sBeAkJ6TYx3nlacMJpm6DRUofn0qEgK7W5ysXC3
         CTAR351EQLQUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6C263E6BB3D;
        Mon,  7 Feb 2022 12:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2 net-next] net: dsa: mv88e6xxx: Fix off by in one in
 mv88e6185_phylink_get_caps()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164423760943.4874.16326636205625200936.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Feb 2022 12:40:09 +0000
References: <20220207082253.GA28514@kili>
In-Reply-To: <20220207082253.GA28514@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     andrew@lunn.ch, rmk+kernel@armlinux.org.uk,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, kabel@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 7 Feb 2022 11:22:53 +0300 you wrote:
> The <= ARRAY_SIZE() needs to be < ARRAY_SIZE() to prevent an out of
> bounds error.
> 
> Fixes: d4ebf12bcec4 ("net: dsa: mv88e6xxx: populate supported_interfaces and mac_capabilities")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [1/2,net-next] net: dsa: mv88e6xxx: Fix off by in one in mv88e6185_phylink_get_caps()
    https://git.kernel.org/netdev/net-next/c/dde41a697331
  - [2/2,net-next] net: dsa: mv88e6xxx: Unlock on error in mv88e6xxx_port_bridge_join()
    https://git.kernel.org/netdev/net-next/c/ff62433883b3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


