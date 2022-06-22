Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D86155425E
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 07:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356811AbiFVFuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 01:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357048AbiFVFuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 01:50:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18D403668C;
        Tue, 21 Jun 2022 22:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAC7BB81C24;
        Wed, 22 Jun 2022 05:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 70ED6C36AE9;
        Wed, 22 Jun 2022 05:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655877014;
        bh=zFTcpDkQx08dBR+1kPcZE7RFg9ZDHD+25+N4itjWW0E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mHo6DTLhtLpzH+VYm74yylETa4cKHTdxSNAzonDwiMv1cUvpcxEXPUdgy4Nohxs52
         JDKw2tsOrmMPlnzyl2h45c7L4QG3Lz8XC1HGfqEPOIdiN4jxqUhV/YlFc6Fr1sMBjy
         Nx4rFIzjxf6NFaXkczfbCvz6kJs4HZ9fR/wvXCNSuHX7TDnzlTwk19fBavJSzRk8B0
         7xXPtFIBYu1g1Pk6iQ+8RxfPolGIeVrcAx//2aoHhy8Ytgdgk7EO+auIl5c9vCpj1U
         O+bQiynR7dhb1tjKtpox2wtRfGIwp2D3ouHRezT16SlEHu2Zes0gS+VfbL2J9L3xyN
         cLWUcd+Vpjy2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5CEEFE574DA;
        Wed, 22 Jun 2022 05:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 1/1] net: phy: dp83td510: add SQI support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165587701437.11274.5244454746330832022.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Jun 2022 05:50:14 +0000
References: <20220620115601.2035452-1-o.rempel@pengutronix.de>
In-Reply-To: <20220620115601.2035452-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
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

On Mon, 20 Jun 2022 13:56:01 +0200 you wrote:
> Convert MSE (mean-square error) values to SNR and split it SQI (Signal Quality
> Indicator) ranges. The used ranges are taken from "OPEN ALLIANCE - Advanced
> diagnostic features for 100BASE-T1 automotive Ethernet PHYs"
> specification.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/1] net: phy: dp83td510: add SQI support
    https://git.kernel.org/netdev/net-next/c/a80d8fb70cc7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


