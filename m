Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87837671FDC
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 15:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbjAROkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 09:40:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbjAROjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 09:39:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A3318B1B;
        Wed, 18 Jan 2023 06:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 86459B81D4C;
        Wed, 18 Jan 2023 14:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0D1F6C433D2;
        Wed, 18 Jan 2023 14:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674052217;
        bh=JxX0BVxFAKwTobporhSU3FdWuIxGhyE23kueob+Pv9c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fElmhPkzDk297m/RfKNefU5ZmH4lAvDHlUGKiF0ZoCR28wAqPigrhAcxD6KAD86Jm
         I9X4uVjyOdQFGZ8979+Y7cRL+Swo/ikFLewBSDnOp5HflKBU8XEWOnVGP7QpoWqF2J
         /pSmeAK14XykS1I6zg5A3T5OwgzR7iAYkWfh3jbDB+P0ijpqiB1p3RirZLIXEg7dtL
         rud30WkEfpVWGnxeIvgTTaIXramYKYaem4em0j1J6qCgfo6tlPcT7HGmVA1iLFet47
         ySAq3QihI2hWawSspYR6nuMUpt73INXCOw4JPRK29qoN6vMlXJZN6dWbrsB07M4wiK
         2U+ZcWKs3McVg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E4C11C3959E;
        Wed, 18 Jan 2023 14:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net V3] virtio-net: correctly enable callback during
 start_xmit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167405221693.16594.2509104291647704318.git-patchwork-notify@kernel.org>
Date:   Wed, 18 Jan 2023 14:30:16 +0000
References: <20230117034707.52356-1-jasowang@redhat.com>
In-Reply-To: <20230117034707.52356-1-jasowang@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, xuanzhuo@linux.alibaba.com,
        lvivier@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 17 Jan 2023 11:47:07 +0800 you wrote:
> Commit a7766ef18b33("virtio_net: disable cb aggressively") enables
> virtqueue callback via the following statement:
> 
>         do {
> 		if (use_napi)
> 			virtqueue_disable_cb(sq->vq);
> 
> [...]

Here is the summary with links:
  - [net,V3] virtio-net: correctly enable callback during start_xmit
    https://git.kernel.org/netdev/net/c/d71ebe8114b4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


