Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47ED04C40EE
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 10:07:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238874AbiBYJH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 04:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbiBYJH5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 04:07:57 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 540C97DA8B;
        Fri, 25 Feb 2022 01:07:24 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id o6so6507890ljp.3;
        Fri, 25 Feb 2022 01:07:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=fn5NcQdFGV/AZHgQDeYIwdp5G2hT9QR6G0E+BTlLLmM=;
        b=N4g2+9yHMZqtwmQBiD8FqkUqq7CN1X/YvuxhJtdC2yuzcykeqaWPcVsnE4q042Y1UM
         TOstBjOfrs2dQGVhhVqEvZU5oGfGhNtdkzNl4sLRAWoTOlLB3I0ckBen1AD2h+dXW2gO
         8dO+oN62JifG2yLMMzik0ruT0F2/q53F1ywRyatSUKcFj0kaBg6fPA9JTtUIi6BN9SRZ
         zFPuBV7RWF1QCfP4uUGx5GaXb+4oL6ZjinYGnIA1HcvzFhA/GMrOy4EHOQ5zy9JXgN3Z
         zODn0JQq0F4ayIEO7RqUY4WStUFENzoQERU5bRWuOSq9x0UuPVzo5bmueMq19oEeOrD9
         Wh7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fn5NcQdFGV/AZHgQDeYIwdp5G2hT9QR6G0E+BTlLLmM=;
        b=o7ovbyaUc9Hqo7IUyatzUQpaKP4Z/VDe9eGoW4ErWY/f/G7+pgbbt0ng1kzbxHi/qH
         wO9a8o73b3RZjQDJldDroQM1OqU+auGFnZnqA5hrCxz83JO1rqgUfh8cNmujxx+MYmFp
         4OEmMVtEu/a6xg8QVr0agwkakR/IlmGJVA+PD25zEVCPFwLbzvK/C/B7ftXrUxbaA1PL
         vinyoYAUIM4VaW5QxVGrHDjNWAnoWBUhrn2SHd8S8fpmC6RXQSwYqRW3p2I/+bzHJuHB
         XAQcl8sxvuT2LetZkO3/ziCZ5bBqfNcFjOY+AQPylbD9Xwy894L9v1D7mJZZ5DM83UDN
         HHPA==
X-Gm-Message-State: AOAM533Ke8nGThg9Nu7GcieZJjUjSULeGSIEOVi0IBCKjfYOCCbdHtmE
        GAr9vJNCxV9JTEx0E78pbeY=
X-Google-Smtp-Source: ABdhPJyRoQba/jYURANAI4qY0Lq8l8uQgYFjt5ERV9t62ofrEn4pz2Xf8hUUah9/wcUDX+4xRslvZA==
X-Received: by 2002:a2e:9919:0:b0:244:b934:aa36 with SMTP id v25-20020a2e9919000000b00244b934aa36mr4658632lji.388.1645780042456;
        Fri, 25 Feb 2022 01:07:22 -0800 (PST)
Received: from [192.168.26.149] (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id a5-20020ac25e65000000b00443c375b7a7sm149342lfr.20.2022.02.25.01.07.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Feb 2022 01:07:21 -0800 (PST)
Message-ID: <e1458f39-a2fe-36bf-af8d-ef2162f7c514@gmail.com>
Date:   Fri, 25 Feb 2022 10:07:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH REBASED 2/2] dt-bindings: nvmem: cells: add MAC address
 cell
To:     Michael Walle <michael@walle.cc>, Rob Herring <robh@kernel.org>
Cc:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
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
        Hauke Mehrtens <hauke@hauke-m.de>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20220125180114.12286-1-zajec5@gmail.com>
 <20220126070745.32305-1-zajec5@gmail.com>
 <20220126070745.32305-2-zajec5@gmail.com>
 <YflX6kxWTD6qMnhJ@robh.at.kernel.org>
 <0b7b8f7ea6569f79524aea1a3d783665@walle.cc>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
In-Reply-To: <0b7b8f7ea6569f79524aea1a3d783665@walle.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1.02.2022 18:01, Michael Walle wrote:
> Am 2022-02-01 16:55, schrieb Rob Herring:
>> On Wed, Jan 26, 2022 at 08:07:45AM +0100, Rafał Miłecki wrote:
>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>
>>> This adds support for describing details of NVMEM cell containing MAC
>>> address. Those are often device specific and could be nicely stored in
>>> DT.
>>>
>>> Initial documentation includes support for describing:
>>> 1. Cell data format (e.g. Broadcom's NVRAM uses ASCII to store MAC)
>>> 2. Reversed bytes flash (required for i.MX6/i.MX7 OCOTP support)
>>> 3. Source for multiple addresses (very common in home routers)
>>>
>>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>>> ---
>>>  .../bindings/nvmem/cells/mac-address.yaml     | 94 +++++++++++++++++++
>>>  1 file changed, 94 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml
>>>
>>> diff --git a/Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml b/Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml
>>> new file mode 100644
>>> index 000000000000..f8d19e87cdf0
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/nvmem/cells/mac-address.yaml
>>> @@ -0,0 +1,94 @@
>>> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
>>> +%YAML 1.2
>>> +---
>>> +$id: http://devicetree.org/schemas/nvmem/cells/mac-address.yaml#
>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>>> +
>>> +title: NVMEM cell containing a MAC address
>>> +
>>> +maintainers:
>>> +  - Rafał Miłecki <rafal@milecki.pl>
>>> +
>>> +properties:
>>> +  compatible:
>>> +    const: mac-address
>>> +
>>> +  format:
>>> +    description: |
>>> +      Some NVMEM cells contain MAC in a non-binary format.
>>> +
>>> +      ASCII should be specified if MAC is string formatted like:
>>> +      - "01:23:45:67:89:AB" (30 31 3a 32 33 3a 34 35 3a 36 37 3a 38 39 3a 41 42)
>>> +      - "01-23-45-67-89-AB"
>>> +      - "0123456789AB"
>>> +    enum:
>>> +      - ascii
>>> +
>>> +  reversed-bytes:
>>> +    type: boolean
>>> +    description: |
>>> +      MAC is stored in reversed bytes order. Example:
>>> +      Stored value: AB 89 67 45 23 01
>>> +      Actual MAC: 01 23 45 67 89 AB
>>> +
>>> +  base-address:
>>> +    type: boolean
>>> +    description: |
>>> +      Marks NVMEM cell as provider of multiple addresses that are relative to
>>> +      the one actually stored physically. Respective addresses can be requested
>>> +      by specifying cell index of NVMEM cell.
>>
>> While a base address is common, aren't there different ways the base is
>> modified.
>>
>> The problem with these properties is every new variation results in a
>> new property and the end result is something not well designed. A unique
>> compatible string, "#nvmem-cell-cells" and code to interpret the data is
>> more flexible.
> 
> I actually like having a unique compatible for anything but the basic
> operations. For example, the sl28 vpd area also has a checksum, which
> could be handled if there is an own compatible. I don't think this is
> possible with this proposal. Also there is a version field, what if
> we change the layout of that thing? Am I supposed to change the
> device tree? The more I think about Rob's proposal to have a compatible
> the more I like it.

Having more detailed binding for cells doesn't stop you from using NVMEM
device specific binding.

You could have e.g.

partition@f00000 {
      compatible = "foo,foo-cells", "nvmem-cells";
      (...)

      mac@100 {
          compatible = "mac-address";
          reg = <0x100 0x6>;
      };

      OR

      mac@100 {
          compatible = "mac-address";
          reg = <0x100 0x11>;
          format = "ascii";
      };
};

Then you can have "foo,foo-cells" driver handling checksum.

I'm not saying we have to use this solution, just saying it's possible.
