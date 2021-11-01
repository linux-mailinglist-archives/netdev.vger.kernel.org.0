Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58AC7441E00
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbhKAQWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:22:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:44576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232693AbhKAQWm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 12:22:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C560961175;
        Mon,  1 Nov 2021 16:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635783608;
        bh=OptXrCd0FiA/UfuAuNlM5eF1pJvaE/59/NVDLUdYUP0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s477AHQmBaS8z5fxwFA+Vn5weBwTLeDaSsy+v9rb3Roc/Le6vQdbgWDEo1em+kk72
         3VAH5Kioosn2PRj8DQmoQsupOQnJZDvEtNnFwAEPdtbFEOVhT7nDPc8RshspxNOSxW
         l73rG8MwrKG5xsnqFz7dZDfL9ffHP3nBtxz8EXCXRbAyHy9r6Yr68x9/lwDYTAmqXk
         Em3C0q9Y1v/7qa8HpdSrt7VOgerNyMPJusy4YKn/KkIghWX8ZqWVTyeehEl6IXShxe
         Av+eos/FiMz25O5KJqUIUhl15Jr9RHKE9JogewTG5+yq6MMtwDcW2YoigX2lProtZC
         9+8eH82y0LEjg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B8EEA60BD0;
        Mon,  1 Nov 2021 16:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATHC bpf v6 1/3] skmsg: lose offset info in sk_psock_skb_ingress
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163578360875.18867.1488273405731214405.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Nov 2021 16:20:08 +0000
References: <20211029141216.211899-1-liujian56@huawei.com>
In-Reply-To: <20211029141216.211899-1-liujian56@huawei.com>
To:     Liu Jian <liujian56@huawei.com>
Cc:     john.fastabend@gmail.com, daniel@iogearbox.net,
        jakub@cloudflare.com, lmb@cloudflare.com, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        xiyou.wangcong@gmail.com, alexei.starovoitov@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri, 29 Oct 2021 22:12:14 +0800 you wrote:
> If sockmap enable strparser, there are lose offset info in
> sk_psock_skb_ingress. If the length determined by parse_msg function
> is not skb->len, the skb will be converted to sk_msg multiple times,
> and userspace app will get the data multiple times.
> 
> Fix this by get the offset and length from strp_msg.
> And as Cong suggestion, add one bit in skb->_sk_redir to distinguish
> enable or disable strparser.
> 
> [...]

Here is the summary with links:
  - [PATHC,bpf,v6,1/3] skmsg: lose offset info in sk_psock_skb_ingress
    https://git.kernel.org/bpf/bpf-next/c/7303524e04af
  - [PATHC,bpf,v6,2/3] selftests, bpf: Fix test_txmsg_ingress_parser error
    https://git.kernel.org/bpf/bpf-next/c/b556c3fd4676
  - [PATHC,bpf,v6,3/3] selftests, bpf: Add one test for sockmap with strparser
    https://git.kernel.org/bpf/bpf-next/c/d69672147faa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


