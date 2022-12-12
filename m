Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05AEF649B5B
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 10:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231918AbiLLJkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 04:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiLLJkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 04:40:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5633293;
        Mon, 12 Dec 2022 01:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C2CB60F6E;
        Mon, 12 Dec 2022 09:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 85BA3C433EF;
        Mon, 12 Dec 2022 09:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670838016;
        bh=cAYUCTY/5WWtYaiqZHend8wBnBtisqH62rk7e9xJbDk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TMtLOOE/wK0EZAVP9NFshKIqzIoKM6UsZfhA6MK7B3cHf6aaRaQNiUj07fj4+1WfZ
         PJx6nSWNMfqXVL5tSOTFEDOd2wnHghfeOAKI6yC5lUdnUpnZpHfuEd86htuFDKq1gc
         Tb1SPWBfVHzVd/JpniG57POGXuVeIA0+PJ9zDcfOT38y2QFzf7MURoFf+dFQpclGGT
         IkgF/HnFyRwV1HO3SWyeu9wOP2FjkAaG2/2FrB+vc1lp4i3jxOgrxq+N9oQJ7hIOqd
         /CDFS0E3xB3gnIvyCJu5ZT/AjWBDxmAQWshLNyatSJM8qqAKtqmddqm+oS0YhiB3dE
         6XEGiUSz8zEEw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6FB28C00448;
        Mon, 12 Dec 2022 09:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 0/6] TUN/VirtioNet USO features support.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167083801644.1612.10899833484454840061.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 09:40:16 +0000
References: <20221207113558.19003-1-andrew@daynix.com>
In-Reply-To: <20221207113558.19003-1-andrew@daynix.com>
To:     Andrew Melnychenko <andrew@daynix.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mst@redhat.com, jasowang@redhat.com,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, yan@daynix.com,
        yuri.benditovich@daynix.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  7 Dec 2022 13:35:52 +0200 you wrote:
> Added new offloads for TUN devices TUN_F_USO4 and TUN_F_USO6.
> Technically they enable NETIF_F_GSO_UDP_L4
> (and only if USO4 & USO6 are set simultaneously).
> It allows the transmission of large UDP packets.
> 
> UDP Segmentation Offload (USO/GSO_UDP_L4) - ability to split UDP packets
> into several segments. It's similar to UFO, except it doesn't use IP
> fragmentation. The drivers may push big packets and the NIC will split
> them(or assemble them in case of receive), but in the case of VirtioNet
> we just pass big UDP to the host. So we are freeing the driver from doing
> the unnecessary job of splitting. The same thing for several guests
> on one host, we can pass big packets between guests.
> 
> [...]

Here is the summary with links:
  - [v5,1/6] udp: allow header check for dodgy GSO_UDP_L4 packets.
    https://git.kernel.org/netdev/net-next/c/1fd54773c267
  - [v5,2/6] uapi/linux/if_tun.h: Added new offload types for USO4/6.
    https://git.kernel.org/netdev/net-next/c/b22bbdd17a5a
  - [v5,3/6] driver/net/tun: Added features for USO.
    https://git.kernel.org/netdev/net-next/c/399e0827642f
  - [v5,4/6] uapi/linux/virtio_net.h: Added USO types.
    https://git.kernel.org/netdev/net-next/c/34061b348ae9
  - [v5,5/6] linux/virtio_net.h: Support USO offload in vnet header.
    https://git.kernel.org/netdev/net-next/c/860b7f27b8f7
  - [v5,6/6] drivers/net/virtio_net.c: Added USO support.
    https://git.kernel.org/netdev/net-next/c/418044e1de30

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


