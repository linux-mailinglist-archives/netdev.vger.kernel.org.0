Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5595B41D9CF
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 14:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350836AbhI3Mbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 08:31:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:36212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350193AbhI3Mbt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 08:31:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 677C1613A5;
        Thu, 30 Sep 2021 12:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633005007;
        bh=FtRl53KRv7Skowsrf60HpHShwEaf8LmJxMEz8RtcSFM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=elHDJaYA0waVq1lbFbwbv1BbrIc93OSJnniaf+0bkXHFVb3pfIpAsW9c6D6ORFsj4
         ejOs2zsD6vp7xEqYVzLJAKwVeaIDPwR2TSQyjRlbJkjELv1tUETh2Z0kV0xF+ZzWxU
         YUcdey48cWG+3ChuhFgNQRMo6fAiVAKF8Ac3fW6M8gGkLpZBKjW56nBuKQ/M5RIYOi
         eZvfjh4E512A6y2lCzN1CKsbPczRZfQ/4XFXyMqliQyNIty79UOK5hFXGUkIlfuj8U
         s/wXmH+KzZP6HgaREtvxGOUjDxugTbzFEj69qTaytBu92U+aI0kUuNgVsfCdKzRpAO
         3krF3qdevEIOw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5AE6F60A3C;
        Thu, 30 Sep 2021 12:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sched: flower: protect fl_walk() with rcu
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163300500736.24074.11602716887495391799.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Sep 2021 12:30:07 +0000
References: <20210929150849.1051782-1-vladbu@nvidia.com>
In-Reply-To: <20210929150849.1051782-1-vladbu@nvidia.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, jiri@resnulli.us, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 29 Sep 2021 18:08:49 +0300 you wrote:
> Patch that refactored fl_walk() to use idr_for_each_entry_continue_ul()
> also removed rcu protection of individual filters which causes following
> use-after-free when filter is deleted concurrently. Fix fl_walk() to obtain
> rcu read lock while iterating and taking the filter reference and temporary
> release the lock while calling arg->fn() callback that can sleep.
> 
> KASAN trace:
> 
> [...]

Here is the summary with links:
  - [net] net: sched: flower: protect fl_walk() with rcu
    https://git.kernel.org/netdev/net/c/d5ef190693a7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


