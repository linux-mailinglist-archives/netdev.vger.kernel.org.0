Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37EFC3A1E75
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbhFIVCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:02:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:47356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229792AbhFIVB7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 17:01:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0D4A3613FE;
        Wed,  9 Jun 2021 21:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623272404;
        bh=ao0t24c/S1hB+BlnDQkic0ywNI0OF5gYNe/dKZgLwD4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qRuX54gjgJn1XIYnhu9PYPk22Twpf1vlfrcpACGOOrFbn/EBjlMsYHtg3bSlTnh3f
         oTQ8XAJaolna0jmRjNQu/j5QJepypT/WPNM6/rcPil/NYuI1z1ICxJ0OqZUoX0Rm9b
         UHnBW7UQpiu32OQSZNxudyraERiVlnUgsCsMZuturAZ3CNFBybpt4kj64vrtESnMRD
         6D2gv5Jc+ZGsn6ua5C3PhanCSBO8mBe/aEeIAkH92NAv2MFyxTq9jUxT80RoQTIb8r
         1axG7Gqk+E3vfYADtKe+Ru6mK0mOHbBUZTFPH9wzMRBX7qdA2blM85vhCyR2SQGeik
         1YmUW78W7ZSag==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 01EEC60BE2;
        Wed,  9 Jun 2021 21:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: dsa: b53: Do not force CPU to be always
 tagged
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327240400.12172.12511880467816959107.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 21:00:04 +0000
References: <20210608212204.3978634-1-f.fainelli@gmail.com>
In-Reply-To: <20210608212204.3978634-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, mnhagan88@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  8 Jun 2021 14:22:04 -0700 you wrote:
> Commit ca8931948344 ("net: dsa: b53: Keep CPU port as tagged in all
> VLANs") forced the CPU port to be always tagged in any VLAN membership.
> This was necessary back then because we did not support Broadcom tags
> for all configurations so the only way to differentiate tagged and
> untagged traffic while DSA_TAG_PROTO_NONE was used was to force the CPU
> port into being always tagged.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: dsa: b53: Do not force CPU to be always tagged
    https://git.kernel.org/netdev/net-next/c/2c32a3d3c233

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


