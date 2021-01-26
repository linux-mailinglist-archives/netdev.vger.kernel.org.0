Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B642303558
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388099AbhAZFjZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:39:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:45320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727045AbhAZDUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Jan 2021 22:20:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id F332F22D04;
        Tue, 26 Jan 2021 03:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611631211;
        bh=Eq7bieJZtKDYCyu5A++q0xsq5LHk5AJNhRbeLAevgdk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e4XxxYD40rJleLQi42qn7kvmAkwBxaqGEjWstE4aOwuoWt+ZMhgq/VWipysdKO+YC
         TkVy6Db7ic/Nw4oaxK8mmiJVjQGVfdOqrpnO9u/N893yI20SVXd6nn62S6inwc0TES
         6SlpkoQB0D8J6YED5f1Zs2tcG/Ep5aW7B9BTclcdxD4SdhyR+DeQLKAXsjZCQ8MMcN
         TB9WFp8GbzAKl5G37tc0PpoLOMVb8ExlGMlpqU/bRevTPRt8GXuS8FT5izzyMqkqs+
         Cp4xBCpxP84y/Okvz8lSSx/Gxad9jxLoq95VsX8Jt6zxDwHL5Ukjudsy86ieVeakjd
         P2RE7IsfwFoYw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E7DCD61FC3;
        Tue, 26 Jan 2021 03:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bridge: Use PTR_ERR_OR_ZERO instead if(IS_ERR(...)) + PTR_ERR
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161163121094.4087.10728008683417299022.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Jan 2021 03:20:10 +0000
References: <1611542381-91178-1-git-send-email-abaci-bugfix@linux.alibaba.com>
In-Reply-To: <1611542381-91178-1-git-send-email-abaci-bugfix@linux.alibaba.com>
To:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Cc:     roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, natechancellor@gmail.com, ndesaulniers@google.com,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 25 Jan 2021 10:39:41 +0800 you wrote:
> coccicheck suggested using PTR_ERR_OR_ZERO() and looking at the code.
> 
> Fix the following coccicheck warnings:
> 
> ./net/bridge/br_multicast.c:1295:7-13: WARNING: PTR_ERR_OR_ZERO can be
> used.
> 
> [...]

Here is the summary with links:
  - bridge: Use PTR_ERR_OR_ZERO instead if(IS_ERR(...)) + PTR_ERR
    https://git.kernel.org/netdev/net-next/c/8d21c882aba8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


