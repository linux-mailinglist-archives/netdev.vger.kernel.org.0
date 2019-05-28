Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 066862C839
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 16:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbfE1OBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 10:01:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35464 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbfE1OBN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 10:01:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=vKGUIXYi/3OQeBSb715W30qlnj13vd2M6rGmCnI+BJc=; b=WAc6Ce3LLQ1k9uSwYyyYazaZIS
        lmhWRpykIh61J+oNz0y7A2iaWTEQPSeDQ/e6y9kfIqhw33dqirTq3/Y+13pOc4Pdn6I69IF4lWqJL
        uSYh7TGyA9Od0NRcD1DNBw9Cl1EF3HivRDR/GH76wx4ZCYmVBghcnsIF6lQePG4TcK94=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hVcf3-0006wh-Pv; Tue, 28 May 2019 16:01:05 +0200
Date:   Tue, 28 May 2019 16:01:05 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH V3 net-next 2/6] net: Introduce a new MII time stamping
 interface.
Message-ID: <20190528140105.GH18059@lunn.ch>
References: <20190521224723.6116-3-richardcochran@gmail.com>
 <20190522005823.GD6577@lunn.ch>
 <20190528051750.ub4urccdwmkg2u3c@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528051750.ub4urccdwmkg2u3c@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 27, 2019 at 10:17:50PM -0700, Richard Cochran wrote:
> On Wed, May 22, 2019 at 02:58:23AM +0200, Andrew Lunn wrote:
> > > -static int dp83640_hwtstamp(struct phy_device *phydev, struct ifreq *ifr)
> > > +static int dp83640_hwtstamp(struct mii_timestamper *mii_ts, struct ifreq *ifr)
> > >  {
> > > -	struct dp83640_private *dp83640 = phydev->priv;
> > > +	struct dp83640_private *dp83640 =
> > > +		container_of(mii_ts, struct dp83640_private, mii_ts);
> > >  	struct hwtstamp_config cfg;
> > >  	u16 txcfg0, rxcfg0;
> > 
> > Hi Richard
> > 
> > David might complain about reverse christmas tree. Maybe define a
> > macro, to_dp83640() which takes mii_ts?
> 
> That is nice idea for another series, I think.  For now this matches
> the existing 'container_of' usage within the driver.

Well, David might reject it because it is not reverse christmas tree.

      Andrew
