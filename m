Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC2C449CFDE
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 17:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243200AbiAZQkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 11:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236669AbiAZQkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 11:40:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66538C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 08:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B323B81F1B
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 16:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DDBEEC340EB;
        Wed, 26 Jan 2022 16:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643215210;
        bh=YtBx1T83sc+l07LSfrFFU352azgiXYAUerKgFXxIIkw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h+t/4SsWl1KN0rFp6VyH35UzTMrIDqMkVNIY7ho2+56AfegYGvMa8q+0Dk3q17E9e
         YBXm8Ad0knaNFsOfX/yLS8fiWUzYVlZ/nVBjCYzhhX/b0lL8wNxb1apFdelue9xssk
         0UPuXMZPbMVhKbD5UzsKXImW76AaJoYWn2PxoAEk8jYI/P+EPbZY2PicfOpO09iwy6
         sQbpykQPSwq3At9iEMjeysJa0sVUCLkAFese8kwW7NeGOhmIB3kyt1G6RCFgpXHBMg
         oEDbf7OpkNhreB+lbjrOyJEhsD6amm2Gx1QJvfGGd/t+Y60GXS4yeC0Kup0lktxqqi
         9KsmhAA+kdyHw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C0E69E5D089;
        Wed, 26 Jan 2022 16:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dpaa2-mac: use .mac_select_pcs() interface
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164321521078.5014.510636948073080368.git-patchwork-notify@kernel.org>
Date:   Wed, 26 Jan 2022 16:40:10 +0000
References: <E1nCOfK-005LEI-To@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1nCOfK-005LEI-To@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     ioana.ciornei@nxp.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 25 Jan 2022 16:27:30 +0000 you wrote:
> Convert dpaa2-mac to use the mac_select_pcs() interface rather than
> using phylink_set_pcs(). The intention here is to unify the approach
> for PCS and eventually to remove phylink_set_pcs().
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] net: dpaa2-mac: use .mac_select_pcs() interface
    https://git.kernel.org/netdev/net-next/c/c592286a527f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


