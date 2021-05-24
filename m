Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE17938DE64
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 02:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232212AbhEXAbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 20:31:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:34444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232120AbhEXAbi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 May 2021 20:31:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 670E261352;
        Mon, 24 May 2021 00:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621816211;
        bh=WXtat16smgUAaIGMDW4P5PS91GPskB7apSEtMEnUoQQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C92a1x1zhJRqv1RiznUtV+KsaxfeDi7kXqh3fffmUnmfhncXwmfdNPejY2zLhKDhO
         pxVWjC4MdApvSMPZrX4AweRXAOIGz5bepoLBILq7wmRbZmL8butv+TRA26wbm401k4
         C1p2a0e+HD4Bhb27pUNo7b5YccdJm1EB8IgGTSfjo6aKQZitb5NBbhz6pMWciIbxHn
         hXL7TTtt0HSzFjYRrI8Xx3tv8H7zNEibo4TqBHL5W6mlYQfN4MkSnBLE1ecOZkTHay
         A8XIu6vBjYbBu6tQL2HOckWqnB+fvrH+dt8AofZXay7M58Axms+xn4t0yFmtD2YdoE
         7Pc2hqgTq7GmA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5DCDE609ED;
        Mon, 24 May 2021 00:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: ftgmac100: add missing error return code in
 ftgmac100_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162181621137.30453.7620078087763802418.git-patchwork-notify@kernel.org>
Date:   Mon, 24 May 2021 00:30:11 +0000
References: <20210522120246.1125535-1-yangyingliang@huawei.com>
In-Reply-To: <20210522120246.1125535-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, andrew@aj.id.au,
        gwshan@linux.vnet.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 22 May 2021 20:02:46 +0800 you wrote:
> The variables will be free on path err_phy_connect, it should
> return error code, or it will cause double free when calling
> ftgmac100_remove().
> 
> Fixes: bd466c3fb5a4 ("net/faraday: Support NCSI mode")
> Fixes: 39bfab8844a0 ("net: ftgmac100: Add support for DT phy-handle property")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [-next] net: ftgmac100: add missing error return code in ftgmac100_probe()
    https://git.kernel.org/netdev/net-next/c/52af13a41489

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


