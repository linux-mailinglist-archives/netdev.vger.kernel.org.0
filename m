Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D28628B58F
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 15:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388674AbgJLNJx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 09:09:53 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:57733 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388633AbgJLNJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 09:09:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602508192; x=1634044192;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VNDSt+zhhFrY3NFQ8ynshBXGxKGZD0F6mYKc9VJJ1Sg=;
  b=TSVkowlt3ylKHv3Dh8zDrCr7wx/wJx7cbuVGDTqBgNb/BpYpdXj9eMMu
   1fRanYE0qTAOP+LWOcvijZ+LWN+XTrTVVSzbpuamqDTF1iOehkwKOe9HN
   MMykx+Iex/9Ti32bTyKXpQKMGxvjU8VmY0UnS3YijU9+aJwcvvEoJ1w/7
   TymSKkd3t4XaBNdr35ExC4aoVeq8m7/qmKF4p+Lnm85yobPc3wbiC9Dvx
   yVz8VwLEr/vikaiEC1x3aMcrnWRu8/gJc9Pnip+iptXCQfILDSGC57Xa1
   y7zUh1wy4Zl8bQ01+tPReEF+WNgAj3X2uU7whCSMn4jw4K2Diaj8YvH4Z
   w==;
IronPort-SDR: VNjvqf+DoJkN6wopDOPvkTDopd84b8JVcoPfO9T5piYXAC7zIonacu+tIsZwOHLdHyh01Qp+A8
 jEcG4vEqm8jaFWtFjSCk7QkhNaskdfhOjPHe1r2IyVTmMypx9z9cIwN+roixXS4BGSbn8HumEa
 U/aKaZuaf2dEEjOs91QPMjPel1TcLdvDk9oRku7hbwCN8s2bpCly1Cw2NAuUrvA3zpeC5Yslqc
 OLVP7BDl8m4wOTnCjOjBdueeVIak1z+lJY9D4ZdjmE6c37GPMvl3wbNTZVPoA3Bv30LobiyWmE
 vLU=
X-IronPort-AV: E=Sophos;i="5.77,366,1596524400"; 
   d="scan'208";a="95011244"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Oct 2020 06:09:51 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 12 Oct 2020 06:09:51 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 12 Oct 2020 06:09:51 -0700
Date:   Mon, 12 Oct 2020 13:08:06 +0000
From:   "henrik.bjoernlund@microchip.com" <henrik.bjoernlund@microchip.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
CC:     "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v4 10/10] bridge: cfm: Netlink Notifications.
Message-ID: <20201012130806.sye6tl4amkuqbbgh@soft-test08>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
 <20201009143530.2438738-11-henrik.bjoernlund@microchip.com>
 <4adba273e44e0c4dbce4a32d07f79a05d3c66601.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <4adba273e44e0c4dbce4a32d07f79a05d3c66601.camel@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 10/09/2020 22:03, Nikolay Aleksandrov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Fri, 2020-10-09 at 14:35 +0000, Henrik Bjoernlund wrote:
> > This is the implementation of Netlink notifications out of CFM.
> >
> > Notifications are initiated whenever a state change happens in CFM.
> >
> > IFLA_BRIDGE_CFM:
> >     Points to the CFM information.
> >
> > IFLA_BRIDGE_CFM_MEP_STATUS_INFO:
> >     This indicate that the MEP instance status are following.
> > IFLA_BRIDGE_CFM_CC_PEER_STATUS_INFO:
> >     This indicate that the peer MEP status are following.
> >
> > CFM nested attribute has the following attributes in next level.
> >
> > IFLA_BRIDGE_CFM_MEP_STATUS_INSTANCE:
> >     The MEP instance number of the delivered status.
> >     The type is NLA_U32.
> > IFLA_BRIDGE_CFM_MEP_STATUS_OPCODE_UNEXP_SEEN:
> >     The MEP instance received CFM PDU with unexpected Opcode.
> >     The type is NLA_U32 (bool).
> > IFLA_BRIDGE_CFM_MEP_STATUS_VERSION_UNEXP_SEEN:
> >     The MEP instance received CFM PDU with unexpected version.
> >     The type is NLA_U32 (bool).
> > IFLA_BRIDGE_CFM_MEP_STATUS_RX_LEVEL_LOW_SEEN:
> >     The MEP instance received CCM PDU with MD level lower than
> >     configured level. This frame is discarded.
> >     The type is NLA_U32 (bool).
> >
> > IFLA_BRIDGE_CFM_CC_PEER_STATUS_INSTANCE:
> >     The MEP instance number of the delivered status.
> >     The type is NLA_U32.
> > IFLA_BRIDGE_CFM_CC_PEER_STATUS_PEER_MEPID:
> >     The added Peer MEP ID of the delivered status.
> >     The type is NLA_U32.
> > IFLA_BRIDGE_CFM_CC_PEER_STATUS_CCM_DEFECT:
> >     The CCM defect status.
> >     The type is NLA_U32 (bool).
> >     True means no CCM frame is received for 3.25 intervals.
> >     IFLA_BRIDGE_CFM_CC_CONFIG_EXP_INTERVAL.
> > IFLA_BRIDGE_CFM_CC_PEER_STATUS_RDI:
> >     The last received CCM PDU RDI.
> >     The type is NLA_U32 (bool).
> > IFLA_BRIDGE_CFM_CC_PEER_STATUS_PORT_TLV_VALUE:
> >     The last received CCM PDU Port Status TLV value field.
> >     The type is NLA_U8.
> > IFLA_BRIDGE_CFM_CC_PEER_STATUS_IF_TLV_VALUE:
> >     The last received CCM PDU Interface Status TLV value field.
> >     The type is NLA_U8.
> > IFLA_BRIDGE_CFM_CC_PEER_STATUS_SEEN:
> >     A CCM frame has been received from Peer MEP.
> >     The type is NLA_U32 (bool).
> >     This is cleared after GETLINK IFLA_BRIDGE_CFM_CC_PEER_STATUS_INFO.
> > IFLA_BRIDGE_CFM_CC_PEER_STATUS_TLV_SEEN:
> >     A CCM frame with TLV has been received from Peer MEP.
> >     The type is NLA_U32 (bool).
> >     This is cleared after GETLINK IFLA_BRIDGE_CFM_CC_PEER_STATUS_INFO.
> > IFLA_BRIDGE_CFM_CC_PEER_STATUS_SEQ_UNEXP_SEEN:
> >     A CCM frame with unexpected sequence number has been received
> >     from Peer MEP.
> >     The type is NLA_U32 (bool).
> >     When a sequence number is not one higher than previously received
> >     then it is unexpected.
> >     This is cleared after GETLINK IFLA_BRIDGE_CFM_CC_PEER_STATUS_INFO.
> >
> > Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
> > Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
> > ---
> >  net/bridge/br_cfm.c         | 48 ++++++++++++++++++++++++
> >  net/bridge/br_cfm_netlink.c | 25 ++++++++-----
> >  net/bridge/br_netlink.c     | 73 ++++++++++++++++++++++++++++++++-----
> >  net/bridge/br_private.h     | 22 ++++++++++-
> >  4 files changed, 147 insertions(+), 21 deletions(-)
> >
> 
> Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
Thanks for the review.

-- 
/Henrik
