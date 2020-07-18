Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105EA224C45
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 17:08:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgGRPIR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 11:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbgGRPIQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 11:08:16 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB735C0619D2;
        Sat, 18 Jul 2020 08:08:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=+RnjnSg97VRVKcHoMSxOG0EgfEJNic76KFl9cOGSwKk=; b=a2QK1vxwa8FyJw0fbents0zYc
        C2Jpn8DLVDecCT9sFPlXcDpmYUyWdwjY8evl8JiBuoPSdgVlGq+TGOnS2xEqXxKeUXCkihRZGIlkV
        uaxPFVf8AE+xDK0pm4U7Db+//2HJ3BpzfssRyP9rieSnMa1w+zT9driTurxlXpqhmDEoV1PNkk3Rh
        RaEVV52MeZrfyPawCyO7kAF5+d2/UnkA600MfBoOEavPoI3iwW2dIZiigq7Bgh1YzCQJH2fz/zlyT
        19P2yICoMX6YD6ybHxYkbPneYsZ0JlU1tXCrAwCfbEFJyn545kEo9BHpgmq0Wgdf6audicKttZk5p
        jqGpE1TMA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41112)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jwoRc-0001fg-Td; Sat, 18 Jul 2020 16:08:08 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jwoRZ-00031g-JG; Sat, 18 Jul 2020 16:08:05 +0100
Date:   Sat, 18 Jul 2020 16:08:05 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     John Crispin <john@phrozen.org>,
        Matthew Hagan <mnhagan88@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jonathan McDowell <noodles@earth.li>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/2] dt-bindings: net: dsa: qca8k: Add PORT0_PAD_CTRL
 properties
Message-ID: <20200718150805.GR1551@shell.armlinux.org.uk>
References: <2e1776f997441792a44cd35a16f1e69f848816ce.1594668793.git.mnhagan88@gmail.com>
 <ea0a35ed686e6dace77e25cb70a8f39fdd1ea8ad.1594668793.git.mnhagan88@gmail.com>
 <20200716150925.0f3e01b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ac7f5f39-9f83-64c0-d8d5-9ea059619f67@gmail.com>
 <53851852-0efe-722e-0254-8652cdfea8fc@phrozen.org>
 <20200718132011.GQ1551@shell.armlinux.org.uk>
 <20200718144435.GA1375379@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200718144435.GA1375379@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 18, 2020 at 04:44:35PM +0200, Andrew Lunn wrote:
> On Sat, Jul 18, 2020 at 02:20:11PM +0100, Russell King - ARM Linux admin wrote:
> > On Fri, Jul 17, 2020 at 10:44:19PM +0200, John Crispin wrote:
> > > in regards to the sgmii clk skew. I never understood the electrics fully I
> > > am afraid, but without the patch it simply does not work. my eletcric foo is
> > > unfortunately is not sufficient to understand the "whys" I am afraid.
> > 
> > Do you happen to know what frequency the clock is?  Is it 1.25GHz or
> > 625MHz?  It sounds like it may be 1.25GHz if the edge is important.
> 
> I'm also a bit clueless when it comes to these systems.
> 
> I thought the clock was embedded into the SERDES signal? You recover
> it from the signal?

Indeed it is.  An external clock can be used to avoid needing clock
recovery in the SERDES receiver.

For example, with the 88E1111, it only accepts the datastream from
the MAC with no provision for a separate clock, but it can be
configured to generate a 625MHz clock for the data stream to the MAC
if required.

Being 625MHz (half the data rate), both edges of the clock are used,
with a delay to help avoid the metastability hazard I previously
described at the receiver.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
