Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352E73D4CFA
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 11:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhGYJJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 05:09:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230359AbhGYJJd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 05:09:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 713FA60F13;
        Sun, 25 Jul 2021 09:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627206604;
        bh=e3XwtdcHkkBCHXRFfxT0Pd9+KNaFrcm0wjAWYR+jCwk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k8AzUnWLvfMXdQX8ZRvioSVDRtiERJ+Q0MIwSJPMV1VszabVaqgIjBB25lIgxq6c+
         0GwqLKboqndRazC1xzFdDknGlP6FrS8wqlLixrgZ5jKUBJT9Gyfe2ZqU2FOEOGLcOy
         4qvckb30q8V4ZXmpZvPchleieMHEPyZjnXw9qKGtCVsMFtDKH5LCsoOV2ShZ/f5cPy
         JmVojbh5BmS77i2Ia4ccScmUcYakDahTQ56uoNnGol/nvqebi7ubgFrrN40X8gQQTs
         8pS0pR5WB4JUEFnvqxFvQZYdBzlBg+ZJyZ3Hxx2c4TQuiCDT2cZ+GelWimmDCBpATy
         EqAkwrhqZgCeA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 64E2960A3A;
        Sun, 25 Jul 2021 09:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: phy: broadcom: re-add check for
 PHY_BRCM_DIS_TXCRXC_NOENRGY on the BCM54811 PHY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162720660440.12734.7508159237495289443.git-patchwork-notify@kernel.org>
Date:   Sun, 25 Jul 2021 09:50:04 +0000
References: <YPrLPwLXwk2zweMw@ns.kevlo.org>
In-Reply-To: <YPrLPwLXwk2zweMw@ns.kevlo.org>
To:     Kevin Lo <kevlo@kevlo.org>
Cc:     f.fainelli@gmail.com, davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 23 Jul 2021 21:59:27 +0800 you wrote:
> Restore PHY_ID_BCM54811 accidently removed by commit 5d4358ede8eb.
> 
> Fixes: 5d4358ede8eb ("net: phy: broadcom: Allow BCM54210E to configure APD")
> Signed-off-by: Kevin Lo <kevlo@kevlo.org>
> ---

Here is the summary with links:
  - net: phy: broadcom: re-add check for PHY_BRCM_DIS_TXCRXC_NOENRGY on the BCM54811 PHY
    https://git.kernel.org/netdev/net/c/ad4e1e48a629

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


