Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7204A23483D
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 17:14:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbgGaPOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 11:14:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37086 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727819AbgGaPOz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 11:14:55 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k1Wk8-007iKb-Sq; Fri, 31 Jul 2020 17:14:44 +0200
Date:   Fri, 31 Jul 2020 17:14:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Dan Callaghan <dan.callaghan@opengear.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Russell King <linux@armlinux.org.uk>, Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, "linux.cj" <linux.cj@gmail.com>,
        linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
Message-ID: <20200731151444.GI1712415@lunn.ch>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
 <20200724133931.GF1472201@lunn.ch>
 <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
 <20200724191436.GH1594328@lunn.ch>
 <1595922651-sup-5323@galangal.danc.bne.opengear.com>
 <20200728204548.GC1748118@lunn.ch>
 <7d42152a-2df1-a26c-b619-b804001e0eac@gmail.com>
 <CAHp75VejnW23LEfyEO6Py8=e3_W0YMomk8jQ3JQeHqYcaeDitg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VejnW23LEfyEO6Py8=e3_W0YMomk8jQ3JQeHqYcaeDitg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > DT can be used on x86, and i suspect it is a much easier path of least
> > > resistance.
> >
> > And you can easily overlay Device Tree to an existing system by using
> > either a full Device Tree overlay (dtbo) or using CONFIG_OF_DYNAMIC and
> > creating nodes on the fly.
> 
> Why do you need DT on a system that runs without it and Linux has all
> means to extend to cover a lot of stuff DT provides for other types of
> firmware nodes?

As i said, path of least resistance. It is here today, heavily used,
well understood by lots of network developers, has a very active
maintainer in the form of Rob Herring, and avoids 'showflakes' as
Florian likes to call it, so we are all sharing the same code,
providing a lot of testing and maintenance.

	  Andrew
