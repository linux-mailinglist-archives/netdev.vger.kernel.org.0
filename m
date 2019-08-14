Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 568DA8CF21
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 11:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfHNJQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 05:16:55 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:32220 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbfHNJQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 05:16:55 -0400
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Allan.Nielsen@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="Allan.Nielsen@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Allan.Nielsen@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Allan.Nielsen@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: rZ1OQJfoWy3CyRy3iay6n/x1U7Wj5MUSMO96s/HBa805uS6pMtRbv3YKcVwPY9jhIaqY30vSZV
 KrPdSJwseVAOE5VAA7I2aqeJxzqQgSd3/mdFLeGoFrij8hJ3R9va93s1hdxuFnkoX233X9mjCo
 rmcHyZ0YkLsPfvEZv13Urm3xdCQMUmqyx9B8CCb5h1MFtG4DTCosq/Udt5QpklvF16jupDO1yk
 yP/df/0CWBZ8Z/LKFadPeJJO7/m9gClSHkmN2gycPQzjgiN//t+ye+HhcAEmX7PZuF2vxZRxVv
 lpQ=
X-IronPort-AV: E=Sophos;i="5.64,384,1559545200"; 
   d="scan'208";a="45083531"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Aug 2019 02:16:53 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 14 Aug 2019 02:16:48 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Wed, 14 Aug 2019 02:16:47 -0700
Date:   Wed, 14 Aug 2019 11:16:47 +0200
From:   "Allan W . Nielsen" <allan.nielsen@microchip.com>
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: Re: [v2, 4/4] ocelot: add VCAP IS2 rule to trap PTP Ethernet frames
Message-ID: <20190814091645.dwo7c36xan2ttln2@lx-anielsen.microsemi.net>
References: <20190813025214.18601-1-yangbo.lu@nxp.com>
 <20190813025214.18601-5-yangbo.lu@nxp.com>
 <20190813062525.5bgdzjc6kw5hqdxk@lx-anielsen.microsemi.net>
 <VI1PR0401MB2237E0F32D6CC719682E8C1AF8AD0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <VI1PR0401MB2237E0F32D6CC719682E8C1AF8AD0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 08/14/2019 04:56, Y.b. Lu wrote:
> > -----Original Message-----
> > From: Allan W . Nielsen <allan.nielsen@microchip.com>
> > Sent: Tuesday, August 13, 2019 2:25 PM
> > To: Y.b. Lu <yangbo.lu@nxp.com>
> > Cc: netdev@vger.kernel.org; David S . Miller <davem@davemloft.net>;
> > Alexandre Belloni <alexandre.belloni@bootlin.com>; Microchip Linux Driver
> > Support <UNGLinuxDriver@microchip.com>
> > Subject: Re: [v2, 4/4] ocelot: add VCAP IS2 rule to trap PTP Ethernet frames
> > 
> > The 08/13/2019 10:52, Yangbo Lu wrote:
> > > All the PTP messages over Ethernet have etype 0x88f7 on them.
> > > Use etype as the key to trap PTP messages.
> > >
> > > Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>
> > > ---
> > > Changes for v2:
> > > 	- Added this patch.
> > > ---
> > >  drivers/net/ethernet/mscc/ocelot.c | 28 ++++++++++++++++++++++++++++
> > >  1 file changed, 28 insertions(+)
> > >
> > > diff --git a/drivers/net/ethernet/mscc/ocelot.c
> > > b/drivers/net/ethernet/mscc/ocelot.c
> > > index 6932e61..40f4e0d 100644
> > > --- a/drivers/net/ethernet/mscc/ocelot.c
> > > +++ b/drivers/net/ethernet/mscc/ocelot.c
> > > @@ -1681,6 +1681,33 @@ int ocelot_probe_port(struct ocelot *ocelot, u8
> > > port,  }  EXPORT_SYMBOL(ocelot_probe_port);
> > >
> > > +static int ocelot_ace_add_ptp_rule(struct ocelot *ocelot) {
> > > +	struct ocelot_ace_rule *rule;
> > > +
> > > +	rule = kzalloc(sizeof(*rule), GFP_KERNEL);
> > > +	if (!rule)
> > > +		return -ENOMEM;
> > > +
> > > +	/* Entry for PTP over Ethernet (etype 0x88f7)
> > > +	 * Action: trap to CPU port
> > > +	 */
> > > +	rule->ocelot = ocelot;
> > > +	rule->prio = 1;
> > > +	rule->type = OCELOT_ACE_TYPE_ETYPE;
> > > +	/* Available on all ingress port except CPU port */
> > > +	rule->ingress_port = ~BIT(ocelot->num_phys_ports);
> > > +	rule->dmac_mc = OCELOT_VCAP_BIT_1;
> > > +	rule->frame.etype.etype.value[0] = 0x88;
> > > +	rule->frame.etype.etype.value[1] = 0xf7;
> > > +	rule->frame.etype.etype.mask[0] = 0xff;
> > > +	rule->frame.etype.etype.mask[1] = 0xff;
> > > +	rule->action = OCELOT_ACL_ACTION_TRAP;
> > > +
> > > +	ocelot_ace_rule_offload_add(rule);
> > > +	return 0;
> > > +}
> > > +
> > >  int ocelot_init(struct ocelot *ocelot)  {
> > >  	u32 port;
> > > @@ -1708,6 +1735,7 @@ int ocelot_init(struct ocelot *ocelot)
> > >  	ocelot_mact_init(ocelot);
> > >  	ocelot_vlan_init(ocelot);
> > >  	ocelot_ace_init(ocelot);
> > > +	ocelot_ace_add_ptp_rule(ocelot);
> > >
> > >  	for (port = 0; port < ocelot->num_phys_ports; port++) {
> > >  		/* Clear all counters (5 groups) */
> > This seems really wrong to me, and much too hard-coded...
> > 
> > What if I want to forward the PTP frames to be forwarded like a normal
> > non-aware PTP switch?
> 
> [Y.b. Lu] As Andrew said, other switches could identify PTP messages and forward to CPU for processing.
> https://patchwork.ozlabs.org/patch/1145627/
Yes, it would be good to see some exampels to understand this better.

> I'm also wondering whether there is common method in linux to address your questions.
Me too.

> If no, I think trapping all PTP messages on all ports to CPU could be used for now.
> If users require PTP synchronization, they actually don’t want a non-aware PTP switch.
Can we continue this discussion in the other thread where I listed the 3
scenarios?

> I once see other ocelot code configure ptp trap rules in ioctl timestamping
> setting. But I don’t think it's proper either.  Enable timestamping doesn’t
> mean we want to trap PTP messages.
Where did you see this?

The effort in [1] is just about the time-stamping and does not really consider
the bridge part of it, and it should not be installing any TCAM rules (I believe
it did in earlier versions, but this has been changed).

[1] https://patchwork.ozlabs.org/patch/1145777/

> > What if do not want this on all ports?
> [Y.b. Lu] Actually I don’t think there should be difference of handling PTP messages on each port.
> You don’t need to run PTP protocol application on the specific port if you don’t want.
What if you want some vlans or some ports to be PTP unaware, and other to be PTP
aware.

> > If you do not have an application behind this implementing a boundary or
> > transparent clock, then you are breaking PTP on the network.
> [Y.b. Lu] You're right. But actually for PTP network, all PTP devices should run PTP protocol on it.
> Of course, it's better to have a way to configure it as non-aware PTP switch.
I think we agree.

In my point of view, it is the PTP daemon who should configure frames to be
trapped. Then the switch will be PTP unaware until the PTP daemon starts up and
is ready to make it aware.

If we put it in the init function, then it will be of PTP broken until the PTP
daemon starts.

/Allan

