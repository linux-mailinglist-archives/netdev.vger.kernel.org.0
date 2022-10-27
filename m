Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE27B60FF76
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 19:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235955AbiJ0Rkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 13:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235586AbiJ0RkY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 13:40:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA265788F
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 10:40:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCD09B8271A
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 17:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 71112C433D6;
        Thu, 27 Oct 2022 17:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666892419;
        bh=oyEfmyVfKFa0KWlTTgTYvrli8uAeOpDBiE/l2VtcOG0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oWkRVRYp6+ZHgzag9TUeXVf2ydj9LWcFbxf5Mcr2rCwV9U/USWSHYUHjh3EBxCZeB
         Z2UbUq+rbkQAI+CVZZv/rcvRVHldvgf0zwEim6IahwHUE4meDGHNMaitv++use30Rb
         75B26XDgaqJPy8YE6dX3JsP/tikcX/yhcwyYtRNoEtTtPAPOv/E/tgjk5QGM0KeYnY
         rqvRsmfSVsFFEncxLmG9IWWyD9ryYdmZhM3R83yJUJ+of+2nIZA1p1gzCj7nFwD1T3
         AJDnnp+0a+A+Nnq2H9rIcKYuu3xMfdbrbVzCw6SZbyNCN5Slfui36/qMddFrgYGcNf
         9Oke4L7AHpDFw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4BF99C4166D;
        Thu, 27 Oct 2022 17:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: broadcom: bcm4908_enet: update TX stats after actual
 transmission
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166689241930.10875.14172148368674030998.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 17:40:19 +0000
References: <20221027112430.8696-1-zajec5@gmail.com>
In-Reply-To: <20221027112430.8696-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tpIDx6YWplYzVAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, rafal@milecki.pl,
        f.fainelli@gmail.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 27 Oct 2022 13:24:30 +0200 you wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Queueing packets doesn't guarantee their transmission. Update TX stats
> after hardware confirms consuming submitted data.
> 
> This also fixes a possible race and NULL dereference.
> bcm4908_enet_start_xmit() could try to access skb after freeing it in
> the bcm4908_enet_poll_tx().
> 
> [...]

Here is the summary with links:
  - net: broadcom: bcm4908_enet: update TX stats after actual transmission
    https://git.kernel.org/netdev/net/c/ef3556ee16c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


