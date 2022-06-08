Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2187542638
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 08:56:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiFHGBf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 02:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349964AbiFHF7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 01:59:11 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5BA28B5F5
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 21:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ACCBBCE2610
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 04:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DCD15C3411F;
        Wed,  8 Jun 2022 04:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654663213;
        bh=o8KKfyujSJ6MuGuTHIV87gs02dgmDj/K8UfuWaCC3K8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XD8TGZZYawk+yUBZ2cEjlVFDkbwv5voagW3YKkYRQP4CaxreLTn7hOiq79S7nVpYP
         PlDG/Fjw/3QLzm23RJ//pAfvk36cY7lBHV79Nh0wnDrONAXKQ13vVRDktgi0gN4R4U
         JBaMG9m8od1OqJi90oCCqIf73d7ZqbNmxdSttchdjjQIbAsdWlpCt7M+Y2dsR+BYam
         Lm1VE5mQg1PVlHfIlm/rE3IZhxUheUL93b+f9Kru6IopINJNpORZFIRZ3O2pTwCIN6
         QBo3+9ZTB0cZ1m+jEAw9RRBSNfFu1NCjSHmNSTbz5oBlRqT5aMrtvaaH1WC2t2QAXp
         UN4g0eyz7Frqw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C380BE737F6;
        Wed,  8 Jun 2022 04:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: mtk_eth_soc: enable rx cksum offload
 for MTK_NETSYS_V2
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165466321279.2228.5866925498609293271.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Jun 2022 04:40:12 +0000
References: <c8699805c18f7fd38315fcb8da2787676d83a32c.1654544585.git.lorenzo@kernel.org>
In-Reply-To: <c8699805c18f7fd38315fcb8da2787676d83a32c.1654544585.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Sam.Shih@mediatek.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  6 Jun 2022 21:49:00 +0200 you wrote:
> Enable rx checksum offload for mt7986 chipset.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] net: ethernet: mtk_eth_soc: enable rx cksum offload for MTK_NETSYS_V2
    https://git.kernel.org/netdev/net-next/c/da6e113ff010

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


