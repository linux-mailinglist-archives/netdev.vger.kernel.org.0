Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B21A60BDFD
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 00:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232196AbiJXW4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 18:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiJXWzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 18:55:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC1332D121E;
        Mon, 24 Oct 2022 14:17:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B304B8120C;
        Mon, 24 Oct 2022 20:40:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 41164C433D7;
        Mon, 24 Oct 2022 20:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666644038;
        bh=VDozaXzQzrSytzPhJ60tx97Ie6w41JEAg0EmO9oUI8U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W0861hFvByNWpEpg+vUkvPestT7yCVhTCOBUtMg6wgxjIKm01d6xpvQ/PEe46Wo79
         PskhTXniRscvfFUUvxI8vAv7uR8NQoOqGaalldwEgdUxIHucNn+MmBNYkargm0CsPb
         znDVoMeNmelIS9BEl7eIRZaIkbtnXYAXIONvg4CulLRmRUUwzeHtxkLTzSTvGFa+Qm
         hrwqfa6BzstMy2ifznxzwBtIdQFoBfnFErI3fGJxO9iiTlUGENW/Scsawi0CBOz7gM
         V2CK8DDxEvbW3tGGvhfUhLDFkxRCjf3tswFpkybVJuEG30Wm7H4W2taIKroZAw+G65
         FnhBEV1zDiWIA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 256D3E29F30;
        Mon, 24 Oct 2022 20:40:38 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH for-6.1 0/3] fail io_uring zc with sockets not supporting it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166664403814.23938.17239840347120158867.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Oct 2022 20:40:38 +0000
References: <cover.1666346426.git.asml.silence@gmail.com>
In-Reply-To: <cover.1666346426.git.asml.silence@gmail.com>
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     axboe@kernel.dk, kuba@kernel.org, pabeni@redhat.com,
        davem@davemloft.net, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, metze@samba.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jens Axboe <axboe@kernel.dk>:

On Fri, 21 Oct 2022 11:16:38 +0100 you wrote:
> Some sockets don't care about msghdr::ubuf_info and would execute the
> request by copying data. Such fallback behaviour was always a pain in
> my experience, so we'd rather want to fail such requests and have a more
> robust api in the future.
> 
> Mark struct socket that support it with a new SOCK_SUPPORT_ZC flag.
> I'm not entirely sure it's the best place for the flag but at least
> we don't have to do a bunch of extra dereferences in the hot path.
> 
> [...]

Here is the summary with links:
  - [for-6.1,1/3] net: flag sockets supporting msghdr originated zerocopy
    https://git.kernel.org/netdev/net/c/e993ffe3da4b
  - [for-6.1,2/3] io_uring/net: fail zc send when unsupported by socket
    https://git.kernel.org/netdev/net/c/edf81438799c
  - [for-6.1,3/3] io_uring/net: fail zc sendmsg when unsupported by socket
    https://git.kernel.org/netdev/net/c/cc767e7c6913

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


