Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493C8610EC5
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 12:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiJ1Kkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 06:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230448AbiJ1KkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 06:40:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D3632BB4
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 03:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2F7DB8293E
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 10:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4E3B5C43142;
        Fri, 28 Oct 2022 10:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666953616;
        bh=P7BusxBlT4IYzew06a07+NiXbO1Ib83AWIKltkfGhbA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OrXsT3IkFFtMZsBfhzAFlfSpDL5pZ+FFHzEDkhT9SXwWbDZp5ADsX4bgBM7EEzNWK
         FLvA6ebQE/yDhUPQEG4V0pC4Hms18oydXUUpVfQxBbsdK2c8sueDfq2/Pg7nYDKcNb
         GHOnITvgqEPuaWY+ZlekGOkeXXfXBwcNXsVqvTpEajPgR76Fw+yCmIO2OCmtMmiHPZ
         E1O36AXavDQrJlcWVKpVzD5ddecK7X2V5P357qdK9wLNX+saQEU10JVRSo/9lp3p12
         uHxFOUQfLgKjHB4SPKFJp9GRz1qks0r77IO06KbJBTwZFQ+P2Nwk5nihwTYtSgJ0SV
         of8jUPwC7xkFQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 35424C41676;
        Fri, 28 Oct 2022 10:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6 0/3] net: WangXun txgbe ethernet driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166695361621.9848.14608741474450050136.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Oct 2022 10:40:16 +0000
References: <20221027061116.683903-1-jiawenwu@trustnetic.com>
In-Reply-To: <20221027061116.683903-1-jiawenwu@trustnetic.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 27 Oct 2022 14:11:13 +0800 you wrote:
> This patch series adds support for WangXun 10 gigabit NIC, to initialize
> hardware, set mac address, and register netdev.
> 
> Change log:
> v6: address comments:
>     Jakub Kicinski: check with scripts/kernel-doc
> v5: address comments:
>     Jakub Kicinski: clean build with W=1 C=1
> v4: address comments:
>     Andrew Lunn: https://lore.kernel.org/all/YzXROBtztWopeeaA@lunn.ch/
> v3: address comments:
>     Andrew Lunn: remove hw function ops, reorder functions, use BIT(n)
>                  for register bit offset, move the same code of txgbe
>                  and ngbe to libwx
> v2: address comments:
>     Andrew Lunn: https://lore.kernel.org/netdev/YvRhld5rD%2FxgITEg@lunn.ch/
> 
> [...]

Here is the summary with links:
  - [net-next,v6,1/3] net: txgbe: Store PCI info
    https://git.kernel.org/netdev/net-next/c/a34b3e6ed8fb
  - [net-next,v6,2/3] net: txgbe: Reset hardware
    https://git.kernel.org/netdev/net-next/c/b08012568ebb
  - [net-next,v6,3/3] net: txgbe: Set MAC address and register netdev
    https://git.kernel.org/netdev/net-next/c/d21d2c7f586c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


