Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAEA47B8E8
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 04:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234448AbhLUDKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 22:10:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbhLUDKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 22:10:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A267C06173F
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 19:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E8C4B81154
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 03:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EDD79C36AEA;
        Tue, 21 Dec 2021 03:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640056211;
        bh=fBqYZsgrxtiUEDYefTIz8N4j0arR02i1saubfQ1g8Y4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gnguMp86F7MJYbu40DLKGn13crcoyHZ3H6QdBTvFg2SXnvU8gBJLNqibkFIEWeUp5
         D5yK4waGUdVZ7K2UXjz0nfR9r9KCei/zwWj0Mmb55IoekruwfssTqESRkN8dRc1RcQ
         UKtEe4IiCObJZsb0TAOnYpJ1rwprX9VsFsG6tw+C3H8Id2trJsfE1Upf6OBvg/LotF
         +N/ldA8l6EPtqvndLzpd/yAihHvqDVxYmnp6DMJ5LccNjH8GT6gQcogBaY4i6UDltR
         OecBrvRMKXkSdlzSyKBf/p3bYaKoH/ETIH+83CE5AGojniYH/8ASESlz4oacH7t5eR
         x0gFgk/xl6cVw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D441660A36;
        Tue, 21 Dec 2021 03:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: accept UFOv6 packages in virtio_net_hdr_to_skb
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164005621086.30905.7721851254455250823.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Dec 2021 03:10:10 +0000
References: <20211220144901.2784030-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20211220144901.2784030-1-willemdebruijn.kernel@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        nemeth@redhat.com, willemb@google.com, andrew@daynix.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 20 Dec 2021 09:49:01 -0500 you wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> Skb with skb->protocol 0 at the time of virtio_net_hdr_to_skb may have
> a protocol inferred from virtio_net_hdr with virtio_net_hdr_set_proto.
> 
> Unlike TCP, UDP does not have separate types for IPv4 and IPv6. Type
> VIRTIO_NET_HDR_GSO_UDP is guessed to be IPv4/UDP. As of the below
> commit, UFOv6 packets are dropped due to not matching the protocol as
> obtained from dev_parse_header_protocol.
> 
> [...]

Here is the summary with links:
  - [net] net: accept UFOv6 packages in virtio_net_hdr_to_skb
    https://git.kernel.org/netdev/net/c/7e5cced9ca84

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


