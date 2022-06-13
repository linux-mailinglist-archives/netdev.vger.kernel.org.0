Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A15F5493BB
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 18:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243503AbiFMPY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 11:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387207AbiFMPY0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 11:24:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD384137C69;
        Mon, 13 Jun 2022 05:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D3BB614C9;
        Mon, 13 Jun 2022 12:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD92EC3411B;
        Mon, 13 Jun 2022 12:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655124612;
        bh=JoRQPCKpZ50r7Vm43APNqBWNBVopKKU31DzC8GydWrk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hM2fscbMgqqJ5nxnuSFmGYI1YaXxKlUxZEAbrytYNfjeImUZXt2uAO4CoHN91pfM4
         NWxXhwzrnkfDb1Fqu9DfRNPLfqiuoCyFCyZ25g0uF6lAOz8HZoSEZe+9yOOB8U1F9R
         Vz4T3Ygk/ncCyhD+3mpu9cFCGOGK5NZFUP/X0AJsO1AHBjF2mMzPf29mkbt/bltFr8
         CcDXBO6hd5ta66Syvq8Yzf9Qjip7qn6EF+sQ604PKlmR7wtxZehO51iTZn0sJJCT44
         RMfPxnqFQzOvtsEmpckl7ma1G1RbqW5J10GdYpYiJcA7KD0+YcxeAU+y3nl3ojweNM
         wCiD+hZzthIKQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B2A05E57538;
        Mon, 13 Jun 2022 12:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net PATCH] octeontx2-vf: Add support for adaptive interrupt
 coalescing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165512461272.14727.15986698743424790428.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Jun 2022 12:50:12 +0000
References: <20220612174536.2403843-1-sumang@marvell.com>
In-Reply-To: <20220612174536.2403843-1-sumang@marvell.com>
To:     Suman Ghosh <sumang@marvell.com>
Cc:     sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 12 Jun 2022 23:15:36 +0530 you wrote:
> Fixes: 6e144b47f560 (octeontx2-pf: Add support for adaptive interrupt coalescing)
> Added support for VF interfaces as well.
> 
> Signed-off-by: Suman Ghosh <sumang@marvell.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net] octeontx2-vf: Add support for adaptive interrupt coalescing
    https://git.kernel.org/netdev/net/c/619c010a6539

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


