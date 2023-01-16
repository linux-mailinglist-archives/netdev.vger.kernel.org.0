Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A614866C016
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbjAPNuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjAPNuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:50:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40DC21F5C5;
        Mon, 16 Jan 2023 05:50:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE6A5B80F10;
        Mon, 16 Jan 2023 13:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8377EC433D2;
        Mon, 16 Jan 2023 13:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877018;
        bh=1Bfs/z3ibodGnKq2wGXOTNR92Q2ckR0xxrvlvCBpvqg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SOor88vo2e4JRa0h3LkBkVP3mY7aKUfVnWzWUuRdBTD0paLK1v85IJlU7Y5l8ZeU+
         lUbPdZ9hoaFZXHZbI06QA83X39kpxK1Ed6av8wWVMfdm8nUsQCsBK9Db5o5dipoTxZ
         AzQHo1jk54xLk4gqwAIt+Svogn7LU1j+5p5YakKH3z8XyzhXPk28v1rxtW+HKRAsTD
         5cH0PR36E1bbnHBkt9pGilj3RoVB65XouH3UJuG22bTpTzrzmv1ijiPu6B1uRYW7fP
         xnC7l1BfOsall1m5A34m7LmDBMfrmitORuTUSRbfr2rcWhJ8sT8p+9c5/9jvg+3GWN
         NzXj+yVmq/SFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 69C54E54D2E;
        Mon, 16 Jan 2023 13:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/8] Add support for two classes of VCAP rules
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167387701842.13526.15302586636454079420.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Jan 2023 13:50:18 +0000
References: <20230114134242.3737446-1-steen.hegelund@microchip.com>
In-Reply-To: <20230114134242.3737446-1-steen.hegelund@microchip.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com,
        rdunlap@infradead.org, casper.casan@gmail.com,
        rmk+kernel@armlinux.org.uk, wanjiabing@vivo.com, nhuck@google.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Steen.Hegelund@microchip.com,
        daniel.machon@microchip.com, horatiu.vultur@microchip.com,
        lars.povlsen@microchip.com, error27@gmail.com, michael@walle.cc
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat, 14 Jan 2023 14:42:34 +0100 you wrote:
> This adds support for two classes of VCAP rules:
> 
> - Permanent rules (added e.g. for PTP support)
> - TC user rules (added by the TC userspace tool)
> 
> For this to work the VCAP Loopups must be enabled from boot, so that the
> "internal" clients like PTP can add rules that are always active.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/8] net: microchip: vcap api: Erase VCAP cache before encoding rule
    https://git.kernel.org/netdev/net-next/c/6573f71ae72f
  - [net-next,v4,2/8] net: microchip: sparx5: Reset VCAP counter for new rules
    https://git.kernel.org/netdev/net-next/c/95fa74148daa
  - [net-next,v4,3/8] net: microchip: vcap api: Always enable VCAP lookups
    https://git.kernel.org/netdev/net-next/c/01ef75a257fa
  - [net-next,v4,4/8] net: microchip: vcap api: Convert multi-word keys/actions when encoding
    https://git.kernel.org/netdev/net-next/c/33e3a273fd4f
  - [net-next,v4,5/8] net: microchip: vcap api: Use src and dst chain id to chain VCAP lookups
    https://git.kernel.org/netdev/net-next/c/cfd9e7b74a1e
  - [net-next,v4,6/8] net: microchip: vcap api: Check chains when adding a tc flower filter
    https://git.kernel.org/netdev/net-next/c/784c3067d094
  - [net-next,v4,7/8] net: microchip: vcap api: Add a storage state to a VCAP rule
    https://git.kernel.org/netdev/net-next/c/814e7693207f
  - [net-next,v4,8/8] net: microchip: vcap api: Enable/Disable rules via chains in VCAP HW
    https://git.kernel.org/netdev/net-next/c/18a15c769d4a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


