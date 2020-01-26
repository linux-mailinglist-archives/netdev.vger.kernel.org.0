Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C19D149AC7
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 14:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbgAZNWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 08:22:16 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:64656 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgAZNWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 08:22:16 -0500
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
IronPort-SDR: Ko7PtFIUmKqu/uKzS/3kb6uOcIPdYFEtzg4pdcQduqsrc5irA1DX5GcbpFI7FYyZ4cNuocAFQG
 Xlm/63c6OyDIqOTIM8GeHzAWOpZF2cTSqe9InrQhN0vSWH3z3/Xg9I7gBqrT4/D/Gg6bkPaLVl
 zIBFVa2lSWt7sorP4/TUNpu9MB/wbDaWjjxJ4Q7NbcnzTXNzkyVZyN8JKgQ7cJKQanX343ka9t
 ba1mI+DzVe5OA1UcDDN/iVbD8QIZShhXQoH8b/5fX58hgGBtoHMVd5TB/d/Nl8IOitlcb2z+rA
 Lrg=
X-IronPort-AV: E=Sophos;i="5.70,365,1574146800"; 
   d="scan'208";a="121043"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Jan 2020 06:22:15 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 26 Jan 2020 06:22:15 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Sun, 26 Jan 2020 06:22:15 -0700
Date:   Sun, 26 Jan 2020 14:22:13 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <anirudh.venkataramanan@intel.com>, <olteanv@gmail.com>,
        <jeffrey.t.kirsher@intel.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next v3 06/10] net: bridge: mrp: switchdev: Extend
 switchdev API to offload MRP
Message-ID: <20200126132213.fmxl5mgol5qauwym@soft-dev3.microsemi.net>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
 <20200124161828.12206-7-horatiu.vultur@microchip.com>
 <20200125163504.GF18311@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20200125163504.GF18311@lunn.ch>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 01/25/2020 17:35, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> > SWITCHDEV_OBJ_ID_RING_TEST_MRP: This is used when to start/stop sending
> >   MRP_Test frames on the mrp ring ports. This is called only on nodes that have
> >   the role Media Redundancy Manager.
> 
> How do you handle the 'headless chicken' scenario? User space tells
> the port to start sending MRP_Test frames. It then dies. The hardware
> continues sending these messages, and the neighbours thinks everything
> is O.K, but in reality the state machine is dead, and when the ring
> breaks, the daemon is not there to fix it?
> 
> And it is not just the daemon that could die. The kernel could opps or
> deadlock, etc.
> 
> For a robust design, it seems like SWITCHDEV_OBJ_ID_RING_TEST_MRP
> should mean: start sending MRP_Test frames for the next X seconds, and
> then stop. And the request is repeated every X-1 seconds.

I totally missed this case, I will update this as you suggest.

> 
>      Andrew

-- 
/Horatiu
