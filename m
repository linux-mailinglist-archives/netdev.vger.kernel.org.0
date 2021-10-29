Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F68143F51E
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 05:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbhJ2DCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 23:02:32 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:58081 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbhJ2DCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 23:02:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635476403; x=1667012403;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pOvyD5ApA1t7pbEAwfbWK5m/uaNPWxsDErnCMa5mOLg=;
  b=jsCaIlP115DtW919EAoymFyOnD+ImYrlfaov175vmXZ/Wz5liQtl6/Pi
   oklY0s9Lq3VTIwhKzNiccLbFJLyX2MaiOP4l9NlN+ItrXYsaCDrxoZqib
   bV53rDCrauQH6Fkltt0uazu+UZnyU6YLJqXjOqqKTIfIWJGE/wnfDjOjV
   /Pc9yPlD0LOSYVFMoT1rxW1439X9I3OqwA+DZxni0xxoHsjASOhSDS1ud
   /DAmraKMDcfa1pDOWOA22nwiB/d7b+MaqpiPop0S3bQNk5CIjU6bdQOCj
   Yp6qBg64dDHD8dNRn7zJhR59jPkehsFa/9lmjsAH4doyWErlfsw0NOkk1
   w==;
IronPort-SDR: qzlQmKSc7gPYjbQUP1dA620HI13VXsra79GvhrQnL9DYQRFxW0+tT3JtzJpRq5MTwKYSzEwLr6
 09hP1ZB5VKXcINioMuEHmh5/1Eo2FKdbL4bpYxRRL1ereeigBa2f0OUIDLl1C/dT0EyPqiI0TT
 HJeCaDx3A4rdo/R9Rdm8cck6PZChMxmIBqNrH3WY0TfhDQOqF+iB+39PCbH3KFPwlaocFZMGN9
 BYnMIUAXsBM7MfPucKwHrieHYtS/tvwUzMRnJ8HJ232Bw0QG1ExaSW5jMiIIkzUjSsfuRFNcIY
 07cW/eXUyDfWZ0xm4Jovv9XP
X-IronPort-AV: E=Sophos;i="5.87,191,1631602800"; 
   d="scan'208";a="149979124"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Oct 2021 20:00:02 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 28 Oct 2021 20:00:02 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 28 Oct 2021 19:59:51 -0700
Message-ID: <b3c069c8bc9b2f68d4705c04fb010cb4aaa0b29b.camel@microchip.com>
Subject: Re: [PATCH v5 net-next 06/10] net: dsa: microchip: add support for
 phylink management
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>, <UNGLinuxDriver@microchip.com>,
        <Woojung.Huh@microchip.com>, <hkallweit1@gmail.com>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Date:   Fri, 29 Oct 2021 08:29:49 +0530
In-Reply-To: <YXrYYL7+NRgUtvN3@shell.armlinux.org.uk>
References: <20211028164111.521039-1-prasanna.vengateshan@microchip.com>
         <20211028164111.521039-7-prasanna.vengateshan@microchip.com>
         <YXrYYL7+NRgUtvN3@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-10-28 at 18:05 +0100, Russell King (Oracle) wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> content is safe
> 
> On Thu, Oct 28, 2021 at 10:11:07PM +0530, Prasanna Vengateshan wrote:
> > Support for phylink_validate() and reused KSZ commmon API for
> > phylink_mac_link_down() operation
> > 
> > lan937x_phylink_mac_config configures the interface using
> > lan937x_mac_config and lan937x_phylink_mac_link_up configures
> > the speed/duplex/flow control.
> > 
> > Currently SGMII & in-band neg are not supported & it will be
> > added later.
> > 
> > Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> 
> Hi,
> 
> I've just sent "net: dsa: populate supported_interfaces member"
> which adds a hook to allow DSA to populate the newly introduced
> supported_interfaces member of phylink_config. Once this patch is
> merged, it would be great to see any new drivers setting this
> member.
> 
> Essentially, the phylink_get_interfaces method is called with the
> DSA switch and port number, and a pointer to the supported_interfaces
> member - which is a bitmap of PHY_INTERFACE_MODEs that are supported
> by this port.
> 
> When you have set any bit in the supported interfaces, phylink's
> behaviour when calling your lan937x_phylink_validate changes - it will
> no longer call it with PHY_INTERFACE_MODE_NA, but will instead do a
> bitwalk over the bitmap, and call it for each supported interface type
> instead.
> 
> When phylink has a specific interface mode, it will continue to make a
> single call - but only if the interface mode is indicated as supported
> in the supported interfaces bitmap.
> 
> Please keep an eye on "net: dsa: populate supported_interfaces member"
> and if you need to respin this series after that patch has been merged,
> please update in regards of this.

Sure, i will watch out for this series and add to my new driver. Do the 
new drivers need to still return all supported modes if state->interface
is set to %PHY_INTERFACE_MODE_NA as per phylink documentation? I 
understand that supported_interfaces will not be empty if
phylink_get_interfaces() is handled. But i just wanted to double check
with you.



