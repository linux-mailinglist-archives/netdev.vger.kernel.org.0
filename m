Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD107480934
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 13:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbhL1MuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 07:50:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbhL1MuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 07:50:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8639BC061574;
        Tue, 28 Dec 2021 04:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AF33B811D8;
        Tue, 28 Dec 2021 12:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DB009C36AEB;
        Tue, 28 Dec 2021 12:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640695809;
        bh=YXuwCkbPs72bsdnl04GFMAaLrgYSp8Aelfoqdg37GBQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FmANAmaJFzvMcq2JXGqmmdRNxmfTOk8t7Le6pJFWnWgq115jNdlxUQODGJtOdt2Vc
         gGMmUmmVgKzWeSgdre3fC5dzxHmZH8dArZwWgDhOaExoLI4yju4To2ZzdoDr/qaIir
         fAi0s7y0GAnSUbtKxJ6S/WEeSP8R7i5wT+2Am8Zhd5tC2kWxv8V0we5h3XfBfzqAL3
         7Nb9WWBwFGkcPY8tWWxyY1Mlr2UYGDCz60L5PJnnmm3e5jNaxulY+FCBSYis6JJXD+
         hLOCU7uQauEgiYzgfdSOVmBxvCV/Qbli7Yj4LLZ47zZrS7BZ7T8RTFyIFOCMwCSyrG
         z7Jpeq5D/DAxA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BF6FDC395E7;
        Tue, 28 Dec 2021 12:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net/smc: fix kernel panic caused by race of smc_sock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164069580977.6060.15231858958100599514.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Dec 2021 12:50:09 +0000
References: <20211228090325.27263-1-dust.li@linux.alibaba.com>
In-Reply-To: <20211228090325.27263-1-dust.li@linux.alibaba.com>
To:     Dust Li <dust.li@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        guwen@linux.alibaba.com, tonylu@linux.alibaba.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 28 Dec 2021 17:03:23 +0800 you wrote:
> This patchset fixes the race between smc_release triggered by
> close(2) and cdc_handle triggered by underlaying RDMA device.
> 
> The race is caused because the smc_connection may been released
> before the pending tx CDC messages got its CQEs. In order to fix
> this, I add a counter to track how many pending WRs we have posted
> through the smc_connection, and only release the smc_connection
> after there is no pending WRs on the connection.
> 
> [...]

Here is the summary with links:
  - [net,1/2] net/smc: don't send CDC/LLC message if link not ready
    https://git.kernel.org/netdev/net/c/90cee52f2e78
  - [net,2/2] net/smc: fix kernel panic caused by race of smc_sock
    https://git.kernel.org/netdev/net/c/349d43127dac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


