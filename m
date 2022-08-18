Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019B4597E03
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 07:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243514AbiHRFU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 01:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243266AbiHRFUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 01:20:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DB87E82E
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 22:20:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 71AE6CE1D98
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 05:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AD7A3C4347C;
        Thu, 18 Aug 2022 05:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660800017;
        bh=+pmM2m9DMl/C1daRqiT0Be24YlHAmpF9wtxIQnJ8N1w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RJMFjwbJgOOyL+cqtQo9NSEyu7o3Q1+HtXnTM4b4PEmBu8mgT2wcix4YN5OAQOx7C
         onmhzgERUoK8IhUmBxtAXC6eUOfEgelY+EBjka+AUarZqzEnVj0lZwobqDTOmt5gqO
         WWbzALawVG9aC0L5VdSl6Ka1yphCjpev4fSpvbOq/DyNKQ9NeDGPS21WMDPzVkDphs
         Tmnh5O9IZhUh5qOjSbbbsN+4bHa5Qs9hlu+a6eXbvCOtWXTcyAakF6Y0na8N4RvPRf
         itiqbMNr9N5WMm/KjO87LODOEOCfrJCLEmbVyn4Y9WYcb44p9AvQwpiK54cETH6WYA
         GkRVipDlp5FIA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8C056E2A057;
        Thu, 18 Aug 2022 05:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: fix possible NULL pointer
 dereference in mtk_xdp_run
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166080001757.8479.14902193480615265805.git-patchwork-notify@kernel.org>
Date:   Thu, 18 Aug 2022 05:20:17 +0000
References: <627a07d759020356b64473e09f0855960e02db28.1660659112.git.lorenzo@kernel.org>
In-Reply-To: <627a07d759020356b64473e09f0855960e02db28.1660659112.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, jbrouer@redhat.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 16 Aug 2022 16:16:15 +0200 you wrote:
> Fix possible NULL pointer dereference in mtk_xdp_run() if the
> ebpf program returns XDP_TX and xdp_convert_buff_to_frame routine fails
> returning NULL.
> 
> Fixes: 5886d26fd25bb ("net: ethernet: mtk_eth_soc: add xmit XDP support")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net] net: ethernet: mtk_eth_soc: fix possible NULL pointer dereference in mtk_xdp_run
    https://git.kernel.org/netdev/net/c/a617ccc01608

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


