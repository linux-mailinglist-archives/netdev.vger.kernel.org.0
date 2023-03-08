Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457E96B00CB
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 09:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbjCHIVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 03:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjCHIUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 03:20:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFB9B1A68
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 00:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8153C61640
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 08:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D46DEC4339C;
        Wed,  8 Mar 2023 08:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678263618;
        bh=UC0c9Qf2wgU+mUT8wJjJSuEnuxoTYmneesuj7CNgvcU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RUazwo1tZXDqEMtdKQCj6+xRwyFnVWUjAW8CPiOhqDZoYrs6tFJ41OgKFUzF1tZX7
         LYS8c1hMl3Wddvz0sMVw3znBTLqO6xwv8Lalafk92wYMEpLJ7rGkON4hy9bL3b/d0i
         u3sjjoCzJdjqvXTxJENVxXqA/FODjoOrLpCWsODR1RoLiFyjfrQI/IXa7R4Y0wyhZT
         +2JeYHSXqeeY9UFP0Bi+Hv+o9TUoYl7dGrAR87fhAMICeqAI3+aWo15IpLhZncPKe2
         6cQRhTSp+oaFD+9GxBPY08a3yLAiAmjUxW5rejwsC9IT1kUnZWbAiY3Qe9N0G2a2qo
         GcFtpbvwVx/Cg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B872FE61B64;
        Wed,  8 Mar 2023 08:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: smsc: simplify lan95xx_config_aneg_ext
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167826361875.8176.1122275776496118992.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Mar 2023 08:20:18 +0000
References: <3da785c7-3ef8-b5d3-89a0-340f550be3c2@gmail.com>
In-Reply-To: <3da785c7-3ef8-b5d3-89a0-340f550be3c2@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     andrew@lunn.ch, linux@armlinux.org.uk, pabeni@redhat.com,
        kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 6 Mar 2023 23:10:57 +0100 you wrote:
> lan95xx_config_aneg_ext() can be simplified by using phy_set_bits().
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/phy/smsc.c | 17 +++++++----------
>  1 file changed, 7 insertions(+), 10 deletions(-)

Here is the summary with links:
  - [net-next] net: phy: smsc: simplify lan95xx_config_aneg_ext
    https://git.kernel.org/netdev/net-next/c/4310e2f42030

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


