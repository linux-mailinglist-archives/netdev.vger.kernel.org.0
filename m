Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42BE43E4283
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 11:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbhHIJU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 05:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234349AbhHIJU0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 05:20:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 751AD610A1;
        Mon,  9 Aug 2021 09:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628500806;
        bh=dyB6k7gx7p1UgqVPtpoRpaBC6qnvvZUq5R8yHOybFOI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oqIWgpK7gKz5A8oZV0Psak7VD72T4jmf8DRv45+BmUk1uNcsLspatD3g1dtIWPDDG
         AT49TEDQDrpk9GGLsNV2bUVuk7HbZwP4WBZpEBmXibuNxBMZegDS6EJBcmP38CQhPn
         /8cshFpH2c+6V8lSrFdcx3sc2L1uBK3ORxtC2jzEgDhrakzM7hXh+9KN5RIqgwW01Y
         L7+6DFJZQ32WtnugQqnM4bnuCL8q3YR1wzFUHD/M4Bv0DuI7NmvHzrV34A8r6uWbfF
         Fk7IYBtXCsVpoe+BwC7lCqBByf8Wp+HYc87NljkR+co8oZ7eXFXHkFHMsNdr3YSqsl
         wNWfECVcy8/pQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6AE9C60A14;
        Mon,  9 Aug 2021 09:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] wwan: mhi: Fix missing spin_lock_init() in
 mhi_mbim_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162850080643.12236.562671529597026467.git-patchwork-notify@kernel.org>
Date:   Mon, 09 Aug 2021 09:20:06 +0000
References: <20210808063344.255867-1-weiyongjun1@huawei.com>
In-Reply-To: <20210808063344.255867-1-weiyongjun1@huawei.com>
To:     Wei Yongjun <weiyongjun1@huawei.com>
Cc:     loic.poulain@linaro.org, ryazanov.s.a@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, hulkci@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 8 Aug 2021 06:33:44 +0000 you wrote:
> The driver allocates the spinlock but not initialize it.
> Use spin_lock_init() on it to initialize it correctly.
> 
> Fixes: aa730a9905b7 ("net: wwan: Add MHI MBIM network driver")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] wwan: mhi: Fix missing spin_lock_init() in mhi_mbim_probe()
    https://git.kernel.org/netdev/net-next/c/94c0a6fbd5cf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


