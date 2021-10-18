Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D465F432A5A
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 01:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbhJRXcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 19:32:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:55274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231297AbhJRXcT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 19:32:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B5620600CC;
        Mon, 18 Oct 2021 23:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634599807;
        bh=1FwAzEjbv0/t3OVXowsfKLlH2XtIW3Kl1d2qA7Qqyhc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G3sYoYQedG+JLaSEiQx2nz7GDfA9+M6dFPBTxA1nd7SN3qzcDRKvLnfGTQFaKyJOg
         StvBESqJLJF7U0W3CztDE8zwPKj4em88/UVq1TwgE7MOBCqO4+d0cdd/AZh88a3zT7
         oifU8xmZdxIDKgKs9sfa1z4HyI0ro/a9MFG+o0BK3TooP7Fr+GISDqYxvpTgJS1Ugw
         DAjPx2/HS8hzJobd+idAde/bLu4eUhKxVv36QEQUkcp0cxkntdtHxiRvF0Jh+66BND
         I82cYbYQRNRSMRR2kdjJlRl8eU2FZyQ+064y7YCRE5Ud5ewZow0wHtPg9j6W7ww0FF
         uGdGe22BI6jdw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A319D600E6;
        Mon, 18 Oct 2021 23:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/2] qed: Optimize the ll2 ooo flow
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163459980766.4858.17698270893538376685.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Oct 2021 23:30:07 +0000
References: <20211015124118.29041-1-smalin@marvell.com>
In-Reply-To: <20211015124118.29041-1-smalin@marvell.com>
To:     Shai Malin <smalin@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        aelior@marvell.com, malin1024@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 15 Oct 2021 15:41:16 +0300 you wrote:
> Optimize the ll2 TCP out-of-order likely flows:
> - Optimize the non-error flows of the ll2 ooo data path.
> - Optimize "QED_OOO_RIGHT_BUF" over "QED_OOO_LEFT_BUF".
> 
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] qed: Optimize the ll2 ooo flow
    https://git.kernel.org/netdev/net-next/c/891e861efb1d
  - [net-next,2/2] qed: Change the TCP common variable - "iscsi_ooo"
    https://git.kernel.org/netdev/net-next/c/939a6567f976

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


