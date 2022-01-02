Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68AC482B02
	for <lists+netdev@lfdr.de>; Sun,  2 Jan 2022 13:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbiABMUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jan 2022 07:20:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58606 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiABMUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jan 2022 07:20:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D70AE60C4E;
        Sun,  2 Jan 2022 12:20:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3F7CDC36AEF;
        Sun,  2 Jan 2022 12:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641126009;
        bh=gFw9Bkudy0WLB2fmuCTRkFdkoevTtHNSg81TjK3q9gw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NgtXRrBDjh8OA7Clto8L1rpBiFobiwPToRtn0UXC/C+ufRXJIcksXa3V3Fy2jvlVO
         K3dtfluaf46QwRhgVIBylq9RyuqXuTUwj1Zqg4OpgIBIGeU3esDECBQiOrqXlWSYO3
         V+CXMD6kdR+g6EFLgUX/4REd2F7I7c8KHZQur6cBDplYZxMVsDJKojKKmRia9fUOG3
         KLOPE64IW2O88xzsWA13d/xrLHcMr4IIEqaJdNLNUiS2csKUeRR+S/F3lT9VMyRutT
         LtkX6yVQMXnw8CWQf965GccZVh64o//ntpFUvoEIu4LEjy9lAVC8NL6ERjaKXm8yDP
         YF2jSAH20Zy+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 25C72C395E8;
        Sun,  2 Jan 2022 12:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] mctp: Remove only static neighbour on RTM_DELNEIGH
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164112600914.23508.794588778406331918.git-patchwork-notify@kernel.org>
Date:   Sun, 02 Jan 2022 12:20:09 +0000
References: <20220101054125.9104-1-gagan1kumar.cs@gmail.com>
In-Reply-To: <20220101054125.9104-1-gagan1kumar.cs@gmail.com>
To:     Gagan Kumar <gagan1kumar.cs@gmail.com>
Cc:     kuba@kernel.org, jk@codeconstruct.com.au,
        matt@codeconstruct.com.au, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sat,  1 Jan 2022 11:11:25 +0530 you wrote:
> Add neighbour source flag in mctp_neigh_remove(...) to allow removal of
> only static neighbours.
> 
> This should be a no-op change and might be useful later when mctp can
> have MCTP_NEIGH_DISCOVER neighbours.
> 
> Signed-off-by: Gagan Kumar <gagan1kumar.cs@gmail.com>
> 
> [...]

Here is the summary with links:
  - [v2] mctp: Remove only static neighbour on RTM_DELNEIGH
    https://git.kernel.org/netdev/net/c/ae81de737885

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


