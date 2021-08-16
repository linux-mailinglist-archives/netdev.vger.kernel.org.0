Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C301E3ED1A4
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbhHPKKr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:10:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:41186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230397AbhHPKKh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 06:10:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C234961BB4;
        Mon, 16 Aug 2021 10:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629108605;
        bh=mBbcz0wPV1iTeXv1YxWCnxHi1j3Mwjsc3MNJ89JThuk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=p7cnrKMrlnEQtx88JI/YXxF/tZifoEq4iMEkwZf0w4dlzWkZhDz6z+tKyc3rrtK9P
         RnDzozl2jVrhNb+4VwSd2N/1FMmhFv+8O+SNexL5oZLlXdDylpoqyjFX74yK+DCRu8
         7pofkq35nYecJydmcS8Q8gnfC8Sohpi1AjQtd0Au9QwnD0+7tkWpPMSkT/rZ6RHCxA
         dd35pagS4+hma1SX8P7TWdMrfw02YX9PUwyUyuyIPUVjeTknqQsRqujwlYPXGRql1z
         MY7U2xJvDD+sGmZmDEvD/v1fH5O7+MZKzhFPHHn6lvVZ248PhcLoO6T7H6M0Cy78T3
         UDH16qKjP6Uww==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B4F8960976;
        Mon, 16 Aug 2021 10:10:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] net: phy: marvell: Add WAKE_PHY support to WOL
 event
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162910860573.22499.3474408155534541859.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Aug 2021 10:10:05 +0000
References: <20210813084508.182333-1-yoong.siang.song@intel.com>
In-Reply-To: <20210813084508.182333-1-yoong.siang.song@intel.com>
To:     Song@ci.codeaurora.org, Yoong Siang <yoong.siang.song@intel.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 13 Aug 2021 16:45:08 +0800 you wrote:
> Add Wake-on-PHY feature support by enabling the Link Up Event.
> 
> Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
> ---
>  drivers/net/phy/marvell.c | 39 ++++++++++++++++++++++++++++++++++++---
>  1 file changed, 36 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net-next,1/1] net: phy: marvell: Add WAKE_PHY support to WOL event
    https://git.kernel.org/netdev/net-next/c/6164659ff7ac

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


