Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 434314BE1F9
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357662AbiBUMNf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 07:13:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357551AbiBUMNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 07:13:08 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C121A2408A;
        Mon, 21 Feb 2022 04:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2E7F0CE0FC9;
        Mon, 21 Feb 2022 12:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 68C73C340EB;
        Mon, 21 Feb 2022 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645445410;
        bh=oqOXkVc5yNJhdWXMaD0+aKtSFP/ziOSljUYY0M9THmg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Qg8drU72Autm7s1kk0d1O2mJ9oms8oeKF99APQp7dTRFdNxluFzfFxSDPbCgXXKaf
         9hiWoE57ZAMwEGtP/kHLrI7sIDNJPVF0spEADmjNknG28qohogkPT6mGONKpHMFh7H
         Wb9YUzOJeN2JgWlbda2mWwIio28xJ0kXphnndjg+Ruj5hStRFdK6tAuqREiHJDwFIw
         BawnE9bh9G86bs/XKFqeX9P9ICo4kAmmJNelY5TFPywad2HojmSnXw2mEhGXErFUgD
         X3pLQl51KYavlVpQGN+k2zidZtY7SfMv1Y0x9Br2sALBaQjbsQym1dUFSXL34d6fAZ
         AbjwsA7H5VoBg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 51F13E6D3E8;
        Mon, 21 Feb 2022 12:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: qualcomm: rmnet: Use skb_put_zero() to simplify code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164544541033.27256.3041730108852805872.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Feb 2022 12:10:10 +0000
References: <8abfe32db956f335d65638dfafdd3577ab6baf0e.1645338968.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <8abfe32db956f335d65638dfafdd3577ab6baf0e.1645338968.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 20 Feb 2022 07:36:59 +0100 you wrote:
> Use skb_put_zero() instead of hand-writing it. This saves a few lines of
> code and is more readable.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Here is the summary with links:
  - net: qualcomm: rmnet: Use skb_put_zero() to simplify code
    https://git.kernel.org/netdev/net-next/c/354ad9a89399

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


