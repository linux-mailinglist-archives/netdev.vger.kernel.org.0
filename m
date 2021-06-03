Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB38B39AE12
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 00:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbhFCWbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 18:31:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:49590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231185AbhFCWbx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 18:31:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D09FC61412;
        Thu,  3 Jun 2021 22:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622759407;
        bh=vwEK4zy2QrRV8Apha+U4pwZeSrz1wq6/gqrv2kdatkA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U4jYwB3u8WQRL4cm3qJHyFb7ZhryG5vtrZ1u8vaRuwgYpxDdi+s8xxBo6JcDU5h8k
         MiZaCpa6iq9JAOk/BNl5rTTbHIktaBF0OklMb9GRqgzn3IEHASUJb3FNcBd+0S6X8Q
         BIM0+VNDZjNH6arnbIDHyFKT2SehVI6gtFCbH54fypux2w3toocCB3WAnilmlKQ9LL
         7ehzYz5itv1fSMjXCWiA1VV0GfbsSLrc9O2JKjmAbtqfquUI9O1LXbePuOiICBfHyq
         bAzyPs4YvZj/gsYf2nWHB8rMDdqOe2heVC9kYbW+A8sTs9Lfnm+Qq0Be5gwoFbzXb1
         ycMDQHzzNgkTQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C470C60BFB;
        Thu,  3 Jun 2021 22:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] bonding: remove redundant initialization of variable ret
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275940779.8870.16351209876886223050.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 22:30:07 +0000
References: <20210603131904.85093-1-colin.king@canonical.com>
In-Reply-To: <20210603131904.85093-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu,  3 Jun 2021 14:19:04 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable ret is being initialized with a value that is never read,
> it is being updated later on.  The assignment is redundant and can be
> removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - bonding: remove redundant initialization of variable ret
    https://git.kernel.org/netdev/net-next/c/92e1b57c3865

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


