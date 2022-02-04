Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 484444A97F3
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 11:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239329AbiBDKkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 05:40:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:51306 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234577AbiBDKkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 05:40:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A636A61A47
        for <netdev@vger.kernel.org>; Fri,  4 Feb 2022 10:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2532C340EF;
        Fri,  4 Feb 2022 10:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643971213;
        bh=Wp4QHA9VAFtdjzpjux6WpWee5SEQiw5bXTiWowaaFnI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sbuRTTxAKDnCrYG3YmkoQ39CTPeUCCG/LME+nazR4IcNjrGA/5VL6QvpimL5n++my
         wv4gW9EOyVuUaqxj1Byi1NmJL7F5JdysT+o0Ep3PprgeSrawCUzdYcgLQQFhdvICxp
         XvqnmmWUleEtRfP5QV2S0TOHfPKWK73W0fVqeXzZ3i7q0B6Xb0pJ8XFbI+Kr1KDbhR
         DsbnOLWurl+/m/3LsC7ChL73NulwfdljkH3oUu0y2BvhGhi+J2v/H6sWif+v6sBufs
         Tkcj7/ARaBvUP7z6tmxymki13k5Yo3J6y5aeeuFJz39ml1K90QozYR6J9HhudddeF6
         ekeZ2zVkYFJvA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D732BE6BBD2;
        Fri,  4 Feb 2022 10:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tls: cap the output scatter list to something
 reasonable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164397121286.5815.16819956253657269354.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Feb 2022 10:40:12 +0000
References: <20220202222031.2174584-1-kuba@kernel.org>
In-Reply-To: <20220202222031.2174584-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        viro@zeniv.linux.org.uk, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, kernel-team@fb.com, axboe@kernel.dk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  2 Feb 2022 14:20:31 -0800 you wrote:
> TLS recvmsg() passes user pages as destination for decrypt.
> The decrypt operation is repeated record by record, each
> record being 16kB, max. TLS allocates an sg_table and uses
> iov_iter_get_pages() to populate it with enough pages to
> fit the decrypted record.
> 
> Even though we decrypt a single message at a time we size
> the sg_table based on the entire length of the iovec.
> This leads to unnecessarily large allocations, risking
> triggering OOM conditions.
> 
> [...]

Here is the summary with links:
  - [net-next] tls: cap the output scatter list to something reasonable
    https://git.kernel.org/netdev/net-next/c/b93235e68921

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


