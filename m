Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37261481849
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234280AbhL3CAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:00:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37394 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234245AbhL3CAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:00:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07C70601B6;
        Thu, 30 Dec 2021 02:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5973AC36AEA;
        Thu, 30 Dec 2021 02:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640829611;
        bh=IwDXPpq15qyXlzhI/VWCsb4u2SUzDzS9ib1rdnRI6wE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PeptUt65uw6STXQmDGsxHrE08OWAAUGUGSxBFPyNa4l/jZBBlGRzULk2r9Uu47ZUo
         qd7GDyY3saYY4snVDvkCYpjUB0PlMVCOmQONjt1E3MvOfOJ973eidgszQQN6gh0ua1
         rziKLR6R6aHZlsa9M4bEQ7Ul7fPYNq7ilTY3BZk4yRSK+ML4+0YjxXcovwrgCrQNwp
         nFTn0sZsCRoyxKE/8CTl9ayZkEAKrH/hiM2qmVN9kYERUJ2ltgDUoBLLDu+e4YSlaj
         aSM+eW2Gkuya5nVnEQl8kY6b3tG3O9wfwTGvQUG4/DEkjlmcfYNVktb01Vh7af64DG
         QTqEQHIS1Arsg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3F1A2C32795;
        Thu, 30 Dec 2021 02:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: fix use-after-free in tw_timer_handler
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164082961125.30206.10818426908442232767.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Dec 2021 02:00:11 +0000
References: <20211228104145.9426-1-songmuchun@bytedance.com>
In-Reply-To: <20211228104145.9426-1-songmuchun@bytedance.com>
To:     Muchun Song <songmuchun@bytedance.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, xemul@openvz.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, cong.wang@bytedance.com,
        fam.zheng@bytedance.com, stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 28 Dec 2021 18:41:45 +0800 you wrote:
> A real world panic issue was found as follow in Linux 5.4.
> 
>     BUG: unable to handle page fault for address: ffffde49a863de28
>     PGD 7e6fe62067 P4D 7e6fe62067 PUD 7e6fe63067 PMD f51e064067 PTE 0
>     RIP: 0010:tw_timer_handler+0x20/0x40
>     Call Trace:
>      <IRQ>
>      call_timer_fn+0x2b/0x120
>      run_timer_softirq+0x1ef/0x450
>      __do_softirq+0x10d/0x2b8
>      irq_exit+0xc7/0xd0
>      smp_apic_timer_interrupt+0x68/0x120
>      apic_timer_interrupt+0xf/0x20
> 
> [...]

Here is the summary with links:
  - net: fix use-after-free in tw_timer_handler
    https://git.kernel.org/netdev/net/c/e22e45fc9e41

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


