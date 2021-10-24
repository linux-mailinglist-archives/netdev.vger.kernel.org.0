Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 062E04388E0
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 14:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbhJXMma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 08:42:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230300AbhJXMm2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 08:42:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 780E260FE7;
        Sun, 24 Oct 2021 12:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635079207;
        bh=vEsz1uJ/6kRB/fN8p8/QjebUEZBt5W5x5M4m5TL4nrE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EcBjvZ48RmupRI1a0cxvLEoZCOV83FpS9fZnNetaqAaGU0ubtiuiXF9Z2FcnCf30G
         59PuCver5tSDknCfJiBzCyaKTcmewnF1beLtjMuRpw7MkkfNB5F8tOyQmJ/mKaz0Fm
         2k6AKvT+30/fFWH5KFNcl9O3AyVue7Hv3xIPm6l0AKsv54F9PrterglNbV3C8cCa+9
         qyoWya4I3TXtneZ92Ou0iAJ1LDLZdrehe8YheLVsE0SV+eMm5VfdLioPUiBnXn2v91
         tm2L52fTHvLDjcRKHogvDmJ0dQAXl6Lxpy23bW6ugecjxQkbPi5SGfdr47GFnCwg/y
         EqrH1h1KvH3rw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6B0B8609D5;
        Sun, 24 Oct 2021 12:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH] octeontx2-af: Increase number of reserved entries in
 KPU
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163507920743.28969.12375546554086732873.git-patchwork-notify@kernel.org>
Date:   Sun, 24 Oct 2021 12:40:07 +0000
References: <20211022124537.3101126-1-kirankumark@marvell.com>
In-Reply-To: <20211022124537.3101126-1-kirankumark@marvell.com>
To:     <kirankumark@marvell.com>
Cc:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 22 Oct 2021 18:15:37 +0530 you wrote:
> From: Kiran Kumar K <kirankumark@marvell.com>
> 
> With current KPU profile, we have 2 reserved entries which can
> be loaded from firmware to parse custom headers. Adding changes
> to increase these reserved entries to 6.
> And also removed KPU entries for unused LTYPEs like
> NPC_LT_LA_IH_8_ETHER, NPC_LT_LA_IH_4_ETHER, NPC_LT_LA_IH_2_ETHER
> 
> [...]

Here is the summary with links:
  - [net-next] octeontx2-af: Increase number of reserved entries in KPU
    https://git.kernel.org/netdev/net-next/c/db690aecafd1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


