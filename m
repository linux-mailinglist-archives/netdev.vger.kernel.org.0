Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D47B0624879
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 18:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbiKJRkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 12:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiKJRkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 12:40:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4DD27CF5;
        Thu, 10 Nov 2022 09:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EBF99CE2372;
        Thu, 10 Nov 2022 17:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E8358C433D7;
        Thu, 10 Nov 2022 17:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668102015;
        bh=mCBZeu1UKfBTGKLzNtrd5QDJXxYz4sjgKPhxwROpVXc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DVtgtd1rrsdiKHilhMtOnAkfnVRx1s5D8ViHpLr0dxq1PtCdCTp566TFSIXfedAGb
         4ThZ8tqDbJi6rPbkFs/oR9ddAA/lcfF/wMw61AX+5VIj1Wd57s4oEH8lNt1yp16Sl7
         olZVhv7qPNEMNVzkcBnyG6abO3bhzDX6uOT8bRPZlicG4Kfuq1xK/SqeRQJX8OWjVh
         ObqysF+mZGZnsasAosR/vww33oNAiOMY3g4E4sd34vcpjMGJ4X2F7ik7Y4zl+PVXm7
         peEIXd8wl6NnD/3NeqvwLD5pi1Yx8kKs9WaD8W241kIEMDmppBNkFSE21RfYp4EpQ6
         86CC9jcxLCblw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CA7ACE270F0;
        Thu, 10 Nov 2022 17:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v1] ethtool: ethtool_get_drvinfo: populate drvinfo
 fields even if callback exits
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166810201482.23079.18183213158036664655.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Nov 2022 17:40:14 +0000
References: <20221108035754.2143-1-mailhol.vincent@wanadoo.fr>
In-Reply-To: <20221108035754.2143-1-mailhol.vincent@wanadoo.fr>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, huangguangbin2@huawei.com,
        chenhao288@hisilicon.com, sean.anderson@seco.com, trix@redhat.com,
        xiangxia.m.yue@gmail.com, wsa+renesas@sang-engineering.com,
        marco@mebeim.net, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  8 Nov 2022 12:57:54 +0900 you wrote:
> If ethtool_ops::get_drvinfo() callback isn't set,
> ethtool_get_drvinfo() will fill the ethtool_drvinfo::name and
> ethtool_drvinfo::bus_info fields.
> 
> However, if the driver provides the callback function, those two
> fields are not touched. This means that the driver has to fill these
> itself.
> 
> [...]

Here is the summary with links:
  - [net-next,v1] ethtool: ethtool_get_drvinfo: populate drvinfo fields even if callback exits
    https://git.kernel.org/netdev/net-next/c/edaf5df22cb8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


