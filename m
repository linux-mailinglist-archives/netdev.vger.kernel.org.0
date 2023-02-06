Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB8C668B8B9
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 10:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjBFJaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 04:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBFJaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 04:30:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EB3A5D0
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 01:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43AC360DC8
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 94B56C4339B;
        Mon,  6 Feb 2023 09:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675675817;
        bh=gmZIYNUo9ezqjG5HTDhLWsd5zzl43PZbj3sF3Ecsmbs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MriBMlspydN3oTNa8/4hQtL2FGbFPgwGx/GMOV9dfglysjXNHD3AbozmmVhD6yu3q
         BZVvoVZVzziM8P1mX5c3IKIi6bW/2IMCdEoHIKWv34VJa4KJh9y/yQuP80uGE9rR0A
         Z6wjk9q2E1TK0hH9zaQx9ZEAvsLd4YvgaI+PQ9i5+NXD1aY5ZW38BTWMbTUtur/ZiE
         8QXSZi8nHEQ8XOyKiaeOtfKfbntLyeRvNfDvnPya7/v6t3n0MczabmiY8gsOrQgUVE
         Tx2CpUEcM3CAqPX4/EK11U+EwghIRnKgCrR7hOB1jeGjqmtHdIqjrecOGNUT686L2e
         qb0hj28LbLz0g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 713ACE55EFB;
        Mon,  6 Feb 2023 09:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: microchip: sparx5: fix PTP init/deinit not checking
 all ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167567581746.9492.11540322843627742697.git-patchwork-notify@kernel.org>
Date:   Mon, 06 Feb 2023 09:30:17 +0000
References: <20230203085557.3785002-1-casper.casan@gmail.com>
In-Reply-To: <20230203085557.3785002-1-casper.casan@gmail.com>
To:     Casper Andersson <casper.casan@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, daniel.machon@microchip.com,
        UNGLinuxDriver@microchip.com, richardcochran@gmail.com,
        horatiu.vultur@microchip.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  3 Feb 2023 09:55:57 +0100 you wrote:
> Check all ports instead of just port_count ports. PTP init was only
> checking ports 0 to port_count. If the hardware ports are not mapped
> starting from 0 then they would be missed, e.g. if only ports 20-30 were
> mapped it would attempt to init ports 0-10, resulting in NULL pointers
> when attempting to timestamp. Now it will init all mapped ports.
> 
> Fixes: 70dfe25cd866 ("net: sparx5: Update extraction/injection for timestamping")
> Signed-off-by: Casper Andersson <casper.casan@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: microchip: sparx5: fix PTP init/deinit not checking all ports
    https://git.kernel.org/netdev/net/c/d7d94b2612f5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


