Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC042F8A7A
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 02:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbhAPB3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 20:29:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:34180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726698AbhAPB3Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 20:29:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9F7A229F0;
        Sat, 16 Jan 2021 01:28:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610760515;
        bh=fujvymmTbRuneGWO47f8G3g/yxmbPewgKGjVo0V93Xw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ct3UY+AkbH8I2Jm6Xg3WgMIOZ1nfkdLBXkpHChMrx0H3kcPG5p9BVWG0vncOb1g6L
         xUA0V5CotA8DDTjJxmW1MN7RJqAmPK7Y+WLYbgffntGQuA81Vdjqu3ORo2TkG1x342
         yPEiWzvDj5pkopQpJu25O2KNekdDSTwJVK9zGx7wPTHpuAa5Fom7aG9gyHYtFnFPeu
         HuSHqK5u7sU8Gs/jS4UGBOPXBcoj8AcUKT08h1tOxmHfFIMpRWbzHNMyKdg3SjGgsD
         0KpfvJxxParjM7rbN3PByCwdOVnU8xn6RbvVQk8Sl9aNZwf8U3R143TQz5jp2RBzW1
         At6E9Fxt5HFrg==
Date:   Fri, 15 Jan 2021 17:28:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, ast@kernel.org, andrii.nakryiko@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: pull-request: bpf 2021-01-16
Message-ID: <20210115172834.25b3c509@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210116002025.15706-1-daniel@iogearbox.net>
References: <20210116002025.15706-1-daniel@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 16 Jan 2021 01:20:25 +0100 Daniel Borkmann wrote:
> 1) Fix a double bpf_prog_put() for BPF_PROG_{TYPE_EXT,TYPE_TRACING} types in
>    link creation's error path causing a refcount underflow, from Jiri Olsa.
> 
> 2) Fix BTF validation errors for the case where kernel modules don't declare
>    any new types and end up with an empty BTF, from Andrii Nakryiko.
> 
> 3) Fix BPF local storage helpers to first check their {task,inode} owners for
>    being NULL before access, from KP Singh.
> 
> 4) Fix a memory leak in BPF setsockopt handling for the case where optlen is
>    zero and thus temporary optval buffer should be freed, from Stanislav Fomichev.
> 
> 5) Fix a syzbot memory allocation splat in BPF_PROG_TEST_RUN infra for
>    raw_tracepoint caused by too big ctx_size_in, from Song Liu.
> 
> 6) Fix LLVM code generation issues with verifier where PTR_TO_MEM{,_OR_NULL}
>    registers were spilled to stack but not recognized, from Gilad Reti.

I forgot the bot doesn't reply to bpf PRs.

Pulled, thanks!
