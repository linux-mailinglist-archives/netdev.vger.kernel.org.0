Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4CA263348A
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 05:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiKVEuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 23:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbiKVEuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 23:50:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA0E27B13
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 20:50:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39A0CB81974
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 04:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DA999C433C1;
        Tue, 22 Nov 2022 04:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669092616;
        bh=t88z6fTjoOuRlXycSEIcIjTZVa9XDO3N8qJHqE8t+uk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EZo86+u9ayDWjKIENbg9VlsqrGFRQjdMQ8vCva3uGw0pPG1AU1m0aBTUOEDCeqLch
         ZAJ3UJfLTsCPwJ/m8q6vu6POHJaaT26hTzNqXLxt2rZSqNDwi+bKjVfYZIodXSoelC
         MS9QVLpsOY+OcxaDduL/PTXrkJMWsiUVx78h5io8/mu8gM2HrS0NRoMDiTB1xnjr7q
         ANjiCvWgBSRakylhBe4PSRjH4G54jiFTjJcDNJ/tB+DSzBKu10F/YrqyxUJz7Jr4dq
         IK4JdEv1jRYJJDk/6SArJbFXhIea4GbhXaMOnyoMovCKZnfVkM3xjokWudiFVjPS2c
         OWo6FQxUqdHSg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C2A83E29F3F;
        Tue, 22 Nov 2022 04:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: fix __sock_gen_cookie()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166909261578.32298.1387749938113677107.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Nov 2022 04:50:15 +0000
References: <20221118043843.3703186-1-edumazet@google.com>
In-Reply-To: <20221118043843.3703186-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        keescook+coverity-bot@chromium.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 18 Nov 2022 04:38:43 +0000 you wrote:
> I was mistaken how atomic64_try_cmpxchg(&sk_cookie, &res, new)
> is working.
> 
> I was assuming @res would contain the final sk_cookie value,
> regardless of the success of our cmpxchg()
> 
> We could do something like:
> 
> [...]

Here is the summary with links:
  - [net-next] net: fix __sock_gen_cookie()
    https://git.kernel.org/netdev/net-next/c/32634819ad37

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


