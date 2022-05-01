Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C53651645A
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 14:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346610AbiEAMYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 08:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346911AbiEAMXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 08:23:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5A93B2;
        Sun,  1 May 2022 05:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC4B860EB1;
        Sun,  1 May 2022 12:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B981C385A9;
        Sun,  1 May 2022 12:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651407612;
        bh=AoQC0Bv8lDzGTOPaC2dG32rWVQcHbDgTh28kzJFZqhg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WriJgoQmhF3p2p+0IkCw9Arskx+wbtOaGXP2OjQ3ynoLuvY6s/g/91dB/183vCzj6
         sZXSMzdMBNKL2t/qiNL53qV3nFJy5QtKT9rD0f5YDweheNbvLUnPPKf7MCby9fz74V
         UiHHzgwjAURWi5U/CI//ROFzNXhTGMcIOjh73QcnVGnVcyRP/uuZCWN+PIlWuTlA1b
         kAl22G7+rwyLCfcJRJ9108nsKgCRQnkgRVWTvxqVvR2LYkbfO47ieDqZ5/OyeXxzqb
         LeuMZH39YAtw7CA+yHTJt9kka6wk8nOVSU4iWEzHb9c0Bi4n+n8mt+gV1yjb/Q3vRt
         kCGwscvUpthSw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2F481E85D90;
        Sun,  1 May 2022 12:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: enable memcg accounting for veth queues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165140761218.13523.5811947461651207574.git-patchwork-notify@kernel.org>
Date:   Sun, 01 May 2022 12:20:12 +0000
References: <0b28d49b-605c-ac1a-df85-643164e69039@openvz.org>
In-Reply-To: <0b28d49b-605c-ac1a-df85-643164e69039@openvz.org>
To:     Vasily Averin <vvs@openvz.org>
Cc:     kuba@kernel.org, roman.gushchin@linux.dev, vbabka@suse.cz,
        shakeelb@google.com, kernel@openvz.org,
        linux-kernel@vger.kernel.org, mhocko@suse.com,
        cgroups@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 29 Apr 2022 08:17:35 +0300 you wrote:
> veth netdevice defines own rx queues and allocates array containing
> up to 4095 ~750-bytes-long 'struct veth_rq' elements. Such allocation
> is quite huge and should be accounted to memcg.
> 
> Signed-off-by: Vasily Averin <vvs@openvz.org>
> ---
>  drivers/net/veth.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] net: enable memcg accounting for veth queues
    https://git.kernel.org/netdev/net-next/c/961c6136359e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


