Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 206AA246DD7
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 19:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389563AbgHQRPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 13:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389552AbgHQRPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 13:15:12 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30978C061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 10:15:12 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id p24so18605932ejf.13
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 10:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m0louAs209E+viMkPXsjOrvTJteMYbc7vLeOipsYyCY=;
        b=D4+SCqsfm1z28hXq9eRjLAxOCApG9yyE8ImhuPLCL7Qp7uhZTxbwJ10U0X19cVqisY
         eIbWTChGFLWfVy0EoB3TkuQ+h3c1rnAV5QPtxf+vNiW+Ltnj6kzCg/xZmYnmatDcNcfO
         0lUYZnQq1S1lF5lMMwl2e8MLzToUs2CKl7dUkc7TphkaGh8cNI2sq/wuB1SQYfjW3Fao
         gqWy7AD5WKY625xSBGrKDf3athwuVRoyZl/e+h6PmgAzonwSkxXVbnnrqrhCQO2y4nGP
         IO8PjIGMWpN8IfAGT7ih62pfWAzdBK7oMXQfMngIq34Wu+Vhy4657MpODgFcX8/IHdAd
         4FrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=m0louAs209E+viMkPXsjOrvTJteMYbc7vLeOipsYyCY=;
        b=oCg58hPiGLyNjni7DYt0q0w+jqchlzyQiytrM8Qo88k3p911CbDXXpvdqpjuzqa0Qj
         Q4YWeeBkRqeWwBsM3OUuDVPSce94ebHxDUDCgmVxzvYNSeAM4Hqfv94vesRhaMS6R2Hs
         5w/OYB2QhaTQ+ewXxk1v1OeaGFQ1pdOXd+zKIwC5ktJLN/Y5MhUXXMXQfadNapfxZeGk
         GsHP0w0hfO4zjzod7jq6Z2WCQWaivew0rXtiKjQKNjjwB1el+4Wx3/bedkzDjyilPQ6Q
         s73dOrXEzyyukWdrGDAVVf0aNjSF9OlqYel+UzLJBbAGU8Omt4yavPO4wGBj2z00grvA
         tONQ==
X-Gm-Message-State: AOAM533Crz2NxEHqPYKjApP6YEHg7u2rXrP689yrBsaH8ha9uc5FrPry
        Xv86k4/8iBsOHtv+s4k5EwK+aFX7zDE=
X-Google-Smtp-Source: ABdhPJyjyrEGO47VGjqO9fceakNdpM/3P8hEBUdiTnU7U9nznSfH64FG1SlKDokSXFEvc5krOMMo+Q==
X-Received: by 2002:a17:906:c8d2:: with SMTP id gc18mr17200792ejb.24.1597684510861;
        Mon, 17 Aug 2020 10:15:10 -0700 (PDT)
Received: from [10.67.50.75] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i9sm14616011ejb.48.2020.08.17.10.15.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2020 10:15:10 -0700 (PDT)
Subject: Re: [PATCH net-next 5/7] net: dsa: mv88e6xxx: Add devlink regions
To:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20200816194316.2291489-1-andrew@lunn.ch>
 <20200816194316.2291489-6-andrew@lunn.ch>
 <20200816221205.mspo63dohn7pvxg4@skbuf> <20200816223941.GC2294711@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <93a2b736-ff45-4529-c63a-b384db12b232@gmail.com>
Date:   Mon, 17 Aug 2020 10:15:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200816223941.GC2294711@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/16/20 3:39 PM, Andrew Lunn wrote:
>>> +static const struct devlink_region_ops *mv88e6xxx_region_port_ops[] = {
>>> +	&mv88e6xxx_region_port_0_ops,
>>> +	&mv88e6xxx_region_port_1_ops,
>>> +	&mv88e6xxx_region_port_2_ops,
>>> +	&mv88e6xxx_region_port_3_ops,
>>> +	&mv88e6xxx_region_port_4_ops,
>>> +	&mv88e6xxx_region_port_5_ops,
>>> +	&mv88e6xxx_region_port_6_ops,
>>> +	&mv88e6xxx_region_port_7_ops,
>>> +	&mv88e6xxx_region_port_8_ops,
>>> +	&mv88e6xxx_region_port_9_ops,
>>> +	&mv88e6xxx_region_port_10_ops,
>>> +	&mv88e6xxx_region_port_11_ops,
>>> +};
>>> +
>>
>> Sounds like there should maybe be an abstraction for 'per-port regions' in
>> devlink? I think your approach hardly scales if you start having
>> switches with more than 11 ports.
> 
> mv88e6xxx is unlikely to have more an 11 ports. Marvell had to move
> bits around in registers in non-compatible ways to support the 6390
> family with this number of ports. I doubt we will ever see a 16 port
> mv88e6xxx switch, the registers are just too congested.

Any number greater than 1 could justify finding a solution that scales.

> 
> So this scales as far as it needs to scale.
> 
>>> +/* The ATU entry varies between chipset generations. Define a generic
>>> + * format which covers all the current and hopefully future
>>> + * generations
>>> + */
>>
>> Could you please present this generic format to us? Maybe my interpretation of
>> the word "generic" is incorrect in this context?
> 
> I mean generic across all mv88e6xxx switches. The fid has been slowly
> getting bigger from generation to generation. If i remember correctly,
> it start off as 6 bits. 2 more bits we added, in a different
> register. Then it got moved into a new register and made 14 bits in
> size. There are also some bits in the atu_op register which changed
> meaning over time.
> 
> In order to decode any of this information in the regions, you need to
> known the specific switch the dump came from. But that is the whole
> point of regions.
> 
> https://www.kernel.org/doc/html/latest/networking/devlink/devlink-region.html
> 
>    As regions are likely very device or driver specific, no generic
>    regions are defined. See the driver-specific documentation files
>    for information on the specific regions a driver supports.
> 
> This should also make the context of 'generic' more clear.

Looking at the documentation above (assuming it is up to date), these
are raw hex dumps of the region, which is mildly useful.

If we were to pretty print those regions such that they can fully
replace the infamous debugfs interface patch from Vivien that has been
floated around before, what other information is available (besides the
driver name) for the user-space tools to do that pretty printing?

Right now, as with any single user facility it is a bit difficult to
determine whether a DSA common representation would be warranted.
-- 
Florian
