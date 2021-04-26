Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF49236AB5C
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 06:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbhDZEHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 00:07:38 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:16745 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhDZEHh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 00:07:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1619410016; x=1650946016;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yuoVX17p+FXB6MoHSoNBWTLSH/BOJ6lr2GX3BOd1FX4=;
  b=WyNahNnmQRthOG4rJEO9b3BmfVFnJf+EB+uWy+1DA5iN/Q7UWl4FKIGO
   ZzoK6vkdkeODOhW/HrlQ2P3ylp8JMp126yGEZ+bMQhZmgkRSwpwNqDO8n
   4OSTOLwUUlERSi7uFEPFntU09KVZggIzXI/7kDjsMuEnv22RlD+bf7xru
   9k9Jz9SvxkoIYuvwTR8rfScjOd+G+5oGJiALuX0O9phuGgdTaAXu8PgCf
   1eYZvSNPG+IcMggdAUnb2AQ7mM0ts+nkOIbGv92qUIeBoQU6x6H47kQzo
   RfeuA2MntCzxLk+hPJCx5x1wBYkKrCecXASsk3LUEx9IE/Faey1gzeVaE
   w==;
IronPort-SDR: aVeXbtIGlsb+qBx6OmyegshCWNfYEp8iumAYWYBfcNfbJaHp3HZVcBeuKQRGWH8cGrfjztM8P7
 MY5V3oLiYXJiSwc9KQFlz3OiPErblvBBat5nCxEAZTyqsgpClvACmRl4rlKFTyZvmbB1nQxsw5
 Rvuh95Y0E5HY1MgssDk+8FMrZhj5oWulbEgPZuRImLo9GFB8ZF+DdMAH75Fv6n36X6NFH7gPqJ
 I4NqDOiXqNUJaiJt7/Ipwo/cKhY3nkP8/84mNbOT8/pt2weHcq7QHPxGSt7CYXSH1r1gFbV1Yf
 1nE=
X-IronPort-AV: E=Sophos;i="5.82,251,1613458800"; 
   d="scan'208";a="118330581"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Apr 2021 21:06:56 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sun, 25 Apr 2021 21:06:56 -0700
Received: from INB-LOAN0158.mchp-main.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Sun, 25 Apr 2021 21:06:51 -0700
Message-ID: <33503dd6d95bd1232fba24b38f66301916e62003.camel@microchip.com>
Subject: Re: [PATCH v2 net-next 2/9] net: phy: Add support for LAN937x T1
 phy driver
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>, <UNGLinuxDriver@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Date:   Mon, 26 Apr 2021 09:36:50 +0530
In-Reply-To: <YIFv9Wcp94395Hbb@lunn.ch>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
         <20210422094257.1641396-3-prasanna.vengateshan@microchip.com>
         <YIFv9Wcp94395Hbb@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-04-22 at 14:45 +0200, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> content is safe
> 
> > +#define PORT_T1_PHY_RESET    BIT(15)
> > +#define PORT_T1_PHY_LOOPBACK BIT(14)
> > +#define PORT_T1_SPEED_100MBIT        BIT(13)
> > +#define PORT_T1_POWER_DOWN   BIT(11)
> > +#define PORT_T1_ISOLATE      BIT(10)
> > +#define PORT_T1_FULL_DUPLEX  BIT(8)
> 
> These appear to be standard BMCR_ values. Please don't define your
> own.
> 
> > +
> > +#define REG_PORT_T1_PHY_BASIC_STATUS 0x01
> > +
> > +#define PORT_T1_MII_SUPPRESS_CAPABLE BIT(6)
> > +#define PORT_T1_LINK_STATUS          BIT(2)
> > +#define PORT_T1_EXTENDED_CAPABILITY  BIT(0)
> > +
> > +#define REG_PORT_T1_PHY_ID_HI 0x02
> > +#define REG_PORT_T1_PHY_ID_LO 0x03
> 
> MII_PHYSID1 and MII_PHYSID2
> 
> Please go through all these #defines and replace them with the
> standard ones Linux provides. You are obfusticating the code by not
> using what people already know.
Sure, i will review it for all the definitions.

> 
>       Andrew


