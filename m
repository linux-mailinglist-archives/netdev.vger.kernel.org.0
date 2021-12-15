Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3CFF475126
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 04:00:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239444AbhLODAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 22:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235420AbhLODAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 22:00:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA26C061574
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 19:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66074B81E23
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 03:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E9384C3460C;
        Wed, 15 Dec 2021 03:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639537211;
        bh=RMjiK5t6v4IaGl/7d8/NKFSnkHB06ivl+qfd16XbFqA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Zlw0A1qnaCWgQMEw9e4SD0gx2jQahVohghXCKtIxu0xTTTFysjpVnQ1lciTtmxL2g
         gjZpR7XBhbrrWD7uNHyzmKQ1cGIu6fu8FToVCx7Pfe2b+VaMGM9xcOWWNsbwD07S4G
         p7ks7V5UckBp0ck7PT0ncl1nYlkc/cxnpKE656NVXKnB9S550VrgSUuYvR1MeDYZau
         8CEq77QwbKn0SPsU8EM7U3rBQLEZk5DUfBybp/JiThPfmSgFFY3Kw024fwlVhZM+Pc
         eiocuWgeeqZRjAPlAGzzmVA6brEf+45p/Veko4mn4JfCsYiB1GVbBIhun8/a+Pg2IR
         8dFapoyjEdoDA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CF98F60A53;
        Wed, 15 Dec 2021 03:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dev_replace_track() cleanup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163953721084.25069.9483848866173462463.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Dec 2021 03:00:10 +0000
References: <20211214151515.312535-1-eric.dumazet@gmail.com>
In-Reply-To: <20211214151515.312535-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 14 Dec 2021 07:15:15 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Use existing helpers (netdev_tracker_free()
> and netdev_tracker_alloc()) to remove ifdefery.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: dev_replace_track() cleanup
    https://git.kernel.org/netdev/net-next/c/9280ac2e6f19

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


