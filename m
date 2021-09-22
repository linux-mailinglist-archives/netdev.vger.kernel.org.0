Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 020AA4143DC
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 10:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233957AbhIVIfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 04:35:20 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:53052 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233792AbhIVIfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 04:35:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632299629; x=1663835629;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=dCzHyBdtZa9KsR+jnO9AvFwdTRmtYkVI8WwzcZB33hI=;
  b=HpSoLfMIs0igBDiFhShu9mNUue1Ci/J+0Ltz9USOkvTa92Ou7lg+IylI
   eolnRYT/ikCfOyrn3WjayVHLhuYkdV1NKfDS3oFO3N3CxXIBqIRMhCBea
   wlq1IOU48SbdfCKjPs1Ni47r4Cti0A4nJt1ZNrzV25xbZg23eikrB86Fd
   eG9QZjmj5P3ZQ2NvmGcKoLWROGkN1eLcjDYTVhYdrb9tOXzxBdjG99rZr
   S9MwZmIhDwRl5iyGz5vP2wdyrURyGHxGyvq6qcJZNO0FWf3RSwQfXrtVR
   OVWMx+0C7lEq6Zb+cRIMlhmemgELArVWYDhh0uk/3ncYtdM8PR9Ee1DBb
   Q==;
IronPort-SDR: ft+4fxqI3sc/fV47Wd3qLDueuLFQeLTUDyEA77HOTuoV+1DyUHPSUcCvM1FL6SqzMau6G3Z3B+
 AefKYAfSuCBqd2TDmB46rhCX4IHxRIA2nSaiiKwgJm1Es859O8q8SBdP4xdv8Pob9MaKo2ljNI
 i0tICXQ2NYH6ogEBzZblqb7dwlUMUvRMyEp0MlOhx63EOptyl1NVVCQXy4V+r/4EmSwlBjUrcN
 1sZNxeSlI7tI6X0QqyRY5CLOjisyBeZMOaEzXTWQUuWygVRPW7RZfWRkb96q1RvfAmOZdEq3pK
 CiRfpAk4eUaxEw/MEhr+clW3
X-IronPort-AV: E=Sophos;i="5.85,313,1624345200"; 
   d="scan'208";a="130179187"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Sep 2021 01:33:49 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 22 Sep 2021 01:33:49 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Wed, 22 Sep 2021 01:33:48 -0700
Date:   Wed, 22 Sep 2021 10:35:17 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <linux@armlinux.org.uk>, <f.fainelli@gmail.com>,
        <alexandre.belloni@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-phy@lists.infradead.org>, <linux-pm@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 02/12] net: phy: mchp: Add support for
 LAN8804 PHY
Message-ID: <20210922083517.ms3pdccxevehdxsr@soft-dev3-1.localhost>
References: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
 <20210920095218.1108151-3-horatiu.vultur@microchip.com>
 <YUh3mP9pcG4Elam7@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YUh3mP9pcG4Elam7@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 09/20/2021 13:59, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Mon, Sep 20, 2021 at 11:52:08AM +0200, Horatiu Vultur wrote:
> > The LAN8804 SKY has same features as that of LAN8804 SKY except that it
> > doesn't support 1588, SyncE or Q-USGMII.
> >
> > This PHY is found inside the LAN966X switches.
> 
> Please add the new PHY to the micrel_tbl[].

Will do that. Thanks
> 
>        Andrew
> 

-- 
/Horatiu
