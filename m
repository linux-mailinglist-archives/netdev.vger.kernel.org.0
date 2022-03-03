Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 760E64CB6A2
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 07:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiCCGBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 01:01:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiCCGBA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 01:01:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25F03144F77
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 22:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74E28B823BE
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 06:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 099B8C340F1;
        Thu,  3 Mar 2022 06:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646287212;
        bh=gOFaSiWkUzNCFCDAMWRMe0qD1DwcWk92Pwj/zdcZOQU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fhO+UAbYCQupcdvbmwktIlYis/+sM56YKPm+Yy8gfeVJu1ML5dDpvvf4VxvhQniVg
         ztxsghBDN8KgMbUTY6FQTbUiKHVqd586kGVYAcTTYUY5JHfTI4QNAXG3S6k09TA8g7
         5arClQiEfAH/d4N9bbxgedpr1n7Bfq/itNfrOctOXSXw7/EkQ33drdMqBctq86tCGm
         lVknsRBtfXq3mjX0XQ+XMudrXMg5dOr775TVTBkNM+G6zD9oZ15qIWgi7mBR/LiICN
         tiiQnz+7xdxH/r5eQnKuBC/P9pJlRw2bCZ9K9TKBdCHKuK/ENkYXyzjkpR1+ARtqOg
         7bThiNRvisKBg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E17EEE7BB08;
        Thu,  3 Mar 2022 06:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/3] batman-adv: Request iflink once in batadv-on-batadv check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164628721191.27095.7549108056265161167.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 06:00:11 +0000
References: <20220302163049.101957-2-sw@simonwunderlich.de>
In-Reply-To: <20220302163049.101957-2-sw@simonwunderlich.de>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org, sven@narfation.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Simon Wunderlich <sw@simonwunderlich.de>:

On Wed,  2 Mar 2022 17:30:47 +0100 you wrote:
> From: Sven Eckelmann <sven@narfation.org>
> 
> There is no need to call dev_get_iflink multiple times for the same
> net_device in batadv_is_on_batman_iface. And since some of the
> .ndo_get_iflink callbacks are dynamic (for example via RCUs like in
> vxcan_get_iflink), it could easily happen that the returned values are not
> stable. The pre-checks before __dev_get_by_index are then of course bogus.
> 
> [...]

Here is the summary with links:
  - [1/3] batman-adv: Request iflink once in batadv-on-batadv check
    https://git.kernel.org/netdev/net/c/690bb6fb64f5
  - [2/3] batman-adv: Request iflink once in batadv_get_real_netdevice
    https://git.kernel.org/netdev/net/c/6116ba09423f
  - [3/3] batman-adv: Don't expect inter-netns unique iflink indices
    https://git.kernel.org/netdev/net/c/6c1f41afc1db

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


