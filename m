Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E93C8465C5A
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 04:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355069AbhLBDD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 22:03:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355049AbhLBDDf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 22:03:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CB7C061748;
        Wed,  1 Dec 2021 19:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 741B0CE2161;
        Thu,  2 Dec 2021 03:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9D5D7C53FD0;
        Thu,  2 Dec 2021 03:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638414009;
        bh=uM3kZTvQUL2wFJbHg4TF3Fza4zm19zNXQ8R8Degy2ww=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CtQtJ6z2+FsIjz4QXlXaOMKlYUJ1lO4S8wtoKRu5IVW2kg37idr0umeq03IOQH3nr
         ZNPW84NeGgkZ8FZcH//5Z9dnn6zmiKXdfXoy3JPlvgFVJ1AnWt3WyaX6OHA0MYMVs6
         y3gGZ4KEI0NKj5WArPmMUpy0ToG6Gq6cczwrSU0tjAO7eQG79bSQ2KCndQzTGKHJbv
         HcBehcoEFJizYKkXzdoTYKpKLLDpnTGxc40z0G7BwCw0a8cokVsnjLAXEA7XCkrVLV
         6n1hiyCBuXSOPA4ufdUZII+rfK8hCZ9pkDs5FY2trX4J2SEbG5d3XtNxyuMTVXzL/u
         gWyXj1LyFtGKw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8A89A60A59;
        Thu,  2 Dec 2021 03:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mdio: mscc-miim: Add depend of REGMAP_MMIO on
 MDIO_MSCC_MIIM
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163841400956.24500.13032222988826524797.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Dec 2021 03:00:09 +0000
References: <20211130110209.804536-1-dtcccc@linux.alibaba.com>
In-Reply-To: <20211130110209.804536-1-dtcccc@linux.alibaba.com>
To:     Tianchen Ding <dtcccc@linux.alibaba.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org,
        colin.foster@in-advantage.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 30 Nov 2021 19:02:09 +0800 you wrote:
> There's build error while CONFIG_REGMAP_MMIO is not set
> and CONFIG_MDIO_MSCC_MIIM=m.
> 
> ERROR: modpost: "__devm_regmap_init_mmio_clk"
> [drivers/net/mdio/mdio-mscc-miim.ko] undefined!
> 
> Add the depend of REGMAP_MMIO to fix it.
> 
> [...]

Here is the summary with links:
  - net: mdio: mscc-miim: Add depend of REGMAP_MMIO on MDIO_MSCC_MIIM
    https://git.kernel.org/netdev/net-next/c/8057cbb8335c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


