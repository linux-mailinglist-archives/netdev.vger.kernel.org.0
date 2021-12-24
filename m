Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7F247EAEA
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 04:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245579AbhLXDaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 22:30:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56066 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245574AbhLXDaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 22:30:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE60861FB1
        for <netdev@vger.kernel.org>; Fri, 24 Dec 2021 03:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0C7B8C36AEA;
        Fri, 24 Dec 2021 03:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640316613;
        bh=MQMNSbkQ/xGPY5rQ4wGNx3A7kO5gPcvV90sp5QpsAps=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y5ggaLIUU1bD8Fh7rpuZibrccHoQQMHXGBRRGpECe8YxdeLrt5oSmzuMhtt0l84ku
         NLcpAm/HrwwC7+uBlKbUZO3rOyUXSS8Hv3U28zN5rgLKRdkWxsPwz/WruOWOQRIz2f
         6J9aH/lE70Q+f7Fu+BaDfQ5o9WSm8NeHvleZrfh5XDLL0CRXylW6NiQp6eaXs/Nkob
         SP4NEFQeEJ7R6i/0ir9rO0WyoG2iq55HfsxpRW56OY9372Nys5Mff7AMb+zyrFtO4l
         odmlLilXlokmLcCEIezlGrOxWVUdZQnqckJ/tqNE9QtgjUg5Ubx0TcAXm9s545JxdG
         XXDwY8ysfLCmg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E473EEAC065;
        Fri, 24 Dec 2021 03:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [v2 net 01/12] net/mlx5: DR,
 Fix NULL vs IS_ERR checking in dr_domain_init_resources
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164031661293.11818.15116470780651720228.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Dec 2021 03:30:12 +0000
References: <20211223190441.153012-2-saeed@kernel.org>
In-Reply-To: <20211223190441.153012-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        roid@nvidia.com, linmq006@gmail.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Thu, 23 Dec 2021 11:04:30 -0800 you wrote:
> From: Miaoqian Lin <linmq006@gmail.com>
> 
> The mlx5_get_uars_page() function  returns error pointers.
> Using IS_ERR() to check the return value to fix this.
> 
> Fixes: 4ec9e7b02697 ("net/mlx5: DR, Expose steering domain functionality")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [v2,net,01/12] net/mlx5: DR, Fix NULL vs IS_ERR checking in dr_domain_init_resources
    https://git.kernel.org/netdev/net/c/6b8b42585886
  - [v2,net,02/12] net/mlx5: DR, Fix querying eswitch manager vport for ECPF
    https://git.kernel.org/netdev/net/c/624bf42c2e39
  - [v2,net,03/12] net/mlx5: Use first online CPU instead of hard coded CPU
    https://git.kernel.org/netdev/net/c/26a7993c93a7
  - [v2,net,04/12] net/mlx5: Fix error print in case of IRQ request failed
    https://git.kernel.org/netdev/net/c/aa968f922039
  - [v2,net,05/12] net/mlx5: Fix SF health recovery flow
    https://git.kernel.org/netdev/net/c/33de865f7bce
  - [v2,net,06/12] net/mlx5: Fix tc max supported prio for nic mode
    https://git.kernel.org/netdev/net/c/d671e109bd85
  - [v2,net,07/12] net/mlx5e: Wrap the tx reporter dump callback to extract the sq
    https://git.kernel.org/netdev/net/c/918fc3855a65
  - [v2,net,08/12] net/mlx5e: Fix skb memory leak when TC classifier action offloads are disabled
    https://git.kernel.org/netdev/net/c/a0cb909644c3
  - [v2,net,09/12] net/mlx5e: Fix interoperability between XSK and ICOSQ recovery flow
    https://git.kernel.org/netdev/net/c/17958d7cd731
  - [v2,net,10/12] net/mlx5e: Fix ICOSQ recovery flow for XSK
    https://git.kernel.org/netdev/net/c/19c4aba2d4e2
  - [v2,net,11/12] net/mlx5e: Delete forward rule for ct or sample action
    https://git.kernel.org/netdev/net/c/2820110d9459
  - [v2,net,12/12] net/mlx5: Fix some error handling paths in 'mlx5e_tc_add_fdb_flow()'
    https://git.kernel.org/netdev/net/c/4390c6edc0fb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


