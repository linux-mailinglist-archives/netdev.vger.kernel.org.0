Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50F1E3BF460
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 06:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbhGHECp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 00:02:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229467AbhGHECo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Jul 2021 00:02:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6DF4861CDE;
        Thu,  8 Jul 2021 04:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625716803;
        bh=gaLB7CEkwL3YfQy/zTvUokaDhs+24Y7DrwCLjqi5zpc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u1MGKLuma4Vj/LsTcmaE6NMZ8w4lpy+RFMBsrRvoL7Ba0bQX5J3DKSL2DPR9lSFks
         Gar4JOcw9XTK/6Lf2kvO4NNNtt+muSjST5iEvdZgs8BGuMsVVrfTRxJxN3SlEQZ9n2
         ljvWCqwcSPSHdCvV27olT5eknt/MzCUosZx5MB3X9DQyHabKBhx3wM4qYvVysEjwAl
         iUHp7OwpKAf9E+dxwi595BQrY3638gu6ahB/Ny8xS6fMayqisMPjEB0uFdkqjSa+r3
         SxnNDEKvTDHhUK0y4TV6VnQ/nbu4MUpgimmknulXhKOqUNZV+42NwX9vK8GqLvgs2N
         ZzYhnzGzuA/kQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5DBE7609B4;
        Thu,  8 Jul 2021 04:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sock: unlock on error in sock_setsockopt()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162571680337.17275.10785864640779511123.git-patchwork-notify@kernel.org>
Date:   Thu, 08 Jul 2021 04:00:03 +0000
References: <YOV7XH5Sqx+ZHghC@mwanda>
In-Reply-To: <YOV7XH5Sqx+ZHghC@mwanda>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     davem@davemloft.net, yangbo.lu@nxp.com, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com,
        mathew.j.martineau@linux.intel.com, aahringo@redhat.com,
        linmiaohe@huawei.com, fw@strlen.de, xiangxia.m.yue@gmail.com,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed, 7 Jul 2021 13:01:00 +0300 you wrote:
> If copy_from_sockptr() then we need to unlock before returning.
> 
> Fixes: d463126e23f1 ("net: sock: extend SO_TIMESTAMPING for PHC binding")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>  net/core/sock.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net] sock: unlock on error in sock_setsockopt()
    https://git.kernel.org/netdev/net/c/271dbc318432

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


