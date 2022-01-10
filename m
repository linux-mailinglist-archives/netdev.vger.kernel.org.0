Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A82C9488DDD
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238089AbiAJBBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:01:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237702AbiAJBAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:00:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06768C061756;
        Sun,  9 Jan 2022 17:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C61CEB8107A;
        Mon, 10 Jan 2022 01:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98C90C36AEF;
        Mon, 10 Jan 2022 01:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641776413;
        bh=oe9gaJp5URaghApbTlnONTTll1LYPSKNFJ49ITzjjtY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P15Z7/kIH9ENZ4WluXgYtabrs1J696H2twDznCPOCqxbCQ9Mt8PXbqRZ+GMjaHFhs
         WwwcMi3rdTZ5CrnXk2pML/P/EnmSuOQlY2x5QsqU9HB1kMAtsm9jIMvVWAscSsbUiv
         xreYdRXqCM/VPNEV3nAd6T5LZ+Ygb3RcC2m3yeyHLBdO5X0+6cJA5uSbZ3KvM2u5Wv
         /PpZbnRAeSMMWQJ2se/rHeBqdcN/5gw2fYA3XCWixVMVunWeEm3ZMuKvJ53f0/vMDJ
         D2Y68be9pqArJuIHBKabdMXWn5zdmuXQzrRAnypMkVrW5c/xtl2hEzDmwbbMUMafT1
         5NrKebGRnrO+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8776BF60790;
        Mon, 10 Jan 2022 01:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] hinic: Remove useless DMA-32 fallback configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177641354.18208.14590154615391558393.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 01:00:13 +0000
References: <23541c28df8d0dcd3663b5dbe0f76af71e70e9cc.1641743855.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <23541c28df8d0dcd3663b5dbe0f76af71e70e9cc.1641743855.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  9 Jan 2022 16:57:50 +0100 you wrote:
> As stated in [1], dma_set_mask() with a 64-bit mask never fails if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
> 
> Simplify code and remove some dead code accordingly.
> 
> [1]: https://lkml.org/lkml/2021/6/7/398
> 
> [...]

Here is the summary with links:
  - hinic: Remove useless DMA-32 fallback configuration
    https://git.kernel.org/netdev/net-next/c/004464835bfc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


