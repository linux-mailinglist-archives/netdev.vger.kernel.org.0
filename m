Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D6095A77FF
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 09:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbiHaHsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 03:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbiHaHsI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 03:48:08 -0400
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7A13BD1C3;
        Wed, 31 Aug 2022 00:48:02 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 39D16380;
        Wed, 31 Aug 2022 09:48:00 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1661932080;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LFoMvcld848Bt86qzpVohSCUMCt08caHdx/NoqLmM1U=;
        b=C53N8311mpQvKcwwMc/oaAQ2T43ilFDeGn3pJEAf5Dj1bhxVoN5yyvFt1xuaN8eGbZmxqr
        ykM+SerEUn4fw8PhkS2yrD5M7+z7IKD9rrSZeLuFqV+EPWct1an/C3TZQsi63bMEXcsWhA
        80x3PsXna5lV2x6r797byOSWvqHkpotQ/4W5h2BimaCzpXkyx86BqHPRyYgZeCV+hF8Fvm
        qp2dwrQyw5fABeoxZrcuY2rxzcG49s8Q23w+iEcEI0/ToFqNbso9lqeqcQTVNI5e+EYan4
        NctumU/JUcggWiu7GIEHoHc2O67thifBQBmYcjner16A4JPfAKyRUX8gf0/rCg==
MIME-Version: 1.0
Date:   Wed, 31 Aug 2022 09:48:00 +0200
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
Subject: Re: [PATCH v1 08/14] dt-bindings: mtd: relax the nvmem compatible
 string
In-Reply-To: <e0afa0fc-4718-2aa1-2555-4ebb2274850b@linaro.org>
References: <20220825214423.903672-1-michael@walle.cc>
 <20220825214423.903672-9-michael@walle.cc>
 <e0afa0fc-4718-2aa1-2555-4ebb2274850b@linaro.org>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <c8aea3ecb0fcf08c42852f99a4f265b6@walle.cc>
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

Am 2022-08-31 09:37, schrieb Krzysztof Kozlowski:
> On 26/08/2022 00:44, Michael Walle wrote:
>> The "user-otp" and "factory-otp" compatible string just depicts a
>> generic NVMEM device. But an actual device tree node might as well
>> contain a more specific compatible string. Make it possible to add
>> more specific binding elsewere and just match part of the compatibles
> 
> typo: elsewhere
> 
>> here.
>> 
>> Signed-off-by: Michael Walle <michael@walle.cc>
>> ---
>>  Documentation/devicetree/bindings/mtd/mtd.yaml | 7 ++++---
>>  1 file changed, 4 insertions(+), 3 deletions(-)
>> 
>> diff --git a/Documentation/devicetree/bindings/mtd/mtd.yaml 
>> b/Documentation/devicetree/bindings/mtd/mtd.yaml
>> index 376b679cfc70..0291e439b6a6 100644
>> --- a/Documentation/devicetree/bindings/mtd/mtd.yaml
>> +++ b/Documentation/devicetree/bindings/mtd/mtd.yaml
>> @@ -33,9 +33,10 @@ patternProperties:
>> 
>>      properties:
>>        compatible:
>> -        enum:
>> -          - user-otp
>> -          - factory-otp
>> +        contains:
>> +          enum:
>> +            - user-otp
>> +            - factory-otp
> 
> This does not work in the "elsewhere" place. You need to use similar
> approach as we do for syscon or primecell.

I'm a bit confused. Looking at
   Documentation/devicetree/bindings/arm/primecell.yaml
it is done in the same way as this binding.

Whereas, the syscon use a "select:" on top of it. I'm
pretty sure, I've tested it without the select and the
validator picked up the constraints.

Could you elaborate on what is wrong here? Select missing?

-michael
