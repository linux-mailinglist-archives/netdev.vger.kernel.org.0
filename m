Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D60352321
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 01:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236125AbhDAXAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 19:00:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:60190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235670AbhDAXAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 19:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E79716112E;
        Thu,  1 Apr 2021 23:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617318008;
        bh=tSr+zGDSluwm5YWn2jN0KZi3KMNYKIeIsuiiZFz4PkI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Bd74D8KdBl9+NjVrc3KlWF3RDkEL8bCZ46tt4u60K3OC4d17ZFdEixaFm0bqrlwUS
         GEHmDrNXSlVZKVKPhcgk3qCIKQn/mbsBU7It93ODlc+F8thfYtnk6ooJHlxfJPoTfT
         1UXzvjYX3/BHVvSOUvABfsUc4iSLQ7pdFtBAibvcaGrNAD6/tcrsEo7g3C8yoj+DiN
         6yOxl6HDH+dkMe3cfKY35CGK22IrzuyiqyHIrGqy/+36s52C6rbpLpWZDH1eCurT0j
         H9m0FAiM5zbYR2UjCbPIDZcmkMsggxIaja79lBrqr4hptmrtjcIuk2sutMM+B3ksYh
         eTgaklKYzvYsg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DF301609CF;
        Thu,  1 Apr 2021 23:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] net: stmmac: remove unnecessary pci_enable_msi()
 call
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161731800891.8028.4149863007531019665.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Apr 2021 23:00:08 +0000
References: <20210401060628.27339-1-vee.khee.wong@linux.intel.com>
In-Reply-To: <20210401060628.27339-1-vee.khee.wong@linux.intel.com>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu,  1 Apr 2021 14:06:28 +0800 you wrote:
> The commit d2a029bde37b ("stmmac: pci: add MSI support for Intel Quark
> X1000") introduced a pci_enable_msi() call in stmmac_pci.c.
> 
> With the commit 58da0cfa6cf1 ("net: stmmac: create dwmac-intel.c to
> contain all Intel platform"), Intel Quark platform related codes
> have been moved to the newly created driver.
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] net: stmmac: remove unnecessary pci_enable_msi() call
    https://git.kernel.org/netdev/net-next/c/2237778d8c21

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


