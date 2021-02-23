Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43FAC322442
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 03:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhBWCpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 21:45:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:45610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229852AbhBWCpQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Feb 2021 21:45:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CDE960232;
        Tue, 23 Feb 2021 02:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614048276;
        bh=l8cdKd6z9r5zti7jnEqEl7pkNmvyrSBGghCoknl6K0I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uy+AtVyvy6YWqx0taZ8kH0eU1p8OSzcuTs16WBxDyhzvkpA9NrDlDSnEdIHN5w4gX
         KrbrT1VJOlPmb3vrqrCXFDQRDpFFUUbG8sypJYjXgc5W25S32ozwz34fkxIbO9VpP7
         a54BjxEbaxyqsLtEMX/NQ4R9mWMSdQy79G1B2d4i1KET9F4NIYCU0l6D8+ExsCOWLy
         wjblngtTWIGlBEtnN4DTVBwj7/6TQ/SC7gfeM6QUAf7Yrh0JX6wpkTiKLD74yKsWGY
         n/m/7V3uYIympBa5F1bCIZj1YpcoTc4OpTdAmuLaj5LbOrvCh+Ra4OtkGdYgHGHcSz
         p1Nd+K+GfUb3g==
Date:   Mon, 22 Feb 2021 18:44:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     netdev@vger.kernel.org, SinYu <liuxyon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        David L Stevens <david.stevens@oracle.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net v4] net: icmp: pass zeroed opts from
 icmp{,v6}_ndo_send before sending
Message-ID: <20210222184432.5888c1e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210219022532.2446968-1-Jason@zx2c4.com>
References: <20210219022532.2446968-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Feb 2021 03:25:32 +0100 Jason A. Donenfeld wrote:
> This commit fixes the issue by passing an empty IPCB or IP6CB along to
> the functions that actually do the work. For the icmp_send, this was
> already trivial, thanks to __icmp_send providing the plumbing function.
> For icmpv6_send, this required a tiny bit of refactoring to make it
> behave like the v4 case, after which it was straight forward.

No longer applies after the net-next merge.

Could you respin?
