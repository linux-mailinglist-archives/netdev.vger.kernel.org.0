Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85ED3DAE1B
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 23:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhG2VUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 17:20:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230179AbhG2VUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 17:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AB76C60F4A;
        Thu, 29 Jul 2021 21:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627593605;
        bh=PeQgSl87D23+JaAr9mjgpbcNaQN2ciEs4NLTeKVgp/g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HW2QulH3S3ZKYFpLPAgwocMfA0fSX5E5f8dIgGF/ve0y4UOMUTzkP/lTUhAJ/gM4G
         ugYsNdak8hq59ajTm2Xcrw8BS8A47GeCtFG1VR71/OfGMmcKHzbK0I9fSObrG8ed2k
         6pyM8mtxPQY0qmrO6QQLOVCnoJ/vbjkXWrbYgfISyN5IRG4bLnxDY1BDwYj41P8db8
         baoye2VYjzSEmMmFOLaET+QWxea7KFI5oRtiBRMiOXmaMgLTwK7/k8ma6f6qELIS3y
         aW6eSa5NSyZ9OrLYOcJanBQdHesnrDT9Q/0Hbw94njbFn+Ybks/XKXwWFd+EsawdSI
         iMa1cFooSHREw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9F34760A7B;
        Thu, 29 Jul 2021 21:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/sched: store the last executed chain also for
 clsact egress
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162759360564.14384.8104734975057957538.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Jul 2021 21:20:05 +0000
References: <cf72f28de22cfb326d4f8f6ea77f2253fcd17aad.1627494599.git.dcaratti@redhat.com>
In-Reply-To: <cf72f28de22cfb326d4f8f6ea77f2253fcd17aad.1627494599.git.dcaratti@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        marcelo.leitner@gmail.com, alaa@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 28 Jul 2021 20:08:00 +0200 you wrote:
> currently, only 'ingress' and 'clsact ingress' qdiscs store the tc 'chain
> id' in the skb extension. However, userspace programs (like ovs) are able
> to setup egress rules, and datapath gets confused in case it doesn't find
> the 'chain id' for a packet that's "recirculated" by tc.
> Change tcf_classify() to have the same semantic as tcf_classify_ingress()
> so that a single function can be called in ingress / egress, using the tc
> ingress / egress block respectively.
> 
> [...]

Here is the summary with links:
  - [net-next] net/sched: store the last executed chain also for clsact egress
    https://git.kernel.org/netdev/net-next/c/3aa260559455

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


