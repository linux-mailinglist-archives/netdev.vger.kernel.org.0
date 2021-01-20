Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0E42FC789
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 03:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727326AbhATCMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 21:12:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:56952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbhATCKx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 21:10:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2602C22509;
        Wed, 20 Jan 2021 02:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611108608;
        bh=qLdlAD9p+OhQW2F9TMFky9uQJaz+4Q1YeuUmNfzWk28=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iRrYKR/OE7v1ZAuUsBSZr6zbBrB5f+x5hJmPuYIJlMdFs6MqDKMYvd9SVzI5Gxp4G
         fd+G+kL6EcKUIBda9MnAj4F91SzRVi88GBrhfDeDQxB5G6V3FFDMU9/JRZ18KZLfpv
         YnyuF/ehDFkBXcpkbkH/iWJPxceKXcbIfczsrv3z+sZcBmqht3/Br7tchqi+xmLpA1
         WW2vrxubiNa3Yd0qgLbEF5N8AE43qMJevtbbIyCxqLuCKsbYe7FvZEHrhdor9RZhs7
         ahtVRrPXMvgS0EP5b9HxIPguW2uLWutYOycpWcdGQGG0ASmWQm7wyoMYnU/80OQTdY
         ajRjLjTtB5mFg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 1D4ED604FC;
        Wed, 20 Jan 2021 02:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: do not mess with cloned skbs in tcp_add_backlog()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161110860811.32660.206464544686306302.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Jan 2021 02:10:08 +0000
References: <20210119164900.766957-1-eric.dumazet@gmail.com>
In-Reply-To: <20210119164900.766957-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, juergh@canonical.com, hkallweit1@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 19 Jan 2021 08:49:00 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Heiner Kallweit reported that some skbs were sent with
> the following invalid GSO properties :
> - gso_size > 0
> - gso_type == 0
> 
> [...]

Here is the summary with links:
  - [net] tcp: do not mess with cloned skbs in tcp_add_backlog()
    https://git.kernel.org/netdev/net/c/b160c28548bc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


