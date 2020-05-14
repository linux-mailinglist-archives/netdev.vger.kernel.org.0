Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F5A1D383D
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 19:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgENRbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 13:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725975AbgENRbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 13:31:08 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3133DC061A0C;
        Thu, 14 May 2020 10:31:07 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id e16so5339007wra.7;
        Thu, 14 May 2020 10:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jbm1Q8qOMwQUuSc9bppb6Dmdqv2iLCl+uaey6+wjuLA=;
        b=CBSyHBzo3+idV0W5j/UzuaOb571oSX7gRIjsHziTEHZTJzLvXm5UvSkaqlEa9l6otn
         VhmJAnGwa40khADvJdzsxqwhzShrOtg8LTxZdP45OnxMoJKihbob8jf79R2sISJRLhVs
         l7hnX07Ep2A2VHETcFN/ZuSe3IlpgAOulB4KczwUyt7K3sdY6dkjzdFa8FSdSRn++tGt
         R62ouWnAwKmICRNR2fy6TVhVdRmi9yKVV/lVlo0EXfZz1mwdiC2HVNAeHPb1lBXe9EPC
         MUlqEn9q/kEYoPpPqFJ7/sMoUQJ8ebKuuKA5gQXEES4UWwYIEguDZCnlPHnTTvJetPFb
         bhzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jbm1Q8qOMwQUuSc9bppb6Dmdqv2iLCl+uaey6+wjuLA=;
        b=iOXFisr7LdUc/KbGrU2V9iihBQyr9aBUGflz9LxUzk570R4oOa+yxJ2vtScgkDEJe2
         l5OZNjKkJfd7AT3Kik4+aGoJ+ruwY90dL/FJgi/KVPqmunyOaTn1oj3UWVrj/n2WbUw6
         Itwiw2PaSWHiNRAFMCIM3fyZrwQQNy2I+95uo5qmab/59gAstvkp+TUUSxchzWKqcv8z
         GSBm5pM6H9/lyS5jv1Y3bm1t8hh9Cxu2damG/1kqYpBHBzFFxT2Cxs/WoXFzZXb4s3CT
         7PfwBonL/dIefRNh1JSxb/gFIO14jYhSa+irdl0+yua06CUIM0PWlcS+Up9iwBLj4Rdz
         4j6A==
X-Gm-Message-State: AOAM532ouAyu1DZVKfNzVi9Iyb0Q7NYboPiU9UJSOwcyeLDBQHXNQFkt
        VNlKe901xcTB3rKCsRmMDHQ=
X-Google-Smtp-Source: ABdhPJxoW+C6Nkoo2+TRu4kQe6smgRYVIMJOTSp166sZd8TRlyHyMwXBCmkHtlSyHAKdGY1DMi0beQ==
X-Received: by 2002:adf:fe90:: with SMTP id l16mr6569637wrr.222.1589477465916;
        Thu, 14 May 2020 10:31:05 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u127sm41495846wme.8.2020.05.14.10.31.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2020 10:31:05 -0700 (PDT)
Subject: Re: [PATCH] net: phy: mdio-moxart: remove unneeded include
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
References: <20200514165938.21725-1-brgl@bgdev.pl>
 <8fc8ea34-a68c-8fbd-3821-d073c08444f8@gmail.com>
 <CAMRc=Mcp89E7f+PeVfhJ8iXXRZdG9c28_CzCeMpSJj=n5Gwo+w@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <283dd0f5-74d1-d0e6-c521-dbad6da5e446@gmail.com>
Date:   Thu, 14 May 2020 10:31:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAMRc=Mcp89E7f+PeVfhJ8iXXRZdG9c28_CzCeMpSJj=n5Gwo+w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/14/2020 10:20 AM, Bartosz Golaszewski wrote:
> czw., 14 maj 2020 o 19:13 Florian Fainelli <f.fainelli@gmail.com> napisał(a):
>>
>>
>>
>> On 5/14/2020 9:59 AM, Bartosz Golaszewski wrote:
>>> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>>>
>>> mdio-moxart doesn't use regulators in the driver code. We can remove
>>> the regulator include.
>>>
>>> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
>>
>> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
>> --
>> Florian
> 
> Hi Andrew, Florian,
> 
> I noticed this by accident when I was looking at the PHY drivers to
> see how they handle regulators supplying PHYs. In the case of the
> MediaTek Pumpkin board I'm working on - the PHY is a Realtek RTL8201F
> and it's supplied by a regulator that's enabled on boot by the
> relevant PMIC driver. I'd like to model it in the device-tree but I'm
> not sure what the correct approach is. Some ethernet drivers have a
> phy-supply property but it looks wrong to me - IMO this should be
> handled at the PHY driver level. Is it fine if I add a probe()
> callback to the realtek driver and retrieve the "phy-supply" there?

Don't you need to do this earlier than probe() though? If the PHY device
is powered down, then surely get_phy_id() won't be able to read its
registers and bind the device to the driver.

This should be dealt the same way that resets are being dealt with,
which is prior to the MDIO bus scan.
-- 
Florian
