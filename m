Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A105258BC
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 01:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359646AbiELXuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 19:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352431AbiELXuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 19:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31851289BF4
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 16:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDEAA62097
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 23:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2A1F5C34113;
        Thu, 12 May 2022 23:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652399415;
        bh=GvhIe0Ec8LNqbbphTTex85xsc83W2uDjZPN/Y+7b83I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Cz+xcLIXrm4WoSLwzt+ebz4djqvaWFq7xln5z3l9CApzeUNFoOwt9EBuWjWjjnh1k
         zd8JOvC4ptytVd1FFjI3Vf65Av1oeH3xL/JCKOvkdyECh8zJRmdaoIBZnOB9rPkjFU
         zjgRrvxHTbobS3M1UQ/XQE1x8mOUUilgj08PoSlmOYkDZMO3A1KU1WmREazPEfRM0P
         QOhB3dSk/ne02oQY4P7W/XxJpJ+5+LMrzyN0zK91/gjYQE54fnTPEje+E8Vg7mBGRz
         PwBbwDsFg4L7sWeuOOCCvBwqWPC5z2rk+p0s3+3/4oRv/wIlns7BswRC+G+uN+LaqE
         kriWP67UOiPBA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 06559F0392C;
        Thu, 12 May 2022 23:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] Restructure struct ocelot_port
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165239941502.20203.13113516324001358297.git-patchwork-notify@kernel.org>
Date:   Thu, 12 May 2022 23:50:15 +0000
References: <20220511100637.568950-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220511100637.568950-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, colin.foster@in-advantage.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 11 May 2022 13:06:34 +0300 you wrote:
> This patch set represents preparation for further work. It adds an
> "index" field to struct ocelot_port, and populates it from the Felix DSA
> driver and Ocelot switchdev driver.
> 
> The users of struct ocelot_port :: index are the same users as those of
> struct ocelot_port_private :: chip_port.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: mscc: ocelot: delete ocelot_port :: xmit_template
    https://git.kernel.org/netdev/net-next/c/15f6d01e4829
  - [net-next,2/3] net: mscc: ocelot: minimize holes in struct ocelot_port
    https://git.kernel.org/netdev/net-next/c/6d0be6004770
  - [net-next,3/3] net: mscc: ocelot: move ocelot_port_private :: chip_port to ocelot_port :: index
    https://git.kernel.org/netdev/net-next/c/7e708760fc11

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


