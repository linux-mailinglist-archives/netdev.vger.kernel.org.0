Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6BC2F8C46
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 10:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfKLJyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 04:54:13 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:40554 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727126AbfKLJyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 04:54:12 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id xAC9s2sI008247;
        Tue, 12 Nov 2019 03:54:02 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1573552442;
        bh=WQT6Vm79FJ7vex/Exo9gZw1GlIJus5QmouBEivGnijk=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=wlc7SuWVvl6nEn8yCCQalX3OATIF4CSmyUHvj1rrDIMbyQzUNditNVLnjvAckSKdW
         kSeGb566okJwWX+cmbgNfOVIH/96heCxHty/pyx99ujC/7x51YYa3G/YCJ58aSbeRu
         RCerjOuZ9Gqobzrs1gI7Em2ImAjI36Ot6O3YvCJE=
Received: from DLEE110.ent.ti.com (dlee110.ent.ti.com [157.170.170.21])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAC9s2Sn019766;
        Tue, 12 Nov 2019 03:54:02 -0600
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE110.ent.ti.com
 (157.170.170.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 12
 Nov 2019 03:53:44 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 12 Nov 2019 03:53:44 -0600
Received: from [10.250.98.116] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAC9rvfr077812;
        Tue, 12 Nov 2019 03:53:58 -0600
Subject: Re: [PATCH v6 net-next 06/13] dt-bindings: net: ti: add new cpsw
 switch driver bindings
To:     Tony Lindgren <tony@atomide.com>
CC:     Florian Fainelli <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>, Sekhar Nori <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
References: <20191109151525.18651-1-grygorii.strashko@ti.com>
 <20191109151525.18651-7-grygorii.strashko@ti.com>
 <20191111172652.GV5610@atomide.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <bac9a300-cbd5-d342-a96d-d90fdcf2e4c3@ti.com>
Date:   Tue, 12 Nov 2019 11:53:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191111172652.GV5610@atomide.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/11/2019 19:26, Tony Lindgren wrote:
> Hi,
> 
> * Grygorii Strashko <grygorii.strashko@ti.com> [191109 15:17]:
>> +    mac_sw: switch@0 {
>> +        compatible = "ti,dra7-cpsw-switch","ti,cpsw-switch";
>> +        reg = <0x0 0x4000>;
>> +        ranges = <0 0 0x4000>;
>> +        clocks = <&gmac_main_clk>;
>> +        clock-names = "fck";
>> +        #address-cells = <1>;
>> +        #size-cells = <1>;
>> +        syscon = <&scm_conf>;
>> +        inctrl-names = "default", "sleep";
>> +
>> +        interrupts = <GIC_SPI 334 IRQ_TYPE_LEVEL_HIGH>,
>> +                     <GIC_SPI 335 IRQ_TYPE_LEVEL_HIGH>,
>> +                     <GIC_SPI 336 IRQ_TYPE_LEVEL_HIGH>,
>> +                     <GIC_SPI 337 IRQ_TYPE_LEVEL_HIGH>;
>> +        interrupt-names = "rx_thresh", "rx", "tx", "misc";
> 
> I think with the ti-sysc managing the interconnect target module as the
> parent of this, you should be able add all the modules as direct children
> of ti-sysc with minor fixups. This would simplify things, and makes it
> easier to update the driver later on when the child modules get
> changed/updated/moved around.
> 
> The child modules just need to call PM runtime to have access to their
> registers, and whatever cpsw control module part could be a separate
> driver providing Linux standard services for example for clock gating :)
> 
>> +        davinci_mdio_sw: mdio@1000 {
>> +                compatible = "ti,cpsw-mdio","ti,davinci_mdio";
>> +                reg = <0x1000 0x100>;
>> +                clocks = <&gmac_clkctrl DRA7_GMAC_GMAC_CLKCTRL 0>;
>> +                clock-names = "fck";
>> +                #address-cells = <1>;
>> +                #size-cells = <0>;
>> +                bus_freq = <1000000>;
>> +
>> +                ethphy0_sw: ethernet-phy@0 {
>> +                        reg = <0>;
>> +                };
>> +
>> +                ethphy1_sw: ethernet-phy@1 {
>> +                        reg = <41>;
>> +                };
>> +        };
> 
> And in this case, mdio above would just move up one level.
> 
> This goes back to my earlier comments saying the cpsw is really just
> a private interconnect with a collection of various mostly independent
> modules. Sounds like you're heading that way already though at the
> driver level :)

No, sorry I do not agree. The MDIO is inseparable part of CPSW and it's enabled when CPSW is enabled
(on interconnect level), more over I want to get rid of platform device in MDIO for most of the cases
as it only introduces boot/probing complexity.

The same is valid for CPTS.

-- 
Best regards,
grygorii
