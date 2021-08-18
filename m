Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E813F01EB
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 12:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234855AbhHRKkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 06:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:48316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234701AbhHRKkk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 06:40:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C639F6103A;
        Wed, 18 Aug 2021 10:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629283205;
        bh=5TyODe8M+d+5wciOeeCR/mpUx6jnRcFvtPnOhQLxwwM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aERx+3HTEs/WHjTU6TIaGYXzQL5uMOfIaYrrlIlP0rt3RDisVsD0Pm9iyCHY5AakA
         ndbZQfRaxFhDdIUQo1+OPZTmYLViEcnKciiXpwPAk1fjPrBslrRAAy5CvzcsWoGPXW
         C3w8YaBGzGWUIGdwPtzUQgoQa2FDUo/r9snKhFWNb2KTjL2hCm53L1T8VOky8eSc8A
         iymBHPu3FPtwlI0cqSxnlAyVRw4OlwNRzJ1JewMZzYyhPJehywnX+Kk4/Q3SNHxE5E
         yeV3ORIBnPBKGctgElDsp8pyl2yVAGu43BL0AtFw4lm0a3QtSa+mD0KIZZItateLxD
         Jg+dAAZYQg+dQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B8E72609EB;
        Wed, 18 Aug 2021 10:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ovs: clear skb->tstamp in forwarding path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162928320575.14375.16569955032450685309.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Aug 2021 10:40:05 +0000
References: <20210818022215.5979-1-fankaixi.li@bytedance.com>
In-Reply-To: <20210818022215.5979-1-fankaixi.li@bytedance.com>
To:     =?utf-8?b?6IyD5byA5ZacIDxmYW5rYWl4aS5saUBieXRlZGFuY2UuY29tPg==?=@ci.codeaurora.org
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        xiexiaohui.xxh@bytedance.com, cong.wang@bytedance.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 18 Aug 2021 10:22:15 +0800 you wrote:
> From: kaixi.fan <fankaixi.li@bytedance.com>
> 
> fq qdisc requires tstamp to be cleared in the forwarding path. Now ovs
> doesn't clear skb->tstamp. We encountered a problem with linux
> version 5.4.56 and ovs version 2.14.1, and packets failed to
> dequeue from qdisc when fq qdisc was attached to ovs port.
> 
> [...]

Here is the summary with links:
  - ovs: clear skb->tstamp in forwarding path
    https://git.kernel.org/netdev/net/c/01634047bf0d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


