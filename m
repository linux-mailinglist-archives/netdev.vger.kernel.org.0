Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 429031B3A9
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 12:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbfEMKGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 06:06:52 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42491 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727339AbfEMKGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 06:06:51 -0400
Received: by mail-wr1-f66.google.com with SMTP id l2so14511837wrb.9
        for <netdev@vger.kernel.org>; Mon, 13 May 2019 03:06:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cWZpI2iOGBt+YmamLzOSa1MZVWDqyyiwbed07CD+vUY=;
        b=NVqMVsb4zw3PQozB+fMujk0U9R5bovAEmdYXPOuG3YTWCH/1ZCWlQ0sl+N8+T1RAwD
         RH0Wd/EEVDlQfmSXoMUtFWX46CWcFGOMK+suaJX9vEoCuzUeAuNd9iML4+MR2QC2w0+Q
         LmMafstZyBofGWMe2Dbg7XhSpRCTb3opyYimXM59Tr4UMkoR0jkSn0od7UBpu0O4l5UF
         OdkiGdXJRIph5Ffcu+J3/fLgDDm58uxDwy8w03X3y1XRPP77IZ7ngpQ/4WKXmjsRC0fc
         7LsmePyFiyzoWLHU2Zc4jaGUmNLKy8Ku5Qp7MccrgcNkc/HnPYS3UTfhRHj+13ReNnJi
         Liig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cWZpI2iOGBt+YmamLzOSa1MZVWDqyyiwbed07CD+vUY=;
        b=OxlKBjvfVVPD5PWixeRV1JFGGQwwhCAVR7WwJulO8RJy63vublM7cXdnicYwU7Yr36
         /Crc+Oja+GJScELsuMY8Wnj096yHQGsjk+p69OrUy/KuR1o6/Ts1OHkKDLJO/0iU3hIr
         atBgN6BIZUPl9emPnb1sVgcLgSbS3ajigW0uqF9D8OyyjNYtr8HDUdyxpR3LcTi+hqkZ
         SuguaQlFvesVQTbblbxuMMfA0vwzUQfqULmiYRTWggj+oiKNbuQzCDINd0n5TMJhLiCS
         zs665p5egAytBiM1rPrIy3a12zbalM/OA4dQnIHwM5hzVS2Y826OhAWGYle+ZIUSEn75
         bgZQ==
X-Gm-Message-State: APjAAAXMPxXDHaA+4+9oOVLQSaW9878pT9z+91X8peGnIdYRWd3LNksd
        QmC1oKhOKV7K2wryakTpukkmAQ==
X-Google-Smtp-Source: APXvYqzltWE/0+4/D4a9+forUflvkb/p4cqe/WXUECEW9bin+ILyukeE+Z2hlAaejR7hDGjQ7GB39g==
X-Received: by 2002:a5d:464f:: with SMTP id j15mr12654824wrs.265.1557742009870;
        Mon, 13 May 2019 03:06:49 -0700 (PDT)
Received: from [192.168.86.34] (cpc89974-aztw32-2-0-cust43.18-1.cable.virginm.net. [86.30.250.44])
        by smtp.googlemail.com with ESMTPSA id j82sm3310715wmj.40.2019.05.13.03.06.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 03:06:49 -0700 (PDT)
Subject: Re: NVMEM address DT post processing [Was: Re: [PATCH net 0/3] add
 property "nvmem_macaddr_swap" to swap macaddr bytes order]
To:     =?UTF-8?Q?Petr_=c5=a0tetiar?= <ynezz@true.cz>
Cc:     Maxime Ripard <maxime.ripard@bootlin.com>,
        Andy Duan <fugang.duan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "john@phrozen.org" <john@phrozen.org>,
        "bgolaszewski@baylibre.com" <bgolaszewski@baylibre.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alban Bedel <albeu@free.fr>, devicetree@vger.kernel.org
References: <1557476567-17397-4-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-3-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-2-git-send-email-fugang.duan@nxp.com>
 <1557476567-17397-1-git-send-email-fugang.duan@nxp.com>
 <20190510112822.GT81826@meh.true.cz> <20190510113155.mvpuhe4yzxdaanei@flea>
 <20190511144444.GU81826@meh.true.cz>
 <547abcff-103a-13b8-f42a-c0bd1d910bbc@linaro.org>
 <20190513090700.GW81826@meh.true.cz>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Message-ID: <8cee0086-7459-24c7-82f9-d559527df6e6@linaro.org>
Date:   Mon, 13 May 2019 11:06:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190513090700.GW81826@meh.true.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 13/05/2019 10:07, Petr Štetiar wrote:
> Srinivas Kandagatla <srinivas.kandagatla@linaro.org> [2019-05-13 09:25:55]:
> 
> Hi,
> 
>> My initial idea was to add compatible strings to the cell so that most of
>> the encoding information can be derived from it. For example if the encoding
>> representing in your example is pretty standard or vendor specific we could
>> just do with a simple compatible like below:
> 
> that vendor/compatible list would be quite long[1], there are hundreds of

You are right just vendor list could be very long, but I was hoping that 
the post-processing would fall in some categories which can be used in 
compatible string.

Irrespective of which we need to have some sort of compatible string to 
enable nvmem core to know that there is some form of post processing to 
be done on the cells!. Without which there is a danger of continuing to 
adding new properties to the cell bindings which have no relation to 
each other.


> devices in current OpenWrt tree (using currently custom patch) and probably
> dozens currently unsupported (ASCII encoded MAC address in NVMEM). So my goal
> is to add some DT functionality which would cover all of these.

> 
>> eth1_addr: eth-mac-addr@18a {
>> 	compatible = "xxx,nvmem-mac-address";
>> 	reg = <0x18a 0x11>;	
>> };
> 
> while sketching the possible DT use cases I came to the this option as well, it
> was very compeling as it would kill two birds with one stone (fix outstanding
> MTD/NVMEM OF clash as well[2]), but I think, that it makes more sense to add
> this functionality to nvmem core so it could be reused by other consumers, not
> just by network layer.

Changes to nvmem dt bindings have been already rejected, for this more 
discussion at: https://lore.kernel.org/patchwork/patch/936312/

--srini

> 
> 1. https://git.openwrt.org/?p=openwrt%2Fopenwrt.git&a=search&h=HEAD&st=grep&s=mtd-mac-address
> 2. https://lore.kernel.org/netdev/20190418133646.GA94236@meh.true.cz
> 
> -- ynezz
> 
