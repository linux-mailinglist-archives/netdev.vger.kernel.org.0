Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 171C162F442
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 13:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241693AbiKRMKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 07:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241682AbiKRMKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 07:10:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF85B8FF93
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 04:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68555B8239C
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 12:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 14643C4314E;
        Fri, 18 Nov 2022 12:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668773417;
        bh=ffhr2UMiheiVLHGmk19PDRoUR5q4OCGE38mOSBGEEck=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N1LWXLXoMbjTrDad4vCDqnjqxaxSyVQccSUJxPzg0T+/Ai8iD3n1g7aep0OuB6sAW
         LFgYOtzjx3r9P96xnpFiorRWcv6P92/X+81h674TzsP2XyHhOPGSb2uJrNK99m/9o2
         91/OUmp26JjucfGat4PeL+Vl02cVnwhPZFqDZ8rG6zlRD3yMCqyBPs2O5zZ8YlONaF
         KhWDIBNoESOb5H+1IlnRwdSckM9jVZxct7wMgkHXXaE9EJchmn2IXxVSl6VWimS/a3
         2gHFJ9xaMw6y5IdnNui/fZZealQEDUP4PpbP1ESjZxPdJeQYHuhJxV5aRtK8tLeN8U
         pVwNrm8YEFW5g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E977BE524E6;
        Fri, 18 Nov 2022 12:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: mtk_eth_soc: remove cpu_relax in
 mtk_pending_work
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166877341694.19277.3005550205165939088.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 12:10:16 +0000
References: <8374a9cdebb9d8056aaa41f218279d373cb69165.1668643071.git.lorenzo@kernel.org>
In-Reply-To: <8374a9cdebb9d8056aaa41f218279d373cb69165.1668643071.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 17 Nov 2022 00:58:46 +0100 you wrote:
> Get rid of cpu_relax in mtk_pending_work routine since MTK_RESETTING is
> set only in mtk_pending_work() and it runs holding rtnl lock
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Here is the summary with links:
  - [net-next] net: ethernet: mtk_eth_soc: remove cpu_relax in mtk_pending_work
    https://git.kernel.org/netdev/net-next/c/ec8cd134eeee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


