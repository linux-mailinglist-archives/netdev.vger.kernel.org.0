Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5375515228
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 19:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379671AbiD2Rdv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 13:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379544AbiD2Rde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 13:33:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCCE6343
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 10:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C4C6623E7
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 17:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7CEBC385AE;
        Fri, 29 Apr 2022 17:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651253412;
        bh=v1+RR9Xe8nKeuCrceUSGmfuEN/9OuRBOsNHM0dvMP6w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c8vsUOJ1LWaVPmeIzCyOgY10a+mSxgu+YvK7nzV79cWXggH8ZJ/xclXVc+GKqHAke
         wwYxqJ6UFtJ8IdG7z8k4V8fWwuT6k+jWote/sMjoglmtu782vxIRxk3zSnsOGXN3zw
         fpcD0k77f15bTbhn7Xi80h4N7pxpJSmeiSgeyqLvvUyDYCS/ti8JUrRHTxQu499xoZ
         KyhXpg6FraKDo8o5INZF4QnTBhbDmzTWaJ1050mDR33DRfXL39L6jnCM6bjT33Ry13
         CP+BEvp5mVmaFAvNqsGCBO1dBfYrDg1POshgPWJU7s37xAs8/KlwLQSWky5rpyEunR
         7jtXrSOIqWaHQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A6BC0E5D087;
        Fri, 29 Apr 2022 17:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next] f_flower: add number of vlans man entry
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165125341266.6491.2584666941141681855.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Apr 2022 17:30:12 +0000
References: <20220428083233.5110-1-boris.sukholitko@broadcom.com>
In-Reply-To: <20220428083233.5110-1-boris.sukholitko@broadcom.com>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org,
        ilya.lifshits@broadcom.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Thu, 28 Apr 2022 11:32:33 +0300 you wrote:
> The documentation was missing in the number of vlans commit.
> 
> Fixes: 5ba31bcf (f_flower: Add num of vlans parameter)
> Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
> ---
>  man/man8/tc-flower.8 | 5 +++++
>  1 file changed, 5 insertions(+)

Here is the summary with links:
  - [iproute2-next] f_flower: add number of vlans man entry
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=a6eb654d1cf6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


