Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE5595A78C3
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 10:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbiHaIRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 04:17:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbiHaIR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 04:17:28 -0400
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B577C695F;
        Wed, 31 Aug 2022 01:17:07 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 4D172126D;
        Wed, 31 Aug 2022 10:17:04 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661933824;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e3iSpyQN09evFGUwpbcqnJSarhmjMiSyteJCLVWGduA=;
        b=QAQljtSCAZAC3wYiQG4rjFZPhdZ2aNOc0QjDAFzywpAhteTA6SXzvE0y8WPLsONYQyCcOR
        9GRj8C9xSA1HQY1YH7W4ZF82mtAk/aiNFyRup8l/T/+bZTDPejrSYLoedouuOFu88lvQxn
        BRR4Stwm8QeCOLpbDmNyH3/vSK7PjZOSBMYvaPyw1+PH5ESRWtmOKwDc8BW/Ji5FbAwq3Q
        BJQdUZ6Y3llTQfNGKuFdg+DC3rMrQ0NvCMZHGOWeJVAOwGSHlggWCYv5hBn2p8DIG0Yfdo
        KmizTcWjRPUAv2rqUClWVGn3CxaCXkhyJiwPPR+Sgxs5TVm9Z7FtL92zaAyGmw==
MIME-Version: 1.0
Date:   Wed, 31 Aug 2022 10:17:04 +0200
From:   Michael Walle <michael@walle.cc>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Frank Rowand <frowand.list@gmail.com>,
        linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: Re: [PATCH v1 09/14] dt-bindings: nvmem: add YAML schema for the sl28
 vpd layout
In-Reply-To: <b85276ee-3e19-3adb-8077-c1e564e02eb3@linaro.org>
References: <20220825214423.903672-1-michael@walle.cc>
 <20220825214423.903672-10-michael@walle.cc>
 <b85276ee-3e19-3adb-8077-c1e564e02eb3@linaro.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <ddaf3328bc7d88c47517285a3773470f@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-08-31 09:45, schrieb Krzysztof Kozlowski:
> On 26/08/2022 00:44, Michael Walle wrote:
>> Add a schema for the NVMEM layout on Kontron's sl28 boards.
>> 
>> Signed-off-by: Michael Walle <michael@walle.cc>
>> ---
>>  .../nvmem/layouts/kontron,sl28-vpd.yaml       | 52 
>> +++++++++++++++++++
>>  1 file changed, 52 insertions(+)
>>  create mode 100644 
>> Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml
>> 
>> diff --git 
>> a/Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml 
>> b/Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml
>> new file mode 100644
>> index 000000000000..e4bc2d9182db
>> --- /dev/null
>> +++ 
>> b/Documentation/devicetree/bindings/nvmem/layouts/kontron,sl28-vpd.yaml
>> @@ -0,0 +1,52 @@
>> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: 
>> http://devicetree.org/schemas/nvmem/layouts/kontron,sl28-vpd.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: NVMEM layout of the Kontron SMARC-sAL28 vital product data
>> +
>> +maintainers:
>> +  - Michael Walle <michael@walle.cc>
>> +
>> +description:
>> +  The vital product data (VPD) of the sl28 boards contains a serial
>> +  number and a base MAC address. The actual MAC addresses for the
>> +  on-board ethernet devices are derived from this base MAC address by
>> +  adding an offset.
>> +
>> +properties:
>> +  compatible:
>> +    items:
>> +      - const: kontron,sl28-vpd
>> +      - const: user-otp
>> +
>> +  serial-number:
>> +    type: object
> 
> You should define the contents of this object. I would expect this to 
> be
> uint32 or string. I think you also need description, as this is not
> really standard field.

First thing, this binding isn't like the usual ones, so it might be
totally wrong.

What I'd like to achieve here is the following:

We have the nvmem-consumer dt binding where you can reference a
nvmem cell in a consumer node. Example:
   nvmem-cells = <&base_mac_address 5>;
   nvmem-cell-names = "mac-address";

On the other end of the link we have the nvmem-provider. The dt
bindings works well if that one has individual cell nodes, like
it is described in the nvmem.yaml binding. I.e. you can give the
cell a label and make a reference to it in the consumer just like
in the example above.

Now comes the catch: what if there is no actual description of the
cell in the device tree, but is is generated during runtime. How
can I get a label to it. Therefore, in this case, there is just
an empty node and the driver will associate it with the cell
created during runtime (see patch 10). It is not expected, that
is has any properties.

>> +
>> +  base-mac-address:
> 
> Fields should be rather described here, not in top-level description.
> 
>> +    type: object
> 
> On this level:
>     additionalProperties: false
> 
>> +
>> +    properties:
>> +      "#nvmem-cell-cells":
>> +        const: 1
>> +
> 
> I also wonder why you do not have unit addresses. What if you want to
> have two base MAC addresses?

That would describe an offset within the nvmem device. But the offset
might not be constant, depending on the content. My understanding
so far was that in that case, you use the "-N" suffix.

base-mac-address-1
base-mac-address-2

(or maybe completely different names).

>> +required:
>> +  - compatible
> 
> Other fields are I guess required? At least serial-number should be 
> always?

Yes I could add them to the required list, but they are only
"required" if you need to reference them within the device tree, in 
which
case there have to be there anyway. IOW, the driver doesn't care if
there is a node. If there is none, it doesn't set the "struct 
device_node*"
in the nvmem cell.

>> +
>> +additionalProperties: false
>> +
>> +examples:
>> +  - |
>> +      otp-1 {
> 
> Messed up indentation (use 4 spaces). Generic node name "otp".
> 
>> +          compatible = "kontron,sl28-vpd", "user-otp";
>> +
>> +          serial_number: serial-number {
> 
> What's the point of the empty node?

See above.

-michael

>> +          };
>> +
>> +          base_mac_address: base-mac-address {
>> +              #nvmem-cell-cells = <1>;
>> +          };
>> +      };
>> +
>> +...
