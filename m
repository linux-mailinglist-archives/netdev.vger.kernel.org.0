Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E925544A80
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 13:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244291AbiFILlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 07:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243953AbiFILkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 07:40:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842071E2888;
        Thu,  9 Jun 2022 04:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0A666B82D3B;
        Thu,  9 Jun 2022 11:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8449AC385A5;
        Thu,  9 Jun 2022 11:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654774812;
        bh=+dbHoNN5ilLTw3ZAKZTv0yssemHwdX0ISjTNs2oxV3I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YVKNn39ul7zcsK8uMOoUCKa4YtWYE0MzBizVv1Ibc7TBA13z+ZH5dt3pcZd5k2aNO
         8fC24cmH5oRT3m/G1DLnevXNEHQ1RXiMeale/9XVNW5qSZdE1fd6QjLbL3TNvYrYHU
         HZ+fJx9ezzfMLZlkDzFxgrHCWKYo1YsL7kq9uH8ww34wH0PzSgEKL/5iSX1jXJhokY
         wDF+amLxGyW7KOwsGlwmyomc1sRjf3tYYpVuTNJOEtW9m3lCworpYNSY+uokOv3R8c
         rCJV2xjNLFmKld4/rW50shQkcnT0OhjYYClShDt2ZGBgix3q756LEsy6p5UAAEt6Ur
         wZRBQZKW7q71A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 684BEE737EE;
        Thu,  9 Jun 2022 11:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND][PATCH net-next] net: macb: change return type for
 gem_ptp_set_one_step_sync()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165477481242.25118.14247813922782865952.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Jun 2022 11:40:12 +0000
References: <20220608080818.1495044-1-claudiu.beznea@microchip.com>
In-Reply-To: <20220608080818.1495044-1-claudiu.beznea@microchip.com>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 8 Jun 2022 11:08:18 +0300 you wrote:
> gem_ptp_set_one_step_sync() always returns zero thus change its return
> type to void.
> 
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
> ---
>  drivers/net/ethernet/cadence/macb_ptp.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)

Here is the summary with links:
  - [RESEND,net-next] net: macb: change return type for gem_ptp_set_one_step_sync()
    https://git.kernel.org/netdev/net-next/c/263efe85a4b6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


