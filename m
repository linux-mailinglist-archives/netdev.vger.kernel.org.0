Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE7BC4B4EB9
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 12:34:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351929AbiBNLee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 06:34:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351552AbiBNLd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 06:33:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2BB6949F;
        Mon, 14 Feb 2022 03:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53D8361126;
        Mon, 14 Feb 2022 11:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B0355C340F0;
        Mon, 14 Feb 2022 11:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644837610;
        bh=1JS+uHQPfJVpvIAzRnbf4toT/uBwKM84kUwybvkFnAM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ozuiVl+GXc62m/nisUzIyypmfSdUqbtwHKOweSoMhEC01AsQCyRAUwbFbtgzWitN1
         aGv+VQhmAvs32ODMvoy9Fx95bZ21PCZeCtB2RBsvtURboGlITBqDp4lNLs1qycrNWP
         X6Sir1zIjLfEJSKIogzYPyr9URyuUSDy4U+7VvN6ZA/hdziRkfOiTVfRDrW2HH66JX
         Uqq/qNrYU4lYujrRUkM8G0oVcnsqvXbY1NinIrfEewi3UCpgQGzXI9Mo/AGh5rOYIi
         xxOPUAYx/dnJ/mxsiscW/hWMIaWvyMV+3pG+uzqoghZQw06u8TXey4+g7TYs94qeQx
         NuZom/Q9OsjWw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 99AF6E6D4D5;
        Mon, 14 Feb 2022 11:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] Generate netlink notification when default IPv6 route
 preference changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164483761062.10850.8641197863341390379.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Feb 2022 11:20:10 +0000
References: <20220210220935.21139-1-kalash@arista.com>
In-Reply-To: <20220210220935.21139-1-kalash@arista.com>
To:     Kalash Nainwal <kalash@arista.com>
Cc:     netdev@vger.kernel.org, fruggeri@arista.com, dsahern@gmail.com,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 10 Feb 2022 14:09:35 -0800 you wrote:
> Generate RTM_NEWROUTE netlink notification when the route preference
>  changes on an existing kernel generated default route in response to
>  RA messages. Currently netlink notifications are generated only when
>  this route is added or deleted but not when the route preference
>  changes, which can cause userspace routing application state to go
>  out of sync with kernel.
> 
> [...]

Here is the summary with links:
  - [v2] Generate netlink notification when default IPv6 route preference changes
    https://git.kernel.org/netdev/net-next/c/806c37ddcf28

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


