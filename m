Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24952480E32
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 01:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238022AbhL2AUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 19:20:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46292 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237994AbhL2AUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 19:20:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A73E761375
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 00:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 06E05C36AF6;
        Wed, 29 Dec 2021 00:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640737212;
        bh=2PeEVaG3RmyvfJB31ZQEQHWFzFUpAQIMZct+mV7qwOE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l8PLXOxD1lG8nBlAEz/OS/E9Q67+SNfrxiywAN3/hGAfhQVwa9635p9D4Fc2yjxpX
         4QobrqBdxE5T7GV7BFh9RblWVLgyaJtDyWpaHCp4qTSYw4da/9uxanD1VgmU39CWPX
         gBMcXcFbzVfPVgyfVofhobQ7ZjjKrhx23WAT2t8Ltc1M+fW9L8ORVb4py1XXTUG4DT
         YcH+zMX0g/9+C/sefpYDPdaeppncSQchihWYkyZkqKUZyIfbSeUpbdrex+Hc1x80F+
         7Sssd54XCxocE2DWI3LUb30s9jN4NBW2Ofv+16do2N+ZKYrp5eQ9Z6khsUXL4tHhOh
         0tes0j9KGk6nw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E318BC395EB;
        Wed, 29 Dec 2021 00:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: don't use pci_irq_vector() in atomic context
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164073721192.15020.14302967135308176907.git-patchwork-notify@kernel.org>
Date:   Wed, 29 Dec 2021 00:20:11 +0000
References: <3cd24763-f307-78f5-76ed-a5fbf315fb28@gmail.com>
In-Reply-To: <3cd24763-f307-78f5-76ed-a5fbf315fb28@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org, tglx@linutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 28 Dec 2021 22:02:30 +0100 you wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> Since referenced change pci_irq_vector() can't be used in atomic
> context any longer. This conflicts with our usage of this function
> in rtl8169_netpoll(). Therefore store the interrupt number in
> struct rtl8169_private.
> 
> [...]

Here is the summary with links:
  - [net-next] r8169: don't use pci_irq_vector() in atomic context
    https://git.kernel.org/netdev/net-next/c/1bd327718841

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


