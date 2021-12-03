Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8661E467C8D
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 18:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382120AbhLCRdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 12:33:37 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42346 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358764AbhLCRdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 12:33:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A78462C60
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 17:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1C25C53FAD;
        Fri,  3 Dec 2021 17:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638552611;
        bh=dkrnkYwRPbHhBt2ny3gI/Y41ztS+/YiP8P26ejnhZ+0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j/iXCi5ogUp8+PyMcda79AxMQjfFkcRQwCYe+rlzZDJlcvz1KulrcUtLqNXH634mZ
         L6OHrxnOM0OCTtEqyIwcJoOGgJivRTtg+GqxY8rrmZCxe3u1iMjgWyMwt+2rOh0U+5
         nn0Ppxt3Ppejv9fKTzm21m2H2pYmL/43ny22L3zabGO3QkA+XRKxN2Onpi8z9uccA4
         V9KtabCqj0Q4ipigwglqc25JQXYR96LnCYmcTh8v6A3BmV+wbwGKtOsiPVWScDcJRh
         xntVoDXzONlfFUjagruO83vRDcNSAOezY4yFcqOQXeuGjiJVPsPQwjSA/qQR02gfCD
         2uUix2sD08YxA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BCCA160A7E;
        Fri,  3 Dec 2021 17:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv4 iproute2-next] bond: add arp_missed_max option
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163855261176.12933.2373471555356886617.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Dec 2021 17:30:11 +0000
References: <20211130042948.1629239-2-liuhangbin@gmail.com>
In-Reply-To: <20211130042948.1629239-2-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jarod@redhat.com, kuba@kernel.org,
        jiri@resnulli.us, davem@davemloft.net, dkirjanov@suse.de,
        dsahern@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Tue, 30 Nov 2021 12:29:48 +0800 you wrote:
> Bond arp_missed_max is the maximum number of arp_interval monitor cycle
> for missed ARP replies. If this number is exceeded, link is reported as
> down.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> 
> [...]

Here is the summary with links:
  - [PATCHv4,iproute2-next] bond: add arp_missed_max option
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=99d09ee9a637

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


