Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4514C06A5
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 02:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbiBWBKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 20:10:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbiBWBKg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 20:10:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF56360D9;
        Tue, 22 Feb 2022 17:10:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A98C61444;
        Wed, 23 Feb 2022 01:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C9CDCC340F0;
        Wed, 23 Feb 2022 01:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645578609;
        bh=Nx5sbaJGxfOXQrZG46XRC5IIkopqYeHN8vpkbXzQSm4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MiP1edxj80mhLNmdvqxK+EPcXakBoAfaD4uxGFnPIZmNGxWn5x1t4tsJohEy9Yfa0
         5St3GcpfmG7KHndEd/0JUnPrrY1MJ3gZDbyu7fKqFBA789J5OivPmeWRnyBuxRspwA
         LpQlrTNTF5m2QzuKtXqkZy8646nAcFznkzojpk6ivsuZOtvSIltiZblBM7JJbUNIta
         TjDGePX3lt2l1yiq4zYVX/KP7rv9ODlvnX6uH1Gq3xHf0OqDJGGd162bvYeplnAk/v
         oh7cCzCpPsi1PaxkscWpy82KXKewZmV1jbcUXeFh8jcNzxvf3wOZLXzQjmcvMAF/NT
         LWj/9XMXZ5fCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B39C8E73590;
        Wed, 23 Feb 2022 01:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: dsa: fix panic when removing unoffloaded port
 from bridge
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164557860973.30746.7349740017886705989.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Feb 2022 01:10:09 +0000
References: <20220221203539.310690-1-alvin@pqrs.dk>
In-Reply-To: <20220221203539.310690-1-alvin@pqrs.dk>
To:     =?utf-8?b?QWx2aW4gxaBpcHJhZ2EgPGFsdmluQHBxcnMuZGs+?=@ci.codeaurora.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, kuba@kernel.org,
        alsi@bang-olufsen.dk, vladimir.oltean@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Mon, 21 Feb 2022 21:35:38 +0100 you wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> If a bridged port is not offloaded to the hardware - either because the
> underlying driver does not implement the port_bridge_{join,leave} ops,
> or because the operation failed - then its dp->bridge pointer will be
> NULL when dsa_port_bridge_leave() is called. Avoid dereferncing NULL.
> 
> [...]

Here is the summary with links:
  - [v2,net] net: dsa: fix panic when removing unoffloaded port from bridge
    https://git.kernel.org/netdev/net/c/342b6419193c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


