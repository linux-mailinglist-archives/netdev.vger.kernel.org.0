Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF683AA45A
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbhFPTcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230332AbhFPTcJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 15:32:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 877EA61246;
        Wed, 16 Jun 2021 19:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623871803;
        bh=f9H14eCfhOjvGvGE7xKVI0N3PyCwuQDCxqlmu4asqo0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BqdBAE2TFTBgmA+TcCJvVRAPxQ352ku5ISlA1NipNhTIvt2TlDFARtlh1ViuFWgAP
         4rQljHMoazXSpr7dt9/G4KRaw4BvPVYZDF8K836Ewun/jERwF6ZaRr0jepn9CFYjKR
         OcG6jEgkixEO33hK7qJZ96S0v43vsI/wt+8To/9j9qxFRmEOVfytsOaMZ77s5/q3/n
         qopJILBhq+8Yt2BnWoBknrFbhlA5soPPtTzLfSQVUDtSFUwQntMFmKKBlA5bcygfp8
         2BrVwOgG1iY2SCQuMQ8SCAX6sajdXDORxZJXwifIIROrSmGE7/xkWSsnvLC/cq4wbv
         YoOoAdMkqHZKA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7B86060A54;
        Wed, 16 Jun 2021 19:30:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: stmmac: disable clocks in stmmac_remove_config_dt()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162387180350.2076.2488923511178824990.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 19:30:03 +0000
References: <20210616091024.13412-1-qiangqing.zhang@nxp.com>
In-Reply-To: <20210616091024.13412-1-qiangqing.zhang@nxp.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-imx@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 16 Jun 2021 17:10:24 +0800 you wrote:
> Platform drivers may call stmmac_probe_config_dt() to parse dt, could
> call stmmac_remove_config_dt() in error handing after dt parsed, so need
> disable clocks in stmmac_remove_config_dt().
> 
> Go through all platforms drivers which use stmmac_probe_config_dt(),
> none of them disable clocks manually, so it's safe to disable them in
> stmmac_remove_config_dt().
> 
> [...]

Here is the summary with links:
  - [net] net: stmmac: disable clocks in stmmac_remove_config_dt()
    https://git.kernel.org/netdev/net/c/8f269102baf7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


