Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 501E850F9B1
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 12:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345049AbiDZKKB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 06:10:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348381AbiDZKI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 06:08:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E7637BD4
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 02:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C17BB81D26
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 09:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 082F1C385AC;
        Tue, 26 Apr 2022 09:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650965411;
        bh=VfPBtSCcYNpRWaAMKCwfgfpTAPh+0ERZ1gJupXJ+0no=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WB9g3rv1CcQVKyfLlSESHShS/5dL2efHj5xhoFGrOQmTaU/kn848fR3lJhBinovXG
         PwMDkI5ND34tCGTDJ/1AmNZthb95adDUXgL98otmES6hM1bAO4bM8a49SQLMJgJb27
         Ggu0GXb9GijFiBYdvOXXGnw7VXR8Hzf/Um8dBwovAC4G/QYgT6L+WFxSWr4uWZE6Wm
         jizb6uYvJgeNscpO8sXXu/JW6yMlpu0+DIMOCWn3mCkc0/EULYdutdt3chx0MEvMPK
         Dl2KxQ5yz9cHeTUg9M4BnDMS6+LRUx3Bd4YZyTO5FRKusk60whYJhccca42fxt+LhX
         qAXxjBAnB/fPw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E2B76E8DD67;
        Tue, 26 Apr 2022 09:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 net-next] net/af_packet: add VLAN support for AF_PACKET
 SOCK_RAW GSO
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165096541092.4224.10118526739950405614.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Apr 2022 09:30:10 +0000
References: <20220425014502.985464-1-liuhangbin@gmail.com>
In-Reply-To: <20220425014502.985464-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        maximmi@mellanox.com,
        WillemdeBruijnwillemdebruijn.kernel@gmail.com, bnemeth@redhat.com,
        mpattric@redhat.com, edumazet@google.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 25 Apr 2022 09:45:02 +0800 you wrote:
> Currently, the kernel drops GSO VLAN tagged packet if it's created with
> socket(AF_PACKET, SOCK_RAW, 0) plus virtio_net_hdr.
> 
> The reason is AF_PACKET doesn't adjust the skb network header if there is
> a VLAN tag. Then after virtio_net_hdr_set_proto() called, the skb->protocol
> will be set to ETH_P_IP/IPv6. And in later inet/ipv6_gso_segment() the skb
> is dropped as network header position is invalid.
> 
> [...]

Here is the summary with links:
  - [PATCHv2,net-next] net/af_packet: add VLAN support for AF_PACKET SOCK_RAW GSO
    https://git.kernel.org/netdev/net-next/c/dfed913e8b55

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


