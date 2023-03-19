Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40A16C008D
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 11:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjCSKuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 06:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjCSKuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 06:50:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BFC136D6;
        Sun, 19 Mar 2023 03:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A641060F98;
        Sun, 19 Mar 2023 10:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0D6CC4339C;
        Sun, 19 Mar 2023 10:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679223018;
        bh=C8O4+Edg6nUoP/urzz0ELTJ2vdwjDQ04VBL86H1WkiI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kYR/x3CcdqDTHdGrY4y+fXQJEwUIN6Gu43szRfEMJgB3kJW0HAJSp50x9iWRDrkwU
         ixbiyX0IXIFWfINS5OldqAsaeseY2ts1opqsOMU26hvO42lInnlz1cxYS9tZ0JmiGb
         NY+x2cVtQ5cHwZ/QFxEypVnf5BRWh6fnAhu9A3MRSn0DWW2L6LbipfmRgk3eBsPRd6
         WoOckysBK95U35rAZh4bm/joykZ1AB/M6l1wiKWq8Dc6ztSaaehUAAg9UydFkKpNe1
         1BDIVetMcnLnG5W6FYzzadQiWn8z5IYpGbVgngpycXGNqHLZK6E0/iPB51Av0lvOUQ
         zflov9I9qFZnw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C4060C43161;
        Sun, 19 Mar 2023 10:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/2] ACPI/DT mdiobus module owner fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167922301879.22899.11427209223870054217.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Mar 2023 10:50:18 +0000
References: <20230316233317.2169394-1-f.fainelli@gmail.com>
In-Reply-To: <20230316233317.2169394-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        frowand.list@gmail.com, rafael@kernel.org,
        calvin.johnson@oss.nxp.com, grant.likely@arm.com,
        ioana.ciornei@nxp.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, mbizon@freebox.fr
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 16 Mar 2023 16:33:15 -0700 you wrote:
> This patch series fixes wrong mdiobus module ownership for MDIO buses
> registered from DT or ACPI.
> 
> Thanks Maxime for providing the first patch and making me see that ACPI
> also had the same issue.
> 
> Changes in v2:
> 
> [...]

Here is the summary with links:
  - [v2,1/2] net: mdio: fix owner field for mdio buses registered using device-tree
    https://git.kernel.org/netdev/net/c/99669259f336
  - [v2,2/2] net: mdio: fix owner field for mdio buses registered using ACPI
    https://git.kernel.org/netdev/net/c/30b605b8501e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


