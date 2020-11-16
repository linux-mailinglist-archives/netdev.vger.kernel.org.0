Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F0D22B555E
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730151AbgKPXuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:50:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:49798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726287AbgKPXug (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 18:50:36 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24D1924641;
        Mon, 16 Nov 2020 23:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605570636;
        bh=revZMqDAKvfAcrUyCPRAeYx6moZKw5JnA44m4JeGMTE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=h+EpHgMkUfqxXUZ3mXGyslpE/q6cYzWQPBWkOGHJKqlV0kaDxcq2M+mnMiep3Gy08
         RxDT0VeWuv2pnGt35DfjxBvPZqewxbsoC6APeyUZ/Zxuat0eQk/XLapB5y+vLXC0JI
         iYCWPTqrj+EjEMFvIXuJ53HkUNBWKKm3nYVxUZsw=
Date:   Mon, 16 Nov 2020 15:50:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net] net: bridge: add missing counters to
 ndo_get_stats64 callback
Message-ID: <20201116155035.7f9e761c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <58ea9963-77ad-a7cf-8dfd-fc95ab95f606@gmail.com>
References: <58ea9963-77ad-a7cf-8dfd-fc95ab95f606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 10:27:27 +0100 Heiner Kallweit wrote:
> In br_forward.c and br_input.c fields dev->stats.tx_dropped and
> dev->stats.multicast are populated, but they are ignored in
> ndo_get_stats64.
> 
> Fixes: 28172739f0a2 ("net: fix 64 bit counters on 32 bit arches")
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
> Patch will not apply cleanly on kernel versions that don't have
> dev_fetch_sw_netstats() yet.

Looks straightforward enough, I'll backport manually.

Applied, thanks!
