Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932C250C2E7
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234095AbiDVXIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 19:08:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234773AbiDVXH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 19:07:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C310184F91
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 15:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 01DFFB832FA
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 22:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9B1E3C385B0;
        Fri, 22 Apr 2022 22:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650667212;
        bh=hRLgNzBIqvHpTpZuAagCaHcG8mUpDJgIDiukZce/JTg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fD9GBTD6Gz7HY2tot0weAkN3gLqzWbdqWk85I9Hq2msZ3uU1nLo6Yqbx9jOyb6l+h
         A+S0mqETJgik3VkRjG1MLn40bbYCsHThFO+FS8tdFLiEZEB/6i2sYit2lRp8m4Qtwa
         jeAvE8hNcVt7tw4k1STW24BXoxU2SanHVWHCPJSo3h7RmIOqeePj9/4cIq0wwk1P5E
         RddSDHNMeWU5bwYUfffCDbPf/ZB73ZQYlz1qU74TgmpGpiUUFmXPam4IRMlFUH4p1k
         2QA8n1CFe3Wk0vAc9Yk98tMk6+o2b759knPLoTvHR+SZ8jJwCZy+6PrQ6PxflAeWp1
         MHqkiFuHpUAdg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 881E8E6D402;
        Fri, 22 Apr 2022 22:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] tcp: ensure to use the most recently sent skb when
 filling the rate sample
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165066721255.28625.17968571510230696057.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Apr 2022 22:40:12 +0000
References: <1650422081-22153-1-git-send-email-yangpc@wangsu.com>
In-Reply-To: <1650422081-22153-1-git-send-email-yangpc@wangsu.com>
To:     Pengcheng Yang <yangpc@wangsu.com>
Cc:     edumazet@google.com, ncardwell@google.com, netdev@vger.kernel.org,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 20 Apr 2022 10:34:41 +0800 you wrote:
> If an ACK (s)acks multiple skbs, we favor the information
> from the most recently sent skb by choosing the skb with
> the highest prior_delivered count. But in the interval
> between receiving ACKs, we send multiple skbs with the same
> prior_delivered, because the tp->delivered only changes
> when we receive an ACK.
> 
> [...]

Here is the summary with links:
  - [net,v3] tcp: ensure to use the most recently sent skb when filling the rate sample
    https://git.kernel.org/netdev/net/c/b253a0680cea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


