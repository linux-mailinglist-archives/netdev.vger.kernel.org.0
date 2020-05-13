Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7011D1806
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 16:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389090AbgEMO40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 10:56:26 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:40854 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728568AbgEMO40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 10:56:26 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04DEtnKA048125;
        Wed, 13 May 2020 09:55:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589381749;
        bh=0p70bdl/DS8LJV46/WfQvFGJxPDm65T9Js3GVTop9dg=;
        h=Subject:From:To:CC:References:Date:In-Reply-To;
        b=zWu3kFMzU/DCSvMnR/s0IFIFNhAMtMgw9sMCpqszjl/l80veVM8pdSI2BsRVDxW3p
         9oUklYXB7G0nz7t6hJjkPdVVsQoQmor7Kh8z/6SbMP/8rRFdqyW7jDtl2l8Jt9N1ie
         hT3z1YD+4MkcqqRqKn8doeP0AdWESkd/86B9ng2U=
Received: from DFLE110.ent.ti.com (dfle110.ent.ti.com [10.64.6.31])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 04DEtnZh116739
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 13 May 2020 09:55:49 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 13
 May 2020 09:55:48 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 13 May 2020 09:55:48 -0500
Received: from [10.250.74.234] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04DEtloQ101784;
        Wed, 13 May 2020 09:55:47 -0500
Subject: Re: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame
 preemption of traffic classes
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Po Liu <po.liu@nxp.com>,
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
 <87a74lgnad.fsf@linux.intel.com>
 <1c06e30e-8999-2c40-e631-1d67b3d9ce39@ti.com>
Message-ID: <968be6d0-813e-c820-1fec-0ac85c838e7f@ti.com>
Date:   Wed, 13 May 2020 10:55:47 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1c06e30e-8999-2c40-e631-1d67b3d9ce39@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On 3/18/20 10:07 AM, Murali Karicheri wrote:
> Hi Vinicius,
> 
> On 03/12/2020 07:34 PM, Vinicius Costa Gomes wrote:
>> Hi,
>>
>> Po Liu <po.liu@nxp.com> writes:
>>
>>> Hi Vinicius,
>>>
>>>
>>> Br,
>>> Po Liu
>>>
>>>> -----Original Message-----
>>>> From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>>>> Sent: 2020年2月22日 5:44
>>>> To: Po Liu <po.liu@nxp.com>; davem@davemloft.net;
>>>> hauke.mehrtens@intel.com; gregkh@linuxfoundation.org; 
>>>> allison@lohutok.net;
>>>> tglx@linutronix.de; hkallweit1@gmail.com; saeedm@mellanox.com;
>>>> andrew@lunn.ch; f.fainelli@gmail.com; alexandru.ardelean@analog.com;
>>>> jiri@mellanox.com; ayal@mellanox.com; pablo@netfilter.org; linux-
>>>> kernel@vger.kernel.org; netdev@vger.kernel.org
>>>> Cc: simon.horman@netronome.com; Claudiu Manoil
>>>> <claudiu.manoil@nxp.com>; Vladimir Oltean <vladimir.oltean@nxp.com>;
>>>> Alexandru Marginean <alexandru.marginean@nxp.com>; Xiaoliang Yang
>>>> <xiaoliang.yang_1@nxp.com>; Roy Zang <roy.zang@nxp.com>; Mingkai Hu
>>>> <mingkai.hu@nxp.com>; Jerry Huang <jerry.huang@nxp.com>; Leo Li
>>>> <leoyang.li@nxp.com>; Po Liu <po.liu@nxp.com>
>>>> Subject: [EXT] Re: [v1,net-next, 1/2] ethtool: add setting frame 
>>>> preemption of
>>>> traffic classes
>>>>
>>>> Caution: EXT Email
>>>>
>>>> Hi,
>>>>
>>>> Po Liu <po.liu@nxp.com> writes:
>>>>
>>>>> IEEE Std 802.1Qbu standard defined the frame preemption of port
>>>>> traffic classes. This patch introduce a method to set traffic classes
>>>>> preemption. Add a parameter 'preemption' in struct
>>>>> ethtool_link_settings. The value will be translated to a binary, each
>>>>> bit represent a traffic class. Bit "1" means preemptable traffic
>>>>> class. Bit "0" means express traffic class.  MSB represent high number
>>>>> traffic class.
>>>>>
>>>>> If hardware support the frame preemption, driver could set the
>>>>> ethernet device with hw_features and features with NETIF_F_PREEMPTION
>>>>> when initializing the port driver.
>>>>>
>>>>> User can check the feature 'tx-preemption' by command 'ethtool -k
>>>>> devname'. If hareware set preemption feature. The property would be a
>>>>> fixed value 'on' if hardware support the frame preemption.
>>>>> Feature would show a fixed value 'off' if hardware don't support the
>>>>> frame preemption.
>>>>>
>>>>> Command 'ethtool devname' and 'ethtool -s devname preemption N'
>>>>> would show/set which traffic classes are frame preemptable.
>>>>>
>>>>> Port driver would implement the frame preemption in the function
>>>>> get_link_ksettings() and set_link_ksettings() in the struct 
>>>>> ethtool_ops.
>>>>>
>>>>
>>>> Any updates on this series? If you think that there's something that 
>>>> I could help,
>>>> just tell.
>>>
>>> Sorry for the long time not involve the discussion. I am focus on 
>>> other tsn code for tc flower.
>>> If you can take more about this preemption serial, that would be good.
>>>
>>> I summary some suggestions from Marali Karicheri and Ivan Khornonzhuk 
>>> and by you and also others:
>>> - Add config the fragment size, hold advance, release advance and flags;
>>>      My comments about the fragment size is in the Qbu spec limit the 
>>> fragment size " the minimum non-final fragment size is 64,
>>> 128, 192, or 256 octets " this setting would affect the guardband 
>>> setting for Qbv. But the ethtool setting could not involve this 
>>> issues but by the taprio side.
>>> - " Furthermore, this setting could be extend for a serial setting 
>>> for mac and traffic class."  "Better not to using the traffic class 
>>> concept."
>>>     Could adding a serial setting by "ethtool --preemption xxx" or 
>>> other name. I don' t think it is good to involve in the queue control 
>>> since queues number may bigger than the TC number.
>>> - The ethtool is the better choice to configure the preemption
>>>    I agree.
>>
>> Just a quick update. I was able to dedicate some time to this, and have
>> something aproaching RFC-quality, but it needs more testing.
>>
> Great! I have got my frame preemption working on my SoC. Currently I am
> using some defaults. I test it by using statistics provided by the
> SoC. I will be able to integrate and test your patch using my internal
> version and will include it in my patch to upstream once I am ready.
> 
Any progress on your side for a patch for the support?

I have posted my EST offload series for AM65x CPSW to netdev list today
at

https://marc.info/?l=linux-netdev&m=158937640015582&w=2
https://marc.info/?l=linux-netdev&m=158937639515579&w=2
https://marc.info/?l=linux-netdev&m=158937638315573&w=2

Next on my list of things to do is the IET FPE support for which I need
to have ethtool interface to allow configuring the express/preemptible
queues and feature enable/disable. Currently I am using a ethtool
priv-flags and some defaults. If you can post a patch, I will be able
to integrate and test it on AM65x CPSW driver and provide my comments/
Tested-by:

Regards,

Murali

> Regards,
> 
> Murali
>> So, question, what were you using for testing this? Anything special?
>>
>> And btw, thanks for the summary of the discussion.
>>
>>>
>>> Thanks！
>>>>
>>>>
>>>> Cheers,
>>>> -- 
>>>> Vinicius
>>
>>
> 

-- 
Murali Karicheri
Texas Instruments
