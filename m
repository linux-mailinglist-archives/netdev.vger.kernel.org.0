Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61513362C62
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 02:20:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235186AbhDQAUl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 20:20:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:38920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231997AbhDQAUj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 20:20:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D1A4A611AB;
        Sat, 17 Apr 2021 00:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618618813;
        bh=L49bIj6qteDwp4mP+ng7zLhqgfk44/tW5FJhGGHpkvI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tDc8GkcZi+A8ZR1apURuin/ibS+ZSSK73dyhVt8YI38Bgvlu2exwuEfACzukwVObh
         FMQmmmvX2u+fSWbRsmDpCMoPssVkGr8RtAKoeOJ30P/0sozwiEs80wEySs3e5YFWur
         u6tX3AaLthxxGAGenEt3vK3lDM2rLmVYW/XPwZ+6aGjSi9Oi49W2sAAON/w1mR60c/
         5ktdiZWwXJArsSmuRGNf8IomoPB5k+shMxED/1jf5K4GQkF2dzhm0edxCSAeNo6zCR
         VG20AUdsV7iC4Zvj6J+RzIHkNzLIbYCg+aZfDGNfzc/8J1Pgo8LElfqCpW20pnJxwk
         GD3K0osUwzrPg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C4FD360CD4;
        Sat, 17 Apr 2021 00:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] Fixups for XDP on NXP ENETC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161861881380.3813.7857023133457832186.git-patchwork-notify@kernel.org>
Date:   Sat, 17 Apr 2021 00:20:13 +0000
References: <20210416212225.3576792-1-olteanv@gmail.com>
In-Reply-To: <20210416212225.3576792-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        po.liu@nxp.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, yangbo.lu@nxp.com, toke@redhat.com,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 17 Apr 2021 00:22:15 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> After some more XDP testing on the NXP LS1028A, this is a set of 10 bug
> fixes, simplifications and tweaks, ranging from addressing Toke's feedback
> (the network stack can run concurrently with XDP on the same TX rings)
> to fixing some OOM conditions seen under TX congestion.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] net: enetc: remove redundant clearing of skb/xdp_frame pointer in TX conf path
    https://git.kernel.org/netdev/net-next/c/e9e49ae88ec8
  - [net-next,02/10] net: enetc: rename the buffer reuse helpers
    https://git.kernel.org/netdev/net-next/c/6b04830d5e0d
  - [net-next,03/10] net: enetc: recycle buffers for frames with RX errors
    https://git.kernel.org/netdev/net-next/c/672f9a21989e
  - [net-next,04/10] net: enetc: stop XDP NAPI processing when build_skb() fails
    https://git.kernel.org/netdev/net-next/c/8f50d8bb3f1c
  - [net-next,05/10] net: enetc: remove unneeded xdp_do_flush_map()
    https://git.kernel.org/netdev/net-next/c/a6369fe6e07d
  - [net-next,06/10] net: enetc: increase TX ring size
    https://git.kernel.org/netdev/net-next/c/ee3e875f10fc
  - [net-next,07/10] net: enetc: use dedicated TX rings for XDP
    https://git.kernel.org/netdev/net-next/c/7eab503b11ee
  - [net-next,08/10] net: enetc: handle the invalid XDP action the same way as XDP_DROP
    https://git.kernel.org/netdev/net-next/c/975acc833c9f
  - [net-next,09/10] net: enetc: fix buffer leaks with XDP_TX enqueue rejections
    https://git.kernel.org/netdev/net-next/c/92ff9a6e578d
  - [net-next,10/10] net: enetc: apply the MDIO workaround for XDP_REDIRECT too
    https://git.kernel.org/netdev/net-next/c/24e393097171

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


