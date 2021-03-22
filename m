Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 849E634509F
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbhCVUUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:20:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231130AbhCVUUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:20:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2F70461998;
        Mon, 22 Mar 2021 20:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616444408;
        bh=/8DrwxSJXkWp1kP+zw98hn/+/RQ4+FdN7ILQ6bhLpdA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ou2o7pBb8NgpdYjxhZc/yoszBF34mJTZeUUD0TWVL65e+QKdjUIPRBc3LvHdAawnc
         k2XSo/w1e6J+lEJf0Z+I2AsyMft83mpYoa37WurjwXwk5FnodT6IcIXZdmC/BPl20v
         /0/QawVdYyF/1Wh+E3EDBsMLn8TV5UJWqfROm3pFyVljOr3am60uWEG3AbkaWoXexL
         2FnFb1hbUi/fbjhkVJJVN88PBUyCHdqmSIGTnaPrpcLvZlDeq2iMdUk8Q/MFocrUBy
         dMTRuMWoO0SH+6h3N5x9a7Xjny8BkfwDhH/MeLTMQCEUamrPYgYAQvcAYnxFojrsJS
         eTGXhqA/ysmHQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1ECD060A70;
        Mon, 22 Mar 2021 20:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: bridge: declare br_vlan_tunnel_lookup argument
 tunnel_id as __be64
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161644440812.26518.17110056440678618651.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Mar 2021 20:20:08 +0000
References: <20210322103819.3723179-1-olteanv@gmail.com>
In-Reply-To: <20210322103819.3723179-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        roopa@nvidia.com, nikolay@nvidia.com, vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 22 Mar 2021 12:38:19 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The only caller of br_vlan_tunnel_lookup, br_handle_ingress_vlan_tunnel,
> extracts the tunnel_id from struct ip_tunnel_info::struct ip_tunnel_key::
> tun_id which is a __be64 value.
> 
> The exact endianness does not seem to matter, because the tunnel id is
> just used as a lookup key for the VLAN group's tunnel hash table, and
> the value is not interpreted directly per se. Moreover,
> rhashtable_lookup_fast treats the key argument as a const void *.
> 
> [...]

Here is the summary with links:
  - [net-next] net: bridge: declare br_vlan_tunnel_lookup argument tunnel_id as __be64
    https://git.kernel.org/netdev/net-next/c/f5fcca89f59c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


