Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5D732C485
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392530AbhCDAOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:14:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:46106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1445769AbhCCQus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 11:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D204964ED7;
        Wed,  3 Mar 2021 16:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614790206;
        bh=8k3m8Z3dLBk+naOkfcZx9VgqX4UmrgK5Fe+gHEK03W8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nqD/XPnpuJAGYRoBtdjEUjuLFA/ioRw0o4QpElLb7jxIOzmbVSSjJMtFi3W54gcrG
         x3F4rOA0189qdGGbeyBPRgNKhlG50SwA/7S1XDYlHFxf9SOSjIxYvMiNBCht8SVrOF
         ib6lERUnrm4ELpFnLteE/2TCnK0Au7HdpFyPWOwpoHmJ8ir6st/ZOIE5l2mY+QG3Fl
         klgyaoVOFKreKQrOKoGdZmQzWTulot3d3OkII1QNBGzv19skUTVuhEmczYroOENush
         mfCJofaBIAfS4zedCQuwKg06gO+kHJWyBbU/Ujc8WTr+Ba2H3MDWQZ9D7EgEfXZ2tq
         xAI4eflmJRccw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C6E6E609EA;
        Wed,  3 Mar 2021 16:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] octeontx2-af: cn10k: fix an array overflow in
 is_lmac_valid()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161479020681.31057.13525523145605254312.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Mar 2021 16:50:06 +0000
References: <YD4f0vIQ1bW++7M7@mwanda>
In-Reply-To: <YD4f0vIQ1bW++7M7@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     sgoutham@marvell.com, hkelam@marvell.com, lcherian@marvell.com,
        gakula@marvell.com, jerinj@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 2 Mar 2021 14:21:54 +0300 you wrote:
> The value of "lmac_id" can be controlled by the user and if it is larger
> then the number of bits in long then it reads outside the bitmap.
> The highest valid value is less than MAX_LMAC_PER_CGX (4).
> 
> Fixes: 91c6945ea1f9 ("octeontx2-af: cn10k: Add RPM MAC support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> [...]

Here is the summary with links:
  - [net] octeontx2-af: cn10k: fix an array overflow in is_lmac_valid()
    https://git.kernel.org/netdev/net/c/2378b2c9ecf4

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


