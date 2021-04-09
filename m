Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6031D35A78E
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 22:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234848AbhDIUAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 16:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:38266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234602AbhDIUAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 16:00:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D1C5E61104;
        Fri,  9 Apr 2021 20:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617998437;
        bh=mgXTe2IacdEbAxHoFNMRWirgq258MSYKecORZt/Gmd4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZdYAveyrUUnRrTHoCb3652APjC69w/uvgtWaSXi2Dy/Lx65kuPxO8B3EzMAsL+DwW
         Qy4Emart51lq7SZB+62XDRx+SxBUhA0QmtND9t23CfviubNbcn/VMasi92O6Qonerf
         lBFcHXy9tgOWJrGDwR7ZB3cFbRhUOL7/8ZoIIH07Odbs/qUkaXeiOYoxdcmHUDlgu+
         LXBnzxdsT5SDe4CnkrzqFJGjw07ezTW9Nmoz2+kTa/WFYgx0pZ6TyHsITjwbZRdQOA
         1qym4lzYbyMi0RfkXSrN10lUcllQB6LWtPG3CZACepBBptHZh6L+vl+iHJM210lmFM
         2ZhUO/P62tLqw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C7B6260C08;
        Fri,  9 Apr 2021 20:00:37 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v1] lan743x: fix ethernet frame cutoff issue
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161799843781.9153.1286906568340511297.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Apr 2021 20:00:37 +0000
References: <20210409003904.8957-1-TheSven73@gmail.com>
In-Reply-To: <20210409003904.8957-1-TheSven73@gmail.com>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     bryan.whitehead@microchip.com, davem@davemloft.net,
        kuba@kernel.org, george.mccollister@gmail.com,
        hkallweit1@gmail.com, andrew@lunn.ch, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  8 Apr 2021 20:39:04 -0400 you wrote:
> From: Sven Van Asbroeck <thesven73@gmail.com>
> 
> The ethernet frame length is calculated incorrectly. Depending on
> the value of RX_HEAD_PADDING, this may result in ethernet frames
> that are too short (cut off at the end), or too long (garbage added
> to the end).
> 
> [...]

Here is the summary with links:
  - [net,v1] lan743x: fix ethernet frame cutoff issue
    https://git.kernel.org/netdev/net/c/3bc41d6d2721

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


