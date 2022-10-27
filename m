Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5747760F5D3
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 13:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234921AbiJ0LAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 07:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234838AbiJ0LAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 07:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78987C317
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 04:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BA6F62297
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 11:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 83914C43142;
        Thu, 27 Oct 2022 11:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666868416;
        bh=4CyVBSxrTbrxEretnISp693RWFtq5B48Btdad5X5NyY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KF9O5u5R747ejJzx03Tnj7NvYGRdiiMlnb0KVnYdEVsDXYmC9LjxQkN9xwjObEMla
         59akAt7nt8QOGIb2EawVZPo/nVELFt1oeCYCibV1fsiO79doq73HV0E4v4Y9xPnRWQ
         s16jladoqpoxe+S4L+q0cyWII2+qhH5zNIGWM4fOPV2UeVjnZ8/QQFt08NS1fGZhIy
         8S0xLeWTryNMURpTQWi5WEWSXaMR1QeAC42XzFKOR/SatVjRo8MuxUnLVTHpB/qw/a
         Ph6zGM2+ogTuz7yFUokxVYfClJ6/Iro6LZGsHQXv+/H1U5ae8wVI1krC1QACa8gBQI
         88VYFrQD+5MuA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6F9CFE270D8;
        Thu, 27 Oct 2022 11:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: dp83822: Print the SOR1 strap status
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166686841645.31058.6553796837315962777.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 11:00:16 +0000
References: <20221025120109.779337-1-festevam@gmail.com>
In-Reply-To: <20221025120109.779337-1-festevam@gmail.com>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     kuba@kernel.org, andrew@lunn.ch, dmurphy@ti.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 25 Oct 2022 09:01:09 -0300 you wrote:
> During the bring-up of the Ethernet PHY, it is very useful to
> see the bootstrap status information, as it can help identifying
> hardware bootstrap mistakes.
> 
> Allow printing the SOR1 register, which contains the strap status
> to ease the bring-up.
> 
> [...]

Here is the summary with links:
  - [net-next] net: dp83822: Print the SOR1 strap status
    https://git.kernel.org/netdev/net-next/c/c926b4c3fa1f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


