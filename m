Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18FB047B4C5
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 22:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhLTVKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 16:10:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48576 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbhLTVKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 16:10:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E80FB6130B;
        Mon, 20 Dec 2021 21:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4EFFCC36AEA;
        Mon, 20 Dec 2021 21:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640034610;
        bh=yZmaZHdiwq2IgL+/TS0ifA/oIR8OHxhuTiOkzCgBHRw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=avCPUbWWn1EzvAVFezAFXsnQF5czXwGdXF0tIve6THuptf5NwRmCxI2v8uKHZkZK6
         BmWmE6yAWTZqEolxPTMTzEkbYzrue0aT7kggs/s59q14c/A5Yqp2hM5xXjby81Zzlg
         jp475WvcuQdCE2MwPjcYpB6smXL53PupBoZIU5+l9jFA3VEJalKuzi0QGW6WlDItYf
         ameKnN9eysncf49rx15nHfAQe4jl3qPZJG1hJ+9qWM+YSkw+e7TgfZRVYMvFO8KJn0
         PhvAEYirW3nMtj/nXXSBdVPb6gfxJSmCx2b1oW76dE1GM9vrsNDXXN/UehPJ9lqEmb
         zcrKgW4kYE20A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 28647609B3;
        Mon, 20 Dec 2021 21:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests/bpf: Correct the INDEX address in
 vmtest.sh
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164003461016.22825.8777048018858756034.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Dec 2021 21:10:10 +0000
References: <20211220050803.2670677-1-pulehui@huawei.com>
In-Reply-To: <20211220050803.2670677-1-pulehui@huawei.com>
To:     Pu Lehui <pulehui@huawei.com>
Cc:     shuah@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Mon, 20 Dec 2021 05:08:03 +0000 you wrote:
> Migration of vmtest to libbpf/ci will change the address
> of INDEX in vmtest.sh, which will cause vmtest.sh to not
> work due to the failure of rootfs fetching.
> 
> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> ---
>  tools/testing/selftests/bpf/vmtest.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [bpf-next] selftests/bpf: Correct the INDEX address in vmtest.sh
    https://git.kernel.org/bpf/bpf-next/c/426b87b111b0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


