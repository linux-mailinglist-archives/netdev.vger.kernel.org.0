Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B3D2A1F7D
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 17:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgKAQYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 11:24:37 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:57286 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726730AbgKAQYh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 11:24:37 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kZG9d-004f5M-PG; Sun, 01 Nov 2020 17:24:29 +0100
Date:   Sun, 1 Nov 2020 17:24:29 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: EXPORT_SYMBOL or EXPORT_SYMBOL_GPL?
Message-ID: <20201101162429.GB1109407@lunn.ch>
References: <19f8fdb8-66b4-4c8d-1b62-c41f50c60e58@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f8fdb8-66b4-4c8d-1b62-c41f50c60e58@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 01, 2020 at 01:43:34PM +0100, Heiner Kallweit wrote:
> I was wondering whether we have any policy on using EXPORT_SYMBOL or
> EXPORT_SYMBOL_GPL for newly exported functions. I've seen both options
> being used.

Hi Heiner

In the case of dev_get_tstats64() it is a trivial function to open
code in a driver. It is not going to cause any hardship for a closed
source out of tree network driver. So it makes no difference.
The existing stats functions in net/core/dev.c:

EXPORT_SYMBOL(netdev_stats_to_stats64);
EXPORT_SYMBOL(dev_get_stats);
EXPORT_SYMBOL_GPL(dev_fetch_sw_netstats);

so there is no general patterns to follow, pick whatever your want.

	Andrew
