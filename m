Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB04C6076ED
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 14:30:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbiJUMa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 08:30:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiJUMaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 08:30:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05E14FA011
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 05:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87430B82BCF
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 12:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 37167C433D7;
        Fri, 21 Oct 2022 12:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666355417;
        bh=0ux4Mz0bv4iwyOrXiOmVYIKsRGEFFUV+ZTWhLt9HJNU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UNaVMNF8ruktk2RFh2VOi3W3D2PjM7TPpPjTzbfFNxKvn6Z330lLUbsmGDwLXF5QJ
         m28qGICjH2RPIsvCmNZ+Hq6WV5AxGjJM4QkNacX0yAQwpKlDjAXw3KLeTaS6J237iY
         ApwMgfCc26lF+t9g02scSoVpV/2GVbj+Un926DFIDd2PZPw06e2sUyje5m2eB5FTUv
         kOK/7I6Qw6+GksAsv9WTTUnrYX2S86KU3qiSH6r+SgQktJh2Yrn+g7RaKRFIz8lwla
         0KYbrHKUnubYdRUWU9ij9s4sJofSK3dfHn1JeBaTAzPQpz4bDvF3nRQLfTKcLP1AgK
         XMb7cYyIaHfsA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 15CA9E270DF;
        Fri, 21 Oct 2022 12:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ethtool: pse-pd: fix null-deref on genl_info in dump
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166635541708.28002.17426980742022498733.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Oct 2022 12:30:17 +0000
References: <20221019223551.1171204-1-kuba@kernel.org>
In-Reply-To: <20221019223551.1171204-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com,
        syzbot+81c4b4bbba6eea2cfcae@syzkaller.appspotmail.com,
        andrew@lunn.ch, linux@rempel-privat.de, bagasdotme@gmail.com,
        lkp@intel.com
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 19 Oct 2022 15:35:51 -0700 you wrote:
> ethnl_default_dump_one() passes NULL as info.
> 
> It's correct not to set extack during dump, as we should just
> silently skip interfaces which can't provide the information.
> 
> Reported-by: syzbot+81c4b4bbba6eea2cfcae@syzkaller.appspotmail.com
> Fixes: 18ff0bcda6d1 ("ethtool: add interface to interact with Ethernet Power Equipment")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net] ethtool: pse-pd: fix null-deref on genl_info in dump
    https://git.kernel.org/netdev/net/c/46cdedf2a0fa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


