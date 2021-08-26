Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F64A3F8DC3
	for <lists+netdev@lfdr.de>; Thu, 26 Aug 2021 20:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243290AbhHZSUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 14:20:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:47904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232729AbhHZSUx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 14:20:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EEF3C61004;
        Thu, 26 Aug 2021 18:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630002006;
        bh=FgtgiMWlY5oPUg4qmUwE/QGtQnMEC91eALnafDcwsCo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IQMz39/qP5GDU74VlGPaBMibSv1PCCnrAc3OGpC3tHYRICWbIvm3T4iHD9fuGCO/E
         NHv2U8i82tE4y09Q1lVWpVa2g8GUZo3h55kAY4AcgVzC5GKT/4PsXwU8HJHNwEAWIo
         OJArmxHbDK6XnQXKEaKFQFcBqygC2BVA1t3Kk9/6DW53Vp4nvN3i2OfSDBI+xkTya0
         gvlN18+Rqlv7x+69igW8zqg6p4ojnokbpAKExPavkN7jtIYCuSJYoZmLeLuIH8gKOL
         BadXwU/pDKfk5U/19Fj1/Z6AseBl5TuSnRXIW5/xQEEUQt+udilqHH0MGEbrW8C0Qt
         LEnWtuyWQjB8A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DE98060972;
        Thu, 26 Aug 2021 18:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Revert "net: really fix the build..."
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163000200590.31811.1873637542988637686.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Aug 2021 18:20:05 +0000
References: <20210826172816.24478-1-kvalo@codeaurora.org>
In-Reply-To: <20210826172816.24478-1-kvalo@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, regressions@lists.linux.dev,
        wt@penguintechs.org, manivannan.sadhasivam@linaro.org,
        hemantk@codeaurora.org, loic.poulain@linaro.org,
        nschichan@freebox.fr
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 26 Aug 2021 20:28:16 +0300 you wrote:
> This reverts commit ce78ffa3ef1681065ba451cfd545da6126f5ca88.
> 
> Wren and Nicolas reported that ath11k was failing to initialise QCA6390
> Wi-Fi 6 device with error:
> 
> qcom_mhi_qrtr: probe of mhi0_IPCR failed with error -22
> 
> [...]

Here is the summary with links:
  - Revert "net: really fix the build..."
    https://git.kernel.org/netdev/net/c/9ebc2758d0bb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


