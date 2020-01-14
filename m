Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7D113A280
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 09:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgANIJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 03:09:01 -0500
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:47472 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728992AbgANIJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 03:09:00 -0500
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
IronPort-SDR: 0diy65lC91otsjZEQ4eu3Nna2eRW0F5DDZSr6SdYu7P1/X58HMQZR5luLnlYZXeV6r5EcQL8M8
 pH30V0qkTK+rD9KKYemCr6Zmt91DO8KLPX8rrV1YaLdPt4IIjiXSu9KWt8Bw0dp2aSYIoVc5o5
 pApc4uMQu6ZC6ACLAPwlaVlIBh+/qNV80CedAblfAiKYCuf7I3fUIehJmOvSdhPxIs2KmTcKFA
 hid8u0abZkoBoErJIXOw+m5jZhvXK00DbHxUX6z+NTjHpsLqYr8d5+yPY5ed+JYs+fclC3a2vp
 BYM=
X-IronPort-AV: E=Sophos;i="5.69,432,1571727600"; 
   d="scan'208";a="60701153"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jan 2020 01:08:58 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 14 Jan 2020 01:08:58 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Tue, 14 Jan 2020 01:08:57 -0700
Date:   Tue, 14 Jan 2020 09:08:56 +0100
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>, <davem@davemloft.net>,
        <roopa@cumulusnetworks.com>, <nikolay@cumulusnetworks.com>,
        <jakub.kicinski@netronome.com>, <vivien.didelot@gmail.com>,
        <olteanv@gmail.com>, <anirudh.venkataramanan@intel.com>,
        <dsahern@gmail.com>, <jiri@resnulli.us>, <ivecera@redhat.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [RFC net-next Patch v2 4/4] net: bridge: mrp: switchdev: Add HW
 offload
Message-ID: <20200114080856.wa7ljxyzaf34u4xj@soft-dev3.microsemi.net>
References: <20200113124620.18657-1-horatiu.vultur@microchip.com>
 <20200113124620.18657-5-horatiu.vultur@microchip.com>
 <20200113140053.GE11788@lunn.ch>
 <20200113225751.jkkio4rztyuff4xj@soft-dev3.microsemi.net>
 <20200113233011.GF11788@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20200113233011.GF11788@lunn.ch>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 01/14/2020 00:30, Andrew Lunn wrote:
> 
> Hi Horatiu
> 
> It has been said a few times what the basic state machine should be in
> user space. A pure software solution can use raw sockets to send and
> receive MRP_Test test frames. When considering hardware acceleration,
> the switchdev API you have proposed here seems quite simple. It should
> not be too hard to map it to a set of netlink messages from userspace.

Yes and we will try to go with this approach, to have a user space
application that contains the state machines and then in the kernel to
extend the netlink messages to map to the switchdev API.
So we will create a new RFC once we will have the user space and the
definition of the netlink messages.

> 
> Yet your argument for kernel, not user space, is you are worried about
> the parameters which need to be passed to the hardware offload engine.
> In order to win the argument for a kernel solution, we are going to
> need a better idea what you think this problem is. The MRP_Test is TLV
> based. Are there other things which could be in this message? Is that
> what you are worried about?

> 
> Thanks
>      Andrew

-- 
/Horatiu
