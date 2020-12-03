Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB212CCDC0
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 05:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbgLCEIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 23:08:40 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35532 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726071AbgLCEIk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 23:08:40 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kkfuQ-009yfM-NI; Thu, 03 Dec 2020 05:07:58 +0100
Date:   Thu, 3 Dec 2020 05:07:58 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Grant Edwards <grant.b.edwards@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: net: macb: fail when there's no PHY
Message-ID: <20201203040758.GC2333853@lunn.ch>
References: <66c0a032-4d20-69f1-deb4-6c65af6ec740@gmail.com>
 <CAK=1mW6Gti0QpUjirB6PfMCiQvnDjkbb56pVKkQmpCSkRU6wtA@mail.gmail.com>
 <6a9c1d4a-ed73-3074-f9fa-158c697c7bfe@gmail.com>
 <X8fb4zGoxcS6gFsc@grante>
 <20201202183531.GJ2324545@lunn.ch>
 <rq8p74$2l0$1@ciao.gmane.io>
 <20201202211134.GM2324545@lunn.ch>
 <rq9ki2$uqk$1@ciao.gmane.io>
 <57728908-1ae3-cbe9-8721-81f06ab688b8@gmail.com>
 <rq9nih$egv$1@ciao.gmane.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <rq9nih$egv$1@ciao.gmane.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> So I can avoid my local hack to macb_main.c by doing a doing a local
> hack to macb_main.c?

User space drivers were never supported in any meaningful way. The
IOCTL call is basically there for mii-tool, and nothing much more.

The way to avoid your local hack is to move your drivers into the
kernel, along side all the other drivers for devices on MDIO busses.

	Andrew
