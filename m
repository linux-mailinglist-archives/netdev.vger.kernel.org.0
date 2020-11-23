Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94C972C17CF
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 22:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730746AbgKWVkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 16:40:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:34840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728093AbgKWVkF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 16:40:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606167605;
        bh=HwkqtUGa++7U26Fj41RJBk4lhegVxbnaPUvBVwVQajM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RegsWNngb6ogoRHHRQquERRfLECbX+P3+gDfOf7C+HUEWUIsRK+lyWqYV5PaLnT5W
         QspTRsU26XhnvemcHBRLwl3PV1g7iYx3EWPmIf8lle7mXGQvrGp0Y5Z6O/x8fNi1P3
         KvKKOz0xyqhO/ATXID2Msft+C14W7Y+wy+Vb9Byc=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] compat: always include linux/compat.h from
 net/compat.h
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160616760493.24220.17022045420607055464.git-patchwork-notify@kernel.org>
Date:   Mon, 23 Nov 2020 21:40:04 +0000
References: <20201121214844.1488283-1-kuba@kernel.org>
In-Reply-To: <20201121214844.1488283-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, hch@lst.de,
        arnd@arndb.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 21 Nov 2020 13:48:44 -0800 you wrote:
> We're about to do reshuffling in networking headers and
> eliminate some implicit includes. This results in:
> 
> In file included from ../net/ipv4/netfilter/arp_tables.c:26:
> include/net/compat.h:60:40: error: unknown type name ‘compat_uptr_t’; did you mean ‘compat_ptr_ioctl’?
>     struct sockaddr __user **save_addr, compat_uptr_t *ptr,
>                                         ^~~~~~~~~~~~~
>                                         compat_ptr_ioctl
> include/net/compat.h:61:4: error: unknown type name ‘compat_size_t’; did you mean ‘compat_sigset_t’?
>     compat_size_t *len);
>     ^~~~~~~~~~~~~
>     compat_sigset_t
> 
> [...]

Here is the summary with links:
  - [net-next,v2] compat: always include linux/compat.h from net/compat.h
    https://git.kernel.org/netdev/net-next/c/fc0d3b24bdb7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


