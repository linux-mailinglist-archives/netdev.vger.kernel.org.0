Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC61114FA5
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 12:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726222AbfLFLOT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 06:14:19 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:35234 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726128AbfLFLOT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 06:14:19 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id xB6BE88C110234;
        Fri, 6 Dec 2019 05:14:08 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1575630848;
        bh=Zmh37uFMtwqctvfI1lVTnfB8t624XUrqIrQyeikJXz0=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Kr45+xjZxQAcs4cnBugZrs6uWYPcER8AaVw2Tue/UbcwSHkwVav6ljKdVNzAu1e41
         GC31UJmNIpyOwiZG0UTvqI+LQovSxw8su78t7Sfrqjhc1JglRyVf0xRmZdDDA0WvRb
         F6oiyxi9wEvfSPeiWy7wAsoHxMTY1FBm+zM35aCA=
Received: from DLEE104.ent.ti.com (dlee104.ent.ti.com [157.170.170.34])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB6BE781055118;
        Fri, 6 Dec 2019 05:14:07 -0600
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE104.ent.ti.com
 (157.170.170.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Fri, 6 Dec
 2019 05:14:07 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Fri, 6 Dec 2019 05:14:07 -0600
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB6BE4Kl122422;
        Fri, 6 Dec 2019 05:14:05 -0600
Subject: Re: [PATCH] dt-bindings: net: mdio: use non vendor specific
 compatible string in example
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
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <eb3cb685-5ddc-8e06-1e26-0f6bc43b294c@ti.com>
Date:   Fri, 6 Dec 2019 13:14:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAL_Jsq+viKkF4FFgpMhTjKCMLeGOX1o9Uq-StU6xwFuTcpCL2Q@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/12/2019 19:59, Rob Herring wrote:
> On Wed, Nov 27, 2019 at 9:39 AM Grygorii Strashko
> <grygorii.strashko@ti.com> wrote:
>>
>> Use non vendor specific compatible string in example, otherwise DT YAML
>> schemas validation may trigger warnings specific to TI ti,davinci_mdio
>> and not to the generic MDIO example.
>>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
>>   Documentation/devicetree/bindings/net/mdio.yaml | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/mdio.yaml b/Documentation/devicetree/bindings/net/mdio.yaml
>> index 5d08d2ffd4eb..524f062c6973 100644
>> --- a/Documentation/devicetree/bindings/net/mdio.yaml
>> +++ b/Documentation/devicetree/bindings/net/mdio.yaml
>> @@ -56,7 +56,7 @@ patternProperties:
>>   examples:
>>     - |
>>       davinci_mdio: mdio@5c030000 {
>> -        compatible = "ti,davinci_mdio";
>> +        compatible = "vendor,mdio";
> 
> The problem with this is eventually 'vendor,mdio' will get flagged as
> an undocumented compatible. We're a ways off from being able to enable
> that until we have a majority of bindings converted. Though maybe
> examples can be enabled sooner rather than later.
> 

May be some generic compatible string be used for all examples,
like: "vendor,example-ip". What do you think?

-- 
Best regards,
grygorii
