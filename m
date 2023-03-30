Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B19346CFAB0
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 07:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjC3FUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 01:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjC3FUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 01:20:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27954C3D
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 22:20:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BF72B825D9
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 05:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25EEAC433D2;
        Thu, 30 Mar 2023 05:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680153620;
        bh=2VqZDuLsOaNqPgGmPErlQdz97trvCPGwJaKi1W5z+SM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F3/FJE3zv6u05/LbSZ99MLblKxk5oJ6rY/gfoR/sXMJ+1lZMz22xvxnBR5F0kP2CF
         HsaOFdtUlX94PPqCXfVJghWK6Y0Y6ssm0DE4QkUzVrNJWYJNFetqgRBbFjt2s92VGP
         mycmhtg4nIKJ2EbpvdDsVs6MqiWE58ohkf6oAFKO2C6IwsuIGxwxvtj4P1fpH8266W
         sU0BmFSunqukAczFcGMmFhNSBw0NMFeLy8bp4rDB/dehKuBHsFyL2nvfBSdJlEERzf
         inEvWVIKaQSBS2DUXBiQke0BaProyjZp4B2cgZnygl96rI5X62AlvHUbe/zZAe3vwD
         mxlPZ4Ro2/SqA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 06EDDE2A037;
        Thu, 30 Mar 2023 05:20:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5e: RX,
 Remove mlx5e_alloc_unit argument in page allocation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168015362002.23884.5034488013210629892.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Mar 2023 05:20:20 +0000
References: <20230328205623.142075-2-saeed@kernel.org>
In-Reply-To: <20230328205623.142075-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, brouer@redhat.com, willy@infradead.org,
        toke@redhat.com, ilias.apalodimas@linaro.org, dtatulea@nvidia.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Saeed Mahameed <saeedm@nvidia.com>:

On Tue, 28 Mar 2023 13:56:09 -0700 you wrote:
> From: Dragos Tatulea <dtatulea@nvidia.com>
> 
> Change internal page cache and page pool api to use a struct page **
> instead of a mlx5e_alloc_unit *.
> 
> This is the first change in a series which is meant to remove the
> mlx5e_alloc_unit altogether.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5e: RX, Remove mlx5e_alloc_unit argument in page allocation
    https://git.kernel.org/netdev/net-next/c/09df03701779
  - [net-next,02/15] net/mlx5e: RX, Remove alloc unit layout constraint for legacy rq
    https://git.kernel.org/netdev/net-next/c/8fb1814f58f6
  - [net-next,03/15] net/mlx5e: RX, Remove alloc unit layout constraint for striding rq
    https://git.kernel.org/netdev/net-next/c/d39092caaedf
  - [net-next,04/15] net/mlx5e: RX, Store SHAMPO header pages in array
    https://git.kernel.org/netdev/net-next/c/ca6ef9f03194
  - [net-next,05/15] net/mlx5e: RX, Remove internal page_cache
    https://git.kernel.org/netdev/net-next/c/08c9b61b071c
  - [net-next,06/15] net/mlx5e: RX, Enable dma map and sync from page_pool allocator
    https://git.kernel.org/netdev/net-next/c/4a5c5e25008f
  - [net-next,07/15] net/mlx5e: RX, Enable skb page recycling through the page_pool
    https://git.kernel.org/netdev/net-next/c/6f5742846053
  - [net-next,08/15] net/mlx5e: RX, Rename xdp_xmit_bitmap to a more generic name
    https://git.kernel.org/netdev/net-next/c/38a36efccd90
  - [net-next,09/15] net/mlx5e: RX, Defer page release in striding rq for better recycling
    https://git.kernel.org/netdev/net-next/c/4c2a13236807
  - [net-next,10/15] net/mlx5e: RX, Change wqe last_in_page field from bool to bit flags
    https://git.kernel.org/netdev/net-next/c/625dff29df39
  - [net-next,11/15] net/mlx5e: RX, Defer page release in legacy rq for better recycling
    https://git.kernel.org/netdev/net-next/c/3f93f82988bc
  - [net-next,12/15] net/mlx5e: RX, Split off release path for xsk buffers for legacy rq
    https://git.kernel.org/netdev/net-next/c/76238d0fbd21
  - [net-next,13/15] net/mlx5e: RX, Increase WQE bulk size for legacy rq
    https://git.kernel.org/netdev/net-next/c/4ba2b4988c98
  - [net-next,14/15] net/mlx5e: RX, Break the wqe bulk refill in smaller chunks
    https://git.kernel.org/netdev/net-next/c/cd640b050368
  - [net-next,15/15] net/mlx5e: RX, Remove unnecessary recycle parameter and page_cache stats
    https://git.kernel.org/netdev/net-next/c/3905f8d64ccc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


