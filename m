Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB1E427475
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 02:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243921AbhJIACD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 20:02:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243797AbhJIACD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 20:02:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4667B60FC2;
        Sat,  9 Oct 2021 00:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633737607;
        bh=3GEKgwv+aHj40Lo2d3YMoAMRIH/ew/OFR2SLhkhvpaM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jh35xL+aE+FbBRMFwOWzeH2ZH1GTPP2HBfudoMPRMfLpMjor1L/N8DvV6lU8MsaW3
         yB08dfhVC0MPYd+Bokl0k4N5RAWxPZQtwbKN6N6FhyCtx3K07hzZlLFsJB/dHM6sO4
         kwNGMg314kLDXLtqk9IWGIB+7KmLYDWVBboQZ8wBwOW8RX2qWXDkV6YC3ibbQjKzWv
         l1n9eZHK1EHw9TDlQ+6z8claYClZo2XEMSSRpwK6lwRBs5OjZsVEoIeCwf0eBvg8R2
         x5rkyTQImfuvzO2WdeTZ0bFvHJTl6arfBRWzNF+NmK2Whu30REwPJGDiS1ZzdsurQF
         V6ZVNNX7ZUGZA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 39DAA60A24;
        Sat,  9 Oct 2021 00:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] isdn: cpai: check ctr->cnr to avoid array index out of bound
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163373760723.30259.10246434589775827749.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Oct 2021 00:00:07 +0000
References: <20211008065830.305057-1-butterflyhuangxx@gmail.com>
In-Reply-To: <20211008065830.305057-1-butterflyhuangxx@gmail.com>
To:     Xiaolong Huang <butterflyhuangxx@gmail.com>
Cc:     isdn@linux-pingi.de, davem@davemloft.net, arnd@arndb.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  8 Oct 2021 14:58:30 +0800 you wrote:
> The cmtp_add_connection() would add a cmtp session to a controller
> and run a kernel thread to process cmtp.
> 
> 	__module_get(THIS_MODULE);
> 	session->task = kthread_run(cmtp_session, session, "kcmtpd_ctr_%d",
> 								session->num);
> 
> [...]

Here is the summary with links:
  - isdn: cpai: check ctr->cnr to avoid array index out of bound
    https://git.kernel.org/netdev/net/c/1f3e2e97c003

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


