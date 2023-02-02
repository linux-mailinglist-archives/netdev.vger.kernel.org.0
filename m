Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB7E68879F
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 20:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbjBBTkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 14:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231905AbjBBTkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 14:40:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6054577510;
        Thu,  2 Feb 2023 11:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC62061CC7;
        Thu,  2 Feb 2023 19:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4BD07C4339E;
        Thu,  2 Feb 2023 19:40:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675366818;
        bh=RKhFRxkKw/oc1MHgIsGdTeY+HE5OfXv4GdCZPBtPHFc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CWjQW27d8ZOodn8t8hCYPfhIzr7DWRSeWLJSrYNvG/kc85m+oVH49B/BMG8qae5IB
         ryD8wDM/siHuB7f/pJYvfE8r2/2taraKp9E/iP688zTr4kqGBcWAVgOqa11I0OzpPG
         pFD3OxdYiiFEFXaNlWqsSDfCXZQPo5pds858biwK6wZ3HcmX4EY0vdgGO+EHrLZVj+
         +qZqps9sdeh2M/Js1vOlU5EXibMF6RbxbaCdOyZBY92fJQRXn+1yiBFE+kgDElvy1G
         Hm4yT4Bjuk3LET3gzHUtq1BcWLqxFDsVyDet2mK9a4hhfEIuElIrWu/Ur/9v1gp5zg
         a+i+tIswm1eRA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 304FEE5254B;
        Thu,  2 Feb 2023 19:40:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: disable hardware DSA
 untagging for second MAC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167536681817.25016.12221190782721540650.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Feb 2023 19:40:18 +0000
References: <20230128094232.2451947-1-arinc.unal@arinc9.com>
In-Reply-To: <20230128094232.2451947-1-arinc.unal@arinc9.com>
To:     None <arinc9.unal@gmail.com>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, lorenzo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        matthias.bgg@gmail.com, arinc.unal@arinc9.com,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        erkin.bozoglu@xeront.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 28 Jan 2023 12:42:32 +0300 you wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> According to my tests on MT7621AT and MT7623NI SoCs, hardware DSA untagging
> won't work on the second MAC. Therefore, disable this feature when the
> second MAC of the MT7621 and MT7623 SoCs is being used.
> 
> Fixes: 2d7605a72906 ("net: ethernet: mtk_eth_soc: enable hardware DSA untagging")
> Link: https://lore.kernel.org/netdev/6249fc14-b38a-c770-36b4-5af6d41c21d3@arinc9.com/
> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: mtk_eth_soc: disable hardware DSA untagging for second MAC
    https://git.kernel.org/netdev/net/c/a1f47752fd62

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


