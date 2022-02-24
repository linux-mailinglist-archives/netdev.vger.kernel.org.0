Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA0C74C33DA
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 18:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbiBXRkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 12:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232116AbiBXRkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 12:40:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 388461C2DAA
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 09:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2EBAB8280F
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 17:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7895DC340F3;
        Thu, 24 Feb 2022 17:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645724410;
        bh=L/zhZneWAWhyhij0FBlOpZHtssRG+/rj1hUO/C54jyc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ayFhr0pwoqo2+rre1OsGaYZZwVByiyuOnoRe8KtCPUzYV3pprsrWrJH36RC3ETcAz
         JUTuFjGQiPcoxhu5jeotvVAoSt94Dti/QKRL5qbDw6jf0tgx8OvhunMVmBV97gFkeF
         chN/Au5UnHxhOdTRuhmIjIgUtwxp+qcKEYZT4H3xbhrnrPnmhEJykF0dbduB6dOmLz
         hwLM/QkEm9uBmPFnpfTE7yEnDkO+/WGu4kWeYwMGTvKOlN3m1qfOhqSdNDWO7ZbaZ4
         2R1BxOIU1q1/OaaIBlCTW0ExO9pK/mHaz7ojrpW/vXki+DMLbcCRD+OiRnFEWXhTC/
         ImPD6xhQuJMxA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5CFC9EAC09B;
        Thu, 24 Feb 2022 17:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v5 1/1] openvswitch: Fix setting ipv6 fields causing hw
 csum failure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164572441037.16635.16112919263701735422.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Feb 2022 17:40:10 +0000
References: <20220223163416.24096-1-paulb@nvidia.com>
In-Reply-To: <20220223163416.24096-1-paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>
Cc:     dev@openvswitch.org, netdev@vger.kernel.org, jhs@mojatatu.com,
        pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org,
        echaudro@redhat.com, ozsh@nvidia.com, vladbu@nvidia.com,
        roid@nvidia.com, lariel@nvidia.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 23 Feb 2022 18:34:16 +0200 you wrote:
> Ipv6 ttl, label and tos fields are modified without first
> pulling/pushing the ipv6 header, which would have updated
> the hw csum (if available). This might cause csum validation
> when sending the packet to the stack, as can be seen in
> the trace below.
> 
> Fix this by updating skb->csum if available.
> 
> [...]

Here is the summary with links:
  - [net,v5,1/1] openvswitch: Fix setting ipv6 fields causing hw csum failure
    https://git.kernel.org/netdev/net/c/d9b5ae5c1b24

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


