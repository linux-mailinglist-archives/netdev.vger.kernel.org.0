Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DFB28F0F0
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 13:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbgJOL0d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 07:26:33 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:21246 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728283AbgJOLZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 07:25:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602761155; x=1634297155;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZoVMllBI6FapwInWS1hyhHru/VQbiws2d3z0bAqZ7Gw=;
  b=IZ4RgBWpfOSjsBAchw7LkaohE899sQ2QCDN4EmnwSQD1oBs/omRWyAXY
   u54aa3umY6tFnFVsWhY2XeqFxjeGHOtcMBCguDz0N7zMNk/X5drwjfHA0
   43KZA7WwMob4ShZHXcrUoklHmK8fIBsP5endy7C+3u0/3qrdYmuXzWC0u
   ub2xpL4fVE2SATSP+zNlKe/ubVvQNhS5UySDPCDS1nVNQ9NBNxqKEJhPh
   +RlF6ZjwUXyCj2uM4P9OYJ2lySChBFcU1ypDifGP9ExhOKUvXgOLxS/uQ
   kOPH1lY5YdNcjvJdpOMZVVdLIQtUb0ATHD8N7NCRySBEme4hFJuLeff3i
   Q==;
IronPort-SDR: ZvMN9xDzjixyB3O2ezKYGx3c9lRJrAkDrFUkpaFJPtYdPVKLgSUn7HupHbbZ2TANbJDRz1b3dy
 L7kI2SKEEtAGY7WDujON8OPQOvV247jGs1aJ4QQnPAEh8Qz5kObMNG++dmAdu/zVie9dQ5ZCaf
 WjXUvECAZ+J5/yMXeE8H2mn36q5tKT9AqOyB4KvUcSrFGsX3J1tmxMoNmFQGCDAc1fbQYceik8
 0t+g6CJ8PIM9aPrCd6YbgS+d11B0FNO3KYWdg9wXECXB+rZ9rAj7blhF7jqlNxWRv+jzWqCVcT
 cMc=
X-IronPort-AV: E=Sophos;i="5.77,378,1596524400"; 
   d="scan'208";a="99624065"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Oct 2020 04:25:55 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 15 Oct 2020 04:25:54 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 15 Oct 2020 04:25:53 -0700
Date:   Thu, 15 Oct 2020 11:24:13 +0000
From:   Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <roopa@nvidia.com>, <nikolay@nvidia.com>,
        <jiri@mellanox.com>, <idosch@mellanox.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bridge@lists.linux-foundation.org>,
        <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net-next v5 08/10] bridge: cfm: Netlink GET configuration
 Interface.
Message-ID: <20201015112413.5vzxwvykmteiesyx@soft-test08>
References: <20201012140428.2549163-1-henrik.bjoernlund@microchip.com>
 <20201012140428.2549163-9-henrik.bjoernlund@microchip.com>
 <20201014163348.2f99e349@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20201014163348.2f99e349@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your review. Comment below.
Regards
Henrik

The 10/14/2020 16:33, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Mon, 12 Oct 2020 14:04:26 +0000 Henrik Bjoernlund wrote:
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
> 
> Consider collapsing writing related attrs in a nest into a single
> if statement:
> 
>         if (nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_SEQ_NO_UPDATE,
>                         mep->cc_ccm_tx_info.seq_no_update) ||
>             nla_put_u32(skb, IFLA_BRIDGE_CFM_CC_CCM_TX_PERIOD,
>                         mep->cc_ccm_tx_info.period) ||
>                 ...
I will prefer to keep it as is for my personal taste :-)

-- 
/Henrik
