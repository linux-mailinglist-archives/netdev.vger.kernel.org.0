Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECC25AAE24
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 14:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235855AbiIBMKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 08:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235854AbiIBMKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 08:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22572A73E;
        Fri,  2 Sep 2022 05:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE2EF620D1;
        Fri,  2 Sep 2022 12:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59A17C433B5;
        Fri,  2 Sep 2022 12:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662120616;
        bh=cfLV+hYmpTeGN4Jr6uIQCPnEFumTwBtZQ2Qc4OquoBs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=noAS4ZqhKh2VfXz2bKLz9WBA1M3CECYi24vq7zaHqMNueSfJQmbsU7Kbp8WEH8prT
         HOs28qruw4CU0X1KGU9sXTJ8x9TqYs5sSOQyqSwxta4R0f9dPyjIfEvbzM33AoHuoh
         T9rdD3XbTcm7z49wKHZ4x2DkuFRidKSfRnnLSmq8lrh8H5HHe4OeHW/+Ed4rme0JYU
         CwZKVtI2JLtHOmE+40yLIPCu8C8kzDacGfkyllq4351Uxnfl+8XhqIPm6UQlxWnIMk
         dfjrPHl4fspRwCz9diZGIFXC6UzLrfJjWHA8H5onf8TIhK3VSKr+NbA1Uv6bWxrQhF
         /AmiBgYfDBhVg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3DC06E924E4;
        Fri,  2 Sep 2022 12:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/6] rxrpc: Miscellaneous fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166212061624.16201.6479351109057474742.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Sep 2022 12:10:16 +0000
References: <166203518656.271364.567426359603115318.stgit@warthog.procyon.org.uk>
In-Reply-To: <166203518656.271364.567426359603115318.stgit@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, marc.dionne@auristor.com,
        jaltman@auristor.com, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David Howells <dhowells@redhat.com>:

On Thu, 01 Sep 2022 13:26:26 +0100 you wrote:
> Here are some fixes for AF_RXRPC:
> 
>  (1) Fix the handling of ICMP/ICMP6 packets.  This is a problem due to
>      rxrpc being switched to acting as a UDP tunnel, thereby allowing it to
>      steal the packets before they go through the UDP Rx queue.  UDP
>      tunnels can't get ICMP/ICMP6 packets, however.  This patch adds an
>      additional encap hook so that they can.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/6] rxrpc: Fix ICMP/ICMP6 error handling
    https://git.kernel.org/netdev/net/c/ac56a0b48da8
  - [net,v3,2/6] rxrpc: Fix an insufficiently large sglist in rxkad_verify_packet_2()
    https://git.kernel.org/netdev/net/c/0d40f728e283
  - [net,v3,3/6] rxrpc: Fix local destruction being repeated
    https://git.kernel.org/netdev/net/c/d3d863036d68
  - [net,v3,4/6] rxrpc: Fix calc of resend age
    https://git.kernel.org/netdev/net/c/214a9dc7d852
  - [net,v3,5/6] afs: Use the operation issue time instead of the reply time for callbacks
    https://git.kernel.org/netdev/net/c/7903192c4b4a
  - [net,v3,6/6] rxrpc: Remove rxrpc_get_reply_time() which is no longer used
    https://git.kernel.org/netdev/net/c/21457f4a91cb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


