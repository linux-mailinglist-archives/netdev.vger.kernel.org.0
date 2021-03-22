Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A9F34505F
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:01:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhCVUAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:00:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:43312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230284AbhCVUAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C9BE16199F;
        Mon, 22 Mar 2021 20:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616443208;
        bh=Mx+4yesAAt8zxAS8dCbjEkLsBLoushBulk3gsUSDggk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=flUdDDpHNr8aIS0TZNWRW6iPJo5ZssMCPNDV0CEK9J7L8VqUqKc8LAPTtlI8i3TzL
         1+TuBHKXCV0AvcX1DdekI6toRb1HMZykCB6DdhxGtOmd9RUPOF5RJmhp+oRmERsTmx
         Dz2mEBVkhPFB6GPOafFsowVgKNTKurcKr5dE9KEyY6FFBmz7grey88w7wjGCOno5J+
         7hb0WVnxaFlh31iwSp3EhVQxhCf6gT90Ihe4n8wM9X8OEDwar+/nJ1CkHV3qsn05DN
         b2QkY6neJK2IxPdNhiSuYX8TyFheln/bhcqidYmDcrmYNgj8jbLUcCgCVJg8Z3T18Z
         4jfCd9Q1KyhmQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BCAF960A6A;
        Mon, 22 Mar 2021 20:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/1] Allow drivers to modify dql.min_limit value
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161644320876.18911.1629441011525783752.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Mar 2021 20:00:08 +0000
References: <20210321134849.463560-1-mailhol.vincent@wanadoo.fr>
In-Reply-To: <20210321134849.463560-1-mailhol.vincent@wanadoo.fr>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     mkl@pengutronix.de, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, dave.taht@gmail.com, peterz@infradead.org,
        rdunlap@infradead.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun, 21 Mar 2021 22:48:48 +0900 you wrote:
> Abstract: would like to directly set dql.min_limit value inside a
> driver to improve BQL performances of a CAN USB driver.
> 
> CAN packets have a small PDU: for classical CAN maximum size is
> roughly 16 bytes (8 for payload and 8 for arbitration, CRC and
> others).
> 
> [...]

Here is the summary with links:
  - [v3,1/1] netdev: add netdev_queue_set_dql_min_limit()
    https://git.kernel.org/netdev/net-next/c/f57bac3c33e7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


