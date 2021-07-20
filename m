Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6513D0359
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 22:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236782AbhGTUJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 16:09:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:34740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237346AbhGTTt1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 15:49:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 40BFD61004;
        Tue, 20 Jul 2021 20:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626813005;
        bh=8MB5a5Nw8VCZnSJ6JIA6f2gvo/qa5V4BLV+zGqhx1nA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R5fOFabROVFqjIT9X/T6qbb5LkpuQUBphZEZuzzgBDq9p3Cb9/9bdVDKO1cmxChwi
         75K59+64BCmv/aTR9ecPXHYwJwBZQTCqjn8Y7XtVIHkCoEtuJXELweOLlabXvosw9K
         v9Mtu1LtjnkrMNrliysc/TTO1JUhiO0lGceftl4njYxMNtB/tvaGHkZ2Wd+SB71OMF
         gUN4bG21zpg7Kp5lVGXWqpCw/fnz9aDPEqDLlE/eOURu19GCGKcs0+YwRabmyPspws
         p317khbT/6UI1YOCuahNmJ8wAJghp8Q1BTLYdKsathz5YZV4MKkcbZDM3b6Sh/yqgL
         osJalJPagrTPg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 32D9C609DA;
        Tue, 20 Jul 2021 20:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf,
 selftests: fix test_maps now that sockmap supports UDP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162681300520.2682.1998892296368210099.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 20:30:05 +0000
References: <20210720184832.452430-1-john.fastabend@gmail.com>
In-Reply-To: <20210720184832.452430-1-john.fastabend@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        xiyou.wangcong@gmail.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Tue, 20 Jul 2021 11:48:32 -0700 you wrote:
> UDP socket support was added recently so testing UDP insert failure is no
> longer correct and causes test_maps failure. The fix is easy though, we
> simply need to test that UDP is correctly added instead of blocked.
> 
> Reported-by: Andrii Nakryiko <andrii@kernel.org>
> Fixes: 122e6c79efe1c ("sock_map: Update sock type checks for UDP")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next] bpf, selftests: fix test_maps now that sockmap supports UDP
    https://git.kernel.org/bpf/bpf-next/c/c39aa2159974

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


