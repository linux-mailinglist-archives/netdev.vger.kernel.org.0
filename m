Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7AD11C7C2D
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbgEFVP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:15:56 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:27581 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730010AbgEFVPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 17:15:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1588799754; x=1620335754;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=T+Ll8tZc9vYZAorA7aIZMRWepCCE5u9iReBymxXDYg4=;
  b=YExOBa0Ch2lsnTIEv/S2mEh8T46XKYqyMARqFAr69/rKuamBopfLTTLK
   aerPG8KU595F0DczxIGp8ebK+tTozNpXL0BIKcCUiqZlkBLTXg8TpFVs/
   HnDltDCkQgsykFEzJBgbzzdsrS//6nLqHpqwBybVS2ommFPkmtfG4bQOW
   mKKkzclZp/9jkZFRPrJrAIrb1xqg3SFDycWK3iOWI5EXPBM84m+jWRNf7
   hsNVGubs0kjP/TSqppG+tGnu5vEVeWPfLuo1aYpfqcvAc7NzcOky5MTxU
   x1FjBgFnjLpTHLXPYMfaKNjZ04VXAU7o1Zi+yAeTckxRA/OQ5i+qF1Mud
   w==;
IronPort-SDR: FAxJtZKujh/IpUWRggqLlWrFDVr26ZPMRf8zPt/VsCzUf9getOXlzsPn7K/I4p/GlbYUgNblYn
 jINB5g8TEnmy86dtrqlFYQca+eBxKXYN7AqCPhwDggg38p/i9OLbgurop55ZXXhIqit23sLHkf
 wXDlFz57QhcFDL4INrSq5UDtkE/Ei5qewuIyETqp0hNYW9l1F0nb6v4FCviMWpyA6nOB+loiUp
 rOxY0/VR5mPFW50sX0glTzpHkFLtNMcWmWFEpDSfyprVaZkjsrGizGB1NFR0IRZQjWeulJYjH2
 aIA=
X-IronPort-AV: E=Sophos;i="5.73,360,1583218800"; 
   d="scan'208";a="74455046"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 May 2020 14:15:53 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 6 May 2020 14:15:55 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Wed, 6 May 2020 14:15:54 -0700
Date:   Wed, 6 May 2020 23:15:51 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "Li Yang" <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jiri Pirko" <jiri@resnulli.us>, Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        <linux-devel@linux.nxdi.nxp.com>
Subject: Re: [PATCH v1 net-next 4/6] net: mscc: ocelot: VCAP IS1 support
Message-ID: <20200506211551.cf6mlad7ysmuqfvq@ws.localdomain>
References: <20200506074900.28529-1-xiaoliang.yang_1@nxp.com>
 <20200506074900.28529-5-xiaoliang.yang_1@nxp.com>
 <20200506094345.n4zdgjvctwiz4pkh@ws.localdomain>
 <CA+h21hoqJC_CJB=Sg=-JanXw3S_WANgjsfYjU+ffqn6YCDMzrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <CA+h21hoqJC_CJB=Sg=-JanXw3S_WANgjsfYjU+ffqn6YCDMzrA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

On 06.05.2020 13:53, Vladimir Oltean wrote:
>On Wed, 6 May 2020 at 12:45, Allan W. Nielsen
><allan.nielsen@microchip.com> wrote:
>>
>> Hi Xiaoliang,
>>
>> On 06.05.2020 15:48, Xiaoliang Yang wrote:
>> >VCAP IS1 is a VCAP module which can filter MAC, IP, VLAN, protocol, and
>> >TCP/UDP ports keys, and do Qos and VLAN retag actions.
>> >This patch added VCAP IS1 support in ocelot ace driver, which can supports
>> >vlan modify action of tc filter.
>> >Usage:
>> >        tc qdisc add dev swp0 ingress
>> >        tc filter add dev swp0 protocol 802.1Q parent ffff: flower \
>> >        skip_sw vlan_id 1 vlan_prio 1 action vlan modify id 2 priority 2
>> I skimmed skimmed through the patch serie, and the way I understood it
>> is that you look at the action, and if it is a VLAN operation, then you
>> put it in IS1 and if it is one of the other then put it in IS2.
>>
>> This is how the HW is designed - I'm aware of that.
>>
>> But how will this work if you have 2 rules, 1 modifying the VLAN and
>> another rule dropping certain packets?
>>
>
>At the moment, the driver does not support more than 1 action. We
>might need to change that, but we can still install more filters with
>the same key and still be fine (see more below). When there is more
>than 1 action, the IS1 stuff will be combined into a single rule
>programmed into IS1, and the IS2 stuff will be combined into a single
>new rule with the same keys installed into VCAP IS2. Would that not
>work?
>
>> The SW model have these two rules in the same table, and can stop
>> process at the first match. SW will do the action of the first frame
>> matching.
>>
>
>Actually I think this is an incorrect assumption - software stops at
>the first action only if told to do so. Let me copy-paste a text from
>a different email thread.

I'm still not able to see how this proposal will give us the same
behavioral in SW and in HW.

A simple example:

tc qdisc add dev enp0s3 ingress
tc filter add dev enp0s3 protocol 802.1Q parent ffff: \
     prio 10 flower vlan_id 5 action vlan modify id 10
tc filter add dev enp0s3 protocol 802.1Q parent ffff: \
     prio 20 flower src_mac 00:00:00:00:00:08 action drop

We can then inject a frame with VID 5 and smac ::08:
$ ef tx tap0 eth smac 00:00:00:00:00:08 ctag vid 5 

We can then check the filter and see that it only hit the first rule:

$ tc -s filter show dev enp0s3 ingress
filter protocol 802.1Q pref 10 flower chain 0
filter protocol 802.1Q pref 10 flower chain 0 handle 0x1
   vlan_id 5
   not_in_hw
         action order 1: vlan  modify id 10 protocol 802.1Q priority 0 pipe
          index 1 ref 1 bind 1 installed 19 sec used 6 sec
         Action statistics:
         Sent 42 bytes 1 pkt (dropped 0, overlimits 0 requeues 0)
         backlog 0b 0p requeues 0

filter protocol 802.1Q pref 20 flower chain 0
filter protocol 802.1Q pref 20 flower chain 0 handle 0x1
   src_mac 00:00:00:00:00:08
   not_in_hw
         action order 1: gact action drop
          random type none pass val 0
          index 1 ref 1 bind 1 installed 11 sec used 11 sec
         Action statistics:
         Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
         backlog 0b 0p requeues 0

If this was done with the proposed HW offload, then both rules would
have been hit and we would have a different behavioral.

This can be fixed by adding the "continue" action to the first rule:

tc filter add dev enp0s3 protocol 802.1Q parent ffff: \
     prio 10 flower vlan_id 5 action vlan modify id 10 continue
tc filter add dev enp0s3 protocol 802.1Q parent ffff: \
     prio 20 flower src_mac 00:00:00:00:00:08 action drop

But that would again break if we add 2 rules manipulating the VLAN (as
the HW does not continue with in a single TCAM).

My point is: I do not think we can hide the fact that this is done
in independent TCAMs in the silicon.

I think it is possible to do this with the chain feature (even though it
is not a perfect match), but it would require more analysis.

/Allan

