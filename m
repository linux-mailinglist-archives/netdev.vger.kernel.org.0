Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF6FD6AD077
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 22:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjCFVbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 16:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbjCFVbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 16:31:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94B486DF1
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 13:30:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 308B6B8113A
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 21:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CC71EC433EF;
        Mon,  6 Mar 2023 21:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678138218;
        bh=QZMQ9tL7qYXQkEDp+k6GwoLI59skwvTvhGQjS+lUZJg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gwGlAP+HY8IW/CuK555CswypDASFQRcORrkio7yqUHMOzwR6hnTZuz19cVH2L3l5R
         3xDnXQK6rL/ZnAEhh15vkP06V/6pd0bH2MijZfJXV/te01IWlnZ+QYBOmLQB7yjisA
         SvFgyPgKtiq3rgzRSS5uhuzXVXHwcQlMubvoCaaPsAKUDzSR5Sl3k4Ki5boeuOwNEU
         2vFwVDQbDrt+F77EO47VyJDdSCIYu9cJ474AORE/WWJpVWpkjJvyQSixL31YZLtyS/
         mOBDHPUNPJM9xIph/+uIk7WhCapbASXMWnnoXhPHQQs+k95/LMB9NZFPdM6f6ZnJAx
         GovEFbfiprfkw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ACB89E501E4;
        Mon,  6 Mar 2023 21:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phylib: get rid of unnecessary locking
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167813821870.7576.1242953495648733695.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Mar 2023 21:30:18 +0000
References: <E1pY8Pq-00D0sw-NY@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1pY8Pq-00D0sw-NY@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, maz@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 03 Mar 2023 16:37:54 +0000 you wrote:
> The locking in phy_probe() and phy_remove() does very little to prevent
> any races with e.g. phy_attach_direct(), but instead causes lockdep ABBA
> warnings. Remove it.
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> 6.2.0-dirty #1108 Tainted: G        W   E
> 
> [...]

Here is the summary with links:
  - [net] net: phylib: get rid of unnecessary locking
    https://git.kernel.org/netdev/net/c/f4b47a2e9463

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


