Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAAA3AD36A
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 22:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbhFRUMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 16:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:45986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230338AbhFRUMO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 16:12:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5CC44613C2;
        Fri, 18 Jun 2021 20:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624047004;
        bh=fQ7TmNp/wbrGhCgwdpBrWfCZOYK2Tt4Wai0IcqJ4Qj0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YUsIeym9SWlurM5obUS3jSEf0NX9gTNnyyug0Kt/UYLbwGA56p2wGJzUe3TqqQ4Nd
         JK5oNEXQh7yhQgkALIfB2u8bpknWsa51VFbGwBzlcEdm9M0TaBGRQKMiOoZVI9EaPc
         OlThjvUbz4Wt4rqPRKgxnAyUxcs73ARyoMarDP+/7VytMAb9Fic0tZ3RuMUQX1v8oX
         fLoodk/YEOG1TQaPAP1Pws3AJNUW7iKKAK+UhMA0Amn2fkH20UadH9uFMLjmpscYAz
         LeFX800FwOi1D5pvHRCuEZ1AymdFas74TnU9Fk1zlsiOHEa5IvsNBuwNGJwshSt0OK
         9jsqS9jh1yPTw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4FABA60A17;
        Fri, 18 Jun 2021 20:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: fix potential use-after-free in ec_bhf_remove
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404700432.5742.11129336023473199529.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 20:10:04 +0000
References: <20210618134902.9793-1-paskripkin@gmail.com>
In-Reply-To: <20210618134902.9793-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     reksio@newterm.pl, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 18 Jun 2021 16:49:02 +0300 you wrote:
> static void ec_bhf_remove(struct pci_dev *dev)
> {
> ...
> 	struct ec_bhf_priv *priv = netdev_priv(net_dev);
> 
> 	unregister_netdev(net_dev);
> 	free_netdev(net_dev);
> 
> [...]

Here is the summary with links:
  - net: ethernet: fix potential use-after-free in ec_bhf_remove
    https://git.kernel.org/netdev/net/c/9cca0c2d7014

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


