Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6B42DD8F9
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 20:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730315AbgLQTAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 14:00:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:44712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730138AbgLQTAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 14:00:48 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608231607;
        bh=EhJ7dfs0EK3hhyFDhg+2S0vTm5KGwZdO7qF2Dfa4TTU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oi32aDTOkeSLGMcc+IXLuSm/tmW3SGvzAPnUy6acyVOraVPBcDH4xdCDw0WXgUqVJ
         wX1pcXy2LXex8Wwnhk63nEoi7+F5F9dVoe7pfERonn9gljdWwoNXU4LhQ92CzcmrCs
         x7p61gEXnWUjEU5vqIMd/f7iDhhPrAlzUfZD0DguXkBAREOtpAqsQ4tF0NLC5+dyo9
         3yKpL5sGpPzhIWDaGmVYrivSPGnZk2e9Tsv8RZRfsBw19sFSOxIBrp3jF74lxHftKq
         xmyKzVSZ/TN2uxI+9AV+c7BVFgggXd7bcqyWNxx3evd72IbIKYD9iVrt6/mT4j4Lp4
         yy1yFEf+u8Ojw==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] qlcnic: Fix error code in probe
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160823160779.4885.3716002123828693484.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Dec 2020 19:00:07 +0000
References: <X9nHbMqEyI/xPfGd@mwanda>
In-Reply-To: <X9nHbMqEyI/xPfGd@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     shshaikh@marvell.com, sony.chacko@qlogic.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net, kuba@kernel.org,
        sucheta.chakraborty@qlogic.com, sritej.velaga@qlogic.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 16 Dec 2020 11:38:04 +0300 you wrote:
> Return -EINVAL if we can't find the correct device.  Currently it
> returns success.
> 
> Fixes: 13159183ec7a ("qlcnic: 83xx base driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net] qlcnic: Fix error code in probe
    https://git.kernel.org/netdev/net/c/0d52848632a3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


