Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3DAC510D75
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 02:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356504AbiD0Axe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 20:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356498AbiD0Ax1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 20:53:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FD21208D
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 17:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B0B3E61AF5
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 00:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 082C4C385AF;
        Wed, 27 Apr 2022 00:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651020612;
        bh=lrydYJjF8fl5pv7H7jwOfVqnpBXMFfGcvaZeDdva/Fg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MoZ1FVIDiB5o8z/s3NkMXhO/Xi8ksCvjfr1fdGZthOaGEMXyv1oy/gvJcrrLMuWkg
         pEPhr//c53V9o4fqWeV8OVN9FA+fx0hr+iQNt7vPdJOFg17bgn9UPu7cwrNvMnMktA
         o2Y1j0jrR0hxlE756del3m4OM9n37Bs88Dmmv+EDVg6vBCWyfseF/PYFKR/fpu2v/U
         aGgIfVLUlEQHY4ZvN8EVCUxeOSATI3pgseRdTi6blbU/i+DXPqWEQgeIw308AML4t1
         zJEKGX6VUDs5A1mrbZOpb52a6T7fDjGMLUpIFfyqXMNnv+K+5MFRI/cck63M/w0s9A
         FViFwR96nJcFA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E06D2F03841;
        Wed, 27 Apr 2022 00:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: mt753x: fix pcs conversion regression
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165102061191.18100.15381630708714680923.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Apr 2022 00:50:11 +0000
References: <E1nj6FW-007WZB-5Y@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1nj6FW-007WZB-5Y@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     Landen.Chao@mediatek.com, dqfext@gmail.com, sean.wang@mediatek.com,
        daniel@makrotopia.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 25 Apr 2022 22:28:02 +0100 you wrote:
> Daniel Golle reports that the conversion of mt753x to phylink PCS caused
> an oops as below.
> 
> The problem is with the placement of the PCS initialisation, which
> occurs after mt7531_setup() has been called. However, burited in this
> function is a call to setup the CPU port, which requires the PCS
> structure to be already setup.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dsa: mt753x: fix pcs conversion regression
    https://git.kernel.org/netdev/net-next/c/fae463084032

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


