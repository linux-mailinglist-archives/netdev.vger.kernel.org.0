Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5770531746A
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 00:31:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233886AbhBJXbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 18:31:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:45008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233668AbhBJXau (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 18:30:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 62C4C64E74;
        Wed, 10 Feb 2021 23:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612999807;
        bh=zcUTY8llwMOnHoeTedDCN65DgA02Y2P4FA1HBAQJIZ8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Pwl7/DfbcyY7L5O5XzAlNDdqjGxZ0OY1sc2aEY6UzzeiuYrth5jLuJtwKY+hO00Iu
         W6MkgM3wYfEXBAE3sbd+pN2JhcI2C3r0zWud/S/nO29BJYzcks9oL+W82eANL2ZyLb
         LKXXa78oHnc9LrQ7LpLfYKYXp/ZSkIhfdeP5yn8F8hOzaDdbBBYILy7SZidTQasBAQ
         Gb7ClwHtIWu8TPiO63/d/rGg0Z9MCZLdj9YpUtD0mAO/NE11/IufqObseCtT2my4wv
         M8KdZMRFe1gKEoY1MUaJ4YSw5Krhb4hTZsW4MRrjKolVYJfTDZ1hJQQtpZBbBrWtAc
         3lrE9gmTnu4kw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 40EA0609F1;
        Wed, 10 Feb 2021 23:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] rxrpc: Fix missing dependency on NET_UDP_TUNNEL
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161299980726.17911.8770731503126341491.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Feb 2021 23:30:07 +0000
References: <161288292553.585687.14447945995623785380.stgit@warthog.procyon.org.uk>
In-Reply-To: <161288292553.585687.14447945995623785380.stgit@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, lkp@intel.com, vfedorenko@novek.ru,
        lucien.xin@gmail.com, alaa@dev.mellanox.co.il, kuba@kernel.org,
        linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 09 Feb 2021 15:02:05 +0000 you wrote:
> The changes to make rxrpc create the udp socket missed a bit to add the
> Kconfig dependency on the udp tunnel code to do this.
> 
> Fix this by adding making AF_RXRPC select NET_UDP_TUNNEL.
> 
> Fixes: 1a9b86c9fd95 ("rxrpc: use udp tunnel APIs instead of open code in rxrpc_open_socket")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: Xin Long <lucien.xin@gmail.com>
> cc: alaa@dev.mellanox.co.il
> cc: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] rxrpc: Fix missing dependency on NET_UDP_TUNNEL
    https://git.kernel.org/netdev/net-next/c/dc0e6056decc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


