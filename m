Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3E2E43750E
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 11:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232415AbhJVJww (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 05:52:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:55598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231992AbhJVJww (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 05:52:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0C87A611CB;
        Fri, 22 Oct 2021 09:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634896235;
        bh=aCRXavwbJdSY/K+s4FvrFyrCNo4Wxkh04CP/XaQOMc8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tZcb4Z9mZmnjxXHiP3rpnpgR8pvv8ELAxLnHg5qupT/GGi5W13GIAMEQR2MDerdcL
         1K06LF+nD4prq1IIUxO7qLKCn7TSmH8tPrhtVHKPvTT6xuJEiFYfOPN3UtL5b5PFRC
         kJ3jl/8/E2KyRwo62DZcpNWPdX9QXgvDqJRirLp3YxCysd2/ygxCvEI4YqchpSnPOv
         sF/LzCdPwB7u4CU3mCVGMcMkwaND2nrqP3Hi0VXaAOmdSg0Bc57nPF62G7WVWTp2/R
         Ewsmxzey+lPwRT29R7anY33B2FkSuwEYsdVm4X6p7DBXRL+NVXYkVG635BKz8s7zzJ
         SWr0glNUtHA3w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F3ED2609E7;
        Fri, 22 Oct 2021 09:50:34 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Networking for 5.15-rc7
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163489623499.18872.8059195415527012685.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Oct 2021 09:50:34 +0000
References: <20211021153226.788611-1-kuba@kernel.org>
In-Reply-To: <20211021153226.788611-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Linus Torvalds <torvalds@linux-foundation.org>:

On Thu, 21 Oct 2021 08:32:26 -0700 you wrote:
> Hi Linus!
> 
> We'll have one more fix for a socket accounting regression,
> it's still getting polished. Otherwise things look fine.
> 
> The following changes since commit ec681c53f8d2d0ee362ff67f5b98dd8263c15002:
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Networking for 5.15-rc7
    https://git.kernel.org/netdev/net/c/6c2c712767ee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


