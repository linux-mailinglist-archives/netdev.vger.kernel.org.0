Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5335364E72
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 01:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhDSXKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 19:10:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230448AbhDSXKp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Apr 2021 19:10:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 55D59613AE;
        Mon, 19 Apr 2021 23:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618873815;
        bh=NR7K7aejLKaT3bRGd3Pg4jkj1qGKVr1xnmfHGQyk8lg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S3yna0QVOsFXza9NJyC4QT4Mo3nw+OSqztKNKtkBWkZqui6EtRxjPOkGvUgZ/rP5c
         m1jKLWilgimMjwIq5s9ZiRRWxHCOkXTNOCIBlNm7b2JY2Rda7ClRzR7+sPdSAGEEQV
         O6N17Pr57DjTsraDYK8YX3Gq9J3JTucTJLTHNFiN/997aC3De1wTx2ZItwFYwTq8XB
         FJpDFnZ9WWMXhfLgCE4TMTdwks2wSYnF2k3pv6eL8U3P264YrL4H2njhWZ+qplzS0X
         VFuBjyZjxGe6t9d7y5xC+QL9y/TgwCpqrqhA6YBc3IMbm4Qy7x/0qnhV52Q7NRTBmQ
         dhPIcbgtO44bA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4CA1460A0B;
        Mon, 19 Apr 2021 23:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] mtk_ppe_offload fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161887381530.661.5855588690103526113.git-patchwork-notify@kernel.org>
Date:   Mon, 19 Apr 2021 23:10:15 +0000
References: <20210418211145.21914-1-pablo@netfilter.org>
In-Reply-To: <20210418211145.21914-1-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        john@phrozen.org, nbd@nbd.name, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, dqfext@gmail.com, frank-w@public-files.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 18 Apr 2021 23:11:42 +0200 you wrote:
> Hi,
> 
> A few incremental fixes for the initial flowtable offload support
> and this driver:
> 
> 1) Fix undefined reference to `dsa_port_from_netdev' due to missing
>    dependencies in Kconfig, reported by Kbuild robot.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: ethernet: mtk_eth_soc: fix undefined reference to `dsa_port_from_netdev'
    https://git.kernel.org/netdev/net-next/c/0e389028ad75
  - [net-next,2/3] net: ethernet: mtk_eth_soc: missing mutex
    https://git.kernel.org/netdev/net-next/c/014d029876b2
  - [net-next,3/3] net: ethernet: mtk_eth_soc: handle VLAN pop action
    https://git.kernel.org/netdev/net-next/c/f5c2cb583abe

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


