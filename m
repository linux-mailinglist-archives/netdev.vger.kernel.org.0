Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFF93B0B94
	for <lists+netdev@lfdr.de>; Tue, 22 Jun 2021 19:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232396AbhFVRm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 13:42:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:47356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232220AbhFVRmU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Jun 2021 13:42:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DD70D61361;
        Tue, 22 Jun 2021 17:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624383604;
        bh=RTAh3y8EyGVdHYfbxr9meAEz2fGjTLGV70d1U2EQvNs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EDJlhHsJpKeyoLBEYuvXe1jI6vCSuEnn2KORKWh5emzbdu8zpKWv62EnC3cqc0lS4
         I48qWvWz/B7qgUOcIWh0jFj486lPKHtxSmXfpZycP5K7p6QvCqiemEQjoX+bFtJkc2
         TQYxcEz5v36ZpLOUOTJD0S3ANujw+nkeVzbj0o2L6ZA3HTp1RQG47BLEe76jTNDP5q
         xagnu1OAwKPJucI7+b0g2o9xsBHQCiCpWeab4sTA7HSfE5COg8PUeSfKwmM0OUiLe3
         yNgjfU4/pHX4ixghwIGaMJQ7yu03FdFCu9aWshNVxOWJT5/XnJijnqEIU9VRgFKtWo
         iPb+0qBf7qLbQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D1108609AC;
        Tue, 22 Jun 2021 17:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: broadcom: bcm4908_enet: reset DMA rings sw indexes
 properly
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162438360485.26881.5778465555411303546.git-patchwork-notify@kernel.org>
Date:   Tue, 22 Jun 2021 17:40:04 +0000
References: <20210622052415.12040-1-zajec5@gmail.com>
In-Reply-To: <20210622052415.12040-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tpIDx6YWplYzVAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        hauke@hauke-m.de, rafal@milecki.pl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 22 Jun 2021 07:24:15 +0200 you wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Resetting software indexes in bcm4908_dma_alloc_buf_descs() is not
> enough as it's called during device probe only. Driver resets DMA on
> every .ndo_open callback and it's required to reset indexes then.
> 
> This fixes inconsistent rings state and stalled traffic after interface
> down & up sequence.
> 
> [...]

Here is the summary with links:
  - [net] net: broadcom: bcm4908_enet: reset DMA rings sw indexes properly
    https://git.kernel.org/netdev/net/c/ddeacc4f6494

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


