Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2DBC4D9407
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 06:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344991AbiCOFl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 01:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbiCOFlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 01:41:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518FE2B26C;
        Mon, 14 Mar 2022 22:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91E4BB81100;
        Tue, 15 Mar 2022 05:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 489AAC340F3;
        Tue, 15 Mar 2022 05:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647322810;
        bh=9r5OhvP++g8/Va83TnjKfdGMFCiNZ57H86PhNszE5pk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Jyq8HcCfWGM1TGGYHPlap8BFTKkBPBI/i29RDmWkVC73DxsfBjbQNBD9LmVKSQa+f
         iKptQAzxOZO/gvSCaOB/3lw4s+26OyhDtsv9Nb7WQ2NFdRSk8GpBUuO1pThkGX0S2v
         19UIZBMgYBSFE9WOBb/3ANC7l5nMYD3pATqnhiMubpasB2BPxd70cWRYHEtFIHV8RE
         m1s/PYHzmcug8PT05VQx7TMQRF4oX+pGGJ73QfKyEmmZ3k5wLzifDTP3iwlaz4ca7p
         f4Py3S+dhQUQ33pjHKL4cpX6O8FGdwUH6AYgCCgavYOoNQ/zHx7hnpmsxIWGaaWjzC
         nT1jFO/fFO+jA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 249A9E6D44B;
        Tue, 15 Mar 2022 05:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mdio: mscc-miim: fix duplicate debugfs entry
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164732281014.21925.130990419485776526.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Mar 2022 05:40:10 +0000
References: <20220312224140.4173930-1-michael@walle.cc>
In-Reply-To: <20220312224140.4173930-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org,
        colin.foster@in-advantage.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 12 Mar 2022 23:41:40 +0100 you wrote:
> This driver can have up to two regmaps. If the second one is registered
> its debugfs entry will have the same name as the first one and the
> following error will be printed:
> 
> [    3.833521] debugfs: Directory 'e200413c.mdio' with parent 'regmap' already present!
> 
> Give the second regmap a name to avoid this.
> 
> [...]

Here is the summary with links:
  - [net] net: mdio: mscc-miim: fix duplicate debugfs entry
    https://git.kernel.org/netdev/net/c/0f8946ae704a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


