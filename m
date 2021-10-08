Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95609426F02
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 18:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236957AbhJHQcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 12:32:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40500 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230301AbhJHQcE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 12:32:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4278361058;
        Fri,  8 Oct 2021 16:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633710609;
        bh=trtTR+tgphJiSiXr6lr5Uzo1hUaBuEPiQu21jNTiviI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h3EsbwA/pXOektv7D2k/OFcu6049fd2YW2PDnv147XuUKjoOCMcjE9BoR+AJ1ZRE6
         6r4Ft6RCuZSdf0UkTAeaMgieV8UAGJwPAa+3xsk8Vi3psTbg9S3afRI1Y71AENzrke
         Q+QPn+cLJUc9yIuzDhgOnwjqqcjvnD9yp+0AEUrmPeuydPvnPsaaPhsHKjCeM1/VBx
         8kocrtZGy7qhL024mvsI8rinbYYfO5dAXNaBBSKWz1+rf0h56UTEXb9220iMmgrnP/
         vnojOemLGhMdWF/f31xY23F/l9qd3wMVZrD4lQF/7EL3UenwQXAfKiFsakEfN+9P01
         tX5iGu++84e0g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3613160A88;
        Fri,  8 Oct 2021 16:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] net: enetc: add support for software TSO
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163371060921.30754.17364969668695586303.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Oct 2021 16:30:09 +0000
References: <20211007153043.2675008-1-ioana.ciornei@nxp.com>
In-Reply-To: <20211007153043.2675008-1-ioana.ciornei@nxp.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  7 Oct 2021 18:30:41 +0300 you wrote:
> This series adds support for driver level TSO in the enetc driver.
> 
> Ever since the ENETC MDIO erratum workaround is in place, the Tx path is
> incurring a penalty (enetc_lock_mdio/enetc_unlock_mdio) for each skb to
> be sent out. On top of this, ENETC does not support Tx checksum
> offloading. This means that software TSO would help performance just by
> the fact that one single mdio lock/unlock sequence would cover multiple
> packets sent. On the other hand, checksum needs to be computed in
> software since the controller cannot handle it.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: enetc: declare NETIF_F_HW_CSUM and do it in software
    https://git.kernel.org/netdev/net-next/c/acede3c5dad5
  - [net-next,v2,2/2] net: enetc: add support for software TSO
    https://git.kernel.org/netdev/net-next/c/fb8629e2cbfc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


