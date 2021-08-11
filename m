Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE92F3E96FD
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 19:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhHKRot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 13:44:49 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:10066 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhHKRos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 13:44:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1628703864; x=1660239864;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qfHVUSB+Z97DSvueqImP5XFwDlXHbgk+KorN5ejls2Y=;
  b=FEvcVdoyuoMwTou8nyvsiSGPFhQpne7Gs3/UigU/pqzzUVjK7kRNM7qv
   gsYgKigq4yxgU6Gntnd5OAPihws6rvcvN7w9mQBTjZVBVndYAkDSDJjeH
   wHG6TwTEe3bFujGvKlZmhmjwTX5sD3UEnWS9lcWG8PRyeqhR5g0Ss4kDh
   eNwwFbYbJJ9DH4tGwvJ7pGoJzCItWPJavWV0SmkOSD1gOCD3ARJ64yjQF
   PTpdVyFEBHyMBQ+anoZbc38AN3ePPzF+Zn4LnhBQMBBXWZmI0dqU7h4NL
   4/k5L3rT3DjepI8xb/QoSiYUumn8LmwqVwkW9aVQS42GLE7M2DXZvHhFq
   Q==;
IronPort-SDR: claGEUQxs+LhdUthaCdYM4eE7xEZ8886peCxPi7H78UdW/mDlBWvPbyzgGELLUmgjNbv0uNbAi
 tfSNnf5eqcHFax5qH+2HpH8SOvHAbuCoSHxIZfF8rPO00cGFVpQ8ABX8JtnpuVyUBHPMGMDGsM
 n96b/cOxjCgqjrnYllYy0nbaXKqWeJ6seytXUOYa7IlsLhRZYsX5o2GllZGTV7HxoZoqpLKGzO
 3W35Er0zQvNcQjnROk4ByFglZCvvyi78riMvk8ioJS1UZ3TdS8nydtcAy7ZRd2iKxdCAcOD7Gb
 PAiu4RdYz6M1aibwv7O/ZYnB
X-IronPort-AV: E=Sophos;i="5.84,313,1620716400"; 
   d="scan'208";a="139704928"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Aug 2021 10:44:23 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 11 Aug 2021 10:44:23 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Wed, 11 Aug 2021 10:44:18 -0700
Message-ID: <20191b895a56e2a29f7fee8063d9cc0900f55bfe.camel@microchip.com>
Subject: Re: [PATCH v3 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
CC:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        <netdev@vger.kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Date:   Wed, 11 Aug 2021 23:14:17 +0530
In-Reply-To: <YQ6pc6EZRLftmRh3@lunn.ch>
References: <20210723173108.459770-6-prasanna.vengateshan@microchip.com>
         <20210731150416.upe5nwkwvwajhwgg@skbuf>
         <49678cce02ac03edc6bbbd1afb5f67606ac3efc2.camel@microchip.com>
         <20210802121550.gqgbipqdvp5x76ii@skbuf> <YQfvXTEbyYFMLH5u@lunn.ch>
         <20210802135911.inpu6khavvwsfjsp@skbuf>
         <50eb24a1e407b651eda7aeeff26d82d3805a6a41.camel@microchip.com>
         <20210803235401.rctfylazg47cjah5@skbuf>
         <20210804095954.GN22278@shell.armlinux.org.uk>
         <20210804104625.d2qw3gr7algzppz5@skbuf> <YQ6pc6EZRLftmRh3@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-08-07 at 17:40 +0200, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> content is safe
> 
> > I am not even clear what is the expected canonical behavior for a MAC
> > driver. It parses rx-internal-delay-ps and tx-internal-delay-ps, and
> > then what?
> 
> So best practices are based around a MAC-PHY link. phy-mode is passed
> to the PHY, and the MAC does not act upon it. MAC rx-internal-delay-ps
> and tx-internal-delay-ps can be used to fine tune the link. You can
> use them to add and sometimes subtract small amounts of delay.
> 
> > It treats all "rgmii*" phy-mode strings identically? Or is it an
> > error to have "rgmii-rxid" for phy-mode and non-zero
> > rx-internal-delay-ps?
> 
> I would say the first is correct, the second statement is false. You
> should always be able to fine tune the link, independent of the PHY
> mode.
> 
> We also have to consider the case when the PHY is not actually able to
> implement the delay. It hopefully returns -EOPNOTSUPP for anything
> other than "rgmii". You can then put the full 2ns delay into
> tx-internal-delay-ps nd rx-internal-delay-ps.

I hope that using "*-internal-delay-ps" for Mac would be the right option.
Shall i include these changes as we discussed in next revision of the patch? 

