Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA925333245
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 01:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbhCJAUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 19:20:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:53452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230421AbhCJAUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 19:20:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9CBDF650F3;
        Wed, 10 Mar 2021 00:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615335609;
        bh=3QrPLDAwqczROX3zLFTJP9PbnmhqQxe/Lh233jR8pdg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e5sti+F+oR0MGYvzl8DpKlQaaqc5UWEuJWSTICJ+m7qkcsWgntLNUNIRtPQxI0K1R
         WNZ4cC4Cxws61xC3sYtj0tQ+yazrz7kbvfWEofx94aqpzd+QQW+2rZ2vF3Ss4Z7ldE
         Yg6c+352ZiHL8p9zwFTrse+sbSq5G8EsDvVvi9Qw8pMPgHQmwyX+gl/WhmJKkH5eiR
         LVsXF+rbuftRLZ6fU/UFWN7WgzwlTEA5VbZgxnCLJYiY/xXGZDqi6oEgczND+3dMV5
         gPA/VqHW2MTlCXwK5vaN4BXUdApK2MzRPPG90ZrJ/U/6jxdTIjECSBjeWB6xWR/aka
         RIw7JSlGnQ9gQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 97F3260952;
        Wed, 10 Mar 2021 00:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/2] net: prevent infinite loop caused by incorrect
 proto from virtio_net_hdr_set_proto
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161533560961.32666.14529023719562864396.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Mar 2021 00:20:09 +0000
References: <cover.1615288658.git.bnemeth@redhat.com>
In-Reply-To: <cover.1615288658.git.bnemeth@redhat.com>
To:     Balazs Nemeth <bnemeth@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, jasowang@redhat.com, dsahern@gmail.com,
        davem@davemloft.net, willemb@google.com,
        virtualization@lists.linux-foundation.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue,  9 Mar 2021 12:30:59 +0100 you wrote:
> These patches prevent an infinite loop for gso packets with a protocol
> from virtio net hdr that doesn't match the protocol in the packet.
> Note that packets coming from a device without
> header_ops->parse_protocol being implemented will not be caught by
> the check in virtio_net_hdr_to_skb, but the infinite loop will still
> be prevented by the check in the gso layer.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/2] net: check if protocol extracted by virtio_net_hdr_set_proto is correct
    https://git.kernel.org/netdev/net/c/924a9bc362a5
  - [net,v3,2/2] net: avoid infinite loop in mpls_gso_segment when mpls_hlen == 0
    https://git.kernel.org/netdev/net/c/d348ede32e99

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


