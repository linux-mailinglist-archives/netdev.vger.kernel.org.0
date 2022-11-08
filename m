Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEDF620661
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 03:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233272AbiKHCAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 21:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiKHCAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 21:00:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD551A07D;
        Mon,  7 Nov 2022 18:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4946B817C0;
        Tue,  8 Nov 2022 02:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57741C433D7;
        Tue,  8 Nov 2022 02:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667872815;
        bh=WPJXS3+wpSz4dtb1CWNy5hwjDCzVPOifqi2qEE1KGVM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XMbEycK39WIoljuyFkfprdtNKvLeQg+6gShWxAXWwWpq3azqPDRFt5BvzJFsb4BHW
         WXb5zCgMqEmrxBJ1amgDObAfKwiKVl/GJziSY5v0/LaZjwgEPUK+34kkunAgycR2EK
         IPJ8jDeoTNdONcIVIBl/4hYBGAz9ocVBvnMD0rM+EUo6OHotNhwDe7bMIXJBrDwVs8
         SsdQgZ/oh/56exjBFra3iUMtawlBqW2G2uxLJOUPDie+N/TrzY9+/1QsMruolUV3a3
         O/3ou0KkePh4Woy8dO3dhPZiklN1o+3i5EmMZO+FFByVf5qAb5lFkJkpz5DUL5Xj/M
         op92WgMUaGsiA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3223DC73FFC;
        Tue,  8 Nov 2022 02:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] dt-bindings: net: tsnep: Fix typo on generic nvmem
 property
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166787281519.2068.13306857950915060036.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Nov 2022 02:00:15 +0000
References: <20221104162147.1288230-1-miquel.raynal@bootlin.com>
In-Reply-To: <20221104162147.1288230-1-miquel.raynal@bootlin.com>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org, robh+dt@kernel.org,
        krzk+dt@kernel.org, devicetree@vger.kernel.org,
        gerhard@engleder-embedded.com
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

On Fri,  4 Nov 2022 17:21:47 +0100 you wrote:
> While working on the nvmem description I figured out this file had the
> "nvmem-cell-names" property name misspelled. Fix the typo, as
> "nvmem-cells-names" has never existed.
> 
> Fixes: 603094b2cdb7 ("dt-bindings: net: Add tsnep Ethernet controller")
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> 
> [...]

Here is the summary with links:
  - [net-next] dt-bindings: net: tsnep: Fix typo on generic nvmem property
    https://git.kernel.org/netdev/net/c/ec683f02a150

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


