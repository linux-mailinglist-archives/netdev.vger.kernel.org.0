Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9FC5AD470
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 16:01:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238254AbiIEOAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 10:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238069AbiIEOAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 10:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019FDFD35
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 07:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A10B612F2
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 14:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF2F6C43140;
        Mon,  5 Sep 2022 14:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662386414;
        bh=GLJjizPDGNQVZXgiVKg2GAS8i2xYExllXfO1rnwuDEA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iIi04nmQBVm9bvC0of3Db2Peadc5OaeiuowDTpWSvWgvvhxlnTHKTN1FLxJEz9C9N
         zPft2gVGA02Gog8Wz+PpkduDj0uvXwakqwEtSlMOelSXfkaIj1OTPRUGN2wSuZhxHU
         oRt4FlI/JWZ69mvfqwC68WC8Af4HjlPcSzBWew2TCHWn/EX0ECIvWyXSsZbAQhjcDd
         htF7mtpnZ5NeVIUX21Q65TmVnybeOXXS7PXVo3WijGmcA2CpKprcE1/jb3pLcS7Caj
         jXL/U3SN+1ovaftJJdBa9++H46pH/zDbtrSaeJxPkbXAvx+d/g+VjmK5FtHjE6KDUu
         9iboYBtBO4aTQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A750AC73FE9;
        Mon,  5 Sep 2022 14:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: remove not needed net_ratelimit() check
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166238641467.11602.6883696349994767716.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Sep 2022 14:00:14 +0000
References: <1b1349bd-bb99-de1b-8323-2685d20f0c10@gmail.com>
In-Reply-To: <1b1349bd-bb99-de1b-8323-2685d20f0c10@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org
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

On Sat, 3 Sep 2022 13:15:13 +0200 you wrote:
> We're not in a hot path and don't want to miss this message,
> therefore remove the net_ratelimit() check.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] r8169: remove not needed net_ratelimit() check
    https://git.kernel.org/netdev/net-next/c/96efd6d01461

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


