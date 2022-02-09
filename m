Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9114AF082
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:01:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbiBIMBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:01:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbiBIMA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:00:56 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9D5E02E3D8;
        Wed,  9 Feb 2022 03:01:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1644404476; x=1675940476;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZcUnnB4GIETEqYMW/unYziD4D7wpQejz5U5oSfHd+qo=;
  b=GYYg/vloz2SCFfXbg6V2WObK/HYJfP01iFC6O1VFSMXWk/sG1sA1gPyS
   ZaqOc2rIF3CIJqCOOu5chiDQDawYfIw/WKItkv6eRerJwzBrbNGSk25Kg
   jhAO8FkEZCtV1KgPpTx8TwUg+JXQ+2x/Fx1lEcQNTEtKXUd+ZekDiESyz
   yLoGefYzo/hi+MF33a2NhN9U1Q3dDo1cIXn2l2W3Jh/2ujTirgHhRkJjI
   xAKbObarpybHhWAvdqrM8W/MBiRQcWiqYtTZ5mw9gDiyBpw8URj/6yg1o
   igFxhuP8gMSEPMgxvW3FAw8Z5j+hubFvDMECw1U+v9uOrDZa4M6XQE7EH
   w==;
IronPort-SDR: FiqHhkLKKPcfwRg+8cqczYtpORQzacBdXoIfZYZTcEfJtG1I2WhNaS/wTDXnBHOax55/B/38cH
 Ct4cgovs9A7CoHsHmWxbzZDRfchs/3jgKdWW7h8YG3M1LLK6XFVPWvWmMvEkS+sv3P4cg5y55t
 dK15Dw7phnAiOViAoxpbrvVBxRhrX+vpOdcOklqBy/rtS2Ccfei9j7cGq7BwOM+zjZdHjKP59U
 5kZa93jar7v2ONbt8gjAIFh2CcVnJ9qplwPBxbhY63lZY+vfgtQAo2lxh3aZtvjAcAIAl2Nw3w
 p/qK6Ua/LMCtNZgL+LOVn2qr
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="145381331"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Feb 2022 04:01:15 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 9 Feb 2022 04:01:15 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Wed, 9 Feb 2022 04:01:09 -0700
Message-ID: <2e0a7e5d3415e7db093f416a4357c603098b9c39.camel@microchip.com>
Subject: Re: [PATCH v8 net-next 06/10] net: dsa: microchip: add support for
 phylink management
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <woojung.huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Date:   Wed, 9 Feb 2022 16:31:08 +0530
In-Reply-To: <20220207172713.efts4o7b7xor37uu@skbuf>
References: <20220207172204.589190-1-prasanna.vengateshan@microchip.com>
         <20220207172204.589190-7-prasanna.vengateshan@microchip.com>
         <20220207172713.efts4o7b7xor37uu@skbuf>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-02-07 at 19:27 +0200, Vladimir Oltean wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the
> content is safe
> 
> On Mon, Feb 07, 2022 at 10:52:00PM +0530, Prasanna Vengateshan wrote:
> > ased on interface later */
> > +     data8 &= ~PORT_MII_SEL_M;
> > +
> > +     /* configure MAC based on interface */
> > +     switch (interface) {
> > +     case PHY_INTERFACE_MODE_MII:
> > +             lan937x_config_gbit(dev, false, &data8);
> > +             data8 |= PORT_MII_SEL;
> > +             break;
> > +     case PHY_INTERFACE_MODE_RMII:
> > +             lan937x_config_gbit(dev, false, &data8);
> > +             data8 |= PORT_RMII_SEL;
> > +             break;
> > +     case PHY_INTERFACE_MODE_RGMII:
> > +             lan937x_config_gbit(dev, true, &data8);
> > +             data8 |= PORT_RGMII_SEL;
> > +             break;
> > +     case PHY_INTERFACE_MODE_RGMII_ID:
> > +     case PHY_INTERFACE_MODE_RGMII_TXID:
> > +     case PHY_INTERFACE_MODE_RGMII_RXID:
> > +             lan937x_config_gbit(dev, true, &data8);
> > +             data8 |= PORT_RGMII_SEL;
> > +
> > +             /* Apply rgmii internal delay for the mac */
> > +             lan937x_apply_rgmii_delay(dev, port, interface, data8);
> 
> I think the agreement from previous discussions was to apply RGMII delay
> _exclusively_ based on the 'rx-internal-delay-ps' and 'tx-internal-delay-ps'
> properties, at least for new drivers with no legacy. You are omitting to
> apply delays in phy-mode = "rgmii", which contradicts that agreement.
> I think you should treat all 4 RGMII cases the same, and remove the
> interface checks from lan937x_apply_rgmii_delay.

Thanks for the feedback. Yes, you are right. Regardless of the phy-mode, mac
should apply its delay from the device tree. I will change both of the places in
the next revision.

Prasanna V
> 

