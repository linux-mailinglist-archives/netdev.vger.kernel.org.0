Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0219C4F9389
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 13:10:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232756AbiDHLM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 07:12:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232741AbiDHLM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 07:12:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C901AF3E;
        Fri,  8 Apr 2022 04:10:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 297E5B829A0;
        Fri,  8 Apr 2022 11:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA3C5C385A5;
        Fri,  8 Apr 2022 11:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649416218;
        bh=Kj9GY+ZwSwJFFvVw5wsTXZ7Zn8VlStHWavPZqmnnJRs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sHcLtp21SCC+Kk8BVh3JzUqrMoqEZoAAkj+I8+oCv0a1yx/0dtoeeETcOHo8VG9zi
         kc+UJ84GKyTa1mA/iXnYvFAuGe1LeXZ7wzz1H1g3HWK09mzt1vHLyFAAznwS8W3ieH
         MBl76fFs/dneG7eVCVIV1bqHnQp+7jUtUWH8Uq/pV3j1nMOT2xa+vpSIENWSv90UwI
         XNnTb1kjSeikkTscpLOm2+VDMraFnTd4orqmMquuV3VUY6mKXd6u40LjAmyQ9xERyY
         FuCxREDCTxchYCL7QGoXj/9+47oHCQqACw3T2vw+O1s9AlRWpVY5f8dPrYubiaiR57
         9ffZCTvnQl6FA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8D862E85D53;
        Fri,  8 Apr 2022 11:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 00/11] bnxt: Support XDP multi buffer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164941621857.19376.4332158800174528610.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Apr 2022 11:10:18 +0000
References: <1649404746-31033-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1649404746-31033-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        gospo@broadcom.com, bpf@vger.kernel.org, john.fastabend@gmail.com,
        toke@redhat.com, lorenzo@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, echaudro@redhat.com, pabeni@redhat.com
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  8 Apr 2022 03:58:55 -0400 you wrote:
> This series adds XDP multi buffer support, allowing MTU to go beyond
> the page size limit.
> 
> v4: Rebase with latest net-next
> v3: Simplify page mode buffer size calculation
>     Check to make sure XDP program supports multipage packets
> v2: Fix uninitialized variable warnings in patch 1 and 10.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,01/11] bnxt: refactor bnxt_rx_xdp to separate xdp_init_buff/xdp_prepare_buff
    https://git.kernel.org/netdev/net-next/c/b231c3f3414c
  - [net-next,v4,02/11] bnxt: add flag to denote that an xdp program is currently attached
    https://git.kernel.org/netdev/net-next/c/ee536dcbdce4
  - [net-next,v4,03/11] bnxt: refactor bnxt_rx_pages operate on skb_shared_info
    https://git.kernel.org/netdev/net-next/c/ca1df2dd8e2f
  - [net-next,v4,04/11] bnxt: rename bnxt_rx_pages to bnxt_rx_agg_pages_skb
    https://git.kernel.org/netdev/net-next/c/23e4c0469ad0
  - [net-next,v4,05/11] bnxt: adding bnxt_rx_agg_pages_xdp for aggregated xdp
    https://git.kernel.org/netdev/net-next/c/4c6c123c9af9
  - [net-next,v4,06/11] bnxt: set xdp_buff pfmemalloc flag if needed
    https://git.kernel.org/netdev/net-next/c/31b9998bf225
  - [net-next,v4,07/11] bnxt: change receive ring space parameters
    https://git.kernel.org/netdev/net-next/c/32861236190b
  - [net-next,v4,08/11] bnxt: add page_pool support for aggregation ring when using xdp
    https://git.kernel.org/netdev/net-next/c/9a6aa3504885
  - [net-next,v4,09/11] bnxt: adding bnxt_xdp_build_skb to build skb from multibuffer xdp_buff
    https://git.kernel.org/netdev/net-next/c/1dc4c557bfed
  - [net-next,v4,10/11] bnxt: support transmit and free of aggregation buffers
    https://git.kernel.org/netdev/net-next/c/a7559bc8c17c
  - [net-next,v4,11/11] bnxt: XDP multibuffer enablement
    https://git.kernel.org/netdev/net-next/c/9f4b28301ce6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


