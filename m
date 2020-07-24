Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACE522D032
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 23:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgGXVGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 17:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbgGXVGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 17:06:47 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E27CC0619D3;
        Fri, 24 Jul 2020 14:06:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CBow5sMSdFqU9XIHLh46kSKhelS/QdYryJzYOsFaK0I=; b=BgZK/ls+cTh3UFlYSRPp5yQZj
        ppPD3a1eWBLFP7cfSIm8J50embsGjoP6YCXX+hT5mN3vmh8By4mjsttKMDa9jTrvXC78Y9KnooZjB
        T87daYBgF4QRd2BMmD7QnMbbeMcft+O3i4Ax6kwJ4Mh4URR5AM4F0QBPvZo6xddj49TcLWZplcSv0
        HDLHycbtEBNZxjoRyibMaT7HnTWFXI2ZfkzhEmhd+gkpeTmyVP28yJxrrpOkFTw5vgwNZ+YAs1ryd
        dx3RKLKFTO7WUezFNDPuOLFONz+VzM22dzirRWCh25i3mUWCGdWJW+JbYPmj4nGXry5yEh9xSW5Dl
        LvXOyoFkg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43708)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jz4tv-0000PJ-1R; Fri, 24 Jul 2020 22:06:43 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jz4tt-0000uQ-Ub; Fri, 24 Jul 2020 22:06:41 +0100
Date:   Fri, 24 Jul 2020 22:06:41 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        netdev <netdev@vger.kernel.org>, linux.cj@gmail.com,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [net-next PATCH v7 1/6] Documentation: ACPI: DSD: Document MDIO
 PHY
Message-ID: <20200724210641.GD1551@shell.armlinux.org.uk>
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-2-calvin.johnson@oss.nxp.com>
 <1a031e62-1e87-fdc1-b672-e3ccf3530fda@arm.com>
 <20200724133931.GF1472201@lunn.ch>
 <97973095-5458-8ac2-890c-667f4ea6cd0e@arm.com>
 <a95f8e07-176b-7f22-1217-466205fa22e7@gmail.com>
 <20200724192008.GI1594328@lunn.ch>
 <CAHp75VdsGsTNc-SYRbM6-HHXSoDdLTqBrvJwyugjUR6HTxwDyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75VdsGsTNc-SYRbM6-HHXSoDdLTqBrvJwyugjUR6HTxwDyA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 11:12:15PM +0300, Andy Shevchenko wrote:
> On Fri, Jul 24, 2020 at 10:20 PM Andrew Lunn <andrew@lunn.ch> wrote:
> 
> > I think we need to NACK all attempts to add ACPI support to phylib and
> > phylink until an authoritative ACPI Linux maintainer makes an
> > appearance and actively steers the work. And not just this patchset,
> > but all patchsets in the networking domain which have an ACPI
> > component.
> 
> It's funny, since I see ACPI mailing list and none of the maintainers
> in the Cc here...
> I'm not sure they pay attention to some (noise-like?) activity which
> (from their perspective) happens on unrelated lists.

That is really disappointing that these patch sets are not being copied
to the appropriate people (ACPI).

I seem to remember I've already stated on at least a couple of
occasions that these patch sets which add ACPI support to phylib need
to be copied to ACPI people.  I guess if ACPI people have been omitted,
there will be a few more patch series iterations.  Then there's that
all the discussion that has already happened is not known to ACPI
people, so we're probably doomed to repeating at least some of that.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
