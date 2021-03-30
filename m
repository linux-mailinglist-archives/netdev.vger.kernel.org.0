Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1573634F26F
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 22:51:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbhC3Uub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 16:50:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:56344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231874AbhC3UuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 16:50:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1DFC8619CA;
        Tue, 30 Mar 2021 20:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617137411;
        bh=4LQ2hLfYRpKz80Teewy7dce/czx0Fwd38bFfT9v5nQ4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WIzwSOEo1eqq4Yki2yaHb+CUOyZ81SGcbgJhWF7JgOQgMXfacVol6wxp8ncomVadK
         CSgKZ9BUtNgaWcu+bkkf3RLr2NJ3GYEQiVduiCi0iiK5audzZJ5cSlEIPz+T5O71ty
         159iOrQnwWFuk9W2suCiMrOSropCNWMJZbvh3NMnHatwJHljyHDX2Yf9rSAyLXE42S
         VOAkenTsJe0iIt2f20a0bd+cVyBDLhYEm+yOVW1qum+xVvvkQkH2X4jrBX5VEJmZZE
         5bhWfEEUk83JrorqbdMM/8hhHhVYWuBFi5Oc0exaEO7t8gjWVzzaGrh3ATQpyn+CwG
         PK3T4KRBLMYxQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 14D9260A3B;
        Tue, 30 Mar 2021 20:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next v2 1/2] mISDN: Use DEFINE_SPINLOCK() for spinlock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161713741108.14455.9996520147767264569.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Mar 2021 20:50:11 +0000
References: <20210330022416.528300-1-liushixin2@huawei.com>
In-Reply-To: <20210330022416.528300-1-liushixin2@huawei.com>
To:     Shixin Liu <liushixin2@huawei.com>
Cc:     isdn@linux-pingi.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 30 Mar 2021 10:24:14 +0800 you wrote:
> spinlock can be initialized automatically with DEFINE_SPINLOCK()
> rather than explicitly calling spin_lock_init().
> 
> Changelog:
> From v1:
> 1. fix the mistake reported by kernel test robot.
> 
> [...]

Here is the summary with links:
  - [-next,v2,1/2] mISDN: Use DEFINE_SPINLOCK() for spinlock
    https://git.kernel.org/netdev/net-next/c/77053fb7b428
  - [-next,v2,2/2] mISDN: Use LIST_HEAD() for list_head
    https://git.kernel.org/netdev/net-next/c/5979415d00d4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


