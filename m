Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46BCE1C6D67
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 11:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbgEFJoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 05:44:08 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:47044 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728663AbgEFJoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 05:44:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1588758247; x=1620294247;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zuKmMeWgZ/UFqq1rP7zWa/wg5C9p4yCyko5/mVu0JcE=;
  b=SrAiDA2tnZpefq9ardbX68VMzxjTy9GT5bV5cSbc2FBt49ZvseAwN5fG
   HTaX30y/lgLNyZAEFqZeFRNIWwKqKecWgzqjNwSYHDdCA2rnP3j3aZKPg
   Ij6y5DJTwil04A92ydLaZNzAvxeE/LERBSpe2H7/o7oYcap6p65GSPP0R
   DfTVbppjIK7y66UWhm/i7NKWqj58xncwIOIH7KXFZnhDr//MzzEhXYzwZ
   9GNpBWGqbmCCIk9b21vtNv4G4OdKP/13MXJLd884QqtefAT8/9vI0HcQH
   XLjH2Z73wxSFyhxVOxvMEowZQ7s+niOjNcvvAkzFyTHlJvRW+vxQdjL/6
   w==;
IronPort-SDR: 8diXjE1BHUCwR7ruJb2Js1oQxx0NR1FxldPu2olFVYsbtwhEjA2IX5vVtD7hMdpcje4QuVxrya
 U0qvMjPIrnkOLvfsY6HIz8V+ounKPbUlIq7AazdCN/BCU8WCG6e/mAWNoQ7o0e9bNRtGeLE/2b
 Vizg3pTMDwOApMBNkDnoxyRNp8d7LJQ6JoWisGN3QkwnO3hr/NcYANbuFN9FgmyROeuHlaeWQ4
 SsFqn/3nkkU/TJeV2vVeNpaDg4KnGww+ZJgonrQ0Ictd0jQZdk+LL/EIDPKxYVmm0vThUr9MEQ
 zmw=
X-IronPort-AV: E=Sophos;i="5.73,358,1583218800"; 
   d="scan'208";a="75696370"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 May 2020 02:43:46 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 6 May 2020 02:43:46 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Wed, 6 May 2020 02:43:46 -0700
Date:   Wed, 6 May 2020 11:43:45 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     <po.liu@nxp.com>, <claudiu.manoil@nxp.com>,
        <alexandru.marginean@nxp.com>, <vladimir.oltean@nxp.com>,
        <leoyang.li@nxp.com>, <mingkai.hu@nxp.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <davem@davemloft.net>, <jiri@resnulli.us>, <idosch@idosch.org>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <horatiu.vultur@microchip.com>,
        <alexandre.belloni@bootlin.com>, <joergen.andreasen@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <nikolay@cumulusnetworks.com>,
        <roopa@cumulusnetworks.com>, <linux-devel@linux.nxdi.nxp.com>
Subject: Re: [PATCH v1 net-next 4/6] net: mscc: ocelot: VCAP IS1 support
Message-ID: <20200506094345.n4zdgjvctwiz4pkh@ws.localdomain>
References: <20200506074900.28529-1-xiaoliang.yang_1@nxp.com>
 <20200506074900.28529-5-xiaoliang.yang_1@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20200506074900.28529-5-xiaoliang.yang_1@nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xiaoliang,

On 06.05.2020 15:48, Xiaoliang Yang wrote:
>VCAP IS1 is a VCAP module which can filter MAC, IP, VLAN, protocol, and
>TCP/UDP ports keys, and do Qos and VLAN retag actions.
>This patch added VCAP IS1 support in ocelot ace driver, which can supports
>vlan modify action of tc filter.
>Usage:
>        tc qdisc add dev swp0 ingress
>        tc filter add dev swp0 protocol 802.1Q parent ffff: flower \
>        skip_sw vlan_id 1 vlan_prio 1 action vlan modify id 2 priority 2
I skimmed skimmed through the patch serie, and the way I understood it
is that you look at the action, and if it is a VLAN operation, then you
put it in IS1 and if it is one of the other then put it in IS2.

This is how the HW is designed - I'm aware of that.

But how will this work if you have 2 rules, 1 modifying the VLAN and
another rule dropping certain packets?

The SW model have these two rules in the same table, and can stop
process at the first match. SW will do the action of the first frame
matching.

The HW will how-ever do both, as they are in independent TCAMs.

If we want to enable all the TCAM lookups in Ocelot/Felix, then we need
to find a way where we will get the same results when doing the
operation in HW and in SW.

/Allan

