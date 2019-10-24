Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 686B9E2ECE
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 12:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438793AbfJXK0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 06:26:11 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:37670 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438770AbfJXK0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 06:26:10 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x9OAQ13G127823;
        Thu, 24 Oct 2019 05:26:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1571912761;
        bh=2dL4+0XO3MuDImEUl3Y2gWiIghrqD+OsX0CzupMV6YU=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=SaQYZT4xPyPgZ8X/0z3e2o+cXsnIvNrFCXHpHXTnxYhI6OsQ5WoS+zw+STgAsQZqW
         skyCgJcz1bCWKcnm3lX7sSA6KMJSsuJq/pmeH4lJaJt47ds6pn/GMWgyQn7WUhdrg5
         yDBSC1a/5MKYsJBJBS61t8FOQ9147HT+3tpjU+B4=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9OAQ1BJ014272;
        Thu, 24 Oct 2019 05:26:01 -0500
Received: from DFLE109.ent.ti.com (10.64.6.30) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 24
 Oct 2019 05:25:50 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 24 Oct 2019 05:25:50 -0500
Received: from [10.250.98.116] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9OAPuoo046450;
        Thu, 24 Oct 2019 05:25:57 -0500
Subject: Re: [RFC PATCH v4 net-next 05/11] dt-bindings: net: ti: add new cpsw
 switch driver bindings
To:     Rob Herring <robh@kernel.org>
CC:     <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>, <devicetree@vger.kernel.org>
References: <20190621181314.20778-1-grygorii.strashko@ti.com>
 <20190621181314.20778-6-grygorii.strashko@ti.com>
 <20190709224853.GA2365@bogus>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <8c10a935-83f8-6a78-c3d7-25e70d6e0278@ti.com>
Date:   Thu, 24 Oct 2019 13:26:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20190709224853.GA2365@bogus>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

Thank you for you review and sorry for delay - I seems missed your mail and found it only now
while preparing new version of the series (v5).

On 10/07/2019 01:48, Rob Herring wrote:
> On Fri, Jun 21, 2019 at 09:13:08PM +0300, Grygorii Strashko wrote:
>> Add bindings for the new TI CPSW switch driver. Comparing to the legacy
>> bindings (net/cpsw.txt):
>> - ports definition follows DSA bindings (net/dsa/dsa.txt) and ports can be
>> marked as "disabled" if not physically wired.
>> - ports definition follows DSA bindings (net/dsa/dsa.txt) and ports can be
>> marked as "disabled" if not physically wired.
>> - all deprecated properties dropped;
>> - all legacy propertiies dropped which represents constant HW cpapbilities
>> (cpdma_channels, ale_entries, bd_ram_size, mac_control, slaves,
>> active_slave)
>> - cpts properties grouped in "cpts" sub-node
>>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
>>   .../bindings/net/ti,cpsw-switch.txt           | 147 ++++++++++++++++++
>>   1 file changed, 147 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/net/ti,cpsw-switch.txt
>>
>> diff --git a/Documentation/devicetree/bindings/net/ti,cpsw-switch.txt b/Documentation/devicetree/bindings/net/ti,cpsw-switch.txt
>> new file mode 100644
>> index 000000000000..787219cddccd
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/ti,cpsw-switch.txt
>> @@ -0,0 +1,147 @@
>> +TI SoC Ethernet Switch Controller Device Tree Bindings (new)
>> +------------------------------------------------------
>> +
>> +The 3-port switch gigabit ethernet subsystem provides ethernet packet
>> +communication and can be configured as an ethernet switch. It provides the
>> +gigabit media independent interface (GMII),reduced gigabit media
>> +independent interface (RGMII), reduced media independent interface (RMII),
>> +the management data input output (MDIO) for physical layer device (PHY)
>> +management.
>> +
>> +Required properties:
>> +- compatible : be one of the below:
>> +	  "ti,cpsw-switch" for backward compatible
>> +	  "ti,am335x-cpsw-switch" for AM335x controllers
>> +	  "ti,am4372-cpsw-switch" for AM437x controllers
>> +	  "ti,dra7-cpsw-switch" for DRA7x controllers
>> +- reg : physical base address and size of the CPSW module IO range
>> +- ranges : shall contain the CPSW module IO range available for child devices
>> +- clocks : should contain the CPSW functional clock
>> +- clock-names : should be "fck"
>> +	See bindings/clock/clock-bindings.txt
>> +- interrupts : should contain CPSW RX, TX, MISC, RX_THRESH interrupts
>> +- interrupt-names : should contain "rx_thresh", "rx", "tx", "misc"
> 
> What's the defined order because it's not consistent here.

fixed.

I've fixed mostly all your comments, just some clarifications below.

> 
>> +	See bindings/interrupt-controller/interrupts.txt
>> +
>> +Optional properties:
>> +- syscon : phandle to the system control device node which provides access to

...

>> +	- local-mac-address : See [1]
>> +
>> +- mdio : CPSW MDIO bus block description
>> +	- bus_freq : MDIO Bus frequency
>> +	See bindings/net/mdio.txt and davinci-mdio.txt
> 
> Standard properties clock-frequency or bus-frequency would have been
> better...

Davinci MDIO driver and its bindings are reused here as is.
So I'd like to avoid such changes here, but if you think it's right, I can try add
bus-frequency to standard MDIO bindings (mdio.yaml) as separate change.

> 
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
> Should have 'ti' prefix and use '-' rather than '_'. However, these are
> already defined somewhere else, right? I can't tell that from reading
> this.

The same here - CPTS is reused here.

> 
>> +
>> +[1] See Documentation/devicetree/bindings/net/ethernet.txt
>> +
>> +Examples - SOC:

[...]

-- 
Best regards,
grygorii
