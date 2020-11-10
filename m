Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 664DD2ACE7F
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 05:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731848AbgKJEUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 23:20:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:48714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731423AbgKJEUF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 23:20:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604982005;
        bh=Nki6tP76ogvCIUAPfGXp7NTm8qaFAjryu//H0OmStwg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=2SnitjEnRCdqkhc0bsH5y48vVdDJcj8Vc4iyPVHt+iXecXh1ZxN2bXEPBywmWBzYV
         CmoS3iRhn5fs8x00ai658OUxEMwTmj7sgrxYADB5bRJVcMN4wlmI3GrKjeiPP5TSjY
         kIX0Q+0h9Bppu4hm5bC29MrHm2ykkCMzyh86BeZI=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: skb_vlan_untag(): don't reset transport
 offset if set by GRO layer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160498200486.13677.18174078816586395491.git-patchwork-notify@kernel.org>
Date:   Tue, 10 Nov 2020 04:20:04 +0000
References: <7JgIkgEztzt0W6ZtC9V9Cnk5qfkrUFYcpN871syCi8@cp4-web-040.plabs.ch>
In-Reply-To: <7JgIkgEztzt0W6ZtC9V9Cnk5qfkrUFYcpN871syCi8@cp4-web-040.plabs.ch>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        linmiaohe@huawei.com, martin.varghese@nokia.com, pshelar@ovn.org,
        willemb@google.com, gnault@redhat.com, viro@zeniv.linux.org.uk,
        fw@strlen.de, steffen.klassert@secunet.com, pabeni@redhat.com,
        kyk.segfault@gmail.com, vladimir.oltean@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 09 Nov 2020 23:47:23 +0000 you wrote:
> Similar to commit fda55eca5a33f
> ("net: introduce skb_transport_header_was_set()"), avoid resetting
> transport offsets that were already set by GRO layer. This not only
> mirrors the behavior of __netif_receive_skb_core(), but also makes
> sense when it comes to UDP GSO fraglists forwarding: transport offset
> of such skbs is set only once by GRO receive callback and remains
> untouched and correct up to the xmitting driver in 1:1 case, but
> becomes junk after untagging in ingress VLAN case and breaks UDP
> GSO offload. This does not happen after this change, and all types
> of forwarding of UDP GSO fraglists work as expected.
> 
> [...]

Here is the summary with links:
  - [v2,net-next] net: skb_vlan_untag(): don't reset transport offset if set by GRO layer
    https://git.kernel.org/netdev/net-next/c/8be33ecfc1ff

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


