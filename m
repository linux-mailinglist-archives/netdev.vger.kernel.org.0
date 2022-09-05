Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967D15AD1D1
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 13:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238289AbiIELuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 07:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236224AbiIELuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 07:50:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E38043E55
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 04:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13F82B8110B
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 11:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3134C433D7;
        Mon,  5 Sep 2022 11:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662378614;
        bh=CjNlkPkRsP6T7tkEnR+OBWCvw8SYUqHw3OBG0pxUAJk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XjvuRLPPevUqh8LwB/8TjacyyS37FaON06g+Y252yNHbcUN7qjejOmezJSC7MFmYU
         ML0oLt34vy/tLa1z3xRBTPk+pc4eEO7LuqH/0KiwxJhlxH5YsgZB6/fKpUVwqzmfOF
         nrsNLubkBUgASDwXt2oyDC5nfPsAUCtso+ZhfhQRpzsBP51zk6q8SlrDErvcgAvLJQ
         QW7fnDAkUhJ4humpX+xF4gz759VvA7AAojCEua26eZxPb2JqvthcgTs77UM7dDWOdo
         qErX16YdsIx1qEEIJvldfLjvIkqr2hB3SaiMVS9Ohl7KOZrVkuTHZqbAgR9SrpsyZg
         vIa038+MJoHFw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 99810C73FE8;
        Mon,  5 Sep 2022 11:50:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: use devm_clk_get_optional_enabled() to
 simplify the code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166237861462.7756.1906697667780605736.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Sep 2022 11:50:14 +0000
References: <68bd1e34-4251-4306-cc7d-e5ccc578acd9@gmail.com>
In-Reply-To: <68bd1e34-4251-4306-cc7d-e5ccc578acd9@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 2 Sep 2022 22:52:34 +0200 you wrote:
> Now that we have devm_clk_get_optional_enabled(), we don't have to
> open-code it.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 37 ++---------------------
>  1 file changed, 3 insertions(+), 34 deletions(-)

Here is the summary with links:
  - [net-next] r8169: use devm_clk_get_optional_enabled() to simplify the code
    https://git.kernel.org/netdev/net-next/c/599566c1c369

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


