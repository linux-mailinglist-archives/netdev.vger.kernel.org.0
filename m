Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9712168EAAC
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 10:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjBHJLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 04:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjBHJL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 04:11:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30B946D6E;
        Wed,  8 Feb 2023 01:10:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58066B81C87;
        Wed,  8 Feb 2023 09:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8189C4339E;
        Wed,  8 Feb 2023 09:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675847418;
        bh=mKwEQs3d8N9Hm762gYytf6a4lLL3QA+GmVUHPzSV9qU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nb6zrV++HT6PG2GKBzbE8QqCR1HTXfJQYgc+ye801aV0fRBp9eJQx5nkcXlvYw3RN
         4M2cuQeAzQbloMoJc7msrhIA0g20NENe2CK67TQT9Lkq/eXwAWkTid8i8BVEhnAVPN
         DcQSa5eUpoaoiIomK0pvyo3RmXrIpojH7e8IXiOlrSnC68B4UtXlE2GOmyqoJlGsOs
         j38vzLv9v9LQeihm61U9NmYQ379SahsfdMjictDydeD03cMLFBtdn1TVtCwEaGtjUI
         PcnH0yKJdOOVtG2UdhtMlv9+5N3igL1q9hMkxswENaHfqWli9W0WBLmJ8pD74GRloP
         TE+TPAMLKkHoQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C8173E21ECB;
        Wed,  8 Feb 2023 09:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: enable special tag when any
 MAC uses DSA
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167584741781.9727.9581653304808207719.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Feb 2023 09:10:17 +0000
References: <20230205175331.511332-1-arinc.unal@arinc9.com>
In-Reply-To: <20230205175331.511332-1-arinc.unal@arinc9.com>
To:     Willem-Jan de Hoog <arinc9.unal@gmail.com>
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, lorenzo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com,
        arinc.unal@arinc9.com, richard@routerhints.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, erkin.bozoglu@xeront.com
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
by David S. Miller <davem@davemloft.net>:

On Sun,  5 Feb 2023 20:53:31 +0300 you wrote:
> From: Arınç ÜNAL <arinc.unal@arinc9.com>
> 
> The special tag is only enabled when the first MAC uses DSA. However, it
> must be enabled when any MAC uses DSA. Change the check accordingly.
> 
> This fixes hardware DSA untagging not working on the second MAC of the
> MT7621 and MT7623 SoCs, and likely other SoCs too. Therefore, remove the
> check that disables hardware DSA untagging for the second MAC of the MT7621
> and MT7623 SoCs.
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: mtk_eth_soc: enable special tag when any MAC uses DSA
    https://git.kernel.org/netdev/net/c/21386e692613

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


