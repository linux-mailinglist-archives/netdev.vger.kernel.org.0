Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 872902AA7E1
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 21:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728437AbgKGUUF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 15:20:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:52412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgKGUUF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 15:20:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604780404;
        bh=P6zCYHZK7DRGRT9TolXwmnMhZA2U+nZvMMt3n/9Kzns=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OmbVtIhWGqwm8+Udi9pE7nuXjVwLE72AixkOg7iMbjBFZ1qzVuwAaVAlVssbp/Pt4
         PU/tE1dWTpMY5Nbakuhze4zhmynEV/mhC0ESZkT2si95AlDhI1qMJqoBQ52wvuwjAo
         L86EVuBxXvGFW8ro+89g0tkJ6I58COxnJWIt7eFs=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] r8169: disable hw csum for short packets on all chip
 versions
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160478040458.5539.16964128639762448744.git-patchwork-notify@kernel.org>
Date:   Sat, 07 Nov 2020 20:20:04 +0000
References: <7fbb35f0-e244-ef65-aa55-3872d7d38698@gmail.com>
In-Reply-To: <7fbb35f0-e244-ef65-aa55-3872d7d38698@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 5 Nov 2020 18:14:47 +0100 you wrote:
> RTL8125B has same or similar short packet hw padding bug as RTL8168evl.
> The main workaround has been extended accordingly, however we have to
> disable also hw checksumming for short packets on affected new chip
> versions. Instead of checking for an affected chip version let's
> simply disable hw checksumming for short packets in general.
> 
> v2:
> - remove the version checks and disable short packet hw csum in general
> - reflect this in commit title and message
> 
> [...]

Here is the summary with links:
  - [v2,net] r8169: disable hw csum for short packets on all chip versions
    https://git.kernel.org/netdev/net/c/847f0a2bfd2f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


