Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9820547842F
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 05:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbhLQEkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 23:40:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232492AbhLQEkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 23:40:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C478C061574;
        Thu, 16 Dec 2021 20:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EF131B826F4;
        Fri, 17 Dec 2021 04:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA9FDC36AE8;
        Fri, 17 Dec 2021 04:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639716010;
        bh=rwv6cNRQrcnb/nNVrWctl59B67f5Gjg6W8600vB6jnk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pNZ1F+qYKnPwkfAFTkQfkhZoBTcLARIzAd+e3bjFL0IIBM7z9F3YChEJeFLFxTEhK
         MDz8A2iBxqGssBOTqv241JmBSkvHLgpnBG5JaMDAvMG6A7I3+3Cbft0I8e5beG7Z/A
         w4vG13IQqpkMd2rcS4/2sYC9kspNxbLk9v0Uc9d3MiIP/IBVzcyhVfv0FheQ4teYgx
         eMHbfAkStDV5+eFer/wghVIwcEMLNx920p6MQeZebc+p0fNxSJ/u5sNe3mZ5/Ox9FI
         UE8Qi6MbPn8v5AXLw1mDpkS4EFPF2hoym2+IcGAZxV/rME741FIKX+dLLzecl8MhHZ
         iH71IYHEeg7cA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A3D0D60BD0;
        Fri, 17 Dec 2021 04:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: mana: Add RX fencing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163971601066.6242.10593525667079499767.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Dec 2021 04:40:10 +0000
References: <20211216001748.8751-1-decui@microsoft.com>
In-Reply-To: <20211216001748.8751-1-decui@microsoft.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     davem@davemloft.net, kuba@kernel.org, gustavoars@kernel.org,
        haiyangz@microsoft.com, netdev@vger.kernel.org, kys@microsoft.com,
        stephen@networkplumber.org, wei.liu@kernel.org,
        linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
        shacharr@microsoft.com, paulros@microsoft.com, olaf@aepfle.de,
        vkuznets@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 15 Dec 2021 16:17:48 -0800 you wrote:
> RX fencing allows the driver to know that any prior change to the RQs has
> finished, e.g. when the RQs are disabled/enabled or the hashkey/indirection
> table are changed, RX fencing is required.
> 
> Remove the previous workaround "ssleep(1)" and add the real support for
> RX fencing as the PF driver supports the MANA_FENCE_RQ request now (any
> old PF driver not supporting the request won't be used in production).
> 
> [...]

Here is the summary with links:
  - [net-next] net: mana: Add RX fencing
    https://git.kernel.org/netdev/net-next/c/6cc74443a773

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


