Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D01AB30547D
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 08:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbhA0HXo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 02:23:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:48178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S316665AbhA0Alc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 19:41:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5688C64D88;
        Wed, 27 Jan 2021 00:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611708010;
        bh=jjFGgTzCmRCv7pShpF5J8MlAqaYhEy4lCIb8vLuNKa4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Kd8UQW5dM5G4XMT2ytIXC2jySY8GIlogq57BAp7B8dxXI9q+WGYE4NOIzDc3Mxwlw
         AsJAIjVri6sYK+4lXqy5SSDlGbE2XyW+lHuF9/2Epm5gXHOiP2BnswBEzEXy/H5XrP
         M8o7TzB7smhB79ImmGwmwO6jURI6dlmS/qP9Fd8yCYGGhBDoPBUSzmZVfBTH3VAjLc
         g8xRl/cGd0hapBmYKkYvrBcM+RpPWq29ZA3p1O/c1U4LNGUKHMt+u9N9xY3v/UmVwt
         2qEK80iBZNixBfhpogkkUg85H8KlpNia6WQdorbNLiE9CrAI8kxlOLIoyt0QakDWu3
         9sfsKeT/Vm9bQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 44453652E0;
        Wed, 27 Jan 2021 00:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bridge: multicast: fix
 br_multicast_eht_set_entry_lookup indentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161170801027.21618.16390055451192059692.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Jan 2021 00:40:10 +0000
References: <20210125082040.13022-1-razor@blackwall.org>
In-Reply-To: <20210125082040.13022-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org, kuba@kernel.org,
        davem@davemloft.net, nikolay@nvidia.com, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 25 Jan 2021 10:20:40 +0200 you wrote:
> From: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> Fix the messed up indentation in br_multicast_eht_set_entry_lookup().
> 
> Fixes: baa74d39ca39 ("net: bridge: multicast: add EHT source set handling functions")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: bridge: multicast: fix br_multicast_eht_set_entry_lookup indentation
    https://git.kernel.org/netdev/net-next/c/3e841bacf72f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


