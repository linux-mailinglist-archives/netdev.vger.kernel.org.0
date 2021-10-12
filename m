Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0367542A30C
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 13:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236122AbhJLLWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 07:22:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:39530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234934AbhJLLWI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 07:22:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A616C6101D;
        Tue, 12 Oct 2021 11:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634037606;
        bh=oRjrEPClGcDdwLWIMK1pc3ZsrHIp77v9kGvOf6+0Y0E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W3KDdWdXLB6eJp88zOf2fLtRDaBvK6IwL3rnlW2m++mKumgvNuAiTK9p5FIpeQ1FO
         ntKZLW+cTPEaZVTh8kGjC3FH0gvPpPttS/GMzDr0sS8YEIwZMR+gARvLVHoQXbQnCy
         31zVzR9ATH6PZ9VgTxjIcz/3Di0qtkJHugBkNDngFwAd+b5g/5QgkwatGX+AWyKoZ1
         /Pqtr6N2RWtxjqU2+QaS0Buwn3HBPk8usbr999afTZlX0WJ2kF1MRwcKdZIB8eMHmg
         3YqKL9Hv4BTvi36QID6AT/YKerWkNM/oKC6PjCN/hi40jFxGUZHsHUA/i8G8ZaF7Vb
         oiSDBKC57CcOw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 99AC6609EF;
        Tue, 12 Oct 2021 11:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH] ice: fix locking for Tx timestamp tracking flush
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163403760662.11134.15462370745654216339.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Oct 2021 11:20:06 +0000
References: <20211011204806.1504406-1-jacob.e.keller@intel.com>
In-Reply-To: <20211011204806.1504406-1-jacob.e.keller@intel.com>
To:     Keller@ci.codeaurora.org, Jacob E <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, anthony.l.nguyen@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 11 Oct 2021 13:48:06 -0700 you wrote:
> Commit 4dd0d5c33c3e ("ice: add lock around Tx timestamp tracker flush")
> added a lock around the Tx timestamp tracker flow which is used to
> cleanup any left over SKBs and prepare for device removal.
> 
> This lock is problematic because it is being held around a call to
> ice_clear_phy_tstamp. The clear function takes a mutex to send a PHY
> write command to firmware. This could lead to a deadlock if the mutex
> actually sleeps, and causes the following warning on a kernel with
> preemption debugging enabled:
> 
> [...]

Here is the summary with links:
  - [net] ice: fix locking for Tx timestamp tracking flush
    https://git.kernel.org/netdev/net/c/4d4a223a86af

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


