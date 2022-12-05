Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3AE76421C0
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 04:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231251AbiLEDAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 22:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231160AbiLEDAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 22:00:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87F6110FE5
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 19:00:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FEAF60EF2
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 03:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5D451C433D7;
        Mon,  5 Dec 2022 03:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670209215;
        bh=AR0ejCdKS8ZhjmKXipvtM9kpqsYYEifH23z+jvxgSy0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CUzlGeEzSr93toKkRhdkkChrlgbiHJpYwEouTDcwsTENw9vHjkk4ZxA3QWTxsfqnE
         mp8X/KZEJsLVVzIfMU/ZJBHps9CieSSH1KftFEkqTnVjMGzb1PA8LxM0JsaI04OcXx
         AKtkQflT+njjUqTB6Izr6Evkl9OERIoWqeflcXBga2pysR7ChT6u8ou2dZRYXg5Mw0
         Sv0TfEIL+5MVSiXUEkO7gxYmpPGBH94s+NIdtNkFtaMJ+vBuAzQ8IGMJmqf2WQdQ00
         4G85f/WIskybTaY3887fm2/ETxQ0cVX7A3htqYefOcevT2qOaCYCbFspL6YMoemzZ9
         +pHcVhsaoE5Gg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 42114E270C7;
        Mon,  5 Dec 2022 03:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] bpf, sockmap: fix race in sock_map_free()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167020921526.5137.6945967136915134698.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Dec 2022 03:00:15 +0000
References: <20221202111640.2745533-1-edumazet@google.com>
In-Reply-To: <20221202111640.2745533-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, jakub@cloudflare.com,
        john.fastabend@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        songliubraving@fb.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Fri,  2 Dec 2022 11:16:40 +0000 you wrote:
> sock_map_free() calls release_sock(sk) without owning a reference
> on the socket. This can cause use-after-free as syzbot found [1]
> 
> Jakub Sitnicki already took care of a similar issue
> in sock_hash_free() in commit 75e68e5bf2c7 ("bpf, sockhash:
> Synchronize delete from bucket list on map free")
> 
> [...]

Here is the summary with links:
  - [net] bpf, sockmap: fix race in sock_map_free()
    https://git.kernel.org/bpf/bpf-next/c/0a182f8d6074

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


