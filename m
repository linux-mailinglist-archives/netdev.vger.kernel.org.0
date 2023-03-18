Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867146BF824
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 06:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbjCRFu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 01:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjCRFuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 01:50:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB49AD022;
        Fri, 17 Mar 2023 22:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCBF960A5F;
        Sat, 18 Mar 2023 05:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 21E7BC433D2;
        Sat, 18 Mar 2023 05:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679118621;
        bh=g3pi7VoFTzyzFGqKTpOE0DL5x6+2CKyYeqc25riQfCw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Nd7KlbmO/akwqzA5sgZ/W2aT8xKoA/BqDny3pNmze26kDIz00M748EUoBHDtpnHeb
         krlsMtHtSYe16DN0o2dOAWhj9zUj6/+3q8aZt3zaPdvmySYAIlvuUQfsMpMDskr6Qp
         IHKJlWh30LsnYJGDuu8dm32ulNtdK9iypeFScB26q72C1oZ/BjegA4a2tSR3E5ecjZ
         qgPIs8Dz9JFarOX21ktyEjrQWPXwNA95D3sucKBjF7YeUH0/z6JN6BvSx9eb/c5K+I
         8h74QgNLshWNYlHaXBao/CnWi4XAaLZFHSjRiuLQSen7xp+yqBGgBRAewl9q+RgttN
         pwydyNfF2WPQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0FF53E21EE5;
        Sat, 18 Mar 2023 05:50:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v8 0/5] net/mlx5e: Add GBP VxLAN HW offload support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167911862106.13068.1349424509665979718.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Mar 2023 05:50:21 +0000
References: <20230316070758.83512-1-gavinl@nvidia.com>
In-Reply-To: <20230316070758.83512-1-gavinl@nvidia.com>
To:     Gavin Li <gavinl@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gavi@nvidia.com, roid@nvidia.com, maord@nvidia.com,
        saeedm@nvidia.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Mar 2023 09:07:53 +0200 you wrote:
> Patch-1: Remove unused argument from functions.
> Patch-2: Expose helper function vxlan_build_gbp_hdr.
> Patch-3: Add helper function for encap_info_equal for tunnels with options.
> Patch-4: Preserving the const-ness of the pointer in ip_tunnel_info_opts.
> Patch-5: Add HW offloading support for TC flows with VxLAN GBP encap/decap
>         in mlx ethernet driver.
> 
> [...]

Here is the summary with links:
  - [net-next,v8,1/5] vxlan: Remove unused argument from vxlan_build_gbp_hdr( ) and vxlan_build_gpe_hdr( )
    https://git.kernel.org/netdev/net-next/c/df5e87f16c33
  - [net-next,v8,2/5] vxlan: Expose helper vxlan_build_gbp_hdr
    https://git.kernel.org/netdev/net-next/c/c641e9279f35
  - [net-next,v8,3/5] net/mlx5e: Add helper for encap_info_equal for tunnels with options
    https://git.kernel.org/netdev/net-next/c/58de53c10258
  - [net-next,v8,4/5] ip_tunnel: Preserve pointer const in ip_tunnel_info_opts
    https://git.kernel.org/netdev/net-next/c/bc9d003dc48c
  - [net-next,v8,5/5] net/mlx5e: TC, Add support for VxLAN GBP encap/decap flows offload
    https://git.kernel.org/netdev/net-next/c/6ee44c518159

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


