Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A353B1AB6
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 15:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhFWNH5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 09:07:57 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:42954 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbhFWNHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 09:07:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1624453532; x=1655989532;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6ngQ1L8CvZrw2+GK1uugRRh4hu9W22hWObLewNrxIaM=;
  b=QvqHL9lx/mKseEyBa6+G31vnMCkg5O6or01+PAPa2odHOaE7XSslv/SE
   NCi3/akhz+Pbtu7wZ627qUmrRcn5foLUGxp/Gg0vhVx3+1aLvKMUudWUT
   Rg5v3tsOFMaQd3o+BR42Iw9/iPL2oQ+DYLLK5ozemLFM330VGU3YXiPsC
   NFHsrp0b6He1T7pY1b0FY24aFx9YApJzuD76l5GgKDAqzn2OKhCJCH3AO
   oHaWe0Ye+gip2OzssQEl9kBQ2lti7nVDTrbOSqP1wr4+sm40yw+STPCLn
   npQaYPTngXk6zIKtmHRqb51Qzdlp+c1jAR/wCaqW2NbkGXR6u+wWkJzYn
   w==;
IronPort-SDR: X4O/Y/IWGPQ2/LS/+RUEM3lDTTnBUBp1MK5HxwzY4+kfmteJJvxqfgNZcwo3kAQ5H3Da2LvhuH
 Zccelp4qDQ0v7eUaHF7Qbw8uppLC74TG5LTv4NZ4FOH5Y2EwvhmjnbAtzJExa5dtoK93oLhz2k
 vVgunE2YP1lbZkb/r8J1cr6uZ8UbVFaZpeBHlf0viFmbn06zJ5FgpfV3y+rqn5GDOI64Aw8v3f
 2f/vQLhSA8fKnabwgXMpi0/thGg5VvBQ0xVhOlUAuMzZboDffsa27x0w1Xe5ffhk94pmSYtk+p
 zZQ=
X-IronPort-AV: E=Sophos;i="5.83,293,1616482800"; 
   d="scan'208";a="126349718"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jun 2021 06:05:31 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 23 Jun 2021 06:05:31 -0700
Received: from [10.205.21.35] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 23 Jun 2021 06:05:26 -0700
Message-ID: <13fc1b7dac31464f8a635336bf41143d7d02b04a.camel@microchip.com>
Subject: Re: [PATCH net-next v4 04/10] net: sparx5: add port module support
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Simon Horman" <simon.horman@netronome.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Date:   Wed, 23 Jun 2021 15:05:25 +0200
In-Reply-To: <20210621143334.GN22278@shell.armlinux.org.uk>
References: <20210615085034.1262457-1-steen.hegelund@microchip.com>
         <20210615085034.1262457-5-steen.hegelund@microchip.com>
         <20210621143334.GN22278@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Russell,

Thanks for your comment.


On Mon, 2021-06-21 at 15:33 +0100, Russell King (Oracle) wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Hi,
> 
> On Tue, Jun 15, 2021 at 10:50:28AM +0200, Steen Hegelund wrote:
> > +static int sparx5_port_pcs_low_set(struct sparx5 *sparx5,
> > +                                struct sparx5_port *port,
> > +                                struct sparx5_port_config *conf)
> > +{
> > +     bool sgmii = false, inband_aneg = false;
> > +     int err;
> > +
> > +     if (!port->conf.has_sfp) {
> > +             sgmii = true; /* Phy is connnected to the MAC */
> > +     } else {
> > +             if (conf->portmode == PHY_INTERFACE_MODE_SGMII ||
> > +                 conf->portmode == PHY_INTERFACE_MODE_QSGMII)
> > +                     inband_aneg = true; /* Cisco-SGMII in-band-aneg */
> > +             else if (conf->portmode == PHY_INTERFACE_MODE_1000BASEX &&
> > +                      conf->autoneg)
> > +                     inband_aneg = true; /* Clause-37 in-band-aneg */
> 
> I have to wonder why the presence of inband aneg depends on whether
> there's a SFP or not... We don't do that kind of thing in other
> drivers, so what is different here?

Hmm.
I have changed the implementation to use phylink_autoneg_inband() instead of a preconfigured value.


> 
> Thanks.
> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

-- 
BR
Steen

-=-=-=-=-=-=-=-=-=-=-=-=-=-=
steen.hegelund@microchip.com



