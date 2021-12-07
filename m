Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 195A346AF8F
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:10:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357109AbhLGBNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:13:42 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:51082 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243594AbhLGBNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:13:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 11687CE198E
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 01:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 37D07C341C6;
        Tue,  7 Dec 2021 01:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638839409;
        bh=/KOazIbs4zHyntxLnHPiYp4DjOm2EhVzUOCRw6qpyPg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kNRpNAqr4cSEzPV96SI7xT/PY2fQMA5qWMINL9GrsSPJ4NCBMntkspJd/vtHBYwB0
         nBh2jxoOl/SIObf7h0R1vw+O1B27CulxEULyLQJilBMLhF8+V2H44+jgk1o1WXNpmQ
         eN6kowoyowJp1PQUkWV6AYS9U6pM6wOikOJ0UWKD/ZzIGOBdPlauip9CccemXN81R8
         qXpcXyBK2FIA+2iiFfLtXYmcZ6Ak/2KT9BHA3v2+njxwUkSmIxS2qVvFph8JYgXRwN
         kyTqAPcpmSAY+Zmq0a2xesbE16xj53O1NAT9P+vd5HePgLvS15wqyuehSLCuDLnNS0
         EUkzIfHq4GTIw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 112F060A4D;
        Tue,  7 Dec 2021 01:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] devlink: fix netns refcount leak in
 devlink_nl_cmd_reload()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163883940906.24390.10425877788916765226.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Dec 2021 01:10:09 +0000
References: <20211205192822.1741045-1-eric.dumazet@gmail.com>
In-Reply-To: <20211205192822.1741045-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, moshe@mellanox.com, jacob.e.keller@intel.com,
        jiri@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  5 Dec 2021 11:28:22 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> While preparing my patch series adding netns refcount tracking,
> I spotted bugs in devlink_nl_cmd_reload()
> 
> Some error paths forgot to release a refcount on a netns.
> 
> [...]

Here is the summary with links:
  - [net] devlink: fix netns refcount leak in devlink_nl_cmd_reload()
    https://git.kernel.org/netdev/net/c/4dbb0dad8e63

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


