Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABA539E8E7
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 23:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbhFGVMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 17:12:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230385AbhFGVL5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 17:11:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B51DE6124B;
        Mon,  7 Jun 2021 21:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623100205;
        bh=8njfDxxSsDzit8jkUYvGeehk1lwT6z0FX5PBRXc0rXM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s3DREzRSrXVWZrq7RhZTRCAWpwrB8xkLZyYTclOqgmbmSJScOEN+T5Dl7ArxQPwJW
         LLw/mBaRAJV9tNXZ368C18g3M/TNDgWMsr1zt62tDQClsrbWxxtFbvgi8dqTxAIseM
         UBqI2rT5NhAe5DA8Fgwd6viJOU0veNZ0gZD1vHlHM2Unkc2NGCFNmsKCG1EvshEwCC
         sh65jtzN7mN7nkFHiUJj2X6pwCAvCZCTA0UcLCxC83LeoEGsmcXTLRX1GZCHX4Y+9Z
         uoC1rI5lg6+yGwRkG76XOAbVRFhLUN3dOFfu5vzwqtOdQLZsqT/R/wkSmlxrgdA2rf
         T6fuI3hBJzWuQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AA0A6609F1;
        Mon,  7 Jun 2021 21:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qed: Fix duplicate included linux/kernel.h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162310020569.31357.4028012659215741108.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 21:10:05 +0000
References: <1623061874-35234-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1623061874-35234-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon,  7 Jun 2021 18:31:14 +0800 you wrote:
> Clean up the following includecheck warning:
> 
> ./drivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.h: linux/kernel.h
> is included more than once.
> 
> No functional change.
> 
> [...]

Here is the summary with links:
  - qed: Fix duplicate included linux/kernel.h
    https://git.kernel.org/netdev/net-next/c/ca4e2b94eb98

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


