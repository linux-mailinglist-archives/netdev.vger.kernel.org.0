Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 708FC34D921
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 22:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhC2Uke (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 16:40:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:48264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhC2UkJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 16:40:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2D59A6196C;
        Mon, 29 Mar 2021 20:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617050409;
        bh=xJ75zZfeeHGiAuPkUV8xBNfuHwhl/VPN2DU8RIAwFuA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gqG9EgVBq+ifysEXw1bjw1dsIvGeZ3t0YaQvQBbDT8nShSEIEd1w1GFhFY4eMLILr
         2pPQZSAEDTrrYGWp7anGwEyQVx/tMJg3J53668+wXXFn8NZxUQWwM42eLMKPvF5txD
         pgBBk1DkvKaEcC4rnnbSmghapJReL/zftcO8D2rRjSwFjoIMVZF4gu86j3p4UdIMED
         d2Cl4T5o09rNY1prf3DuwYDmAsr7LQK9mLQaZalXJnhCdOXSqw1tMmdP9Mnq4OcwyI
         EUEKopEzM1wuA/4FeGnBJnh6V3mSdz8gjgHl6CuxhLfnJxsS/SfhfxRP5Rc2upczjt
         POVg2GjPSfeWg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 21BA160A3B;
        Mon, 29 Mar 2021 20:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: can 2021-03-29
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161705040913.15223.11767373062136414770.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Mar 2021 20:40:09 +0000
References: <20210329085355.921447-1-mkl@pengutronix.de>
In-Reply-To: <20210329085355.921447-1-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (refs/heads/master):

On Mon, 29 Mar 2021 10:53:52 +0200 you wrote:
> Hello Jakub, hello David,
> 
> this is a pull request of 3 patches for net/master.
> 
> The two patch are by Oliver Hartkopp. He fixes length check in the
> proto_ops::getname callback for the CAN RAW, BCM and ISOTP protocols,
> which were broken by the introduction of the J1939 protocol.
> 
> [...]

Here is the summary with links:
  - pull-request: can 2021-03-29
    https://git.kernel.org/netdev/net/c/f4c848db16be
  - [net,2/3] can: isotp: fix msg_namelen values depending on CAN_REQUIRED_SIZE
    https://git.kernel.org/netdev/net/c/f522d9559b07
  - [net,3/3] can: uapi: can.h: mark union inside struct can_frame packed
    https://git.kernel.org/netdev/net/c/f5076c6ba02e

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


