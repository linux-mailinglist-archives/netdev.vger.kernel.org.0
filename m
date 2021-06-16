Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47083A946A
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 09:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbhFPHwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 03:52:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231666AbhFPHwK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 03:52:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C5BCE613CD;
        Wed, 16 Jun 2021 07:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623829804;
        bh=2/Pfq4V0NUEuxm2cMUGried3iYOMpcx2N4qGAFGjhiM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aiakAGgKM9zdWz2KEPyClszr5rEhkzxoqybhOjKuD4494H/6VQLEMptpPisilQkvX
         3CC2l8MHxEtZODCDtRTypb4sYI3sv/C8nbCEWPXI/Kw3GPub+oolukj4jintz0HC+r
         vQ7FjkPFlVbffMZRCOfEnz8/Tyn1hTdOd9N6F6wmqGxZnDVV4OFjA2zSnt/jE9SYkH
         m80whZYgbdu4eoVYT32Int4Om3LrunumWVdBXAJpHuV+yOLL8JRUXCS0yACNgxORLn
         HIPYN2pr7cTUSu+WWkXIhCwTnhqMvXG0p5CmiOeewG4Fvfm4APmXFDpBHJJPZ+an+N
         wUNLi7DuKXUBA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BC78160A71;
        Wed, 16 Jun 2021 07:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ethtool: add a stricter length check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162382980476.6206.10984768774468130208.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 07:50:04 +0000
References: <20210616033338.616576-1-kuba@kernel.org>
In-Reply-To: <20210616033338.616576-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, mkubecek@suse.cz
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 15 Jun 2021 20:33:38 -0700 you wrote:
> There has been a few errors in the ethtool reply size calculations,
> most of those are hard to trigger during basic testing because of
> skb size rounding up and netdev names being shorter than max.
> Add a more precise check.
> 
> This change will affect the value of payload length displayed in
> case of -EMSGSIZE but that should be okay, "payload length" isn't
> a well defined term here.
> 
> [...]

Here is the summary with links:
  - [net-next] ethtool: add a stricter length check
    https://git.kernel.org/netdev/net-next/c/4d1fb7cde0cc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


