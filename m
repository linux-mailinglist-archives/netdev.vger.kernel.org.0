Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60D8C64A91E
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 22:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbiLLVBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 16:01:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232871AbiLLVBO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 16:01:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56ACD19C1B;
        Mon, 12 Dec 2022 13:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A7E2FCE0FDD;
        Mon, 12 Dec 2022 21:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E024BC433A7;
        Mon, 12 Dec 2022 21:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670878817;
        bh=O06dcxALdaiAZ7GkSYnUnuuDVtVajIiDb8qy4vzQcvI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Jxaup04GFy5M7KlneezoseB5J0Bho48YhvvfbZDFfN5phN+IWeGF89rmafA4zQtsJ
         IOaX9fYjXgLM6+zH8KrtgkspxIOHEgsjuTlsg/fTDmgixcEB4E1aHBofPhIwMd2zRe
         6woJuPcOY2Au3gxU3xn767ORRusz/GSUGZTBIw1csoCr57CwA6ySiNGiIMfU3IJxub
         dJULcmFXBwpRTD4E6nSbdYv32IQ4+UFDZ15UB9oq/xyZEk6Z2qk8871ClltMBR5pg8
         0RcQbKXTPCvbpQQ52vEX8l19OkSAwkn7cgCc4oZLPnV9RPH0V6wiWMji8E0AZhT477
         PgEuswoA5Qhgg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CA90FE21EF1;
        Mon, 12 Dec 2022 21:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: ti: am65-cpsw: Fix PM runtime leakage
 in am65_cpsw_nuss_ndo_slave_open()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167087881682.21711.2011176766794694783.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 21:00:16 +0000
References: <20221208105534.63709-1-rogerq@kernel.org>
In-Reply-To: <20221208105534.63709-1-rogerq@kernel.org>
To:     Roger Quadros <rogerq@kernel.org>
Cc:     davem@davemloft.net, maciej.fijalkowski@intel.com, kuba@kernel.org,
        andrew@lunn.ch, edumazet@google.com, pabeni@redhat.com,
        vigneshr@ti.com, s-vadapalli@ti.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  8 Dec 2022 12:55:34 +0200 you wrote:
> Ensure pm_runtime_put() is issued in error path.
> 
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Roger Quadros <rogerq@kernel.org>
> ---
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [net-next] net: ethernet: ti: am65-cpsw: Fix PM runtime leakage in am65_cpsw_nuss_ndo_slave_open()
    https://git.kernel.org/netdev/net-next/c/5821504f5073

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


