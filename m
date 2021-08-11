Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F8AF3E9394
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 16:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbhHKOVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 10:21:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45150 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232341AbhHKOVy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Aug 2021 10:21:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=hKc2VUZOlUn7+9qhTayubrmJeEFnKYw+IpcOlyGgPPk=; b=PbyC/yxQGYgnOdQZDAa0h8cp6m
        Qlzmv+ahlLg98NOGhtKsPTjc5n4pywyf0RD2mgvwWFJpCpJOwSLsu/y58jWtQNZO5bTSbHSy3cQS3
        4PsgXxyKHPz9IbUkdqdRUBChsNzWnr6T2OhDC2hLQDR7n57+YaDf/GW9w/bBFFq6NEbY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mDp6G-00H7vb-PU; Wed, 11 Aug 2021 16:20:56 +0200
Date:   Wed, 11 Aug 2021 16:20:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] net: pcs: xpcs: enable skip xPCS soft reset
Message-ID: <YRPcyHTc2FJeEoqk@lunn.ch>
References: <20210809102229.933748-1-vee.khee.wong@linux.intel.com>
 <20210809102229.933748-2-vee.khee.wong@linux.intel.com>
 <YREvDRkiuScyN8Ws@lunn.ch>
 <20210810235529.GB30818@linux.intel.com>
 <f2a1f135-b77a-403d-5d2e-c497efc99df7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2a1f135-b77a-403d-5d2e-c497efc99df7@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > BIOS does configured the SerDes. The problem here is that all the
> > configurations done by BIOS are being reset at xpcs_create().
> > 
> > We would want user of the pcs-xpcs module (stmmac, sja1105) to have
> > control whether or not we need to perform to the soft reset in the
> > xpcs_create() call.
> 
> I understood Andrew's response as suggesting to introduce the ability for
> xpcs_create() to make a BIOS call which would configure the SerDes after
> xpcs_soft_reset().

Yes. Exactly. That is what ACPI is for, so we should use it for this.

     Andrew
