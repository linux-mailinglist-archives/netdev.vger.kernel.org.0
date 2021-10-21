Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50083436D9F
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 00:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbhJUWmY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 18:42:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229567AbhJUWmY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 18:42:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6F68D603E8;
        Thu, 21 Oct 2021 22:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634856007;
        bh=yFf1BE/DBYZe5STBguh4hYk8JjOzIPCKIZBmUB/U0fI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mg+7hOgRe1YT1d+edk8a4/E4+kmqeukXQ/1b0rI3OqI/sn8usEXd3LBYLR1nVwNTU
         nvOH3WP9SxOjpAuhJ6M3UYLGZxO3c3JXNsEBI8qQ2Mw5cgqNUOCW9CCjPaCqX7hO2h
         cbol+2/ARAOP8aIoOWfDVLUyUhN9CrEMyg2i50ajNmwjK2QmWD9TEaWcpCiohaR/FO
         5C+YLwBsudA671XgmfbJbltcWF1clr4I4ZTObZDiErGf7qRkcawdfWhsofBMPxftB8
         JF6OxlOtlvx4vvAz/Gply8JLJBMulmEpktEJV7sQfji+APZzDcOyG4gRfuZicw4h35
         HS5gJ+Ib2ma6g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 56EF860A24;
        Thu, 21 Oct 2021 22:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] enetc: trivial PTP one-step TX timestamping
 cleanups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163485600735.31145.3968599007027017979.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Oct 2021 22:40:07 +0000
References: <20211020174220.1093032-1-vladimir.oltean@nxp.com>
In-Reply-To: <20211020174220.1093032-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        claudiu.manoil@nxp.com, yangbo.lu@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 20 Oct 2021 20:42:18 +0300 you wrote:
> These are two cleanup patches for some inconsistencies I noticed in the
> driver's TX ring cleanup function.
> 
> Vladimir Oltean (2):
>   net: enetc: remove local "priv" variable in enetc_clean_tx_ring()
>   net: enetc: use the skb variable directly in enetc_clean_tx_ring()
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: enetc: remove local "priv" variable in enetc_clean_tx_ring()
    https://git.kernel.org/netdev/net-next/c/ae77bdbc2fc6
  - [net-next,2/2] net: enetc: use the skb variable directly in enetc_clean_tx_ring()
    https://git.kernel.org/netdev/net-next/c/520661495409

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


