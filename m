Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04911396CE4
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 07:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231607AbhFAFlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 01:41:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229477AbhFAFln (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 01:41:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2A2D661370;
        Tue,  1 Jun 2021 05:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622526003;
        bh=IWMWX+rAbMpURQf3ziJb2mkS7aqHn/qFD79CdVgGB/Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aC6atCRAl0sDY7ExSsFSP/f0MAcxN2wCLZISMUzHz5BHpJhbWZfO7EJUe//Wq01gf
         xBFQnPjpzAXozV5vlp/NEuuYHT5On260aTB+h5OiGsh26m5CEEavHMXnM3QP/HDEur
         IhgI+wHOthkSuG6s5ENn91Zt7DGgGKJgnKgswsvpAkL/3p5I2AqqRpGvt84fY3AOy5
         dA9Mxgqvd7jYQu128oOcWYF7FnPrdBww/dgWLdjrY2lHB9scOQN8uEeW0fXRNeLlXa
         I3Z/PG7Dyh3F8ZeFhokkPnfnOxWhtH28gYjKmagR7qDfqntv0LQ5ZLW4uPwjtyf1Wn
         Rhi5ybIkpkkjA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1DB7C609D9;
        Tue,  1 Jun 2021 05:40:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bnx2x: Remove the repeated declaration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162252600311.31715.8402845462375431.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 05:40:03 +0000
References: <1622449756-2627-1-git-send-email-zhangshaokun@hisilicon.com>
In-Reply-To: <1622449756-2627-1-git-send-email-zhangshaokun@hisilicon.com>
To:     Shaokun Zhang <zhangshaokun@hisilicon.com>
Cc:     netdev@vger.kernel.org, aelior@marvell.com, skalluru@marvell.com,
        GR-everest-linux-l2@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 31 May 2021 16:29:16 +0800 you wrote:
> Function 'bnx2x_vfpf_release' is declared twice, so remove the
> repeated declaration.
> 
> Cc: Ariel Elior <aelior@marvell.com>
> Cc: Sudarsana Kalluru <skalluru@marvell.com>
> Cc: GR-everest-linux-l2@marvell.com
> Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
> 
> [...]

Here is the summary with links:
  - bnx2x: Remove the repeated declaration
    https://git.kernel.org/netdev/net-next/c/44fdd2edb36f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


