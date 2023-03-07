Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F90A6AE370
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 15:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjCGOz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 09:55:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229834AbjCGOxz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 09:53:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33D485342;
        Tue,  7 Mar 2023 06:40:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EC4F60FC8;
        Tue,  7 Mar 2023 14:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8790BC4339B;
        Tue,  7 Mar 2023 14:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678200022;
        bh=6KSSDLxApAGfAGVWW1HnpG2XRbT8ELm/2m8BT5B0iRs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e9lFazkxpt2TE/uHnMsjyHn0CfyzLqmqXuAoD7EiG8cgfvlFkYsBduka71EkgE716
         W0ZDj9IjG9gVWsTsh3JbW4AP2SI3FgxmIW67Dyw1JUs594r/mAjilb9eLuomkEuTPU
         trBLb1FcuVEcxRdbrgqQevhyfHs/Q+02kNSMyDU5U8OEiw80tjqbqv3P5JxsrDapuO
         B+J9MYLJGdQxeQwfMhmgkUvhJOeOnVmt1+jRbXobcxhbU98msU9ifE9Xu7VI+9y+x+
         N08n1qC//XTqEVRj2VJ2UeeS9MtugvsYz3c0iVe3DxvCYH9QNdfQrogWJRlSoaVVZO
         nJdWddQfmPcfw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5AD59E61B65;
        Tue,  7 Mar 2023 14:40:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH NET 1/1] net: usb: cdc_mbim: avoid altsetting toggling for
 Telit FE990
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167820002235.18846.17456901212057341424.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Mar 2023 14:40:22 +0000
References: <20230306115933.198259-1-enrico.sau@gmail.com>
In-Reply-To: <20230306115933.198259-1-enrico.sau@gmail.com>
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

On Mon,  6 Mar 2023 12:59:33 +0100 you wrote:
> Add quirk CDC_MBIM_FLAG_AVOID_ALTSETTING_TOGGLE for Telit FE990
> 0x1081 composition in order to avoid bind error.
> 
> Signed-off-by: Enrico Sau <enrico.sau@gmail.com>
> ---
> 
> This is the verbose lsusb:
> 
> [...]

Here is the summary with links:
  - [NET,1/1] net: usb: cdc_mbim: avoid altsetting toggling for Telit FE990
    https://git.kernel.org/netdev/net/c/418383e6ed6b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


