Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 592746790C3
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 07:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbjAXGUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 01:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230149AbjAXGUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 01:20:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F88630E98;
        Mon, 23 Jan 2023 22:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52018B8109E;
        Tue, 24 Jan 2023 06:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 03747C4339B;
        Tue, 24 Jan 2023 06:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674541218;
        bh=htIej7QYbhaOPD6v4mD8j1CKCVcA0sBQZVK/BHROMs0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UGD5Oe7NPaWwdH3E2KQwACkUb39Ax6GbapOc6isw3Djo0eTNBcdLXPMRxN7TJnVb8
         bzQ03yRRnguO26oCkQXQ7pznSHvPYUzaxqhnmAzDKjVOFZ7P9biAkD+cNOl42gAayz
         mtYveuF+KEL7oMjXiBiUKlJSslAoQqk38GfQgT/gAipfbWrqN5Y5s/6Q3LPRl0oIhn
         5MKq98UHHwMuUa+MQwzmk1FtKDv3ozb9pyAtGSV2wpJra5o9Ydsp0JyMqx8f6wznQe
         OmoyRc8pepNVloWYG8893owUpobAtwWvrwPUid3RG4jdlAc1EOfx0yeBOLxvM40sFa
         ng5NoeW1vidbg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E0961E4522B;
        Tue, 24 Jan 2023 06:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch net-next v2 0/2] net: dsa: microchip: add support for credit
 based shaper
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167454121791.18672.15309097312124008848.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Jan 2023 06:20:17 +0000
References: <20230120052135.32120-1-arun.ramadoss@microchip.com>
In-Reply-To: <20230120052135.32120-1-arun.ramadoss@microchip.com>
To:     Arun Ramadoss <arun.ramadoss@microchip.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        Tristram.Ha@microchip.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 20 Jan 2023 10:51:33 +0530 you wrote:
> LAN937x switch family, KSZ9477, KSZ9567, KSZ9563 and KSZ8563 supports
> the credit based shaper. But there were few difference between LAN937x and KSZ
> switch like
> - number of queues for LAN937x is 8 and for others it is 4.
> - size of credit increment register for LAN937x is 24 and for other is 16-bit.
> This patch series add the credit based shaper with common implementation for
> LAN937x and KSZ swithes.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: dsa: microchip: enable port queues for tc mqprio
    https://git.kernel.org/netdev/net-next/c/e30f33a5f5c7
  - [net-next,v2,2/2] net: dsa: microchip: add support for credit based shaper
    https://git.kernel.org/netdev/net-next/c/71d7920fb2d1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


