Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C04B0531339
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 18:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238367AbiEWQAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 12:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238319AbiEWQAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 12:00:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A18B6161F;
        Mon, 23 May 2022 09:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BF31ECE1677;
        Mon, 23 May 2022 16:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 26CFFC36AF5;
        Mon, 23 May 2022 16:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653321612;
        bh=nl764TnpF5LojCBXNEfM9nqApgfA6vTtKzmYaLebMMs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H1BFu1N71NZN+cnf9UEkLvODfBePH5cKiIQa6fqar02y2dKrM/VSrBNUSoNHfFWsU
         oAysoKYwik2+4DJwKDb0I0BS5D4PK5TR0GM+oDUUZEligvIfGFIF9U6kBa25bGH3V6
         E30dTClN9YIC+r/V97G8P3xJbMmx0zhKKmaXS7a0xFcmpfqdXAQNgyj1shAuu04IiN
         1p6s6VsaHs5UBf4LBME+Q4v6mbRcYJrRFBOHfOkToUn/145T5cD5zE58a0ZcIXmKBb
         o53+0cTtF717sXBLXQf9FDOvD8dCyemvagK/aMfInC0aYnobRYGZZbqxF1jCO1W+5O
         xZGmwkXu7/+mQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0E6A9EAC081;
        Mon, 23 May 2022 16:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Bluetooth: hci_sync: use hci_skb_event() helper
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <165332161205.20224.14103410632009923897.git-patchwork-notify@kernel.org>
Date:   Mon, 23 May 2022 16:00:12 +0000
References: <20220521201050.424197-1-a.fatoum@pengutronix.de>
In-Reply-To: <20220521201050.424197-1-a.fatoum@pengutronix.de>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, kernel@pengutronix.de,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to bluetooth/bluetooth-next.git (master)
by Marcel Holtmann <marcel@holtmann.org>:

On Sat, 21 May 2022 22:10:50 +0200 you wrote:
> This instance is the only opencoded version of the macro, so have it
> follow suit.
> 
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> ---
>  net/bluetooth/hci_request.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - Bluetooth: hci_sync: use hci_skb_event() helper
    https://git.kernel.org/bluetooth/bluetooth-next/c/edcb185fa9c4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


