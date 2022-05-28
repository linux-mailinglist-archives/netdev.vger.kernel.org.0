Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1AA3536CB6
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 13:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239984AbiE1LuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 07:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355852AbiE1LuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 07:50:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 775621EADD;
        Sat, 28 May 2022 04:50:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0BBD60DB6;
        Sat, 28 May 2022 11:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3ECDCC34118;
        Sat, 28 May 2022 11:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653738612;
        bh=h2oaBiriLz66b0BCJyrBwlxYNKmjHoYpVL3/wtre59E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=repAeERIKKJG4Q8BgzcClu1QKWV3JcmryjGW4VwlRgnEVqExZXCs8xpH8Q+QHHTSN
         qbRZWGI4xRb14beqlD4IDvJ7lvKgNHxjH8+YX7W+kmhM4/AFbR1L6TmWFIoKQ0YAyN
         AAz+Lv6SJJjgSqeL7mJsFlrsoBkBKrJRk2mZteoo77D9Fi1Mc4rOBqBaobLixWYWYT
         srz3jy60vtSziN1KbB623XdN9wXsyroNZNLm+KHrYEEkflNvrrgRvaIOKtAaQ2K5z7
         sK1XOyV6kbbaZxF4+4rWXPSkNPXT2TSCEbFCrB57APVLLCtxLpgqQyz3DGSvhiHcSt
         EoDyAZlV/OuxA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 285E2F0394B;
        Sat, 28 May 2022 11:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dpaa: Convert to SPDX identifiers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165373861216.5820.10733749071308142078.git-patchwork-notify@kernel.org>
Date:   Sat, 28 May 2022 11:50:12 +0000
References: <20220527203747.3335579-1-sean.anderson@seco.com>
In-Reply-To: <20220527203747.3335579-1-sean.anderson@seco.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        madalin.bucur@nxp.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 27 May 2022 16:37:47 -0400 you wrote:
> This converts these files to use SPDX idenfifiers instead of license
> text.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
>  .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 31 ++----------------
>  .../net/ethernet/freescale/dpaa/dpaa_eth.h    | 31 ++----------------
>  .../ethernet/freescale/dpaa/dpaa_eth_sysfs.c  | 32 ++-----------------
>  .../ethernet/freescale/dpaa/dpaa_eth_trace.h  | 32 ++-----------------
>  .../ethernet/freescale/dpaa/dpaa_ethtool.c    | 32 ++-----------------
>  5 files changed, 15 insertions(+), 143 deletions(-)

Here is the summary with links:
  - net: dpaa: Convert to SPDX identifiers
    https://git.kernel.org/netdev/net/c/d8064c10560d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


