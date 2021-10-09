Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237DD427484
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 02:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243954AbhJIAMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 20:12:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243818AbhJIAMD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 20:12:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0EB2F60FC3;
        Sat,  9 Oct 2021 00:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633738207;
        bh=98gtCc2rJJsNDXtGpCkdID9cTcNp76kpQ/7acnYzelI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TRsFyhMf8bUdmsDncV2P8EnnSYJIsq3C/Y3Ui/SolyAW6cUfCs6rfg/P9X9jc9Z0i
         CSf2qopxm0htj3FdRB636vhnqhX3A5tj3arBhyu3g3MDQ0hPeYDn/TdtKI7Xud8zU5
         qCuUlLjf1hUb3Uh9QfXQG7WhAKLz7xin3SB15ivCUVyMRIK85Ab3XyBlgtx6SE7tSy
         hswHCwWFFJwmM8Z24v5GrBZF7FSAfq5yKuF6xSWbrJJTytJxejALnv7pPKY7eYEuE1
         fw1zGf5QDFZSXU/P+PVHDiP7C1GVFjsTi8BsXqIt0lb740cFaAQy4WbbeKWJtcMeil
         QSTvxOypAX+Zw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 016BC60A38;
        Sat,  9 Oct 2021 00:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftests/tls: add SM4 GCM/CCM to tls selftests
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163373820700.1766.226175234547653621.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Oct 2021 00:10:07 +0000
References: <20211008091745.42917-1-tianjia.zhang@linux.alibaba.com>
In-Reply-To: <20211008091745.42917-1-tianjia.zhang@linux.alibaba.com>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, shuah@kernel.org,
        borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  8 Oct 2021 17:17:45 +0800 you wrote:
> Add new cipher as a variant of standard tls selftests.
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> ---
>  tools/testing/selftests/net/tls.c | 28 ++++++++++++++++++++++++++--
>  1 file changed, 26 insertions(+), 2 deletions(-)

Here is the summary with links:
  - selftests/tls: add SM4 GCM/CCM to tls selftests
    https://git.kernel.org/netdev/net-next/c/e506342a03c7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


