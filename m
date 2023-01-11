Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA6C665718
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 10:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbjAKJOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 04:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238425AbjAKJOJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 04:14:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC137BE28;
        Wed, 11 Jan 2023 01:10:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5F929B81ACE;
        Wed, 11 Jan 2023 09:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1F7EC433EF;
        Wed, 11 Jan 2023 09:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673428219;
        bh=42gL1q+GkZgt9fX2//DcHxxejEgYJTpJAhZ1nV5h5cc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ma5uFwIY9ynUxhmWaSUEHFE+DmL43KU8WXadcjMenbmQ+Ny4etnC46SRobdPbvKoI
         O9q7dYY2OKOh03hdkScppXcgwuIrx/u4ygbMXV47PqhVO7n3KXYnWs+OQlj5fy4xn0
         RewEUvrZpYZ6TKUfam7+Epk7jEd1Y3s2Kcmat/LWzbRlvJJz7fkpBNQEvMUxXRFH5x
         Iy8E9zuBbJYQCLJCgE4BJKJ9Qn2FTu676sBDC9qn2d1hRT4BjA/TcqKo4qnIsZfoOk
         peS9PALxHGd6u8woa8VxqcHmQBsSjPAQqbbRqw8RGPGIVuXMMGExoksMYhlnXq80ht
         66YD0XBaBcSGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CB594E45233;
        Wed, 11 Jan 2023 09:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next 0/5] add PLCA RS support and onsemi NCN26000
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167342821882.24876.7581626078662045769.git-patchwork-notify@kernel.org>
Date:   Wed, 11 Jan 2023 09:10:18 +0000
References: <cover.1673282912.git.piergiorgio.beruto@gmail.com>
In-Reply-To: <cover.1673282912.git.piergiorgio.beruto@gmail.com>
To:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, o.rempel@pengutronix.de,
        mailhol.vincent@wanadoo.fr, sudheer.mogilappagari@intel.com,
        sbhatta@marvell.com, linux-doc@vger.kernel.org,
        wangjie125@huawei.com, corbet@lwn.net, lkp@intel.com,
        gal@nvidia.com, gustavoars@kernel.org, bagasdotme@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 9 Jan 2023 17:59:25 +0100 you wrote:
> This patchset adds support for getting/setting the Physical Layer
> Collision Avoidace (PLCA) Reconciliation Sublayer (RS) configuration and
> status on Ethernet PHYs that supports it.
> 
> PLCA is a feature that provides improved media-access performance in terms
> of throughput, latency and fairness for multi-drop (P2MP) half-duplex PHYs.
> PLCA is defined in Clause 148 of the IEEE802.3 specifications as amended
> by 802.3cg-2019. Currently, PLCA is supported by the 10BASE-T1S single-pair
> Ethernet PHY defined in the same standard and related amendments. The OPEN
> Alliance SIG TC14 defines additional specifications for the 10BASE-T1S PHY,
> including a standard register map for PHYs that embeds the PLCA RS (see
> PLCA management registers at https://www.opensig.org/about/specifications/).
> 
> [...]

Here is the summary with links:
  - [v4,net-next,1/5] net/ethtool: add netlink interface for the PLCA RS
    https://git.kernel.org/netdev/net-next/c/8580e16c28f3
  - [v4,net-next,2/5] drivers/net/phy: add the link modes for the 10BASE-T1S Ethernet PHY
    https://git.kernel.org/netdev/net-next/c/16178c8ef53d
  - [v4,net-next,3/5] drivers/net/phy: add connection between ethtool and phylib for PLCA
    https://git.kernel.org/netdev/net-next/c/a23a1e57a677
  - [v4,net-next,4/5] drivers/net/phy: add helpers to get/set PLCA configuration
    https://git.kernel.org/netdev/net-next/c/493323416fed
  - [v4,net-next,5/5] drivers/net/phy: add driver for the onsemi NCN26000 10BASE-T1S PHY
    https://git.kernel.org/netdev/net-next/c/b53e7e8d8557

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


