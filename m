Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3857238F4BF
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 23:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbhEXVLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 17:11:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:32796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232859AbhEXVLj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 17:11:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3D0E161411;
        Mon, 24 May 2021 21:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621890611;
        bh=IF0KICuEwzVqeFBA/u7U4JJaKE7n2z6hECEKCfI27cs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fLUqj+GlHN8LwikQB3mIEgqATbrNvZsfl0kg663h541VrQplifMMuQ4bsOBIXxbT8
         ydASxvAMY+1eQcp33GlsFC/AYo5kUamtM2hdgvxdv6+1SHp+FqDLwFJWxUaCbEw6BO
         CV4WNbPAwd8CLbY+/o4ukRFd7zccTNw4CRCYt8PEX4sfy8H4ALjdDRMD4iiXlYCV1W
         JmCUb+D378sZkQhmh135OtkBvo8ySWnlmM9tLltD98AVCw8rk8P2rKpN+Cs+vIqizW
         Ck5lRggy4W6gd8yj5EZHo2suDIb9lzvrSuldK9pXLe9N5uzU2XHpoaxjb6W08LrDn5
         +cwyx5Z6mLLjw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 30BBA60A39;
        Mon, 24 May 2021 21:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: appletalk: cops: Fix data race in cops_probe1
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162189061119.7619.7983599518749277035.git-patchwork-notify@kernel.org>
Date:   Mon, 24 May 2021 21:10:11 +0000
References: <20210524133712.15720-1-saubhik.mukherjee@gmail.com>
In-Reply-To: <20210524133712.15720-1-saubhik.mukherjee@gmail.com>
To:     Saubhik Mukherjee <saubhik.mukherjee@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org,
        wanghai38@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 24 May 2021 19:07:12 +0530 you wrote:
> In cops_probe1(), there is a write to dev->base_addr after requesting an
> interrupt line and registering the interrupt handler cops_interrupt().
> The handler might be called in parallel to handle an interrupt.
> cops_interrupt() tries to read dev->base_addr leading to a potential
> data race. So write to dev->base_addr before calling request_irq().
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> [...]

Here is the summary with links:
  - net: appletalk: cops: Fix data race in cops_probe1
    https://git.kernel.org/netdev/net/c/a4dd4fc6105e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


