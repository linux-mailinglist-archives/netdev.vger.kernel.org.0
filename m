Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6293E174F
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 16:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240530AbhHEOuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 10:50:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:38706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233088AbhHEOuU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 10:50:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 42EF161158;
        Thu,  5 Aug 2021 14:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628175006;
        bh=erYl14tDj3mv4/TVWmONkGfxb0ywMwdNkd8GpI9HiPs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N4FLdObSBqfvg+aP34s2ncD4nGGK5ZMAD0M0EuzH/l2M8GcOk464XPEqVqKJmPW8A
         wJx+KpzzyBXZXwgOqMNdFalJnvxZG588wwMsnCd7IwCFxGTFznblsTaa0tmZJUJ8fO
         QxM36YawCdS0MmyKf6F1metsF6bwGiBDVwJ858P3CbVb3+19ZSXG2v7B0yOandYgN7
         cCDloU99R+EWjSPjBkhhimQBvWLM85jz90yaD9xFA8yDJ6z7ENie/zw9CnkRtJREtm
         4UAhgzG09iCfwwfDpLvG+YR9coNyR07savpfs4yN8PInhfPhgS+HTVubw9RDJbHOKt
         3ZVUeL/mNnNow==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 35880609D7;
        Thu,  5 Aug 2021 14:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] net: fix use-after-free bugs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162817500621.11382.5799205341486244507.git-patchwork-notify@kernel.org>
Date:   Thu, 05 Aug 2021 14:50:06 +0000
References: <cover.1628091954.git.paskripkin@gmail.com>
In-Reply-To: <cover.1628091954.git.paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, qiangqing.zhang@nxp.com,
        hslester96@gmail.com, fugang.duan@nxp.com, jdmason@kudzu.us,
        jesse.brandeburg@intel.com, colin.king@canonical.com,
        dan.carpenter@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed,  4 Aug 2021 18:48:57 +0300 you wrote:
> I've added new checker to smatch yesterday. It warns about using
> netdev_priv() pointer after free_{netdev,candev}() call. I hope, it will
> get into next smatch release.
> 
> Some of the reported bugs are fixed and upstreamed already, but Dan ran new
> smatch with allmodconfig and found 2 more. Big thanks to Dan for doing it,
> because I totally forgot to do it.
> 
> [...]

Here is the summary with links:
  - [1/2] net: fec: fix use-after-free in fec_drv_remove
    https://git.kernel.org/netdev/net/c/44712965bf12
  - [2/2] net: vxge: fix use-after-free in vxge_device_unregister
    https://git.kernel.org/netdev/net/c/942e560a3d38

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


