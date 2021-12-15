Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6538475B7A
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 16:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243717AbhLOPKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 10:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243715AbhLOPKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 10:10:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01053C06173E
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 07:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09BA0B81FBF
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 15:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A2C5FC3460B;
        Wed, 15 Dec 2021 15:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639581012;
        bh=tSCAeyIrXTpz+grbHFbsXe8xgF5majHtNJFXxNLxsnE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=T4tkmh6NnAGFSe+InbL91pTJKZTHzJeWyB6utQrkwnVPldCj3pBfn83VOM1niDcyV
         3E6sjd/TTY8pKzeFaLnkQe0Ej4cSWteQvzjGMshjeDw6ZXj+UbQfIhhgI01Ohh++i2
         +sZYwg/op66QHbwVIrq5Z94iyeG/FY9tnrThdJG3i65VvsS73jOvP0gg+BPF5P2WOQ
         nUe26uEqdTB19hEaURQr7iwJfEHMwhiiqHye7/EFbqctqS2kC07Oqt16RiIlUO96G1
         4Recc3Artn0yjC8UraUlOjN0Cvd6UeIQZ7TdcUsnuQ1/NMAWtDHXXFgGu+ZEnE+jF+
         3SVp0/ydAykzQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 91FE960984;
        Wed, 15 Dec 2021 15:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: add net device refcount tracker to struct
 packet_type
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163958101259.23013.16387515835183954852.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Dec 2021 15:10:12 +0000
References: <20211214150933.242895-1-eric.dumazet@gmail.com>
In-Reply-To: <20211214150933.242895-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, jmaloy@redhat.com, ying.xue@windriver.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 14 Dec 2021 07:09:33 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Most notable changes are in af_packet, tipc ones are trivial.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Jon Maloy <jmaloy@redhat.com>
> Cc: Ying Xue <ying.xue@windriver.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: add net device refcount tracker to struct packet_type
    https://git.kernel.org/netdev/net-next/c/f1d9268e0618

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


