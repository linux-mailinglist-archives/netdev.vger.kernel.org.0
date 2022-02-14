Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A32474B4EBB
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 12:34:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351552AbiBNLef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 06:34:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:32854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351868AbiBNLd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 06:33:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A504F6949C
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 03:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49CB460F97
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 11:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A1A43C340EF;
        Mon, 14 Feb 2022 11:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644837610;
        bh=dtDXFV8w3G58YXDmWF/GEAt2lMOzFK1DoSIdXBteqeA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S9P9N+lBqvCrEszV29P7f5RNyBYvmEiUXH8aFheMEMakqktQhL0mWgAvy/l9DJ/4F
         t+iCnTxSq18a5qVchvenUvB2Usn8LrwX09pu4bTNBPoU0cSr2yMlsBXtMOdruI8/06
         NhiBKWdLhjT9l72Aor1yzV7eW6m1nxnhMDCxhE6BW+NL53xXiDzcpEdqrtvmzwIMza
         ZrVCCAyc1Nkq+H4xFVo1/0T+Qr97Y5uxyVcubRaA8YZD5wMPRkYU1jngPBZEpuzoHj
         /lyeeVWH0pVeiKcSGZhiwuj7CkZIPBlsV60k/4FaiwXKKh4QHlbLQyM9UeM04qlf9u
         CZIZt3HCgc71g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 85182E6D447;
        Mon, 14 Feb 2022 11:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/sched: act_police: more accurate MTU policing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164483761053.10850.17314465755661482816.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Feb 2022 11:20:10 +0000
References: <876d597a0ff55f6ba786f73c5a9fd9eb8d597a03.1644514748.git.dcaratti@redhat.com>
In-Reply-To: <876d597a0ff55f6ba786f73c5a9fd9eb8d597a03.1644514748.git.dcaratti@redhat.com>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ozsh@nvidia.com, echaudro@redhat.com, marcelo.leitner@gmail.com
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 10 Feb 2022 18:56:08 +0100 you wrote:
> in current Linux, MTU policing does not take into account that packets at
> the TC ingress have the L2 header pulled. Thus, the same TC police action
> (with the same value of tcfp_mtu) behaves differently for ingress/egress.
> In addition, the full GSO size is compared to tcfp_mtu: as a consequence,
> the policer drops GSO packets even when individual segments have the L2 +
> L3 + L4 + payload length below the configured valued of tcfp_mtu.
> 
> [...]

Here is the summary with links:
  - [net-next] net/sched: act_police: more accurate MTU policing
    https://git.kernel.org/netdev/net-next/c/4ddc844eb81d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


