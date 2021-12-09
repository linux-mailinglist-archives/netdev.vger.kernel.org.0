Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE8D46ECEE
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 17:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241001AbhLIQXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 11:23:47 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41916 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237216AbhLIQXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 11:23:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01210B82568;
        Thu,  9 Dec 2021 16:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C410DC341C3;
        Thu,  9 Dec 2021 16:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639066809;
        bh=aX/3vLuFjcxCYUWcp4iLTjHuoMCxWqcBUQjFlIFG5ww=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eqKns1CQAQgF/kmpBBI2RixxzJ+0mhLiRoPSkpCuG+YCiF9+Gw3NySrLW/R6cjws1
         b0sx46GkxnMSCI0saCqeunkDKiD5kfWcZ/H7gEpRVQCaEA8A7l9pe2waU7Fzp3tmLG
         xfpY4fWCib5y+9Qw/3k6SercSg20++EkFbFU+QlH/4ZOOhlDl9eCf2YiCVipCYFqKL
         OqDa8wi05D2FEQaYL3WonUsyul8GA+mkOQcOgLj2c3jS2G5MW0POhrALuZLtT5wk++
         wWF1MNtVjoJrPueOVgFo06MensbwblI91CDt+XRiiqCqSLYQ2m9ZwOCfY+hvnZ1AzZ
         48ZdX7Ot3VCEw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AC2D7609D7;
        Thu,  9 Dec 2021 16:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: dsa: felix: Fix memory leak in
 felix_setup_mmio_filtering
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163906680969.23169.11355567482010587770.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 16:20:09 +0000
References: <20211209110538.11585-1-jose.exposito89@gmail.com>
In-Reply-To: <20211209110538.11585-1-jose.exposito89@gmail.com>
To:     =?utf-8?b?Sm9zw6kgRXhww7NzaXRvIDxqb3NlLmV4cG9zaXRvODlAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Dec 2021 12:05:40 +0100 you wrote:
> Avoid a memory leak if there is not a CPU port defined.
> 
> Fixes: 8d5f7954b7c8 ("net: dsa: felix: break at first CPU port during init and teardown")
> Addresses-Coverity-ID: 1492897 ("Resource leak")
> Addresses-Coverity-ID: 1492899 ("Resource leak")
> Signed-off-by: José Expósito <jose.exposito89@gmail.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> [...]

Here is the summary with links:
  - [v2] net: dsa: felix: Fix memory leak in felix_setup_mmio_filtering
    https://git.kernel.org/netdev/net/c/e8b1d7698038

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


