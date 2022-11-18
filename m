Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F0062F2FB
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 11:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241728AbiKRKuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 05:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241512AbiKRKuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 05:50:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188F992B56
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 02:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D14F6B81FAC
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 10:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8AF84C433D7;
        Fri, 18 Nov 2022 10:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668768616;
        bh=W0DD1qDJFG6Q3ed5tuaM2r7PGDKYlGg3skDpIOyzbg8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fUvNxmMyIKWIB1MSinT7QFD7vzmZk2eD7vUiZmEtxxo/kmoAWUvHFLrgSu9IIgWoI
         p+RgBLLuHxRZhWwW9VzldwXUmoAWNn28mbfpedLwIRfwBlgbFJmIAbhxuYHN7zSXM8
         MBEG7E/oOrxyqOLJISLy6AZrDLvG5opeJpFl4wpH4g9+BF2YytGCnMDRqlt+2wIn0D
         p32G7quVbJvKuE0ylKMrvCxE1Ocge6/EAYcNfRENdFeRqkEATgCfNW2iXmP5c6cU0J
         Mkt/VGwv4lSXl1/v3p8wYxpn9G58TRqzYBP/XeqP2rLW4VqyXcTKExiqNM6dKpZzhA
         84BCPgMWw9J4A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 70E50C395F3;
        Fri, 18 Nov 2022 10:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipvlan: hold lower dev to avoid possible use-after-free
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166876861645.8561.1509208989108002904.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 10:50:16 +0000
References: <20221116011914.96240-1-maheshb@google.com>
In-Reply-To: <20221116011914.96240-1-maheshb@google.com>
To:     Mahesh Bandewar <maheshb@google.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com, davem@davemloft.net,
        kuba@kernel.org, mahesh@bandewar.net
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
by David S. Miller <davem@davemloft.net>:

On Tue, 15 Nov 2022 17:19:14 -0800 you wrote:
> Recently syzkaller discovered the issue of disappearing lower
> device (NETDEV_UNREGISTER) while the virtual device (like
> macvlan) is still having it as a lower device. So it's just
> a matter of time similar discovery will be made for IPvlan
> device setup. So fixing it preemptively. Also while at it,
> add a refcount tracker.
> 
> [...]

Here is the summary with links:
  - [net] ipvlan: hold lower dev to avoid possible use-after-free
    https://git.kernel.org/netdev/net/c/40b9d1ab63f5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


