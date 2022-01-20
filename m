Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B87F494CFF
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 12:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbiATLaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 06:30:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbiATLaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 06:30:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2588FC061574
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 03:30:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 67C1FB81D46
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 11:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3C765C340E0;
        Thu, 20 Jan 2022 11:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642678211;
        bh=62alT1yT9gFiBDTdbbREB9uwyKY3TL4nx7WYNSJ48iE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Dn7SydM/qv/mx8RwTZwzEoxeifyXLu+iGeEtU6kjZuYsxeEla20F3G/uFnADEU2Tc
         x65FQyDnc0A/LlzyOYnUjPnUfCEcqx8OcvG9DsFwkxWHL5Y5p5PNoyg5eu7j8Rq5cQ
         +X43eEdpzBSL+SNBgb/8ffbWIGZUqFpPZT+iKtURF0ywZgfzbthTg6paxYaLuV0MGr
         dyWJBu1Ki9v262RoXLwUoF4+LLzADlz3Iub2mSffzek1XiWBVPHKr7gnVtAmHOvnH+
         YZQSjVbyALTvWiH2DG9fxJKjNnIiMV/saD6Zj98d8yzpfpLM6W9xs42JXG3U7f7eTf
         HUUvule9xz6Og==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 282B6F6079C;
        Thu, 20 Jan 2022 11:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: phy: broadcom: hook up soft_reset for BCM54616S
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164267821016.14873.13752803731967227641.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Jan 2022 11:30:10 +0000
References: <20220118215243.359473-1-robert.hancock@calian.com>
In-Reply-To: <20220118215243.359473-1-robert.hancock@calian.com>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, bcm-kernel-feedback-list@broadcom.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 18 Jan 2022 15:52:43 -0600 you wrote:
> A problem was encountered with the Bel-Fuse 1GBT-SFP05 SFP module (which
> is a 1 Gbps copper module operating in SGMII mode with an internal
> BCM54616S PHY device) using the Xilinx AXI Ethernet MAC core, where the
> module would work properly on the initial insertion or boot of the
> device, but after the device was rebooted, the link would either only
> come up at 100 Mbps speeds or go up and down erratically.
> 
> [...]

Here is the summary with links:
  - [net] net: phy: broadcom: hook up soft_reset for BCM54616S
    https://git.kernel.org/netdev/net/c/d15c7e875d44

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


