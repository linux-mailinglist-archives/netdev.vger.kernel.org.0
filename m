Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70929673914
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 14:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjASNAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 08:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230038AbjASNAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 08:00:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC4143581;
        Thu, 19 Jan 2023 05:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5704A60AD1;
        Thu, 19 Jan 2023 13:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA7F6C433EF;
        Thu, 19 Jan 2023 13:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674133217;
        bh=J2sdmk+O3cZf5N4mF2+OZgXMrz7lzTqr8VuxQ9Oox3U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EHvGiNk8/5xS6D/NiSaZn5sQMcy5w+r58UbNY5xjsXk2DV7xjD+8G8e/oTJU7bdk7
         lrkTkynL+z5330DIuVF+mlABuCsBPWLyc0WtxMMk6V8OSkzuTCzbgSCeoNCpivPrxn
         yVmXIs2rCdWqLkc2/n/agXbI7tfNqyFGnZ6ZF4SC+YpazFez2jKwQ9Lu1wY3g3o66t
         /uiatdvFbVBvfmgZNJoFrd3tYblEclbIbv6uq0urjCm1UkJXAKVaoIoT6Ep4OccixN
         DAQ/gsBOG7dfLWptr7xmYN043UMDmKZ4IDbbG5cV5uzLyeUQPFmZ2KHTapv+oaAHQp
         kuLLMrGt7CRxw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9DF3DC39563;
        Thu, 19 Jan 2023 13:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3]  generic implementation of phy interface and
 fixed_phy support for the LAN743x device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167413321764.14341.1192990758690221867.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Jan 2023 13:00:17 +0000
References: <20230117141614.4411-1-Pavithra.Sathyanarayanan@microchip.com>
In-Reply-To: <20230117141614.4411-1-Pavithra.Sathyanarayanan@microchip.com>
To:     Pavithra Sathyanarayanan <Pavithra.Sathyanarayanan@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bryan.whitehead@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 17 Jan 2023 19:46:11 +0530 you wrote:
> This patch series includes the following changes:
> 
> - Remove the unwanted interface settings in the LAN743x driver as
>   it is preset in EEPROM configurations.
> 
> - Handle generic implementation for the phy interfaces for different
>   devices LAN7430/31 and pci11x1x.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net: lan743x: remove unwanted interface select settings
    https://git.kernel.org/netdev/net-next/c/1c9bb4429009
  - [net-next,2/3] net: lan743x: add generic implementation for phy interface selection
    https://git.kernel.org/netdev/net-next/c/e86c721090e3
  - [net-next,3/3] net: lan743x: add fixed phy support for LAN7431 device
    https://git.kernel.org/netdev/net-next/c/624864fbff92

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


