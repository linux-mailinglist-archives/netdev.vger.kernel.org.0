Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 334443F1943
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 14:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239558AbhHSMar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 08:30:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237181AbhHSMan (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 08:30:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 53AF06113B;
        Thu, 19 Aug 2021 12:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629376207;
        bh=To182//YcJ1LCAQ8opO9ETogE0IQmzChUZQqM0g2+bo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZVTHY92pZYfEZLEZDGMBk5614wO4FW9vbScB9Gp+FCGEtz+sMUL/gs+RlOHyWUQH3
         e2YUaLrnezWpPDMdSP51q3vaC4TFEVeseB11kYytioN39c4N8BBlU6LL6IPNc0ucbN
         WIS/Ojy2N8nU1s3JjQMWJ/1H5VLDypYfUmM1GxpH/8/Gn7E0x9w84yxOfE1bAaqWH1
         k75E/+V5er4pxGkO4BusL/ybsUCvkSdVM6O/bvAtA4NLvktDGocHCm72/Dh28m7GJR
         gzwnEA/SAcBoTpdHL/mjlyZ18KE7WdNdgg11s3xpIQYIk7z4mWtsuOOoaK8WS+KZ5v
         JPBHUyvN7Vw4g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 483F160997;
        Thu, 19 Aug 2021 12:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: ti: cpsw: make array stpa static const,
 makes object smaller
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162937620729.15458.551511596902094158.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Aug 2021 12:30:07 +0000
References: <20210819120443.7083-1-colin.king@canonical.com>
In-Reply-To: <20210819120443.7083-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     grygorii.strashko@ti.com, davem@davemloft.net, kuba@kernel.org,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 19 Aug 2021 13:04:43 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Don't populate the array stpa on the stack but instead it
> static const. Makes the object code smaller by 81 bytes:
> 
> Before:
>    text    data   bss    dec    hex filename
>   54993   17248     0  72241  11a31 ./drivers/net/ethernet/ti/cpsw_new.o
> 
> [...]

Here is the summary with links:
  - net: ethernet: ti: cpsw: make array stpa static const, makes object smaller
    https://git.kernel.org/netdev/net-next/c/5c8a2bb48159

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


