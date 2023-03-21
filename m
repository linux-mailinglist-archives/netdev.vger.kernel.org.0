Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 417C06C31B6
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 13:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjCUMaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 08:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjCUMaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 08:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BAC61FC8
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 05:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3110561794
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 12:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 815AAC433D2;
        Tue, 21 Mar 2023 12:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679401818;
        bh=QaE0JGfcrtNEBvxHbQI519nOguGhfUh5vgcNp0czjTI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c3tA7JyrDvseCo7DTLjKUaePA3Ze3OQJJDKqUgM6aJx81hWEP9wzYC/dbH3vSi9sv
         jn6hB4R977ggK8UDTiV0B6GPJXBKNWE0ID9hrEZTjT6y+KHVcvw0eO+VXwQ59411UM
         5xAJSsCYlrvgl1iUmO6N5AKhSOwyxeTKZGnPnsi+s9jM5FG1ZRFA7kbtiRUYrUv7IM
         pg3lD7yZa2QWUJX+lYBmJRnat1NGL7WC+q4qUYnRnGDV2V/fh0JG5/FsOiJoWh/hSH
         3CZTdhTTd8tqHQ2E6eTKOI/Hy1UCdeGh+6pYFmosgmwDXehiA8K9G6yaDVL3GP8TQ9
         +4lw4YdHYzVEg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5F858E66C9A;
        Tue, 21 Mar 2023 12:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: qca8k: remove assignment of an_enabled in
 pcs_get_state()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167940181838.17617.13250880331142888193.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Mar 2023 12:30:18 +0000
References: <E1pdsE5-00Dl2l-8F@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1pdsE5-00Dl2l-8F@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, noodles@earth.li,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 19 Mar 2023 12:33:29 +0000 you wrote:
> pcs_get_state() implementations are not supposed to alter an_enabled.
> Remove this assignment.
> 
> Fixes: b3591c2a3661 ("net: dsa: qca8k: Switch to PHYLINK instead of PHYLIB")
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/dsa/qca/qca8k-8xxx.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - [net-next] net: dsa: qca8k: remove assignment of an_enabled in pcs_get_state()
    https://git.kernel.org/netdev/net-next/c/9ef70d0130f2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


