Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3714B356038
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347459AbhDGAU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:20:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236241AbhDGAUV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:20:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 068C1613CB;
        Wed,  7 Apr 2021 00:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617754813;
        bh=KTqpuXgzrieXAX+sUDBWy1nDUfNde7siIgorhzsRH90=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OJykp99e1Jw3zhOCm6CJ8OJm1c8lPQLL5biQPIIcNeECtHwlTlnJoessSSyaZKMKU
         wc4O1YyaCKSIUPtM8B6fpYSCaJD1A9zlBGEEtfnK+HVwv0R42c419Rd3a7EFypxTJe
         o1ifbteQtDHoz9jygwnFX1q+iOQozmg6aFSgQE1rHvhvAdYEfUSGFh7HoZVqdfkVEH
         NkUjuRsfEKaySmLgeawFzizJK3CsoIQH20O2C6GcsUnrmbcJvmZtq2ypvsjEvTmCsy
         MOgXGNFAOPHZdEKnJ5mj9vwHkm0kOwpJKTOxR8u2jD6Fx8Hz/+atvLCrxe+gc0f3d9
         F7oZY6IEdzOaA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F015260A6B;
        Wed,  7 Apr 2021 00:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 1/1] stmmac: intel: Drop duplicate ID in the list
 of PCI device IDs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161775481297.4854.15334694335904751602.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Apr 2021 00:20:12 +0000
References: <20210406101306.59162-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20210406101306.59162-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, kuba@kernel.org, mcoquelin.stm32@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  6 Apr 2021 13:13:06 +0300 you wrote:
> The PCI device IDs are defined with a prefix PCI_DEVICE_ID.
> There is no need to repeat the ID part at the end of each definition.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  .../net/ethernet/stmicro/stmmac/dwmac-intel.c | 60 +++++++++----------
>  1 file changed, 30 insertions(+), 30 deletions(-)

Here is the summary with links:
  - [net-next,v1,1/1] stmmac: intel: Drop duplicate ID in the list of PCI device IDs
    https://git.kernel.org/netdev/net-next/c/3036ec035c4d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


