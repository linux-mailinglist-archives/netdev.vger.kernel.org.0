Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8AA754E995
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 20:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378007AbiFPSkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 14:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377897AbiFPSkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 14:40:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5425400A;
        Thu, 16 Jun 2022 11:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 794F461C5D;
        Thu, 16 Jun 2022 18:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CE709C3411B;
        Thu, 16 Jun 2022 18:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655404812;
        bh=uUBE/KWpkbd0j6y3BK6WIh1q3g51qdXfreTj8S+4e2s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UA9XtvGIHN5VzPvbPpCQ526yW1G8VGBXRHyD+OgWVXXvaScu8G9Zxrh3U2+nZDoyD
         WrDlvwk3aExpMCggXDnKsdxIOj+2YFdy2T7BnbNbEWUbZ10QCGZkSNCsxnilxN79va
         06MnT1AQC5h5r4iF6Kl4v/+1zTkJfUJZcpkp3OxbaWeLGfbhG9iazKezRJ1CercZ/N
         ceDrMSiT0Ka/bcxRgL99LKoGOu9qUlw/KIzBNdO3dlDdSKutJQCGzB6n/a+tzserJR
         Z//xYAQ3fHtuN1hB22uyoIH2t0Uu4WJEWXlOaeh5kUM48pZZZUeBnT3ySfyaEwXt3G
         ypSUg0/00mV2g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B7D20FD99FF;
        Thu, 16 Jun 2022 18:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: axienet: add missing error return code in
 axienet_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165540481274.4200.18216116266879133238.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Jun 2022 18:40:12 +0000
References: <20220616062917.3601-1-yangyingliang@huawei.com>
In-Reply-To: <20220616062917.3601-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, andy.chiu@sifive.com,
        max.hsu@sifive.com, greentime.hu@sifive.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 16 Jun 2022 14:29:17 +0800 you wrote:
> It should return error code in error path in axienet_probe().
> 
> Fixes: 00be43a74ca2 ("net: axienet: make the 64b addresable DMA depends on 64b archectures")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net] net: axienet: add missing error return code in axienet_probe()
    https://git.kernel.org/netdev/net/c/2e7bf4a6af48

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


