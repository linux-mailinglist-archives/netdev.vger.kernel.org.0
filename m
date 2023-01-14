Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF04B66A990
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 07:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjANGKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 01:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjANGKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 01:10:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5D630D3
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 22:10:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 567B2B8075C
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 06:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EA55FC433F1;
        Sat, 14 Jan 2023 06:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673676621;
        bh=BRoY+bk4FXKAgtc2DoQ0dSda2JvLBCZeFlGgnmMThds=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aC9q7wqLgTZiDJy5DTbp5o8leKKARk3xdNTXbbek+5ATVqR2ks095tMWN3QaFjD9m
         p86cr4wRRcQ/6zdp30P2cWZaBQ6xisAaxr4daiP+JJ+P5RuSQwYYW/Zm9lCMeBLrh+
         rbIIkYiaFkDKnROvbv/9Xhs2txoK4Vef4c581hskuh0pn5JqRRtImZLUhiKADQUnZi
         vO00mnY8ngizaybWQ6HclI7kGPxL4ezdxF+UIBSg2vevK10udeSpXYg4k/VLmBK/qe
         um/axgF3eyaEhRhRTVvwtYzj6b9u4hUyrpAq3vtW6r5fuMOzv1UjMS1TWqEgexE2Eb
         2p9aMEF+yrfxQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CB130C395CA;
        Sat, 14 Jan 2023 06:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: pcs: pcs-lynx: use phylink_get_link_timer_ns()
 helper
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167367662082.24172.16078354754374977057.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Jan 2023 06:10:20 +0000
References: <E1pFyhW-0067jq-Fh@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1pFyhW-0067jq-Fh@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, ioana.ciornei@nxp.com, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 12 Jan 2023 14:37:06 +0000 you wrote:
> Use the phylink_get_link_timer_ns() helper to get the period for the
> link timer.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/pcs/pcs-lynx.c | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)

Here is the summary with links:
  - [net-next] net: pcs: pcs-lynx: use phylink_get_link_timer_ns() helper
    https://git.kernel.org/netdev/net-next/c/e2a9575025fe

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


