Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D31E6BDDA1
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 01:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbjCQAa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 20:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjCQAaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 20:30:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5CC3590
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 17:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82CEFB822EC
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 00:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 48AE2C433EF;
        Fri, 17 Mar 2023 00:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679013020;
        bh=S478N1pWf5+TR5/r0QWer5jug1OBW94VAAgKVNzaxi0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Zox+Vj51gnUGFqqgzA7Jkr5GS8ntGl+NS5XFGAqfBv+Uv08lJfjKYcugwQqUR3PqQ
         ysJq9cJwnwvz0LHnC/yth0ksG/ffJoxmF8PeO0C9njbRNABnINF0zBkk7G+TpA83ax
         32tbtC+3cxj/jKsoMwRQ25ZfmmR/CXKSkiWko8InmCDKcUu3gv5KIYTr+jdmzfChUf
         WroGcm8Dtq8YkLKkdQ7gHe4t/HH9TFTSKTBzhQAGpDPBgxkEpPjK+SJ41SRbeepC00
         Hn85EEswj+Zs/xTzoqPHHnMR+G06ubaah6BkHVJKdfqcabe1op9pYZeig3SgedFgHJ
         7QTzzHHcAnptw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 29D3FE66CBF;
        Fri, 17 Mar 2023 00:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ipv4: Fix incorrect table ID in IOCTL path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167901302015.26766.13860366542997278911.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 00:30:20 +0000
References: <20230315124009.4015212-1-idosch@nvidia.com>
In-Reply-To: <20230315124009.4015212-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, dsahern@kernel.org,
        mark.tomlinson@alliedtelesis.co.nz, gaoxingwang1@huawei.com,
        mlxsw@nvidia.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 15 Mar 2023 14:40:09 +0200 you wrote:
> Commit f96a3d74554d ("ipv4: Fix incorrect route flushing when source
> address is deleted") started to take the table ID field in the FIB info
> structure into account when determining if two structures are identical
> or not. This field is initialized using the 'fc_table' field in the
> route configuration structure, which is not set when adding a route via
> IOCTL.
> 
> [...]

Here is the summary with links:
  - [net] ipv4: Fix incorrect table ID in IOCTL path
    https://git.kernel.org/netdev/net/c/8a2618e14f81

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


