Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE52677A2B
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 12:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbjAWLa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 06:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbjAWLaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 06:30:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1718A11174;
        Mon, 23 Jan 2023 03:30:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ADBE160DBB;
        Mon, 23 Jan 2023 11:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 128B5C4339B;
        Mon, 23 Jan 2023 11:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674473416;
        bh=20/FKvWs3D1OgmK/Ipby3rnpT21aHPODDhRIBm9Agjc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LEW2sgFdQofpm36gzlO+LZSJrkgt6WNi4h4SEpDQ1OLlhSGxBS+GZpZt+CGA5QXRO
         2KuQyzvMQrXNTi9xHd9+oaxArd+F3QfXYTH/FY6ImK4uRPc3ojOCcSNCs6TSGz5YSY
         C8q1l4UutrwA33DfFIi02H0HAhkeayn2mdSof/moqpeLzc7ICcKlQchJhL7Nsw5aIy
         i+bZvEvKDuhQSn/RLnOOONLWVpaUGL2riC/ajgn3KzNrfQ0D4kVirasnrjAa+MDnPo
         YuHBJWuNoLbqqZ3JJ/M9BHcl7Jw/xweH8s6FapBvZp1PW4dsOcZSEAUr2E6Ol69Fuq
         t+n5enENeceeA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E980DC395CA;
        Mon, 23 Jan 2023 11:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v7] net/sock: Introduce trace_sk_data_ready()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167447341595.18489.6607326024797331487.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Jan 2023 11:30:15 +0000
References: <20230120004516.3944-1-yepeilin.cs@gmail.com>
In-Reply-To: <20230120004516.3944-1-yepeilin.cs@gmail.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        peilin.ye@bytedance.com, cong.wang@bytedance.com, leon@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Thu, 19 Jan 2023 16:45:16 -0800 you wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> As suggested by Cong, introduce a tracepoint for all ->sk_data_ready()
> callback implementations.  For example:
> 
> <...>
>   iperf-609  [002] .....  70.660425: sk_data_ready: family=2 protocol=6 func=sock_def_readable
>   iperf-609  [002] .....  70.660436: sk_data_ready: family=2 protocol=6 func=sock_def_readable
> <...>
> 
> [...]

Here is the summary with links:
  - [net-next,v7] net/sock: Introduce trace_sk_data_ready()
    https://git.kernel.org/netdev/net-next/c/40e0b0908142

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


