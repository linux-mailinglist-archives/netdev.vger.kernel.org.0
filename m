Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34DBF48188A
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:30:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234807AbhL3CaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:30:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234793AbhL3CaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:30:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7D0C061574
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 18:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4542ACE1AB2
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 02:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6B02DC36AE1;
        Thu, 30 Dec 2021 02:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640831410;
        bh=Yk3b/zTOW5YeoA/GLqsIDEpm/Ybd6BznLjqoorHTT60=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WbfWjeObGHC+1uZwb0O52MQMKjEYcGKJp+RQ+21BjRlYFwJHnP/yzqGVgm+XNk5y3
         5Zz6bKY5Y+ZicFXoxGT/9iT7astxMPMrlFX7cfl4mMRiDzskN1pj1tP+x59CA40/av
         ro9L/K3XP/hppmy5W7rNB7w2AckdOkG3nRTPTieoOp9VPoZaAChL+TY/aPvEyH5gav
         6MM9yEjQT5IsQT58RwgZ5rrKdfvlxAEN5GeP345qWqaF+4BR9WAzZprbr6MtUFZcVv
         0DwGhQGe1V4Khjlbu2Ueekap5NXo+6awuq8qw8UFoSq1VIbEey34x2DVt+IxI08A9H
         xrFU0cF60JP2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 50467C395E4;
        Thu, 30 Dec 2021 02:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net 1/2] net/mlx5e: TC,
 Fix memory leak with rules with internal port
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164083141032.11132.2786231068394087418.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Dec 2021 02:30:10 +0000
References: <20211229065352.30178-2-saeed@kernel.org>
In-Reply-To: <20211229065352.30178-2-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        roid@nvidia.com, saeedm@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Saeed Mahameed <saeedm@nvidia.com>:

On Tue, 28 Dec 2021 22:53:51 -0800 you wrote:
> From: Roi Dayan <roid@nvidia.com>
> 
> Fix a memory leak with decap rule with internal port as destination
> device. The driver allocates a modify hdr action but doesn't set
> the flow attr modify hdr action which results in skipping releasing
> the modify hdr action when releasing the flow.
> 
> [...]

Here is the summary with links:
  - [net,1/2] net/mlx5e: TC, Fix memory leak with rules with internal port
    https://git.kernel.org/netdev/net/c/077cdda764c7
  - [net,2/2] net/mlx5e: Fix wrong features assignment in case of error
    https://git.kernel.org/netdev/net/c/992d8a4e38f0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


