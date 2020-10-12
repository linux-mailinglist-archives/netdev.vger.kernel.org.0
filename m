Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C52E28B5B4
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 15:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730551AbgJLNO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 09:14:27 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:18538 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726572AbgJLNO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 09:14:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1602508467; x=1634044467;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=AziLle62dzQqXG3eHawz0SiT4sBXo6D4inxNSWkuyGU=;
  b=SxBC0XpamDE03mo43CCHUCTdNVEIzQmyJxw1ODhUl+m7uuMsK63d7uEF
   z0w5ZHhZD79S6oLK9t1/OdnNSNuFJE19OeqfMxZX9LpTGKSA/vIkGBMzX
   M738WM1snWKVPpm/TyFi+5grvIbYjTYdnuLCM3i12fQYx7gQrzpgCNwDg
   RYVfzV2FhrFY4sPSsMZ58DmOHg/5Np3PrisRD5Olu3BfyiSFLpaV1101v
   zHGGg+lOZ2sNvqa6auMTnvPPd5bMcuQjFFvr4+FdW0Tf0sAJVXPN/n6nm
   WbBxdbBb3a/TsTY3Y5bRjfx5OGKdXhjC1/uXRo8Sy68Rh79qWdes4RV/t
   g==;
IronPort-SDR: BMVaTsUsC46W45Bspo5y2OzNsRihR7Iv476quhlpvd7uopzPKrvMGfLtl8iRDsSZdGN80kL5jn
 JbjaXOReytmABKTEh9P8ZXXXz5SciR8/lQn+zFcRWXaQFfeRu0nUi7RZXIpJa9t5XP/MzK4Sno
 OYeMvRcKaGtkUjoxQ+/2uFo5yngjR6oTc+c5MMx7420/qgfuqJ1+0qkwj+HqpuNgnRzXkElAnD
 BgTsfJ2OxPIqvbpQ6fPpMCKK4yQMXNqlCSCjq3D2LfXb9dX96ctiAsdzyNhSNAOLVAPdPh3rWc
 LSw=
X-IronPort-AV: E=Sophos;i="5.77,366,1596524400"; 
   d="scan'208";a="94260967"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Oct 2020 06:14:14 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 12 Oct 2020 06:14:13 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Mon, 12 Oct 2020 06:14:13 -0700
Date:   Mon, 12 Oct 2020 13:12:27 +0000
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
Subject: Re: [PATCH net-next v4 04/10] bridge: cfm: Kernel space
 implementation of CFM. MEP create/delete.
Message-ID: <20201012131227.l7on7k3n2nogoace@soft-test08>
References: <20201009143530.2438738-1-henrik.bjoernlund@microchip.com>
 <20201009143530.2438738-5-henrik.bjoernlund@microchip.com>
 <491685c20c840f3962433bed13f53aa5418696f5.camel@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <491685c20c840f3962433bed13f53aa5418696f5.camel@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the review.

The 10/09/2020 21:42, Nikolay Aleksandrov wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Fri, 2020-10-09 at 14:35 +0000, Henrik Bjoernlund wrote:
> > This is the first commit of the implementation of the CFM protocol
> > according to 802.1Q section 12.14.
> >
> > It contains MEP instance create, delete and configuration.
> >
> > Connectivity Fault Management (CFM) comprises capabilities for
> > detecting, verifying, and isolating connectivity failures in
> > Virtual Bridged Networks. These capabilities can be used in
> > networks operated by multiple independent organizations, each
> > with restricted management access to each other<E2><80><99>s equipment.
> >
> > CFM functions are partitioned as follows:
> >     - Path discovery
> >     - Fault detection
> >     - Fault verification and isolation
> >     - Fault notification
> >     - Fault recovery
> >
> > Interface consists of these functions:
> > br_cfm_mep_create()
> > br_cfm_mep_delete()
> > br_cfm_mep_config_set()
> > br_cfm_cc_config_set()
> > br_cfm_cc_peer_mep_add()
> > br_cfm_cc_peer_mep_remove()
> >
> > A MEP instance is created by br_cfm_mep_create()
> >     -It is the Maintenance association End Point
> >      described in 802.1Q section 19.2.
> >     -It is created on a specific level (1-7) and is assuring
> >      that no CFM frames are passing through this MEP on lower levels.
> >     -It initiates and validates CFM frames on its level.
> >     -It can only exist on a port that is related to a bridge.
> >     -Attributes given cannot be changed until the instance is
> >      deleted.
> >
> > A MEP instance can be deleted by br_cfm_mep_delete().
> >
> > A created MEP instance has attributes that can be
> > configured by br_cfm_mep_config_set().
> >
> > A MEP Continuity Check feature can be configured by
> > br_cfm_cc_config_set()
> >     The Continuity Check Receiver state machine can be
> >     enabled and disabled.
> >     According to 802.1Q section 19.2.8
> >
> > A MEP can have Peer MEPs added and removed by
> > br_cfm_cc_peer_mep_add() and br_cfm_cc_peer_mep_remove()
> >     The Continuity Check feature can maintain connectivity
> >     status on each added Peer MEP.
> >
> > Signed-off-by: Henrik Bjoernlund  <henrik.bjoernlund@microchip.com>
> > Reviewed-by: Horatiu Vultur  <horatiu.vultur@microchip.com>
> > ---
> >  include/uapi/linux/cfm_bridge.h |  23 +++
> >  net/bridge/Makefile             |   2 +
> >  net/bridge/br_cfm.c             | 278 ++++++++++++++++++++++++++++++++
> >  net/bridge/br_if.c              |   1 +
> >  net/bridge/br_private.h         |  10 ++
> >  net/bridge/br_private_cfm.h     |  61 +++++++
> >  6 files changed, 375 insertions(+)
> >  create mode 100644 include/uapi/linux/cfm_bridge.h
> >  create mode 100644 net/bridge/br_cfm.c
> >  create mode 100644 net/bridge/br_private_cfm.h
> >
> 
> Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>
> 

-- 
/Henrik
