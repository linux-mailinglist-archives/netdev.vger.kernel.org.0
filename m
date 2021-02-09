Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399633144F0
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 01:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbhBIAaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 19:30:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:39810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229554AbhBIAas (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 19:30:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1433364E9A;
        Tue,  9 Feb 2021 00:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612830608;
        bh=tdBGVa4iM1TZ8u6gj8c3+muojqUGknmIlI7Wq+qo1pY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gHhb2v7hg9FiZ8qyCToIw1YnsMmrn9ZVfvndwqpto1+n6u7+cfWUf8Vg2ITW6uPw9
         +EFUsu3mzap6FYYN3GgG1+f2rVscWFtLUJ5JMMKSkog8J+vkRrf9s2DPblXGN9bfxO
         xZp8XlbwNV6nfzvuWdCxAaYczImMrlTqeDmPRlO+CGxQ5RyEEfC+1V23m7Waw9RGBB
         y0Uo9zXHNB2aelPuga88B1JccEZalXOtX9JmyZlY78KiPgY8YvNbptzGOytcF7KZl5
         HDVVEnyjZFi6Eo7O9HCqr4mQ6j2YECys4kJRXGuv82m5bL20PVb0r+KKbI01uKQKy7
         c88Dglw70yx+w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 07B01609D4;
        Tue,  9 Feb 2021 00:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: watchdog: hold device global xmit lock during tx
 disable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161283060802.30880.13274297452987698387.git-patchwork-notify@kernel.org>
Date:   Tue, 09 Feb 2021 00:30:08 +0000
References: <20210206013732.508552-1-edwin.peer@broadcom.com>
In-Reply-To: <20210206013732.508552-1-edwin.peer@broadcom.com>
To:     Edwin Peer <edwin.peer@broadcom.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        andrew.gospodarek@broadcom.com, michael.chan@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  5 Feb 2021 17:37:32 -0800 you wrote:
> Prevent netif_tx_disable() running concurrently with dev_watchdog() by
> taking the device global xmit lock. Otherwise, the recommended:
> 
> 	netif_carrier_off(dev);
> 	netif_tx_disable(dev);
> 
> driver shutdown sequence can happen after the watchdog has already
> checked carrier, resulting in possible false alarms. This is because
> netif_tx_lock() only sets the frozen bit without maintaining the locks
> on the individual queues.
> 
> [...]

Here is the summary with links:
  - [net] net: watchdog: hold device global xmit lock during tx disable
    https://git.kernel.org/netdev/net/c/3aa6bce9af0e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


