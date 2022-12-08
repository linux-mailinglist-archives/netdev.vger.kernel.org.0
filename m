Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1B46474F0
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 18:20:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiLHRUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 12:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiLHRUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 12:20:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D488C6BD;
        Thu,  8 Dec 2022 09:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9743CB82583;
        Thu,  8 Dec 2022 17:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 49902C433F2;
        Thu,  8 Dec 2022 17:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670520016;
        bh=+qWr5OgV+ASUPlcQiDwWmxYKt772L4SsruZm0A+X7DM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MyiCsCfrw2ugo1U30Cos31ZjVCkHU3QHRJf04cJXhx8LCxG7VRYNVPlNeP8PkOaj0
         f0UwKuqbvSL/PombYwekXuiWD3REd5o6GGa5yjGwrl7NCJNeEN2hhYvhC7YV3Bqt6Q
         booW3LuFu1FfRnmpTYV4T1rEVwzeiXLyJOFofBsFwD2qjkzPA4qui40TI3dYUBB+bL
         rGviUKI+BV6hvcBBiarPDPxTWZ4qDY9VsgtYshR1SoRXhuBCYH7Xfv3KzboDm91hqF
         OjKQuWVJXPnB4gUfpTLcAHZQ48ZEApUwEKU6f0Z4zg9EzksjDf88Q1wc43HS7D9dSJ
         evWGaDYiau5hg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 20FE5C00442;
        Thu,  8 Dec 2022 17:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: mvneta: Fix an out of bounds check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167052001612.19571.10773749806364386937.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Dec 2022 17:20:16 +0000
References: <Y5A7d1E5ccwHTYPf@kadam>
In-Reply-To: <Y5A7d1E5ccwHTYPf@kadam>
To:     Dan Carpenter <error27@gmail.com>
Cc:     thomas.petazzoni@bootlin.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 7 Dec 2022 10:06:31 +0300 you wrote:
> In an earlier commit, I added a bounds check to prevent an out of bounds
> read and a WARN().  On further discussion and consideration that check
> was probably too aggressive.  Instead of returning -EINVAL, a better fix
> would be to just prevent the out of bounds read but continue the process.
> 
> Background: The value of "pp->rxq_def" is a number between 0-7 by default,
> or even higher depending on the value of "rxq_number", which is a module
> parameter. If the value is more than the number of available CPUs then
> it will trigger the WARN() in cpu_max_bits_warn().
> 
> [...]

Here is the summary with links:
  - [net,v2] net: mvneta: Fix an out of bounds check
    https://git.kernel.org/netdev/net/c/cdd97383e19d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


