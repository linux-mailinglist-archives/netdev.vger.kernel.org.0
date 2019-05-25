Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2458C2A3A5
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 11:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726582AbfEYJOW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 May 2019 05:14:22 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:34892 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726432AbfEYJOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 May 2019 05:14:22 -0400
Received: by mail-lf1-f65.google.com with SMTP id c17so8815471lfi.2
        for <netdev@vger.kernel.org>; Sat, 25 May 2019 02:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JU8FrK/hIidk6y4ugFnwoOuI36C15q+xqTnfhupBW6U=;
        b=c36wgbPDjudenP1NTvfE2dwS7JpkWmrWK9F/NukdiGteCy47rL8UtZ/sjGp0IOttnf
         wGTVSnzcuhpxL1IuF82CN85hxPx8l5cGDSVp+vldvO+G1Q4A7HBePTViwsk0RdY4k3l/
         dLmQ2mpMgGOoqkiGefJ3C3ACmZ3kLcYryWCzY6mpNRB1q88BwkgvOuT0z2RoZCOIWIiH
         aR1ikf/oQcvVuNbx1HG0puFqshbHOCtTi9xwRHoT6CuGJPDDMTUKcxAyste/qkYnCjWV
         wjN+wOqtFD2rgaq6A5tJxAmiyJOv5/hTWzW9yUzKSBQCIadTLsN3dRCfyLgltpv/JOkM
         H6CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JU8FrK/hIidk6y4ugFnwoOuI36C15q+xqTnfhupBW6U=;
        b=L2ytFB2dJlmFQR/uoVPlmOCFqPFV+r8tS05YsaJzPqyn9fbA0miTBA6TEvPuqwgIGM
         dnnzxWmqJv182NYbwGe61sp0EIxjLbgkDtj9nH+srVP/CNA6WShDFW3XzmbNkBrLYh1X
         t1/4HaIrCSr3G3EcgxymkVJWjBKzv/Rf4VisMCYQU8UI92aObsMczg+0emJRIP32vcRy
         ZOLpxzKn+gVt9QFDk1o3PXEhao079+T2G9WDNzfOYU5IDmBjsV0XHChj4MTVHmApRdbc
         pCdKaJBb88gBZS/DGoXB1B+bzh0FRaZEdTcds79Ofa/RjsV1bssUShUJKiDA9METPj6V
         XT7A==
X-Gm-Message-State: APjAAAUaiRmN28c5m4wvrdBv72kRcsrNJkovk9xyjf6ENQb+NjpbhaU4
        ZAkj8aKwA5DDZNx3Etov0gHtKD0YGXA=
X-Google-Smtp-Source: APXvYqzf1Cc1PH0WXJCwHr5mYGKdTBKHUjwRQG3GeJqkQfxAmAE6mJeki685p7eGZJ6FXhdsptArNg==
X-Received: by 2002:ac2:4312:: with SMTP id l18mr41170812lfh.139.1558775660390;
        Sat, 25 May 2019 02:14:20 -0700 (PDT)
Received: from [192.168.0.199] ([31.173.80.128])
        by smtp.gmail.com with ESMTPSA id g15sm955204ljk.83.2019.05.25.02.14.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 25 May 2019 02:14:19 -0700 (PDT)
Subject: Re: [PATCH 4/8] ARM/net: ixp4xx: Pass ethernet physical base as
 resource
To:     Andrew Lunn <andrew@lunn.ch>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Krzysztof Halasa <khalasa@piap.pl>
References: <20190524162023.9115-1-linus.walleij@linaro.org>
 <20190524162023.9115-5-linus.walleij@linaro.org>
 <20190524200012.GP21208@lunn.ch>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <da114d45-5649-b525-039a-470f45d50386@cogentembedded.com>
Date:   Sat, 25 May 2019 12:14:04 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190524200012.GP21208@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 24.05.2019 23:00, Andrew Lunn wrote:

>> In order to probe this ethernet interface from the device tree
>> all physical MMIO regions must be passed as resources. Begin
>> this rewrite by first passing the port base address as a
>> resource for all platforms using this driver, remap it in
>> the driver and avoid using any reference of the statically
>> mapped virtual address in the driver.
>>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>> ---
>>   arch/arm/mach-ixp4xx/fsg-setup.c         | 20 ++++++++++++++++++++
>>   arch/arm/mach-ixp4xx/goramo_mlr.c        | 20 ++++++++++++++++++++
>>   arch/arm/mach-ixp4xx/ixdp425-setup.c     | 20 ++++++++++++++++++++
>>   arch/arm/mach-ixp4xx/nas100d-setup.c     | 10 ++++++++++
>>   arch/arm/mach-ixp4xx/nslu2-setup.c       | 10 ++++++++++
>>   arch/arm/mach-ixp4xx/omixp-setup.c       | 20 ++++++++++++++++++++
>>   arch/arm/mach-ixp4xx/vulcan-setup.c      | 20 ++++++++++++++++++++
>>   drivers/net/ethernet/xscale/ixp4xx_eth.c | 20 +++++++++++---------
>>   8 files changed, 131 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/arm/mach-ixp4xx/fsg-setup.c b/arch/arm/mach-ixp4xx/fsg-setup.c
>> index 648932d8d7a8..507ee3878769 100644
>> --- a/arch/arm/mach-ixp4xx/fsg-setup.c
>> +++ b/arch/arm/mach-ixp4xx/fsg-setup.c
>> @@ -132,6 +132,22 @@ static struct platform_device fsg_leds = {
>>   };
>>   
>>   /* Built-in 10/100 Ethernet MAC interfaces */
>> +static struct resource fsg_eth_npeb_resources[] = {
>> +	{
>> +		.start		= IXP4XX_EthB_BASE_PHYS,
>> +		.end		= IXP4XX_EthB_BASE_PHYS + 0x0fff,
> 
> Hi Linus
> 
> It is a long time since i did resources. But i was always told to use
> the SZ_ macros, so SZ_4K. I also think 0xfff is wrong, it should be
> 0x1000.

    No, 0x0fff is correct there, 0x1000 is not...

> 	Andrew

MBR, Sergei
