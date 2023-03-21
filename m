Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7F96C3146
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 13:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjCUMKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 08:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjCUMKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 08:10:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8EC2E0D5
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 05:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0E9A6198C
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 12:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 57C4DC433D2;
        Tue, 21 Mar 2023 12:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679400617;
        bh=gkGyoTxIc8FOFzV4exDAjPL/q9EMt70f5mA+SD4HQDI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Sp4oZXRCcZizf3l1qivaC3sFjq6/XJBne7KrCTZ/CgbibCPibED+nds+PoTXYFzTa
         dA/N+K1La3+tYvFHqRT6NvOVt4HUIPLI7pjJodx751v4ogiTawktZojWn7bVSQzRXc
         76uL2JN7wP7t+IicqnwFxvHrQ5FJl1PVCjTT6cBZvyK9plF60oCoDX4xaDWUim/tuN
         7d7lPyzT11338ovlwk+i63a09QXBT+Vb33RCYcXoB++kP2/1pSm5Kb1KjNr7OL10xd
         2pfzhlJYbWFj8tuZDDj0apFJy/K3gUIQdJjgsuzPFb+RNv0Xb03AlliM67t90VgFJv
         mClqojknPcYGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3C7B8E66C98;
        Tue, 21 Mar 2023 12:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: fix mdio bus' phy_mask member
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167940061724.8307.7866437512253631602.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Mar 2023 12:10:17 +0000
References: <20230319140238.9470-1-kabel@kernel.org>
In-Reply-To: <20230319140238.9470-1-kabel@kernel.org>
To:     =?utf-8?q?Marek_Beh=C3=BAn_=3Ckabel=40kernel=2Eorg=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, olteanv@gmail.com,
        klaus.kudielka@gmail.com, f.fainelli@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 19 Mar 2023 15:02:38 +0100 you wrote:
> Commit 2c7e46edbd03 ("net: dsa: mv88e6xxx: mask apparently non-existing
> phys during probing") added non-trivial bus->phy_mask in
> mv88e6xxx_mdio_register() in order to avoid excessive mdio bus
> transactions during probing.
> 
> But the mask is incorrect for switches with non-zero phy_base_addr (such
> as 88E6341).
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: mv88e6xxx: fix mdio bus' phy_mask member
    https://git.kernel.org/netdev/net-next/c/a4926c2943dd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


