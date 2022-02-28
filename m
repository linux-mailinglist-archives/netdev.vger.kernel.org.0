Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A51404C6B46
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 12:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbiB1Lu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 06:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236013AbiB1Luv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 06:50:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FA8710F1
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 03:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A109EB810DD
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 11:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D4E3C340F3;
        Mon, 28 Feb 2022 11:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646049010;
        bh=U/Q+voR/Rtc3rNbAs8/WPks6WvuNWvJ+gS9nrmNAfio=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Lzn0g9g9yRZ4vkGQclO+WUUMYZWJYXApfr9bRSue1r1u9cMNtcd1vTQXUZI8BSiBC
         7v7siofwbcxB6LNdcg3GUpozJ9ftJxiAkFvzcTFz6dHxi/7lu9A8IrLPEeXeQYkxk8
         ivm9PHwm5ugiGvU4tul4CIM4C8jTUgGlku8WbqFH8COiPgY/Luury1l0aciP/eM82D
         KvRoV6i9rSVsd7AvLSVlUcIeUk2MWZB20js0bZUdjEbP9fi1dXTaGd1IRgRVStQUS7
         P1ECwzIjVeD4oeKKFEgecF7d+ngqDyEIYT8kiMZjvKIvmx2tHh9nh04AV4xulJCVsW
         FKEvrKrFG//cA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 36F44E6D4BB;
        Mon, 28 Feb 2022 11:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sparx5: Add #include to remove warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164604901022.16787.13047804859844827596.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Feb 2022 11:50:10 +0000
References: <20220225124327.ef4uzmeo3imnxrvv@wse-c0155>
In-Reply-To: <20220225124327.ef4uzmeo3imnxrvv@wse-c0155>
To:     Casper Andersson <casper.casan@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri, 25 Feb 2022 13:43:27 +0100 you wrote:
> main.h uses NUM_TARGETS from main_regs.h, but
> the missing include never causes any errors
> because everywhere main.h is (currently)
> included, main_regs.h is included before.
> But since it is dependent on main_regs.h
> it should always be included.
> 
> [...]

Here is the summary with links:
  - [net] net: sparx5: Add #include to remove warning
    https://git.kernel.org/netdev/net/c/90d402528574

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


