Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 263E56442D8
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 13:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235243AbiLFMEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 07:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235247AbiLFMDr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 07:03:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58BED29CA1
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 04:01:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5ED13616E2
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 12:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B6AA1C433D6;
        Tue,  6 Dec 2022 12:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670328015;
        bh=rK6FlOpKkSjERrktm3/JAUHT371nFTb8lVfJ/rWvPYw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J6yJ+hOP2ySB/R5eSDTQPV5Oiri0UmtMQeg68mlrTpmqo6dIk0G+IGykm5mypd2Ps
         7ijOPei2SVoChAnNDpHLTEdh7IBU8RE/zZ/4c9kfuM5AbbiAFOfeL3e1tBUruHSkrS
         m3kX3p+NfXH9L5InCEYyzzx2HVxM7pC6lwhB4lxPQddyM3SDDs3xh67EoTAPNAHxwQ
         rVVJ66uKhAUQuGT3ZYRtoTtD9krozAKft2Z1HC6qHrMcntj/Nz3DDa9YAsgRWZwNpo
         SQyF7HhsDlSLD8xs7AvxlP5l3v+BfS6lPGKExAHU06Ohu6k4SpQdebVsTkwhNByDQW
         e04YCknfxv5SQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9CEB7E56AA1;
        Tue,  6 Dec 2022 12:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: mdio: fix unbalanced fwnode reference count in
 mdio_device_release()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167032801563.16172.4290390805089674583.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Dec 2022 12:00:15 +0000
References: <20221203073441.3885317-1-zengheng4@huawei.com>
In-Reply-To: <20221203073441.3885317-1-zengheng4@huawei.com>
To:     Zeng Heng <zengheng4@huawei.com>
Cc:     hkallweit1@gmail.com, edumazet@google.com, pabeni@redhat.com,
        kuba@kernel.org, davem@davemloft.net, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@armlinux.org.uk, liwei391@huawei.com,
        netdev@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Sat, 3 Dec 2022 15:34:41 +0800 you wrote:
> There is warning report about of_node refcount leak
> while probing mdio device:
> 
> OF: ERROR: memory leak, expected refcount 1 instead of 2,
> of_node_get()/of_node_put() unbalanced - destroy cset entry:
> attach overlay node /spi/soc@0/mdio@710700c0/ethernet@4
> 
> [...]

Here is the summary with links:
  - [v2] net: mdio: fix unbalanced fwnode reference count in mdio_device_release()
    https://git.kernel.org/netdev/net/c/cb37617687f2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


