Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47E2666BCBD
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 12:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjAPLU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 06:20:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbjAPLUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 06:20:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C31265A0;
        Mon, 16 Jan 2023 03:20:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00BDEB80E5E;
        Mon, 16 Jan 2023 11:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 81B20C433F0;
        Mon, 16 Jan 2023 11:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673868018;
        bh=j29fL+h026AwbMOOxpMNQ+dWXbJnlnHEKqJG+DHbV1M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ADQsalS5lZ3faYNAzgKCHT7Imz5IQB70BxZ2g1t/SO8jf+WG8zc1OqDfWwaLfKdXi
         hpXOy15/baq/SCeEnM7HDu6OSCTsZ1vNx4tB/4NVuGq39rJBGtIuHIhDRklW2iWM4A
         tyU2yug7cz3LpUQwkQoXbpPiq3ecN/NnfiMCwJJn44/nwEQcisZHzRJINwNBiktXo0
         y1f1xDJQhhQGVOoo/EkZQ27aiISSeQWaxF2w7bRpKNrPgfAneoHMnrXa3lXcCjyhFB
         8iGcrd9kOs4dKLH65Dru7jEt13YvOfj4xIXuxd7YTl3XMO24vSoJsVLXJZRQR3n9IH
         LcJv22CaFObCQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6883CE54D2A;
        Mon, 16 Jan 2023 11:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 00/10] virtio-net: support multi buffer xdp
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167386801842.2835.2141479981702177893.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Jan 2023 11:20:18 +0000
References: <20230114082229.62143-1-hengqi@linux.alibaba.com>
In-Reply-To: <20230114082229.62143-1-hengqi@linux.alibaba.com>
To:     Heng Qi <hengqi@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, jasowang@redhat.com,
        mst@redhat.com, pabeni@redhat.com, kuba@kernel.org,
        john.fastabend@gmail.com, davem@davemloft.net,
        daniel@iogearbox.net, ast@kernel.org, edumazet@google.com,
        xuanzhuo@linux.alibaba.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 14 Jan 2023 16:22:19 +0800 you wrote:
> Changes since PATCH v4:
> - Make netdev_warn() in [PATCH 2/10] independent from [PATCH 3/10].
> 
> Changes since PATCH v3:
> - Separate fix patch [2/10] for MTU calculation of single buffer xdp.
>   Note that this patch needs to be backported to the stable branch.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,01/10] virtio-net: disable the hole mechanism for xdp
    https://git.kernel.org/netdev/net-next/c/484beac2ffc1
  - [net-next,v5,02/10] virtio-net: fix calculation of MTU for single-buffer xdp
    https://git.kernel.org/netdev/net-next/c/e814b958ad88
  - [net-next,v5,03/10] virtio-net: set up xdp for multi buffer packets
    https://git.kernel.org/netdev/net-next/c/8d9bc36de5fc
  - [net-next,v5,04/10] virtio-net: update bytes calculation for xdp_frame
    https://git.kernel.org/netdev/net-next/c/50bd14bc98fa
  - [net-next,v5,05/10] virtio-net: build xdp_buff with multi buffers
    https://git.kernel.org/netdev/net-next/c/ef75cb51f139
  - [net-next,v5,06/10] virtio-net: construct multi-buffer xdp in mergeable
    https://git.kernel.org/netdev/net-next/c/22174f79a44b
  - [net-next,v5,07/10] virtio-net: transmit the multi-buffer xdp
    https://git.kernel.org/netdev/net-next/c/97717e8dbda1
  - [net-next,v5,08/10] virtio-net: build skb from multi-buffer xdp
    https://git.kernel.org/netdev/net-next/c/b26aa481b4b7
  - [net-next,v5,09/10] virtio-net: remove xdp related info from page_to_skb()
    https://git.kernel.org/netdev/net-next/c/18117a842ab0
  - [net-next,v5,10/10] virtio-net: support multi-buffer xdp
    https://git.kernel.org/netdev/net-next/c/fab89bafa95b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


