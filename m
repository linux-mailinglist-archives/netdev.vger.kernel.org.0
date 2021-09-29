Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D86241C1CD
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 11:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245112AbhI2Jlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 05:41:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245070AbhI2Jlu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 05:41:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8002C613A9;
        Wed, 29 Sep 2021 09:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632908408;
        bh=3UuYp7x0md0g45SJB6ZntNn3VOuOn7BOrgGoWaqn61U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GMmzV/DTZPOSyuUNv8yhsxSlECkuHN+qf5BzZveO8M3nyKnmtBkQtxQb/qHF1v57m
         Kb5KSQDxrvhSs066cs9NkT/CXJMk8AiwhNwWYLdAJ5/qO16AOXW1/Pabb7tFDyZ30p
         iV3c8RbbsVYdoR8TXynLhKzl8djWwkWCfCqha9G9N5jFkY4kzlVfBc0Oj+UWXmRSos
         J6/mRBkSVvL+sKoeycJGNOV5QXfmOxr0VdAbjEHzgOebP3yMQY9oxE8SdG6hvxOOdB
         ckxhipqY4GXZ+vcW7BVwrI6yPywqkq6eGeN+hS8FM/W0X5rmYqdufjqNcNX8L66/D4
         SMW73qRGLefEA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6CD1560A7E;
        Wed, 29 Sep 2021 09:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-09-28
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163290840844.357.9791606865749160465.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Sep 2021 09:40:08 +0000
References: <20210928215757.3378414-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210928215757.3378414-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 28 Sep 2021 14:57:51 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Dave adds support for QoS DSCP allowing for DSCP to TC mapping via APP
> TLVs.
> 
> Ani adds enforcement of DSCP to only supported devices with the
> introduction of a feature bitmap and corrects messaging of unsupported
> modules based on link mode.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] ice: Add DSCP support
    https://git.kernel.org/netdev/net-next/c/2a87bd73e50d
  - [net-next,2/6] ice: Add feature bitmap, helpers and a check for DSCP
    https://git.kernel.org/netdev/net-next/c/40b247608bc5
  - [net-next,3/6] ice: Fix link mode handling
    https://git.kernel.org/netdev/net-next/c/4fc5fbee5cb7
  - [net-next,4/6] ice: refactor devlink getter/fallback functions to void
    https://git.kernel.org/netdev/net-next/c/0128cc6e928d
  - [net-next,5/6] ice: Fix macro name for IPv4 fragment flag
    https://git.kernel.org/netdev/net-next/c/b37e4e94c1a8
  - [net-next,6/6] ice: Prefer kcalloc over open coded arithmetic
    https://git.kernel.org/netdev/net-next/c/30cba287eb21

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


