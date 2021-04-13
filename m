Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2926E35E870
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 23:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345350AbhDMVke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 17:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232678AbhDMVkd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 17:40:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 95FCB61244;
        Tue, 13 Apr 2021 21:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618350012;
        bh=Pc42y9BwpCcvBnEOgNEkzVDFAHE768WYwvYWqxdzGrY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JpKPcXvDY3jbjWj2NUFrxhqLnY4MycEY1lwF1U77EVzHfs11AOJZ3vxLYy7e64C79
         icoTd8xMRa/JMoMeNAdPJbFL15Ic+obOTqTbZR73MlKS7rcM5AjmiPGUchq4dzktE3
         gIL+eyYasiMs+hvD4EML/cii3VlQjj02UYCxlSUrdrh4uXtAavbLvMAy4TlRuGrBvF
         DkMFAHYTwMpcujWy/WPPgAsc47+r6tmr1oF3VInnDCFSI58U77eyWfrJmO2S6/f2Eb
         PDNOzXJaRKzFdSTmv1YWrXny2oNlXQPJ3hoUxLyA1sKNTFyW80ZUMgxjpqg1ocDuAJ
         vc4ugCS+TbXOQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8CAED60CCF;
        Tue, 13 Apr 2021 21:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: dsa: mt7530: Add support for EEE features
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161835001256.18297.14223110480767225137.git-patchwork-notify@kernel.org>
Date:   Tue, 13 Apr 2021 21:40:12 +0000
References: <20210412065031.29492-1-opensource@vdorst.com>
In-Reply-To: <20210412065031.29492-1-opensource@vdorst.com>
To:     =?utf-8?q?Ren=C3=A9_van_Dorst_=3Copensource=40vdorst=2Ecom=3E?=@ci.codeaurora.org
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, kuba@kernel.org, Landen.Chao@mediatek.com,
        matthias.bgg@gmail.com, linux@armlinux.org.uk,
        sean.wang@mediatek.com, vivien.didelot@gmail.com,
        olteanv@gmail.com, linux-mediatek@lists.infradead.org,
        netdev@vger.kernel.org, sergio.paracuellos@gmail.com,
        frank-w@public-files.de, dqfext@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 12 Apr 2021 08:50:31 +0200 you wrote:
> This patch adds EEE support.
> 
> Signed-off-by: René van Dorst <opensource@vdorst.com>
> ---
> v1 -> v2:
> - Refactor the mt753x_{get,set}_mac_eee().
>   As DENQ Qingfang mentioned, most things are set else were.
>   These functions only set/report the LPI timeout value/LPI timeout enable bit.
> - Removed the variable "eee_enabled", don't need too track the EEE status.
> - Refactor mt753x_phylink_mac_link_up().
>   phy_init_eee() reports is the EEE is active, this function also checks
>   the PHY, duplex and broken DTS modes.
>   When active set the MAC EEE bit based on the speed.
> - Add {GET,SET)_LPI_THRESH(x) macro
> - PMCR_FORCE_EEE1G | PMCR_FORCE_EEE100 are now placed in the right MASK variable
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: dsa: mt7530: Add support for EEE features
    https://git.kernel.org/netdev/net-next/c/40b5d2f15c09

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


