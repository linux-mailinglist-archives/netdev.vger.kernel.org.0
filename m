Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2DF642731
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 12:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbiLELKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 06:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbiLELKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 06:10:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2504D17405
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 03:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF86B60C6F
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 11:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1D36AC433D6;
        Mon,  5 Dec 2022 11:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670238616;
        bh=cvcjaxwiRDba8+lW+GQbhnaelbYDxGVVVEFcufbRYqE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MpygJ00Sr1q0UuU8CyXzCeg3X1wgPWlUDGRZ2HuH/O3Wu63NnqeFlhCrytiqOi0On
         btuUrVm8ArUeKVN4U4foSPNu0il1xRahNneOZQdvUzZxgbHOR+YYNjYA9v/e77fqwM
         T6Yk8jY0IngaIEVfaDLYVYWZSImuWw5dRhDC217cgnqC8ZkXVWMFGTimx4zzVAjRdE
         TCfion0BG8w2MA5Cbp88e93+MD1t7QspdVHP7pP/eITl7DeDKVY2ElfuOGGoa/oe+g
         LMrIjIx9nrs9q3uKsL2qCkYXNs7+NgFt/vu/PNkGOmV5kJWFX8x84/DvVYtKVPUrEp
         zygtOX4eot21w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EDD23C395E5;
        Mon,  5 Dec 2022 11:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net: mdiobus: fix double put fwnode in the error path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167023861596.18576.2479015617199052939.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Dec 2022 11:10:15 +0000
References: <20221202051833.699945-1-yangyingliang@huawei.com>
In-Reply-To: <20221202051833.699945-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ioana.ciornei@nxp.com,
        calvin.johnson@oss.nxp.com, grant.likely@arm.com,
        zengheng4@huawei.com
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

On Fri, 2 Dec 2022 13:18:33 +0800 you wrote:
> If phy_device_register() or fwnode_mdiobus_phy_device_register()
> fail, phy_device_free() is called, the device refcount is decreased
> to 0, then fwnode_handle_put() will be called in phy_device_release(),
> but in the error path, fwnode_handle_put() has already been called,
> so set fwnode to NULL after fwnode_handle_put() in the error path to
> avoid double put.
> 
> [...]

Here is the summary with links:
  - [net,v3] net: mdiobus: fix double put fwnode in the error path
    https://git.kernel.org/netdev/net/c/165df24186ec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


