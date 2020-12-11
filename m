Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA74D2D7A02
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 16:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387944AbgLKP4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 10:56:25 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:50894 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390243AbgLKP4E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Dec 2020 10:56:04 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1knklN-00BS2r-L3; Fri, 11 Dec 2020 16:55:21 +0100
Date:   Fri, 11 Dec 2020 16:55:21 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marian Cichy <mci@pengutronix.de>
Cc:     Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>, netdev@vger.kernel.org,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>, kernel@pengutronix.de
Subject: Re: [PATCH] net: ethernet: fec: Clear stale flag in IEVENT register
 before MII transfers
Message-ID: <20201211155521.GE2654274@lunn.ch>
References: <20201209102959.2131-1-u.kleine-koenig@pengutronix.de>
 <20201209144413.GJ2611606@lunn.ch>
 <20201209165148.6kbntgmjopymomx5@pengutronix.de>
 <dbf9184d-adb2-6377-414b-0593ecb89149@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbf9184d-adb2-6377-414b-0593ecb89149@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > @Marian: As it's you who has to work on this i.MX25 machine, can you
> > maybe test if using a kernel > 5.10-rc3 (or cherry-picking
> > 1e6114f51f9d4090390fcec2f5d67d8cc8dc4bfc) fixes the problem for you?
> 
> Tested it on 5.10-rc7 and the problem is fixed without your previous patch.

Hi Marian

Thanks for testing. It keeps surprising me how much breakage this
change i made caused :-(

       Andrew
