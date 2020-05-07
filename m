Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8322F1C9B0F
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 21:29:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbgEGT3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 15:29:06 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:5100 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726320AbgEGT3G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 15:29:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1588879745; x=1620415745;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kUD9Cq9Eg8ZUdHPqFwtCoPURI8ru60H4eEns1xViiDA=;
  b=IPI0L4Ld8Isq9gzEcfU5EWq8hg0Z/x/OfVcwok82FWFiy8VBNKWURSn2
   5POY55TcbRexO9tQLdlxlizWjY9qI6wfS3V9DktVANapLqr1c/EjpyLOp
   YDbceQ845CeTo77g3SIeikLbiGtK6X/grbi8kZ8DDfBitb9RbxPEHWTii
   YRhCaeFIUN8+cmcFqoI6OS/1i//PClbi0zEgljndY3iXOhOzvsVh1v6DF
   lpcr8CyaUF1Ypsfrbl3gPS1Y/5xUMqFNCGuKog3UXVSN/AH7cidiXnJY/
   K/Z0q5P8A7BGcXu4yw77HJG2U+lgFw63ckmat50R8a74IXHaVdrn6vpc7
   A==;
IronPort-SDR: ZCUPRRcnf/MRnKA9qCq6C0dwZ3PinEIW3bMjCNlH1zDuOMehmOXu2tGFZuLt7UU7W+m/kxgYPs
 K8FLFUKJnBP/OAEHjabKiovbWrr9NuMmG2aI77FjGAwF8MYV5q3TlYxdSPy7i6jqfM4wEPRQsn
 LwNZIpVKM4aUwgz3liRLtZrnOJ/RBTgA/TOaGgDz168j6F1/k4zCN6BBdqAh1JvDekJJg3WTph
 ftAcXQMyi7/N7pCLxiv2JqiZFLAYNjsW3O4Ae0m1+wZYU19WBpQ8O8vxU+Ms12QwZ/OxpYm9us
 fvg=
X-IronPort-AV: E=Sophos;i="5.73,364,1583218800"; 
   d="scan'208";a="78739973"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 May 2020 12:29:04 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 May 2020 12:29:04 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Thu, 7 May 2020 12:29:04 -0700
Date:   Thu, 7 May 2020 21:29:03 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
CC:     Vladimir Oltean <olteanv@gmail.com>, Po Liu <po.liu@nxp.com>,
        "Claudiu Manoil" <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "Leo Li" <leoyang.li@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
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
        "linux-devel@linux.nxdi.nxp.com" <linux-devel@linux.nxdi.nxp.com>
Subject: Re: [EXT] Re: [PATCH v1 net-next 4/6] net: mscc: ocelot: VCAP IS1
 support
Message-ID: <20200507192903.whnx2j3f35ga7jzx@ws.localdomain>
References: <20200506074900.28529-1-xiaoliang.yang_1@nxp.com>
 <20200506074900.28529-5-xiaoliang.yang_1@nxp.com>
 <20200506094345.n4zdgjvctwiz4pkh@ws.localdomain>
 <CA+h21hoqJC_CJB=Sg=-JanXw3S_WANgjsfYjU+ffqn6YCDMzrA@mail.gmail.com>
 <20200506211551.cf6mlad7ysmuqfvq@ws.localdomain>
 <DB8PR04MB5785BE9AC6FAC6F395C8A20DF0A50@DB8PR04MB5785.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <DB8PR04MB5785BE9AC6FAC6F395C8A20DF0A50@DB8PR04MB5785.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.05.2020 11:23, Xiaoliang Yang wrote:
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>
>Hi Allan,
>
>
>> Hi Vladimir,
>>
>> On 06.05.2020 13:53, Vladimir Oltean wrote:
>[snip]
>> >At the moment, the driver does not support more than 1 action. We might
>> >need to change that, but we can still install more filters with the
>> >same key and still be fine (see more below). When there is more than 1
>> >action, the IS1 stuff will be combined into a single rule programmed
>> >into IS1, and the IS2 stuff will be combined into a single new rule
>> >with the same keys installed into VCAP IS2. Would that not work?
>> >
>> >> The SW model have these two rules in the same table, and can stop
>> >> process at the first match. SW will do the action of the first frame
>> >> matching.
>> >>
>> >
>> >Actually I think this is an incorrect assumption - software stops at
>> >the first action only if told to do so. Let me copy-paste a text from a
>> >different email thread.
>>
>> I'm still not able to see how this proposal will give us the same behavioral in SW and in HW.
>>
>> A simple example:
>>
>> tc qdisc add dev enp0s3 ingress
>> tc filter add dev enp0s3 protocol 802.1Q parent ffff: \
>>      prio 10 flower vlan_id 5 action vlan modify id 10 tc filter add dev enp0s3 protocol 802.1Q parent ffff: \
>>      prio 20 flower src_mac 00:00:00:00:00:08 action drop
>>
>> We can then inject a frame with VID 5 and smac ::08:
>> $ ef tx tap0 eth smac 00:00:00:00:00:08 ctag vid 5
>>
>> We can then check the filter and see that it only hit the first rule:
>>
>> $ tc -s filter show dev enp0s3 ingress
>> filter protocol 802.1Q pref 10 flower chain 0 filter protocol 802.1Q pref 10 flower chain 0 handle 0x1
>>    vlan_id 5
>>    not_in_hw
>>          action order 1: vlan  modify id 10 protocol 802.1Q priority 0 pipe
>>           index 1 ref 1 bind 1 installed 19 sec used 6 sec
>>          Action statistics:
>>          Sent 42 bytes 1 pkt (dropped 0, overlimits 0 requeues 0)
>>          backlog 0b 0p requeues 0
>>
>> filter protocol 802.1Q pref 20 flower chain 0 filter protocol 802.1Q pref 20 flower chain 0 handle 0x1
>>   src_mac 00:00:00:00:00:08
>>   not_in_hw
>>         action order 1: gact action drop
>>          random type none pass val 0
>>          index 1 ref 1 bind 1 installed 11 sec used 11 sec
>>         Action statistics:
>>         Sent 0 bytes 0 pkt (dropped 0, overlimits 0 requeues 0)
>>         backlog 0b 0p requeues 0
>>
>> If this was done with the proposed HW offload, then both rules would have been hit and we would have a different behavioral.
>>
>> This can be fixed by adding the "continue" action to the first rule:
>
>> tc filter add dev enp0s3 protocol 802.1Q parent ffff: \
>>      prio 10 flower vlan_id 5 action vlan modify id 10 continue tc filter add dev enp0s3 protocol 802.1Q parent ffff: \
>>      prio 20 flower src_mac 00:00:00:00:00:08 action drop
>>
>> But that would again break if we add 2 rules manipulating the VLAN (as the HW does not continue with in a single TCAM).
>>
>> My point is: I do not think we can hide the fact that this is done in independent TCAMs in the silicon.
>>
>> I think it is possible to do this with the chain feature (even though it is not a perfect match), but it would require more analysis.
>>
>> /Allan
>
>Do you mean it's better to set vlan modify filters in a different chain, and write the filter entries with a same chain in the same VCAP TCAM?
>For example:
>        tc filter add dev enp0s3 protocol 802.1Q chain 11 parent ffff: prio 10 flower skip_sw vlan_id 5 action vlan modify id 10
>        tc filter add dev enp0s3 protocol 802.1Q chain 22 parent ffff: prio 20 flower skip_sw src_mac 00:00:00:00:00:08 action drop
>for this usage, we only need to ensure a chain corresponding to a VCAP in ocelot ace driver. I'm not sure is my understanding right?

I still have not found a satisfying solution to this. As I understand
the chains, they require the "goto" action to be used to tie them
together.

We could use that to represent a single lookup in is1 and link that to a
lookup in is2. Not sure if we should, it will also require
(non-backwards compatible) changes in how the existing IS2 support is
working.

Again, I do not have the answer (I'm also looking for it), but I think
we need something where it is clear to the user that this end up in
different lists.

/Allan


