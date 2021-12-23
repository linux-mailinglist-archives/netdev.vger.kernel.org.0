Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B47F47E245
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 12:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347941AbhLWLaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 06:30:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50718 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347939AbhLWLaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 06:30:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9E9261E52
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 11:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 072FFC36AEA;
        Thu, 23 Dec 2021 11:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640259011;
        bh=Iwc6WkAlibjEtL2Tl8G9nkZGjdd2wr3JcXBmwPh3EN4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Uhco+O5gnFLUzKDVuKB8P8kz1K5ZULMFTdIv2RtOU7Eb2wCV/bQH9kOPp/9YHxvGc
         Jipb9Wg3h1D0/ybbQzI4uveRdrF2N2Zz3OYSkP27u95mV5TSH6AiyVkwHFl/kVmhnx
         3RAeIFo1aezT8/odVAQ4ano3uJ7Y+/DOsefPm8qlKNckQmgpcR81c+VEPrPWU9PxDd
         dlD8qtDDe0pG0O86CKEKSkoK1jq6119nxeCVHFpujeWQ9yHn1xtxAs7EMlRC5Tyyy3
         c10MIw3Uth5C29tu02EMcHSlAdA6h9a31JQPztnduze275GFyLT2uUjaoUo9lrAzYi
         oU6Ozup2TiHig==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DF844EAC067;
        Thu, 23 Dec 2021 11:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] mlxsw: Add tests for VxLAN with IPv6 underlay
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164025901090.907.2390969715522042066.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Dec 2021 11:30:10 +0000
References: <20211223073002.3733510-1-amcohen@nvidia.com>
In-Reply-To: <20211223073002.3733510-1-amcohen@nvidia.com>
To:     Amit Cohen <amcohen@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 23 Dec 2021 09:29:54 +0200 you wrote:
> mlxsw driver lately added support for VxLAN with IPv6 underlay.
> This set adds tests for IPv6, which are dedicated for mlxsw.
> 
> Patch set overview:
> Patches #1-#2 make vxlan.sh test more flexible and extend it for IPv6
> Patches #3-#4 make vxlan_fdb_veto.sh test more flexible and extend it
> for IPv6
> Patches #5-#6 add tests for VxLAN flooding for different ASICs
> Patches #7-#8 add test for VxLAN related traps and align the existing
> test
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] selftests: mlxsw: vxlan: Make the test more flexible for future use
    https://git.kernel.org/netdev/net-next/c/8e059d64bee4
  - [net-next,2/8] selftests: mlxsw: Add VxLAN configuration test for IPv6
    https://git.kernel.org/netdev/net-next/c/21d4282dc1b8
  - [net-next,3/8] selftests: mlxsw: vxlan_fdb_veto: Make the test more flexible for future use
    https://git.kernel.org/netdev/net-next/c/696285305b32
  - [net-next,4/8] selftests: mlxsw: Add VxLAN FDB veto test for IPv6
    https://git.kernel.org/netdev/net-next/c/1c7b183dac89
  - [net-next,5/8] selftests: mlxsw: spectrum: Add a test for VxLAN flooding with IPv6
    https://git.kernel.org/netdev/net-next/c/7ae23eddfa3e
  - [net-next,6/8] selftests: mlxsw: spectrum-2: Add a test for VxLAN flooding with IPv6
    https://git.kernel.org/netdev/net-next/c/d01724dd2a66
  - [net-next,7/8] selftests: mlxsw: Add test for VxLAN related traps for IPv6
    https://git.kernel.org/netdev/net-next/c/c777d726267c
  - [net-next,8/8] selftests: mlxsw: devlink_trap_tunnel_vxlan: Fix 'decap_error' case
    https://git.kernel.org/netdev/net-next/c/810ef9552dec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


