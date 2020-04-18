Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1526F1AF50E
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 23:07:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728134AbgDRVHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 17:07:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgDRVHa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 17:07:30 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9EFC061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:07:30 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id nu11so2707120pjb.1
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+jcXILCwbFeeKJcwb4IZAN7BkSQSrArqH03+JgMsLSw=;
        b=ftwPxoD3kbarVm6Ea6m7SbgurKXbZexsw/vxhq8fruZSJD7c2DkhCcpXFiaEvywlTf
         7j4pyDh7tQcBtTf1sy2v+pBaPeN/pyICKLV06xCHf+DbZlpi0c9X+6kkYNTtsvh+zbZ8
         RSSvRwOyV4AYy7SGT5RDWe2nJo7YJO11e0R+0ggDfEAh9maXTvOSuC35fohYwLM7Exss
         HjKxwgND5xE+r/lY2kj3gMXmF5ds+sWHQ8rgJkxcaqm1gz9J53k5uZ4KXFOT/jAhnwRb
         BmR7euwEiJfbN+pbjYCiomqz4rfQstffJLYWOucicrDy+H6CsfKkLnsC2I5BJuw/e7Iq
         bupw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+jcXILCwbFeeKJcwb4IZAN7BkSQSrArqH03+JgMsLSw=;
        b=cOkcJVQIvs2zJVuibTd1IEPAyT48ZMmymn7dVyBu+VL4ysDC/iTjwlmLROSivioKtn
         MifFBhnc/y2NSLkBeZPIrVSWPL/7pan4GVZVoM83omAXyOcT+iYoX7Rx0ZF63LGHM+pB
         8PGlsGcCCFVGMhff63KXoM0ZNrnSZcAHQlYWU7i3jBQh5l7lmoAv6H+uciXF8dJziDUo
         /JQY1MBqhRh+zlKqkwjvk7pgwvweL/cqB2L0yOyyvxTwKfT+cQlsND+5Ijjw+NR2fSeK
         26iSzOzu0xW8jbZNYGKOtpnS2xqOZKLxeUMCLYmrglhwAmbneFc5au7ZuXmzC8L77YSw
         YVDg==
X-Gm-Message-State: AGi0PuZ7Qg2s4WsvjawObUgLwv6S9Jf96c6B626XOowAZlRz1NNZ/Aps
        zIP5hDIDfTdeRYxO+POCMNk=
X-Google-Smtp-Source: APiQypJPgENk5MKubokl0e4z+7Uxl2P5M8u77276CCI5gxaH8cVh9tGOnbhhMkU+QUeLNGbZu0E/+g==
X-Received: by 2002:a17:90a:f197:: with SMTP id bv23mr12089042pjb.3.1587244050050;
        Sat, 18 Apr 2020 14:07:30 -0700 (PDT)
Received: from [10.230.188.26] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j4sm18944045pfa.214.2020.04.18.14.07.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 14:07:29 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/3] net: ethernet: fec: Allow configuration
 of MDIO bus speed
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, fugang.duan@nxp.com,
        Chris Healy <Chris.Healy@zii.aero>
References: <20200418000355.804617-1-andrew@lunn.ch>
 <20200418000355.804617-3-andrew@lunn.ch>
 <3cb32a99-c684-03fd-c471-1d061ca97d4b@gmail.com>
 <20200418142336.GB804711@lunn.ch>
 <b6b6c42b-aa2d-8036-958e-4f9929752536@gmail.com>
 <20200418164902.GK804711@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a0b9a840-aea3-ab23-1d0d-5b5c33aa1fe2@gmail.com>
Date:   Sat, 18 Apr 2020 14:07:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200418164902.GK804711@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/18/2020 9:49 AM, Andrew Lunn wrote:
>>> I don't see how that would work. Each device on the bus needs to be
>>> able to receiver the transaction in order to decode the device
>>> address, and then either discard it, or act on it. So the same as I2C
>>> where the device address is part of the transaction. You need the bus
>>> to run as fast as the slowest device on the bus. So a bus property is
>>> the simplest. You could have per device properties, and during the bus
>>> scan, figure out what the slowest device is, but that seems to add
>>> complexity for no real gain. I2C does not have this either.
>>>
>>> If MDIO was more like SPI, with per device chip select lines, then a
>>> per device frequency would make sense.
>>
>> OK, that is a good point, but then again, just like patch #3 you need to
>> ensure that you are setting a MDIO bus controller frequency that is the
>> lowest common denominator of all MDIO slaves on the bus, which means that
>> you need to know about what devices do support.
> 
> Hi Florian
> 
> I've been following what I2C does, since MDIO and I2C is very similar.
> I2C has none of what you are asking for. If I2C does not need any of
> this, does MDIO? I2C assumes what whoever writes the DT knows what
> they are doing and will set a valid clock frequency which works for
> all devices on the bus. This seems to work for I2C, so why should it
> not work for MDIO?
> 
> My preference is KISS.

OK, you have convinced me.
-- 
Florian
