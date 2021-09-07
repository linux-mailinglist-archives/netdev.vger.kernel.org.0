Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DD940296B
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 15:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344667AbhIGNLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 09:11:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243976AbhIGNLM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 09:11:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7910461057;
        Tue,  7 Sep 2021 13:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631020206;
        bh=xCwlLeM3S/KdjmRtHP6BV82/ufommIMDbF/40He+gkQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Af2G74Y8792N5XcftcR0HXJiBtYtdXTfpdUPi49tFYkXsteg7Fr06NQ/fbsD2OUj/
         RTYKgBMEaiC/oDaKTubKi3OwAsPpHcMx2Eq85dYOgLWQ54D/9ZJ+KAhuU9pdrpzrrJ
         XlOMVb4HjlfvQI2uRZhsPZm5b3qt94ti1NynFx30WWRc0uFPV4jZaa60OaoAOCZxiG
         L7AoroQeBOvba74zoLwhSZlkPfLQEqBwsAax28MhIbnrP8QqtahPC0qcrZMptK7BBm
         ppcNmC6rtpzCQItYSeocvB8oMVE8GUPgmUUezLs7/KvMGr1ZKnMdrLmETdxDCS5BXr
         EVSNy17ZohjHg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6E7D1609AB;
        Tue,  7 Sep 2021 13:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net: stmmac: fix WoL issue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163102020644.3494.2552562162347505160.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Sep 2021 13:10:06 +0000
References: <20210907105647.16068-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20210907105647.16068-1-qiangqing.zhang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk, andrew@lunn.ch,
        hkallweit1@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue,  7 Sep 2021 18:56:45 +0800 you wrote:
> This patch set fixes stmmac not working after system resume back with WoL
> active. Thanks a lot for Russell King keeps looking into this issue.
> 
> Joakim Zhang (1):
>   net: stmmac: fix MAC not working when system resume back with WoL
>     active
> 
> [...]

Here is the summary with links:
  - [net,1/2] net: phylink: add suspend/resume support
    https://git.kernel.org/netdev/net/c/f97493657c63
  - [net,2/2] net: stmmac: fix MAC not working when system resume back with WoL active
    https://git.kernel.org/netdev/net/c/90702dcd19c0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


