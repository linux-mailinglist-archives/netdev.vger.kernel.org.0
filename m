Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E41E16EEC3
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 20:12:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730986AbgBYTMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 14:12:30 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:57398 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728913AbgBYTMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 14:12:30 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 01PHmo2Z000692;
        Tue, 25 Feb 2020 11:48:50 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1582652930;
        bh=12s3X3izH7v/kPf++ntOe88qKZbyQH4fY+tAP53VpyY=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Czs0op2WyFonLyjwUBBRDqhwgiFz+qFy3ZFROi52MGVp5i4Nspk4g2gJw7YsfyYsR
         SOiXFE2IWD+gbhjNVDvJY9d0T0e+DvUmvlHXwmu6i4BWQprayuqzyCmTT0jZ6u3I6g
         YzJIFbdMNrRQHoP6K4/KoP8oqBtXetUZcZDqKBng=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 01PHmorR013552
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Feb 2020 11:48:50 -0600
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 25
 Feb 2020 11:48:49 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 25 Feb 2020 11:48:49 -0600
Received: from [158.218.117.45] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 01PHmmOj055084;
        Tue, 25 Feb 2020 11:48:48 -0600
Subject: Re: [v1,net-next, 1/2] ethtool: add setting frame preemption of
 traffic classes
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vladimir Oltean <olteanv@gmail.com>
CC:     Po Liu <po.liu@nxp.com>,
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
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>
References: <20191127094517.6255-1-Po.Liu@nxp.com>
 <87v9p93a2s.fsf@linux.intel.com>
 <9b13a47e-8ca3-66b0-063c-798a5fa71149@ti.com>
 <CA+h21hqk2pCfrQg5kC6HzmL=eEqJXjuRsu+cVkGsEi8OXGpKJA@mail.gmail.com>
 <87d0bajc3l.fsf@linux.intel.com>
 <70deb628-d7bc-d2a3-486d-d3e53854c06e@ti.com>
 <877e0tx71r.fsf@linux.intel.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <b1ef134d-e275-439f-f7a1-038537af4855@ti.com>
Date:   Tue, 25 Feb 2020 12:55:59 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <877e0tx71r.fsf@linux.intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vinicius,

On 02/11/2020 02:22 PM, Vinicius Costa Gomes wrote:
> Murali Karicheri <m-karicheri2@ti.com> writes:
> 
>> We are still working to send a patch for taprio offload on our hardware
>> and it may take a while to get to this. So if someone can help to add
>> the required kernel/driver interface for this, that will be great!
> 
> Will add this to my todo list. But if anyone else has the spare cycles
> feel free to have a go at it.
> 
Thanks! We have made some progress in sending the base driver to netdev
list now https://lkml.org/lkml/2020/2/22/157

This device is taprio offload capable. Next step is to add taprio
offload to this driver. Then other features will follow.

>>
>>>>>        - ConfigChangeError - Error in configuration (AdminBaseTime <
>>>>>          CurrentTime)
>>>>
>>>> This can be exported similarly.
>>>
>>> In my view, having this as a "runtime" error is not useful, as we can
>>> verify this at configuration time.
>>
>> Looks like this is not an error per 802.1Q standard if I understood it
>> correctly.
>>
>> This is what I see.
>> =======================================================================
>>   From 802.1Q 2018, 8.6.9.1.1 SetCycleStartTime()
>>
>> If AdminBaseTime is set to the same time in the past in all bridges and
>> end stations, OperBaseTime is always in the past, and all cycles start
>> synchronized. Using AdminBaseTime in the past is appropriate when you
>> can start schedules prior to starting the application that uses the
>> schedules. Use of AdminBaseTime in the future is intended to change a
>> currently running schedule in all bridges and end stations to a new
>> schedule at a future time. Using AdminBaseTime in the future is
>> appropriate when schedules must be changed without stopping the
>> application
>> ========================================================================
>>
> 
> What I meant here is the case that I already have an "oper" schedule
> running, so my "oper->base_time" is in the past, and I try to add an
> "admin" schedule with a "base_time" also in the past. What's the
> expected behavior in this case? The text about stopping/starting
> applications doesn't seem to apply to the way the tc subsystem interacts
> with the applications.
> 
 > I try to add an "admin" schedule with a "base_time" also in the past.
 > What's the expected behavior in this case?

Ok got it. I don't think this behavior is explained in the spec. I would
assume a sane thing to do is to switch to admin schedule if 
admin->base_time is newer than oper->base_time and flag
the ConfigChangeError to be compliant to the spec, but frankly speaking
I don't know how application is going to use this. It is a low priority
item IMO and can be added as needed.

Regards,

Murali
>>>
>>>>
>>>>>        - SupportedListMax - Maximum supported Admin/Open shed list.
>>>>>
>>>>> Is there a plan to export these from driver through tc show or such
>>>>> command? The reason being, there would be applications developed to
>>>>> manage configuration/schedule of TSN nodes that would requires these
>>>>> information from the node. So would need a support either in tc or
>>>>> some other means to retrieve them from hardware or driver. That is my
>>>>> understanding...
>>>>>
>>>
>>> Hm, now I understamd what you meant here...
>>>
>>>>
>>>> Not sure what answer you expect to receive for "is there any plan".
>>>> You can go ahead and propose something, as long as it is reasonably
>>>> useful to have.
>>>
>>> ... if this is indeed useful, perhaps one way to do is to add a subcommand
>>> to TC_SETUP_QDISC_TAPRIO, so we can retrieve the stats/information we want
>>> from the driver. Similar to what cls_flower does.
>>>
>>
>> What I understand is that there will be some work done to allow auto
>> configuration of TSN nodes from user space and that would need access to
>> all or some of the above parameters along with tc command to configure
>> the same. May be a open source project for this or some custom
>> application? Any such projects existing??
> 
> Yeah, this is a big missing piece for TSN. I've heard 'netopeer2' and
> 'sysrepo' mentioned when similar questions were asked, but I have still
> to take a look at them and see what's missing. (Or if they are the right
> tool for the job)
> 
> 

-- 
Murali Karicheri
Texas Instruments
