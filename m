Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF702530D5C
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 12:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232759AbiEWJKh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 05:10:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232480AbiEWJK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 05:10:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D7E4666B;
        Mon, 23 May 2022 02:10:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0314460FDA;
        Mon, 23 May 2022 09:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5DB16C34116;
        Mon, 23 May 2022 09:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653297022;
        bh=qy+0osjsCOFr+lHjvrqan0OPUPodV0O8rSz2sIFeUUQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GHozS3Hxhv93rqXrGDOLP5AJ0gerfd8RzqJTxD1IKxcSQHxpKKbWs3r0mmC0Oum4v
         bYa1Bg9WVSQE8X/VTEWwoAYj/96s18yCCLQre3qU/HmTNkYVWZZ9QGR2sr9UjgHWft
         lt1dXCUief0yo0n5xIeARWUZdh7ygMUBmpO+KEkoSmiH/b/IxgPqfNlzFRE+Mgbmyc
         23UEJYOX8TcF15ptgXZkS6KUVclArDMdDiDtOhooahFPH/oGExzZstCscIqOu/5OTg
         mqZ+Svf6aiVJizXn6sOj791iHhOAj04nlH0irb7as8oUBSSz0CtD6ZO/tBBhbsBWbU
         nQuWm0bIfKX0w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 487F2EAC081;
        Mon, 23 May 2022 09:10:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net/smc: postpone sk_refcnt increment in connect()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165329702229.13209.6286752264509182107.git-patchwork-notify@kernel.org>
Date:   Mon, 23 May 2022 09:10:22 +0000
References: <20220523045707.1704761-1-liuyacan@corp.netease.com>
In-Reply-To: <20220523045707.1704761-1-liuyacan@corp.netease.com>
To:     None <liuyacan@corp.netease.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ubraun@linux.ibm.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Mon, 23 May 2022 12:57:07 +0800 you wrote:
> From: liuyacan <liuyacan@corp.netease.com>
> 
> Same trigger condition as commit 86434744. When setsockopt runs
> in parallel to a connect(), and switch the socket into fallback
> mode. Then the sk_refcnt is incremented in smc_connect(), but
> its state stay in SMC_INIT (NOT SMC_ACTIVE). This cause the
> corresponding sk_refcnt decrement in __smc_release() will not be
> performed.
> 
> [...]

Here is the summary with links:
  - [v2,net] net/smc: postpone sk_refcnt increment in connect()
    https://git.kernel.org/netdev/net/c/75c1edf23b95

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


