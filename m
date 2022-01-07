Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14EFE4870C0
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 03:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345525AbiAGCuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 21:50:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:46964 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344814AbiAGCuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 21:50:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B02F4B82352;
        Fri,  7 Jan 2022 02:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 76B41C36AEB;
        Fri,  7 Jan 2022 02:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641523809;
        bh=koq3A7hujLIy2uyI7nagoAvy2SFEXAwoDZZnx+D4F/A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l4P5VKfzI7oH2O6ZicM0h1gO9HkMfKVREoQmpqN3r0ABsxSQLVemMqzhDAhaq1fUJ
         uSkePzqRKHJkUVS3OXVCiZC7ZZU6kIRTFxnb3HOThffSB5XWjnchEefq/fC36dPzKy
         jZ5s2lJ0ukX/bbqNN4bhd+JJHOr4+6O+NiSH6eJ9gczjDJYrjdBKxlknzpi9ucckLy
         kZsSejptH9jN8UFP5oOdkkuGIKTTgQ2dWJ0J04Qey3M3g5qnWRcIeIDNSS7kiwksV6
         YtTOyLkLci5FrbeLetq/SpKMU0jbF9juxoBZ//DhIMoKsBtXoMJAlA20RqH7uWygml
         9zUdQHHkae13w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5AC94F79408;
        Fri,  7 Jan 2022 02:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/4] netfilter: ipt_CLUSTERIP: fix refcount leak in
 clusterip_tg_check()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164152380936.10678.3908043014438003731.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Jan 2022 02:50:09 +0000
References: <20220106215139.170824-2-pablo@netfilter.org>
In-Reply-To: <20220106215139.170824-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu,  6 Jan 2022 22:51:36 +0100 you wrote:
> From: Xin Xiong <xiongx18@fudan.edu.cn>
> 
> The issue takes place in one error path of clusterip_tg_check(). When
> memcmp() returns nonzero, the function simply returns the error code,
> forgetting to decrease the reference count of a clusterip_config
> object, which is bumped earlier by clusterip_config_find_get(). This
> may incur reference count leak.
> 
> [...]

Here is the summary with links:
  - [net,1/4] netfilter: ipt_CLUSTERIP: fix refcount leak in clusterip_tg_check()
    https://git.kernel.org/netdev/net/c/d94a69cb2cfa
  - [net,2/4] selftests: netfilter: switch to socat for tests using -q option
    https://git.kernel.org/netdev/net/c/1585f590a2e5
  - [net,3/4] netfilter: nft_payload: do not update layer 4 checksum when mangling fragments
    https://git.kernel.org/netdev/net/c/4e1860a38637
  - [net,4/4] netfilter: nft_set_pipapo: allocate pcpu scratch maps on clone
    https://git.kernel.org/netdev/net/c/23c54263efd7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


