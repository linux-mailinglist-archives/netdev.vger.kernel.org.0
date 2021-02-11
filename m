Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7C553194DA
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 22:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbhBKVKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 16:10:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:59918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhBKVKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 16:10:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0FC9A64E3C;
        Thu, 11 Feb 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613077810;
        bh=RANnAEIX4udOozDxyVvM6+xJLGuolLOE951RbQJdOW4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hJem8Gc+3LlEpeBj7UBXsRp0BaE+IOAuBRhYJR510EtBFzZ/GgT3wljD1hhEqi4mA
         oA4yQa4g8shEe3a+I40lbeMJXTiH5FjPoKEXsU+re4sSzfkHdrTVE79bd0EvVgQK3K
         KQuhxlF/XpVj7CavHYgf60LzlvGI28Wj3EPYl0HYHfUnZKYbt5SyW+s0bj+G0yKcZF
         hnk/Zxf0SRMVKAdz2n5vcUGlVQnzyYXppPgu331nVyGdt4JIoYhBJ+H6VeB6tVLg3F
         uR95AkCIONDhQgGwplUysT1locWdpKM2O1l94ylFh/9/hnzBZTYE8mNjRw9OdEvYKS
         ddyUMMz0bEStw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 00C0A60951;
        Thu, 11 Feb 2021 21:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7][pull request] 40GbE Intel Wired LAN Driver
 Updates 2021-02-10
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161307780999.4804.16367743746327065658.git-patchwork-notify@kernel.org>
Date:   Thu, 11 Feb 2021 21:10:09 +0000
References: <20210210232436.4084373-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210210232436.4084373-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 10 Feb 2021 15:24:29 -0800 you wrote:
> This series contains updates to i40e driver only.
> 
> Arkadiusz adds support for software controlled DCB. Upon disabling of the
> firmware LLDP agent, the driver configures DCB with default values
> (only one Traffic Class). At the same time, it allows a software based
> LLDP agent - userspace application i.e. lldpad) to receive DCB TLVs
> and set desired DCB configuration through DCB related netlink callbacks.
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] i40e: Add hardware configuration for software based DCB
    https://git.kernel.org/netdev/net-next/c/90bc8e003be2
  - [net-next,2/7] i40e: Add init and default config of software based DCB
    https://git.kernel.org/netdev/net-next/c/4b208eaa8078
  - [net-next,3/7] i40e: Add netlink callbacks support for software based DCB
    https://git.kernel.org/netdev/net-next/c/5effa78e7c94
  - [net-next,4/7] i40e: Add EEE status getting & setting implementation
    https://git.kernel.org/netdev/net-next/c/95f352dca19d
  - [net-next,5/7] i40e: Add flow director support for IPv6
    https://git.kernel.org/netdev/net-next/c/efca91e89b67
  - [net-next,6/7] i40e: VLAN field for flow director
    https://git.kernel.org/netdev/net-next/c/a9219b332f52
  - [net-next,7/7] i40e: remove the useless value assignment in i40e_clean_adminq_subtask
    https://git.kernel.org/netdev/net-next/c/bfe2e5c44d72

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


