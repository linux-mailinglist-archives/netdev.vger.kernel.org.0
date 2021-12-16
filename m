Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81B9D477DDE
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241489AbhLPUvr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:51:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57516 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241455AbhLPUvm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:51:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6EAC61F82;
        Thu, 16 Dec 2021 20:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E152FC36AF1;
        Thu, 16 Dec 2021 20:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639687900;
        bh=Dew2NGhQprrsqyg2lanlqDsfZkNx6AKfYBjxvep4BbM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VqcJoCMZ1Jto3KlnXHw4BBhL36FR3lQb72b1spqRQLaxkdz/qnasG8qklvbupcDiA
         77tvrpe/ksv2fv0aqxD6NkgukA6EFIuMrgWyddNo3r3WlDPUxPk3lcsyIZys61TEL5
         DjcreYOfRAnwWjTjpNrPQ+SS2GSKkC3pqiUh+4Z0BJiyZ3GRTsSPice9XUnxhLYNTa
         dyqqK5XH+tegrQg838I3fyw9d3iOIjDDcd+kqbjs0ibXccSD1iyJPIcCy7bgACczLf
         Sz0WG7sXWCz4VBNCn+2c/i+mVtrxkKcrkkOy8jqnfKcSQ3K2/u55fJnwxHDXARP+vQ
         1dENuNVqkaMoQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C6F4160A3C;
        Thu, 16 Dec 2021 20:51:40 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] sfc_ef100: potential dereference of null pointer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163968790081.17466.11082813129449777501.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Dec 2021 20:51:40 +0000
References: <20211215143731.188026-1-jiasheng@iscas.ac.cn>
In-Reply-To: <20211215143731.188026-1-jiasheng@iscas.ac.cn>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lkp@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 15 Dec 2021 22:37:31 +0800 you wrote:
> The return value of kmalloc() needs to be checked.
> To avoid use in efx_nic_update_stats() in case of the failure of alloc.
> 
> Fixes: b593b6f1b492 ("sfc_ef100: statistics gathering")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
> Reported-by: kernel test robot <lkp@intel.com>
> 
> [...]

Here is the summary with links:
  - [v2] sfc_ef100: potential dereference of null pointer
    https://git.kernel.org/netdev/net/c/407ecd1bd726

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


