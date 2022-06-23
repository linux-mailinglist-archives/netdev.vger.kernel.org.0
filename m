Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35676556FEB
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 03:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244720AbiFWBaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 21:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237828AbiFWBaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 21:30:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219E74339C;
        Wed, 22 Jun 2022 18:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE01BB82185;
        Thu, 23 Jun 2022 01:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9B4C3C341C5;
        Thu, 23 Jun 2022 01:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655947813;
        bh=ovCsGvzEsvgDTBhcIXWG04M1NeUaNuVh9D3Y5BE9nhk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dShnmHCfD1ozPdAqEqFIXkGM2eJ6nP/DBaJ9LwHxZcOvBF/VI8ggKBgFa7l3gaXCB
         pdUnXrLg+RSm5WxKlyXyjbYJpaP8Xa/hcUV17j5H4ZvFgv7HWd8ns4WBpQQkDX3OuH
         mfKittEnWqRCP8XYaNhaceww2tsM0ApPmoAvZTOmeLZvDFXAUJ5WUhQ+sz7CMbci7Y
         C6HBZcbrP0lp+7vFuZAxvI5Z2WxTFO5u6/bK0+FhBG3CMMjky0UrxlbhNKp3tiii/b
         VIRgXI04TAzD1ntAj4pSP/MUWh0z+M98V/0U7Ro7V43VEW5EvupM/rt520INaQqJUy
         hwMXIiFngMvqA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7DE94E7387A;
        Thu, 23 Jun 2022 01:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] isdn: mISDN: hfcsusb: drop unexpected word "the" in the
 comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165594781350.21755.6624075051253698330.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Jun 2022 01:30:13 +0000
References: <20220621114529.108079-1-jiangjian@cdjrlc.com>
In-Reply-To: <20220621114529.108079-1-jiangjian@cdjrlc.com>
To:     Jiang Jian <jiangjian@cdjrlc.com>
Cc:     isdn@linux-pingi.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Jun 2022 19:45:29 +0800 you wrote:
> there is an unexpected word "the" in the comments that need to be dropped
> 
> file: ./drivers/isdn/hardware/mISDN/hfcsusb.c
> line: 1560
>  /* set USB_SIZE_I to match the the wMaxPacketSize for ISO transfers */
> changed to
>  /* set USB_SIZE_I to match the wMaxPacketSize for ISO transfers */
> 
> [...]

Here is the summary with links:
  - isdn: mISDN: hfcsusb: drop unexpected word "the" in the comments
    https://git.kernel.org/netdev/net-next/c/d4667f96f485

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


