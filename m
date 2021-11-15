Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCB8045057E
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 14:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbhKONd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 08:33:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:49214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231768AbhKONdE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 08:33:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6F16263219;
        Mon, 15 Nov 2021 13:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636983009;
        bh=ECeB90vh8v0dpjB4BPwkqR/Ng3dJMGNlO/tFyh8RMhE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=urEl1pgCbl5m6/yHew3ax+suPqAwXd7zYqzIccDiQi6elL432cWVBNaonaO/0qsR4
         No243bdThKV1EgAh0h2BECnJnqhk3ixESKfqit6PqFc8Sun7EHN0mQUFGqkuWoqxPr
         jSRTXxNo46h58vya4B6Vkl2NaQ0QmN5t82198fP2eIllClilzmO38hb1acAgPlCLcH
         hAZrLWfdrSF3VOOslDcnM5lIKUCOQhQIcOgvlThxEQihUouged9a+1k6/+aNMoW1qx
         DRF58VN0KgnSj/3DD8ut0nflTqENn2VptRIGhDvgREwM0YYcnhnWrnWdj5vbyEjeIr
         S8nCMIHJR3F2A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 68FA060A4E;
        Mon, 15 Nov 2021 13:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: sched: sch_netem: Refactor code in 4-state loss
 generator
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163698300942.26335.7264728041918085849.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Nov 2021 13:30:09 +0000
References: <20211112213647.18062-1-harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20211112213647.18062-1-harshit.m.mogalapalli@oracle.com>
To:     Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc:     stephen@networkplumber.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        kuba@kernel.org, yangyingliang@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 12 Nov 2021 13:36:47 -0800 you wrote:
> Fixed comments to match description with variable names and
> refactored code to match the convention as per [1].
> 
> To match the convention mapping is done as follows:
> State 3 - LOST_IN_BURST_PERIOD
> State 4 - LOST_IN_GAP_PERIOD
> 
> [...]

Here is the summary with links:
  - [v2] net: sched: sch_netem: Refactor code in 4-state loss generator
    https://git.kernel.org/netdev/net-next/c/cb3ef7b00042

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


