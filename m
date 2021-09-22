Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E93414ACF
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 15:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233093AbhIVNlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 09:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232754AbhIVNlh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Sep 2021 09:41:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CA7A7611EE;
        Wed, 22 Sep 2021 13:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632318007;
        bh=XtCfyNLtv9F2J71znzoANXN/A0DBmASQDItylGm6u54=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qGUw8Jey7m7d7KxSIb/QgezwFUK+CBu56g21yZxOM8l0ww41cCFI3L1n/Gobl7MZy
         m+aGPlVdnJ4wjdyxSQSGSJB/6+jCVR7Rtty9pqkYXYoqGt/dwD4HyznkcAIQtimLPd
         q5DPoEZsUgY2aKuqZrLp9tvk3byIxn4fZ9SyEeK0skrW65hCqBve1dOZD/uyiFHb4g
         zv4k/UTpmbpAhlCuvQfwU26Olf4IDqr7YSGEwT4YLVF9isvn61GDN9r63+2cc8lH3e
         lHac5rastnLjziBivJ14cOGM4uBXvZTEyGG70I7QZbUS/KNkSM7KEy//IX30aIB2/a
         0lKgmfGqD+faw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BF24360A6B;
        Wed, 22 Sep 2021 13:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] mlxsw: Alter trap adjacency entry allocation
 scheme
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163231800777.24457.6344591772401894676.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Sep 2021 13:40:07 +0000
References: <20210922073642.796559-1-idosch@idosch.org>
In-Reply-To: <20210922073642.796559-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 22 Sep 2021 10:36:40 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> In commit 0c3cbbf96def ("mlxsw: Add specific trap for packets routed via
> invalid nexthops"), mlxsw started allocating a new adjacency entry
> during driver initialization, to trap packets routed via invalid
> nexthops.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] mlxsw: spectrum_router: Add trap adjacency entry upon first nexthop group
    https://git.kernel.org/netdev/net-next/c/4bdf80bcb79a
  - [net-next,2/2] mlxsw: spectrum_router: Start using new trap adjacency entry
    https://git.kernel.org/netdev/net-next/c/e3a3aae74d76

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


