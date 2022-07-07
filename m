Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACB98569875
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 05:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234936AbiGGDAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 23:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234886AbiGGDAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 23:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647342FFC2;
        Wed,  6 Jul 2022 20:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F8C46215B;
        Thu,  7 Jul 2022 03:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 07E6CC341D0;
        Thu,  7 Jul 2022 03:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657162815;
        bh=4J4PQ9uv1asp0Vk3OGGwL6SJmMqMoMnptqZmjN/jiOA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ii26B/MqwP6zqbcfpkK5b0QCXTfUrmK0Fl8Ur+MHSgzkik8BW1zAFDU7E6sx1SUnz
         Wk/YlViVMnwvqQhBQcU7QqwnaWiHz4DQXEPdQuWiWUjK72LS2BenK8273fnqlAJ7E4
         ZLHM5QgPlym7t4O27J5P3F6CXwJjRUTInVw1lRESiGQof1ZRnzvldLyc8aKyI1v12A
         9a2uxT6+GiK8ZH2pVkBUslyH7WQgCjjYBYX1d2fTlnhOATkef0o7XWkP/KuENk5cjY
         SLg4GOlfd6uxk43dtl3tDyhhJios1bLNsUnQAl2XDIpBi6k+le0i7KSb4449LlSUvb
         fOBJfVxdIODqA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DE97BE45BDF;
        Thu,  7 Jul 2022 03:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: dsa: b53: remove unnecessary spi_set_drvdata()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165716281490.11165.7183920279535695114.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Jul 2022 03:00:14 +0000
References: <20220705131733.351962-1-yangyingliang@huawei.com>
In-Reply-To: <20220705131733.351962-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, davem@davemloft.net
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 5 Jul 2022 21:17:33 +0800 you wrote:
> Remove unnecessary spi_set_drvdata() in b53_spi_remove(), the
> driver_data will be set to NULL in device_unbind_cleanup() after
> calling ->remove().
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/dsa/b53/b53_spi.c | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - [-next] net: dsa: b53: remove unnecessary spi_set_drvdata()
    https://git.kernel.org/netdev/net-next/c/6ca4b3932114

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


