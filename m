Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB53A482B0E
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 13:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbiABMUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 07:20:18 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37524 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiABMUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 07:20:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36396B80D1E;
        Sun,  2 Jan 2022 12:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D91ABC36AEF;
        Sun,  2 Jan 2022 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641126010;
        bh=ORvVYn/g/JF/EeG9FNS1xBD9XD9MbupLOpHX2mMaNvQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pKtaygDiVs4bYfIv6zRh6Ew0APK6FasVpjC5J/rvsQu19zB62E+nPGuE446cja7Nz
         3Pw2Z8wxJRMUI8z33tf9PVPidpJHTQBW3ViWGjJksJWpvUlgdvE4fM0KZ2e3t7ixrp
         IMbRUXCOijoRjulfHVauUO0q2+Be81NNI6M9ocNmHSflDSE+JFKGsaWudUDEP6/vwD
         4QXtMJFCwEAWsvV2jQKMwZ6qG7WxCZrK0bG+25s/tP9AX7bEoBJFck1It7+4rfxvlc
         B2MK5zqvXvbEEkxNlgCBrypVSOTzuqQ65i7tbj6XXoff5ri7lfwr8RjAXzqnPfVib8
         6ioRC9Y/ACDXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C706DC395EA;
        Sun,  2 Jan 2022 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/smc: remove redundant re-assignment of pointer link
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164112601081.23508.17573608066281276225.git-patchwork-notify@kernel.org>
Date:   Sun, 02 Jan 2022 12:20:10 +0000
References: <20211230153900.274049-1-colin.i.king@gmail.com>
In-Reply-To: <20211230153900.274049-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 30 Dec 2021 15:39:00 +0000 you wrote:
> The pointer link is being re-assigned the same value that it was
> initialized with in the previous declaration statement. The
> re-assignment is redundant and can be removed.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  net/smc/smc_clc.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - net/smc: remove redundant re-assignment of pointer link
    https://git.kernel.org/netdev/net-next/c/3a856c14c31b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


