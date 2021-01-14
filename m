Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83EF62F5931
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727808AbhANDUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 22:20:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:54800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725953AbhANDUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Jan 2021 22:20:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0414423788;
        Thu, 14 Jan 2021 03:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610594409;
        bh=LK8ZJ5pcQLauLQbDg+w49XDtH69PCpOJ6pQPSfHtE98=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cac+TxaIGKrUMiva2r3rACLTY94+7DYdPA5cv2+nbyWwYKP/E6GZSZTZDeUYVNqyQ
         lOz4BkMPTCYg//VuYDw6KWMXMnAwDzktpRkHXONPMPBjx5wlZCXWGUm1pxTqXv80H3
         gEV6bgkbFFxcgRiTFlFKqtxCw21CHLdUu2xCT4l3L9+dUlPosE/w8YXBWu2G7jMk8r
         ISacLbbn1igxxA74MudH4e6gcq2rr+Mh4FsheIY03m18f/BIdgE6zXIdHpRspw0VLo
         Uwf9k69kAJSJOxCgfYCLlbmuV34aF471X/teBuQz9wbSczzY6YNP6QvhIPqs5rMgEu
         BvjpYKymE2SrQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id EF4686018E;
        Thu, 14 Jan 2021 03:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: core: use eth_type_vlan in
 __netif_receive_skb_core
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161059440897.32332.9097025081494728731.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jan 2021 03:20:08 +0000
References: <20210111104221.3451-1-dong.menglong@zte.com.cn>
In-Reply-To: <20210111104221.3451-1-dong.menglong@zte.com.cn>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, ast@kernel.org,
        andriin@fb.com, daniel@iogearbox.net, edumazet@google.com,
        ap420073@gmail.com, xiyou.wangcong@gmail.com, jiri@mellanox.com,
        bjorn.topel@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, dong.menglong@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 11 Jan 2021 02:42:21 -0800 you wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> Replace the check for ETH_P_8021Q and ETH_P_8021AD in
> __netif_receive_skb_core with eth_type_vlan.
> 
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - [net-next] net: core: use eth_type_vlan in __netif_receive_skb_core
    https://git.kernel.org/netdev/net-next/c/324cefaf1c72

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


