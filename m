Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 882C14C6B43
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 12:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236022AbiB1Lux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 06:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231491AbiB1Luv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 06:50:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E2359A5D
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 03:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B505061117
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 11:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 201EDC340F7;
        Mon, 28 Feb 2022 11:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646049011;
        bh=+gVoPcP6i3c5ZE8slA+EtSLggl6nK55QxdVyOx2jRj4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QJEzkfUdYOYoyJIRM6ujQP9HkPeYsXHRVCxNYNciaV8oHjlUh0j7PPub3+nVAM/cg
         GJvW4mYNsB1pw72WlRURHECl11wSbjXRx5jSTqEMZ/sc2DY0CUAy4EnBzSKCtH83/Q
         TQbMlJncE6a/Spfi+/GEzXGqTSAcMXHuQnGZ2GWq6BKnwIEGvc82SeeU96rvm2sQDE
         04fF2I0+PIT10BB6KjCWkAh5SyCjp5wDACD7buAvBNnr4XH+pte8tXC98gP/3iKV8x
         WRj7JZE3+U+5ZBs+BobfOwwfUBIP+tTr0oS4A+0SuaQCda3jXfcyOPZm2BL2BA7kMs
         lunyRgYixUSBg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0996CEAC09E;
        Mon, 28 Feb 2022 11:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: netsec: enable pp skb recycling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164604901103.16787.17923152440634436952.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Feb 2022 11:50:11 +0000
References: <89abfd9e920d9ee4bc396a6bf94ad4c61d4ef3af.1645802768.git.lorenzo@kernel.org>
In-Reply-To: <89abfd9e920d9ee4bc396a6bf94ad4c61d4ef3af.1645802768.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ilias.apalodimas@linaro.org, lorenzo.bianconi@redhat.com
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 25 Feb 2022 16:29:51 +0100 you wrote:
> Similar to mvneta or mvpp2, enable page_pool skb recycling for netsec
> dirver.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/socionext/netsec.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: netsec: enable pp skb recycling
    https://git.kernel.org/netdev/net-next/c/6a4696c4284f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


