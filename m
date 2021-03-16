Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B9D33CD57
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 06:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbhCPFaP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 01:30:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230330AbhCPFaI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 01:30:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 53463650EB;
        Tue, 16 Mar 2021 05:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615872608;
        bh=Jfbek6IwkNe8ICEeoHLfAofEcAHzeO7Toa0Aqg1o1ZQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JROCvxRDP1BdDTmwXnHwmQAambMb9c31CuwkBm1ED2Ps0liBuaj3loL0H4q+SUYKN
         508hGkP2xLdyYuf83hOGn05jpcMlYpRmkRb1kIUlzYCOyAtFTIDq2MNqtxumPywfrl
         dWQSjsw7ujfpWXTa5Fanj0Qi9cSLbf64J03/wcVAbRDYW4IA7qvOILoO8Y0+Yz/2hw
         QQgJXe1vw5VWmf4Y1GgfYA3/gXitviyKmd54me3gqS0+42t/+AOsQmQazS+aofw0fa
         rPzirOeWFN/JLsbVJMQKvVQRbU7Ck8mmPqXAtGn6q2xMEloPlNwbiyHeW4qrvkZXGZ
         faQ8S7IIy0cIw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3F7A660A3D;
        Tue, 16 Mar 2021 05:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bpf: selftests: remove unused 'nospace_err' in tests for
 batched ops in array maps
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161587260825.28244.7747420744552197162.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Mar 2021 05:30:08 +0000
References: <20210315132954.603108-1-pctammela@gmail.com>
In-Reply-To: <20210315132954.603108-1-pctammela@gmail.com>
To:     Pedro Tammela <pctammela@gmail.com>
Cc:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Mon, 15 Mar 2021 14:29:51 +0100 you wrote:
> This seems to be a reminiscent from the hashmap tests.
> 
> Signed-off-by: Pedro Tammela <pctammela@gmail.com>
> ---
>  tools/testing/selftests/bpf/map_tests/array_map_batch_ops.c | 5 -----
>  1 file changed, 5 deletions(-)

Here is the summary with links:
  - bpf: selftests: remove unused 'nospace_err' in tests for batched ops in array maps
    https://git.kernel.org/bpf/bpf-next/c/23f50b5ac331

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


