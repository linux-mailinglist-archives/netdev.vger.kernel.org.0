Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1E92BBF00
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 13:45:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727779AbgKUMnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 07:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727497AbgKUMnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 07:43:20 -0500
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4824EC0613CF
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 04:43:20 -0800 (PST)
Received: by mail-qk1-x731.google.com with SMTP id q5so11675366qkc.12
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 04:43:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3Zc+dlXFIIGYHYHhVppoc4UhTH7sKtif4KbulN3IIqs=;
        b=BZIWnkA2H9n68VaasrH9vhqg8+iFk6NIlfeyutZoruSMUhd3nj2mvX5wZ20Hv2nMAt
         Rp6QsNJJ1aGBN/krOrHpFJ1Mpgvy2aKP3eIQQ0YyPtVXvBxbbKoY9W2slczSmnoIKl7U
         5r7y0N4T4H77UQYCyjt8Qi5SQW5tfTI2Ue/MLccnwqe1h+AmxXKw8Us9TbcB4KRYuIRk
         ueZespyfz8qEtQQuranDIPJzwmK0WHQ7/btWB+CL/btgPeYJGxq6ghIkSWO0SJD6k98K
         gcbhR4Vo+ni5449uGCR2UUYSJQmhEi82WC0DVotaLr4F8J6nSav2gEUa+H3SyIfh4wdY
         Mh5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3Zc+dlXFIIGYHYHhVppoc4UhTH7sKtif4KbulN3IIqs=;
        b=IPGdPIlfmI5kUG9pUoDP4DD91D6kx0mXISUqOhL2NAVAThtz1+Q00JKhoTf+7c0uPd
         daYHFMxvYVgyEWq9wSYmhA13pbk6ii8Bu1XH4ba+4bUsq8KlF2VbML7RRlXaOCchMUJd
         uoRWbpBU6dMnXXKi7d/sIdd4UTR/xcXEmw32+3G4KINgB7Eqjyv74qZNwGhrerceVQ+c
         PjE1WNd5iUgWfBhut9DGtKe3UJPPczHIjtbtzUWvpZSXwK/sj3yzUcZVGPLHfqI0kzMr
         29F8UKixM6BvPfqBhaP567TwOBoBfs2urM+YHoBNRKRT0zFOUgRMUIJdIdRHldBuKfPn
         U7tg==
X-Gm-Message-State: AOAM531NleaamtEbRBK1nV3uzb1YtnoxBRnNf5CjJt9hJ/q/7qqFNez+
        aasvZUkUd633swNSzOCYVXUUVQ==
X-Google-Smtp-Source: ABdhPJx87jCEvmAo7WZ5uGHwYscozO8wu8zgWLuPo+G0WStIPC9xUiuFZRn3U9ucviVL/50uxdGUOw==
X-Received: by 2002:ae9:dc06:: with SMTP id q6mr21779395qkf.310.1605962599376;
        Sat, 21 Nov 2020 04:43:19 -0800 (PST)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id w45sm4099743qtw.96.2020.11.21.04.43.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Nov 2020 04:43:18 -0800 (PST)
Subject: Re: [EXT] Re: [RFC, net-next] net: qos: introduce a redundancy flow
 action
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Arvid.Brodin@xdin.com" <Arvid.Brodin@xdin.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "ivan.khoronzhuk@linaro.org" <ivan.khoronzhuk@linaro.org>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "allan.nielsen@microchip.com" <allan.nielsen@microchip.com>,
        Po Liu <po.liu@nxp.com>, Mingkai Hu <mingkai.hu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Leo Li <leoyang.li@nxp.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
References: <20201117063013.37433-1-xiaoliang.yang_1@nxp.com>
 <20201117190041.dejmwpi4kvgrcotj@soft-dev16>
 <fc5d88d6-ca5e-59f5-cf3d-edfecce46dd4@mojatatu.com>
 <DB8PR04MB5785668533329D4B012545D1F0FF0@DB8PR04MB5785.eurprd04.prod.outlook.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <a6b689ba-bf11-fec8-6ede-c8f6675085e1@mojatatu.com>
Date:   Sat, 21 Nov 2020 07:43:17 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB5785668533329D4B012545D1F0FF0@DB8PR04MB5785.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2020-11-20 2:32 a.m., Xiaoliang Yang wrote:
> Hi Jamal,
> 
> On 2020-11-19 0:11, Jamal Hadi Salim wrote:
>> The 11/17/2020 14:30, Xiaoliang Yang wrote:
>>> EXTERNAL EMAIL: Do not click links or open attachments unless you

[..]

>> We already have mirroring + ability to add/pop tags.
>> Would the following not work?
>>
>> Example, generator mode:
>> tc filter add dev swp0 ingress protocol 802.1Q flower \ 
action vlan push id 789 protocol 802.1q \ action mirred egress mirror 
dev swp1 \ action mirred egress mirror dev swp2
>>
>> recovery mode:
>> tc filter add dev swp0 ingress protocol 802.1Q flower \ skip_hw dst_mac 00:01:02:03:04:06 vlan_id 1 \ actopm vlan pop
>>
> 
> Action mirred only copy the packets and forward to different egress ports. 

Also to ingress of ports (and can redirect as well, etc)

>802.1CB need to add a redundancy tag before forward. Recovery mode need pop the
redundancy tag
and check sequence in R-TAG, drop the repeat frames. So I added a new 
action to do this.
> 

Ok, when you said "tags" I thought you meant 802.1q tags. But seems like
different ethernet tags?
The preferred approach is to write an action to pop/push these R-TAGs.

generator mode:
tc filter add dev swp0 ingress protocol 802.1Q flower \
action rtag push \
action mirred egress mirror dev swp1 \
action mirred egress mirror dev swp2

recovery mode:
tc filter add dev swp0 ingress protocol 802.1Q flower \
action rtag pop
...
.....

We have a few examplery actions which provide tags at L2
(IFE, MPLS, VLAN, etc).

cheers,
jamal
