Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84D1764531E
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 05:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiLGEk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 23:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiLGEkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 23:40:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9F9E56EE6
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 20:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 55CA461A18
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 04:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8737FC43470;
        Wed,  7 Dec 2022 04:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670388016;
        bh=8C/lJTVQMdPXqiWQ6YdAbjArwkD9z1Zq8KoDiAafbIU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gxZagwgSf2wxTlAvDg3CROINzfGqJtKtY1Rcjt4amfVV88icFswC2dQe3qYpJQ1hL
         COQmQ/rNs0kASGdLKFDn37OsCKgeAeb4QssHuxM6ApzGLqSdfLDOglVM9hJVaElhI1
         xeiR3ty0FPA2zlIyQEpXesSTTkF4Z+ECDJrUJW+q7Iim0kE890DL53reaV3ZNi7z/U
         e3xC02UPrYf8lcrVRafIsloJBRBMsfXbacaZcZ7tiVLC4+ZDZIJ+8QAS/1MQmh+5aV
         OPvmrav6oVOzwMdlG3zlqiDkw0lqpUz9jfO95G455LOEUDc2kXY3cQK0eDcbWQ1nop
         oViBdUC1XeXZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 61F7BE4D02C;
        Wed,  7 Dec 2022 04:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] ipv4: Two bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167038801639.19727.8599688624920791761.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Dec 2022 04:40:16 +0000
References: <20221204075045.3780097-1-idosch@nvidia.com>
In-Reply-To: <20221204075045.3780097-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, dsahern@kernel.org,
        mark.tomlinson@alliedtelesis.co.nz, sharpd@nvidia.com,
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  4 Dec 2022 09:50:43 +0200 you wrote:
> Two small fixes for bugs in IPv4 routing code.
> 
> A variation of the second bug was reported by an FRR 5.0 (released
> 06/18) user as this version was setting a table ID of 0 for the default
> VRF, unlike iproute2 and newer FRR versions.
> 
> The first bug was discovered while fixing the second.
> 
> [...]

Here is the summary with links:
  - [net,1/2] ipv4: Fix incorrect route flushing when source address is deleted
    https://git.kernel.org/netdev/net/c/f96a3d74554d
  - [net,2/2] ipv4: Fix incorrect route flushing when table ID 0 is used
    https://git.kernel.org/netdev/net/c/c0d999348e01

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


