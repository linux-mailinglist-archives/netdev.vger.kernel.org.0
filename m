Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430BF44243D
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 00:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhKAXml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 19:42:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhKAXml (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 19:42:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0C18060EFF;
        Mon,  1 Nov 2021 23:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635810007;
        bh=cKXh17ovZfbEwhB6Rs7IWOrMQUGyGSNTqzZHhlfcdyw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R1+V4bgcJXv0HmTO+mhcQaXsWmlSfFyxcPXxYZ8XEfgchIt+74x1yDqgrkVHGuX5B
         2UIj0Gs7vODd6c0xzO570eNZ499Keo0BfjdmWVCUKJ/XqhOWcuhBk3flh9ueK/SBRI
         AW/wm+w6KRupQUGKNsSLxMvi6/lHn/z9tPoUY4/qC9P/RmSjBErng6r9s6iWL3k4g3
         oI2ANAyJBT4jk7AGuHx7mSRY2IMuJc2vzO8gZ6ay9rYjJDvMnsj3blRMe9JlSpn+0o
         vnYOkDNeNZWQXQLs+WP2Pys1V4dXyBn+86J1HfuqjrgzU6vbpQMmiKeree9KGpQ1Ij
         +/Qcuq4oPiFMw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F1019609EF;
        Mon,  1 Nov 2021 23:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] netdevsim: fix uninit value in
 nsim_drv_configure_vfs()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163581000698.12918.9152853404945571515.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Nov 2021 23:40:06 +0000
References: <20211101221845.3188490-1-kuba@kernel.org>
In-Reply-To: <20211101221845.3188490-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  1 Nov 2021 15:18:45 -0700 you wrote:
> Build bot points out that I missed initializing ret
> after refactoring.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 1c401078bcf3 ("netdevsim: move details of vf config to dev")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] netdevsim: fix uninit value in nsim_drv_configure_vfs()
    https://git.kernel.org/netdev/net-next/c/047304d0bfa5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


