Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30A9A4BE9E0
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358601AbiBUNKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 08:10:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238073AbiBUNKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 08:10:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D0B1EAFB;
        Mon, 21 Feb 2022 05:10:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC7B261356;
        Mon, 21 Feb 2022 13:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4FA5AC340EC;
        Mon, 21 Feb 2022 13:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645449009;
        bh=GCXcCZ2E1oBP1y1VQ5p6xbUiZRAGSfaKlA/fTTfKNng=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cY7R2iNcow5F2Q/DegO7C0KHsefPgQbVJnX6qzjJslAMBLzMV09C070FmSWDTALn0
         hqZXkU+PY0JcKBGg4NUFJsN4dYNJfUwQ2UiS3gymEh27l65iXVlzJep9Q8r/b96mJK
         wP5mQGpvPDaI0PHNFxgLoZSAdaZ8xl5AadZ5V5grWDnQDb6mYwC50w/LRw01M8AcIf
         5VhFo7HAOpeH9KR99G90H7yd7/WejPs8GV4VS3twkz4dwGUSGwGqztf5aTOspZrHSj
         SAEpDwudYd3JWSdUmz1xGqOiY/l9uPCfe7i+RcyUdNqgBxZ2RDhJEyEuLgVuN83iBd
         HA8UzvzzcOehw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3A59EE6D452;
        Mon, 21 Feb 2022 13:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mdio-ipq4019: add delay after clock enable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164544900923.23760.523704837972847805.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Feb 2022 13:10:09 +0000
References: <01c6b6afb00c02a48fa99542c5b4c6a2c69092b0.1645443957.git.baruch@tkos.co.il>
In-Reply-To: <01c6b6afb00c02a48fa99542c5b4c6a2c69092b0.1645443957.git.baruch@tkos.co.il>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        baruch.siach@siklu.com, robert.marko@sartura.hr,
        luoj@codeaurora.org, bryan.odonoghue@linaro.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 21 Feb 2022 13:45:57 +0200 you wrote:
> From: Baruch Siach <baruch.siach@siklu.com>
> 
> Experimentation shows that PHY detect might fail when the code attempts
> MDIO bus read immediately after clock enable. Add delay to stabilize the
> clock before bus access.
> 
> PHY detect failure started to show after commit 7590fc6f80ac ("net:
> mdio: Demote probed message to debug print") that removed coincidental
> delay between clock enable and bus access.
> 
> [...]

Here is the summary with links:
  - net: mdio-ipq4019: add delay after clock enable
    https://git.kernel.org/netdev/net/c/b6ad6261d277

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


