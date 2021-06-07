Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128D739E83F
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 22:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbhFGUVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 16:21:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231362AbhFGUVz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 16:21:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8861361159;
        Mon,  7 Jun 2021 20:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623097203;
        bh=fzdXm+91CW1zgd+OttrpPmM9CH6we+S6yzqHg7b83e4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oAsYCj3sgg1pLSF3RKEelQpysgi8scG5v8HyMtjDKEk4H+i59MEvSQA8Ek7XiBrf9
         V4yPEt+oChkJwNdXk06DOC+Yz/fe29B3yc4MRfMOwuk6nTB8jEactF4FADmsPnpH6u
         opcVfkIzW/ILfJyLfFX3apzTDQ7wbrSuNTJpzA6o/dydvJcauolT68tgs1r77GV+Ka
         8FAyxNCwnkJbSPoyjivH2O7TWYUxVAhkR1gjJM5yBP5lO3m1ulLeDAb/+oUsQw8Fin
         UyRedFzfzcI+gr1gsaPrIQn0xurjg7lB3dgzPMh8aX3H8IUfdzRI8DFQ4fE+mTK743
         MSBUUbsJVVVIg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 74CB260BFB;
        Mon,  7 Jun 2021 20:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ethtool: Fix NULL pointer dereference during module
 EEPROM dump
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162309720347.9512.9512055978020262902.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 20:20:03 +0000
References: <20210606142422.1589376-1-idosch@idosch.org>
In-Reply-To: <20210606142422.1589376-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        mkubecek@suse.cz, vladyslavt@nvidia.com, andrew@lunn.ch,
        moshe@nvidia.com, mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Sun,  6 Jun 2021 17:24:22 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> When get_module_eeprom_by_page() is not implemented by the driver, NULL
> pointer dereference can occur [1].
> 
> Fix by testing if get_module_eeprom_by_page() is implemented instead of
> get_module_info().
> 
> [...]

Here is the summary with links:
  - [net] ethtool: Fix NULL pointer dereference during module EEPROM dump
    https://git.kernel.org/netdev/net/c/51c96a561f24

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


