Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47575B9441
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 08:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiIOGZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 02:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiIOGZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 02:25:20 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84E92760F5;
        Wed, 14 Sep 2022 23:25:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1663223087; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=LHfWDtMNgOvOfEbfNUHH9nIVo7W0rsksV3jz1HdukHzBpVG+42uLX9ZfDPkPVk1hL+X7w6M7RLj1PbYXRP3RdOh1iJ1/EXSXKAM1z0oOg0FVrERfrR55hxkBjJSrck0Veaqv36JCs1gzWfvz8tebQqZ9E/vAHXGU1/Fw2QhNEvc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1663223087; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=oEaoXALK+VgOi7G2IDCnIIo3seYUhyWLBC+zZdaDb8Y=; 
        b=Iq43QbpkA2rATF9wTLiSrjmVigKCaJOk3d1KCpdo1g+8C1VHY+SmaCp0p5gzE6/oNiCZAEMMupt/uAJmYQxLjrPWE8St/UWmtPXNImOjFzY24qoikd5AolmEM1F4D1QksnFCAQd/JaNc72Zlr3oEaVnJ7me84dQMe672C/HWzDw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1663223087;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=oEaoXALK+VgOi7G2IDCnIIo3seYUhyWLBC+zZdaDb8Y=;
        b=Y11g1riPDVbG/5BDpiZU6eaGOxYQFzWbaNt27euGXFMWU3Y6CepPFVZIf5nSK8Af
        M3m57dpRwluzHEFRe9T7llqErBzbAqxFi46y8SauBrNvWFAYZuk+L+3ICxe87N0jJS+
        DiZRNF69GzVKb/0Cx743dvlgGK4mo80/WjzHgltU=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 1663223086300677.7194623027028; Wed, 14 Sep 2022 23:24:46 -0700 (PDT)
Message-ID: <90a639f9-d0b6-e2f3-a93b-b13a9695adae@arinc9.com>
Date:   Thu, 15 Sep 2022 09:24:39 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 05/10] mips: dts: ralink: mt7621: fix some dtc warnings
Content-Language: en-US
To:     Sergio Paracuellos <sergio.paracuellos@gmail.com>
Cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
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
 <6593afa8-931b-81eb-d9a8-ec3adbd047c6@arinc9.com>
 <CAMhs-H_woEpWVEWbe+1p76g6M3ALjoVn-OgzpnJQHOjd02tHxw@mail.gmail.com>
 <CAMhs-H9m9LdQ3J5PjDNo_fh1b6rhSdu5Ddb3nfE=2nWxfTCP=A@mail.gmail.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <CAMhs-H9m9LdQ3J5PjDNo_fh1b6rhSdu5Ddb3nfE=2nWxfTCP=A@mail.gmail.com>
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

On 15.09.2022 08:59, Sergio Paracuellos wrote:
> On Thu, Sep 15, 2022 at 5:30 AM Sergio Paracuellos
> <sergio.paracuellos@gmail.com> wrote:
>>
>> On Wed, Sep 14, 2022 at 12:46 PM Arınç ÜNAL <arinc.unal@arinc9.com> wrote:
>>>
>>> Hi Sergio,
>>>
>>> On 14.09.2022 12:14, Sergio Paracuellos wrote:
>>>> Hi Arinc,
>>>>
>>>> On Wed, Sep 14, 2022 at 10:55 AM Arınç ÜNAL <arinc.unal@arinc9.com> wrote:
>>>>>
>>>>> Fix the dtc warnings below.
>>>>>
>>>>> /cpus/cpu@0: failed to match any schema with compatible: ['mips,mips1004Kc']
>>>>> /cpus/cpu@1: failed to match any schema with compatible: ['mips,mips1004Kc']
>>>>> uartlite@c00: $nodename:0: 'uartlite@c00' does not match '^serial(@.*)?$'
>>>>>           From schema: /home/arinc9/Documents/linux/Documentation/devicetree/bindings/serial/8250.yaml
>>>>> uartlite@c00: Unevaluated properties are not allowed ('clock-names' was unexpected)
>>>>>           From schema: /home/arinc9/Documents/linux/Documentation/devicetree/bindings/serial/8250.yaml
>>>>> sdhci@1e130000: $nodename:0: 'sdhci@1e130000' does not match '^mmc(@.*)?$'
>>>>>           From schema: /home/arinc9/Documents/linux/Documentation/devicetree/bindings/mmc/mtk-sd.yaml
>>>>> sdhci@1e130000: Unevaluated properties are not allowed ('bus-width', 'cap-mmc-highspeed', 'cap-sd-highspeed', 'disable-wp', 'max-frequency', 'vmmc-supply', 'vqmmc-supply' were unexpected)
>>>>>           From schema: /home/arinc9/Documents/linux/Documentation/devicetree/bindings/mmc/mtk-sd.yaml
>>>>> xhci@1e1c0000: $nodename:0: 'xhci@1e1c0000' does not match '^usb(@.*)?'
>>>>>           From schema: /home/arinc9/Documents/linux/Documentation/devicetree/bindings/usb/mediatek,mtk-xhci.yaml
>>>>> xhci@1e1c0000: compatible: ['mediatek,mt8173-xhci'] is too short
>>>>>           From schema: /home/arinc9/Documents/linux/Documentation/devicetree/bindings/usb/mediatek,mtk-xhci.yaml
>>>>> switch0@0: $nodename:0: 'switch0@0' does not match '^(ethernet-)?switch(@.*)?$'
>>>>>           From schema: /home/arinc9/Documents/linux/Documentation/devicetree/bindings/net/dsa/mediatek,mt7530.yaml
>>>>> port@1: status:0: 'off' is not one of ['okay', 'disabled', 'reserved']
>>>>>           From schema: /home/arinc9/.local/lib/python3.10/site-packages/dtschema/schemas/dt-core.yaml
>>>>> port@2: status:0: 'off' is not one of ['okay', 'disabled', 'reserved']
>>>>>           From schema: /home/arinc9/.local/lib/python3.10/site-packages/dtschema/schemas/dt-core.yaml
>>>>> port@3: status:0: 'off' is not one of ['okay', 'disabled', 'reserved']
>>>>>           From schema: /home/arinc9/.local/lib/python3.10/site-packages/dtschema/schemas/dt-core.yaml
>>>>>
>>>>> - Remove "mips,mips1004Kc" compatible string from the cpu nodes. This
>>>>> doesn't exist anywhere.
>>>>> - Change "memc: syscon@5000" to "memc: memory-controller@5000".
>>>>> - Change "uartlite: uartlite@c00" to "serial0: serial@c00" and remove the
>>>>> aliases node.
>>>>> - Remove "clock-names" from the serial0 node. The property doesn't exist on
>>>>> the 8250.yaml schema.
>>>>> - Change "sdhci: sdhci@1e130000" to "mmc: mmc@1e130000".
>>>>> - Change "xhci: xhci@1e1c0000" to "usb: usb@1e1c0000".
>>>>> - Add "mediatek,mtk-xhci" as the second compatible string on the usb node.
>>>>> - Change "switch0: switch0@0" to "switch0: switch@0"
>>>>> - Change "off" to "disabled" for disabled nodes.
>>>>>
>>>>> Remaining warnings are caused by the lack of json-schema documentation.
>>>>>
>>>>> /cpuintc: failed to match any schema with compatible: ['mti,cpu-interrupt-controller']
>>>>> /palmbus@1e000000/wdt@100: failed to match any schema with compatible: ['mediatek,mt7621-wdt']
>>>>> /palmbus@1e000000/i2c@900: failed to match any schema with compatible: ['mediatek,mt7621-i2c']
>>>>> /palmbus@1e000000/spi@b00: failed to match any schema with compatible: ['ralink,mt7621-spi']
>>>>> /ethernet@1e100000: failed to match any schema with compatible: ['mediatek,mt7621-eth']
>>>>>
>>>>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>>>>> ---
>>>>>    .../boot/dts/ralink/mt7621-gnubee-gb-pc1.dts  |  2 +-
>>>>>    .../boot/dts/ralink/mt7621-gnubee-gb-pc2.dts  |  2 +-
>>>>>    arch/mips/boot/dts/ralink/mt7621.dtsi         | 32 +++++++------------
>>>>>    3 files changed, 14 insertions(+), 22 deletions(-)
>>>>>
>>>>> diff --git a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc1.dts b/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc1.dts
>>>>> index 24eebc5a85b1..6ecb8165efe8 100644
>>>>> --- a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc1.dts
>>>>> +++ b/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc1.dts
>>>>> @@ -53,7 +53,7 @@ system {
>>>>>           };
>>>>>    };
>>>>>
>>>>> -&sdhci {
>>>>> +&mmc {
>>>>>           status = "okay";
>>>>>    };
>>>>>
>>>>> diff --git a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts b/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts
>>>>> index 34006e667780..2e534ea5bab7 100644
>>>>> --- a/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts
>>>>> +++ b/arch/mips/boot/dts/ralink/mt7621-gnubee-gb-pc2.dts
>>>>> @@ -37,7 +37,7 @@ key-reset {
>>>>>           };
>>>>>    };
>>>>>
>>>>> -&sdhci {
>>>>> +&mmc {
>>>>>           status = "okay";
>>>>>    };
>>>>>
>>>>> diff --git a/arch/mips/boot/dts/ralink/mt7621.dtsi b/arch/mips/boot/dts/ralink/mt7621.dtsi
>>>>> index ee46ace0bcc1..9302bdc04510 100644
>>>>> --- a/arch/mips/boot/dts/ralink/mt7621.dtsi
>>>>> +++ b/arch/mips/boot/dts/ralink/mt7621.dtsi
>>>>> @@ -15,13 +15,11 @@ cpus {
>>>>>
>>>>>                   cpu@0 {
>>>>>                           device_type = "cpu";
>>>>> -                       compatible = "mips,mips1004Kc";
>>>>>                           reg = <0>;
>>>>>                   };
>>>>>
>>>>>                   cpu@1 {
>>>>>                           device_type = "cpu";
>>>>> -                       compatible = "mips,mips1004Kc";
>>>>>                           reg = <1>;
>>>>>                   };
>>>>>           };
>>>>
>>>> Instead of removing this, since compatible is correct here, I think a
>>>> cpus yaml file needs to be added to properly define mips CPU's but
>>>> compatible strings using all around the sources are a bit messy. Take
>>>> a look of how is this done for arm [0]
>>>
>>> I did investigate the arm bindings beforehand. I've seen that some of
>>> the strings are also checked by code. I don't see the mips strings used
>>> anywhere but DTs so I had decided to remove it here. I guess we can make
>>> a basic binding to list the mips processor cores.
>>
>> At the very least I do think a compatible string should exist for cpu
>> nodes :). And because of the mess with MIPS cpu nodes in dts files all
>> around I think we should only add this 'compatible' as a requirement
>> and mark 'reg' and 'device_type' as optionals.
> 
> I have just sent a patch to start from containing all compatible
> strings I have found in the 'arch/mips/boot/dts' folder:
> 
> https://lore.kernel.org/linux-devicetree/20220915055514.463241-1-sergio.paracuellos@gmail.com/T/#u

Awesome, I'll keep the string on v2.

> 
>>
>>>
>>> What do you think Thomas?
>>>
>>>>
>>>>> @@ -33,11 +31,6 @@ cpuintc: cpuintc {
>>>>>                   compatible = "mti,cpu-interrupt-controller";
>>>>>           };
>>>>>
>>>>> -       aliases {
>>>>> -               serial0 = &uartlite;
>>>>> -       };
>>>>> -
>>>>> -
>>>>>           mmc_fixed_3v3: regulator-3v3 {
>>>>>                   compatible = "regulator-fixed";
>>>>>                   regulator-name = "mmc_power";
>>>>> @@ -110,17 +103,16 @@ i2c: i2c@900 {
>>>>>                           pinctrl-0 = <&i2c_pins>;
>>>>>                   };
>>>>>
>>>>> -               memc: syscon@5000 {
>>>>> +               memc: memory-controller@5000 {
>>>>>                           compatible = "mediatek,mt7621-memc", "syscon";
>>>>>                           reg = <0x5000 0x1000>;
>>>>>                   };
>>>>>
>>>>
>>>> I think syscon nodes need to use 'syscon' in the node name, but I am
>>>> not 100% sure.
>>>
>>> I've tested this patch series on my GB-PC2, it currently works fine.
>>> Also, DT binding for MT7621 memory controller uses memory-controller on
>>> the example so I guess it's fine?
>>
>> I know that works fine but when the node is a syscon it is good to
>> have that syscon in the node name (I don't know if having it is a rule
>> or something, I guess no). In any case I agree that binding and dts
>> should match.

Understood, I'll keep it syscon in v2.

Arınç
