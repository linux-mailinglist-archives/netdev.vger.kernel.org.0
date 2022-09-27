Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC0AE5EBD9B
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 10:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbiI0Ik2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 04:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbiI0IkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 04:40:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7482E13CD3;
        Tue, 27 Sep 2022 01:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22134B81A65;
        Tue, 27 Sep 2022 08:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D71C5C433C1;
        Tue, 27 Sep 2022 08:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664268013;
        bh=b0ZhK3hV/o09XXYsHPWRPM8C5arDiG7mKJX0iGy8btE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XbvvONQN6Bilzl8wobbB5Zr2xhM1Rf2wGmmG0Y7/h2ASSbQaqEXI7yB6b6CvXK+Rl
         ZrxZt4ns5Z+CvjYNCqgWsBE7KP5b/01WxAXDk/asbpnZH9SWwOuaDj12aTNQ8/r+dA
         pw/3cYWc1JB3zlCDh9hx41w6bFr2OVOE8Mbr31daSLQ5xJsY+6Et3Zd4VkBbeo9tD2
         BYRkJ6/LJYh705mbHMEhHhchn77Rl1ilHfwQCFxMcSyq9LmE0ROdVKBHuvUvLYZoit
         NmBKE64Qnowl9xyDuO1chiZrkj8hMCJhec9EjsaFn38z8cYWJrOwi/KDh8r6lhfxhx
         +51iT4VkCoS/g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BC4F1E21EC2;
        Tue, 27 Sep 2022 08:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/smc: Support SO_REUSEPORT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166426801376.10582.14892411464781451134.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Sep 2022 08:40:13 +0000
References: <20220922121906.72406-1-tonylu@linux.alibaba.com>
In-Reply-To: <20220922121906.72406-1-tonylu@linux.alibaba.com>
To:     Tony Lu <tonylu@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Thu, 22 Sep 2022 20:19:07 +0800 you wrote:
> This enables SO_REUSEPORT [1] for clcsock when it is set on smc socket,
> so that some applications which uses it can be transparently replaced
> with SMC. Also, this helps improve load distribution.
> 
> Here is a simple test of NGINX + wrk with SMC. The CPU usage is collected
> on NGINX (server) side as below.
> 
> [...]

Here is the summary with links:
  - [net-next] net/smc: Support SO_REUSEPORT
    https://git.kernel.org/netdev/net-next/c/6627a2074d5c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


