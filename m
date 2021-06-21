Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8663AF78F
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 23:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbhFUVmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 17:42:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:42640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230331AbhFUVmT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 17:42:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 79D1B611BD;
        Mon, 21 Jun 2021 21:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624311604;
        bh=4PzvXmOzCpR/+dWxxNc7CWpXcZLC4sLsZoFeZp5123o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C7YGvjEHFUKZTunjrLB9phqMSq41byLKHq0DL2DH2mYsDxECj3FXAKYXB4C4pBvL0
         n+MaWIBBYviIFqOQGX/Zv92YPyqYp99NRwF+9Tqp4aNCX9GXcYsKkKurkbUYUD0Jdk
         YypdzLd6oK5atT2siiNjGKLEdOc92iLk6keLb4g2uueojpKEH5d1zBFjWXzo6taEjF
         sb8qK6VfUXEvL63oXKVP7G2QnjluabSEHCzd5hj2FauXUEVO8PxvOhvLKlGTvQhouz
         jza7DZlMyr3gYy+GYp8Vo4iUU73115/auwCf7DTPAdEigiJwxKRiydDnYNCKa10DF4
         yUyaDRw3wD3Pg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6C0C7609AD;
        Mon, 21 Jun 2021 21:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V3 net-next 0/2] net: fec: fix TX bandwidth fluctuations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162431160443.11017.14637252438734266524.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 21:40:04 +0000
References: <20210621062737.16896-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20210621062737.16896-1-qiangqing.zhang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, frieder.schrempf@kontron.de,
        andrew@lunn.ch, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 21 Jun 2021 14:27:35 +0800 you wrote:
> This patch set intends to fix TX bandwidth fluctuations, any feedback would be appreciated.
> 
> ---
> ChangeLogs:
> 	V1: remove RFC tag, RFC discussions please turn to below:
> 	    https://lore.kernel.org/lkml/YK0Ce5YxR2WYbrAo@lunn.ch/T/
> 	V2: change functions to be static in this patch set. And add the
> 	t-b tag.
> 	V3: fix sparse warining: ntohs()->htons()
> 
> [...]

Here is the summary with links:
  - [V3,1/2] net: fec: add FEC_QUIRK_HAS_MULTI_QUEUES represents i.MX6SX ENET IP
    https://git.kernel.org/netdev/net-next/c/471ff4455d61
  - [V3,2/2] net: fec: add ndo_select_queue to fix TX bandwidth fluctuations
    https://git.kernel.org/netdev/net-next/c/52c4a1a85f4b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


