Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67254479AC2
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 13:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231898AbhLRMkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 07:40:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34048 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231875AbhLRMkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 07:40:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ECBA660B72;
        Sat, 18 Dec 2021 12:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4872EC36AE8;
        Sat, 18 Dec 2021 12:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639831210;
        bh=FFGB3RVCB4aGnm21eSkJPuLKnXWaHQmdFoXWAE6bFbY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MbCre2X9znaR5kVnA1IqQx5PI1if92J3Cs5WBC6MPztINXd/dUPHSp5iYZckgMGTC
         0RkzsNpBw5os7Y/NoKZ1C4H7s3PyiGiPeXmlDFFPdkCQSQ20NrxvNLT0BaTpwFtaSk
         68FHDrNrHiTW2qp7BxnhrrULXAHwAS5MDcmAhwH2LZCKg3vjIcRK4aV8Y5kyGEzPNF
         XhAYN6rDuWeSlzh+fdrnyma8YgKntbvF1zTfS3kvhq5makB3/WWPm1g3YUHRcb0LEP
         onFgLBW+OP9vTTdEQCriufLgNPbWsFqKvQwScoZp28Hh/rxkyxpLYNG4LiQ+71qrzl
         6Hhcfe8xTYTUg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2CEE660A3A;
        Sat, 18 Dec 2021 12:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v0] ax25: NPD bug when detaching AX25 device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163983121017.1461.2630742040562872080.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Dec 2021 12:40:10 +0000
References: <20211217022941.27901-1-linma@zju.edu.cn>
In-Reply-To: <20211217022941.27901-1-linma@zju.edu.cn>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, jreuter@yaina.de, ralf@linux-mips.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        nagi@zju.edu.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Dec 2021 10:29:41 +0800 you wrote:
> The existing cleanup routine implementation is not well synchronized
> with the syscall routine. When a device is detaching, below race could
> occur.
> 
> static int ax25_sendmsg(...) {
>   ...
>   lock_sock()
>   ax25 = sk_to_ax25(sk);
>   if (ax25->ax25_dev == NULL) // CHECK
>   ...
>   ax25_queue_xmit(skb, ax25->ax25_dev->dev); // USE
>   ...
> }
> 
> [...]

Here is the summary with links:
  - [v0] ax25: NPD bug when detaching AX25 device
    https://git.kernel.org/netdev/net/c/1ade48d0c27d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


