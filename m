Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734804A6721
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 22:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbiBAViQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 16:38:16 -0500
Received: from 2.mo584.mail-out.ovh.net ([46.105.72.36]:58663 "EHLO
        2.mo584.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiBAViQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 16:38:16 -0500
X-Greylist: delayed 8397 seconds by postgrey-1.27 at vger.kernel.org; Tue, 01 Feb 2022 16:38:15 EST
Received: from player687.ha.ovh.net (unknown [10.108.20.113])
        by mo584.mail-out.ovh.net (Postfix) with ESMTP id 68E8123720
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 16:49:37 +0000 (UTC)
Received: from RCM-web6.webmail.mail.ovh.net (ip-194-187-74-233.konfederacka.maverick.com.pl [194.187.74.233])
        (Authenticated sender: rafal@milecki.pl)
        by player687.ha.ovh.net (Postfix) with ESMTPSA id 9168F26E9FF01;
        Tue,  1 Feb 2022 16:49:14 +0000 (UTC)
MIME-Version: 1.0
Date:   Tue, 01 Feb 2022 17:49:14 +0100
From:   =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
To:     Rob Herring <robh@kernel.org>, Michael Walle <michael@walle.cc>
Cc:     =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: Re: [PATCH REBASED 2/2] dt-bindings: nvmem: cells: add MAC address
 cell
In-Reply-To: <YflX6kxWTD6qMnhJ@robh.at.kernel.org>
References: <20220125180114.12286-1-zajec5@gmail.com>
 <20220126070745.32305-1-zajec5@gmail.com>
 <20220126070745.32305-2-zajec5@gmail.com>
 <YflX6kxWTD6qMnhJ@robh.at.kernel.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <1dd3522d9c7cfcb40f4f8198d4d35118@milecki.pl>
X-Sender: rafal@milecki.pl
X-Originating-IP: 194.187.74.233
X-Webmail-UserID: rafal@milecki.pl
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 7251076875513539502
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrgeefgdelvdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpeggfffhvffujghffgfkgihitgfgsehtkehjtddtreejnecuhfhrohhmpeftrghfrghlpgfoihhlvggtkhhiuceorhgrfhgrlhesmhhilhgvtghkihdrphhlqeenucggtffrrghtthgvrhhnpedugeeluefgffekfeehieehvdfgffehtdettefffeekieeijeelhfelvedvgfevtdenucffohhmrghinhepuggvvhhitggvthhrvggvrdhorhhgpdhkvghrnhgvlhdrohhrghenucfkpheptddrtddrtddrtddpudelgedrudekjedrjeegrddvfeefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpohhuthdphhgvlhhopehplhgrhigvrheikeejrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomheprhgrfhgrlhesmhhilhgvtghkihdrphhlpdhnsggprhgtphhtthhopedupdhrtghpthhtohepnhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhg
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-02-01 16:55, Rob Herring wrote:
> On Wed, Jan 26, 2022 at 08:07:45AM +0100, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>> 
>> This adds support for describing details of NVMEM cell containing MAC
>> address. Those are often device specific and could be nicely stored in
>> DT.
>> 
>> Initial documentation includes support for describing:
>> 1. Cell data format (e.g. Broadcom's NVRAM uses ASCII to store MAC)
>> 2. Reversed bytes flash (required for i.MX6/i.MX7 OCOTP support)
>> 3. Source for multiple addresses (very common in home routers)
>> 
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>> ---
>>  .../bindings/nvmem/cells/mac-address.yaml     | 94 
>> +++++++++++++++++++
>>  1 file changed, 94 insertions(+)
>>  create mode 100644 
>> Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml
>> 
>> diff --git 
>> a/Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml 
>> b/Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml
>> new file mode 100644
>> index 000000000000..f8d19e87cdf0
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml
>> @@ -0,0 +1,94 @@
>> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/nvmem/cells/mac-address.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: NVMEM cell containing a MAC address
>> +
>> +maintainers:
>> +  - Rafał Miłecki <rafal@milecki.pl>
>> +
>> +properties:
>> +  compatible:
>> +    const: mac-address
>> +
>> +  format:
>> +    description: |
>> +      Some NVMEM cells contain MAC in a non-binary format.
>> +
>> +      ASCII should be specified if MAC is string formatted like:
>> +      - "01:23:45:67:89:AB" (30 31 3a 32 33 3a 34 35 3a 36 37 3a 38 
>> 39 3a 41 42)
>> +      - "01-23-45-67-89-AB"
>> +      - "0123456789AB"
>> +    enum:
>> +      - ascii
>> +
>> +  reversed-bytes:
>> +    type: boolean
>> +    description: |
>> +      MAC is stored in reversed bytes order. Example:
>> +      Stored value: AB 89 67 45 23 01
>> +      Actual MAC: 01 23 45 67 89 AB
>> +
>> +  base-address:
>> +    type: boolean
>> +    description: |
>> +      Marks NVMEM cell as provider of multiple addresses that are 
>> relative to
>> +      the one actually stored physically. Respective addresses can be 
>> requested
>> +      by specifying cell index of NVMEM cell.
> 
> While a base address is common, aren't there different ways the base is
> modified.
> 
> The problem with these properties is every new variation results in a
> new property and the end result is something not well designed. A 
> unique
> compatible string, "#nvmem-cell-cells" and code to interpret the data 
> is
> more flexible.
> 
> For something like this to fly, I need some level of confidence this is
> enough for everyone for some time (IOW, find all the previous attempts
> and get those people's buy-in). You have found at least 3 cases, but I
> seem to recall more.

For base address I thought of dealing with base + offset only. I'm not
sure what are other cases.

I read few old threads:
https://lore.kernel.org/lkml/20211228142549.1275412-1-michael@walle.cc/T/
https://lore.kernel.org/linux-devicetree/20211123134425.3875656-1-michael@walle.cc/
https://lore.kernel.org/all/20210414152657.12097-2-michael@walle.cc/
https://lore.kernel.org/linux-devicetree/362f1c6a8b0ec191b285ac6a604500da@walle.cc/

but didn't find other required /transformations/ except for offset and
format. Even "reversed-bytes" wasn't widely discussed (or I missed that)
and I just came with it on my own.

If anyone knows other cases: please share so we have a complete view.


I tried to Cc all previously invovled people but it seems only me and
Michael remained active in this subject. If anyone knows other
interested please Cc them and let us know.


Rob: instead of me and Michael sending patch after patch let me try to
gather solutions I can think of / I recall. Please kindly review them
and let us know what do you find the cleanest.


1. NVMEM specific "compatible" string

Example:

partition@f00000 {
     compatible = "brcm,foo-cells", "nvmem-cells";
     label = "calibration";
     reg = <0xf00000 0x100000>;
     ranges = <0 0xf00000 0x100000>;
     #address-cells = <1>;
     #size-cells = <1>;

     mac@100 {
         reg = <0x100 0x6>;
         [optional: #nvmem-cell-cells = <1>;]
     };
};

A minimalistic binding proposed by Michael. DT doesn't carry any
information on NVMEM cell format. Specific drivers (e.g. one handling
"brcm,foo-cells") have to know how to handle specific cell.

Cell handling conditional code can depend on cell node name ("mac" in
above case) OR on value of "nvmem-cell-names" in cell consumer (e.g.
nvmem-cell-names = "mac-address").


2. NVMEM specific "compatible" string + cells "compatible"s

Example:

partition@f00000 {
     compatible = "brcm,foo-cells", "nvmem-cells";
     label = "calibration";
     reg = <0xf00000 0x100000>;
     ranges = <0 0xf00000 0x100000>;
     #address-cells = <1>;
     #size-cells = <1>;

     mac@100 {
         compatible = "mac-address";
         reg = <0x100 0x6>;
         [optional: #nvmem-cell-cells = <1>;]
     };
};

Similar to the first case but cells that require special handling are
marked with NVMEM device specific "compatible" values. Details of 
handling
cells are still hardcoded in NVMEM driver. Different cells with
compatible = "mac-address";
may be handled differencly - depending on parent NVMEM device.


3. Flexible properties in NVMEM cells

Example:

partition@f00000 {
     compatible = "brcm,foo-cells", "nvmem-cells";
     label = "calibration";
     reg = <0xf00000 0x100000>;
     ranges = <0 0xf00000 0x100000>;
     #address-cells = <1>;
     #size-cells = <1>;

     mac@100 {
         compatible = "mac-address";
         reg = <0x100 0x6>;
         [optional: #nvmem-cell-cells = <1>;]
     };

     mac@200 {
         compatible = "mac-address";
         reg = <0x200 0x6>;
         reversed-bytes;
         [optional: #nvmem-cell-cells = <1>;]
     };

     mac@300 {
         compatible = "mac-address";
         reg = <0x300 0x11>;
         format = "ascii";
         [optional: #nvmem-cell-cells = <1>;]
     };
};

This moves details into DT and requires more shared properties. It helps
avoiding duplicated code for common cases (like base MAC address).

It's what I proposed in the
[PATCH 0/2] dt-bindings: nvmem: support describing cells
