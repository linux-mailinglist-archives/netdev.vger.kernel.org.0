Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2E3C2FF9E0
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 02:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbhAVBVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 20:21:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:46728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726433AbhAVBVN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 20:21:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 7F577239EF;
        Fri, 22 Jan 2021 01:20:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611278431;
        bh=8difEtIjjmN87rvDGs8GNBBRdMEvl7YKuBBq4A0cpwU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Fos0RIdjuHiXAShFizAmHh/qJhKARhNSS1GAQ0CgDY7AfuBPDQNgqhkn/VQpoq+DX
         j7hLktrxXx/uSI3STDg5zNzd3jXfJbPRQt+wGVOWb/fT+dNuucdaJ4Y5z26IySUBEl
         kvzHtIWTv4KUDf9fIk2sZvgzKmpmd3dUhmELo0ZOn11JffhDtXX+kKK9bE4eF3MePi
         5yNQ4UobVDcjLUhzYyjdfGEvDXxSOX+B+ClgirmfCXyHUQMu3zogVa6vQsYatRz/xH
         4/vmS3/xSncpuFIDuHDoT/Cd3+T1MpjuwXqmgFJUVoL7A188j5NA4rDG0EE86p+jIv
         Bj5WICSSuaVUQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 7460560591;
        Fri, 22 Jan 2021 01:20:31 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] cxgb4: remove bogus CHELSIO_VPD_UNIQUE_ID
 constant
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161127843147.8998.18442623206376056097.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Jan 2021 01:20:31 +0000
References: <644ef22f-e86a-5cc1-0f27-f873ab165696@gmail.com>
In-Reply-To: <644ef22f-e86a-5cc1-0f27-f873ab165696@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     rajur@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 20 Jan 2021 08:27:14 +0100 you wrote:
> The comment is quite weird, there is no such thing as a vendor-specific
> VPD id. 0x82 is the value of PCI_VPD_LRDT_ID_STRING. So what we are
> doing here is simply checking whether the byte at VPD address VPD_BASE
> is a valid string LRDT, same as what is done a few lines later in
> the code.
> LRDT = Large Resource Data Tag, see PCI 2.2 spec, VPD chapter
> 
> [...]

Here is the summary with links:
  - [v2,net-next] cxgb4: remove bogus CHELSIO_VPD_UNIQUE_ID constant
    https://git.kernel.org/netdev/net-next/c/05fcc25662a3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


