Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8A2563DF6
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 05:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbiGBDUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 23:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbiGBDUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 23:20:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8656D326C4;
        Fri,  1 Jul 2022 20:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2040561DAF;
        Sat,  2 Jul 2022 03:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 76489C341D7;
        Sat,  2 Jul 2022 03:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656732015;
        bh=py35Jkb9SXf3dMOQJgoaLh6E3cfW5aoYSyRfitidNJw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kYwmhpmki8d4ayPJYdD5Ov0ZCpjHhBgUuHf3IoxUrrS2u/Xitjqt31cB7Cs+E4sM7
         e+1F11M7E8Xa+vdiym5TsnGNVveXIOj3smMEgJXgT2vjRxj1pZAycP1Gg9gxNyxMio
         d8RyFFPFbqoGWs/D2HM+VvteNfmXH+FaOwcmA6y+BKSy4zoG0PezZ4+2tZwqkQ8SmP
         +wFSEx3rXkVGHzTck+X+SZxCEInsS/xQF5VCAghdh+4Nakm/TOAn2z7fnnKGAt/jUM
         HUlbQamNP1TSP5Ou/+l7TctUueM8zIho+c6dU83xiQEp5NpXnDwV2vc+hveqbkJnCn
         yDICMm3RKiZmA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5F232E49FA1;
        Sat,  2 Jul 2022 03:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] usbnet: remove vestiges of debug macros
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165673201538.6297.2718104574560255465.git-patchwork-notify@kernel.org>
Date:   Sat, 02 Jul 2022 03:20:15 +0000
References: <20220630110741.21314-1-oneukum@suse.com>
In-Reply-To: <20220630110741.21314-1-oneukum@suse.com>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
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

On Thu, 30 Jun 2022 13:07:41 +0200 you wrote:
> The driver has long since be converted to dynamic debugging.
> The internal compile options for more debugging can simply be
> deleted.
> 
> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> ---
>  drivers/net/usb/usbnet.c | 3 ---
>  1 file changed, 3 deletions(-)

Here is the summary with links:
  - usbnet: remove vestiges of debug macros
    https://git.kernel.org/netdev/net-next/c/1d7f94cdd8f0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


