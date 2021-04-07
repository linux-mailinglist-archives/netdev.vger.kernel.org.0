Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 546DD357760
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 00:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbhDGWKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 18:10:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229640AbhDGWKW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 18:10:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F067761353;
        Wed,  7 Apr 2021 22:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617833412;
        bh=MbeWD88f8jD0gLyIm+8WMDx6sspBJX9rWdchSIgUtEk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X8xWWYTJH9c1NnC8n0SVZVMi41apHOxN08RTNuIYH67GBb9/nrPuMD++GisENSifS
         /q3ReuDCw2eI5gSlL+XQY3e+DG53PlSsN8+epaWsPbVAXTFNmH+NDFTKq/zn5fvq67
         DF9EDVi9UP8TTMRHm/wVP7EQvbvHiPABYpR7Wf5pwkN/SPvBxAabb7AVv+R5ep55Ou
         z8fR2PYJ5aQBaNSZniDniIOAVgODzWUo0uxPs1V4mmcTxfpVZ7bhJptj2RfhvK7YEe
         2Bbahnu4NpvYLyUNigEJ6FSQT78nSxE52LS/BCd9IkTZPoUTIqTR1SCeZ7izY7OCgt
         GQWwLXAb0kR2Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EB091609D8;
        Wed,  7 Apr 2021 22:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] liquidio: Fix unintented sign extension of a left shift of a
 u16
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161783341195.5631.6736576843347914096.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 22:10:11 +0000
References: <20210407101248.485307-1-colin.king@canonical.com>
In-Reply-To: <20210407101248.485307-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        davem@davemloft.net, kuba@kernel.org,
        rvatsavayi@caviumnetworks.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed,  7 Apr 2021 11:12:48 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The macro CN23XX_PEM_BAR1_INDEX_REG is being used to shift oct->pcie_port
> (a u16) left 24 places. There are two subtle issues here, first the
> shift gets promoted to an signed int and then sign extended to a u64.
> If oct->pcie_port is 0x80 or more then the upper bits get sign extended
> to 1. Secondly shfiting a u16 24 bits will lead to an overflow so it
> needs to be cast to a u64 for all the bits to not overflow.
> 
> [...]

Here is the summary with links:
  - liquidio: Fix unintented sign extension of a left shift of a u16
    https://git.kernel.org/netdev/net-next/c/298b58f00c0f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


