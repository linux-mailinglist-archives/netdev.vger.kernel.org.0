Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3909C2F8AA6
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 03:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbhAPCAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 21:00:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:37618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726065AbhAPCAt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Jan 2021 21:00:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id B53C323A52;
        Sat, 16 Jan 2021 02:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610762408;
        bh=DmJ4csxoeyfo4RsppM24pr6ahENfcj/S0ENm3c9iQd4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n0ecl2udrfU6J1SpKdpII4dqV5WSZ3AIg4EKMtd+vCtqkMdAgGCjKBRRU7dNZY729
         R/GlcNAcb2hnUetPgBxTkkvJxMlLPXKswI+CsVJ+zSi7q5Dnt+DStiXrDJL3AEUDxA
         Us6aqkppfRsKAmEbUxq9PhPP0EsSvCnMD6ctqPPp6Jt4VDYnvwGG3lNzy8KR4tJ/P3
         M3kX1HfFpuNeieiHtOscc3+vqIwCVDgiRFu6jqNFXFOIUVY6SLVggsIPZKxyoAZwta
         LmW+z1QVClfmdIDOsYXrko6d2YxUUlrGRQVmL4HnU7zyBXyRETYuXn2je+HIIxf3lb
         xf5gFTObnsOUw==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id A6D9F60649;
        Sat, 16 Jan 2021 02:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ks8851: remove definition of DEBUG
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161076240867.31907.16058522188590513095.git-patchwork-notify@kernel.org>
Date:   Sat, 16 Jan 2021 02:00:08 +0000
References: <20210115153128.131026-1-trix@redhat.com>
In-Reply-To: <20210115153128.131026-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, marex@denx.de,
        andrew@lunn.ch, zhengyongjun3@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 15 Jan 2021 07:31:28 -0800 you wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Defining DEBUG should only be done in development.
> So remove DEBUG.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> 
> [...]

Here is the summary with links:
  - net: ks8851: remove definition of DEBUG
    https://git.kernel.org/netdev/net-next/c/3ada665b8fab

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


