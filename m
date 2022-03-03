Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4BE04CC058
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 15:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbiCCOu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 09:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231432AbiCCOu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 09:50:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C00C4FC42;
        Thu,  3 Mar 2022 06:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31529B82600;
        Thu,  3 Mar 2022 14:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6BAEC004E1;
        Thu,  3 Mar 2022 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646319010;
        bh=M+Xlgcob4w5XnkVe4GbpEAx14evwYSmptbB04R43aMI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KawGHsPph71zbalUsK2m8Us87vom6GrWU+XBukaJe60dQrpi1oBSqRU8aoPCNnDMx
         3e80LbrCqOiOI+/nU3iz1Fo0+8NyAkNcneUhUOLo9mRs7HrkDv2aq1bsgzRKCKNA26
         ZA2cNSaC755gxGx+D1aYLsaer/P0vrs+E2rDR6ieKKkB3+mPsYv8uqmkTDZhmmfY72
         28IewOtIIAXdieMwImAPvS/TM5DQoroO6N/jhW5ffCzx+mfB3LFdzVtJa8ieun2njS
         P+6ytOiT/dkQpe+E0dQGHtyuQTw96to0rhtSjWb3kwNJe0HQMWBVXqyaBVcEhOMSYt
         nvas+Tp5h49kA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C1FC5EAC096;
        Thu,  3 Mar 2022 14:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bnx2: Fix an error message
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164631900979.29171.14311877408050693466.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 14:50:09 +0000
References: <a6cf1111d372dd0a682f4ba929f9e8e2538260a6.1646252465.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <a6cf1111d372dd0a682f4ba929f9e8e2538260a6.1646252465.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     rmody@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  2 Mar 2022 21:21:15 +0100 you wrote:
> Fix an error message and report the correct failing function.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/broadcom/bnx2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - bnx2: Fix an error message
    https://git.kernel.org/netdev/net/c/8ccffe9ac323

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


