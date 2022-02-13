Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 319B84B3B49
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 13:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235921AbiBMMUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 07:20:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231621AbiBMMUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 07:20:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B735D18A;
        Sun, 13 Feb 2022 04:20:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 483DD61155;
        Sun, 13 Feb 2022 12:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A4DBCC340EF;
        Sun, 13 Feb 2022 12:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644754809;
        bh=K571NG4X4Pc1O52F5naqG4zxvyzSqkmmp5kjlV11zQ0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Yu0eV/N6i2MbTFvekxllQgV3Rlyo2mfIFbChisRicC84AEl30miZB2SZVsdmcnbrq
         QmbgYB4QjQazfcnUQpxZxAYFKi0oni2UUKEA+Aq7QjtzHRhHN3Qr/eT/qi4xwjDcUK
         +7oRzZKtunKW/VSpHU+Y7XJfYD54DYVP/HVSjwkbRv5rLE8yUOvb5iu4IXvPpO2H6h
         av9r5W/WJlB3E36NfOISs0QKF1WBdttvTRNh+mnaHo6dn2LU1iUg6OdRXXf09LvADB
         89sy/BNQ1u2A+g2aWvO0I8Foc+KQvBCFx8EIAI1FC5iDc9XshmeDtgzbiWnHZeQEn0
         OV+TlI59WoefQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8E031E6BBD2;
        Sun, 13 Feb 2022 12:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tipc: fix a bit overflow in tipc_crypto_key_rcv()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164475480957.14254.17768988352478949538.git-patchwork-notify@kernel.org>
Date:   Sun, 13 Feb 2022 12:20:09 +0000
References: <20220211045510.18870-1-hbh25y@gmail.com>
In-Reply-To: <20220211045510.18870-1-hbh25y@gmail.com>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     jmaloy@redhat.com, ying.xue@windriver.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net, linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 11 Feb 2022 12:55:10 +0800 you wrote:
> msg_data_sz return a 32bit value, but size is 16bit. This may lead to a
> bit overflow.
> 
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
>  net/tipc/crypto.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] tipc: fix a bit overflow in tipc_crypto_key_rcv()
    https://git.kernel.org/netdev/net/c/143de8d97d79

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


