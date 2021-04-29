Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01A6936F10B
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 22:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237091AbhD2UaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 16:30:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237075AbhD2UaL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Apr 2021 16:30:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F11496140C;
        Thu, 29 Apr 2021 20:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619728164;
        bh=CVQXrTGaKg0pI2gecguqSN5CvNlnsfeFdQWUDat/lcU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hOVEMwZHc5v0/sGZeDuBAn5+WeBQugpGh5GNX7MOdP08WF2IUBIQwuY4MCl+gHp/5
         cjQKrMa57eh06EflK7ADJoMRK/vpUPkgIHlQ72ZxxIpC45HmqFutt7td/TKWOsaOnf
         Xy8E4wgrg4V1GxLOPAu9uU7IEDsgqUXtRYf5aY4sq1av42oGwP246mmMT3uZS9goak
         j8hXDcu4NlvtzzVu+pHjLtcPu3XjeIsxcfU0DhoJZYNyFYP2bHehra0q+aBXTscQTf
         tfuY2Et4KExxl+Vggi2z0748KfJmX3DCwAZoBGKNe7VrYtqyzXCs1M6DSJvSHDpFk+
         LLMDste/+42pQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E525660A3A;
        Thu, 29 Apr 2021 20:29:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Networking for 5.13
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161972816393.13177.15976811163947595940.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Apr 2021 20:29:23 +0000
References: <20210429023712.2011727-1-kuba@kernel.org>
In-Reply-To: <20210429023712.2011727-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     torvalds@linux-foundation.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Wed, 28 Apr 2021 19:37:12 -0700 you wrote:
> Hi Linus!
> 
> This is the 5.13 netdev PR. At the time of writing we expect two minor
> conflicts - trivial in drivers/of/of_net.c, and net/nfc/nci/uart.c.
> For the latter removal of the code is correct, our only change was
> a spelling fix.
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Networking for 5.13
    https://git.kernel.org/netdev/net/c/9d31d2338950

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


