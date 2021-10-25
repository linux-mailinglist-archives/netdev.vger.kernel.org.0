Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2414398D0
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 16:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbhJYOmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 10:42:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:34640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232779AbhJYOm3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 10:42:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6FFB060F4F;
        Mon, 25 Oct 2021 14:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635172807;
        bh=/6abjMQS5xEYvS/FjEnWDsVCa5+gy5AlYE2h4/ddhwQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rAI5ZIVkxpPC0elvZGRJ7bG6gwz3oDDt0ETYYk5yD9BTBKDwf3Ov/YD2zEAcTfwPE
         5b3DQwAQdajoqqlh2ayZFSLNxslTH7r8Q1ITOJYhbaDPG+uhMmOLLjtpbUeHOAQLe6
         fH7POmZr8PWuC6F6Jm+Npn4bV5A7wZO5cNCQn7cwTOj/wEONW12Syr6zr4Mo1GxkYu
         iSOM3tyuCfpHiWTedZ4dN3kDD6+SWzUL/Zm6vW1iDUC4MJOeN5Ybb2RCmDUoUurDlV
         24QOIKoU0eRedoaOS4nk75u78FOFULaNDOhb1vqEWBciQ6fFfxmR6Zi6QTFrzBVBFt
         S/mODMzYB0FjA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5805E60A90;
        Mon, 25 Oct 2021 14:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] usbb: catc: use correct API for MAC addresses
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163517280735.8080.10052885339658850678.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Oct 2021 14:40:07 +0000
References: <20211025141121.14828-1-oneukum@suse.com>
In-Reply-To: <20211025141121.14828-1-oneukum@suse.com>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 25 Oct 2021 16:11:21 +0200 you wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it got through appropriate helpers.
> 
> In the case of catc we need a new temporary buffer to conform
> to the rules for DMA coherency. That in turn necessitates
> a reworking of error handling in probe().
> 
> [...]

Here is the summary with links:
  - usbb: catc: use correct API for MAC addresses
    https://git.kernel.org/netdev/net-next/c/7ce9a701ac8f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


