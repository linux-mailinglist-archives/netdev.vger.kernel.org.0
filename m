Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692B828B5A4
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 15:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730497AbgJLNL6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 09:11:58 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:3018 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729344AbgJLNL5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 09:11:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602508317; x=1634044317;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3Hrlwix+7SVw9+2v1Fa6CIN5duwOjjNhqPaNRHrObBs=;
  b=nRevLmS37+HGmcrE8xBEYwIZXvylCEYkk/LXnL7Y1rwmc8ngyIrprhQ9
   EKZqsU7u8DppsjaSYPZ88iyux82MF37eISDibF8vsEGyKAVpK3/AEorpU
   M+Q2L3c7o/8sb1BOVst8TaaawSylqEidAoXQaJVGEX4UZJnS5iBdHXFsI
   /rXATvnlDmIYCfVTdPV+XKPXjMVQ4vm1VucpUO2TQNCQ/d/J/GoY1fmZ5
   RkR90vb5YgGTh5n82bZgidK3273bdiPOJscL5Si9WC70bCz5+vz+TsX9d
   qzwswYcOmZ8lrshX3eZYff5dRsgD+llKujX66eDxDo8IvFjcxDpGRTh2k
   Q==;
IronPort-SDR: otditQ9suGkiInK8JXOFxBPR6uzZnouxTaCnNjQQ1cp9oVJLNrWyMNraGbHcXzJcQnCeR2wS4F
 S1oHkZ23W0NU7M2VKFsBpGk6fNx8ZpB1c//5vhAjMa48uu/UhMuE8LPTosat6Kliuc0Bns6NTS
 1ed6OCRsbht9GjkIeUay//aHhVvlVZ4melAglVurOj9IzfG5kM28du/GbpsjTPId6YJyBDENOg
 O8igUwc/pFm9FL66Y2oWxtS478PRak1wJ3wlOXUt/05PLES4wkrjZm9MCKfb4l/oPScfesQCK3
 uNA=
X-IronPort-AV: E=Sophos;i="5.77,366,1596524400"; 
   d="scan'208";a="94260305"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Oct 2020 06:11:57 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 12 Oct 2020 06:11:56 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 12 Oct 2020 06:11:56 -0700
Date:   Mon, 12 Oct 2020 13:10:10 +0000
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
Subject: Re: [PATCH net-next v4 08/10] bridge: cfm: Netlink GET configuration
 Interface.
Message-ID: <20201012131010.lm2gs2k5ovghlqhx@soft-test08>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
 <20201009143530.2438738-9-henrik.bjoernlund@microchip.com>
 <1180153d9d7dc5d5c6af9c2eb32f4052c47e14f3.camel@nvidia.com>
 <8e2e3709f4a0143c99e0f7c8c7a36ac6615b348e.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <8e2e3709f4a0143c99e0f7c8c7a36ac6615b348e.camel@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the review. Comments below.

The 10/09/2020 21:59, Nikolay Aleksandrov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Sat, 2020-10-10 at 00:56 +0300, Nikolay Aleksandrov wrote:
> > On Fri, 2020-10-09 at 14:35 +0000, Henrik Bjoernlund wrote:
> > > This is the implementation of CFM netlink configuration
> > > get information interface.
> > >
> > > Add new nested netlink attributes. These attributes are used by the
> > > user space to get configuration information.
> > >
> > > GETLINK:
> > >     Request filter RTEXT_FILTER_CFM_CONFIG:
> > >     Indicating that CFM configuration information must be delivered.
> > >
> > >     IFLA_BRIDGE_CFM:
> > >         Points to the CFM information.
> > >
> > >     IFLA_BRIDGE_CFM_MEP_CREATE_INFO:
> > >         This indicate that MEP instance create parameters are following.
> > >     IFLA_BRIDGE_CFM_MEP_CONFIG_INFO:
> > >         This indicate that MEP instance config parameters are following.
> > >     IFLA_BRIDGE_CFM_CC_CONFIG_INFO:
> > >         This indicate that MEP instance CC functionality
> > >         parameters are following.
> > >     IFLA_BRIDGE_CFM_CC_RDI_INFO:
> > >         This indicate that CC transmitted CCM PDU RDI
> > >         parameters are following.
> > >     IFLA_BRIDGE_CFM_CC_CCM_TX_INFO:
> > >         This indicate that CC transmitted CCM PDU parameters are
> > >         following.
> > >     IFLA_BRIDGE_CFM_CC_PEER_MEP_INFO:
> > >         This indicate that the added peer MEP IDs are following.
> > >
> > > CFM nested attribute has the following attributes in next level.
> > >
> > > GETLINK RTEXT_FILTER_CFM_CONFIG:
> > >     IFLA_BRIDGE_CFM_MEP_CREATE_INSTANCE:
> > >         The created MEP instance number.
> > >         The type is u32.
> > >     IFLA_BRIDGE_CFM_MEP_CREATE_DOMAIN:
> > >         The created MEP domain.
> > >         The type is u32 (br_cfm_domain).
> > >         It must be BR_CFM_PORT.
> > >         This means that CFM frames are transmitted and received
> > >         directly on the port - untagged. Not in a VLAN.
> > >     IFLA_BRIDGE_CFM_MEP_CREATE_DIRECTION:
> > >         The created MEP direction.
> > >         The type is u32 (br_cfm_mep_direction).
> > >         It must be BR_CFM_MEP_DIRECTION_DOWN.
> > >         This means that CFM frames are transmitted and received on
> > >         the port. Not in the bridge.
> > >     IFLA_BRIDGE_CFM_MEP_CREATE_IFINDEX:
> > >         The created MEP residence port ifindex.
> > >         The type is u32 (ifindex).
> > >
> > >     IFLA_BRIDGE_CFM_MEP_DELETE_INSTANCE:
> > >         The deleted MEP instance number.
> > >         The type is u32.
> > >
> > >     IFLA_BRIDGE_CFM_MEP_CONFIG_INSTANCE:
> > >         The configured MEP instance number.
> > >         The type is u32.
> > >     IFLA_BRIDGE_CFM_MEP_CONFIG_UNICAST_MAC:
> > >         The configured MEP unicast MAC address.
> > >         The type is 6*u8 (array).
> > >         This is used as SMAC in all transmitted CFM frames.
> > >     IFLA_BRIDGE_CFM_MEP_CONFIG_MDLEVEL:
> > >         The configured MEP unicast MD level.
> > >         The type is u32.
> > >         It must be in the range 1-7.
> > >         No CFM frames are passing through this MEP on lower levels.
> > >     IFLA_BRIDGE_CFM_MEP_CONFIG_MEPID:
> > >         The configured MEP ID.
> > >         The type is u32.
> > >         It must be in the range 0-0x1FFF.
> > >         This MEP ID is inserted in any transmitted CCM frame.
> > >
> > >     IFLA_BRIDGE_CFM_CC_CONFIG_INSTANCE:
> > >         The configured MEP instance number.
> > >         The type is u32.
> > >     IFLA_BRIDGE_CFM_CC_CONFIG_ENABLE:
> > >         The Continuity Check (CC) functionality is enabled or disabled.
> > >         The type is u32 (bool).
> > >     IFLA_BRIDGE_CFM_CC_CONFIG_EXP_INTERVAL:
> > >         The CC expected receive interval of CCM frames.
> > >         The type is u32 (br_cfm_ccm_interval).
> > >         This is also the transmission interval of CCM frames when enabled.
> > >     IFLA_BRIDGE_CFM_CC_CONFIG_EXP_MAID:
> > >         The CC expected receive MAID in CCM frames.
> > >         The type is CFM_MAID_LENGTH*u8.
> > >         This is MAID is also inserted in transmitted CCM frames.
> > >
> > >     IFLA_BRIDGE_CFM_CC_PEER_MEP_INSTANCE:
> > >         The configured MEP instance number.
> > >         The type is u32.
> > >     IFLA_BRIDGE_CFM_CC_PEER_MEPID:
> > >         The CC Peer MEP ID added.
> > >         The type is u32.
> > >         When a Peer MEP ID is added and CC is enabled it is expected to
> > >         receive CCM frames from that Peer MEP.
> > >
> > >     IFLA_BRIDGE_CFM_CC_RDI_INSTANCE:
> > >         The configured MEP instance number.
> > >         The type is u32.
> > >     IFLA_BRIDGE_CFM_CC_RDI_RDI:
> > >         The RDI that is inserted in transmitted CCM PDU.
> > >         The type is u32 (bool).
> > >
> > >     IFLA_BRIDGE_CFM_CC_CCM_TX_INSTANCE:
> > >         The configured MEP instance number.
> > >         The type is u32.
> > >     IFLA_BRIDGE_CFM_CC_CCM_TX_DMAC:
> > >         The transmitted CCM frame destination MAC address.
> > >         The type is 6*u8 (array).
> > >         This is used as DMAC in all transmitted CFM frames.
> > >     IFLA_BRIDGE_CFM_CC_CCM_TX_SEQ_NO_UPDATE:
> > >         The transmitted CCM frame update (increment) of sequence
> > >         number is enabled or disabled.
> > >         The type is u32 (bool).
> > >     IFLA_BRIDGE_CFM_CC_CCM_TX_PERIOD:
> > >         The period of time where CCM frame are transmitted.
> > >         The type is u32.
> > >         The time is given in seconds. SETLINK IFLA_BRIDGE_CFM_CC_CCM_TX
> > >         must be done before timeout to keep transmission alive.
> > >         When period is zero any ongoing CCM frame transmission
> > >         will be stopped.
> > >     IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV:
> > >         The transmitted CCM frame update with Interface Status TLV
> > >         is enabled or disabled.
> > >         The type is u32 (bool).
> > >     IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV_VALUE:
> > >         The transmitted Interface Status TLV value field.
> > >         The type is u8.
> > >     IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV:
> > >         The transmitted CCM frame update with Port Status TLV is enabled
> > >         or disabled.
> > >         The type is u32 (bool).
> > >     IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV_VALUE:
> > >         The transmitted Port Status TLV value field.
> > >         The type is u8.
> > >
> > > Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
> > > Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
> > > ---
> > >  include/uapi/linux/if_bridge.h |   6 ++
> > >  net/bridge/br_cfm_netlink.c    | 161 +++++++++++++++++++++++++++++++++
> > >  net/bridge/br_netlink.c        |  29 +++++-
> > >  net/bridge/br_private.h        |   6 ++
> > >  4 files changed, 200 insertions(+), 2 deletions(-)
> > >
> >
> > Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> >
> 
> I missed this until now, but the local variables need to
> be arranged in reverse xmas tree (longest to shortest) in
> br_cfm_config_fill_info().
> 
I changed this as requested.
> 

-- 
/Henrik
