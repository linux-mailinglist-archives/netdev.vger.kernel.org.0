Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78FB2DF109
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 19:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbgLSSas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Dec 2020 13:30:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725960AbgLSSar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Dec 2020 13:30:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608402607;
        bh=cj45JuCXNPY3xInrOk6ZUDWlvxGH+VBZTSXSTW9cwnw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=czwBzABW3OCfP0WhsNTn+7idFg+dAGyQjZkn9Qagmyvuuar3o4moPYpxsYm1XIaeI
         9fd0T1cwneVCVq4hZf8+sxQYJD5mI8Y6mFGk7e9t4a4j2VZmaXa0ijksm5pxdkJLgI
         JyojnRyz77gghEE4PE5qF+k86jlJ1YV7a5lQKyVjqXpVYn8spiTgdmZ7U8N0/Gncj/
         kXBbdq/zlKl6zXgAw6s0YQZiqJoWigZKlz7mHYINv1kb9bCKBGmyg1kyG/sTnjcrPo
         iygzBGKUGf6dfEAFRxIPGt4GGwwiScnGVq97DzqDZPqASUiEVMKRyux8HXip050pdY
         zdvt8NdGVAOwg==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: mvpp2: prs: fix PPPoE with ipv6 packet parse
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160840260707.19884.10591726484296178579.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Dec 2020 18:30:07 +0000
References: <1608230266-22111-1-git-send-email-stefanc@marvell.com>
In-Reply-To: <1608230266-22111-1-git-send-email-stefanc@marvell.com>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        davem@davemloft.net, nadavh@marvell.com, ymarkman@marvell.com,
        linux-kernel@vger.kernel.org, kuba@kernel.org,
        linux@armlinux.org.uk, mw@semihalf.com, andrew@lunn.ch,
        rmk+kernel@armlinux.org.uk, atenart@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 17 Dec 2020 20:37:46 +0200 you wrote:
> From: Stefan Chulski <stefanc@marvell.com>
> 
> Current PPPoE+IPv6 entry is jumping to 'next-hdr'
> field and not to 'DIP' field as done for IPv4.
> 
> Fixes: 3f518509dedc ("ethernet: Add new driver for Marvell Armada 375 network unit")
> Reported-by: Liron Himi <lironh@marvell.com>
> Signed-off-by: Stefan Chulski <stefanc@marvell.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] net: mvpp2: prs: fix PPPoE with ipv6 packet parse
    https://git.kernel.org/netdev/net/c/fec6079b2eea

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


