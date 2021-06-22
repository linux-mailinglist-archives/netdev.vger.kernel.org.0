Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964223B0BDA
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232443AbhFVRwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230338AbhFVRwW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 13:52:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0A4C861289;
        Tue, 22 Jun 2021 17:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624384206;
        bh=+X26jWrn502XmJ+RVNJ/cH7Ls9UO1egNbWvPBFfoy6k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DiGOOjrgsN6z077gs8nEyTX4IRNIFlxllDeuWMFKLy6JwmVkV96PcvdoI37OdglgN
         g/fgfirD8c+A8Uxm6paie06t2yf1NReof1HjX4cyOTwvMmss3YOWcVRpGiP4SfR0Cz
         nFJi/vkq47XNgW9KVj0ItdBC2shXOvr6WP0FDfI6/ay2f2sks1s/73Op+hRs2BGXNQ
         xJ5YzL5jLAVv1FdjbdvowqOJLoBkxSw6IuJguSWjPPZqAk5AAnr3tUfo41mf30tPQ0
         moTkCPclYqz7xQOiZhihzKcAdW3G2olcAFmH9nb3ciVb/1iYx7bVcQLUzD3fW609sA
         6FKUCb9E9AvKQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EE48F609FF;
        Tue, 22 Jun 2021 17:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] ethtool: Module EEPROM API improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162438420597.559.1800354365880832465.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Jun 2021 17:50:05 +0000
References: <20210622065052.2545107-1-idosch@idosch.org>
In-Reply-To: <20210622065052.2545107-1-idosch@idosch.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        andrew@lunn.ch, vladyslavt@nvidia.com, mkubecek@suse.cz,
        moshe@nvidia.com, mlxsw@nvidia.com, idosch@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 22 Jun 2021 09:50:45 +0300 you wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> This patchset contains various improvements to recently introduced
> module EEPROM netlink API. Noticed these while adding module EEPROM
> write support.
> 
> Ido Schimmel (7):
>   ethtool: Use correct command name in title
>   ethtool: Document correct attribute type
>   ethtool: Decrease size of module EEPROM get policy array
>   ethtool: Document behavior when module EEPROM bank attribute is
>     omitted
>   ethtool: Use kernel data types for internal EEPROM struct
>   ethtool: Validate module EEPROM length as part of policy
>   ethtool: Validate module EEPROM offset as part of policy
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] ethtool: Use correct command name in title
    https://git.kernel.org/netdev/net-next/c/78c57f22e3c8
  - [net-next,2/7] ethtool: Document correct attribute type
    https://git.kernel.org/netdev/net-next/c/913d026fbfaf
  - [net-next,3/7] ethtool: Decrease size of module EEPROM get policy array
    https://git.kernel.org/netdev/net-next/c/f5fe211d13af
  - [net-next,4/7] ethtool: Document behavior when module EEPROM bank attribute is omitted
    https://git.kernel.org/netdev/net-next/c/37a025e83902
  - [net-next,5/7] ethtool: Use kernel data types for internal EEPROM struct
    https://git.kernel.org/netdev/net-next/c/b8c48be23c2d
  - [net-next,6/7] ethtool: Validate module EEPROM length as part of policy
    https://git.kernel.org/netdev/net-next/c/0dc7dd02ba7a
  - [net-next,7/7] ethtool: Validate module EEPROM offset as part of policy
    https://git.kernel.org/netdev/net-next/c/88f9a87afeee

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


