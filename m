Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16566B3793
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 08:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbjCJHli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 02:41:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbjCJHkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 02:40:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A742F104922;
        Thu,  9 Mar 2023 23:40:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C6ECB821DF;
        Fri, 10 Mar 2023 07:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 00BDDC4331D;
        Fri, 10 Mar 2023 07:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678434021;
        bh=aMCZFZWpmUkhd0ND1FCMjMn88Z7Y4ZjzuCO60/lYc4A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=D4jumGUIuPDqMysUrmpKCWrQc2eYJPyIatStLlcvumrOQEh8lxhAHL5KytRr+KSXb
         5eIp1vu5JuUu4FTPA+l0Jl0SnZtOkagZD9XyA/Cw782FwiPta9eoRQlZARgYi/6exA
         Irb2++tOB/76Ma08X2hBfvQ3uphOG6pCu2gyEdPgcyPFgltvmUybu7Gv/RsvwVF0gv
         25fjKTgBuGzRiHDvV1VPchbi+pBWJbjXn0E5p1JGLa9IWckZBNutmHOsupew+KV3ms
         8kI7nkQjqU8NRCkCiMO7BumjfSTwyhgOj6ccrcgjau0WflVZQ6ImRlRA5Y/3d4MC4E
         BrXWXEzR4Y6IA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D6DE6E270C7;
        Fri, 10 Mar 2023 07:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 net-next] udp: introduce __sk_mem_schedule() usage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167843402087.26917.6747945848629021248.git-patchwork-notify@kernel.org>
Date:   Fri, 10 Mar 2023 07:40:20 +0000
References: <20230308021153.99777-1-kerneljasonxing@gmail.com>
In-Reply-To: <20230308021153.99777-1-kerneljasonxing@gmail.com>
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     simon.horman@corigine.com, willemdebruijn.kernel@gmail.com,
        davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        kernelxing@tencent.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Mar 2023 10:11:53 +0800 you wrote:
> From: Jason Xing <kernelxing@tencent.com>
> 
> Keep the accounting schema consistent across different protocols
> with __sk_mem_schedule(). Besides, it adjusts a little bit on how
> to calculate forward allocated memory compared to before. After
> applied this patch, we could avoid receive path scheduling extra
> amount of memory.
> 
> [...]

Here is the summary with links:
  - [v4,net-next] udp: introduce __sk_mem_schedule() usage
    https://git.kernel.org/netdev/net-next/c/fd9c31f83441

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


