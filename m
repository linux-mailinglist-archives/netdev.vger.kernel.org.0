Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE3439953C
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 23:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbhFBVLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 17:11:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:59236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229558AbhFBVLt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 17:11:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 39A0B61287;
        Wed,  2 Jun 2021 21:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622668206;
        bh=PwQmK7m73fjwV3e252/9AXIDMygL3XKbAdpOiuV9koY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sFzkoqJd/vKmjXfRvZiA0/6yoQWTTLByHAYPtYS8iq7cI24hIHcWQXQ7bnbfgLOmc
         78hG01xRcvYI5cRP4mTbMTTQ+QP4P+rLOZqpalUEG0GMxHGVLSl3mzLxhgOTAGSehE
         IAoLdVCi7B2ivL6BpLjCsJ4JRJPfIedHYAkbxUEkIZapmrVYFlqx4RA5pABfxysV0/
         xYhdXUC50DZfERoyWcVY7POImAs2QFaPH6CDv8IXOxjfIv9q0HiO+fUIRV5fkUjpnH
         sXfUcp5ofYQcM5XfCX0URaefwj9YUnOV13oLJZ9VlmK6bFSJ6LG+fr0HQ+e6rJD7hq
         j7riDWvohUVKA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2DE9260BFB;
        Wed,  2 Jun 2021 21:10:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/8] Introduce conntrack offloading to the nfp
 driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162266820618.24657.17305840919596099059.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 21:10:06 +0000
References: <20210602115952.17591-1-simon.horman@corigine.com>
In-Reply-To: <20210602115952.17591-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, louis.peens@corigine.com,
        yinjun.zhang@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed,  2 Jun 2021 13:59:44 +0200 you wrote:
> Louis Peens says:
> 
> This is the first in a series of patches to offload conntrack
> to the nfp. The approach followed is to flatten out three
> different flow rules into a single offloaded flow. The three
> different flows are:
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/8] nfp: flower: move non-zero chain check
    https://git.kernel.org/netdev/net-next/c/2bda0a5e3bf8
  - [net-next,v3,2/8] nfp: flower-ct: add pre and post ct checks
    https://git.kernel.org/netdev/net-next/c/c8b034fbeba5
  - [net-next,v3,3/8] nfp: flower-ct: add ct zone table
    https://git.kernel.org/netdev/net-next/c/e236e4849b58
  - [net-next,v3,4/8] nfp: flower-ct: add zone table entry when handling pre/post_ct flows
    https://git.kernel.org/netdev/net-next/c/bd0fe7f96a3c
  - [net-next,v3,5/8] nfp: flower-ct: add nfp_fl_ct_flow_entries
    https://git.kernel.org/netdev/net-next/c/072c089ca536
  - [net-next,v3,6/8] nfp: flower-ct: add a table to map flow cookies to ct flows
    https://git.kernel.org/netdev/net-next/c/fa81d6d214a4
  - [net-next,v3,7/8] nfp: flower-ct: add tc_merge_tb
    https://git.kernel.org/netdev/net-next/c/f7ae12e2f95d
  - [net-next,v3,8/8] nfp: flower-ct: add tc merge functionality
    https://git.kernel.org/netdev/net-next/c/3c863c300c09

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


