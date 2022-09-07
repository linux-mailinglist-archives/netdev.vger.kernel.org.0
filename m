Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069015B07C5
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 17:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbiIGPAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 11:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiIGPAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 11:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC7EC9A98C
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 08:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73330B81D98
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 15:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2775AC43140;
        Wed,  7 Sep 2022 15:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662562816;
        bh=R+OzuMU4jQ7Us9uToXClvGaNk03wy3tvRbJr386DNxA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YNloUyzoHaYTonq6z89AaxoYtU84Ud5uypXCMYBqv62SIye2/9d4wwAaz8HMIGlZ3
         8J+U1XYXFsRU3KaLhNSvt6Y4kqthVDKdh7VjIBYo09PIeGW8UUvqVHDDz46UJ2IpF3
         SF8Oal0TpVrR94qdz7WiD/Be4EVui2OfEUm5cqeQxsJn+casuxcpAICR5HmlFf2TID
         ucMQGTklJy+o/+sWQz/HfLHFnDq9mpJHRbHvPOmktazEQHDJ/yWEykY8fY1zRqISpw
         prJkNaqfxmm/XekEw6dRDDLnV7mRWITRfOthQGQSQDJloArS0noDzKTlmgPsw9Yk3S
         rFRLj3LQFtSmQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 08054E1CABE;
        Wed,  7 Sep 2022 15:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: check max allowed hash in
 mtk_ppe_check_skb
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166256281600.26447.686694241748240905.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Sep 2022 15:00:16 +0000
References: <b9f18ec4dd40d53b401a1b9935999bf025f3357d.1662381450.git.lorenzo@kernel.org>
In-Reply-To: <b9f18ec4dd40d53b401a1b9935999bf025f3357d.1662381450.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com
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

On Mon,  5 Sep 2022 14:41:28 +0200 you wrote:
> Even if max hash configured in hw in mtk_ppe_hash_entry is
> MTK_PPE_ENTRIES - 1, check theoretical OOB accesses in
> mtk_ppe_check_skb routine
> 
> Fixes: c4f033d9e03e9 ("net: ethernet: mtk_eth_soc: rework hardware flow table management")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: mtk_eth_soc: check max allowed hash in mtk_ppe_check_skb
    https://git.kernel.org/netdev/net/c/f27b405ef433

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


