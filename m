Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D903D6738A9
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 13:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbjASMfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 07:35:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231199AbjASMfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 07:35:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 197AA8017A;
        Thu, 19 Jan 2023 04:31:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37F6A60DDB;
        Thu, 19 Jan 2023 12:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9250AC43396;
        Thu, 19 Jan 2023 12:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674131417;
        bh=4UeenFskQ8q5ZbX2PwrZcltp0ex12Pdp3UUb4Xpyb/Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fYaVXswFEQWlqji+VemEoYX5p7R9knh766Nlqn9+wZSHvwhgWSmIppC6OjyLndS/s
         KdmkWeui/Zmc+dy6xyGntUNihG4FI+fqBzT3aHTEM+2vhnNjnZ4nNFoFHnz/uBcTyW
         9LC7BKdjARDW4ZxXviTZNAxAxXfO1+5dix8mrEZF8fTUSvoO7WfjKQ94HJBTg85Hca
         Kxl3MchQHhlVh0kq3YNDao3ukrqwn3tr3nfkVh3PEscOyDzrW2KZCafTgd3IyrR1V+
         C88STX3H5sQ8WXC6jeROPkAG4h89f6pgR73kvsu6HzvYunepBOvDmhKfqyaCTFAcv7
         boctDdPoPAUdA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 78E3EE54D27;
        Thu, 19 Jan 2023 12:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v7 net] tcp: avoid the lookup process failing to get sk in
 ehash table
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167413141749.31602.11458006016740118769.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Jan 2023 12:30:17 +0000
References: <20230118015941.1313-1-kerneljasonxing@gmail.com>
In-Reply-To: <20230118015941.1313-1-kerneljasonxing@gmail.com>
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernelxing@tencent.com, kuniyu@amazon.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 18 Jan 2023 09:59:41 +0800 you wrote:
> From: Jason Xing <kernelxing@tencent.com>
> 
> While one cpu is working on looking up the right socket from ehash
> table, another cpu is done deleting the request socket and is about
> to add (or is adding) the big socket from the table. It means that
> we could miss both of them, even though it has little chance.
> 
> [...]

Here is the summary with links:
  - [v7,net] tcp: avoid the lookup process failing to get sk in ehash table
    https://git.kernel.org/netdev/net/c/3f4ca5fafc08

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


