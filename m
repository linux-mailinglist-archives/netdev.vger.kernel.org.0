Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D0D488DB0
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237743AbiAJBAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237687AbiAJBAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:00:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05D8DC06173F;
        Sun,  9 Jan 2022 17:00:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D20561093;
        Mon, 10 Jan 2022 01:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BAA71C36AF8;
        Mon, 10 Jan 2022 01:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641776413;
        bh=cUhaWZHYpcYcrXLhOAVImihV/TLJac/2TWQmffO+QtQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TCWLQTVJW7S4IbqdobeJrsPbBzKPT5pzJcmOVKYHcF8V8OC1oVcE+2v4hzjFa0QUK
         WNyvSxgVK5cPn9W3VJo4yW8+NsWHrcL9pd1XPCASrp0G+pdUz9/TPU004ypvvXn6Ut
         F20OJlZZBHaax9Cp4IKX/8iN/AA2pSZ13CaOR5maIFoL1zQu7DIt2I7z04LYKMU93o
         X/aNQ0HB+zFVOUp46oDahjeXnSlXEdQXfWtrv00uXZKMAGcNvFmnivdwl9qoUyNXM8
         CMlcCzfat4ngj7+8wU0fKgP5NqGLUhgYMKNLhg/nabHFm23imTpNhtNq0DlsR1oSfU
         SIlpoybnJfEzw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A8CDDF6078F;
        Mon, 10 Jan 2022 01:00:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] cxgb4: Remove useless DMA-32 fallback configuration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177641368.18208.5077653983544342613.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 01:00:13 +0000
References: <56db10d53be0897ff1be5f37d64b91cb7e1d932c.1641736387.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <56db10d53be0897ff1be5f37d64b91cb7e1d932c.1641736387.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  9 Jan 2022 14:53:27 +0100 you wrote:
> As stated in [1], dma_set_mask() with a 64-bit mask never fails if
> dev->dma_mask is non-NULL.
> So, if it fails, the 32 bits case will also fail for the same reason.
> 
> So, if dma_set_mask_and_coherent() succeeds, 'highdma' is known to be true.
> 
> Simplify code and remove some dead code accordingly.
> 
> [...]

Here is the summary with links:
  - cxgb4: Remove useless DMA-32 fallback configuration
    https://git.kernel.org/netdev/net-next/c/7fc7fc5da61b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


