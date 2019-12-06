Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42E44115499
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 16:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726313AbfLFPua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 10:50:30 -0500
Received: from muru.com ([72.249.23.125]:44222 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726251AbfLFPua (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Dec 2019 10:50:30 -0500
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 05DB48047;
        Fri,  6 Dec 2019 15:51:07 +0000 (UTC)
Date:   Fri, 6 Dec 2019 07:50:26 -0800
From:   Tony Lindgren <tony@atomide.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/2] arm: omap2plus_defconfig: enable NET_SWITCHDEV
Message-ID: <20191206155026.GE35479@atomide.com>
References: <20191204174533.32207-1-grygorii.strashko@ti.com>
 <20191204174533.32207-3-grygorii.strashko@ti.com>
 <c8058866-2be9-831c-19f6-31d17decb6f1@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8058866-2be9-831c-19f6-31d17decb6f1@ti.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Grygorii Strashko <grygorii.strashko@ti.com> [191206 11:08]:
> Hi Tony,
> 
> On 04/12/2019 19:45, Grygorii Strashko wrote:
> > The TI_CPSW_SWITCHDEV definition in Kconfig was changed from "select
> > NET_SWITCHDEV" to "depends on NET_SWITCHDEV", and therefore it is required
> > to explicitelly enable NET_SWITCHDEV config option in omap2plus_defconfig.
> > 
> > Fixes: 3727d259ddaf ("arm: omap2plus_defconfig: enable new cpsw switchdev driver")
> > Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> > ---
> >   arch/arm/configs/omap2plus_defconfig | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm/configs/omap2plus_defconfig b/arch/arm/configs/omap2plus_defconfig
> > index 89cce8d4bc6b..7bbef86a4e76 100644
> > --- a/arch/arm/configs/omap2plus_defconfig
> > +++ b/arch/arm/configs/omap2plus_defconfig
> > @@ -92,6 +92,7 @@ CONFIG_IP_PNP_BOOTP=y
> >   CONFIG_IP_PNP_RARP=y
> >   CONFIG_NETFILTER=y
> >   CONFIG_PHONET=m
> > +CONFIG_NET_SWITCHDEV=y
> >   CONFIG_CAN=m
> >   CONFIG_CAN_C_CAN=m
> >   CONFIG_CAN_C_CAN_PLATFORM=m
> > @@ -182,6 +183,7 @@ CONFIG_SMSC911X=y
> >   # CONFIG_NET_VENDOR_STMICRO is not set
> >   CONFIG_TI_DAVINCI_EMAC=y
> >   CONFIG_TI_CPSW=y
> > +CONFIG_TI_CPSW_SWITCHDEV=y
> >   CONFIG_TI_CPTS=y
> >   # CONFIG_NET_VENDOR_VIA is not set
> >   # CONFIG_NET_VENDOR_WIZNET is not set
> > @@ -554,4 +556,3 @@ CONFIG_DEBUG_INFO_DWARF4=y
> >   CONFIG_MAGIC_SYSRQ=y
> >   CONFIG_SCHEDSTATS=y
> >   # CONFIG_DEBUG_BUGVERBOSE is not set
> > -CONFIG_TI_CPSW_SWITCHDEV=y
> > 
> 
> Could it be applied as fix, as without it cpsw switch driver will not be built,
> so no networking on am571x-idk

OK I'll be applying it into fixes.

Thanks,

Tony
