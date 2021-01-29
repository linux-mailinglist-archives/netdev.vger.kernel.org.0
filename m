Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 925FB3084B1
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 05:52:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231963AbhA2EvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 23:51:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:52840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231948AbhA2Euz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Jan 2021 23:50:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 783D064E00;
        Fri, 29 Jan 2021 04:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611895813;
        bh=hFO4wZFk+MmDuUL0+KttA/ndgg/tAmxp+GtIV9fTC1Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bidV6eG5JONi/OgtHGC3rorSjNlYk317n/5SDb8vDgac6vQNfI34kXeUk1IwXUS0Z
         Aq5JX2Xu9sfSH+e+B46NFazSjYSBGtYkfpcdaYzbCJZqGHM8ChTTBxesd/X1jEs6o4
         EFpor6859oisoIvM79EsFKU58GCpMos/k0OPwxjQE6a/huiFtyn04o/iw7riXluOwA
         esWs5ITl4/5W/+TaA0yFSE3hYV3EhrradSEGxs1BAnX5tawA308EL7rYEOTRGd4pZV
         7QYFBoiamxRq3a3vHRVmwT/i5eMpsJrkYgz3jOmqBdeAs9u0jP/vpHXcRAtSpxHpTD
         cDUoYSQvsgD/Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 690EA65324;
        Fri, 29 Jan 2021 04:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5] net/iucv: updates 2021-01-28
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161189581342.32508.4406500317410182987.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jan 2021 04:50:13 +0000
References: <20210128114108.39409-1-jwi@linux.ibm.com>
In-Reply-To: <20210128114108.39409-1-jwi@linux.ibm.com>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, kgraul@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 28 Jan 2021 12:41:03 +0100 you wrote:
> Hi Dave & Jakub,
> 
> please apply the following patch series for iucv to netdev's net-next tree.
> 
> This reworks & simplifies the TX notification path in af_iucv, so that we
> can send out SG skbs over TRANS_HIPER sockets. Also remove a noisy
> WARN_ONCE() in the RX path.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] net/af_iucv: remove WARN_ONCE on malformed RX packets
    https://git.kernel.org/netdev/net-next/c/27e9c1de5299
  - [net-next,2/5] net/af_iucv: don't lookup the socket on TX notification
    https://git.kernel.org/netdev/net-next/c/c464444fa2ca
  - [net-next,3/5] net/af_iucv: count packets in the xmit path
    https://git.kernel.org/netdev/net-next/c/ef6af7bdb9e6
  - [net-next,4/5] net/af_iucv: don't track individual TX skbs for TRANS_HIPER sockets
    https://git.kernel.org/netdev/net-next/c/80bc97aa0aaa
  - [net-next,5/5] net/af_iucv: build SG skbs for TRANS_HIPER sockets
    https://git.kernel.org/netdev/net-next/c/2c3b4456c812

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


