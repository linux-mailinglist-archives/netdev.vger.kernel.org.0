Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82994318C20
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 14:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231929AbhBKNdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 08:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231428AbhBKNab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 08:30:31 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A3AC0613D6;
        Thu, 11 Feb 2021 05:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=b6o4aDZrMqqadRFFl5hXLDZ9uNJ0V1uHD3B0a1g67QA=; b=sQGdtXmcj/fpQLIDNuwVr2e7q
        D6QOXwqSINqDuPtvitlBPfmt2u5LPYJ2ITDGtgy0XCMjPLQJrozQSYhFEAWVKTcVgc39oX6BTiY4U
        CwBCBu4FgH6JlIHbybbDvTl3IYt8qtoy/nPvkV27c/hQhpen7BhP2EzSyX76DYOSofdS6xZnsi4Oj
        xn1BefN2dAGgrB0Jnz80PkujScNWj/SWPW460Ks21MwX1ep/OfvOnnAUG5fUiFlF+H+BZmjnja7z+
        nRSE8XFGXg9pCEm1r7Jkqni07+AvzwsGfTDe5YoLxeGKGwqQqtWinSYdIOx+MVPE+FXFDNNitp26O
        h0vlWOHsQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42050)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lAC2U-0006DE-3k; Thu, 11 Feb 2021 13:29:46 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lAC2S-00068K-Nn; Thu, 11 Feb 2021 13:29:44 +0000
Date:   Thu, 11 Feb 2021 13:29:44 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Stefan Chulski <stefanc@marvell.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "gregory.clement@bootlin.com" <gregory.clement@bootlin.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [EXT] Re: [PATCH v13 net-next 08/15] net: mvpp2: add FCA RXQ non
 occupied descriptor threshold
Message-ID: <20210211132944.GJ1463@shell.armlinux.org.uk>
References: <1613040542-16500-1-git-send-email-stefanc@marvell.com>
 <1613040542-16500-9-git-send-email-stefanc@marvell.com>
 <20210211125009.GF1463@shell.armlinux.org.uk>
 <CO6PR18MB387356BB83D26789CA8B17E9B08C9@CO6PR18MB3873.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB387356BB83D26789CA8B17E9B08C9@CO6PR18MB3873.namprd18.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 01:02:14PM +0000, Stefan Chulski wrote:
> > On Thu, Feb 11, 2021 at 12:48:55PM +0200, stefanc@marvell.com wrote:
> > > diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > index 761f745..8b4073c 100644
> > > --- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > +++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
> > > @@ -1133,14 +1133,19 @@ static inline void
> > > mvpp2_qvec_interrupt_disable(struct mvpp2_queue_vector *qvec)  static
> > > void mvpp2_interrupts_mask(void *arg)  {
> > >  	struct mvpp2_port *port = arg;
> > > +	int cpu = smp_processor_id();
> > > +	u32 thread;
> > >
> > >  	/* If the thread isn't used, don't do anything */
> > > -	if (smp_processor_id() > port->priv->nthreads)
> > > +	if (cpu > port->priv->nthreads)
> > >  		return;
> > 
> > What happened to a patch fixing this? Did I miss it? Was it submitted
> > independently to the net tree?
> 
> Some reviewers asked to remove this from the series. I would send it as separate patch to net.

It is not a regression, and although it is a fix, as you explained when
I first raised it, it isn't a condition that can be reached due to:

        priv->nthreads = min_t(unsigned int, num_present_cpus(),
	                       MVPP2_MAX_THREADS);

and I don't think we support a dynamic present CPU mask on any platform
that is currently supported by this driver.

If we did, then it would be possible for the off-by-one issue to be
triggered.

No matter what, it should happen _before_ this patch set is merged.
Trying to do it afterwards guarantees more pain if stable trees decide
they want to backport the fix.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
