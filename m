Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75B694D606A
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 12:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348140AbiCKLLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 06:11:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245126AbiCKLLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 06:11:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81A4B18F20A;
        Fri, 11 Mar 2022 03:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33D91B82B40;
        Fri, 11 Mar 2022 11:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A63F1C340F5;
        Fri, 11 Mar 2022 11:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646997014;
        bh=Pao5hleAqEMhXTiRfC7ac3xNAZDX/iQDsGlHjeeL9nE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=llQB6Wrl5gX1gA4sJ0RctHXOuazkGSDPdzYVfJicQk1kUcfDupoj2MSIzn00EQZen
         B3Zt4KDMEkWgVJ+pDuXfEvCgJPoJGjs0kuH1QsbjPZH34/1E9UOYbPZ1ewxnab85a1
         5HHCKerZLtIuHHkD3VvuOIj87CtujFeuDk2H2N0diW5wEzxhuYQ5n2u751x7dA+lD3
         Zb0/EafQ9wjX6UVd0wMeIZlrSAbVqeuNnQ7LjEQyfsGOe8zGGPo/LuehuC/ll5APdf
         mWeb3zspiXvH/9YcpPvX+9NyUMRc5ji37mps/uImoJfiKTugOrmJceRJJ2PKgLs7Ru
         1n01oBJuhCy/A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 87F9BF03842;
        Fri, 11 Mar 2022 11:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2] net: mv643xx_eth: use platform_get_irq() instead of
 platform_get_resource()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164699701455.2968.17332998919617311135.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Mar 2022 11:10:14 +0000
References: <20220310062035.2084669-1-chi.minghao@zte.com.cn>
In-Reply-To: <20220310062035.2084669-1-chi.minghao@zte.com.cn>
To:     Lv Ruyi <cgel.zte@gmail.com>
Cc:     sebastian.hesselbarth@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, chi.minghao@zte.com.cn,
        zealci@zte.com.cn
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 10 Mar 2022 06:20:35 +0000 you wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> It is not recommened to use platform_get_resource(pdev, IORESOURCE_IRQ)
> for requesting IRQ's resources any more, as they can be not ready yet in
> case of DT-booting.
> 
> platform_get_irq() instead is a recommended way for getting IRQ even if
> it was not retrieved earlier.
> 
> [...]

Here is the summary with links:
  - [V2] net: mv643xx_eth: use platform_get_irq() instead of platform_get_resource()
    https://git.kernel.org/netdev/net-next/c/bf2b83425b59

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


