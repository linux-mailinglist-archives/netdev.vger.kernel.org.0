Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A958D560FEC
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 06:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230371AbiF3EKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 00:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbiF3EKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 00:10:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFDF62FE5D;
        Wed, 29 Jun 2022 21:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F7C1B8283B;
        Thu, 30 Jun 2022 04:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1C5D1C341C8;
        Thu, 30 Jun 2022 04:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656562213;
        bh=j5h/0V/Zafl9F7pQI8pfw0BVHw0jl1NCR9vxQNzETW8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hiCmoLzF6gO8a24aWlRwDVoJuD/KiNx9nXKJ647KXwEZ1f+IuzKslx4wMkdxdYXKn
         +bEbdye9zILTPecRuM1oyO6Bpj+6Y8jBTroyKrYa4Us/yUr70/Ly4hTo0rsQnXlUXm
         gUU6rZ47V1Fut64+I7rR0c+Gl5SQ6hwDa6hf/NMe5rKD7y5GtcnI1a88vJtIHwJIvD
         EDe36gSd8CnLOoKjnSBcycos000/xiZEPMaMU0vcR3Q7NiTIwOVvvHzpCjpt/6xyuc
         vcxtfXN121ChjH4vq/6mxNzpReKuohHgs1wyt8E7jwMgcerIf5D/W8zV5197ZQby2l
         UnR3A7SuF+q0g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ED0E9E49F65;
        Thu, 30 Jun 2022 04:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next v2] net: pcs-rzn1-miic: fix return value check in
 miic_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165656221296.5522.12753802189388825124.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Jun 2022 04:10:12 +0000
References: <20220628131259.3109124-1-yangyingliang@huawei.com>
In-Reply-To: <20220628131259.3109124-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, clement.leger@bootlin.com,
        olteanv@gmail.com, f.fainelli@gmail.com, davem@davemloft.net
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 28 Jun 2022 21:12:59 +0800 you wrote:
> On failure, devm_platform_ioremap_resource() returns a ERR_PTR() value
> and not NULL. Fix return value checking by using IS_ERR() and return
> PTR_ERR() as error value.
> 
> Fixes: 7dc54d3b8d91 ("net: pcs: add Renesas MII converter driver")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [-next,v2] net: pcs-rzn1-miic: fix return value check in miic_probe()
    https://git.kernel.org/netdev/net-next/c/dbc6fc7e3f76

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


