Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326F12C867A
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbgK3ORE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:17:04 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:54960 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgK3ORD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 09:17:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1606745823; x=1638281823;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=gXJa2GLoR+9cQw6bzdTpZp8O02BmQweuLBOY+wsJ/pQ=;
  b=uZINWAlAZm1e7aHX5ClttmGABeZNnoJYuQNnruF0lFfg2A8apEFEBUK9
   e7UPeZGou7zVOlV41Y3TE8MuUgq98wYMBYbN9jcJXEnYyQwsy5A5+Zmth
   zD/I655lnEEKcBEZe3ZqCQLqhaRwbpqymaLUYU+puAgR+7W9/jjaW4nKk
   2y/VGJ6Uqqet3qM7zCV9HW99O+fS8LpeHSjTVT+CXk6OnjadCOtYWafaI
   1UbZ2rfBBttLWkwCr7TTcFp9StRUbId+sp715PLDvOGILwkDcmrpYB+d1
   LZhYLjkEKC14uQOw6UNJeGdWsQmRQ1p9GaGSNIg5/iIEyWwcWaCeY1cRE
   g==;
IronPort-SDR: UBpIndPWD+sPiPr1xAWrBjFrAw0jyatfCbO5eBHO4lhfJD0yqIlRCUdOKtoQEKPcca+rauqNjP
 5/b7fARWciTeOHhBPU1fc1Ln42oBCmAxrDFmXzXgPW6xhpmn5bqKjAXz0tJ05mu2kadvLOZ/eh
 uxPoTxKEGIY//1VIcnM0SS76IPFUroR5ZQ8OZ+CIkrlkd5btOYmW/nLboe7QfTJeqaAzoJcORS
 v6UxVFfVOk7CCG67IZy9YiarYs4CPKYXh0D66zGqMmg/+t1RbLA7130B4UMJXHxg6o7lwrkBPd
 JY4=
X-IronPort-AV: E=Sophos;i="5.78,381,1599548400"; 
   d="scan'208";a="105475172"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Nov 2020 07:15:57 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 07:15:57 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 30 Nov 2020 07:15:57 -0700
Date:   Mon, 30 Nov 2020 15:15:56 +0100
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
Message-ID: <20201130141556.o4vg32lr4uykwxmu@mchp-dev-shegelun>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-3-steen.hegelund@microchip.com>
 <20201128190616.GF2191767@lunn.ch>
 <20201128222828.GQ1551@shell.armlinux.org.uk>
 <20201129105245.GG1605@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20201129105245.GG1605@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.11.2020 10:52, Russell King - ARM Linux admin wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>On Sat, Nov 28, 2020 at 10:28:28PM +0000, Russell King - ARM Linux admin wrote:
>> On Sat, Nov 28, 2020 at 08:06:16PM +0100, Andrew Lunn wrote:
>> > > +static void sparx5_phylink_mac_config(struct phylink_config *config,
>> > > +                               unsigned int mode,
>> > > +                               const struct phylink_link_state *state)
>> > > +{
>> > > + struct sparx5_port *port = netdev_priv(to_net_dev(config->dev));
>> > > + struct sparx5_port_config conf;
>> > > + int err = 0;
>> > > +
>> > > + conf = port->conf;
>> > > + conf.autoneg = state->an_enabled;
>> > > + conf.pause = state->pause;
>> > > + conf.duplex = state->duplex;
>> > > + conf.power_down = false;
>> > > + conf.portmode = state->interface;
>> > > +
>> > > + if (state->speed == SPEED_UNKNOWN) {
>> > > +         /* When a SFP is plugged in we use capabilities to
>> > > +          * default to the highest supported speed
>> > > +          */
>> >
>> > This looks suspicious.
>>
>> Yes, it looks highly suspicious. The fact that
>> sparx5_phylink_mac_link_up() is empty, and sparx5_phylink_mac_config()
>> does all the work suggests that this was developed before the phylink
>> re-organisation, and this code hasn't been updated for it.
>>
>> Any new code for the kernel really ought to be updated for the new
>> phylink methodology before it is accepted.
>>
>> Looking at sparx5_port_config(), it also seems to use
>> PHY_INTERFACE_MODE_1000BASEX for both 1000BASE-X and 2500BASE-X. All
>> very well for the driver to do that internally, but it's confusing
>> when it comes to reviewing this stuff, especially when people outside
>> of the driver (such as myself) reviewing it need to understand what's
>> going on with the configuration.
>

Hi Russell,

>There are other issues too.
>
>Looking at sparx5_get_1000basex_status(), we have:
>
> +       status->link = DEV2G5_PCS1G_LINK_STATUS_LINK_STATUS_GET(value) |
> +                      DEV2G5_PCS1G_LINK_STATUS_SYNC_STATUS_GET(value);
>

>Why is the link status the logical OR of these?

Oops: It should have been AND. Well spotted.

>
> +                       if ((lp_abil >> 8) & 1) /* symmetric pause */
> +                               status->pause = MLO_PAUSE_RX | MLO_PAUSE_TX;
> +                       if (lp_abil & (1 << 7)) /* asymmetric pause */
> +                               status->pause |= MLO_PAUSE_RX;
>
>is actually wrong, and I see I need to improve the documentation for
>mac_pcs_get_state(). The intention in the documentation was concerning
>hardware that indicated the _resolved_ status of pause modes. It was
>not intended that drivers resolve the pause modes themselves.
>
>Even so, the above is still wrong; it takes no account of what is being
>advertised at the local end. If one looks at the implementation in
>phylink_decode_c37_word(), one will notice there is code to deal with
>this.
>
>I think we ought to make phylink_decode_c37_word() and
>phylink_decode_sgmii_word() public functions, and then this driver can
>use these helpers to decode the link partner advertisement to the
>phylink state.

Should I remove the current implementation and use something like what
is in phylink_decode_c37_word() and phylink_decode_sgmii_word() in the
meantime?

>
>Does the driver need to provide an ethtool .get_link function? That
>seems to bypass phylink. Why can't ethtool_op_get_link() be used?

I think that I tried that earlier, but ran into problems.  I better
revisit this, and try out your suggestion.

>
>I think if ethtool_op_get_link() is used, we then have just one caller
>for sparx5_get_port_status(), which means "struct sparx5_port_status"
>can be eliminated and the code cleaned up to use the phylink decoding
>helpers.
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
