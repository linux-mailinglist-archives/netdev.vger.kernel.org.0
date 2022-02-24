Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB7E84C3492
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 19:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232688AbiBXSUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 13:20:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbiBXSUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 13:20:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A78253178;
        Thu, 24 Feb 2022 10:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 23A3AB82845;
        Thu, 24 Feb 2022 18:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A64BEC340EC;
        Thu, 24 Feb 2022 18:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645726810;
        bh=WxvLfnTXHVLuU8/S/6Q8Slr0LuDth5ZsCso4HJjuxuo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Iuwf/8dGtGRETxZJvtvsU1SNlF3ge82gzVAONrMmA/oIMZDsZeNqDWnjlH9TJjtXK
         QpiAWnEOFWWShnpz+TEmdb5QfStjuPdt7T3j5w7fPYzxQc2ro65xg1E4jBXLQWZ6WB
         7/iiemghdkRBwxgExqyHP4QLa7T/Gn9PBUc0soyWAU/vu2kv1xNOcb6mVIxZwNIAM5
         7v2UYFMuCnltjss8mYIgdQHwCN2oD/DOLFKz0Fp9BYQ4EO1m2p8uX+SvSdEmNNW3zW
         /7wLCZfY7ShtQG5auD6mL+Nm+0jsvBxhmCowdfXz+zZK2za8Uml9AaaRGQwyxbFbGr
         /7RFnCHujKdrQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8A4ECEAC09A;
        Thu, 24 Feb 2022 18:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: mv643xx_eth: process retval from of_get_mac_address
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164572681056.6045.9971807699908202532.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Feb 2022 18:20:10 +0000
References: <20220223142337.41757-1-maukka@ext.kapsi.fi>
In-Reply-To: <20220223142337.41757-1-maukka@ext.kapsi.fi>
To:     Mauri Sandberg <maukka@ext.kapsi.fi>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        sebastian.hesselbarth@gmail.com, davem@davemloft.net,
        kuba@kernel.org, andrew@lunn.ch
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 23 Feb 2022 16:23:37 +0200 you wrote:
> Obtaining a MAC address may be deferred in cases when the MAC is stored
> in an NVMEM block, for example, and it may not be ready upon the first
> retrieval attempt and return EPROBE_DEFER.
> 
> It is also possible that a port that does not rely on NVMEM has been
> already created when getting the defer request. Thus, also the resources
> allocated previously must be freed when doing a roll-back.
> 
> [...]

Here is the summary with links:
  - [v2] net: mv643xx_eth: process retval from of_get_mac_address
    https://git.kernel.org/netdev/net/c/42404d8f1c01

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


