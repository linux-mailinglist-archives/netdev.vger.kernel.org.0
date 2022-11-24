Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 573C163716E
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 05:20:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiKXEUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 23:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbiKXEUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 23:20:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E015C6052;
        Wed, 23 Nov 2022 20:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3B0BB826C9;
        Thu, 24 Nov 2022 04:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 65A7FC43470;
        Thu, 24 Nov 2022 04:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669263616;
        bh=DdzHxBoUY3t1snPG9Xeh+A63SNX1s+9my781uSg9vYM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R2Fg/peztimKPAkj89NkQwzf66jW8uYMHhStrkYAYAFYOjbA7FstL7cT+xJqTa2KI
         pVcZZky0eZjKYFteopU0vS9pTZhH9c0rUpPmBySzBoCGdOSYPq3/aUkNVM0OVUtZE4
         9rfcjSE3EqgSwmFuCjZB08Pt/J6dKFJgTYhw/dypO6YVtSOTiQRuzixWZ3pDUBb7KR
         p5bCllMt2/+EwAerUWRWg7DjwSdkpwukH4r5chPKhDOwUIugt9+vg+3oJkOrAEb/dQ
         T0ZGGOX8NKwiOtvgnQ8CeDJBGc5BIQ/dtVw8QC32CltR3zNqcW3DSTCs9Xo09rwjpk
         5sDq3q9wEHDsA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4B3AEE270C9;
        Thu, 24 Nov 2022 04:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] ethtool: avoiding integer overflow in ethtool_phys_id()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166926361630.22792.11398511927543555936.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Nov 2022 04:20:16 +0000
References: <20221122122901.22294-1-korotkov.maxim.s@gmail.com>
In-Reply-To: <20221122122901.22294-1-korotkov.maxim.s@gmail.com>
To:     Maxim Korotkov <korotkov.maxim.s@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, huangguangbin2@huawei.com, andrew@lunn.ch,
        alexandr.lobakin@intel.com, jacob.e.keller@intel.com,
        trix@redhat.com, marco@mebeim.net, ecree@solarflare.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 22 Nov 2022 15:29:01 +0300 you wrote:
> The value of an arithmetic expression "n * id.data" is subject
> to possible overflow due to a failure to cast operands to a larger data
> type before performing arithmetic. Used macro for multiplication instead
> operator for avoiding overflow.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> [...]

Here is the summary with links:
  - [v3] ethtool: avoiding integer overflow in ethtool_phys_id()
    https://git.kernel.org/netdev/net-next/c/64a8f8f7127d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


