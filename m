Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3F7769C844
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 11:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbjBTKKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 05:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229688AbjBTKKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 05:10:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B40ECC2B
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 02:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98AF260DBF
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 10:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09E58C4339E;
        Mon, 20 Feb 2023 10:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676887817;
        bh=k1eQgEORa4EzYCZ1PUK6fNmuZNUevuOFiaSy09q1xYA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bdQAP3Dq715ogrIX3fM7vv/FK7imDRaopJGCf6vPm16pOGt2mTSmt7mgstbAaWlkk
         x5oCyJiieapBvCe/T+36fhP/hXtuf27UxE+KJHVGycueXKnLZE7CDZAgiZ8Ts/I7fM
         NYm3hN9jqMGKxuSvKr+OkndmSrXkzr4I4Hj2cCMa8JfLZxNnb77G7ZwkrAEMn58w4h
         f3G/MAeWu6XzmrXXyDM6qvoA0gXnloxpNqUTsPJd2GZr+Xs4QdnzRgfxT5fOAt/2js
         iuE+qfV0HEbxu9T9ejbeT5sWJLaph89R7nQM/6rmh4UDgu2UjtsUatMeWF+3jTtkq7
         RmU+RjPSE3+CQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EB2F0E68D23;
        Mon, 20 Feb 2023 10:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Add additional phydev locks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167688781696.25409.9806793382078281550.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Feb 2023 10:10:16 +0000
References: <20230217030714.1249009-1-andrew@lunn.ch>
In-Reply-To: <20230217030714.1249009-1-andrew@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, rmk+kernel@armlinux.org.uk,
        hkallweit1@gmail.com, f.fainelli@gmail.com
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

On Fri, 17 Feb 2023 04:07:12 +0100 you wrote:
> The phydev lock should be held when accessing members of phydev, or
> calling into the driver. Some of the phy_ethtool_ functions are
> missing locks. Add them. To avoid deadlock the marvell driver is
> modified since it calls one of the functions which gain locks, which
> would result in a deadlock.
> 
> The missing locks have not caused noticeable issues, so these patches
> are for net-next.
> 
> [...]

Here is the summary with links:
  - [=PATCH,net-next,1/2] net: phy: marvell: Use the unlocked genphy_c45_ethtool_get_eee()
    https://git.kernel.org/netdev/net-next/c/3365777a6a22
  - [=PATCH,net-next,2/2] net: phy: Add locks to ethtool functions
    https://git.kernel.org/netdev/net-next/c/2f987d486610

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


