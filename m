Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8365A319833
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 03:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhBLCKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:10:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:40700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229521AbhBLCKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 21:10:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id F11DA64E44;
        Fri, 12 Feb 2021 02:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613095808;
        bh=WWZq60lKjBbV1QGpCo+4xQ4EhtmI2S3/9grhTT5qphI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qQFdgDPq9zN2OQ0l4bBzJHYqnC6g3uO6CmHbmcinzeFq/mjWKEydlfEFqN/oX2scI
         2T2hpqxIYso9CS6kRsBY0YeNif+Ed0cuHNtO6PM5PHOfpJRtFaZSuqGqaizvf57Ifg
         VMKHphzDk9NoF6rjeAZ8uIpNtOa2e9VRtqlKUdiQTLWX+bGEBwnF3FXPP5NIgsrqF/
         zrdLR9buMN4MbqwYV3r+bFSdb650y3xBhp2tBdcYuJwPCCg9GzRjdy2gz91k27/9aC
         gv52xrQlXDvI8EWzikas7dlLYkXGUM/dd1JFi2cAdkh9jABqjrVRbS6tlzSPmxosJ4
         1a2v6MoytddpA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DD27360951;
        Fri, 12 Feb 2021 02:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/4] net: ti: am65-cpsw-nuss: Add switchdev driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161309580790.7705.13800045098803596831.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Feb 2021 02:10:07 +0000
References: <20210211105644.15521-1-vigneshr@ti.com>
In-Reply-To: <20210211105644.15521-1-vigneshr@ti.com>
To:     Vignesh Raghavendra <vigneshr@ti.com>
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        jiri@nvidia.com, grygorii.strashko@ti.com, andrew@lunn.ch,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 11 Feb 2021 16:26:40 +0530 you wrote:
> This series adds switchdev support for AM65 CPSW NUSS driver to support
> multi port CPSW present on J721e and AM64 SoCs.
> It adds devlink hook to switch b/w switch mode and multi mac mode.
> 
> v2:
> Rebased on latest net-next
> Update patch 1/4 with rationale for using devlink
> 
> [...]

Here is the summary with links:
  - [v2,1/4] net: ti: am65-cpsw-nuss: Add devlink support
    https://git.kernel.org/netdev/net-next/c/58356eb31d60
  - [v2,2/4] net: ti: am65-cpsw-nuss: Add netdevice notifiers
    https://git.kernel.org/netdev/net-next/c/2934db9bcb30
  - [v2,3/4] net: ti: am65-cpsw-nuss: Add switchdev support
    https://git.kernel.org/netdev/net-next/c/86e8b070b25e
  - [v2,4/4] docs: networking: ti: Add driver doc for AM65 NUSS switch driver
    https://git.kernel.org/netdev/net-next/c/e276cfb9cd5b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


