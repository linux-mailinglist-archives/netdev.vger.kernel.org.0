Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E5950DEB0
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 13:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240961AbiDYLXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 07:23:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240634AbiDYLXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 07:23:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3712F10FE5;
        Mon, 25 Apr 2022 04:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAA05B815E0;
        Mon, 25 Apr 2022 11:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 993EFC385B0;
        Mon, 25 Apr 2022 11:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650885611;
        bh=IWnp5D3ggL4CK4fq3CnzOL/qFZ1Ao6c6jqN5taxJZhw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mPiNP8CEfBdezop6wxvtesDp+rbqX7KylNTLS9pTuVRvHdpmwoJMXVM/s/waXAxiV
         bVmphxxqdDtN4rzUatbISTVd+TT/NU7V984g5T4oj1x8N81eGHCS0z41Ml3VGmzZYT
         FHoPL5vLnFKcbfw08AiJA6JuR7HriyBet5ne1SdAY28PPvscCg4/G/Ipnm5ycywSz5
         KB/pjR+EvgrI9lARx4WKM4e64LMfpviUhElTCzvQPRV/dY6mQBCSv2ULkFUCKctU6C
         4VH5kAcSW3zLJAAKtLfBLl9aztOL3F92XnZvcUKGia8RyoZTDspogIRUonY77lVrGY
         2k7OVVV901m4A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 81F6BEAC09C;
        Mon, 25 Apr 2022 11:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next: PATCH] net: dsa: remove unused headers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165088561152.26271.12190054127991995532.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Apr 2022 11:20:11 +0000
References: <20220425101102.2811727-1-mw@semihalf.com>
In-Reply-To: <20220425101102.2811727-1-mw@semihalf.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        upstream@semihalf.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 25 Apr 2022 12:11:02 +0200 you wrote:
> Reduce a number of included headers to a necessary minimum.
> 
> Signed-off-by: Marcin Wojtas <mw@semihalf.com>
> ---
>  net/dsa/dsa.c | 9 ---------
>  1 file changed, 9 deletions(-)

Here is the summary with links:
  - [net-next:] net: dsa: remove unused headers
    https://git.kernel.org/netdev/net-next/c/df1cc21152ff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


