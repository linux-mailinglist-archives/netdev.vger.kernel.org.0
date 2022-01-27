Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5EDA49E3BB
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 14:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238415AbiA0NkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 08:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbiA0NkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 08:40:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51965C06174A
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 05:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABE6261C54
        for <netdev@vger.kernel.org>; Thu, 27 Jan 2022 13:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 183DCC340ED;
        Thu, 27 Jan 2022 13:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643290811;
        bh=RbSUetkMYVhvwiyGpLj30woREv5lCF18KyTwsW0Fhsc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RrquttNKVBAVUPK0qeot0RxOzwDKaiBldnCmrsvWX/4tD7dOKNaIRgtVjR/Y2oeLr
         aCB2ZPpSmM6fNGLrRw/n+KyO2TFEArT3ZSlTWxSWZygxmyzRityPWfpW3u2bG7FoNb
         PsdrLpeFL4I1VMob7MjkUiyCC9oosA7T7dKivSP9VKpUbo7tCLoLaRrKjy1WQHjg5H
         WzUMQjd3pz3ux4aTHLER2bGIecFLU2RwdRIVIFN7E0Y6BK6RnUJBfchLCcaYpB7Rso
         Z0nlxm5guDeaa3MRAsw/a3rg2ixL5S2iKfCuRS/tHs2XKRGtZU7NjWPlSdmvs+JWm8
         ntE0VUO3gwL9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 04682E5D089;
        Thu, 27 Jan 2022 13:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/3] at803x fiber/SFP support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164329081101.3515.14681100372528194386.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 13:40:11 +0000
References: <20220125165410.252903-1-robert.hancock@calian.com>
In-Reply-To: <20220125165410.252903-1-robert.hancock@calian.com>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        mail@david-bauer.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 25 Jan 2022 10:54:07 -0600 you wrote:
> Add support for 1000Base-X fiber modes to the at803x PHY driver, as
> well as support for connecting a downstream SFP cage.
> 
> Changes since v3:
> -Renamed some constants with OHM suffix for clarity
> 
> Changes since v2:
> -fixed tabs/spaces issue in one patch
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/3] net: phy: at803x: move page selection fix to config_init
    https://git.kernel.org/netdev/net-next/c/4f3a00c7f5b2
  - [net-next,v4,2/3] net: phy: at803x: add fiber support
    https://git.kernel.org/netdev/net-next/c/3265f4218878
  - [net-next,v4,3/3] net: phy: at803x: Support downstream SFP cage
    https://git.kernel.org/netdev/net-next/c/dc4d5fcc5d36

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


