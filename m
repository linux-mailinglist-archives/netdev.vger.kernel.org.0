Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB62A63851E
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 09:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbiKYIUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 03:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiKYIUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 03:20:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA03B201B3;
        Fri, 25 Nov 2022 00:20:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44159622EA;
        Fri, 25 Nov 2022 08:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A04FEC43147;
        Fri, 25 Nov 2022 08:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669364416;
        bh=kQVXv6pPvEM0IpXOMW+VapW3A5XBAmE9zIXDe2QHk9Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iRF2TMcSI74Q+tYrGSynRfWqis0behPZR6m+ooFITy4rDbXDsW1JM/zjjzsRMuntG
         UuxTgKe7ZgXt4yvPfJ25eULUJSNwuk55ShTEaZwIduxShXDK7QqjSQQY0Zg5eT2rIn
         AFOIjBTpVISyReFND9N5+5iETu8UDEiUiDmWOsr1gBBzK1mNZaq3CeS1i+WAjmcQu/
         KUQO4xt2J/WXwzRUTdCkT0X3MluFnug8IHXT/xGSwZI1pWC4VV/jmPJxZ97QUyLlP7
         HueSrrU8nsYhDbLkGYjbe67NjYVrVoWlRIRB4w9G9EYj/qh4Am1viSS2oqUl9TVXiQ
         o82rX95WQaPrQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8AB3DE50D6A;
        Fri, 25 Nov 2022 08:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] lib/test_rhashtable: Remove set but unused variable
 'insert_retries'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166936441656.8812.16306518757917727950.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Nov 2022 08:20:16 +0000
References: <20221123093702.32219-1-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <20221123093702.32219-1-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     tgraf@suug.ch, herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, abaci@linux.alibaba.com
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
by David S. Miller <davem@davemloft.net>:

On Wed, 23 Nov 2022 17:37:02 +0800 you wrote:
> Variable 'insert_retries' is not effectively used in the function, so
> delete it.
> 
> lib/test_rhashtable.c:437:18: warning: variable 'insert_retries' set but not used.
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3242
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - [v2] lib/test_rhashtable: Remove set but unused variable 'insert_retries'
    https://git.kernel.org/netdev/net-next/c/b084f6cc3563

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


