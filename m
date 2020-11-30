Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5732C86F1
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgK3OkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:40:16 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:50457 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgK3OkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 09:40:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606747215; x=1638283215;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=7ETIU12Ts+TxxTcWnjeAV2a9iG5nvtGZmL7ij0piNUY=;
  b=vaWouUASPUqlSuVROtLELAF7luT8A1tdL8YDSFnI02mnPNLtzsAq63IJ
   4FGKAnHmSHWygTArvSMkuS4gVeHZfabHLFnlLxDrERMZHkjT1lx5sL9HD
   bgIUE8dBHua/sY7avrq33j9HpoyE96pKgIeJT8zqu2UreBtVnZ0DTvTj8
   sXcV/GyZKavtTdmaBvHuVnNRSxDqO6ZhfNvP6vQJYZA4kcDbblEB9nOGD
   3pFnZhaxv41855pJ4dpYwWWdRiA5zHew08IrtVzeV39obwUwqNgVwCQG5
   oUFGYPvUN0nTXWYKf/MdK11XbHUvVsxgC8iYk3tQ/AKxxT+kdSD5wfLXF
   A==;
IronPort-SDR: aOwgCviPRzdqXrRN2jjULK/wrNfA0R1DJAZsYYAj1LLHE7spX5Rjpi/MmCJuq8/tzsbpKK4PCZ
 4Dnj7+Kg4UovxwSP7X1v6BT3hWbBuXiAoq0A3Gdd3MQ6S6IdbHSRclzBiP9BrYk1InJkq1hcjj
 gruKaOCJV+W1trMzGyUtfWAPAwwGDIva5fxHWfRN32egO+/5n69ONYXMKH3NVXe+zMaBirvnDv
 8uYWRq7/M7uhEzF0n0yc5/c3WQBOOT8IHm3iuiEHEsv8gczpOLTcHQy73fWLsotdnTqgE+Dv7e
 yHk=
X-IronPort-AV: E=Sophos;i="5.78,381,1599548400"; 
   d="scan'208";a="105480636"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2020 07:39:09 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 07:39:09 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 30 Nov 2020 07:39:08 -0700
Date:   Mon, 30 Nov 2020 15:39:08 +0100
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
Message-ID: <20201130143908.yodoocifsek55bb7@mchp-dev-shegelun>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-3-steen.hegelund@microchip.com>
 <20201128190616.GF2191767@lunn.ch>
 <20201128222828.GQ1551@shell.armlinux.org.uk>
 <20201129105245.GG1605@shell.armlinux.org.uk>
 <20201129112814.GH1605@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20201129112814.GH1605@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.11.2020 11:28, Russell King - ARM Linux admin wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>On Sun, Nov 29, 2020 at 10:52:45AM +0000, Russell King - ARM Linux admin wrote:
>> On Sat, Nov 28, 2020 at 10:28:28PM +0000, Russell King - ARM Linux admin wrote:
>> > On Sat, Nov 28, 2020 at 08:06:16PM +0100, Andrew Lunn wrote:
>> > > > +static void sparx5_phylink_mac_config(struct phylink_config *config,
>> > > > +                                     unsigned int mode,
>> > > > +                                     const struct phylink_link_state *state)
>> > > > +{
>> > > > +       struct sparx5_port *port = netdev_priv(to_net_dev(config->dev));
>> > > > +       struct sparx5_port_config conf;
>> > > > +       int err = 0;
>> > > > +
>> > > > +       conf = port->conf;
>> > > > +       conf.autoneg = state->an_enabled;
>> > > > +       conf.pause = state->pause;
>> > > > +       conf.duplex = state->duplex;
>> > > > +       conf.power_down = false;
>> > > > +       conf.portmode = state->interface;
>> > > > +
>> > > > +       if (state->speed == SPEED_UNKNOWN) {
>> > > > +               /* When a SFP is plugged in we use capabilities to
>> > > > +                * default to the highest supported speed
>> > > > +                */
>> > >
>> > > This looks suspicious.
>> >
>> > Yes, it looks highly suspicious. The fact that
>> > sparx5_phylink_mac_link_up() is empty, and sparx5_phylink_mac_config()
>> > does all the work suggests that this was developed before the phylink
>> > re-organisation, and this code hasn't been updated for it.
>> >
>> > Any new code for the kernel really ought to be updated for the new
>> > phylink methodology before it is accepted.
>> >
>> > Looking at sparx5_port_config(), it also seems to use
>> > PHY_INTERFACE_MODE_1000BASEX for both 1000BASE-X and 2500BASE-X. All
>> > very well for the driver to do that internally, but it's confusing
>> > when it comes to reviewing this stuff, especially when people outside
>> > of the driver (such as myself) reviewing it need to understand what's
>> > going on with the configuration.
>>
>> There are other issues too.
>>
>> Looking at sparx5_get_1000basex_status(), we have:
>>
>>  +       status->link = DEV2G5_PCS1G_LINK_STATUS_LINK_STATUS_GET(value) |
>>  +                      DEV2G5_PCS1G_LINK_STATUS_SYNC_STATUS_GET(value);
>>
>> Why is the link status the logical OR of these?
>>
>>  +                       if ((lp_abil >> 8) & 1) /* symmetric pause */
>>  +                               status->pause = MLO_PAUSE_RX | MLO_PAUSE_TX;
>>  +                       if (lp_abil & (1 << 7)) /* asymmetric pause */
>>  +                               status->pause |= MLO_PAUSE_RX;
>>
>> is actually wrong, and I see I need to improve the documentation for
>> mac_pcs_get_state(). The intention in the documentation was concerning
>> hardware that indicated the _resolved_ status of pause modes. It was
>> not intended that drivers resolve the pause modes themselves.
>>
>> Even so, the above is still wrong; it takes no account of what is being
>> advertised at the local end. If one looks at the implementation in
>> phylink_decode_c37_word(), one will notice there is code to deal with
>> this.
>>
>> I think we ought to make phylink_decode_c37_word() and
>> phylink_decode_sgmii_word() public functions, and then this driver can
>> use these helpers to decode the link partner advertisement to the
>> phylink state.
>>
>> Does the driver need to provide an ethtool .get_link function? That
>> seems to bypass phylink. Why can't ethtool_op_get_link() be used?
>>
>> I think if ethtool_op_get_link() is used, we then have just one caller
>> for sparx5_get_port_status(), which means "struct sparx5_port_status"
>> can be eliminated and the code cleaned up to use the phylink decoding
>> helpers.
>
>(Sorry, I keep spotting bits in the code - it's really not an easy
>chunk of code to review.)
>
>I'm also not sure that this is really correct:
>
>+       status->serdes_link = !phy_validate(port->serdes, PHY_MODE_ETHERNET,
>+                                           port->conf.portmode, NULL);
>
>The documentation for phy_validate() says:
>
> * Used to check that the current set of parameters can be handled by
> * the phy. Implementations are free to tune the parameters passed as
> * arguments if needed by some implementation detail or
> * constraints. It will not change any actual configuration of the
> * PHY, so calling it as many times as deemed fit will have no side
> * effect.
>
>and clearly, passing NULL for opts, gives the function no opportunity
>to do what it's intended, so phy_validate() is being used for some
>other purpose than that which the drivers/phy subsystem intends it to
>be used for.

Hi Russell,

Yes this is a bit of an overload of the phy_validate().

The Serdes driver validates the portmode, and if OK, it returns the
current state of the link (bool), so that the client (SwitchDev) can know if the
link parameters so far results in a operational link. It does not change
any configuration.

I have not found another way to get the state of a generic PHY driver, but if
there is one, I will certainly use that.

Can you suggest the way to go?

>
>--
>RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
>FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

BR
Steen

---------------------------------------
Steen Hegelund
steen.hegelund@microchip.com
