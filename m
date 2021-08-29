Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9EC3FAAAB
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 12:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235264AbhH2KBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 06:01:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:36190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234935AbhH2KA5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Aug 2021 06:00:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C82C960C41;
        Sun, 29 Aug 2021 10:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630231205;
        bh=qJuSD3NSpuGrNVH+pOlPEVpW4+BSg5IPon0/mGKDSRY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qn4y4Eo/6pneaKGHySRPiDJnTfQWMGmUKP10uMHZjPfD8W0KnpfhiuxnTwxodGrom
         GHovug9RtYKxKK67w1zqSHIXB9SIjqlKed78yJmjJOMa1hJW3VrlUb2FRqNuRdWsRK
         OFfnHpQUb45P6k0xCNaASTxqEk8wVrtsswDqCXkJAimCKh96M5XMnNfgn23t/j5LCX
         q+La6hNpdYT1UceFf7+8oEODF65tjXAwccbDKSqP5HtCDp6lOOjA8vHAbWOyrR0eU/
         pOyIPa6iuXzbDQjFfqRt4F2CrK4zUw1E2tol3Ri9kK8BIxvICwam91fNsSIt6cTUGr
         tL8ZUSH5uLROA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BD92460A14;
        Sun, 29 Aug 2021 10:00:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: spider_net: switch from 'pci_' to 'dma_' API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163023120577.23170.14559498942761787716.git-patchwork-notify@kernel.org>
Date:   Sun, 29 Aug 2021 10:00:05 +0000
References: <60abc3d0c8b4ef8368a4d63326a25a5cb3cd218c.1630094078.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <60abc3d0c8b4ef8368a4d63326a25a5cb3cd218c.1630094078.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     kou.ishizaki@toshiba.co.jp, geoff@infradead.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 27 Aug 2021 21:56:28 +0200 you wrote:
> In [1], Christoph Hellwig has proposed to remove the wrappers in
> include/linux/pci-dma-compat.h.
> 
> Some reasons why this API should be removed have been given by Julia
> Lawall in [2].
> 
> A coccinelle script has been used to perform the needed transformation
> Only relevant parts are given below.
> 
> [...]

Here is the summary with links:
  - net: spider_net: switch from 'pci_' to 'dma_' API
    https://git.kernel.org/netdev/net-next/c/27d57f85102b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


