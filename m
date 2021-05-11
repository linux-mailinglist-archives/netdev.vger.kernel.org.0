Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22F837B267
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 01:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhEKXVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 19:21:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229932AbhEKXVR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 19:21:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 273D6610E6;
        Tue, 11 May 2021 23:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620775210;
        bh=bhM1W8rLqxdNkwy0iC9I/cJlJaPOYPdrIrU+hXTPIi0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ye+VcachCqngUty0MQIkabp+cwHLjJGmwcC+6jjV+QDLZcuxh6a4fA4GrLPbB8yxX
         gBx5uebJk+FLdh3weoCSwW20+wpZVrx+miIm1Y7K18xA88ArKnPgB6jjOOBJDs/nmw
         4fjh+S3Hwia6TX+uvttvc+gzsHU+idlnGlbfwXCHMBaMSMFcVggKJyb9gJj+Asx92v
         4EEHqT8SpF1rITniQM4+VnEu5/LW2BJfD7zGAETvU+EregakIhOnVuZsB9UcxMdlFa
         kY9/Wdsi/OMxOH7zF+Z2wsQu/H9aDFiLPUqyTRsLnXjfU93KI9Wpi0n1j69SqnCBEM
         FgTnM5qDW43Nw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 17A5760A0B;
        Tue, 11 May 2021 23:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] mISDN: fix possible use-after-free in HFC_cleanup()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162077521009.13970.2587870888353575789.git-patchwork-notify@kernel.org>
Date:   Tue, 11 May 2021 23:20:10 +0000
References: <1620716333-108153-1-git-send-email-zou_wei@huawei.com>
In-Reply-To: <1620716333-108153-1-git-send-email-zou_wei@huawei.com>
To:     Zou Wei <zou_wei@huawei.com>
Cc:     isdn@linux-pingi.de, davem@davemloft.net, gustavoars@kernel.org,
        christophe.jaillet@wanadoo.fr, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 11 May 2021 14:58:53 +0800 you wrote:
> This module's remove path calls del_timer(). However, that function
> does not wait until the timer handler finishes. This means that the
> timer handler may still be running after the driver's remove function
> has finished, which would result in a use-after-free.
> 
> Fix by calling del_timer_sync(), which makes sure the timer handler
> has finished, and unable to re-schedule itself.
> 
> [...]

Here is the summary with links:
  - [-next] mISDN: fix possible use-after-free in HFC_cleanup()
    https://git.kernel.org/netdev/net-next/c/009fc857c5f6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


