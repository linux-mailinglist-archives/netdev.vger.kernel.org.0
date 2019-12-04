Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFDD911304C
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 17:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728916AbfLDQz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 11:55:57 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:41236 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726934AbfLDQz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 11:55:57 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id xB4GsVWb112486;
        Wed, 4 Dec 2019 10:54:31 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1575478471;
        bh=lW5PKBvi48YJF7fIkLzfyMM9Iv2FXBYD/7nel/gzXv0=;
        h=Subject:To:References:From:Date:In-Reply-To;
        b=HuHGdgMwJaLEwtplq12FWz/L4g52TSfATIXTHfEL1fI4AI0mYInk79MkK1iteiuRv
         7amC0rIQYxe/dXTb2owJrFtfJ7D9rS2gEFo8TjnMflz2tiProEqVOq4MIDSk6W5UGn
         QDhf0KCRbqMCvS1XnrX1p9MbjnP6St6qeO4haVx8=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xB4GsVXJ044253
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 4 Dec 2019 10:54:31 -0600
Received: from DFLE112.ent.ti.com (10.64.6.33) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Wed, 4 Dec
 2019 10:54:31 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Wed, 4 Dec 2019 10:54:31 -0600
Received: from [158.218.113.14] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB4GsJZr061204;
        Wed, 4 Dec 2019 10:54:21 -0600
Subject: Re: [EXT] Re: [v1,ethtool] ethtool: add setting frame preemption of
 traffic classes
To:     Po Liu <po.liu@nxp.com>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "netdev-owner@vger.kernel.org" <netdev-owner@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Roy Zang <roy.zang@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Jerry Huang <jerry.huang@nxp.com>, Leo Li <leoyang.li@nxp.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
References: <20191127094448.6206-1-Po.Liu@nxp.com>
 <20191203162659.GC2680@khorivan>
 <62250ff1-ab89-b6c2-051b-93f1650139eb@ti.com>
 <VE1PR04MB649677D690436632ED407178925D0@VE1PR04MB6496.eurprd04.prod.outlook.com>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <1e451e89-a801-5f6d-e7e6-5563dc95267d@ti.com>
Date:   Wed, 4 Dec 2019 11:59:49 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.7.0
MIME-Version: 1.0
In-Reply-To: <VE1PR04MB649677D690436632ED407178925D0@VE1PR04MB6496.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/04/2019 03:14 AM, Po Liu wrote:
> Hi Murali, Ivan,
> 
> Thank you for your feedback. Maybe it is better to use "RFC" type for these patches for the discussion.
> 
Yes please.

Murali
> 
> Br,
> Po Liu
> 
>> -----Original Message-----
>> From: Murali Karicheri <m-karicheri2@ti.com>
>> Sent: 2019年12月4日 1:42
>> To: Po Liu <po.liu@nxp.com>; rmk+kernel@armlinux.org.uk;
>> linville@tuxdriver.com; netdev-owner@vger.kernel.org; davem@davemloft.net;
>> linux-kernel@vger.kernel.org; netdev@vger.kernel.org;
>> vinicius.gomes@intel.com; simon.horman@netronome.com; Claudiu Manoil
>> <claudiu.manoil@nxp.com>; Vladimir Oltean <vladimir.oltean@nxp.com>;
>> Xiaoliang Yang <xiaoliang.yang_1@nxp.com>; Roy Zang <roy.zang@nxp.com>;
>> Mingkai Hu <mingkai.hu@nxp.com>; Jerry Huang <jerry.huang@nxp.com>; Leo
>> Li <leoyang.li@nxp.com>
>> Subject: [EXT] Re: [v1,ethtool] ethtool: add setting frame preemption of traffic
>> classes
>>
>> Caution: EXT Email
>>
>> Hi Po Liu,
>>
>> Thanks for working on this! Some suggestion below as we are working on adding
>> this support to Texas Instrument's CPSW driver on AM65x family of SoCs as well.
>> TRM for that is provided below for your reference.
>> Relevant section for IET (Frame pre-emption) is
>>
>> 12.2.1.4.6.6.1IET Configuration
>>
>> https://eur01.safelinks.protection.outlook.com/?url=http%3A%2F%2Fwww.ti.c
>> om%2Flit%2Fug%2Fspruid7d%2Fspruid7d.pdf&amp;data=02%7C01%7Cpo.liu%
>> 40nxp.com%7C15544a9db1ff422e2fdf08d77817647f%7C686ea1d3bc2b4c6fa
>> 92cd99c5c301635%7C0%7C1%7C637109914194485742&amp;sdata=VD5kg%
>> 2FY1SDDWjwMZHjgUNlFrcvXnDvdIPGblWkx4DXs%3D&amp;reserved=0
>>
>> On 12/03/2019 11:27 AM, Ivan Khoronzhuk wrote:
>>> On Wed, Nov 27, 2019 at 09:58:52AM +0000, Po Liu wrote:
>>>
>>> Hi Po Liu,
>>>
>>>> IEEE Std 802.1Qbu standard defined the frame preemption of port
>>>> trffic classes. User can set a value to hardware. The value will be
>>>> translated to a binary, each bit represent a traffic class.
>>>> Bit "1" means preemptable traffic class. Bit "0" means express
>>>> traffic class.  MSB represent high number traffic class.
>>>>
>>>> ethtool -k devname
>>>>
>>>> This command would show if the tx-preemption feature is available.
>>>> If hareware set preemption feature. The property would be a fixed
>>>> value 'on' if hardware support the frame preemption. Feature would
>>>> show a fixed value 'off' if hardware don't support the frame preemption.
>>>>
>>>> ethtool devname
>>>>
>>>> This command would show include an item 'preemption'. A following
>>>> value '0' means all traffic classes are 'express'. A value none zero
>>>> means traffic classes preemption capabilities. The value will be
>>>> translated to a binary, each bit represent a traffic class. Bit '1'
>>>> means preemptable traffic class. Bit '0' means express traffic class.
>>>> MSB represent high number traffic class.
>>>>
>>>> ethtool -s devname preemption N
>>>
>>> What about other potential parameters like MAC fragment size, mac hold?
>>> Shouldn't be it considered along with other FP parameters to provide
>>> correct interface later?
>>>
>>> Say, preemption, lets name it fp-mask or frame-preemption-mask.
>>> Then other potential setting can be similar and added later:
>>>
>>> frame-preemption-mask
>>> frame-preemption-fragsize
>>> frame-preemption-machold
>> Need additional capabilities as described by Ivan above. Thanks Ivan!
>>
>> So it would be better to use feature/sub-parameter format so that it can be
>> extended as needed in the future.
>>
>> For express/Preemptable mask setting it becomes
>>
>> ethtool -s devname frame-preemption tc-mask  N
>>
>> For setting min fragment size
>>
>> ethtool -s devname frame-preemption min-fragsize 64
>>
> 
> I thought the fragment size set 64 is enough for Qbv.  Anyway, if you prefer more details setting. I think it is better to set a specific serial type. For example, '-p' for set  tc-mask  N  and min-fragsize 64, '-P' for status.
> 
>> Also the device may be capable of doing Verify process to detect the capability
>> of neighbor device and show the status. So we should have a way to show this
> 
> The verify process maybe disabled as default.
> 
>> status as well when user type
>>
>> ethtool devname
>>
>> We are working currently to add this feature to CPSW driver on AM65x which
>> will be upstream-ed soon. So want to have this done in an way that we can
>> extend it later.
>> Similarly for taprio, there are some parameters that user might want to tune
>> such as Max SDU size per tc class. I hope we could use ethtool to set the same
>> on a similar way.
> 
> Furthermore, this setting could be extend for a serial setting for mac and traffic class.
> 
>>
>> Thanks
>>
>> Murali
>>
>>> ....
>>>
>>> mac-hold it's rather flag, at least I've used it as priv-flag.
>>> so can or so
>>>
>>> frame-preemption-flags
>>>
>>>>
>>>> This command would set which traffic classes are frame preemptable.
>>>> The value will be translated to a binary, each bit represent a
>>>> traffic class. Bit '1' means preemptable traffic class. Bit '0'
>>>> means express traffic class. MSB represent high number traffic class.
>>>>
>>>> Signed-off-by: Po Liu <Po.Liu@nxp.com>
>>>> ---
>>>> ethtool-copy.h |  6 +++++-
>>>> ethtool.8.in   |  8 ++++++++
>>>> ethtool.c      | 18 ++++++++++++++++++
>>>> 3 files changed, 31 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/ethtool-copy.h b/ethtool-copy.h index 9afd2e6..e04bdf3
>>>> 100644
>>>> --- a/ethtool-copy.h
>>>> +++ b/ethtool-copy.h
>>>> @@ -1662,6 +1662,9 @@ static __inline__ int
>>>> ethtool_validate_duplex(__u8 duplex)
>>>> #define AUTONEG_DISABLE        0x00
>>>> #define AUTONEG_ENABLE        0x01
>>>>
>>>> +/* Disable preemtion. */
>>>> +#define PREEMPTION_DISABLE    0x0
>>>> +
>>>> /* MDI or MDI-X status/control - if MDI/MDI_X/AUTO is set then
>>>>   * the driver is required to renegotiate link  */ @@ -1878,7 +1881,8
>>>> @@ struct ethtool_link_settings {
>>>>      __s8    link_mode_masks_nwords;
>>>>      __u8    transceiver;
>>>>      __u8    reserved1[3];
>>>> -    __u32    reserved[7];
>>>> +    __u32    preemption;
>>>> +    __u32    reserved[6];
>>>>      __u32    link_mode_masks[0];
>>>>      /* layout of link_mode_masks fields:
>>>>       * __u32 map_supported[link_mode_masks_nwords];
>>>> diff --git a/ethtool.8.in b/ethtool.8.in index 062695a..7d612b2
>>>> 100644
>>>> --- a/ethtool.8.in
>>>> +++ b/ethtool.8.in
>>>> @@ -236,6 +236,7 @@ ethtool \- query or control network driver and
>>>> hardware settings
>>>> .B2 autoneg on off
>>>> .BN advertise
>>>> .BN phyad
>>>> +.BN preemption
>>>> .B2 xcvr internal external
>>>> .RB [ wol \ \*(WO]
>>>> .RB [ sopass \ \*(MA]
>>>> @@ -703,6 +704,13 @@ lB    l    lB.
>>>> .BI phyad \ N
>>>> PHY address.
>>>> .TP
>>>> +.BI preemption \ N
>>>> +Set preemptable traffic classes by bits.
>>>> +.B A
>>>> +value will be translated to a binary, each bit represent a traffic
>>>> class.
>>>> +Bit "1" means preemptable traffic class. Bit "0" means express
>>>> traffic class.
>>>> +MSB represent high number traffic class.
>>>> +.TP
>>>> .A2 xcvr internal external
>>>> Selects transceiver type. Currently only internal and external can be
>>>> specified, in the future further types might be added.
>>>> diff --git a/ethtool.c b/ethtool.c
>>>> index acf183d..d5240f8 100644
>>>> --- a/ethtool.c
>>>> +++ b/ethtool.c
>>>> @@ -928,6 +928,12 @@ dump_link_usettings(const struct
>>>> ethtool_link_usettings *link_usettings)
>>>>          }
>>>>      }
>>>>
>>>> +    if (link_usettings->base.preemption == PREEMPTION_DISABLE)
>>>> +        fprintf(stdout, "    Preemption: 0x0 (off)\n");
>>>> +    else
>>>> +        fprintf(stdout, "    Preemption: 0x%x\n",
>>>> +            link_usettings->base.preemption);
>>>> +
>>>>      return 0;
>>>> }
>>>>
>>>> @@ -2869,6 +2875,7 @@ static int do_sset(struct cmd_context *ctx)
>>>>      int port_wanted = -1;
>>>>      int mdix_wanted = -1;
>>>>      int autoneg_wanted = -1;
>>>> +    int preemption_wanted = -1;
>>>>      int phyad_wanted = -1;
>>>>      int xcvr_wanted = -1;
>>>>      u32 *full_advertising_wanted = NULL; @@ -2957,6 +2964,12 @@
>>>> static int do_sset(struct cmd_context *ctx)
>>>>              } else {
>>>>                  exit_bad_args();
>>>>              }
>>>> +        } else if (!strcmp(argp[i], "preemption")) {
>>>> +            gset_changed = 1;
>>>> +            i += 1;
>>>> +            if (i >= argc)
>>>> +                exit_bad_args();
>>>> +            preemption_wanted = get_u32(argp[i], 16);
>>>>          } else if (!strcmp(argp[i], "advertise")) {
>>>>              gset_changed = 1;
>>>>              i += 1;
>>>> @@ -3094,6 +3107,9 @@ static int do_sset(struct cmd_context *ctx)
>>>>              }
>>>>              if (autoneg_wanted != -1)
>>>>                  link_usettings->base.autoneg = autoneg_wanted;
>>>> +            if (preemption_wanted != -1)
>>>> +                link_usettings->base.preemption
>>>> +                    = preemption_wanted;
>>>>              if (phyad_wanted != -1)
>>>>                  link_usettings->base.phy_address = phyad_wanted;
>>>>              if (xcvr_wanted != -1)
>>>> @@ -3186,6 +3202,8 @@ static int do_sset(struct cmd_context *ctx)
>>>>                  fprintf(stderr, "  not setting transceiver\n");
>>>>              if (mdix_wanted != -1)
>>>>                  fprintf(stderr, "  not setting mdix\n");
>>>> +            if (preemption_wanted != -1)
>>>> +                fprintf(stderr, "  not setting preemption\n");
>>>>          }
>>>>      }
>>>>
>>>> --
>>>> 2.17.1
>>>>
>>>
> 

