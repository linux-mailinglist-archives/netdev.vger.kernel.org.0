Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C02555F1885
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 03:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbiJABub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 21:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232255AbiJABuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 21:50:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D31BBF1EF
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 18:50:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42B0CB82B01
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 01:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA851C433D7;
        Sat,  1 Oct 2022 01:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664589018;
        bh=lALOzKaTO0FxGW68smXndKia+HOChPgxB11+Vu7/TtY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OiFIp7r4gTb/nZdkF6PJoXYfC5DrrE/3at9bEmcP5m9sKU4rOj2mv0ztOE2haEO7F
         oYccs0pp9LChSB3esHEDuZcz2sXRI+I7vJqOdvVqjcbozr6h+D9bFXQRt9T4Zd9prK
         kzpcVGPVKyNjDou85EWY1w+6sLmX7qFnzWMd3ikqIMuHNwklSl9o3lPMpIUYnujVvs
         G9kSNT4eiWs9o5Qgg61QU5Zz7itwk4usGDYT7E/+IzhxLNkkg1hL0h6YBOot8AurOh
         TJeiQIAIN4zQydad2988tjkSjy7L3fLzV//g5KKIVP1SB9dpwKuGlv9Ne1iJrSN+O8
         ddWPPVKaflVVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B6E1DE524CD;
        Sat,  1 Oct 2022 01:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next v3 0/7] devlink: sanitize per-port region
 creation/destruction
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166458901873.12957.13113256513275583660.git-patchwork-notify@kernel.org>
Date:   Sat, 01 Oct 2022 01:50:18 +0000
References: <20220929072902.2986539-1-jiri@resnulli.us>
In-Reply-To: <20220929072902.2986539-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        tariqt@nvidia.com, moshe@nvidia.com, saeedm@nvidia.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 29 Sep 2022 09:28:55 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Currently the only user of per-port devlink regions is DSA. All drivers
> that use regions register them before devlink registration. For DSA,
> this was not possible as the internals of struct devlink_port needed for
> region creation are initialized during port registration.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/7] net: devlink: introduce port registered assert helper and use it
    https://git.kernel.org/netdev/net-next/c/3fcb698d9c77
  - [net-next,v3,2/7] net: devlink: introduce a flag to indicate devlink port being registered
    https://git.kernel.org/netdev/net-next/c/081adcfe930e
  - [net-next,v3,3/7] net: devlink: add port_init/fini() helpers to allow pre-register/post-unregister functions
    https://git.kernel.org/netdev/net-next/c/ae3bbc04d4bf
  - [net-next,v3,4/7] net: dsa: move port_setup/teardown to be called outside devlink port registered area
    https://git.kernel.org/netdev/net-next/c/d82acd85cc41
  - [net-next,v3,5/7] net: dsa: don't leave dangling pointers in dp->pl when failing
    https://git.kernel.org/netdev/net-next/c/cf5ca4ddc37a
  - [net-next,v3,6/7] net: dsa: don't do devlink port setup early
    https://git.kernel.org/netdev/net-next/c/c698a5fbf7fd
  - [net-next,v3,7/7] net: dsa: remove bool devlink_port_setup
    https://git.kernel.org/netdev/net-next/c/61e4a5162158

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


