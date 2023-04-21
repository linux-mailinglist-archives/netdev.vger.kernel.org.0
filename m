Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1A8E6EA8BD
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 13:00:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbjDULAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 07:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjDULAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 07:00:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCCF43A88
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 04:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BB7664FE4
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 11:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D04FCC433D2;
        Fri, 21 Apr 2023 11:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682074820;
        bh=Nt9mWJLPYSwdp+VV6ZyhT436uhHVFABEdzG1v8r3cl4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TQ6ryOj4YmFCNCYYvq3TCs/mRb+yk+7/QDGF/V9a0B9Htr/UiCNMZqmzhNm8G9HNt
         4XzjrS/kAKo8roblckl6o57ZCtjvzY4It/UumFGTHeUjGdiLk1ao3exBuDCt8K78re
         K8xc3mEkOX1QVzgJCe2FJ6tLA5KtWOy178PCsIJWrlY+Jwx4ZoOJdG6jMnlZWgA+18
         /a3hk2YSZkJolDlf3KNP+mM5TXSZVQ3XwInyEf5RBhQsgBgxHHaz4QJRIBh249faHB
         J7fq4c7ChZBvTURnuBlPH636zjh0Y0KWNh66MQMRRWeEjHZcNcsbVqWT2lDjPCpTmQ
         pgfIdSFkwAuuQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A7C53E270E2;
        Fri, 21 Apr 2023 11:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] Fixes to mlx5 IPsec implementation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168207482068.15708.11405033223948355702.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Apr 2023 11:00:20 +0000
References: <cover.1681976818.git.leon@kernel.org>
In-Reply-To: <cover.1681976818.git.leon@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     kuba@kernel.org, leonro@nvidia.com, ehakim@nvidia.com,
        edumazet@google.com, netdev@vger.kernel.org, pabeni@redhat.com,
        raeds@nvidia.com, saeedm@nvidia.com, steffen.klassert@secunet.com,
        simon.horman@corigine.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 20 Apr 2023 11:02:46 +0300 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Hi,
> 
> This small patchset includes various fixes and one refactoring patch
> which I collected for the features sent in this cycle, with one exception -
> first patch.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net/mlx5e: Fix FW error while setting IPsec policy block action
    https://git.kernel.org/netdev/net-next/c/e239e31ae802
  - [net-next,2/5] net/mlx5e: Don't overwrite extack message returned from IPsec SA validator
    https://git.kernel.org/netdev/net-next/c/697b3518ebfd
  - [net-next,3/5] net/mlx5e: Compare all fields in IPv6 address
    https://git.kernel.org/netdev/net-next/c/3198ae7d42af
  - [net-next,4/5] net/mlx5e: Properly release work data structure
    https://git.kernel.org/netdev/net-next/c/94edec448479
  - [net-next,5/5] net/mlx5e: Refactor duplicated code in mlx5e_ipsec_init_macs
    https://git.kernel.org/netdev/net-next/c/45fd01f2fbf1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


