Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35CC456472B
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 13:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbiGCLaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 07:30:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232650AbiGCLaR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 07:30:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D62D1A458
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 04:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71F85612F5
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 11:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D04FAC341CD;
        Sun,  3 Jul 2022 11:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656847815;
        bh=cdVyv1bwFgC282mHRNSMCPFVI1fkr28rAK88aLbTkZE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=esYiHpjEBNxlDuzSCXdUifI2SsrxrAoLx/WFsEk0w1hufHJO9BA/d7nt0S4ojuYYw
         GPgMRgeAjJuSJR8iInVCS0XBUoAM6thQXQG/CEiDjigmLH9pD/T8OfTg80DRgiAOzJ
         6f+eBjuKU050TwdNHAo67gZDhZzuLExmj9QE0ONVpNDXUlck2q1+9DCCc+HLT7PLYi
         JBRh8CTXIB7TQeW1WOJvL9h5uerd1q49tzB5wYBB6J0FwEA8Yi+BSGCq1F5Q+WIxjs
         djd8SYpr0ZzTaoedGoYRfbYvz+j3/Zj8pLXzEwM6wy63wndyM3hPnE+VXxzF6IgUN/
         R5Wb0dR8gsz8g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BAB98E49BB8;
        Sun,  3 Jul 2022 11:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next v2 01/15] net/mlx5: Delete ipsec_fs header file as not used
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165684781576.480.1235802815190328077.git-patchwork-notify@kernel.org>
Date:   Sun, 03 Jul 2022 11:30:15 +0000
References: <20220702190213.80858-2-saeed@kernel.org>
In-Reply-To: <20220702190213.80858-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        leonro@nvidia.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat,  2 Jul 2022 12:01:59 -0700 you wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> ipsec_fs.h is not used and can be safely deleted.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/15] net/mlx5: Delete ipsec_fs header file as not used
    https://git.kernel.org/netdev/net-next/c/9de64ae8160d
  - [net-next,v2,02/15] net/mlx5: delete dead code in mlx5_esw_unlock()
    https://git.kernel.org/netdev/net-next/c/8e755f7a8cef
  - [net-next,v2,03/15] net/mlx5: E-switch, Introduce flag to indicate if vport acl namespace is created
    https://git.kernel.org/netdev/net-next/c/ea5872dd6b05
  - [net-next,v2,04/15] net/mlx5: E-switch, Introduce flag to indicate if fdb table is created
    https://git.kernel.org/netdev/net-next/c/fbd43b7259bc
  - [net-next,v2,05/15] net/mlx5: E-switch, Remove dependency between sriov and eswitch mode
    https://git.kernel.org/netdev/net-next/c/f019679ea5f2
  - [net-next,v2,06/15] net/mlx5: E-switch: Change eswitch mode only via devlink command
    https://git.kernel.org/netdev/net-next/c/b6f2846afc0c
  - [net-next,v2,07/15] net/mlx5: Add support to create SQ and CQ for ASO
    https://git.kernel.org/netdev/net-next/c/cdd04f4d4d71
  - [net-next,v2,08/15] net/mlx5: Implement interfaces to control ASO SQ and CQ
    https://git.kernel.org/netdev/net-next/c/c491ded04325
  - [net-next,v2,09/15] net/mlx5e: Prepare for flow meter offload if hardware supports it
    https://git.kernel.org/netdev/net-next/c/74e6b2a87433
  - [net-next,v2,10/15] net/mlx5e: Add support to modify hardware flow meter parameters
    https://git.kernel.org/netdev/net-next/c/6ddac26cf763
  - [net-next,v2,11/15] net/mlx5e: Get or put meter by the index of tc police action
    https://git.kernel.org/netdev/net-next/c/b8acfd4f21e2
  - [net-next,v2,12/15] net/mlx5e: Add generic macros to use metadata register mapping
    https://git.kernel.org/netdev/net-next/c/17c5da03879b
  - [net-next,v2,13/15] net/mlx5e: Add post meter table for flow metering
    https://git.kernel.org/netdev/net-next/c/06fe52a47659
  - [net-next,v2,14/15] net/mlx5e: Add flow_action to parse state
    https://git.kernel.org/netdev/net-next/c/03a92a938dc7
  - [net-next,v2,15/15] net/mlx5e: TC, Support offloading police action
    https://git.kernel.org/netdev/net-next/c/a8d52b024d6d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


