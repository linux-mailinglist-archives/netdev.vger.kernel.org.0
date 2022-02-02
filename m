Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2054A6AD9
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 05:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244505AbiBBEUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 23:20:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244504AbiBBEUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 23:20:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DC7C061771
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 20:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5574B82FF2
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 04:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6B7EAC340E4;
        Wed,  2 Feb 2022 04:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643775609;
        bh=95nXyy2gR/bG5bvlqdhqJgnA69syxgZSEbkzbIMuEy4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E9Flvn2LgYP3iKG6chWelMuYukynW78ybnLUydVIa+sJonlNPrhDHXNaNvMgQI/We
         LCU7c4dU12k/t3HLntYXG0N6txamOEVg4ZgIch7deYbt7Iuyx2WJ+cp/WlH1sH87Rn
         IaM47FppNWPDmAZ6snXtqnWgxN5j137vK0zPGez4fh/D/TCC6rJzTNuGndmtMsjLuM
         +GwCtYkFP5bcYlCYAvAsBHYRC2RwDwXQHbAbDy8ag7G4CcHWF6URCScv6XC+QfbsiP
         YiR5MmoO1rLnKUz2aH/Qan4JAhL165DEINzk/LiOp6XgOcA+qIyH033rPDvmyuK62I
         9pVPMbQirBvLQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 529EDE5D09D;
        Wed,  2 Feb 2022 04:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sched: fix use-after-free in tc_new_tfilter()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164377560933.9311.16069509035127622499.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Feb 2022 04:20:09 +0000
References: <20220131172018.3704490-1-eric.dumazet@gmail.com>
In-Reply-To: <20220131172018.3704490-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, vladbu@mellanox.com, jiri@mellanox.com,
        xiyou.wangcong@gmail.com, syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 31 Jan 2022 09:20:18 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Whenever tc_new_tfilter() jumps back to replay: label,
> we need to make sure @q and @chain local variables are cleared again,
> or risk use-after-free as in [1]
> 
> For consistency, apply the same fix in tc_ctl_chain()
> 
> [...]

Here is the summary with links:
  - [net] net: sched: fix use-after-free in tc_new_tfilter()
    https://git.kernel.org/netdev/net/c/04c2a47ffb13

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


