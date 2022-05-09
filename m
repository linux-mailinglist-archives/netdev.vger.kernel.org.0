Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 555C351FE94
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 15:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236152AbiEINoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 09:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236112AbiEINoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 09:44:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8885E262701
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 06:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1ACED61563
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 13:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 653C6C385AF;
        Mon,  9 May 2022 13:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652103614;
        bh=YNaYIk4jdaSF8uQN66zxjJy83R5wm5YQUaGK+dsNnqY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=THDMJ14m50SPBLRARm+iH5W6Q2iKL5ml5TidJc+QLHJrUZaz6MfcXVUFPYNAIcDC7
         cFErJETL3xL+Fpg4Trg4KUzBnBHAqM3aTXr7ajhc8mMtv+1Jph+FWJKbIXU7pDorc7
         Q4Q4fN+hrJ/QvYoW1/AL/fSi3NW5CHkzLOPMXJJl/9mFe01lNnWDjqk94b12jBbjR7
         jWqQP7XwneyDjQUtT1auneQHI0B52HgjsS4xdZcbchvhKzbaSsgxbZLaUh5FUsb1u6
         Vny4ZUy4xxtJJbIDbSX4wN6tu8YdiZ5b7QNYt5J6uKj8QJ8BORoXdWtndKGS6jUHqE
         fyf8TlbCKAgYQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3C633F03927;
        Mon,  9 May 2022 13:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next 0/2] net: phy: add LAN8742 phy support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165210361423.30657.3972779184170370201.git-patchwork-notify@kernel.org>
Date:   Mon, 09 May 2022 13:40:14 +0000
References: <20220505181252.32196-1-yuiko.oshino@microchip.com>
In-Reply-To: <20220505181252.32196-1-yuiko.oshino@microchip.com>
To:     Yuiko Oshino <yuiko.oshino@microchip.com>
Cc:     woojung.huh@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, andrew@lunn.ch, ravi.hegde@microchip.com,
        UNGLinuxDriver@microchip.com, kuba@kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 5 May 2022 11:12:50 -0700 you wrote:
> add LAN8742 phy support
> update LAN88xx phy ID and phy ID mask so that it can coexist with LAN8742
> 
> The current phy IDs on the available hardware.
>     LAN8742 0x0007C130, 0x0007C131
>     LAN88xx 0x0007C132
> 
> [...]

Here is the summary with links:
  - [v4,net-next,1/2] net: phy: microchip: update LAN88xx phy ID and phy ID mask.
    https://git.kernel.org/netdev/net-next/c/e078286a1375
  - [v4,net-next,2/2] net: phy: smsc: add LAN8742 phy support.
    https://git.kernel.org/netdev/net-next/c/53ad22868289

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


