Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8645E33D6EB
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 16:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238000AbhCPPMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 11:12:37 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:17176 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234124AbhCPPMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 11:12:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615907526; x=1647443526;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=O4oHfRQGq38rmI80Q6+GGgcSW1fHuUmIMjoilw7bs5w=;
  b=kHLYx1MrFot8dCUwayj2tOI/jWN+qs+zTK7NmuI0+wXnSvXBHTJLmQT0
   DRyMwwdPR7H2vvrHPspQ3VLor7bWBm4uh8qNGBmCV5k9yvL8OjTd2fo+h
   MKCRN/qMeRK3Rz+0g6LlGGJ54RtdH2F+rejQtMCco2MgUu7k3UySR4a14
   zJA90B+GaurMeb72QDpSs9xyV8OIqcMUqMZk+fa0K22SOb9gQOjQrpyWV
   tBo3mvcr1Ada83dZ7bzFFx3xa0gwMn4dYG8BL1PWkmqYiOfv+6td3ahUt
   +MIehLVFTfDKyXy6DkKpSWjiCF5DUff+g/rEjzZ68Dpw6j+A3oZUbBHWl
   Q==;
IronPort-SDR: sWwrNC4OrAatjwdpIzDpEosWPXz5nXrG5frIvKSEQUEbiqM0PoUIAgVZToJ8wPIu5ZUvwsng+O
 l1ZzXGtggXkEfYrtVLKcB0J60pydtiIaRiHC4ZAhICkOMuiVpWCzkTO1QMuLs/6plgaCl9cAuE
 dhYVoEgYypvxqO4wZ3rvJeHZ+VL6XAyLrPbwltupfefBvXWDv7A5BIciyjL9k0dvp7l4OGMV5k
 a1SmFjOIRqOXgwhQJK8eOeGy2N8jLJJdOkdbbVrUp4FtOV7hgEBe5c2wu7dNTbBmBkD1+Fu3xx
 4yw=
X-IronPort-AV: E=Sophos;i="5.81,251,1610434800"; 
   d="scan'208";a="119144732"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Mar 2021 08:12:02 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 16 Mar 2021 08:12:02 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Tue, 16 Mar 2021 08:12:02 -0700
Date:   Tue, 16 Mar 2021 16:12:15 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH v2 net-next 09/12] Documentation: networking: dsa: add
 paragraph for the MRP offload
Message-ID: <20210316151215.4dz2cvjspetayxyq@soft-dev3-1.localhost>
References: <20210316112419.1304230-1-olteanv@gmail.com>
 <20210316112419.1304230-10-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20210316112419.1304230-10-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 03/16/2021 13:24, Vladimir Oltean wrote:
> 
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Add a short summary of the methods that a driver writer must implement
> for getting an MRP instance to work on top of a DSA switch.
> 
> Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  Documentation/networking/dsa/dsa.rst | 30 ++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
> index e8576e81735c..0daafa2fb9eb 100644
> --- a/Documentation/networking/dsa/dsa.rst
> +++ b/Documentation/networking/dsa/dsa.rst
> @@ -757,6 +757,36 @@ can optionally populate ``ds->num_lag_ids`` from the ``dsa_switch_ops::setup``
>  method. The LAG ID associated with a bonding/team interface can then be
>  retrieved by a DSA switch driver using the ``dsa_lag_id`` function.
> 
> +IEC 62439-2 (MRP)
> +-----------------
> +
> +The Media Redundancy Protocol is a topology management protocol optimized for
> +fast fault recovery time for ring networks, which has some components
> +implemented as a function of the bridge driver. MRP uses management PDUs
> +(Test, Topology, LinkDown/Up, Option) sent at a multicast destination MAC
> +address range of 01:15:4e:00:00:0x and with an EtherType of 0x88e3.
> +Depending on the node's role in the ring (MRM: Media Redundancy Manager,
> +MRC: Media Redundancy Client, MRA: Media Redundancy Automanager), certain MRP
> +PDUs might need to be terminated locally and others might need to be forwarded.
> +An MRM might also benefit from offloading to hardware the creation and
> +transmission of certain MRP PDUs (Test).
> +
> +Normally an MRP instance can be created on top of any network interface,
> +however in the case of a device with an offloaded data path such as DSA, it is
> +necessary for the hardware, even if it is not MRP-aware, to be able to extract
> +the MRP PDUs from the fabric before the driver can proceed with the software
> +implementation. DSA today has no driver which is MRP-aware, therefore it only
> +listens for the bare minimum switchdev objects required for the software assist
> +to work properly. The operations are detailed below.
> +
> +- ``port_mrp_add`` and ``port_mrp_del``: notifies driver when an MRP instance
> +  with a certain ring ID, priority, primary port and secondary port is
> +  created/deleted.
> +- ``port_mrp_add_ring_role`` and ``port_mrp_del_ring_role``: function invoked
> +  when an MRP instance changes ring roles between MRM or MRC. This affects
> +  which MRP PDUs should be trapped to software and which should be autonomously
> +  forwarded.
> +
>  TODO
>  ====
> 
> --
> 2.25.1
> 

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

-- 
/Horatiu
