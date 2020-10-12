Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 181C728B587
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 15:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388629AbgJLNJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 09:09:07 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:2467 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730321AbgJLNJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 09:09:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602508145; x=1634044145;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=c6Ivqf4OspDRp407mzox5L4R7nJcJEmFcZbBbxEq/VM=;
  b=tK9aGjRLkpTj7al4xQ4J+47bBi6GBJVijlYu5m/btUjY60ntXSkkqsux
   /kXmUYR2dmkBEHIjNrmHT8AN2HvRCZCaqlx6beDZKdh1PDIou6XE1EqNb
   1SIB6tOxgY4oVkAw2F/LU/bujqfm1PxhTtq4ZZBoeYW+98+ad1ZQqZ879
   chBWfTIn7xQVqiryQx1mMzkG/3adXayITwYLncn4QfQvyeMQRHhgsp6Gd
   RJDNc7UbXmYv1D8o0PZ8GptsE9clPTQV7185R2s9HhkPZaLXBUgjp9hvE
   8OHjR5QXeY4vXxIOSg+1tTTYRMGRdpDuLTHfX6CixRcyvsnqL2da7hh/f
   w==;
IronPort-SDR: NT28TSS16jg06yBzrsMurprqOSGprMznsPEaRe03fqV7VCYlH/ehZmyj0IEFcfU00gOmUClgQ4
 UVhiDrIEZ1WHKCoba5IPeJZh8Aj4t6HV3H3lvUM50sYrx8funtFp80bj9+X/m0knxY1FSF1Snu
 5B/683RllY2cQbHsZJiMLlFrVlUmCW2Wdc2t6b9W10GMR66tyOckrCSOBBnydEo+rU391Xy3z4
 sx7L0WJBaFfGh3wMIaH0VLg0CD/zhc2Jg4F/Gg2frAwSj0xU6VJdbSrHSSpxC2swRL11Wd/FpA
 iUo=
X-IronPort-AV: E=Sophos;i="5.77,366,1596524400"; 
   d="scan'208";a="89897893"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Oct 2020 06:09:05 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 12 Oct 2020 06:09:05 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 12 Oct 2020 06:09:05 -0700
Date:   Mon, 12 Oct 2020 13:07:19 +0000
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
Subject: Re: [PATCH net-next v4 07/10] bridge: cfm: Netlink SET configuration
 Interface.
Message-ID: <20201012130719.f33smgwclykfnwed@soft-test08>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
 <20201009143530.2438738-8-henrik.bjoernlund@microchip.com>
 <7b6678065b33aea63ab5e802852e738035b94719.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <7b6678065b33aea63ab5e802852e738035b94719.camel@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 10/09/2020 21:53, Nikolay Aleksandrov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Fri, 2020-10-09 at 14:35 +0000, Henrik Bjoernlund wrote:
> > This is the implementation of CFM netlink configuration
> > set information interface.
> >
> > Add new nested netlink attributes. These attributes are used by the
> > user space to create/delete/configure CFM instances.
> >
> > SETLINK:
> >     IFLA_BRIDGE_CFM:
> >         Indicate that the following attributes are CFM.
> >
> >     IFLA_BRIDGE_CFM_MEP_CREATE:
> >         This indicate that a MEP instance must be created.
> >     IFLA_BRIDGE_CFM_MEP_DELETE:
> >         This indicate that a MEP instance must be deleted.
> >     IFLA_BRIDGE_CFM_MEP_CONFIG:
> >         This indicate that a MEP instance must be configured.
> >     IFLA_BRIDGE_CFM_CC_CONFIG:
> >         This indicate that a MEP instance Continuity Check (CC)
> >         functionality must be configured.
> >     IFLA_BRIDGE_CFM_CC_PEER_MEP_ADD:
> >         This indicate that a CC Peer MEP must be added.
> >     IFLA_BRIDGE_CFM_CC_PEER_MEP_REMOVE:
> >         This indicate that a CC Peer MEP must be removed.
> >     IFLA_BRIDGE_CFM_CC_CCM_TX:
> >         This indicate that the CC transmitted CCM PDU must be configured.
> >     IFLA_BRIDGE_CFM_CC_RDI:
> >         This indicate that the CC transmitted CCM PDU RDI must be
> >         configured.
> >
> > CFM nested attribute has the following attributes in next level.
> >
> > SETLINK RTEXT_FILTER_CFM_CONFIG:
> >     IFLA_BRIDGE_CFM_MEP_CREATE_INSTANCE:
> >         The created MEP instance number.
> >         The type is u32.
> >     IFLA_BRIDGE_CFM_MEP_CREATE_DOMAIN:
> >         The created MEP domain.
> >         The type is u32 (br_cfm_domain).
> >         It must be BR_CFM_PORT.
> >         This means that CFM frames are transmitted and received
> >         directly on the port - untagged. Not in a VLAN.
> >     IFLA_BRIDGE_CFM_MEP_CREATE_DIRECTION:
> >         The created MEP direction.
> >         The type is u32 (br_cfm_mep_direction).
> >         It must be BR_CFM_MEP_DIRECTION_DOWN.
> >         This means that CFM frames are transmitted and received on
> >         the port. Not in the bridge.
> >     IFLA_BRIDGE_CFM_MEP_CREATE_IFINDEX:
> >         The created MEP residence port ifindex.
> >         The type is u32 (ifindex).
> >
> >     IFLA_BRIDGE_CFM_MEP_DELETE_INSTANCE:
> >         The deleted MEP instance number.
> >         The type is u32.
> >
> >     IFLA_BRIDGE_CFM_MEP_CONFIG_INSTANCE:
> >         The configured MEP instance number.
> >         The type is u32.
> >     IFLA_BRIDGE_CFM_MEP_CONFIG_UNICAST_MAC:
> >         The configured MEP unicast MAC address.
> >         The type is 6*u8 (array).
> >         This is used as SMAC in all transmitted CFM frames.
> >     IFLA_BRIDGE_CFM_MEP_CONFIG_MDLEVEL:
> >         The configured MEP unicast MD level.
> >         The type is u32.
> >         It must be in the range 1-7.
> >         No CFM frames are passing through this MEP on lower levels.
> >     IFLA_BRIDGE_CFM_MEP_CONFIG_MEPID:
> >         The configured MEP ID.
> >         The type is u32.
> >         It must be in the range 0-0x1FFF.
> >         This MEP ID is inserted in any transmitted CCM frame.
> >
> >     IFLA_BRIDGE_CFM_CC_CONFIG_INSTANCE:
> >         The configured MEP instance number.
> >         The type is u32.
> >     IFLA_BRIDGE_CFM_CC_CONFIG_ENABLE:
> >         The Continuity Check (CC) functionality is enabled or disabled.
> >         The type is u32 (bool).
> >     IFLA_BRIDGE_CFM_CC_CONFIG_EXP_INTERVAL:
> >         The CC expected receive interval of CCM frames.
> >         The type is u32 (br_cfm_ccm_interval).
> >         This is also the transmission interval of CCM frames when enabled.
> >     IFLA_BRIDGE_CFM_CC_CONFIG_EXP_MAID:
> >         The CC expected receive MAID in CCM frames.
> >         The type is CFM_MAID_LENGTH*u8.
> >         This is MAID is also inserted in transmitted CCM frames.
> >
> >     IFLA_BRIDGE_CFM_CC_PEER_MEP_INSTANCE:
> >         The configured MEP instance number.
> >         The type is u32.
> >     IFLA_BRIDGE_CFM_CC_PEER_MEPID:
> >         The CC Peer MEP ID added.
> >         The type is u32.
> >         When a Peer MEP ID is added and CC is enabled it is expected to
> >         receive CCM frames from that Peer MEP.
> >
> >     IFLA_BRIDGE_CFM_CC_RDI_INSTANCE:
> >         The configured MEP instance number.
> >         The type is u32.
> >     IFLA_BRIDGE_CFM_CC_RDI_RDI:
> >         The RDI that is inserted in transmitted CCM PDU.
> >         The type is u32 (bool).
> >
> >     IFLA_BRIDGE_CFM_CC_CCM_TX_INSTANCE:
> >         The configured MEP instance number.
> >         The type is u32.
> >     IFLA_BRIDGE_CFM_CC_CCM_TX_DMAC:
> >         The transmitted CCM frame destination MAC address.
> >         The type is 6*u8 (array).
> >         This is used as DMAC in all transmitted CFM frames.
> >     IFLA_BRIDGE_CFM_CC_CCM_TX_SEQ_NO_UPDATE:
> >         The transmitted CCM frame update (increment) of sequence
> >         number is enabled or disabled.
> >         The type is u32 (bool).
> >     IFLA_BRIDGE_CFM_CC_CCM_TX_PERIOD:
> >         The period of time where CCM frame are transmitted.
> >         The type is u32.
> >         The time is given in seconds. SETLINK IFLA_BRIDGE_CFM_CC_CCM_TX
> >         must be done before timeout to keep transmission alive.
> >         When period is zero any ongoing CCM frame transmission
> >         will be stopped.
> >     IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV:
> >         The transmitted CCM frame update with Interface Status TLV
> >         is enabled or disabled.
> >         The type is u32 (bool).
> >     IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV_VALUE:
> >         The transmitted Interface Status TLV value field.
> >         The type is u8.
> >     IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV:
> >         The transmitted CCM frame update with Port Status TLV is enabled
> >         or disabled.
> >         The type is u32 (bool).
> >     IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV_VALUE:
> >         The transmitted Port Status TLV value field.
> >         The type is u8.
> >
> > Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
> > Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
> > ---
> >  include/uapi/linux/if_bridge.h |  90 +++++++
> >  include/uapi/linux/rtnetlink.h |   1 +
> >  net/bridge/Makefile            |   2 +-
> >  net/bridge/br_cfm.c            |   5 +
> >  net/bridge/br_cfm_netlink.c    | 458 +++++++++++++++++++++++++++++++++
> >  net/bridge/br_netlink.c        |   5 +
> >  net/bridge/br_private.h        |  17 +-
> >  7 files changed, 576 insertions(+), 2 deletions(-)
> >  create mode 100644 net/bridge/br_cfm_netlink.c
> >
> 
> Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> 

Thanks for the review.

-- 
/Henrik
