Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B13049FBA9
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 15:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349161AbiA1OaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 09:30:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236715AbiA1OaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 09:30:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9AEEC061714
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 06:30:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 518AB61DF2
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 14:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B90D9C340ED;
        Fri, 28 Jan 2022 14:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643380210;
        bh=U+6/FpnkUCJk6wZD5KoKEpwj8rR0O2qiLG2pmWOBorY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PGXLpjlq/8cie1ADUTYEnnkXUdV7pZKMEIBD07Q/D2yVrSx9qa6CrUkUtZWZVhRMu
         ELQUpof8b0uM1wM15zZxIXynsGd3RKtInFPAm3n10vLtNdsbRhqvTZxiKR4ZE7MDII
         0u4PDQt9MnXyiLcntALWeYu/bgdS1Mh8+tNH/n9nl5WQU0dGfhAu65OXguwgkhavO0
         fGfzYApOdK0iPSWHx67q+IWKqTlMYvRWV8DQ6jTWt6W97GREPzJW5p3mdKUwM94A91
         YgFijmCYTWgMLVfc5u+0FBo3IxjPLz+eSIZcP01m4DtMRW+0xa1SLveREkJNb/IAyW
         zL6eor7dbEDtQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A6EFEF60799;
        Fri, 28 Jan 2022 14:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sparx5: use .mac_select_pcs() interface
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164338021067.15816.10336079646445394338.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Jan 2022 14:30:10 +0000
References: <E1nD2QW-005UHW-QK@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1nD2QW-005UHW-QK@rmk-PC.armlinux.org.uk>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     lars.povlsen@microchip.com, Steen.Hegelund@microchip.com,
        davem@davemloft.net, kuba@kernel.org, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 27 Jan 2022 10:54:52 +0000 you wrote:
> Convert sparx5 to use the mac_select_interface rather than using
> phylink_set_pcs(). The intention here is to unify the approach for
> PCS and eventually remove phylink_set_pcs().
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> ---
>  drivers/net/ethernet/microchip/sparx5/sparx5_main.c    |  1 -
>  drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c | 10 ++++++++++
>  2 files changed, 10 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: sparx5: use .mac_select_pcs() interface
    https://git.kernel.org/netdev/net-next/c/9c8c44022b0d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


