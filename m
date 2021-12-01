Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDAF84650AD
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 16:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346117AbhLAPDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 10:03:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57372 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234427AbhLAPDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 10:03:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13B85B81FE7
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 15:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF851C53FCF;
        Wed,  1 Dec 2021 15:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638370816;
        bh=KHwM3gqHYdctEom8HypJnOrFbufKLa/BxeYtOkF2MGk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CfPSksOW9poItNpMojnaE7qcaQRFTtOdyc4DKbQJzmvBTGWQgCYoPFxoiAYdf0i8g
         QYfSi4OjPBX6wA1vzs6nY9FAiJni6S+YiZ/pkuuuT9ow2TrkaLZ1KbNGC2cO+oGkJH
         P9/DRjdpG4Lvg0VmrajykYDRwZDT3ZrBSbKyS4fr1A3cNm0NKrj3RcV6K9+XU+2sDi
         mPpoe0WYoget1v3cvyRK7cHje3nDntT0m353Q09Tog37WrWrsTsmI9ol6ZRp5y2L/E
         dSVx3F0YziwIc+AdLzLAphtEv0WB2Em4TEnVDxYVSaL4EhPfMXc+GDPTQDFweAUn0X
         kavytqNeKvxYg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id AABFB60BE3;
        Wed,  1 Dec 2021 15:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] mlxsw: Spectrum-4 preparations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163837081669.15182.316558560943506127.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Dec 2021 15:00:16 +0000
References: <20211201081240.3767366-1-idosch@idosch.org>
In-Reply-To: <20211201081240.3767366-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  1 Dec 2021 10:12:30 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> The Spectrum-4 ASIC will support more than 256 ports, unlike existing
> ASICs. As such, various device registers were extended with two
> additional bits to encode a 10 bit local port. In some cases, new
> (Version 2) registers were introduced.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] mlxsw: spectrum: Bump minimum FW version to xx.2010.1006
    https://git.kernel.org/netdev/net-next/c/2cb310dc4402
  - [net-next,02/10] mlxsw: reg: Remove unused functions
    https://git.kernel.org/netdev/net-next/c/b25dea489b55
  - [net-next,03/10] mlxsw: item: Add support for local_port field in a split form
    https://git.kernel.org/netdev/net-next/c/fda39347d90f
  - [net-next,04/10] mlxsw: reg: Align existing registers to use extended local_port field
    https://git.kernel.org/netdev/net-next/c/fd24b29a1b74
  - [net-next,05/10] mlxsw: reg: Increase 'port_num' field in PMTDB register
    https://git.kernel.org/netdev/net-next/c/da56f1a0d2a5
  - [net-next,06/10] mlxsw: reg: Adjust PPCNT register to support local port 255
    https://git.kernel.org/netdev/net-next/c/242e696e035f
  - [net-next,07/10] mlxsw: Use u16 for local_port field instead of u8
    https://git.kernel.org/netdev/net-next/c/c934757d9000
  - [net-next,08/10] mlxsw: Add support for more than 256 ports in SBSR register
    https://git.kernel.org/netdev/net-next/c/f8538aec88b4
  - [net-next,09/10] mlxsw: Use Switch Flooding Table Register Version 2
    https://git.kernel.org/netdev/net-next/c/e86ad8ce5bed
  - [net-next,10/10] mlxsw: Use Switch Multicast ID Register Version 2
    https://git.kernel.org/netdev/net-next/c/51ef6b00798c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


