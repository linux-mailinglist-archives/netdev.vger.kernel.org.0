Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9D5488108
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 04:10:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233417AbiAHDKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 22:10:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233414AbiAHDKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 22:10:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A6EC06173E
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 19:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C00EB827FA
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 03:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED2FFC36AEB;
        Sat,  8 Jan 2022 03:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641611411;
        bh=jA6gHaa1p6xKAcQmrRqJECzO7xRAK+ZzXQopgW+4i+8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fMxTplamQ7x2UB1jROeRdh86oMWNgszd3UbUe4WIkcwfAAX6O9a2k2JxwSWm9wyEG
         sZb0nAn/MCdPIlFxWCekUyp0wiuaNLzGr+Z81SNjI8a7Qy/GbA8y0ZThXhIyS5//J3
         P+e4o1Xx30eV6/f1y6IYAK7hI9kpnXPV/YDQg4qKmdRE1390gNS2CZiDaHmci3nU6y
         EEAtt0fgyWjttjoULurJhROEXI8eOnluZwWXXOQfja8rS3opbPrAg53bQOuiRTkiDK
         +lEh/5khenJl+yMjyHbMjH+q5ddwf8xE9Ln2YoV9og+0FJPzQjdVAFnmYu2u8TeCLK
         5Xre3MP5Zak+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D9149F7940C;
        Sat,  8 Jan 2022 03:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: felix: add port fast age support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164161141088.29029.11809935205559242748.git-patchwork-notify@kernel.org>
Date:   Sat, 08 Jan 2022 03:10:10 +0000
References: <20220107144229.244584-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220107144229.244584-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  7 Jan 2022 16:42:29 +0200 you wrote:
> Add support for flushing the MAC table on a given port in the ocelot
> switch library, and use this functionality in the felix DSA driver.
> 
> This operation is needed when a port leaves a bridge to become
> standalone, and when the learning is disabled, and when the STP state
> changes to a state where no FDB entry should be present.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: felix: add port fast age support
    https://git.kernel.org/netdev/net-next/c/5cad43a52ee3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


