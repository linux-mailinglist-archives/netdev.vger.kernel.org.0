Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEB2F3531AE
	for <lists+netdev@lfdr.de>; Sat,  3 Apr 2021 01:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234908AbhDBXuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 19:50:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235228AbhDBXuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Apr 2021 19:50:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id F1A0561184;
        Fri,  2 Apr 2021 23:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617407409;
        bh=1IVvjuyZ1QICzilp2XowpWfGo8fIWk7amz0N5v9AgA0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YLoPcRYbTVkesYusNKy60PYlZAMuINHzl8HZc6HFy3N/z0gGRT1lXciXCLBkzMeVk
         BeJlb4QfscvjyHYXzSBjs0bhnSDuAp/uZgCUkWcNu06dXFNQHqatACJP7zRuWuvNNe
         AnyZ2y6gq1i1QdlLBMv3Cb7ZXxSWKYSo3hSKPIx0FvMWBYDoYlixB/ckKO/vmrUjpd
         5XptuOyzVF8+aqMg64nU+9guw4D0sn96x9idXV3cm2pv1hjj1yUcmqC46KS3hz55yX
         0aLUm6QkZN/Rc9UrdaJ3UV65ZYk+G+t7hUchlwyoYfNbKD+DK4hijMQOBjJekGgJ+Y
         C26NCKHoGXyMA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E648D609DC;
        Fri,  2 Apr 2021 23:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [Patch bpf-next] bpf: remove unused parameter from ___bpf_prog_run
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161740740893.27506.2977951925004823983.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Apr 2021 23:50:08 +0000
References: <20210331075135.3850782-1-hefengqing@huawei.com>
In-Reply-To: <20210331075135.3850782-1-hefengqing@huawei.com>
To:     He Fengqing <hefengqing@huawei.com>
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, kpsingh@kernel.org,
        john.fastabend@gmail.com, yhs@fb.com, songliubraving@fb.com,
        kafai@fb.com, andrii@kernel.org, daniel@iogearbox.net,
        ast@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Wed, 31 Mar 2021 07:51:35 +0000 you wrote:
> 'stack' parameter is not used in ___bpf_prog_run,
> the base address have been set to FP reg. So consequently remove it.
> 
> Signed-off-by: He Fengqing <hefengqing@huawei.com>
> ---
>  kernel/bpf/core.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [bpf-next] bpf: remove unused parameter from ___bpf_prog_run
    https://git.kernel.org/bpf/bpf-next/c/2ec9898e9c70

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


