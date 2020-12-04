Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082B22CF678
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 23:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730109AbgLDWAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 17:00:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:56738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgLDWAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 17:00:48 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607119208;
        bh=GLchs7RpbysdRcGDs0qUl/H2Yvy6mr6HLZKcyi1g8+8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cQwIcDF/lRjN26cUEuU1n9+MtY6f8C8wAwFrWRAXrN0TeFURvmiQ75nNbdh9AsEj7
         9BOuatosYHIc+uQnsQi6rb+Nu4vMq546gmJ4zPb/nxcQ3zfxpxC0vl37p5Z3tAk2W+
         Rckdwf0mW2SnMFzcQfwxaTaSdRQeKs1ry6VteDB2Z3RaV5vocSy4UDYX2XU/lY7LtW
         gw75aowxA01rMJ5vFl3ooG6Qr4AaGvBL0r/7qho9YXMQRhxa7sQ4wj5F1Cql6pXYgz
         tX/lxGcT1iNoeM8pbvesN0p4CcLPR0D2aSc68LNFnOtvNvvosbjxFFACGf/f4erNiA
         yHZnAoqZFouLA==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next v5 1/6] net: Remove the err argument from
 sock_from_file
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160711920795.26112.15547923878362487061.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Dec 2020 22:00:07 +0000
References: <20201204113609.1850150-1-revest@google.com>
In-Reply-To: <20201204113609.1850150-1-revest@google.com>
To:     Florent Revest <revest@chromium.org>
Cc:     bpf@vger.kernel.org, viro@zeniv.linux.org.uk, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, yhs@fb.com, andrii@kernel.org, kpsingh@chromium.org,
        revest@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kpsingh@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (refs/heads/master):

On Fri,  4 Dec 2020 12:36:04 +0100 you wrote:
> Currently, the sock_from_file prototype takes an "err" pointer that is
> either not set or set to -ENOTSOCK IFF the returned socket is NULL. This
> makes the error redundant and it is ignored by a few callers.
> 
> This patch simplifies the API by letting callers deduce the error based
> on whether the returned socket is NULL or not.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v5,1/6] net: Remove the err argument from sock_from_file
    https://git.kernel.org/bpf/bpf-next/c/dba4a9256bb4
  - [bpf-next,v5,2/6] bpf: Add a bpf_sock_from_file helper
    https://git.kernel.org/bpf/bpf-next/c/4f19cab76136
  - [bpf-next,v5,3/6] bpf: Expose bpf_sk_storage_* to iterator programs
    https://git.kernel.org/bpf/bpf-next/c/a50a85e40c59
  - [bpf-next,v5,4/6] selftests/bpf: Add an iterator selftest for bpf_sk_storage_delete
    https://git.kernel.org/bpf/bpf-next/c/593f6d41abbb
  - [bpf-next,v5,5/6] selftests/bpf: Add an iterator selftest for bpf_sk_storage_get
    https://git.kernel.org/bpf/bpf-next/c/bd9b327e58f9
  - [bpf-next,v5,6/6] selftests/bpf: Test bpf_sk_storage_get in tcp iterators
    https://git.kernel.org/bpf/bpf-next/c/34da87213d3d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


