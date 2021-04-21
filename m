Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C6A936715A
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 19:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244752AbhDURat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 13:30:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:49272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244672AbhDURan (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 13:30:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4DCBC6145C;
        Wed, 21 Apr 2021 17:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619026210;
        bh=wvG6mq/pPzzw+F3r/h1+Yj8Af73d25CcCy4yT3YbXyI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dJuh4n8zXWmLA3oNwCD/f/Wy53aaRMstQmirCTqglofjWb25/nEEykH5gRMeRGCSC
         TSRRrUpEcZCO/tTY9IBMXecAj5mHkOpTH6wwtnspDBOx+HVFREID2/FNDkdctXDPPN
         Rge3aYpuisIltu2MTGHLcL/Oxm8xfudPy390k+576iRr/uhMQ2dLNiQ8iLBBhmxUay
         DAtYe9hGVPzz5FN8eVDnjKW3v05IwEIbF7XkwmzgtsepV2dRz5fVlkPpuHZ8ucgmC9
         uXjtFbhNKmwlnQrJiXLyYRxGzzGdOhZ0QNs+Y9PFf8x7XxJ17k9hZqOEISe2MXL+R4
         jilbJ45JAmnbg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4847B60A3C;
        Wed, 21 Apr 2021 17:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] stmmac: intel: unlock on error path in
 intel_crosststamp()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161902621029.9844.10834595645280467228.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 17:30:10 +0000
References: <YIAnKtpJa/K+0efq@mwanda>
In-Reply-To: <YIAnKtpJa/K+0efq@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     peppe.cavallaro@st.com, tee.min.tan@intel.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        davem@davemloft.net, kuba@kernel.org, mcoquelin.stm32@gmail.com,
        vee.khee.wong@linux.intel.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 21 Apr 2021 16:22:50 +0300 you wrote:
> We recently added some new locking to this function but one error path
> was overlooked.  We need to drop the lock before returning.
> 
> Fixes: f4da56529da6 ("net: stmmac: Add support for external trigger timestamping")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net-next] stmmac: intel: unlock on error path in intel_crosststamp()
    https://git.kernel.org/netdev/net-next/c/53e35ebb9a17

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


