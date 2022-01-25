Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4BD49AA59
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 05:36:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1325364AbiAYDg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 22:36:56 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:52124 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346056AbiAYB6d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jan 2022 20:58:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vqIncw13EOORmlT/EjoC9h1eW7p1pLa1zW6wJTH4hys=; b=LehDvF77PFOcpCL1ZlaeFDIvoy
        6kdNcCdYavZY8+3gy+TB/K/Slen/OnLNJCdIHkF7MpikmyoRpea9BKbbuLu7UvV/xH51qrjZT5bPI
        7A3Myt6wLQLzABqOIHDH4s9Ex/dkrmxmsX6tYe7qKv8CxnoWENvJ1DZrsmCCWydCODNk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nCAhM-002ZLq-HM; Tue, 25 Jan 2022 02:32:40 +0100
Date:   Tue, 25 Jan 2022 02:32:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Voon, Weifeng" <weifeng.voon@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 2/2] net: stmmac: skip only stmmac_ptp_register when
 resume from suspend
Message-ID: <Ye9TOHoFJi3PjhNV@lunn.ch>
References: <20220124095951.23845-1-mohammad.athari.ismail@intel.com>
 <20220124095951.23845-3-mohammad.athari.ismail@intel.com>
 <Ye6maxMtt68JlZ9l@lunn.ch>
 <CO1PR11MB47716D7115E85AC4649CD3A5D55E9@CO1PR11MB4771.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB47716D7115E85AC4649CD3A5D55E9@CO1PR11MB4771.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > @@ -3308,13 +3309,11 @@ static int stmmac_hw_setup(struct net_device
> > *dev, bool init_ptp)
...

> > The init_ptp parameter now seems unused? If so, please remove it.
> 
> I believe you miss below diff. It is renamed to ptp_register.

Ah, yes, sorry. I was looking at the context information diff gives
you, which still has the old name.

      Andrew
