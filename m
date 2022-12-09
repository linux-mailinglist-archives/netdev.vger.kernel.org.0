Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5D764829B
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 13:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiLIMxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 07:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbiLIMxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 07:53:54 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADD36D7DE;
        Fri,  9 Dec 2022 04:53:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670590431; x=1702126431;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pQLpFDzbw7TKoL4vHHookBKgAqmAD1Lnc7h67IPEi3Y=;
  b=1yc/9slXGdXDiemczVxPDxaCT5teN7urZqENV00hY5m6V09gYdmXJynD
   u9bBcH8pxok34viUnJngu9KMghltJAnajfo/kHr8qnzy63KBF3xD639rP
   E/0f4sxc1LWFVpe9DaKdm7Uup8O97ZUkrW7AR1c3ayFPB/4WoFiZi/qmK
   xBl80LzdWdN2nVaU3im2okx2a5ZGfMxDXr5VSiIGZORV8E3/Qztw7Q4L3
   exElJG1j1/dKYMT2m36XwIaOa+Z2rdtevHebe2BW+QxqgW9Hux5y0EDS/
   HiZqUYELe7Fvpb97ZeoZ83p/CO4gct+Y2Ab/CN5a0HFKNqlnsKsFjV3b2
   A==;
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="203303507"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2022 05:53:50 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 9 Dec 2022 05:53:50 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Fri, 9 Dec 2022 05:53:50 -0700
Date:   Fri, 9 Dec 2022 13:58:57 +0100
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
Message-ID: <20221209125857.yhsqt4nj5kmavhmc@soft-dev3-1>
References: <20221203104348.1749811-5-horatiu.vultur@microchip.com>
 <20221208092511.4122746-1-michael@walle.cc>
 <c8b2ef73330c7bc5d823997dd1c8bf09@walle.cc>
 <20221208130444.xshazhpg4e2utvjs@soft-dev3-1>
 <adb8e2312b169d13e756ff23c45872c3@walle.cc>
 <20221209092904.asgka7zttvdtijub@soft-dev3-1>
 <c8b755672e20c223a83bc3cd4332f8cd@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <c8b755672e20c223a83bc3cd4332f8cd@walle.cc>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 12/09/2022 13:10, Michael Walle wrote:
> 
> Hi,

Hi Michael,

> 
> > > > The issue is because you have not enabled the TCAM lookups per
> > > > port. They can be enabled using this commands:
> > > >
> > > > tc qdisc add dev eth0 clsact
> > > 
> > > This gives me the following error, might be a missing kconfig option:
> > > 
> > > # tc qdisc add dev eth0 clsact
> > > RTNETLINK answers: Operation not supported
> > 
> > Yes that should be the case, I think you are missing:
> > CONFIG_NET_SCHED
> > But may be others when you try to add the next rule.
> 
> I guess I'd need to update my kernel config sometime. At the
> moment I just have a basic one, as there is still so much stuff
> missing for the lan9668. So I haven't come around testing anything
> else. As I said, I just noticed because my rootfs happens to have
> linuxptp started by default.

I understand.

> 
> > > > tc filter add dev eth0 ingress prio 5 handle 5 matchall skip_sw action
> > > > goto chain 8000000
> > > >
> > > > This will enable the lookup and then you should be able to start again
> > > > the ptp4l. Sorry for not mention this, at least I should have written
> > > > it
> > > > somewhere that this is required.
> > > >
> > > > I was not sure if lan966x should or not enable tcam lookups
> > > > automatically when a ptp trap action is added. I am open to suggestion
> > > > here.
> > > 
> > > IMHO, from a user point of view this should just work. For a user
> > > there is no connection between running linuxptp and some filtering
> > > stuff with 'tc'.
> > > 
> > > Also, if the answer to my question above is yes, and ptp should
> > > have worked on eth0 before, this is a regression then.
> > 
> > OK, I can see your point.
> > With the following diff, you should see the same behaviour as before:
> 
> Ok, I can say, I don't see the error message anymore. Haven't tested
> PTP though. I'd need to setup it up first.

Good, at least no more warnings and should not be any regression there.

> 
> Does it also work out of the box with the following patch if
> the interface is part of a bridge or do you still have to do
> the tc magic from above?

You will still need to enable the TCAM using the tc command to have it
working when the interface is part of the bridge.

> 
> -michael
> 
> > ---
> > diff --git
> > a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
> > b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
> > index 904f5a3f636d3..538f4b76cf97a 100644
> > --- a/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
> > +++ b/drivers/net/ethernet/microchip/lan966x/lan966x_vcap_impl.c
> > @@ -91,8 +91,6 @@ lan966x_vcap_is2_get_port_keysets(struct net_device
> > *dev, int lookup,
> > 
> >         /* Check if the port keyset selection is enabled */
> >         val = lan_rd(lan966x, ANA_VCAP_S2_CFG(port->chip_port));
> > -       if (!ANA_VCAP_S2_CFG_ENA_GET(val))
> > -               return -ENOENT;
> > 
> >         /* Collect all keysets for the port in a list */
> >         if (l3_proto == ETH_P_ALL)
> > ---
> > 
> > > 
> > > -michael

-- 
/Horatiu
