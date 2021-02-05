Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE9231030E
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 04:01:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhBEDAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 22:00:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:54670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229581AbhBEDAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 22:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 573B564FB4;
        Fri,  5 Feb 2021 03:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612494008;
        bh=zO30pbOBo1epgIq4FBJG/IHWytZ8Kx9gBDQ+rBT/vnU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z5zImg7Sy2IWRlPOj51Nj3+ZyEY3Y+weqs3KPfk4y1tRIazuAUSiUGLD2jdQd0Cqq
         st7MA4R/IZJhcg2RKEwqjTYsGWau5DgiChcNuWIWiZhw+FdoDb7Qhe85RpGbqZ8oNs
         auyQD2zL4XpptJudYBWOG0mfv3/tG3yGsPzC4vP55WSjPgZXeeBn4UZlCrIJrRV830
         mMuVuNAFgscaVsqBPWX5MgKiKfQwUtdUHJGBovfWFsB3lrAWbEtq8QtVkaQ17557Ku
         PAhdqUErB2BiwOovUQnFaLGGLF4RljOX8j7q+d7gmG/+35Wx3+BupZrgB+4koNeXRJ
         vpiZ23wi0kOGw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4303A609F2;
        Fri,  5 Feb 2021 03:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv5 net-next 0/2] net: enable udp v6 sockets receiving v4
 packets with UDP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161249400826.18283.11858703865882095684.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Feb 2021 03:00:08 +0000
References: <cover.1612342376.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1612342376.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, willemb@google.com, martin.varghese@nokia.com,
        alexander.duyck@gmail.com, dhowells@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed,  3 Feb 2021 16:54:21 +0800 you wrote:
> Currently, udp v6 socket can not process v4 packets with UDP GRO, as
> udp_encap_needed_key is not increased when udp_tunnel_encap_enable()
> is called for v6 socket.
> 
> This patchset is to increase it and remove the unnecessary code in
> bareudp in Patch 1/2, and improve rxrpc encap_enable by calling
> udp_tunnel_encap_enable().
> 
> [...]

Here is the summary with links:
  - [PATCHv5,net-next,1/2] udp: call udp_encap_enable for v6 sockets when enabling encap
    https://git.kernel.org/netdev/net-next/c/a4a600dd301c
  - [PATCHv5,net-next,2/2] rxrpc: call udp_tunnel_encap_enable in rxrpc_open_socket
    https://git.kernel.org/netdev/net-next/c/5d30c626b67e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


