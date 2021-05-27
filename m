Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7744F39246D
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 03:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234589AbhE0Blp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 21:41:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:36854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233460AbhE0Bln (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 21:41:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BD38A613CA;
        Thu, 27 May 2021 01:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622079611;
        bh=36xc4ziP1cL9E7ISODiIhk4dfMNqlvis3UOMnlo2BR4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=up8hstGG0/iJIXm/YDfMZ0SOLzOTO0K8QSCfHdT6TqOsRaMfmObdbqJbfMvJZ/dL8
         dpFPstyMQwUXRGzuoGgLF3X+uiSMvCexLlKY1bomgCf25rrwOFL/yYQpII+rAOdADm
         HMGd5bizwOi4K2CQ6vuLPeStHCW7v7Imby0CQiuH5ca8FNtAc3mLkEObWudTIeejgp
         conGlk+eW8BAx/fWgAkL1XiuNsq3A4wP77gkkrFg+kULiS7um3lnKjBnWk6GivjVLv
         rQ+jLiVaE6OoQWzAUGm3fcJeG9+80soR+6eGuDWNlZcR+6zsj6szrgFUDf56hsdyDD
         nuAXhP3qIUVPA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B0B1E609B2;
        Thu, 27 May 2021 01:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/11][pull request] 1GbE Intel Wired LAN Driver
 Updates 2021-05-26
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162207961171.7975.3781366941146096580.git-patchwork-notify@kernel.org>
Date:   Thu, 27 May 2021 01:40:11 +0000
References: <20210526172346.3515587-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210526172346.3515587-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com, jesse.brandeburg@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 26 May 2021 10:23:35 -0700 you wrote:
> Jesse Brandeburg says:
> 
> In this series I address the C=2 (sparse) warnings. The goal is to be
> completely sparse clean in the drivers/net/ethernet/intel directory.
> This can help us run this tool for every patch, and helps the kernel
> code by reducing technical debt.
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] e100: handle eeprom as little endian
    https://git.kernel.org/netdev/net-next/c/d4ef55288aa2
  - [net-next,02/11] intel: remove checker warning
    https://git.kernel.org/netdev/net-next/c/c40591cc3d48
  - [net-next,03/11] fm10k: move error check
    https://git.kernel.org/netdev/net-next/c/0a5d8a9d226f
  - [net-next,04/11] igb/igc: use strongly typed pointer
    https://git.kernel.org/netdev/net-next/c/88c228b22e00
  - [net-next,05/11] igb: handle vlan types with checker enabled
    https://git.kernel.org/netdev/net-next/c/c7cbfb028b95
  - [net-next,06/11] igb: fix assignment on big endian machines
    https://git.kernel.org/netdev/net-next/c/b514958dd1a3
  - [net-next,07/11] igb: override two checker warnings
    https://git.kernel.org/netdev/net-next/c/9fb8602e565d
  - [net-next,08/11] intel: call csum functions with well formatted arguments
    https://git.kernel.org/netdev/net-next/c/de8447131d2b
  - [net-next,09/11] igbvf: convert to strongly typed descriptors
    https://git.kernel.org/netdev/net-next/c/b6ce4a1c4ba4
  - [net-next,10/11] ixgbe: use checker safe conversions
    https://git.kernel.org/netdev/net-next/c/b16dc6c2f178
  - [net-next,11/11] ixgbe: reduce checker warnings
    https://git.kernel.org/netdev/net-next/c/205523bc06ce

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


