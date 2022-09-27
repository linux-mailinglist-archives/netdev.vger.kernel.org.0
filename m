Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18A95EBF00
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 11:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbiI0JuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 05:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231180AbiI0JuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 05:50:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52238248D5;
        Tue, 27 Sep 2022 02:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E507E6179B;
        Tue, 27 Sep 2022 09:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 40B73C43470;
        Tue, 27 Sep 2022 09:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664272215;
        bh=0Zwavg5JUia+nTJVviyK4sqLSRBCzbsBJAMKxVxcRWg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E7HL0oOGU1UZ6PyFOpEgHPBC3AhNUsWEBYZl06iV6+JtLNLYpJdf3W0LCQdt8C2gm
         7bXy++WEtpKcwWhgqOWMqnqFxI2GaxMROsGIkkyohkg2tMMrTymLsP9djQpDsZchB/
         aRR5y3fdCnovkNsCgi8hLUbyD38mEva1TkDdS5TYAnhyhCvj/r6XDXL5Gu5OI2tXq4
         NNbM28BbqpHzo4mP51gi/SWY9HMhnz8JWqmIYXuLvZpRC+yYD0aJGuclzEjfG9sF1k
         bNoAcy56aePV0A5k5qgAXvo9MC6CyN2HyB5c6Ob0OGTyMWpL4gzn+D1iwh2mEcEXrX
         Uvz9OBqkgYvqQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 269C6E21EC2;
        Tue, 27 Sep 2022 09:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/2] net: openvswitch: metering and conntrack in
 userns
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166427221515.2561.12363623872450620942.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Sep 2022 09:50:15 +0000
References: <20220923133820.993725-1-michael.weiss@aisec.fraunhofer.de>
In-Reply-To: <20220923133820.993725-1-michael.weiss@aisec.fraunhofer.de>
To:     =?utf-8?q?Michael_Wei=C3=9F_=3Cmichael=2Eweiss=40aisec=2Efraunhofer=2Ede=3E?=@ci.codeaurora.org
Cc:     pabeni@redhat.com, pshelar@ovn.org, davem@davemloft.net,
        kuba@kernel.org, joe@cilium.io, azhou@ovn.org, edumazet@google.com,
        netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Fri, 23 Sep 2022 15:38:18 +0200 you wrote:
> Currently using openvswitch in a non-initial user namespace, e.g., an
> unprivileged container, is possible but without metering and conntrack
> support. This is due to the restriction of the corresponding Netlink
> interfaces to the global CAP_NET_ADMIN.
> 
> This simple patches switch from GENL_ADMIN_PERM to GENL_UNS_ADMIN_PERM
> in several cases to allow this also for the unprivileged container
> use case.
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/2] net: openvswitch: allow metering in non-initial user namespace
    https://git.kernel.org/netdev/net-next/c/803937184717
  - [v3,net-next,2/2] net: openvswitch: allow conntrack in non-initial user namespace
    https://git.kernel.org/netdev/net-next/c/59cd7377660a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


