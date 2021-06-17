Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C383ABC95
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 21:21:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbhFQTWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 15:22:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:39582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233264AbhFQTWV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 15:22:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9A2F5613FB;
        Thu, 17 Jun 2021 19:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623957613;
        bh=KyQZr1dUm8eihf9rmFcrwtoIVDpukIaGJ+V4Czydxz4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nqFdhN43f5Bn5i225GM4fZOYZMVpwB+ylEtFnzGtUhUi06bK24N0xCzxa2VUSsy51
         gs8dDGdJM2K+wbuT9dHAWbvsIqmPTfQdBGOxPD0iB4pyaTL0qAHo253RjiCXmYzvuW
         f0YviklOjkxRho0SMkueLqMPQHhczK3iM6MAe8l+h/LDo0TkLparrHoRVpOUvkGIxc
         eWLrDgqmnxW7cywaCBqUseeRHha78OE+I9z/n1y2qe6FOCyKdB6UGrpamCgbcd7Ias
         UTtKr47S3pgwmLFVY+cDGMupI4YVQb7mDovIooiQulBbeEK3IT6GU8l0vS5YFyST3m
         ukpzmSTAaaI9w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 92E8960A0A;
        Thu, 17 Jun 2021 19:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8152: store the information of the pipes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162395761359.22568.8846076007661203766.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Jun 2021 19:20:13 +0000
References: <1394712342-15778-367-Taiwan-albertk@realtek.com>
In-Reply-To: <1394712342-15778-367-Taiwan-albertk@realtek.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 17 Jun 2021 18:00:15 +0800 you wrote:
> Store the information of the pipes to avoid calling usb_rcvctrlpipe(),
> usb_sndctrlpipe(), usb_rcvbulkpipe(), usb_sndbulkpipe(), and
> usb_rcvintpipe() frequently.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  drivers/net/usb/r8152.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)

Here is the summary with links:
  - [net-next] r8152: store the information of the pipes
    https://git.kernel.org/netdev/net-next/c/b67fda9a8280

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


