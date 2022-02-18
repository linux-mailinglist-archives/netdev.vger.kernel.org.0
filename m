Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8D4F4BB8A9
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 12:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234975AbiBRLuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 06:50:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234939AbiBRLub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 06:50:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 749C11B061E
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 03:50:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE1F6B82607
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 11:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A74E7C340EF;
        Fri, 18 Feb 2022 11:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645185011;
        bh=GGx7t9DGb8k3H0u/KRnEWV+onc2PZNE9uj7JErsPQ4A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gFuCrEbaFcPQ6d0XTvxpRJVEGa6m1lTrLEJTLqoT5esVgSQT6ssDZAE6H12Qhsw7K
         W4+jQvxVSlzQSjuEes12mZJZahPYcx3LApnp4SsJjezzzMZvhY1mMjXbr0HZd90Xu3
         a6vtv+/N6BoOHpPaG9SGWbnqUWRakKDlZPKitamHi6sWxBkyjXeHG/zvxzPi27ZSVp
         ebPD6d8li9+qCY8tjBdaXL/09CDjIdHW96vWkEQr5PXipBpNE7Wqa9gR+zFL/lX60f
         m1JrevfjmFB7f7QhqOQ0+cz04hlUsOEj5z4IhpCqs+O7kG/5jmM0bWrL8k/cLxXlKM
         8fv9glezhUo3g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 95538E7BB08;
        Fri, 18 Feb 2022 11:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/6] net: dsa: qca8k: convert to phylink_pcs and
 mark as non-legacy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164518501160.13243.1771737464674853600.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Feb 2022 11:50:11 +0000
References: <Yg6UHt2HAw7YTiwN@shell.armlinux.org.uk>
In-Reply-To: <Yg6UHt2HAw7YTiwN@shell.armlinux.org.uk>
To:     Russell King (Oracle) <linux@armlinux.org.uk>
Cc:     ansuelsmth@gmail.com, andrew@lunn.ch, davem@davemloft.net,
        f.fainelli@gmail.com, kuba@kernel.org, netdev@vger.kernel.org,
        vivien.didelot@gmail.com, olteanv@gmail.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 17 Feb 2022 18:29:50 +0000 you wrote:
> This series adds support into DSA for the mac_select_pcs method, and
> converts qca8k to make use of this, eventually marking qca8k as non-
> legacy.
> 
> Patch 1 adds DSA support for mac_select_pcs.
> Patch 2 and patch 3 moves code around in qca8k to make patch 4 more
> readable.
> Patch 4 does a simple conversion to phylink_pcs.
> Patch 5 moves the serdes configuration to phylink_pcs.
> Patch 6 marks qca8k as non-legacy.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/6] net: dsa: add support for phylink mac_select_pcs()
    https://git.kernel.org/netdev/net-next/c/bde018222c6b
  - [net-next,v2,2/6] net: dsa: qca8k: move qca8k_setup()
    https://git.kernel.org/netdev/net-next/c/3ce855f0408a
  - [net-next,v2,3/6] net: dsa: qca8k: move qca8k_phylink_mac_link_state()
    https://git.kernel.org/netdev/net-next/c/10728cd7967a
  - [net-next,v2,4/6] net: dsa: qca8k: convert to use phylink_pcs
    https://git.kernel.org/netdev/net-next/c/9612a8f9154f
  - [net-next,v2,5/6] net: dsa: qca8k: move pcs configuration
    https://git.kernel.org/netdev/net-next/c/7544b3ff745b
  - [net-next,v2,6/6] net: dsa: qca8k: mark as non-legacy
    https://git.kernel.org/netdev/net-next/c/d9cbacf0574a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


