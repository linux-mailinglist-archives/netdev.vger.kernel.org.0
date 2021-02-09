Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1843315D23
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 03:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbhBJCWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 21:22:23 -0500
Received: from 3.mo6.mail-out.ovh.net ([178.33.253.26]:43005 "EHLO
        3.mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233610AbhBJCVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 21:21:25 -0500
Received: from player774.ha.ovh.net (unknown [10.109.143.220])
        by mo6.mail-out.ovh.net (Postfix) with ESMTP id 5674F240356
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 23:07:23 +0100 (CET)
Received: from milecki.pl (ip-194-187-74-233.konfederacka.maverick.com.pl [194.187.74.233])
        (Authenticated sender: rafal@milecki.pl)
        by player774.ha.ovh.net (Postfix) with ESMTPSA id 72B011AFB9FE1;
        Tue,  9 Feb 2021 22:07:12 +0000 (UTC)
Authentication-Results: garm.ovh; auth=pass (GARM-98R00214cc0512-b6f7-4d99-9498-2d40eb3402b0,
                    ECAF73ED9022E26008F51CC3B8E5D9CA72646693) smtp.auth=rafal@milecki.pl
X-OVh-ClientIp: 194.187.74.233
Subject: Re: [PATCH V2 net-next 1/2] dt-bindings: net: document BCM4908
 Ethernet controller
To:     Rob Herring <robh@kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Masahiro Yamada <masahiroy@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
References: <20210205214417.11178-1-zajec5@gmail.com>
 <20210207222632.10981-1-zajec5@gmail.com>
 <20210209214345.GA244143@robh.at.kernel.org>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Message-ID: <a22b4a6b-8712-f074-5168-f0800e6fa489@milecki.pl>
Date:   Tue, 9 Feb 2021 23:07:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210209214345.GA244143@robh.at.kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 548031780550512271
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduledrheehgdduheelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepuffvfhfhkffffgggjggtgfesthekredttdefjeenucfhrhhomheptfgrfhgrlhcuofhilhgvtghkihcuoehrrghfrghlsehmihhlvggtkhhirdhplheqnecuggftrfgrthhtvghrnhepffefgefhhfehjeetfeetkefgkeehleeghefgtddthefhgfffhfduieetjeffveegnecuffhomhgrihhnpeguvghvihgtvghtrhgvvgdrohhrghenucfkpheptddrtddrtddrtddpudelgedrudekjedrjeegrddvfeefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpqdhouhhtpdhhvghlohepphhlrgihvghrjeejgedrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehrrghfrghlsehmihhlvggtkhhirdhplhdprhgtphhtthhopehnvghtuggvvhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.02.2021 22:43, Rob Herring wrote:
> On Sun, Feb 07, 2021 at 11:26:31PM +0100, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>>
>> BCM4908 is a family of SoCs with integrated Ethernet controller.
>>
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>> ---
>>   .../bindings/net/brcm,bcm4908enet.yaml        | 45 +++++++++++++++++++
>>   1 file changed, 45 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/net/brcm,bcm4908enet.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/net/brcm,bcm4908enet.yaml b/Documentation/devicetree/bindings/net/brcm,bcm4908enet.yaml
>> new file mode 100644
>> index 000000000000..5f12f51c5b19
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/brcm,bcm4908enet.yaml
>> @@ -0,0 +1,45 @@
>> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/brcm,bcm4908enet.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: Broadcom BCM4908 Ethernet controller
>> +
>> +description: Broadcom's Ethernet controller integrated into BCM4908 family SoCs
>> +
>> +maintainers:
>> +  - Rafał Miłecki <rafal@milecki.pl>
>> +
> 
> allOf:
>    - $ref: 'ethernet-controller.yaml#'

Thanks!


>> +properties:
>> +  compatible:
>> +    const: brcm,bcm4908enet
> 
> Normal convention is 'brcm,bcm4908-enet'. (And update the filename/$id)

Is it? ;) It seems we have:
brcm,bcmgenet (not brcm,bcmg-enet)
fsl-enetc (not e.g. fsl-enet-c)
xilinx_axienet (not xilinx_axi-enet)
apm,xgene1-sgenet (not apm,xgene1-sg-enet)

Of course, as you seem to prefer *-enet, I'll make it so! V3 soon.


>> +
>> +  reg:
>> +    maxItems: 1
>> +
>> +  interrupts:
>> +    description: RX interrupt
>> +
>> +  interrupt-names:
>> +    const: rx
> 
> Don't really need *-names when only 1 possible entry.

I think this controller may have some more interrupts (I don't know about). We can "interrupt-names" later, when we find them out.
