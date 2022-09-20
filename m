Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491D55BE291
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 12:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiITKAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 06:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbiITKAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 06:00:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8B9661B24
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 03:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A7B96289E
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 10:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 72BDBC433C1;
        Tue, 20 Sep 2022 10:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663668015;
        bh=KTaTBWs3e7JzFRyWJPZEZMvUKpnB0mOT4xrm40D0knE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g0BJEdi4KBR+dVrho1K0J6+Yscysb15d+9qFz8GEas0U8gTZHV8wsepY+QSLqPlc1
         JKwkimvnq+N0PK55u0NpiHhIo5FYXnF+/A9kwaSZNaUu0EVb3IOuEF27bjkj797q58
         eaDPk0aVStJxVbtsw5gVK3UOSbYS1ZBHe6tqQJkSlEwiY9q3hnJTikPn7kH5dgIBzI
         fTWGVsYRo15/x/hrvkH+FLuojx43YM4502/Q4D4j2ABbeWINpaEbY2Fdk9LcJnyopX
         MnpTUKwHuYjnXlo1jgVWBlqBiq9WiJ+GaQMUCdMAft5OWFEjLO2qiewhNSKkLA82pQ
         0cBjCPbMPG2Vg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 47998E21EE0;
        Tue, 20 Sep 2022 10:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net-next: gro: Fix use of skb_gro_header_slow
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166366801528.32034.7624093546615460254.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 10:00:15 +0000
References: <20220911184835.GA105063@debian>
In-Reply-To: <20220911184835.GA105063@debian>
To:     Richard Gobert <richardbgobert@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
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

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 11 Sep 2022 20:48:49 +0200 you wrote:
> In the cited commit, the function ipv6_gro_receive was accidentally
> changed to use skb_gro_header_slow, without attempting the fast path.
> Fix it.
> 
> Fixes: 35ffb6654729 ("net: gro: skb_gro_header helper function")
> Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
> 
> [...]

Here is the summary with links:
  - net-next: gro: Fix use of skb_gro_header_slow
    https://git.kernel.org/netdev/net-next/c/cb628a9a7ef6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


