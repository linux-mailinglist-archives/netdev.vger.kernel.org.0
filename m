Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81BA028F169
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 13:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbgJOLf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 07:35:27 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:10825 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728481AbgJOLfP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 07:35:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602761714; x=1634297714;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zmVfAZBQrTe6Fi17zOJ8O3GgbRp9oajUPFq1mfmh16w=;
  b=PrECu/k+7GIhTAXOQT5bcSsOkk740TxQHCmM/LjuSQb/SbacqqdBkhoS
   cVxnP8ABRNuMr/I1+/R+nLfU3cOIVyy1+d+eAYLKiu7TqR1YDIR7S8+zw
   jTKQxf9mRz1xSZuLW8VPTMMagol6C7z+XR0ORm1C51R+L3zr1+XLNouEs
   Pb8Xpf5DojjZiXilvFEuKr0LZclq3RhrFECmDFIUZBNEGNbYEBS52JAeh
   7AIOtbvNDNfuFujYrpbk+bIArVMoVnNfEWVxY3W1sgNOKD9umz2pIyXc0
   0wcZDRUPlwQGMPGydgSW46H5hD4JpAjd7BUUrwPK/aB90h2Wm3Ts1pU0p
   A==;
IronPort-SDR: 9IoJiBaOfMkru96T/wSZgYLhhzuAY8fg3Hvy7DjxQ0qs3Zft71WwFjrg/6ie8UCfKUDT6DFtXU
 yAOf7NVND/HW5u7DwI2+mjtis/VpSVTEwyY6n7PNC4w3/AkGUYUsYREoRLeHj2XNPoI/ZKFXGi
 Etvd+xh8yDQpGuH7cBQMChvqbBAspdvIf//lRunLOUA2nzgZXN4/qs6VNd1mpQv6sbi1oB+1fg
 Jud9wi3/dLAoiIkd+1fg1s2FDXOQeAa5fDJpVEMlrgc6UdpiNHyW6ixLXYSn17m8+dMpe9t2Zs
 cfA=
X-IronPort-AV: E=Sophos;i="5.77,378,1596524400"; 
   d="scan'208";a="92708713"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Oct 2020 04:35:14 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 15 Oct 2020 04:35:13 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 15 Oct 2020 04:35:13 -0700
Date:   Thu, 15 Oct 2020 11:33:33 +0000
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
Subject: Re: [PATCH net-next v5 09/10] bridge: cfm: Netlink GET status
 Interface.
Message-ID: <20201015113333.6pbjvrib7kl7gczp@soft-test08>
References: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
 <20201012140428.2549163-10-henrik.bjoernlund@microchip.com>
 <1253ca825551235c5fd45300f401a161f2bdd3f2.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1253ca825551235c5fd45300f401a161f2bdd3f2.camel@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your review.
Regards
Henrik

The 10/14/2020 11:24, Nikolay Aleksandrov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Mon, 2020-10-12 at 14:04 +0000, Henrik Bjoernlund wrote:
> > This is the implementation of CFM netlink status
> > get information interface.
> >
> > Add new nested netlink attributes. These attributes are used by the
> > user space to get status information.
> >
> > GETLINK:
> >     Request filter RTEXT_FILTER_CFM_STATUS:
> >     Indicating that CFM status information must be delivered.
> >
> >     IFLA_BRIDGE_CFM:
> >         Points to the CFM information.
> >
> >     IFLA_BRIDGE_CFM_MEP_STATUS_INFO:
> >         This indicate that the MEP instance status are following.
> >     IFLA_BRIDGE_CFM_CC_PEER_STATUS_INFO:
> >         This indicate that the peer MEP status are following.
> >
> > CFM nested attribute has the following attributes in next level.
> >
> > GETLINK RTEXT_FILTER_CFM_STATUS:
> >     IFLA_BRIDGE_CFM_MEP_STATUS_INSTANCE:
> >         The MEP instance number of the delivered status.
> >         The type is u32.
> >     IFLA_BRIDGE_CFM_MEP_STATUS_OPCODE_UNEXP_SEEN:
> >         The MEP instance received CFM PDU with unexpected Opcode.
> >         The type is u32 (bool).
> >     IFLA_BRIDGE_CFM_MEP_STATUS_VERSION_UNEXP_SEEN:
> >         The MEP instance received CFM PDU with unexpected version.
> >         The type is u32 (bool).
> >     IFLA_BRIDGE_CFM_MEP_STATUS_RX_LEVEL_LOW_SEEN:
> >         The MEP instance received CCM PDU with MD level lower than
> >         configured level. This frame is discarded.
> >         The type is u32 (bool).
> >
> >     IFLA_BRIDGE_CFM_CC_PEER_STATUS_INSTANCE:
> >         The MEP instance number of the delivered status.
> >         The type is u32.
> >     IFLA_BRIDGE_CFM_CC_PEER_STATUS_PEER_MEPID:
> >         The added Peer MEP ID of the delivered status.
> >         The type is u32.
> >     IFLA_BRIDGE_CFM_CC_PEER_STATUS_CCM_DEFECT:
> >         The CCM defect status.
> >         The type is u32 (bool).
> >         True means no CCM frame is received for 3.25 intervals.
> >         IFLA_BRIDGE_CFM_CC_CONFIG_EXP_INTERVAL.
> >     IFLA_BRIDGE_CFM_CC_PEER_STATUS_RDI:
> >         The last received CCM PDU RDI.
> >         The type is u32 (bool).
> >     IFLA_BRIDGE_CFM_CC_PEER_STATUS_PORT_TLV_VALUE:
> >         The last received CCM PDU Port Status TLV value field.
> >         The type is u8.
> >     IFLA_BRIDGE_CFM_CC_PEER_STATUS_IF_TLV_VALUE:
> >         The last received CCM PDU Interface Status TLV value field.
> >         The type is u8.
> >     IFLA_BRIDGE_CFM_CC_PEER_STATUS_SEEN:
> >         A CCM frame has been received from Peer MEP.
> >         The type is u32 (bool).
> >         This is cleared after GETLINK IFLA_BRIDGE_CFM_CC_PEER_STATUS_INFO.
> >     IFLA_BRIDGE_CFM_CC_PEER_STATUS_TLV_SEEN:
> >         A CCM frame with TLV has been received from Peer MEP.
> >         The type is u32 (bool).
> >         This is cleared after GETLINK IFLA_BRIDGE_CFM_CC_PEER_STATUS_INFO.
> >     IFLA_BRIDGE_CFM_CC_PEER_STATUS_SEQ_UNEXP_SEEN:
> >         A CCM frame with unexpected sequence number has been received
> >         from Peer MEP.
> >         The type is u32 (bool).
> >         When a sequence number is not one higher than previously received
> >         then it is unexpected.
> >         This is cleared after GETLINK IFLA_BRIDGE_CFM_CC_PEER_STATUS_INFO.
> >
> > Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
> > Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
> > ---
> >  include/uapi/linux/if_bridge.h |  29 +++++++++
> >  include/uapi/linux/rtnetlink.h |   1 +
> >  net/bridge/br_cfm_netlink.c    | 105 +++++++++++++++++++++++++++++++++
> >  net/bridge/br_netlink.c        |  16 ++++-
> >  net/bridge/br_private.h        |   6 ++
> >  5 files changed, 154 insertions(+), 3 deletions(-)
> >
> >
> 
> Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> 
> 

-- 
/Henrik
