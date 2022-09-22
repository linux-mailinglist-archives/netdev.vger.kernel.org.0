Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D15545E5805
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 03:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbiIVBaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 21:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230307AbiIVBaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 21:30:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BF49E8AF;
        Wed, 21 Sep 2022 18:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2AE362E19;
        Thu, 22 Sep 2022 01:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1BA74C43470;
        Thu, 22 Sep 2022 01:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663810216;
        bh=QbJszHzmsEoyoiMjuBJIWkjs4j9BZnNPZaHSPS7grjs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YAgX9zNtTrCrZI8jTgRkuworUqgZD0y7GoD6DXmQZ/1zoedvfTyfc5lIV12Ix65lJ
         a9DHiJjAF1PXFMm8E4t+q6EJPqAe/wIT7yxzYyLaTC+kRx42U203rTMFIrVCaZ2PRl
         wqaWuy45gXApboguxlExbpUOqwvq4UVcB96L5/RUhCjtc53jGzmTH9q5aInz0uSW5s
         qVQN645wolDVsWT7e/cnbF8VZ14MvGHpa5sb0t8oZaQA4bevELuTH08lNJGurL5LjD
         1OaR/UcN0mUxG1mV875EmyTBhy7e0hLcbxVvQTVl/4Qq3hPZZKlgaAJ9KWDfBOP7wU
         lWOznB0aORFSA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ECDA9E4D03D;
        Thu, 22 Sep 2022 01:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: sched: simplify code in mall_reoffload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166381021596.720.12592169293832991365.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 01:30:15 +0000
References: <20220917063556.2673-1-williamsukatube@163.com>
In-Reply-To: <20220917063556.2673-1-williamsukatube@163.com>
To:     None <williamsukatube@163.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Sat, 17 Sep 2022 14:35:56 +0800 you wrote:
> From: William Dean <williamsukatube@163.com>
> 
> such expression:
> 	if (err)
> 		return err;
> 	return 0;
> can simplify to:
> 	return err;
> 
> [...]

Here is the summary with links:
  - [-next] net: sched: simplify code in mall_reoffload
    https://git.kernel.org/netdev/net-next/c/2801f30e2cef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


