Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B05A46CCD5
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 06:10:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhLHFNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 00:13:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230316AbhLHFNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 00:13:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69F60C061574;
        Tue,  7 Dec 2021 21:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17DBFB81F77;
        Wed,  8 Dec 2021 05:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BC600C00446;
        Wed,  8 Dec 2021 05:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638940208;
        bh=xST+sHP1UDvvtYZEnXeAwVG5Pu5fxpKjXr0ifZOX9qM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h/tnU65s0BdafBVI9+vquWn3RquNsTDSEsys9Vt/J0V5gP1spnhqcpz/QLjEWP0/o
         tPpHm2R6r/R4cL8TaSPzWh4seK2ZRUMoSa0c5SZNtI3H2LsQHT9a66NlyMC1W1XAIZ
         aF9Scc4d/tMUaQEow6yCMDJ+BbHmcjGr5D+ojVOl7zG9pLZJ4gszvR8G1LBVm3rXov
         ID3bV7upzOJfy9dPyRIT1YR/Jy2kNZwY5eNdzhdDHkH/403+Ys+JLGdBicmdA1Y3EV
         lBTlhmTGA0SWEejQH71jQQ9GxqoF3ttsn2tamLRwsxgyOdhsXymTiIU0XoRIbPER23
         NTRmettfusnGg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 997AF60A53;
        Wed,  8 Dec 2021 05:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] gve: fix for null pointer dereference.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163894020862.28255.17651952704191745484.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Dec 2021 05:10:08 +0000
References: <20211205183810.8299-1-amhamza.mgc@gmail.com>
In-Reply-To: <20211205183810.8299-1-amhamza.mgc@gmail.com>
To:     Ameer Hamza <amhamza.mgc@gmail.com>
Cc:     jeroendb@google.com, csully@google.com, awogbemila@google.com,
        davem@davemloft.net, kuba@kernel.org, bcf@google.com,
        willemb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  5 Dec 2021 23:38:10 +0500 you wrote:
> Avoid passing NULL skb to __skb_put() function call if
> napi_alloc_skb() returns NULL.
> 
> Addresses-Coverity: 1494144 (Dereference NULL return value)
> 
> Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
> 
> [...]

Here is the summary with links:
  - [v2] gve: fix for null pointer dereference.
    https://git.kernel.org/netdev/net/c/e6f60c51f043

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


