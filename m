Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1B149CEDF
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 16:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239112AbiAZPuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 10:50:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57496 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234303AbiAZPuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 10:50:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9871B81EE7;
        Wed, 26 Jan 2022 15:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 947D5C340E9;
        Wed, 26 Jan 2022 15:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643212211;
        bh=Fpd60YgLZ5CrmUXnEPeEhJTefMoMXl7hPe50yHSyO6Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P3Qwa8v9nv++xBg+67ybzPQUXUFEKODU8jTiLkmEbWKQrOVnVYMZ6o2oPcXsPQwbZ
         sQwJTmosf0Vp9GXjBzA9tPPDLktARYJjsl/a8uKbzSv0nJjsgfwXMCUcCKfv0gNdER
         zaNKwRlkmfUJR4fp/HJkpn3wPHWSOHMqAcYdvemWQE834t4aB9ZgqBPEiBuCNGRx5r
         Q/U8Xgbe1Re0SjEYxni/2yM9HiCFiAXhq50RJQoXco7GOgodpCQoLgiw451oqcDhtH
         4KKUWTcWoLlkonWtL6wjqpit1aw3ghKqqtdh9uVB6JT5Z/T3i862NzsBYjPFlkRP5P
         PBKRkFXPa+7mA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 777C1E5D087;
        Wed, 26 Jan 2022 15:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] net: lan966x: Fixes for sleep in atomic context
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164321221148.12592.6841652619897496438.git-patchwork-notify@kernel.org>
Date:   Wed, 26 Jan 2022 15:50:11 +0000
References: <20220125114816.187124-1-horatiu.vultur@microchip.com>
In-Reply-To: <20220125114816.187124-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, davem@davemloft.net, kuba@kernel.org,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        vladimir.oltean@nxp.com, andrew@lunn.ch
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 25 Jan 2022 12:48:14 +0100 you wrote:
> This patch series contains 2 fixes for lan966x that is sleeping in atomic
> context. The first patch fixes the injection of the frames while the second
> one fixes the updating of the MAC table.
> 
> v1->v2:
>  - correct the fix tag in the second patch, it was using the wrong sha.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] net: lan966x: Fix sleep in atomic context when injecting frames
    https://git.kernel.org/netdev/net/c/b6ab149654ef
  - [net,v2,2/2] net: lan966x: Fix sleep in atomic context when updating MAC table
    https://git.kernel.org/netdev/net/c/77bdaf39f3c8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


