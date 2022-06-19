Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AFBE5509D9
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 12:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235403AbiFSKuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 06:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235217AbiFSKuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 06:50:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711D8101F9;
        Sun, 19 Jun 2022 03:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A191B80BA0;
        Sun, 19 Jun 2022 10:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9B0A4C341C6;
        Sun, 19 Jun 2022 10:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655635812;
        bh=aLRNj3k6T82Etzn9dQKbVxAQNEitVOAfgJ0/zD56CTA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SXelyQ6V4O0g81/O6+4RIhqVPvCy3+VRUaGAJ5Uc/k9D9s7ezoREaoAVegx6UQ6Mr
         oLADw4zG/1m3XzSnXg0Wvcro361y+51cudpXBJ7y052quMj6mkSuZ4UBBo6Hv/x0rl
         eccmwrK/MvWPaHGcrcGwPoAoGGYyRXz/zIzUqWnMmTvvptUzFLhvbKLInptWcxQaxk
         y232Vb2zZcAPtEl2d3weRT/hK04LW72g/r61dKREgnjD+Glzu1Yciq+64mQsdFiJqd
         LQM4Z0CMZKD8Y3YRZTz+LazDaV4jiNcDrqFKjGKQN8BhME1wsxlFcFyedwFE4Vdmw5
         jc55oQmLC84tg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7D5B4E7BB29;
        Sun, 19 Jun 2022 10:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: emac: Fix typo in a comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165563581251.13134.6006431361723553079.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Jun 2022 10:50:12 +0000
References: <20220618131626.13811-1-wangxiang@cdjrlc.com>
In-Reply-To: <20220618131626.13811-1-wangxiang@cdjrlc.com>
To:     Xiang wangx <wangxiang@cdjrlc.com>
Cc:     timur@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Sat, 18 Jun 2022 21:16:26 +0800 you wrote:
> Delete the redundant word 'and'.
> 
> Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
> ---
>  drivers/net/ethernet/qualcomm/emac/emac-mac.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: emac: Fix typo in a comment
    https://git.kernel.org/netdev/net-next/c/a278bfb24298

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


