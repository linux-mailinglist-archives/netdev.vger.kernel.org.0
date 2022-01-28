Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09ADD49FC71
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 16:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345576AbiA1PKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 10:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236989AbiA1PKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 10:10:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F8D8C061714;
        Fri, 28 Jan 2022 07:10:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D82A5B82615;
        Fri, 28 Jan 2022 15:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 935D2C340E7;
        Fri, 28 Jan 2022 15:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643382611;
        bh=upUbrLfCOw1Vh49+BWsrSMrdEFkeqSF7qD5m4/nErbE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f40k58h+NqKXYK97fudU+SvGvOU2UCg79e7tCoGp4zuokN3COhljw/VHXZX/AGjh+
         L8pLlaRxIhwoFD/IqZLwh6spSXii6r77FrvEqUa9qslSPr6gpti/qZXBI2dFvgzd7Z
         7Os/M0rr1U/uoUNHg5UosNCGfErfemp6rdBN5svTbdRud/6GzDa7wuDkNKIHlHRSBm
         aw8CnEGJ5D0mgghBzcY8R8NZRmelVkvHq+5NdY3Rj+LAyQN0qOSbaLhaGZ/sqlEGc2
         WgTi6Ha2WYCDPL5HxK+jVRSc4a9aGaDrH2lzKmSEWbJyCrbKN1iKcOiSMY83Wf3g6t
         lL+y4oOyyTHpQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7B08BF60799;
        Fri, 28 Jan 2022 15:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] ax25: fix NPD and UAF bugs when detaching ax25 device
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164338261149.2420.16351407833253880236.git-patchwork-notify@kernel.org>
Date:   Fri, 28 Jan 2022 15:10:11 +0000
References: <cover.1643343397.git.duoming@zju.edu.cn>
In-Reply-To: <cover.1643343397.git.duoming@zju.edu.cn>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-hams@vger.kernel.org, jreuter@yaina.de, ralf@linux-mips.org,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Jan 2022 12:47:14 +0800 you wrote:
> There are NPD and UAF bugs when detaching ax25 device, we
> use lock and refcount to mitigate these bugs.
> 
> Duoming Zhou (2):
>   ax25: improve the incomplete fix to avoid UAF and NPD bugs
>   ax25: add refcount in ax25_dev to avoid UAF bugs
> 
> [...]

Here is the summary with links:
  - [1/2] ax25: improve the incomplete fix to avoid UAF and NPD bugs
    https://git.kernel.org/netdev/net/c/4e0f718daf97
  - [2/2] ax25: add refcount in ax25_dev to avoid UAF bugs
    https://git.kernel.org/netdev/net/c/d01ffb9eee4a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


