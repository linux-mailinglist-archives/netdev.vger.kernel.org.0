Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8ABE67907C
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 06:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbjAXFwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 00:52:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjAXFwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 00:52:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96AA83BDB4;
        Mon, 23 Jan 2023 21:51:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 428F3B81061;
        Tue, 24 Jan 2023 05:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0F63C433EF;
        Tue, 24 Jan 2023 05:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674539418;
        bh=WY1EBJb8X9T+vDrndSsyN2P2Et/Gad9XcNibmTc2RMg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n9I0cgEsBxuZLOKIDWFzBGmRMOhXc4tSDdRv0BjtoNJDynaESIAgB1jbV1ifMuplE
         FbEyv2M7PDsON6nEUYBxdRjnS+hlpmiLaI3QYxz+XAj40pN69wHw4bWDjpAwSJWStp
         vsEPmnTWVi+FYUodNrRPZivrE+L0QT7dYQ4iPqGmJieejdI29CUi8nTCp0yAqpOk92
         blqxXU2vpNPrsKn6NLbBWWOm6YZtjvrvHMO8DQBo6Favh5ST+w6Uws7DNjGvPJJd+U
         CLAl+CBiDRhow2k0cgJ7RHkjXtKVufC0BbXaZ8GKdeGTJKE91FCq1P9vzpZo0N1fR9
         YgvX/79X5p4hw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C7406E4522B;
        Tue, 24 Jan 2023 05:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: dsa: microchip: fix probe of I2C-connected
 KSZ8563
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167453941781.4419.5339150286567490548.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Jan 2023 05:50:17 +0000
References: <20230120110933.1151054-1-a.fatoum@pengutronix.de>
In-Reply-To: <20230120110933.1151054-1-a.fatoum@pengutronix.de>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     kuba@kernel.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, linux@rempel-privat.de,
        kernel@pengutronix.de, ore@pengutronix.de,
        Arun.Ramadoss@microchip.com, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 20 Jan 2023 12:09:32 +0100 you wrote:
> Starting with commit eee16b147121 ("net: dsa: microchip: perform the
> compatibility check for dev probed"), the KSZ switch driver now bails
> out if it thinks the DT compatible doesn't match the actual chip ID
> read back from the hardware:
> 
>   ksz9477-switch 1-005f: Device tree specifies chip KSZ9893 but found
>   KSZ8563, please fix it!
> 
> [...]

Here is the summary with links:
  - [net,v2] net: dsa: microchip: fix probe of I2C-connected KSZ8563
    https://git.kernel.org/netdev/net/c/360fdc999d92

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


