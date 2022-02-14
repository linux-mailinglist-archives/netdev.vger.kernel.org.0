Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93AA24B521F
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 14:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343878AbiBNNuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 08:50:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344890AbiBNNuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 08:50:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1B449FB9
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 05:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 46E8060B80
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 13:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A132AC340F0;
        Mon, 14 Feb 2022 13:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644846610;
        bh=AYT9Q6WY6iwjWtuCHhL4FlCn8AO0xy2NkEuOpRyD5EY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JhLsYy8FdokToZ6gH5WfZOocqtMvq4ZAFPgnzZ4xw71ocx0AkXR0n76t4ejmewlOb
         oNaWYvigkB9WsJ1IegPbh9o7FfUGcWfbDjFu8mWZR0eJ8OKQbsmU682BCB0z79NcsH
         tpdpCdgxFUzuUpuMk1W7wlzKCBUIMW8vCIk8DBCuIZTMFiEOy+sSCndUoXohwFpjZf
         LHd1hVRfdk2n2HkRjkAeV9OLyqISIUiXnOj/cLorVCJ151aXNJYXxURmjJFJgizpJg
         BKVwErKsVSwnYCPYLtbLRV3ADSypQ49xrb7RjI7h+GOoPs8NBIt0hP6SHirzlvUS0L
         f1YrUJZADx5Eg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8672EE74CC2;
        Mon, 14 Feb 2022 13:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dsa: realtek: rename macro to match filename
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164484661054.29461.16726907137444901233.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Feb 2022 13:50:10 +0000
References: <20220212022533.2416-1-luizluca@gmail.com>
In-Reply-To: <20220212022533.2416-1-luizluca@gmail.com>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
Cc:     netdev@vger.kernel.org, linus.walleij@linaro.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, alsi@bang-olufsen.dk,
        arinc.unal@arinc9.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 11 Feb 2022 23:25:34 -0300 you wrote:
> The macro was missed while renaming realtek-smi.h to realtek.h.
> 
> Fixes: f5f119077b1c (net: dsa: realtek: rename realtek_smi to)
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---
>  drivers/net/dsa/realtek/realtek.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] net: dsa: realtek: rename macro to match filename
    https://git.kernel.org/netdev/net-next/c/7db45f8d955d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


