Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49B0A30144C
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 10:41:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbhAWJlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 04:41:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbhAWJlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 04:41:03 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096FFC06174A;
        Sat, 23 Jan 2021 01:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=XKa+GXO9ufZsxD8+yBXi0m/qSb14cINiN5NUfGG8QZA=; b=JOoIWp77m0DXIi9Ty2U5JWLy5
        X9EqyxxKm2CGcOuGiAvErIh01r9AnuLrRemrXDeNHnrwHQYr6nSdlEsnOhQGeHrguNbLXq+WhZBqX
        aTp6fmTNnAxN/kFZmTSw9pAuwxGLXLk9nSYq8PNa0L1uaefC6CyCm1T+AhrDH5+KD1BaAT3XvI7f7
        9rjtnarmtzN0lF08E3R7KAwS0p2Ox8TKGwZKGiUOawZyH9tqmYgfVBzrCaBS3O+k2oJH2lEhJkrCZ
        snzyP67BRbxrsD0mh+Ua3wJuA7OUy9BAiaJhg908rpAiCjUk3k+wTROtHVXdpNngTgqfeJ3hJOLEa
        BU8bDDckQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51634)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1l3FOg-0001kZ-D3; Sat, 23 Jan 2021 09:39:58 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1l3FOb-0000aE-9R; Sat, 23 Jan 2021 09:39:53 +0000
Date:   Sat, 23 Jan 2021 09:39:53 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Marc Zyngier <maz@kernel.org>, linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Brandon Streiff <brandon.streiff@ni.com>,
        Olof Johansson <olof@lixom.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        David Miller <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net 2/4] net: mvpp2: Remove unneeded Kconfig dependency.
Message-ID: <20210123093953.GT1551@shell.armlinux.org.uk>
References: <cover.1611198584.git.richardcochran@gmail.com>
 <1069fecd4b7e13485839e1c66696c5a6c70f6144.1611198584.git.richardcochran@gmail.com>
 <20210121102753.GO1551@shell.armlinux.org.uk>
 <20210121150802.GB20321@hoboy.vegasvil.org>
 <20210122181444.66f9417d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122181444.66f9417d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 22, 2021 at 06:14:44PM -0800, Jakub Kicinski wrote:
> On Thu, 21 Jan 2021 07:08:02 -0800 Richard Cochran wrote:
> > On Thu, Jan 21, 2021 at 10:27:54AM +0000, Russell King - ARM Linux admin wrote:
> > > On Wed, Jan 20, 2021 at 08:06:01PM -0800, Richard Cochran wrote:  
> > > > The mvpp2 is an Ethernet driver, and it implements MAC style time
> > > > stamping of PTP frames.  It has no need of the expensive option to
> > > > enable PHY time stamping.  Remove the incorrect dependency.
> > > > 
> > > > Signed-off-by: Richard Cochran <richardcochran@gmail.com>
> > > > Fixes: 91dd71950bd7 ("net: mvpp2: ptp: add TAI support")  
> > > 
> > > NAK.  
> > 
> > Can you please explain why mvpp2 requires NETWORK_PHY_TIMESTAMING?
> 
> Russell, I think we all agree now this is not the solution to the
> problem of which entity should provide the timestamp, but the series
> doesn't seem objectionable in itself.
> 
> Please LMK if you think otherwise.
> 
> (I would put it in net-next tho, given the above this at most a space
> optimization.)

Correct - my NAK is on the basis that this series was put forward
as solving the issue I had raised, but in reality it does little
to achieve that.

It is, as you say, just a space optimisation, and I have no issue
with it being merged on that basis.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
