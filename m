Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23EB0121C1F
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 22:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfLPVnx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 16 Dec 2019 16:43:53 -0500
Received: from mga03.intel.com ([134.134.136.65]:65082 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726891AbfLPVnx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 16:43:53 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Dec 2019 13:43:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,323,1571727600"; 
   d="scan'208";a="416594399"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.26])
  by fmsmga006.fm.intel.com with ESMTP; 16 Dec 2019 13:43:50 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Po Liu <po.liu@nxp.com>,
        Andre Guedes <andre.guedes@linux.intel.com>,
        "alexandru.ardelean\@analog.com" <alexandru.ardelean@analog.com>,
        "allison\@lohutok.net" <allison@lohutok.net>,
        "andrew\@lunn.ch" <andrew@lunn.ch>,
        "ayal\@mellanox.com" <ayal@mellanox.com>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "f.fainelli\@gmail.com" <f.fainelli@gmail.com>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hauke.mehrtens\@intel.com" <hauke.mehrtens@intel.com>,
        "hkallweit1\@gmail.com" <hkallweit1@gmail.com>,
        "jiri\@mellanox.com" <jiri@mellanox.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "pablo\@netfilter.org" <pablo@netfilter.org>,
        "saeedm\@mellanox.com" <saeedm@mellanox.com>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     "simon.horman\@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: RE: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame preemption of traffic classes
In-Reply-To: <VE1PR04MB6496CEA449E9B844094E580492510@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com> <157603276975.18462.4638422874481955289@pipeline> <VE1PR04MB6496CEA449E9B844094E580492510@VE1PR04MB6496.eurprd04.prod.outlook.com>
Date:   Mon, 16 Dec 2019 13:44:13 -0800
Message-ID: <87eex43pzm.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Po,

Po Liu <po.liu@nxp.com> writes:

> Hi Andre,
>
>
> Br,
> Po Liu
>
>> -----Original Message-----
>> From: Andre Guedes <andre.guedes@linux.intel.com>
>> Sent: 2019年12月11日 10:53
>> To: alexandru.ardelean@analog.com; allison@lohutok.net; andrew@lunn.ch;
>> ayal@mellanox.com; davem@davemloft.net; f.fainelli@gmail.com;
>> gregkh@linuxfoundation.org; hauke.mehrtens@intel.com;
>> hkallweit1@gmail.com; jiri@mellanox.com; linux-kernel@vger.kernel.org;
>> netdev@vger.kernel.org; pablo@netfilter.org; saeedm@mellanox.com;
>> tglx@linutronix.de; Po Liu <po.liu@nxp.com>
>> Cc: vinicius.gomes@intel.com; simon.horman@netronome.com; Claudiu Manoil
>> <claudiu.manoil@nxp.com>; Vladimir Oltean <vladimir.oltean@nxp.com>;
>> Alexandru Marginean <alexandru.marginean@nxp.com>; Xiaoliang Yang
>> <xiaoliang.yang_1@nxp.com>; Roy Zang <roy.zang@nxp.com>; Mingkai Hu
>> <mingkai.hu@nxp.com>; Jerry Huang <jerry.huang@nxp.com>; Leo Li
>> <leoyang.li@nxp.com>; Po Liu <po.liu@nxp.com>
>> Subject: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame preemption of
>> traffic classes
>> 
>> Caution: EXT Email
>> 
>> Hi Po,
>> 
>> Quoting Po Liu (2019-11-27 01:59:18)
>> > IEEE Std 802.1Qbu standard defined the frame preemption of port
>> > traffic classes. This patch introduce a method to set traffic classes
>> > preemption. Add a parameter 'preemption' in struct
>> > ethtool_link_settings. The value will be translated to a binary, each
>> > bit represent a traffic class. Bit "1" means preemptable traffic
>> > class. Bit "0" means express traffic class.  MSB represent high number
>> > traffic class.
>> >
>> > If hardware support the frame preemption, driver could set the
>> > ethernet device with hw_features and features with NETIF_F_PREEMPTION
>> > when initializing the port driver.
>> >
>> > User can check the feature 'tx-preemption' by command 'ethtool -k
>> > devname'. If hareware set preemption feature. The property would be a
>> > fixed value 'on' if hardware support the frame preemption.
>> > Feature would show a fixed value 'off' if hardware don't support the
>> > frame preemption.

Having some knobs in ethtool to enable when/how Frame Preemption is
advertised on the wire makes sense. I also agree that it should be "on"
by default.

>> >
>> > Command 'ethtool devname' and 'ethtool -s devname preemption N'
>> > would show/set which traffic classes are frame preemptable.
>> >
>> > Port driver would implement the frame preemption in the function
>> > get_link_ksettings() and set_link_ksettings() in the struct ethtool_ops.
>> 
>> In an early RFC series [1], we proposed a way to support frame preemption. I'm
>> not sure if you have considered it before implementing this other proposal
>> based on ethtool interface so I thought it would be a good idea to bring that up
>> to your attention, just in case.
>  
> Sorry, I didn't notice the RFC proposal. Using ethtool set the
> preemption just thinking about 8021Qbu as standalone. And not limit to
> the taprio if user won't set 802.1Qbv.

I see your point of using frame-preemption "standalone", I have two
ideas:

 1. add support in taprio to be configured without any schedule in the
 "full offload" mode. In practice, allowing taprio to work somewhat
 similar to (mqprio + frame-preemption), changes in the code should de
 fairly small;

 2. extend mqprio to support frame-preemption;

>
> As some feedback  also want to set the MAC merge minimal fragment size
> and get some more information of 802.3br.

The minimal fragment size, I guess, also makes sense to be kept in
ethtool. That is we have a sane default, and allow the user to change
this setting for special cases.

>
>> 
>> In that initial proposal, Frame Preemption feature is configured via taprio qdisc.
>> For example:
>> 
>> $ tc qdisc add dev IFACE parent root handle 100 taprio \
>>       num_tc 3 \
>>       map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
>>       queues 1@0 1@1 2@2 \
>>       preemption 0 1 1 1 \
>>       base-time 10000000 \
>>       sched-entry S 01 300000 \
>>       sched-entry S 02 300000 \
>>       sched-entry S 04 400000 \
>>       clockid CLOCK_TAI
>> 
>> It also aligns with the gate control operations Set-And-Hold-MAC and Set-And-
>> Release-MAC that can be set via 'sched-entry' (see Table 8.7 from
>> 802.1Q-2018 for further details.
>  
> I am curious about Set-And-Hold-Mac via 'sched-entry'. Actually, it
> could be understand as guardband by hardware preemption. MAC should
> auto calculate the nano seconds before  express entry slot start to
> break to two fragments. Set-And-Hold-MAC should minimal larger than
> the fragment-size oct times.

Another interesting point. My first idea is that when the schedule is
offloaded to the driver and the driver detects that the "entry" width is
smaller than the fragment side, the driver could reject that schedule
with a nice error message.

>
>> 
>> Please share your thoughts on this.
>
> I am good to see there is frame preemption proposal. Each way is ok
> for me but ethtool is more flexible. I've seen the RFC the code. The
> hardware offload is in the mainline, but preemption is not yet, I
> don't know why. Could you post it again?

It's not mainline because this kind of stuff will not be accepted
upstream without in-tree users. And you are the first one to propose
such a thing :-)

It's just now that I have something that supports frame-preemption, the
code I have is approaching RFC-like quality. I will send another RFC
this week hopefully, and we can see how things look in practice.


Cheers,
--
Vinicius
