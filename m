Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA1E3AF672
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 21:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhFUTw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 15:52:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231501AbhFUTwV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 15:52:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4255F61352;
        Mon, 21 Jun 2021 19:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624305006;
        bh=FkKfTU57u0JH2tvXEZd3dXC2bahFlb+npzTuYq1zfi4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A/v8pfhMXqR5cECJ8wK3p9P9WEnC0wgmY3DzkWUmgVie/4Ty1qU+NiBH5n9VcCW2T
         tkmT0UDXvp6RFE++Vdw1CXiIZFavffNrIZe8XnOc0ygtsaJp0z91UjVrvAQsoNRinZ
         LgwLaC+iZj/LM5f/9BHhNIcWJwXuaHtgGP/KPqVNW4iTzqlYqdOt+C7R4w//I4DC4w
         9aWNuSccnWQDKKCznZWD6hXffbwFAdJWq9VFWVjZYyaPXYGV4BDoSWuj5lcI3nxgHv
         vJfFK1JEKYVYpWpNSKXOF4upk2kYCZZHVzo1GX02pNpbiMv4f7/mOoEjoI/zwPEULD
         d5XeLYIoGxmwQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 38E4A60A02;
        Mon, 21 Jun 2021 19:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] mlxsw: Add support for module EEPROM read by
 page
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162430500622.22375.6039834054469422102.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 19:50:06 +0000
References: <20210621075041.2502416-1-idosch@idosch.org>
In-Reply-To: <20210621075041.2502416-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, vadimp@nvidia.com, mlxsw@nvidia.com,
        idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 21 Jun 2021 10:50:38 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Add support for ethtool_ops::get_module_eeprom_by_page() operation.
> 
> Patch #1 adds necessary field in device register.
> 
> Patch #2 documents possible MCIA status values so that more meaningful
> error messages could be returned to user space via extack.
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] mlxsw: reg: Add bank number to MCIA register
    https://git.kernel.org/netdev/net-next/c/d51ea60e01f9
  - [net-next,2/3] mlxsw: reg: Document possible MCIA status values
    https://git.kernel.org/netdev/net-next/c/cecefb3a6eeb
  - [net-next,3/3] mlxsw: core: Add support for module EEPROM read by page
    https://git.kernel.org/netdev/net-next/c/1e27b9e40803

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


