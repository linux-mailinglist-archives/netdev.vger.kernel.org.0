Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5CF26A28B
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 11:51:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgIOJv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 05:51:57 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:26568 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbgIOJvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 05:51:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1600163513; x=1631699513;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=J3nTx9MVCcozv6gxZb0/clByzrBBXGog8z2lWqsaNx8=;
  b=gp/K75AiZlJNdCnfwbdX/Kku7OsD8gH+7BoZfGjhgtDFHld+szTz7nGL
   cuAR4t50lHN5/F2hrFBjvKZmxoiCiwZd4hYs1r7K+t20EyCEeUlbmQKep
   1Nb0GRoNrfdYWfhVuHZ2c+i7KC4iW29dQlaOubRA+FmNoKWOYIHMFxsl/
   /svbsSOei2nCw6eV51WKWj9Rsax1v1ZsJ00/K901wtkSoc8eAkiLuRBy3
   dQZRTecr0tc81gYiEIm0aWYX2Sf6QDCqtXlofS/MdrbQnSQks19pJxz6L
   zLXQBBeme4nSwOA5LX3lFw/eIhjohpYsYqEllw5t5isI6851OH8SvInyr
   Q==;
IronPort-SDR: IXy+wjg3QMPe+WU61IyNjiRmARocdaApeVgfqSdW6pZnUoci2Ih0rEV0LYwe9E3q+Q7AMU8OJP
 o1XC4OEemlCtLlb+r/jLpXosGUb7H+lNiLYh79OIAffCNNZt2HcxrMM8F+HKMEr2o9Ekb9F4Pe
 FTUWV3x0lyJJCriFnAVrVvyHtnN7jq3uIz1Bib9NMjZH+w6NX5mudWZCD7VMpLD4qiixmXQbgI
 C9F4VFButn5aNgbLTJE12CM2aESzgXKew5IltbwD1WE9f7A0rghY9J95ROOnEU06Y9hjeeEDaW
 ZMo=
X-IronPort-AV: E=Sophos;i="5.76,429,1592895600"; 
   d="scan'208";a="89122881"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Sep 2020 02:51:53 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Sep 2020 02:51:51 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 15 Sep 2020 02:51:50 -0700
Date:   Tue, 15 Sep 2020 09:49:16 +0000
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
Subject: Re: [PATCH RFC 5/7] bridge: cfm: Netlink Interface.
Message-ID: <20200915094916.mh62lydni45c3cge@soft-test08>
References: <20200904091527.669109-1-henrik.bjoernlund@microchip.com>
 <20200904091527.669109-6-henrik.bjoernlund@microchip.com>
 <c4d53859b95f3933406cc6dc869ca9d6eac4a4dc.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <c4d53859b95f3933406cc6dc869ca9d6eac4a4dc.camel@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the review. Comments below.

The 09/08/2020 13:47, Nikolay Aleksandrov wrote:
> 
> On Fri, 2020-09-04 at 09:15 +0000, Henrik Bjoernlund wrote:
> > This is the implementation of CFM netlink configuration
> > and status information interface.
> >
> > Add new nested netlink attributes. These attributes are used by the
> > user space to create/delete/configure CFM instances and get status.
> > Also they are used by the kernel to notify the user space when changes
> > in any status happens.
> [snip]
> >       __u64 transition_fwd;
> > diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
> > index 9b814c92de12..fdd408f6a5d2 100644
> > --- a/include/uapi/linux/rtnetlink.h
> > +++ b/include/uapi/linux/rtnetlink.h
> > @@ -779,6 +779,8 @@ enum {
> >  #define RTEXT_FILTER_BRVLAN_COMPRESSED       (1 << 2)
> >  #define      RTEXT_FILTER_SKIP_STATS (1 << 3)
> >  #define RTEXT_FILTER_MRP     (1 << 4)
> > +#define RTEXT_FILTER_CFM_CONFIG      (1 << 5)
> > +#define RTEXT_FILTER_CFM_STATUS      (1 << 6)
> >
> >  /* End of information exported to user level */
> >
> > diff --git a/net/bridge/Makefile b/net/bridge/Makefile
> > index ddc0a9192348..4702702a74d3 100644
> > --- a/net/bridge/Makefile
> > +++ b/net/bridge/Makefile
> > @@ -28,4 +28,4 @@ obj-$(CONFIG_NETFILTER) += netfilter/
> >
> >  bridge-$(CONFIG_BRIDGE_MRP)  += br_mrp_switchdev.o br_mrp.o br_mrp_netlink.o
> >
> > -bridge-$(CONFIG_BRIDGE_CFM)  += br_cfm.o
> > +bridge-$(CONFIG_BRIDGE_CFM)  += br_cfm.o br_cfm_netlink.o
> > diff --git a/net/bridge/br_cfm_netlink.c b/net/bridge/br_cfm_netlink.c
> > new file mode 100644
> > index 000000000000..4e39aab1cd0b
> > --- /dev/null
> > +++ b/net/bridge/br_cfm_netlink.c
> > @@ -0,0 +1,684 @@
> > +// SPDX-License-Identifier: GPL-2.0-or-later
> > +
> > +#include <net/genetlink.h>
> > +
> > +#include "br_private.h"
> > +#include "br_private_cfm.h"
> > +
> > +static inline struct mac_addr nla_get_mac(const struct nlattr *nla)
> > +{
> > +     struct mac_addr mac;
> > +
> > +     nla_memcpy(&mac.addr, nla, sizeof(mac.addr));
> > +
> > +     return mac;
> > +}
> > +
> > +static inline struct br_cfm_maid nla_get_maid(const struct nlattr *nla)
> > +{
> > +     struct br_cfm_maid maid;
> > +
> > +     nla_memcpy(&maid.data, nla, sizeof(maid.data));
> > +
> > +     return maid;
> > +}
> 
> IMO, these 1-line helpers don't really help readability.
>
I think they make a difference - you can write nicely in one line:
config.unicast_mac = nla_get_mac(tb[IFLA_BRIDGE_CFM_MEP_CONFIG_UNICAST_MAC]);
Also you can argue the same with functions nla_get_u32() and nla_get_u8 () they are one liner functions.
I you think it must be changed I will ofc do it.

> > +
> > +static inline int nla_put_u64(struct sk_buff *skb, int attrtype, u64 value)
> > +{
> > +     u64 tmp = value;
> > +
> > +     return nla_put(skb, attrtype, sizeof(u64), &tmp);
> > +}
> 
> What?! Read include/net/netlink.h
> 
I have removed this. Not used anyway.

> > +
> > +static const struct nla_policy
> > +br_cfm_policy[IFLA_BRIDGE_CFM_MAX + 1] = {
> > +     [IFLA_BRIDGE_CFM_UNSPEC]                = { .type = NLA_REJECT },
> > +     [IFLA_BRIDGE_CFM_MEP_CREATE]            = { .type = NLA_NESTED },
> > +     [IFLA_BRIDGE_CFM_MEP_DELETE]            = { .type = NLA_NESTED },
> > +     [IFLA_BRIDGE_CFM_MEP_CONFIG]            = { .type = NLA_NESTED },
> > +     [IFLA_BRIDGE_CFM_CC_CONFIG]             = { .type = NLA_NESTED },
> > +     [IFLA_BRIDGE_CFM_CC_PEER_MEP_ADD]       = { .type = NLA_NESTED },
> > +     [IFLA_BRIDGE_CFM_CC_PEER_MEP_REMOVE]    = { .type = NLA_NESTED },
> > +     [IFLA_BRIDGE_CFM_CC_RDI]                = { .type = NLA_NESTED },
> > +     [IFLA_BRIDGE_CFM_CC_CCM_TX]             = { .type = NLA_NESTED },
> > +};
> > +
> > +static const struct nla_policy
> > +br_cfm_mep_create_policy[IFLA_BRIDGE_CFM_MEP_CREATE_MAX + 1] = {
> > +     [IFLA_BRIDGE_CFM_MEP_CREATE_UNSPEC]     = { .type = NLA_REJECT },
> > +     [IFLA_BRIDGE_CFM_MEP_CREATE_INSTANCE]   = { .type = NLA_U32 },
> > +     [IFLA_BRIDGE_CFM_MEP_CREATE_DOMAIN]     = { .type = NLA_U32 },
> > +     [IFLA_BRIDGE_CFM_MEP_CREATE_DIRECTION]  = { .type = NLA_U32 },
> > +     [IFLA_BRIDGE_CFM_MEP_CREATE_IFINDEX]    = { .type = NLA_U32 },
> > +};
> > +
> > +static const struct nla_policy
> > +br_cfm_mep_delete_policy[IFLA_BRIDGE_CFM_MEP_DELETE_MAX + 1] = {
> > +     [IFLA_BRIDGE_CFM_MEP_DELETE_UNSPEC]     = { .type = NLA_REJECT },
> > +     [IFLA_BRIDGE_CFM_MEP_DELETE_INSTANCE]   = { .type = NLA_U32 },
> > +};
> > +
> > +static const struct nla_policy
> > +br_cfm_mep_config_policy[IFLA_BRIDGE_CFM_MEP_CONFIG_MAX + 1] = {
> > +     [IFLA_BRIDGE_CFM_MEP_CONFIG_UNSPEC]             = { .type = NLA_REJECT },
> > +     [IFLA_BRIDGE_CFM_MEP_CONFIG_INSTANCE]           = { .type = NLA_U32 },
> > +     [IFLA_BRIDGE_CFM_MEP_CONFIG_UNICAST_MAC]        = NLA_POLICY_ETH_ADDR,
> > +     [IFLA_BRIDGE_CFM_MEP_CONFIG_MDLEVEL]            = { .type = NLA_U32 },
> > +     [IFLA_BRIDGE_CFM_MEP_CONFIG_MEPID]              = { .type = NLA_U32 },
> > +};
> > +
> > +static const struct nla_policy
> > +br_cfm_cc_config_policy[IFLA_BRIDGE_CFM_CC_CONFIG_MAX + 1] = {
> > +     [IFLA_BRIDGE_CFM_CC_CONFIG_UNSPEC]              = { .type = NLA_REJECT },
> > +     [IFLA_BRIDGE_CFM_CC_CONFIG_INSTANCE]            = { .type = NLA_U32 },
> > +     [IFLA_BRIDGE_CFM_CC_CONFIG_ENABLE]              = { .type = NLA_U32 },
> > +     [IFLA_BRIDGE_CFM_CC_CONFIG_EXP_INTERVAL]        = { .type = NLA_U32 },
> > +     [IFLA_BRIDGE_CFM_CC_CONFIG_EXP_MAID]    = {
> > +     .type = NLA_BINARY, .len = CFM_MAID_LENGTH },
> > +};
> > +
> > +static const struct nla_policy
> > +br_cfm_cc_peer_mep_policy[IFLA_BRIDGE_CFM_CC_PEER_MEP_MAX + 1] = {
> > +     [IFLA_BRIDGE_CFM_CC_PEER_MEP_UNSPEC]    = { .type = NLA_REJECT },
> > +     [IFLA_BRIDGE_CFM_CC_PEER_MEP_INSTANCE]  = { .type = NLA_U32 },
> > +     [IFLA_BRIDGE_CFM_CC_PEER_MEPID]         = { .type = NLA_U32 },
> > +};
> > +
> > +static const struct nla_policy
> > +br_cfm_cc_rdi_policy[IFLA_BRIDGE_CFM_CC_RDI_MAX + 1] = {
> > +     [IFLA_BRIDGE_CFM_CC_RDI_UNSPEC]         = { .type = NLA_REJECT },
> > +     [IFLA_BRIDGE_CFM_CC_RDI_INSTANCE]       = { .type = NLA_U32 },
> > +     [IFLA_BRIDGE_CFM_CC_RDI_RDI]            = { .type = NLA_U32 },
> > +};
> > +
> > +static const struct nla_policy
> > +br_cfm_cc_ccm_tx_policy[IFLA_BRIDGE_CFM_CC_CCM_TX_MAX + 1] = {
> > +     [IFLA_BRIDGE_CFM_CC_CCM_TX_UNSPEC]              = { .type = NLA_REJECT },
> > +     [IFLA_BRIDGE_CFM_CC_CCM_TX_INSTANCE]            = { .type = NLA_U32 },
> > +     [IFLA_BRIDGE_CFM_CC_CCM_TX_DMAC]                = NLA_POLICY_ETH_ADDR,
> > +     [IFLA_BRIDGE_CFM_CC_CCM_TX_SEQ_NO_UPDATE]       = { .type = NLA_U32 },
> > +     [IFLA_BRIDGE_CFM_CC_CCM_TX_PERIOD]              = { .type = NLA_U32 },
> > +     [IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV]              = { .type = NLA_U32 },
> > +     [IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV_VALUE]        = { .type = NLA_U8 },
> > +     [IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV]            = { .type = NLA_U32 },
> > +     [IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV_VALUE]      = { .type = NLA_U8 },
> > +};
> > +
> > +static int br_mep_create_parse(struct net_bridge *br, struct nlattr *attr,
> > +                            struct netlink_ext_ack *extack)
> > +{
> > +     struct nlattr *tb[IFLA_BRIDGE_CFM_MEP_CREATE_MAX + 1];
> > +     struct br_cfm_mep_create create;
> > +     u32 instance;
> > +     int err;
> > +
> > +     err = nla_parse_nested(tb, IFLA_BRIDGE_CFM_MEP_CREATE_MAX, attr,
> > +                            br_cfm_mep_create_policy, extack);
> > +     if (err)
> > +             return err;
> > +
> > +     if (!tb[IFLA_BRIDGE_CFM_MEP_CREATE_INSTANCE] ||
> > +         !tb[IFLA_BRIDGE_CFM_MEP_CREATE_DOMAIN] ||
> > +         !tb[IFLA_BRIDGE_CFM_MEP_CREATE_DIRECTION] ||
> > +         !tb[IFLA_BRIDGE_CFM_MEP_CREATE_IFINDEX]) {
> > +             NL_SET_ERR_MSG_MOD(extack,
> > +                                "Missing attribute: INSTANCE or DOMAIN or DIRECTION or VID or IFINDEX");
> 
> Break these into separate errors.
> 
> > +             return -EINVAL;
> > +     }
> > +
> > +     memset(&create, 0, sizeof(create));
> > +
> > +     instance =  nla_get_u32(tb[IFLA_BRIDGE_CFM_MEP_CREATE_INSTANCE]);
> > +     create.domain = nla_get_u32(tb[IFLA_BRIDGE_CFM_MEP_CREATE_DOMAIN]);
> > +     create.direction = nla_get_u32(tb[IFLA_BRIDGE_CFM_MEP_CREATE_DIRECTION]);
> > +     create.ifindex = nla_get_u32(tb[IFLA_BRIDGE_CFM_MEP_CREATE_IFINDEX]);
> > +
> > +     return br_cfm_mep_create(br, instance, &create, extack);
> > +}
> > +
> > +static int br_mep_delete_parse(struct net_bridge *br, struct nlattr *attr,
> > +                            struct netlink_ext_ack *extack)
> > +{
> > +     struct nlattr *tb[IFLA_BRIDGE_CFM_MEP_DELETE_MAX + 1];
> > +     u32 instance;
> > +     int err;
> > +
> > +     err = nla_parse_nested(tb, IFLA_BRIDGE_CFM_MEP_DELETE_MAX, attr,
> > +                            br_cfm_mep_delete_policy, extack);
> > +     if (err)
> > +             return err;
> > +
> > +     if (!tb[IFLA_BRIDGE_CFM_MEP_CREATE_INSTANCE]) {
> > +             NL_SET_ERR_MSG_MOD(extack,
> > +                                "Missing attribute: INSTANCE");
> 
> "Missing instance attribute". Same for all similar messages.
> 
I will change that as suggested.

> > +             return -EINVAL;
> > +     }
> > +
> > +     instance =  nla_get_u32(tb[IFLA_BRIDGE_CFM_MEP_CREATE_INSTANCE]);
> > +
> > +     return br_cfm_mep_delete(br, instance, extack);
> > +}
> > +
> > +static int br_mep_config_parse(struct net_bridge *br, struct nlattr *attr,
> > +                            struct netlink_ext_ack *extack)
> > +{
> > +     struct nlattr *tb[IFLA_BRIDGE_CFM_MEP_CONFIG_MAX + 1];
> > +     struct br_cfm_mep_config config;
> > +     u32 instance;
> > +     int err;
> > +
> > +     err = nla_parse_nested(tb, IFLA_BRIDGE_CFM_MEP_CONFIG_MAX, attr,
> > +                            br_cfm_mep_config_policy, extack);
> > +     if (err)
> > +             return err;
> > +
> > +     if (!tb[IFLA_BRIDGE_CFM_MEP_CONFIG_INSTANCE] ||
> > +         !tb[IFLA_BRIDGE_CFM_MEP_CONFIG_UNICAST_MAC] ||
> > +         !tb[IFLA_BRIDGE_CFM_MEP_CONFIG_MDLEVEL] ||
> > +         !tb[IFLA_BRIDGE_CFM_MEP_CONFIG_MEPID]) {
> > +             NL_SET_ERR_MSG_MOD(extack,
> > +                                "Missing attribute: INSTANCE or UNICAST_MAC or MDLEVEL or MEPID or VID");
> 
> Break these into separate errors.
> 
I will change that as suggested.

> > +             return -EINVAL;
> > +     }
> > +
> > +     memset(&config, 0, sizeof(config));
> > +
> > +     instance =  nla_get_u32(tb[IFLA_BRIDGE_CFM_MEP_CONFIG_INSTANCE]);
> > +     config.unicast_mac = nla_get_mac(tb[IFLA_BRIDGE_CFM_MEP_CONFIG_UNICAST_MAC]);
> > +     config.mdlevel = nla_get_u32(tb[IFLA_BRIDGE_CFM_MEP_CONFIG_MDLEVEL]);
> > +     config.mepid = nla_get_u32(tb[IFLA_BRIDGE_CFM_MEP_CONFIG_MEPID]);
> > +     config.vid = 0;
> > +
> > +     return br_cfm_mep_config_set(br, instance, &config, extack);
> > +}
> > +
> > +static int br_cc_config_parse(struct net_bridge *br, struct nlattr *attr,
> > +                           struct netlink_ext_ack *extack)
> > +{
> > +     struct nlattr *tb[IFLA_BRIDGE_CFM_CC_CONFIG_MAX + 1];
> > +     struct br_cfm_cc_config config;
> > +     u32 instance;
> > +     int err;
> > +
> > +     err = nla_parse_nested(tb, IFLA_BRIDGE_CFM_CC_CONFIG_MAX, attr,
> > +                            br_cfm_cc_config_policy, extack);
> > +     if (err)
> > +             return err;
> > +
> > +     if (!tb[IFLA_BRIDGE_CFM_CC_CONFIG_INSTANCE] ||
> > +         !tb[IFLA_BRIDGE_CFM_CC_CONFIG_ENABLE] ||
> > +         !tb[IFLA_BRIDGE_CFM_CC_CONFIG_EXP_INTERVAL] ||
> > +         !tb[IFLA_BRIDGE_CFM_CC_CONFIG_EXP_MAID]) {
> > +             NL_SET_ERR_MSG_MOD(extack,
> > +                                "Missing attribute: INSTANCE or ENABLE or INTERVAL or PRIORITY or MAID");
> 
> Break these into separate errors.
> 
I will change that as suggested.

> > +             return -EINVAL;
> > +     }
> > +
> > +     memset(&config, 0, sizeof(config));
> > +
> > +     instance =  nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_CONFIG_INSTANCE]);
> > +     config.enable = nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_CONFIG_ENABLE]);
> > +     config.exp_interval = nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_CONFIG_EXP_INTERVAL]);
> > +     config.exp_priority = 0;
> > +     config.exp_maid = nla_get_maid(tb[IFLA_BRIDGE_CFM_CC_CONFIG_EXP_MAID]);
> > +
> > +     return br_cfm_cc_config_set(br, instance, &config, extack);
> > +}
> > +
> > +static int br_cc_peer_mep_add_parse(struct net_bridge *br, struct nlattr *attr,
> > +                                 struct netlink_ext_ack *extack)
> > +{
> > +     struct nlattr *tb[IFLA_BRIDGE_CFM_CC_PEER_MEP_MAX + 1];
> > +     u32 instance, peer_mep_id;
> > +     int err;
> > +
> > +     err = nla_parse_nested(tb, IFLA_BRIDGE_CFM_CC_PEER_MEP_MAX, attr,
> > +                            br_cfm_cc_peer_mep_policy, extack);
> > +     if (err)
> > +             return err;
> > +
> > +     if (!tb[IFLA_BRIDGE_CFM_CC_PEER_MEP_INSTANCE] ||
> > +         !tb[IFLA_BRIDGE_CFM_CC_PEER_MEPID]) {
> > +             NL_SET_ERR_MSG_MOD(extack,
> > +                                "Missing attribute: INSTANCE or PEER_MEP_ID");
> 
> Break these into separate errors.
> 
I will change that as suggested.

> > +             return -EINVAL;
> > +     }
> > +
> > +     instance =  nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_PEER_MEP_INSTANCE]);
> > +     peer_mep_id =  nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_PEER_MEPID]);
> > +
> > +     return br_cfm_cc_peer_mep_add(br, instance, peer_mep_id, extack);
> > +}
> > +
> > +static int br_cc_peer_mep_remove_parse(struct net_bridge *br, struct nlattr *attr,
> > +                                    struct netlink_ext_ack *extack)
> > +{
> > +     struct nlattr *tb[IFLA_BRIDGE_CFM_CC_PEER_MEP_MAX + 1];
> > +     u32 instance, peer_mep_id;
> > +     int err;
> > +
> > +     err = nla_parse_nested(tb, IFLA_BRIDGE_CFM_CC_PEER_MEP_MAX, attr,
> > +                            br_cfm_cc_peer_mep_policy, extack);
> > +     if (err)
> > +             return err;
> > +
> > +     if (!tb[IFLA_BRIDGE_CFM_CC_PEER_MEP_INSTANCE] ||
> > +         !tb[IFLA_BRIDGE_CFM_CC_PEER_MEPID]) {
> > +             NL_SET_ERR_MSG_MOD(extack,
> > +                                "Missing attribute: INSTANCE or PEER_MEP_ID");
> 
> Break these into separate errors.
> 
I will change that as suggested.

> > +             return -EINVAL;
> > +     }
> > +
> > +     instance =  nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_PEER_MEP_INSTANCE]);
> > +     peer_mep_id =  nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_PEER_MEPID]);
> > +
> > +     return br_cfm_cc_peer_mep_remove(br, instance, peer_mep_id, extack);
> > +}
> > +
> > +static int br_cc_rdi_parse(struct net_bridge *br, struct nlattr *attr,
> > +                        struct netlink_ext_ack *extack)
> > +{
> > +     struct nlattr *tb[IFLA_BRIDGE_CFM_CC_RDI_MAX + 1];
> > +     u32 instance, rdi;
> > +     int err;
> > +
> > +     err = nla_parse_nested(tb, IFLA_BRIDGE_CFM_CC_RDI_MAX, attr,
> > +                            br_cfm_cc_rdi_policy, extack);
> > +     if (err)
> > +             return err;
> > +
> > +     if (!tb[IFLA_BRIDGE_CFM_CC_RDI_INSTANCE] ||
> > +         !tb[IFLA_BRIDGE_CFM_CC_RDI_RDI]) {
> > +             NL_SET_ERR_MSG_MOD(extack,
> > +                                "Missing attribute: INSTANCE or RDI");
> 
> Break these into separate errors.
> 
I will change that as suggested.

> > +             return -EINVAL;
> > +     }
> > +
> > +     instance =  nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_RDI_INSTANCE]);
> > +     rdi =  nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_RDI_RDI]);
> > +
> > +     return br_cfm_cc_rdi_set(br, instance, rdi, extack);
> > +}
> > +
> > +static int br_cc_ccm_tx_parse(struct net_bridge *br, struct nlattr *attr,
> > +                           struct netlink_ext_ack *extack)
> > +{
> > +     struct nlattr *tb[IFLA_BRIDGE_CFM_CC_CCM_TX_MAX + 1];
> > +     u32 instance;
> > +     struct br_cfm_cc_ccm_tx_info tx_info;
> > +     int err;
> > +
> > +     err = nla_parse_nested(tb, IFLA_BRIDGE_CFM_CC_CCM_TX_MAX, attr,
> > +                            br_cfm_cc_ccm_tx_policy, extack);
> > +     if (err)
> > +             return err;
> > +
> > +     if (!tb[IFLA_BRIDGE_CFM_CC_CCM_TX_INSTANCE] ||
> > +         !tb[IFLA_BRIDGE_CFM_CC_CCM_TX_DMAC] ||
> > +         !tb[IFLA_BRIDGE_CFM_CC_CCM_TX_SEQ_NO_UPDATE] ||
> > +         !tb[IFLA_BRIDGE_CFM_CC_CCM_TX_PERIOD] ||
> > +         !tb[IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV] ||
> > +         !tb[IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV_VALUE] ||
> > +         !tb[IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV] ||
> > +         !tb[IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV_VALUE]) {
> > +             NL_SET_ERR_MSG_MOD(extack,
> > +                                "Missing attribute: INSTANCE or PRIORITY or DEI or DMAC or SEQ_NO_UPDATE or PERIOD or IF_TLV or IF_TLV_VALUE or PORT_TLV or PORT_TLV_VALUE");
> 
> Break these into separate errors.
> 
I will change that as suggested.

> > +             return -EINVAL;
> > +     }
> > +
> > +     instance = nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_RDI_INSTANCE]);
> > +     tx_info.priority = 0;
> > +     tx_info.dei = 0;
> > +     tx_info.dmac = nla_get_mac(tb[IFLA_BRIDGE_CFM_CC_CCM_TX_DMAC]);
> > +     tx_info.seq_no_update = nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_CCM_TX_SEQ_NO_UPDATE]);
> > +     tx_info.period = nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_CCM_TX_PERIOD]);
> > +     tx_info.if_tlv = nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV]);
> > +     tx_info.if_tlv_value = nla_get_u8(tb[IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV_VALUE]);
> > +     tx_info.port_tlv = nla_get_u32(tb[IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV]);
> > +     tx_info.port_tlv_value = nla_get_u8(tb[IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV_VALUE]);
> > +
> > +     return br_cfm_cc_ccm_tx(br, instance, &tx_info, extack);
> > +}
> > +
> > +int br_cfm_parse(struct net_bridge *br, struct net_bridge_port *p,
> > +              struct nlattr *attr, int cmd, struct netlink_ext_ack *extack)
> > +{
> > +     struct nlattr *tb[IFLA_BRIDGE_CFM_MAX + 1];
> > +     int err;
> > +
> > +     /* When this function is called for a port then the br pointer is
> > +      * invalid, therefor set the br to point correctly
> > +      */
> > +     if (p)
> > +             br = p->br;
> > +
> > +     err = nla_parse_nested(tb, IFLA_BRIDGE_CFM_MAX, attr,
> > +                            br_cfm_policy, extack);
> > +     if (err)
> > +             return err;
> > +
> > +     if (tb[IFLA_BRIDGE_CFM_MEP_CREATE]) {
> > +             err = br_mep_create_parse(br, tb[IFLA_BRIDGE_CFM_MEP_CREATE],
> > +                                       extack);
> > +             if (err)
> > +                     return err;
> > +     }
> > +
> > +     if (tb[IFLA_BRIDGE_CFM_MEP_DELETE]) {
> > +             err = br_mep_delete_parse(br, tb[IFLA_BRIDGE_CFM_MEP_DELETE],
> > +                                       extack);
> > +             if (err)
> > +                     return err;
> > +     }
> > +
> > +     if (tb[IFLA_BRIDGE_CFM_MEP_CONFIG]) {
> > +             err = br_mep_config_parse(br, tb[IFLA_BRIDGE_CFM_MEP_CONFIG],
> > +                                       extack);
> > +             if (err)
> > +                     return err;
> > +     }
> > +
> > +     if (tb[IFLA_BRIDGE_CFM_CC_CONFIG]) {
> > +             err = br_cc_config_parse(br, tb[IFLA_BRIDGE_CFM_CC_CONFIG],
> > +                                      extack);
> > +             if (err)
> > +                     return err;
> > +     }
> > +
> > +     if (tb[IFLA_BRIDGE_CFM_CC_PEER_MEP_ADD]) {
> > +             err = br_cc_peer_mep_add_parse(br, tb[IFLA_BRIDGE_CFM_CC_PEER_MEP_ADD],
> > +                                            extack);
> > +             if (err)
> > +                     return err;
> > +     }
> > +
> > +     if (tb[IFLA_BRIDGE_CFM_CC_PEER_MEP_REMOVE]) {
> > +             err = br_cc_peer_mep_remove_parse(br, tb[IFLA_BRIDGE_CFM_CC_PEER_MEP_REMOVE],
> > +                                               extack);
> > +             if (err)
> > +                     return err;
> > +     }
> > +
> > +     if (tb[IFLA_BRIDGE_CFM_CC_RDI]) {
> > +             err = br_cc_rdi_parse(br, tb[IFLA_BRIDGE_CFM_CC_RDI],
> > +                                   extack);
> > +             if (err)
> > +                     return err;
> > +     }
> > +
> > +     if (tb[IFLA_BRIDGE_CFM_CC_CCM_TX]) {
> > +             err = br_cc_ccm_tx_parse(br, tb[IFLA_BRIDGE_CFM_CC_CCM_TX],
> > +                                      extack);
> > +             if (err)
> > +                     return err;
> > +     }
> > +
> > +     return 0;
> > +}
> > +
> > +int br_cfm_config_fill_info(struct sk_buff *skb, struct net_bridge *br)
> > +{
> > +     struct nlattr *tb, *cfm_tb;
> > +     struct br_cfm_mep *mep;
> > +     struct br_cfm_peer_mep *peer_mep;
> > +
> > +     cfm_tb = nla_nest_start_noflag(skb, IFLA_BRIDGE_CFM);
> 
> Why _noflag everywhere?
> 
I will change that to nla_nest_start().

> > +     if (!cfm_tb)
> > +             return -EMSGSIZE;
> > +
> > +     list_for_each_entry_rcu(mep, &br->mep_list, head) {
> > +             tb = nla_nest_start_noflag(skb, IFLA_BRIDGE_CFM_MEP_CREATE_INFO);
> > +             if (!tb)
> > +                     goto nla_info_failure;
> > +
> > +             if (nla_put_u32(skb, IFLA_BRIDGE_CFM_MEP_CREATE_INSTANCE,
> > +                             mep->instance))
> > +                     goto nla_put_failure;
> > +
> > +             if (nla_put_u32(skb, IFLA_BRIDGE_CFM_MEP_CREATE_DOMAIN,
> > +                             mep->create.domain))
> > +                     goto nla_put_failure;
> > +
> > +             if (nla_put_u32(skb, IFLA_BRIDGE_CFM_MEP_CREATE_DIRECTION,
> > +                             mep->create.direction))
> > +                     goto nla_put_failure;
> > +
> > +             if (nla_put_u32(skb, IFLA_BRIDGE_CFM_MEP_CREATE_IFINDEX,
> > +                             mep->create.ifindex))
> > +                     goto nla_put_failure;
> > +
> > +             nla_nest_end(skb, tb);
> > +
> > +             tb = nla_nest_start_noflag(skb, IFLA_BRIDGE_CFM_MEP_CONFIG_INFO);
> > +
> > +             if (!tb)
> > +                     goto nla_info_failure;
> > +
> > +             if (nla_put_u32(skb, IFLA_BRIDGE_CFM_MEP_CONFIG_INSTANCE,
> > +                             mep->instance))
> > +                     goto nla_put_failure;
> > +
> > +             if (nla_put(skb, IFLA_BRIDGE_CFM_MEP_CONFIG_UNICAST_MAC,
> > +                         sizeof(mep->config.unicast_mac.addr),
> > +                         mep->config.unicast_mac.addr))
> > +                     goto nla_put_failure;
> > +
> > +             if (nla_put_u32(skb, IFLA_BRIDGE_CFM_MEP_CONFIG_MDLEVEL,
> > +                             mep->config.mdlevel))
> > +                     goto nla_put_failure;
> > +
> > +             if (nla_put_u32(skb, IFLA_BRIDGE_CFM_MEP_CONFIG_MEPID,
> > +                             mep->config.mepid))
> > +                     goto nla_put_failure;
> > +
> > +             nla_nest_end(skb, tb);
> > +
> > +             tb = nla_nest_start_noflag(skb, IFLA_BRIDGE_CFM_CC_CONFIG_INFO);
> > +
> > +             if (!tb)
> > +                     goto nla_info_failure;
> > +
> > +             if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_CONFIG_INSTANCE,
> > +                             mep->instance))
> > +                     goto nla_put_failure;
> > +
> > +             if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_CONFIG_ENABLE,
> > +                             mep->cc_config.enable))
> > +                     goto nla_put_failure;
> > +
> > +             if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_CONFIG_EXP_INTERVAL,
> > +                             mep->cc_config.exp_interval))
> > +                     goto nla_put_failure;
> > +
> > +             if (nla_put(skb, IFLA_BRIDGE_CFM_CC_CONFIG_EXP_MAID,
> > +                         sizeof(mep->cc_config.exp_maid.data),
> > +                         mep->cc_config.exp_maid.data))
> > +                     goto nla_put_failure;
> > +
> > +             nla_nest_end(skb, tb);
> > +
> > +             tb = nla_nest_start_noflag(skb, IFLA_BRIDGE_CFM_CC_RDI_INFO);
> > +
> > +             if (!tb)
> > +                     goto nla_info_failure;
> > +
> > +             if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_RDI_INSTANCE,
> > +                             mep->instance))
> > +                     goto nla_put_failure;
> > +
> > +             if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_RDI_RDI,
> > +                             mep->rdi))
> > +                     goto nla_put_failure;
> > +
> > +             nla_nest_end(skb, tb);
> > +
> > +             tb = nla_nest_start_noflag(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_INFO);
> > +
> > +             if (!tb)
> > +                     goto nla_info_failure;
> > +
> > +             if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_INSTANCE,
> > +                             mep->instance))
> > +                     goto nla_put_failure;
> > +
> > +             if (nla_put(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_DMAC,
> > +                         sizeof(mep->cc_ccm_tx_info.dmac),
> > +                         mep->cc_ccm_tx_info.dmac.addr))
> > +                     goto nla_put_failure;
> > +
> > +             if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_SEQ_NO_UPDATE,
> > +                             mep->cc_ccm_tx_info.seq_no_update))
> > +                     goto nla_put_failure;
> > +
> > +             if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_PERIOD,
> > +                             mep->cc_ccm_tx_info.period))
> > +                     goto nla_put_failure;
> > +
> > +             if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV,
> > +                             mep->cc_ccm_tx_info.if_tlv))
> > +                     goto nla_put_failure;
> > +
> > +             if (nla_put_u8(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_IF_TLV_VALUE,
> > +                            mep->cc_ccm_tx_info.if_tlv_value))
> > +                     goto nla_put_failure;
> > +
> > +             if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV,
> > +                             mep->cc_ccm_tx_info.port_tlv))
> > +                     goto nla_put_failure;
> > +
> > +             if (nla_put_u8(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_PORT_TLV_VALUE,
> > +                            mep->cc_ccm_tx_info.port_tlv_value))
> > +                     goto nla_put_failure;
> > +
> > +             nla_nest_end(skb, tb);
> > +
> > +             list_for_each_entry_rcu(peer_mep, &mep->peer_mep_list, head) {
> > +                     tb = nla_nest_start_noflag(skb, IFLA_BRIDGE_CFM_CC_PEER_MEP_INFO);
> > +
> > +                     if (!tb)
> > +                             goto nla_info_failure;
> > +
> > +                     if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_PEER_MEP_INSTANCE,
> > +                                     mep->instance))
> > +                             goto nla_put_failure;
> > +
> > +                     if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_PEER_MEPID,
> > +                                     peer_mep->mepid))
> > +                             goto nla_put_failure;
> > +
> > +                     nla_nest_end(skb, tb);
> > +             }
> > +     }
> > +     nla_nest_end(skb, cfm_tb);
> > +
> > +     return 0;
> > +
> > +nla_put_failure:
> > +     nla_nest_cancel(skb, tb);
> > +
> > +nla_info_failure:
> > +     nla_nest_cancel(skb, cfm_tb);
> > +
> > +     return -EMSGSIZE;
> > +}
> > +
> > +int br_cfm_status_fill_info(struct sk_buff *skb, struct net_bridge *br)
> > +{
> > +     struct nlattr *tb, *cfm_tb;
> > +     struct br_cfm_mep *mep;
> > +     struct br_cfm_peer_mep *peer_mep;
> > +
> > +     cfm_tb = nla_nest_start_noflag(skb, IFLA_BRIDGE_CFM);
> > +     if (!cfm_tb)
> > +             return -EMSGSIZE;
> > +
> > +     list_for_each_entry_rcu(mep, &br->mep_list, head) {
> > +             tb = nla_nest_start_noflag(skb, IFLA_BRIDGE_CFM_MEP_STATUS_INFO);
> > +             if (!tb)
> > +                     goto nla_info_failure;
> > +
> > +             if (nla_put_u32(skb, IFLA_BRIDGE_CFM_MEP_STATUS_INSTANCE,
> > +                             mep->instance))
> > +                     goto nla_put_failure;
> > +
> > +             if (nla_put_u32(skb, IFLA_BRIDGE_CFM_MEP_STATUS_OPCODE_UNEXP_SEEN,
> > +                             mep->status.opcode_unexp_seen))
> > +                     goto nla_put_failure;
> > +
> > +             if (nla_put_u32(skb, IFLA_BRIDGE_CFM_MEP_STATUS_VERSION_UNEXP_SEEN,
> > +                             mep->status.version_unexp_seen))
> > +                     goto nla_put_failure;
> > +
> > +             if (nla_put_u32(skb, IFLA_BRIDGE_CFM_MEP_STATUS_RX_LEVEL_LOW_SEEN,
> > +                             mep->status.rx_level_low_seen))
> > +                     goto nla_put_failure;
> > +
> > +             /* Clear all 'seen' indications */
> > +             mep->status.opcode_unexp_seen = false;
> > +             mep->status.version_unexp_seen = false;
> > +             mep->status.rx_level_low_seen = false;
> > +
> > +             nla_nest_end(skb, tb);
> > +
> > +             list_for_each_entry_rcu(peer_mep, &mep->peer_mep_list, head) {
> > +                     tb = nla_nest_start_noflag(skb, IFLA_BRIDGE_CFM_CC_PEER_STATUS_INFO);
> > +
> > +                     if (!tb)
> > +                             goto nla_info_failure;
> > +
> > +                     if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_PEER_STATUS_INSTANCE,
> > +                                     mep->instance))
> > +                             goto nla_put_failure;
> > +
> > +                     if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_PEER_STATUS_PEER_MEPID,
> > +                                     peer_mep->mepid))
> > +                             goto nla_put_failure;
> > +
> > +                     if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_PEER_STATUS_CCM_DEFECT,
> > +                                     peer_mep->cc_status.ccm_defect))
> > +                             goto nla_put_failure;
> > +
> > +                     if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_PEER_STATUS_RDI,
> > +                                     peer_mep->cc_status.rdi))
> > +                             goto nla_put_failure;
> > +
> > +                     if (nla_put_u8(skb, IFLA_BRIDGE_CFM_CC_PEER_STATUS_PORT_TLV_VALUE,
> > +                                    peer_mep->cc_status.port_tlv_value))
> > +                             goto nla_put_failure;
> > +
> > +                     if (nla_put_u8(skb, IFLA_BRIDGE_CFM_CC_PEER_STATUS_IF_TLV_VALUE,
> > +                                    peer_mep->cc_status.if_tlv_value))
> > +                             goto nla_put_failure;
> > +
> > +                     if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_PEER_STATUS_SEEN,
> > +                                     peer_mep->cc_status.seen))
> > +                             goto nla_put_failure;
> > +
> > +                     if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_PEER_STATUS_TLV_SEEN,
> > +                                     peer_mep->cc_status.tlv_seen))
> > +                             goto nla_put_failure;
> > +
> > +                     if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_PEER_STATUS_SEQ_UNEXP_SEEN,
> > +                                     peer_mep->cc_status.seq_unexp_seen))
> > +                             goto nla_put_failure;
> > +
> > +                     /* Clear all 'seen' indications */
> > +                     peer_mep->cc_status.seen = false;
> > +                     peer_mep->cc_status.tlv_seen = false;
> > +                     peer_mep->cc_status.seq_unexp_seen = false;
> > +
> > +                     nla_nest_end(skb, tb);
> > +             }
> > +     }
> > +     nla_nest_end(skb, cfm_tb);
> > +
> > +     return 0;
> > +
> > +nla_put_failure:
> > +     nla_nest_cancel(skb, tb);
> > +
> > +nla_info_failure:
> > +     nla_nest_cancel(skb, cfm_tb);
> > +
> > +     return -EMSGSIZE;
> > +}
> > diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> > index 8a71c60fa357..6de5cb1295f6 100644
> > --- a/net/bridge/br_netlink.c
> > +++ b/net/bridge/br_netlink.c
> > @@ -16,6 +16,7 @@
> >
> >  #include "br_private.h"
> >  #include "br_private_stp.h"
> > +#include "br_private_cfm.h"
> >  #include "br_private_tunnel.h"
> >
> >  static int __get_num_vlan_infos(struct net_bridge_vlan_group *vg,
> > @@ -481,6 +482,48 @@ static int br_fill_ifinfo(struct sk_buff *skb,
> >               nla_nest_end(skb, af);
> >       }
> >
> > +     if (filter_mask & RTEXT_FILTER_CFM_CONFIG) {
> > +             struct nlattr *af;
> > +             int err;
> > +
> > +             if (!br_cfm_created(br) || port)
> > +                     goto done;
> > +
> > +             af = nla_nest_start_noflag(skb, IFLA_AF_SPEC);
> > +             if (!af)
> > +                     goto nla_put_failure;
> > +
> > +             rcu_read_lock();
> > +             err = br_cfm_config_fill_info(skb, br);
> > +             rcu_read_unlock();
> > +
> > +             if (err)
> > +                     goto nla_put_failure;
> > +
> > +             nla_nest_end(skb, af);
> > +     }
> > +
> > +     if (filter_mask & RTEXT_FILTER_CFM_STATUS) {
> > +             struct nlattr *af;
> > +             int err;
> > +
> > +             if (!br_cfm_created(br) || port)
> > +                     goto done;
> > +
> > +             af = nla_nest_start_noflag(skb, IFLA_AF_SPEC);
> > +             if (!af)
> > +                     goto nla_put_failure;
> > +
> > +             rcu_read_lock();
> > +             err = br_cfm_status_fill_info(skb, br);
> > +             rcu_read_unlock();
> > +
> > +             if (err)
> > +                     goto nla_put_failure;
> > +
> > +             nla_nest_end(skb, af);
> > +     }
> 
> I actually noticed this just now, you can't have multiple IFLA_AF_SPEC
> attributes. It seems we already have that problem with MRP.
> Since filter_mask is a mask one could request multiple rtext attributes.
> 
I will change to assure that only one IFLA_AF_SPEC is inserted for all
possible flags set in filter_mask.
I will also assure that only one IFLA_BRIDGE_CFM is inserted if both
RTEXT_FILTER_CFM_CONFIG and RTEXT_FILTER_CFM_STATUS is set in
filter_mask.

> > +
> >  done:
> >       nlmsg_end(skb, nlh);
> >       return 0;
> > @@ -542,7 +585,9 @@ int br_getlink(struct sk_buff *skb, u32 pid, u32 seq,
> >
> >       if (!port && !(filter_mask & RTEXT_FILTER_BRVLAN) &&
> >           !(filter_mask & RTEXT_FILTER_BRVLAN_COMPRESSED) &&
> > -         !(filter_mask & RTEXT_FILTER_MRP))
> > +         !(filter_mask & RTEXT_FILTER_MRP) &&
> > +         !(filter_mask & RTEXT_FILTER_CFM_CONFIG) &&
> > +         !(filter_mask & RTEXT_FILTER_CFM_STATUS))
> >               return 0;
> >
> >       return br_fill_ifinfo(skb, port, pid, seq, RTM_NEWLINK, nlflags,
> > @@ -704,6 +749,11 @@ static int br_afspec(struct net_bridge *br,
> >                       if (err)
> >                               return err;
> >                       break;
> > +             case IFLA_BRIDGE_CFM:
> > +                     err = br_cfm_parse(br, p, attr, cmd, extack);
> > +                     if (err)
> > +                             return err;
> > +                     break;
> >               }
> >       }
> >
> > diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> > index 385a6a6aa17e..fe36592f7525 100644
> > --- a/net/bridge/br_private.h
> > +++ b/net/bridge/br_private.h
> > @@ -1365,9 +1365,20 @@ static inline int br_mrp_fill_info(struct sk_buff *skb, struct net_bridge *br)
> >
> >  /* br_cfm.c */
> >  #if IS_ENABLED(CONFIG_BRIDGE_CFM)
> > +int br_cfm_parse(struct net_bridge *br, struct net_bridge_port *p,
> > +              struct nlattr *attr, int cmd, struct netlink_ext_ack *extack);
> >  int br_cfm_rx_frame_process(struct net_bridge_port *p, struct sk_buff *skb);
> >  bool br_cfm_created(struct net_bridge *br);
> > +int br_cfm_config_fill_info(struct sk_buff *skb, struct net_bridge *br);
> > +int br_cfm_status_fill_info(struct sk_buff *skb, struct net_bridge *br);
> >  #else
> > +static inline int br_cfm_parse(struct net_bridge *br, struct net_bridge_port *p,
> > +                            struct nlattr *attr, int cmd,
> > +                            struct netlink_ext_ack *extack)
> > +{
> > +     return -EOPNOTSUPP;
> > +}
> > +
> >  static inline int br_cfm_rx_frame_process(struct net_bridge_port *p, struct sk_buff *skb)
> >  {
> >       return -EOPNOTSUPP;
> > @@ -1377,6 +1388,16 @@ static inline bool br_cfm_created(struct net_bridge *br)
> >  {
> >       return false;
> >  }
> > +
> > +static inline int br_cfm_config_fill_info(struct sk_buff *skb, struct net_bridge *br)
> > +{
> > +     return -EOPNOTSUPP;
> > +}
> > +
> > +static inline int br_cfm_status_fill_info(struct sk_buff *skb, struct net_bridge *br)
> > +{
> > +     return -EOPNOTSUPP;
> > +}
> >  #endif
> >
> >  /* br_netlink.c */
> 

-- 
/Henrik
