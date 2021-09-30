Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2849641E48F
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 01:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349141AbhI3XG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 19:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345470AbhI3XG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 19:06:27 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14EC4C06176A;
        Thu, 30 Sep 2021 16:04:44 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id u7so6282162pfg.13;
        Thu, 30 Sep 2021 16:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aUdRJqN7Q8Md0WLihot4c+nT71azCPqR01b/CTAu2es=;
        b=EoX/Af0qQrI5JjOIGgcosWADNp06+Zxy8UTiqJp/KCtfoY6Eps16HylPPQf+j5xApl
         k534ELCGLXmfZWhsAUvFam1aXHX4uehJU2DvmYI12z1+sKmvEFHNY66wRq2ID6tqWtvD
         Ag9lyQbJIMAy4Vsfpa3cwuAAaXJi1MVtXjgiVkxLFQHZ7ka23lWgxHGpPFxbv889bAYJ
         n8zxRwHKKY8qwcohQE7RRE/OgEJyT6ZvIPFeltjfOisdKE0Kv0SXs7cIUrGhWOMuNXVJ
         QBIcmxiVDVj1MI7SHn4DZWkofpqUC1JuTTa3fXsGQQv/eSY3ZPdGdU8wlo6N+hCpkadf
         HhJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aUdRJqN7Q8Md0WLihot4c+nT71azCPqR01b/CTAu2es=;
        b=ymcEqa4HoXItg428/8vOQUn5jzybLaAdHAxKJEGuylsY8onkwXRuFbYM4f8ySyq5LC
         iKkwJ6lb1BxfH7udxAhyGee9dE+O6bARMRaK38Qpfhqs7leSYucFC52YPTU9iZFeyWIn
         AOgmN7XuBnaX2SHRxR5dWdhng/kzb99ZWH4Zgj/ctRNBznw9mr0s68IA4qgihwrt9kja
         s0iGvWmFKie6PqfnAszArdbF384We0ZuaF+kYvXlznVajsu9fDufUd9TYTXcIemKcZZT
         O1ofOKxv5z5nmBSYQihVYeeBwBbKcBagyI0XqBwJTjdK6EqxZJb4ZNbXY8Q0oWuCbtEe
         EzSg==
X-Gm-Message-State: AOAM532Wb5XTAjhWfsfye1pheOlFUPAyVJlj+yGIM+qcp2LMH5yubSKq
        dVtRrgyFAN2aHQVkn4QiZlVcxxZNIkQ=
X-Google-Smtp-Source: ABdhPJwzXaInJPCsyL+QovMoEB2pENaTd2orUuJTQf7uhEeBi03Qw2Gjf88gJHgIja+f2XcRgRcDNg==
X-Received: by 2002:a65:580d:: with SMTP id g13mr6961278pgr.233.1633043083452;
        Thu, 30 Sep 2021 16:04:43 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ep6sm1095809pjb.34.2021.09.30.16.04.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 16:04:42 -0700 (PDT)
Subject: Re: [PATCH net-next] net: bgmac: support MDIO described in DT
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210920123441.9088-1-zajec5@gmail.com>
 <168e00d3-f335-4e62-341f-224e79a08558@gmail.com>
 <79c91b0e-7f6a-ef40-9ab2-ee8212bf5791@gmail.com>
 <780a6e7f-655a-6d79-d086-2eefd7e9ccb6@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c687a7b4-24eb-f088-d6d0-f167a8f9da1f@gmail.com>
Date:   Thu, 30 Sep 2021 16:04:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <780a6e7f-655a-6d79-d086-2eefd7e9ccb6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/21 7:29 AM, Rafał Miłecki wrote:
> On 20.09.2021 19:57, Rafał Miłecki wrote:
>> On 20.09.2021 18:11, Florian Fainelli wrote:
>>> I believe this leaks np and the use case is not exactly clear to me
>>> here. AFAICT the Northstar SoCs have two MDIO controllers: one for
>>> internal PHYs and one for external PHYs which how you would attach a
>>> switch to the chip (in chipcommonA). Is 53573 somewhat different here?
>>> What is the MDIO bus driver that is being used?
>>
>> of_get_child_by_name() doesn't seem to increase refcount or anything and
>> I think it's how most drivers handle it. I don't think it should leak.
>>
>> BCM53573 is a built with some older blocks. Please check:
>>
>> 4ebd50472899 ("ARM: BCM53573: Initial support for Broadcom BCM53573
>> SoCs")
>>      BCM53573 series is a new family with embedded wireless. By marketing
>>      people it's sometimes called Northstar but it uses different CPU
>> and has
>>      different architecture so we need a new symbol for it.
>>      Fortunately it shares some peripherals with other iProc based
>> SoCs so we
>>      will be able to reuse some drivers/bindings.
>>
>> e90d2d51c412 ("ARM: BCM5301X: Add basic dts for BCM53573 based Tenda
>> AC9")
>>      BCM53573 seems to be low priced alternative for Northstar
>> chipsts. It
>>      uses single core Cortex-A7 and doesn't have SDU or local (TWD)
>> timer. It
>>      was also stripped out of independent SPI controller and 2 GMACs.
>>
>> Northstar uses SRAB which is some memory based (0x18007000) access to
>> switch register space.
>> BCM53573 uses different blocks & mappings and it doesn't include SRAB at
>> 0x18007000. Accessing switch registers is handled over MDIO.
> 
> Florian: did my explanations help reviewing this patch? Would you ack it
> now?

Thanks for providing the background.

You still appear to be needing an of_node_put() after
of_mdiobus_register() because that function does increase the reference
count.
-- 
Florian
