Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6482E4AA629
	for <lists+netdev@lfdr.de>; Sat,  5 Feb 2022 04:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378933AbiBEDSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 22:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238357AbiBEDSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 22:18:32 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0B76C061346;
        Fri,  4 Feb 2022 19:18:31 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id n32so6675998pfv.11;
        Fri, 04 Feb 2022 19:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=R7incvgluYs5dTKR2o83cZ4xjLUlYz2zw4AZmoxYKh0=;
        b=CruTIdnN0MOxwfdWronF0oZDLrIx9+ejQZH03EMu/p/DMVEu2ZYE9W28nRI2xeCuuz
         9PQ9G43A0iq58Q7HnnjhtuXnltzAynm1kAw6Eyq6hbu6W7NxjTwN4CLeKL1ytizDGPuq
         FnqX8WUTNOJDS9lpIdYS/VTLHnsc0LPXj0ro0JO30Gly3KKWwMsO3qTRYk9fay89dKKe
         HVaBVptsa70kgMMMZ9+qB5JWVRfkuyljPQw853tTksh8CBHwtNQeHtL/aDDzhKgOhM7R
         gHFnw0t26rvNApUUdVZnhnQr8Cwf3cqNWHGfTowxXT4tUYXQsbFUKI8qx1Ob+1TC2GcB
         efjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=R7incvgluYs5dTKR2o83cZ4xjLUlYz2zw4AZmoxYKh0=;
        b=fyWYv1k/92krQel7L+7KzcpWYjBaEwBrFg3CAHTTbgqlXruD5LsnNLQ1EaapFH0Dq+
         8D3EkJOUO9cqKBRHUY84aEoHy8TTlGDW4tjTey9VUshZwVHyQCFdlfwIVYnaJN+I9kFR
         l1/SrwXkgmQLK/M4m0GbxehqsRwxits2cTYyIQhBy07oj5WfkoZaNqQSC9l1NN8iiaOC
         74ZDDQZv87tPgA1+Zxn2lq1O8LG8NjcU9TdHY4uyLvW3Pd7fRowSi9/6wl1LPZLDqBgq
         V9CgycRf5HDphq51J1NY4TheZLfLgPlXUNIpvTXQbS3FDNFqQrPScX8BZsNafGplojBl
         NKxw==
X-Gm-Message-State: AOAM532pACOu6cBmxCQoiQgZipKWwCtYmKetnY2RysgWMKOyKlnM1CDg
        +yENJ8RcoWTWrEYapOaAIjQ=
X-Google-Smtp-Source: ABdhPJz0qcDgW8+C4I/2MCh/cmTTsVEqPv/CztD4vzde27m+23EhRqV4bgrd6uiOBpW+l1Xcx0V59w==
X-Received: by 2002:a63:8ac9:: with SMTP id y192mr1630526pgd.598.1644031110164;
        Fri, 04 Feb 2022 19:18:30 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:d9cb:da6e:2448:2d1c? ([2600:8802:b00:4a48:d9cb:da6e:2448:2d1c])
        by smtp.gmail.com with ESMTPSA id s6sm2682161pgk.44.2022.02.04.19.18.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 19:18:29 -0800 (PST)
Message-ID: <d34fc733-d8ee-5e11-92b2-11a948d656cf@gmail.com>
Date:   Fri, 4 Feb 2022 19:18:27 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH devicetree v3] dt-bindings: phy: Add `tx-p2p-microvolt`
 property binding
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>
Cc:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        devicetree@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Holger Brunck <holger.brunck@hitachienergy.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        linux-phy@lists.infradead.org, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>
References: <20220119131117.30245-1-kabel@kernel.org>
 <74566284-ff3f-8e69-5b7d-d8ede75b78ad@gmail.com>
 <Yf3egEVYyyXUkklM@robh.at.kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <Yf3egEVYyyXUkklM@robh.at.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/4/2022 6:18 PM, Rob Herring wrote:
> On Fri, Jan 21, 2022 at 11:18:09AM -0800, Florian Fainelli wrote:
>> On 1/19/22 5:11 AM, Marek Behún wrote:
>>> Common PHYs and network PCSes often have the possibility to specify
>>> peak-to-peak voltage on the differential pair - the default voltage
>>> sometimes needs to be changed for a particular board.
>>>
>>> Add properties `tx-p2p-microvolt` and `tx-p2p-microvolt-names` for this
>>> purpose. The second property is needed to specify the mode for the
>>> corresponding voltage in the `tx-p2p-microvolt` property, if the voltage
>>> is to be used only for speficic mode. More voltage-mode pairs can be
>>> specified.
>>>
>>> Example usage with only one voltage (it will be used for all supported
>>> PHY modes, the `tx-p2p-microvolt-names` property is not needed in this
>>> case):
>>>
>>>    tx-p2p-microvolt = <915000>;
>>>
>>> Example usage with voltages for multiple modes:
>>>
>>>    tx-p2p-microvolt = <915000>, <1100000>, <1200000>;
>>>    tx-p2p-microvolt-names = "2500base-x", "usb", "pcie";
>>>
>>> Add these properties into a separate file phy/transmit-amplitude.yaml,
>>> which should be referenced by any binding that uses it.
>>
>> p2p commonly means peer to peer which incidentally could be confusing,
>> can you spell out the property entire:
>>
>> tx-peaktopeak-microvolt or:
>>
>> tx-pk2pk-microvolt for a more compact name maybe?
> 
> Peer to peer makes little sense in terms of a voltage. I think this is
> fine as-is.

Understood, my point was that peer is a word that is commonly used in an 
environment where you are talking about networking equipment at large. 
Anyway, feel free to ignore it.
-- 
Florian
