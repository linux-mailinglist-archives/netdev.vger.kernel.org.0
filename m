Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560DE3662B5
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 02:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234520AbhDUAAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 20:00:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234501AbhDUAAn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 20:00:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DD0566141A;
        Wed, 21 Apr 2021 00:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618963210;
        bh=S57yaWVR8g2k72mrSoWwn5RCUhiq/40+G+LB8VNzYXs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sUKCRX+MKCdjkL6RP3HdqIlF3oz9url6AczOy5nFdobNU/t9yAleNt5BghFu5XGk1
         HUdaj9wnhOSEWmiUXl04hkJAOXyuto0CIIkARSugDvTlrSvYlArg940nL9HqNWI6UU
         EE/4893/qg2P9wO4TrluqFIfC3AE1ze/8S+1V/Ft07OoQ7xyR3k++LnLmYMgb9ic83
         mzokO/NCjcdrc3ruDAxpqJA6ma1Zr83gSWqSr8wvUGRim/ikSZfmjd2YB8ZZUgFzWd
         N5dzT4Pu0EfcfXL/7VfQdK5q5WDB4SnBf5oPD/1ECATPn7C+AfgoJ8+I3OgAFqheof
         HwPniTxSAl+Yw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D41A560982;
        Wed, 21 Apr 2021 00:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net-next 0/5] net: dsa: Allow default tag protocol to be
 overridden from DT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161896321086.2554.15712504527093585485.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Apr 2021 00:00:10 +0000
References: <20210420185311.899183-1-tobias@waldekranz.com>
In-Reply-To: <20210420185311.899183-1-tobias@waldekranz.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        devicetree@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 20 Apr 2021 20:53:06 +0200 you wrote:
> This is a continuation of the work started in this patch:
> https://lore.kernel.org/netdev/20210323102326.3677940-1-tobias@waldekranz.com/
> 
> In addition to the mv88e6xxx support to dynamically change the
> protocol, it is now possible to override the protocol from the device
> tree. This means that when a board vendor finds an incompatibility,
> they can specify a working protocol in the DT, and users will not have
> to worry about it.
> 
> [...]

Here is the summary with links:
  - [v3,net-next,1/5] net: dsa: mv88e6xxx: Mark chips with undocumented EDSA tag support
    https://git.kernel.org/netdev/net-next/c/670bb80f8196
  - [v3,net-next,2/5] net: dsa: mv88e6xxx: Allow dynamic reconfiguration of tag protocol
    https://git.kernel.org/netdev/net-next/c/9a99bef5f87f
  - [v3,net-next,3/5] net: dsa: Only notify CPU ports of changes to the tag protocol
    https://git.kernel.org/netdev/net-next/c/21e0b508c8d1
  - [v3,net-next,4/5] net: dsa: Allow default tag protocol to be overridden from DT
    https://git.kernel.org/netdev/net-next/c/deff710703d8
  - [v3,net-next,5/5] dt-bindings: net: dsa: Document dsa-tag-protocol property
    https://git.kernel.org/netdev/net-next/c/eb78cacebaf2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


