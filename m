Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDA960B8EA
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 21:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiJXT7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 15:59:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233945AbiJXT6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 15:58:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE9627E07B;
        Mon, 24 Oct 2022 11:21:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1746F61532;
        Mon, 24 Oct 2022 18:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6DF4DC433D6;
        Mon, 24 Oct 2022 18:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666635618;
        bh=QCZRAB01/HVGTv6Ncloc2hbCHm9JQtsbxlhg6H9axV8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eLCYFiAFx0kcI4Sw9M34QyjQ7nEvBvnHyKeoXTQlDoB1lRTuzjQN0LbEPooaSm5+w
         uI3Du1ao003VIBjxkNp+jElnpyQR1zlXiDyhbcSKYJnNbBOnznT3xbQETysVR3muWe
         1B24Jzmkd2RHfCwLT0Um5kUxLsby2XiaLfbmKrpA9nrzIHPsaFp1xrBJQDs0VfQuxN
         xM7xZAPO7pW3rpY+q/nd9qahaLj6yJqX3yvuJhcHoJZL7NUvotMav+LvL/ltOc8qWo
         e/diZMnUQuc2k/T3E4xW+c6FTnF6Ko2RIGTghQWSXvg4iii+2hYvLCXYJdJnG7fOk7
         Li2TWLQwb+r0g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4D0EBE4D005;
        Mon, 24 Oct 2022 18:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net-memcg: avoid stalls when under memory pressure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166663561831.26708.58782572819195454.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Oct 2022 18:20:18 +0000
References: <20221021160304.1362511-1-kuba@kernel.org>
In-Reply-To: <20221021160304.1362511-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     edumazet@google.com, netdev@vger.kernel.org, davem@davemloft.net,
        pabeni@redhat.com, cgroups@vger.kernel.org,
        roman.gushchin@linux.dev, shakeelb@google.com, weiwan@google.com,
        ncardwell@google.com, ycheng@google.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 21 Oct 2022 09:03:04 -0700 you wrote:
> As Shakeel explains the commit under Fixes had the unintended
> side-effect of no longer pre-loading the cached memory allowance.
> Even tho we previously dropped the first packet received when
> over memory limit - the consecutive ones would get thru by using
> the cache. The charging was happening in batches of 128kB, so
> we'd let in 128kB (truesize) worth of packets per one drop.
> 
> [...]

Here is the summary with links:
  - [net] net-memcg: avoid stalls when under memory pressure
    https://git.kernel.org/netdev/net/c/720ca52bcef2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


