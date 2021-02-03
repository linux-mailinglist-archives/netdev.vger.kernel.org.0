Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB8030D144
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 03:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbhBCCKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 21:10:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:40824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229624AbhBCCKs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 21:10:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5934F64F77;
        Wed,  3 Feb 2021 02:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612318207;
        bh=CGHQh/TE03WOGsqglRMUZdNF8m7rCsMbZpSXzcg5jTk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s+i/UhJPBD1Y/PoZ9/bjlMem95YavYa9Bx7QrOmCOFwkzJWTd1MYsukKDzMhSoxw9
         oMmDyXWooVgJzcnvH1nr3KrUQR5wDVg4QgbMjUbjnm55JBVh2rtYIZZf4Kp5UN/KHH
         ZMKyt0jz8fY0fWw+OJrGPenFhWkGlYArIRh/g5AXHDcSKaqpGeuNGgWLlVH4QUaX8f
         66bKFqDR9ZRsni0E/ZRQt1VKSfNDXqgA6uIoXbAXkXd8XmvWw5Yayxd6ImBpQmepq6
         WKMno6cgST8CEk8LEmX2+nIywuAM1auQ8XM6PHOwLqohnodWxc/GCfM9YEauRAmepX
         wa7NWjnnJ2Eig==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 49C85609E1;
        Wed,  3 Feb 2021 02:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] r8169: Add support for another RTL8168FP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161231820729.7086.8696746160919313169.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Feb 2021 02:10:07 +0000
References: <20210202044813.1304266-1-kai.heng.feng@canonical.com>
In-Reply-To: <20210202044813.1304266-1-kai.heng.feng@canonical.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     hkallweit1@gmail.com, nic_swsd@realtek.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  2 Feb 2021 12:48:12 +0800 you wrote:
> According to the vendor driver, the new chip with XID 0x54b is
> essentially the same as the one with XID 0x54a, but it doesn't need the
> firmware.
> 
> So add support accordingly.
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> 
> [...]

Here is the summary with links:
  - [v2] r8169: Add support for another RTL8168FP
    https://git.kernel.org/netdev/net-next/c/e6d6ca6e1204

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


