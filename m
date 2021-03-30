Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D92E834F20A
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 22:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232126AbhC3UU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 16:20:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231627AbhC3UUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 16:20:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 346C661968;
        Tue, 30 Mar 2021 20:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617135609;
        bh=Qtxx+uGCJgvXWDNpRjRgAZLSW86E1DEykiXDnFc8fhc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ix6zkoVr1ORZFCI2gBouUUmvMLO//4YpW678ZqlaAPmVOUre7DlElYI7lkRxk39PS
         hBufRF2uIGFRWeBSLWYas6ydgqjSQpSCvT5GieWNBhjQWXdj0Nmq7WUWnsUdpQK1M/
         CPiaNmqQ1LD62re6BQ8VVqX5f3vq91GNZmYoF2zR/mtzL7O/PYBwNjpD2rzRaoF4xI
         ex3NoLw5e2QdQuJyQyx0REvrbiUVsVF7ULfcsU+L+eSLXeuvvJ0NFtxsL6TKqATr9e
         yzALlE/xTn03fJu+6IbnsAw9ZxonfuPVwdxAoHfzNlm75buVW/n7S3kQKeyYaMhI2T
         Yy5pzY606M2ew==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2E7DB60A5B;
        Tue, 30 Mar 2021 20:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: phy: lan87xx: fix access to wrong register of
 LAN87xx
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161713560918.2790.13371551221306898976.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Mar 2021 20:20:09 +0000
References: <20210329094536.3118619-1-andre.edich@microchip.com>
In-Reply-To: <20210329094536.3118619-1-andre.edich@microchip.com>
To:     Andre Edich <andre.edich@microchip.com>
Cc:     netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Parthiban.Veerasooran@microchip.com, mans@mansr.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 29 Mar 2021 11:45:36 +0200 you wrote:
> The function lan87xx_config_aneg_ext was introduced to configure
> LAN95xxA but as well writes to undocumented register of LAN87xx.
> This fix prevents that access.
> 
> The function lan87xx_config_aneg_ext gets more suitable for the new
> behavior name.
> 
> [...]

Here is the summary with links:
  - [net-next] net: phy: lan87xx: fix access to wrong register of LAN87xx
    https://git.kernel.org/netdev/net-next/c/fdb5cc6ab3b6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


