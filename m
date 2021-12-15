Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6272D475768
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 12:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236856AbhLOLKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 06:10:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55548 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234114AbhLOLKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 06:10:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9583D61859
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 11:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F2157C3460C;
        Wed, 15 Dec 2021 11:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639566613;
        bh=u28mIiv8lvWSY4ksjJH1B68RcmHr9Agi/AbgYG06X+E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CHFARLiAwWbRLy14EoS5iLoNdbsvDJ5kLW4dImow8PFAcDXenLzZV+GGYihQFj7Al
         qp5HKuRLKBb+90vsbsgwTSiukW8oYkawVKj+3dh6hKJSga6N8EaymvUU2VbUCifAzX
         t8rljby7vt9s14d21xYnSZybvZ6miNnD7/ae9vXvsPvQBhLTVabwO7yq4ess7Q7Cq7
         2IG/RV4o8Hu3CiopLhSQxUCxI2cexgc4B7/DDDjUIODDXTdIf7ITUEndu869B70A15
         6gFNRLeBd+7O0JjmavunrRw+/eHWa1HXRiLMS5at447ZvXYLE+obJG5W4Kzpt+QVvH
         LgM5DOEpk4mdw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CDF72609FE;
        Wed, 15 Dec 2021 11:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] sun4i-emac.c: remove unnecessary branch
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163956661283.16045.17717988161462472475.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Dec 2021 11:10:12 +0000
References: <tencent_39931E47EFB90517A5E15B534DD305606C08@qq.com>
In-Reply-To: <tencent_39931E47EFB90517A5E15B534DD305606C08@qq.com>
To:     None <conleylee@foxmail.com>
Cc:     mripard@kernel.org, wens@csie.org, jernej.skrabec@gmail.com,
        arnd@arndb.de, christophe.jaillet@wanadoo.fr, andrew@lunn.ch,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 14 Dec 2021 17:11:06 +0800 you wrote:
> From: Conley Lee <conleylee@foxmail.com>
> 
> According to the current implementation of emac_rx, every arrived packet
> will be processed in the while loop. So, there is no remain packet last
> time. The skb_last field and this branch for dealing with it is
> unnecessary.
> 
> [...]

Here is the summary with links:
  - sun4i-emac.c: remove unnecessary branch
    https://git.kernel.org/netdev/net-next/c/3899c928bccc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


