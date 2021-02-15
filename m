Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F328C31C44F
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 00:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhBOXVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 18:21:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:33226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229930AbhBOXUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 18:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A673E64DF4;
        Mon, 15 Feb 2021 23:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613431207;
        bh=x7bGegF9+wSasEWd2L4AivrcElOEby6/T/Fzat9KdCY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=G2oC2kDr3XrJaD/kiJmyZvYCkCVfHHzXGCM27DLWRhaCzeHHebCb+2fxwmuyWFY4d
         2EQTNAQ0mZjARp4cJzwO8kciCPW27jCiXQuZBjoLzsTNFsTO733gZxoblnGQAspF4r
         FWJVzsg+ETT3qBRWcOyIJ/t+kbTTGYeHxu/kVdF31IjqQ/bp5Ftd47dm7+65yOUIZ9
         JkTdpt6+OitY62PUELMspRkG655bh2SBHV9QcE3/wZBYbl7pwKvjKJ6bAKoN//j1Sg
         RXxketlDUe8p468tmRbP7v4S81LiCt15GXAaTK7zOSl33KD0jJJ2gGUncPuI1MDPLR
         b2uYidfUdOIaA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 95BE6609D9;
        Mon, 15 Feb 2021 23:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ibmvnic: add memory barrier to protect long term buffer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161343120760.10830.18267099576537035370.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Feb 2021 23:20:07 +0000
References: <20210213024840.56036-1-ljp@linux.ibm.com>
In-Reply-To: <20210213024840.56036-1-ljp@linux.ibm.com>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, drt@linux.ibm.com,
        tlfalcon@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 12 Feb 2021 20:48:40 -0600 you wrote:
> dma_rmb() barrier is added to load the long term buffer before copying
> it to socket buffer; and dma_wmb() barrier is added to update the
> long term buffer before it being accessed by VIOS (virtual i/o server).
> 
> Fixes: 032c5e82847a ("Driver for IBM System i/p VNIC protocol")
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
> Acked-by: Thomas Falcon <tlfalcon@linux.ibm.com>
> 
> [...]

Here is the summary with links:
  - [net] ibmvnic: add memory barrier to protect long term buffer
    https://git.kernel.org/netdev/net/c/42557dab78ed

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


