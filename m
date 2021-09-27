Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16E041931B
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 13:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234057AbhI0Lb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 07:31:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234003AbhI0Lbz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 07:31:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A628760F91;
        Mon, 27 Sep 2021 11:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632742217;
        bh=Sbwut3Ghtz/0GEWJ/rscuO9D2NBvEHt//GGAePOBlSQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k6EIsiqgA6RVLNjZpNRl/jIhEMgNzaXk1gRR4qvkAtLjoaKvM0zIMtE37g8QHuicu
         kujZXsp2Xuh3cB0a2+WlHr1QiPZx171MvLzcDhK2PeL/69DfQ1l8C/aDYz7Gw9hoGv
         SLKMI4/XoVyA5gIqXECaWgUV8OWNkfxTsmeIyx+xd0N8IqnEek+XgcoWSbsLW+RJ30
         XT60FRXrMtL7IiW/ka+Q1MFLJdl7KQPIqTRTXfXaUfeBxpxx7YpUOIIxTn/CGOptae
         CeQwN+9UzuFaoqXcm5bgZ3nraOHPFYCar7A6prMV4NDvZ2QpiDaX6VMZ/kBs0kLWnl
         XXKw535/qeBQQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A0BB160A59;
        Mon, 27 Sep 2021 11:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: make napi_disable() symmetric with enable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163274221765.5839.11364590533296108553.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Sep 2021 11:30:17 +0000
References: <20210924202453.1051687-1-kuba@kernel.org>
In-Reply-To: <20210924202453.1051687-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, weiwan@google.com,
        xuanzhuo@linux.alibaba.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 24 Sep 2021 13:24:53 -0700 you wrote:
> Commit 3765996e4f0b ("napi: fix race inside napi_enable") fixed
> an ordering bug in napi_enable() and made the napi_enable() diverge
> from napi_disable(). The state transitions done on disable are
> not symmetric to enable.
> 
> There is no known bug in napi_disable() this is just refactoring.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: make napi_disable() symmetric with enable
    https://git.kernel.org/netdev/net-next/c/719c57197010

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


