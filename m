Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D743645065E
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232093AbhKOONl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:13:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:33430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232132AbhKOONG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Nov 2021 09:13:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id BC66361C4F;
        Mon, 15 Nov 2021 14:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636985408;
        bh=xwJZkdktg0NLCh5xmpdvC5ijjldRWG2/4GMbefs3CkA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AW08DENHCHgUs0fVDIvYiibD9nRbeDbD4x0UBCzd+PLdDULFzWp/ejR6Tg5S2sQOD
         YJlVZ69TVzwJ7WQymZ6Sj7NOYYSgVVmN/useNXMrsYsP1DTzo+5yWKuaaJuwwVU0tk
         u19p919GB+jRirRdEwvAU3mpgjr9hSn7Uoi09Hyc1rl1TSH+FmzfVtKFvTL+mfMkaT
         tVRiy01sXx2X3nxcmpzdfpO7sbNN00Yogy0UFyXyd3vl51qDXdPIxDy4lqwcAsRzrh
         jmu4wo+WftQe4q4OIPz4Ub7zoagQXj0olPrjhN/D2T3QqYzp3mFOjRZzAa/eevEDAE
         1vYrLTLovV3Lw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9D54D6095A;
        Mon, 15 Nov 2021 14:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -net] net: ethernet: lantiq_etop: fix build errors/warnings
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163698540863.13805.40510360412441123.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Nov 2021 14:10:08 +0000
References: <20211115010229.15933-1-rdunlap@infradead.org>
In-Reply-To: <20211115010229.15933-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, lkp@intel.com, olek2@wp.pl,
        hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        john@phrozen.org, linux-mips@vger.kernel.org, ralf@linux-mips.org,
        michael.opdenacker@bootlin.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 14 Nov 2021 17:02:29 -0800 you wrote:
> Fix build error and warnings reported by kernel test robot:
> 
> drivers/net/ethernet/lantiq_etop.c: In function 'ltq_etop_probe':
> drivers/net/ethernet/lantiq_etop.c:673:15: error: implicit declaration of function 'device_property_read_u32' [-Werror=implicit-function-declaration]
>      673 |         err = device_property_read_u32(&pdev->dev, "lantiq,tx-burst-length", &priv->tx_burst_len);
> 
>    drivers/net/ethernet/lantiq_etop.c: At top level:
>    drivers/net/ethernet/lantiq_etop.c:730:1: warning: no previous prototype for 'init_ltq_etop' [-Wmissing-prototypes]
>      730 | init_ltq_etop(void)
> 
> [...]

Here is the summary with links:
  - [-net] net: ethernet: lantiq_etop: fix build errors/warnings
    https://git.kernel.org/netdev/net/c/e97b21e94652

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


