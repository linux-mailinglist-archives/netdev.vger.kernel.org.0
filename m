Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A51C472FED
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 16:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239501AbhLMPAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 10:00:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57842 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234277AbhLMPAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 10:00:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 75CBA61119
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 15:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7421C3460B;
        Mon, 13 Dec 2021 15:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639407610;
        bh=eE0kQD32j0z6vpzjnApzWp1G0DUmPqRaGs5VuDgO4nY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iHI4SHelq+u8ivowJgKdJvzYFDqOSMeN58nTotP6C0iMm/DVn44hRqFKxw8vxZUL8
         KsiR3SxfFGR4t6pPPZEegxtP3hd5CyNBORzC6dqXRncYnM/aCd7S56oEY/sLkwGM3w
         05AhMwv7msOuKAmuPW13jh73bN22Q3QJu7DTARjTzR4sRK2cWoMrEFAc+Tyx5RJFF3
         QQF7akiadCsfKzx6cxJwNsZFzzDcnKY0hPkzQRUqvs0Nh3YVT3VKu1tIRrV0iuySCZ
         +/2Nwy4tMYuhLQkggYomm5VYrt5pP03SEJ5vSjRp3fHZAxwfhbNbKqotOVOW/gYaww
         Lz3l9B+VAgkvA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C853E60A3C;
        Mon, 13 Dec 2021 15:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: dev: Always serialize on Qdisc::busylock in
 __dev_xmit_skb() on PREEMPT_RT.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163940761081.26947.10343673170662846351.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Dec 2021 15:00:10 +0000
References: <YbcmKeLngWW/pb1V@linutronix.de>
In-Reply-To: <YbcmKeLngWW/pb1V@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, tglx@linutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 13 Dec 2021 11:53:29 +0100 you wrote:
> The root-lock is dropped before dev_hard_start_xmit() is invoked and after
> setting the __QDISC___STATE_RUNNING bit. If the Qdisc owner is preempted
> by another sender/task with a higher priority then this new sender won't
> be able to submit packets to the NIC directly instead they will be
> enqueued into the Qdisc. The NIC will remain idle until the Qdisc owner
> is scheduled again and finishes the job.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: dev: Always serialize on Qdisc::busylock in __dev_xmit_skb() on PREEMPT_RT.
    https://git.kernel.org/netdev/net-next/c/64445dda9d83

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


