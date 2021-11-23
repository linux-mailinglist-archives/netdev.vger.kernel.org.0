Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C376445A1E7
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 12:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236610AbhKWLxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 06:53:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:40966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236553AbhKWLxS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 06:53:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2C21361058;
        Tue, 23 Nov 2021 11:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637668210;
        bh=TXlKzkYqWBJk01fe6LTS5vQkhPwHOi1yrmeFUZhsc5Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JjeTXm4WVDUJwpy5RJWeH2k1lyD/IQwrTxUj6IW+nevjrtpnQzVKPqb/a+uVxdJlb
         q8F5/neHaG85eGbfAMVVU5MIxQU+ZfxL5V8Fgh26Lh/EmT2bpGJdADxqgvGpPQv6OE
         LnLl6S25j/1OV6j4dc86rYRq6TvKpSKcWsMNUUZPBCI485xgCU+PhIv0+RTaA/FzuV
         GV24FzfEQdx2dmXJVBjEbG4iLUGdyoZ5AMyFb0oJCN7JmbXUpEzfYnILxxW4vePVnb
         GMlG3J9dOLvy1zqzE00jG7mEpdFtUo+sRsye++grjIPL6zWXTWWVMsbxQ3TYggJNff
         Q6tykSp0RwAqA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 26ADA60A4E;
        Tue, 23 Nov 2021 11:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] mlxsw: Various updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163766821015.27860.2103851959936439606.git-patchwork-notify@kernel.org>
Date:   Tue, 23 Nov 2021 11:50:10 +0000
References: <20211123075447.3083579-1-idosch@idosch.org>
In-Reply-To: <20211123075447.3083579-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 23 Nov 2021 09:54:45 +0200 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> Patch #1 removes deadcode reported by Coverity.
> 
> Patch #2 adds a shutdown method in the PCI driver to ensure the kexeced
> kernel starts working with a device that is in a sane state.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] mlxsw: spectrum_router: Remove deadcode in mlxsw_sp_rif_mac_profile_find
    https://git.kernel.org/netdev/net-next/c/ed1607e2ddf4
  - [net-next,2/2] mlxsw: pci: Add shutdown method in PCI driver
    https://git.kernel.org/netdev/net-next/c/c1020d3cf475

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


