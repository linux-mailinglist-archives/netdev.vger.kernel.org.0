Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5605A3A0808
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 01:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbhFHXwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 19:52:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231492AbhFHXv6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 19:51:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7921F61364;
        Tue,  8 Jun 2021 23:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623196204;
        bh=3qZVdO8JJlicODgnOb7ivyERyp17IaM46xEbA1u3zfk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t0EFD+neQTCPNIIzlizY/jvpn1WE/6TF7hk8uXMrRK2Mpmnn57CMpZCtIYynucJgk
         9El+KEXD3o29oNRdkzaAvv3Z5WXyuV1Pc3udghccmxakFTTKysS13DGoVmbgA83lQm
         chk0s0syWHHPo+ftcixUEGLB+/w9UMMBV5tDqbEe6XT+b6W/LJqjIxGSgtExQko8es
         MobMI8lhRrAK3H4Kkf7GI/YeinBymto3fya7eLQXoS/ClIy2m65uKLEqCaYApVjp6X
         W30TDrED44iBM6GoKt5gg4vCd0Mp5rBL2L+9INqCysnB5bIyr2X928tnji2KNfg8EL
         uvSsgS4cwHGSA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6EE21608B9;
        Tue,  8 Jun 2021 23:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: stmmac: explicitly deassert GMAC_AHB_RESET
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162319620444.30091.10501807716630909257.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 23:50:04 +0000
References: <20210608185913.3909878-1-mnhagan88@gmail.com>
In-Reply-To: <20210608185913.3909878-1-mnhagan88@gmail.com>
To:     Matthew Hagan <mnhagan88@gmail.com>
Cc:     bjorn.andersson@linaro.org, p.zabel@pengutronix.de,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, linux@armlinux.org.uk,
        weifeng.voon@intel.com, boon.leong.ong@intel.com,
        vee.khee.wong@linux.intel.com, tee.min.tan@intel.com,
        vee.khee.wong@intel.com, michael.wei.hong.sit@intel.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  8 Jun 2021 19:59:06 +0100 you wrote:
> We are currently assuming that GMAC_AHB_RESET will already be deasserted
> by the bootloader. However if this has not been done, probing of the GMAC
> will fail. To remedy this we must ensure GMAC_AHB_RESET has been deasserted
> prior to probing.
> 
> v2 changes:
>  - remove NULL condition check for stmmac_ahb_rst in stmmac_main.c
>  - unwrap dev_err() message in stmmac_main.c
>  - add PTR_ERR() around plat->stmmac_ahb_rst in stmmac_platform.c
> 
> [...]

Here is the summary with links:
  - [v3] net: stmmac: explicitly deassert GMAC_AHB_RESET
    https://git.kernel.org/netdev/net-next/c/e67f325e9cd6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


