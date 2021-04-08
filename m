Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C76E358F16
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 23:20:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbhDHVUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 17:20:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:59056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232331AbhDHVUV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 17:20:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C993A61181;
        Thu,  8 Apr 2021 21:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617916809;
        bh=o/aOzT6oaL9RJgtIV/dvs6yshDusJOtkol7NcdjfAE4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SK7pPAIIqbnYuhkoOaJfymeuHISjNp22wljpL1h5IXd0BlMqGoScssAnCqv3zInPT
         sKf1PGkK4C/fa4wDisJcvygf4KMegQSMHbrkyOKjOCA1+VpcXbu2p0A0IDhl3PlLbn
         FWxe76BVR/slWmZZZKaZrR4p/wXeInABMAnj5e9fjQhXuhuyiahjJmfNQFORpEKKot
         ZSRu7IvBFz4sWGahyeMCew2atKpIyQjityXUp+muaN1CMObO2YJrYVc/GN3XHQD6hv
         V6BbIrrb8XgHnMpRPZOQzdz9Kv64NbbsDlMD24oh8NcVB5YHDrhy0K/hhX0OFCp7ZT
         MLLDqVnFmlq2Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BCF3D60A2A;
        Thu,  8 Apr 2021 21:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: sched: sch_teql: fix null-pointer dereference
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161791680976.13372.4479863088354346844.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Apr 2021 21:20:09 +0000
References: <20210408151431.9512-1-ptikhomirov@virtuozzo.com>
In-Reply-To: <20210408151431.9512-1-ptikhomirov@virtuozzo.com>
To:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  8 Apr 2021 18:14:31 +0300 you wrote:
> Reproduce:
> 
>   modprobe sch_teql
>   tc qdisc add dev teql0 root teql0
> 
> This leads to (for instance in Centos 7 VM) OOPS:
> 
> [...]

Here is the summary with links:
  - net: sched: sch_teql: fix null-pointer dereference
    https://git.kernel.org/netdev/net/c/1ffbc7ea9160

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


