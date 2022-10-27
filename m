Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8550260EE75
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 05:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233817AbiJ0DU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 23:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233187AbiJ0DUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 23:20:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65EC6317C0
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 20:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 186766214D
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 03:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5C2B7C433B5;
        Thu, 27 Oct 2022 03:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666840816;
        bh=fM3Y9gpIU8uXSndK6AEg1JAx1gqmSEn1VTWTG/Oqdw0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jM5VOQnO3ZMCTIifr5sXOVkjxkhDxwklCfjy+jUN8EbkDTOJe08vLGjaVmmLXPMn/
         XtCrmUPTw+IXWYRmo5z1xMMg3E71W1iWlwBCEoZo9sqD2nZVJwIRoeagSW8pKtGmwX
         v/uv+m37N6wLGRVVbV5D+Pfe7Ph9hSqR0yPY7cVcIwk2Il1UexFJYLpNZI5kuDuoYG
         uY1HN7y9+PI6dGbZdaqGsn0Zz7CoacgX/Wyvuk4bgwjFAKoq5gdMj8koHTLGtqfGzQ
         hE9RuRNazRTbeOdW6s2CKQjzTPkJRkNj9IN3QxR60TGTpPIfbEMiicIHOUny0FYYWN
         h336jIkl9gd1g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3C731E45192;
        Thu, 27 Oct 2022 03:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] mptcp: fix tracking issue in
 mptcp_subflow_create_socket()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166684081624.26512.18069142554042773050.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Oct 2022 03:20:16 +0000
References: <20221025180546.652251-1-edumazet@google.com>
In-Reply-To: <20221025180546.652251-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, kuniyu@amazon.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 25 Oct 2022 18:05:46 +0000 you wrote:
> My recent patch missed that mptcp_subflow_create_socket()
> was creating a 'kernel' socket, then converted it to 'user' socket.
> 
> Fixes: 0cafd77dcd03 ("net: add a refcount tracker for kernel sockets")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Cc: Matthieu Baerts <matthieu.baerts@tessares.net>
> Cc: Kuniyuki Iwashima <kuniyu@amazon.com>
> 
> [...]

Here is the summary with links:
  - [net-next] mptcp: fix tracking issue in mptcp_subflow_create_socket()
    https://git.kernel.org/netdev/net-next/c/d1e96cc4fbe0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


