Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1967459F9F7
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 14:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237421AbiHXMaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 08:30:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237420AbiHXMaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 08:30:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18E657886
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 05:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ACAA619E9
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 12:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7D584C4314F;
        Wed, 24 Aug 2022 12:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661344220;
        bh=kIKbJkpwdKFig1pNieA52aNd1wmePYK38sJ1vJf9Ifc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I6QLC4UNCf0Qgk8cDAhBtELRjBhffkeJA7qKe0pjyElwoG3bHACV2JFIy6sDchjf/
         tvBX/yDhVWvOh/6v5bjLbcVaCCfF991q+xibmknWaCGsFItu3KsNk7wPQY9uj6Rl4T
         OYMMZb2qaJxBTLAR/UUxlg2OjN6mjXDZ7ZfQysCJEuf2QeFqGlGeF4RsPyc8gYNrmZ
         AkKOn8XoRgH3eqP0tSmu9ua+cDgDP2jwRcoj1RL8FeSCBe4yw9uzzTIC1J1VACOehc
         QWsxSRmWPkmzM7BBGPIs4e6Rle3P/mXxUdYQ+ptETP+C1vvNXY/r2+cpUgAbKS207K
         usvU99iqnLMaQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5AEAFC04E59;
        Wed, 24 Aug 2022 12:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/5] r8169: remove support for few unused chip
 versions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166134422036.21889.3351330965192168863.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Aug 2022 12:30:20 +0000
References: <3bff9a7a-2353-3b37-3b6e-ebcae00f7816@gmail.com>
In-Reply-To: <3bff9a7a-2353-3b37-3b6e-ebcae00f7816@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        pabeni@redhat.com, edumazet@google.com, netdev@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 23 Aug 2022 20:33:06 +0200 you wrote:
> There's a number of chip versions that apparently never made it to the
> mass market. Detection of these chip versions has been disabled for
> few kernel versions now and nobody complained. Therefore remove
> support for these chip versions.
> 
> Heiner Kallweit (5):
>   r8169: remove support for chip version 41
>   r8169: remove support for chip versions 45 and 47
>   r8169: remove support for chip version 49
>   r8169: remove support for chip version 50
>   r8169: remove support for chip version 60
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/5] r8169: remove support for chip version 41
    https://git.kernel.org/netdev/net-next/c/44307b27de2e
  - [net-next,v3,2/5] r8169: remove support for chip versions 45 and 47
    https://git.kernel.org/netdev/net-next/c/ebe598985711
  - [net-next,v3,3/5] r8169: remove support for chip version 49
    https://git.kernel.org/netdev/net-next/c/8a1ab0c4028d
  - [net-next,v3,4/5] r8169: remove support for chip version 50
    https://git.kernel.org/netdev/net-next/c/133706a960de
  - [net-next,v3,5/5] r8169: remove support for chip version 60
    https://git.kernel.org/netdev/net-next/c/efc37109c780

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


