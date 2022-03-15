Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 486254D9406
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 06:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243559AbiCOFlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 01:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239899AbiCOFlZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 01:41:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518662B25A
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 22:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91FE6B8110C
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 05:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3BB26C340F5;
        Tue, 15 Mar 2022 05:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647322810;
        bh=hC3SxfYWMP6+hdGAIQC/Zhi6TkSR0JhMEVRQcw73Z3U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y6okUpo1cXCBAN7QWLbYvZulDbXqZ/xvARBL1z78QGA4kGeGd8VcBOgTJ/wuTZS3E
         1toEqDpg9mueKY0Qsnrk0BHKYPeYP7YcYP9Zb9Fg8XsV48fum2/XXEzJSiTVE8wPbj
         bRW1atzlA6zfcrpDoZcDJ3tQN2oQrjZB378+LF+0WWcfQl3hmjWuICSOJCR3Whd9Vy
         l+ky8kpKfWaI5LxJqErqf+2NpuUterEKUv6AslgTTDlv6gUpqJpkQVtPsyDv7yJKfI
         sgb1YtIV/bB1yAn4m7DL/a04Qoi0MM99D2kgRE5cHZvS3qS2ZOAo+4giskXkVnTwH1
         DOI/dk7Z++adg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1ABA1F0383F;
        Tue, 15 Mar 2022 05:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/packet: fix slab-out-of-bounds access in
 packet_recvmsg()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164732281010.21925.14083073406818964716.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Mar 2022 05:40:10 +0000
References: <20220312232958.3535620-1-eric.dumazet@gmail.com>
In-Reply-To: <20220312232958.3535620-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, syzkaller@googlegroups.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sat, 12 Mar 2022 15:29:58 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot found that when an AF_PACKET socket is using PACKET_COPY_THRESH
> and mmap operations, tpacket_rcv() is queueing skbs with
> garbage in skb->cb[], triggering a too big copy [1]
> 
> Presumably, users of af_packet using mmap() already gets correct
> metadata from the mapped buffer, we can simply make sure
> to clear 12 bytes that might be copied to user space later.
> 
> [...]

Here is the summary with links:
  - [net] net/packet: fix slab-out-of-bounds access in packet_recvmsg()
    https://git.kernel.org/netdev/net/c/c700525fcc06

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


