Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A51362C24
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 02:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235176AbhDQAAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 20:00:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235010AbhDQAAg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 20:00:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8E9C3611AF;
        Sat, 17 Apr 2021 00:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618617611;
        bh=UWmFFH882qEW+CCAJckvBlwDzQC97jt9sn5omLp/nJU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KVM+yGwGRBmURy5VWDyQXu+V9popEVx1XvqtDvPT7YrOlE9bTsqYkn8w5iRMxXWTp
         /slAbjCx1j2mQV6UJTq64xC/pLg0+ZXPT6ZbEdSr9mfWV5rImZepH3NVtUYraZEtI8
         IEWSnh5FHx7dW1Ebv1nhubxzrq5f+aq9c3BLI0akTW6Ecfu+I2RiT3Xsm++Kra3xlU
         wFY0/vk9MvsNKh9XaCD8pHKKVOZo0j6rHKlJwZzLpZYYKOHtfWlCKieWd2v+XQ6XC9
         uF7FffvkBf2LtULVZvIpDHuGcUbpfd6E+2b8NTFDTdAe9jjSbsx0Y7TJUkg5Z8yAYU
         tT1WbQQ6Gwr6A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7E6FC60CD6;
        Sat, 17 Apr 2021 00:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: gianfar: Drop GFAR_MQ_POLLING support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161861761151.26880.8323384757169074141.git-patchwork-notify@kernel.org>
Date:   Sat, 17 Apr 2021 00:00:11 +0000
References: <20210416171123.22969-1-claudiu.manoil@nxp.com>
In-Reply-To: <20210416171123.22969-1-claudiu.manoil@nxp.com>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        vladimir.oltean@nxp.com, devicetree@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, robh+dt@kernel.org,
        benh@kernel.crashing.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 16 Apr 2021 20:11:21 +0300 you wrote:
> Drop long time obsolete "per NAPI multi-queue" support in gianfar,
> and related (and undocumented) device tree properties.
> 
> Claudiu Manoil (2):
>   gianfar: Drop GFAR_MQ_POLLING support
>   powerpc: dts: fsl: Drop obsolete fsl,rx-bit-map and fsl,tx-bit-map
>     properties
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] gianfar: Drop GFAR_MQ_POLLING support
    https://git.kernel.org/netdev/net-next/c/8eda54c5e6c4
  - [net-next,2/2] powerpc: dts: fsl: Drop obsolete fsl,rx-bit-map and fsl,tx-bit-map properties
    https://git.kernel.org/netdev/net-next/c/221e8c126b78

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


