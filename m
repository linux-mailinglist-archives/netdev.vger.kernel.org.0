Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9685A41FCB2
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 17:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233468AbhJBPVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 11:21:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232575AbhJBPVx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 2 Oct 2021 11:21:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7917161B21;
        Sat,  2 Oct 2021 15:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633188007;
        bh=YJYyP9axb7xwZ0VEBvGaxpql7EFNPlKqIZDSS/WIN44=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BTjgLcfJ3zBn15QJKH1j3rRJMHRWTkjXDgUs5mTw5DFF9qcRQbsMwDrFIdLOWEkzS
         VW/a+0G66WkLYjibbGhepp2OmZBt3OWjJdkkp9bBqpxVhku3Hofs/NPzf7d2xwqdKZ
         bRBFXX9Dlcl0Bp5Yx6n8PJqX0ykMBgvt1HwXakCRJw6zXU+yFGoMwsdl4suiC/hw2E
         msmCQGthmO41QTJ9g9C47eJMHi831DFMTwojIHQDw0B0vBW9xBHi7AGrjEhAYuyAbq
         7bN8E239yoehMVOi6PRH18INQqMKw16kwGy+DGHaX9hD2uAH1WKwRDRQef0yBXMNB5
         t4j7jofWtl8Cw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7231D600AB;
        Sat,  2 Oct 2021 15:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: wwan: iosm: correct devlink extra params
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163318800746.15445.8256454747829483471.git-patchwork-notify@kernel.org>
Date:   Sat, 02 Oct 2021 15:20:07 +0000
References: <20211002143212.282851-1-m.chetan.kumar@linux.intel.com>
In-Reply-To: <20211002143212.282851-1-m.chetan.kumar@linux.intel.com>
To:     M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        johannes@sipsolutions.net, ryazanov.s.a@gmail.com,
        loic.poulain@linaro.org, krishna.c.sudi@intel.com,
        m.chetan.kumar@intel.com, linuxwwan@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat,  2 Oct 2021 20:02:12 +0530 you wrote:
> 1. Removed driver specific extra params like download_region,
>    address & region_count. The required information is passed
>    as part of flash API.
> 2. IOSM Devlink documentation updated to reflect the same.
> 
> Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: wwan: iosm: correct devlink extra params
    https://git.kernel.org/netdev/net-next/c/b8aa16541d73

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


