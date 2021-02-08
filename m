Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCCA931439F
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 00:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhBHXU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 18:20:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:56632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229991AbhBHXUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 18:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 55EED64E75;
        Mon,  8 Feb 2021 23:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612826407;
        bh=xxZgdPkmDD3DF9mBzROSpELdoFcXp5PC4JCDZasKkJI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oUDQeVDASRFtssbca6n99AKBpxXKBloHZZ9eKYiqHK+vxOfm+D/85GfXWbHmKtCXD
         AAO+7z/J3PJQ05YuEF65cqywP/TdXcj3z/rfs1bMHebTFniG5XWKKOfGEHs1Ri8Zmh
         mukHEVZs2gI6tSP9b+MZgSgKbSeEJ7lggALNJ72hsqdC5ccV8qlsSyAeJRlU6p2BAk
         s0MP4O8DHECdZl+l2okZ3DnvcRW0J/Y2bdnYQ+/8G086z6Sbjz0fOUA9f25WkqaUFW
         t79ptalb4TyZL2j7TvwJ/01Iv7TKGuq6aJJc78ozYH8d4gvDuYJPK+BJzFDnatu0jz
         joikooVc9XyVQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 459E3609D2;
        Mon,  8 Feb 2021 23:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] rxrpc: use udp tunnel APIs instead of open code in
 rxrpc_open_socket
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161282640727.30474.5920750020422293580.git-patchwork-notify@kernel.org>
Date:   Mon, 08 Feb 2021 23:20:07 +0000
References: <33e11905352da3b65354622dcd2f7d2c3c00c645.1612686194.git.lucien.xin@gmail.com>
In-Reply-To: <33e11905352da3b65354622dcd2f7d2c3c00c645.1612686194.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        dhowells@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun,  7 Feb 2021 16:23:14 +0800 you wrote:
> In rxrpc_open_socket(), now it's using sock_create_kern() and
> kernel_bind() to create a udp tunnel socket, and other kernel
> APIs to set up it. These code can be replaced with udp tunnel
> APIs udp_sock_create() and setup_udp_tunnel_sock(), and it'll
> simplify rxrpc_open_socket().
> 
> Note that with this patch, the udp tunnel socket will always
> bind to a random port if transport is not provided by users,
> which is suggested by David Howells, thanks!
> 
> [...]

Here is the summary with links:
  - [net-next] rxrpc: use udp tunnel APIs instead of open code in rxrpc_open_socket
    https://git.kernel.org/netdev/net-next/c/1a9b86c9fd95

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


