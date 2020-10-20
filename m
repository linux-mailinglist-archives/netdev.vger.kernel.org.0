Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F7C293FEC
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 17:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436877AbgJTPv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 11:51:28 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36862 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731778AbgJTPv2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 11:51:28 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUtv4-002gPx-51; Tue, 20 Oct 2020 17:51:26 +0200
Date:   Tue, 20 Oct 2020 17:51:26 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org
Subject: Re: [PATCH russell-kings-net-queue v2 2/3] net: phy: sfp: add
 support for multigig RollBall modules
Message-ID: <20201020155126.GH139700@lunn.ch>
References: <20201020150615.11969-1-kabel@kernel.org>
 <20201020150615.11969-3-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020150615.11969-3-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> @@ -2006,6 +2040,23 @@ static int sfp_sm_mod_probe(struct sfp *sfp, bool report)
>  
>  	sfp->id = id;
>  
> +	sfp->phy_addr = SFP_PHY_ADDR;
> +
> +	rollball = ((!memcmp(id.base.vendor_name, "OEM             ", 16) ||
> +		     !memcmp(id.base.vendor_name, "Turris          ", 16)) &&
> +		    (!memcmp(id.base.vendor_pn, "SFP-10G-T       ", 16) ||
> +		     !memcmp(id.base.vendor_pn, "RTSFP-10", 8)));

Are you customising the SFP, so that it has your vendor name?

Is the generic SFP OEM/SFP-10G-T, and your customized one Turris/ 
RTSFP-10?

	Andrew
