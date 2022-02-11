Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 053814B253E
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 13:10:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349847AbiBKMKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 07:10:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349837AbiBKMKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 07:10:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CAAE64;
        Fri, 11 Feb 2022 04:10:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 077E6B8295F;
        Fri, 11 Feb 2022 12:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8A54FC340EE;
        Fri, 11 Feb 2022 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644581410;
        bh=Pk5PRi9RMQEl6Jmn1/2va44sErBkUvmmUbVsCCAGOIY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KvfcgGIttFRNsQrnhDPgAvV0kN9U70nqniUTXxK/xNUQxX3IhYpEt2r9+pYnlvFgm
         pfl06CeMM3hQbHlUQlI6GEakHXdZvHF+7djTHjPxSsyVADsqIwFoHoNvzIKw3rkD1L
         1T5cj69bJhEO++fUG3h1Tr/cripqB7baoMJA6qE9qcGNC1J9c0KxzYIh0cqiN0UxNY
         /c4q+4gNdQ/WOswrpC0RGw9L6JnXr5TgPz9eXOon60kroNFdSfDOL6R3aK7vDvjXEX
         1RpZmVzf1DrRxaakW7Z0nKNT0tW9X9LjkTRGHBINwSdmuJlrLHVobg3NsguKVz573U
         9MQr6IYkW416g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6CA73E5D09D;
        Fri, 11 Feb 2022 12:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/6] selftests: netfilter: add synproxy test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164458141044.22011.8395736107258519318.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Feb 2022 12:10:10 +0000
References: <20220210231021.204488-2-pablo@netfilter.org>
In-Reply-To: <20220210231021.204488-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 11 Feb 2022 00:10:16 +0100 you wrote:
> From: Florian Westphal <fw@strlen.de>
> 
> Simple test for synproxy feature, iperf3 should be intercepted
> by synproxy netns, but connection should still succeed.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [...]

Here is the summary with links:
  - [net,1/6] selftests: netfilter: add synproxy test
    https://git.kernel.org/netdev/net/c/7152303cbec4
  - [net,2/6] netfilter: xt_socket: fix a typo in socket_mt_destroy()
    https://git.kernel.org/netdev/net/c/75063c9294fb
  - [net,3/6] selftests: netfilter: fix exit value for nft_concat_range
    https://git.kernel.org/netdev/net/c/2e71ec1a725a
  - [net,4/6] netfilter: nft_synproxy: unregister hooks on init error path
    https://git.kernel.org/netdev/net/c/2b4e5fb4d377
  - [net,5/6] selftests: netfilter: synproxy test requires nf_conntrack
    https://git.kernel.org/netdev/net/c/249749c88906
  - [net,6/6] selftests: netfilter: disable rp_filter on router
    https://git.kernel.org/netdev/net/c/bbe4c0896d25

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


