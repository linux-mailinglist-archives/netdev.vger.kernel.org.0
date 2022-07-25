Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D68157FF9F
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 15:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234115AbiGYNKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 09:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233500AbiGYNKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 09:10:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1352AFC
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 06:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90BEDB80EBD
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 13:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2D013C341CD;
        Mon, 25 Jul 2022 13:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658754616;
        bh=/wRz2VzwOEqgIG5aIhpyf8u6cf/iltL5J2JgCYUEqRo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qbWRNCnMol48JpIz4qHePa2lZUn8Lb1XftJt5uKrbPyhW5ryVqIVSpOJA4b9J2VKU
         Cjs+j36opf7Kg6Y3Jzx/X8QV9KE8ychAEAPTtWO1IVVfAhCNgcCvMq5OkAN/r/nH2b
         t0BYbm+Qz+e3OJwEwArE+zJAJ6wuI7P8OgfQcjUtJNV8W3CQ0qh89UQx17IwUrwUF2
         vE0ogDRU+W6JDmGKeoCewcGfUzWqN5eNYb0hoMbD5vB+wHuA80de+9m7+KYfxZH6Pn
         hvasJQ29qR3JBlx0hoBqrq1mjDHydF8z8XB6oP87qvckP8QauHWGBvG7q8DIjUWtFm
         MevMWi4XeXM3Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 04403E450B4;
        Mon, 25 Jul 2022 13:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/15] mlxsw: Spectrum-2 PTP preparations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165875461601.4294.2131579476587667849.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Jul 2022 13:10:16 +0000
References: <20220724080329.2613617-1-idosch@nvidia.com>
In-Reply-To: <20220724080329.2613617-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, petrm@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, richardcochran@gmail.com,
        mlxsw@nvidia.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 24 Jul 2022 11:03:14 +0300 you wrote:
> This patchset includes various preparations required for Spectrum-2 PTP
> support.
> 
> Most of the changes are non-functional (e.g., renaming, adding
> registers). The only intentional user visible change is in patch #10
> where the PHC time is initialized to zero in accordance with the
> recommendation of the PTP maintainer.
> 
> [...]

Here is the summary with links:
  - [net-next,01/15] mlxsw: Rename mlxsw_reg_mtptptp_pack() to mlxsw_reg_mtptpt_pack()
    https://git.kernel.org/netdev/net-next/c/1c358fedecd1
  - [net-next,02/15] mlxsw: reg: Add MTUTC register's fields for supporting PTP in Spectrum-2
    https://git.kernel.org/netdev/net-next/c/97b05cfb68ae
  - [net-next,03/15] mlxsw: reg: Add Monitoring Time Precision Correction Port Configuration Register
    https://git.kernel.org/netdev/net-next/c/731416e9ae5d
  - [net-next,04/15] mlxsw: pci_hw: Add 'time_stamp' and 'time_stamp_type' fields to CQEv2
    https://git.kernel.org/netdev/net-next/c/aa98487cc96b
  - [net-next,05/15] mlxsw: cmd: Add UTC related fields to query firmware command
    https://git.kernel.org/netdev/net-next/c/577d80238ff7
  - [net-next,06/15] mlxsw: Set time stamp type as part of config profile
    https://git.kernel.org/netdev/net-next/c/291fcb937e95
  - [net-next,07/15] mlxsw: spectrum: Fix the shift of FID field in TX header
    https://git.kernel.org/netdev/net-next/c/81016180e3f4
  - [net-next,08/15] mlxsw: resources: Add resource identifier for maximum number of FIDs
    https://git.kernel.org/netdev/net-next/c/448e9cb3631e
  - [net-next,09/15] mlxsw: Rename 'read_frc_capable' bit to 'read_clock_capable'
    https://git.kernel.org/netdev/net-next/c/33a9583f9a02
  - [net-next,10/15] mlxsw: spectrum_ptp: Initialize the clock to zero as part of initialization
    https://git.kernel.org/netdev/net-next/c/22d950b79ea7
  - [net-next,11/15] mlxsw: pci: Simplify FRC clock reading
    https://git.kernel.org/netdev/net-next/c/946832296389
  - [net-next,12/15] mlxsw: spectrum_ptp: Use 'struct mlxsw_sp_ptp_state' per ASIC
    https://git.kernel.org/netdev/net-next/c/e8fea346b556
  - [net-next,13/15] mlxsw: spectrum_ptp: Use 'struct mlxsw_sp_ptp_clock' per ASIC
    https://git.kernel.org/netdev/net-next/c/9bfe3c16fc23
  - [net-next,14/15] mlxsw: spectrum_ptp: Rename mlxsw_sp_ptp_get_message_types()
    https://git.kernel.org/netdev/net-next/c/4017d9296492
  - [net-next,15/15] mlxsw: spectrum_ptp: Rename mlxsw_sp1_ptp_phc_adjfreq()
    https://git.kernel.org/netdev/net-next/c/a168e13f8448

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


