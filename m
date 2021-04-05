Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0563D3542AD
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 16:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241284AbhDEOUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 10:20:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237450AbhDEOUO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 10:20:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 96A6A613B1;
        Mon,  5 Apr 2021 14:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617632408;
        bh=1yM1ydajs00nts4Yq8R6FyJMbgeKaGI1O2iM3aO8eks=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=APyn1fuXvSuXnWJ90Fq8DQ2E1Wv19Tg8UcbGiVfz4N7s9WwU8kMfbocSstAJJXztN
         4ZpQirlGZ38cVy1Rk8usk1EJgEsj6sH0XLZXnU2gSgb5sILQ4yyox2rlNaCp6VzgAs
         XyIUuCKc3jmC//idql7CkATnXYt2ktpz2mww8eMEDbCgtqSA4TdbjjfsYURX/wyFMM
         C0mTz1966JyGHiepRclpnmLuRoYqpS8ac98GVUFJBp1ZeqgydsSw/8bK0/I2ikZ1O4
         1gHs7/4iGfIxG5toKxvx4BpCvvqr+6PTdI+x6sRZgAf59/Uw9lkSkK90lP2uHTx6JF
         b4h1wB0pcBM6w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8737960A00;
        Mon,  5 Apr 2021 14:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] libbpf: Fix KERNEL_VERSION macro
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161763240854.530.7712695951554965162.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Apr 2021 14:20:08 +0000
References: <20210405040119.802188-1-hengqi.chen@gmail.com>
In-Reply-To: <20210405040119.802188-1-hengqi.chen@gmail.com>
To:     Hengqi Chen <hengqi.chen@gmail.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, andrii@kernel.org,
        yhs@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Mon,  5 Apr 2021 12:01:19 +0800 you wrote:
> Add missing ')' for KERNEL_VERSION macro.
> 
> Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
> ---
>  tools/lib/bpf/bpf_helpers.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [bpf-next] libbpf: Fix KERNEL_VERSION macro
    https://git.kernel.org/bpf/bpf-next/c/1e1032b0c4af

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


