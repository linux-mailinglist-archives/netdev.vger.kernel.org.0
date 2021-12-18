Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362E4479ADC
	for <lists+netdev@lfdr.de>; Sat, 18 Dec 2021 13:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233209AbhLRM6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Dec 2021 07:58:39 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:17148 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbhLRM6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Dec 2021 07:58:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1639832319; x=1671368319;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=k8rUJHLOFqptEjRq5e0B1yL89lUJ1IVO33IrB6HwBuA=;
  b=1pF+DFt2VFOTt38XQkCVmuSFXzZQ0ckiB4J/EZcNtRFJki2gGoHX3X4x
   DUx6Mczyo+5g5UN0eeif/ZIM98mwoK+w4j+aOx7ZeVACvwAJzCY/JaSRR
   77Me9VdJx2QdNLiCSz1rSOHs/GYFjzEZDMNQSJ+HOozk1gAgq85BbfjJx
   d7zcRmC+wFPFAj8Pm+Dx1p8nyTw21zGjFgx3ZmMd0gi4VW3KTMaGPh0UH
   zLQfvUI5i8c6uFsQ1PnQBi+cve6FzTI5Bif+k2X4CGHRpcbIKxZKMrYdC
   +T3I1bL/Yb03Drih2hf+1dbNHzePf+WzbSD3FFZYC4Yv2w6/BBVujUKFg
   g==;
IronPort-SDR: rbLK/0/d2KyIkGCghYDqok6XLDgi72O6r6f/ixWK9g4Uzn4ZPsLHEpvQKO6tbJ95LG1vj0JNEI
 lZIvFRL2cB5G+EkLwP+2jTE4ZFYW7jux73eCHwCE5Ulo7kHaKKdabREXTcQElwoNdeCcUKRzXU
 zXAwG5rVTEAzMaua5Fqd9jbIwsCKz5WhIj+ffj0Af/P+TXCSXF/colyXatBTOpsOKFknY/nCOT
 Adr4sj4BTiHUvM0ohw4nftgXn9jy3XtzRFWNuznPQfp6EdMNsYQdC1PAVRdAOr/uEnFQOy0FxR
 u7xxThMCqshzod5eXiHqERbb
X-IronPort-AV: E=Sophos;i="5.88,216,1635231600"; 
   d="scan'208";a="147682204"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Dec 2021 05:58:38 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 18 Dec 2021 05:58:37 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Sat, 18 Dec 2021 05:58:37 -0700
Date:   Sat, 18 Dec 2021 14:00:42 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net-next v7 7/9] net: lan966x: Add vlan support.
Message-ID: <20211218130042.77ebu7otpqfpqq7x@soft-dev3-1.localhost>
References: <20211217155353.460594-1-horatiu.vultur@microchip.com>
 <20211217155353.460594-8-horatiu.vultur@microchip.com>
 <20211217181434.mfnur3nucfiykgto@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20211217181434.mfnur3nucfiykgto@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/17/2021 18:14, Vladimir Oltean wrote:
> 
> On Fri, Dec 17, 2021 at 04:53:51PM +0100, Horatiu Vultur wrote:
> > @@ -120,7 +124,12 @@ static void lan966x_port_bridge_leave(struct lan966x_port *port,
> >       if (!lan966x->bridge_mask)
> >               lan966x->bridge = NULL;
> >
> > -     lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, PORT_PVID);
> > +     /* Set the port back to host mode */
> > +     lan966x_vlan_port_set_vlan_aware(port, false);
> > +     lan966x_vlan_port_set_vid(port, HOST_PVID, false, false);
> > +     lan966x_vlan_port_apply(port);
> > +
> > +     lan966x_mac_cpu_learn(lan966x, port->dev->dev_addr, HOST_PVID);
> 
> Do you still need to re-learn the port MAC address?

It is not needed. I will remove this in the next version.

> 
> >  }

-- 
/Horatiu
