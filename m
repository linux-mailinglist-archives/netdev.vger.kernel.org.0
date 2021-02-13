Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10AFC31A8F3
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 01:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhBMAus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 19:50:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:57206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229650AbhBMAur (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 19:50:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 632F8614A5;
        Sat, 13 Feb 2021 00:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613177407;
        bh=GJ3TZ/I/6QwPg0SzN6DZHSsV/17BNh7cZIf/6WdN4FY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EftjFM0kyMjYfVl5jFU8SkSSFdwMJXxmbpmKf56l/oGys6+s6Kr8w46WLxOmjhvOA
         HnR36EqGgRZxLvsYe6ZqpnHceSfbAEn6/e8yUMOUl4i9Sp+y2IM3sqmqphEvq3P7Fv
         pjcye9I+TK9wQ5ioTnjs6Ziyp20fTLruTyvzr9rDfles9STTEMVHppS7/hsRGHGMdj
         n0PjC+C1jrxO/8X07J3dRWhkR2qNMXOlwIr02ad2SyZKG72h2ewVYPxCE+9cdARzi+
         OQqNckwRikej/5uHXXLykPXgr7FwcKgWnwrah+hlm1LDUqLtnEXO0gK7++cqMeXrzh
         uY0+2iU8PYZRw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4FAF460A2E;
        Sat, 13 Feb 2021 00:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] appletalk: Fix skb allocation size in loopback case
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161317740732.7081.2562791534480299640.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Feb 2021 00:50:07 +0000
References: <20210212052754.11271-1-doug@schmorgal.com>
In-Reply-To: <20210212052754.11271-1-doug@schmorgal.com>
To:     Doug Brown <doug@schmorgal.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 11 Feb 2021 21:27:54 -0800 you wrote:
> If a DDP broadcast packet is sent out to a non-gateway target, it is
> also looped back. There is a potential for the loopback device to have a
> longer hardware header length than the original target route's device,
> which can result in the skb not being created with enough room for the
> loopback device's hardware header. This patch fixes the issue by
> determining that a loopback will be necessary prior to allocating the
> skb, and if so, ensuring the skb has enough room.
> 
> [...]

Here is the summary with links:
  - appletalk: Fix skb allocation size in loopback case
    https://git.kernel.org/netdev/net/c/39935dccb21c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


