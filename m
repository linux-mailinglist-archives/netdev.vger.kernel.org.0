Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7454046F1E8
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 18:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242971AbhLIRdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 12:33:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54524 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242968AbhLIRdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 12:33:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BCD0B825BF;
        Thu,  9 Dec 2021 17:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D8AACC341CC;
        Thu,  9 Dec 2021 17:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639071008;
        bh=hcxU/vwqHLc/C1J5S3lKfH0BVsiOq4i8RZAUZn1UU3A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BNGV4e0ZpC1ocg2tvmbzDRnsE2EHjkXbL8mhxeubaxSeN0ePqq4CGJjaZB+PbRkTA
         xOFvCfPta1tAnKe0SdPAVasEqqLoWyxM8QnjfEyFHcOR42eimuDsroHZCb2TClEITe
         zukO0xuJ9o/iS9He1788Vj6ebYgdoQp/km475XeX/0IHWgvxkg/PAc1a2tDlhaqMkk
         uZX5zDfRYqiJv/l0oINNNUHrk8M0lbj4KsBJEHTw3++RpFQqDp3tCfXY5Ufj8I2fuz
         +6ot9JmzeVr6a1wcQ6vFPZIJPqqSqTY6zotfB6PSV6Kp55nIu0/VvzVnzs40KwyfhC
         JL2XXT9D4ePtQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BBF9160A3C;
        Thu,  9 Dec 2021 17:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 bpf-next] samples/bpf:remove unneeded variable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163907100876.21920.14393877995704250888.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 17:30:08 +0000
References: <20211209080051.421844-1-chi.minghao@zte.com.cn>
In-Reply-To: <20211209080051.421844-1-chi.minghao@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     andrii.nakryiko@gmail.com, andrii@kernel.org, ast@kernel.org,
        bpf@vger.kernel.org, chi.minghao@zte.com.cn, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
        kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, yhs@fb.com, zealci@zte.com.cm
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Thu,  9 Dec 2021 08:00:51 +0000 you wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> return value form directly instead of
> taking this in another redundant variable.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cm>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - [PATCHv2,bpf-next] samples/bpf:remove unneeded variable
    https://git.kernel.org/bpf/bpf-next/c/ac55b3f00c32

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


