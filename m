Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3262F9D06
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 11:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389292AbhARKnm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 05:43:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:34750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388945AbhARJfV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 04:35:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A7B29222B3;
        Mon, 18 Jan 2021 09:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610962477;
        bh=6RFfUjPneWSE6yVh1hIrKXWzhESjY+xKu9hm6R9pzMI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RzEbLpeZGSL/Mv3eWzWfkEihXoDN8z8/0AjulVjQ7q6YbejLJUOYOQRxfjLWFlSTu
         4xzHaFkz7P2XwLaRJCIQJDgGHudWlxdQMFzxBmmDNzywK1hodJZ6xgyqJXo/yRqyBC
         an9DIf+leBh8m0jtKcEt/93AS8wcz35+6CkNymga0eOz/7aHthx/S2EVWHIQ87FGir
         J0+EmrzP7CFIFYLlc6bKHJn1+vzBcWu8eDWWC968mCpmX39DU8Ra/Hljq/4D/czcPT
         rhOiG0Ts5WifAAgPI1SjtYwTp2arMVLgYhC8nX1/vvzoulAEzojPdhhzd0ZUFGi7bW
         DI/Fg8oMFFjrA==
Received: by pali.im (Postfix)
        id 6A52E889; Mon, 18 Jan 2021 10:34:35 +0100 (CET)
Date:   Mon, 18 Jan 2021 10:34:35 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] net: sfp: add support for GPON RTL8672/RTL9601C
 and Ubiquiti U-Fiber
Message-ID: <20210118093435.coy3rnchbmlkinpe@pali>
References: <20201230154755.14746-1-pali@kernel.org>
 <20210111113909.31702-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210111113909.31702-1-pali@kernel.org>
User-Agent: NeoMutt/20180716
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday 11 January 2021 12:39:07 Pali Rohár wrote:
> This is a third version of patches which add workarounds for
> RTL8672/RTL9601C EEPROMs and Ubiquiti U-Fiber Instant SFP.
> 
> Russel's PATCH v2 2/3 was dropped from this patch series as
> it is being handled separately.

Andrew and Russel, are you fine with this third iteration of patches?
Or are there still some issues which needs to be fixed?

> Pali Rohár (2):
>   net: sfp: add workaround for Realtek RTL8672 and RTL9601C chips
>   net: sfp: add mode quirk for GPON module Ubiquiti U-Fiber Instant
> 
>  drivers/net/phy/sfp-bus.c |  15 +++++
>  drivers/net/phy/sfp.c     | 117 ++++++++++++++++++++++++++------------
>  2 files changed, 97 insertions(+), 35 deletions(-)
> 
> -- 
> 2.20.1
> 
