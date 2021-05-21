Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CC3238CFEB
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 23:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhEUVbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 17:31:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229568AbhEUVbd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 17:31:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5CA7D613EE;
        Fri, 21 May 2021 21:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621632610;
        bh=1pE3V9JkGWBHtRW7sSAojQ07EFPVyh8MZZ/u3LF7Q44=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qy6u8fOxxPHltRcCB0d1so1kcclmGS8qt6uwyQ60/14S642Y8uL7vux56+zC9NfTl
         phnNox9kLT0ZT0DoC/VFBnS48im5kcPRkrw2M8OhfjdZ0sN+wCNyWzlbz6qaW/GIh2
         Ya0M1XAw8OC8mr0fDs+Qos9XtEuBCZCnPaD5ln3qpqk5CivLxUMyeNVbWbJ9iJZ32j
         t7rEfDQHzJ8hXVyi2vNcdyk4n4x3ix20bypeof4zm2Z1DVRHFCgC8eJVaudYgn/0Ja
         HFov/UpIpg6FF55sZdgPzuezzrJlOOY+TQXiKKSXLVhYQCfNJHTIYjm6QZ56gTNL3W
         fg1vYVLKKTlRw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5062B60A56;
        Fri, 21 May 2021 21:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: lantiq: fix memory corruption in RX ring
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162163261032.6211.4385678507932104671.git-patchwork-notify@kernel.org>
Date:   Fri, 21 May 2021 21:30:10 +0000
References: <20210521144558.2071-1-olek2@wp.pl>
In-Reply-To: <20210521144558.2071-1-olek2@wp.pl>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>
Cc:     hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 21 May 2021 16:45:58 +0200 you wrote:
> In a situation where memory allocation or dma mapping fails, an
> invalid address is programmed into the descriptor. This can lead
> to memory corruption. If the memory allocation fails, DMA should
> reuse the previous skb and mapping and drop the packet. This patch
> also increments rx drop counter.
> 
> Fixes: fe1a56420cf2 ("net: lantiq: Add Lantiq / Intel VRX200 Ethernet driver ")
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> 
> [...]

Here is the summary with links:
  - [net,v2] net: lantiq: fix memory corruption in RX ring
    https://git.kernel.org/netdev/net/c/c7718ee96dbc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


