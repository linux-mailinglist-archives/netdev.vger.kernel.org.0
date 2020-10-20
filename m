Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF21293CFA
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 15:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407323AbgJTNJE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 09:09:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36612 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407245AbgJTNI6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 09:08:58 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUrNk-002fbE-2s; Tue, 20 Oct 2020 15:08:52 +0200
Date:   Tue, 20 Oct 2020 15:08:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Duan <fugang.duan@nxp.com>
Cc:     Greg Ungerer <gerg@linux-m68k.org>,
        Chris Heally <cphealy@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH] net: ethernet: fec: Replace interrupt driven
 MDIO with polled IO
Message-ID: <20201020130852.GZ456889@lunn.ch>
References: <c8143134-1df9-d3bc-8ce7-79cb71148d49@linux-m68k.org>
 <20201020024000.GV456889@lunn.ch>
 <AM8PR04MB73150BDBA6E79ABE662B6762FF1F0@AM8PR04MB7315.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM8PR04MB73150BDBA6E79ABE662B6762FF1F0@AM8PR04MB7315.eurprd04.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Now, I want to revert the polling mode to original interrupt mode, do you agree ?

Hi Andy

I would like to see if fixed, rather than reverted. Lets try to figure
out the quirks needed to handle the different versions for the IP.

    Andrew
