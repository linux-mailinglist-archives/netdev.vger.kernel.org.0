Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C986F477DDF
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241396AbhLPUvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241473AbhLPUvo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:51:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EF4C061574;
        Thu, 16 Dec 2021 12:51:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28D2EB8263E;
        Thu, 16 Dec 2021 20:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CDAF6C36AEE;
        Thu, 16 Dec 2021 20:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639687900;
        bh=Ud7JEZsgfXJLxq8d3PVyQQhBSvG6W/4Xe5JpvEINbpY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ACk2ZAjMluqh/Ro4YXUl4Ntia5uwxYnXNQEu+tvecRNud+n7900O7s48InNPUlcgr
         ie/q4Up5cBG6UW2/vTOHK9lXcT1tEGq2AIDOZDlGieRpDp0YoEDlADNFYVSFLrSzIw
         1wV/KHUQwp90Fnn6UoF9GIyRjyvPPRYyv8oQf1LoH9JMdyyVyec0xIqCVg2B1QjN3U
         QzE9PrMjXcgoAzzxhNK/ftV7S0LKMYbiLU/bLReE18Ekm/uuXTaYxcly266u5NwGNg
         cr1i9iW20Dk9AP5GjhNHfKbsUaaxJaQ/0f0sqv0fFiS3PGaooP7modkYncRJDBH6WX
         aX6RhElbPkuGA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B00FF60A4F;
        Thu, 16 Dec 2021 20:51:40 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: stmmac: dwmac-rk: fix oob read in rk_gmac_setup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163968790071.17466.7200435085941937139.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Dec 2021 20:51:40 +0000
References: <20211214191009.2454599-1-john@metanate.com>
In-Reply-To: <20211214191009.2454599-1-john@metanate.com>
To:     John Keeping <john@metanate.com>
Cc:     netdev@vger.kernel.org, linux-rockchip@lists.infradead.org,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com, david.wu@rock-chips.com,
        ezequiel@vanguardiasur.com.ar,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 14 Dec 2021 19:10:09 +0000 you wrote:
> KASAN reports an out-of-bounds read in rk_gmac_setup on the line:
> 
> 	while (ops->regs[i]) {
> 
> This happens for most platforms since the regs flexible array member is
> empty, so the memory after the ops structure is being read here.  It
> seems that mostly this happens to contain zero anyway, so we get lucky
> and everything still works.
> 
> [...]

Here is the summary with links:
  - net: stmmac: dwmac-rk: fix oob read in rk_gmac_setup
    https://git.kernel.org/netdev/net/c/0546b224cc77

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


