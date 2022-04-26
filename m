Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0BFC50FE37
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 15:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243433AbiDZNFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 09:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350566AbiDZNDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 09:03:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8E8C27;
        Tue, 26 Apr 2022 06:00:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E2A260EFC;
        Tue, 26 Apr 2022 13:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF7E5C385AC;
        Tue, 26 Apr 2022 13:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650978010;
        bh=2HA9wsWe++ap3VvtZQXVolIQ4s3VI7wu+bVpKnxfwN4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VxZpmxwaYB1qCa4KuL7G4UoJPAcSip4tT6FLIfQTHQ0bpyj7vsuTSLgZ6ufjRIiL8
         APK5CC7G9r73++88q8aDLQvc7DsqPKijdFhE5+y6hAtRfbCqpx8NqHvzAh/Rao1wOT
         vQS9i2Bl83G0o5c2ge8aYVqk0XyOVtam4hcnN3uUn1qDpmgNa0TcX1g5hlnrK1Z3c7
         BzVP/vszHWys26e3NyGz75gE/LmeTx84WCou+CB92xMYywtheeYEvkwsrM8T8w/4Ap
         Jbf/QquwJ3FOuYUB57G1eLXMoTidGPZee9Hy+lDPzGAJBDszeLyjLpOHUpxWg9FCV3
         GOVU31Pye6xdA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C6D82E8DD67;
        Tue, 26 Apr 2022 13:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] virtio_net: fix wrong buf address calculation when
 using xdp
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165097801081.17994.867649031795224132.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Apr 2022 13:00:10 +0000
References: <20220425103703.3067292-1-razor@blackwall.org>
In-Reply-To: <20220425103703.3067292-1-razor@blackwall.org>
To:     Nikolay Aleksandrov <razor@blackwall.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        stable@vger.kernel.org, jasowang@redhat.com,
        xuanzhuo@linux.alibaba.com, daniel@iogearbox.net, mst@redhat.com,
        virtualization@lists.linux-foundation.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 25 Apr 2022 13:37:03 +0300 you wrote:
> We received a report[1] of kernel crashes when Cilium is used in XDP
> mode with virtio_net after updating to newer kernels. After
> investigating the reason it turned out that when using mergeable bufs
> with an XDP program which adjusts xdp.data or xdp.data_meta page_to_buf()
> calculates the build_skb address wrong because the offset can become less
> than the headroom so it gets the address of the previous page (-X bytes
> depending on how lower offset is):
>  page_to_skb: page addr ffff9eb2923e2000 buf ffff9eb2923e1ffc offset 252 headroom 256
> 
> [...]

Here is the summary with links:
  - [net,v3] virtio_net: fix wrong buf address calculation when using xdp
    https://git.kernel.org/netdev/net/c/acb16b395c3f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


