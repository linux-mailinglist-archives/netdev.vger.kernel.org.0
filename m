Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4593656B8F2
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 13:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238082AbiGHLuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 07:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237691AbiGHLuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 07:50:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3299E951E0
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 04:50:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBBED6256A
        for <netdev@vger.kernel.org>; Fri,  8 Jul 2022 11:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2E1CDC341CF;
        Fri,  8 Jul 2022 11:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657281016;
        bh=5xodls2JrDA34rA6fYi4QulUKbfS7GKOm16e27ob6gQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZBt8i0s5RbpetGSjjn+Nc2+b+fHbOwo2ZphF8DNYljIt9XFUUzf+dNEg84NzR8om+
         PrsFOwCo1FMRnSAW3WntPpRrQPCYsFUhod3QYcNbJAnLJxAn9sEGzxp+siQpf3GEBn
         JDbfwlnDhtyrRht6cEtDyFpMIqffd264R8VYXCSCK4VMfM/772TE9YshEFc9Wzz7d7
         ZP93RFAO/2C/IkMLpfN1mCKiYxTrL62LtEjjS006+dU6CjOD/BtSPqyhi9Jd/7wtsQ
         vTeuTbrqZW6Hic+69SPGVomJJVohsLs2909Wpdnag5zxO+YORWYwBDRjdDzaO0t7bU
         GDsWoYwE/d9tA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 194C5E45BE0;
        Fri,  8 Jul 2022 11:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/2] eth: mtk: switch to netif_napi_add_tx()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165728101610.21070.6913233478168687633.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Jul 2022 11:50:16 +0000
References: <20220707030020.1382722-1-kuba@kernel.org>
In-Reply-To: <20220707030020.1382722-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        matthias.bgg@gmail.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  6 Jul 2022 20:00:19 -0700 you wrote:
> netif_napi_add_tx() does not require the weight argument.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: nbd@nbd.name
> CC: john@phrozen.org
> CC: sean.wang@mediatek.com
> CC: Mark-MC.Lee@mediatek.com
> CC: matthias.bgg@gmail.com
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] eth: mtk: switch to netif_napi_add_tx()
    https://git.kernel.org/netdev/net-next/c/c0f50574223c
  - [net-next,2/2] eth: sp7021: switch to netif_napi_add_tx()
    https://git.kernel.org/netdev/net-next/c/9157533a0a8b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


