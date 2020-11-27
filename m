Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C612C6DCC
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 00:52:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732570AbgK0Xva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 18:51:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:41404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730826AbgK0XuV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 18:50:21 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606521021;
        bh=SGdSUjoCHshGhPyoMyZ1cVTtgKUjSZoirFy8nd8rM7g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AYrmPen7HbdOaI2X3MtLRV2kX9d2FImMjAXkgDB5Oc7rkZpyDfQDtivUTKV4tLrJZ
         tlJHmR+26PWkJGDf+qW6b/NH78M9J+1L25Ut6ffJJF5Injj19KqWnaeCV5tzU20Ezg
         Qo2vNilGE/pwGpcyTKLuyHuwUAJFVN2ixJTIjbr4=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Networking
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160652102130.12601.8586675332676762024.git-patchwork-notify@kernel.org>
Date:   Fri, 27 Nov 2020 23:50:21 +0000
References: <20201127200428.221620-1-kuba@kernel.org>
In-Reply-To: <20201127200428.221620-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Fri, 27 Nov 2020 12:04:28 -0800 you wrote:
> The following changes since commit 4d02da974ea85a62074efedf354e82778f910d82:
> 
>   Merge tag 'net-5.10-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-11-19 13:33:16 -0800)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git tags/net-5.10-rc6
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Networking
    https://git.kernel.org/netdev/net/c/79c0c1f0389d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


