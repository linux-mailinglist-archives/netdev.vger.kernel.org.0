Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069EC322076
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 20:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbhBVTrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 14:47:52 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:58606 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbhBVTrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 14:47:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1614023265; x=1645559265;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=moKLOh/90GdtNxD+lbLEqc8GYIIRPWMLOOU5tRrfJjA=;
  b=N75mbz/YWm2fHWNsDKmq4z9zKxJe/OtAPb97Vvs9XMui4RrpZPpCFPJe
   hX2TNmAHsoTAxlwSBmekEYvP0shT5180d3YQKzM3dwW4aY95ZZ8FbSUGp
   CC6e7y4+2izaj0msNl2lQZTzFxDi4ckpYzIqzRS8/vQqBhhVhCSEazPRr
   2th2tUL+Cv+ll3Yb4XZRbZTcvGjFA4UYC0+5gs9A/fAMpVzLHU0lSMzIB
   Kgb1yxmcHXzwkcL124ZUin5ht2MwUMboCHHCqgmZUmh4EWcbfWUm9Cnsw
   2CJ5npDqQBO7Wgu6+pSVbmfvl0+ApqVFh7J2+eM/VGNfIUO8+RX8J5bNo
   w==;
IronPort-SDR: i6VzJ9PuVA/2NMr+eWf+twCFDG8e971dNPGr+rFaqxYYznx748QBABYu+PYYQzSXZEdyAVCOwD
 lj7v5l3Tz5HEXxdXgWby8PfB9Lf2UkrG7gatnLnPjiJPx604fAJ//Rb66x912zSm3v+q+O+VLz
 pL5JVZ0+jM53G+H3XlyQj8PjMaIRqdkOjRh3YszjA3Un0Fj700hLN0bMkE/j5ty+3l+N2TaK7F
 yPs2iHkGypm0tvXqRFiAlpDRSJf5gJpEtuixjKTXAMkwp+9xY7Tv35ICBLsRf/fEwaJoTEsSGC
 +tw=
X-IronPort-AV: E=Sophos;i="5.81,198,1610434800"; 
   d="scan'208";a="116155460"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Feb 2021 12:46:26 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 22 Feb 2021 12:46:27 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 22 Feb 2021 12:46:26 -0700
Date:   Mon, 22 Feb 2021 20:46:26 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH net-next 09/12] Documentation: networking: dsa: add
 paragraph for the MRP offload
Message-ID: <20210222194626.srj7wwafyzfc355t@soft-dev3.localdomain>
References: <20210221213355.1241450-1-olteanv@gmail.com>
 <20210221213355.1241450-10-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20210221213355.1241450-10-olteanv@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 02/21/2021 23:33, Vladimir Oltean wrote:
> 
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Add a short summary of the methods that a driver writer must implement
> for getting an MRP instance to work on top of a DSA switch.
> 
> Cc: Horatiu Vultur <horatiu.vultur@microchip.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Hi Vladimir,

> 
> Horatiu:
> - Why does ocelot support a single MRP ring if all it does is trap the
>   MRP PDUs to the CPU? What is stopping it from supporting more than
>   one ring?

So the HW can support to run multiple rings. But to have an initial
basic implementation I have decided to support only one ring. So
basically is just a limitation in the driver.

> - Why is listening for SWITCHDEV_OBJ_ID_MRP necessary at all, since it
>   does nothing related to hardware configuration?

It is listening because it needs to know which ports are part of the
ring. In case you have multiple rings and do forwarding in HW you need
to know which ports are part of which ring. Also in case a MRP frame
will come on a port which is not part of the ring then that frame should
be flooded.

> - Why is ocelot_mrp_del_vcap called from both ocelot_mrp_del and from
>   ocelot_mrp_del_ring_role?

To clean after itself. Lets say a user creates a node and sets it up.
Then when she decides to delete the node, what should happen? Should it
first disable the node and then do the cleaning or just do the cleaning?
This userspace application[1] does the second option but I didn't want
to implement the driver to be specific to this application so I have put
the call in both places.

> - Why does ocelot not look at the MRM/MRC ring role at all, and it traps
>   all MRP PDUs to the CPU, even those which it could forward as an MRC?
>   I understood from your commit d8ea7ff3995e ("net: mscc: ocelot: Add
>   support for MRP") description that the hardware should be able of
>   forwarding the Test PDUs as a client, however it is obviously not
>   doing that.

It doesn't look at the role because it doesn't care. Because in both
cases is looking at the sw_backup because it doesn't support any role
completely. Maybe comment was misleading but I have put it under
'current limitations' meaning that the HW can do that but the driver
doesn't take advantage of that yet. The same applies to multiple rings
support.

The idea is to remove these limitations in the next patches and
to be able to remove these limitations then the driver will look also
at the role.

[1] https://github.com/microchip-ung/mrp

> ---
>  Documentation/networking/dsa/dsa.rst | 30 ++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
> index 0a5b06cf4d45..bf82f2aed29a 100644
> --- a/Documentation/networking/dsa/dsa.rst
> +++ b/Documentation/networking/dsa/dsa.rst
> @@ -730,6 +730,36 @@ can optionally populate ``ds->num_lag_ids`` from the ``dsa_switch_ops::setup``
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

-- 
/Horatiu
