Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3ED245497F
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 16:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231991AbhKQPDn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 10:03:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:34818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238358AbhKQPDI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 10:03:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A894461BAA;
        Wed, 17 Nov 2021 15:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637161209;
        bh=SBlnpiAxk+ZWGNEJFI9bKHRpnUMb68jaP6jwoQdQbsg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LPxNZvskX35iNpFJOxA+2OaEIAQhE644PHBsglJGXIYYY3JQtmra6ljSn4QWVC38M
         uYaYE6NHxYaf2RtXW+tmD9sGJvB5U+jK8TAqeN/HYriosLKSb3EXyvkG7JQvbdrgZU
         Fz6PVA/vRbSgK7DCDsnKKxQtPIYlWBfbFBuij3Pv2cA++NDOA1wO3V7KiWdeIoubae
         7tGr3PCBRhNkeobZ04nqZvG+yu2b09LQeoZ3JRXANUVE9uCagOTZqDhJdyG411BSPF
         /0kgXTbl/mFZVJh/1ISUCoEMcK7hVtWIc6INv4eJ9n9j9E8/8U1Zd9dp4NPoXK2VRz
         m7k0O5exq0KXw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9E81760A4E;
        Wed, 17 Nov 2021 15:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: virtio_net_hdr_to_skb: count transport header in
 UFO
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163716120964.17032.16005858432470270907.git-patchwork-notify@kernel.org>
Date:   Wed, 17 Nov 2021 15:00:09 +0000
References: <20211116174242.32681-1-jonathan.davies@nutanix.com>
In-Reply-To: <20211116174242.32681-1-jonathan.davies@nutanix.com>
To:     Jonathan Davies <jonathan.davies@nutanix.com>
Cc:     willemb@google.com, netdev@vger.kernel.org, flosch@nutanix.com,
        thilakraj.sb@nutanix.com, mst@redhat.com, jasowang@redhat.com,
        davem@davemloft.net, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 16 Nov 2021 17:42:42 +0000 you wrote:
> virtio_net_hdr_to_skb does not set the skb's gso_size and gso_type
> correctly for UFO packets received via virtio-net that are a little over
> the GSO size. This can lead to problems elsewhere in the networking
> stack, e.g. ovs_vport_send dropping over-sized packets if gso_size is
> not set.
> 
> This is due to the comparison
> 
> [...]

Here is the summary with links:
  - [v2,net] net: virtio_net_hdr_to_skb: count transport header in UFO
    https://git.kernel.org/netdev/net/c/cf9acc90c80e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


