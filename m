Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96BBB36CDCB
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 23:23:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239141AbhD0VXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 17:23:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:48748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237016AbhD0VXb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 17:23:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A1294613FC;
        Tue, 27 Apr 2021 21:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619558567;
        bh=Qh8+JybLCw8yPUcKnD87aSrwocG+dlWU05//tgfzvBE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gg21PNrsEkeSpSHOCRRkEjEI0ZSowYfrYymcR1exentlh8gmDCqNDE1YND+Jh3CyB
         KS8jB7Q9Om8z5p5vh4BuFg1hEm6701XAmizRttWlBtjSR9q8W/AVuZ57sqfqMJSpVs
         5OOP+Gqv0u4fi6+gvmsWNf+siCL+pIy0ktrs4ebvZju4wUO3zo6SL7XfbUKFnqDsr0
         uapyxwexXWeVKAFa+okoC0QpOS35ytTE/RRQi8ZhCSD9g1VLJCVM2thase9+4Oa73e
         vtkFdaMmQyDcjzSx1JW4Gt51JLp+j6uZXH0KX1ZxO8mRrara0KddLqr0CFKcD6nJ5y
         FXpxQl+kX8xVQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 96E91609CC;
        Tue, 27 Apr 2021 21:22:47 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mpls: Remove redundant assignment to err
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161955856761.21098.16667511919577856486.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Apr 2021 21:22:47 +0000
References: <1619519456-61310-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1619519456-61310-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 27 Apr 2021 18:30:56 +0800 you wrote:
> Variable err is set to -ENOMEM but this value is never read as it is
> overwritten with a new value later on, hence it is a redundant
> assignment and can be removed.
> 
> Cleans up the following clang-analyzer warning:
> 
> net/mpls/af_mpls.c:1022:2: warning: Value stored to 'err' is never read
> [clang-analyzer-deadcode.DeadStores].
> 
> [...]

Here is the summary with links:
  - mpls: Remove redundant assignment to err
    https://git.kernel.org/netdev/net-next/c/ad542fb7f2e2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


