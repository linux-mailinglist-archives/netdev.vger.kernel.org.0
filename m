Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D446613281
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 10:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbiJaJUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 05:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230301AbiJaJU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 05:20:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF3FDF35
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 02:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 631ED6106E
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 09:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B9173C43140;
        Mon, 31 Oct 2022 09:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667208016;
        bh=3lb4EHg2nh6MqyrVZM0FS0scAYFdokZFRBfmy0yLryM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bFtO3Rn4u7+qTyEsNPEVgmsIVPX3x7XJAF066PZE8q3k/kIaO4yKek5/gjJxVO9TZ
         Eq9XMIJnNJVQNfmIhHEJD9DHTBAO4shuo7ISI/ep6HYl2D0sECvyz1Zh8mf4F3HBzd
         ezpW31LcDHtLFTeSS+7MWex/Mz8MMv1UrUn7uy7+O9Qz19P2KnqjGQbnQH3/Z0I062
         JUyohMInb1q7XsW2ti3rHBQ864KCFziK+seZwAxLLHVfe/aP4rzP5BjTjC87WDRKuL
         w5sG70voOFc+iazafFgUMnMZzeqsvjBls0D2MX7mcZ4c8OU4jQx2q7ZvlMnX0GJVhi
         kD5xXsJ/UzWRQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 959BCE524C0;
        Mon, 31 Oct 2022 09:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] drivers: net: convert to boolean for the
 mac_managed_pm flag
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166720801660.13996.14268238884177162083.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Oct 2022 09:20:16 +0000
References: <74e1ed89-c3b7-1cbc-6880-9ca5dc5c3876@suse.de>
In-Reply-To: <74e1ed89-c3b7-1cbc-6880-9ca5dc5c3876@suse.de>
To:     Denis Kirjanov <dkirjanov@suse.de>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, kuba@kernel.org,
        qiangqing.zhang@nxp.com
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 27 Oct 2022 21:45:02 +0300 you wrote:
> Signed-off-by: Dennis Kirjanov <dkirjanov@suse.de>
> ---
> v2: adjust the subject
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 2 +-
>  drivers/net/ethernet/realtek/r8169_main.c | 2 +-
>  drivers/net/usb/asix_devices.c            | 4 ++--
>  3 files changed, 4 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [net-next,v2] drivers: net: convert to boolean for the mac_managed_pm flag
    https://git.kernel.org/netdev/net-next/c/eca485d22165

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


