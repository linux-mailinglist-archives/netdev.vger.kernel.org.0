Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9468434D94F
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231228AbhC2UuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:50:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231218AbhC2UuL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 16:50:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C4CB5619B4;
        Mon, 29 Mar 2021 20:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617051010;
        bh=grisBTz1M+NF5n3tzyPpex6F9HsIE7iq9zWN4guVo9k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BrdfmZuA9seyo8oAaWoTtrtyNbVrslp8ci6xge+WBXl7p2daKB8oaMZqo0F/yl2fV
         FWW1vi9083SJjKbcxuKq0MXIi6zs9HLQ81s3XEpKUtT/CA9gyvJJyaAkY6uAWm2hob
         0u0HRHe/r0NtX3eHt5IHQ63PUSIQp5Fgoz6sh8Y/lMIpBXLsL1vYhAwuW6dqFEF3YF
         OPUcXLH0PsVjA4EEZqv+tJKUgzCQKOfspsTH/hJQPBGc8KbOuzNz0GxSX3hgw09/E7
         xSgcclPpdLkDejPGnTtsYlfdz53A5KUtBQ8NVxJmC8nYDpyZ43na+A4Cg3yNe2GeXy
         GbIXW2gR6heEQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B7B4460A48;
        Mon, 29 Mar 2021 20:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: bonding: Correct function name
 bond_change_active_slave() in comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161705101074.19110.17487266967749951428.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 20:50:10 +0000
References: <20210329124257.3273074-1-yangyingliang@huawei.com>
In-Reply-To: <20210329124257.3273074-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 29 Mar 2021 20:42:57 +0800 you wrote:
> Fix the following make W=1 kernel build warning:
> 
>  drivers/net/bonding/bond_main.c:982: warning: expecting prototype for change_active_interface(). Prototype was for bond_change_active_slave() instead
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [-next] net: bonding: Correct function name bond_change_active_slave() in comment
    https://git.kernel.org/netdev/net-next/c/acf61b3d84cc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


