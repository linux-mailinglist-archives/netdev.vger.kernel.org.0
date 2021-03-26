Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E879534B269
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbhCZXAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:00:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230134AbhCZXAN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 19:00:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BA91D61A49;
        Fri, 26 Mar 2021 23:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616799612;
        bh=0bnB2HhWV1YHrVWqPsRTJGOesxJEv+VvQvRSHujYw7I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V53LaL9eEyRfWbK/KnRIpewVV1A7EvzcrFAceWkIU569MtVrvBQPJeSgQ4bip8nSa
         aRq2LRpn4K1ydk3AaP60qovUWeXyObb9W4stmzjo++G0JGm4nrkHXKjtnVFmHjEsuq
         trcBpRXRo/V0WZc8iqpYboSrTwFjlKvuye4mPv26yBmRcZU3SXTTxv9g8eOFv+G1KS
         wrxYIrqbOtFosc+RbYlGnITeCJ7EQlxDv7eBLuBVYnj3NIcreQ6hFx9FOTZXNItzW8
         Emg/Zq1Nf6L7P5m3fRRSSV8u+wGsG9/Gnkfv7aYr7hSh20UzVkPpcwPHSvpce3/ovu
         5C9SXZfv/nakQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9CB5560986;
        Fri, 26 Mar 2021 23:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] farsync: use DEFINE_SPINLOCK() for spinlock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161679961263.14639.18190519609786202394.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 23:00:12 +0000
References: <20210326123138.159616-1-liujian56@huawei.com>
In-Reply-To: <20210326123138.159616-1-liujian56@huawei.com>
To:     'Liu Jian <liujian56@huawei.com>
Cc:     kevin.curtis@farsite.co.uk, kuba@kernel.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 26 Mar 2021 20:31:38 +0800 you wrote:
> From: Liu Jian <liujian56@huawei.com>
> 
> spinlock can be initialized automatically with DEFINE_SPINLOCK()
> rather than explicitly calling spin_lock_init().
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] farsync: use DEFINE_SPINLOCK() for spinlock
    https://git.kernel.org/netdev/net-next/c/a1281601f88e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


