Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDD7560FCE
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 06:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230076AbiF3EAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 00:00:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiF3EAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 00:00:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A6FB27CC4;
        Wed, 29 Jun 2022 21:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB423620B3;
        Thu, 30 Jun 2022 04:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78268C341D6;
        Thu, 30 Jun 2022 04:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656561614;
        bh=hcLWaRkJxY1Ey58GTAW64dYutAo+YabHm/Nn+JVelgk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tly59KC0SBlB9ddDutluHLX17CCMqDsx7CSQUX/+t/maS138yfJVF5yE3FPD55R3Y
         Xg4OMDH94wq7XU+eEI56pp8021sL2zWKlWX388hr5KY5H5Px2NfDd1Q6taOWdZF0RF
         fsMTNvT1276cDjOnrrxcEGrsKSSBameHz0x37Par6kDu0J5/6mQmd1/lSiOqpScC4g
         nKHxsjaOSEH+niT4joWFemCanUgaQq9lRhkBFT29rAhpncaC8WMxEL7ZhzBJ1iysg1
         ljHfK0aAneA7KcV+sFAQXzF6Der4VNwm+gvnGxO9yZ1D5xNACtDxqnhwFURrW6svV1
         qNnabsC4kLe7w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 61AAAE49BBA;
        Thu, 30 Jun 2022 04:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipv6: remove redundant store to value after addition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165656161439.1686.17032985946330755868.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Jun 2022 04:00:14 +0000
References: <20220628145406.183527-1-colin.i.king@gmail.com>
In-Reply-To: <20220628145406.183527-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 28 Jun 2022 15:54:06 +0100 you wrote:
> There is no need to store the result of the addition back to variable count
> after the addition. The store is redundant, replace += with just +
> 
> Cleans up clang scan build warning:
> warning: Although the value stored to 'count' is used in the enclosing
> expression, the value is never actually read from 'count'
> 
> [...]

Here is the summary with links:
  - ipv6: remove redundant store to value after addition
    https://git.kernel.org/netdev/net-next/c/74fd304f2395

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


