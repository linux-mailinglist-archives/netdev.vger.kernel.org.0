Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D55DE619455
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 11:20:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231542AbiKDKUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 06:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbiKDKUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 06:20:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C086913E05;
        Fri,  4 Nov 2022 03:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5FD756213C;
        Fri,  4 Nov 2022 10:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BC74DC433C1;
        Fri,  4 Nov 2022 10:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667557216;
        bh=pPEnncCTz2EtjOknSSKgRJprcEPtzDivReJFeiusk5U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jHpa6rispekGwnpWVVH6f2vXCf42q0pFSM7CATR79AYwk2GzN4KF+Wbi2eAEveL7P
         fI9D3TwzOkOo/KVaaXgjU6xYJ3m5S9YFwR4XWUEyK0c6ohFpVp69jw99+R5uN0iYZ5
         WXVD+q6KDPC4sY1tg7qTA+S010os3GC4zJ1sV0F4IiEvZ3MC4kq5U4WBGxD/+edXqa
         F9y+ThPCt9hYY+SedEtMAC2AsdRtpv/TumV18yyKefYKye+fe+f3IBt+lrwnOckisN
         S8CBFKQgJdm+g8Fk3OTlQBT/drPEUODwTO3seyxFrzNLTM8Km+DEj03R+nsm3YGTkW
         5nIhxzJv6AvYg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9A986E29F4C;
        Fri,  4 Nov 2022 10:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests/net: give more time to udpgro bg processes to
 complete startup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166755721662.22576.1172812278551216334.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Nov 2022 10:20:16 +0000
References: <20221101184809.50013-1-athierry@redhat.com>
In-Reply-To: <20221101184809.50013-1-athierry@redhat.com>
To:     Adrien Thierry <athierry@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
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

On Tue,  1 Nov 2022 14:48:08 -0400 you wrote:
> In some conditions, background processes in udpgro don't have enough
> time to set up the sockets. When foreground processes start, this
> results in the test failing with "./udpgso_bench_tx: sendmsg: Connection
> refused". For instance, this happens from time to time on a Qualcomm
> SA8540P SoC running CentOS Stream 9.
> 
> To fix this, increase the time given to background processes to
> complete the startup before foreground processes start.
> 
> [...]

Here is the summary with links:
  - selftests/net: give more time to udpgro bg processes to complete startup
    https://git.kernel.org/netdev/net/c/cdb525ca92b1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


