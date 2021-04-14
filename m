Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E8935FD5E
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 23:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbhDNVkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 17:40:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:38004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232273AbhDNVke (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 17:40:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A1895611AD;
        Wed, 14 Apr 2021 21:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618436412;
        bh=RNBt112aUgHObpmqsDO/S/Ba0UwuXGJD6FEkNBfvpTo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V1iJFYnWpjhJfnVeP6mdyzmoWLymjO+oe9xR08t1M/eH1TldwCGbFTXX1+R5TkWUb
         5ts5XvTN5bPhNOxGG6cVLhdQscuS10g39SvhNrXjR+ZuYA/SoMARFNU1s08iIM9way
         i7L+akWqsqzZ3IHxKlpQdGSDbD/1YQf6o9BL28h6mNQBguTLTJtKGFMPMNSYIUKaL6
         qVvWbpAIH5P7maKYMoIEBO8vGXlWs+Niz9Ukj3vUYW4Fx29xgIg4NWH21tPT0N+eh4
         lZ3ydCsGPtkxH3Ir2RUkPRm2iXgpEmro2xpbuPGmTBG/KostSbQVFtN5R4HhVooKXR
         /n0TaSPVZNDVQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9294960CD5;
        Wed, 14 Apr 2021 21:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next] can: etas_es58x: fix null pointer dereference when
 handling error frames
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161843641259.17301.17320204986142431938.git-patchwork-notify@kernel.org>
Date:   Wed, 14 Apr 2021 21:40:12 +0000
References: <20210414200352.2473363-2-mkl@pengutronix.de>
In-Reply-To: <20210414200352.2473363-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        mailhol.vincent@wanadoo.fr, arunachalam.santhanam@in.bosch.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 14 Apr 2021 22:03:52 +0200 you wrote:
> From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> 
> During the handling of CAN bus errors, a CAN error SKB is allocated
> using alloc_can_err_skb(). Even if the allocation of the SKB fails,
> the function continues in order to do the stats handling.
> 
> All access to the can_frame pointer (cf) should be guarded by an if
> statement:
> 	if (cf)
> 
> [...]

Here is the summary with links:
  - [net-next] can: etas_es58x: fix null pointer dereference when handling error frames
    https://git.kernel.org/netdev/net-next/c/e2b1e4b532ab

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


