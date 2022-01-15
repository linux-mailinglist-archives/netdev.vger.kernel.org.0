Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F23348F9BE
	for <lists+netdev@lfdr.de>; Sun, 16 Jan 2022 00:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbiAOXAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 18:00:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52730 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231483AbiAOXAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 18:00:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CA99B80C83;
        Sat, 15 Jan 2022 23:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29539C36AEF;
        Sat, 15 Jan 2022 23:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642287609;
        bh=yKSa1yO06cC7xDb44AAOZz+o9oAW/joqyx8YUk6xLCg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZH6ARvIoQlMGAyMsJZD7PVYUVBRKeNyPp+m40WTbyQY11VqVQmw6g5D6QmWCxJtGa
         uvHcUDGbbIRzz4vs7cAYyQGlluIpuyzEoTbjilHYNMpdJcUcFYyR9GWyV+H2cgTZ5/
         mXphCW2atzxue60BYFsXeOth3L/L3ttbvgirZr1aG/TISMIm04RoF1jphK4PWYSq2F
         HEUAtgSAoCk5D6E7aQttGmBzA4LHywdgXOql7D4+5/ecuS0acx/nWKJR3hOlkl8FP+
         HrNIzfDZLEDX33wItMstP83vK6xgBZd8hez0F8RKvoCLL1DsbrMzZD2NpZXJs84aiR
         0VwJMltSGJY+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1196DF6079A;
        Sat, 15 Jan 2022 23:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/smc: Remove unused function declaration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164228760906.1385.6668664437675144815.git-patchwork-notify@kernel.org>
Date:   Sat, 15 Jan 2022 23:00:09 +0000
References: <1642167345-77338-1-git-send-email-guwen@linux.alibaba.com>
In-Reply-To: <1642167345-77338-1-git-send-email-guwen@linux.alibaba.com>
To:     Wen Gu <guwen@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 14 Jan 2022 21:35:45 +0800 you wrote:
> The declaration of smc_wr_tx_dismiss_slots() is unused.
> So remove it.
> 
> Fixes: 349d43127dac ("net/smc: fix kernel panic caused by race of smc_sock")
> Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
> ---
>  net/smc/smc_wr.h | 4 ----
>  1 file changed, 4 deletions(-)

Here is the summary with links:
  - [net] net/smc: Remove unused function declaration
    https://git.kernel.org/netdev/net/c/9404bc1e58e4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


