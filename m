Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 529F4645D8D
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 16:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiLGPUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 10:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbiLGPUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 10:20:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652DF5C0D0
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 07:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E57CC60BC6
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 15:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 494E0C433D7;
        Wed,  7 Dec 2022 15:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670426417;
        bh=RN4voQl/6YnlzLeY7U/Ot3fGJxdHZWmf5s1RTBcMD/k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ssHFdfqbyR1YERTE7Z+xOeVOomHGqHa+YgDlU6k0rr+jh/MrzXrteNLz9aybJmkpi
         i99lt+aZMslF3cjX3ovItVZRufVXaQdsQigvArI0maZS3A4SSEELwi9soBPcplAI79
         PMWxwumssJ9JDT0/ss+9o9Bk/Eflzob1+zPJhdlCEjdI3RbcegqYAGaAtoM+HcKoo0
         K+vqOb46JYwzjzY/lPnxRU2VQb1luqMGZxGTsNJZjM3Lb73x0RzWl23msHXoeqXO8L
         iIU6JVmGwtVax0lIfK7r6g1E4kITlyjhJQK90k5QQAUKPRd9NyykyFlYftcuyHxx2j
         TFEINtXGxS0Rw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2C9EBE270CF;
        Wed,  7 Dec 2022 15:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: accept phy-mode = "internal" for
 internal PHY ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167042641717.25218.8941759413511080187.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Dec 2022 15:20:17 +0000
References: <20221205194845.2131161-1-vladimir.oltean@nxp.com>
In-Reply-To: <20221205194845.2131161-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        kabel@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        tharvey@gateworks.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon,  5 Dec 2022 21:48:45 +0200 you wrote:
> The ethernet-controller dt-schema, mostly pushed forward by Linux, has
> the "internal" PHY mode for denoting MAC connections to an internal PHY.
> 
> U-Boot may provide device tree blobs where this phy-mode is specified,
> so make the Linux driver accept them.
> 
> It appears that the current behavior with phy-mode = "internal" was
> introduced when mv88e6xxx started reporting supported_interfaces to
> phylink. Prior to that, I don't think it would have any issues accepting
> this phy-mode.
> 
> [...]

Here is the summary with links:
  - [net] net: dsa: mv88e6xxx: accept phy-mode = "internal" for internal PHY ports
    https://git.kernel.org/netdev/net/c/87a39882b5ab

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


