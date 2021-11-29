Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E075461CE2
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 18:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346560AbhK2Rp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 12:45:29 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39142 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbhK2Rn3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 12:43:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65BAEB8159F;
        Mon, 29 Nov 2021 17:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 108C1C53FAD;
        Mon, 29 Nov 2021 17:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638207609;
        bh=dccMp4qWzGZyhIoQfq16V2DtLbONeetd98FYSGIoB4A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Co5bd/d84jArxton/fOudSQoUKD15LpRUftXX+jf6EQTgSYeoVlKlHaPxLzX79TdC
         tkmNILuLng1upcJbN/lxEWFfXripH+La1ZU3HjsqoB8k3SVUyxfB2qw4hFgkgzau78
         6q2fFrAvUovDulQV+C+uYWgX0XDGtgzqe8wu3u+Xb5vNrx23KUkpMz0q0baTLgf3Xb
         4xPjzQ6JJP85nXOGEqcfAsDI8g+aBo6TL1luFbSTsUAvI+ahaUILwUOUsEn/0qMhwf
         QvZSCmkvpv0nnRLao7jLciA0lZMzrJXoe/cetwRKZObMg3Jdl/aMZmMLA0c8PSK2ao
         ZTj9b9GbwBgUg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id DC816609D5;
        Mon, 29 Nov 2021 17:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf] libbpf: silence uninitialized warning/error in
 btf_dump_dump_type_data
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163820760889.6331.14578711690771500673.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 17:40:08 +0000
References: <1638180040-8037-1-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1638180040-8037-1-git-send-email-alan.maguire@oracle.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Mon, 29 Nov 2021 10:00:40 +0000 you wrote:
> When compiling libbpf with gcc 4.8.5, we see:
> 
>   CC       staticobjs/btf_dump.o
> btf_dump.c: In function ‘btf_dump_dump_type_data.isra.24’:
> btf_dump.c:2296:5: error: ‘err’ may be used uninitialized in this function [-Werror=maybe-uninitialized]
>   if (err < 0)
>      ^
> cc1: all warnings being treated as errors
> make: *** [staticobjs/btf_dump.o] Error 1
> 
> [...]

Here is the summary with links:
  - [bpf] libbpf: silence uninitialized warning/error in btf_dump_dump_type_data
    https://git.kernel.org/bpf/bpf-next/c/43174f0d4597

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


