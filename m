Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F785565115
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 11:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbiGDJkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 05:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiGDJkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 05:40:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F088B21A4
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 02:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8658061414
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 09:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E25B5C341CA;
        Mon,  4 Jul 2022 09:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656927614;
        bh=B5MaxqKOU4L4Y/leFdcY1ZKe7qkud51naZaUOnZt8Zc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=om7ExKmulsp2R1jPEcUlvQQMlDeOfucT7DN1DM7Q557SmG2F03Zxo7AZ+NJMQDwNN
         yOd8YgKQka2f6QK4y8e/cAZpnOYQ3mwattrqG6y7yTXfZllNuL7kGqzKOM3gxfu+cK
         O/MO69SbKftU9hyqnx/ZJHV0Ns2Dmx6YwtoDBypnZWFz3ZGDqo0xsFvaZBJVUbK1+n
         YvLmYZi/aX4V99skQRGikcr1FuJLI0RGyQDnyeCukMDFqzoyiXVctLh6WAJOHXgCUQ
         qlXmEfjnX3CdtBfHCErVUhRaib7prDXPz1SJhLqWqTD0A1Zx1V7MaIm+Egz/R5PU9e
         28trfhmiIpoYQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C77B7E45BDB;
        Mon,  4 Jul 2022 09:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: broadcom: Add support for BCM53128
 internal PHYs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165692761481.15750.8517791391616718062.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Jul 2022 09:40:14 +0000
References: <20220701175606.22586-1-kurt@linutronix.de>
In-Reply-To: <20220701175606.22586-1-kurt@linutronix.de>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  1 Jul 2022 19:56:06 +0200 you wrote:
> Add support for BCM53128 internal PHYs. These support interrupts as well as
> statistics. Therefore, enable the Broadcom PHY driver for them.
> 
> Tested on BCM53128 switch using the mainline b53 DSA driver.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next] net: phy: broadcom: Add support for BCM53128 internal PHYs
    https://git.kernel.org/netdev/net-next/c/39bfb3c12d79

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


