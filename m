Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B6C31C399
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 22:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbhBOVaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 16:30:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:59668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229803AbhBOVas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 16:30:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 8A4A564DE8;
        Mon, 15 Feb 2021 21:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613424607;
        bh=IgWuxNFyMN45artRe/GLjAQmmi+5cTSbrXDTsHIjmi4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rT2JXHGDXJkXwCeY+0N9uYwYt2LvvI7AHYk8rM2XG4/lgDr7+1I754KLG8oT1psW3
         Q3cO79mO1i9oKliMad2Dtewm4s2e/syQ5cqrPLWT/K2J9Aq8TugJpenU4sVM4AX2rW
         ctPHIw8A4s9OC8OJQGcHuUCbk+HTKYR1S7AEJBNmxaCY/ooFAzrfJxpH1pTxHQVEVD
         7DDI5e5DowoHZ1xYo7TmeP2HXCfM7K/kPgqsFXbR2P35fp/FOCspDsFK+yKKddYpoD
         9gI7zys1ELEPtqYgf5eh3lzX6JEerSur/kdmGYBqq1W4+BKCQrtTWeojZ/zFFpR3up
         7fkcItCYS4F9Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7794B609CD;
        Mon, 15 Feb 2021 21:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: caif: Use netif_rx_any_context().
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161342460748.27343.9729426832137631588.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Feb 2021 21:30:07 +0000
References: <20210213170514.3092234-1-bigeasy@linutronix.de>
In-Reply-To: <20210213170514.3092234-1-bigeasy@linutronix.de>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     netdev@vger.kernel.org, tglx@linutronix.de, davem@davemloft.net,
        kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sat, 13 Feb 2021 18:05:14 +0100 you wrote:
> The usage of in_interrupt() in non-core code is phased out. Ideally the
> information of the calling context should be passed by the callers or the
> functions be split as appropriate.
> 
> The attempt to consolidate the code by passing an arguemnt or by
> distangling it failed due lack of knowledge about this driver and because
> the call chains are hard to follow.
> 
> [...]

Here is the summary with links:
  - [net-next] net: caif: Use netif_rx_any_context().
    https://git.kernel.org/netdev/net/c/d6d8a24023bf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


