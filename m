Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603212ECE08
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 11:39:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbhAGKjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 05:39:49 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:38549 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726607AbhAGKjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 05:39:49 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id D58DA581F2D;
        Thu,  7 Jan 2021 05:38:42 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 07 Jan 2021 05:38:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=G/oo69
        eG16t8QTcVV9dLgzHpx0u7J4+Gw6PfzlV4+B8=; b=WaJo/MeaLRthsu5BTfVWtJ
        xC3JcUdsZ19JvysEEO4Yu80erYfId5vhymM66ufUyE7oZpIxRBbHWhuCo7zkeJwq
        bH464cRHjHbBnrQjFBzrLXqOjCWfnIz2oaKcp680nfuMrRDwsQs88jmqbKb8BndR
        DMpuD1UPHCna0fLFu0MAvW2FJXLpaHhmuUahkM5xFDPRP3WQZjF7dsUznlM/pXXb
        rLSYq7Mgx5hgSbf7slbt6hp+0eKvN+zZxlrbY5WnzzxlIjDmYSEH59hGMBvxkkEV
        QqkLcgkfEjJGPPGeF4yU18VxpuptmDq6thAJfXqUDhUt1lZ5/9m3c+0GSLfWLFTw
        ==
X-ME-Sender: <xms:r-T2X0dU_Tgb8yCRmvAc39SMCB7DHbP_BRKSQfpBooLuZIKeVWILLQ>
    <xme:r-T2X2PI_mijZjRETsHRkM7Y_twi-cFsTM9bWlaKHXsoTv-U8fJUqRDjhrTDuy6hM
    A-3t8NcOs180HA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdegvddgudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucfkphepkeegrddvvdelrdduheefrdeggeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:r-T2X1icKClzW1hhwb_jZZCgs1N3oHGkSiuCTPaUv7UYIJCvHXsxKA>
    <xmx:r-T2X58Nxbh8BBvSrFwGf6hjZyFBC5VieLqMU9XxfqRwBtmU2r2j9w>
    <xmx:r-T2Xwtr-2KwOQ1A2yzGKMbq1SfvH1LKvqnEQ0NI44T5Ovv7doGniA>
    <xmx:suT2X4T3IQnjmElqcYg6Nc2xM_fxITkOptWObYT4l_ECbfG56Nu7Bw>
Received: from localhost (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id AF8CD24005B;
        Thu,  7 Jan 2021 05:38:38 -0500 (EST)
Date:   Thu, 7 Jan 2021 12:38:35 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
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
Message-ID: <20210107103835.GA1102653@shredder.lan>
References: <20210106231728.1363126-1-olteanv@gmail.com>
 <20210106231728.1363126-4-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210106231728.1363126-4-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+Petr

On Thu, Jan 07, 2021 at 01:17:20AM +0200, Vladimir Oltean wrote:
>  static int mlxsw_sp_port_obj_add(struct net_device *dev,
>  				 const struct switchdev_obj *obj,
> -				 struct switchdev_trans *trans,
>  				 struct netlink_ext_ack *extack)
>  {
>  	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
>  	const struct switchdev_obj_port_vlan *vlan;
> +	struct switchdev_trans trans;
>  	int err = 0;
>  
>  	switch (obj->id) {
>  	case SWITCHDEV_OBJ_ID_PORT_VLAN:
>  		vlan = SWITCHDEV_OBJ_PORT_VLAN(obj);
> -		err = mlxsw_sp_port_vlans_add(mlxsw_sp_port, vlan, trans,
> +

Got the regression results. The call to mlxsw_sp_span_respin() should be
placed here because it needs to be triggered regardless of the return
value of mlxsw_sp_port_vlans_add().

I'm looking into another failure, which might not be related to these
patches. I will also have results with a debug kernel tomorrow (takes
almost a day to complete). Will let you know.

> +		trans.ph_prepare = true;
> +		err = mlxsw_sp_port_vlans_add(mlxsw_sp_port, vlan, &trans,
>  					      extack);
> +		if (err)
> +			break;
>  
> -		if (switchdev_trans_ph_prepare(trans)) {
> -			/* The event is emitted before the changes are actually
> -			 * applied to the bridge. Therefore schedule the respin
> -			 * call for later, so that the respin logic sees the
> -			 * updated bridge state.
> -			 */
> -			mlxsw_sp_span_respin(mlxsw_sp_port->mlxsw_sp);
> -		}
> +		/* The event is emitted before the changes are actually
> +		 * applied to the bridge. Therefore schedule the respin
> +		 * call for later, so that the respin logic sees the
> +		 * updated bridge state.
> +		 */
> +		mlxsw_sp_span_respin(mlxsw_sp_port->mlxsw_sp);
> +
> +		trans.ph_prepare = false;
> +		err = mlxsw_sp_port_vlans_add(mlxsw_sp_port, vlan, &trans,
> +					      extack);
>  		break;
>  	case SWITCHDEV_OBJ_ID_PORT_MDB:
>  		err = mlxsw_sp_port_mdb_add(mlxsw_sp_port,
> -					    SWITCHDEV_OBJ_PORT_MDB(obj),
> -					    trans);
> +					    SWITCHDEV_OBJ_PORT_MDB(obj));
>  		break;
>  	default:
>  		err = -EOPNOTSUPP;
