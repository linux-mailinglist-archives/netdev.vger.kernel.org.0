Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261A864E870
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 10:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiLPJD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 04:03:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiLPJDY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 04:03:24 -0500
Received: from mail.3ffe.de (0001.3ffe.de [159.69.201.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 114651EC5C;
        Fri, 16 Dec 2022 01:03:22 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id 6065B1382;
        Fri, 16 Dec 2022 10:03:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1671181399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7vJFigaF3hOVrlkh94Vhue4PWpwlwOfUG4VGh2Ry3so=;
        b=UxjrW7XS5s/5LVlnO1RX6ypK4y7kRWP+my750kFEmq9nfyoQMTUE9EPTNgIxHayJT/h6EJ
        B51y9RwgGn0wC2zyXY7NIz5rwMRWutVZWr4C4T/Twq7EkP+cmFCsJGPKYM0fr1/hwZlNny
        mk+8WAVUP2MBwxBtVPErTW6PoxSyxubKZmVPkKfjkGzQjhvigkkCXXD622q2bAQB4xfgpI
        iTNZ6yV60ezv4TEVNUvTpOoNaE9Bg5+dj1R1ud3eztXNIF0XrloFSpZRRiEay+7VcgZwY6
        ss+8jlNARSccp9hqkstryrnnI09UXNY41OPTrQJdyip2YI/POnDJ+mmZ6Y3s0Q==
MIME-Version: 1.0
Date:   Fri, 16 Dec 2022 10:03:19 +0100
From:   Michael Walle <michael@walle.cc>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Rob Herring <robh@kernel.org>, Xu Liang <lxu@maxlinear.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 3/4] dt-bindings: net: phy: add MaxLinear
 GPY2xx bindings
In-Reply-To: <6c82b403962aaf1450eb5014c9908328@walle.cc>
References: <20221202151204.3318592-1-michael@walle.cc>
 <20221202151204.3318592-4-michael@walle.cc>
 <20221205212924.GA2638223-robh@kernel.org>
 <99d4f476d4e0ce5945fa7e1823d9824a@walle.cc>
 <9c0506a6f654f72ea62fed864c1b2a26@walle.cc>
 <2597b9e5-7c61-e91c-741c-3fe18247e27c@linaro.org>
 <6c82b403962aaf1450eb5014c9908328@walle.cc>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <796a528b23aded95c1a647317c277b1f@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-12-06 10:44, schrieb Michael Walle:
> Am 2022-12-06 09:38, schrieb Krzysztof Kozlowski:
> 
>>>>> Just omit the interrupt property if you don't want interrupts and
>>>>> add it if you do.
>>>> 
>>>> How does that work together with "the device tree describes
>>>> the hardware and not the configuration". The interrupt line
>>>> is there, its just broken sometimes and thus it's disabled
>>>> by default for these PHY revisions/firmwares. With this
>>>> flag the user can say, "hey on this hardware it is not
>>>> relevant because we don't have shared interrupts or because
>>>> I know what I'm doing".
>> 
>> Yeah, that's a good question. In your case broken interrupts could be
>> understood the same as "not connected", so property not present. When
>> things are broken, you do not describe them fully in DTS for the
>> completeness of hardware description, right?
> 
> I'd agree here, but in this case it's different. First, it isn't
> obvious in the first place that things are broken and boards in
> the field wouldn't/couldn't get that update. I'd really expect
> an erratum from MaxLinear here. And secondly, (which I
> just noticed right now, sorry), is that the interrupt line
> is also used for wake-on-lan, which can also be used even for
> the "broken" PHYs.
> 
> To work around this, the basic idea was to just disable the
> normal interrupts and fall back to polling mode, as the PHY
> driver just use it for link detection and don't offer any
> advanced features like PTP (for now). But still get the system
> integrator a knob to opt-in to the old behavior on new device
> trees.
> 
>>> Specifically you can't do the following: Have the same device
>>> tree and still being able to use it with a future PHY firmware
>>> update/revision. Because according to your suggestion, this
>>> won't have the interrupt property set. With this flag you can
>>> have the following cases:
>>>   (1) the interrupt information is there and can be used in the
>>>       future by non-broken PHY revisions,
>>>   (2) broken PHYs will ignore the interrupt line
>>>   (3) except the system designer opts-in with this flag (because
>>>       maybe this is the only PHY on the interrupt line etc).
>> 
>> I am not sure if I understand the case. You want to have a DTS with
>> interrupts and "maxlinear,use-broken-interrupts", where the latter 
>> will
>> be ignored by some future firmware?
> 
> Yes, that's correct.
> 
>> Isn't then the property not really correct? Broken for one firmware
>> on the same device, working for other firmware on the same device?
> 
> Arguable, but you can interpret "use broken-interrupts" as no-op
> if there are no broken interrupts.
> 
>> I would assume that in such cases you (or bootloader or overlay)
>> should patch the DTS...
> 
> I think this would turn the opt-in into an opt-out and we'd rely
> on the bootloader to workaround the erratum. Which isn't what we
> want here.

Just a recap what happened on IRC:
  (1) Krzysztof signalled that such a property might be ok but the
      commit message should be explain it better. For reference
      here is what I explained there:

       maybe that property has a wrong name, but ultimately, it's just
       a hint that the systems designer wants to use the interrupts
       even if they don't work as expected, because they work on that
       particular hardware.
       the interrupt line is there but it's broken, there are device
       trees out there with that property, so all we can do is to not
       use the interrupts for that PHY. but as a systems designer who
       is aware of the consequences and knowing that they don't apply
       to my board, how could i then tell the driver to use it anyway.

  (2) Krzysztof pointed out that there is still the issue raised by
      Rob, that the schemas haven't any compatible and cannot be
      validated. I think that applies to all the network PHY bindings
      in the tree right now. I don't know how to fix them.

  (3) The main problem with the broken interrupt handling of the PHY
      is that it will disturb other devices on that interrupt line.
      IOW if the interrupt line is shared the PHY should fall back
      to polling mode. I haven't found anything in the interrupt
      subsys to query if a line is shared and I guess it's also
      conceptually impossible to do such a thing, because there
      might be any driver probed at a later time which also uses
      that line.
      Rob had the idea to walk the device tree and determine if
      a particular interrupt is used by other devices, too. If
      feasable, this sounds like a good enough heuristic for our
      problem. Although there might be some edge cases, like
      DT overlays loaded at linux runtime (?!).

So this is what I'd do now: I'd skip a new device tree property
for now and determine if the interrupt line is shared (by solely
looking at the DT) and then disable the interrupt in the PHY
driver. This begs the question what we do if there is no DT,
interrupts disabled or enabled?

Andrew, what do you think?

-michael
