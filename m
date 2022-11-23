Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68DAD63609E
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 14:56:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237587AbiKWN4Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 08:56:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236394AbiKWNzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 08:55:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85CF68B13D;
        Wed, 23 Nov 2022 05:50:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EC2761CD7;
        Wed, 23 Nov 2022 13:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 73CDAC433D7;
        Wed, 23 Nov 2022 13:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669211415;
        bh=YglOyN/FLlZOluyhXxYhok9LJD3noFe6JWNcOaOZsm0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CF+t9rpuwT0uTH+JxUlm7ZXNxzDp9ZcyTAUa9vmuUzB3h2lJ3H+GtkhMwUCYV6UcV
         qwSEkhdyBNMVnG5iCG2SbZnCf2BSg/3g+49L74a6bMWf6u0IVMpVE/7GDUmH2BnO2Z
         XzZ9VAJkg39LFYwAiXSdJ55DVQvduxSo1XA06ThYaSTL+F7T40tlU27HAyWtFjtpP2
         XfUAzEo3Wca1H/sYwRpXs7ajjyh1htaqF+rYCqiXUdDWOKHuOAzdmz/17uXrdT07LZ
         cHwo6AIdBLFpJQxJhVd7rismigrnK4UeZiUZC5Givh6h9/hBsafJ45wEp+HFDpLL81
         YzQLLnzQ+yXGw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 576C6E21EF9;
        Wed, 23 Nov 2022 13:50:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net/cdc_ncm: Fix multicast RX support for CDC NCM devices
 with ZLP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166921141535.13791.14050518206893569028.git-patchwork-notify@kernel.org>
Date:   Wed, 23 Nov 2022 13:50:15 +0000
References: <20221121205304.62587-1-santiago.ruano-rincon@imt-atlantique.fr>
In-Reply-To: <20221121205304.62587-1-santiago.ruano-rincon@imt-atlantique.fr>
To:     =?utf-8?q?Santiago_Ruano_Rinc=C3=B3n_=3Csantiago=2Eruano-rincon=40imt-atlant?=@ci.codeaurora.org,
        =?utf-8?q?ique=2Efr=3E?=@ci.codeaurora.org
Cc:     gregkh@linuxfoundation.org, oliver@neukum.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 21 Nov 2022 21:53:05 +0100 you wrote:
> ZLP for DisplayLink ethernet devices was enabled in 6.0:
> 266c0190aee3 ("net/cdc_ncm: Enable ZLP for DisplayLink ethernet devices").
> The related driver_info should be the "same as cdc_ncm_info, but with
> FLAG_SEND_ZLP". However, set_rx_mode that enables handling multicast
> traffic was missing in the new cdc_ncm_zlp_info.
> 
> usbnet_cdc_update_filter rx mode was introduced in linux 5.9 with:
> e10dcb1b6ba7 ("net: cdc_ncm: hook into set_rx_mode to admit multicast
> traffic")
> 
> [...]

Here is the summary with links:
  - [v2] net/cdc_ncm: Fix multicast RX support for CDC NCM devices with ZLP
    https://git.kernel.org/netdev/net/c/748064b54c99

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


