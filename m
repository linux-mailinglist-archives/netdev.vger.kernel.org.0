Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54284DD89B
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 12:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235568AbiCRLBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 07:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231196AbiCRLBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 07:01:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD692D7A8F;
        Fri, 18 Mar 2022 04:00:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29ECD6167A;
        Fri, 18 Mar 2022 11:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85FA1C340EC;
        Fri, 18 Mar 2022 11:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647601211;
        bh=447LM5Kabq8FL028QKE58b3nFgciqE+JJr1ZsWiSnXY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jBZ2HsUAYcsNtL062OPYgcdcFlvsIHmhtZyXqkPz9+8Vre8OJRI4hgi9MlRI2a3jl
         66deGyggaFj6m+/jnMQHJ6g+HDwjNtor71t/mb3ttW9JiJWWakKQNqFOV61IDa2ze+
         RU2PGBuwYE6YB0lGReZnXOdKF7l+Y9UQviJMxUJuwDP+uH4R1U3T+Dfm3+e1hJFwTm
         45Bt86f27Xv4suAJWcj+E9gwmaoZunfWawSSeH5LcHuu4o1mr+MifcutINZEG9FNcN
         hvk1/2e984lZhNWhX3GbUZFbg1dBtqRpbJh+TsKL/URsbk4qwwA5JA5XIq3DIie920
         woOHz6UijKORQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 69EF9E6D44B;
        Fri, 18 Mar 2022 11:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/3] netfilter: flowtable: Fix QinQ and pppoe support for
 inet table
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164760121142.15393.1837895121278287864.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Mar 2022 11:00:11 +0000
References: <20220317202534.41530-2-pablo@netfilter.org>
In-Reply-To: <20220317202534.41530-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 17 Mar 2022 21:25:32 +0100 you wrote:
> nf_flow_offload_inet_hook() does not check for 802.1q and PPPoE.
> Fetch inner ethertype from these encapsulation protocols.
> 
> Fixes: 72efd585f714 ("netfilter: flowtable: add pppoe support")
> Fixes: 4cd91f7c290f ("netfilter: flowtable: add vlan support")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net,1/3] netfilter: flowtable: Fix QinQ and pppoe support for inet table
    https://git.kernel.org/netdev/net/c/0492d857636e
  - [net,2/3] netfilter: nf_tables: validate registers coming from userspace.
    https://git.kernel.org/netdev/net/c/6e1acfa387b9
  - [net,3/3] netfilter: nf_tables: initialize registers in nft_do_chain()
    https://git.kernel.org/netdev/net/c/4c905f6740a3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


