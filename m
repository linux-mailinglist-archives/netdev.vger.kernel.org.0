Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25EB343B3D4
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:20:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236470AbhJZOWb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:22:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:42746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232907AbhJZOWb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 10:22:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5F7696108D;
        Tue, 26 Oct 2021 14:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635258007;
        bh=BCP26ij8aQiPlP+YPKgPF+AgJTQ9BjYADpVl6K6OnPU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e9N77GVHn/fmNK7hs2n+6WWwy/JycojbDwEvCHCD5EkNVBIu1BYb0ZfP5Gp61ijP3
         LRMuTQRe63DmHD9snaSVSq8/69RQvVQLZTWteerMfA2G0MHDC+IfjJoC+BSjNuFPKa
         +d6WfP6b77Jmle7bDbV3rvuxPH0k4NkXEW67kCoH4CjPNJqmzy6J19QnA8wz/rMbxj
         zQEOJRmqaebB07WvZEZ/HQfcPMK5oy2+PA6z2PXTSlDRc3qp5EANQw1DmoaGqDx5ov
         LXwXudvu2KsYLyb17ABNyFFB/jl2AnaOR6VGI+wA3KkXVk8oFHG3WGTRPAjxUrHykI
         HsE3SW2voErTQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4F80C608FE;
        Tue, 26 Oct 2021 14:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: lan78xx: fix division by zero in send path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163525800732.18574.12890707438455809679.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Oct 2021 14:20:07 +0000
References: <20211026103617.5686-1-johan@kernel.org>
In-Reply-To: <20211026103617.5686-1-johan@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Woojung.Huh@microchip.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 26 Oct 2021 12:36:17 +0200 you wrote:
> Add the missing endpoint max-packet sanity check to probe() to avoid
> division by zero in lan78xx_tx_bh() in case a malicious device has
> broken descriptors (or when doing descriptor fuzz testing).
> 
> Note that USB core will reject URBs submitted for endpoints with zero
> wMaxPacketSize but that drivers doing packet-size calculations still
> need to handle this (cf. commit 2548288b4fb0 ("USB: Fix: Don't skip
> endpoint descriptors with maxpacket=0")).
> 
> [...]

Here is the summary with links:
  - net: lan78xx: fix division by zero in send path
    https://git.kernel.org/netdev/net/c/db6c3c064f5d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


