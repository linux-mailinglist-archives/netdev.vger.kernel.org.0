Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8632308065
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 22:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231436AbhA1VVB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 16:21:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:60208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231301AbhA1VUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 16:20:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6151364DED;
        Thu, 28 Jan 2021 21:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611868811;
        bh=qYMoaduRff6h3xUtPrullrDy7UxCd6JnGwQyKOGtxHM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i3bXAGBiRB7nlXcc8hOmQH7Vsgxr5GKB4xC+VqzbPTRumaNUCca49n6SS4fnygscP
         swv1HJfN5zlpxMgVcLJfwaEeyvcX1fpG4Yz1lbmsD7RwoeK1AOanT/26LGNW3hAEMu
         K3frlAxvyEDACgM/4aPc7v23B9wl5FmkImBPXRghYOhRH6rZ7zhv4xwz1FLDJ+Dcfe
         EQ0nI1Lojw0jbtMPLFCvF3U67+0zS8HLmYnW6jPWQ30h6MBS/hQbdt6BNP8X/o2gXB
         K8zUdrh/g7f3MZt9kn+tnAaJo9r6Z66vP9wXgLsjdKjf8Cn4NzV6KXbb7/GOC8tqrs
         xcXAIdBnAJFmA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5695365322;
        Thu, 28 Jan 2021 21:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] mlxsw: Various fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161186881134.25673.4178729640417233981.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 21:20:11 +0000
References: <20210128144820.3280295-1-idosch@idosch.org>
In-Reply-To: <20210128144820.3280295-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu, 28 Jan 2021 16:48:18 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Patch #1 fixes wrong invocation of mausezahn in a couple of selftests.
> The tests started failing after Fedora updated their libnet package from
> version 1.1.6 to 1.2.1. With the fix the tests pass regardless of libnet
> version.
> 
> [...]

Here is the summary with links:
  - [net,1/2] selftests: forwarding: Specify interface when invoking mausezahn
    https://git.kernel.org/netdev/net/c/11df27f7fdf0
  - [net,2/2] mlxsw: spectrum_span: Do not overwrite policer configuration
    https://git.kernel.org/netdev/net/c/b6f6881aaf23

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


