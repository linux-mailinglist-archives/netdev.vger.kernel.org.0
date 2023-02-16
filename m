Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87B6C69942C
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 13:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjBPMUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 07:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjBPMUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 07:20:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EBD5359A;
        Thu, 16 Feb 2023 04:20:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9420B826AA;
        Thu, 16 Feb 2023 12:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66EBCC4339B;
        Thu, 16 Feb 2023 12:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676550020;
        bh=T+eqhOPEhX/3YmGw3VA36cZ9ZO1kX5yOpptGMfZQfBw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HTFVDxa++cuc2vDhMMuToKpYkpgZOryvngUN3OIBXSyBnqBh2LhvRVTXFBa0Y1pmd
         0P1NF8cvNmB5kO2cvvFSIwg0Oms8w32eRnAYgp0pq2wF+kOWdjf9GMc3Mq+7k7C8YP
         4Mbbiz2WJ2ZyFlN7qCpnmUqD4x67Cw4GV7v9j05dClV/T/bAKvX4idMHiM74IU3TFn
         n3tDYyJfnenxOWoiAw9UQ02+90YwW7Q2smHFCTfIF8LahCsgJdTfmETtX/GzWyxOYj
         f/AGgtrP7wAYwWXHFyzi8Tul3qtb/CoJ+TQS4OtEokh/vwLFEJy8xQiDjviu+pBFDX
         m2Bifc7Cu0L6Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 492AEE21EC3;
        Thu, 16 Feb 2023 12:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: ocelot: fix selecting MFD_OCELOT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167655002029.8163.12563431131032946888.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Feb 2023 12:20:20 +0000
References: <20230215104631.31568-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20230215104631.31568-1-lukas.bulwahn@gmail.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     colin.foster@in-advantage.com, vladimir.oltean@nxp.com,
        f.fainelli@gmail.com, kuba@kernel.org, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 15 Feb 2023 11:46:31 +0100 you wrote:
> Commit 3d7316ac81ac ("net: dsa: ocelot: add external ocelot switch
> control") adds config NET_DSA_MSCC_OCELOT_EXT, which selects the
> non-existing config MFD_OCELOT_CORE.
> 
> Replace this select with the intended and existing MFD_OCELOT.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
> 
> [...]

Here is the summary with links:
  - net: dsa: ocelot: fix selecting MFD_OCELOT
    https://git.kernel.org/netdev/net-next/c/f5b12be34249

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


