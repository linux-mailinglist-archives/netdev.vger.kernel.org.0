Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23A586BD77F
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 18:50:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbjCPRu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 13:50:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbjCPRuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 13:50:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C95DCA40;
        Thu, 16 Mar 2023 10:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C865B822F0;
        Thu, 16 Mar 2023 17:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0EC62C4339B;
        Thu, 16 Mar 2023 17:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678989020;
        bh=IJDYG+9CxMOoa0OhQpSvem/aupmEe+hwiEbqjI121r0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hxAJ+P55+9YksBnbEHsTRNP3zNvY/3vyJvSJ7oQ7Yu/qpJNrUzqOR63UZw6majpi9
         9ADeBqRNUofbadwieVSkbfJI/XrhFnHhjH89BryZBfhT+AUa1V8RWSm7iaNnhdeUmJ
         DM4+MHWCQjf5+xjjYQ0zFFRsIVphHoMeTcpWHJG07xvpsAymJV3yFoNeaGXAHKdgq6
         Z9S9SRSGMpQ8cN2ORkYfvG6MmI8OPkCP4oPolwq5g8T9XzhHFm0U5xchI2OeZSdA8d
         vAgIOb+K4hQcHgc35Yr9U1y1peG3G3g7SqhGKlbv1zBtNHSoImDFUmdUU791KIM5Db
         XfkgVWuET8/CA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DFD12E66CBF;
        Thu, 16 Mar 2023 17:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2] virtio_net: fix two bugs related to XDP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167898901991.2133.10546001323200249698.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Mar 2023 17:50:19 +0000
References: <20230315015223.89137-1-xuanzhuo@linux.alibaba.com>
In-Reply-To: <20230315015223.89137-1-xuanzhuo@linux.alibaba.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     netdev@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        hengqi@linux.alibaba.com,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Wed, 15 Mar 2023 09:52:21 +0800 you wrote:
> This patch set fixes two bugs related to XDP.
> These two patch is not associated.
> 
> v2:
>     1. add unlikely()
> 
> v1:
>     1. fix the grammer error
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] virtio_net: fix page_to_skb() miss headroom
    https://git.kernel.org/netdev/net/c/fa0f1ba7c823
  - [net,v2,2/2] virtio_net: free xdp shinfo frags when build_skb_from_xdp_buff() fails
    https://git.kernel.org/netdev/net/c/1a3bd6eabae3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


