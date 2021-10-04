Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90B45420AC8
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 14:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbhJDMWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 08:22:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233134AbhJDMV7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 08:21:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 854D3613A2;
        Mon,  4 Oct 2021 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633350010;
        bh=DMFxEWTqfbnq1ZABZ316JYtNGzInIZEnFJF/Sr6NcIo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=neOu2rpEKv/cI+7zfUa47vyjK7828WWiIo2X0+YsB0ZF2KMzjnD+0VzZCruLGDe6s
         +EFZEW733ELPWz7mG5RbWQiAqcyGrOQaCqGw92e7QeZXKNBa9DBmlsYcXO9TLnui+H
         drNjwtQTQ/tOXOnZFOHFo3zL5wkGfHZPSY++GQZ+iN3eax7SBi8GCkjvQIvExEOAyD
         QYb73eMKrUcVKvRdzBDBQertzbV4F25P4/z9+sAf8Ho/jcLlDkbXXfkPK5pG+xT+Vt
         4hKJ6vxxvn/RKzutwllTRRbc9cKZybqY56xGymy5C56dAaHE+NTIfwNStu01YKaihF
         rkMOJfbkLn12Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7979F608AF;
        Mon,  4 Oct 2021 12:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 00/13] qed: new firmware version 8.59.1.0 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163335001049.30570.14249227941766939428.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Oct 2021 12:20:10 +0000
References: <20211004065851.1903-1-pkushwaha@marvell.com>
In-Reply-To: <20211004065851.1903-1-pkushwaha@marvell.com>
To:     Prabhakar Kushwaha <pkushwaha@marvell.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, aelior@marvell.com, smalin@marvell.com,
        jhasan@marvell.com, mrangankar@marvell.com,
        prabhakar.pkin@gmail.com, malin1024@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 4 Oct 2021 09:58:38 +0300 you wrote:
> This series integrate new firmware version 8.59.1.0, along with updated
> HSI (hardware software interface) to use the FW, into the family of
> qed drivers (fastlinq devices). This FW does not reside in the NVRAM.
> It needs to be programmed to device during driver load as the part of
> initialization sequence.
> 
> Similar to previous FW support series, this FW is tightly linked to
> software and pf function driver. This means FW release is not backward
> compatible, and driver should always run with the FW it was designed
> against.
> 
> [...]

Here is the summary with links:
  - [v2,01/13] qed: Fix kernel-doc warnings
    https://git.kernel.org/netdev/net-next/c/19198e4ec97d
  - [v2,02/13] qed: Remove e4_ and _e4 from FW HSI
    https://git.kernel.org/netdev/net-next/c/fb09a1ed5c6e
  - [v2,03/13] qed: Split huge qed_hsi.h header file
    https://git.kernel.org/netdev/net-next/c/ee824f4bcc10
  - [v2,04/13] qed: Update common_hsi for FW ver 8.59.1.0
    https://git.kernel.org/netdev/net-next/c/484563e230a8
  - [v2,05/13] qed: Update qed_mfw_hsi.h for FW ver 8.59.1.0
    https://git.kernel.org/netdev/net-next/c/f2a74107f1e1
  - [v2,06/13] qed: Update qed_hsi.h for fw 8.59.1.0
    https://git.kernel.org/netdev/net-next/c/fe40a830dcde
  - [v2,07/13] qed: Use enum as per FW 8.59.1.0 in qed_iro_hsi.h
    https://git.kernel.org/netdev/net-next/c/3091be065f11
  - [v2,08/13] qed: Update FW init functions to support FW 8.59.1.0
    https://git.kernel.org/netdev/net-next/c/b90cb5385af7
  - [v2,09/13] qed: Add '_GTT' suffix to the IRO RAM macros
    https://git.kernel.org/netdev/net-next/c/e2dbc2237692
  - [v2,10/13] qed: Update debug related changes
    https://git.kernel.org/netdev/net-next/c/6c95dd8f0aa1
  - [v2,11/13] qed: Update TCP silly-window-syndrome timeout for iwarp, scsi
    https://git.kernel.org/netdev/net-next/c/3a6f5d0cbda3
  - [v2,12/13] qed: Update the TCP active termination 2 MSL timer ("TIME_WAIT")
    https://git.kernel.org/netdev/net-next/c/a64aa0a8b991
  - [v2,13/13] qed: fix ll2 establishment during load of RDMA driver
    https://git.kernel.org/netdev/net-next/c/17696cada74f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


