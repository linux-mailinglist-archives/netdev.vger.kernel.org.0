Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B419E6888A8
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 22:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbjBBVAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 16:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjBBVAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 16:00:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C0181B3F;
        Thu,  2 Feb 2023 13:00:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E599EB8286C;
        Thu,  2 Feb 2023 21:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 80966C4339B;
        Thu,  2 Feb 2023 21:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675371618;
        bh=GKyRb/OSr7qk+73H0dw82Jo80xmQ59n36CiaFi8Yko4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RkZRIZqw7+QnrWQkR5RztulQAcFRdPmCVZAi8Mx3mY7q8QMFOyOym1RSgIP3Q1QwY
         RRZeEZ8018XqxTnUR2Y7evyVEOcpu50eNIQCEQW/6Fc3TMQPYMaQJpXKfAygZa6lGf
         +ivjVSTKJjcjjeGTjeh+a+8qlpqm7/271y++e1P0USS+UWkNejumgNQQ2eZDDrmCaN
         4cOFTNXImIfFAqp8AjcyKM0ZQ6AabaWMViIKPKNgdAkIa08BATALIPbx7LBWw0BKNb
         5mvPDpSLWhJwyWmd8OIq4YlvInkS/P720omv3KbVgcKFH1SV5wL9IqwE02HJv1M4oj
         1D+x7ldz10nQg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5E69FE50D67;
        Thu,  2 Feb 2023 21:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 net 0/3] fixes for mtk_eth_soc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167537161838.31793.11989786394773759034.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 21:00:18 +0000
References: <20230201182331.943411-1-bjorn@mork.no>
In-Reply-To: <20230201182331.943411-1-bjorn@mork.no>
To:     =?utf-8?b?QmrDuHJuIE1vcmsgPGJqb3JuQG1vcmsubm8+?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        lorenzo@kernel.org, linux@armlinux.org.uk, daniel@makrotopia.org,
        lynxis@fe80.eu, simon.horman@corigine.com, pabeni@redhat.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        matthias.bgg@gmail.com, opensource@vdorst.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  1 Feb 2023 19:23:28 +0100 you wrote:
> Changes since v4:
>  - use same field order for kernel-doc and code in patch 1
>  - cc'ing full maintainer list from get_maintainer.pl
> 
> Changes since v3:
>  - fill hole in struct mtk_pcs with new interface field
>  - improved patch 2 commit message
>  - added fixes tags
>  - updated review tags
> 
> [...]

Here is the summary with links:
  - [v5,net,1/3] net: mediatek: sgmii: ensure the SGMII PHY is powered down on configuration
    https://git.kernel.org/netdev/net/c/7ff82416de82
  - [v5,net,2/3] net: mediatek: sgmii: fix duplex configuration
    https://git.kernel.org/netdev/net/c/9d32637122de
  - [v5,net,3/3] mtk_sgmii: enable PCS polling to allow SFP work
    https://git.kernel.org/netdev/net/c/3337a6e04ddf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


