Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C55C656C676
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 05:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiGIDkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 23:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiGIDkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 23:40:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A6D820DA
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 20:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8499ACE29A7
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 03:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5177C341D1;
        Sat,  9 Jul 2022 03:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657338014;
        bh=IG0+GERQ4uT02bt+AvZZH1fmdWihs2XjCcOMHOT0QAU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r3hGr8NchhzqJXPd4MaiZs1y0GugCqYnA6dejie5AIV3KZoU52c8XiLspTZCBynjt
         QXNZzzdXWcS/Q/CyTXIlFBRaWUYNBrmg8m549lHFS5qMtMLnrdqNM37zzpcvDax/VV
         d7dMXNF+SxcmNiwe1A66H6niurmKt4bbveVFwlxus4XgTvTvEeT1IhLbc7/1Ze4b3n
         DqtbgpPh53GDKjJH3ctp5b6ng26NMDOQeB/dudsjZloMtckkJedP4mNRR5VN+6r0Hu
         KzFnLa3A0ppO595sddAC14Xfd2Us8YKuk/PQHzYjzuCnAz5lQ2QK3HOfWF3TBPdI4k
         cDv0+ACv2GstA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B1690E45BE1;
        Sat,  9 Jul 2022 03:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phylink: fix SGMII inband autoneg enable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165733801472.11477.5753843751071771176.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Jul 2022 03:40:14 +0000
References: <E1o9Ng2-005Qbe-3H@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1o9Ng2-005Qbe-3H@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robert.hancock@calian.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 07 Jul 2022 10:20:02 +0100 you wrote:
> When we are operating in SGMII inband mode, it implies that there is a
> PHY connected, and the ethtool advertisement for autoneg applies to
> the PHY, not the SGMII link. When in 1000base-X mode, then this applies
> to the 802.3z link and needs to be applied to the PCS.
> 
> Fix this.
> 
> [...]

Here is the summary with links:
  - [net-next] net: phylink: fix SGMII inband autoneg enable
    https://git.kernel.org/netdev/net-next/c/6d1ce9c03880

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


