Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA4A78B78
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 14:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbfG2MOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 08:14:12 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:12462 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbfG2MOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 08:14:12 -0400
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
IronPort-SDR: aLZiBvBLONgzOEJZrm4T1FxjFfo9JWe95bD4mlbxe9tnN/sS2MwW6HVEVRXUfUP49oivvT+Kw9
 SJ3JvYMAOwmmlbjjSAvfkvk6HAK2Q4ckKGVzqbH1K8krtLYLYCygF2UAqzGZKJP0G3R73oaXFK
 67C4MxDAh3LjW8UfpbrY5Pph7BIA3IVJ0XIexjhWV++1E8Y09z+0bNTHHP1txignmlRel8YagR
 TbiN+EcfluhWIwMOn4cc76Z9WtM9ptl/Je9be8eWM/fBLNTHTvv2heZOz0zPa3RY8KkAJ9PuXT
 ogU=
X-IronPort-AV: E=Sophos;i="5.64,322,1559545200"; 
   d="scan'208";a="43090694"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jul 2019 05:14:11 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex03.mchp-main.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 29 Jul 2019 05:14:11 -0700
Received: from localhost (10.10.85.251) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Mon, 29 Jul 2019 05:14:10 -0700
Date:   Mon, 29 Jul 2019 14:14:10 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
CC:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        <roopa@cumulusnetworks.com>, <davem@davemloft.net>,
        <bridge@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: bridge: Allow bridge to joing multicast groups
Message-ID: <20190729121409.wa47uelw5f6l4vs4@lx-anielsen.microsemi.net>
References: <1564055044-27593-1-git-send-email-horatiu.vultur@microchip.com>
 <7e7a7015-6072-d884-b2ba-0a51177245ab@cumulusnetworks.com>
 <eef063fe-fd3a-7e02-89c2-e40728a17578@cumulusnetworks.com>
 <20190725142101.65tusauc6fzxb2yp@soft-dev3.microsemi.net>
 <b9ce433a-3ef7-fe15-642a-659c5715d992@cumulusnetworks.com>
 <e6ad982f-4706-46f9-b8f0-1337b09de350@cumulusnetworks.com>
 <20190726120214.c26oj5vks7g5ntwu@soft-dev3.microsemi.net>
 <b755f613-e6d8-a2e6-16cd-6f13ec0a6ddc@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <b755f613-e6d8-a2e6-16cd-6f13ec0a6ddc@cumulusnetworks.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nikolay,

First of all, as mentioned further down in this thread, I realized that our
implementation of the multicast floodmasks does not align with the existing SW
implementation. We will change this, such that all multicast packets goes to the
SW bridge.

This changes things a bit, not that much.

I actually think you summarized the issue we have (after changing to multicast
flood-masks) right here:

The 07/26/2019 12:26, Nikolay Aleksandrov wrote:
> >> Actually you mentioned non-IP traffic, so the querier stuff is not a problem. This
> >> traffic will always be flooded by the bridge (and also a copy will be locally sent up).
> >> Thus only the flooding may need to be controlled.

This seems to be exactly what we need.

Assuming we have a SW bridge (br0) with 4 slave interfaces (eth0-3). We use this
on a network where we want to limit the flooding of frames with dmac
01:21:6C:00:00:01 (which is non IP traffic) to eth0 and eth1.

One way of doing this could potentially be to support the following command:

bridge fdb add    01:21:6C:00:00:01 port eth0
bridge fdb append 01:21:6C:00:00:01 port eth1

On 25/07/2019 16:06, Nikolay Aleksandrov wrote:
> >>>>>>  In general NLM_F_APPEND is only used in vxlan, the bridge does not
> >>>>>>  handle that flag at all.  FDB is only for *unicast*, nothing is joined
> >>>>>>  and no multicast should be used with fdbs. MDB is used for multicast
> >>>>>>  handling, but both of these are used for forwarding.
This is true, and this should have been addressed in the patch, we were too
focused on setting up the offload patch in the driver, and forgot to do the SW
implementation.

Do you see any issues in supporting this flag, and updating the SW
forwarding in br_handle_frame_finish such that it can support/allow a FDB entry
to be a multicast?

/Allan

