Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC60674B15
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 05:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjATEoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 23:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbjATEnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 23:43:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35E92CE89A
        for <netdev@vger.kernel.org>; Thu, 19 Jan 2023 20:39:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 942B8B82819
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 04:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 13860C433D2;
        Fri, 20 Jan 2023 04:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674187219;
        bh=KBg4loY015TjacXFYFvRoqxPDSKaKFRLuEYMYx5h5bA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=r4qVTg/ZWWWYi9hifCiE2n83l7YnFB3QDCleJQ92Pjki3oe5qqRpbigtUVoCJJsGA
         RcdkCjyvvFDsDq/MIqwOB92+JAbTq7jmgKUWDqqxw78mDBKqAH+7bbEIa2Cd/O4EVo
         TK5o0vyZlHhpd81JwaQT+CZcW7P2hfEsBG8APKWjbxYNhcK0zISq0yjCd06PV/BFnW
         EHKP9/bM1KHxRJWlEC1nHpqlKIpadKPhgUFe/hxkfcvULyJg/5RTtxFKmMGp/bVxZq
         ZK9G3BXJsoWRvemqapVjgPDfyEOv/fTGk0fbhS63uq9SaTs84OIerJdp4+lZmqE88G
         R9SZS9LlX+wqw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EBCF0C43147;
        Fri, 20 Jan 2023 04:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next 01/15] net/mlx5e: Suppress Send WQEBB room warning for
 PAGE_SIZE >= 16KB
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167418721896.19800.10233583368684186895.git-patchwork-notify@kernel.org>
Date:   Fri, 20 Jan 2023 04:00:18 +0000
References: <20230118183602.124323-2-saeed@kernel.org>
In-Reply-To: <20230118183602.124323-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        tariqt@nvidia.com, rrameshbabu@nvidia.com, lkp@intel.com
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
by Saeed Mahameed <saeedm@nvidia.com>:

On Wed, 18 Jan 2023 10:35:48 -0800 you wrote:
> From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> 
> Send WQEBB size is 64 bytes and the max number of WQEBBs for an SQ is 255.
> For 16KB pages and greater, there is always sufficient spaces for all
> WQEBBs of an SQ. Cast mlx5e_get_max_sq_wqebbs(mdev) to u16. Prevents
> -Wtautological-constant-out-of-range-compare warnings from occurring when
> PAGE_SIZE >= 16KB.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] net/mlx5e: Suppress Send WQEBB room warning for PAGE_SIZE >= 16KB
    https://git.kernel.org/netdev/net-next/c/022dbea0ea8e
  - [net-next,02/15] net/mlx5: Suppress error logging on UCTX creation
    https://git.kernel.org/netdev/net-next/c/d0f332dc9689
  - [net-next,03/15] net/mlx5: Add adjphase function to support hardware-only offset control
    https://git.kernel.org/netdev/net-next/c/8e11a68e2e8a
  - [net-next,04/15] net/mlx5: Add hardware extended range support for PTP adjtime and adjphase
    https://git.kernel.org/netdev/net-next/c/d3c8a33a5cad
  - [net-next,05/15] net/mlx5: E-switch, Remove redundant comment about meta rules
    https://git.kernel.org/netdev/net-next/c/1158b7d1c640
  - [net-next,06/15] net/mlx5e: Fail with messages when params are not valid for XSK
    https://git.kernel.org/netdev/net-next/c/130b12079f37
  - [net-next,07/15] net/mlx5e: Add warning when log WQE size is smaller than log stride size
    https://git.kernel.org/netdev/net-next/c/b80ae281277f
  - [net-next,08/15] net/mlx5e: TC, Pass flow attr to attach/detach mod hdr functions
    https://git.kernel.org/netdev/net-next/c/82b564802661
  - [net-next,09/15] net/mlx5e: TC, Add tc prefix to attach/detach hdr functions
    https://git.kernel.org/netdev/net-next/c/c43182e6db32
  - [net-next,10/15] net/mlx5e: TC, Use common function allocating flow mod hdr or encap mod hdr
    https://git.kernel.org/netdev/net-next/c/ef78b8d5d6f1
  - [net-next,11/15] net/mlx5e: Warn when destroying mod hdr hash table that is not empty
    https://git.kernel.org/netdev/net-next/c/2a1f4fed392b
  - [net-next,12/15] net/mlx5: E-Switch, Fix typo for egress
    https://git.kernel.org/netdev/net-next/c/55b458481d68
  - [net-next,13/15] net/mlx5e: Support Geneve and GRE with VF tunnel offload
    https://git.kernel.org/netdev/net-next/c/521933cdc4aa
  - [net-next,14/15] net/mlx5e: Remove redundant allocation of spec in create indirect fwd group
    https://git.kernel.org/netdev/net-next/c/42cd20044e85
  - [net-next,15/15] net/mlx5e: Use read lock for eswitch get callbacks
    https://git.kernel.org/netdev/net-next/c/efb4879f7623

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


