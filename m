Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0E54A739A
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 15:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345128AbiBBOuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 09:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345125AbiBBOuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 09:50:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2DF9C061714;
        Wed,  2 Feb 2022 06:50:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FF1760B8A;
        Wed,  2 Feb 2022 14:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6D90C340EB;
        Wed,  2 Feb 2022 14:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643813414;
        bh=0Lyfnvij/5gGncnyr/u8/K/FKzma9y5FVY7+KvpdqYU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kSgA/pLlVzBlhNR3sJHpGtbGlC0b906kH97WxYgg5pg0O+8TBAvJ2BU1YE3Wf19kw
         UbUOMVeDScgQ87NKGiGTOtUYI6Uqdim/J5l1u/xttfKPcr45gIgBnnXVGJz8pllP7V
         1bX9HAn7IRjgi6wBxDCb574xguSqrNOHk8Zvf3axoLn5VxmDwA447XYf+HTmt6+hU2
         Cnle9lrkzTmmpvrhZL4dsfPZId7gI360rN0fdRALGjh3LmFy5oXM6ygck/F0Wdi0pt
         dHroxvmZZWY5xZStfQjanqDEr7jb9ILOfJ0eHGrmGO0kyE6tXmNASmpY8zTKzYbMLy
         6OcJS5oCi286A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C7BFFE5D07E;
        Wed,  2 Feb 2022 14:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v8 00/16] Add support for qca8k mdio rw in Ethernet
 packet
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164381341380.24396.15212921424557438012.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Feb 2022 14:50:13 +0000
References: <20220202000335.19296-1-ansuelsmth@gmail.com>
In-Reply-To: <20220202000335.19296-1-ansuelsmth@gmail.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  2 Feb 2022 01:03:19 +0100 you wrote:
> Hi, this is ready but require some additional test on a wider userbase.
> 
> The main reason for this is that we notice some routing problem in the
> switch and it seems assisted learning is needed. Considering mdio is
> quite slow due to the indirect write using this Ethernet alternative way
> seems to be quicker.
> 
> [...]

Here is the summary with links:
  - [net-next,v8,01/16] net: dsa: provide switch operations for tracking the master state
    https://git.kernel.org/netdev/net-next/c/295ab96f478d
  - [net-next,v8,02/16] net: dsa: replay master state events in dsa_tree_{setup,teardown}_master
    https://git.kernel.org/netdev/net-next/c/e83d56537859
  - [net-next,v8,03/16] net: dsa: tag_qca: convert to FIELD macro
    https://git.kernel.org/netdev/net-next/c/6b0458299297
  - [net-next,v8,04/16] net: dsa: tag_qca: move define to include linux/dsa
    https://git.kernel.org/netdev/net-next/c/3ec762fb13c7
  - [net-next,v8,05/16] net: dsa: tag_qca: enable promisc_on_master flag
    https://git.kernel.org/netdev/net-next/c/101c04c3463b
  - [net-next,v8,06/16] net: dsa: tag_qca: add define for handling mgmt Ethernet packet
    https://git.kernel.org/netdev/net-next/c/c2ee8181fddb
  - [net-next,v8,07/16] net: dsa: tag_qca: add define for handling MIB packet
    https://git.kernel.org/netdev/net-next/c/18be654a4345
  - [net-next,v8,08/16] net: dsa: tag_qca: add support for handling mgmt and MIB Ethernet packet
    https://git.kernel.org/netdev/net-next/c/31eb6b4386ad
  - [net-next,v8,09/16] net: dsa: qca8k: add tracking state of master port
    https://git.kernel.org/netdev/net-next/c/cddbec19466a
  - [net-next,v8,10/16] net: dsa: qca8k: add support for mgmt read/write in Ethernet packet
    https://git.kernel.org/netdev/net-next/c/5950c7c0a68c
  - [net-next,v8,11/16] net: dsa: qca8k: add support for mib autocast in Ethernet packet
    https://git.kernel.org/netdev/net-next/c/5c957c7ca78c
  - [net-next,v8,12/16] net: dsa: qca8k: add support for phy read/write with mgmt Ethernet
    https://git.kernel.org/netdev/net-next/c/2cd548566384
  - [net-next,v8,13/16] net: dsa: qca8k: move page cache to driver priv
    https://git.kernel.org/netdev/net-next/c/4264350acb75
  - [net-next,v8,14/16] net: dsa: qca8k: cache lo and hi for mdio write
    https://git.kernel.org/netdev/net-next/c/2481d206fae7
  - [net-next,v8,15/16] net: dsa: qca8k: add support for larger read/write size with mgmt Ethernet
    https://git.kernel.org/netdev/net-next/c/90386223f44e
  - [net-next,v8,16/16] net: dsa: qca8k: introduce qca8k_bulk_read/write function
    https://git.kernel.org/netdev/net-next/c/4f3701fc5998

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


