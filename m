Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F00531C459
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 00:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbhBOXWa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 18:22:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:33716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230011AbhBOXVf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 18:21:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 170D564E09;
        Mon, 15 Feb 2021 23:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613431209;
        bh=4/rE9dvaxalyGmzsQcJF5ndZQXOGiHn8sWZnyl3WWKM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eXsFD7tsypNuw2r+xYFqPSQw5w2QGtA7XBxw0FwNdOoZKW4JsyoPKav0rzyVaa1MC
         AEibF0kXJmedSnAi84UBqJ+5BaX3oOLGJn1mWiBhfPvW2BrCqX4D0QZznjmimDcD80
         mjOEtePm8467n+LfqatxHk56pBt03tjH10lFOhph3MrGnwaM/qnCm05NYqiOqKKpNH
         63DGLzuMPRELRBKG12DET4J0odWRp8avdCr+Q1cTxycjJ+Jpd1yQmoUOAUjAWzvCIa
         xSexMN3EyHndtNlzDdA827nEN949h/oyVsdUs7jrwUcxZmUnG1nkH7DbZ1m/dcY2P2
         UpkuOrJspTKsg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1021660977;
        Mon, 15 Feb 2021 23:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 5.12] net: broadcom: bcm4908_enet: set MTU on open & on
 request
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161343120906.10830.18192335437219614781.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Feb 2021 23:20:09 +0000
References: <20210212152135.27030-1-zajec5@gmail.com>
In-Reply-To: <20210212152135.27030-1-zajec5@gmail.com>
To:     =?utf-8?b?UmFmYcWCIE1pxYJlY2tpIDx6YWplYzVAZ21haWwuY29tPg==?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        f.fainelli@gmail.com, bcm-kernel-feedback-list@broadcom.com,
        rafal@milecki.pl
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 12 Feb 2021 16:21:35 +0100 you wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Hardware comes up with default max frame size set to 1518. When using it
> with switch it results in actual Ethernet MTU 1492:
> 1518 - 14 (Ethernet header) - 4 (Broadcom's tag) - 4 (802.1q) - 4 (FCS)
> 
> Above means hardware in its default state can't handle standard Ethernet
> traffic (MTU 1500).
> 
> [...]

Here is the summary with links:
  - [5.12] net: broadcom: bcm4908_enet: set MTU on open & on request
    https://git.kernel.org/netdev/net-next/c/14b3b46a67f7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


