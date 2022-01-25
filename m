Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC70949AA3F
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 05:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1325069AbiAYDfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 22:35:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3415395AbiAYBp7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 20:45:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AA2C01D7CC;
        Mon, 24 Jan 2022 17:27:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B38A6121F;
        Tue, 25 Jan 2022 01:27:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 89270C340E7;
        Tue, 25 Jan 2022 01:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643074019;
        bh=KoCXqwAtOQUl137F9WCCAF0wUAWh3QeKgh1PfwR5B/k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s1hHQt29AeVfFEOeDOvGAfOnfaZX2i+pj3wZpl6Bw1ZXw7xccJzQY+HURuCWRtbOa
         b+AoEYwrImEeu51qx4BqwiOznE0rL7qClzqUry5D/aOQQ41WN+l18p2Lb/8qbbeUp6
         64+NkhX6aOO+7HOCVyRUWun3EOIz6VA61gDmRebTwl9sTORQtSpztR14QXOgb7a0jA
         FXU0tJHM+mskAjnJmBLyltGDH5eldCBNEjggjtAQLr9iq325eBzwaMY6Cf/O4fCYih
         KHH7mXY/nfLmoaZBqxdNp0liG5T/wFN8B8meRKfE6eXC6lPycB8vE0TvATdg2Tf+qL
         i4UwRCDLHDoew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 694A7E5D087;
        Tue, 25 Jan 2022 01:26:59 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: usb: asix: remove redundant assignment to variable reg
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164307401942.21160.7465294917447555080.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Jan 2022 01:26:59 +0000
References: <20220123184035.112785-1-colin.i.king@gmail.com>
In-Reply-To: <20220123184035.112785-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux@rempel-privat.de,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun, 23 Jan 2022 18:40:35 +0000 you wrote:
> Variable reg is being masked however the variable is never read
> after this. The assignment is redundant and can be removed.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  drivers/net/usb/asix_devices.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - net: usb: asix: remove redundant assignment to variable reg
    https://git.kernel.org/netdev/net-next/c/9f16e0fa1079

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


