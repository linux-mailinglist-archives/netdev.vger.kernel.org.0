Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEEAA458F65
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 14:30:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232910AbhKVNdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 08:33:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232194AbhKVNdQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 08:33:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 143C8604DA;
        Mon, 22 Nov 2021 13:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637587810;
        bh=1Ud4ei4JYPWOsKbjw1UeAYMo9UsrsPCvIPRUaUg8Cc0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W0GQ1931yQ/5ZI3cKJXaVva3dp7q//9lfTQpc5oX2kJecwWNIjg7e2GnUlFQfSYVh
         cT3lheSzBxSr2oHsys2aGwGqq43TZoHX71Da3Eyr8TZ0jb9xtkmQAV7SIsIDLxsFXD
         tUABR9bbQzAbPjyEljgFZ+046ghjfammBDuczZGXItAja+j3x4KFNpsHJAEN1MI331
         GfmtsW4vlsJ7oEgaQvXrTgFiWo3T32frVWzSN9pdHrJekrShDbprBO5hixV+9E2E3K
         uts1guIuHKQWPFLuiRFUykFOeiuTmowyEAFOKQHaoIguy7fm5MGypVIMMMHeRfySkO
         44999zca6rQHQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 09E4A609D9;
        Mon, 22 Nov 2021 13:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6 0/3] TSN endpoint Ethernet MAC driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163758781003.2556.6411296816480904986.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Nov 2021 13:30:10 +0000
References: <20211119225826.19617-1-gerhard@engleder-embedded.com>
In-Reply-To: <20211119225826.19617-1-gerhard@engleder-embedded.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        richardcochran@gmail.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 19 Nov 2021 23:58:23 +0100 you wrote:
> This series adds a driver for my FPGA based TSN endpoint Ethernet MAC.
> It also includes the device tree binding.
> 
> The device is designed as Ethernet MAC for TSN networks. It will be used
> in PLCs with real-time requirements up to isochronous communication with
> protocols like OPC UA Pub/Sub.
> 
> [...]

Here is the summary with links:
  - [net-next,v6,1/3] dt-bindings: Add vendor prefix for Engleder
    https://git.kernel.org/netdev/net-next/c/2b34a288d200
  - [net-next,v6,2/3] dt-bindings: net: Add tsnep Ethernet controller
    https://git.kernel.org/netdev/net-next/c/603094b2cdb7
  - [net-next,v6,3/3] tsnep: Add TSN endpoint Ethernet MAC driver
    https://git.kernel.org/netdev/net-next/c/403f69bbdbad

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


