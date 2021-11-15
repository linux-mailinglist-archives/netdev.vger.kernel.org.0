Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F964506F8
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:31:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbhKOOdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:33:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232735AbhKOOdF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 09:33:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 3F29963222;
        Mon, 15 Nov 2021 14:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636986610;
        bh=5P25mLT6Jr6VmyP/I0R+Oxwdz1c2BzKwtGMFLED8VYY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QwmLij4v79zfinmYoB7fJfDZQneCm1VgJioEa9NR0AqwiyWfBUyC3SFpyHRZujvKT
         Dkny2IsqH2W1IP19Mgutwx+QlEWLu8slCc735sUkBOChB/c/Ac71jZf9xRje0dA+/T
         xlXxICRUIoNvREMDNpK9QaHMRD0PQTW8nGJ65RpS2YX1XP5WI5VxyfgEKQ7+O3H5va
         l/vvLCvRISXn+f//f6ZoFw8Hm6tAIY+z4hvhWa2O4tHYx0JG9NIvZDp+LvfpQQW92c
         RXMMzWIu+SM6z0ZErh6MZ4aLv3hOCCIkv9rYkWs/af4QqL7RfYwDVbGiXbQlfEph1b
         Ixk4yetYvM0nQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 37F0460A49;
        Mon, 15 Nov 2021 14:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/wan/fsl_ucc_hdlc: fix sparse warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163698661022.25242.10725414110897368088.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Nov 2021 14:30:10 +0000
References: <28f87309a3bb26e91d93e808a3b0e43baf79cc3b.1636974508.git.christophe.leroy@csgroup.eu>
In-Reply-To: <28f87309a3bb26e91d93e808a3b0e43baf79cc3b.1636974508.git.christophe.leroy@csgroup.eu>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     qiang.zhao@nxp.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux@rasmusvillemoes.dk, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 15 Nov 2021 12:08:59 +0100 you wrote:
> CHECK   drivers/net/wan/fsl_ucc_hdlc.c
> drivers/net/wan/fsl_ucc_hdlc.c:309:57: warning: incorrect type in argument 2 (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:309:57:    expected void [noderef] __iomem *
> drivers/net/wan/fsl_ucc_hdlc.c:309:57:    got restricted __be16 *
> drivers/net/wan/fsl_ucc_hdlc.c:311:46: warning: incorrect type in argument 2 (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:311:46:    expected void [noderef] __iomem *
> drivers/net/wan/fsl_ucc_hdlc.c:311:46:    got restricted __be32 *
> drivers/net/wan/fsl_ucc_hdlc.c:320:57: warning: incorrect type in argument 2 (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:320:57:    expected void [noderef] __iomem *
> drivers/net/wan/fsl_ucc_hdlc.c:320:57:    got restricted __be16 *
> drivers/net/wan/fsl_ucc_hdlc.c:322:46: warning: incorrect type in argument 2 (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:322:46:    expected void [noderef] __iomem *
> drivers/net/wan/fsl_ucc_hdlc.c:322:46:    got restricted __be32 *
> drivers/net/wan/fsl_ucc_hdlc.c:372:29: warning: incorrect type in assignment (different base types)
> drivers/net/wan/fsl_ucc_hdlc.c:372:29:    expected unsigned short [usertype]
> drivers/net/wan/fsl_ucc_hdlc.c:372:29:    got restricted __be16 [usertype]
> drivers/net/wan/fsl_ucc_hdlc.c:379:36: warning: restricted __be16 degrades to integer
> drivers/net/wan/fsl_ucc_hdlc.c:402:12: warning: incorrect type in assignment (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:402:12:    expected struct qe_bd [noderef] __iomem *bd
> drivers/net/wan/fsl_ucc_hdlc.c:402:12:    got struct qe_bd *curtx_bd
> drivers/net/wan/fsl_ucc_hdlc.c:425:20: warning: incorrect type in assignment (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:425:20:    expected struct qe_bd [noderef] __iomem *[assigned] bd
> drivers/net/wan/fsl_ucc_hdlc.c:425:20:    got struct qe_bd *tx_bd_base
> drivers/net/wan/fsl_ucc_hdlc.c:427:16: error: incompatible types in comparison expression (different address spaces):
> drivers/net/wan/fsl_ucc_hdlc.c:427:16:    struct qe_bd [noderef] __iomem *
> drivers/net/wan/fsl_ucc_hdlc.c:427:16:    struct qe_bd *
> drivers/net/wan/fsl_ucc_hdlc.c:462:33: warning: incorrect type in argument 1 (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:506:41: warning: incorrect type in argument 1 (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:528:33: warning: incorrect type in argument 1 (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:552:38: warning: incorrect type in argument 1 (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:596:67: warning: incorrect type in argument 2 (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:611:41: warning: incorrect type in argument 1 (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:851:38: warning: incorrect type in initializer (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:854:40: warning: incorrect type in argument 1 (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:855:40: warning: incorrect type in argument 1 (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:858:39: warning: incorrect type in argument 1 (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:861:37: warning: incorrect type in argument 2 (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:866:38: warning: incorrect type in initializer (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:868:21: warning: incorrect type in argument 1 (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:870:40: warning: incorrect type in argument 2 (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:871:40: warning: incorrect type in argument 2 (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:873:39: warning: incorrect type in argument 2 (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:993:57: warning: incorrect type in argument 2 (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:995:46: warning: incorrect type in argument 2 (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:1004:57: warning: incorrect type in argument 2 (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:1006:46: warning: incorrect type in argument 2 (different address spaces)
> drivers/net/wan/fsl_ucc_hdlc.c:412:35: warning: dereference of noderef expression
> drivers/net/wan/fsl_ucc_hdlc.c:412:35: warning: dereference of noderef expression
> drivers/net/wan/fsl_ucc_hdlc.c:724:29: warning: dereference of noderef expression
> drivers/net/wan/fsl_ucc_hdlc.c:815:21: warning: dereference of noderef expression
> drivers/net/wan/fsl_ucc_hdlc.c:1021:29: warning: dereference of noderef expression
> 
> [...]

Here is the summary with links:
  - net/wan/fsl_ucc_hdlc: fix sparse warnings
    https://git.kernel.org/netdev/net-next/c/5cf46d8e741f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


