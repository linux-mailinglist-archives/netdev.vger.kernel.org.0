Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F5C44ACE0
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 12:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343585AbhKILwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 06:52:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:39676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242051AbhKILwx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 06:52:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A38B660D42;
        Tue,  9 Nov 2021 11:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636458607;
        bh=5dGMXGGBh/T8GvxpyZnSiphS0FSNg/jxf3THcywD4WU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DgZL10efTvlL4sysLlf3vaFO2a+tpJtgEu2dxuC13Q3+Kf8pcvccJIwJmO05Oet3z
         YrMYRvar9InpEh+wS8UyZJist3i4d6RQW6KiPus78czFJTOARjrcFJ6TkKZ6Br+N4t
         X5EqmDKCIJ6B+17S/tGn03KBxW2u4FPbZF9QyU2mo4KxoNZAS5tXx7UFmG0OyLRuqA
         lI6/rjHm7AYJo45N8S2pTcodcCVu0/xlCm4aaxZ1ULxSFYzDX7rbq2Gyq5CVSoZttz
         XkjiLt3akg00XXpVNBqRv8WYJP2Lzskz0ocE2hY2OE9F5xkhxSQWC/a3QSpRHvBEc7
         E8wTe75b2LRyA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9310E60A3C;
        Tue,  9 Nov 2021 11:50:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sungem_phy: fix code indentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163645860759.18500.9569652988948787689.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Nov 2021 11:50:07 +0000
References: <20211108065941.2548-1-sakiwit@gmail.com>
In-Reply-To: <20211108065941.2548-1-sakiwit@gmail.com>
To:     =?utf-8?q?J=CE=B5an_Sacren_=3Csakiwit=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, jens@de.ibm.com,
        jeff@garzik.org, linas@austin.ibm.com, arnd.bergmann@de.ibm.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun,  7 Nov 2021 23:59:41 -0700 you wrote:
> From: Jean Sacren <sakiwit@gmail.com>
> 
> Remove extra space in front of the return statement.
> 
> Fixes: eb5b5b2ff96e ("sungem_phy: support bcm5461 phy, autoneg.")
> Signed-off-by: Jean Sacren <sakiwit@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: sungem_phy: fix code indentation
    https://git.kernel.org/netdev/net/c/54f0bad6686c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


