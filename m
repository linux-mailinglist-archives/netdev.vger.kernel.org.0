Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 590715A7CBB
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 14:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbiHaMAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 08:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbiHaMAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 08:00:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9570E1C116;
        Wed, 31 Aug 2022 05:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC2176192E;
        Wed, 31 Aug 2022 12:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2A882C433D7;
        Wed, 31 Aug 2022 12:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661947215;
        bh=ZRuhytxmiHx8WH7GqqZsAfkvnGqaVO1af5RA9tdMy9I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jkpBkvppQS2fEEedNt5n/xmQwCQZqqxdRSXpBBp/x+2CJzes3X+tUWljSh3urj1gK
         nJWqQfgI39YvuxBrXfpnX9PAqqLVMWEAWdjHAzBnwCO7kLO0NUu08CAkzWbNaFDAhb
         2u2xBqdbDP6jH+NoIxYGPN2tZMTpAi5kISv2BoJyfzeQs+CL0UL4JCQNgwnNqZQ3Cf
         lyPLGqw7686LDtTjceVghKCfpRaCnWoDeepIBuw1OmiRgcVWN9tMHZcM+9jrBQognU
         wtctZNNrCDgH7GIP6zluka8x8mzX+20Q8yvUzXSwFnDTwz7uq+qvykAJM6X4hKkgmF
         aLyd8ip/laSpw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0F944C4166F;
        Wed, 31 Aug 2022 12:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] phy: lan966x: add support for QUSGMII
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166194721505.25040.17438501930962804343.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Aug 2022 12:00:15 +0000
References: <20220826141722.563352-1-maxime.chevallier@bootlin.com>
In-Reply-To: <20220826141722.563352-1-maxime.chevallier@bootlin.com>
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc:     davem@davemloft.net, linux-phy@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, vkoul@kernel.org, horatiu.vultur@microchip.com,
        linux@armlinux.org.uk, UNGLinuxDriver@microchip.com,
        thomas.petazzoni@bootlin.com
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

On Fri, 26 Aug 2022 16:17:22 +0200 you wrote:
> Makes so that the serdes driver also takes QUSGMII in consideration.
> It's configured exactly as QSGMII as far as the serdes driver is
> concerned.
> 
> Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
> ---
> 
> [...]

Here is the summary with links:
  - [net-next] phy: lan966x: add support for QUSGMII
    https://git.kernel.org/netdev/net-next/c/215da896df6c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


