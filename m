Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 717EF36CDB7
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 23:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbhD0VLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 17:11:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239034AbhD0VKx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 17:10:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 038DC61400;
        Tue, 27 Apr 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619557810;
        bh=KKT2nxGiiJCNE4rvKEMc1xfdZbqLtS/uvbAtWpUXY/g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QnVWaEeN+rn0oVm6mjAW34fuSzjE37CptdiRfU0467hdq4bmxuHZz63go6N8Xc+1F
         Fb865uMeUxGmp42rmcuWmgmvH0AJ2Zgrs3CI0plOPFZ/Ud7cTxyg9UBa2SKf2CxOEz
         c7iekbuPr+A87J9YG5grhzuzPNY9367AAw5CkhNQlHfbtcTsBPiFdcRV+q+71rMdOA
         s0Enx7bPIOmhnkCj/62hrpm3ETVd74hRn2uuwYoJliIRD90fPngT0Z8bcGW1CfRG5X
         87CkPOD2x0vl8jP1JD6l5KmXqpkR29mOBruy7W7QsPCDaabOYAY17Ts8/RHzvtHRTF
         RwRAjlJF135Dw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EBCC2609CC;
        Tue, 27 Apr 2021 21:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] rxrpc: rxkad: Remove redundant variable offset
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161955780996.15707.5333111691696409267.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Apr 2021 21:10:09 +0000
References: <1619431983-87222-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1619431983-87222-1-git-send-email-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     dhowells@redhat.com, davem@davemloft.net, kuba@kernel.org,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 26 Apr 2021 18:13:03 +0800 you wrote:
> Variable offset is being assigned a value from a calculation
> however the variable is never read, so this redundant variable
> can be removed.
> 
> Cleans up the following clang-analyzer warning:
> 
> net/rxrpc/rxkad.c:579:2: warning: Value stored to 'offset' is never read
> [clang-analyzer-deadcode.DeadStores].
> 
> [...]

Here is the summary with links:
  - rxrpc: rxkad: Remove redundant variable offset
    https://git.kernel.org/netdev/net-next/c/6c375d793be6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


