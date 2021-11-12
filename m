Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1D144DF3F
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 01:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbhKLAoB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 19:44:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:59376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231965AbhKLAoA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 19:44:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id AE76361260;
        Fri, 12 Nov 2021 00:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636677670;
        bh=qc0RLnESA3nFtjBnn0Qt5J8mmMt6Ufa2sTbacnDgLZQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uuQoihRGGxhilFOmYBJWixZFrumlMMs4dCVpgftV/kICN2P9w4dsNqP5B3OYs5QM4
         d644I+Wop2GZGI1ydFIrjsGHVBy/MY/dcBx+qXW3DhVmSLs96JCQjmWDdTH9LJ/PxS
         jyGKC57Hba9vWsEzVp44uT4C5tBnv3Kf0etlliMlWwfl03PjhccREUIU7xo8u5ZX6W
         HpGexm1kYMX+NesNQeGUvSy2WXySKJ/HQDvxUiI0+8gndfHBc+KnC90iAL7v6NNROp
         Ok0/EM0ulM7g0ktI9hMVK9AyMwlcHn1M1MK1xmOJuNMMIa5I3/x1fkouFczkVyiPBX
         s2PXsk73biQtA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9E54B60074;
        Fri, 12 Nov 2021 00:41:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH linux-next] ipv6: Remove assignment to 'newinet'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163667767064.21646.9365544142891525487.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Nov 2021 00:41:10 +0000
References: <20211111092346.159994-1-luo.penghao@zte.com.cn>
In-Reply-To: <20211111092346.159994-1-luo.penghao@zte.com.cn>
To:     luo penghao <cgel.zte@gmail.com>
Cc:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo.penghao@zte.com.cn,
        zealci@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 11 Nov 2021 09:23:46 +0000 you wrote:
> From: luo penghao <luo.penghao@zte.com.cn>
> 
> The same statement will overwrite it afterwards. meanwhile, the
> assignment is in the if statement, the variable will not be used
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - [linux-next] ipv6: Remove assignment to 'newinet'
    https://git.kernel.org/netdev/net-next/c/70bf363d7adb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


