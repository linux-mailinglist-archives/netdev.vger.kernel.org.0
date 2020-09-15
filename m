Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05CFF26A0E0
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 10:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgIOI3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 04:29:38 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:40803 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbgIOI33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 04:29:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1600158568; x=1631694568;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fTwn5T1pKJoEK59ue7GNAJ2X0iCUowH1el/JpPlsyUU=;
  b=lQhjU+I+GdpllOf3d8j099orGe/okkaTrxVNPgdYD2PC7owKKNSAh11G
   +pkn2lCV1oSp24KlSn8ItsZWFEA0XXxJRrGta3/ZEDfgN1GFZDLSauUpR
   dgB4veDdbmsDiuhOzGZohzH4vFORPSQAidfZri/u89J6PlYxkCEMiDC+L
   uxWWFqFwTLJLkDbhzegHd+i2XhDp5enpOCMfkukY+2MBMaj3uheuPZ9mN
   AyuMRHoy4gc7n3dLkpR3glCDuUnfs8690ohSlQ55MuCISJLFb9OtLeUDq
   bdoEO+eO0Coqf5kVv5GEGwWR5aAiB9xXdy8sCjXBsaFm7CGixZr+tqE8p
   Q==;
IronPort-SDR: NTXXUh8W7UGlRIh3NYvTRg3imnAHdVO9PbXTh/qe189wADZPMm7FsK6a1D28TsSmbjCRYpFM8W
 Rbt/tSEuRZ9Gi7ruA/yfm4mxInDR6vItb5CywcYszlsqsy0pNNIDjRpoS3dxERxiLKmwiKBCtO
 RV2JwkKzbKqC0bBxslYUlAxGXKvTGuDnYozLxz9x76Zx5nonaZzd3y2+++eoYpC8dditdUfF0x
 sUF6DDG8NSfdqHSwJthwkjm2Mhs7BnVwPpRJY+fejd4pG6HrFPwXiJ3LWAiDkmSFANKQXewUUe
 w1U=
X-IronPort-AV: E=Sophos;i="5.76,429,1592895600"; 
   d="scan'208";a="26444736"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Sep 2020 01:29:27 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 15 Sep 2020 01:29:26 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 15 Sep 2020 01:29:18 -0700
Date:   Tue, 15 Sep 2020 08:26:51 +0000
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
Subject: Re: [PATCH RFC 2/7] bridge: cfm: Add BRIDGE_CFM to Kconfig.
Message-ID: <20200915082651.4c5s734la37iqwfz@soft-test08>
References: <20200904091527.669109-1-henrik.bjoernlund@microchip.com>
 <20200904091527.669109-3-henrik.bjoernlund@microchip.com>
 <e145b130ba56460ecf11318f9a4550d2637aa222.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <e145b130ba56460ecf11318f9a4550d2637aa222.camel@nvidia.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for your review. I will update in the next version as suggested.

Regards
Henrik


The 09/08/2020 12:18, Nikolay Aleksandrov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Fri, 2020-09-04 at 09:15 +0000, Henrik Bjoernlund wrote:
> > This makes it possible to include or exclude the CFM
> > protocol according to 802.1Q section 12.14.
> >
> > Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
> > ---
> >  net/bridge/Kconfig      | 11 +++++++++++
> >  net/bridge/br_device.c  |  3 +++
> >  net/bridge/br_private.h |  3 +++
> >  3 files changed, 17 insertions(+)
> >
> > diff --git a/net/bridge/Kconfig b/net/bridge/Kconfig
> > index 80879196560c..3c8ded7d3e84 100644
> > --- a/net/bridge/Kconfig
> > +++ b/net/bridge/Kconfig
> > @@ -73,3 +73,14 @@ config BRIDGE_MRP
> >         Say N to exclude this support and reduce the binary size.
> >
> >         If unsure, say N.
> > +
> > +config BRIDGE_CFM
> > +     bool "CFM protocol"
> > +     depends on BRIDGE
> > +     help
> > +       If you say Y here, then the Ethernet bridge will be able to run CFM
> > +       protocol according to 802.1Q section 12.14
> > +
> > +       Say N to exclude this support and reduce the binary size.
> > +
> > +       If unsure, say N.
> > diff --git a/net/bridge/br_device.c b/net/bridge/br_device.c
> > index a9232db03108..d12f5626a4b1 100644
> > --- a/net/bridge/br_device.c
> > +++ b/net/bridge/br_device.c
> > @@ -476,6 +476,9 @@ void br_dev_setup(struct net_device *dev)
> >       INIT_LIST_HEAD(&br->ftype_list);
> >  #if IS_ENABLED(CONFIG_BRIDGE_MRP)
> >       INIT_LIST_HEAD(&br->mrp_list);
> > +#endif
> > +#if IS_ENABLED(CONFIG_BRIDGE_CFM)
> > +     INIT_LIST_HEAD(&br->mep_list);
> >  #endif
> >       spin_lock_init(&br->hash_lock);
> >
> > diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> > index e67c6d9e8bea..6294a3e51a33 100644
> > --- a/net/bridge/br_private.h
> > +++ b/net/bridge/br_private.h
> > @@ -445,6 +445,9 @@ struct net_bridge {
> >  #if IS_ENABLED(CONFIG_BRIDGE_MRP)
> >       struct list_head                mrp_list;
> >  #endif
> > +#if IS_ENABLED(CONFIG_BRIDGE_CFM)
> > +     struct list_head                mep_list;
> > +#endif
> >  };
> >
> >  struct br_input_skb_cb {
> 
> Looks good, perhaps also can use hlist to reduce the head size in net_bridge.
> 

-- 
/Henrik
