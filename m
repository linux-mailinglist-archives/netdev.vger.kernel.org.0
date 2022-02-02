Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C20214A6AC0
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 05:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244250AbiBBEKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 23:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232069AbiBBEKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 23:10:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC06BC061714
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 20:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A2F1B82FF1
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 04:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A98DC340F1;
        Wed,  2 Feb 2022 04:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643775010;
        bh=p1GBd0VYfoG3Sec5HgbSj1s93lqI4WHns8bG2SZY6Yw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f1yzvstg5jZW/ehNGsqRuSdqjGIo3h+KfWpxNW1Oom9X+tPl194TRnjDzaf9zCSNH
         lvh8v6yHpxb+KLn95NbG5sZR2W0qM3eYyHYDoDM17wj6qCzfY47m/BzASKAQlrPEiB
         4ZB8a2mCgzcqGflEE8sY+gWW9tzV1Vpc9bsdLTJPtCHLeqoCYQO5pHexjGPK1l5BUr
         qi1mJoZYDZEjSWjsIs3BR3hlTlLFAxP55BjhnOgSd0FJ3yNsmBjSjh47bsEGjrU9p+
         SE65z6hsUX3MG3teuaOrpHmX3Yf1daibcrgpXsYH/BI3+Mi8Cpn9qkr3ONsdP6rOeG
         FdE5yfcxZhQeQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 28226E5D07E;
        Wed,  2 Feb 2022 04:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: allow SO_MARK with CAP_NET_RAW via cmsg
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164377501015.4092.796119772755179776.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Feb 2022 04:10:10 +0000
References: <20220131233357.52964-1-kuba@kernel.org>
In-Reply-To: <20220131233357.52964-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, dsahern@gmail.com,
        edumazet@google.com, maze@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 31 Jan 2022 15:33:57 -0800 you wrote:
> There's not reason SO_MARK would be allowed via setsockopt()
> and not via cmsg, let's keep the two consistent. See
> commit 079925cce1d0 ("net: allow SO_MARK with CAP_NET_RAW")
> for justification why NET_RAW -> SO_MARK is safe.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> --
> CC: maze@google.com
> 
> [...]

Here is the summary with links:
  - [net-next] net: allow SO_MARK with CAP_NET_RAW via cmsg
    https://git.kernel.org/netdev/net-next/c/91f0d8a4813a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


