Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19CD5623A74
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 04:30:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbiKJDa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 22:30:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232636AbiKJDaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 22:30:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F2A28E3D
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 19:30:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7408ECE2083
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 03:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B1D91C433D6;
        Thu, 10 Nov 2022 03:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668051018;
        bh=K+8a66hs8qAIAe/6tZ9tl3yQ2XhnG4uFdwh/r7DvqNo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WeFd2Yjzi/5eYvTaMuyEua8jd+tCzL3wCoXpYUX5fqOt94XV88kpPN23+ioUW8YVx
         182+rWgk4qI6owhTCf1QqMxRaLzmqpTPUbIpOYd3dV2mxc1gAEPHrj8l8Y+y9AD0c5
         kqivFBKyIPoNt2BSRQmIC6aOvBegYgd1H1VabPrJXYoweQ6B9CHBYTJ6CJozg0dohj
         t2vUJnL8lN8CsXeOpHy2CfRjulwyGm75sFyrZKNGqyWthPWbEXt7Xvx1U14Xuc2dA7
         utL8fhVBoczAxxZqHfiKbaDSxVpSoAMuRaOYxpPOmee4nvNW3HdWWGCFzL6WHunGtf
         dtJnMR7SKKLCQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9933AC395FE;
        Thu, 10 Nov 2022 03:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/15] mlxsw: Add 802.1X and MAB offload support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166805101862.26797.801225756307788281.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Nov 2022 03:30:18 +0000
References: <cover.1667902754.git.petrm@nvidia.com>
In-Reply-To: <cover.1667902754.git.petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ivecera@redhat.com, netdev@vger.kernel.org,
        razor@blackwall.org, roopa@nvidia.com, jiri@nvidia.com,
        bridge@lists.linux-foundation.org, idosch@nvidia.com,
        netdev@kapio-technology.com, mlxsw@nvidia.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 8 Nov 2022 11:47:06 +0100 you wrote:
> Ido Schimmel <idosch@nvidia.com> writes:
> 
> This patchset adds 802.1X [1] and MAB [2] offload support in mlxsw.
> 
> Patches #1-#3 add the required switchdev interfaces.
> 
> Patches #4-#5 add the required packet traps for 802.1X.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] bridge: switchdev: Let device drivers determine FDB offload indication
    https://git.kernel.org/netdev/net-next/c/9baedc3c8780
  - [net-next,02/15] bridge: switchdev: Allow device drivers to install locked FDB entries
    https://git.kernel.org/netdev/net-next/c/27fabd02abf3
  - [net-next,03/15] bridge: switchdev: Reflect MAB bridge port flag to device drivers
    https://git.kernel.org/netdev/net-next/c/9c0ca02bace4
  - [net-next,04/15] devlink: Add packet traps for 802.1X operation
    https://git.kernel.org/netdev/net-next/c/2640a82bbc08
  - [net-next,05/15] mlxsw: spectrum_trap: Register 802.1X packet traps with devlink
    https://git.kernel.org/netdev/net-next/c/d85be0f5fd7c
  - [net-next,06/15] mlxsw: reg: Add Switch Port FDB Security Register
    https://git.kernel.org/netdev/net-next/c/0b31fb9ba2b5
  - [net-next,07/15] mlxsw: spectrum: Add an API to configure security checks
    https://git.kernel.org/netdev/net-next/c/dc0d1a8b7f84
  - [net-next,08/15] mlxsw: spectrum_switchdev: Prepare for locked FDB notifications
    https://git.kernel.org/netdev/net-next/c/b72cb660b26b
  - [net-next,09/15] mlxsw: spectrum_switchdev: Add support for locked FDB notifications
    https://git.kernel.org/netdev/net-next/c/5a660e43f8b9
  - [net-next,10/15] mlxsw: spectrum_switchdev: Use extack in bridge port flag validation
    https://git.kernel.org/netdev/net-next/c/136b8dfbd784
  - [net-next,11/15] mlxsw: spectrum_switchdev: Add locked bridge port support
    https://git.kernel.org/netdev/net-next/c/25ed80884ce1
  - [net-next,12/15] selftests: devlink_lib: Split out helper
    https://git.kernel.org/netdev/net-next/c/da23a713d1de
  - [net-next,13/15] selftests: mlxsw: Add a test for EAPOL trap
    https://git.kernel.org/netdev/net-next/c/25a26f0c2015
  - [net-next,14/15] selftests: mlxsw: Add a test for locked port trap
    https://git.kernel.org/netdev/net-next/c/fb398432db2f
  - [net-next,15/15] selftests: mlxsw: Add a test for invalid locked bridge port configurations
    https://git.kernel.org/netdev/net-next/c/cdbde7edf0e5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


