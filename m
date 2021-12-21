Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C09547C9CC
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 00:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238051AbhLUXkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 18:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237268AbhLUXkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 18:40:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2B6AC061574;
        Tue, 21 Dec 2021 15:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80730B81A1A;
        Tue, 21 Dec 2021 23:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4871BC36AE9;
        Tue, 21 Dec 2021 23:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640130010;
        bh=jVNHRStyiVY0Sjnk9dkkVva59KRAM1l4OOZqiqsDIy4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k6cZ5m1sjrwKvLLoE/bOW9LNd0Y1zETT3lb1AR7rO7RAJ/n3G99FbSOpExVOSgy43
         n92L+i6a0XGOtVxsBCeQC7FHlm+0Dj99ow5ik19ps3V2NsRG21JTwjVtTaTzKS3E4j
         dPzF2ZHqT7eUxvyqqy9Rxqk+m699YCBO7P1u5xuf5Nh7NePgJxkHqBcsxqKAdjpgP4
         Fno1Z+ObnkZQxSPikQ452kLf+Fq+CKJenj3M6s0gVdG48IR8UGinKyC4P/+abLJE8U
         4LkXL1Kq/uP9adx4k5ba62icDlp9O1qse6DL+oEQw7CWnshYgF81Ikp0LHk1/BPjLy
         brCSRCfEG4rLg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 152BE609CC;
        Tue, 21 Dec 2021 23:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] bpf: Use struct_size() helper
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164013001008.21551.5732842230936261495.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Dec 2021 23:40:10 +0000
References: <20211220113048.2859-1-xiujianfeng@huawei.com>
In-Reply-To: <20211220113048.2859-1-xiujianfeng@huawei.com>
To:     Xiu Jianfeng <xiujianfeng@huawei.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Mon, 20 Dec 2021 19:30:48 +0800 you wrote:
> In an effort to avoid open-coded arithmetic in the kernel, use the
> struct_size() helper instead of open-coded calculation.
> 
> Link: https://github.com/KSPP/linux/issues/160
> Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
> ---
>  kernel/bpf/local_storage.c   | 3 +--
>  kernel/bpf/reuseport_array.c | 6 +-----
>  2 files changed, 2 insertions(+), 7 deletions(-)

Here is the summary with links:
  - [bpf-next] bpf: Use struct_size() helper
    https://git.kernel.org/bpf/bpf-next/c/0dd668d2080c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


