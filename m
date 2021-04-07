Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CCB35772B
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 23:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234418AbhDGVuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 17:50:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhDGVuU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 17:50:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BCAE561246;
        Wed,  7 Apr 2021 21:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617832210;
        bh=FZOVOW3eZ/QQfCDWfs5OIWNifqf1/yAJoG8vWQyMF2s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Jtt0eBLiyXoxL71sfdUPCcZNbNaQEIo26aviEy+diCyW3najZ0QV7zEd/f+gXxx43
         MrI8TcLrvVRfEDQHjd7FNAS2vX9fsLT2DmvepoAd+2TDyw9wK3vWMOOKLEolUHyGIv
         bYqa6yY+hxoxDhgNBQ5TwORzyjbgDck7Zvsm8EcKp6UcybPYKjIZKouwDJ2tkmX8tg
         DDIPucudOExIW4qlt6y+WbCnKscJ5pFLKkyHn4hNUiQXWM0xFh+0aoEu/G/FDrzhRN
         F62/mz3XcEU3VzH5Qh+q+540yMSKD+pb45eJ8+TzS3Tf+Hur5NjENg4dZ0N2qawR7c
         GwTTkUZBJ+New==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AD49E609B6;
        Wed,  7 Apr 2021 21:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: introduce nla_policy for IFLA_NEW_IFINDEX
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161783221070.30231.4148077025595242541.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 21:50:10 +0000
References: <20210407064003.248047-1-avagin@gmail.com>
In-Reply-To: <20210407064003.248047-1-avagin@gmail.com>
To:     Andrei Vagin <avagin@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  6 Apr 2021 23:40:03 -0700 you wrote:
> In this case, we don't need to check that new_ifindex is positive in
> validate_linkmsg.
> 
> Fixes: eeb85a14ee34 ("net: Allow to specify ifindex when device is moved to another namespace")
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Andrei Vagin <avagin@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: introduce nla_policy for IFLA_NEW_IFINDEX
    https://git.kernel.org/netdev/net-next/c/7e4a51319d3a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


