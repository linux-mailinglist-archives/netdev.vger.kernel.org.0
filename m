Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8301B425FA9
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 00:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241615AbhJGWJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 18:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234117AbhJGWJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 18:09:25 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F14C061755;
        Thu,  7 Oct 2021 15:07:30 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id b8so28591544edk.2;
        Thu, 07 Oct 2021 15:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GIFnlR0UIXiylNNwxbCFNahTUAckFo8NiK+ix7l+nDY=;
        b=bi70k7ySJr0oP4n409NVhcfvhjjhzNlELBKnM57osLf6iwIWEL6O5pW6Rch7QqNp/9
         vaFx7m8WXj+yf6jQWwKZQihVcJIbH7ixfMdQhG/dkfSXqM95WjqyHHbB0NxyjQa6X5wb
         7M46KBH2J7xM7sKlrPb0ydvacGFgv7+fonP0Dm4M4hCV8ed/0sOHu3cgq3kRVrn9f3vK
         +ptW6Egn4qAIfdMNeL3aEN3Dh4yCiMKQNEp/o3fVU8HoLDePnY896zyPizbT3ZVn1Ymh
         Ry7G6xBP5o//NNxotaYPzImr5iM9FSFRxrowPpLMUOK44QU5CzvePS9htPqqxwcKdBFd
         FrUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GIFnlR0UIXiylNNwxbCFNahTUAckFo8NiK+ix7l+nDY=;
        b=GUIyRAkdX0XNGx2XQhgEi5eKktZtFqIUknVRpG2GXrmcwH+bVA3/Z/utGojD2cPU/U
         3xubUZyXCS1saYrkQwIOtRvQ967q42sJNYh8YexrO3DBYIxXt7SmnTOl03u24ZrTUvDa
         x3tOlhZMSDY6VBwgGNE0dCM96xN6dUKOt668MhgUV4DqyZioT37owU7YxQYF6A2VPpn4
         VN+6rlKZsf37PnBHTWAgPiy/sMUDDnn3x24aD3sXxQkJAwDKsaDERYXWJqkbVm9GJMiq
         Qb6Zl8TixTTWWAkS0jeRKu2fXszu9hqmauh3U//yiiGIADMb80BJlLWf3poY/G+345f0
         dbIA==
X-Gm-Message-State: AOAM531F4uefYM/oh6vzLfPMHD1CTzgoN35ku6fJrfBtJH0XnRWwEawP
        83yDj75j0RgEMNoDoYOLRYY=
X-Google-Smtp-Source: ABdhPJw9pourmTC5wkkn4jvJ71C3kyOzgk0wvxgWlP4YM67fNQ1VGR//LyCYA12WoGNfEU5fFopRPQ==
X-Received: by 2002:a17:906:4f19:: with SMTP id t25mr2217629eju.176.1633644448446;
        Thu, 07 Oct 2021 15:07:28 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.gmail.com with ESMTPSA id d30sm263682edn.49.2021.10.07.15.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 15:07:27 -0700 (PDT)
Date:   Fri, 8 Oct 2021 00:07:25 +0200
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next PATCH 02/13] drivers: net: phy: at803x: add DAC
 amplitude fix for 8327 phy
Message-ID: <YV9vnW+aUdttNkQl@Ansuel-xps.localdomain>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-3-ansuelsmth@gmail.com>
 <YV44ex0Vh6qtHbOs@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YV44ex0Vh6qtHbOs@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 01:59:55AM +0200, Andrew Lunn wrote:
> On Thu, Oct 07, 2021 at 12:35:52AM +0200, Ansuel Smith wrote:
> > QCA8327 internal phy require DAC amplitude adjustement set to +6% with
> > 100m speed. Also add additional define to report a change of the same
> > reg in QCA8337. (different scope it does set 1000m voltage)
> > Add link_change_notify function to set the proper amplitude adjustement
> > on PHY_RUNNING state and disable on any other state.
> > 
> > Fixes: c6bcec0d6928 ("net: phy: at803x: add support for qca 8327 A variant internal phy")
> > Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> 
> Since this is a fix, you might want to send it on its own, based on
> net.
> 
> > +	/* QCA8327 require DAC amplitude adjustment for 100m set to +6%.
> > +	 * Disable on init and enable only with 100m speed following
> > +	 * qca original source code.
> > +	 */
> > +	if (phydev->drv->phy_id == QCA8327_A_PHY_ID ||
> > +	    phydev->drv->phy_id == QCA8327_B_PHY_ID)
> > +		at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_0,
> > +				      QCA8327_DEBUG_MANU_CTRL_EN, 0);
> > +
> >  	return 0;
> >  }
> >  
> > +static void qca83xx_link_change_notify(struct phy_device *phydev)
> > +{
> > +	/* QCA8337 doesn't require DAC Amplitude adjustement */
> > +	if (phydev->drv->phy_id == QCA8337_PHY_ID)
> > +		return;
> > +
> > +	/* Set DAC Amplitude adjustment to +6% for 100m on link running */
> > +	if (phydev->state == PHY_RUNNING) {
> > +		if (phydev->speed == SPEED_100)
> > +			at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_0,
> > +					      QCA8327_DEBUG_MANU_CTRL_EN,
> > +					      QCA8327_DEBUG_MANU_CTRL_EN);
> > +	} else {
> > +		/* Reset DAC Amplitude adjustment */
> > +		at803x_debug_reg_mask(phydev, AT803X_DEBUG_REG_0,
> > +				      QCA8327_DEBUG_MANU_CTRL_EN, 0);
> 
> Here you don't make it conditional on QCA8327_A_PHY_ID and
> QCA8327_B_PHY_ID, where as above you do?
>
>  	  Andrew

We skip the DAC Amplitude for 8337. We support 8327 a/b and 8337.
Anyway sending this and other patch to v2 with the asked changes.

-- 
	Ansuel
