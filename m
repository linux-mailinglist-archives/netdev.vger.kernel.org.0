Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB95D5ABE38
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 11:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiICJka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Sep 2022 05:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiICJkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Sep 2022 05:40:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB2C558C4;
        Sat,  3 Sep 2022 02:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E85461127;
        Sat,  3 Sep 2022 09:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7ED8C43470;
        Sat,  3 Sep 2022 09:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662198015;
        bh=1WDgVLfsGFXYQXBIELIqHHBbqbtcLoixke9jx2sw0MY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lF+K9AxoSfmf+EQ4qAv6gV074DFRj8G+EHZcT4NPRi0gzWqT1kBruA0WpcdHEP9Ue
         CqU6deFOcIlrzBeupz7yJcpRQqwzLu3Ty0BOYnI2/AQl1XhLAyNInKGWHyUgL69N2E
         GNlMVGf8/EZSuC4WCnQmidkGWpN2EPr346AWzk8KhnnTLlIByW/JwO8Hv20zxkt6t2
         qsz5M79GKhTfynr90XU6QPY6P9lfJnbRLTMx49603YaGCX1FEqADBbYNmZOyiMJCZ1
         UFDAcepVL/1VwpYFQrPDAF7Iwp7auk2szxX2FZhLNyh0ZshhTzrVZOxXtZkPJyVLMy
         tPM0vTnE1rIOA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BB507C73FE2;
        Sat,  3 Sep 2022 09:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8152: Add MAC passthrough support for Lenovo Travel
 Hub
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166219801576.23737.2454170362876714023.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Sep 2022 09:40:15 +0000
References: <20220901170013.7975-1-git@apitzsch.eu>
In-Reply-To: <20220901170013.7975-1-git@apitzsch.eu>
To:     =?utf-8?b?QW5kcsOpIEFwaXR6c2NoIDxnaXRAYXBpdHpzY2guZXU+?=@ci.codeaurora.org
Cc:     aaron.ma@canonical.com, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Thu,  1 Sep 2022 19:00:13 +0200 you wrote:
> The Lenovo USB-C Travel Hub supports MAC passthrough.
> 
> Signed-off-by: André Apitzsch <git@apitzsch.eu>
> ---
>  drivers/net/usb/r8152.c | 2 ++
>  1 file changed, 2 insertions(+)

Here is the summary with links:
  - [net-next] r8152: Add MAC passthrough support for Lenovo Travel Hub
    https://git.kernel.org/netdev/net-next/c/e26c258434b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


