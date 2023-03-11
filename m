Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF3756B572C
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 01:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbjCKA4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 19:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjCKA4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 19:56:21 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0CAD42BFA;
        Fri, 10 Mar 2023 16:55:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BF3C6CE2B86;
        Sat, 11 Mar 2023 00:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3475DC433A8;
        Sat, 11 Mar 2023 00:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678495819;
        bh=dAkz0u2ZcVcgnkbevyZA/41VUY4q2eV4N5qD0eF+670=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QGizU2h894QvdFJsS46fCnx7n66Evy32dtQ2WRT0V2AFsuXgQrWlxBinkLO28eGZI
         woS1ux8IGHadJJi2/VFR0269pX6BUIi9+lkzU1ZdlKSqzaIX7nPqa8jAHjZwRLGz20
         tlTQXwT4hVeoSldvyIw5a0QB2++aKoEzE8DFtxAZO+mLhE/R00pIRKlnEChy8hD0hC
         b9UnOiY8K+ydCJDewcpHewOR5AkSVZIgSZZPz0j7o2PjgbQB4fg9TQpKetIVhaGHiO
         gGiU7HbUB4QdlORBEclX19v3z5+PYMsrlHb6jTYOoQSuJ+6i050euKTsYqV5FbB1Q2
         ZoBw+HRqhd4Uw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1D77EE21EEB;
        Sat, 11 Mar 2023 00:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net, stable v1 0/3] add checking sq is full inside xdp xmit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167849581911.26321.1114806973395785134.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Mar 2023 00:50:19 +0000
References: <20230308024935.91686-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230308024935.91686-1-xuanzhuo@linux.alibaba.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        yichun@openresty.com, alexanderduyck@fb.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Mar 2023 10:49:32 +0800 you wrote:
> If the queue of xdp xmit is not an independent queue, then when the xdp
> xmit used all the desc, the xmit from the __dev_queue_xmit() may encounter
> the following error.
> 
> net ens4: Unexpected TXQ (0) queue failure: -28
> 
> This patch adds a check whether sq is full in XDP Xmit.
> 
> [...]

Here is the summary with links:
  - [net,stable,v1,1/3] virtio_net: reorder some funcs
    https://git.kernel.org/netdev/net/c/25074a44ac4e
  - [net,stable,v1,2/3] virtio_net: separate the logic of checking whether sq is full
    https://git.kernel.org/netdev/net/c/b8ef4809bc7f
  - [net,stable,v1,3/3] virtio_net: add checking sq is full inside xdp xmit
    https://git.kernel.org/netdev/net/c/cd1c604aa1d8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


