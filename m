Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D9212DA6D9
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 04:32:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgLODbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 22:31:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:46122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgLODar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 22:30:47 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608003006;
        bh=nMm+whYuvJjPzdM2B09GjvAvwKHGHE6M3r8Gzml6gQ0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OQYLm3ioxrTiQrBeWse5s49Imvg96TUu2yW862randKSwo3JEVAVIZK08/3tLZAgZ
         6Vn0kRQPKKNjQLOFm7OXt4qchE8vLLDlznUttvOFbgbc+w/HS7QGmtMAWJJzPXQiuf
         wkYFrc6YmTf9DRlX9ogAL3O50sC3W05wEeBgfrcYzkkpSOJAiHZn45oA2QeJAGlzEH
         vqk4SC+1yIrhUomHO/rkHqVmTcXM0aFJh9ZDZqVzNk9qJz3QJfcrKPYUDMKNy+7jKx
         1Q9+CUHiOAPSUEt9pSCrIUS2WDJPa33Ot4YhBAzKUXcXrQBAOTMOfEKtPWxVB3/DTq
         NSy/iO4vR5Nqg==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfc: s3fwrn5: Release the nfc firmware
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160800300676.31797.12277059792599912184.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Dec 2020 03:30:06 +0000
References: <20201213095850.28169-1-bongsu.jeon@samsung.com>
In-Reply-To: <20201213095850.28169-1-bongsu.jeon@samsung.com>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     krzk@kernel.org, linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bongsu.jeon@samsung.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 13 Dec 2020 18:58:50 +0900 you wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> add the code to release the nfc firmware when the firmware image size is
> wrong.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> [...]

Here is the summary with links:
  - [net-next] nfc: s3fwrn5: Release the nfc firmware
    https://git.kernel.org/netdev/net-next/c/a4485baefa1e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


