Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 219AF42715
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 15:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439349AbfFLNK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 09:10:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48586 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439328AbfFLNK5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jun 2019 09:10:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Zzc6GI7lGEPaQXGvlamBcEyrm5Fho0Vz0zqRdDP5hq0=; b=QQ0PwDAeuICS/1pKrFIl9qqFCV
        DVvk65aiWdgNZKve6NvZEweANaJXywqmPwYKrmAVNEvtvFwEVTj7E+J2FualB+Tb+98QSaZKGqZgO
        pc0lw2PM0jUsWWW9P6hUqGY37Dc4KXe0Ps3dd4cQbhHZq5gx9+yKnAXHrTjlMkvVm/1o=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hb31d-0004Fu-AP; Wed, 12 Jun 2019 15:10:49 +0200
Date:   Wed, 12 Jun 2019 15:10:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/6] ptp: add QorIQ PTP support for DPAA2
Message-ID: <20190612131049.GC23615@lunn.ch>
References: <20190610032108.5791-1-yangbo.lu@nxp.com>
 <20190610032108.5791-2-yangbo.lu@nxp.com>
 <20190610130601.GD8247@lunn.ch>
 <VI1PR0401MB2237247525AB5DB5B5F275A8F8EC0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0401MB2237247525AB5DB5B5F275A8F8EC0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig index
> > > 9b8fee5..b1b454f 100644
> > > --- a/drivers/ptp/Kconfig
> > > +++ b/drivers/ptp/Kconfig
> > > @@ -44,7 +44,7 @@ config PTP_1588_CLOCK_DTE
> > >
> > >  config PTP_1588_CLOCK_QORIQ
> > >  	tristate "Freescale QorIQ 1588 timer as PTP clock"
> > > -	depends on GIANFAR || FSL_DPAA_ETH || FSL_ENETC || FSL_ENETC_VF
> > > +	depends on GIANFAR || FSL_DPAA_ETH || FSL_DPAA2_ETH ||
> > FSL_ENETC ||
> > > +FSL_ENETC_VF
> > >  	depends on PTP_1588_CLOCK
> > 
> > Hi Yangbo
> > 
> > Could COMPILE_TEST also be added?
> 
> [Y.b. Lu] COMPILE_TEST is usually for other ARCHs build coverage.
> Do you want me to append it after these Ethernet driver dependencies?

Hii Y.b. Lu

Normally, drivers like this should be able to compile independent of
the MAC driver. So you should be able to add COMPILE_TEST here.

    Andrew
