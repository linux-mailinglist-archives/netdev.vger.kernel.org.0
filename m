Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8F94BA695
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 18:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237990AbiBQRA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 12:00:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:44872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbiBQRAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 12:00:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8361E1A340B;
        Thu, 17 Feb 2022 09:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1ED236178A;
        Thu, 17 Feb 2022 17:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 810F3C340EC;
        Thu, 17 Feb 2022 17:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645117210;
        bh=gueckinjtOEIjelF1xO+nt1DmFDCQUSBxCQCM9yYzWU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qw72mNq/xXwGORKaRPncZHgA5VCcWV1OV2LEKwCS595ZOh9bzA37f8EztIvjQAbXc
         wYEx8XjgCpopejKhsbnTdvz9eurbwyPO9Ry75NpjnwTLBv7clYIgWJyFgi76mArrMP
         u4x5xOySTXqr3NQTchaOX6Z3D7dEmDAea+mHa4ktXzVjUxQQIDsL9eA6Z2hnWWcrsV
         NIgIQMwYrxQ27rycA300TlatQWXN3/6G+s/ZWPiHE0eyYFLqOiV+Excvqjk09z2BVR
         3mL53JZxfP1wJZRcmGNt+0RXqWiJ2hXqCbvWCXw7T2zMhqWOTGtHGtbUcB5eo6deQO
         lKbdGxqEmoptw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 66BBFE6D446;
        Thu, 17 Feb 2022 17:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "net: ethernet: bgmac: Use
 devm_platform_ioremap_resource_byname"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164511721041.14515.4448188702966988874.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Feb 2022 17:00:10 +0000
References: <20220216184634.2032460-1-f.fainelli@gmail.com>
In-Reply-To: <20220216184634.2032460-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, jonas.gorski@gmail.com,
        rafal@milecki.pl, bcm-kernel-feedback-list@broadcom.com,
        davem@davemloft.net, kuba@kernel.org, yangyingliang@huawei.com,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 16 Feb 2022 10:46:34 -0800 you wrote:
> From: Jonas Gorski <jonas.gorski@gmail.com>
> 
> This reverts commit 3710e80952cf2dc48257ac9f145b117b5f74e0a5.
> 
> Since idm_base and nicpm_base are still optional resources not present
> on all platforms, this breaks the driver for everything except Northstar
> 2 (which has both).
> 
> [...]

Here is the summary with links:
  - [net] Revert "net: ethernet: bgmac: Use devm_platform_ioremap_resource_byname"
    https://git.kernel.org/netdev/net/c/6aba04ee3263

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


