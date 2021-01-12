Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B67582F343D
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 16:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403796AbhALPfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 10:35:38 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:2780 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391542AbhALPfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 10:35:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610465739; x=1642001739;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QyGWuPqLtbiZ4Sx64HpU/v/Ruq4xAC5p6ggIJuivk+s=;
  b=lIacRtONk1BGSZmweluysCTNaERdz4/bL3lB4kUtykaOBHEvHBLgxUBx
   fhAU7pk4eWVCJNmq/E7IOIEFkosHDky0PVnBCYeGs7abb9Sg0DORJVuOJ
   MN2wHIP5eJJ92522iQMCxlaskccAmfqWTVCWmuHtZNCq4etyjUPHZDj4V
   FEqoUlGUUTq2kTwqliaIR0nVxOugUCxloyncIRt0yFI//hYcAGqdi1BM4
   Ao0k0kZf6KM9577M+HVwyjO8umwe4buhukl9p4ck+QumZKS7DDiJH2fRE
   dwq6GLBXDNe1FVZVEsWtnv25B4hgaHOlzZYRbUvoH0ol3B28zywTJ5yha
   Q==;
IronPort-SDR: 110ZQelFImbkW/oUe53p+ndZm1cnNMb1cJvC9OfeOqQ/nFtCsuZc0WfvVgyZebrypJhzfbPEkc
 i/5q+0aWKDS041JK5M2Aqg9zMlYIbrYyl51OH5vEsG/g7wa8asRiVEwllmjJ5lklSB0pYFf7Hi
 E7I92vxCrQ+ImyAMKmqHQrN4XxGo9BNXJxYRB3scTONZ1Viyqmo5Y0CAFWMStDmjodqVysSnUX
 xqlDJL4E8UQD1mg5MPW2nmEr2thJgsSoG2bu9XmF8ySL0lsU+km1jtlSkveLpja5mkh2C+ls5G
 mrY=
X-IronPort-AV: E=Sophos;i="5.79,341,1602572400"; 
   d="scan'208";a="105149176"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Jan 2021 08:34:23 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 12 Jan 2021 08:34:22 -0700
Received: from soft-dev2 (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 12 Jan 2021 08:34:20 -0700
Message-ID: <4080678764ff0abfb7491e9b34fc4f46bf3262a8.camel@microchip.com>
Subject: Re: [PATCH v1 1/2] net: phy: Add 100 base-x mode
From:   Bjarni Jonasson <bjarni.jonasson@microchip.com>
To:     =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirqus@gmail.com>
CC:     Russell King <linux@armlinux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Linux Kernel" <linux-kernel@vger.kernel.org>,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Date:   Tue, 12 Jan 2021 16:34:19 +0100
In-Reply-To: <CAHXqBFJSgebLn9GxgdYGdVR6_+i76uX5YyjHw5niOet9BuYj6A@mail.gmail.com>
References: <20210111130657.10703-1-bjarni.jonasson@microchip.com>
         <20210111130657.10703-2-bjarni.jonasson@microchip.com>
         <CAHXqBFJSgebLn9GxgdYGdVR6_+i76uX5YyjHw5niOet9BuYj6A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-01-11 at 20:37 +0100, Michał Mirosław wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you
> know the content is safe
> 
> pon., 11 sty 2021 o 14:54 Bjarni Jonasson
> <bjarni.jonasson@microchip.com> napisał(a):
> > Sparx-5 supports this mode and it is missing in the PHY core.
> > 
> > Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
> > ---
> >  include/linux/phy.h | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/include/linux/phy.h b/include/linux/phy.h
> > index 56563e5e0dc7..dce867222d58 100644
> > --- a/include/linux/phy.h
> > +++ b/include/linux/phy.h
> > @@ -111,6 +111,7 @@ extern const int phy_10gbit_features_array[1];
> >   * @PHY_INTERFACE_MODE_10GBASER: 10G BaseR
> >   * @PHY_INTERFACE_MODE_USXGMII:  Universal Serial 10GE MII
> >   * @PHY_INTERFACE_MODE_10GKR: 10GBASE-KR - with Clause 73 AN
> > + * @PHY_INTERFACE_MODE_100BASEX: 100 BaseX
> >   * @PHY_INTERFACE_MODE_MAX: Book keeping
> 
> [...]
> 
> This is kernel-internal interface, so maybe the new mode can be
> inserted before 1000baseX for easier lookup?
> 
> Best Regards
> Michał Mirosław

Yes, will do that.
--
Bjarni Jonasson
Microchip


