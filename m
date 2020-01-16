Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 874D713D0DB
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 01:01:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731307AbgAPABo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 19:01:44 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38982 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729842AbgAPABo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 19:01:44 -0500
Received: by mail-ed1-f67.google.com with SMTP id t17so17236743eds.6;
        Wed, 15 Jan 2020 16:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XqhItCK7V6ulpvs5WUncRacwZYB1LPdnQtijs/bMn2Q=;
        b=Z7f1N/pyEC2CGQL9PUzmy+GrTyzupUQ7ccHpNYIGRIdij0nyYlh+k/YdptjJUH/8dS
         YuxLOqFqgDnYfO0bNYkA7T0GQCE78Y0kSz9XpgOkYJ/qJojJWiOHOUAV1q38fLo8sWfh
         /0brxwp1zfEdE7LEOtV1Ioxifdz4RIHdBFbgRM6FuKNpQW80wy27UtjCsXDnCrRjqkc8
         IHu3sNwfiL+Cjz5LxiET8yHDVEWfM5qhUPri4MFyGK2vnBH5r6mSOcVoB1qlH8n6p7G1
         U4yy31B8bB3o/Y440znMZ6fVwC7S0uAlPtcYqOiRSgBdhwOnK4XpuixfNVC9wo3977kR
         nblQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=XqhItCK7V6ulpvs5WUncRacwZYB1LPdnQtijs/bMn2Q=;
        b=RxWWSH6lstFFxnMGGYkY8+rfmSg/ftBHAHu7mbwbqovHB8RLUwP5i2mAS5M8vu0l3h
         p6tvVItwBn+iFjIDJouuPCZ4/UfMkcEK0t4hRkgSkgs0bgPmGs2FaYz4Tv0QjsB0RNxX
         rgFx9T8Q4l143Ic6lNci7jP/4/vYUzKaXix+NZkkPtSOmhwiOfdTi1c/0VTPvnEgw1ts
         yC6ZP/UFSfegqVmPeMnFzFiHO3dx9XWAyNp9p5a+iXLeQjj+Z4f0mQU32/tIO0tdD1t9
         zthEBBS7b5+/CCjxYYE0axXccBp4yCMkZcw0GqD/EIs2fWxk6tyRXKC/XAHgNdZ8gXgO
         GGWQ==
X-Gm-Message-State: APjAAAVjooXFhVpcPDIq2iCSYH+unTPvJ6HNBgvkdx6Lcs7q98eIaVTw
        ycgozyS1sHFOqXvpbB2MlF6pezyC
X-Google-Smtp-Source: APXvYqzxxCaSA4hiMVr8abSwM17KDCRJKG4HOyzkytakjRYlEw6UZ7q8kUWm1Mi2ULR+0BsW2aHZrQ==
X-Received: by 2002:a17:906:2596:: with SMTP id m22mr3110ejb.167.1579132901424;
        Wed, 15 Jan 2020 16:01:41 -0800 (PST)
Received: from [10.67.50.41] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w10sm815624eds.69.2020.01.15.16.01.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 16:01:40 -0800 (PST)
Subject: Re: [PATCH net-next v2] net: phy: Maintain MDIO device and bus
 statistics
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, cphealy@gmail.com,
        rmk+kernel@armlinux.org.uk, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        open list <linux-kernel@vger.kernel.org>
References: <20200115204228.26094-1-f.fainelli@gmail.com>
 <20200115235357.GG2475@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <218cae70-3137-39f5-afb4-0e745b8500b9@gmail.com>
Date:   Wed, 15 Jan 2020 16:01:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200115235357.GG2475@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 1/15/20 3:53 PM, Andrew Lunn wrote:
>> +#define MDIO_BUS_STATS_ADDR_ATTR(field, addr, file)			\
>> +static ssize_t mdio_bus_##field##_##addr##_show(struct device *dev,	\
>> +						struct device_attribute *attr, \
>> +						char *buf)		\
>> +{									\
>> +	struct mii_bus *bus = to_mii_bus(dev);				\
>> +	return mdio_bus_stats_##field##_show(&bus->stats[addr], buf);	\
>> +}									\
> 
> Hi Florian
> 
> Lots of Macro magic here. But it is reasonably understandable.
> However, the compiler is maybe not doing the best of jobs:
> 
> 00000064 l     F .text	00000030 mdio_bus_reads_31_show
> 00000094 l     F .text	00000030 mdio_bus_reads_30_show
> 000000c4 l     F .text	00000030 mdio_bus_reads_29_show
> 000000f4 l     F .text	00000030 mdio_bus_reads_28_show
> 00000124 l     F .text	00000030 mdio_bus_reads_27_show
> 00000154 l     F .text	00000030 mdio_bus_reads_26_show
> 00000184 l     F .text	00000030 mdio_bus_reads_25_show
> 000001b4 l     F .text	00000034 mdio_bus_reads_24_show
> 000001e8 l     F .text	00000034 mdio_bus_reads_23_show
> 0000021c l     F .text	00000034 mdio_bus_reads_22_show
> 00000250 l     F .text	00000034 mdio_bus_reads_21_show
> 00000284 l     F .text	00000034 mdio_bus_reads_20_show
> 000002b8 l     F .text	00000034 mdio_bus_reads_19_show
> 000002ec l     F .text	00000034 mdio_bus_reads_18_show
> 00000320 l     F .text	00000034 mdio_bus_reads_17_show
> 00000354 l     F .text	00000034 mdio_bus_reads_16_show
> 00000388 l     F .text	00000034 mdio_bus_reads_15_show
> 000003bc l     F .text	00000034 mdio_bus_reads_14_show
> 000003f0 l     F .text	00000034 mdio_bus_reads_13_show
> 00000424 l     F .text	00000034 mdio_bus_reads_12_show
> 00000458 l     F .text	00000034 mdio_bus_reads_11_show
> 0000048c l     F .text	00000034 mdio_bus_reads_10_show
> 000004c0 l     F .text	00000034 mdio_bus_reads_9_show
> 000004f4 l     F .text	00000034 mdio_bus_reads_8_show
> 00000528 l     F .text	00000034 mdio_bus_reads_7_show
> 0000055c l     F .text	00000034 mdio_bus_reads_6_show
> 00000590 l     F .text	00000034 mdio_bus_reads_5_show
> 000005c4 l     F .text	00000034 mdio_bus_reads_4_show
> 000005f8 l     F .text	00000034 mdio_bus_reads_3_show
> 0000062c l     F .text	00000034 mdio_bus_reads_2_show
> 00000660 l     F .text	00000034 mdio_bus_reads_1_show
> 00000694 l     F .text	00000034 mdio_bus_reads_0_show
> 
> It appears to be inlining everything, so end up with lots of
> functions, and they are not tiny.
> 
> I'm wondering if we can get ride of this per address
> reads/write/transfer function. Could you stuff the addr into var of
> struct dev_ext_attribute?

That is a great suggestion, thanks! This should reduce the number of
those _show functions, expect v3 soon.
-- 
Florian
