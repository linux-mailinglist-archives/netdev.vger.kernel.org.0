Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C3F39B8C8
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 14:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230292AbhFDMLi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 08:11:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45306 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230063AbhFDMLh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 08:11:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=tvPVQ1G77EHS9INUUKJYFytpPi6OHzU61guoVrrwqK0=; b=ZGjhoMyiWy6T25xovKAPXAnJWb
        GarTgpKZ3mGqNAvfW/KCIF5CaYTgV5zlnzKGjToMwi2IOoJvJPEAVSd3HV3p/UwDdL8IDbfKAifPk
        Ei8n6EeeflJM4lNcT1pCAMJEEQMk1vrs66wuQnPH1XNb691sOHj3hy94S973GKoRk6lI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lp8e0-007nRL-G9; Fri, 04 Jun 2021 14:09:44 +0200
Date:   Fri, 4 Jun 2021 14:09:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Liang Xu <lxu@maxlinear.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>
Subject: Re: [PATCH v2] net: phy: add Maxlinear GPY115/21x/24x driver
Message-ID: <YLoYCEut5MIzikUQ@lunn.ch>
References: <20210603073438.33967-1-lxu@maxlinear.com>
 <20210603091750.GQ30436@shell.armlinux.org.uk>
 <54b527d6-0fe6-075f-74d6-cc4c51706a87@maxlinear.com>
 <YLjzeMpRDIUV9OAI@lunn.ch>
 <1e580c98-3a0c-2e60-17e3-01ad8bfd69d9@maxlinear.com>
 <YLkL6MWJCheuUJv1@lunn.ch>
 <627eca5a-04a5-5b73-2f7e-fab372d74fd3@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <627eca5a-04a5-5b73-2f7e-fab372d74fd3@maxlinear.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> In one of our product (in developing), the NIC driver can decide to 
> switch to 2nd firmware.

There are currently no systems like this in Linux. So this is going to
need new support. Ideally, we don't want the MAC involved in this
switch, because then you need to teach every MAC driver in linux about
how your PHY is special.

I would say, for the moment, forget about this setup. When you submit
support for it, we can look at the bigger picture, and see how best to
support it.

So please put the firmware version print in the driver probe
function. That should work for the devices the driver currently
supports.

	  Andrew
