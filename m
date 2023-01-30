Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B94A268098F
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 10:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236471AbjA3JdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 04:33:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236204AbjA3JdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 04:33:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE7312E803;
        Mon, 30 Jan 2023 01:31:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31D29B80EBE;
        Mon, 30 Jan 2023 09:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C9CB0C4339B;
        Mon, 30 Jan 2023 09:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675071016;
        bh=ChZMOk/YstgkDoaODho1KbvmSn2xHocDCwOPLPDxQI4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O2KnTwXmBYFBBFb3iNO4n0ik1Z935EoilPQTF01d42KRzQ/VTuLMqHQ4wWLOXyMeA
         pIvi05h/0gRhp+2LXKMYLXfbHZs71OrrzdPfQenWuwQLzJNIco5flXwTKsFxzcoB62
         SO1xDqz+TNIWDHx4Ie+GaBF1Lv1juIo/7ECrxEKX6VzGZbZboMry19068nbbNvCNBh
         vUw7jyFvZRiq2k/ISVcWQ18deivFwkDVI0P7sjv5jp1sFBVSTTxpvGRsz3VGHivohd
         UTdEoCJJFlFk+5vELU0X9LsEGDIkin6Y8oFeRbwtxQuQeghtfjhDUmYhEcvZYYzZCH
         i2hOGKMiqZETw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AF692E21ED7;
        Mon, 30 Jan 2023 09:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net] net: phy: fix null dereference in phy_attach_direct
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167507101671.23681.13798327745838935441.git-patchwork-notify@kernel.org>
Date:   Mon, 30 Jan 2023 09:30:16 +0000
References: <20230127171427.265023-1-colin.foster@in-advantage.com>
In-Reply-To: <20230127171427.265023-1-colin.foster@in-advantage.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, xiaolei.wang@windriver.com,
        pabeni@redhat.com, kuba@kernel.org, edumazet@google.com,
        davem@davemloft.net, linux@armlinux.org.uk, hkallweit1@gmail.com,
        andrew@lunn.ch
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
by David S. Miller <davem@davemloft.net>:

On Fri, 27 Jan 2023 09:14:27 -0800 you wrote:
> Commit bc66fa87d4fd ("net: phy: Add link between phy dev and mac dev")
> introduced a link between net devices and phy devices. It fails to check
> whether dev is NULL, leading to a NULL dereference error.
> 
> Fixes: bc66fa87d4fd ("net: phy: Add link between phy dev and mac dev")
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> 
> [...]

Here is the summary with links:
  - [v1,net] net: phy: fix null dereference in phy_attach_direct
    https://git.kernel.org/netdev/net/c/73a876022273

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


