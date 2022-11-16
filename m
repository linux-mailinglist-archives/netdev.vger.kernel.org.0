Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906A362B259
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 05:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiKPEaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 23:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiKPEaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 23:30:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5316214D35
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 20:30:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B68D56192B
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 04:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 085F8C433B5;
        Wed, 16 Nov 2022 04:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668573015;
        bh=9my8L1EDa+RU5DBrUIK7299BZUArfYM2A1TOfNB45LA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rpRVU+/UQr/qOR2RgmV10VK4O/2/zh52YCTnks/zO+3MHxoCC3TEUQMDTbhJ+I4p+
         OTTijlMq4SfgZ4png5lj9GFht8otZOxWfTjR10CLpk65rUZoT/PDhY7jimoTJQoj7C
         1oI06SC8BSrdVdTPtf2dhWW4YM/O2E/adVuJABr+68f2pZzdIYVMFlxZ2VjHKFNuhf
         ggLT5MN/ID6qkyt7t9+l67ZP+y3GeeqGTVh9EFoop4TuqCcSQ51A5feg+lacnsWIn+
         2/DvmhYY6fEIIanoEdaj0+fP5LlJZIW5QMVbQTg97ZWbqZNCV+fgGsfNRADZAxtGVw
         ez7QHxsFpnnuA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DF5FCC395F6;
        Wed, 16 Nov 2022 04:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ag71xx: call phylink_disconnect_phy if
 ag71xx_hw_enable() fail in ag71xx_open()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166857301490.26862.17784382249604965319.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Nov 2022 04:30:14 +0000
References: <20221114095549.40342-1-liujian56@huawei.com>
In-Reply-To: <20221114095549.40342-1-liujian56@huawei.com>
To:     Liu Jian <liujian56@huawei.com>
Cc:     chris.snook@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        linux@rempel-privat.de, netdev@vger.kernel.org
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

On Mon, 14 Nov 2022 17:55:49 +0800 you wrote:
> If ag71xx_hw_enable() fails, call phylink_disconnect_phy() to clean up.
> And if phylink_of_phy_connect() fails, nothing needs to be done.
> Compile tested only.
> 
> Fixes: 892e09153fa3 ("net: ag71xx: port to phylink")
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> 
> [...]

Here is the summary with links:
  - net: ag71xx: call phylink_disconnect_phy if ag71xx_hw_enable() fail in ag71xx_open()
    https://git.kernel.org/netdev/net/c/c9b895c6878b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


