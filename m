Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 881AE6DB87F
	for <lists+netdev@lfdr.de>; Sat,  8 Apr 2023 05:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229783AbjDHDKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 23:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDHDKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 23:10:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E8ACA0D
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 20:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D21C46552D
        for <netdev@vger.kernel.org>; Sat,  8 Apr 2023 03:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2EE69C4339C;
        Sat,  8 Apr 2023 03:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680923420;
        bh=CfCeXl8q/07dq1dhVX7n2ybua/2fD/no/1tbeJLHymc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DgIJbH7A2taTVkVJweUeR/a9ydk1lPDmsIiHQcpmzqktdRhfskr0kQmd/LwU5Pke8
         rh8dyQoq9XgohWqdnHlOZ3OPEHzYwhmaDWELNYl4ypqpRurLNU3vOke6730gXw/ZL3
         EgRZTvShucH+mWAG+m6JRWWBIPhi9y7gb3wVlVt2eJBZZsRIOHUBU9MeVT9bbZbeqs
         BlfLLIanYngbzlpyAqW4TjpDXVIzeTfHO3tue7/bWVqGewmzfSsFdsdUd834xRqTM3
         5tJh01zlfhYS790kZ8m+584KVBxhX/AfWSJhqIdaUejbvJomQY0x4D3wmsTxYu8beR
         WQVsazz6cM5IA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0EA05E21EF2;
        Sat,  8 Apr 2023 03:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: stmmac: remove set but unused mask in
 stmmac_ethtool_set_link_ksettings()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168092342005.22423.17778361822558891683.git-patchwork-notify@kernel.org>
Date:   Sat, 08 Apr 2023 03:10:20 +0000
References: <20230406125412.48790-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230406125412.48790-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, andrew@lunn.ch,
        f.fainelli@gmail.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  6 Apr 2023 15:54:12 +0300 you wrote:
> This was never used since the commit that added it - e58bb43f5e43
> ("stmmac: initial support to manage pcs modes").
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 9 ---------
>  1 file changed, 9 deletions(-)

Here is the summary with links:
  - [net-next] net: stmmac: remove set but unused mask in stmmac_ethtool_set_link_ksettings()
    https://git.kernel.org/netdev/net-next/c/07e75db6b1b2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


