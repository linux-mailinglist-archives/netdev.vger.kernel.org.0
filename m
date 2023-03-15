Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6467B6BAA9D
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbjCOIUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCOIUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24A1D1A64C;
        Wed, 15 Mar 2023 01:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACB5F61C03;
        Wed, 15 Mar 2023 08:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1343EC433EF;
        Wed, 15 Mar 2023 08:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678868418;
        bh=JypeBE5SEgcdZLpEqXnwicW8PFwnoZF0s++ovdaqtLc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mIyF5sCmCkIgZ30NkeBSQvUqivgc2bzrVSXh912Op3CWY6y0ICn+6JzY66aMaQwbk
         XZsboFWRxhHFQNIKPpCkb6VB0Xd4ad/TWj5KNYSsWO8nuXTVNYmU6HZn00grUUdXPi
         MpnHl11YJlFTXTb/Q+mTYF3YjzdhIRAulPRp3zaOAjcW/Mrz2fcuTDlVChACfkORoG
         ZbB8NT6Xz/Dl+wwKgcZxXW1lHPJWdYZbhDvLGRoQGwazfoVSFheStPvTSFoGiEZxmO
         5eR/pNyCsBxfu5KDXSRLQk1Jmi9f3VhWq/S3x0zjIpeuJikr0W2hvm63cx/mdQ3G3K
         XeEzEBrGdsdXA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ED410E66CBC;
        Wed, 15 Mar 2023 08:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net/smc: Fixes 2023-03-01
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167886841796.29094.5229369446837887446.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Mar 2023 08:20:17 +0000
References: <20230313100829.13136-1-wenjia@linux.ibm.com>
In-Reply-To: <20230313100829.13136-1-wenjia@linux.ibm.com>
To:     Wenjia Zhang <wenjia@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        hca@linux.ibm.com, kgraul@linux.ibm.com, wintera@linux.ibm.com,
        jaka@linux.ibm.com, raspl@linux.ibm.com, tonylu@linux.alibaba.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 13 Mar 2023 11:08:27 +0100 you wrote:
> The 1st patch solves the problem that CLC message initialization was
> not properly reversed in error handling path. And the 2nd one fixes
> the possible deadlock triggered by cancel_delayed_work_sync().
> 
> Stefan Raspl (1):
>   net/smc: Fix device de-init sequence
> 
> [...]

Here is the summary with links:
  - [net,1/2] net/smc: fix deadlock triggered by cancel_delayed_work_syn()
    https://git.kernel.org/netdev/net/c/13085e1b5cab
  - [net,2/2] net/smc: Fix device de-init sequence
    https://git.kernel.org/netdev/net/c/9d876d3ef27f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


