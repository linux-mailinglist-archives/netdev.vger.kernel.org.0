Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 673818537C
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 21:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730382AbfHGTSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 15:18:38 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35156 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730363AbfHGTSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 15:18:38 -0400
Received: by mail-wm1-f66.google.com with SMTP id l2so8914wmg.0;
        Wed, 07 Aug 2019 12:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=dq3DdDTvPFuZUDp0cjn4nr/nlDjCZ+WE+PuSO4ucy3M=;
        b=PtVNRjJ46TYNpqSF+eVH0bsJRIiG+x3mHhTN66EWRy5IKlUEZlK124J12FKEcBes71
         GBOfHNBoJFxWCwDaet7h3tckXA1VVY7ImUdlavzGZxizbMSKaqdWAyVRAt6Vwc/0sIcm
         i7dWHmQpv3liF69Mscq2lrVWMmxUQxmu3mIPdqa213iQX4MVvlsjGiuut7x1z4FBoO+f
         V9eQ88ddyoCXRSw2oI0CtH5r22w1M0eNBxzR2cG4lZ7UkyY30a5g5dw4jsEXANniiSp0
         yWPfjKpuvMVVNv/H7+Q7mhECIBIwvV3EgdR4Z1YUbTN8yVQDHxq8iVWHHACpeBPF/9rI
         kGmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dq3DdDTvPFuZUDp0cjn4nr/nlDjCZ+WE+PuSO4ucy3M=;
        b=RBZLnkQoz8v0cxXm4Vrj+2dspWyLe4TkhRw0y7rWfZB0mVpVQpkWubYBN1EE8JYNKU
         2zcIWHTKb9iJ6Ejo2uA3FlfaedYj+tfnMduL5MZOnmTV/6LOqsQ+3S5MnTonPL0YKswJ
         GPd9ffAP8hRJBwi1DWRRTdTvkisimO0ObRS07NPjBPpZCXM5mOEcuEHNMf4KJeDzglxg
         fI1/k7aBytourUbxuT9HQb8/W7PuJbroH2+GAnTbkqUKVGS8Uy3liWQGNskqr0q7oyPN
         7ILExxyit83AprDj+ehXIYjmX4PLerCH5SVHwg6Q+agBwsE8V9dc7A1ahD6sVHJQDxZP
         GyJg==
X-Gm-Message-State: APjAAAXQM+1DneHaotRl/Bfv+FizWe0R72mXHkXx88uKX0XcC/J1m8B3
        V1oVlRM+NDU8kDqvkQfCk8s=
X-Google-Smtp-Source: APXvYqxT79/zZlyJ7m/7OQRHIi2Ga4eTnMIdlRq2ogHvMMmVvyxmm6qJqNgK/lITl1w0bLa5rBTqSg==
X-Received: by 2002:a05:600c:1007:: with SMTP id c7mr1187277wmc.161.1565205516123;
        Wed, 07 Aug 2019 12:18:36 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:c422:a07f:e697:f900? (p200300EA8F2F3200C422A07FE697F900.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:c422:a07f:e697:f900])
        by smtp.googlemail.com with ESMTPSA id w24sm548141wmc.30.2019.08.07.12.18.34
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 12:18:35 -0700 (PDT)
Subject: Re: [PATCH net-next v4 2/2] net: phy: broadcom: add 1000Base-X
 support for BCM54616S
To:     Tao Ren <taoren@fb.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
References: <20190806210931.3723590-1-taoren@fb.com>
 <fe0d39ea-91f3-0cac-f13b-3d46ea1748a3@fb.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <cfd6e14e-a447-aedb-5bd6-bf65b4b6f98a@gmail.com>
Date:   Wed, 7 Aug 2019 21:18:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <fe0d39ea-91f3-0cac-f13b-3d46ea1748a3@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06.08.2019 23:42, Tao Ren wrote:
> Hi Andrew / Heiner / Vladimir,
> 
> On 8/6/19 2:09 PM, Tao Ren wrote:
>> The BCM54616S PHY cannot work properly in RGMII->1000Base-KX mode (for
>> example, on Facebook CMM BMC platform), mainly because genphy functions
>> are designed for copper links, and 1000Base-X (clause 37) auto negotiation
>> needs to be handled differently.
>>
>> This patch enables 1000Base-X support for BCM54616S by customizing 3
>> driver callbacks:
>>
>>   - probe: probe callback detects PHY's operation mode based on
>>     INTERF_SEL[1:0] pins and 1000X/100FX selection bit in SerDES 100-FX
>>     Control register.
>>
>>   - config_aneg: bcm54616s_config_aneg_1000bx function is added for auto
>>     negotiation in 1000Base-X mode.
>>
>>   - read_status: BCM54616S and BCM5482 PHY share the same read_status
>>     callback which manually set link speed and duplex mode in 1000Base-X
>>     mode.
>>
>> Signed-off-by: Tao Ren <taoren@fb.com>
> 
> I customized config_aneg function for BCM54616S 1000Base-X mode and link-down issue is also fixed: the patch is tested on Facebook CMM and Minipack BMC and everything looks normal. Please kindly review when you have bandwidth and let me know if you have further suggestions.
> 
> BTW, I would be happy to help if we decide to add a set of genphy functions for clause 37, although that may mean I need more help/guidance from you :-)

You want to have standard clause 37 aneg and this should be generic in phylib.
I hacked together a first version that is compile-tested only:
https://patchwork.ozlabs.org/patch/1143631/
It supports fixed mode too.

It doesn't support half duplex mode because phylib doesn't know 1000BaseX HD yet.
Not sure whether half duplex mode is used at all in reality.

You could test the new core functions in your own config_aneg and read_status
callback implementations.

> 
> 
> Cheers,
> 
> Tao
> 
Heiner
