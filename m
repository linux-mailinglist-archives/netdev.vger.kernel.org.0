Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318593D72F6
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 12:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236218AbhG0KUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 06:20:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236169AbhG0KUF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 06:20:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9719D611C4;
        Tue, 27 Jul 2021 10:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627381205;
        bh=Ikd8bFaK0yvzUnxMI2mOjgA2Cy0fJITmR9svvlG00dk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MdRKQBtRDF6fj67gu/UesNEWizlEJZZ3TSjbSwlgit50YEaJDXu+CApQrAxV59tS+
         9Z4lWJ0VybSVzb8fiVBCAIR9PRn39lbD63HotzIyQwHjKFBJHBYxFcZhyBcNa6px0u
         o72WAe2kYDDoxcE5PCQ5URuKSCAxJi3H2Mr2pYk0dljK3bTQkaq2rbHAxofYGDUC9a
         UL/BHaduEgSf4GHHGwdQETd0S+CiEuAQyXhTmxTEbv7fbgpiw1uof6IlYQNPCFGSKs
         Rj1Ijj35EU9JSh2szfen5yPisLe4A2mL8/CPhWEbg6g1qXl3fQwsvx7p9t5CXQbPO9
         MVcqe0/XF6KhA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8798260A6C;
        Tue, 27 Jul 2021 10:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ethtool: Fix rxnfc copy to user buffer overflow
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162738120555.32176.18384450334218586781.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Jul 2021 10:20:05 +0000
References: <20210726221539.492937-1-saeed@kernel.org>
In-Reply-To: <20210726221539.492937-1-saeed@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        saeedm@nvidia.com, snelson@pensando.io, arnd@arndb.de, hch@lst.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 26 Jul 2021 15:15:39 -0700 you wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> In the cited commit, copy_to_user() got called with the wrong pointer,
> instead of passing the actual buffer ptr to copy from, a pointer to
> the pointer got passed, which causes a buffer overflow calltrace to pop
> up when executing "ethtool -x ethX".
> 
> [...]

Here is the summary with links:
  - [net-next] ethtool: Fix rxnfc copy to user buffer overflow
    https://git.kernel.org/netdev/net-next/c/9b29a161ef38

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


