Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8A8A1145EF
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 18:29:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730165AbfLER3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 12:29:14 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38041 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729396AbfLER3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 12:29:14 -0500
Received: by mail-ed1-f67.google.com with SMTP id i6so2241859edr.5;
        Thu, 05 Dec 2019 09:29:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=p2+5NVyqXKni3UfDeqBg+GwKAPXpgjVjW38hhs12SWY=;
        b=mHdD7Vn1QOd1d6aWjbakrN8F9qhWqpoC8BBiao4PcQWdSKO37IBCO3ZAsoRfnw1TYN
         zsSs7Bhp2cmHI9+YmVp0oTcujBefBjaA1JqOXNOJklKtuhbHDEpmi1w2krMJbbqPNKiB
         R1bhhr6X65BNQi9bdvD3Bau7fEloFXlBRkgBZl62u0y89A2Rzl4TG4JWWZXrcuV1fgU6
         LnbOJ2SGvy9HepU3gJA9GQtTyKytVwFLtUM4s1MiHle0EvFpC+IjmxL4bP7IHe6mzUdv
         eDT3p5+v03JYU4IBVd0OCXWoJWDv9/cvo118eVhqA+6H1n/OLQoE5dumN48OFhEjW31S
         Lk2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=p2+5NVyqXKni3UfDeqBg+GwKAPXpgjVjW38hhs12SWY=;
        b=uDKufytY7owWH5JAOPcJGijen72arL+/ZS80P+/dfJ0smT0wYGlVMut7fSa5zUJj50
         y9YhvAwRV6vDU+vhyo1tJpFRLWBRj7mfX7oh9oTF3ZVtlpsqiYSngqZ8CaQfwWc9t1my
         pmtO++IaggCnazQsd/CyekFdndBCp1eN3fwIXf7S3mtZMUe1EBhy0e9WlQhrOmWYfAQO
         R/JLsgjMzm7A15LBaEItOZGcmwWYYYRm1q1Rqf9MD9dijrITzxm4fvcNolG7LbAaYQZV
         By7A2zXvfABoWWnnx4Ahes/9XpIarkcxLg8wOnUrB8rLMKwkSVsizlswjNrGBVAnl6rV
         kMOg==
X-Gm-Message-State: APjAAAXjb8jmSfWblNEAjo6DJyZeVgofnrKMN5uaS2vdT4W1sw2UWnuM
        OiXJWoCGZmbmVFM87oR3nxt56O2E
X-Google-Smtp-Source: APXvYqwOLg2pe5kKujhu85izYU1+p/E71BwUqB27fPtYebrD/QyTSmV1vnoDxJv9eYnrFnco34S64w==
X-Received: by 2002:a17:906:27cb:: with SMTP id k11mr10116720ejc.301.1575566951388;
        Thu, 05 Dec 2019 09:29:11 -0800 (PST)
Received: from [10.67.50.21] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id dj21sm372488edb.55.2019.12.05.09.29.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 09:29:10 -0800 (PST)
Subject: Re: [PATCH] dt-bindings: net: mdio: use non vendor specific
 compatible string in example
To:     Simon Horman <simon.horman@netronome.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
References: <20191127153928.22408-1-grygorii.strashko@ti.com>
 <20191205144837.GA28725@netronome.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <60f445a1-e401-afeb-6b8f-4a16b92b43c8@gmail.com>
Date:   Thu, 5 Dec 2019 09:29:07 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191205144837.GA28725@netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/5/19 6:48 AM, Simon Horman wrote:
> On Wed, Nov 27, 2019 at 05:39:28PM +0200, Grygorii Strashko wrote:
>> Use non vendor specific compatible string in example, otherwise DT YAML
>> schemas validation may trigger warnings specific to TI ti,davinci_mdio
>> and not to the generic MDIO example.
>>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> This seems sensible to me.
> 
> Reviewed-by: Simon Horman <simon.horman@netronome.com>
> 
> Are there any plans to address the errors DT YAML schema validation reports?

Sure, let me try to tackle this weekend.

> 
> $ ARCH=arm make dtbs_check DT_SCHEMA_FILES=Documentation/devicetree/bindings/net/mdio.yaml
> .../linux/arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm4708-asus-rt-ac56u.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm4708-netgear-r6250.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm4708-netgear-r6250.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm4708-linksys-ea6300-v1.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm4708-linksys-ea6300-v1.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm4708-asus-rt-ac68u.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm4708-asus-rt-ac68u.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm4708-linksys-ea6500-v2.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm4708-linksys-ea6500-v2.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm4708-buffalo-wzr-1750dhp.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm4708-buffalo-wzr-1750dhp.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm4708-luxul-xap-1510.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm4708-luxul-xap-1510.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm47081-luxul-xwr-1200.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm47081-luxul-xwr-1200.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm47081-buffalo-wzr-600dhp2.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm47081-buffalo-wzr-600dhp2.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm4708-smartrg-sr400ac.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm4708-smartrg-sr400ac.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm4708-luxul-xwc-1000.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm4708-luxul-xwc-1000.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm4708-netgear-r6300-v2.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm4708-netgear-r6300-v2.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm47081-asus-rt-n18u.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm47081-asus-rt-n18u.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm4709-asus-rt-ac87u.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm4709-asus-rt-ac87u.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm47081-tplink-archer-c5-v2.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm47081-tplink-archer-c5-v2.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm47081-buffalo-wzr-900dhp.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm47081-buffalo-wzr-900dhp.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm4709-netgear-r7000.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm4709-netgear-r7000.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm4709-linksys-ea9200.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm4709-linksys-ea9200.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm47081-luxul-xap-1410.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm47081-luxul-xap-1410.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm47094-luxul-xwr-3150-v1.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm47094-luxul-xwr-3150-v1.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm47094-luxul-xap-1610.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm47094-luxul-xap-1610.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm47094-dlink-dir-885l.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm47094-dlink-dir-885l.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm4709-netgear-r8000.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm4709-netgear-r8000.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm4709-buffalo-wxr-1900dhp.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm4709-buffalo-wxr-1900dhp.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm4709-tplink-archer-c9-v1.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm4709-tplink-archer-c9-v1.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm47094-luxul-abr-4500.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm47094-luxul-abr-4500.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm47094-linksys-panamera.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm47094-linksys-panamera.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm47094-luxul-xwr-3100.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm47094-luxul-xwr-3100.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm94709.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm94709.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm47094-luxul-xbr-4500.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm47094-luxul-xbr-4500.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm47094-phicomm-k3.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm47094-phicomm-k3.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm911360k.dt.yaml: mdio@18002000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm911360k.dt.yaml: mdio@18002000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm47094-netgear-r8500.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm47094-netgear-r8500.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm94708.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm94708.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm953012k.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm953012k.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm953012er.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm953012er.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm911360_entphn.dt.yaml: mdio@18002000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm911360_entphn.dt.yaml: mdio@18002000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm953012hr.dt.yaml: mdio@18003000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm953012hr.dt.yaml: mdio@18003000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm958305k.dt.yaml: mdio@18002000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm958305k.dt.yaml: mdio@18002000: #size-cells:0:0: 0 was expected
> .../linux/arch/arm/boot/dts/bcm958300k.dt.yaml: mdio@18002000: #address-cells:0:0: 1 was expected
> .../linux/arch/arm/boot/dts/bcm958300k.dt.yaml: mdio@18002000: #size-cells:0:0: 0 was expected
> 


-- 
Florian
