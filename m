Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2742609CBE
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 10:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbiJXIcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 04:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbiJXIcE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 04:32:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C9F66F1C;
        Mon, 24 Oct 2022 01:31:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 561EEB80F62;
        Mon, 24 Oct 2022 08:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0AD22C433D7;
        Mon, 24 Oct 2022 08:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666600220;
        bh=EHtIBEnqwO8OTxRcLhosYYv9nlqvYEyu/1vJwIPI8tE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r5CpeRNzRivAQYTpwtFHMityznFW9ivTvgxmpp1ePtSBsiG4IRwHtsC+4EFGk8NBy
         aO0zgH9fvN4cH6ZGpeSO7tR/CMSvG1c5R1fDZxajPG9vqj1BcKqV629ydfSrsIvMKs
         WTmZ8gRCQTT1JGjrExYNVYqXHh9kSeIGyY2BktRHZkzS1gOIaa8YdXSgSENfMxO8OS
         M3tqiuyxocaNQ6D52wXfzY7DuV10uT0/fpHWC1cZLzT9eFvf3AriV+b5DiIzbrlsRB
         klRl3Cfds1o5F7AZEN5uAO63Z6vT91+dHXJummfuHXiav/i8ub8mkY9MMkLnqoN+bi
         31b2c7B6CLzlQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DABE1E270DE;
        Mon, 24 Oct 2022 08:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 00/12] net: dpaa2-eth: AF_XDP zero-copy support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166660021989.31349.8801845015313190458.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Oct 2022 08:30:19 +0000
References: <20221018141901.147965-1-ioana.ciornei@nxp.com>
In-Reply-To: <20221018141901.147965-1-ioana.ciornei@nxp.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        bpf@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 18 Oct 2022 17:18:49 +0300 you wrote:
> This patch set adds support for AF_XDP zero-copy in the dpaa2-eth
> driver. The support is available on the LX2160A SoC and its variants and
> only on interfaces (DPNIs) with a maximum of 8 queues (HW limitations
> are the root cause).
> 
> We are first implementing the .get_channels() callback since this a
> dependency for further work.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,01/12] net: dpaa2-eth: add support to query the number of queues through ethtool
    https://git.kernel.org/netdev/net-next/c/14e493ddc341
  - [net-next,v3,02/12] net: dpaa2-eth: rearrange variable in dpaa2_eth_get_ethtool_stats
    https://git.kernel.org/netdev/net-next/c/331320682767
  - [net-next,v3,03/12] net: dpaa2-eth: add support for multiple buffer pools per DPNI
    https://git.kernel.org/netdev/net-next/c/095174dafc74
  - [net-next,v3,04/12] net: dpaa2-eth: export the CH#<index> in the 'ch_stats' debug file
    https://git.kernel.org/netdev/net-next/c/96b44697e53a
  - [net-next,v3,05/12] net: dpaa2-eth: export buffer pool info into a new debugfs file
    https://git.kernel.org/netdev/net-next/c/b1dd9bf6ead8
  - [net-next,v3,06/12] net: dpaa2-eth: update the dpni_set_pools() API to support per QDBIN pools
    https://git.kernel.org/netdev/net-next/c/801c76dd067c
  - [net-next,v3,07/12] net: dpaa2-eth: use dev_close/open instead of the internal functions
    https://git.kernel.org/netdev/net-next/c/e3caeb2ddbf2
  - [net-next,v3,08/12] net: dpaa2-eth: create and export the dpaa2_eth_alloc_skb function
    https://git.kernel.org/netdev/net-next/c/129902a351bf
  - [net-next,v3,09/12] net: dpaa2-eth: create and export the dpaa2_eth_receive_skb() function
    https://git.kernel.org/netdev/net-next/c/ee2a3bdef94b
  - [net-next,v3,10/12] net: dpaa2-eth: AF_XDP RX zero copy support
    https://git.kernel.org/netdev/net-next/c/48276c08cf5d
  - [net-next,v3,11/12] net: dpaa2-eth: AF_XDP TX zero copy support
    https://git.kernel.org/netdev/net-next/c/4a7f6c5ac9e5
  - [net-next,v3,12/12] net: dpaa2-eth: add trace points on XSK events
    https://git.kernel.org/netdev/net-next/c/3817b2ac71de

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


