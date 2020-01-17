Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 075B11414E7
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 00:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730321AbgAQXqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 18:46:02 -0500
Received: from mga03.intel.com ([134.134.136.65]:38944 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730184AbgAQXqC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jan 2020 18:46:02 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jan 2020 15:46:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,332,1574150400"; 
   d="scan'208";a="426165804"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.26])
  by fmsmga006.fm.intel.com with ESMTP; 17 Jan 2020 15:46:00 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     Po Liu <po.liu@nxp.com>,
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
        "simon.horman\@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
Subject: Re: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame preemption of traffic classes
In-Reply-To: <2400f5bd-eb82-23ad-215f-bf4ae5eb66a8@ti.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com> <157603276975.18462.4638422874481955289@pipeline> <VE1PR04MB6496CEA449E9B844094E580492510@VE1PR04MB6496.eurprd04.prod.outlook.com> <87eex43pzm.fsf@linux.intel.com> <20191219004322.GA20146@khorivan> <87lfr9axm8.fsf@linux.intel.com> <2400f5bd-eb82-23ad-215f-bf4ae5eb66a8@ti.com>
Date:   Fri, 17 Jan 2020 15:47:04 -0800
Message-ID: <8736cd4pdz.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Murali Karicheri <m-karicheri2@ti.com> writes:

[...]

>>>
>>> 2) What if I want to use frame preemption with another "transmission selection
>>> algorithm"? Say another one "time sensitive" - CBS? How is it going to be
>>> stacked?
>> 
>> I am not seeing any (conceptual*) problems when plugging a cbs (for
>> example) qdisc into one of taprio children. Or, are you talking about a
>> more general problem?
>> 
>
> If I understand it correctly problem is not stacking taprio with cbs,
> but rather pre-emption with other qdiscs and allow configuring
> the parameters such as frag size. How do I use frame pre-emption as
> an independent feature and configure frag size? Ethool appears to be
> better from this point of view as Ivan has mentioned below.
>

Yeah, after all the discussion here, I think we came to the rough
consensus that ethtool is the best place we have to enable/disable frame
preemption and its configuration knobs.

I just have a few comments to add to the series (sorry for the long
delay).


Cheers,
--
Vinicius
