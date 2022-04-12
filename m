Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7370C4FCD4A
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 05:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243695AbiDLDwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 23:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345021AbiDLDwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 23:52:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0542D15710;
        Mon, 11 Apr 2022 20:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACA94B81A96;
        Tue, 12 Apr 2022 03:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F571C385AA;
        Tue, 12 Apr 2022 03:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649735413;
        bh=OWBmsH7tNkO0L31bvNdB0XbMkvwcnMB5Nadg22RZl6w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jneuIcp1Zok0MZicDAHeC21MbacLJG+ayqcXDw0sxIfQSlTeW9uxsLa2khkDI3Zry
         Wid+Tgpe2zGtvhrhxcT954bAkl32/BtFaaC1AYbapZA4JsvsmCLMxz6Fb6U7vmon0H
         UjfYXdAKw8/fpEkXiu1DP8j9jULTd0YhGm8YkhtsvvJmhypoHp/zVZg9XNkySW8hzA
         h6B/4RIsh2I8nc+2FpeANJCFG1eLXraQXocj0KNw8LwS7hTpL4OpKL8Ed5hkWoxdwF
         sLroqQ0GpitkVS4XNtl3SGQpK2FmrxHmkjvutruP2PN7uOWP0YmWem7TgIfyYYHnLZ
         gbbgWcBvSXwiw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 404B5E8DBD1;
        Tue, 12 Apr 2022 03:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] Please pull mlx5-next changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164973541325.27148.6416076913978942343.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Apr 2022 03:50:13 +0000
References: <20220409055303.1223644-1-leon@kernel.org>
In-Reply-To: <20220409055303.1223644-1-leon@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     pabeni@redhat.com, kuba@kernel.org, davem@davemloft.net,
        jgg@nvidia.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, leonro@nvidia.com
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

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat,  9 Apr 2022 08:53:03 +0300 you wrote:
> The following changes since commit 3123109284176b1532874591f7c81f3837bbdc17:
> 
>   Linux 5.18-rc1 (2022-04-03 14:08:21 -0700)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git mlx5-next
> 
> [...]

Here is the summary with links:
  - [GIT,PULL] Please pull mlx5-next changes
    https://git.kernel.org/netdev/net-next/c/e69a837f5801

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


