Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0933234C6
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 02:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbhBXAzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 19:55:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:57422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234709AbhBXAGC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 19:06:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CD5864E89;
        Wed, 24 Feb 2021 00:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614124945;
        bh=JL0TqMHL2r1vE999Jf2re1bedmETPkSyBE0bEjRlCY0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oeX08Hx7+xLHgqBfSpW/tYFaBBEHShK4U4RlEdjbpN0MkO2P3Hzfia8drKwaaz8th
         iVFwTwybH4GgbmC4Volw16ZS2U2Em+rgf+GwcNknSsYqA3ZLMw0VSEnKgJxZPMAL46
         k2SH9d0G+A2WSi6N9+vbCWilARUAr44ns/Q5eMa2RfN75J9oMGOkMlyHLen70QMIsu
         dGfbj3udTHLqDFhGQ4yBBqnnjkNJEywHfIym9zFbBvfHAiDv1HubZ5ugRQSiEqgrkc
         mHoLbZZ+CCFUZXX/l/+XrsOOW6sYQq4/Sr/QEfTw5kcW1FuDoGAkger9/piSPdDnLu
         rXxFANJdlXLbg==
Date:   Tue, 23 Feb 2021 16:02:21 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net 0/7] wireguard fixes for 5.12-rc1
Message-ID: <20210223160221.02e365b6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210222162549.3252778-1-Jason@zx2c4.com>
References: <20210222162549.3252778-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Feb 2021 17:25:42 +0100 Jason A. Donenfeld wrote:
> This series has a collection of fixes that have piled up for a little
> while now, that I unfortunately didn't get a chance to send out earlier.
> 
> 1) Removes unlikely() from IS_ERR(), since it's already implied.
> 
> 2) Remove a bogus sparse annotation that hasn't been needed for years.
> 
> 3) Addition test in the test suite for stressing parallel ndo_start_xmit.
> 
> 4) Slight struct reordering in preparation for subsequent fix.
> 
> 5) If skb->protocol is bogus, we no longer attempt to send icmp messages.
> 
> 6) Massive memory usage fix, hit by larger deployments.
> 
> 7) Fix typo in kconfig dependency logic.
> 
> (1) and (2) are tiny cleanups, and (3) is just a test, so if you're
> trying to reduce churn, you could not backport these. But (4), (5), (6),
> and (7) fix problems and should be applied to stable. IMO, it's probably
> easiest to just apply them all to stable.

Preferably 1, 2, 4 and 6 should go into net-next first, and not be
posted half way through the merge window, but I trust you had them 
well tested so applied, thanks!
