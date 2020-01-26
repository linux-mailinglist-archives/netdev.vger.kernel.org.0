Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E81B149ACC
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 14:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729008AbgAZN2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 08:28:46 -0500
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:10231 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgAZN2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 08:28:45 -0500
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Horatiu.Vultur@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="Horatiu.Vultur@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Horatiu.Vultur@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; dkim=none (message not signed) header.i=none; spf=Pass smtp.mailfrom=Horatiu.Vultur@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: VxDbpN+x7qnbLHzjRB0O+pdnR7Lau/oN5vajjMhaHegbtt9HensLX8N88e8XPl7jjF9iKVYMiB
 KMO//fyGniIJ8/rbyoYN26VJraCGPyTg1WsBk7aGIwzhoQwegUXXt6iNeb774uk90oOypxWvuC
 vHRWrVbHIGub6Dgf4Tw5QInTWYf2TORCv+JE5/99CCNjXfTUpUiDgn3kI1WkJmenFlbSazxHEy
 oEebIhAU9v3H+PdipGijV0lZm65sJeOa1z6IfGKpsGJrER43oOMv8cmUSNCl35M/r9O1dWHtI3
 06o=
X-IronPort-AV: E=Sophos;i="5.70,365,1574146800"; 
   d="scan'208";a="66037731"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Jan 2020 06:28:44 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 26 Jan 2020 06:28:41 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Sun, 26 Jan 2020 06:28:44 -0700
Date:   Sun, 26 Jan 2020 14:28:43 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
CC:     Andrew Lunn <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bridge@lists.linux-foundation.org>,
        <jiri@resnulli.us>, <ivecera@redhat.com>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <anirudh.venkataramanan@intel.com>, <olteanv@gmail.com>,
        <jeffrey.t.kirsher@intel.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next v3 03/10] net: bridge: mrp: Add MRP interface used
 by netlink
Message-ID: <20200126132843.k4rzn7vfti7lqvos@soft-dev3.microsemi.net>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
 <20200124161828.12206-4-horatiu.vultur@microchip.com>
 <20200124174315.GC13647@lunn.ch>
 <20200125113726.ousbmm4n3ab4xnqt@soft-dev3.microsemi.net>
 <20200125152023.GA18311@lunn.ch>
 <20200125191612.5dlzlvb7g2bucqna@lx-anielsen.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20200125191612.5dlzlvb7g2bucqna@lx-anielsen.microsemi.net>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 01/25/2020 20:16, Allan W. Nielsen wrote:
> On 25.01.2020 16:20, Andrew Lunn wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > On Sat, Jan 25, 2020 at 12:37:26PM +0100, Horatiu Vultur wrote:
> > > The 01/24/2020 18:43, Andrew Lunn wrote:
> > > > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > > >
> > > > > br_mrp_flush - will flush the FDB.
> > > >
> > > > How does this differ from a normal bridge flush? I assume there is a
> > > > way for user space to flush the bridge FDB.
> > > 
> > > Hi,
> > > 
> > > If I seen corectly the normal bridge flush will clear the entire FDB for
> > > all the ports of the bridge. In this case it is require to clear FDB
> > > entries only for the ring ports.
> > 
> > Maybe it would be better to extend the current bridge netlink call to
> > be able to pass an optional interface to be flushed?  I'm not sure it
> > is a good idea to have two APIs doing very similar things.
> I agree.
I would look over this.

> 
> And when looking at this again, I start to think that we should have
> extended the existing netlink interface with new commands, instead of
> adding a generic netlink.
We could do also that. The main reason why I have added a new generic
netlink was that I thought it would be clearer what commands are for MRP
configuration. But if you think that we should go forward by extending
existing netlink interface, that is perfectly fine for me.

> 
> /Allan
> 

-- 
/Horatiu
