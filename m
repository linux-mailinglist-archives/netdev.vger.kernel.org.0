Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7418650DE30
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 12:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235197AbiDYKxT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 06:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiDYKxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 06:53:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DA56EC70;
        Mon, 25 Apr 2022 03:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25D6160FBD;
        Mon, 25 Apr 2022 10:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 710B5C385A7;
        Mon, 25 Apr 2022 10:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650883812;
        bh=x7KizP5ueeJ9w8gJMouIeEWvRj0UVLY4YnSVJ7SItgo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rL2QUstj40f8mUZcOfy7vS+ydP4ciWvPKuGt4oSDOSjMeK1nQUK88cxZjtbY8pr+9
         Pi7+Q4VlooMAW+hiVsY0Zpp5bzQhIhq6S/XXuOACx+ruFGbM/NAjH2F42W1Lhg0Sv8
         eOeOyBNO0WylpIHwsWEIPrkgdObKEclNF6hNARtWLCgs2dMABx7giuVIDxjyJ/baxr
         pTBsBn5vVqE+zWoMKrpt2+pA3YhbAnWMEEFJUvcc3F/vy4dSaghp3XnI6Cg/JRcZBO
         6k9HOAHfJRw3r9CojmbgwIlVZuHzmOro+VfETCc47qf5wMG/SHUvYS9U3IBIWG7I8O
         W6qv1AtCrAXHA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5547CEAC09C;
        Mon, 25 Apr 2022 10:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] ip_gre, ip6_gre: o_seqno fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165088381234.11295.8950748121825886947.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Apr 2022 10:50:12 +0000
References: <cover.1650575919.git.peilin.ye@bytedance.com>
In-Reply-To: <cover.1650575919.git.peilin.ye@bytedance.com>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, pabeni@redhat.com, peilin.ye@bytedance.com,
        xeb@mail.ru, u9012063@gmail.com, daniel@iogearbox.net,
        cong.wang@bytedance.com, eric.dumazet@gmail.com, ast@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 21 Apr 2022 15:06:39 -0700 you wrote:
> From: Peilin Ye <peilin.ye@bytedance.com>
> 
> Hi all,
> 
> As pointed out [1] by Jakub Kicinski, currently using TUNNEL_SEQ in
> collect_md mode is racy for [IP6]GRE[TAP] devices, since they (typically,
> e.g. if created using "ip") use lockless TX.
> 
> [...]

Here is the summary with links:
  - [net,1/3] ip_gre: Make o_seqno start from 0 in native mode
    https://git.kernel.org/netdev/net/c/ff827beb706e
  - [net,2/3] ip6_gre: Make o_seqno start from 0 in native mode
    https://git.kernel.org/netdev/net/c/fde98ae91f79
  - [net,3/3] ip_gre, ip6_gre: Fix race condition on o_seqno in collect_md mode
    https://git.kernel.org/netdev/net/c/31c417c948d7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


