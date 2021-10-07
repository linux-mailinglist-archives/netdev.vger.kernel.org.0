Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031EF424B89
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 03:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240139AbhJGBMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 21:12:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230252AbhJGBMB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 21:12:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8B04D610FC;
        Thu,  7 Oct 2021 01:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633569008;
        bh=hXHlsYvh0ts99nidte6wL0KWYgFdPxq49F45WfGCep0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uW5omPdtKQ9dxsFYAbyX4q3FiRLa5DC01klNbLZPiuaZWalLHtevfQa55obfujRYr
         ZI0qgn894079GRUJ1xz95DjY/290xd139CcBAO1l4m1wWAxLIZbtIMg3SLJRWro1uo
         3Mzzb+FsZiMnpNMIH+SodNf5KyvWns4MNNu0qZ9I2chh++nItSH/BfPp/AwSR4Cs+X
         A1oZxlC/Zra7QkFCYHmxFxwqwto+IF+lP7woJWnRgoq2YfJoy3fyfatuiFH4cSrrkB
         3MiqtmikQFiq0E0GygtvhWQwOi5WgZWKYCqrrk8Nhmqb+x39MjN5fjNo4Jzwt23EjI
         VuyS+xBU11IKg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7B9CF60A39;
        Thu,  7 Oct 2021 01:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/6] ethtool: Add ability to control transceiver
 modules' power mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163356900850.5781.2836466708298272842.git-patchwork-notify@kernel.org>
Date:   Thu, 07 Oct 2021 01:10:08 +0000
References: <20211006104647.2357115-1-idosch@idosch.org>
In-Reply-To: <20211006104647.2357115-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, mkubecek@suse.cz, pali@kernel.org,
        jacob.e.keller@intel.com, jiri@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed,  6 Oct 2021 13:46:41 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patchset extends the ethtool netlink API to allow user space to
> control transceiver modules. Two specific APIs are added, but the plan
> is to extend the interface with more APIs in the future (see "Future
> plans").
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/6] ethtool: Add ability to control transceiver modules' power mode
    applied by Jakub Kicinski <kuba@kernel.org>
    https://git.kernel.org/netdev/net-next/c/353407d917b2
  - [net-next,v2,2/6] mlxsw: reg: Add Port Module Memory Map Properties register
    applied by Jakub Kicinski <kuba@kernel.org>
    https://git.kernel.org/netdev/net-next/c/f10ba086f7e3
  - [net-next,v2,3/6] mlxsw: reg: Add Management Cable IO and Notifications register
    applied by Jakub Kicinski <kuba@kernel.org>
    https://git.kernel.org/netdev/net-next/c/fc53f5fb8037
  - [net-next,v2,4/6] mlxsw: Add ability to control transceiver modules' power mode
    applied by Jakub Kicinski <kuba@kernel.org>
    https://git.kernel.org/netdev/net-next/c/0455dc50bcca
  - [net-next,v2,5/6] ethtool: Add transceiver module extended state
    applied by Jakub Kicinski <kuba@kernel.org>
    https://git.kernel.org/netdev/net-next/c/3dfb51126064
  - [net-next,v2,6/6] mlxsw: Add support for transceiver module extended state
    applied by Jakub Kicinski <kuba@kernel.org>
    https://git.kernel.org/netdev/net-next/c/235dbbec7d72

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


