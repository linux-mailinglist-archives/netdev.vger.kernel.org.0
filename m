Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE6D4D6D32
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 08:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbiCLHLT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 02:11:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiCLHLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 02:11:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E9BF13CCC;
        Fri, 11 Mar 2022 23:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1111B82E15;
        Sat, 12 Mar 2022 07:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60F17C340ED;
        Sat, 12 Mar 2022 07:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647069010;
        bh=AwuO9bOvBfea6PvvSNh6PKayFanU72GnPoaLXmHGLHk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tZALQzwq8G9xtjKyYr1EUJRFEv9TzW9hpRBAnGroMWK50tqQ4HjhDSyKka3gx49vu
         fGS4wED7QuWNjIuH0isTlqqKL1/TbOtmhfiWmfAYhE5jS7r0u/9b4QnUL2+dyDO3DF
         WlyZqOtJ/NSWPe5s/ruZRN1sp9s6+Hxd8s8y7LVVUvQ3y8eGCMu6EWZwnt+6hiELPm
         SOVjFKcFVYB3D8HuhV2NR6TPzWdEdvokOgc/tUGuB6TWLKGuBU8ShaEzL6ApAHFp0D
         iejwIotgYiCVwPe/QrTfW0Nuf8RpY1/fOvnBlQqeeLxVo2S+PHC6TjtQHM6JU9S4dx
         RGCprieOmLr0Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3F2DCE6D3DD;
        Sat, 12 Mar 2022 07:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] ethernet: 8390: Remove unnecessary print function
 dev_err()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164706901025.31184.3021384925271483358.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Mar 2022 07:10:10 +0000
References: <20220311001756.12234-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20220311001756.12234-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, abaci@linux.alibaba.com
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

On Fri, 11 Mar 2022 08:17:56 +0800 you wrote:
> The print function dev_err() is redundant because platform_get_irq()
> already prints an error.
> 
> Eliminate the follow coccicheck warning:
> ./drivers/net/ethernet/8390/mcf8390.c:414:2-9: line 414 is redundant
> because platform_get_irq() already prints an error
> 
> [...]

Here is the summary with links:
  - [-next] ethernet: 8390: Remove unnecessary print function dev_err()
    https://git.kernel.org/netdev/net-next/c/d59c85ddacb3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


