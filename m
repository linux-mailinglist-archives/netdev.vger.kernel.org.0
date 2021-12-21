Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEEF47B8E6
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 04:10:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234437AbhLUDKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 22:10:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234351AbhLUDKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 22:10:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FFABC06173E
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 19:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F912B8114E
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 03:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C1CA9C36AE5;
        Tue, 21 Dec 2021 03:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640056210;
        bh=FsijyrsZgpeivtKx4vvtoY0Ke8/I8sMupXhrqqeri8U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n9HGsXOyGWZDZGbPpjQRi7LYsh5l1upFTrnrrtE/HzznOciKKWlOcOPDITnMo0xyX
         PCnDLw+10rfQJ3KkQiRSyusPsyWnmwJoahXe1OefveIoYvyRiKz0aiaa0sxdOVyqHw
         ss6/Plho1i3t4Vdc9epxkqFltdjT7IUpIPyoqvGFwkNfvNqE7YFqjAOAhdsuvmO0CB
         9MiKAyYk/N4VFehOgGdpbQt1z8oGrqYpP7WXEadVl2dNqvdtOX+P5BdOjcpoiQPBiR
         pW8iO3bBtjJ8X6VPMCvypIban5Js46oaNroD/siANrhV2goe5BH1H9Y8o8x56qzxDT
         p5dvHTyQAFM/w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A449E609B3;
        Tue, 21 Dec 2021 03:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: skip virtio_net_hdr_set_proto if protocol already
 set
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164005621066.30905.223795412491246597.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Dec 2021 03:10:10 +0000
References: <20211220145027.2784293-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20211220145027.2784293-1-willemdebruijn.kernel@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jianfeng.tan@linux.alibaba.com, willemb@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 20 Dec 2021 09:50:27 -0500 you wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> virtio_net_hdr_set_proto infers skb->protocol from the virtio_net_hdr
> gso_type, to avoid packets getting dropped for lack of a proto type.
> 
> Its protocol choice is a guess, especially in the case of UFO, where
> the single VIRTIO_NET_HDR_GSO_UDP label covers both UFOv4 and UFOv6.
> 
> [...]

Here is the summary with links:
  - [net] net: skip virtio_net_hdr_set_proto if protocol already set
    https://git.kernel.org/netdev/net/c/1ed1d5921139

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


