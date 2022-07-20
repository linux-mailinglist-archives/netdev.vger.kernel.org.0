Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 372B157AAE0
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 02:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234905AbiGTAUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 20:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232935AbiGTAUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 20:20:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ACF53C166;
        Tue, 19 Jul 2022 17:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96B6F61647;
        Wed, 20 Jul 2022 00:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 013EBC341CA;
        Wed, 20 Jul 2022 00:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658276414;
        bh=J0+tDWmV71XXoMFlvH3w595vcx49oyiVwUNFoSLD+ec=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hNImw0ISrQQFbH9E9PQbU9J+tJXQWMTxDR+HsrJFNc7v1ZOmEIyAnIE8Xp9xT2dnU
         Ur2yHy/z5XNYMP1+4FbWspq/Gu9vf9/lyCdghaS82OMz/K7NU4EtlFkLxAWA/2kzQm
         eNfgXzhBGSdFaRR0IJRnnrVAo0PmyuVLGFAmjVl7u5Z4nFNFPoCg2xqk24By0uv46J
         CMr9zbaQj1QQF5Gm0d6sYsFCqDJjlNnvDcP3y9DBIGFPIurEShj01hGys9Mcci9zLA
         OJOv58W/DQ6OCddQGOqflO/gE+0++o8toMNNws45UyBe8jlrAqdyzPzBG7etxq2gSX
         uLrekbh8lT8UQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D9C1DE451B7;
        Wed, 20 Jul 2022 00:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] r8152: fix a WOL issue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165827641388.1716.6764396748930335570.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jul 2022 00:20:13 +0000
References: <20220718082120.10957-391-nic_swsd@realtek.com>
In-Reply-To: <20220718082120.10957-391-nic_swsd@realtek.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 18 Jul 2022 16:21:20 +0800 you wrote:
> This fixes that the platform is waked by an unexpected packet. The
> size and range of FIFO is different when the device enters S3 state,
> so it is necessary to correct some settings when suspending.
> 
> Regardless of jumbo frame, set RMS to 1522 and MTPS to MTPS_DEFAULT.
> Besides, enable MCU_BORW_EN to update the method of calculating the
> pointer of data. Then, the hardware could get the correct data.
> 
> [...]

Here is the summary with links:
  - [net] r8152: fix a WOL issue
    https://git.kernel.org/netdev/net/c/cdf0b86b250f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


