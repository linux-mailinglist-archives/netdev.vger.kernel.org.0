Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED474A4587
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 12:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377946AbiAaLmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 06:42:16 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40802 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379406AbiAaLkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 06:40:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B141F613EA
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 11:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 156C8C36AE3;
        Mon, 31 Jan 2022 11:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643629211;
        bh=uo5k0DbIkcge1TPjOVMDCPHvKaSkvrKctIyd1H8bNPk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I0CY6UJ0wceRosAjq15KYj1s5kljdvC/tBuJ3xOXH4W4vMeIbAkNhUQUALeaX0GMv
         Q/HmepavmFbLsyHAygQEUTn04Hi/221yR/5l1WpvGXkI3w9y57RNKJnL5GevrOz8ij
         EN6jgzzJxM6oQWFmG2RccRjbT7ZdhGNKRY265Dui17/gNvKXHu0Xq7hU41jwBeMf2o
         pzhaHUBmRUTmdPpZPjJ/hiOfdFm9LidCM11dCPd1QHmaDNSFWTo9h2BxmzzoONh03i
         LnlQzL6VCsViI3OsOrvFsuSKNT/tz2LCOkXHJpSY2pu9ZqBQBfxFr8WN/XpMdwWydw
         B5m2rsTvO71Qw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E7A94E6BB3D;
        Mon, 31 Jan 2022 11:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/2] net: dsa: mv88e6xxx: Improve indirect
 addressing performance
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164362921094.6327.2899132291555240817.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Jan 2022 11:40:10 +0000
References: <20220128162650.2510062-1-tobias@waldekranz.com>
In-Reply-To: <20220128162650.2510062-1-tobias@waldekranz.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, David.Laight@ACULAB.COM
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Jan 2022 17:26:48 +0100 you wrote:
> The individual patches have all the details. This work was triggered
> by recent work on a platform that took 16s (sic) to load the mv88e6xxx
> module.
> 
> The first patch gets rid of most of that time by replacing a very long
> delay with a tighter poll loop to wait for the busy bit to clear.
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/2] net: dsa: mv88e6xxx: Improve performance of busy bit polling
    https://git.kernel.org/netdev/net-next/c/35da1dfd9484
  - [v3,net-next,2/2] net: dsa: mv88e6xxx: Improve indirect addressing performance
    https://git.kernel.org/netdev/net-next/c/7bca16b22e6a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


