Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5972C863E
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:15:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgK3OLp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:11:45 -0500
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:47747 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgK3OLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 09:11:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606745504; x=1638281504;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=FH77bFtA5a2R6TWdcgtc3PXyniZXLChHMOGTf9xtf+M=;
  b=S8XO5XHGINIxZalY9lp919+JcOI2hn7sI8OTWk3A37rnNkf4k2vEvBGD
   EFPZJ8ZgoGGvkfesjyeMLHasDqCjZ7BwV2gXjtsUn9CZL4vSbputdwTBI
   XECXDFb+/bj9R0cchZfcm1bqqhEGbJSTGvIt6UE7CMYzxlxWRRqIYHnBl
   pbdC1tHA24PbpzEyW6SwPobb+4LHAfXAEVAi3ueJYhNsz5dZAi71ZCgd4
   Ei566ZzFpS3OznU2Fv8HXO0fIPcvPgG1AYrU94/cNhQVWqVq3nc0v6Mjk
   3Fo/FcObZc5j+6/pM4R8jM+AY+dYbh68qMFe8OuWu3exb19gOWBhU4xwv
   w==;
IronPort-SDR: Zf+E3IVKfhQ0AHu3Q89dRf/zaEVuLq/vkxn2XJAKcSArTIl25dBHSnlZh3g1uqm5czbw12XG29
 ZHV1t5qOy3Tia+7kccj4JCMVJCre6lVIPOeQuXqLvPp50z+YzXgLZon+XOojXrJV/i0qpbIOBC
 wB+/vm59yjYKxCwr5M40/HLfwA++DrSBdnmm6gdVA3j8bgiz78dV4FApgQpICfLFsVHOLwtzUx
 vMJRhHhoR+7P3LrRrn0bHqsT8J8BhF8ODRJL4Kj3DOn3cfgjCoE/HgSKHQY5Qkaq9wyIow+hl1
 GM0=
X-IronPort-AV: E=Sophos;i="5.78,381,1599548400"; 
   d="scan'208";a="97983422"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2020 07:10:38 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 07:10:37 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 30 Nov 2020 07:10:37 -0700
Date:   Mon, 30 Nov 2020 15:10:36 +0100
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 2/3] net: sparx5: Add Sparx5 switchdev driver
Message-ID: <20201130141036.il7u2ux4x57qgqiz@mchp-dev-shegelun>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-3-steen.hegelund@microchip.com>
 <20201128190616.GF2191767@lunn.ch>
 <20201128222828.GQ1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20201128222828.GQ1551@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.11.2020 22:28, Russell King - ARM Linux admin wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>On Sat, Nov 28, 2020 at 08:06:16PM +0100, Andrew Lunn wrote:
>> > +static void sparx5_phylink_mac_config(struct phylink_config *config,
>> > +                                 unsigned int mode,
>> > +                                 const struct phylink_link_state *state)
>> > +{
>> > +   struct sparx5_port *port = netdev_priv(to_net_dev(config->dev));
>> > +   struct sparx5_port_config conf;
>> > +   int err = 0;
>> > +
>> > +   conf = port->conf;
>> > +   conf.autoneg = state->an_enabled;
>> > +   conf.pause = state->pause;
>> > +   conf.duplex = state->duplex;
>> > +   conf.power_down = false;
>> > +   conf.portmode = state->interface;
>> > +
>> > +   if (state->speed == SPEED_UNKNOWN) {
>> > +           /* When a SFP is plugged in we use capabilities to
>> > +            * default to the highest supported speed
>> > +            */
>>
>> This looks suspicious.
>
>Yes, it looks highly suspicious. The fact that
>sparx5_phylink_mac_link_up() is empty, and sparx5_phylink_mac_config()
>does all the work suggests that this was developed before the phylink
>re-organisation, and this code hasn't been updated for it.

Hi Russell,

The work started on 5.4 and I think I may have not really
understood the finer details in the changes in 5.9.
>
>Any new code for the kernel really ought to be updated for the new
>phylink methodology before it is accepted.
>

Could you point me to a good example of the new methodology?

>Looking at sparx5_port_config(), it also seems to use
>PHY_INTERFACE_MODE_1000BASEX for both 1000BASE-X and 2500BASE-X. All
>very well for the driver to do that internally, but it's confusing
>when it comes to reviewing this stuff, especially when people outside
>of the driver (such as myself) reviewing it need to understand what's
>going on with the configuration.

Hmmm. I better check if this is as intended.

>
>--
>RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
>FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

Thanks for your comments.

BR
Steen

---------------------------------------
Steen Hegelund
steen.hegelund@microchip.com
