Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902C42CCAF6
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 01:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbgLCAUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 19:20:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:52074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726198AbgLCAUr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 19:20:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606954806;
        bh=6dnqb8iTAheOYvkqZJVEY46nIVptmBFmM+iR1px2Z7k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ebIfFMF++Pd2dLuv8G1zHf3+qHCjuK1sskXlyhznrhJnHzlkKDuMA5CvTPY+UtKat
         DX1ehua888MVzA7kDnq1XUHB7HQF+hS3y+rYd/RHAH7ZJkJ4E5HBGAS+YsqtDhdJfB
         ldah8/2/XWj8krdpFzmgA8eU12Bh0CPrwmfMQNVHjnyxCP+qA6FFdDBZKR//ooNQ7N
         hZuehshbDcaBTVm75iP5/1RzkyklXVVdOJU9eEEYQsOeUbnOu8jyDWU4LcMGimJEhj
         RXTMmIsZGNfB3CqAWZR7iQzzV9N1uV6m4KKTJVvCOMZWhW2GFoftOW+SfivH0cC34V
         mdaDfZEi6lY5Q==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf V3 0/2] xsk: fix for xsk_poll writeable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160695480669.11736.7328129700877198830.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Dec 2020 00:20:06 +0000
References: <cover.1606555939.git.xuanzhuo@linux.alibaba.com>
In-Reply-To: <cover.1606555939.git.xuanzhuo@linux.alibaba.com>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     magnus.karlsson@intel.com, daniel@iogearbox.net,
        bjorn.topel@intel.com, jonathan.lemon@gmail.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@chromium.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf.git (refs/heads/master):

On Tue,  1 Dec 2020 21:56:56 +0800 you wrote:
> V2:
>    #2 patch made some changes following magnus' opinions.
> 
> V3:
>    Regarding the function xskq_cons_present_entries, I think daniel are right,
>    I have modified it.
> 
> [...]

Here is the summary with links:
  - [bpf,V3,1/2] xsk: replace datagram_poll by sock_poll_wait
    https://git.kernel.org/bpf/bpf/c/f5da54187e33
  - [bpf,V3,2/2] xsk: change the tx writeable condition
    https://git.kernel.org/bpf/bpf/c/3413f04141aa

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


