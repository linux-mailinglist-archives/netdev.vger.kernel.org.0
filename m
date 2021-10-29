Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128FF43FC6D
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 14:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231579AbhJ2Mmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 08:42:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230134AbhJ2Mmg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 08:42:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6E92161177;
        Fri, 29 Oct 2021 12:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635511208;
        bh=2lWuBtcnRVRyq9rdHhRC6nZNPKRk8d/Y0+d1xvGfYdY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ogkl8ef3nfz0Z0L5giexuKddmfezNegZQZcNBC7OwVQMA6Q1xfK1BjcS37InLh481
         0H+l4IQ9aIKR0F2Cc/LULTofDTjClvvRR0nZISx4oNc6vZznvCoUCassdlFdJcqa/Q
         jTIciVIViM2S+7LIP5g/Zey0f79hvzMXBy81ZXGpl4KjWUW8/HIKDQzeWovJltx6o9
         Vu5taR1zQhB9S9wHiM3gVDRZN+ppSFyY3E7GR/GQFmfq/OQ+lHeX8Tmh9CLq8RFdIl
         b+xFM5M7nV9SYHwhT/l6dkno/9ZNbm0kxE+86II0aDjPAZZz/yG7xeGvkcFJd0/hns
         3xxQ85y5VioEQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5C2C460A1B;
        Fri, 29 Oct 2021 12:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] MCTP flow support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163551120837.27055.959178317809229965.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Oct 2021 12:40:08 +0000
References: <20211029030145.633626-1-jk@codeconstruct.com.au>
In-Reply-To: <20211029030145.633626-1-jk@codeconstruct.com.au>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matt@codeconstruct.com.au, andrew@aj.id.au
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 29 Oct 2021 11:01:42 +0800 you wrote:
> For certain MCTP transport bindings, the binding driver will need to be
> aware of request/response pairing. For example, the i2c binding may need
> to set multiplexer configuration when expecting a response from a device
> behind a mux.
> 
> This series implements a mechanism for informing the driver about these
> flows, so it can implement transport-specific behaviour when a flow is
> in progress (ie, a response is expected, and/or we time-out on that
> expectation). We use a skb extension to notify the driver about the
> presence of a flow, and a new dev->ops callback to notify about a flow's
> destruction.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] mctp: Return new key from mctp_alloc_local_tag
    https://git.kernel.org/netdev/net-next/c/212c10c3c658
  - [net-next,v2,2/3] mctp: Add flow extension to skb
    https://git.kernel.org/netdev/net-next/c/78476d315e19
  - [net-next,v2,3/3] mctp: Pass flow data & flow release events to drivers
    https://git.kernel.org/netdev/net-next/c/67737c457281

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


