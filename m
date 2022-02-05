Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A627A4AA97F
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 15:49:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380069AbiBEOsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Feb 2022 09:48:45 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43798 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231243AbiBEOsm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Feb 2022 09:48:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=RWk0M1l84ETj2V8yuZdcSey40lGc+adG6rlPXZ9B838=; b=jxOiIcwoX6wsboF8MHOXeHfXrm
        IliUTar6Irri2hQRlO1/HbfM05jC/pjX2/P3nqT3hM0oQKJiFFiMnrmlPc0pw4Rl0B4qFIUYE+3aE
        ix9twcRZngwOWmAs69FUu6VPaxL8IvxmiBI4nm/za00yd56lA4jrMOPeNr6y/HfytvDE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nGMMj-004Ost-KQ; Sat, 05 Feb 2022 15:48:41 +0100
Date:   Sat, 5 Feb 2022 15:48:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 2/3] sunhme: fix the version number in struct
 ethtool_drvinfo
Message-ID: <Yf6OSc78JScHNgag@lunn.ch>
References: <4686583.GXAFRqVoOG@eto.sf-tec.de>
 <3152336.aeNJFYEL58@eto.sf-tec.de>
 <YfwNCAYc6Xyk8V8K@lunn.ch>
 <5538622.DvuYhMxLoT@eto.sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5538622.DvuYhMxLoT@eto.sf-tec.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > struct ethtool_drvinfo *info> 
> > >  {
> > >  
> > >  	struct happy_meal *hp = netdev_priv(dev);
> > > 
> > > -	strlcpy(info->driver, "sunhme", sizeof(info->driver));
> > > -	strlcpy(info->version, "2.02", sizeof(info->version));
> > > +	strlcpy(info->driver, DRV_NAME, sizeof(info->driver));
> > > +	strlcpy(info->version, DRV_VERSION, sizeof(info->version));
> > 
> > I would suggest you drop setting info->version. The kernel will fill
> > it with the current kernel version, which is much more meaningful.
> 
> Would it make sense to completely remove the version number from the driver 
> then?

If it is not used anywhere else, yes, you can remove it.

   Andrew
