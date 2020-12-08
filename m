Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7AE2D2176
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 04:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbgLHDar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 22:30:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:55306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727009AbgLHDar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Dec 2020 22:30:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607398206;
        bh=UxZHozCqu0pe9rsFuVws+A/XjXB1JmD+DEt1GYhcEVM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=babfjzNc3eIXs55mUG2drQjXrGFLuqHb0w2OL7fPWgS8SQ+m5Fb75dXkwPQBgQjG8
         fyd9xtK+uvmp2LabL2lrXg+CzWvgl92WNKN3bW2xZ5pvFFdMUMyuwSMsRDhKBnwQBC
         0uqiTpehuKJZ6bj7UWRE06It+ZzrkyAgf8KQoYLnBIIJ0aVFF4SQfth7YrWYs6xQXf
         vbhBJyIZ/YzGqer/11cwcDtmPJYyUO2HoM/c3WWHM3UIdvwOu0iTUVsj+NxneXq8u8
         yGjlF+PQMseEm/2PhRj6bVAejPBJ8YMmJvL8u61NaK1EZ4CkPp7f+e4J8CDVNlSl/f
         fI+umF9LN8JGw==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: propagate __user annotations properly
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160739820678.1788.12048920183003808630.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Dec 2020 03:30:06 +0000
References: <20201207123720.19111-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20201207123720.19111-1-lukas.bulwahn@gmail.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@chromium.org,
        kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Mon,  7 Dec 2020 13:37:20 +0100 you wrote:
> __htab_map_lookup_and_delete_batch() stores a user pointer in the local
> variable ubatch and uses that in copy_{from,to}_user(), but ubatch misses a
> __user annotation.
> 
> So, sparse warns in the various assignments and uses of ubatch:
> 
>   kernel/bpf/hashtab.c:1415:24: warning: incorrect type in initializer
>     (different address spaces)
>   kernel/bpf/hashtab.c:1415:24:    expected void *ubatch
>   kernel/bpf/hashtab.c:1415:24:    got void [noderef] __user *
> 
> [...]

Here is the summary with links:
  - bpf: propagate __user annotations properly
    https://git.kernel.org/bpf/bpf-next/c/2f4b03195fe8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


