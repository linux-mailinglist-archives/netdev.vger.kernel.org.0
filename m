Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1C5342612
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 20:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhCSTUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 15:20:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230221AbhCSTUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Mar 2021 15:20:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 89E2D6197A;
        Fri, 19 Mar 2021 19:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616181608;
        bh=yEMZQtZbCOePOV5+OM4LMyiQVt8RhDn1apelcQpoDco=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bLc+BCu9bl/ot16XpTZeeNR7kfUp3zx8JaBRz+Dyhu5KDDVTwkFeqO+D/ymbo6c4A
         IDDv3DgRt/Z1Y+tNexu4J9nmkY/MDNYLEVFGIFAO3FZEZISh/TUZIpGTTT3JV3rEkH
         uqUnvyNCpL3BU5sARQyALprCK0adWzygZBah0KcFwODee546L8P4g2j7PMHBdzrHf2
         Z1tP8CF7IiB/LneAwvcHfGZeVTuSnpfzmTLZFlWe1yPQsTxVWLcrB+1Ztbye+BoGLN
         g6ka9whisV7o9vmvN5QiEDUPtUech0jo2P2P+BvD/a03a6749pvM2pMWf944Wwr8of
         8mRmljWRfIFGA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7870D609DB;
        Fri, 19 Mar 2021 19:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] octeontx2-pf: Fix missing spin_lock_init() in
 otx2_tc_add_flow()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161618160848.4810.12360157378814720132.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 19:20:08 +0000
References: <20210319094103.4185148-1-weiyongjun1@huawei.com>
In-Reply-To: <20210319094103.4185148-1-weiyongjun1@huawei.com>
To:     'w00385741 <weiyongjun1@huawei.com>
Cc:     sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, kuba@kernel.org, naveenm@marvell.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        hulkci@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 19 Mar 2021 09:41:03 +0000 you wrote:
> From: Wei Yongjun <weiyongjun1@huawei.com>
> 
> The driver allocates the spinlock but not initialize it.
> Use spin_lock_init() on it to initialize it correctly.
> 
> Fixes: d8ce30e0cf76 ("octeontx2-pf: add tc flower stats handler for hw offloads")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] octeontx2-pf: Fix missing spin_lock_init() in otx2_tc_add_flow()
    https://git.kernel.org/netdev/net-next/c/140960564d63

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


