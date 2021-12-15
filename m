Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16607475B78
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 16:12:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243711AbhLOPKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 10:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243502AbhLOPKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 10:10:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DBE6C061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 07:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 350506195A
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 15:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 99256C34606;
        Wed, 15 Dec 2021 15:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639581012;
        bh=wQe4HLHiZEJYTpLAuMvuPLyYGiZ7zwR1LINqcZOBgEg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Rck2hFAuKU1vbZOzj/+in7mu3w5CfJaq1rrJdQm1TFYtpYtYYz8LHhiq+Dh43kClD
         eIVT3M6aUtIJSDPmTQJYL0rgsMpChMwjOsBsnGNqtPKvVS2Tb0H662Cl+cIkQOcRuT
         kh6gQJuWTS61CpqDXud7ih1EjVb9IUhdF1uxfiRfMp1d9kLEFg7PZsc9LWUtIgroLK
         2zE1EvJOo78qRN3SNeR9j6Q7rxkpwh3Jwu1JoYJv2a9NhUxUfBPinwe1565EkIvg4V
         JJ7Dg9tkWa9Ax6sF2H8At2+KQs2H+Ieu18VckpS/kY0Ttz/KPiHm1ueAzpffmfA5Km
         Mb+t7n75n5q8Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8859C60A4F;
        Wed, 15 Dec 2021 15:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] mlxsw: Add support for VxLAN with IPv6 underlay
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163958101255.23013.4040471877048572145.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Dec 2021 15:10:12 +0000
References: <20211214142551.606542-1-idosch@nvidia.com>
In-Reply-To: <20211214142551.606542-1-idosch@nvidia.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        amcohen@nvidia.com, petrm@nvidia.com, mlxsw@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 14 Dec 2021 16:25:43 +0200 you wrote:
> So far, mlxsw only supported VxLAN with IPv4 underlay. This patchset
> extends mlxsw to also support VxLAN with IPv6 underlay. The main
> difference is related to the way IPv6 addresses are handled by the
> device. See patch #1 for a detailed explanation.
> 
> Patch #1 creates a common hash table to store the mapping from IPv6
> addresses to KVDL indexes. This table is useful for both IP-in-IP and
> VxLAN tunnels with an IPv6 underlay.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] mlxsw: spectrum: Add hash table for IPv6 address mapping
    https://git.kernel.org/netdev/net-next/c/e846efe2737b
  - [net-next,2/8] mlxsw: spectrum_ipip: Use common hash table for IPv6 address mapping
    https://git.kernel.org/netdev/net-next/c/cf42911523e0
  - [net-next,3/8] mlxsw: spectrum_nve_vxlan: Make VxLAN flags check per address family
    https://git.kernel.org/netdev/net-next/c/720d683cbe8b
  - [net-next,4/8] mlxsw: Split handling of FDB tunnel entries between address families
    https://git.kernel.org/netdev/net-next/c/1fd85416e3b5
  - [net-next,5/8] mlxsw: reg: Add a function to fill IPv6 unicast FDB entries
    https://git.kernel.org/netdev/net-next/c/4b08c3e676b1
  - [net-next,6/8] mlxsw: spectrum_nve: Keep track of IPv6 addresses used by FDB entries
    https://git.kernel.org/netdev/net-next/c/0860c7641634
  - [net-next,7/8] mlxsw: Add support for VxLAN with IPv6 underlay
    https://git.kernel.org/netdev/net-next/c/06c08f869c0e
  - [net-next,8/8] selftests: mlxsw: vxlan: Remove IPv6 test case
    https://git.kernel.org/netdev/net-next/c/fb488be8c28d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


