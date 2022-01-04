Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F184842B5
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 14:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233675AbiADNoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 08:44:13 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:4767 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiADNoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 08:44:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1641303853; x=1672839853;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/XyRR2E6g5YR1q0FJ04Zxvyy6yiS1fDuIqUgg+RCblE=;
  b=hL7isyo2wCnqZoZ7964n9SECLVULXa/7Ocv+S6t7PScIRR3all2e0QOe
   veufGVU7nOm37HuKBnCCQQevVJ+uPIkkI6Z2yFeJjVwU4qKeAxry6jZm8
   uqKSmAk9sAXBCm0TMPKCbG9DL6TKCy4kYcVPcmyU3IRoLmi4DMazhLpb3
   KCOR5HjCUbFR5txbX0paVZ+6f+jyvnYV+zgNcIhurXJ+PWqGNoPptj9wX
   eNsZt+HHa7R7d2Gd62gtdepaSChGBLhblxCpNIUvWPV6GzQBXAHKjHkrH
   tRa4M1EnuAuBDlevAfHP+Puap/DfrJfyXFhnGhoezGQie4+Bqfze8Ptfl
   g==;
IronPort-SDR: PDtgc7tL6lMUcRxjBNJoI9VK/vCYXXosYq45IyQCZzTf6IDu/hD/iCdrvkvqqLWhLaUq964Yz/
 5OyBLDGDm4wwCKxUovZGVixew6UKgePG1fp4u6hWLqnPyqKbfrfMwp63q+CY5gGhHhORw4GZ8Y
 JKkAYZcqPOZAC9SKZAIlFTmTUZtMmNsMlUBAw7YvQ95iv2+VHjIiBNlZreJaM3eeP+W9oPEeGP
 IZpRjvtd+vDMvxeyE+ZoOvfWVLAW87V6pbYOfpRC3jXYIgDFTDmh8cUngYEnZDeMzmeJzah3lI
 CIkSBUo83bReITT696iIQQnA
X-IronPort-AV: E=Sophos;i="5.88,261,1635231600"; 
   d="scan'208";a="144276767"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jan 2022 06:44:13 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 4 Jan 2022 06:44:12 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 4 Jan 2022 06:44:12 -0700
Date:   Tue, 4 Jan 2022 14:46:26 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v2 2/3] net: lan966x: Add PGID_FIRST and
 PGID_LAST
Message-ID: <20220104134626.nrerh23jgni2dhnn@soft-dev3-1.localhost>
References: <20220104101849.229195-1-horatiu.vultur@microchip.com>
 <20220104101849.229195-3-horatiu.vultur@microchip.com>
 <20220104112120.6tfdrzikkn6nbhkn@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20220104112120.6tfdrzikkn6nbhkn@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 01/04/2022 11:21, Vladimir Oltean wrote:
> 
> On Tue, Jan 04, 2022 at 11:18:48AM +0100, Horatiu Vultur wrote:
> > The first entries in the PGID table are used by the front ports while
> > the last entries are used for different purposes like flooding mask,
> > copy to CPU, etc. So add these macros to define which entries can be
> > used for general purpose.
> >
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> > ---
> 
> Not too thrilled by the "first" and "last" names, since there are PGIDs
> before the "first" PGID, and after the "last" PGID, too. I can see how
> others may get confused about this. In the ocelot driver they are called
> "nonreserved" PGIDs. It also doesn't help that PGID_FIRST and PGID_LAST
> are defined under the "Reserved PGIDs" comment, because they aren't reserved.

OK, I will try to find a better name fore these.

> 
> >  drivers/net/ethernet/microchip/lan966x/lan966x_main.h | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > index f70e54526f53..190d62ced3fd 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
> > @@ -30,7 +30,11 @@
> >  /* Reserved amount for (SRC, PRIO) at index 8*SRC + PRIO */
> >  #define QSYS_Q_RSRV                  95
> >
> > +#define CPU_PORT                     8
> > +
> >  /* Reserved PGIDs */
> > +#define PGID_FIRST                   (CPU_PORT + 1)
> > +#define PGID_LAST                    PGID_CPU
> 
> Since PGID_LAST is defined in terms of PGID_CPU, I would put it _below_
> PGID_CPU.
> 
> >  #define PGID_CPU                     (PGID_AGGR - 6)
> >  #define PGID_UC                              (PGID_AGGR - 5)
> >  #define PGID_BC                              (PGID_AGGR - 4)
> > @@ -44,8 +48,6 @@
> >  #define LAN966X_SPEED_100            2
> >  #define LAN966X_SPEED_10             3
> >
> > -#define CPU_PORT                     8
> > -
> >  /* MAC table entry types.
> >   * ENTRYTYPE_NORMAL is subject to aging.
> >   * ENTRYTYPE_LOCKED is not subject to aging.
> > --
> > 2.33.0
> >

-- 
/Horatiu
