Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7BE46E0A3
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 03:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbhLICDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 21:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbhLICDo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 21:03:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D33C061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 18:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FA3BB82375
        for <netdev@vger.kernel.org>; Thu,  9 Dec 2021 02:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4D222C341C6;
        Thu,  9 Dec 2021 02:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639015209;
        bh=FJifAsTfwO8VUet2pg1PrYr95aM5d+v3GFUuHLB7fIg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DfQn0eHiaULFgyHHAzYU1YsiuyUskDGlXri/raXsvzo0QFXE3UowTewQwzM1OAg/5
         9cdTJyv+/Fx1vWhFoItGTuE2Jwj006fx9FSBsMLjMvU9H/Lg1EC7495Fp3owe4nafT
         hV1E41ko0Ao3U6hE+ILm72XNY/Q9d1lmJcmciEyp/A6mHp+sKgxbfeCMitjOq9zaqK
         Mt53JtW2iTOEp2Z+XBDDzl/XxNChuDPWlDs57pfxhb17ksQzsUGrHR/hoLJQlHfqnN
         0VmFTsRm14zpL4nWR6RDo5+shXHcVZrJjeTOys//zfSNoR40JAmH9WFHod+pjijUfk
         ejeUrU/HdfXtw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2C16E60A36;
        Thu,  9 Dec 2021 02:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net, neigh: clear whole pneigh_entry at alloc time
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163901520917.18433.4839560060498321567.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 02:00:09 +0000
References: <20211206165329.1049835-1-eric.dumazet@gmail.com>
In-Reply-To: <20211206165329.1049835-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, roopa@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  6 Dec 2021 08:53:29 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Commit 2c611ad97a82 ("net, neigh: Extend neigh->flags to 32 bit
> to allow for extensions") enables a new KMSAM warning [1]
> 
> I think the bug is actually older, because the following intruction
> only occurred if ndm->ndm_flags had NTF_PROXY set.
> 
> [...]

Here is the summary with links:
  - [net] net, neigh: clear whole pneigh_entry at alloc time
    https://git.kernel.org/netdev/net/c/e195e9b5dee6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


