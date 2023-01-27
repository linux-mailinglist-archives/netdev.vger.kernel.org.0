Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF8767DAEF
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 01:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbjA0AuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 19:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjA0AuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 19:50:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FB1470B5;
        Thu, 26 Jan 2023 16:50:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEB06B81F6B;
        Fri, 27 Jan 2023 00:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7F6EEC4339B;
        Fri, 27 Jan 2023 00:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674780618;
        bh=8+PlQ5dRXgotElxfcj/CEkKeon4B3RXjfPbboiV1eQE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HRfM7PoZtcACs73ZnVIPMnM7YJjzRr+XAh20Z2UzQBIsXL8Ek6HSgC85T8PMzRY60
         n7w6O5UbQT4PtE/wW3lttDAZBcCBoXY8SXQ2kwjHVZbWWq91lDkvJEBKR6q1ctQtDU
         3CAqgpUWA25PEmn4ofSM/TBgDw2zuU/S6PlRpuL0nV5wyt6UixT8u64DpOJfU+KCla
         j7YlD0H7bvx3m6jACJRx72LVHnXe+x8+jEO6ybhwevTLYAGnYJ1k8XFFALJE8tMScS
         sQTgXvtje6R/V6mJXq80Y77m/joPzYTZn+P+1yJpwVf4Zq4FpYteIFuDdmnwgIv/QH
         HUSQQAGrplwkw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 68D3EF83ED2;
        Fri, 27 Jan 2023 00:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1 00/10] Convert drivers to return XFRM
 configuration errors through extack
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167478061842.17988.12550218546200310016.git-patchwork-notify@kernel.org>
Date:   Fri, 27 Jan 2023 00:50:18 +0000
References: <cover.1674560845.git.leon@kernel.org>
In-Reply-To: <cover.1674560845.git.leon@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, steffen.klassert@secunet.com,
        andy@greyhouse.net, ayush.sawal@chelsio.com, edumazet@google.com,
        herbert@gondor.apana.org.au, intel-wired-lan@lists.osuosl.org,
        j.vosburgh@gmail.com, jesse.brandeburg@intel.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        pabeni@redhat.com, rajur@chelsio.com, saeedm@nvidia.com,
        simon.horman@corigine.com, anthony.l.nguyen@intel.com,
        vfalico@gmail.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 24 Jan 2023 13:54:56 +0200 you wrote:
> Changelog
> v1:
>  * Fixed rebase errors in mlx5 and cxgb4 drivers
>  * Fixed previously existed typo in nfp driver
>  * Added Simon's ROB
>  * Removed my double SOB tags
> v0: https://lore.kernel.org/all/cover.1674481435.git.leon@kernel.org
> 
> [...]

Here is the summary with links:
  - [net-next,v1,01/10] xfrm: extend add policy callback to set failure reason
    https://git.kernel.org/netdev/net-next/c/3089386db090
  - [net-next,v1,02/10] net/mlx5e: Fill IPsec policy validation failure reason
    https://git.kernel.org/netdev/net-next/c/1bb70c5ab6ec
  - [net-next,v1,03/10] xfrm: extend add state callback to set failure reason
    https://git.kernel.org/netdev/net-next/c/7681a4f58fb9
  - [net-next,v1,04/10] net/mlx5e: Fill IPsec state validation failure reason
    https://git.kernel.org/netdev/net-next/c/902812b81604
  - [net-next,v1,05/10] netdevsim: Fill IPsec state validation failure reason
    https://git.kernel.org/netdev/net-next/c/6c4869795568
  - [net-next,v1,06/10] nfp: fill IPsec state validation failure reason
    https://git.kernel.org/netdev/net-next/c/05ddf5f8cb6c
  - [net-next,v1,07/10] ixgbevf: fill IPsec state validation failure reason
    https://git.kernel.org/netdev/net-next/c/c068ec5c964d
  - [net-next,v1,08/10] ixgbe: fill IPsec state validation failure reason
    https://git.kernel.org/netdev/net-next/c/505c500cfcb4
  - [net-next,v1,09/10] bonding: fill IPsec state validation failure reason
    https://git.kernel.org/netdev/net-next/c/3fe57986271a
  - [net-next,v1,10/10] cxgb4: fill IPsec state validation failure reason
    https://git.kernel.org/netdev/net-next/c/8c284ea429d2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


