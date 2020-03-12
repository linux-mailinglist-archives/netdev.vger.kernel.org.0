Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A0EA183D5E
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 00:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726842AbgCLXcl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 12 Mar 2020 19:32:41 -0400
Received: from mga03.intel.com ([134.134.136.65]:11238 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726513AbgCLXck (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Mar 2020 19:32:40 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Mar 2020 16:32:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,546,1574150400"; 
   d="scan'208";a="444116838"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.26])
  by fmsmga006.fm.intel.com with ESMTP; 12 Mar 2020 16:32:38 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Po Liu <po.liu@nxp.com>,
        "davem\@davemloft.net" <davem@davemloft.net>,
        "hauke.mehrtens\@intel.com" <hauke.mehrtens@intel.com>,
        "gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "allison\@lohutok.net" <allison@lohutok.net>,
        "tglx\@linutronix.de" <tglx@linutronix.de>,
        "hkallweit1\@gmail.com" <hkallweit1@gmail.com>,
        "saeedm\@mellanox.com" <saeedm@mellanox.com>,
        "andrew\@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli\@gmail.com" <f.fainelli@gmail.com>,
        "alexandru.ardelean\@analog.com" <alexandru.ardelean@analog.com>,
        "jiri\@mellanox.com" <jiri@mellanox.com>,
        "ayal\@mellanox.com" <ayal@mellanox.com>,
        "pablo\@netfilter.org" <pablo@netfilter.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "simon.horman\@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: RE: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame preemption of traffic classes
In-Reply-To: <VE1PR04MB64968E2DE71D1BCE48C6E17192EE0@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com> <87a75br4ze.fsf@linux.intel.com> <VE1PR04MB64968E2DE71D1BCE48C6E17192EE0@VE1PR04MB6496.eurprd04.prod.outlook.com>
Date:   Thu, 12 Mar 2020 16:34:50 -0700
Message-ID: <87a74lgnad.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Po Liu <po.liu@nxp.com> writes:

> Hi Vinicius,
>
>
> Br,
> Po Liu
>
>> -----Original Message-----
>> From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>> Sent: 2020年2月22日 5:44
>> To: Po Liu <po.liu@nxp.com>; davem@davemloft.net;
>> hauke.mehrtens@intel.com; gregkh@linuxfoundation.org; allison@lohutok.net;
>> tglx@linutronix.de; hkallweit1@gmail.com; saeedm@mellanox.com;
>> andrew@lunn.ch; f.fainelli@gmail.com; alexandru.ardelean@analog.com;
>> jiri@mellanox.com; ayal@mellanox.com; pablo@netfilter.org; linux-
>> kernel@vger.kernel.org; netdev@vger.kernel.org
>> Cc: simon.horman@netronome.com; Claudiu Manoil
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
>> Hi,
>> 
>> Po Liu <po.liu@nxp.com> writes:
>> 
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
>> >
>> > Command 'ethtool devname' and 'ethtool -s devname preemption N'
>> > would show/set which traffic classes are frame preemptable.
>> >
>> > Port driver would implement the frame preemption in the function
>> > get_link_ksettings() and set_link_ksettings() in the struct ethtool_ops.
>> >
>> 
>> Any updates on this series? If you think that there's something that I could help,
>> just tell.
>
> Sorry for the long time not involve the discussion. I am focus on other tsn code for tc flower.
> If you can take more about this preemption serial, that would be good.
>
> I summary some suggestions from Marali Karicheri and Ivan Khornonzhuk and by you and also others:
> - Add config the fragment size, hold advance, release advance and flags;
>     My comments about the fragment size is in the Qbu spec limit the fragment size " the minimum non-final fragment size is 64,
> 128, 192, or 256 octets " this setting would affect the guardband setting for Qbv. But the ethtool setting could not involve this issues but by the taprio side.
> - " Furthermore, this setting could be extend for a serial setting for mac and traffic class."  "Better not to using the traffic class concept."
>    Could adding a serial setting by "ethtool --preemption xxx" or other name. I don' t think it is good to involve in the queue control since queues number may bigger than the TC number.
> - The ethtool is the better choice to configure the preemption
>   I agree.

Just a quick update. I was able to dedicate some time to this, and have
something aproaching RFC-quality, but it needs more testing.

So, question, what were you using for testing this? Anything special?

And btw, thanks for the summary of the discussion.

>
> Thanks！
>> 
>> 
>> Cheers,
>> --
>> Vinicius


-- 
Vinicius
