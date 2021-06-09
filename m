Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 506AC3A09E9
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 04:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbhFICV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 22:21:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229911AbhFICV5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 22:21:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BC97960FDB;
        Wed,  9 Jun 2021 02:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623205203;
        bh=bv01djUeF4szVNu9W89WMbXytcJTU721/mip35uNkMA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ITl41tcOezQZOEl/gyeCMZozV/rbOFtLRZx9X+zNePJ+hHyTJKWX9r/Irl7J+2ML3
         SX8tTWmakemoAGjxBIiZmAoX58dTGa3gxLRAEGp4c6vRjgaTPGrynlknBJireoYcJM
         qj0nYzbSLxzoYYu0bBEEyAnwLzMuq5DJIG4fpY16rhc0j05WsbPBS12uwobJbMyDDL
         8CCiGATrkbUl0kabkZ1GrvyiltDu9dbbK3QD/OBzf+jnuexeFBQ6/dCSDJZt+CGkK9
         80gWtT6a3BQqI8VTVtyIWdpULO2IeD1bbA4dXGmU0DimkpC9ssDS5ycyCV4unsHOlv
         9tt2I8zbX9otQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A719460192;
        Wed,  9 Jun 2021 02:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: lantiq: disable interrupt before sheduling NAPI
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162320520367.32397.3856716167633372569.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 02:20:03 +0000
References: <20210608212107.222690-1-olek2@wp.pl>
In-Reply-To: <20210608212107.222690-1-olek2@wp.pl>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  8 Jun 2021 23:21:07 +0200 you wrote:
> This patch fixes TX hangs with threaded NAPI enabled. The scheduled
> NAPI seems to be executed in parallel with the interrupt on second
> thread. Sometimes it happens that ltq_dma_disable_irq() is executed
> after xrx200_tx_housekeeping(). The symptom is that TX interrupts
> are disabled in the DMA controller. As a result, the TX hangs after
> a few seconds of the iperf test. Scheduling NAPI after disabling
> interrupts fixes this issue.
> 
> [...]

Here is the summary with links:
  - [net] net: lantiq: disable interrupt before sheduling NAPI
    https://git.kernel.org/netdev/net/c/f2386cf7c5f4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


