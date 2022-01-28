Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A99249F152
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 03:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345561AbiA1Cxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 21:53:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56090 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345559AbiA1Cxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 21:53:48 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40AE7B82439
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 02:53:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 04FA1C340EA;
        Fri, 28 Jan 2022 02:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643338426;
        bh=fqBN3tZ7yzR4C7PWn/93Qz9+aa8L8wZw9FgoOWy2FyM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PK36b/iXacA869wqvsPf8Z03cVI7Ak5/Iu0vbJYr3DV6MDn59+MM14mxAfyA93jBG
         brfXeakqUqaPEqrk2yz7gjIWW3ahF+jPXn5Npo7FSgVsNrUOJcBY8GEu0va9ESVuTl
         yRE/RDKLsOMU4Rc3slfW2kh6mpSxVLSTycyz781UZ7Dx/hJOaafcQYFPi6zrsrOmtm
         S9uDHgFBRWymV8YaNJa/ZrgPgHYMYQUgZWcVcA8Yrb2XzR4Tth49MHkQSpsKxdpYcz
         oWDJKFe68Vri12shePP5Di2Lz1AS9JGplJdd3JcZj5cUn2C1kaNFKLXnEoBA6z6CpV
         PPXXMoxdVT9kg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DBF64E5D07E;
        Fri, 28 Jan 2022 02:53:45 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: amd-xgbe: Fix skb data length underflow
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164333842589.3422.3038399508263251234.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Jan 2022 02:53:45 +0000
References: <20220127092003.2812745-1-Shyam-sundar.S-k@amd.com>
In-Reply-To: <20220127092003.2812745-1-Shyam-sundar.S-k@amd.com>
To:     Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Cc:     thomas.lendacky@amd.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Raju.Rangoju@amd.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 27 Jan 2022 14:50:03 +0530 you wrote:
> There will be BUG_ON() triggered in include/linux/skbuff.h leading to
> intermittent kernel panic, when the skb length underflow is detected.
> 
> Fix this by dropping the packet if such length underflows are seen
> because of inconsistencies in the hardware descriptors.
> 
> Fixes: 622c36f143fc ("amd-xgbe: Fix jumbo MTU processing on newer hardware")
> Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
> Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
> 
> [...]

Here is the summary with links:
  - [net] net: amd-xgbe: Fix skb data length underflow
    https://git.kernel.org/netdev/net/c/5aac9108a180

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


