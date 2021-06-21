Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D79A93AF82E
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 00:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhFUWC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 18:02:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231797AbhFUWCT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 18:02:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 064AC61350;
        Mon, 21 Jun 2021 22:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624312804;
        bh=eFHj6qBXbR+dYcXiope7yhbFZq8OsOAcFa0HMConQwA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=enzFTdUbRrmlYcAzRMj2kUAms87nTz8zkWaNTVl3+NZMxarWc3W3LVfGgx7rjM73u
         iic+GIxoE+dCKHzKHa+Nti+2vuug+5Q6/FDeGxVStC+JMGcawRdvijQ/HK6N3d8ik6
         pXGS/vEdRM+Gmk77aVdoMHuSn2fnVDIWTxhaROkf6KF1JVhtAXgmrCxukgFvc54c4Q
         TCHjZD2531sa/yK5NWu3K7XNMniDc5ISyAUD8EtBpQ8tthL/ni15WFfAIT6dDtDNk/
         17VSE+A8LFBgtRXIF51kWHhbEyijlMwDQzihT4ZTrWhuiCs6aThLUL/ey/N2py2hkG
         X8prMu+7JgiDg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ED32960A37;
        Mon, 21 Jun 2021 22:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: handle ARPHRD_IP6GRE in
 dev_is_mac_header_xmit()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162431280396.22265.6066614149597418420.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 22:00:03 +0000
References: <5f9a7d9f535e3fa9be60fdc5b10f273fc2e8f7e8.1624306000.git.gnault@redhat.com>
In-Reply-To: <5f9a7d9f535e3fa9be60fdc5b10f273fc2e8f7e8.1624306000.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        daniel@iogearbox.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 21 Jun 2021 22:08:49 +0200 you wrote:
> Similar to commit 3b707c3008ca ("net: dev_is_mac_header_xmit() true for
> ARPHRD_RAWIP"), add ARPHRD_IP6GRE to dev_is_mac_header_xmit(), to make
> ip6gre compatible with act_mirred and __bpf_redirect().
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  include/linux/if_arp.h | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net-next] net: handle ARPHRD_IP6GRE in dev_is_mac_header_xmit()
    https://git.kernel.org/netdev/net-next/c/a3fa449ffcf5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


