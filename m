Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84225AD3E6
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 15:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237808AbiIENaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 09:30:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237758AbiIENaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 09:30:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 784C615A1A
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 06:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 361E1B8117E
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 13:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD16CC43142;
        Mon,  5 Sep 2022 13:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662384614;
        bh=w4ORGJfUzvNwMMhuYaFvg0ldvpZh45EzEQ4uDKxGkgo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X5fivTbB01x00ICF2gnUBfwYqYnjkoTEIvGqPlfklawxHPBWgLLw+623Flz+4r31R
         HKtSGTSV7VkUjww+GzBuG5mx9hvp1U63vNiEaXuiLbdV/IXZkr4WOS60ANcHz2KsSM
         c8kCOoiZrDn/9rCpOQBF9uD7pPeVTW8FJn+23/gokcBzd2uYwrxfwxM9I71XEqDK9O
         aEkHDC6LRWcfteIZDfFkvdrG7uG/oGB73EwIEBTUMsKoD52HDLp2QnoBYa7ksaSMxx
         RruGnwB0Uix03E1unsOClhrci7lA8ziKS0l5lSedYOwK8gnGnVMkYVeq3v8G7XIps0
         rguQe1LZY/eDA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B9425C73FE0;
        Mon,  5 Sep 2022 13:30:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: remove useless PCI region size check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166238461475.27659.12227776495607345989.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Sep 2022 13:30:14 +0000
References: <5739775a-a5d7-cd72-469c-d1ded3347a77@gmail.com>
In-Reply-To: <5739775a-a5d7-cd72-469c-d1ded3347a77@gmail.com>
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

On Fri, 2 Sep 2022 23:16:52 +0200 you wrote:
> Let's trust the hardware here and remove this useless check.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 6 ------
>  1 file changed, 6 deletions(-)

Here is the summary with links:
  - [net-next] r8169: remove useless PCI region size check
    https://git.kernel.org/netdev/net-next/c/36f9b47457f0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


