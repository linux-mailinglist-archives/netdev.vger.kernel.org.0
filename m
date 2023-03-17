Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 336056BDD68
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 01:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjCQAK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 20:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbjCQAKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 20:10:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DABBF7605B;
        Thu, 16 Mar 2023 17:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6CCEBB823A9;
        Fri, 17 Mar 2023 00:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 10F67C4339B;
        Fri, 17 Mar 2023 00:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679011819;
        bh=z/uXwGs3VxfZc/p5EaF2U0ZmnVig+z30SDyD9tqAQFU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IDsbMRqQVsg/m/MPYSp1yjePJRkH9VG6UnOPOOTmgjxG8crfFA7c5ww926pU+hmCF
         RR6Z+AhoOF06LlzAgM9jbRiM/i9wOASmM1UEc5wMDIhDhn4DomqAwxMrZGs8xm7Ohm
         FZNV+GSQzY++q50UoDQzRPtLGJ7pC6DlfZT26BNn/K6OE6rvTl9ivW+YjnoWmmtFp9
         Rf36eF9zOL34xzv9BNOzpxVwvKIoGQheQN909ItA68NMQuwPYdFWwxAVyaB0IL+0d7
         rw7sWXj+DAZL8yMn1oU7FtNhjY5XRHwn6c24DUx6qJ5z8acagZo+wRFOaR5pIin9gu
         Luv22k7VyYP7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E860FE66CBF;
        Fri, 17 Mar 2023 00:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6 1/1] net: dsa: hellcreek: Get rid of custom
 led_init_default_state_get()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167901181894.18963.13988486211283809064.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 00:10:18 +0000
References: <20230314181824.56881-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20230314181824.56881-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kurt@linutronix.de, andrew@lunn.ch, f.fainelli@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 14 Mar 2023 20:18:24 +0200 you wrote:
> LED core provides a helper to parse default state from firmware node.
> Use it instead of custom implementation.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
> v6: wrapped long lines (Simon, Jakub)
>  drivers/net/dsa/hirschmann/hellcreek_ptp.c | 45 ++++++++++++----------
>  1 file changed, 24 insertions(+), 21 deletions(-)

Here is the summary with links:
  - [net-next,v6,1/1] net: dsa: hellcreek: Get rid of custom led_init_default_state_get()
    https://git.kernel.org/netdev/net-next/c/d565263b7d83

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


