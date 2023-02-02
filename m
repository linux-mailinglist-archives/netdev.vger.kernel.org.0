Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 357B7687431
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 05:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbjBBEA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 23:00:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbjBBEAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 23:00:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E2274A40;
        Wed,  1 Feb 2023 20:00:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CADDBB8240B;
        Thu,  2 Feb 2023 04:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 704C3C433AA;
        Thu,  2 Feb 2023 04:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675310418;
        bh=SPR/gEatixNHzTcp0h+t+RVCNS6qoQAa2AJBQKgk5hE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rUvGK2exzZYdYnQHcgGDPDENvzkPVQJ7ub2ISVzX8hswVsJqCMv1NDk+Nk+4H57wi
         nAG1UgMWyTcMsSoaRzilLFW6S6mgR9F136wXY09EfyOLunsiqXoPFcSoR3V90au4O4
         GZwh685og3sK7xmRbXai5hNF64YMW8abAuQZ9pTsBG+8/GWdeOBQRhLdKZ4OpcnTyg
         KlbSOGqv0Ntq89WZa1mSyKDf4TSh5oClzIMzBaJhS7IOlW2lAMU4dm87m/KFxE83HN
         afN7NzTRXrhhk87Z/9p0Nn+e3844qvI9YialCN3K5KHpVRMRi0dcgM8NtIsxkt6TNe
         V5X1L0IMla0Ew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 59F53E4D037;
        Thu,  2 Feb 2023 04:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ipv6: ICMPV6: Use swap() instead of open coding it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167531041836.2562.6662890759437922796.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 04:00:18 +0000
References: <20230131063456.76302-1-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <20230131063456.76302-1-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        abaci@linux.alibaba.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 31 Jan 2023 14:34:56 +0800 you wrote:
> Swap is a function interface that provides exchange function. To avoid
> code duplication, we can use swap function.
> 
> ./net/ipv6/icmp.c:344:25-26: WARNING opportunity for swap().
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3896
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - ipv6: ICMPV6: Use swap() instead of open coding it
    https://git.kernel.org/netdev/net-next/c/bc61761394ce

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


