Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4296245D37D
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 04:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345557AbhKYDPW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 22:15:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:36312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344083AbhKYDNU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 22:13:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 6286961106;
        Thu, 25 Nov 2021 03:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637809810;
        bh=e4FmjYyJ4ncXLVumKFfhC2FzIZoBgu9XrN1IVOmsdS0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DM8wVnTNdkfSVa9PrlhIViXnsOyxGZDFTLT9B4S9wkDC1Ahf252AMyu55GGdouHtf
         5OTGAGnTHR5iJEQPsS3zMChnUMBn0LgaF51Oiwd1shKsFYSsTB8dxvU/te8i1rXIdf
         HqRuftaVQzhmu7Ryuti6CunXcbToT5lpR2Yh/5lvyi5PLgV4LjIZBgRbw0Y8+iVwHm
         i1hQseHx6rg1IsSTNQaggJIycq4IblgEsuwWGH+yKa7UVM9UmWBExAJkJuoS2bM9u7
         Up69lCpiYLOmikK6Zi1pP4S5g037bL8t78bemSXFodIOQFHmcpVoj0BNthN6bu6gam
         qRK41Xmj49anA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 52E4E60A50;
        Thu, 25 Nov 2021 03:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: allow CAP_NET_RAW to setsockopt SO_PRIORITY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163780981033.14115.11254342260682596351.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Nov 2021 03:10:10 +0000
References: <20211123203702.193221-1-zenczykowski@gmail.com>
In-Reply-To: <20211123203702.193221-1-zenczykowski@gmail.com>
To:     =?utf-8?q?Maciej_=C5=BBenczykowski_=3Czenczykowski=40gmail=2Ecom=3E?=@ci.codeaurora.org
Cc:     maze@google.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 23 Nov 2021 12:37:02 -0800 you wrote:
> From: Maciej Żenczykowski <maze@google.com>
> 
> CAP_NET_ADMIN is and should continue to be about configuring the
> system as a whole, not about configuring per-socket or per-packet
> parameters.
> Sending and receiving raw packets is what CAP_NET_RAW is all about.
> 
> [...]

Here is the summary with links:
  - net: allow CAP_NET_RAW to setsockopt SO_PRIORITY
    https://git.kernel.org/netdev/net-next/c/a1b519b74548

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


