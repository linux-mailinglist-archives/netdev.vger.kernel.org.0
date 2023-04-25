Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6C376ED9DB
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 03:30:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233209AbjDYBaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 21:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbjDYBaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 21:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0EA0AF04
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 18:30:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D57D62566
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 01:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3050C4339C;
        Tue, 25 Apr 2023 01:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682386218;
        bh=k2Tjs1gLaPKwh2bxlP6hLukx066kLgddX4SVWvQ5ZLo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KUJxu5xhuXGqSED8NyTC18SHMwtaJEcd/8Yop/8BC/kWsfx+I1DVVMd3FTTmn7aK9
         c1kMBbF3FD1+h++jOQMz32fqRnzKRXUVA0e3tmB5b1BvHPkK5iXJRV/1x+Oawz+8gp
         BmrP9DUnSogpUaD8SsekL9n6GQbHW4IG7GG4spft/271lIA8ctUirHGh/CSOQcWXNQ
         8otNnMVNgbt56TfK9T+n4oTPfUxBvrGqGI4zZJJcSO9u530ikZ0YYe+QJn/BrZiLp2
         NsrAO+SD3iVKU6xi6NvNJUCkMDba6G7dplxeoM47rb9SjQiRqGwFGqcV3Bqqn2GhF3
         d4vYFiT9cj7Mg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 942E6C395D8;
        Tue, 25 Apr 2023 01:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] net: phy: dp83867: Add led_brightness_set support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168238621860.15904.8046998032073341937.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Apr 2023 01:30:18 +0000
References: <20230424134625.303957-1-alexander.stein@ew.tq-group.com>
In-Reply-To: <20230424134625.303957-1-alexander.stein@ew.tq-group.com>
To:     Alexander Stein <alexander.stein@ew.tq-group.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 24 Apr 2023 15:46:25 +0200 you wrote:
> Up to 4 LEDs can be attached to the PHY, add support for setting
> brightness manually.
> 
> Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> ---
> Blinking cannot be enforced, so led_blink_set cannot be implemented.
> 
> [...]

Here is the summary with links:
  - [1/1] net: phy: dp83867: Add led_brightness_set support
    https://git.kernel.org/netdev/net-next/c/938f65adc420

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


