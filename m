Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94074D2DFA
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 12:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbiCILbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 06:31:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232171AbiCILbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 06:31:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EAE914FBDA
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 03:30:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B97A361853
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1CD77C340F6;
        Wed,  9 Mar 2022 11:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646825413;
        bh=ggIkyToWplM/jdmoCUVdqYqytY088P8rIIjz5q7AZcU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m5R9Wajoxh6EumxXI/6EvwNK/tJARFtbmMlhOfhQXNq/lPJfkHGSGYBuamLA3vjiB
         x3StULjCUDLP6kH1+TpOp+feeBCObr1upi/cSPT8QOmctzHrVKhHEwMJP8vUeEcXJq
         eY/apcgGvv39F9rBHsrRBN5xKwjFhO+UeBwK9cWjNyRuXRbu4i+R4x9mhIIN8ykNse
         Z6K3yyweBDOnoRA/Y3H4M22YmPJMxg+KuBifSvHfkn4zNKAuvDZo4Uw/ifSdNMrkxh
         1hoeOOH4QSqO5h6nK+J464w07aF0xWKOLnGsz6XOWKhqFzedqyPYe9O4utPofT+jw4
         XxhnoXQUnJMQw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0284CF0383B;
        Wed,  9 Mar 2022 11:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/fungible: Fix local_memory_node error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164682541300.22286.8177571192280832883.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Mar 2022 11:30:13 +0000
References: <20220308045321.2843-1-dmichail@fungible.com>
In-Reply-To: <20220308045321.2843-1-dmichail@fungible.com>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sfr@canb.auug.org.au
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon,  7 Mar 2022 20:53:21 -0800 you wrote:
> Stephen Rothwell reported the following failure on powerpc:
> 
> ERROR: modpost: ".local_memory_node"
> [drivers/net/ethernet/fungible/funeth/funeth.ko] undefined!
> 
> AFAICS this is because local_memory_node() is a non-inline non-exported
> function when CONFIG_HAVE_MEMORYLESS_NODES=y. It is also the wrong API
> to get a CPU's memory node. Use cpu_to_mem() in the two spots it's used.
> 
> [...]

Here is the summary with links:
  - [net-next] net/fungible: Fix local_memory_node error
    https://git.kernel.org/netdev/net-next/c/cdba24904e1d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


