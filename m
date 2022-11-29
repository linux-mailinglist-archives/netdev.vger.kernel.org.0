Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40CB563B7BC
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 03:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235202AbiK2CU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 21:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235102AbiK2CUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 21:20:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3733729CB3
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 18:20:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D90CEB81107
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 02:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 168DAC4314C;
        Tue, 29 Nov 2022 02:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669688417;
        bh=Lim0F4j8LeA5VO8AAhoYKE1njaSRkoaZlXQ4ouiElCI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A2GKQ96u+AdoijU2lPgrFABNghPaO/BSf9bCp53RSQBSlF+BoWhry4dv2F19nT6c+
         rsau7BLb2w7SjFGtimA2SlsB2qAK46SK/fZyZ6jhphcmVP+OoSMACkshV8a58xl+Ck
         ZbLcih+ycLoCgJYklR5+E432Rw/YUncGdqNemgCqZFjM6YWp+R0V5dE45hjHlNOQqD
         LHV3AbjdqnGO1FFsuG5TjNdS0oAvkOfscqMt1S+kkzbRTkOLVChBntZyl9yI2hTp8g
         27xaJVztqPt8hIOQxh0UQH7lraIOGcZpHkSm8lCafGlNZv2vIx+pe7I/NYbp2iQ5UG
         qoLWYKP7FEXOw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DA58BE29F3B;
        Tue, 29 Nov 2022 02:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: mdiobus: fix unbalanced node reference count
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166968841689.21086.2802647159020696048.git-patchwork-notify@kernel.org>
Date:   Tue, 29 Nov 2022 02:20:16 +0000
References: <20221124150130.609420-1-yangyingliang@huawei.com>
In-Reply-To: <20221124150130.609420-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ioana.ciornei@nxp.com,
        calvin.johnson@oss.nxp.com, grant.likely@arm.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 24 Nov 2022 23:01:30 +0800 you wrote:
> I got the following report while doing device(mscc-miim) load test
> with CONFIG_OF_UNITTEST and CONFIG_OF_DYNAMIC enabled:
> 
>   OF: ERROR: memory leak, expected refcount 1 instead of 2,
>   of_node_get()/of_node_put() unbalanced - destroy cset entry:
>   attach overlay node /spi/soc@0/mdio@7107009c/ethernet-phy@0
> 
> [...]

Here is the summary with links:
  - [net] net: mdiobus: fix unbalanced node reference count
    https://git.kernel.org/netdev/net/c/cdde1560118f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


