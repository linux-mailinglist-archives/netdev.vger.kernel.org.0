Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0690116EF60
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 20:48:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730637AbgBYTsq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 14:48:46 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:40696 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728443AbgBYTsq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 14:48:46 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01PHprpF117879;
        Tue, 25 Feb 2020 11:51:53 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1582653113;
        bh=/d5Vd5oiaQH19vYJUAtx0fN3kkFJcOQ0EtyuBQuYOwY=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=kCihkCk38atKc2IxuB5xoD9DirvUYwJcUd1ugSK0if2KKycinf/7Bm1jPAKnj1+9u
         UE9pvz+empMdjcCuQuojTptgqCD8G4tT/qQbWxs2MArXWVSmxrHnvO+dmTOjjnTWgh
         A6zZFtxD6fYyHo/PENXqmEicRNBEraLhBTf+hQ9g=
Received: from DFLE102.ent.ti.com (dfle102.ent.ti.com [10.64.6.23])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01PHprKL018788
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Feb 2020 11:51:53 -0600
Received: from DFLE113.ent.ti.com (10.64.6.34) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 25
 Feb 2020 11:51:53 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 25 Feb 2020 11:51:53 -0600
Received: from [158.218.117.45] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01PHpppQ060872;
        Tue, 25 Feb 2020 11:51:51 -0600
Subject: Re: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame
 preemption of traffic classes
To:     Po Liu <po.liu@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hauke.mehrtens@intel.com" <hauke.mehrtens@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "allison@lohutok.net" <allison@lohutok.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "alexandru.ardelean@analog.com" <alexandru.ardelean@analog.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "ayal@mellanox.com" <ayal@mellanox.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
References: <20191127094517.6255-1-Po.Liu@nxp.com>
 <87a75br4ze.fsf@linux.intel.com>
 <VE1PR04MB64968E2DE71D1BCE48C6E17192EE0@VE1PR04MB6496.eurprd04.prod.outlook.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <7d68d83c-c81d-5221-b843-07adb40e4b93@ti.com>
Date:   Tue, 25 Feb 2020 12:59:03 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <VE1PR04MB64968E2DE71D1BCE48C6E17192EE0@VE1PR04MB6496.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Po,

On 02/21/2020 10:26 PM, Po Liu wrote:
> Hi Vinicius,
> 
> 
> Br,
> Po Liu
> 
>> -----Original Message-----
>> From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>> Sent: 2020Äê2ÔÂ22ÈÕ 5:44
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
>>> IEEE Std 802.1Qbu standard defined the frame preemption of port
>>> traffic classes. This patch introduce a method to set traffic classes
>>> preemption. Add a parameter 'preemption' in struct
>>> ethtool_link_settings. The value will be translated to a binary, each
>>> bit represent a traffic class. Bit "1" means preemptable traffic
>>> class. Bit "0" means express traffic class.  MSB represent high number
>>> traffic class.
>>>
>>> If hardware support the frame preemption, driver could set the
>>> ethernet device with hw_features and features with NETIF_F_PREEMPTION
>>> when initializing the port driver.
>>>
>>> User can check the feature 'tx-preemption' by command 'ethtool -k
>>> devname'. If hareware set preemption feature. The property would be a
>>> fixed value 'on' if hardware support the frame preemption.
>>> Feature would show a fixed value 'off' if hardware don't support the
>>> frame preemption.
>>>
>>> Command 'ethtool devname' and 'ethtool -s devname preemption N'
>>> would show/set which traffic classes are frame preemptable.
>>>
>>> Port driver would implement the frame preemption in the function
>>> get_link_ksettings() and set_link_ksettings() in the struct ethtool_ops.
>>>
>>
>> Any updates on this series? If you think that there's something that I could help,
>> just tell.
> 
> Sorry for the long time not involve the discussion. I am focus on other tsn code for tc flower.
> If you can take more about this preemption serial, that would be good.
> 
> I summary some suggestions from Marali Karicheri and Ivan Khornonzhuk and by you and also others:

It is Murali :)

> - Add config the fragment size, hold advance, release advance and flags;

  - I believe hold advance, release advance values are read only

>      My comments about the fragment size is in the Qbu spec limit the fragment size " the minimum non-final fragment size is 64,
> 128, 192, or 256 octets " this setting would affect the guardband setting for Qbv. But the ethtool setting could not involve this issues but by the taprio side.
> - " Furthermore, this setting could be extend for a serial setting for mac and traffic class."  "Better not to using the traffic class concept."
  - Couldn't understand the above? Could you please explain a bit more
    on what you meant here?

Murali
>     Could adding a serial setting by "ethtool --preemption xxx" or other name. I don' t think it is good to involve in the queue control since queues number may bigger than the TC number.
> - The ethtool is the better choice to configure the preemption
>    I agree.
> 
> Thanks£¡
>>
>>
>> Cheers,
>> --
>> Vinicius

-- 
Murali Karicheri
Texas Instruments
