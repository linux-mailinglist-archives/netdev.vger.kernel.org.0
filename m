Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC66631E99
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 11:40:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiKUKkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 05:40:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiKUKkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 05:40:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B018919C31;
        Mon, 21 Nov 2022 02:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C60FB80E3E;
        Mon, 21 Nov 2022 10:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF7B6C433D7;
        Mon, 21 Nov 2022 10:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669027216;
        bh=lBiqzDRkZEo/yngzgO1ZDReCb0oZVmB/vSipjkPE9sU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=maeEusjEU3xdx6q1KVqJlC84er/pDJJmoXev4lrhLgu5kkNaq+20HeflAPftLM6v7
         GlBlH5S0DbE8CZaAESCW2UPed+ZBuwZdS/gg4lYoTSa6zTG1TS+WC4aCsqogfBKCTa
         W85XkL8Aa8j9WUBmp3wGL3pFG+KGvJijs/zJ0NveSdUiK8+4w4fsDvnIMH/FiCLK83
         zmfKh09i9IG6TE/XZ9nFCnTMI8rI1PkNB4iAwm+fye5/2NCo5xZmHOVOQybKWEJLKK
         3uwObUMl6e2s5wqs9pZtTFUaC42xRz+Wy5N4dko0i0DE7OKVCREB++vZJCGSWGxp7j
         P/T/pkNzhd3oQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CA236E29F3F;
        Mon, 21 Nov 2022 10:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 net-next 0/3] net: axienet: Use a DT property to configure
 frequency of the MDIO bus
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166902721582.6572.2868204459150625114.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Nov 2022 10:40:15 +0000
References: <20221117154014.1418834-1-andy.chiu@sifive.com>
In-Reply-To: <20221117154014.1418834-1-andy.chiu@sifive.com>
To:     Andy Chiu <andy.chiu@sifive.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, kuba@kernel.org,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, robh+dt@kernel.org,
        pabeni@redhat.com, edumazet@google.com, greentime.hu@sifive.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 17 Nov 2022 23:40:11 +0800 you wrote:
> Some FPGA platforms have to set frequency of the MDIO bus lower than 2.5
> MHz. Thus, we use a DT property, which is "clock-frequency", to work
> with it at boot time. The default 2.5 MHz would be set if the property
> is not pressent. Also, factor out mdio enable/disable functions due to
> the api change since 253761a0e61b7.
> 
> Changelog:
> 
> [...]

Here is the summary with links:
  - [v5,net-next,1/3] net: axienet: Unexport and remove unused mdio functions
    https://git.kernel.org/netdev/net-next/c/29f8eefba3ba
  - [v5,net-next,2/3] dt-bindings: describe the support of "clock-frequency" in mdio
    https://git.kernel.org/netdev/net-next/c/6830604ec0c7
  - [v5,net-next,3/3] net: axienet: set mdio clock according to bus-frequency
    https://git.kernel.org/netdev/net-next/c/2e1f2c1066c1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


