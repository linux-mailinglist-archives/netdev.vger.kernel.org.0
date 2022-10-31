Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 625D4613463
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 12:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbiJaLUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 07:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbiJaLUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 07:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B98FDF21;
        Mon, 31 Oct 2022 04:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 299D3611C6;
        Mon, 31 Oct 2022 11:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C137C433B5;
        Mon, 31 Oct 2022 11:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667215218;
        bh=aM13XmhVQI5P/QcxYw1W730gNBdzToftccpzwuyWg7E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mW4VqkbthTk1gwp55i5oPSA+IDa5HaspeQpr+Y1iyFobu9868k8GaKVaEKne/4DSx
         9Cn4GQ+TFNOncoxj5OYatKlaYU16AciXHX91vhWgVSEroyk/9g+XeHNfogz+s0cOdu
         MSQHLlXVOqW7Zdd+LHvVyr3Zw9QCeoz8SDC1X6/X6rZN6q8b4IWTRruw1Ecr4OrPjZ
         0/Y5Fi82STzikBvEijPvxyqZSu2Z4nJpWCZKHxPz9xdrqBAkjglxTi4P3X/t5Kcg2x
         KcX56EdivNhA/PftsdRIhFQ38DmRk8tZzMK/9aZci5dmrRPf+CVldKt75FzmDx8g62
         BwDdDrxjJdDEQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 566EBE270D6;
        Mon, 31 Oct 2022 11:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v8.2] net: phy: Add driver for Motorcomm yt8521
 gigabit ethernet phy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166721521834.14218.17383155931568712245.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Oct 2022 11:20:18 +0000
References: <20221028092621.1061-1-Frank.Sae@motor-comm.com>
In-Reply-To: <20221028092621.1061-1-Frank.Sae@motor-comm.com>
To:     Frank <Frank.Sae@motor-comm.com>
Cc:     pgwipeout@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, yinghong.zhang@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 28 Oct 2022 17:26:21 +0800 you wrote:
> Add a driver for the motorcomm yt8521 gigabit ethernet phy. We have verified
>  the driver on StarFive VisionFive development board, which is developed by
>  Shanghai StarFive Technology Co., Ltd.. On the board, yt8521 gigabit ethernet
>  phy works in utp mode, RGMII interface, supports 1000M/100M/10M speeds, and
>  wol(magic package).
> 
> Signed-off-by: Frank <Frank.Sae@motor-comm.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v8.2] net: phy: Add driver for Motorcomm yt8521 gigabit ethernet phy
    https://git.kernel.org/netdev/net-next/c/70479a40954c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


