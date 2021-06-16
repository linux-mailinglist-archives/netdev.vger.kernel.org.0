Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE71E3AA49A
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbhFPTwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:52:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:55116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231171AbhFPTwL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 15:52:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 01C52613AE;
        Wed, 16 Jun 2021 19:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623873005;
        bh=xs9QveBOSTxEoeoe0chR8OOZ4h6t12vC0JzB+RQHJeg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rDx8oZLEqyMFKFKUsBzo08/19ug0iMbXloerbWd6kBoOVrSO1KHySKczkflnIDIwE
         F4j2ocFkuzcWm0+f0qpA47/mAviIcm197ya9/+aM/G1f6KTLSh385tiRAZ9X3ZAKcp
         VrOfbLA/tVPtY9aSFMKcGnq3JB3I2xIcQt2+RA2kn7NBEDS5cezNSI5QNLsNfjKf2N
         VJP32OEgidXd7mU5Rw9Un0F323YOyTxRxfuJNzFFzg5HGdY09yGalI/xQJgGkQEIa1
         mNblPA1qj/7Zz1HkET+NDEGj9pzGJKriuuIf7iWkUzaVDunoPbsEoFrM+nANVV/RFs
         ERuRgUXL2Vx7w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id EAA3960A54;
        Wed, 16 Jun 2021 19:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net/packet: annotate data races
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162387300495.13042.6965213419499189155.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 19:50:04 +0000
References: <20210616134202.3661456-1-eric.dumazet@gmail.com>
In-Reply-To: <20210616134202.3661456-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 16 Jun 2021 06:42:00 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> KCSAN sent two reports about data races in af_packet.
> Nothing serious, but worth fixing.
> 
> Eric Dumazet (2):
>   net/packet: annotate accesses to po->bind
>   net/packet: annotate accesses to po->ifindex
> 
> [...]

Here is the summary with links:
  - [net,1/2] net/packet: annotate accesses to po->bind
    https://git.kernel.org/netdev/net/c/c7d2ef5dd4b0
  - [net,2/2] net/packet: annotate accesses to po->ifindex
    https://git.kernel.org/netdev/net/c/e032f7c9c7ce

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


