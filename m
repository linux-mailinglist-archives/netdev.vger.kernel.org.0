Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADD645F7B0
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 01:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344478AbhK0Az2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 19:55:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344296AbhK0Ax2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Nov 2021 19:53:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93808C06175B
        for <netdev@vger.kernel.org>; Fri, 26 Nov 2021 16:50:14 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2E31B8299C
        for <netdev@vger.kernel.org>; Sat, 27 Nov 2021 00:50:12 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 0DFF2600AA;
        Sat, 27 Nov 2021 00:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637974211;
        bh=8mBHhhLKJEqstWVCGZyXo22WNtFwf5jMUYGQsGWYDYo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Aq/fqYwnDIKZXg6vnSFz6y97PiyXBhp8CK6nMb+KToaUn/FiDS4MZquiRZ+01cMrN
         9frep4UBTVs4rhKUymX7dzyJBcSIw3d+gx04yufjbngZurTiNUbomA0HIjxRrnJxOe
         dXZ0CnqXB1XUohbDIZB/7Vr/tFaQnYLDxG4Wel326nxwfKmNADyO5lQ9HJPgDECS3i
         /F6qkGXPVOdHSUap8p640zvST2g+eGi3RSIT9XpbXVSzmx5jF6NZlyYZe4TYPUJNR1
         T17jtYw+VUlof4aUTTmNAhmsGBG/93uQhLgkHfawAaOTT0wb3r8psvy1zAvjB0yO7Z
         wFslPzy57okgg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EFAA560BE2;
        Sat, 27 Nov 2021 00:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v3] net: ethtool: set a default driver name
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163797421097.20298.14139291532822935249.git-patchwork-notify@kernel.org>
Date:   Sat, 27 Nov 2021 00:50:10 +0000
References: <20211125163049.84970-1-xiangxia.m.yue@gmail.com>
In-Reply-To: <20211125163049.84970-1-xiangxia.m.yue@gmail.com>
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        leon@kernel.org, arnd@arndb.de, chenhao288@hisilicon.com,
        hkallweit1@gmail.com, gustavoars@kernel.org, danieller@nvidia.com,
        andrew@lunn.ch, leonro@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 26 Nov 2021 00:30:49 +0800 you wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> The netdev (e.g. ifb, bareudp), which not support ethtool ops
> (e.g. .get_drvinfo), we can use the rtnl kind as a default name.
> 
> ifb netdev may be created by others prefix, not ifbX.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: ethtool: set a default driver name
    https://git.kernel.org/netdev/net-next/c/bde3b0fd8055

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


