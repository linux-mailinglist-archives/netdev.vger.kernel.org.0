Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 964D84D4014
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 05:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239398AbiCJEBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 23:01:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238110AbiCJEBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 23:01:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCE8D31F8;
        Wed,  9 Mar 2022 20:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D1F35617E8;
        Thu, 10 Mar 2022 04:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 35525C340F3;
        Thu, 10 Mar 2022 04:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646884811;
        bh=nGcXux3HhOMFeI4LfeIm/1h3o6WAHCoM7XbftuaGu0U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sFfOeHE0MLsUFnlzDk0MpqfHpxY2PAXlAY2oTh+2qnYoKCHTw0yr+Anp+YwZ73UbA
         2rIS38pelT10P9xRoGk6bn5caEZZJdsEdzdv30q3hT6bf4Xzx2CoRUef5zU1KvyPuq
         sDlPpvFWxHKTaz45hGgtFo2qgLkEb+kb4Aev4kunK5x5jVkQiwg/H5xcDbX2YDhRUb
         gc/rgvkHZgp8+Z5g5RcypGuO+AaEfMAal2MTDkA6Btv4BGqhia/zlTvAmP2P+qQAnI
         jRgGDdlVg/2jVcpVmFHGgWaT8uiGAq5Z2XolRsAS8Y4R9Th9hZ7C9rboQb5smcyAcn
         wtVzJQQ0CKNIw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1DA58F03841;
        Thu, 10 Mar 2022 04:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ptp: idt82p33: use rsmu driver to access i2c/spi bus
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164688481111.32652.2698356518749751397.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 04:00:11 +0000
References: <1646748651-16811-1-git-send-email-min.li.xe@renesas.com>
In-Reply-To: <1646748651-16811-1-git-send-email-min.li.xe@renesas.com>
To:     Min Li <min.li.xe@renesas.com>
Cc:     richardcochran@gmail.com, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  8 Mar 2022 09:10:51 -0500 you wrote:
> rsmu (Renesas Synchronization Management Unit ) driver is located in
> drivers/mfd and responsible for creating multiple devices including
> idt82p33 phc, which will then use the exposed regmap and mutex
> handle to access i2c/spi bus.
> 
> Signed-off-by: Min Li <min.li.xe@renesas.com>
> 
> [...]

Here is the summary with links:
  - [net] ptp: idt82p33: use rsmu driver to access i2c/spi bus
    https://git.kernel.org/netdev/net-next/c/013a3e7c79ac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


