Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDAAE5031C1
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 01:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353996AbiDOVxv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 17:53:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354750AbiDOVxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 17:53:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B086F499
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 14:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2E59621BE
        for <netdev@vger.kernel.org>; Fri, 15 Apr 2022 21:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 470BFC385A5;
        Fri, 15 Apr 2022 21:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650059413;
        bh=0z43GDb1HUFYADI6CLZ6lkniT44CK8NG1/TnSto14aE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=beoD1vgGMpi3pmUR8xEWKO3wd+mCpLnzLDKprHzrKnbLsHsRJZZdjYzCvthaAz1p9
         +iH/GrA4WdaVjq8qyrJeX6VirfkfT0R6F6wt9PJgNOTtMhOTPAgTvwxsgBw171AWbN
         uNYmIomLpgHoSWJjmTJjxEwivoP4cp87LOItTjXZHeQCC//F74r94bJtKJk7dkdEdD
         7jwGgbPwUT3xEjhbHRmTs5Bv5rgzmD18w79FWSTj5k/Bs+rA9baSM+RaGe7NIE/v4F
         WV5b9ag1dNlEHlja3S6bcKSe2+UqFmN/dS852edsINB7KutwqCo4eC56F490TiwRGe
         iOxa9dqRmx94w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2546DE8DBD4;
        Fri, 15 Apr 2022 21:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] l3mdev: Fix ip tunnel case after recent l3mdev change
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165005941314.21261.596606933899156187.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 21:50:13 +0000
References: <20220413174320.28989-1-dsahern@kernel.org>
In-Reply-To: <20220413174320.28989-1-dsahern@kernel.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Apr 2022 11:43:18 -0600 you wrote:
> Second patch provides a fix for ip tunnels after the recent l3mdev change
> that avoids touching the oif in the flow struct. First patch preemptively
> provides a fix to an existing function that the second patch uses.
> 
> David Ahern (2):
>   l3mdev: l3mdev_master_upper_ifindex_by_index_rcu should be using
>     netdev_master_upper_dev_get_rcu
>   net: Handle l3mdev in ip_tunnel_init_flow
> 
> [...]

Here is the summary with links:
  - [net,1/2] l3mdev: l3mdev_master_upper_ifindex_by_index_rcu should be using netdev_master_upper_dev_get_rcu
    https://git.kernel.org/netdev/net/c/83daab06252e
  - [net,2/2] net: Handle l3mdev in ip_tunnel_init_flow
    https://git.kernel.org/netdev/net/c/db53cd3d88dc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


