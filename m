Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D275A4C068B
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 02:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234987AbiBWBAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 20:00:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiBWBAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 20:00:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9296D37A0E;
        Tue, 22 Feb 2022 17:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EDB2B81D9D;
        Wed, 23 Feb 2022 01:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EFF29C340F0;
        Wed, 23 Feb 2022 01:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645578010;
        bh=LYwytnWXHxfxYXram32RAbeJJAgXCd4/bODGE0oMfRc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I7qnbb/nQCLummg3I+raqCm2V0jD6oWcVkkeiRSFGp4DiDB6RORO7l/xc9/cHP8Mx
         EG7FxvaB3WuKzThxsevoA5P1oxSd2i2G9aYkPX2MRm0NI2g1N3LNQWYJF+LTZpzH78
         lagrBxNIRYePMuSGU8LY44KGHRmjETn5ci0TkUFMFBP1EPCdlxxuPsGUeH/fjuCRLx
         ce5AApens3voruVf7V+aXFvgbkStxod+IrWZAf2Wrew5AcpeVjMcTG69f7MbHX+e6C
         z8ezgjYZJpZIjXDMOGo8K5n96ZZtp08nBf8zyT1ERaj1u1e2DPP23FKB/KBFkPdMGM
         nPhEZSy/EX6uQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D98FCEAC081;
        Wed, 23 Feb 2022 01:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 1/1] net: dsa: microchip: ksz9477: reduce polling
 interval for statistics
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164557800988.26141.16016016627435094814.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Feb 2022 01:00:09 +0000
References: <20220221084129.3660124-1-o.rempel@pengutronix.de>
In-Reply-To: <20220221084129.3660124-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 21 Feb 2022 09:41:29 +0100 you wrote:
> 30 seconds is too long interval especially if it used with ip -s l.
> Reduce polling interval to 5 sec.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/dsa/microchip/ksz_common.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next,v1,1/1] net: dsa: microchip: ksz9477: reduce polling interval for statistics
    https://git.kernel.org/netdev/net-next/c/12c740c8683f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


