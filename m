Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE03224546
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 22:40:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728511AbgGQUjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 16:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728202AbgGQUjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 16:39:53 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21C1C0619D2;
        Fri, 17 Jul 2020 13:39:52 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id o8so16654556wmh.4;
        Fri, 17 Jul 2020 13:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IXs/e+IKfCKZYm+1L55kbcN352SX30fVz7ZsKTgLIqA=;
        b=IOBbkr8s1Tap6+EcIv6TveMxOtoOB0UObaA7D8Pl0QEabLTK23xmX80URa5eh9Tv44
         ukMZMh7GfXX8n3LQ1nXnv0x4txYCb1kF7u/TO+7p2CJSjvJFoA18pWYNypQwtFogzOBf
         eWeLYqEY8ypiHKz2LrfH/u9AhqMrO/C7L80YeFyWCr7XvIlHQ8aK4YfIcuQfHwM5iOxs
         cH0JQwGiIEZfdhGYIb3rVcg66Z0gwy2VqgOkq5O3/ls3Kp+dj2NETAfEUJe33nnhWt31
         Oa5hrtsE/F6ETc4xkP8MPzNHWUAzlFSjjzAHOjHck2vkHjyVSa/dDRvNFbh2v0yu8ucJ
         hlKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IXs/e+IKfCKZYm+1L55kbcN352SX30fVz7ZsKTgLIqA=;
        b=TDXpRLmJMYr3MSgZW/6uoCMdJHuCc95PCB09cDRLZxMlbM5GVS9VwQudwkP7WcH8D+
         I6mM794ugHl/FT2LRz9VgB52vBKEkuF8FDhN/nzxhH51crf3VbLlLe5bxBX0KR4ScSJE
         qFYWDoFOEQOUFcZPfxc6gA3gpEKm95eDRdhO5SFcXxNYgMXSvadeoB0Baf4Pm9HGdBcJ
         /NzdlnBnLSgYNuXCfRo1OAoTul5iYtGil+XG/0o57UnzEHUP7mYuKuvdo55wQHN0T/8R
         RG99ciWikHWuLYwOatYQAfRjNNBIrBFZqy+FOH/yPL+XGR6DUV1P7DFMz0iRaz5+lLvN
         tbGg==
X-Gm-Message-State: AOAM532e436fRZxjLKDIAFH9IYp7rN9OEauulxb7j3g3bT/6W/c8V+ve
        C6Xwtvu8wan+/AjOoScWhxaV8+9t
X-Google-Smtp-Source: ABdhPJyQ+VbylVikYdvSPK0ICyJDW93rbVaEdR7v9UhPeMr6bGMjgOTX1SbPO5zy0KboNSOZnh49Ug==
X-Received: by 2002:a05:600c:2317:: with SMTP id 23mr11287327wmo.72.1595018391143;
        Fri, 17 Jul 2020 13:39:51 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c188sm4068569wma.22.2020.07.17.13.39.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2020 13:39:50 -0700 (PDT)
Subject: Re: [PATCH 2/2] dt-bindings: net: dsa: qca8k: Add PORT0_PAD_CTRL
 properties
To:     Matthew Hagan <mnhagan88@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        John Crispin <john@phrozen.org>,
        Jonathan McDowell <noodles@earth.li>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
References: <2e1776f997441792a44cd35a16f1e69f848816ce.1594668793.git.mnhagan88@gmail.com>
 <ea0a35ed686e6dace77e25cb70a8f39fdd1ea8ad.1594668793.git.mnhagan88@gmail.com>
 <20200716150925.0f3e01b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ac7f5f39-9f83-64c0-d8d5-9ea059619f67@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b16a6e8d-0799-388c-b98c-fe6e14611d9f@gmail.com>
Date:   Fri, 17 Jul 2020 13:39:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <ac7f5f39-9f83-64c0-d8d5-9ea059619f67@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/17/2020 1:29 PM, Matthew Hagan wrote:
> 
> 
> On 16/07/2020 23:09, Jakub Kicinski wrote:
>> On Mon, 13 Jul 2020 21:50:26 +0100 Matthew Hagan wrote:
>>> Add names and decriptions of additional PORT0_PAD_CTRL properties.
>>>
>>> Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
>>> ---
>>>  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 8 ++++++++
>>>  1 file changed, 8 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
>>> index ccbc6d89325d..3d34c4f2e891 100644
>>> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
>>> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
>>> @@ -13,6 +13,14 @@ Optional properties:
>>>  
>>>  - reset-gpios: GPIO to be used to reset the whole device
>>>  
>>> +Optional MAC configuration properties:
>>> +
>>> +- qca,exchange-mac0-mac6:	If present, internally swaps MAC0 and MAC6.
>>
>> Perhaps we can say a little more here?
>>
> From John's patch:
> "The switch allows us to swap the internal wirering of the two cpu ports.
> For the HW offloading to work the ethernet MAC conencting to the LAN
> ports must be wired to cpu port 0. There is HW in the wild that does not
> fulfill this requirement. On these boards we need to swap the cpu ports."
> 
> This option is somewhat linked to instances where both MAC0 and MAC6 are
> used as CPU ports. I may omit this for now since support for this hasn't
> been added and MAC0 is hard-coded as the CPU port. The initial intention
> here was to cover options commonly set by OpenWrt devices, based upon
> their ar8327-initvals, to allow migration to qca8k.

If you update the description of the property, I do not see a reason why
this should not be supported as of today, sooner or later you will need
it to convert more devices to qca8k as you say.
-- 
Florian
