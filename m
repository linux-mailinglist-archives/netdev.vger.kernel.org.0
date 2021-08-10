Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099A23E8652
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 01:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235300AbhHJXKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 19:10:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:48314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235206AbhHJXK2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 19:10:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AFF7A61008;
        Tue, 10 Aug 2021 23:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628637005;
        bh=vBijd+yOHnMVfA6hBJZC1XpF4AilH1BaRDnnR6x/oEQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LswInmuniq6CU34O1UFWISnsIiCvyXVW/K9YWHzXJvO6nXXYiVB9SGJJnf5oUcWI1
         YjpkLvN12eTIlnFUofQW5J1XpaQ3HXDZO7lUYUsEWN99XwKSJaTk72WplhhO1hfTsh
         QzPsZWnoKgd4x7YhRABiWDyXsUiMk2CIFf7zssPP1XKrk6JJqpG7dMOCZmnWkvpPt3
         bVrfEJKtq+oYJfdWczrxMs7glC1sZSfsGVsLzf+6OPDvqnpRcbApPLl8cxP1fsljUg
         DThnr6/RqVi6hdhlfd+/ZfnyJdF0ZD48rvr2UglnRWwfvvAoHP44JLMjqbHHl2zamZ
         Wf8uBG7mqA3fg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9FF3A60A54;
        Tue, 10 Aug 2021 23:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v2] net/sched: cls_api, reset flags on replay
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162863700565.24690.12950360863435062958.git-patchwork-notify@kernel.org>
Date:   Tue, 10 Aug 2021 23:10:05 +0000
References: <20210810034305.63997-1-mbloch@nvidia.com>
In-Reply-To: <20210810034305.63997-1-mbloch@nvidia.com>
To:     Mark Bloch <mbloch@nvidia.com>
Cc:     netdev@vger.kernel.org, xiyou.wangcong@gmail.com,
        vladbu@nvidia.com, cong.wang@bytedance.com, jhs@mojatatu.com,
        jiri@resnulli.us
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 10 Aug 2021 03:43:05 +0000 you wrote:
> tc_new_tfilter() can replay a request if it got EAGAIN. The cited commit
> didn't account for this when it converted TC action ->init() API
> to use flags instead of parameters. This can lead to passing stale flags
> down the call chain which results in trying to lock rtnl when it's
> already locked, deadlocking the entire system.
> 
> Fix by making sure to reset flags on each replay.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net/sched: cls_api, reset flags on replay
    https://git.kernel.org/netdev/net-next/c/a5397d68b2db

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


