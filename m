Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55B0DEC9BB
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 21:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbfKAUlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 16:41:13 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:60726 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbfKAUlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 16:41:13 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id xA1Kf5FQ034212;
        Fri, 1 Nov 2019 15:41:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1572640865;
        bh=DWoyQIOP+Dnx87nS7EMk/Arh6FOoKdD8LFrByX5asjs=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=xdEUx+8PL+9YMPjp+pAT/YAwoCmNEMHbA4A3u3JtkTjVaqGLItvTuSZCbqAYvPQcM
         n3AI+LRPFLedEtgonI1mVPsaOTsBaV+y9rSVm/3rpxLhLBzrWHNXExGHyei/871aeq
         b2vF/o4snZc5g/B/v+rnLR+B6EJXs0CHCTxEPI3I=
Received: from DFLE112.ent.ti.com (dfle112.ent.ti.com [10.64.6.33])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xA1Kf4rG014068
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 1 Nov 2019 15:41:05 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE112.ent.ti.com
 (10.64.6.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Fri, 1 Nov
 2019 15:40:51 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Fri, 1 Nov 2019 15:40:51 -0500
Received: from [10.250.98.116] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id xA1Kf1GF114953;
        Fri, 1 Nov 2019 15:41:02 -0500
Subject: Re: [PATCH v5 net-next 05/12] dt-bindings: net: ti: add new cpsw
 switch driver bindings
To:     Florian Fainelli <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
References: <20191024100914.16840-1-grygorii.strashko@ti.com>
 <20191024100914.16840-6-grygorii.strashko@ti.com>
 <caf68306-46ce-f97d-b45a-0fc1cd5323f7@gmail.com>
 <6e64b70e-604a-b8c6-12ce-7977ffa4ed5a@ti.com>
 <5c286f76-d108-5d78-dd8f-19e1baf64396@gmail.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <b81b6502-0e2b-d786-ae71-b40b0a1fab79@ti.com>
Date:   Fri, 1 Nov 2019 22:40:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <5c286f76-d108-5d78-dd8f-19e1baf64396@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01/11/2019 19:36, Florian Fainelli wrote:
> On 11/1/19 10:25 AM, Grygorii Strashko wrote:
>> Hi Florian,
>>
>> On 25/10/2019 20:47, Florian Fainelli wrote:
>>> On 10/24/19 3:09 AM, Grygorii Strashko wrote:
>>>> Add bindings for the new TI CPSW switch driver. Comparing to the legacy
>>>> bindings (net/cpsw.txt):
>>>> - ports definition follows DSA bindings (net/dsa/dsa.txt) and ports
>>>> can be
>>>> marked as "disabled" if not physically wired.
>>>> - all deprecated properties dropped;
>>>> - all legacy propertiies dropped which represent constant HW
>>>> cpapbilities
>>>> (cpdma_channels, ale_entries, bd_ram_size, mac_control, slaves,
>>>> active_slave)
>>>> - TI CPTS DT properties are reused as is, but grouped in "cpts" sub-node
>>>> - TI Davinci MDIO DT bindings are reused as is, because Davinci MDIO is
>>>> reused.
>>>>
>>>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>>> ---
>>>
>>> [snip]
>>>> +- mdio : CPSW MDIO bus block description
>>>> +    - bus_freq : MDIO Bus frequency
>>>
>>> clock-frequency is a more typical property to describe the bus clock's
>>> frequency, that is what i2c and spi do.
>>
>> The MDIO is re-used here unchanged (including bindings).
>> i think, I could try to add standard optional property "bus-frequency"
>> to MDIO bindings
>> as separate series, and deprecate "bus_freq".
> 
> What is wrong with 'clock-frequency'?
> 
> Documentation/devicetree/bindings/i2c/i2c.txt:
> 
> - clock-frequency
>          frequency of bus clock in Hz.
> 
> Documentation/devicetree/bindings/net/brcm,unimac-mdio.txt:
> 
> - clock-frequency: the MDIO bus clock that must be output by the MDIO bus
>    hardware, if absent, the default hardware values are used
> 
> Maybe this is a bit of a misnomer as it is usually considered a
> replacement for the lack of a proper "clocks" property with a clock
> provider, but we can flip the coin around any way we want, it looks
> almost the same.
> 

I can do clock-frequency, but I like more bus-frequency (personally)
due to more understandable meaning, and because in "Devicetree Specification v0.2"
clock-frequency is defined as more related to clocks.

Any way I hope you agree that it should be part separate discussion?


-- 
Best regards,
grygorii
