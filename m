Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FFE25163F7
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 13:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344744AbiEALNl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 07:13:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345406AbiEALNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 07:13:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA47F4D
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 04:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1471CB80CF7
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 11:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A946CC385AF;
        Sun,  1 May 2022 11:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651403411;
        bh=eB5VoypmhY+lQ+zQfvKD//NZNhviuv0IlHAMSnIZ1GI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b2uIe+TNxShLUHZ5jtMB7gF6QyFZ1P6kqGMXEwTzX7TR9JPk3vqot2LxfidF0khBf
         rlKL/t4sDURs5BzVqogg6hYN6WMjkbxNkIf3xmm12K5pCnEmLVItEHj25jg5nTPV8T
         hHch4PS1nbHkiJb6b8k7PmNPLXubfqxVVwaDgXeGW171etXZAWCfK3UIQ19zN69Z0D
         0KfGCakRoacsPjvgHcs9k32v6lpbZb63Ug6NxSSc53d9ucHrzltKuO8kLP2YgFNtPW
         DneV/Md/lnuB3dZ6ogHsiI+jdxYru37CX3eHc+toHNxdLdr3Pdi5U71L1P8mesY8oK
         XNU+qKRdWLj4Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8A4A0F03841;
        Sun,  1 May 2022 11:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: marvell: update abilities and advertising
 when switching to SGMII
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165140341156.16654.10434931995474555191.git-patchwork-notify@kernel.org>
Date:   Sun, 01 May 2022 11:10:11 +0000
References: <20220427193928.2155805-1-robert.hancock@calian.com>
In-Reply-To: <20220427193928.2155805-1-robert.hancock@calian.com>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 27 Apr 2022 13:39:28 -0600 you wrote:
> With some SFP modules, such as Finisar FCLF8522P2BTL, the PHY hardware
> strapping defaults to 1000BaseX mode, but the kernel prefers to set them
> for SGMII mode. When this happens and the PHY is soft reset, the BMSR
> status register is updated, but this happens after the kernel has already
> read the PHY abilities during probing. This results in support not being
> detected for, and the PHY not advertising support for, 10 and 100 Mbps
> modes, preventing the link from working with a non-gigabit link partner.
> 
> [...]

Here is the summary with links:
  - [net-next] net: phy: marvell: update abilities and advertising when switching to SGMII
    https://git.kernel.org/netdev/net-next/c/0ed99ecc95b9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


