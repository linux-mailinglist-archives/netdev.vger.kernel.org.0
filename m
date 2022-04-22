Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47C0E50B6B7
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 14:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447250AbiDVMDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 08:03:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1447214AbiDVMDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 08:03:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7F763F7;
        Fri, 22 Apr 2022 05:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1A4AB82CBD;
        Fri, 22 Apr 2022 12:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AFE4AC385AC;
        Fri, 22 Apr 2022 12:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650628812;
        bh=zQrMIPHuCAwcsFxTQf+xe50+KfMsAf58w2aK7PIWyxA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jRcyA83SgmjoxxcHSAymG7T0TD1JTJILZlhRnJF2er0gTxRBVzfdroFSwzLLbqrHR
         aImLb+UotcueB50SVhHlW25qipXa5PTScXHtLP4TwgMhpjGQQX1WxOuZORF5WjSwvK
         /ERY6qWXJHZHNdLwCsuHGaw9ldlpXbZ1lZOhSUVpzgSJF5Eidlp/oxR+noj7toGVLs
         vZ6+VDr5SlwC/G2uyzEqrJauoli5+18+QTg99Z2xso6OVw+sGK/PyJ/Xoxj3YzYxUm
         Mnt8Z6FrByS9PQWdrCUMxneKaRHAMSMvR3npr6JmNX9fP0RO6a7g44Plz9tn9Fmg9/
         UH/ot/smjjdSA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9664AE85D90;
        Fri, 22 Apr 2022 12:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] net: macb: Make ZynqMP SGMII phy configuration optional
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165062881261.32249.18140200057485548714.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Apr 2022 12:00:12 +0000
References: <1650452590-32948-1-git-send-email-radhey.shyam.pandey@xilinx.com>
In-Reply-To: <1650452590-32948-1-git-send-email-radhey.shyam.pandey@xilinx.com>
To:     Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org,
        nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, michals@xilinx.com,
        harinik@xilinx.com, git@xilinx.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 20 Apr 2022 16:33:08 +0530 you wrote:
> This patchset drop phy-names property from MACB node and also make
> SGMII Phy configuration optional. The motivation for this change
> is to support traditional usescase in which first stage bootloader
> does PS-GT configuration, and should still be supported in macb
> driver.
> 
> 
> [...]

Here is the summary with links:
  - [1/2] dt-bindings: net: cdns,macb: Drop phy-names property for ZynqMP SGMII PHY
    https://git.kernel.org/netdev/net-next/c/3ac8316e09b0
  - [2/2] net: macb: In ZynqMP initialization make SGMII phy configuration optional
    https://git.kernel.org/netdev/net-next/c/29e96fe9e0ec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


