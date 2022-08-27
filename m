Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 183D25A33EB
	for <lists+netdev@lfdr.de>; Sat, 27 Aug 2022 04:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238065AbiH0CuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 22:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232233AbiH0CuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 22:50:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D64D34ED;
        Fri, 26 Aug 2022 19:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A06F761DC4;
        Sat, 27 Aug 2022 02:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F32ABC433C1;
        Sat, 27 Aug 2022 02:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661568616;
        bh=os270vXfGSIivsAz52bNqKvdrgy0Wc7xuBxU/UvcZSA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ic0SNvHFTiPY5poENWQ5MWemamzJvuRcAQ3L/xZprAvTirlqb/txsXgIBkZYFpT81
         sXCrUkia+n5CzMX96ED3szZ8HmIlrKs9cvxE6TvFyVWepO6XVQ4/uj9TkfVUcm0aC2
         lLNRVf0/DbFUDVi/iv9hd1ZzNwokoNxrxlxFwrEdscM2Kw7gh0dZ3ZG7rdaU8yEGQb
         uY44ZQv3Hc+Bsn8fWwy4JUkCHed/t65N+P6kKL2EXmAnqpWyKr1P7GLFmdO6svmikB
         GOcuwSUFmnrAHUhhEy4BMlpAF4uBjfqkblIq7o3RzVI6GkSk7HyaQy3IQ3y8mcu2Cn
         Jn+9vDH6MePJw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D3452E2A042;
        Sat, 27 Aug 2022 02:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net_sched: remove impossible conditions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166156861586.29832.8019964906111296555.git-patchwork-notify@kernel.org>
Date:   Sat, 27 Aug 2022 02:50:15 +0000
References: <Ywd4NIoS4aiilnMv@kili>
In-Reply-To: <Ywd4NIoS4aiilnMv@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 25 Aug 2022 16:25:08 +0300 you wrote:
> We no longer allow "handle" to be zero, so there is no need to check
> for that.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This obviously is low priority so it could go to net-next instead.
> 
> [...]

Here is the summary with links:
  - [net] net_sched: remove impossible conditions
    https://git.kernel.org/netdev/net-next/c/53a406803ca5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


