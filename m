Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B283642732
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 12:10:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbiLELKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 06:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231475AbiLELK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 06:10:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC26C17412;
        Mon,  5 Dec 2022 03:10:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63501B80ED6;
        Mon,  5 Dec 2022 11:10:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2E85AC433B5;
        Mon,  5 Dec 2022 11:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670238623;
        bh=SGrY2VbBiY8EvXHZCofJcL9wewiXKh5c/vxkaEVzX0o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=doUfkrL/n+6merTwuFKH3n4knBMFUFaP9che/oZyBEt00wqNckzQkyI9csUTHc3xd
         WUvBq+MegNEY7byrutOkETwXM4uNKYbvUjLKJOLXib3k0H3MheYaNgfJBJqtH8Jf2N
         pC01rVKd9cG+vIrmtdiaLiuzb8klDZUUMy3AnehmTybiKhWGTajfngZkwOwZ9RPUd2
         k7RZ14Knge7ckl3tkpjcCBOt7uw8fD2+Aufpq6vQvRZ5Ib/ADIZfWQavWcGDf+ONKk
         zLxnFLxKBFK9VzYAfGGN3SUbficDAHg6L4W2zKf5na/ypRideEGqOZpszDVUzNhoZn
         +NjafdEjsnvdg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1C65BC395E5;
        Mon,  5 Dec 2022 11:10:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/36] rxrpc: Increasing SACK size and moving away
 from softirq, parts 2 & 3
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167023862311.18576.967367568555185874.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Dec 2022 11:10:23 +0000
References: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
In-Reply-To: <166994010342.1732290.13771061038178613124.stgit@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
Cc:     netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        marc.dionne@auristor.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David Howells <dhowells@redhat.com>:

On Fri, 02 Dec 2022 00:15:03 +0000 you wrote:
> Here are the second and third parts of patches in the process of moving
> rxrpc from doing a lot of its stuff in softirq context to doing it in an
> I/O thread in process context and thereby making it easier to support a
> larger SACK table.
> 
> The full description is in the description for the first part[1] which is
> already in net-next.
> 
> [...]

Here is the summary with links:
  - [net-next,01/36] rxrpc: Fix checker warning
    https://git.kernel.org/netdev/net-next/c/84924aac08a4
  - [net-next,02/36] rxrpc: Implement an in-kernel rxperf server for testing purposes
    https://git.kernel.org/netdev/net-next/c/75bfdbf2fca3
  - [net-next,03/36] rxrpc: Fix call leak
    https://git.kernel.org/netdev/net-next/c/49df54a6b295
  - [net-next,04/36] rxrpc: Remove decl for rxrpc_kernel_call_is_complete()
    https://git.kernel.org/netdev/net-next/c/2ed83ed2be1b
  - [net-next,05/36] rxrpc: Remove handling of duplicate packets in recvmsg_queue
    https://git.kernel.org/netdev/net-next/c/30efa3ce109d
  - [net-next,06/36] rxrpc: Remove the [k_]proto() debugging macros
    https://git.kernel.org/netdev/net-next/c/2ebdb26e6abd
  - [net-next,07/36] rxrpc: Remove the [_k]net() debugging macros
    https://git.kernel.org/netdev/net-next/c/e969c92ce597
  - [net-next,08/36] rxrpc: Drop rxrpc_conn_parameters from rxrpc_connection and rxrpc_bundle
    https://git.kernel.org/netdev/net-next/c/2cc800863c49
  - [net-next,09/36] rxrpc: Extract the code from a received ABORT packet much earlier
    https://git.kernel.org/netdev/net-next/c/f14febd8df5a
  - [net-next,10/36] rxrpc: trace: Don't use __builtin_return_address for rxrpc_local tracing
    https://git.kernel.org/netdev/net-next/c/0fde882fc9ee
  - [net-next,11/36] rxrpc: trace: Don't use __builtin_return_address for rxrpc_peer tracing
    https://git.kernel.org/netdev/net-next/c/47c810a79844
  - [net-next,12/36] rxrpc: trace: Don't use __builtin_return_address for rxrpc_conn tracing
    https://git.kernel.org/netdev/net-next/c/7fa25105b2d3
  - [net-next,13/36] rxrpc: trace: Don't use __builtin_return_address for rxrpc_call tracing
    https://git.kernel.org/netdev/net-next/c/cb0fc0c9722c
  - [net-next,14/36] rxrpc: Trace rxrpc_bundle refcount
    https://git.kernel.org/netdev/net-next/c/fa3492abb64b
  - [net-next,15/36] rxrpc: trace: Don't use __builtin_return_address for sk_buff tracing
    https://git.kernel.org/netdev/net-next/c/9a36a6bc22ca
  - [net-next,16/36] rxrpc: Don't hold a ref for call timer or workqueue
    https://git.kernel.org/netdev/net-next/c/3feda9d69c83
  - [net-next,17/36] rxrpc: Don't hold a ref for connection workqueue
    https://git.kernel.org/netdev/net-next/c/3cec055c5695
  - [net-next,18/36] rxrpc: Split the receive code
    https://git.kernel.org/netdev/net-next/c/96b2d69b43a0
  - [net-next,19/36] rxrpc: Create a per-local endpoint receive queue and I/O thread
    https://git.kernel.org/netdev/net-next/c/a275da62e8c1
  - [net-next,20/36] rxrpc: Move packet reception processing into I/O thread
    https://git.kernel.org/netdev/net-next/c/446b3e14525b
  - [net-next,21/36] rxrpc: Move error processing into the local endpoint I/O thread
    https://git.kernel.org/netdev/net-next/c/ff7348254e70
  - [net-next,22/36] rxrpc: Remove call->input_lock
    https://git.kernel.org/netdev/net-next/c/4041a8ff653e
  - [net-next,23/36] rxrpc: Don't use sk->sk_receive_queue.lock to guard socket state changes
    https://git.kernel.org/netdev/net-next/c/81f2e8adc0fd
  - [net-next,24/36] rxrpc: Implement a mechanism to send an event notification to a call
    https://git.kernel.org/netdev/net-next/c/15f661dc95da
  - [net-next,25/36] rxrpc: Copy client call parameters into rxrpc_call earlier
    https://git.kernel.org/netdev/net-next/c/f3441d4125fc
  - [net-next,26/36] rxrpc: Move DATA transmission into call processor work item
    https://git.kernel.org/netdev/net-next/c/cf37b5987508
  - [net-next,27/36] rxrpc: Remove RCU from peer->error_targets list
    https://git.kernel.org/netdev/net-next/c/29fb4ec385f1
  - [net-next,28/36] rxrpc: Simplify skbuff accounting in receive path
    https://git.kernel.org/netdev/net-next/c/2d1faf7a0ca3
  - [net-next,29/36] rxrpc: Reduce the use of RCU in packet input
    https://git.kernel.org/netdev/net-next/c/cd21effb0552
  - [net-next,30/36] rxrpc: Extract the peer address from an incoming packet earlier
    https://git.kernel.org/netdev/net-next/c/393a2a2007d1
  - [net-next,31/36] rxrpc: Make the I/O thread take over the call and local processor work
    https://git.kernel.org/netdev/net-next/c/5e6ef4f1017c
  - [net-next,32/36] rxrpc: Remove the _bh annotation from all the spinlocks
    https://git.kernel.org/netdev/net-next/c/3dd9c8b5f09f
  - [net-next,33/36] rxrpc: Trace/count transmission underflows and cwnd resets
    https://git.kernel.org/netdev/net-next/c/32cf8edb079a
  - [net-next,34/36] rxrpc: Move the cwnd degradation after transmitting packets
    https://git.kernel.org/netdev/net-next/c/5086d9a9dfec
  - [net-next,35/36] rxrpc: Fold __rxrpc_unuse_local() into rxrpc_unuse_local()
    https://git.kernel.org/netdev/net-next/c/a2cf3264f331
  - [net-next,36/36] rxrpc: Transmit ACKs at the point of generation
    https://git.kernel.org/netdev/net-next/c/b0346843b107

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


