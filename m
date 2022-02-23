Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6CFB4C06A7
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 02:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236120AbiBWBKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 20:10:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234529AbiBWBKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 20:10:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8240F60D9
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 17:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 200496144F
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 01:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83CD6C340F4;
        Wed, 23 Feb 2022 01:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645578610;
        bh=QOyuGKBNpNv+W6/pVbcvm5shEwGgNuysHtksNCobmiA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WFbE0y6jVlWzCXaoyzJTXzEFVxbDPNicMoyjbgCuBv2hkGwY8mR0iYWZJwL9hBjJL
         SOdUCBVi+mI49WpI+PzY2t+i2yAFU2Vl4VcTmMSLp78weOmtloFkebQxdqpy3rzxXy
         8CwCyenS06IrO7p/V7wECL1abuZJYvyfIeE/itn7crafuAJskUZ3b4lPankLJEeLFG
         RgoiT669ABreG64AUUMlQrP2D3bDTNOAUVXVMYAqUQ/nFoMqo2FVbZd3EzLYGMSSBs
         yIyH14WRLzY12okTME0KMzW/smyBrwlproVCQkpNFDFsJyKspCwYXTe0UvIxOSEq8F
         FVDsBThaL0fHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 70CFDE73590;
        Wed, 23 Feb 2022 01:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: phylink: fix DSA mac_select_pcs()
 introduction
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164557861045.30746.11160734387004397736.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Feb 2022 01:10:10 +0000
References: <E1nMCD6-00A0wC-FG@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1nMCD6-00A0wC-FG@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     olteanv@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, netdev@vger.kernel.org
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

On Mon, 21 Feb 2022 17:10:52 +0000 you wrote:
> Vladimir Oltean reports that probing on DSA drivers that aren't yet
> populating supported_interfaces now fails. Fix this by allowing
> phylink to detect whether DSA actually provides an underlying
> mac_select_pcs() implementation.
> 
> Reported-by: Vladimir Oltean <olteanv@gmail.com>
> Fixes: bde018222c6b ("net: dsa: add support for phylink mac_select_pcs()")
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> 
> [...]

Here is the summary with links:
  - [net-next] net: phy: phylink: fix DSA mac_select_pcs() introduction
    https://git.kernel.org/netdev/net-next/c/1054457006d4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


