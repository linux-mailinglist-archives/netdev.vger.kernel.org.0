Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93A0D6AE373
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 15:56:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjCGO4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 09:56:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjCGOx4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 09:53:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EA58534D;
        Tue,  7 Mar 2023 06:40:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B02760F78;
        Tue,  7 Mar 2023 14:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 91DB9C433D2;
        Tue,  7 Mar 2023 14:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678200022;
        bh=R5QTVd+c91hp6O3qR/+q2uyI0ss+MPW1LQ8rU2VOp/w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GrYk0S3nSCxxecS93UI0vn2q8/HcoNe5kvcVk+d/6AVjTJB/AHgfTvQcoxFir8pQ/
         L9zDBMF8ykymB82H0ZbzVDc6bN02bPW4TllAdrLbKeSUCJuVbJ53oww4KKGGzM5RbF
         3rlt/H2Azi7y0kmofQ2mmOSTDtF2xteEuvfFacjsOSIKlChiXwhc+7yPaCXu0b8kHe
         UKgvpN/MJziTfi8La4TNHrzlZo8HUdVJn7ykZank/H55K/LbgocpcpVXfjyycFf0jp
         5SR0gK52YFPiHo14OCwQ/XTZc7A9SRxmPrYhjRKQRuNd45xvaxCHbfA40h1GGbRzt5
         UqqotQQoOnhpQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6DC63E61B63;
        Tue,  7 Mar 2023 14:40:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH NET 1/1] net: usb: qmi_wwan: add Telit 0x1080 composition
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167820002243.18846.4300496620014346642.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Mar 2023 14:40:22 +0000
References: <20230306120528.198842-1-enrico.sau@gmail.com>
In-Reply-To: <20230306120528.198842-1-enrico.sau@gmail.com>
To:     Enrico Sau <enrico.sau@gmail.com>
Cc:     bjorn@mork.no, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon,  6 Mar 2023 13:05:28 +0100 you wrote:
> Add the following Telit FE990 composition:
> 
> 0x1080: tty, adb, rmnet, tty, tty, tty, tty
> 
> Signed-off-by: Enrico Sau <enrico.sau@gmail.com>
> ---
> 
> [...]

Here is the summary with links:
  - [NET,1/1] net: usb: qmi_wwan: add Telit 0x1080 composition
    https://git.kernel.org/netdev/net/c/382e363d5bed

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


