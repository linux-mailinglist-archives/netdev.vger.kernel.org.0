Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A63221EE9
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 10:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgGPIus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 04:50:48 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:17736 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgGPIur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 04:50:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1594889446; x=1626425446;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=KThZHa+Je4qNybDtnf/HF3OhnWN7ZLuDdSx3xsHd2mE=;
  b=vcwzyq1OPX6rVWOdKZAqSSI3tmgG7t9aTCKMhmZY0ymnolVUNPsQi1fD
   WQwnzp1D8yzof0EOpuKbWTg5W3ayspnDn7YIWVdNmLAkxBk++sJ8wObEd
   glsSGQvQlFT88jR1Ch32SflYYsvIcvZpT9FrHUVBSZXmV8ARpm6B8+Jok
   hKHDqgRijBDhf7XmsDa3AYPdJREGety2NT4xGnC9liv9lnoGDAw7fOiZx
   rTUjLnntOvrL+a1s1DOGM+V3mnvKbSt1yDQHrflxhhI7P9r6xTl8AWJyg
   psICE2aIWYo5IW2M/HcHR271rqi+ZeiXUkYCZEQe13V85Tx0jcCgeo+VA
   g==;
IronPort-SDR: 8PpKmRZwYA87h7fseG5cXOoabPJXh3OHo7jJBnKTZpSIcMUAvHw6KnoJxzXA9lZF872FZ4jPgz
 7wob9jNle0yWe2vX/R96jUFG26cYuwFaSty6Hr+XRG6dcomKCcFJvtAGaWv35vec6LjWzcQAMs
 WerZ6JEQ1S+HiPujzTr2ewT/mjv52hBlKfgjsBYrIiwYjnjQmVXHPGhGLkyn0e/RQpKoZD31Jk
 4dE/V7qN9d1Y8YwXuL9Apct3J2Q4DwjKf8K8lIZFQx0rzZRmwORXJlv+BemY8F1qkZEfUXsrCq
 Jok=
X-IronPort-AV: E=Sophos;i="5.75,358,1589266800"; 
   d="scan'208";a="82071504"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Jul 2020 01:50:45 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 16 Jul 2020 01:50:10 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 16 Jul 2020 01:50:44 -0700
Date:   Thu, 16 Jul 2020 10:50:44 +0200
From:   Joergen Andreasen <joergen.andreasen@microchip.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Vladimir Oltean <olteanv@gmail.com>, Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Florian Fainelli" <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        "Ido Schimmel" <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Vinicius Costa Gomes" <vinicius.gomes@intel.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "Horatiu Vultur" <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "linux-devel@linux.nxdi.nxp.com" <linux-devel@linux.nxdi.nxp.com>
Subject: Re: [EXT] Re: [PATCH v2 net-next 03/10] net: mscc: ocelot: allocated
 rules to different hardware VCAP TCAMs by chain index
Message-ID: <20200716085044.wzwdca535aa5oiv4@soft-dev16>
References: <20200602051828.5734-1-xiaoliang.yang_1@nxp.com>
 <20200602051828.5734-4-xiaoliang.yang_1@nxp.com>
 <20200602083613.ddzjh54zxtbklytw@ws.localdomain>
 <CA+h21hocBOyuDFvnLq-sBEG5phaJPxbhvZ_P5H8HnTkBDv1x+w@mail.gmail.com>
 <20200608135633.jznoxwny6qtzxjng@ws.localdomain>
 <CA+h21hqoZdQeSxTtrEsVEHi6ZP1LrWKQGwZ9zPvjyWZ62TNfbg@mail.gmail.com>
 <20200610181802.2sqdhsoyrkd4awcg@ws.localdomain>
 <DB8PR04MB57851605ACFE209B4E54208EF07F0@DB8PR04MB5785.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <DB8PR04MB57851605ACFE209B4E54208EF07F0@DB8PR04MB5785.eurprd04.prod.outlook.com>
User-Agent: NeoMutt/20171215
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xiaoliang,

The 07/16/2020 06:49, Xiaoliang Yang wrote:
> Hi Allan,
> 
> On 11.06.2002 2:18, Allan W. Nielsen <allan.nielsen@microchip.com> wrote:
> >> >> Here is my initial suggestion for an alternative chain-schema:
> >> >>
> >> >> Chain 0:           The default chain - today this is in IS2. If we proceed
> >> >>                     with this as is - then this will change.
> >> >> Chain 1-9999:      These are offloaded by "basic" classification.
> >> >> Chain 10000-19999: These are offloaded in IS1
> >> >>                     Chain 10000: Lookup-0 in IS1, and here we could limit the
> >> >>                                  action to do QoS related stuff (priority
> >> >>                                  update)
> >> >>                     Chain 11000: Lookup-1 in IS1, here we could do VLAN
> >> >>                                  stuff
> >> >>                     Chain 12000: Lookup-2 in IS1, here we could apply the
> >> >>                                  "PAG" which is essentially a GOTO.
> >> >>
> >> >> Chain 20000-29999: These are offloaded in IS2
> >> >>                     Chain 20000-20255: Lookup-0 in IS2, where CHAIN-ID -
> >> >>                                        20000 is the PAG value.
> >> >>                     Chain 21000-21000: Lookup-1 in IS2.
> >> >>
> >> >> All these chains should be optional - users should only need to
> >> >> configure the chains they need. To make this work, we need to
> >> >> configure both the desired actions (could be priority update) and the goto action.
> >> >> Remember in HW, all packets goes through this process, while in SW
> >> >> they only follow the "goto" path.
> >> >>
> 
> I agree with this chain assignment, following is an example to set rules:
> 
> 1. Set a matchall rule for each chain, the last chain do not need goto chain action.
> # tc filter add dev swp0 chain 0 flower skip_sw action goto chain 10000
> # tc filter add dev swp0 chain 10000 flower skip_sw action goto chain 21000
> In driver, use these rules to register the chain.
> 
> 2. Set normal rules.
> # tc filter add dev swp0 chain 10000 protocol 802.1Q parent ffff: flower skip_sw vlan_id 1 vlan_prio 1 action skbedit priority 1 action goto chain 21000
> # tc filter add dev swp0 chain 21000 protocol 802.1Q parent ffff: flower skip_sw vlan_id 1 vlan_prio 1 action drop
> 
> In driver, we check if the chain ID has been registered, and goto chain is the same as first matchall rule, if is not, then return error. Each rule need has goto action except last chain.
> 
> I also have check about chain template, it can not set an action template for each chain, so I think it's no use for our case. If this way to set rules is OK, I will update the patch to do as this.
> 
> Thanks,
> Xiaoliang Yang
> 

I agree that you cannot set an action template for each chain but you can set a match template which for example can be used for setting up which IS1 key to generate for the device/port.
The template ensures that you cannot add an illegal match.
I have attached a snippet from a testcase I wrote in order to test these ideas.
Note that not all actions are valid for the hardware.

SMAC       = "00:00:00:11:11:11"
DMAC       = "00:00:00:dd:dd:dd"
VID1       = 0x10
VID2       = 0x20
PCP1       = 3
PCP2       = 5
DEI        = 1
SIP        = "10.10.0.1"
DIP        = "10.10.0.2"

IS1_L0     = 10000 # IS1 lookup 0
IS1_L1     = 11000 # IS1 lookup 1
IS1_L2     = 12000 # IS1 lookup 2

IS2_L0     = 20000 # IS2 lookup 0 # IS2 20000 - 20255 -> pag 0-255
IS2_L0_P1  = 20001 # IS2 lookup 0 pag 1
IS2_L0_P2  = 20002 # IS2 lookup 0 pag 2

IS2_L1     = 21000 # IS2 lookup 1

$skip = "skip_hw" # or "skip_sw"

test "Chain templates and goto" do
    t_i "'prio #' sets the sequence of filters. Lowest number = highest priority = checked first. 0..0xffff"
    t_i "'handle #' is a reference to the filter. Use this is if you need to reference the filter later. 0..0xffffffff"
    t_i "'chain #' is the chain to use. Chain 0 is the default. Different chains can have different templates. 0..0xffffffff"
    $ts.dut.run "tc qdisc add dev #{$dp[0]} clsact"

    t_i "Add templates"
    t_i "Configure the VCAP port configuration to match the shortest key that fulfill the purpose"

    t_i "Create a template that sets IS1 lookup 0 to generate S1_NORMAL with S1_DMAC_DIP_ENA"
    t_i "If you match on both src and dst you will generate S1_7TUPLE"
    $ts.dut.run "tc chain add dev #{$dp[0]} ingress protocol ip chain #{IS1_L0} flower #{$skip} "\
                "dst_mac 00:00:00:00:00:00 "\
                "dst_ip 0.0.0.0 "

    t_i "Create a template that sets IS1 lookup 1 to generate S1_5TUPLE_IP4"
    $ts.dut.run "tc chain add dev #{$dp[0]} ingress protocol ip chain #{IS1_L1} flower #{$skip} "\
                "src_ip 0.0.0.0 "\
                "dst_ip 0.0.0.0 "

    t_i "Create a template that sets IS1 lookup 2 to generate S1_DBL_VID"
    $ts.dut.run "tc chain add dev #{$dp[0]} ingress protocol 802.1ad chain #{IS1_L2} flower #{$skip} "\
                "vlan_id 0 "\
                "vlan_prio 0 "\
                "vlan_ethtype 802.1q "\
                "cvlan_id 0 "\
                "cvlan_prio 0 "

    $ts.dut.run "tc chain show dev #{$dp[0]} ingress"

    t_i "Start the chaining party. We can have other matchall rules here but the last one must goto IS1"
    $ts.dut.run "tc filter add dev #{$dp[0]} ingress protocol all prio 0xffff handle 0x1 matchall #{$skip} "\
                "action goto chain #{IS1_L0} "
    
    t_i "Insert catch all last in chain IS1_L0. Note: Protocol == all and prio = max"
    t_i "flower must be used here in order to satisfy the template although it is used as a 'matchall' filter."
    t_i "Driver must enforce that every filter in chain IS1_L0 ends with a goto chain IS1_L1"
    $ts.dut.run "tc filter add dev #{$dp[0]} ingress protocol all prio 0xffff handle 0x199 chain #{IS1_L0} flower #{$skip} "\
                "action mirred egress mirror dev #{$dp[2]} "\
                "action goto chain #{IS1_L1} "

    t_i "Insert catch all last in chain IS1_L1. Note: Protocol == all and prio = max"
    t_i "flower must be used here in order to satisfy the template although it is used as a 'matchall' filter."
    t_i "Driver must enforce that every filter in chain IS1_L1 ends with a goto chain IS1_L2"
    $ts.dut.run "tc filter add dev #{$dp[0]} ingress protocol all prio 0xffff handle 0x299 chain #{IS1_L1} flower #{$skip} "\
                "action goto chain #{IS1_L2} "

    t_i "Insert catch all last in chain IS1_L2. Note: Protocol == all and prio = max"
    t_i "flower must be used here in order to satisfy the template although it is used as a 'matchall' filter."
    t_i "Driver must enforce that every filter in chain IS1_L2 ends with a goto chain IS2_L0 + PAG value 0..255"
    $ts.dut.run "tc filter add dev #{$dp[0]} ingress protocol all prio 0xffff handle 0x399 chain #{IS1_L2} flower #{$skip} "\
                "action continue " # goto IS2!

    t_i "Insert in chain IS1_L0"
    $ts.dut.run "tc filter add dev #{$dp[0]} ingress protocol ip prio 10 handle 0x100 chain #{IS1_L0} flower #{$skip} "\
                "dst_mac #{DMAC} "\
                "dst_ip #{DIP} "\
                "action goto chain #{IS1_L1} "

    t_i "Insert in chain IS1_L1"
    $ts.dut.run "tc filter add dev #{$dp[0]} ingress protocol ip prio 11 handle 0x200 chain #{IS1_L1} flower #{$skip} "\
                "src_ip #{SIP} "\
                "dst_ip #{DIP} "\
                "action goto chain #{IS1_L2} "

    t_i "Insert in chain IS1_L1"
    $ts.dut.run "tc filter add dev #{$dp[0]} ingress protocol ip prio 12 handle 0x201 chain #{IS1_L1} flower #{$skip} "\
                "dst_ip #{DIP} "\
                "action goto chain #{IS1_L2} "

    t_i "Insert in chain IS1_L2"
    $ts.dut.run "tc filter add dev #{$dp[0]} ingress protocol 802.1ad prio 11 handle 0x300 chain #{IS1_L2} flower #{$skip} "\
                "vlan_id 10 "\
                "vlan_prio 1 "\
                "vlan_ethtype 802.1q "\
                "cvlan_id 20 "\
                "cvlan_prio 2 "\
                "action pass " # TODO: goto IS2!

    # TODO: Add IS2

    t_i "Test invalid inserts that must fail"
    $ts.dut.run_err "tc filter add dev #{$dp[0]} ingress protocol ip chain #{IS1_L0} flower #{$skip} "\
                    "src_ip 10.10.0.0/16 "\
                    "action drop"

    $ts.dut.run_err "tc filter add dev #{$dp[0]} ingress protocol ip chain #{IS1_L1} flower #{$skip} "\
                    "dst_mac aa:11:22:33:44:55/00:00:ff:00:00:00 "\
                    "action drop"

    $ts.dut.run_err "tc filter add dev #{$dp[0]} ingress protocol ip chain #{IS1_L2} flower #{$skip} "\
                    "ip_proto udp "\
                    "action drop"
end
                                                                                        

-- 
Joergen Andreasen, Microchip
