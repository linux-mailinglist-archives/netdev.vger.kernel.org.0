Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA43349DD1
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 01:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230153AbhCZAa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 20:30:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229994AbhCZAaM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 20:30:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4470C61A4E;
        Fri, 26 Mar 2021 00:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616718612;
        bh=xKaXnl5sYosJefXTbbLLT5VkI4el+tSUGY07s43IMfw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oZqWyynN4pg7xDRBEGFZbt/LJD+6jY/XEEPwgtvEypDRVwlvMGsZ3d/VkRzqBSUhP
         VF1LVdwW231Sb33jLgUyX8EKex2YiNvfnblvDxN5hjQ1+Lld78i0wU48lGENXVZnCI
         /xzI/fuTwTA90GySj/ZG8TqGdehhdxjYNaIHdV5asw5SyJxCNRdsRginDfIPNCG2SO
         rAnNOKS1x37jAAcWiiK/R9e303U0yAtxvBC+Crw3eHltzOSmPuOHWvbjJ+xUHcngpL
         Gh07QCttswEvLRC+gJEIW3/4DKKmrliiSV0H06RDq2J83snOiqB3aKzThCsWo2/wxt
         +KECmEPxWsaQA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 40438625C0;
        Fri, 26 Mar 2021 00:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: change netdev_unregister_timeout_secs min
 value to 1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161671861225.2256.11001681624595630001.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 00:30:12 +0000
References: <20210325145245.3160366-1-dvyukov@google.com>
In-Reply-To: <20210325145245.3160366-1-dvyukov@google.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     edumazet@google.com, davem@davemloft.net, leon@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 25 Mar 2021 15:52:45 +0100 you wrote:
> netdev_unregister_timeout_secs=0 can lead to printing the
> "waiting for dev to become free" message every jiffy.
> This is too frequent and unnecessary.
> Set the min value to 1 second.
> 
> Also fix the merge issue introduced by
> "net: make unregister netdev warning timeout configurable":
> it changed "refcnt != 1" to "refcnt".
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: change netdev_unregister_timeout_secs min value to 1
    https://git.kernel.org/netdev/net-next/c/6c996e19949b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


