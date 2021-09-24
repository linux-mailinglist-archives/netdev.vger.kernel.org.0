Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A66416F2B
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 11:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245291AbhIXJlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 05:41:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245241AbhIXJlm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Sep 2021 05:41:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 170D46105A;
        Fri, 24 Sep 2021 09:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632476410;
        bh=dcW20119vH1g7DvDy7ncF76BOF84GbJy27wK89ohvK8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QJdJKPwtmbOSUzKYIhFKDloVu4gEqGOL0otZK6zhQzsMEsTx0BDsRdrDUBugQ9CeU
         hf77qOCPyQDwbXGP3tHxx/R/VULg1jMS8x8a/zi3K4yK7C8UCsp39d2y/KIAUA31M3
         AU0Cwfk0blX8hw4T1mUh/f2O14Hwz1Ma5Gu+n+0hhiO9Zk0VZACUk0JRLB88f3MXty
         Ex8HJZNbqzrQeu3zfopWJGPQuu1E+6vs74ou5X6JfwYKVq0OkYSS7I7J2lzopuLVue
         rDn+378dtac4OS8XutXP/Cg2kFyZEWvgwhKiSG3tI2H3QerhEQPJNDu6hcQz/l4VV0
         NN9PWu2zUNiQw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1040D60AA4;
        Fri, 24 Sep 2021 09:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/14] mlxsw: Add support for IP-in-IP with IPv6
 underlay
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163247641006.26581.76537304639283935.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Sep 2021 09:40:10 +0000
References: <20210923123700.885466-1-idosch@idosch.org>
In-Reply-To: <20210923123700.885466-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        amcohen@nvidia.com, petrm@nvidia.com, jiri@nvidia.com,
        mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 23 Sep 2021 15:36:46 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Currently, mlxsw only supports IP-in-IP with IPv4 underlay. Traffic
> routed through 'gre' netdevs is encapsulated with IPv4 and GRE headers.
> Similarly, incoming IPv4 GRE packets are decapsulated and routed in the
> overlay VRF (which can be the same as the underlay VRF).
> 
> [...]

Here is the summary with links:
  - [net-next,01/14] mlxsw: spectrum_router: Create common function for fib_entry_type_unset() code
    https://git.kernel.org/netdev/net-next/c/45bce5c99d46
  - [net-next,02/14] mlxsw: spectrum_ipip: Pass IP tunnel parameters by reference and as 'const'
    https://git.kernel.org/netdev/net-next/c/aa6fd8f177d6
  - [net-next,03/14] mlxsw: spectrum_router: Fix arguments alignment
    https://git.kernel.org/netdev/net-next/c/8aba32cea3f3
  - [net-next,04/14] mlxsw: spectrum_ipip: Create common function for mlxsw_sp_ipip_ol_netdev_change_gre()
    https://git.kernel.org/netdev/net-next/c/80ef2abcddbc
  - [net-next,05/14] mlxsw: Take tunnel's type into account when searching underlay device
    https://git.kernel.org/netdev/net-next/c/59bf980dd90f
  - [net-next,06/14] mlxsw: reg: Add Router IP version Six Register
    https://git.kernel.org/netdev/net-next/c/dd8a9552d484
  - [net-next,07/14] mlxsw: reg: Add support for rtdp_ipip6_pack()
    https://git.kernel.org/netdev/net-next/c/a917bb271d16
  - [net-next,08/14] mlxsw: reg: Add support for ratr_ipip6_entry_pack()
    https://git.kernel.org/netdev/net-next/c/c729ae8d6cbc
  - [net-next,09/14] mlxsw: reg: Add support for ritr_loopback_ipip6_pack()
    https://git.kernel.org/netdev/net-next/c/36c2ab890b8f
  - [net-next,10/14] mlxsw: Create separate ipip_ops_arr for different ASICs
    https://git.kernel.org/netdev/net-next/c/a82feba686e8
  - [net-next,11/14] mlxsw: spectrum_ipip: Add mlxsw_sp_ipip_gre6_ops
    https://git.kernel.org/netdev/net-next/c/713e8502fd3e
  - [net-next,12/14] mlxsw: Add IPV6_ADDRESS kvdl entry type
    https://git.kernel.org/netdev/net-next/c/53eedd61dea9
  - [net-next,13/14] mlxsw: spectrum_router: Increase parsing depth for IPv6 decapsulation
    https://git.kernel.org/netdev/net-next/c/8d4f10463cd6
  - [net-next,14/14] mlxsw: Add support for IP-in-IP with IPv6 underlay for Spectrum-2 and above
    https://git.kernel.org/netdev/net-next/c/ba1c71324bc2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


