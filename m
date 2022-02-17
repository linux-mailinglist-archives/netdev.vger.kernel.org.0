Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38DDB4BA668
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 17:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243428AbiBQQu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 11:50:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243184AbiBQQu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 11:50:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B8BD994E
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 08:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BED006172E
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 16:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 27206C340E9;
        Thu, 17 Feb 2022 16:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645116610;
        bh=grj+xejRb3IKt7uLrJ/rwSlGtKBWgQG/afbv3l4dhqw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=b89HSmbO8yvk9peWHvBk+MovG8qk6WnwJwmbOHW47RYMaNCHwDWb/4/eGVYSzGAT2
         XC2XOSqsWWf3LdqhJZQrAGK1s4IGBPkxOItwrnwhh33zPkcHcp271Fs0rEQHtjRN2h
         4iwz1mdfyHCq2/msPkzPDjVEy3V0f7pGNLMkuQ6h5kJzXex/NsKl2ctZeTL6xJcDf/
         uhDVsb35dvv+TEsh5kuRA2ooC3NuCyoQIyxZb+Qx41d/gkJsH0jMYpi3yUE4U6Spuk
         tAKl9VM88oGy0j3L2+DdkNCedV5Gs0UwMQK787LnZDjWZx0wog4ymuWSt6n3J3joxo
         TW9grfLvA6unQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0EB7DE7BB08;
        Thu, 17 Feb 2022 16:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipv6/addrconf: ensure addrconf_verify_rtnl() has
 completed
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164511661005.9378.5051264826164600253.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Feb 2022 16:50:10 +0000
References: <20220216182037.3742-1-eric.dumazet@gmail.com>
In-Reply-To: <20220216182037.3742-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dsahern@kernel.org, edumazet@google.com, syzkaller@googlegroups.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 16 Feb 2022 10:20:37 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Before freeing the hash table in addrconf_exit_net(),
> we need to make sure the work queue has completed,
> or risk NULL dereference or UAF.
> 
> Thus, use cancel_delayed_work_sync() to enforce this.
> We do not hold RTNL in addrconf_exit_net(), making this safe.
> 
> [...]

Here is the summary with links:
  - [net-next] ipv6/addrconf: ensure addrconf_verify_rtnl() has completed
    https://git.kernel.org/netdev/net-next/c/be6b41c15dc0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


