Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A16761352D
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 13:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiJaMAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 08:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiJaMAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 08:00:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99FF95586;
        Mon, 31 Oct 2022 05:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33230611DA;
        Mon, 31 Oct 2022 12:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 72612C433D7;
        Mon, 31 Oct 2022 12:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667217616;
        bh=Lj6fOi0fH77D+aFtolDors/yRRGcoNoRxy1ro/ZWgew=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jfFOSv0u7PNjzuBRNGyows97B9PGsR+FoB/hc2s5PeYeJiw9zTpAint30755QepRJ
         QBaZb8EibUEUulYx+C82/ltZmQV2txnbicvboQg/fZzemJPPD+VI3rauMHWf2mWwsZ
         UWcnIBsdv92KeRfkfMwo4d50GJo4G0mSBy4837283G81hQ88osuW8BMztOG8g07Neh
         C2Xgjfq7bzQCR2NHQgaCaZ2uogiZn0KYMokcZs28keJuL8oCs17UrIjqtIByeXPPO8
         XHwR+vYMkPy0Ya/eXniQK8LnuuOcM2W8HHUR3EbF/Fayd8pHTe4NGaQXkC144MYngK
         y1LcKb5l1tfQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5A426E270D6;
        Mon, 31 Oct 2022 12:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sched: Fix use after free in red_enqueue()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166721761636.1563.6943148452161990990.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Oct 2022 12:00:16 +0000
References: <Y1vvnBnSVl976Pt3@kili>
In-Reply-To: <Y1vvnBnSVl976Pt3@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, toke@toke.dk,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, harshit.m.mogalapalli@oracle.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Oct 2022 18:05:00 +0300 you wrote:
> We can't use "skb" again after passing it to qdisc_enqueue().  This is
> basically identical to commit 2f09707d0c97 ("sch_sfb: Also store skb
> len before calling child enqueue").
> 
> Fixes: d7f4f332f082 ("sch_red: update backlog as well")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> [...]

Here is the summary with links:
  - [net] net: sched: Fix use after free in red_enqueue()
    https://git.kernel.org/netdev/net/c/8bdc2acd420c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


