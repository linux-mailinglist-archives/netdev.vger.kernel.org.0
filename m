Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70964397D84
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 02:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235376AbhFBAME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 20:12:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235237AbhFBALu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 20:11:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 12563613CC;
        Wed,  2 Jun 2021 00:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622592608;
        bh=CrWdz25DNX/8aydsNxCTxPdu1CoQsOFO8Fc8OmO28EA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XWDD3+N3UQei+qSuYAh7GObqkral0ohdP4Q5hwWqc9/mQzOkYspwFxht7hoK4tEDX
         9UG37IsgzQZN6PKJhPRHHD5DFHYpF4Nj4cD38m9jH3c/M56LNHl5DIzPKf1dAQPxAv
         8KJtI76eLiJ4bE8BftqeJxekh7Ml7VxOsid88B4tjt8fDb/O8F++CMEcMpl4sIIZOG
         s9rdXRsAXZFBIJbaMKLosb/WhoLmWq4OgY6ck5iby6XZ473Ptsmgo9PfRogh1Qoizv
         4SCR+z/P7qmZE4gAZdm1DydOhrXdmt+H2vmkwOlgS44pAXCe9vUs2B/qwt5BVc/h/Q
         abty3iDOwLTLA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F2B9A60C28;
        Wed,  2 Jun 2021 00:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/7][pull request] iwl-next Intel Wired LAN Driver
 Updates 2021-06-01
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162259260798.22595.6107700603996156280.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 00:10:07 +0000
References: <20210601162644.1469616-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210601162644.1469616-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, dledford@redhat.com,
        jgg@mellanox.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, shiraz.saleem@intel.com,
        david.m.ertman@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue,  1 Jun 2021 09:26:37 -0700 you wrote:
> This pull request is targeting net-next and rdma-next branches.
> These patches have been reviewed by netdev and rdma mailing lists[1].
> 
> This series adds RDMA support to the ice driver for E810 devices and
> converts the i40e driver to use the auxiliary bus infrastructure
> for X722 devices. The PCI netdev drivers register auxiliary RDMA devices
> that will bind to auxiliary drivers registered by the new irdma module.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/7] i40e: Replace one-element array with flexible-array member
    https://git.kernel.org/netdev/net-next/c/125217e0967f
  - [net-next,v3,2/7] iidc: Introduce iidc.h
    https://git.kernel.org/netdev/net-next/c/e860fa9b69e1
  - [net-next,v3,3/7] ice: Initialize RDMA support
    https://git.kernel.org/netdev/net-next/c/d25a0fc41c1f
  - [net-next,v3,4/7] ice: Implement iidc operations
    https://git.kernel.org/netdev/net-next/c/348048e724a0
  - [net-next,v3,5/7] ice: Register auxiliary device to provide RDMA
    https://git.kernel.org/netdev/net-next/c/f9f5301e7e2d
  - [net-next,v3,6/7] i40e: Prep i40e header for aux bus conversion
    https://git.kernel.org/netdev/net-next/c/9ed753312121
  - [net-next,v3,7/7] i40e: Register auxiliary devices to provide RDMA
    https://git.kernel.org/netdev/net-next/c/f4370a85d62e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


