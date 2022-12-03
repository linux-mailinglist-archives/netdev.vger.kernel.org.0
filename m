Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3059F641450
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 06:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231442AbiLCFac (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 00:30:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbiLCFaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 00:30:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B19BF2EF72;
        Fri,  2 Dec 2022 21:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59108B8236F;
        Sat,  3 Dec 2022 05:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E4A38C433B5;
        Sat,  3 Dec 2022 05:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670045418;
        bh=2z1WTvnwzKytK1JC1S/Jspyn3dVooutblZHK4E6rKpA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UrHqAkmkwZrB+1nRy7HBIn9Kr8UvwVHRmdq9TsfrqE/wWHJX5joh60w4/l5kLdnr7
         HMKAoG8PwF5HLZGPuZEtlwIqh9IeuNYxQSgYtiS4Ybrz/jlRV8c7z0Vk3l/FzV9Qsu
         yF80F7LirkTh5MvGp+QujhzFMb2yKl2AuIVHRxnIQhGFT4h1GcxRwrM2OkqWJFsmVx
         lsiYJs4XkPrZWPCdMqUqlDcn5y9tYyQw41eGawFFwfNqMNMyaqaz4Ge5M+v9TBFqNM
         gOh1VEJC+mffmE0d953veD7fWt4erhNcC4/tn/zj6p4WzlR+cEbrLoD5BEAqmU55KA
         19UO/ODx9+Ovg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C3BFEE29F40;
        Sat,  3 Dec 2022 05:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests: net: Use "grep -E" instead of "egrep"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167004541779.20517.3590243426565282994.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Dec 2022 05:30:17 +0000
References: <1669864248-829-1-git-send-email-yangtiezhu@loongson.cn>
In-Reply-To: <1669864248-829-1-git-send-email-yangtiezhu@loongson.cn>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu,  1 Dec 2022 11:10:48 +0800 you wrote:
> The latest version of grep claims the egrep is now obsolete so the build
> now contains warnings that look like:
> 	egrep: warning: egrep is obsolescent; using grep -E
> fix this using "grep -E" instead.
> 
>   sed -i "s/egrep/grep -E/g" `grep egrep -rwl tools/testing/selftests/net`
> 
> [...]

Here is the summary with links:
  - selftests: net: Use "grep -E" instead of "egrep"
    https://git.kernel.org/netdev/net/c/6a30d3e3491d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


