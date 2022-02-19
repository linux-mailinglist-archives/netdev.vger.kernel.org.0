Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 296594BC958
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 17:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242633AbiBSQki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 11:40:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242630AbiBSQkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 11:40:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8631D3DAA
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 08:40:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BDB5B80BFA
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 16:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A8719C340F4;
        Sat, 19 Feb 2022 16:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645288811;
        bh=VdZ3p04jHNM5H+SFIHwyhaOgl143ClddVRSNDqI2Omc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iJd7hWzDxrimniRh4xrH35EIm3+mgIq76kUUQ0JIPsHbOtqnfQp4p2WPgMpspo6RA
         LEl9Wf0Of3z51jpCYyZEVbWMnGSS6X5moEjDQWMAEOgJdoKYIiXy3Hq+4w7r5KmLwH
         CNKvDng4ovRRkI7gEbLlc2qcbHklNJ+zKs5je8YqktxThm29IHGIh0LGUm62n5Blrd
         rB+E8uIBBUgG/MswjxKZ4G2hD0ZE82TfM7HaUaXtyTebgYbOSmuAa31M0JQxvLD2ct
         kbhF9Yln9Ymne1hSAIYVz8j9/v4jZgXuXOJRw7B9O1QKqx2XSMolCmrkreSjM37m55
         VDPNe/Aw8P8mw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8DCB2E7BB1A;
        Sat, 19 Feb 2022 16:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: get rid of rtnl_lock_unregistering()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164528881157.6364.8570081995828538737.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Feb 2022 16:40:11 +0000
References: <20220218175856.2836878-1-eric.dumazet@gmail.com>
In-Reply-To: <20220218175856.2836878-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
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

On Fri, 18 Feb 2022 09:58:56 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> After recent patches, and in particular commits
>  faab39f63c1f ("net: allow out-of-order netdev unregistration") and
>  e5f80fcf869a ("ipv6: give an IPv6 dev to blackhole_netdev")
> we no longer need the barrier implemented in rtnl_lock_unregistering().
> 
> [...]

Here is the summary with links:
  - [net-next] net: get rid of rtnl_lock_unregistering()
    https://git.kernel.org/netdev/net-next/c/8a4fc54b07d7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


