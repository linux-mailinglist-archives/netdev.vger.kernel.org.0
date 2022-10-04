Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D70FB5F3A3E
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 02:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiJDAAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 20:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229985AbiJDAAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 20:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DDD14013
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 17:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F407AB816DA
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 00:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A64DCC433C1;
        Tue,  4 Oct 2022 00:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664841614;
        bh=WEKQWmwRBAPQ0oLaNNqshG2rXzOd3OpdDAypWWQVPMI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LqWRaV8tlgS8jhund1iJXIu6zERmo9hdvYTZwkbY8Bgw6zOMqM9+v0LJIMnoU3T8J
         /i4/0Yqoez7DplxPH5KDEEexyrLZG77QK5L0HR4CgWDshAqdQnrZJLUAh97I9MGqBG
         artq1Y3JvUN2ouNDdpmUeGCM7g1Iq0D43xNAa4GFMtry6S+IFKNFjs/AP84TwnMBWw
         ul/l2Jn0c3/EzQSy/AsS9uSZ3byDAS6YrsZrFUFO1T7fY6Id/I2taLhQ36rO1ua3zn
         +54i7uOvpcGInPGVXAC7hGR17Vn9K06EImT+1ZcvlHaGfMdW5MJhcn+nkZh8dNHUGp
         9BekwLf6cthfg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 81C5FE4D013;
        Tue,  4 Oct 2022 00:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mvpp2: fix mvpp2 debugfs leak
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166484161452.2431.4721974681787225608.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Oct 2022 00:00:14 +0000
References: <E1ofOAB-00CzkG-UO@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1ofOAB-00CzkG-UO@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     davem@davemloft.net, kuba@kernel.org, sashal@kernel.org,
        gregkh@linuxfoundation.org, mw@semihalf.com, edumazet@google.com,
        pabeni@redhat.com, maxime.chevallier@bootlin.com,
        netdev@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 03 Oct 2022 17:19:27 +0100 you wrote:
> When mvpp2 is unloaded, the driver specific debugfs directory is not
> removed, which technically leads to a memory leak. However, this
> directory is only created when the first device is probed, so the
> hardware is present. Removing the module is only something a developer
> would to when e.g. testing out changes, so the module would be
> reloaded. So this memory leak is minor.
> 
> [...]

Here is the summary with links:
  - [net] net: mvpp2: fix mvpp2 debugfs leak
    https://git.kernel.org/netdev/net/c/0152dfee235e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


