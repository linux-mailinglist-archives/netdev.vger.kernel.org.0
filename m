Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18C3DEC77C
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 18:26:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbfKAR0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 13:26:08 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:53630 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbfKAR0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 13:26:08 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id xA1HPxMa058744;
        Fri, 1 Nov 2019 12:25:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1572629159;
        bh=nGisqRyPLExUF9ZP0CfxjlJzvTcpgSdEj80aORcRt60=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=gvgtnr/SmfDEFFWJM5ThItG/EWdgsfJ9XPxWHXVE+DgvEC40f2ruaBfyDRhKcCROz
         WwitdSlD8kEtbVIMlpZE2Mgfv+z1rMis4S6J93iytONFRg8DX4+kjbGArJgO7u2akq
         ibh7LuHkHWudBWFvpVS00AY1J/0u1MXtDF7gkSxQ=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xA1HPxat112615
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 1 Nov 2019 12:25:59 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Fri, 1 Nov
 2019 12:25:45 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Fri, 1 Nov 2019 12:25:45 -0500
Received: from [10.250.98.116] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id xA1HPtGJ040578;
        Fri, 1 Nov 2019 12:25:56 -0500
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
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <6e64b70e-604a-b8c6-12ce-7977ffa4ed5a@ti.com>
Date:   Fri, 1 Nov 2019 19:25:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <caf68306-46ce-f97d-b45a-0fc1cd5323f7@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On 25/10/2019 20:47, Florian Fainelli wrote:
> On 10/24/19 3:09 AM, Grygorii Strashko wrote:
>> Add bindings for the new TI CPSW switch driver. Comparing to the legacy
>> bindings (net/cpsw.txt):
>> - ports definition follows DSA bindings (net/dsa/dsa.txt) and ports can be
>> marked as "disabled" if not physically wired.
>> - all deprecated properties dropped;
>> - all legacy propertiies dropped which represent constant HW cpapbilities
>> (cpdma_channels, ale_entries, bd_ram_size, mac_control, slaves,
>> active_slave)
>> - TI CPTS DT properties are reused as is, but grouped in "cpts" sub-node
>> - TI Davinci MDIO DT bindings are reused as is, because Davinci MDIO is
>> reused.
>>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
> 
> [snip]
>> +- mdio : CPSW MDIO bus block description
>> +	- bus_freq : MDIO Bus frequency
> 
> clock-frequency is a more typical property to describe the bus clock's
> frequency, that is what i2c and spi do.

The MDIO is re-used here unchanged (including bindings).
i think, I could try to add standard optional property "bus-frequency" to MDIO bindings
as separate series, and deprecate "bus_freq".

> 
>> +	See bindings/net/mdio.txt and davinci-mdio.txt
>> +
>> +- cpts : The Common Platform Time Sync (CPTS) module description
>> +	- clocks : should contain the CPTS reference clock
>> +	- clock-names : should be "cpts"
>> +	See bindings/clock/clock-bindings.txt
>> +
>> +	Optional properties - all ports:
>> +	- cpts_clock_mult : Numerator to convert input clock ticks into ns
>> +	- cpts_clock_shift : Denominator to convert input clock ticks into ns
>> +			  Mult and shift will be calculated basing on CPTS
>> +			  rftclk frequency if both cpts_clock_shift and
>> +			  cpts_clock_mult properties are not provided.
> 
> Why would those two be needed that would be modeled in the Linux Common
> Clock Framework?

The CPTS is re-used here unchanged (including bindings).

This is very specific tuning options for PHC clock (cyclecounter) which intended to be used
in very rare cases with some ref frequencies when automatic calculation is not working properly.



-- 
Best regards,
grygorii
