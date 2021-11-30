Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA332463419
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 13:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241511AbhK3MXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 07:23:33 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:39032 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241500AbhK3MXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 07:23:32 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DF884CE198D
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 12:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 12C74C58325;
        Tue, 30 Nov 2021 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638274810;
        bh=NUWt0z/cMZQle34DSv49sF/x2xMyfPgTH19+prkLAmg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Gs6g+NGNSI6ABDBJf/cioTsb3Co+kTYVd6bOGtd/91e9hTD8EQ1LvHkmhx7QOw+XS
         qr1WaVYpQhqyt4GMoN1IONSZk1xFP/vsSgBZO+7j58Q5lNli89MA7ooz6Cwl6LApaQ
         P3OS0Tok/ZwnRtOrCU4DTyePEmfmRMBFX0EOjRUFThd9AA7GuPcn/nU57A48eMEa0z
         QGCBWqZKlZVeVy1usY4syKMkbFZvZn/2hqyVKR9l11LFe8AmbhBhgMYgU1IqdUu5g+
         nvY6//vN+PiCvs0R+Uy3YeY2UI81ualjf7djLx26jN9C1Zh1PdTTwHyl1dX0LXweCU
         neO9DFcJlAIxg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F335060A50;
        Tue, 30 Nov 2021 12:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv4 net-next] Bonding: add arp_missed_max option
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163827480999.28928.7861812683592037856.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Nov 2021 12:20:09 +0000
References: <20211130042948.1629239-1-liuhangbin@gmail.com>
In-Reply-To: <20211130042948.1629239-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jarod@redhat.com, kuba@kernel.org,
        jiri@resnulli.us, davem@davemloft.net, dkirjanov@suse.de,
        dsahern@gmail.com, jay.vosburgh@canonical.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 30 Nov 2021 12:29:47 +0800 you wrote:
> Currently, we use hard code number to verify if we are in the
> arp_interval timeslice. But some user may want to reduce/extend
> the verify timeslice. With the similar team option 'missed_max'
> the uers could change that number based on their own environment.
> 
> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> 
> [...]

Here is the summary with links:
  - [PATCHv4,net-next] Bonding: add arp_missed_max option
    https://git.kernel.org/netdev/net-next/c/5944b5abd864

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


