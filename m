Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3EFE590602
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 19:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235880AbiHKRka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 13:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235662AbiHKRkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 13:40:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2035BC24;
        Thu, 11 Aug 2022 10:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE5A561745;
        Thu, 11 Aug 2022 17:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4FCADC43470;
        Thu, 11 Aug 2022 17:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660239614;
        bh=rARQNLKYFyAdqTCjtmqdIJOSM4W78mV48IVgZTjCUwo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iJeh4vJeWErGl/Jtyuae8qW5IfEhNQEcMee0irpqYXER9JWrtdD5kdwhn+EtM/XKV
         8/Ah2iDNU/0WQnY7sV/B96TLMz9F4CnJ5YLbY/DXbg9Yu1csCJ+H9RkdC+rYkjgzaD
         VkAqMOgxVIDO76TI8d42UNTw/0dnHlQvC0+55zyvuHbptEKi04vPr2M8SREZ7HQbbJ
         Ee7cNy4XXca2EOEhcr5v6TzmL0phxPXvdADYjlbiT5VHfYGWSjhuvu8v3s7tgzkD3K
         1fyHOu6hF5a9j4N9AUtplivhHj5wi7yyYUn4MolAQIiQo/SPF1U79/XOd4V+bML/Cq
         tRioWb5hfgDZQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3065AC43143;
        Thu, 11 Aug 2022 17:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] dpaa2-eth: trace the allocated address instead of page
 struct
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166023961419.31756.16594052173444905202.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Aug 2022 17:40:14 +0000
References: <20220811151651.3327-1-chen45464546@163.com>
In-Reply-To: <20220811151651.3327-1-chen45464546@163.com>
To:     Chen Lin <chen45464546@163.com>
Cc:     ioana.ciornei@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, yi.liu@nxp.com, chen.lin5@zte.com.cn
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 11 Aug 2022 23:16:51 +0800 you wrote:
> We should trace the allocated address instead of page struct.
> 
> Fixes: 27c874867c4 ("dpaa2-eth: Use a single page per Rx buffer")
> Signed-off-by: Chen Lin <chen.lin5@zte.com.cn>
> Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [v2] dpaa2-eth: trace the allocated address instead of page struct
    https://git.kernel.org/netdev/net/c/e34f49348f8b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


