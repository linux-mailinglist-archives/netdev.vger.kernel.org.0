Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30019122816
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 10:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfLQJ6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 04:58:06 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:42508 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfLQJ6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 04:58:05 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id xBH9vrgG002303;
        Tue, 17 Dec 2019 03:57:53 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1576576673;
        bh=kte7BVuYVqY32RjMAWvDS4mgoVABOxfQA3f+71NU83s=;
        h=Subject:From:To:CC:References:Date:In-Reply-To;
        b=OGsiv4nDN8AQcCdF0Vxp5mNaBT0spklX0Dp0ZJNBZcZy+IplPBUf+lGnTz9jrbaP1
         Nhno2exXdboT4l7PZnUu5gg6ZqluvmoMXRwfSzbUnwVLaKJD1xQUURlIIJL4AMZemv
         dRjEA6wPS2zFB8ewJCHA+WS9hcVcOiTjMNfJwk7o=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xBH9vrNX015072
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 17 Dec 2019 03:57:53 -0600
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 17
 Dec 2019 03:57:53 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 17 Dec 2019 03:57:53 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id xBH9vpN1058862;
        Tue, 17 Dec 2019 03:57:51 -0600
Subject: Re: [PATCH] dt-bindings: net: mdio: use non vendor specific
 compatible string in example
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Rob Herring <robh+dt@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        netdev <netdev@vger.kernel.org>
References: <20191127153928.22408-1-grygorii.strashko@ti.com>
 <CAL_Jsq+viKkF4FFgpMhTjKCMLeGOX1o9Uq-StU6xwFuTcpCL2Q@mail.gmail.com>
 <eb3cb685-5ddc-8e06-1e26-0f6bc43b294c@ti.com>
 <CAL_JsqKZ5qexJMSm5MZYQp5LutyHHHObbfA3r2_XQa7E6kjqpg@mail.gmail.com>
 <72fc7152-abb8-e0b4-0e0f-c8afe649a2c7@ti.com>
Message-ID: <41f9a362-0eb2-dca9-5975-62a6497ca826@ti.com>
Date:   Tue, 17 Dec 2019 11:57:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <72fc7152-abb8-e0b4-0e0f-c8afe649a2c7@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On 06/12/2019 17:44, Grygorii Strashko wrote:
> 
> 
> On 06/12/2019 17:09, Rob Herring wrote:
>> On Fri, Dec 6, 2019 at 5:14 AM Grygorii Strashko
>> <grygorii.strashko@ti.com> wrote:
>>>
>>>
>>>
>>> On 05/12/2019 19:59, Rob Herring wrote:
>>>> On Wed, Nov 27, 2019 at 9:39 AM Grygorii Strashko
>>>> <grygorii.strashko@ti.com> wrote:
>>>>>
>>>>> Use non vendor specific compatible string in example, otherwise DT YAML
>>>>> schemas validation may trigger warnings specific to TI ti,davinci_mdio
>>>>> and not to the generic MDIO example.
>>>>>
>>>>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>>>> ---
>>>>>    Documentation/devicetree/bindings/net/mdio.yaml | 2 +-
>>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/net/mdio.yaml b/Documentation/devicetree/bindings/net/mdio.yaml
>>>>> index 5d08d2ffd4eb..524f062c6973 100644
>>>>> --- a/Documentation/devicetree/bindings/net/mdio.yaml
>>>>> +++ b/Documentation/devicetree/bindings/net/mdio.yaml
>>>>> @@ -56,7 +56,7 @@ patternProperties:
>>>>>    examples:
>>>>>      - |
>>>>>        davinci_mdio: mdio@5c030000 {
>>>>> -        compatible = "ti,davinci_mdio";
>>>>> +        compatible = "vendor,mdio";
>>>>
>>>> The problem with this is eventually 'vendor,mdio' will get flagged as
>>>> an undocumented compatible. We're a ways off from being able to enable
>>>> that until we have a majority of bindings converted. Though maybe
>>>> examples can be enabled sooner rather than later.
>>>>
>>>
>>> May be some generic compatible string be used for all examples,
>>> like: "vendor,example-ip". What do you think?
>>
>> I'm still not clear what problem you are trying to solve. 'may trigger
>> warnings' doesn't sound like an actual problem.
> 
> oh. sry.
> it's like this
>   - mdio.yaml describes generic MDIO properties, but uses compatible = "ti,davinci_mdio";
>   - davinci_mdio (or other IPs) has some custom properties.
>     Some of them can be marked as required - for example bus_freq.
>     And in the feature i need to add clocks.
> 
>    Now "bus_freq" is required for davinci_mdio, but not required for generic mdio example.
>    As result, by default, following warning will be produced:
> /home/grygorii/kernel.org/linux-master/linux/Documentation/devicetree/bindings/net/mdio.example.dt.yaml: mdio@5c030000: 'bus_freq' is a required property
> 
>   to w/a above I've added for davinci_mdio:
> if:
>    properties:
>      compatible:
>        contains:
>          const: ti,davinci_mdio
>    required:
>      - bus_freq
>   (by the way above is incorrect and if i add "then:" it will still produce warning :), but
>    it is different story)
> 
>   Next if I add "clocks" as required for davinci_mdio I'll get warning again and
>   will need to hack ti,davinci-mdio.yaml or update example in mdio.yaml.
> 
>   So, I'm the position of lucky persons who is working on some HW module which bindings
>   where occasionally selected as generic example. :)
> 
> FYI, below is example from power-domain.yaml:
> 
>      parent3: power-controller@12340000 {
>          compatible = "foo,power-controller";
>          reg = <0x12340000 0x1000>;
>          #power-domain-cells = <0>;
>          domain-idle-states = <&DOMAIN_RET>, <&DOMAIN_PWR_DN>;
>      };
> 

May be it would be acceptable to just drop "compatible" property from generic MDIO example?

-- 
Best regards,
grygorii
