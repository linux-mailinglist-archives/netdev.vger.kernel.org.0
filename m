Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAE0530DB8
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 12:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbiEWJuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 05:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbiEWJuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 05:50:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2090738DB8
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 02:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC7BD61191
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 09:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11678C34116;
        Mon, 23 May 2022 09:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653299413;
        bh=3FuKiRwf0WM931+Y5XGTR3+nTmNs74plZGxF6IOQ21s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aUDcqrE/KZAymhlVsnE93ZTR6k+0HfPRMJnGs94IPIz/PYuVx9c877BMvOZIcbXeu
         iQLAmbt1sZ4t1oBKfAExJglJCOfvjpWm9BuDgnOy9eJXEN5UNNWG8MSAoOB2SbR8DL
         SGSGhfkwm+WuiYs3ipQIXIkLXy4pA4qjEo6dyIloT6L3MatdltHZLs04022Dx4f3QE
         gzBvkJF8/b3RPpXvuoTzMvvq1BQ+JoIbkdkY1lCT4AL4wA621qUsRhaFV+te8x4ReZ
         bTTJTt0Fq8ygLLrogU923gM4hmWqXa33smgTk3BfVz6t5HXY3fu2GZAorxsbkDlDTz
         8FpoSmOUPt3zw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E8B17F03938;
        Mon, 23 May 2022 09:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] DSA changes for multiple CPU ports (part 2)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165329941294.6525.5572743475291541417.git-patchwork-notify@kernel.org>
Date:   Mon, 23 May 2022 09:50:12 +0000
References: <20220521213743.2735445-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220521213743.2735445-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, andrew@lunn.ch, olteanv@gmail.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, colin.foster@in-advantage.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 22 May 2022 00:37:37 +0300 you wrote:
> As explained in part 1:
> https://patchwork.kernel.org/project/netdevbpf/cover/20220511095020.562461-1-vladimir.oltean@nxp.com/
> I am trying to enable the second internal port pair from the NXP LS1028A
> Felix switch for DSA-tagged traffic via "ocelot-8021q". This series
> represents part 2 (of an unknown number) of that effort.
> 
> This series deals only with a minor bug fix (first patch) and with code
> reorganization in the Felix DSA driver and in the Ocelot switch library.
> Hopefully this will lay the ground for a clean introduction of new UAPI
> for changing the DSA master of a user port in part 3.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: dsa: fix missing adjustment of host broadcast flooding
    https://git.kernel.org/netdev/net-next/c/129b7532a0ed
  - [net-next,2/6] net: dsa: felix: move the updating of PGID_CPU to the ocelot lib
    https://git.kernel.org/netdev/net-next/c/61be79ba2d90
  - [net-next,3/6] net: dsa: felix: update bridge fwd mask from ocelot lib when changing tag_8021q CPU
    https://git.kernel.org/netdev/net-next/c/a72e23dd679c
  - [net-next,4/6] net: dsa: felix: directly call ocelot_port_{set,unset}_dsa_8021q_cpu
    https://git.kernel.org/netdev/net-next/c/8c166acb60f8
  - [net-next,5/6] net: mscc: ocelot: switch from {,un}set to {,un}assign for tag_8021q CPU ports
    https://git.kernel.org/netdev/net-next/c/c295f9831f1d
  - [net-next,6/6] net: dsa: felix: tag_8021q preparation for multiple CPU ports
    https://git.kernel.org/netdev/net-next/c/a4e044dc4c5b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


