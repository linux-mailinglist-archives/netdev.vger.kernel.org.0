Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D30652CB2E
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 06:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233705AbiESEkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 00:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbiESEkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 00:40:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEEA5DA45
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 21:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7AF0619B3
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 04:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 196B0C34115;
        Thu, 19 May 2022 04:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652935213;
        bh=GengvdPnnNJJFXUwQ7fIWyO7uiyEHWAdF0YsAbHPCr4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NZvgM08rJS7AummB7rs8U7xLp9ZVjKWcy3USm5sJiA3/qSHCJWEGwGKx/fPhboTiH
         kOXxTf2kWWNjyVz97kP5RxiS5Oce/6MFZGw6wdj9/M+730NuUhWFpf5YvrVA8vEmwf
         Zqv4qY7EpHA7oyc+rSUyrmJwz1f5VENIwOVvmFW92FEpB4xuRkRQQPka10Y85v5XcN
         9AS/FVaAc/zF757gfczZ9veCrsAEY+VX/guSeFFUqG6nj1NbaRroDpHuyKuH5tBvK3
         iyA8u+JBKPmndjXiZ38cjWuZL5bhLuChAjZsvICKast7PwV8HHqK6sRKDt1LONxHIN
         UWVZb4NC5zJCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F2E95F0393A;
        Thu, 19 May 2022 04:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] selftests: forwarding: fix missing backslash
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165293521299.13143.3237253527431447066.git-patchwork-notify@kernel.org>
Date:   Thu, 19 May 2022 04:40:12 +0000
References: <20220518151630.2747773-1-troglobit@gmail.com>
In-Reply-To: <20220518151630.2747773-1-troglobit@gmail.com>
To:     Joachim Wiberg <troglobit@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, liuhangbin@gmail.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 18 May 2022 17:16:30 +0200 you wrote:
> Fix missing backslash, introduced in f62c5acc800ee.  Causes all tests to
> not be installed.
> 
> Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
> ---
>  tools/testing/selftests/net/forwarding/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next,1/1] selftests: forwarding: fix missing backslash
    https://git.kernel.org/netdev/net/c/090f9dd092c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


