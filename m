Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0A934F539
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 02:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbhCaAAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 20:00:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232221AbhCaAAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 20:00:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5B050619D7;
        Wed, 31 Mar 2021 00:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617148811;
        bh=ysOe6gV6VLVY/dAxzArYun+ymQ/xTKzYhzoq2I0b7ZA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GUHx+9enHBcPboBFsqMeROxBsZDrztZWphS/QWzotm4t6PymL1JVfkEMME30Xpmyn
         g16hMNrBb6yX1aelq3wYjHKsQqRMHNPbiHAEH5QorFe0QtppS4n+3mKiy5urMe+8yU
         1GAVh7PeyFULyFpeO9scl894T+9XUZi43uMDU2ms34M4ZdKqVfKWPPWhl8/Iy+nQQ+
         dRe1VobZ/vbEL3zA527cszGOAk56/t6yhxFM7yRkgTqFhCT+jK4wRXkjDQZcsAa5Zs
         5XYnVt9+a/t8NpzvkB/0F4D0a4wq8R+wjKQbAAI1OvRJKkpec+Ezvo5W1CAAS5ndx7
         G9mVp25a4iisg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5424860A5B;
        Wed, 31 Mar 2021 00:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/6] Clean up obsolete TODO files
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161714881133.29090.6649016688836045626.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 00:00:11 +0000
References: <1617087773-7183-1-git-send-email-wangqing@vivo.com>
In-Reply-To: <1617087773-7183-1-git-send-email-wangqing@vivo.com>
To:     Wang Qing <wangqing@vivo.com>
Cc:     tsbogend@alpha.franken.de, aacraid@microsemi.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com, luisbg@kernel.org,
        salah.triki@gmail.com, dwmw2@infradead.org, richard@nod.at,
        ralf@linux-mips.org, davem@davemloft.net, kuba@kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net, gregkh@linuxfoundation.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 30 Mar 2021 15:02:43 +0800 you wrote:
> It is mentioned in the official documents of the Linux Foundation and WIKI
> that you can participate in its development according to the TODO files of
> each module.
> 
> But the TODO files here has not been updated for 15 years, and the function
> development described in the file have been implemented or abandoned.
> 
> [...]

Here is the summary with links:
  - [1/6] mips/sgi-ip27: Delete obsolete TODO file
    https://git.kernel.org/netdev/net-next/c/0f1b2a4912b2
  - [2/6] scsi/aacraid: Delete obsolete TODO file
    https://git.kernel.org/netdev/net-next/c/ef843f261b88
  - [3/6] fs/befs: Delete obsolete TODO file
    https://git.kernel.org/netdev/net-next/c/22612b4e6039
  - [4/6] fs/jffs2: Delete obsolete TODO file
    https://git.kernel.org/netdev/net-next/c/ab36ba4f3a81
  - [5/6] net/ax25: Delete obsolete TODO file
    https://git.kernel.org/netdev/net-next/c/8d9e5bbf5c68
  - [6/6] net/decnet: Delete obsolete TODO file
    https://git.kernel.org/netdev/net-next/c/b9aa074b896b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


