Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7268194873
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 21:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728317AbgCZUNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 16:13:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60062 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726363AbgCZUNa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 16:13:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zwAVpJjqPLq6MNjNDRRsQrtVSOVks/wsW0vawmy5I7M=; b=FSqcZVqvG+4ObFQxnM5G6yMi7O
        EaRdqLRt4IZCBSs967tq9jqR77bXOKAzbrrV4qfB7maXYu/RXBJWPLYByKO4FeJ+3aofZruSiuzvO
        L4sHuZEERWMA/AdVRqyU77if1nwI6FmqNrwz+09q+NTufDsoBf81h9+gr8pqrvnu20AE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jHYsI-0002vn-OE; Thu, 26 Mar 2020 21:13:10 +0100
Date:   Thu, 26 Mar 2020 21:13:10 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joe Perches <joe@perches.com>
Cc:     florinel.iordache@nxp.com, davem@davemloft.net,
        netdev@vger.kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, kuba@kernel.org, corbet@lwn.net,
        shawnguo@kernel.org, leoyang.li@nxp.com, madalin.bucur@oss.nxp.com,
        ioana.ciornei@nxp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 7/9] net: phy: enable qoriq backplane support
Message-ID: <20200326201310.GB11004@lunn.ch>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
 <1585230682-24417-8-git-send-email-florinel.iordache@nxp.com>
 <ba3b1a69496eb08cb071dace96fd385ff8f838e7.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba3b1a69496eb08cb071dace96fd385ff8f838e7.camel@perches.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static int qoriq_backplane_config_init(struct phy_device *bpphy)
> > +{
> []
> > +	for (i = 0; i < bp_phy->num_lanes; i++) {
> []
> > +		ret = of_address_to_resource(lane_node, 0, &res);
> > +		if (ret) {
> > +			bpdev_err(bpphy,
> > +				  "could not obtain lane memory map for index=%d, ret = %d\n",
> > +				  i, ret);
> > +			return ret;
> 
> This could use the new vsprintf %pe extension:

Hi Joe

Probably a FAQ. But is there plans to extend vsprintf to take an int
errno value, rather than having to do this ugly ERR_PTR(ret) every
time? Format string %de ?

      Andrew
