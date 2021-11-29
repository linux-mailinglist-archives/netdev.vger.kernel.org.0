Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4938C461A55
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243917AbhK2Oza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:55:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48656 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351690AbhK2Ox1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:53:27 -0500
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29F0261537
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 14:50:10 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id A223360E8E;
        Mon, 29 Nov 2021 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638197409;
        bh=AtMShSlb9t/IH0HDmrRqMefI56lTg2zqXDB8hB9qOSc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XxbJCVjL4LRqz0j266Imr5mfZruyhrwQN/wIvztJccX7J9dDTH4c2yOU4+KFfTF++
         WJGNYTrmkLk6L3VGzyGt0aRCTTuVgc+KqCMQcshYMAaVsG0S2FCsKQrKOPV4IQIDdp
         VX2eh8sEilRl4hT9UGrEfIuFscXIq+js+ONogsUhuzXP6+fHYWjfBbgOLamHNeSQDc
         jfn2ZT9FFAuTxkXD2QGuhR4UhzpZ9FuPt/QBCF/UTGX8FEncfYWt8+ekPkbMp4E/Be
         xrhWE3JS9gnEY74VBQVAClJR1FHJ45xlkdfnWXsRoZb7U5KlRT2kGt0PtXIf5VrEnd
         jE+AEDyg8dxPw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 97A65609D5;
        Mon, 29 Nov 2021 14:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] stmmac: remove ethtool driver version info
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163819740961.26434.15520154602257357539.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 14:50:09 +0000
References: <c1bab067-00ba-f6b5-f683-709f1d5b09a9@gmail.com>
In-Reply-To: <c1bab067-00ba-f6b5-f683-709f1d5b09a9@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        davem@davemloft.net, kuba@kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 28 Nov 2021 19:45:56 +0100 you wrote:
> I think there's no benefit in reporting a date from almost 6 yrs ago.
> Let ethtool report the default (kernel version) instead.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac.h         | 1 -
>  drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c | 1 -
>  2 files changed, 2 deletions(-)

Here is the summary with links:
  - [net-next] stmmac: remove ethtool driver version info
    https://git.kernel.org/netdev/net-next/c/09ae03e2fc9d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


