Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38A447B8EA
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 04:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234351AbhLUDKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 22:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbhLUDKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 22:10:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF776C061747;
        Mon, 20 Dec 2021 19:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFE7AB8115B;
        Tue, 21 Dec 2021 03:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 00B5BC36AF1;
        Tue, 21 Dec 2021 03:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640056211;
        bh=ZGKw0GZQpsnXz6HncqgLbp2Cs9Lhro2rcTnLrO0pPgg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ls0IuA6m8NPxnRcsLkmFi1+4cC1AnbYuntN672UWqQmDZblT/t9WjLLltgBH3kkU4
         x6EFwYm8efxCo5xkLyKvvHoBQjO3U3rqOIWLCF/EK3G0DMP3k7yaQ3gxoukJQfpgyf
         x5gHgkcjVYP4UL5lwJK7YnJOPfxJQmYB2Vt12YmZ6rNse4oec0h0LY2boEFkaYvdaE
         XHi242prYQAwKIYYN7SMG8kRU+0e05NjqbFJ+HA+sK6sYP4g5ik1v5rVhrSlW84g6a
         qs02NwScVyrbQjIGVgfJhYzZSFzVNRU74FfCgCASPyLdeqn3KvY0vQDib1mO3eessF
         IRy8zFnu9KBBQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DF27B60074;
        Tue, 21 Dec 2021 03:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] igb: fix deadlock caused by taking RTNL in RPM resume
 path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164005621090.30905.3402677038991667985.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Dec 2021 03:10:10 +0000
References: <20211220201844.2714498-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211220201844.2714498-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hkallweit1@gmail.com,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        martin.stolpe@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 20 Dec 2021 12:18:44 -0800 you wrote:
> From: Heiner Kallweit <hkallweit1@gmail.com>
> 
> Recent net core changes caused an issue with few Intel drivers
> (reportedly igb), where taking RTNL in RPM resume path results in a
> deadlock. See [0] for a bug report. I don't think the core changes
> are wrong, but taking RTNL in RPM resume path isn't needed.
> The Intel drivers are the only ones doing this. See [1] for a
> discussion on the issue. Following patch changes the RPM resume path
> to not take RTNL.
> 
> [...]

Here is the summary with links:
  - [net,1/1] igb: fix deadlock caused by taking RTNL in RPM resume path
    https://git.kernel.org/netdev/net/c/ac8c58f5b535

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


