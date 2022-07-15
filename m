Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA719575ADA
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 07:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiGOFUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 01:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiGOFUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 01:20:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB97796A2
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 22:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B23562264
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C26F6C341C0;
        Fri, 15 Jul 2022 05:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657862416;
        bh=FvwIFcyir+buwP3PK16Q/gPkxK4Fh4ggV569QhE6Ulg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c4a2tFyQHrlvCVDihMi13ORIclgdUjpbwviPHWYO6vkOEyyQSZi7VH468cequ3iXo
         lCZF/bNFPB/DsKTaDfuGN8Zxi+sif1usqn8ax1pse6CVmXe2Hb0+dIKtW6Okt+g13Q
         qLqVzBQFiL/F9gwR4UNfsRCgrSzRRr9U0nuW8scJTvuYBeocff+lXB0UOmc+hTgzog
         xhgjsNigBbmD5Vd6tgd+TQGSOxZkfwsol0I8S7tkWVldMM+hzkYNQAZ3sJfxuaTbRk
         aZZnsIiKxyB31qYztUzOYSXGqogarU4/pThsb4V0dnp/vbzTT5fFpViwvU/gmX+RrK
         OPhTblT0jGLhQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A8D43E45228;
        Fri, 15 Jul 2022 05:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5: Use the bitmap API to allocate bitmaps
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165786241668.22424.66017311516157017.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Jul 2022 05:20:16 +0000
References: <20220713225859.401241-2-saeed@kernel.org>
In-Reply-To: <20220713225859.401241-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        christophe.jaillet@wanadoo.fr
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

This series was applied to netdev/net-next.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Wed, 13 Jul 2022 15:58:45 -0700 you wrote:
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> Use bitmap_zalloc()/bitmap_free() instead of hand-writing them.
> 
> It is less verbose and it improves the semantic.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5: Use the bitmap API to allocate bitmaps
    https://git.kernel.org/netdev/net-next/c/32ea2776a81b
  - [net-next,02/15] net/mlx5: Introduce ifc bits for using software vhca id
    https://git.kernel.org/netdev/net-next/c/0372c546eca5
  - [net-next,03/15] net/mlx5: Use software VHCA id when it's supported
    https://git.kernel.org/netdev/net-next/c/dc402ccc0d7b
  - [net-next,04/15] net/mlx5: Expose vnic diagnostic counters for eswitch managed vports
    https://git.kernel.org/netdev/net-next/c/606e6a72e29d
  - [net-next,05/15] net/mlx5: debugfs, Add num of in-use FW command interface slots
    https://git.kernel.org/netdev/net-next/c/e723f8662de7
  - [net-next,06/15] net/mlx5: Bridge, refactor groups sizes and indices
    https://git.kernel.org/netdev/net-next/c/55d3654c1658
  - [net-next,07/15] net/mlx5: Bridge, rename filter fg to vlan_filter
    https://git.kernel.org/netdev/net-next/c/d4893978f9f1
  - [net-next,08/15] net/mlx5: Bridge, extract VLAN push/pop actions creation
    https://git.kernel.org/netdev/net-next/c/5a9db8d47a49
  - [net-next,09/15] net/mlx5: Bridge, implement infrastructure for VLAN protocol change
    https://git.kernel.org/netdev/net-next/c/c5fcac93a3c2
  - [net-next,10/15] net/mlx5: Bridge, implement QinQ support
    https://git.kernel.org/netdev/net-next/c/9c0ca9baaa04
  - [net-next,11/15] net/mlx5e: Removed useless code in function
    https://git.kernel.org/netdev/net-next/c/bbf0b4234bdc
  - [net-next,12/15] net/mlx5e: configure meter in flow action
    https://git.kernel.org/netdev/net-next/c/9153da4635fe
  - [net-next,13/15] net/mlx5e: Extend flower police validation
    https://git.kernel.org/netdev/net-next/c/f7434ba0abfc
  - [net-next,14/15] net/mlx5e: Move the LRO-XSK check to mlx5e_fix_features
    https://git.kernel.org/netdev/net-next/c/1c31cb922199
  - [net-next,15/15] net/mlx5e: Remove the duplicating check for striding RQ when enabling LRO
    https://git.kernel.org/netdev/net-next/c/1a5504867437

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


