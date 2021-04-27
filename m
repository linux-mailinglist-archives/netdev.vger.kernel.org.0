Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C526E36CDD2
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 23:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239392AbhD0VXn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 17:23:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238817AbhD0VXc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 17:23:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B494B61405;
        Tue, 27 Apr 2021 21:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619558567;
        bh=ic4oP1ajHgJVZOU6lQiK+31ajafCwDycr6u/FTKctRo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QRFXlQqb0iPCyUGjDrWBdZ4R6B1Yb3Bny8lxGYI1pd9b/pH2v8nChOMWvb+mowFog
         pnwVcc4RacBzj4XdbZJNPnHh5LL33zUL0gKURIP4J23zS4TTB82bIPuNJrWVyFd0S0
         iJiPjLdCr3aYSkrs9tIa8lOFKnz/Q4he8ZcRHdvbiHFa4kve1Xx/Cl8qaPDd0kSEsM
         7k5nuEsr4A+aIEjbXBAtxgRMS/6SNmDoQXv67wSbeZc+BWR+Wxm5kIpP4y2nqOr0+X
         bXWo8mevKOY+ZAL8BouI+ZKgf5obNiJc6KBzWTYDjrYUrr72XfDScDCmy/gM6NHd2H
         4OS2S2H1hNT5Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A03AA60A23;
        Tue, 27 Apr 2021 21:22:47 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] llc2: Remove redundant assignment to rc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161955856765.21098.5708480208914549566.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Apr 2021 21:22:47 +0000
References: <1619519388-60321-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1619519388-60321-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 27 Apr 2021 18:29:48 +0800 you wrote:
> Variable rc is set to zero but this value is never read as it is
> overwritten with a new value later on, hence it is a redundant
> assignment and can be removed.
> 
> Cleans up the following clang-analyzer warning:
> 
> net/llc/llc_station.c:86:2: warning: Value stored to 'rc' is never read
> [clang-analyzer-deadcode.DeadStores].
> 
> [...]

Here is the summary with links:
  - llc2: Remove redundant assignment to rc
    https://git.kernel.org/netdev/net-next/c/2342eb1afe00

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


