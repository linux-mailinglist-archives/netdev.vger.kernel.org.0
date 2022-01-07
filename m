Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741454878AE
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 15:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347498AbiAGOKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 09:10:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39838 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238405AbiAGOKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 09:10:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C60A461EA3
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 14:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2249EC36AE5;
        Fri,  7 Jan 2022 14:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641564611;
        bh=xMtQdyUpxvpipGGqnCgbzn/zNym3nTksoMNhMZJSqoU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qQuZMqcthQ1NvGRylbBv1IL3RFv4tdNjOYvyuRJ9ni7a3LXY8r9FdS66y/FZ8Cvm9
         RecoHDJQjAy0N/zVOA4m2lFuaP6KZknwnMfdDKRCpmLA1yDsp66I2I6Q1Ck5J4YVyi
         ZJeTXWMrJwL324ShfUF/AgkZOB6m3q0/6U8pGzulowK8pUq3KywlOHydnkYwc7KymD
         YSrUxkhqoxUfcINyNaUHSxIn/iI/ACymwWw1W6Z7VfEJSoJVWnvbhjb5wRNPurT3mk
         5ZMmq/QYNxiOc1dk6VOZKcwNlqKAed87gDE3ZfSBNkZdWTaHsndtXiKBlovVCcbqld
         TpyArXl78WnjA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F3CB4F79405;
        Fri,  7 Jan 2022 14:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] mptcp: Fixes for buffer reclaim and option writing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164156461099.16670.12145239421394821609.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Jan 2022 14:10:10 +0000
References: <20220106220638.305287-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220106220638.305287-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev,
        pabeni@redhat.com, geliang.tang@suse.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  6 Jan 2022 14:06:35 -0800 you wrote:
> Here are three fixes dealing with a syzkaller crash MPTCP triggers in
> the memory manager in 5.16-rc8, and some option writing problems.
> 
> Patches 1 and 2 fix some corner cases in MPTCP option writing.
> 
> Patch 3 addresses a crash that syzkaller found a way to trigger in the mm
> subsystem by passing an invalid value to __sk_mem_reduce_allocated().
> 
> [...]

Here is the summary with links:
  - [net,1/3] mptcp: fix opt size when sending DSS + MP_FAIL
    https://git.kernel.org/netdev/net/c/04fac2cae942
  - [net,2/3] mptcp: fix a DSS option writing error
    https://git.kernel.org/netdev/net/c/110b6d1fe98f
  - [net,3/3] mptcp: Check reclaim amount before reducing allocation
    https://git.kernel.org/netdev/net/c/269bda9e7da4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


