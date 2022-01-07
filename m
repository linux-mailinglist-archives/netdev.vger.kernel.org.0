Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C321B4878C9
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 15:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347672AbiAGOUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 09:20:13 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34032 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347640AbiAGOUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 09:20:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC217B82633;
        Fri,  7 Jan 2022 14:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6F298C36AE0;
        Fri,  7 Jan 2022 14:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641565210;
        bh=8ArphtMs5lHlkG3KGagptlon8x0XX0zifyrk+uhpTVI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GoFSHisj/ZHjeUEdZ6l+HgWeaayeO7lOVRbmRqTi+t14HkH+jp7DFX+RVX0k0shGv
         Xfm9+rWbuQWdHD8GyhXG2V/bkZCRDuF3aDR4aO/mpkdVehpiwHSuUuNL3VYEnGgvJ4
         n9mHraUyMIvfaqWGRZo1c3Sa00OutwRka40PtZUaj/hGvXseDtYq2Vs6tUDb06+X2K
         x5LnJ3TM+OlrYTQ3LbNBNtVf4w8zW/jhhXPDE3/IIdv7/bTSAHdbuSoRLXERaswpjz
         C36LF3utcjSORC55O7CpwBYARi8i4NKwNJwVnoKOSrEPmmM9N/ASjhePmbolYVkqtS
         RtN4MRM7jX0rg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4F7CBF7940A;
        Fri,  7 Jan 2022 14:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ax25: uninitialized variable in ax25_setsockopt()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164156521031.21832.2063678868639107574.git-patchwork-notify@kernel.org>
Date:   Fri, 07 Jan 2022 14:20:10 +0000
References: <20220107071312.GB22086@kili>
In-Reply-To: <20220107071312.GB22086@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     jreuter@yaina.de, hch@lst.de, ralf@linux-mips.org,
        stefan@datenfreihafen.org, matthieu.baerts@tessares.net,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 7 Jan 2022 10:13:12 +0300 you wrote:
> The "opt" variable is unsigned long but we only copy 4 bytes from
> the user so the lower 4 bytes are uninitialized.
> 
> I have changed the integer overflow checks from ULONG to UINT as well.
> This is a slight API change but I don't expect it to break anything.
> 
> Fixes: a7b75c5a8c41 ("net: pass a sockptr_t into ->setsockopt")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> [...]

Here is the summary with links:
  - [net] ax25: uninitialized variable in ax25_setsockopt()
    https://git.kernel.org/netdev/net/c/9371937092d5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


