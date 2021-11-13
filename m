Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB28744F12E
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 05:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235713AbhKMEXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 23:23:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:60614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235646AbhKMEXC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Nov 2021 23:23:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D32926115A;
        Sat, 13 Nov 2021 04:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636777209;
        bh=BW0xAHHjbWA6sxM7B21+aTu4swk6D4nDHHgt8abiBr4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BTU7h1GNh8n2zi6iiSvsP4oJWIEo77IvI64gE72pCBagP2BwIcnr+K7ibbd6w6knR
         xAPMdPk09nQYenDET/AXOPR+gsjErXf7TlLkac/qmwQyRUe+SFll05F4J13/Lfpx8A
         C6kjA1vkl0RabFj5jLTsWQ7a1KrT9ILPz2L7EiC1CHtvHgxKTrWim/J46JJ2rRRS3B
         iAIMSp5arOmnWorezXSdc44FjL6Q4VCaHqrzyiGL90CgxdOJmJhohuoUd5sXAOsM2o
         zN0jPx/GfHvIoLaNELDukeQpnW2JACnMd7RejKCgpsISbwCbyyoNIgkbGt6U0vxr6+
         9d2T2RCf5AoYg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C489260AA1;
        Sat, 13 Nov 2021 04:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ethernet: sis900: fix indentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163677720979.27008.10208886225046109290.git-patchwork-notify@kernel.org>
Date:   Sat, 13 Nov 2021 04:20:09 +0000
References: <20211111210824.676201-1-kuba@kernel.org>
In-Reply-To: <20211111210824.676201-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 11 Nov 2021 13:08:24 -0800 you wrote:
> A space has snuck in.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 74fad215ee3d ("ethernet: sis900: use eth_hw_addr_set()")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/ethernet/sis/sis900.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] ethernet: sis900: fix indentation
    https://git.kernel.org/netdev/net/c/aae458725412

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


