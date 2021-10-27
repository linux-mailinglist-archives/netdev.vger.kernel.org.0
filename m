Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CC743D16F
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 21:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240559AbhJ0TMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 15:12:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240552AbhJ0TMd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 15:12:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5DF6C60EB4;
        Wed, 27 Oct 2021 19:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635361807;
        bh=GAklYL3rCh1qGamoJhgj6bSHRd1RB7dk37n7hwJ0+OQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J3gdFrjbb+1yXdDClDQyAY/HwE7is1MhCajKsyM+wxeReFULCHFGUB35KlpVWGXQ+
         SrK3OI9eH2s5p14MD/R5BvSG2jH7GW0Guf0DZnFKfJATZXFtMaGkLT0dSF3Ig8KeqX
         MqKUgwqTC6pATT2y+KCoKLhsHxMkzeXaNohmLY/gbN08Y2a7gc0fuODh1LCGPd1Gfb
         NtapfVi3mWtGIEN9t3zarvSAI4mOplsSyDqufynai565czpNNi1QZmooaWFWA/icWP
         m941Q1osgQRMsSlVZn7/3kbVT0LK3+JXPAxZwKPUWb3QOMUCKBg/SVkdGyX7mCm9hc
         yno4maZdvQ0yw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4F53760726;
        Wed, 27 Oct 2021 19:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] Two reverts to calm down devlink discussion
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163536180732.417.12653315027705238824.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Oct 2021 19:10:07 +0000
References: <cover.1635276828.git.leonro@nvidia.com>
In-Reply-To: <cover.1635276828.git.leonro@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, leonro@nvidia.com,
        jiri@nvidia.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 26 Oct 2021 22:40:40 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Hi,
> 
> Two reverts as was discussed in [1], fast, easy and wrong in long run
> solution to syzkaller bug [2].
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] Revert "devlink: Remove not-executed trap group notifications"
    https://git.kernel.org/netdev/net-next/c/fb9d19c2d844
  - [net-next,2/2] Revert "devlink: Remove not-executed trap policer notifications"
    https://git.kernel.org/netdev/net-next/c/c5e0321e43de

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


