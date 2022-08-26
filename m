Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B76C5A2423
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 11:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343558AbiHZJUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 05:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237428AbiHZJUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 05:20:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C5F3A0607;
        Fri, 26 Aug 2022 02:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB50761DA9;
        Fri, 26 Aug 2022 09:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2039DC433D7;
        Fri, 26 Aug 2022 09:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661505616;
        bh=leeSq0uhsvsZ1M2h4b37Xow0Nd4SXYxO05PCnzc1ujo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WRzDm/opsY29XW/smmD8KDuSwhWdAuF7RIiOSsiNOCmH7bY9ke/MbLTh7cjp5oJe1
         EwG9frPwDjv7qaCq6sY509JPbQOOT1DNCSHx4r/ZzWaV/CynEhjf/nrMw0rxDia0xm
         CQPnPly9hg/2GnOt3TwmrEKIwU3XyVc2XnMwWd4FAHbq7OJmXPcRX2Ee3CqF+nqQvY
         ZWftgwPowkGUkISL4AklQBYT0UZnkgjV5Tirihz08IFYfbJQDaoaBnOJ84Rs/4adZq
         PrI4o6HXEdkNGe1TFZ7sEb8/hq9mHamSGUBMhPvSwe3FMdRNpGP8RfoBmCqN/qzdX5
         UNiGbz2jeVTGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F3E4AE2A03B;
        Fri, 26 Aug 2022 09:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 1/2] net: asix: ax88772: migrate to phylink
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166150561599.22218.15711919447360089727.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Aug 2022 09:20:15 +0000
References: <20220822123943.2409987-1-o.rempel@pengutronix.de>
In-Reply-To: <20220822123943.2409987-1-o.rempel@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        lukas@wunner.de, linux@armlinux.org.uk
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

On Mon, 22 Aug 2022 14:39:42 +0200 you wrote:
> There are some exotic ax88772 based devices which may require
> functionality provide by the phylink framework. For example:
> - US100A20SFP, USB 2.0 auf LWL Converter with SFP Cage
> - AX88772B USB to 100Base-TX Ethernet (with RMII) demo board, where it
>   is possible to switch between internal PHY and external RMII based
>   connection.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: asix: ax88772: migrate to phylink
    https://git.kernel.org/netdev/net-next/c/e0bffe3e6894
  - [net-next,v2,2/2] net: asix: ax88772: add ethtool pause configuration
    https://git.kernel.org/netdev/net-next/c/6661918c3b59

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


