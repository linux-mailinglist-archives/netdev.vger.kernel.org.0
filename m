Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112153F9234
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 04:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244005AbhH0CEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Aug 2021 22:04:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44182 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231588AbhH0CE3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Aug 2021 22:04:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=GuRZkuKuMuIZkC+HPEQmbSTwj2lMnWB+PUw0G55rLes=; b=vhd7m8gEUoEIMs6OaIWlMmSvXe
        GKT1vYNssoGR6c4ym6+a/W5UTYIIvJkM02ILKd4++Bq5JIxnXIRfvgdnqHy+/HK46ZXjK9WKRLeeQ
        SSqAnndp4xK2HmO3h/ZHK6C29Yr4op4JYR9UZ+lhHVRk2Uk5OmJ7Gks4YAHasKlCuFug=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mJRDP-0042ba-AC; Fri, 27 Aug 2021 04:03:31 +0200
Date:   Fri, 27 Aug 2021 04:03:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Subject: Re: [PATCH net-next v2 1/2] net: pcs: xpcs: enable skip xPCS soft
 reset
Message-ID: <YShH84C9gFtL1LcJ@lunn.ch>
References: <20210826235134.4051310-1-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826235134.4051310-1-vee.khee.wong@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 07:51:32AM +0800, Wong Vee Khee wrote:
> Unlike any other platforms, Intel AlderLake-S uses Synopsys SerDes where
> all the SerDes PLL configurations are controlled by the xPCS at the BIOS
> level. If the driver perform a xPCS soft reset on initialization, these
> settings will be switched back to the power on reset values.

So you have given up on the idea of calling into the BIOS to do this?
ACPI is too difficult to use? Can you at least copy the code from the
BIOS into the driver? It might then also be possible to fix your
inability to swap link speeds?

	  Andrew
