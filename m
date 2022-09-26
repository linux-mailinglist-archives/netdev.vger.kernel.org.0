Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6305EAF7D
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 20:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbiIZSTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 14:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbiIZSSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 14:18:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E02F4F1AD
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 11:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C91EDB80C95
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 18:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6EFF2C433B5;
        Mon, 26 Sep 2022 18:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664215814;
        bh=D2dHIyDxLB1fz2RkdV3/LOc70gDBCQjG89xgboSLUC4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cmcp2Ww/X++YtHdljvghjtDRaa8oMoey1hGRocfE5z7IsePQs9R7WgNFIhJZYA6m3
         uMSL3o7c9Hd4cfvIGU8LKQUfLrxv7m90cqCwzM1eKOVD+CTTeCr/7Fkq1CP0KEaGuG
         5jA9f12X1ukQ27JCLrvTFvUbSaMRlhIYmTX9lmUvq8teOgoV37kWuUNGHXURFSwKWd
         gPIcxXVi41CW81I1Z5aKKrO+qTUHJJvo0CThuvXKqUCMs03rk5ZfnUH132XstXsGbZ
         0FYqm0IdvZv6ttIXZIZwWt/LEvvfNVbrqEw/ZozzeRC6Zb5S9P06Y7oPY5oxpcY6ww
         lzPFyuBCgaibw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 53515C070C8;
        Mon, 26 Sep 2022 18:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Revert "net: mvpp2: debugfs: fix memory leak when using
 debugfs_lookup()"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166421581432.31572.1565270418001750642.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Sep 2022 18:10:14 +0000
References: <20220923234736.657413-1-sashal@kernel.org>
In-Reply-To: <20220923234736.657413-1-sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        stable@kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 23 Sep 2022 19:47:36 -0400 you wrote:
> This reverts commit fe2c9c61f668cde28dac2b188028c5299cedcc1e.
> 
> On Tue, Sep 13, 2022 at 05:48:58PM +0100, Russell King (Oracle) wrote:
> >What happens if this is built as a module, and the module is loaded,
> >binds (and creates the directory), then is removed, and then re-
> >inserted?  Nothing removes the old directory, so doesn't
> >debugfs_create_dir() fail, resulting in subsequent failure to add
> >any subsequent debugfs entries?
> >
> >I don't think this patch should be backported to stable trees until
> >this point is addressed.
> 
> [...]

Here is the summary with links:
  - Revert "net: mvpp2: debugfs: fix memory leak when using debugfs_lookup()"
    https://git.kernel.org/netdev/net/c/6052a4c11fd8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


