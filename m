Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F20D5149553
	for <lists+netdev@lfdr.de>; Sat, 25 Jan 2020 12:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgAYLh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jan 2020 06:37:29 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:13978 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgAYLh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jan 2020 06:37:29 -0500
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
IronPort-SDR: Pfv05u6HOka84/YF+LjrNiolUrO4H6UUM+p0c3XumyDDF64ohVrDR+Y6b2sktZThQ9TFo8zrzJ
 VDfg0cAUU07Q4vgkUigrqCtWX2QdZWvA+W3PSyamb3gC6jfk5zcxcEopJCFXXXZ5qSjyLvNymF
 6K3zjK9ZTb4LI2RaFS3xnMNiHBbgS7//L04mBaZtna7mqUMa9yeFuKAIPZvJNHu/Fe3QTBNb/v
 Q37dxCY55vpSP+Zo78a5011KvSBvfdZX1m/wv97rE/Uk/mo62rS1sFEwg+p+FEBf0y3fpdcIIi
 AZI=
X-IronPort-AV: E=Sophos;i="5.70,361,1574146800"; 
   d="scan'208";a="75343"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Jan 2020 04:37:28 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 25 Jan 2020 04:37:28 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Sat, 25 Jan 2020 04:37:27 -0700
Date:   Sat, 25 Jan 2020 12:37:26 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <jiri@resnulli.us>,
        <ivecera@redhat.com>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <anirudh.venkataramanan@intel.com>, <olteanv@gmail.com>,
        <jeffrey.t.kirsher@intel.com>, <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next v3 03/10] net: bridge: mrp: Add MRP interface used
 by netlink
Message-ID: <20200125113726.ousbmm4n3ab4xnqt@soft-dev3.microsemi.net>
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
 <20200124161828.12206-4-horatiu.vultur@microchip.com>
 <20200124174315.GC13647@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20200124174315.GC13647@lunn.ch>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 01/24/2020 18:43, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> > br_mrp_flush - will flush the FDB.
> 
> How does this differ from a normal bridge flush? I assume there is a
> way for user space to flush the bridge FDB.

Hi,

If I seen corectly the normal bridge flush will clear the entire FDB for
all the ports of the bridge. In this case it is require to clear FDB
entries only for the ring ports. In the next series I will add a better
description of this function and update also the implementation.

The user space doesn't know and doesn't contain a FDB. The user space
will just call the kernel(via netlink interface) to clear the FDB. And
the netlink call will eventually call this function.

> 
>     Andrew

-- 
/Horatiu
