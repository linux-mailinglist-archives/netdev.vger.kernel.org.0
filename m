Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E622ED186
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 15:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728396AbhAGOPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 09:15:02 -0500
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:34561 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727292AbhAGOPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 09:15:02 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 4A4A2581F07;
        Thu,  7 Jan 2021 09:13:56 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 07 Jan 2021 09:13:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=hQ9UDP
        jGkepfF6AmMvRBs0dOsCjK4yU+brVfc2VLT2s=; b=L+54am6xq/aRKCa6MFdQkf
        Agohhj/p0fkjHEGO1wu4/sMyUv3y+ki0JwZQUx73vnFtdCO7BXhBIRPi9+UGJD0G
        ejbzr9VcBLc71JH9auORSE1jO0PzgzwmTIiaz82QoX50VnvuEhevSoL/C9IFySNa
        /zeMY2eP4ZF/acFqdflxIDDCSGaDLuTcvRzcSIaD0xCLHyiP3H5IeIEY8hymDI+Q
        o1MrgrPNrc0zfwMKQGPiz4gHvztID+2TCprWeEviObAiZCYHxTOXW0UJm07lZoRS
        mhNORQl9xspx2LGQwIm2nLowxL4kKZrFGJwpVTjbDRgKXpQ8imOHqtMdY32UTkzw
        ==
X-ME-Sender: <xms:IBf3X4mLFkOOKs39GgDBDHWFXltF7yCaowQhbQzIeWxTwZx1wMNs4Q>
    <xme:IBf3X32bOIqXwgCtsRI72ve0zazOGUrlMBrx3__ttu8XtEy8WlFOR_TewKnYwHQTh
    ZNfvsFCPVEO1Js>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdegvddgiedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:IBf3X2raaGqN-G1XZrvX7ohupmm0ubu9TJiSNdj2uBH5nPeVFTBuBg>
    <xmx:IBf3X0mnew38e4PeZCjzy66QRc5SzzN6_ZsYmXAHhna3t-sdGFBezQ>
    <xmx:IBf3X22UgZe-30vCZeVEMd0cRbR0tgT887t1O8DKUJZQCRURW9-NCQ>
    <xmx:JBf3XwULEzehimhLulbVVJEp_-SWrvSqzk44PvsLhf56FJu-c2HB-Q>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5179C108005B;
        Thu,  7 Jan 2021 09:13:52 -0500 (EST)
Date:   Thu, 7 Jan 2021 16:13:49 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     petrm@nvidia.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: Re: [PATCH v3 net-next 03/11] net: switchdev: remove the transaction
 structure from port object notifiers
Message-ID: <20210107141349.GA1130184@shredder.lan>
References: <20210106231728.1363126-1-olteanv@gmail.com>
 <20210106231728.1363126-4-olteanv@gmail.com>
 <20210107103835.GA1102653@shredder.lan>
 <20210107111822.icmzu4lvs5ygsuef@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107111822.icmzu4lvs5ygsuef@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 01:18:22PM +0200, Vladimir Oltean wrote:
> On Thu, Jan 07, 2021 at 12:38:35PM +0200, Ido Schimmel wrote:
> > +Petr
> > 
> > On Thu, Jan 07, 2021 at 01:17:20AM +0200, Vladimir Oltean wrote:
> > >  static int mlxsw_sp_port_obj_add(struct net_device *dev,
> > >  				 const struct switchdev_obj *obj,
> > > -				 struct switchdev_trans *trans,
> > >  				 struct netlink_ext_ack *extack)
> > >  {
> > >  	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
> > >  	const struct switchdev_obj_port_vlan *vlan;
> > > +	struct switchdev_trans trans;
> > >  	int err = 0;
> > >  
> > >  	switch (obj->id) {
> > >  	case SWITCHDEV_OBJ_ID_PORT_VLAN:
> > >  		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
> > > -		err = mlxsw_sp_port_vlans_add(mlxsw_sp_port, vlan, trans,
> > > +
> > 
> > Got the regression results. The call to mlxsw_sp_span_respin() should be
> > placed here because it needs to be triggered regardless of the return
> > value of mlxsw_sp_port_vlans_add().
> 
> So before, mlxsw_sp_span_respin() was called right in between the
> prepare phase and the commit phase, regardless of the error value of
> mlxsw_sp_port_vlans_add. How does that work, I assume that
> mlxsw_sp_span_respin_work gets to run after the commit phase because it
> serializes using rtnl_lock()? Then why did it matter enough to schedule
> it between the prepare and commit phase in the first place?
> And what is there to do in mlxsw_sp_span_respin_work when
> mlxsw_sp_port_vlans_add returns -EOPNOTSUPP, -EBUSY, -EINVAL, -EEXIST or
> -ENOMEM?

The bridge driver will ignore -EOPNOTSUPP and actually add the VLAN on
the bridge device. See commit 9c86ce2c1ae3 ("net: bridge: Notify about
bridge VLANs") and commit ea4721751977 ("mlxsw: spectrum_switchdev:
Ignore bridge VLAN events")

Since the VLAN was successfully added on the bridge device,
mlxsw_sp_span_respin_work() should be able to resolve the egress port
for a packet that is mirrored to a gre tap and passes through the bridge
device.
