Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DBDC4BB7D0
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 12:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234500AbiBRLKg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 06:10:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233933AbiBRLKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 06:10:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1782B4611;
        Fri, 18 Feb 2022 03:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0D62B825D6;
        Fri, 18 Feb 2022 11:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7DD84C340EB;
        Fri, 18 Feb 2022 11:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645182610;
        bh=lp7cghyXAebWMJKIuCyhowwplg9kOkL9uCDs5vCYHQ4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I2d8DAE0RZTwk/xl2i5NpXx4JJiznECeOgOSW0Tcf3tTHGothSEYihWnNwKyZ0Heu
         DP76tP6kC35xG1M9NLoELYMZdYJswfQkZAgUYiFdRuAP8Pee3JAOsORE+2P7TkZ/Rt
         JtKJeWGEruqhdRZefJUxfpThEsGJPFa4Xn+NdEfp5yjAAsiI7JKP0qRa242nEoqNQL
         13oE79ddhwBxmvxyMWkvmpS8S30kYTzlzwHTeC8TFzlnIr/ooFAv5i7VXC0TawweJ5
         MZoLelwj8Le7z3DqefckL8Vtu1BYv37jJi272sJ7ETgo04TrHCMkgTzaNxPmZdYsUW
         aBAQEYPYQyhPw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6A12DE5D07D;
        Fri, 18 Feb 2022 11:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sr9700: sanity check for packet length
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164518261043.25032.13889771767086361342.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Feb 2022 11:10:10 +0000
References: <20220217131044.26983-1-oneukum@suse.com>
In-Reply-To: <20220217131044.26983-1-oneukum@suse.com>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     davem@davemloft.net, kuba@kernel.org, grundler@chromium.org,
        andrew@lunn.ch, jgg@ziepe.ca, linux-usb@vger.kernel.org,
        arnd@arndb.de, netdev@vger.kernel.org
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

On Thu, 17 Feb 2022 14:10:44 +0100 you wrote:
> A malicious device can leak heap data to user space
> providing bogus frame lengths. Introduce a sanity check.
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> ---
>  drivers/net/usb/sr9700.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - sr9700: sanity check for packet length
    https://git.kernel.org/netdev/net/c/e9da0b56fe27

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


