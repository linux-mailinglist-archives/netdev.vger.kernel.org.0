Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEEA3048D6
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388085AbhAZFjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:39:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:45312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726830AbhAZDUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 22:20:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id DB294225AB;
        Tue, 26 Jan 2021 03:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611631210;
        bh=MfQiPkeY7Zub6JZJsjffsPcUfhKgD/9P0lXdNTtcJOs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O0J/p737CKEKdWxc9G8BKateDJyGotX+Yp0Yv65wJv9Yw5PXPEsrckAC5iNbEza4X
         fEBD0sMBZteKZ7FKX2p/qFkCDRBuzQntmaIQmdH9kF2OIKQNzz31G/zpR9DhCaEnZJ
         BZjYcn2NgDtzXaqEX0FiaMK96JH47iv1FRSoDovfTFOGJ1bWHXVq0zkQwKiiZiQSu5
         WQzZopAuBR5nOzzjURwapnQd01VmrEuEHzyUxTbeTRckoUKSIU+3cKgLXu4Qtnf/1L
         1ycceJF8SHjWZWW7tdbKxk3ThVStJgjpemGEhYL6SC/5MqnxjP/ljiRTFnA+/yrRj8
         5iSdA71tt1SJw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CFEDD61FC0;
        Tue, 26 Jan 2021 03:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: ethernet: mediatek: support setting MTU
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161163121084.4087.12910254272532951713.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Jan 2021 03:20:10 +0000
References: <20210125042046.5599-1-dqfext@gmail.com>
In-Reply-To: <20210125042046.5599-1-dqfext@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        linux@armlinux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, andrew@lunn.ch,
        frank-w@public-files.de, dwmw2@infradead.org, opensource@vdorst.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 25 Jan 2021 12:20:46 +0800 you wrote:
> MT762x HW, except for MT7628, supports frame length up to 2048
> (maximum length on GDM), so allow setting MTU up to 2030.
> 
> Also set the default frame length to the hardware default 1518.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: ethernet: mediatek: support setting MTU
    https://git.kernel.org/netdev/net-next/c/4fd59792097a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


