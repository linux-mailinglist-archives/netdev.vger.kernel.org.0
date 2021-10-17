Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3BAC430A78
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 18:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242566AbhJQQVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 12:21:50 -0400
Received: from ixit.cz ([94.230.151.217]:43472 "EHLO ixit.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242540AbhJQQVu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Oct 2021 12:21:50 -0400
Received: from [192.168.1.138] (ip-89-176-96-70.net.upcbroadband.cz [89.176.96.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ixit.cz (Postfix) with ESMTPSA id 3651C24E6D;
        Sun, 17 Oct 2021 18:19:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ixit.cz; s=dkim;
        t=1634487577;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=wWjQh1NDpDiGhtuAQnWHLqSqeC+APKGhQWQnsGPgJHE=;
        b=XoN2T7JZ0Nvu6lGpniTJNBaigXp3/2OITiaJMVY7+1Nu43G4dusA/he+LDwTFEW6Z/quov
        5OiE5jKyanylzRmWDl0OdI13ui4e1GHyouKFZqj6X62nasmd0wdW4Nqum5XVVgwQwV8qGd
        y0qmxBrAdg4FQ0stWO+jZ6UdYXhWHd8=
Date:   Sun, 17 Oct 2021 18:18:05 +0200
From:   David Heidelberg <david@ixit.cz>
Subject: Re: [PATCH v3] dt-bindings: net: nfc: nxp,pn544: Convert txt bindings
 to yaml
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Rob Herring <robh@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, ~okias/devicetree@lists.sr.ht
Message-Id: <5MQ41R.3H1Q29VJH3GC3@ixit.cz>
In-Reply-To: <1a315cff-fa34-0fac-8312-9a96d56966c7@canonical.com>
References: <20211009161941.41634-1-david@ixit.cz>
        <1633894316.431235.3158667.nullmailer@robh.at.kernel.org>
        <1a315cff-fa34-0fac-8312-9a96d56966c7@canonical.com>
X-Mailer: geary/40.0
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Sun, Oct 10 2021 at 23:01:24 +0200, Krzysztof Kozlowski 
<krzysztof.kozlowski@canonical.com> wrote:
> On 10/10/2021 21:31, Rob Herring wrote:
>>  On Sat, 09 Oct 2021 18:19:42 +0200, David Heidelberg wrote:
>>>  Convert bindings for NXP PN544 NFC driver to YAML syntax.
>>> 
>>>  Signed-off-by: David Heidelberg <david@ixit.cz>
>>>  ---
>>>  v2
>>>   - Krzysztof is a maintainer
>>>   - pintctrl dropped
>>>   - 4 space indent for example
>>>   - nfc node name
>>>  v3
>>>   - remove whole pinctrl
>>>   .../bindings/net/nfc/nxp,pn544.yaml           | 61 
>>> +++++++++++++++++++
>>>   .../devicetree/bindings/net/nfc/pn544.txt     | 33 ----------
>>>   2 files changed, 61 insertions(+), 33 deletions(-)
>>>   create mode 100644 
>>> Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml
>>>   delete mode 100644 
>>> Documentation/devicetree/bindings/net/nfc/pn544.txt
>>> 
>> 
>>  Running 'make dtbs_check' with the schema in this patch gives the
>>  following warnings. Consider if they are expected or the schema is
>>  incorrect. These may not be new warnings.
>> 
>>  Note that it is not yet a requirement to have 0 warnings for 
>> dtbs_check.
>>  This will change in the future.
>> 
>>  Full log is available here: 
>> https://patchwork.ozlabs.org/patch/1538804
>> 
>> 
>>  pn547@28: 'clock-frequency' is a required property
>>  	arch/arm64/boot/dts/qcom/msm8992-msft-lumia-octagon-talkman.dt.yaml
>>  	arch/arm64/boot/dts/qcom/msm8994-msft-lumia-octagon-cityman.dt.yaml
>> 
> 
> I think clock-frequency should be dropped from I2C slave device.
> Similarly to this one:
> https://lore.kernel.org/linux-nfc/f955726a-eb2d-7b3e-9c5f-978358710eb6@canonical.com/T/#u
> 
You have right, it isn't parsed by driver and values match parent i2c 
bus. I dropped it in next revision.

David

> 
> Best regards,
> Krzysztof


