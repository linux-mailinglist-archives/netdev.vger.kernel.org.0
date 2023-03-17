Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01C506BDDA5
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 01:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjCQAaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 20:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjCQAaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 20:30:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4BC3D0A6;
        Thu, 16 Mar 2023 17:30:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 18BC8CE1EB3;
        Fri, 17 Mar 2023 00:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5BE1BC4339B;
        Fri, 17 Mar 2023 00:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679013020;
        bh=7o1ndXGP2MiYrjcAv7VYkvDlwwEmyLWC3DDj4rMPu2o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sjxz0sl1/1SZyg81mhKLeb+vKYPjoaSoFJQfypeYNQarmfVsyKYWvhGJg40vhxabn
         QyrqFTFuL3H+kWy58zNotAC0eskNgbJ1lh68f7kFhJXid9RnBER6v4kN0+De8rslGs
         B8hCgTuFtqluLOfh58SobkARcDlPpYo53mDKFqlR2LPtWgM3R9IrZgtzEGdZEyCfyq
         RQ/5EQT+E4PavAoMzRB76hkUSwz6D+fsT6KhxIgOEeIQ5fdg868PG/fNeDpeeZAJ4a
         NzRtTuxPErRQxCYdOvvYoUhgbuiNu7uQ2Zrc2YwI42APy3LiyTZzDZlQyYGbF7vqMd
         Nxhi4lATlsJgg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 36994E4D002;
        Fri, 17 Mar 2023 00:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] net: renesas: set 'mac_managed_pm' at probe time
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167901302021.26766.6629035403026123851.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 00:30:20 +0000
References: <20230315074115.3008-1-wsa+renesas@sang-engineering.com>
In-Reply-To: <20230315074115.3008-1-wsa+renesas@sang-engineering.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 15 Mar 2023 08:41:13 +0100 you wrote:
> When suspending/resuming an interface which was not up, we saw mdiobus
> related PM handling despite 'mac_managed_pm' being set for RAVB/SH_ETH.
> Heiner kindly suggested the fix to set this flag at probe time, not at
> init/open time. I implemented his suggestion and it works fine on these
> two Renesas drivers.
> 
> Changes since v1:
> * added tag from Michal (thanks!)
> * split out patches which are for 'net' only (Thanks, Simon!)
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] ravb: avoid PHY being resumed when interface is not up
    https://git.kernel.org/netdev/net/c/7f5ebf5dae42
  - [net,v2,2/2] sh_eth: avoid PHY being resumed when interface is not up
    https://git.kernel.org/netdev/net/c/c6be7136afb2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


