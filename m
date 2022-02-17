Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C23074BA3E4
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 16:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242292AbiBQPAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 10:00:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238532AbiBQPA2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 10:00:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DFC63B9;
        Thu, 17 Feb 2022 07:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B9ADB821FA;
        Thu, 17 Feb 2022 15:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 046F7C340EC;
        Thu, 17 Feb 2022 15:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645110010;
        bh=7g5K1tyQnpYpzj8EjNVVkumgeZTHpZWDqLo+7Cv7jL0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sbBz2r9YUUg8qn6HEQgAKgBgfqj/ThCkWpoN4HRI7J9S1SwzNMjM/gMKXdiuLXvfW
         As5UfKEiYs0SP2SMF9C0a15i9lFuFK9qPYh5rqD5kAvhT7sGliy1iXh0AFpsvyoGlU
         Ro9WUocNib3Y2tdcpiyx4kqYiM/K2DK29gBs9USRvgbWKxA7D8Ue8OdveRWCpA7eim
         TWRGI3K65bsKPbGMmtyOkQrCCM/YzcC1+I7PUZzYu0Q/hxMEMMxTqm0lb6i/zv90g/
         1vqXHmIabxetooC3IXxJsUP31hnCjsFU6Y5j9m06rhq7tBGC6q2AhoPDCAvxQAB0NL
         qwy3Li+8v9AQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E1006E7BB07;
        Thu, 17 Feb 2022 15:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/1] net: usb: cdc_mbim: avoid altsetting toggling for Telit
 FN990
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164511000991.15414.17501136834263839066.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Feb 2022 15:00:09 +0000
References: <20220215111335.26703-1-dnlplm@gmail.com>
In-Reply-To: <20220215111335.26703-1-dnlplm@gmail.com>
To:     Daniele Palmas <dnlplm@gmail.com>
Cc:     oliver@neukum.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
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

On Tue, 15 Feb 2022 12:13:35 +0100 you wrote:
> Add quirk CDC_MBIM_FLAG_AVOID_ALTSETTING_TOGGLE for Telit FN990
> 0x1071 composition in order to avoid bind error.
> 
> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
> ---
>  drivers/net/usb/cdc_mbim.c | 5 +++++
>  1 file changed, 5 insertions(+)

Here is the summary with links:
  - [1/1] net: usb: cdc_mbim: avoid altsetting toggling for Telit FN990
    https://git.kernel.org/netdev/net/c/21e8a96377e6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


