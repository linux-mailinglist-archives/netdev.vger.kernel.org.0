Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5E231439E
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 00:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbhBHXUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 18:20:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:56630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229913AbhBHXUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 18:20:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 4DA6664E7A;
        Mon,  8 Feb 2021 23:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612826407;
        bh=np9RFv3gOcJXMyUj4MZKAwZzqqyq73afMA84zT7bNbQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bg0hvdj62DD2Yn1ACg150lrOUMKkbJmcuGiaum/gjqLYuHTVUwSYE0jEIHXxR4Y8E
         /yTyFjOxDBY6Isi+rzORPVFN1A88vVKKP1QB4dbnd6YTrDWtqO9ZRFTX7/WdlIIHja
         YAEDtLqiD/iTYNAeljQ2Qr2AkamYsAIAAqKIeWrnF1aQvZoTCr51BhNvYPH9CF2HTH
         2eoWLqLWoCLeR2NV48vTng7JjLEkY/35Pe/gfO26KwBxluPvPxf1I5Jv/MZPUzjJ7/
         CcQaIwJGJxPcshP/8My9LI6CEnfx1BA14GyICEHm5jS7dcTVN9lRNoYU/sKXKh5FFd
         neElzdgdRJaBg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3A2C1609D4;
        Mon,  8 Feb 2021 23:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH] net-sysfs: Add rtnl locking for getting Tx queue
 traffic class
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161282640723.30474.14084362862672002729.git-patchwork-notify@kernel.org>
Date:   Mon, 08 Feb 2021 23:20:07 +0000
References: <161282332082.135732.12397609202412953449.stgit@localhost.localdomain>
In-Reply-To: <161282332082.135732.12397609202412953449.stgit@localhost.localdomain>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        atenart@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 08 Feb 2021 14:29:18 -0800 you wrote:
> From: Alexander Duyck <alexanderduyck@fb.com>
> 
> In order to access the suboordinate dev for a device we should be holding
> the rtnl_lock when outside of the transmit path. The existing code was not
> doing that for the sysfs dump function and as a result we were open to a
> possible race.
> 
> [...]

Here is the summary with links:
  - [net-next] net-sysfs: Add rtnl locking for getting Tx queue traffic class
    https://git.kernel.org/netdev/net-next/c/b2f175648031

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


