Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590B449E872
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 18:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244287AbiA0RKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 12:10:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43574 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234656AbiA0RKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 12:10:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8613761AC7
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 17:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E0983C340EC;
        Thu, 27 Jan 2022 17:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643303409;
        bh=pQ9TQhH/zfvT4t/ngXp1Qvqr0CwHUKwkOyGw+KL0Poc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AeICuIR1X4/4Yb/dvF4124tcCZYPjJ5Gfnbwedn/qxktOGf3pN19E55pKKykUwXl6
         FbB0aVKp7Bt0LUuMMx8CheBnvd7pXHKjcX/SW5e4SCsgaZFayjNKWvq8AeWnIgWyL8
         Kp4yENYSkM3tLgEhZihA/OS61Zhc0RRbXeh4/2cTju83Qb4tZi6j3XLgh9znj0ww1D
         HHSspTTNt/0n3WDlV/nGtSBVi6/EmA1FtTXYIexW9uStXW8AmaCWa3Cp/+yRJxPbiR
         H7D6L2/QOPax/pjby1Oni3K1mNpRdI1BJOcfVz5y+eLk7AmOstxE2rMKMPSxqyhnhL
         ILzEt0OG1rFEg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C9D31E5D084;
        Thu, 27 Jan 2022 17:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: bridge: vlan: fix memory leak in __allowed_ingress
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164330340982.19448.11235674242390336417.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 17:10:09 +0000
References: <20220127074953.12632-1-tim.yi@pica8.com>
In-Reply-To: <20220127074953.12632-1-tim.yi@pica8.com>
To:     Tim Yi <tim.yi@pica8.com>
Cc:     nikolay@nvidia.com, roopa@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 27 Jan 2022 15:49:53 +0800 you wrote:
> When using per-vlan state, if vlan snooping and stats are disabled,
> untagged or priority-tagged ingress frame will go to check pvid state.
> If the port state is forwarding and the pvid state is not
> learning/forwarding, untagged or priority-tagged frame will be dropped
> but skb memory is not freed.
> Should free skb when __allowed_ingress returns false.
> 
> [...]

Here is the summary with links:
  - net: bridge: vlan: fix memory leak in __allowed_ingress
    https://git.kernel.org/netdev/net/c/fd20d9738395

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


