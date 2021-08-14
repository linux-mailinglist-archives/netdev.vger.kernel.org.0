Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 589FE3EBF82
	for <lists+netdev@lfdr.de>; Sat, 14 Aug 2021 04:00:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236548AbhHNCAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 22:00:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236264AbhHNCAd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 22:00:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2F33F6109D;
        Sat, 14 Aug 2021 02:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628906406;
        bh=x+vIUa90xu9doi5TOlFrlHiTgBSLjXLMMQAbvCKvfZ8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=flFniyCV2doBSfLIjPeTwES4VWYKB7thPS5g+nUgVMAWr13XfPof9OQz5r0HCd/ts
         CKEBaciozoT/4CQGSI7l4tARJbWHtQ17vDy1QBgHVJyMhCt9rJ8WJVAPDW7WhpwrsC
         JhTh8PrFEwj0/m7p3I5vvnE7+qNoxvI32IjcZ9nU2B0RAbTHinc5D8MbgvkZLB2kIl
         yEFtmXPr86/wqXQermYVDcAzrc9Brx+rKc+XX/d6PJGF08zZqlvVM2wkFldcJuz1a7
         dGtMaP/nLXLzTR+pqtrQFpY7ENZb8e9ZTtiB3Gb5PHlI9kLMnlKZ/9nWMbtM5enG+g
         qlgDqnRAxkvoQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 21B2E609AF;
        Sat, 14 Aug 2021 02:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ethernet: fix PTP_1588_CLOCK dependencies
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162890640613.14711.5571042390891720240.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Aug 2021 02:00:06 +0000
References: <20210812183509.1362782-1-arnd@kernel.org>
In-Reply-To: <20210812183509.1362782-1-arnd@kernel.org>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, arnd@arndb.de,
        snelson@pensando.io, jacob.e.keller@intel.com,
        richardcochran@gmail.com, vladimir.oltean@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 12 Aug 2021 20:33:58 +0200 you wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The 'imply' keyword does not do what most people think it does, it only
> politely asks Kconfig to turn on another symbol, but does not prevent
> it from being disabled manually or built as a loadable module when the
> user is built-in. In the ICE driver, the latter now causes a link failure:
> 
> [...]

Here is the summary with links:
  - ethernet: fix PTP_1588_CLOCK dependencies
    https://git.kernel.org/netdev/net-next/c/e5f31552674e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


