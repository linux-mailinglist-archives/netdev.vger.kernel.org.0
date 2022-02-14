Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D57D4B51ED
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 14:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354446AbiBNNkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 08:40:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbiBNNkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 08:40:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58385621C;
        Mon, 14 Feb 2022 05:40:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 719F9614FD;
        Mon, 14 Feb 2022 13:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D58A7C36AE3;
        Mon, 14 Feb 2022 13:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644846009;
        bh=t+3A7IemZeIy2izi4BzkNKp+rbO8ID2k2gzjcH33Apk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Si76sOSy0APJPpUgebjXIL54VMSVC2yfSVrlH/2Lmrthaa9OcMnhUpgDRKWFzjtEm
         bZq1AuFActM4qVBkM7KVLtMs78Nwp1xyY4E+vkTAKuqAVetxGwrO9gCmKDXgHwiCJO
         LZaZ7c1obNLc3E7vj++1Rl6ptjnsGYAY7aPvikZp3/lloHO9bXFd26s/QlwZUuQe12
         QsRHQdW9VLuCRKbl6kIPBbriTHYiCrcXTgzeueTT6V8ZnTTXAwySfoDYFcxbxRUuaF
         ee6Z1K51rP/OVdqOajqb4RUNIeuNHxRPRxhZUZc1xAAcYHca0KV32gAQ2G4ewuej9o
         zKkkx0ihr4fjg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C06A1E5D09D;
        Mon, 14 Feb 2022 13:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipv6: mcast: use rcu-safe version of ipv6_get_lladdr()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164484600978.23487.12151105643711844035.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Feb 2022 13:40:09 +0000
References: <20220211173042.112852-1-ignat@cloudflare.com>
In-Reply-To: <20220211173042.112852-1-ignat@cloudflare.com>
To:     Ignat Korchagin <ignat@cloudflare.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@cloudflare.com,
        dpini@cloudflare.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 11 Feb 2022 17:30:42 +0000 you wrote:
> Some time ago 8965779d2c0e ("ipv6,mcast: always hold idev->lock before mca_lock")
> switched ipv6_get_lladdr() to __ipv6_get_lladdr(), which is rcu-unsafe
> version. That was OK, because idev->lock was held for these codepaths.
> 
> In 88e2ca308094 ("mld: convert ifmcaddr6 to RCU") these external locks were
> removed, so we probably need to restore the original rcu-safe call.
> 
> [...]

Here is the summary with links:
  - ipv6: mcast: use rcu-safe version of ipv6_get_lladdr()
    https://git.kernel.org/netdev/net/c/26394fc118d6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


