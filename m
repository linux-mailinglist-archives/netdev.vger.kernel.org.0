Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AE795B868E
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 12:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229912AbiINKqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Sep 2022 06:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiINKq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 06:46:29 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F3C5F99C;
        Wed, 14 Sep 2022 03:46:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663152353; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=iGPw8t+So/QnrltPxP7Gttojb7nAyji53CwJPoA+p7RtHQCbN52rrtaHHf8QeLwFzoEXyc9lOuOLwj3jN0MI+89GJtSArw9bHSZ6Y4Eh0NDgXVxlK5B1R/xUtE50UfZ081W7btm1G0DN8GUgRUG9wFbZjgbJg2AiBWSAwWkU+YY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663152353; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=JHE4hIaU+mIlGLtDCI0fwqADCbRQLVqPJfowtonHB9M=; 
        b=m+rANsaqtZuHm9fXCIiCe5MODHwgsRYTydEJKDNMAO9XcDUc6nm9L1Y/Wkj6EBo3Zw02S97XDZh88Tb0m0i86fOZ4XWIPTeSSYh7G42pJEbQDRzN+6dOxkvGoGplUWrT+VhmaxlhNMrUwhqiLEPuKv/ZC8qbc2V6b0qNnQBOh4c=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663152353;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=JHE4hIaU+mIlGLtDCI0fwqADCbRQLVqPJfowtonHB9M=;
        b=Apf13ZjF/Rk3R/cPtJWMZbsQA/4MEYyhFhpgd/JHZFyofgDqSLGjuSu7WnzRDhlg
        9a0QQ5h8U7sXfRKatYXvxZQaJIsfPHQmxrKKU27DjfyYyrQ2yxyhsbk5+xhpW4GN3D9
        QxE7qxqoFtZ9lQG8V5r5/Y3B+SR10j0tiOeTaV9I=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1663152351718975.8432230605008; Wed, 14 Sep 2022 03:45:51 -0700 (PDT)
Message-ID: <6593afa8-931b-81eb-d9a8-ec3adbd047c6@arinc9.com>
Date:   Wed, 14 Sep 2022 13:45:45 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 05/10] mips: dts: ralink: mt7621: fix some dtc warnings
Content-Language: en-US
To:     Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, erkin.bozoglu@xeront.com,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-arm-kernel@lists.infradead.org,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>
References: <20220914085451.11723-1-arinc.unal@arinc9.com>
 <20220914085451.11723-6-arinc.unal@arinc9.com>
 <CAMhs-H9pj+qEdOCEhkyCJPvbFonLuhgSHgL4L6kkhO3YRh52vw@mail.gmail.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <CAMhs-H9pj+qEdOCEhkyCJPvbFonLuhgSHgL4L6kkhO3YRh52vw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sergio,

On 14.09.2022 12:14, Sergio Paracuellos wrote:
> Hi Arinc,
> 
> On Wed, Sep 14, 2022 at 10:55 AM Arınç ÜNAL <arinc.unal@arinc9.com> wrote:
>>
>> Fix the dtc warnings below.
>>
>> /cpus/cpu@0: failed to match any schema with compatible: ['mips,mips1004Kc']
>> /cpus/cpu@1: failed to match any schema with compatible: ['mips,mips1004Kc']
>> uartlite@c00: $nodename:0: 'uartlite@c00' does not match '^serial(@.*)?$'
>>          From schema: /home/arinc9/Documents/linux/Documentation/devicetree/bindings/serial/8250.yaml
>> uartlite@c00: Unevaluated properties are not allowed ('clock-names' was unexpected)
>>          From schema: /home/arinc9/Documents/linux/Documentation/devicetree/bindings/serial/8250.yaml
>> sdhci@1e130000: $nodename:0: 'sdhci@1e130000' does not match '^mmc(@.*)?$'
>>          From schema: /home/arinc9/Documents/linux/Documentation/devicetree/bindings/mmc/mtk-sd.yaml
>> sdhci@1e130000: Unevaluated properties are not allowed ('bus-width', 'cap-mmc-highspeed', 'cap-sd-highspeed', 'disable-wp', 'max-frequency', 'vmmc-supply', 'vqmmc-supply' were unexpected)
>>          From schema: /home/arinc9/Documents/linux/Documentation/devicetree/bindings/mmc/mtk-sd.yaml
>> xhci@1e1c0000: $nodename:0: 'xhci@1e1c0000' does not match '^usb(@.*)?'
>>          From schema: /home/arinc9/Documents/linux/Documentation/devicetree/bindings/usb/mediatek,mtk-xhci.yaml
>> xhci@1e1c0000: compatible: ['mediatek,mt8173-xhci'] is too short
>>          From schema: /home/arinc9/Documents/linux/Documentation/devicetree/bindings/usb/mediatek,mtk-xhci.yaml
>> switch0@0: $nodename:0: 'switch0@0' does not match '^(ethernet-)?switch(@.*)?$'
>>          From schema: /home/arinc9/Documents/linux/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>> port@1: status:0: 'off' is not one of ['okay', 'disabled', 'reserved']
>>          From schema: /home/arinc9/.local/lib/python3.10/site-packages/dtschema/schemas/dt-core.yaml
>> port@2: status:0: 'off' is not one of ['okay', 'disabled', 'reserved']
>>          From schema: /home/arinc9/.local/lib/python3.10/site-packages/dtschema/schemas/dt-core.yaml
>> port@3: status:0: 'off' is not one of ['okay', 'disabled', 'reserved']
>>          From schema: /home/arinc9/.local/lib/python3.10/site-packages/dtschema/schemas/dt-core.yaml
>>
>> - Remove "mips,mips1004Kc" compatible string from the cpu nodes. This
>> doesn't exist anywhere.
>> - Change "memc: syscon@5000" to "memc: memory-controller@5000".
>> - Change "uartlite: uartlite@c00" to "serial0: serial@c00" and remove the
>> aliases node.
>> - Remove "clock-names" from the serial0 node. The property doesn't exist on
>> the 8250.yaml schema.
>> - Change "sdhci: sdhci@1e130000" to "mmc: mmc@1e130000".
>> - Change "xhci: xhci@1e1c0000" to "usb: usb@1e1c0000".
>> - Add "mediatek,mtk-xhci" as the second compatible string on the usb node.
>> - Change "switch0: switch0@0" to "switch0: switch@0"
>> - Change "off" to "disabled" for disabled nodes.
>>
>> Remaining warnings are caused by the lack of json-schema documentation.
>>
>> /cpuintc: failed to match any schema with compatible: ['mti,cpu-interrupt-controller']
>> /palmbus@1e000000/wdt@100: failed to match any schema with compatible: ['mediatek,mt7621-wdt']
>> /palmbus@1e000000/i2c@900: failed to match any schema with compatible: ['mediatek,mt7621-i2c']
>> /palmbus@1e000000/spi@b00: failed to match any schema with compatible: ['ralink,mt7621-spi']
>> /ethernet@1e100000: failed to match any schema with compatible: ['mediatek,mt7621-eth']
>>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
>>   .../boot/dts/ralink/mt7621-gnubee-gb-pc1.dts  |  2 +-
>>   .../boot/dts/ralink/mt7621-gnubee-gb-pc2.dts  |  2 +-
>>   arch/mips/boot/dts/ralink/mt7621.dtsi         | 32 +++++++------------
>>   3 files changed, 14 insertions(+), 22 deletions(-)
>>
>> diff --git a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc1.dts b/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc1.dts
>> index 24eebc5a85b1..6ecb8165efe8 100644
>> --- a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc1.dts
>> +++ b/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc1.dts
>> @@ -53,7 +53,7 @@ system {
>>          };
>>   };
>>
>> -&sdhci {
>> +&mmc {
>>          status = "okay";
>>   };
>>
>> diff --git a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts b/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts
>> index 34006e667780..2e534ea5bab7 100644
>> --- a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts
>> +++ b/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts
>> @@ -37,7 +37,7 @@ key-reset {
>>          };
>>   };
>>
>> -&sdhci {
>> +&mmc {
>>          status = "okay";
>>   };
>>
>> diff --git a/arch/mips/boot/dts/ralink/mt7621.dtsi b/arch/mips/boot/dts/ralink/mt7621.dtsi
>> index ee46ace0bcc1..9302bdc04510 100644
>> --- a/arch/mips/boot/dts/ralink/mt7621.dtsi
>> +++ b/arch/mips/boot/dts/ralink/mt7621.dtsi
>> @@ -15,13 +15,11 @@ cpus {
>>
>>                  cpu@0 {
>>                          device_type = "cpu";
>> -                       compatible = "mips,mips1004Kc";
>>                          reg = <0>;
>>                  };
>>
>>                  cpu@1 {
>>                          device_type = "cpu";
>> -                       compatible = "mips,mips1004Kc";
>>                          reg = <1>;
>>                  };
>>          };
> 
> Instead of removing this, since compatible is correct here, I think a
> cpus yaml file needs to be added to properly define mips CPU's but
> compatible strings using all around the sources are a bit messy. Take
> a look of how is this done for arm [0]

I did investigate the arm bindings beforehand. I've seen that some of 
the strings are also checked by code. I don't see the mips strings used 
anywhere but DTs so I had decided to remove it here. I guess we can make 
a basic binding to list the mips processor cores.

What do you think Thomas?

> 
>> @@ -33,11 +31,6 @@ cpuintc: cpuintc {
>>                  compatible = "mti,cpu-interrupt-controller";
>>          };
>>
>> -       aliases {
>> -               serial0 = &uartlite;
>> -       };
>> -
>> -
>>          mmc_fixed_3v3: regulator-3v3 {
>>                  compatible = "regulator-fixed";
>>                  regulator-name = "mmc_power";
>> @@ -110,17 +103,16 @@ i2c: i2c@900 {
>>                          pinctrl-0 = <&i2c_pins>;
>>                  };
>>
>> -               memc: syscon@5000 {
>> +               memc: memory-controller@5000 {
>>                          compatible = "mediatek,mt7621-memc", "syscon";
>>                          reg = <0x5000 0x1000>;
>>                  };
>>
> 
> I think syscon nodes need to use 'syscon' in the node name, but I am
> not 100% sure.

I've tested this patch series on my GB-PC2, it currently works fine. 
Also, DT binding for MT7621 memory controller uses memory-controller on 
the example so I guess it's fine?

Arınç
