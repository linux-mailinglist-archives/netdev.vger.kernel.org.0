Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8D83CA4FA
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 20:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235506AbhGOSNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 14:13:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:37622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236414AbhGOSNA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 14:13:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AB609613D3;
        Thu, 15 Jul 2021 18:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626372606;
        bh=F9OiKXrcne2DqqS9KR5XXVFoJ09Kmtsco2tYKKJL1v8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Zm6gUMmB7+Sd3xvm1Oi5xUTcZ2WADotaCCjh5xGy9T6jSQPiJxYWIqNaO3UJcX6Y+
         ev+ZWFqrscznxO/zgwmhTFRTMLm1zGOFCQsIO9H6Zg4BvndD8F7BKqSifCMYOT28wr
         AZ4ODYfQm9mi9wVN7jSsa7oOhL5FkWreU8QIIqkt+imDkdF44A5M1c2Co5tQvqgCSl
         9fbrIl4sqvkbtyHBaL1dpjgovCBgtkVVsQiIKJRNb+nAT7jdQ0U8quFzjqFc4aESFJ
         TIEir0kzAGVT0AnUsW87wjYF7X21OC9dk/IqkY8Scyn90mVgXFZiiRFmWyEU4ZUahX
         AYdhSGQQkb1Qw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A0EA5609CD;
        Thu, 15 Jul 2021 18:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net-next v3] net_sched: introduce tracepoint
 trace_qdisc_enqueue()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162637260665.877.16677452623666618709.git-patchwork-notify@kernel.org>
Date:   Thu, 15 Jul 2021 18:10:06 +0000
References: <20210715060324.43337-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20210715060324.43337-1-xiyou.wangcong@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, qitao.xu@bytedance.com,
        cong.wang@bytedance.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 14 Jul 2021 23:03:24 -0700 you wrote:
> From: Qitao Xu <qitao.xu@bytedance.com>
> 
> Tracepoint trace_qdisc_enqueue() is introduced to trace skb at
> the entrance of TC layer on TX side. This is similar to
> trace_qdisc_dequeue():
> 
> 1. For both we only trace successful cases. The failure cases
>    can be traced via trace_kfree_skb().
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net_sched: introduce tracepoint trace_qdisc_enqueue()
    https://git.kernel.org/netdev/net/c/70713dddf3d2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


