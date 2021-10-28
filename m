Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64EFD43E2ED
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 16:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbhJ1OCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 10:02:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230409AbhJ1OCg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 10:02:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B6EF861139;
        Thu, 28 Oct 2021 14:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635429609;
        bh=IYkK7PP3hjmq0IlYSJS3zCHoO0XyR/VAFc3Npd6eD8s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bgkcP9QKHC5KQYZH0X+b+7rCw2Sxe1D9rSnHRZQ6rv2QDeI4k9VXbcr1CZyiAm3er
         /qo4gVaShCZDBcgcnmssJqPJraoduSe38xKxQ0ubq7VLdylIABHiM0ByG/TNXnW2Nc
         wKK3rhvKV9yUkYHurR+n8yQd+ZfGfJJCrRBybILyXB81p4XWDa2niI1LDYLP+NDU0Y
         mXDK/MghU6g7zQmHujP4EOYeewLTL7ovka8OQorSbyUzwyD9LKs1z0FZdwD3V4PsAn
         HDYvvjtmj3fm3kbqVntKELUveLG2HSxXFPzFzwtRIYajksYvxcHGi50m0GU/mss3zv
         3z8IqytnrRLHg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A883260A5A;
        Thu, 28 Oct 2021 14:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v3 0/3] RVU Debugfs updates.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163542960968.12929.3902021796749448464.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 14:00:09 +0000
References: <20211027180745.27947-1-rsaladi2@marvell.com>
In-Reply-To: <20211027180745.27947-1-rsaladi2@marvell.com>
To:     Rakesh Babu Saladi <rsaladi2@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        gakula@marvell.com, sbhatta@marvell.com, hkelam@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 27 Oct 2021 23:37:42 +0530 you wrote:
> Patch 1: Few minor changes such as spelling mistakes, deleting unwanted
> characters, etc.
> Patch 2: Add debugfs dump for lmtst map table
> Patch 3: Add channel and channel mask in debugfs.
> 
> Changes made from v2 to v3:
> 1. In patch 1 moved few lines and submitted those changes as a
> different patch to net branch
> 2. Patch 2 is left unchanged.
> 3. Patch 3 is left unchanged.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/3] octeontx2-af: debugfs: Minor changes.
    https://git.kernel.org/netdev/net-next/c/1910ccf03306
  - [net-next,v3,2/3] octeontx2-af: cn10k: debugfs for dumping LMTST map table
    https://git.kernel.org/netdev/net-next/c/0daa55d033b0
  - [net-next,v3,3/3] octeontx2-af: debugfs: Add channel and channel mask.
    https://git.kernel.org/netdev/net-next/c/9716a40a0f48

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


