Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212622B2A08
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 01:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgKNAkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 19:40:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:40262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726140AbgKNAkF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 19:40:05 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605314405;
        bh=fsbtnEr2aG+n9jOY88RMKWwwiNhdr6CC0J9akXnJhHA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=wr83tzq1ZeZ7dC6SJVIwbpWtLoepYRM9QUTg8uOvlHkUqOeJ1PW+bThCxI9VxGVQv
         OAp8LKURqXwJrfsVNNs0fOuR/X1L6dNFSEEKk/niaByf4sDRZFwF1uTb9Q3l4bdp2U
         cu8GuPowocyb9sSOVRo4ROg+zrGEDSLoatVgUg2A=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: improve rtl_tx
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160531440553.7757.12553285009084767438.git-patchwork-notify@kernel.org>
Date:   Sat, 14 Nov 2020 00:40:05 +0000
References: <c2e19e5e-3d3f-d663-af32-13c3374f5def@gmail.com>
In-Reply-To: <c2e19e5e-3d3f-d663-af32-13c3374f5def@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 11 Nov 2020 22:56:29 +0100 you wrote:
> We can simplify the for() condition and eliminate variable tx_left.
> The change also considers that tp->cur_tx may be incremented by a
> racing rtl8169_start_xmit().
> In addition replace the write to tp->dirty_tx and the following
> smp_mb() with an equivalent call to smp_store_mb(). This implicitly
> adds a WRITE_ONCE() to the write.
> 
> [...]

Here is the summary with links:
  - [net-next] r8169: improve rtl_tx
    https://git.kernel.org/netdev/net-next/c/ca1ab89cd2d6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


