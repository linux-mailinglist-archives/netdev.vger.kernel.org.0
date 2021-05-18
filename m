Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40496387E69
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 19:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351139AbhERRet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 13:34:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46030 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351129AbhERRes (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 13:34:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=7vaTVRbD5NAxdIe/vpM1HK16oQXk9mflt3rGB8eO3bY=; b=AI7RnZCNBh6e1z35nl6UVgDdY7
        oCp25LDRaaWkS7Fd6eN0wkWIfIwQV9JfN0RHoFf7O+iczW4Zxmb0MeQEDc3kJEXAtWZdX3ODJRQhj
        sTWzSxb0S/eIoUEZeAzFiaFBXYfr/Lh6Ir0VcuyZt1+bdTBmBAw8+4de2hKnvGg3abwQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lj3aq-004nBt-NY; Tue, 18 May 2021 19:33:20 +0200
Date:   Tue, 18 May 2021 19:33:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        John Crispin <john@phrozen.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: linux-next: Tree for May 18 (drivers/net/dsa/qca8k.c)
Message-ID: <YKP6YNUyo1K0ojqQ@lunn.ch>
References: <20210518192729.3131eab0@canb.auug.org.au>
 <785e9083-174e-5287-8ad0-1b5b842e2282@infradead.org>
 <20210518164348.vbuxaqg4s3mwzp4e@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210518164348.vbuxaqg4s3mwzp4e@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Would something like this work?
> 
> -----------------------------[ cut here ]-----------------------------
> >From 36c0b3f04ebfa51e52bd1bc2dc447d12d1c6e119 Mon Sep 17 00:00:00 2001
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Tue, 18 May 2021 19:39:18 +0300
> Subject: [PATCH] net: mdio: provide shim implementation of
>  devm_of_mdiobus_register
> 
> Similar to the way in which of_mdiobus_register() has a fallback to the
> non-DT based mdiobus_register() when CONFIG_OF is not set, we can create
> a shim for the device-managed devm_of_mdiobus_register() which calls
> devm_mdiobus_register() and discards the struct device_node *.
> 
> In particular, this solves a build issue with the qca8k DSA driver which
> uses devm_of_mdiobus_register and can be compiled without CONFIG_OF.
> 
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

This should be O.K.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Thanks
    Andrew
