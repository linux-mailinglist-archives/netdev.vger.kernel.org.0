Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6BAE497E66
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 13:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238071AbiAXMAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 07:00:14 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59752 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234568AbiAXMAN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 07:00:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D5C3B80EFD;
        Mon, 24 Jan 2022 12:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 027A2C340E7;
        Mon, 24 Jan 2022 12:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643025611;
        bh=DT8OYthDG798LEBWYIZPpNqKNhR8EiuZXTCrK9rPmyc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QsINNchFg02zDiSr1zDtOE/8DHO8lsm1oKczmtEpndrk3M8BGO+lnsU9NDXyKuB6y
         YAScTwjDNGzZvRuSoV+qPbFMEYK0yGsdwuCUQTZ02RfkbWuC9IHCtjnTDBdXgL93tt
         n9sqTsz8G1o0HjVJln6qHhjw1rCsDNYeo7mgXLf6VEvI0E//pf00n2BKf8UoQb2aus
         SgyX4vJ+9bdlI4WmqsYoy1uXgDWBxVtHClc3Hh+7CvyrrDD1iBAUV8Fuf8ZYxppyjv
         79QQEgctphc3epPosesSOcApumzlsgHcrMHHMwl2arJWU4RsBASsc7Vvnnw6+SlCKR
         hux/YF6q2PYIA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DCC7DF6079F;
        Mon, 24 Jan 2022 12:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: sfp: ignore disabled SFP node
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164302561089.14817.10802410141680621538.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Jan 2022 12:00:10 +0000
References: <20220119164455.1397-1-kabel@kernel.org>
In-Reply-To: <20220119164455.1397-1-kabel@kernel.org>
To:     =?utf-8?q?Marek_Beh=C3=BAn_=3Ckabel=40kernel=2Eorg=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, rmk+kernel@armlinux.org.uk, andrew@lunn.ch,
        davem@davemloft.net, stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 19 Jan 2022 17:44:55 +0100 you wrote:
> Commit ce0aa27ff3f6 ("sfp: add sfp-bus to bridge between network devices
> and sfp cages") added code which finds SFP bus DT node even if the node
> is disabled with status = "disabled". Because of this, when phylink is
> created, it ends with non-null .sfp_bus member, even though the SFP
> module is not probed (because the node is disabled).
> 
> We need to ignore disabled SFP bus node.
> 
> [...]

Here is the summary with links:
  - [net] net: sfp: ignore disabled SFP node
    https://git.kernel.org/netdev/net/c/2148927e6ed4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


