Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6877574EB5
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 15:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238561AbiGNNKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 09:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbiGNNKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 09:10:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 629413B97F;
        Thu, 14 Jul 2022 06:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3E3262017;
        Thu, 14 Jul 2022 13:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 55136C3411C;
        Thu, 14 Jul 2022 13:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657804214;
        bh=ccXUe53SyOaVkQSaDRX8mNDGXd0zr0+4nl3q/mIG90E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JVKJc/mk03E1Mx8s4H7u3EbtJpyU5si+t2W+rKGcyNWByZOVxHAAxiCK9Lq1AX1lX
         l6J7YbtUY37VzcAo171H/WiZLww4wR69QXRiyKKUlD1GaYq4dr9LQMC6ims1y0dkkA
         2AcGM6S19pwnweW8BnmZXUgPBR6mUwTtv2AvlkXqp+g+5HlzxHB3AdKTtzzCc4vFyk
         mSo6Lqcq/NwykIeRWp3u8SyEvE7a+hUjq5miIQA5ZqE2XxoIWI8THmOkV1RXTE0XUz
         xk2av02UbTz701lL/CbQ8bTArw7Ivl40yHrXG5WQbFV/fW09z2N8jKIudibeu1mtrO
         i04rDXV9so6Uw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2D40CE45225;
        Thu, 14 Jul 2022 13:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 1/2] ip: fix dflt addr selection for connected nexthop
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165780421418.729.15886797244518922619.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jul 2022 13:10:14 +0000
References: <20220713114853.29406-1-nicolas.dichtel@6wind.com>
In-Reply-To: <20220713114853.29406-1-nicolas.dichtel@6wind.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, dsahern@kernel.org,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, stable@vger.kernel.org,
        edwin.brossette@6wind.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 13 Jul 2022 13:48:52 +0200 you wrote:
> When a nexthop is added, without a gw address, the default scope was set
> to 'host'. Thus, when a source address is selected, 127.0.0.1 may be chosen
> but rejected when the route is used.
> 
> When using a route without a nexthop id, the scope can be configured in the
> route, thus the problem doesn't exist.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/2] ip: fix dflt addr selection for connected nexthop
    https://git.kernel.org/netdev/net/c/747c14307214
  - [net,v3,2/2] selftests/net: test nexthop without gw
    https://git.kernel.org/netdev/net/c/cd72e61bad14

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


