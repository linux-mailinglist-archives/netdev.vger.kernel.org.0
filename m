Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A45F39AC5B
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 23:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbhFCVLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 17:11:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:47278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229972AbhFCVLu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 17:11:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9CBE2613EA;
        Thu,  3 Jun 2021 21:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622754605;
        bh=lbDFdHaBMvJl/yFHn0zrTbFJo59Ca7lfA6cg4Gr/kM0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jGOuMSsGIJ9AdhBUkOSBeD/2dq3LSINmzoG8/Bg2YDggux9i5r/3hn1Jm2lKjLmxF
         MmiCfieEVu3pfEQqUISCSml+NmZM5xGGt7v85oDGw2rbq3/9dScLe9/bKruDPUg0P7
         V3qhpt/X3HV7CzhZTnWZ3XtD5vsPVe+WB5aFO+8Q5QcM9LhqkDo67gs+6Hrx3YqU3H
         XwvS2KtvMu0xWWUZkLHal2PY5CgtvyPlMMzlQY1rZIMeda+BFArOIKadjuwAeAaKnx
         jWSChMRMjgKq/cqlv+1NzZgPzf8VwAAclF9lCZh3lpNA4IGKq3bbGYzYbwuNpJaVfA
         rFoG5jP7zbgtA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8DAF7609D9;
        Thu,  3 Jun 2021 21:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/7] QED NVMeTCP Offload
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275460557.4513.1472731666027007171.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 21:10:05 +0000
References: <20210602171655.23581-1-smalin@marvell.com>
In-Reply-To: <20210602171655.23581-1-smalin@marvell.com>
To:     Shai Malin <smalin@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org, aelior@marvell.com,
        mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, prabhakar.pkin@gmail.com,
        malin1024@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 2 Jun 2021 20:16:48 +0300 you wrote:
> Hi Dave,
> 
> Intro:
> ======
> This is the qed part of Marvell’s NVMeTCP offload series, shared as
> RFC series "NVMeTCP Offload ULP and QEDN Device Drive".
> This part is a standalone series, and is not dependent on other parts
> of the RFC.
> The overall goal is to add qedn as the offload driver for NVMeTCP,
> alongside the existing offload drivers (qedr, qedi and qedf for rdma,
> iscsi and fcoe respectively).
> 
> [...]

Here is the summary with links:
  - [1/7] qed: Add TCP_ULP FW resource layout
    https://git.kernel.org/netdev/net-next/c/1bd4f5716fc3
  - [2/7] qed: Add NVMeTCP Offload PF Level FW and HW HSI
    https://git.kernel.org/netdev/net-next/c/897e87a10c35
  - [3/7] qed: Add NVMeTCP Offload Connection Level FW and HW HSI
    https://git.kernel.org/netdev/net-next/c/76684ab8f4f9
  - [4/7] qed: Add support of HW filter block
    https://git.kernel.org/netdev/net-next/c/203d136e8958
  - [5/7] qed: Add NVMeTCP Offload IO Level FW and HW HSI
    https://git.kernel.org/netdev/net-next/c/ab47bdfd2e2e
  - [6/7] qed: Add NVMeTCP Offload IO Level FW Initializations
    https://git.kernel.org/netdev/net-next/c/826da4861430
  - [7/7] qed: Add IP services APIs support
    https://git.kernel.org/netdev/net-next/c/806ee7f81a2b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


