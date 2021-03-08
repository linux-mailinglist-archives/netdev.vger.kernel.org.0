Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB2B331835
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 21:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbhCHUKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 15:10:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:56624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231886AbhCHUKI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 15:10:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 82D8A65274;
        Mon,  8 Mar 2021 20:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615234208;
        bh=ud/VTHbkJwakVHys4brgCYId5JluKZf0nUGWjLaCGq8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LuEkYIh2X8o+Z1WTMZKzOKmNXl+8Eg0qYk3Oxz3l/Do4W6Mt1FI7Yp+OLkxUIrHj9
         LJfxC4um0wOAc0yyrWt8R2+nVEgQBIbDAw2KQyJ+SW2fPJhiQbDXzGaeoHvqHBbpe0
         xzblR1onpxxwxTBRPgj+b06OEV+l+A+2GNe7OE8nHehPtN1ok3pN3gVKOoWSxpQTBH
         BHiS/JEJH3a8KGPkDeAsN7Vn6CyLkE3klFMxuhrGSAkKuCFGHTXXz4aukGAh9xhAwL
         6nPYLt9M/hPMjFJ6mtJwchR49nkRsFFjSwEi2Cr4Zgg9R6FI58Jk9hoGD8FNdRcOir
         Nga4c9Qaxb3SA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 73D07609DB;
        Mon,  8 Mar 2021 20:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] net: enetc: set MAC RX FIFO to recommended value
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161523420847.27243.3461503048418275217.git-patchwork-notify@kernel.org>
Date:   Mon, 08 Mar 2021 20:10:08 +0000
References: <20210307132339.2320009-1-olteanv@gmail.com>
In-Reply-To: <20210307132339.2320009-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        po.liu@nxp.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, michael@walle.cc, jason.hui.liu@nxp.com,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Sun,  7 Mar 2021 15:23:38 +0200 you wrote:
> From: Alex Marginean <alexandru.marginean@nxp.com>
> 
> On LS1028A, the MAC RX FIFO defaults to the value 2, which is too high
> and may lead to RX lock-up under traffic at a rate higher than 6 Gbps.
> Set it to 1 instead, as recommended by the hardware design team and by
> later versions of the ENETC block guide.
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: enetc: set MAC RX FIFO to recommended value
    https://git.kernel.org/netdev/net/c/1b2395dfff5b
  - [net,2/2] net: enetc: allow hardware timestamping on TX queues with tc-etf enabled
    https://git.kernel.org/netdev/net/c/29d98f54a4fe

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


