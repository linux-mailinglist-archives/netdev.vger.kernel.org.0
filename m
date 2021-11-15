Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0983450512
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 14:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbhKONNk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 08:13:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:44818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231661AbhKONNF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 08:13:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 04E3F61BC1;
        Mon, 15 Nov 2021 13:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636981809;
        bh=QWzkyQIaiUBeN3SEIjxEa+FCUNRyPRJ5QKu3bx2V9KI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l+e8VKefPyytOp9gYqkQd6GjmydQxH/p3LOTIHvg6rFhWQjEOo9mxw8ufmrTdb3wY
         0Pn+ptTUTfoNqkPHu73B6GCs1Iav8S44EycTIOB1kopLW0DbaGfPwV2sm3j2banZjY
         IsdvMwvupcLvN4sn3vbYODxrZD3q/EEi1ulDCWGtG0keF6NP5saOcLGYit/vvRfdv3
         bzOcnhJ6M8UYoFn5PWQC8sFVdZT+1y7KQ6P2Kgwt+Hm6HLHGon/HkXLi6ic3Uxg+wu
         3HMQq0YHkTsSWwLCSSRUv4ukcJFr5RLd+slwPtn3CBLC/9AjOb7tVfCg9zVZzHdZDv
         zES50jgMlHgnQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E87CE60A88;
        Mon, 15 Nov 2021 13:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tun: fix bonding active backup with arp monitoring
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163698180894.15087.10819422346391173910.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Nov 2021 13:10:08 +0000
References: <20211112075603.6450-1-nicolas.dichtel@6wind.com>
In-Reply-To: <20211112075603.6450-1-nicolas.dichtel@6wind.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 12 Nov 2021 08:56:03 +0100 you wrote:
> As stated in the bonding doc, trans_start must be set manually for drivers
> using NETIF_F_LLTX:
>  Drivers that use NETIF_F_LLTX flag must also update
>  netdev_queue->trans_start. If they do not, then the ARP monitor will
>  immediately fail any slaves using that driver, and those slaves will stay
>  down.
> 
> [...]

Here is the summary with links:
  - [net] tun: fix bonding active backup with arp monitoring
    https://git.kernel.org/netdev/net/c/a31d27fbed5d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


