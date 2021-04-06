Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD049355E4B
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 23:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343793AbhDFV7u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 17:59:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232975AbhDFV7t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 17:59:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2B165613CC;
        Tue,  6 Apr 2021 21:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617746381;
        bh=5lQ/mw+vYWQI5JvA38HRccif3Qtxjm4VeczH3hea1qc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pdX26CBrFvAI0GHJBpMZwEVYZBuMSG1DXlWFr2cTeG+9YQBxBo97SC37nLGBXkUg+
         HpfxYZnd4tGagEWR+SFyxp9SmQ4eybwiJsGdVSZx86UzasZA9cJn8qXMX58dvD7rIL
         VmNQ2rcSCRvqwSsI7a6fIEFFVeC8d2Lyt/osdgMPazOfLqDNrejakVLZemcLXT+26A
         fmBB9NGftWcdIsgYk0Hfvn7ADaa+CPy3Ir8rHcl8Clb4n/KCrpep8VJ69zgcmSWXhx
         7+oremRPukV3/Ae+iNUuCFGCFBYcN3aRe3s5P/M268W7ug8I3gtFUBlGDrb44WmVmf
         Ttg9wEQSzbB9Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2506260A19;
        Tue,  6 Apr 2021 21:59:41 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] inode: Remove second initialization of the bpf_preload_lock
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161774638114.15399.8001840751538307402.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Apr 2021 21:59:41 +0000
References: <20210405194904.GA148013@LEGION>
In-Reply-To: <20210405194904.GA148013@LEGION>
To:     Muhammad Usama Anjum <musamaanjum@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, zhengyongjun3@huawei.com,
        dan.carpenter@oracle.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (refs/heads/master):

On Tue, 6 Apr 2021 00:49:04 +0500 you wrote:
> bpf_preload_lock is already defined with DEFINE_MUTEX. There is no need
> to initialize it again. Remove the extraneous initialization.
> 
> Signed-off-by: Muhammad Usama Anjum <musamaanjum@gmail.com>
> ---
>  kernel/bpf/inode.c | 2 --
>  1 file changed, 2 deletions(-)

Here is the summary with links:
  - inode: Remove second initialization of the bpf_preload_lock
    https://git.kernel.org/bpf/bpf-next/c/957dca3df624

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


