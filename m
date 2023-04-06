Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 915AF6D8D4E
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 04:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbjDFCKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 22:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbjDFCKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 22:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49CB959F9
        for <netdev@vger.kernel.org>; Wed,  5 Apr 2023 19:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DAAB362CF8
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 02:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4931EC433A1;
        Thu,  6 Apr 2023 02:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680747018;
        bh=N2jYoPNNJhAjGX4xjW/S9IfW6yuURkdAykIcmIyOxv0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r4iV3y3W/CFQNYGTnrnCP7cy+fElMVebej5tiJplNlgB2a/uXNZqkmJKe9vs/o63w
         GGnxpSEWCrjG9jOd+BjQ8m6n6jto0CA29IIyllJ0ni1hmINk1dE2a6BSsWk7u10arZ
         Oec6B0IL+9WugYT6n3RFPUFVjC6iklFVjEoLr0iKCNTJ/7wopB8bCfz+uvLxOyrx8k
         1BvEXprjYXeSe4eCmQG2dk1cdJsHjLK5m9xzFjua8pb6jUhTEKH5Y1VZrpdQ1CdsXu
         0mMuMbYhe/+a1Zy9eDg0gYVzktn5mPLGKVxHix5F5tNXQctNQNxeAf2sBkzP+2VJFR
         T/ThNKy08pEHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 195BCC395D8;
        Thu,  6 Apr 2023 02:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: fec: make use of MDIO C45 quirk
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168074701809.16861.560454477705826551.git-patchwork-notify@kernel.org>
Date:   Thu, 06 Apr 2023 02:10:18 +0000
References: <20230404052207.3064861-1-gerg@linux-m68k.org>
In-Reply-To: <20230404052207.3064861-1-gerg@linux-m68k.org>
To:     Greg Ungerer <gerg@linux-m68k.org>
Cc:     wei.fang@nxp.com, shenwei.wang@nxp.com, xiaoning.wang@nxp.com,
        linux-imx@nxp.com, netdev@vger.kernel.org, andrew@lunn.ch
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  4 Apr 2023 15:22:07 +1000 you wrote:
> Not all fec MDIO bus drivers support C45 mode transactions. The older fec
> hardware block in many ColdFire SoCs does not appear to support them, at
> least according to most of the different ColdFire SoC reference manuals.
> The bits used to generate C45 access on the iMX parts, in the OP field
> of the MMFR register, are documented as generating non-compliant MII
> frames (it is not documented as to exactly how they are non-compliant).
> 
> [...]

Here is the summary with links:
  - net: fec: make use of MDIO C45 quirk
    https://git.kernel.org/netdev/net/c/abc33494ddd5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


