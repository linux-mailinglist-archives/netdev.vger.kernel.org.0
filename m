Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7573E31D27B
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 23:11:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbhBPWLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 17:11:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:49148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230059AbhBPWKt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 17:10:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B39A264E85;
        Tue, 16 Feb 2021 22:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613513408;
        bh=AEFRt6RDphU6diddzooodWRq2bXG7yFKXx/tp0ntiYQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VD+Io3w3LJAh08zbFWMmXI8j44Zx6dAft9HbN1xS8LwfJkoripZ5E1KveoXPCyHjr
         9REXJG53CzP+6yobiTA+qhtg0R/UOTObBKImqWEGEdBa3q0AL7JSUV71OXOWQ8gsZB
         N8VgfXG97qFckW3RUnLpCNzRsi52BpN9g13MEllQ7j8iExDyntljIXjYXRK1tTEeRb
         pJNNB0M/0rrAJDdTInIZPLcPOPdtKZLHh++n2vYiybZRE9q8DEK/xYPbxgHLioSVeI
         +bwh+KLwZ4ELDyVTc2QbLbead5IQRlLSuAROGXn+yl3olsDTg9pCfjGxrcjBezUZ8/
         nCZDEm461sLUg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A711760971;
        Tue, 16 Feb 2021 22:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v2] octeontx2-af: cn10k: Fixes CN10K RPM reference issue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161351340868.15084.12431489859751486846.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Feb 2021 22:10:08 +0000
References: <20210216113936.26580-1-gakula@marvell.com>
In-Reply-To: <20210216113936.26580-1-gakula@marvell.com>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, sgoutham@marvell.com,
        lcherian@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        jerinj@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 16 Feb 2021 17:09:36 +0530 you wrote:
> This patch fixes references to uninitialized variables and
> debugfs entry name for CN10K platform and HW_TSO flag check.
> 
> Fixes: 3ad3f8f93c81 ("octeontx2-af: cn10k: MAC internal loopback support").
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] octeontx2-af: cn10k: Fixes CN10K RPM reference issue
    https://git.kernel.org/netdev/net-next/c/786621d20023

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


