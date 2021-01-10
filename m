Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 845652F0860
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 17:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbhAJQXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 11:23:03 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59836 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726727AbhAJQXD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 11:23:03 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kydTq-00HKlc-9S; Sun, 10 Jan 2021 17:22:14 +0100
Date:   Sun, 10 Jan 2021 17:22:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yuusuke Ashizuka <ashiduka@fujitsu.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, torii.ken1@fujitsu.com
Subject: Re: [PATCH v2] net: phy: realtek: Add support for RTL9000AA/AN
Message-ID: <X/sptqSqUS7T5XWR@lunn.ch>
References: <20210110085221.5881-1-ashiduka@fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210110085221.5881-1-ashiduka@fujitsu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 05:52:21PM +0900, Yuusuke Ashizuka wrote:
> RTL9000AA/AN as 100BASE-T1 is following:
> - 100 Mbps
> - Full duplex
> - Link Status Change Interrupt

Hi Yuusuke

For T1, it seems like Master is pretty important. Do you have
information to be able to return the current Master/slave
configuration, or allow it to be configured? See the nxp-tja11xx.c for
an example.

   Thanks
	Andrew
