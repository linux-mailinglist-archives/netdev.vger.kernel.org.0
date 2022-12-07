Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A359064526F
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 04:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbiLGDKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 22:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLGDKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 22:10:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F71245A3E
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 19:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43861B81C9B
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 03:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DFF02C433D7;
        Wed,  7 Dec 2022 03:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670382616;
        bh=mNMSPGbzg/0UGgEUC7v7ezyBy9Mcw9F8GuS+9+Z/u7Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EnMg7h9CJsKSqgpcCNS2LbFTySdgowVEFa0Hohoo8bfzQ5uSNs0sHBSeQffHwP1fE
         2DE8n8nJ+qxvN7LAURSji0do2z29TvD7+HZZKEa/E2llhOH5g56JCS30w98w2oZ47I
         bEHyTYTXI/HEdk9R0vDrxHv3lchEbSOr64Dy2hxOcNI3GxqGMbNbs9/1fXyuNYyknD
         cmRzEfmE9S0e1rs1vaW7Str2Yddza6VHBYxXEm6yabnV4rsZBDLsGiQNDEXMJ6f+82
         7YO5mMe93o0o6jcSba771jLrp1+P3Tag+tYj1IJuw829mBtL1Cf8/FDCyosfI/MJb+
         NlOcLqHi2OjZA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C5FBBE56AA2;
        Wed,  7 Dec 2022 03:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net: sfp: clean up i2c-bus property parsing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167038261680.31129.14108338151143138467.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Dec 2022 03:10:16 +0000
References: <E1p1WGJ-0098wS-4w@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1p1WGJ-0098wS-4w@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 03 Dec 2022 17:25:15 +0000 you wrote:
> We currently have some complicated code in sfp_probe() which gets the
> I2C bus depending on whether the sfp node is DT or ACPI, and we use
> completely separate lookup functions.
> 
> This could do with being in a separate function to make the code more
> readable, so move it to a new function, sfp_i2c_get(). We can also use
> fwnode_find_reference() to lookup the I2C bus fwnode before then
> decending into fwnode-type specific parsing.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: sfp: clean up i2c-bus property parsing
    https://git.kernel.org/netdev/net-next/c/15309fb26b87

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


