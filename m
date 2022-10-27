Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 747C460FCA4
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 18:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236376AbiJ0QIP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 12:08:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236344AbiJ0QIN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 12:08:13 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D450B181DB5
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 09:08:09 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id i12so1735955qvs.2
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 09:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+EByezWssNJpDNY0y+L8q4F549C1PMWF7aqVJonq+z0=;
        b=aAVZaCTCOqatS09ZMKrhBEnOEbQndq2u9CKWDuWcuRP38rqyHCkiTwZh9zPE1q2+mR
         gVCrlGA4rKcKHf1K8jkfpjSR/pPaLnDDzvrIbCYPTBNc9lncg0QvLmshiuF7Cxm4Gltx
         uCb8bYZaFFjiT7/PbY6/ZuMUYPXBEPw8I1xqdf2vDQ8xzr6B7vmxhvhJLJvrfImXcL4K
         X44hEmyBYA8IwWRc/hMhQ2db2BTq2sV17rr1r+/KCnuKEjqJ98Nlt3u1bPvOxe9S8epF
         3Lii+YEzV+Nbr6Noz/2gnVYU5pU95cPX4XV1D8Jku1vlQEoIOW0NCsQdmSUADbhfr4mA
         ILCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+EByezWssNJpDNY0y+L8q4F549C1PMWF7aqVJonq+z0=;
        b=OmpBril6PwwlB65NM7tJQn9oIKnqBirKwt+yrZJluMVRtKdBTv2ayCxiatU1bK1LZ/
         B6+3T1jKPO1ik9n3cmw9NWPsu/+5HBrdJewtQ+t+pee9qwj1iATFHTYouriVpOa+cDju
         D17TkBznwTUahOxZWRYXtBFEkmmGpa0hyC9rJ+KL2RZoILUEKUFaU0zQWiKY5RQP4vAC
         LcW9Q7Ypf36kpAdMvSpLT0cZG4u8eFBJtsdU1rOs1SkwNsDjnDE1dKeE0TGuf1UyBDlT
         9WOHOkxJVixz5i4FPyQAbN7+xmawYO/ZoUCKWB0N9KQMht2s4vrZvUER43Gn0hEEWmFH
         qSbA==
X-Gm-Message-State: ACrzQf0LOZCx9ro0K4FO3tVhgKrT3md9mbAAVA68J+INNOGVy4b6dm+G
        ZS0LRojjVtoCeTWw4oMVQO1v2A==
X-Google-Smtp-Source: AMsMyM5KQ32g/c5YieGNUnfeAUqqnYFAbo62RxNtSDi/P5hmklPmYdfcPmNYo17iNk7me6skE3c8Ow==
X-Received: by 2002:a05:6214:dac:b0:4bb:5901:38b1 with SMTP id h12-20020a0562140dac00b004bb590138b1mr26687385qvh.18.1666886888990;
        Thu, 27 Oct 2022 09:08:08 -0700 (PDT)
Received: from [192.168.1.11] ([64.57.193.93])
        by smtp.gmail.com with ESMTPSA id g19-20020a05620a40d300b006eeb3165565sm1214137qko.80.2022.10.27.09.08.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Oct 2022 09:08:08 -0700 (PDT)
Message-ID: <b2844341-d334-27e6-bceb-94914e42131c@linaro.org>
Date:   Thu, 27 Oct 2022 12:08:06 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [RFC net-next 1/2] dt-bindings: net: dsa: add bindings for GSW
 Series switches
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Camel Guo <camelg@axis.com>, Camel Guo <Camel.Guo@axis.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Rob Herring <robh@kernel.org>, kernel <kernel@axis.com>
References: <20221025135243.4038706-1-camel.guo@axis.com>
 <20221025135243.4038706-2-camel.guo@axis.com>
 <16aac887-232a-7141-cc65-eab19c532592@linaro.org>
 <d0179725-0730-5826-caa4-228469d3bad4@axis.com>
 <a7f75d47-30e7-d076-a9fd-baa57688bbf7@linaro.org>
 <20221027135719.pt7rz6dnjvcuqcxv@skbuf>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221027135719.pt7rz6dnjvcuqcxv@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/10/2022 09:57, Vladimir Oltean wrote:
> Hi Camel,
> 
> On Thu, Oct 27, 2022 at 08:46:27AM -0400, Krzysztof Kozlowski wrote:
>>>  >> +      - enum:
>>>  >> +          - mxl,gsw145-mdio
>>>  >
>>>  > Why "mdio" suffix?
>>>
>>> Inspired by others dsa chips.
>>> lan9303.txt:  - "smsc,lan9303-mdio" for mdio managed mode
>>> lantiq-gswip.txt:- compatible   : "lantiq,xrx200-mdio" for the MDIO bus
>>> inside the GSWIP
>>> nxp,sja1105.yaml:                  - nxp,sja1110-base-t1-mdio
>>
>> As I replied to Andrew, this is discouraged.
> 
> Let's compare apples to apples, shall we?
> "nxp,sja1110-base-t1-mdio" is the 100Base-T1 MDIO controller of the
> NXP SJA1110 switch, hence the name. It is not a SJA1110 switch connected
> over MDIO.

Thanks for clarifying. Then this could be fine. Let me then explain what
is discouraged:
1. Adding bus suffixes to the compatible, so for example foo,bar LED
controller is on I2C bus, so you call it "foo,bar-i2c".

2. Adding device types to the compatible, if this is the only
function/variant of the device, so for example calling foo,bar LED
controller "foo,bar-led". This makes sense in case of multi functional
devices (PMICs, SoCs), but not standalone ones.

So what do we have here? Is it one of the cases above?

Best regards,
Krzysztof

