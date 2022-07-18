Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB12577FE6
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 12:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbiGRKkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 06:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234347AbiGRKkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 06:40:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E61D1EAFE;
        Mon, 18 Jul 2022 03:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72E876114B;
        Mon, 18 Jul 2022 10:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5890C341CE;
        Mon, 18 Jul 2022 10:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658140816;
        bh=mg9fTSUCfuCU/fSiQ8U5MqukI9xExX8O7SjUL+dpdyA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Un4235bVj2OICXEH7ESR3S54ttq40982gQLv+BqXxsQ3231O5Z96TnHiat1j5Hbz6
         gwmk37et1xOspsedZkwYbzFH2gDPwJ+lACsRUSXdRkbX+YKXroldpc0V+WOmaUSC8/
         LI/qsBYQEIpGCboicgX46L+z6nonPcSTdE87o9ryhL0Osy3kbV+mUBJeVkdwOu/E4n
         s9h8dTw8nUtRRGGyojU8cDacXsdsKCUCKztesYJP7A4iHC4HXvBUvmNG27g28wd9qx
         z3Xrn3/Y+jeHrb99JsnKiKVB9yPX5Xwq8rKxFSAk5tohl1UXOgGveRsPZI2kDmsSjT
         ba7SgjlfW5sxw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AA454E451B3;
        Mon, 18 Jul 2022 10:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] atl1c: use netif_napi_add_tx() for Tx NAPI
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165814081669.19605.5277892923414855203.git-patchwork-notify@kernel.org>
Date:   Mon, 18 Jul 2022 10:40:16 +0000
References: <20220715075043.912-1-liew.s.piaw@gmail.com>
In-Reply-To: <20220715075043.912-1-liew.s.piaw@gmail.com>
To:     Sieng-Piaw Liew <liew.s.piaw@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 15 Jul 2022 15:50:43 +0800 you wrote:
> Use netif_napi_add_tx() for NAPI in Tx direction instead of the regular
> netif_napi_add() function.
> 
> Signed-off-by: Sieng-Piaw Liew <liew.s.piaw@gmail.com>
> ---
>  drivers/net/ethernet/atheros/atl1c/atl1c_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next,v2] atl1c: use netif_napi_add_tx() for Tx NAPI
    https://git.kernel.org/netdev/net-next/c/6e693a104207

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


