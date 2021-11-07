Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D2044754C
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 20:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233992AbhKGTmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 14:42:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:42558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233561AbhKGTmv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Nov 2021 14:42:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0786761251;
        Sun,  7 Nov 2021 19:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636314008;
        bh=CRn2Esz9M4d12OzFcXU8PUBs0EVDZGQ+rs6/8FrxwfI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JVnhvd8y4iohgwmR8Gf77g0rq+6CmNefBJ2QjsLlae88hCc1vDAbHt4G3GNZF6Om8
         3LK495xchZbEN30tVsOEG4IXGPEiuphlkDg00XogVJY1cXiKWLOBJubtPJt0gnyrd8
         SccgYNSz4u2eyNLu53A0DR2beSiJt4DevKDxCaqWFHF5VQjqQ/DuVV5OJde1ao6/sI
         QflH6AdpELUKo1PIfHAY7cE+pVJ8sIK/XSNFcb4mI3tj1pbmKRoN+zosGQ63nHtqOr
         2GeNbCE7qKxZ+V+Qoi55C+EayOE6j7B4l89orzET+5uIEZO9jKijwRtpK5p7wlZXM9
         1hiMwVKr/5CrA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EB39B60AA3;
        Sun,  7 Nov 2021 19:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] nfc: pn533: Fix double free when
 pn533_fill_fragment_skbs() fails
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163631400795.18215.415300214484837799.git-patchwork-notify@kernel.org>
Date:   Sun, 07 Nov 2021 19:40:07 +0000
References: <20211105133636.31282-1-cyeaa@connect.ust.hk>
In-Reply-To: <20211105133636.31282-1-cyeaa@connect.ust.hk>
To:     Chengfeng Ye <cyeaa@connect.ust.hk>
Cc:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        kuba@kernel.org, wengjianfeng@yulong.com, dan.carpenter@oracle.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  5 Nov 2021 06:36:36 -0700 you wrote:
> skb is already freed by dev_kfree_skb in pn533_fill_fragment_skbs,
> but follow error handler branch when pn533_fill_fragment_skbs()
> fails, skb is freed again, results in double free issue. Fix this
> by not free skb in error path of pn533_fill_fragment_skbs.
> 
> Signed-off-by: Chengfeng Ye <cyeaa@connect.ust.hk>
> 
> [...]

Here is the summary with links:
  - [v2] nfc: pn533: Fix double free when pn533_fill_fragment_skbs() fails
    https://git.kernel.org/netdev/net/c/9fec40f85065

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


