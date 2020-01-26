Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA327149ADD
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 14:39:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729222AbgAZNjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 08:39:08 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:29526 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgAZNjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 08:39:08 -0500
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: 5+Q26d+J7PfCyMiRfduWDMvPl7C/kwKAfX9jzwehnmvTT5+2YJ8GnvkORj7N0JPGzTk4EE6SSf
 jEGK7FICZo7/W6jMw9pBmrYP0E6zugnSGCFq7nHvW4wfS/m64gGuHAxnvVKVIzwLMZt6K19BQe
 AeMyX57ErCOjLi9tt+/cIi9j7fuBOBG2K7eNJvL2dE0hMMBMDob1wGEQDlPdAEQB7ce8xGganC
 pyVazYuEtgzQfkrUc6R2pdthq0tNtWcf9xritgXhvdLqODiBA4Og+wmICi49Nf8C7sXI0gZe0g
 P3o=
X-IronPort-AV: E=Sophos;i="5.70,365,1574146800"; 
   d="scan'208";a="121477"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Jan 2020 06:39:06 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 26 Jan 2020 06:39:06 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Sun, 26 Jan 2020 06:39:06 -0700
Date:   Sun, 26 Jan 2020 14:39:05 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
CC:     Andrew Lunn <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <anirudh.venkataramanan@intel.com>, <olteanv@gmail.com>,
        <jeffrey.t.kirsher@intel.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next v3 04/10] net: bridge: mrp: Add generic netlink
 interface to configure MRP
Message-ID: <20200126133905.wzsvdsdvkc32dd4k@soft-dev3.microsemi.net>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
 <20200124161828.12206-5-horatiu.vultur@microchip.com>
 <20200125153403.GB18311@lunn.ch>
 <20200125192854.yi544iu2atvbbwey@lx-anielsen.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20200125192854.yi544iu2atvbbwey@lx-anielsen.microsemi.net>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
The 01/25/2020 20:28, Allan W. Nielsen wrote:
> On 25.01.2020 16:34, Andrew Lunn wrote:
> > On Fri, Jan 24, 2020 at 05:18:22PM +0100, Horatiu Vultur wrote:
> > > Implement the generic netlink interface to configure MRP. The implementation
> > > will do sanity checks over the attributes and then eventually call the MRP
> > > interface which eventually will call the switchdev API.
> > What was your thinking between adding a new generic netlink interface,
> > and extending the current one?
I thought is more clear to see which commands are used to configure MRP
by adding a new generic netlink than extending the existing one.

> > 
> > I've not looked at your user space code yet, but i assume it has to
> > make use of both? It needs to create the bridge and add the
> > interfaces. And then it needs to control the MRP state.
Actually the userspace application doesn't create the bridge and add the
interfaces. It expects that user does this using iproute2 or other
commands.
And once the bridge and interfaces are added then it would just
configure the bridge.

> > 
> > Allan mentioned you might get around to implementing 802.1CB? Would
> > that be another generic netlink interface, or would you extend the MRP
> > interface?
> Horatiu, if you have given this any thoughts, then please share them.
I have not look yet over this, I will try to have a look ASAP.

> 
> Here are my thoughts on 802.1CB: If we look at this with the traditional
> NIC/host POW, then it would be natural to look at the HSR interface as
> Vinicius suggested, and expose it as a new interface (HSR0). But when
> looking at how 802.1CB say a bridge should act, and also what the
> capabilities of the HW are, then it seem more natural to extend the TC
> system. In HW it is a TCAM classifying the traffic, and it has some
> actions to either replicate the matched frames, or eliminate the
> additional copies.
> 
> The HW also supports CFM (see [1]), which we need (partly) to complete
> the MRP implementation with MIM/MIC roles. This is also useful for none
> MRP users (like ERPS).
> 
> This seems like an argument for moving this to the existing netlink
> interfaces instead of having it as a generic netlink.
> 
> [1] https://en.wikipedia.org/wiki/IEEE_802.1ag
> 
> /Allan

-- 
/Horatiu
