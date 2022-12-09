Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FF0648013
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 10:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiLIJYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 04:24:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiLIJYC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 04:24:02 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D49C36C42;
        Fri,  9 Dec 2022 01:23:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670577840; x=1702113840;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=XK/r9Yv+fEFNTG77MFjQPZxHHD70wakKqSR1wYV+Yy0=;
  b=SwBVdW1532kgKr53qhx4jyxwUAqv1U0P+76XuN/LsQZdK4MS4LFluve2
   2pxSjiqGf26i+IATwYN7FDgf/y3B1vH6Y4BKh9QNdt5i8kJaEfxNni3Yb
   tb/inzHClKB6f0h2bYXn0PgvzEJ8isnRxEQ+nEfF12vUk4K7q+bIQJF4N
   WQoRmebgOcPd6nMX9FRSJ+nnTRgxRBDs60ZJYSexs9qp/09O6dmNxDzOd
   CBKm7aSoevzEp/BDpc6Mg6eSQFQ5YnOa6TaXB5/azF+PB68R4F44LVYUA
   gvh63Gvm+rZWWmTbwWXSPSai5g4mD6A0lB+TkPedWf19ZaRkgW49zJW7B
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="187348703"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2022 02:23:58 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 9 Dec 2022 02:23:57 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Fri, 9 Dec 2022 02:23:57 -0700
Date:   Fri, 9 Dec 2022 10:29:04 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Michael Walle <michael@walle.cc>
CC:     <Steen.Hegelund@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <daniel.machon@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>,
        <lars.povlsen@microchip.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <olteanv@gmail.com>, <pabeni@redhat.com>,
        <richardcochran@gmail.com>
Subject: Re: [PATCH net-next v3 4/4] net: lan966x: Add ptp trap rules
Message-ID: <20221209092904.asgka7zttvdtijub@soft-dev3-1>
References: <20221203104348.1749811-5-horatiu.vultur@microchip.com>
 <20221208092511.4122746-1-michael@walle.cc>
 <c8b2ef73330c7bc5d823997dd1c8bf09@walle.cc>
 <20221208130444.xshazhpg4e2utvjs@soft-dev3-1>
 <adb8e2312b169d13e756ff23c45872c3@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <adb8e2312b169d13e756ff23c45872c3@walle.cc>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/08/2022 14:18, Michael Walle wrote:
> 
> Hi Horatiu,

Hi Michael,

> 
> Am 2022-12-08 14:04, schrieb Horatiu Vultur:
> > > > > Currently lan966x, doesn't allow to run PTP over interfaces that are
> > > > > part of the bridge. The reason is when the lan966x was receiving a
> > > > > PTP frame (regardless if L2/IPv4/IPv6) the HW it would flood this
> > > > > frame.
> > > > > Now that it is possible to add VCAP rules to the HW, such to trap
> > > > > these
> > > > > frames to the CPU, it is possible to run PTP also over interfaces that
> > > > > are part of the bridge.
> > > >
> > > > This gives me:
> > > >
> > > > # /etc/init.d/S65ptp4l start
> > > > Starting linuxptp daemon: OK
> > > > [   44.136870] vcap_val_rule:1678: keyset was not updated: -22
> > > > [   44.140196] vcap_val_rule:1678: keyset was not updated: -22
> > > > #
> > > >
> > > > # ptp4l -v
> > > > 3.1.1
> > > > # uname -a
> > > > Linux buildroot 6.1.0-rc8-next-20221208+ #924 SMP Thu Dec  8 10:08:58
> > > > CET 2022 armv7l GNU/Linux
> > > >
> > > > I don't know whats going on, but I'm happy to help with debugging with
> > > > some
> > > > guidance.
> > > 
> > > Oh, and linuxptp is running on eth0, no bridges are set up. linuxptp
> > > is started with "/usr/sbin/ptp4l -f /etc/linuxptp.cfg"
> > > 
> > > # cat /etc/linuxptp.cfg
> > > # LinuxPTP configuration file for synchronizing the system clock to
> > > # a remote PTP master in slave-only mode.
> > > #
> > > # By default synchronize time in slave-only mode using UDP and
> > > hardware
> > > time
> > > # stamps on eth0. If the difference to master is >1.0 second correct
> > > by
> > > # stepping the clock instead of adjusting the frequency.
> > > #
> > > # If you change the configuration don't forget to update the phc2sys
> > > # parameters accordingly in linuxptp-system-clock.service (systemd)
> > > # or the linuxptp SysV init script.
> > > 
> > > [global]
> > > slaveOnly               1
> > > delay_mechanism         Auto
> > > network_transport       UDPv4
> > > time_stamping           hardware
> > > step_threshold          1.0
> > > 
> > > [eth0]
> > 
> > Thanks for trying this!
> 
> Actually I was just booting my board which happens to have linuxptp
> started by default. And the error messages were new. But I'm not so
> sure anymore if PTP was really working. I'm still puzzled by reading
> your commit message. Was it already working for interfaces which aren't
> part of a bridge and this commit will make it work even for interfaces
> which are part of a bridge?

Exactly!
This worked on interfaces that were not part of the bridge. And with
this commit will make it work even on interfaces that are part of the
bridge.

> 
> > The issue is because you have not enabled the TCAM lookups per
> > port. They can be enabled using this commands:
> > 
> > tc qdisc add dev eth0 clsact
> 
> This gives me the following error, might be a missing kconfig option:
> 
> # tc qdisc add dev eth0 clsact
> RTNETLINK answers: Operation not supported

Yes that should be the case, I think you are missing:
CONFIG_NET_SCHED
But may be others when you try to add the next rule.

> 
> > tc filter add dev eth0 ingress prio 5 handle 5 matchall skip_sw action
> > goto chain 8000000
> > 
> > This will enable the lookup and then you should be able to start again
> > the ptp4l. Sorry for not mention this, at least I should have written
> > it
> > somewhere that this is required.
> > 
> > I was not sure if lan966x should or not enable tcam lookups
> > automatically when a ptp trap action is added. I am open to suggestion
> > here.
> 
> IMHO, from a user point of view this should just work. For a user
> there is no connection between running linuxptp and some filtering
> stuff with 'tc'.
> 
> Also, if the answer to my question above is yes, and ptp should
> have worked on eth0 before, this is a regression then.

OK, I can see your point.
With the following diff, you should see the same behaviour as before:
---
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
index 904f5a3f636d3..538f4b76cf97a 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
@@ -91,8 +91,6 @@ lan966x_vcap_is2_get_port_keysets(struct net_device *dev, int lookup,

        /* Check if the port keyset selection is enabled */
        val = lan_rd(lan966x, ANA_VCAP_S2_CFG(port->chip_port));
-       if (!ANA_VCAP_S2_CFG_ENA_GET(val))
-               return -ENOENT;

        /* Collect all keysets for the port in a list */
        if (l3_proto == ETH_P_ALL)
---

> 
> -michael

-- 
/Horatiu
