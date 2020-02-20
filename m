Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA5D165DC3
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 13:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728079AbgBTMpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 07:45:01 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:59558 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728021AbgBTMpB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 07:45:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=R369sL0VLFimBIx147SXo3eqZwfJGSxdQcRCXIrFIUI=; b=CltUXaS33n+OwBFjIcX/JHoWi
        SmsXkCCQumQ+PiqIRm6SFpTec3uPlVmjF/qRKs3yJUcJaTlrYPKQuK6d0oen0ZHTXsbivHo4WKWlL
        hNLFaPGbx/qGtUaTT9ji9Bc282fxjBwFyO45vcM/5Qc4vEbd/EMevu4HLsG8O8lvMRIALyJZWUmYx
        eeg4US9utxDh2pSJepcHXllDGX2OnPy4zCyoN1C8fpprEnvTFJgUhMmxi439ppDgh6xgot0hH5Gy8
        BoZdimP8shOWk1CalY8yHi9WWTjXK9NIUAl/8z+g8j42/0L489z4EYdxUI8tKIGsuETcBPJZvk/m8
        6x9ZzU2jA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:50388)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j4lCG-0003Ht-5J; Thu, 20 Feb 2020 12:44:52 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j4lCD-0002Rg-0l; Thu, 20 Feb 2020 12:44:49 +0000
Date:   Thu, 20 Feb 2020 12:44:48 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: Re: [CFT 6/8] net: macb: use resolved link config in mac_link_up()
Message-ID: <20200220124448.GZ25745@shell.armlinux.org.uk>
References: <20200217172242.GZ25745@shell.armlinux.org.uk>
 <E1j3k85-00072l-RK@rmk-PC.armlinux.org.uk>
 <20200219143036.GB3390@piout.net>
 <20200220101828.GV25745@shell.armlinux.org.uk>
 <20200220123853.GH3281@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220123853.GH3281@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 01:38:53PM +0100, Andrew Lunn wrote:
> > Thanks, that looks reasonable to me. I'll replace my patch with this
> > one if it's appropriate for net-next when I send this series for
> > merging.  However, I see most affected network driver maintainers
> > haven't responded yet, which is rather disappointing.  So, thanks
> > for taking the time to look at this.
> 
> Hi Russell
> 
> I suspect most maintainers are lazy. Give them a branch to pull, and
> they might be more likely to test.

While that seems like a trivial solution, it'll take me a while to
set that up. I've no desire to upload a lot of data over my
internet connection during peak hours (and see the upload rate in
my signature below.)

Not everywhere has "fast" internet.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
