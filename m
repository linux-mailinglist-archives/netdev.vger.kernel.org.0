Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A799492776
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 14:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243024AbiARNuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 08:50:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49686 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239731AbiARNuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 08:50:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C682B8167A
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 13:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 476EDC340E5;
        Tue, 18 Jan 2022 13:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642513809;
        bh=ykigtN32Cgzc50RKCxOfEPts7CflvMZHg2A7ZpuSxeQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Xjvnfyob4ZdgW8UXoZ/yXVFrjiaQQ9V7p4Qw5pS5JRFPjyllkGxWCZwwiXhgdMMAS
         B0NxbAAmuKFuaX86xRIvr5qW+9rQUNKCtYAPHO8khYAjMCM2Qn6EGDQtea1Oa2PYDu
         wAZLP0PXYgL8KB7ar6P7GM9r7Q01nfi+0apVAOPc6PVEpSjjXXc9hS/o5SZYD6O2lm
         JwZp65aHnOKnSAkXdtprj6VplDRLsfz2Sn2t6UZkofIz/XCO9BpLPfWhG3ZYr/nsLB
         w77pe+BIpVxwYkgczzrtF1NtB9m7pcdZeCyKBKZhgot+qATYuwmtqT8Wodgk+V9scI
         UIIROgLCimEzg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 308DDF6079A;
        Tue, 18 Jan 2022 13:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netns: add schedule point in ops_exit_list()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164251380919.26892.1393675920945794283.git-patchwork-notify@kernel.org>
Date:   Tue, 18 Jan 2022 13:50:09 +0000
References: <20220118114340.3322252-1-eric.dumazet@gmail.com>
In-Reply-To: <20220118114340.3322252-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, ebiederm@xmission.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 18 Jan 2022 03:43:40 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> When under stress, cleanup_net() can have to dismantle
> netns in big numbers. ops_exit_list() currently calls
> many helpers [1] that have no schedule point, and we can
> end up with soft lockups, particularly on hosts
> with many cpus.
> 
> [...]

Here is the summary with links:
  - [net] netns: add schedule point in ops_exit_list()
    https://git.kernel.org/netdev/net/c/2836615aa22d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


