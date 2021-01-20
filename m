Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475F32FC736
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 02:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730841AbhATBwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 20:52:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:53126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731102AbhATBuv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 20:50:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 63C3422472;
        Wed, 20 Jan 2021 01:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611107410;
        bh=fYVhz0Utn/IH6+2xkAXvc2UhddhAnB+A/q8GU/7LXZ8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o36XoS0e9yW42WCIpWPxbEeA55yu+dzjXtl7opTY0GK2l5hLBNcOjCR0iv8UqZygY
         w6TYwDPsP+cxPhFuwCK0MyXOojwuespJs0wShCsjlh38PjmsCqeP3Jr8u+urS7Yl3N
         ZqmDgaxpnw/hn2ZJoygYEIanHk0jn0KXwgfJSKTiR2/6/1kBZH5YVWWwtvqHsjMcBP
         Pq2fmFtqgmsr+DGQZ8Lxy8gIXJm8Tk2NcH0rLZwE5Vs+8mL1mkcq952dQhJJ+NM+eD
         tRwwww+xNERk/l7zkhJTfnniz++AmzAhTt+3jmacoujRgHubP5FOo9wOZ1jgLKlpGJ
         4XWyU1JyYENAA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 5C6AB604FC;
        Wed, 20 Jan 2021 01:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 0/6] net: ethernet: ti: am65-cpsw-nuss: introduce support
 for am64x cpsw3g
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161110741037.23772.5269078969682153495.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jan 2021 01:50:10 +0000
References: <20210115192853.5469-1-grygorii.strashko@ti.com>
In-Reply-To: <20210115192853.5469-1-grygorii.strashko@ti.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        peter.ujfalusi@gmail.com, vigneshr@ti.com, robh+dt@kernel.org,
        linux-kernel@vger.kernel.org, nsekhar@ti.com,
        devicetree@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 15 Jan 2021 21:28:47 +0200 you wrote:
> Hi
> 
> This series introduces basic support for recently introduced TI K3 AM642x SoC [1]
> which contains 3 port (2 external ports) CPSW3g module. The CPSW3g integrated
> in MAIN domain and can be configured in multi port or switch modes.
> In this series only multi port mode is enabled. The initial version of switchdev
> support was introduced by Vignesh Raghavendra [2] and work is in progress.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] dt-binding: ti: am65x-cpts: add assigned-clock and power-domains props
    https://git.kernel.org/netdev/net-next/c/b3228c74e0d2
  - [net-next,2/6] dt-binding: net: ti: k3-am654-cpsw-nuss: update bindings for am64x cpsw3g
    https://git.kernel.org/netdev/net-next/c/19d9a846d9fc
  - [net-next,3/6] net: ethernet: ti: am65-cpsw-nuss: Use DMA device for DMA API
    https://git.kernel.org/netdev/net-next/c/ed569ed9b30a
  - [net-next,4/6] net: ethernet: ti: am65-cpsw-nuss: Support for transparent ASEL handling
    https://git.kernel.org/netdev/net-next/c/39fd0547ee66
  - [net-next,5/6] net: ti: cpsw_ale: add driver data for AM64 CPSW3g
    https://git.kernel.org/netdev/net-next/c/1dd3841033b3
  - [net-next,6/6] net: ethernet: ti: am65-cpsw: add support for am64x cpsw3g
    https://git.kernel.org/netdev/net-next/c/4f7cce272403

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


