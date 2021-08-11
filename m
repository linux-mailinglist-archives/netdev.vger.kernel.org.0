Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBCAF3E9A91
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 23:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232191AbhHKVu3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 17:50:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:42380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229589AbhHKVu3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 17:50:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2D1DA6101E;
        Wed, 11 Aug 2021 21:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628718605;
        bh=EgXnqI5kU7oXufWpPBqdUDzZ84mHpwmcOJWzj8/4H6U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FwyCGKa1tK1N2Ixayd1CMZ6qzwAvVmqzm+MNH9NwgXfk5duTZyEu+8y3wxEeGxRUE
         RTcFkxtcV6AVilTuF7uLepn1M8jH0g9kCLFo5cRqjIweBYVzI21Xg4EMWuIqaAXUQA
         WDIu60ouoveOKS80vFN6TBjNL/ib8U6qEIAJkCjkYae+Bu2CamR2D/bw50zQkBw+RR
         bIf4imiMTkLKlR/W5VsA/OZHVr2mDIsSl3eZGjez6cUdRfiI8nnPqWyfWREaK0Ce2Y
         ebKyZ/jqN0A60e7KZwvLHhBnQW/q+x79JL6E+4S+EmOOEMUCNhP/+vzmmzJjTqQvZs
         hixZsk1JLpwow==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1BAEA60A54;
        Wed, 11 Aug 2021 21:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: linkwatch: fix failure to restore device state
 across suspend/resume
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162871860510.17042.12476066873348315637.git-patchwork-notify@kernel.org>
Date:   Wed, 11 Aug 2021 21:50:05 +0000
References: <20210809160628.22623-1-w@1wt.eu>
In-Reply-To: <20210809160628.22623-1-w@1wt.eu>
To:     Willy Tarreau <w@1wt.eu>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        hkallweit1@gmail.com, geert+renesas@glider.be, f.fainelli@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon,  9 Aug 2021 18:06:28 +0200 you wrote:
> After migrating my laptop from 4.19-LTS to 5.4-LTS a while ago I noticed
> that my Ethernet port to which a bond and a VLAN interface are attached
> appeared to remain up after resuming from suspend with the cable unplugged
> (and that problem still persists with 5.10-LTS).
> 
> It happens that the following happens:
> 
> [...]

Here is the summary with links:
  - [net] net: linkwatch: fix failure to restore device state across suspend/resume
    https://git.kernel.org/netdev/net/c/6922110d152e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


